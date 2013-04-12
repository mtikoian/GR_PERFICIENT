USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 04/25/2012 04:15:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 04/25/2012 04:15:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/*********************************************************************************************************************
Description
	This stored procedure processes actual transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
	1. Set the default unknown values to be used in the fact tables
	2. Get data exclusion lists (Manage Type tables) from GDM
	3. Source MRI data from USCORP, USPROP, EUCORP, EUPROP, INCORP, INPROP, BRCORP, BRPROP
	4. Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
	5. Map GDM GL Account Categorization Data
	6. Map General Ledger to GDM, HR and GACS mapping data
	7. Insert data into table representing schema of ProfitabilityActual
	8. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
	9. Clean up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
			2011-09-27		: PKayongo	:	Changed the General Ledger account mapping to new Categorizations (CC21)
			2011-11-14		: PKayongo	:	
			2012-04-25		: Jason Gu	:	implemnets 'Accrual to Cash' function for EU PROP
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate	DateTime=NULL,
	@ImportEndDate		DateTime=NULL,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGeneralLedger'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
PRINT '####'

IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportMRIActuals') <> 1)
BEGIN
	PRINT ('Import of MRI Actuals is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...')
	RETURN
END

IF (@ImportStartDate IS NULL)
	BEGIN
	SET @ImportStartDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportStartDate'))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
	SET @ImportEndDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportEndDate'))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
	END

/* ===========================================================================================================================================
	Set the default unknown values to be used in the fact tables - these are used when a join can't be made to a dimension
   =========================================================================================================================================== */
   
DECLARE 
	@FunctionalDepartmentKeyUnknown INT,
	@ReimbursableKeyUnknown INT,
	@ActivityTypeKeyUnknown INT,
	@SourceKeyUnknown INT,
	@OriginatingRegionKeyUnknown INT,
	@AllocationRegionKeyUnknown INT,
	@PropertyFundKeyUnknown INT,
	@OverheadKeyUnknown INT,
	@GLCategorizationHierarchyKeyUnknown INT,
    @LocalCurrencyKeyUnknown INT
   
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN' AND SnapshotId = 0)
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN' AND SnapshotId = 0)
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN' AND SnapshotId = 0)
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')
SET @LocalCurrencyKeyUnknown		= (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')
SET @GLCategorizationHierarchyKeyUnknown  = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0)




/* ==============================================================================================================================================
	Get data exclusion lists (Manage Type tables) from GDM
   =========================================================================================================================================== */
BEGIN
	
	/* Temp table creation and data inserts - Change Control 7
		The ManageType tables are used to exclude certain data from being inserted into the ProfitabilityActual fact table.
		ManageCorporateDepartment excludes Corporate Departments.
		ManageCorporateEntity excludes Corporate Entities.
		ManagePropertyDepartment excludes Property Departments.
		ManagePropertyEntity excludes Property Entities		
	*/

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManageType
	*/
	
CREATE TABLE #ManageType
(
	ManageTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL
)
INSERT INTO #ManageType
(
	ManageTypeId,
	Code
)
SELECT
	MT.ManageTypeId,
	MT.Code
FROM
	Gdm.ManageType MT
	INNER JOIN Gdm.ManageTypeActive(@DataPriorToDate) MTA ON
		MT.ImportKey = MTA.ImportKey
		
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManageCorporateDepartment
	*/		
		
CREATE TABLE #ManageCorporateDepartment
(
	ManageCorporateDepartmentId INT NOT NULL,
	CorporateDepartmentCode NCHAR(8) NOT NULL,
	SourceCode NCHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL
)
INSERT INTO #ManageCorporateDepartment
(
	ManageCorporateDepartmentId,
	CorporateDepartmentCode,
	SourceCode,
	IsDeleted 
)
SELECT
	MCD.ManageCorporateDepartmentId,
	MCD.CorporateDepartmentCode,
	MCD.SourceCode,
	MCD.IsDeleted 
FROM
	Gdm.ManageCorporateDepartment MCD
	INNER JOIN Gdm.ManageCorporateDepartmentActive(@DataPriorToDate) MCDA ON
		MCD.ImportKey = MCDA.ImportKey
	INNER JOIN #ManageType MT ON
		MCD.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManageCorporateEntity
	*/	
		
CREATE TABLE #ManageCorporateEntity
(
	ManageCorporateEntityId INT NOT NULL,
	CorporateEntityCode NCHAR(6) NOT NULL,
	SourceCode NCHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL
)
INSERT INTO #ManageCorporateEntity
(
	ManageCorporateEntityId,
	CorporateEntityCode,
	SourceCode,
	IsDeleted,
	InsertedDate
)
SELECT
	MCE.ManageCorporateEntityId,
	MCE.CorporateEntityCode,
	MCE.SourceCode,
	MCE.IsDeleted,
	MCE.InsertedDate
FROM
	Gdm.ManageCorporateEntity MCE
	INNER JOIN Gdm.ManageCorporateEntityActive(@DataPriorToDate) MCEA ON
		MCE.ImportKey = MCEA.ImportKey
	INNER JOIN #ManageType MT ON
		MCE.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManagePropertyDepartment
	*/	
	
CREATE TABLE #ManagePropertyDepartment
(
	ManagePropertyDepartmentId INT NOT NULL,
	PropertyDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL
)
INSERT INTO #ManagePropertyDepartment
(
	ManagePropertyDepartmentId,
	PropertyDepartmentCode,
	SourceCode,
	IsDeleted 
)
SELECT
	MPD.ManagePropertyDepartmentId,
	MPD.PropertyDepartmentCode,
	MPD.SourceCode,
	MPD.IsDeleted
FROM
	Gdm.ManagePropertyDepartment MPD
	INNER JOIN Gdm.ManagePropertyDepartmentActive(@DataPriorToDate) MPDA ON
		MPD.ImportKey = MPDA.ImportKey
	INNER JOIN #ManageType MT ON
		MPD.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManagePropertyEntity
	*/	
		
CREATE TABLE #ManagePropertyEntity
(
	ManagePropertyEntityId INT NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
)
INSERT INTO #ManagePropertyEntity(
	ManagePropertyEntityId,
	PropertyEntityCode,
	SourceCode,
	IsDeleted
)
SELECT
	MPE.ManagePropertyEntityId,
	MPE.PropertyEntityCode,
	MPE.SourceCode,
	MPE.IsDeleted
FROM
	Gdm.ManagePropertyEntity MPE
	INNER JOIN Gdm.ManagePropertyEntityActive(@DataPriorToDate) MPEA ON
		MPE.ImportKey = MPEA.ImportKey
	INNER JOIN #ManageType MT ON
		MPE.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'
	
END

/* =============================================================================================================================================
	Source MRI data from USCORP, USPROP, EUCORP, EUPROP, INCORP, INPROP, BRCORP, BRPROP
   =========================================================================================================================================== */

BEGIN   

CREATE TABLE #ProfitabilityGeneralLedger
(
	SourcePrimaryKey VARCHAR(100) NULL,
	SourceTableId INT NOT NULL,
	SourceTableName VARCHAR(20) NULL,
	SourceCode VARCHAR(2) NOT NULL,
	Period CHAR(6) NOT NULL,
	OriginatingRegionCode CHAR(6) NOT NULL,
	PropertyFundCode CHAR(12) NOT NULL,
	FunctionalDepartmentCode CHAR(15) NULL,
	JobCode CHAR(15) NULL,
	GlAccountCode CHAR(12) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual MONEY NOT NULL,
	EnterDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	Basis CHAR(1) NOT NULL,
	LastDate DATETIME NULL,
	GlAccountSuffix VARCHAR(2) NULL,
	NetTSCost CHAR(1) NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		US-PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	'USD' AS ForeignCurrency,
	Gl.Amount AS ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM 
	USProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.EntityId
				FROM
					USProp.ENTITY En
					INNER JOIN USProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					USProp.GACC Ga
					INNER JOIN USProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM 

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND -- Make sure the transaction is within the window
	Gl.Basis IN ('A','B') AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND -- Ensures that there is no Corporate Department associated with the record
	Gl.BALFOR <> 'B' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND -- Makes sure the transaction is doesn't have a Corporate Overhead activity type
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y' -- Ensures that the GLAccount is a GR account
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.IsDeleted,
									PEAI.SourceCode
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'US')
	) AND
	
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = 'US' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = 'US' AND
			MPD.IsDeleted = 0
	)

PRINT 'US PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		US CORP
	*/	

INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,

	'USD' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM USCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					USCorp.ENTITY En
					INNER JOIN USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		Gl.RegionCode = En.ENTITYID  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					USCorp.GACC Ga
					INNER JOIN USCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
				
	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					USCorp.GDEP Gd
					INNER JOIN USCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B' AND
	
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = 'UC'
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = 'UC'
	)
	
PRINT 'US CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		EU PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = 'PLZ' THEN 'PLN' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.Description, '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',-- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM EUProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID,
					En.CURRCODE,
					En.ISFUND
				FROM
					EUProp.ENTITY En
					INNER JOIN EUProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId  

	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					EUProp.GACC Ga
					INNER JOIN EUProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
			

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	 --Gl.Basis IN ('A','B') AND
	(
	(Gl.Basis = 'A' and En.ISFUND = 'Y') or
	(Gl.Basis = 'C' and (En.ISFUND <> 'Y' or En.ISFUND is null)) or
	(Gl.Basis = 'B')
	) AND
	--GEN.Source = 'EU' AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.IsDeleted,
									PEAI.SourceCode
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'EU')
	) AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = 'EU' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = 'EU' AND
			MPD.IsDeleted = 0
	)

PRINT 'EU PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		EU CORP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode, 
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription, 
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = 'PLZ' THEN 'PLN' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount, 0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
	
FROM 
	EUCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID,
					En.CURRCODE
				FROM
					EUCorp.ENTITY En
					INNER JOIN EUCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
				
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					GA.ISGR
				FROM
					EUCorp.GACC Ga
					INNER JOIN EUCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					EUCorp.GDEP Gd
					INNER JOIN EUCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR, 0) = 'Y' AND
	Gl.BALFOR <> 'B' --AND
	--Change Control 1 : GC 2010-09-01
	AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = 'EC'
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = 'EC'
	)
	
PRINT 'EU CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		BR PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.Description, '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	BRProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					BRProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					BRProp.ENTITY En
					INNER JOIN BRProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					GA.ISGR
				FROM
					BRProp.GACC Ga
					INNER JOIN BRProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND

	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source]	= 'GR' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.IsDeleted,
									PEAI.SourceCode
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'BR')
	) AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = 'BR' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN 
		( -- exclude Property Department
	
			SELECT
				MPD.PropertyDepartmentCode
			FROM
				#ManagePropertyDepartment MPD
			WHERE
				MPD.SourceCode = 'BR' AND
				MPD.IsDeleted = 0
		)

PRINT 'BR PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		BR CORP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	'BRL' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '')),
	RTRIM(IsNull(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM 
	BRCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
				FROM
						BRCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.EntityId
				FROM
					BRCorp.ENTITY En
					INNER JOIN BRCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					BRCorp.GACC Ga
					INNER JOIN BRCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					BRCorp.GDEP Gd
					INNER JOIN BRCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source] = 'GR'	AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = 'BC'
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = 'BC'
	)
	

PRINT 'BR CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		CN PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	ISNULL(Em.LocalEntityRef, Gl.PropertyFundCode) PropertyFundCode, --Generic convert 7char to 6char EntityID
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '')),
	RTRIM(IsNull(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId  

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId  
			
	INNER JOIN (
				SELECT
					Em.OriginalEntityRef,
					Em.[Source],
					Em.LocalEntityRef
				FROM
					GACS.EntityMapping Em
					INNER JOIN GACS.EntityMappingActive(@DataPriorToDate) EmA ON
						Em.ImportKey = EmA.ImportKey  
				) Em ON
		Gl.PropertyFundCode = Em.OriginalEntityRef  AND
		Gl.SourceCode = Em.[Source] -- this should filter EntityMapping by source of 'CN', because Gl.SourceCode will always be this
			
	LEFT OUTER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					CNProp.GACC Ga
					INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN 
			( 
				SELECT
					PEAI.GLAccountCode
				FROM
					(
						SELECT
							PEAI.PropertyEntityCode,
							PEAI.GLAccountCode,
							PEAI.SourceCode,
							PEAI.IsDeleted
						FROM							
							Gdm.PropertyEntityGLAccountInclusion PEAI
							INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
								PEAI.ImportKey = PEAIA.ImportKey
					) PEAI
				WHERE
					PEAI.PropertyEntityCode = 
						CASE --Gl.PropertyFundCode AND
							WHEN LTRIM(RTRIM(Gl.PropertyFundCode)) = LTRIM(RTRIM(Em.OriginalEntityRef)) 
								THEN Em.LocalEntityRef 
							ELSE Gl.PropertyFundCode
						END AND							
					PEAI.IsDeleted = 0 AND
					PEAI.SourceCode = 'CN'
			)
	) AND
	-- Change Control 7: IS - begin
			
	CASE --Gl.PropertyFundCode NOT IN ( -- exclude Property Entity
		WHEN LTRIM(RTRIM(Gl.PropertyFundCode)) = LTRIM(RTRIM(Em.OriginalEntityRef)) THEN Em.LocalEntityRef ELSE Gl.PropertyFundCode
	END NOT IN (

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = 'CN' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = 'CN' AND
			MPD.IsDeleted = 0
	)


PRINT 'CH PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		CN CORP
	*/

INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					CNCorp.ENTITY En
					INNER JOIN CNCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					CNCorp.GACC Ga
					INNER JOIN CNCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					CNCorp.GDEP Gd
					INNER JOIN CNCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT 
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B' --AND
	AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = 'CC'
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = 'CC'
	)
	
	
PRINT 'CH CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		IN PROP
	*/
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INProp.GeneralLedger Gl
	INNER JOIN 
		(
			--This allows JOURNAL&GHIS to each have a record with the same PK,
			--but that is incorrect data and as such GR will pick GHIS as the 
			--more accurate data, for it is posted data, where journal data is still open data
			SELECT
				SourcePrimaryKey,
				MAX(SourceTableId) SourceTableId
			FROM
				INProp.GeneralLedger Gl
			GROUP BY
				SourcePrimaryKey
		) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId 

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					INProp.ENTITY En
					INNER JOIN INProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey 
				) En ON
		Gl.PropertyFundCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					GA.ISGR
				FROM
					INProp.GACC Ga
					INNER JOIN INProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM 
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source] = 'GR' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.SourceCode,
									PEAI.IsDeleted
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'IN')
	) AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = 'IN' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = 'IN' AND
			MPD.IsDeleted = 0
	)


PRINT 'IN PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		IN CORP
	*/
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					INCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId  

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					INCorp.ENTITY En
					INNER JOIN INCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					INCorp.GACC Ga
					INNER JOIN INCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
				
	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					INCorp.GDEP Gd
					INNER JOIN INCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR, 0) = 'Y' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source] = 'GR' --AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'
	AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = 'IC'
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = 'IC'
	)
	

PRINT 'IN CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityGeneralLedger_Clustered ON #ProfitabilityGeneralLedger (UpdatedDate, FunctionalDepartmentCode, JobCode, GlAccountCode, SourceCode, Period, OriginatingRegionCode, PropertyFundCode, SourcePrimaryKey)

PRINT 'Completed building clustered index on #ProfitabilityGeneralLedger'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

END

/* =============================================================================================================================================
	Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The Functional Department table is used to map the transactions to their relevant Functional Departments.	
	*/ 
	
CREATE TABLE #FunctionalDepartment
(
	FunctionalDepartmentId INT NOT NULL,
	Code VARCHAR(31) NOT NULL,
	GlobalCode CHAR(3) NULL
)
INSERT INTO #FunctionalDepartment(
	FunctionalDepartmentId,
	Code,
	GlobalCode
)
SELECT
	Fd.FunctionalDepartmentId,
	Fd.Code,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		Fd.ImportKey = FdA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#Department
	*/ 
			
CREATE TABLE #Department
(
	Department CHAR(8) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL,
)
INSERT INTO #Department(
	Department,
	[Source],
	FunctionalDepartmentId
)
SELECT
	Dpt.DepartmentCode,
	Dpt.[Source],
	Dpt.FunctionalDepartmentId
FROM Gdm.Department Dpt
	INNER JOIN Gdm.DepartmentActive(@DataPriorToDate) DptA ON
		Dpt.ImportKey = DptA.ImportKey
WHERE
	Dpt.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Department_Department ON #Department (Department, [Source])
	
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#JobCode
	*/ 

CREATE TABLE #JobCode
(
	JobCode VARCHAR(15) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL
) 
INSERT INTO #JobCode
(
	JobCode,
	[Source],
	FunctionalDepartmentId
)
SELECT
	Jc.JobCode,
	Jc.[Source],
	Jc.FunctionalDepartmentId
FROM
	GACS.JobCode Jc
	INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON
		Jc.ImportKey = JcA.ImportKey
WHERE
	Jc.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_JobCode_JobCode ON #JobCode (JobCode, [Source])

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ActivityType
	*/ 
	
CREATE TABLE #ActivityType
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	GLAccountSuffix char(2) NULL
)
INSERT INTO #ActivityType(
	ActivityTypeId,
	ActivityTypeCode,
	GLAccountSuffix
)
SELECT
	At.ActivityTypeId,
	At.Code,
	At.GLAccountSuffix
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		At.ImportKey = Ata.ImportKey
WHERE
	AT.IsActive = 1

CREATE UNIQUE CLUSTERED INDEX IX_ActivityType_ActivityTypeId ON #ActivityType (ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #OriginatingRegionCorporateEntity and #OriginatingRegionPropertyDepartment tables are used to determine the Originating Regions of 
		transactions.
	*/
	
CREATE TABLE #OriginatingRegionCorporateEntity
( -- GDM 2.0 addition
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #OriginatingRegionCorporateEntity
(
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode
)
SELECT
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCE.ImportKey = ORCEA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionCorporateEntity_CorporateEntity ON #OriginatingRegionCorporateEntity(CorporateEntityCode, SourceCode)

CREATE TABLE #OriginatingRegionPropertyDepartment
( -- GDM 2.0 addition
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #OriginatingRegionPropertyDepartment
(
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode
)
SELECT
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPD.ImportKey = ORPDA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionPropertyDepartment_PropertyDepartment ON #OriginatingRegionPropertyDepartment(PropertyDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The PropertyFundMapping table is used to determine the PropertyFund of Overhead transactions.
		Note: This only maps the PropertyFund for transactions before period 201007	
	*/
	
CREATE TABLE #PropertyFundMapping
(
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)
INSERT INTO #PropertyFundMapping(
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	IsDeleted,
	ActivityTypeId
)
SELECT
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		Pfm.ImportKey = PfmA.ImportKey
WHERE
	Pfm.IsDeleted = 0

CREATE UNIQUE CLUSTERED INDEX UX_PropertyFundMapping_PropertyFund ON #PropertyFundMapping (PropertyFundCode, SourceCode, ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyFund table is used to map transactions to their Property Fund and find the Allocation Sub Region of a transaction.
	*/

CREATE TABLE #PropertyFund
( -- GDM 2.0 change
	PropertyFundId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL
)
INSERT INTO #PropertyFund(
	PropertyFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	[Name]
)
SELECT
	PF.PropertyFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.[Name]
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PF.ImportKey = PFA.ImportKey
WHERE
	PF.IsActive = 1

CREATE UNIQUE CLUSTERED INDEX IX_PropertyFund_PropertyFundId ON #PropertyFund (PropertyFundId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingEntityCorporateDepartment and #ReportingEntityPropertyEntity tables are used to determine the Property Funds of
		transactions (Property Funds are used to determine the Allocation Sub Region).
	*/
	
CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL

)
INSERT INTO	#ReportingEntityCorporateDepartment
(
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode
)
SELECT
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECD.ImportKey = RECDA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityCorporateDepartment_CorporateDepartment ON #ReportingEntityCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ReportingEntityPropertyEntity	
	*/

CREATE TABLE #ReportingEntityPropertyEntity
( -- GDM 2.0 addition
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL
)
INSERT INTO #ReportingEntityPropertyEntity
(
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode
)
SELECT
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPE.ImportKey = REPEA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityPropertyEntity_PropertyEntity ON #ReportingEntityPropertyEntity(PropertyEntityCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ConsolidationRegionCorporateDepartment and #ConsolidationRegionPropertyEntity tables are used to determine the Consolidation 
		Region of a transaction.
	*/
	
CREATE TABLE #ConsolidationRegionCorporateDepartment
( -- GDM 2.0 addition
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL
)
INSERT INTO	#ConsolidationRegionCorporateDepartment
(
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode
)
SELECT
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode
FROM
	Gdm.ConsolidationRegionCorporateDepartment CRCD
	INNER JOIN Gdm.ConsolidationRegionCorporateDepartmentActive(@DataPriorToDate) CRCDA ON
		CRCD.ImportKey = CRCDA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartment ON #ConsolidationRegionCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ConsolidationRegionPropertyEntity
	*/
	
CREATE TABLE #ConsolidationRegionPropertyEntity
( -- GDM 2.0 addition
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL
)
INSERT INTO #ConsolidationRegionPropertyEntity
(
	ConsolidationRegionPropertyEntityId,
	GlobalRegionId,
	SourceCode,
	PropertyEntityCode
)
SELECT
	CRPE.ConsolidationRegionPropertyEntityId,
	CRPE.GlobalRegionId,
	CRPE.SourceCode,
	CRPE.PropertyEntityCode
FROM
	Gdm.ConsolidationRegionPropertyEntity CRPE
	INNER JOIN Gdm.ConsolidationRegionPropertyEntityActive(@DataPriorToDate) CRPEA ON
		CRPE.ImportKey = CRPEA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionPropertyEntity_PropertyEntity ON #ConsolidationRegionPropertyEntity(PropertyEntityCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #AllocationSubRegion table is used to filter GlobalRegion to make sure the Allocation Sub Region specified by the #PropertyFund
		table is flagged as an Allocation Region in the GlobalRegion table in GDM.	
	*/

CREATE TABLE #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL
)
INSERT INTO #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	AllocationRegionGlobalRegionId
)
SELECT
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.AllocationRegionGlobalRegionId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON 
		ASR.ImportKey = ASRA.ImportKey
WHERE
	ASR.IsActive = 1
	
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ConsolidationSubRegion table is used to filter GlobalRegion to make sure the Consolidation Sub Region specified by the #PropertyFund
		table is flagged as an Consolidation Region in the GlobalRegion table in GDM.	
	*/
		
CREATE TABLE #ConsolidationSubRegion
(
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ConsolidationRegionGlobalRegionId INT NULL
)
INSERT INTO #ConsolidationSubRegion
(
	ConsolidationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionCode,
	[Name],
	ConsolidationRegionGlobalRegionId
)
SELECT
	CSR.ConsolidationSubRegionGlobalRegionId,
	CSR.ConsolidationSubRegionGlobalRegionCode,
	CSR.[Name],
	CSR.ConsolidationRegionGlobalRegionId
FROM
	Gdm.ConsolidationSubRegion CSR
	INNER JOIN	Gdm.ConsolidationSubRegionActive(@DataPriorToDate) CSRA ON 
		CSR.ImportKey = CSRA.ImportKey
WHERE
	CSR.IsActive = 1
	
CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationSubRegion_ConsolidationSubRegionGlobalRegionId ON #ConsolidationSubRegion(ConsolidationSubRegionGlobalRegionId)
	
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #JobCodeFunctionalDepartment gets the Functional Department dimension data in the warehouse. It is used to resolve the dimension
		keys when mapping Job Codes
	*/

CREATE TABLE #JobCodeFunctionalDepartment
(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)
INSERT INTO #JobCodeFunctionalDepartment
(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE
	FunctionalDepartmentCode <> SubFunctionalDepartmentCode
	
CREATE UNIQUE CLUSTERED INDEX IX_JobCodeFunctionalDepartment_ReferenceCode ON #JobCodeFunctionalDepartment(ReferenceCode, StartDate, EndDate)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #JobCodeFunctionalDepartment gets the Functional Department dimension data in the warehouse. It is used to resolve the dimension
		keys when mapping Functional Departments
	*/

CREATE TABLE #ParentFunctionalDepartment
(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)
INSERT INTO #ParentFunctionalDepartment
(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE (
		FunctionalDepartmentCode = SubFunctionalDepartmentCode
		OR 
		ReferenceCode = FunctionalDepartmentCode+':UNKNOWN'
	  )
	  
END



/* =============================================================================================================================================
	Map GDM GL Account Categorization Data
   =========================================================================================================================================== */
 BEGIN
 
 	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorizationType
	*/
	 
CREATE TABLE #GLCategorizationType
(
	GLCategorizationTypeId INT NOT NULL
)
INSERT INTO #GLCategorizationType
(
	GLCategorizationTypeId
)
SELECT
	GLCategorizationTypeId
FROM
	Gdm.GLCategorizationType GCT
	INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTA ON
		GCT.ImportKey = GCTA.ImportKey

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorization
	*/
	
CREATE TABLE #GLCategorization
(
	GLCategorizationId INT NOT NULL,
	GLCategorizationTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	RechargeSourceCode CHAR(2) NULL,
	IsConfiguredForRecharge BIT NULL
)
INSERT INTO #GLCategorization
(
	GLCategorizationId,
	GLCategorizationTypeId,
	Name,
	RechargeSourceCode,
	IsConfiguredForRecharge
)
SELECT
	Cat.GLCategorizationId,
	Cat.GLCategorizationTypeId,
	Cat.Name,
	Cat.RechargeSourceCode,
	Cat.IsConfiguredForRecharge
FROM
	Gdm.GLCategorization Cat
	INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) CatA ON
		Cat.ImportKey = CatA.ImportKey


CREATE UNIQUE CLUSTERED INDEX IX_GLCategorization_GLCategorizationId ON #GLCategorization (GLCategorizationId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLFinancialCategory	
	*/
	
CREATE TABLE #GLFinancialCategory
(
	GLFinancialCategoryId INT NOT NULL,
	GLCategorizationId INT NOT NULL
)	

INSERT INTO #GLFinancialCategory
(
	GLFinancialCategoryId,
	GLCategorizationId
)
SELECT
	GFC.GLFinancialCategoryId,
	GFC.GLCategorizationId
FROM
	Gdm.GLFinancialCategory GFC
	INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) GFCA ON
		GFC.ImportKey = GFCA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_GLFinancialCategory_GLFinancialCategoryId ON #GLFinancialCategory (GLFinancialCategoryId)


	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMajorCategory	
	*/

CREATE TABLE #GLMajorCategory
(
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(400) NOT NULL,
	GLCategorizationId INT NOT NULL,
	GLFinancialCategoryId INT NOT NULL
)
INSERT INTO #GLMajorCategory
(
	GLMajorCategoryId,
	Name,
	GLCategorizationId,
	GLFinancialCategoryId
)
SELECT
	MajC.GLMajorCategoryId,
	MajC.Name,
	MajC.GLCategorizationId,
	MajC.GLFinancialCategoryId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey
WHERE
	MajC.IsActive = 1
			
CREATE UNIQUE CLUSTERED INDEX IX_GLMajorCategory_GLMajorCategoryId ON #GLMajorCategory (GLMajorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMinorCategory	
	*/
	
CREATE TABLE #GLMinorCategory
(
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(400) NOT NULL
)
INSERT INTO #GLMinorCategory
(
	GLMinorCategoryId,
	GLMajorCategoryId,
	Name
)
SELECT
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	MinC.Name
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinC.ImportKey = MinCA.ImportKey
WHERE
	MinC.IsActive = 1

CREATE UNIQUE CLUSTERED INDEX IX_GLMinorCategory_GLMinorCategoryId ON #GLMinorCategory (GLMinorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccountCategorization table is used to map Global Accounts to Minor Categories for the relevant Categorizations	
	*/
	
CREATE TABLE #GLGlobalAccountCategorization
(
	GLGlobalAccountCategorizationId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLCategorizationId INT NULL,
	DirectGLMinorCategoryId INT NULL,
	IndirectGLMinorCategoryId INT NULL,
	CoAGLMinorCategoryId INT NULL
)
INSERT INTO #GLGlobalAccountCategorization
(
	GLGlobalAccountCategorizationId,
	GLGlobalAccountId,
	GLCategorizationId,
	DirectGLMinorCategoryId,
	IndirectGLMinorCategoryId,
	CoAGLMinorCategoryId
)
SELECT
	GCat.GLGlobalAccountCategorizationId,
	GCat.GLGlobalAccountId,
	GCat.GLCategorizationId,
	GCat.DirectGLMinorCategoryId,
	GCat.IndirectGLMinorCategoryId,
	GCat.CoAGLMinorCategoryId
FROM
	Gdm.GLGlobalAccountCategorization GCat
	INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GCatA ON
		GCat.ImportKey = GCatA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_GLGlobalAccountCategorization_GLGlobalAccount ON #GLGlobalAccountCategorization (GLGlobalAccountId, GLCategorizationId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccount table is used to map local GL Accounts to their Global accounts.
	*/
	
CREATE TABLE #GLGlobalAccount
(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	Code VARCHAR(10) NOT NULL
)
INSERT INTO #GLGlobalAccount
(
	GLGlobalAccountId,
	ActivityTypeId,
	Code
)
SELECT
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.Code
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLA.ImportKey = GLAA.ImportKey
WHERE
	GLA.IsActive = 1
	
CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount (GLGlobalAccountId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLAccount table is used to map local GL Accounts to their Global accounts.
	*/
	
CREATE TABLE #GLAccount
(
	GLAccountId int NOT NULL,
	GLGlobalAccountId int NULL,
	Code varchar(15) NOT NULL,
	SourceCode char(2) NOT NULL,
	IsGlobalReporting BIT NOT NULL
)
INSERT INTO #GLAccount
(
	GLAccountId,
	GLGlobalAccountId,
	Code,
	SourceCode,
	IsGlobalReporting
)
SELECT
	GLAccountId,
	GLGlobalAccountId,
	Code,
	SourceCode,
	IsGlobalReporting
FROM
	Gdm.GLAccount GL
	
	INNER JOIN Gdm.GLAccountActive(@DataPriorToDate) GLA ON
		GL.ImportKey = GLA.ImportKey
WHERE
	GL.IsActive = 1
	
CREATE UNIQUE CLUSTERED INDEX UX_GLAccount_AccountCode ON #GLAccount(Code, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingCategorization is used to determine the default categorization to be shown in local reports based on the EntityType and
		Allocation sub region.
	*/
	
CREATE TABLE #ReportingCategorization
(
	ReportingCategorizationId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	GLCategorizationId INT NOT NULL
)
INSERT INTO #ReportingCategorization
(
	ReportingCategorizationId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	GLCategorizationId
)
SELECT
	RC.ReportingCategorizationId,
	RC.EntityTypeId,
	RC.AllocationSubRegionGlobalRegionId,
	RC.GLCategorizationId
FROM
	Gdm.ReportingCategorization RC 
	INNER JOIN Gdm.ReportingCategorizationActive(@DataPriorToDate) RCa ON
		RC.ImportKey = RCa.ImportKey
		
CREATE UNIQUE CLUSTERED INDEX IX_ReportingCategorization_Categorization ON #ReportingCategorization (EntityTypeId, AllocationSubRegionGlobalRegionId)

PRINT 'Completed inserting active records into temp table'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyPayrollPropertyGLAccount is used to map payroll transactions to their local GL Accounts for the local categorizations
	*/

CREATE TABLE #PropertyPayrollPropertyGLAccount
(
	GLCategorizationId INT NOT NULL,
	PayrollTypeId INT NOT NULL,
	ActivityTypeId INT NULL,
	FunctionalDepartmentId INT NULL,
	PropertyGLAccountId INT NULL,
	GLGlobalAccountId INT NULL,
	GLMinorCategoryId INT NULL
)
INSERT INTO #PropertyPayrollPropertyGLAccount
(
	GLCategorizationId,
	PayrollTypeId,
	ActivityTypeId,
	FunctionalDepartmentId,
	PropertyGLAccountId,
	GLGlobalAccountId,
	GLMinorCategoryId
)
SELECT
	PPPGA.GLCategorizationId,
	PPPGA.PayrollTypeId,
	PPPGA.ActivityTypeId,
	PPPGA.FunctionalDepartmentId,
	PPPGA.PropertyGLAccountId,
	PPPGA.GLGlobalAccountId,
	PPPGA.GLMinorCategoryId
FROM
	Gdm.PropertyPayrollPropertyGLAccount PPPGA
	
	INNER JOIN Gdm.PropertyPayrollPropertyGLAccountActive(@DataPriorToDate) PPPGAa ON
		PPPGA.ImportKey = PPPGAa.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_PropertyPayrollPropertyGLAccount_Unique ON #PropertyPayrollPropertyGLAccount
	(
		GLCategorizationId,
		PayrollTypeId,
		GLMinorCategoryId,
		ActivityTypeId,
		FunctionalDepartmentId
	)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The ##GLMinorCategoryPayrollType is used to map a GL Minor Category to a payroll type
	*/
	
CREATE TABLE #GLMinorCategoryPayrollType
(
	GLMinorCategoryId INT NOT NULL,
	PayrollTypeId INT NOT NULL
)
INSERT INTO #GLMinorCategoryPayrollType
(
	GLMinorCategoryId,
	PayrollTypeId
)
SELECT
	GLMinorCategoryId,
	PayrollTypeId
FROM
	Gdm.GLMinorCategoryPayrollType MCPT
	
	INNER JOIN Gdm.GLMinorCategoryPayrollTypeActive(@DataPriorToDate) MCPTa	ON
		MCPT.ImportKey = MCPTa.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_GLMinorCategoryPayrollType_GLMinorCategoryId_PayrollTypeId ON #GLMinorCategoryPayrollType
	(
		GLMinorCategoryId,
		PayrollTypeId
	)
	
	/*	-------------------------------------------------------------------------------------------------------------------------
		Global Categorization Payroll Mappings
		
		Gets global Major and Minor Catetgory combinations
	*/

CREATE TABLE #PayrollGlobalMappings
(
	GLMinorCategoryName VARCHAR(120) NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryName VARCHAR(120) NOT NULL,
	GLMajorCategoryId INT NOT NULL
)

INSERT INTO #PayrollGlobalMappings
(
	GLMinorCategoryName,
	GLMinorCategoryId,
	GLMajorCategoryName,
	GLMajorCategoryId
)
SELECT DISTINCT
	MinC.Name AS GLMinorCategoryName,
	MinC.GLMinorCategoryId AS GLMinorCategoryId,
	MajC.Name AS GLMajorCategoryName,
	MajC.GLMajorCategoryId GLMajorCategoryId
FROM
	#GLMinorCategory MinC
	
	INNER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId
WHERE
	(
		MajC.Name = 'Salaries/Taxes/Benefits' OR
		(
			MinC.Name = 'External General Overhead' AND
			MajC.Name = 'General Overhead'
		)
	) AND
	MajC.GLCategorizationId = 233

/*

The following table gets the Global Account Categorization mapping data from GDM, and pivots the data so that the first row has the 
Global Account Id and each column represents the a GL Categorization Hierarchy code for one of the GL Categorizations.

The purpose of having the table like this is to avoid joining onto the fact table multiple times.

*/

CREATE TABLE #GlAccountCategoryMapping 
(
	GLGlobalAccountId INT NOT NULL,
	IsDirect BIT NOT NULL,
	GlobalGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	
)
INSERT INTO #GlAccountCategoryMapping
(
	GLGlobalAccountId,
	IsDirect,
	GlobalGLCategorizationHierarchyCode,
	USPropertyGLCategorizationHierarchyCode,
	USFundGLCategorizationHierarchyCode,
	EUPropertyGLCategorizationHierarchyCode,
	EUFundGLCategorizationHierarchyCode,
	USDevelopmentGLCategorizationHierarchyCode,
	EUDevelopmentGLCategorizationHierarchyCode
)
SELECT
	PivotTable.GLGlobalAccountId,
	PivotTable.IsDirectCost,
	PivotTable.[Global] AS GlobalGLCategorizationHierarchyCode,
	PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyCode,
	PivotTable.[US Fund] AS USFundGLCategorizationHierarchyCode,
	PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyCode,
	PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyCode,
	PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyCode,
	PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyCode
FROM
	(	
	-- Union to deal with both Direct mappings and Indirect mappings
		SELECT
			GGA.GLGlobalAccountId,
			GLC.Name AS GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GLCT.GLCategorizationTypeId, -1)) + ':' +
				CONVERT(VARCHAR(10), ISNULL(GLC.GLCategorizationId, -1)) + ':' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + ':' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END)  + ':' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + ':' +
				CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode,
			
			0 AS IsDirectCost
		FROM
			#GLGlobalAccount GGA
			
			LEFT OUTER JOIN #GLCategorization GLC ON
				GLC.GLCategorizationId = GLC.GLCategorizationId  
			
			LEFT OUTER JOIN #GLCategorizationType GLCT ON
				GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId 
				
			LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
				GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId AND
				GLC.GLCategorizationId = GLGAC.GLCategorizationId
				
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				GLGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId
				
			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	
			
			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  
			
				
		UNION
		
		SELECT
			GGA.GLGlobalAccountId,
			GLC.Name AS GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GLCT.GLCategorizationTypeId, -1)) + ':' +
				CONVERT(VARCHAR(10), ISNULL(GLC.GLCategorizationId, -1)) + ':' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + ':' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END)  + ':' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + ':' +
				CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode,
			
			1 AS IsDirectCost
		FROM
			#GLGlobalAccount GGA
			
			LEFT OUTER JOIN #GLCategorization GLC ON
				GLC.GLCategorizationId = GLC.GLCategorizationId  
			
			LEFT OUTER JOIN #GLCategorizationType GLCT ON
				GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId 
				
			LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
				GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId AND
				GLC.GLCategorizationId = GLGAC.GLCategorizationId
				
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				GLGAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId
				
			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	
			
			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId 
	)Mappings
	PIVOT
	(
		MAX(GLCategorizationHierarchyCode)
		FOR GLCategorizationName IN ([Global], [US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
	) AS PivotTable


CREATE UNIQUE CLUSTERED INDEX IX_GlAccountCategoryMapping_GLGlobalAccountId ON #GlAccountCategoryMapping (GLGlobalAccountId, IsDirect)
PRINT 'Completed building clustered index on #GlAccountCategoryMapping'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
	
END

CREATE TABLE #LocalPayrollGLCategorizationMapping(
	FunctionalDepartmentId INT NULL,
	ActivityTypeId INT NULL,
	PayrollTypeId INT NULL,
	GlobalGLMinorCategoryId INT NULL,
	USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL
)
INSERT INTO #LocalPayrollGLCategorizationMapping
(
	FunctionalDepartmentId,
	ActivityTypeId,
	PayrollTypeId,
	GlobalGLMinorCategoryId,
	USPropertyGLCategorizationHierarchyCode,
	USFundGLCategorizationHierarchyCode,
	EUPropertyGLCategorizationHierarchyCode,
	EUFundGLCategorizationHierarchyCode,
	USDevelopmentGLCategorizationHierarchyCode,
	EUDevelopmentGLCategorizationHierarchyCode
)
SELECT
	PivotTable.FunctionalDepartmentId,
	PivotTable.ActivityTypeId,
	PivotTable.PayrollTypeId,
	PivotTable.GLMinorCategoryId,
	PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyCode,
	PivotTable.[US Fund] AS USFundGLCategorizationHierarchyCode,
	PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyCode,
	PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyCode,
	PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyCode,
	PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyCode
FROM
	(
		SELECT DISTINCT
			FD.FunctionalDepartmentId,
			AType.ActivityTypeId,
			PPPGA.PayrollTypeId,
			MinCa.GLMinorCategoryId,
			GC.Name as GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GC.GLCategorizationTypeId, -1)) + ':' +
			CONVERT(VARCHAR(10), ISNULL(GC.GLCategorizationId, -1)) + ':' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(FinC.GLFinancialCategoryId, -1) END) + ':' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MajC.GLMajorCategoryId, -1) END) + ':' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MinC.GLMinorCategoryId, -1) END) + ':' +
			CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode
		FROM
			#PropertyPayrollPropertyGLAccount PPPGA

			INNER JOIN #ActivityType AType ON
				ISNULL(PPPGA.ActivityTypeId, 0) = CASE WHEN PPPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END 
				
			INNER JOIN #FunctionalDepartment FD ON
				ISNULL(PPPGA.FunctionalDepartmentId, 0) = CASE WHEN PPPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END 

			INNER JOIN #GLMinorCategory MinCa ON
				ISNULL(PPPGA.GLMinorCategoryId, 0) = CASE WHEN PPPGA.GLMinorCategoryId IS NULL THEN 0 ELSE MinCa.GLMinorCategoryId END 

			INNER JOIN #GLMajorCategory MajCa ON
				MinCa.GLMajorCategoryId = MajCa.GLMajorCategoryId
			
			INNER JOIN #GLCategorization GC ON
				PPPGA.GLCategorizationId = GC.GLCategorizationId

			INNER JOIN #GLAccount GA ON
				PPPGA.PropertyGLAccountId = GA.GLAccountId
			/*
				If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount 
					local account
				If the local Categorization is not configured for recharge, the Global account is determined directly from the 
					#PropertyPayrollPropertyGLAccount table
			*/
			INNER JOIN #GLGlobalAccount GGA ON
				GGA.GLGlobalAccountId = 
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GA.GLGlobalAccountId
						ELSE
							PPPGA.GLGlobalAccountId
					END 

			LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
				GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId   AND
				PPPGA.GLCategorizationId = GGAC.GLCategorizationId 
			/*
				If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
					in the #GLGlobalAccountCategorization table.
				If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
					field in the #GLGlobalAccountCategorization table.
			*/	
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				MinC.GLMinorCategoryId =
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GGAC.CoAGLMinorCategoryId
						ELSE
							GGAC.DirectGLMinorCategoryId
					END 

			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId 

			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
				GC.GLCategorizationId  = FinC.GLCategorizationId 

			LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
				DIM.GLCategorizationHierarchyCode = 
					CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + ':' +
					CONVERT(VARCHAR(10), GC.GLCategorizationId) + ':' +
					CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), FinC.GLFinancialCategoryId) END + ':' +
					CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), MajC.GLMajorCategoryId) END + ':' +
					CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN '-1' ELSE CONVERT(VARCHAR(10), MinC.GLMinorCategoryId) END + ':' +
					(CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))) 

		WHERE
		(
			MajCa.Name = 'Salaries/Taxes/Benefits' OR
			(
				MinCa.Name = 'External General Overhead' AND
				MajCa.Name = 'General Overhead'
			)
		) AND
		MajCa.GLCategorizationId = 233
	) LocalMappings
	PIVOT
	(
		MAX(GLCategorizationHierarchyCode)
		FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
	) AS PivotTable
	
/* ===========================================================================================================================================
	Map General Ledger to GDM, HR and GACS mapping data
   =========================================================================================================================================== */
BEGIN

CREATE TABLE #ProfitabilityActualSource
(
	Period CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL,
	FunctionalDepartmentCode CHAR(15) NULL,
	JobCode CHAR(15) NULL,
	OriginatingRegionCode CHAR(6) NOT NULL,
	OriginatingSubRegionGlobalRegionId INT NULL,
	AllocationSubRegionGlobalRegionId INT NULL,
	ConsolidationSubRegionGlobalRegionId INT NULL,
	PropertyFundId INT NULL,
	EntityTypeId INT NULL,
	ActivityTypeId INT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual MONEY NOT NULL,
	EntryDate DATETIME NOT NULL,
	LastDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	PropertyFundCode CHAR(12) NULL,
	GLGlobalAccountId INT NULL,
	IsGlobalReporting BIT NULL,
	IsReimbursable BIT NULL,
	DefaultGLCategorizationId INT NULL,
	SourceTableName VARCHAR(20) NOT NULL
)
INSERT INTO #ProfitabilityActualSource
(
	Period,
	SourceCode,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	JobCode,
	OriginatingRegionCode,
	OriginatingSubRegionGlobalRegionId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	PropertyFundId,
	EntityTypeId,
	ActivityTypeId,
	ReferenceCode,
	LocalCurrency,
	LocalActual,
	EntryDate,
	LastDate,
	[User],
	[Description],
	AdditionalDescription,
	PropertyFundCode,
	GLGlobalAccountId,
	IsGlobalReporting,
	IsReimbursable,
	DefaultGLCategorizationId,
	SourceTableName
)
SELECT
	Gl.Period,
	LTRIM(RTRIM(Gl.SourceCode)),
	Fd.FunctionalDepartmentId,
	LTRIM(RTRIM(Fd.GlobalCode)),
	LTRIM(RTRIM(Gl.JobCode)),
	LTRIM(RTRIM(Gl.OriginatingRegionCode)),
	ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId),
	PF.AllocationSubRegionGlobalRegionId,
	ISNULL(CRCD.GlobalRegionId, CRPE.GlobalRegionId),
	PF.PropertyFundId,
	pf.EntityTypeId,
	GA.ActivityTypeId,
	Gl.SourcePrimaryKey,
	Gl.LocalCurrency,
	Gl.LocalActual,
	Gl.EnterDate,
	Gl.LastDate,
	Gl.[User],
	Gl.[Description],
	Gl.AdditionalDescription,
	LTRIM(RTRIM(Gl.PropertyFundCode)),
	GA.GLGlobalAccountId,
	GLA.IsGlobalReporting,
	CASE WHEN Gl.NetTSCost = 'Y' THEN 0 ELSE 1 END,
	RC.GLCategorizationId,
	Gl.SourceTableName
FROM
	#ProfitabilityGeneralLedger Gl

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON -- Used to determine if the source is a Property or a Corporate source
		Gl.SourceCode = GrSc.SourceCode  

	LEFT OUTER JOIN #JobCode Jc ON --The JobCodes is FunctionalDepartment in Corp
		Gl.JobCode = Jc.JobCode AND
		Gl.SourceCode = Jc.Source AND
		GrSc.IsCorporate = 'YES'
			
	LEFT OUTER JOIN #Department Dp ON --The Department (Region+FunctionalDept) is FunctionalDepartment in Prop
		Dp.Department = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		Gl.SourceCode = Dp.Source AND
		GrSc.IsProperty = 'YES'

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		/*
	      Functional Department Investigation, When running Import and clearing wherehouse data for period 201012
	      some of the history is lost and functional departments cannot be linked again and does not exist in gacs anymore
	      so for period 201012 we want to report on the historic functional department we add a little hack
	      
	      Legal Risk and Records Hack:
          you will find the functional department id hack below, when they split legal risk and records into 3 departments
          the reused the code LGL, so for 2010 data we have to hack it.
          
          Revised:
          Add the property to it too, property is joined in GL FunctionalDepartmentCode rather than the GL JobCode.
	    */		
        Fd.FunctionalDepartmentId = 
			CASE 
				WHEN (GL.Period <= 201012) THEN
					CASE GrSc.IsCorporate	
						WHEN 'YES' THEN
							  CASE 
									WHEN (LTRIM(RTRIM(GL.JobCode)) IN ('LGL','RSK', 'RIM')) THEN
										  14
									ELSE 
										  ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
							  END
						ELSE
							CASE
								  WHEN (LTRIM(RTRIM(GL.FunctionalDepartmentCode)) IN ('LGL','RSK','RIM')) THEN
										14
								  ELSE	
									ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
							END
					END								 
				ELSE
					  ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
			END
			
	LEFT OUTER JOIN #GLAccount GLA ON
		Gl.GlAccountCode = GLA.Code  AND
		Gl.SourceCode = GLA.SourceCode 
		
	LEFT OUTER JOIN #GLGlobalAccount GA ON
		GLA.GLGlobalAccountId = GA.GLGlobalAccountId

	LEFT OUTER JOIN #PropertyFundMapping Pfm ON
		LTRIM(RTRIM(Gl.PropertyFundCode)) = Pfm.PropertyFundCode AND
		Gl.SourceCode = Pfm.SourceCode AND
		(
			(GrSc.IsProperty = 'YES' AND Pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND Pfm.ActivityTypeId = GA.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND Pfm.ActivityTypeId IS NULL AND GA.ActivityTypeId IS NULL)
			)
		) AND
		(Gl.Period < '201007')

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(Gl.PropertyFundCode)) = RECD.CorporateDepartmentCode  AND
		Gl.SourceCode = RECD.SourceCode AND
		Gl.Period >= '201007'
		
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		REPE.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201007'		   
	
	LEFT OUTER JOIN	#ConsolidationRegionCorporateDepartment CRCD ON -- CC16
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(Gl.PropertyFundCode)) = CRCD.CorporateDepartmentCode  AND
		Gl.SourceCode = CRCD.SourceCode AND
		Gl.Period >= '201101'
	
	LEFT OUTER JOIN #ConsolidationRegionPropertyEntity CRPE ON -- CC16
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		LTRIM(RTRIM(Gl.PropertyFundCode)) = CRPE.PropertyEntityCode AND
		Gl.SourceCode = CRPE.SourceCode AND
		Gl.Period >= '201007'
	
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		Gl.OriginatingRegionCode = ORCE.CorporateEntityCode AND
		Gl.SourceCode = ORCE.SourceCode  
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) = ORPD.PropertyDepartmentCode  AND
		Gl.SourceCode  = ORPD.SourceCode 
		 
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId =
			CASE
				WHEN Gl.Period < '201007' THEN Pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END	
			
	LEFT OUTER JOIN #ReportingCategorization RC ON
		PF.EntityTypeId = RC.EntityTypeId AND
		PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId  

PRINT 'Rows inserted into ProfitabilityActualSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
END			
/* =============================================================================================================================================
	Insert data into table representing schema of ProfitabilityActual
   =========================================================================================================================================== */

/*
The table below resolves the data warehouse keys based on the mapping data from GDM, HR and GACS.
*/

CREATE TABLE #ProfitabilityActual
(
	CalendarKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	ConsolidationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	SourceSystemKey INT NOT NULL,
	
	LastDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	OriginatingRegionCode NCHAR(6) NULL,
	PropertyFundCode NCHAR(12) NULL,
	FunctionalDepartmentCode NCHAR(15) NULL,
	
	GlobalGLCategorizationHierarchyKey INT NULL,
	USPropertyGLCategorizationHierarchyKey INT NULL,
	USFundGLCategorizationHierarchyKey INT NULL,
	EUPropertyGLCategorizationHierarchyKey INT NULL,
	EUFundGLCategorizationHierarchyKey INT NULL,
	USDevelopmentGLCategorizationHierarchyKey INT NULL,
	EUDevelopmentGLCategorizationHierarchyKey INT NULL,
	ReportingGLCategorizationHierarchyKey INT NULL
) 

INSERT INTO #ProfitabilityActual
(
	CalendarKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	SourceSystemKey,
	LastDate,
	[User],
	[Description],
	AdditionalDescription,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
	ReportingGLCategorizationHierarchyKey
)

SELECT 

	DATEDIFF(dd, '1900-01-01', LEFT(ActualSource.Period, 4)+'-'+RIGHT(ActualSource.Period, 2)+'-01')  AS CalendarKey,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown) AS  SourceKey,
	COALESCE(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) AS FunctionalDepartmentKey,
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown)AS ReimbursableKey,
	ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) AS ActivityTypeKey,
	ISNULL(OrR.OriginatingRegionKey, @OriginatingRegionKeyUnknown) AS OriginatingRegionKey,
	ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AS AllocationRegionKey,
	
	CASE -- CC16: Before 2011, Consolidation Region Key = Allocation Region Key
		WHEN ActualSource.Period < '201101' THEN
			ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown)
		ELSE
				ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown)
	END AS ConsolidationRegionKey,
		
	ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) AS PropertyFundKey,
	ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown) AS OverheadKey,
	
	ActualSource.ReferenceCode,
	ISNULL(Cu.CurrencyKey, @LocalCurrencyKeyUnknown),
	ActualSource.LocalActual,
	SourceSystem.SourceSystemKey,
	ISNULL(ActualSource.LastDate, ActualSource.EntryDate),
	ActualSource.[User],
	ActualSource.[Description],
	ActualSource.AdditionalDescription,
	
	ActualSource.OriginatingRegionCode,
	ActualSource.PropertyFundCode,
	ActualSource.FunctionalDepartmentCode,
	
	-- CC21 Changes
	/*
	Each categorization is mapped using the keys from the GLCategorizationHierarchy dimension. If the record cannot be found,
	the unkown record for the respective GL Account is used, and if the GL account is unknown, the global Unknown key is used.
	*/
	COALESCE(GlobalGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey),
	COALESCE (USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),	
	COALESCE(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
	COALESCE(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
	COALESCE(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
	COALESCE(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey),
	COALESCE(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown),
	
	/*
	The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
	when a local report is generated.
	*/
		
	CASE 
		WHEN GC.GLCategorizationId IS NOT NULL THEN
			CASE
				WHEN (GC.Name = 'US Property') 
				THEN ISNULL(USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
				
				WHEN (GC.Name = 'US Fund')  
				THEN  ISNULL(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey) 
				
				WHEN (GC.Name = 'EU Property')  
				THEN ISNULL(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
				
				WHEN (GC.Name = 'EU Fund')  
				THEN ISNULL(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey) 
				
				WHEN (GC.Name = 'US Development')  
				THEN ISNULL(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey) 
				
				WHEN (GC.Name = 'EU Development')  
				THEN ISNULL(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
				
				WHEN GC.Name = 'Global' 
				THEN COALESCE(GlobalGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
				ELSE @GLCategorizationHierarchyKeyUnknown
			END
		ELSE @GLCategorizationHierarchyKeyUnknown
	END ReportingGLCategorizationHierarchyKey

FROM
	#ProfitabilityActualSource ActualSource
	
	LEFT OUTER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
		ActualSource.SourceTableName = SourceSystem.SourceTableName AND
		SourceSystem.SourceSystemName = 'MRI'
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = ActualSource.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		ActualSource.LocalCurrency = Cu.CurrencyCode  

	LEFT OUTER JOIN #JobCodeFunctionalDepartment GrFdm1 ON --Detail/Sub Level : JobCode
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate)  BETWEEN GrFdm1.StartDate AND GrFdm1.EndDate AND
		GrFdm1.ReferenceCode = CASE WHEN ActualSource.JobCode IS NOT NULL THEN LTRIM(RTRIM(ActualSource.FunctionalDepartmentCode)) + ':'+ LTRIM(RTRIM(ActualSource.JobCode))
									ELSE LTRIM(RTRIM(ActualSource.FunctionalDepartmentCode)) + ':UNKNOWN' END

	--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
	--that will be used, should the JobCode not match, but the FunctionalDepartment does match
	LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2 ON
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate AND
		GrFdm2.ReferenceCode = LTRIM(RTRIM(ActualSource.FunctionalDepartmentCode)) +':' 
		
	-- Change Control 21: New GL Account Categorization Mappings
	
	-- The join to the mapping table created above for the Global and Local categorizations.		
	LEFT OUTER JOIN #GlAccountCategoryMapping GACM ON
		ActualSource.GLGlobalAccountId = GACM.GLGlobalAccountId AND
		GACM.IsDirect = (CASE WHEN GrSc.IsProperty = 'YES' THEN 1 ELSE 0 END)
	
	-- The join to the GLCategorizationHierarchy dimension for the Global categorization.	
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalGCH ON
		GACM.GlobalGLCategorizationHierarchyCode  = GlobalGCH.GLCategorizationHierarchyCode AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GlobalGCH.StartDate AND GlobalGCH.EndDate AND
		GlobalGCH.SnapshotId = 0
		
	LEFT OUTER JOIN #PayrollGlobalMappings PGM ON
		GlobalGCH.GLMinorCategoryName = PGM.GLMinorCategoryName AND
		GlobalGCH.GLMajorCategoryName = PGM.GLMajorCategoryName
		
	LEFT OUTER JOIN #GLMinorCategoryPayrollType MCPT ON
		PGM.GLMinorCategoryId = MCPT.GLMinorCategoryId
		
	LEFT OUTER JOIN #LocalPayrollGLCategorizationMapping LocalPayrollMappings ON
		ActualSource.ActivityTypeId = LocalPayrollMappings.ActivityTypeId AND
		ActualSource.FunctionalDepartmentId = LocalPayrollMappings.FunctionalDepartmentId AND
		MCPT.GLMinorCategoryId = LocalPayrollMappings.GlobalGLMinorCategoryId AND
		MCPT.PayrollTypeId = LocalPayrollMappings.PayrollTypeId	
		
	-- The join to the GLCategorizationHierarchy dimension for the US Property local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USPropertyGCH ON
		USPropertyGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN LocalPayrollMappings.USPropertyGLCategorizationHierarchyCode
				ELSE GACM.USPropertyGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN USPropertyGCH.StartDate AND USPropertyGCH.EndDate AND
		USPropertyGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the US Fund local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USFundGCH ON
		USFundGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN LocalPayrollMappings.USFundGLCategorizationHierarchyCode
				ELSE GACM.USFundGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN USFundGCH.StartDate AND USFundGCH.EndDate AND
		USFundGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the EU Property local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUPropertyGCH ON
		EUPropertyGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN LocalPayrollMappings.EUPropertyGLCategorizationHierarchyCode
				ELSE GACM.EUPropertyGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN EUPropertyGCH.StartDate AND EUPropertyGCH.EndDate AND
		EUPropertyGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the EU Fund local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUFundGCH ON
		EUFundGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN LocalPayrollMappings.EUFundGLCategorizationHierarchyCode
				ELSE GACM.EUFundGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN EUFundGCH.StartDate AND EUFundGCH.EndDate AND
		EUFundGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the US Development local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USDevelopmentGCH ON
		USDevelopmentGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN LocalPayrollMappings.USDevelopmentGLCategorizationHierarchyCode
				ELSE GACM.USDevelopmentGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN USDevelopmentGCH.StartDate AND USDevelopmentGCH.EndDate AND
		USDevelopmentGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the EU Development local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUDevelopmentGCH ON
		EUDevelopmentGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = 'Salaries/Taxes/Benefits'
				THEN LocalPayrollMappings.EUDevelopmentGLCategorizationHierarchyCode
				ELSE GACM.EUDevelopmentGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN EUDevelopmentGCH.StartDate AND EUDevelopmentGCH.EndDate AND
		EUDevelopmentGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for when the GlAccount is known, but the Categorization details
	-- are unknown.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
		UnknownGCH.GLCategorizationHierarchyCode = '-1:-1:-1:-1:-1:' + CONVERT(VARCHAR(10), ActualSource.GLGlobalAccountId) AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN UnknownGCH.StartDate AND UnknownGCH.EndDate AND
		UnknownGCH.SnapshotId = 0
		
	-- Change Control 21 End

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ActualSource.ActivityTypeId = GrAt.ActivityTypeId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = 0

	--GC Change Control 1
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' ELSE 'N/A' END
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion OrR ON
		ActualSource.OriginatingSubRegionGlobalRegionId = OrR.GlobalRegionId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN OrR.StartDate AND OrR.EndDate AND
		OrR.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ActualSource.PropertyFundId = GrPf.PropertyFundId AND 
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrPf.StartDate AND GrPf.EndDate AND
		GrPf.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ActualSource.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrAr.StartDate AND GrAr.EndDate AND 
		GrAr.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- ConsolidationRegion Change Control 16
		ActualSource.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrCr.StartDate AND GrCr.EndDate AND 
		GrCr.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = 
			CASE 
				WHEN ActualSource.IsReimbursable = 0 
					THEN 'NO' 
				ELSE 'YES' 
			END
	
	-- The default categorization to be used in the report
		
	LEFT OUTER JOIN #GLCategorization GC ON
		ActualSource.DefaultGLCategorizationID = GC.GLCategorizationId
		
PRINT 'Rows inserted into ProfitabilityActual:'+CONVERT(char(10),@@rowcount)	
PRINT 'Completed converting all transactional data to star schema keys'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityActual_ReferenceCode ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

/* ==============================================================================================================================================
	Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
   =========================================================================================================================================== */
BEGIN

DECLARE @UpdatedDate DATETIME = GETDATE()

--Transfer the updated rows
UPDATE DIM
SET	
	CalendarKey						 = Pro.CalendarKey,
	FunctionalDepartmentKey			 = Pro.FunctionalDepartmentKey,
	ReimbursableKey					 = Pro.ReimbursableKey,
	ActivityTypeKey					 = Pro.ActivityTypeKey,
	OriginatingRegionKey			 = Pro.OriginatingRegionKey,
	AllocationRegionKey				 = Pro.AllocationRegionKey,
	ConsolidationRegionKey			 = Pro.ConsolidationRegionKey,
	PropertyFundKey					 = Pro.PropertyFundKey,
	OverheadKey						 = Pro.OverheadKey,
	LocalCurrencyKey				 = Pro.LocalCurrencyKey,
	LocalActual						 = Pro.LocalActual,
	SourceSystemKey					 = Pro.SourceSystemKey,
	
	GlobalGLCategorizationHierarchyKey		 = Pro.GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey	 = Pro.USPropertyGLCategorizationHierarchyKey, 
	USFundGLCategorizationHierarchyKey		 = Pro.USFundGLCategorizationHierarchyKey, 
	EUPropertyGLCategorizationHierarchyKey	 = Pro.EUPropertyGLCategorizationHierarchyKey, 
	EUFundGLCategorizationHierarchyKey		 = Pro.EUFundGLCategorizationHierarchyKey, 
	USDevelopmentGLCategorizationHierarchyKey = Pro.USDevelopmentGLCategorizationHierarchyKey, 
	EUDevelopmentGLCategorizationHierarchyKey = Pro.EUDevelopmentGLCategorizationHierarchyKey, 
	ReportingGLCategorizationHierarchyKey	= Pro.ReportingGLCategorizationHierarchyKey,
	
	LastDate						 = Pro.LastDate,
	[User]							 = Pro.[User],
	[Description]					 = Pro.[Description],
	AdditionalDescription			 = Pro.AdditionalDescription,
	
	OriginatingRegionCode			 = Pro.OriginatingRegionCode,
	PropertyFundCode				 = Pro.PropertyFundCode,
	FunctionalDepartmentCode		 = Pro.FunctionalDepartmentCode,
	
	UpdatedDate						= @UpdatedDate
FROM
	GrReporting.dbo.ProfitabilityActual DIM
	
	INNER JOIN #ProfitabilityActual Pro ON
		DIM.SourceKey = Pro.SourceKey AND
		DIM.ReferenceCode = Pro.ReferenceCode
WHERE
	DIM.CalendarKey						 <> Pro.CalendarKey OR
	DIM.FunctionalDepartmentKey			 <> Pro.FunctionalDepartmentKey OR
	DIM.ReimbursableKey					 <> Pro.ReimbursableKey OR
	DIM.ActivityTypeKey					 <> Pro.ActivityTypeKey OR
	DIM.OriginatingRegionKey			 <> Pro.OriginatingRegionKey OR
	DIM.AllocationRegionKey				 <> Pro.AllocationRegionKey OR
	DIM.ConsolidationRegionKey			 <> Pro.ConsolidationRegionKey OR
	DIM.PropertyFundKey					 <> Pro.PropertyFundKey OR
	DIM.OverheadKey						 <> Pro.OverheadKey OR
	DIM.LocalCurrencyKey				 <> Pro.LocalCurrencyKey OR
	DIM.LocalActual						 <> Pro.LocalActual OR
	DIM.SourceSystemKey					 <> Pro.SourceSystemKey OR
	
	ISNULL(DIM.GlobalGLCategorizationHierarchyKey, '')		 <> Pro.GlobalGLCategorizationHierarchyKey OR
	ISNULL(DIM.USPropertyGLCategorizationHierarchyKey, '')	 <> Pro.USPropertyGLCategorizationHierarchyKey OR 
	ISNULL(DIM.USFundGLCategorizationHierarchyKey, '')		 <> Pro.USFundGLCategorizationHierarchyKey OR 
	ISNULL(DIM.EUPropertyGLCategorizationHierarchyKey, '')	 <> Pro.EUPropertyGLCategorizationHierarchyKey OR 
	ISNULL(DIM.EUFundGLCategorizationHierarchyKey, '')		 <> Pro.EUFundGLCategorizationHierarchyKey OR 
	ISNULL(DIM.USDevelopmentGLCategorizationHierarchyKey, '') <> Pro.USDevelopmentGLCategorizationHierarchyKey OR 
	ISNULL(DIM.EUDevelopmentGLCategorizationHierarchyKey, '') <> Pro.EUDevelopmentGLCategorizationHierarchyKey OR 
	ISNULL(DIM.ReportingGLCategorizationHierarchyKey, '')	<> Pro.ReportingGLCategorizationHierarchyKey OR
	
	DIM.LastDate						 <> Pro.LastDate OR
	DIM.[User]							 <> Pro.[User] OR
	DIM.[Description]					 <> Pro.[Description] OR
	DIM.AdditionalDescription			 <> Pro.AdditionalDescription OR
	
	DIM.OriginatingRegionCode			 <> Pro.OriginatingRegionCode OR
	DIM.PropertyFundCode				 <> Pro.PropertyFundCode OR
	DIM.FunctionalDepartmentCode		 <> Pro.FunctionalDepartmentCode
	

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual 
(
	CalendarKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverHeadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	SourceSystemKey,
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
	ReportingGLCategorizationHierarchyKey,
	LastDate,
	[User],
	[Description],
	AdditionalDescription,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	InsertedDate,
	UpdatedDate
)
	
SELECT
	Pro.CalendarKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.ConsolidationRegionKey,
	Pro.PropertyFundKey,
	Pro.OverHeadKey,
	Pro.ReferenceCode,
	Pro.LocalCurrencyKey,
	Pro.LocalActual,
	Pro.SourceSystemKey,
	
	Pro.GlobalGLCategorizationHierarchyKey,
	Pro.USPropertyGLCategorizationHierarchyKey,
	Pro.USFundGLCategorizationHierarchyKey,
	Pro.EUPropertyGLCategorizationHierarchyKey,
	Pro.EUFundGLCategorizationHierarchyKey,
	Pro.USDevelopmentGLCategorizationHierarchyKey,
	Pro.EUDevelopmentGLCategorizationHierarchyKey,
	Pro.ReportingGLCategorizationHierarchyKey,
	
	Pro.LastDate,
	Pro.[User],
	Pro.[Description],
	Pro.AdditionalDescription,
	Pro.OriginatingRegionCode, 
	Pro.PropertyFundCode, 
	Pro.FunctionalDepartmentCode,
	
	@UpdatedDate, -- InsertedDate
	@UpdatedDate -- UpdatedDate
FROM
	#ProfitabilityActual Pro
	
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		Pro.SourceKey  = ProExists.SourceKey AND
		Pro.ReferenceCode = ProExists.ReferenceCode  
WHERE
	ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)


-- remove orphan rows from the warehouse that have been removed in the source data systems
EXEC stp_IU_ArchiveProfitabilityMRIActual @ImportStartDate=@ImportStartDate, @ImportEndDate=@ImportEndDate, @DataPriorToDate=@DataPriorToDate

END
/* ==============================================================================================================================================
	Clean up
   =========================================================================================================================================== */
 
BEGIN

IF OBJECT_ID('tempdb..#ManageType') IS NOT NULL
	DROP TABLE #ManageType

IF OBJECT_ID('tempdb..#ManageCorporateDepartment') IS NOT NULL
	DROP TABLE #ManageCorporateDepartment
	
IF OBJECT_ID('tempdb..#ManageCorporateEntity') IS NOT NULL
	DROP TABLE #ManageCorporateEntity
	
IF OBJECT_ID('tempdb..#ManagePropertyDepartment') IS NOT NULL	
	DROP TABLE #ManagePropertyDepartment
	
IF OBJECT_ID('tempdb..#ManagePropertyEntity') IS NOT NULL
	DROP TABLE #ManagePropertyEntity

IF OBJECT_ID('tempdb..#ProfitabilityGeneralLedger') IS NOT NULL
	DROP TABLE #ProfitabilityGeneralLedger
	
IF OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL	
	DROP TABLE #FunctionalDepartment
	
IF OBJECT_ID('tempdb..#Department') IS NOT NULL	
	DROP TABLE #Department

IF OBJECT_ID('tempdb..#JobCode') IS NOT NULL
	DROP TABLE #JobCode

IF OBJECT_ID('tempdb..#ActivityType') IS NOT NULL
	DROP TABLE #ActivityType
	
IF OBJECT_ID('tempdb..#GLGlobalAccount') IS NOT NULL	
	DROP TABLE #GLGlobalAccount
	
IF OBJECT_ID('tempdb..#OriginatingRegionCorporateEntity') IS NOT NULL	
	DROP TABLE #OriginatingRegionCorporateEntity

IF OBJECT_ID('tempdb..#OriginatingRegionPropertyDepartment') IS NOT NULL
	DROP TABLE #OriginatingRegionPropertyDepartment

IF OBJECT_ID('tempdb..#PropertyFundMapping') IS NOT NULL
	DROP TABLE #PropertyFundMapping

IF OBJECT_ID('tempdb..#PropertyFund') IS NOT NULL
	DROP TABLE #PropertyFund

IF OBJECT_ID('tempdb..#ReportingEntityCorporateDepartment') IS NOT NULL
	DROP TABLE #ReportingEntityCorporateDepartment

IF OBJECT_ID('tempdb..#ReportingEntityPropertyEntity') IS NOT NULL
	DROP TABLE #ReportingEntityPropertyEntity

IF OBJECT_ID('tempdb..#AllocationSubRegion') IS NOT NULL
	DROP TABLE #AllocationSubRegion

IF OBJECT_ID('tempdb..#JobCodeFunctionalDepartment') IS NOT NULL
	DROP TABLE #JobCodeFunctionalDepartment

IF OBJECT_ID('tempdb..#ParentFunctionalDepartment') IS NOT NULL
	DROP TABLE #ParentFunctionalDepartment

IF OBJECT_ID('tempdb..#GLCategorizationType') IS NOT NULL
	DROP TABLE #GLCategorizationType

IF OBJECT_ID('tempdb..#GLCategorization') IS NOT NULL
	DROP TABLE #GLCategorization

IF OBJECT_ID('tempdb..#GLGlobalAccountCategorization') IS NOT NULL
	DROP TABLE #GLGlobalAccountCategorization

IF OBJECT_ID('tempdb..#GLFinancialCategory') IS NOT NULL
	DROP TABLE #GLFinancialCategory

IF OBJECT_ID('tempdb..#GLAccount') IS NOT NULL
	DROP TABLE #GLAccount

IF OBJECT_ID('tempdb..#GLMajorCategory') IS NOT NULL
	DROP TABLE #GLMajorCategory

IF OBJECT_ID('tempdb..#GLMinorCategory') IS NOT NULL
	DROP TABLE #GLMinorCategory

IF OBJECT_ID('tempdb..#ProfitabilityActual') IS NOT NULL
	DROP TABLE #ProfitabilityActual

IF OBJECT_ID('tempdb..#GlAccountCategoryMapping') IS NOT NULL
	DROP TABLE #GlAccountCategoryMapping

IF OBJECT_ID('tempdb..#ConsolidationRegionCorporateDepartment') IS NOT NULL
	DROP TABLE #ConsolidationRegionCorporateDepartment

IF OBJECT_ID('tempdb..#ConsolidationRegionPropertyEntity') IS NOT NULL
	DROP TABLE #ConsolidationRegionPropertyEntity

IF OBJECT_ID('tempdb..#ConsolidationSubRegion') IS NOT NULL
	DROP TABLE #ConsolidationSubRegion

END





GO


