/*
1. dbo.stp_IU_LoadGrProfitabiltyGeneralLedger.sql
2. dbo.stp_IU_LoadGrProfitabiltyGBSBudget
3. dbo.stp_IU_LoadGrProfitabiltyGBSReforecast
4. dbo.stp_IU_LoadGrProfitabiltyPayrollOriginalBudget
5. dbo.stp_IU_LoadGrProfitabiltyPayrollReforecast
6. dbo.stp_IU_LoadGrProfitabiltyOverhead.sql
7. dbo.stp_IU_ArchiveProfitabilityMRIActual.sql
8. dbo.stp_IU_ArchiveProfitabilityOverheadActual.sql
9. dbo.stp_IU_ArchiveProfitabilityMRIActual.sql
*/ 

USE GrReportingStaging
GO

/*
1. dbo.stp_IU_LoadGrProfitabiltyGeneralLedger.sql
*/ 
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 11/08/2010 10:25:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
GO

/*********************************************************************************************************************
Description
	This stored procedure processes actual transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate	DateTime=NULL,
	@ImportEndDate		DateTime=NULL,
	@DataPriorToDate	DateTime=NULL
AS

IF (@ImportStartDate IS NULL)
	BEGIN
	SET @ImportStartDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'ActualImportStartDate'))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
	SET @ImportEndDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'ActualImportEndDate'))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'ActualDataPriorToDate'))
	END

DECLARE 
		@GlAccountKeyUnknown INT,
		@GlAccountCategoryKey INT,
		@FunctionalDepartmentKeyUnknown INT,
		@ReimbursableKeyUnknown INT,
		@ActivityTypeKeyUnknown INT,
		@SourceKeyUnknown INT,
		@OriginatingRegionKeyUnknown INT,
		@AllocationRegionKeyUnknown INT,
		@PropertyFundKeyUnknown INT,
		@OverheadKeyUnknown INT,
		-- @CurrencyKey	INT,
		@EUFundGlAccountCategoryKeyUnknown	INT,
		@EUCorporateGlAccountCategoryKeyUnknown INT,
		@EUPropertyGlAccountCategoryKeyUnknown	INT,
		@USFundGlAccountCategoryKeyUnknown INT,
		@USPropertyGlAccountCategoryKeyUnknown	INT,
		@USCorporateGlAccountCategoryKeyUnknown INT,
		@DevelopmentGlAccountCategoryKeyUnknown INT,
		@GlobalGlAccountCategoryKeyUnknown INT
      
--Default FK for the Fact table
/*

DECLARE	@ImportStartDate DateTime
DECLARE	@ImportEndDate DateTime
DECLARE	@DataPriorToDate DateTime

SET	@ImportStartDate = '1900-01-01'
SET	@ImportEndDate = '2010-12-31'
SET	@DataPriorToDate = '2010-12-31'

[stp_IU_LoadGrProfitabiltyGeneralLedgerVer2]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/       
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN' AND SnapshotId = 0) -- GDM: changed GlAccountCode to Code
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN' AND SnapshotId = 0)
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN' AND SnapshotId = 0)
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN' AND SnapshotId = 0)
--SET @CurrencyKey			 = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNK')
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN' AND SnapshotId = 0)

IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()

IF 	(@DataPriorToDate < '2010-01-01')
	SET @DataPriorToDate = '2010-01-01'
	
SET NOCOUNT ON
PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGeneralLedger'
PRINT CONVERT(VARCHAR(27), getdate(), 121)
PRINT '####'

----- Temp table creation and data inserts - Change Control 7

CREATE TABLE #ManageType(
	ImportKey INT NOT NULL,
	ManageTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #ManageCorporateDepartment(
	ImportKey INT NOT NULL,
	ManageCorporateDepartmentId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #ManageCorporateEntity(
	ImportKey INT NOT NULL,
	ManageCorporateEntityId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)


CREATE TABLE #ManagePropertyDepartment(
	ImportKey INT NOT NULL,
	ManagePropertyDepartmentId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	PropertyDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #ManagePropertyEntity(
	ImportKey INT NOT NULL,
	ManagePropertyEntityId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
----

-- #ManageType

INSERT INTO #ManageType(
	ImportKey,
	ManageTypeId,
	Code,
	Name,
	[Description],
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MT.ImportKey,
	MT.ManageTypeId,
	MT.Code,
	MT.Name,
	MT.[Description],
	MT.IsDeleted,
	MT.InsertedDate,
	MT.UpdatedDate
FROM
	Gdm.ManageType MT
	INNER JOIN Gdm.ManageTypeActive(@DataPriorToDate) MTA ON
		MT.ImportKey = MTA.ImportKey
		
-- #ManageCorporateDepartment

INSERT INTO #ManageCorporateDepartment(
	ImportKey,
	ManageCorporateDepartmentId,
	ManageTypeId,
	CorporateDepartmentCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MCD.ImportKey,
	MCD.ManageCorporateDepartmentId,
	MCD.ManageTypeId,
	MCD.CorporateDepartmentCode,
	MCD.SourceCode,
	MCD.IsDeleted,
	MCD.InsertedDate,
	MCD.UpdatedDate 
FROM
	Gdm.ManageCorporateDepartment MCD
	INNER JOIN Gdm.ManageCorporateDepartmentActive(@DataPriorToDate) MCDA ON
		MCD.ImportKey = MCDA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MCD.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- #ManageCorporateEntity

INSERT INTO #ManageCorporateEntity(
	ImportKey,
	ManageCorporateEntityId,
	ManageTypeId,
	CorporateEntityCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MCE.ImportKey,
	MCE.ManageCorporateEntityId,
	MCE.ManageTypeId,
	MCE.CorporateEntityCode,
	MCE.SourceCode,
	MCE.IsDeleted,
	MCE.InsertedDate,
	MCE.UpdatedDate 
FROM
	Gdm.ManageCorporateEntity MCE
	INNER JOIN Gdm.ManageCorporateEntityActive(@DataPriorToDate) MCEA ON
		MCE.ImportKey = MCEA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MCE.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- #ManagePropertyDepartment

INSERT INTO #ManagePropertyDepartment(
	ImportKey,
	ManagePropertyDepartmentId,
	ManageTypeId,
	PropertyDepartmentCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MPD.ImportKey,
	MPD.ManagePropertyDepartmentId,
	MPD.ManageTypeId,
	MPD.PropertyDepartmentCode,
	MPD.SourceCode,
	MPD.IsDeleted,
	MPD.InsertedDate,
	MPD.UpdatedDate 
FROM
	Gdm.ManagePropertyDepartment MPD
	INNER JOIN Gdm.ManagePropertyDepartmentActive(@DataPriorToDate) MPDA ON
		MPD.ImportKey = MPDA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MPD.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- #ManagePropertyEntity

INSERT INTO #ManagePropertyEntity(
	ImportKey,
	ManagePropertyEntityId,
	ManageTypeId,
	PropertyEntityCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MPE.ImportKey,
	MPE.ManagePropertyEntityId,
	MPE.ManageTypeId,
	MPE.PropertyEntityCode,
	MPE.SourceCode,
	MPE.IsDeleted,
	MPE.InsertedDate,
	MPE.UpdatedDate 
FROM
	Gdm.ManagePropertyEntity MPE
	INNER JOIN Gdm.ManagePropertyEntityActive(@DataPriorToDate) MPEA ON
		MPE.ImportKey = MPEA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MPE.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Master Temp table for the combined ledger results from MRI Sources
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityGeneralLedger(
	SourcePrimaryKey VARCHAR(100) NULL,
	SourceTableId INT NOT NULL,
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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger (
	SourcePrimaryKey,
	SourceTableId,
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
	'N',
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					USProp.ENTITY En
					INNER JOIN USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					USProp.GACC Ga
					INNER JOIN USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

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
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
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

	-- Change Control 7: IS - end

PRINT 'US PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					USCorp.ENTITY En
					INNER JOIN USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					USCorp.GACC Ga
					INNER JOIN USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
				
	INNER JOIN (
				SELECT
					Gd.*
				FROM
					USCorp.GDEP Gd
					INNER JOIN USCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
										
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
	
	-- Change Control 7: IS - end	
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'


PRINT 'US CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
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
	'N',
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					EUProp.ENTITY En
					INNER JOIN EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode

	INNER JOIN (
				SELECT
					Ga.*
				FROM
					EUProp.GACC Ga
					INNER JOIN EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

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
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
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

	-- Change Control 7: IS - end

PRINT 'EU PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
	
FROM EUCorp.GeneralLedger Gl
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					EUCorp.ENTITY En
					INNER JOIN EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
				
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					EUCorp.GACC Ga
					INNER JOIN EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					EUCorp.GDEP Gd
					INNER JOIN EUCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR, 0) = 'Y' AND
	Gl.BALFOR <> 'B' --AND
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
	
	-- Change Control 7: IS - end	

PRINT 'EU CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
	'N',
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					BRProp.ENTITY En
					INNER JOIN BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					BRProp.GACC Ga
					INNER JOIN BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
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
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
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
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = 'BR' AND
			MPD.IsDeleted = 0
	)

	-- Change Control 7: IS - end

PRINT 'BR PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
		
FROM BRCorp.GeneralLedger Gl
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					BRCorp.ENTITY En
					INNER JOIN BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					BRCorp.GACC Ga
					INNER JOIN BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					BRCorp.GDEP Gd
					INNER JOIN BRCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR,0) = 'Y' AND
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
	
	-- Change Control 7: IS - end

PRINT 'BR CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
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
	'N',
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Em.*
				FROM
					GACS.EntityMapping Em
					INNER JOIN GACS.EntityMappingActive(@DataPriorToDate) EmA ON
						EmA.ImportKey = Em.ImportKey
				) Em ON
		Em.OriginalEntityRef = Gl.PropertyFundCode AND
		Em.[Source] = Gl.SourceCode -- this should filter EntityMapping by source of 'CN', because Gl.SourceCode will always be this
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					CNProp.GACC Ga
					INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
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
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = CASE --Gl.PropertyFundCode AND
														WHEN LTRIM(RTRIM(Gl.PropertyFundCode)) = LTRIM(RTRIM(Em.OriginalEntityRef)) THEN Em.LocalEntityRef ELSE Gl.PropertyFundCode
													  END AND							
							
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'CN')
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

	-- Change Control 7: IS - end

PRINT 'CH PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					CNCorp.ENTITY En
					INNER JOIN CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					CNCorp.GACC Ga
					INNER JOIN CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					CNCorp.GDEP Gd
					INNER JOIN CNCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B' --AND
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
	
	-- Change Control 7: IS - end
	
PRINT 'CH CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INProp.GeneralLedger Gl
	INNER JOIN (
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					INProp.ENTITY En
					INNER JOIN INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					INProp.GACC Ga
					INNER JOIN INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	-- En.Name	NOT LIKE '%Intercompany%' AND -- Change Control 7: IS - removed
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
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
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

	-- Change Control 7: IS - end

PRINT 'IN PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
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
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					INCorp.ENTITY En
					INNER JOIN INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					INCorp.GACC Ga
					INNER JOIN INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
				
	INNER JOIN (
				SELECT
					Gd.*
				FROM
					INCorp.GDEP Gd
					INNER JOIN INCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
										
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
	
	-- Change Control 7: IS - end

PRINT 'IN CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityGeneralLedger (UpdatedDate, FunctionalDepartmentCode, JobCode, GlAccountCode, SourceCode, Period, OriginatingRegionCode, PropertyFundCode, SourcePrimaryKey)

PRINT 'Completed building clustered index on #ProfitabilityGeneralLedger'
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them INTo the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Prepare the # tables used for performance optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Code VARCHAR(31) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

CREATE TABLE #Department(
	ImportKey INT NOT NULL,
	Department CHAR(8) NOT NULL,
	[Description] VARCHAR(50) NULL,
	LastDate DATETIME NULL,
	MRIUserID CHAR(20) NULL,
	[Source] CHAR(2) NOT NULL,
	IsActive BIT NOT NULL,
	FunctionalDepartmentId INT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #JobCode(
	ImportKey INT NOT NULL,
	JobCode VARCHAR(15) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	JobType VARCHAR(15) NOT NULL,
	BuildingRef VARCHAR(6) NULL,
	LastDate DATETIME NOT NULL,
	IsActive BIT NOT NULL,
	Reference VARCHAR(50) NOT NULL,
	MRIUserID CHAR(20) NOT NULL,
	[Description] VARCHAR(50) NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL,
	AccountingComment VARCHAR(5000) NULL,
	PMComment VARCHAR(5000) NULL,
	LeaseRef VARCHAR(20) NULL,
	Area INT NULL,
	AreaType VARCHAR(20) NULL,
	RMPropertyRef VARCHAR(6) NULL,
	IsAssumption BIT NOT NULL,
	FunctionalDepartmentId INT NULL
) 

CREATE TABLE #ActivityType(
	ImportKey INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	GLAccountSuffix char(2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #GLGlobalAccount(
	ImportKey INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountGLAccount( -- used to be #GlAccountMapping in GDM 1.2
	ImportKey INT NOT NULL,
	GLGlobalAccountGLAccountId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(12) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[Description] NVARCHAR(255) NOT NULL,
	PreGlobalAccountCode VARCHAR(50) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

CREATE TABLE #PropertyFund( -- GDM 2.0 change
	ImportKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

CREATE TABLE #ConsolidationRegionCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ConsolidationRegionPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ConsolidationSubRegion(
	ImportKey INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	ConsolidationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #JobCodeFunctionalDepartment(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

CREATE TABLE #ParentFunctionalDepartment(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

-- #FunctionalDepartment

INSERT INTO #FunctionalDepartment(
	ImportKey,
	FunctionalDepartmentId,
	[Name],
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT
	Fd.ImportKey,
	Fd.FunctionalDepartmentId,
	Fd.Name,
	Fd.Code,
	Fd.IsActive,
	Fd.InsertedDate,
	Fd.UpdatedDate,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		FdA.ImportKey = Fd.ImportKey

-- #Department

INSERT INTO #Department(
	ImportKey,
	Department,
	[Description],
	LastDate,
	MRIUserID,
	[Source],
	IsActive,
	FunctionalDepartmentId,
	UpdatedDate
)
SELECT
	Dpt.ImportKey,
	Dpt.Department,
	Dpt.[Description],
	Dpt.LastDate,
	Dpt.MRIUserID,
	Dpt.[Source],
	Dpt.IsActive,
	Dpt.FunctionalDepartmentId,
	Dpt.UpdatedDate
FROM GACS.Department Dpt
	INNER JOIN GACS.DepartmentActive(@DataPriorToDate) DptA ON
		DptA.ImportKey = Dpt.ImportKey
WHERE
	Dpt.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #Department (Department, [Source])

-- #JobCode

INSERT INTO #JobCode(
	ImportKey,
	JobCode,
	[Source],
	JobType,
	BuildingRef,
	LastDate,
	IsActive,
	Reference,
	MRIUserID,
	[Description],
	StartDate,
	EndDate,
	AccountingComment,
	PMComment,
	LeaseRef,
	Area,
	AreaType,
	RMPropertyRef,
	IsAssumption,
	FunctionalDepartmentId
)
SELECT
	Jc.ImportKey,
	Jc.JobCode,
	Jc.[Source],
	Jc.JobType,
	Jc.BuildingRef,
	Jc.LastDate,
	Jc.IsActive,
	Jc.Reference,
	Jc.MRIUserID,
	Jc.[Description],
	Jc.StartDate,
	Jc.EndDate,
	Jc.AccountingComment,
	Jc.PMComment,
	Jc.LeaseRef,
	Jc.Area,
	Jc.AreaType,
	Jc.RMPropertyRef,
	Jc.IsAssumption,
	Jc.FunctionalDepartmentId
FROM
	GACS.JobCode Jc
	INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON
		JcA.ImportKey = Jc.ImportKey
WHERE
	Jc.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #JobCode (JobCode, [Source])

-- #ActivityType

INSERT INTO #ActivityType(
	ImportKey,
	ActivityTypeId,
	ActivityTypeCode,
	[Name],
	GLAccountSuffix,
	InsertedDate,
	UpdatedDate
)
SELECT
	At.ImportKey,
	At.ActivityTypeId,
	At.Code,
	At.Name,
	At.GLAccountSuffix,
	At.InsertedDate,
	At.UpdatedDate
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

-- #GLGlobalAccount

INSERT INTO #GLGlobalAccount(
	ImportKey,
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GLA.ImportKey,
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.GLStatutoryTypeId,
	GLA.Code,
	GLA.[Name], 
	GLA.[Description],
	GLA.IsGR,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.IsActive,
	GLA.InsertedDate,
	GLA.UpdatedDate,
	GLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLAA.ImportKey = GLA.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

-- #GLGlobalAccountGLAccount

INSERT INTO #GLGlobalAccountGLAccount(
	ImportKey,
	GLGlobalAccountGLAccountId,
	GLGlobalAccountId,
	SourceCode,
	Code,
	[Name],
	[Description],
	PreGlobalAccountCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GAGLA.ImportKey,
	GAGLA.GLGlobalAccountGLAccountId,
	GAGLA.GLGlobalAccountId,
	GAGLA.SourceCode,
	GAGLA.Code,
	GAGLA.[Name],
	GAGLA.[Description],
	GAGLA.PreGlobalAccountCode,
	GAGLA.IsActive,
	GAGLA.InsertedDate,
	GAGLA.UpdatedDate,
	GAGLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountGLAccount GAGLA
	INNER JOIN Gdm.GLGlobalAccountGLAccountActive(@DataPriorToDate) GlA ON
		GlA.ImportKey = GAGLA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccountGLAccount (Code, SourceCode, GLGlobalAccountGLAccountId)

-- #PropertyFundMapping

INSERT INTO #PropertyFundMapping(
	ImportKey,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId)
SELECT
	Pfm.ImportKey,
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

-- #PropertyFund

INSERT INTO #PropertyFund(
	ImportKey,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	[Name],
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	PF.ImportKey,
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.[Name],
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.IsActive,
	PF.InsertedDate,
	PF.UpdatedDate,
	PF.UpdatedByStaffId
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PFA.ImportKey = PF.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (PropertyFundId)

-- #ReportingEntityCorporateDepartment

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

-- #ReportingEntityPropertyEntity

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey
		
-- #ConsolidationRegionCorporateDepartment

INSERT INTO	#ConsolidationRegionCorporateDepartment(
	ImportKey,
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	CRCD.ImportKey,
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode,
	CRCD.InsertedDate,
	CRCD.UpdatedDate,
	CRCD.UpdatedByStaffId
FROM
	Gdm.ConsolidationRegionCorporateDepartment CRCD
	INNER JOIN Gdm.ConsolidationRegionCorporateDepartmentActive(@DataPriorToDate) CRCDA ON
		CRCDA.ImportKey = CRCD.ImportKey

-- #ConsolidationRegionPropertyEntity

INSERT INTO #ConsolidationRegionPropertyEntity(
	ImportKey,
	ConsolidationRegionPropertyEntityId,
	GlobalRegionId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	CRPE.ImportKey,
	CRPE.ConsolidationRegionPropertyEntityId,
	CRPE.GlobalRegionId,
	CRPE.SourceCode,
	CRPE.PropertyEntityCode,
	CRPE.InsertedDate,
	CRPE.UpdatedDate,
	CRPE.UpdatedByStaffId
FROM
	Gdm.ConsolidationRegionPropertyEntity CRPE
	INNER JOIN Gdm.ConsolidationRegionPropertyEntityActive(@DataPriorToDate) CRPEA ON
		CRPEA.ImportKey = CRPE.ImportKey

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

-- #ConsolidationSubRegion

INSERT INTO #ConsolidationSubRegion(
	ImportKey,
	ConsolidationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionCode,
	[Name],
	ProjectCodePortion,
	ConsolidationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	CSR.ImportKey,
	CSR.ConsolidationSubRegionGlobalRegionId,
	CSR.ConsolidationSubRegionGlobalRegionCode,
	CSR.[Name],
	CSR.ProjectCodePortion,
	CSR.ConsolidationRegionGlobalRegionId,
	CSR.DefaultCurrencyCode,
	CSR.CountryId,
	CSR.IsActive,
	CSR.InsertedDate,
	CSR.UpdatedDate,
	CSR.UpdatedByStaffId
FROM
	Gdm.ConsolidationSubRegion CSR
	INNER JOIN	Gdm.ConsolidationSubRegionActive(@DataPriorToDate) CSRA ON CSRA.ImportKey = CSR.ImportKey

-- #JobCodeFunctionalDepartment
INSERT INTO #JobCodeFunctionalDepartment(
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

-- Parent Level
INSERT INTO #ParentFunctionalDepartment(
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

-----------------------------------------------------------------------------------------------------------

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType(
	ImportKey,
	GLGlobalAccountTranslationTypeId,
	GLGlobalAccountId,
	GLTranslationTypeId,
	GLAccountTypeId,
	GLAccountSubTypeId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATT.ImportKey,
	GATT.GLGlobalAccountTranslationTypeId,
	GATT.GLGlobalAccountId,
	GATT.GLTranslationTypeId,
	GATT.GLAccountTypeId,
	CASE WHEN GA.ACtivityTypeId = 99 THEN 
											--GC :: CC1 >>
											--Unallocated overhead expenses will be grouped under the “Overhead” expense 
											--type and not “Non-Payroll”. This will be based on the activity of the 
											--transaction; all transactions that have a corporate overhead activity 
											--will have an expense type of “Overhead”.
											
											(
											Select GST.GLAccountSubTypeId 
											From Gdm.GLAccountSubType GST 
												INNER JOIN Gdm.GLTranslationType GTT ON GTT.GLTranslationTypeId = GST.GLTranslationTypeId
											Where GTT.Code = 'GL'
											AND GST.Code = 'GRPOHD'	
											) 
										ELSE GATT.GLAccountSubTypeId END,
	GATT.IsActive,
	GATT.InsertedDate,
	GATT.UpdatedDate,
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey
		
	LEFT OUTER JOIN 
					(Select GA.*
					From	Gdm.GLGlobalAccount GA
							INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GAA ON
								GAA.ImportKey = GA.ImportKey
					) GA ON GA.GLGlobalAccountId = GATT.GLGlobalAccountId

-- #GLGlobalAccountTranslationSubType

INSERT INTO #GLGlobalAccountTranslationSubType(
	ImportKey,
	GLGlobalAccountTranslationSubTypeId,
	GLGlobalAccountId,
	GLTranslationSubTypeId,
	GLMinorCategoryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATST.ImportKey,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId,
	GATST.IsActive,
	GATST.InsertedDate,
	GATST.UpdatedDate,
	GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.[Name],
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- drop table #ProfitabilityActual

PRINT 'Completed inserting active records into temp table'
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-- drop table #ProfitabilityActual

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
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
	ProfitabilityActualSourceTableId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL,
	
	EntryDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	OriginatingRegionCode char(6) NULL,
	PropertyFundCode char(12) NULL,
	FunctionalDepartmentCode char(15) NULL 
) 



INSERT INTO #ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
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
	ProfitabilityActualSourceTableId,
	EntryDate,
	[User],
	[Description],
	AdditionalDescription,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode 
)

SELECT 

	DATEDIFF(dd, '1900-01-01', LEFT(Gl.PERIOD, 4)+'-'+RIGHT(Gl.PERIOD, 2)+'-01') CalendarKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKeyUnknown ELSE GrSc.SourceKey END SourceKey,
	CASE WHEN ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.ActivityTypeKey END ActivityTypeKey,
	CASE WHEN OrR.OriginatingRegionKey IS NULL THEN @OriginatingRegionKeyUnknown ELSE OrR.OriginatingRegionKey END OriginatingRegionKey,
	CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END AllocationRegionKey,
	CASE -- CC16: Before 2011, Consolidation Region Key = Allocation Region Key
		WHEN Gl.Period < '201101' THEN
			CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END
		ELSE
			CASE WHEN 
				GrCr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown 
			ELSE 
				GrCr.AllocationRegionKey 
			END
		END ConsolidationRegionKey,
	CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.PropertyFundKey END PropertyFundKey,
	CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE GrOh.OverheadKey END OverheadKey,
	Gl.SourcePrimaryKey,
	Cu.CurrencyKey,
	Gl.LocalActual,
	Gl.SourceTableId,
	Gl.EnterDate,
	Gl.[User],
	Gl.[Description],
	Gl.AdditionalDescription,
	
	Gl.OriginatingRegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode

FROM
	#ProfitabilityGeneralLedger Gl
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Cu.CurrencyCode = Gl.LocalCurrency

	LEFT OUTER JOIN #JobCode Jc ON --The JobCodes is FunctionalDepartment in Corp
		Jc.JobCode = Gl.JobCode AND
		Jc.Source = Gl.SourceCode AND
		GrSc.IsCorporate = 'YES'
	
	LEFT OUTER JOIN #Department Dp ON --The Department (Region+FunctionalDept) is FunctionalDepartment in Prop
		Dp.Department = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		Dp.Source = Gl.SourceCode AND
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
									WHEN (GL.JobCode IN ('LGL','RSK', 'RIM')) THEN
										  14
									ELSE 
										  ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
							  END
						ELSE
							CASE
								  WHEN (GL.FunctionalDepartmentCode IN ('LGL','RSK','RIM')) THEN
										14
								  ELSE	
									ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
							END
					END								 
				ELSE
					  ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
			END
													

	LEFT OUTER JOIN #JobCodeFunctionalDepartment GrFdm1 ON --Detail/Sub Level : JobCode
		ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm1.StartDate AND GrFdm1.EndDate AND
		GrFdm1.ReferenceCode = CASE WHEN Gl.JobCode IS NOT NULL THEN Fd.GlobalCode + ':'+ LTRIM(RTRIM(Gl.JobCode))
									ELSE Fd.GlobalCode + ':UNKNOWN' END

	--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
	--that will be used, should the JobCode not match, but the FunctionalDepartment does match
	LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2 ON
		ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate AND
		GrFdm2.ReferenceCode = Fd.GlobalCode +':' 
		
	LEFT OUTER JOIN #GLGlobalAccountGLAccount GAGLA ON --#GlAccountMapping Gam
		GAGLA.Code = Gl.GlAccountCode AND
		GAGLA.SourceCode = Gl.SourceCode AND
		GAGLA.IsActive = 1
		
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.GLGlobalAccountId = GAGLA.GLGlobalAccountId AND --Gam.GlobalGlAccountId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrGa.StartDate AND GrGa.EndDate AND
		GrGa.SnapshotId = 0

	LEFT OUTER JOIN #GLGlobalAccount GA ON --#GlobalGlAccount Glo
		GA.GLGlobalAccountId = GAGLA.GLGlobalAccountId
		--ON Glo.GlobalGlAccountId = Gam.GlobalGlAccountId

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = GA.ActivityTypeId

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = 0

	--GC Change Control 1
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END
		
	LEFT OUTER JOIN #PropertyFundMapping Pfm ON
		Pfm.PropertyFundCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		Pfm.SourceCode = Gl.SourceCode AND
		Pfm.IsDeleted = 0 AND
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
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		RECD.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201007' AND			   
		RECD.IsDeleted = 0
		
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		REPE.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201007' AND
		REPE.IsDeleted = 0			   
	
	LEFT OUTER JOIN	#ConsolidationRegionCorporateDepartment CRCD ON -- CC16
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		CRCD.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201101'
	
	LEFT OUTER JOIN #ConsolidationRegionPropertyEntity CRPE ON -- CC16
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		CRPE.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201007'
	
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.SourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		ORPD.SourceCode = Gl.SourceCode AND
		ORPD.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion OrR ON
		OrR.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		--OrR.GlobalRegionId = ORPD.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN OrR.StartDate AND OrR.EndDate AND
		OrR.SnapshotId = 0
	
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
			
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = PF.PropertyFundId AND 
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrPf.StartDate AND GrPf.EndDate AND
		GrPf.SnapshotId = 0

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		--ON GrAr.GlobalRegionId = Arm.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate AND 
		GrAr.SnapshotId = 0
		
	LEFT OUTER JOIN #ConsolidationSubRegion CSR ON
		CSR.ConsolidationSubRegionGlobalRegionId =
			CASE
				WHEN GrSc.IsCorporate = 'YES' THEN CRCD.GlobalRegionId
				ELSE CRPE.GlobalRegionId
			END
			
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
		GrCr.GlobalRegionId = CSR.ConsolidationSubRegionGlobalRegionId AND
		--ON GrAr.GlobalRegionId = Arm.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrCr.StartDate AND GrCr.EndDate AND 
		GrCr.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE WHEN Gl.NetTSCost = 'Y' THEN 'NO' ELSE 'YES' END

			
--This is NOT needed for the temp table selects at the top already filter the inserts!
--/*Where ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate*/

PRINT 'Completed converting all transactional data to star schema keys'
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-----------------------------------------------------------------------------------------------------------
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey AND
		Gla.SnapshotId = 0

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		GATT.GLGlobalAccountId = Gla.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		GATST.GLGlobalAccountId = Gla.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		TST.GLTranslationTypeId = GATT.GLTranslationTypeId AND
		TST.GLTranslationSubTypeId = GATST.GLTranslationSubTypeId AND
		TST.Code = 'GL' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		MinC.GLMinorCategoryId = GATST.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId)) AND
		GLAC.SnapshotId = 0
	

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--Transfer the updated rows
UPDATE
	GrReporting.dbo.ProfitabilityActual
SET	
	CalendarKey						 = Pro.CalendarKey,
	GlAccountKey					 = Pro.GlAccountKey,
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
	ProfitabilityActualSourceTableId = Pro.ProfitabilityActualSourceTableId,
	
	EUCorporateGlAccountCategoryKey	 = @EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey	 = @EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey		 = @EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey	 = @USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey	 = @USCorporateGlAccountCategoryKeyUnknown, --Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey		 = @USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey		 = Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey	 = @DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey

	
	EntryDate						 = Pro.EntryDate,
	[User]							 = Pro.[User],
	[Description]					 = Pro.[Description],
	AdditionalDescription			 = Pro.AdditionalDescription,
	
	OriginatingRegionCode			 = Pro.OriginatingRegionCode,
	PropertyFundCode				 = Pro.PropertyFundCode,
	FunctionalDepartmentCode		 = Pro.FunctionalDepartmentCode
	
FROM
	#ProfitabilityActual Pro
WHERE
	ProfitabilityActual.SourceKey = Pro.SourceKey AND
	ProfitabilityActual.ReferenceCode = Pro.ReferenceCode

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
	
--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual (
	CalendarKey,
	GlAccountKey,
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
	ProfitabilityActualSourceTableId,
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EntryDate,
	[User],
	[Description],
	AdditionalDescription,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode
)
	
SELECT
	Pro.CalendarKey,
	Pro.GlAccountKey,
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
	Pro.ProfitabilityActualSourceTableId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----Pro.USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	Pro.GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	Pro.EntryDate,
	Pro.[User],
	Pro.[Description],
	Pro.AdditionalDescription,
	Pro.OriginatingRegionCode, 
	Pro.PropertyFundCode, 
	Pro.FunctionalDepartmentCode

FROM
	#ProfitabilityActual Pro
	
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists
		ON ProExists.SourceKey = Pro.SourceKey AND
		   ProExists.ReferenceCode = Pro.ReferenceCode
		   
WHERE
	ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--MRI should never delete rows from the GeneralLedger....
--hence we should never have to delete records
--PRINT 'Orphan Rows Delete in Profitability:'+CONVERT(char(10),@@rowcount)
--PRINT CONVERT(VARCHAR(27), getdate(), 121)

-- remove orphan rows from the warehouse that have been removed in the source data systems
EXEC stp_IU_ArchiveProfitabilityMRIActual @ImportStartDate=@ImportStartDate, @ImportEndDate=@ImportEndDate, @DataPriorToDate=@DataPriorToDate

DROP TABLE #ManageType
DROP TABLE #ManageCorporateDepartment
DROP TABLE #ManageCorporateEntity
DROP TABLE #ManagePropertyDepartment
DROP TABLE #ManagePropertyEntity

DROP TABLE #ProfitabilityGeneralLedger
DROP TABLE #FunctionalDepartment
DROP TABLE #Department
DROP TABLE #JobCode
DROP TABLE #ActivityType
DROP TABLE #GLGlobalAccount
DROP TABLE #GLGlobalAccountGLAccount
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #AllocationSubRegion
DROP TABLE #JobCodeFunctionalDepartment
DROP TABLE #ParentFunctionalDepartment
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #ProfitabilityActual

DROP TABLE #ConsolidationRegionCorporateDepartment
DROP TABLE #ConsolidationRegionPropertyEntity
DROP TABLE #ConsolidationSubRegion

GO

/*
2. dbo.stp_IU_LoadGrProfitabiltyGBSBudget
*/ 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	This stored procedure processes non-payroll and fee original budget information and uploads it to the
	ProfitabilityBudget table in the data warehouse (GrReporting.dbo.ProfitabilityBudget)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]

AS

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGBSBudget'
PRINT '####'
DECLARE @RowCount INT
DECLARE @StartTime DATETIME = GETDATE()
DECLARE @CanImportGBSBudget INT = (SELECT ConfiguredValue FROM [GrReportingStaging].[dbo].[SSISConfigurations] WHERE ConfigurationFilter = 'CanImportGBSBudget')

IF (@CanImportGBSBudget <> 1)
BEGIN
	PRINT ('Import of GBS Budget is not scheduled in GrReportingStaging.dbo.SSISConfigurations')
	RETURN
END

SET @StartTime = GETDATE()


-- ==============================================================================================================================================
-- Get Budgets to Process
-- ==============================================================================================================================================

SELECT 
	BTPC.*, 
	Reforecast.ReforecastKey
INTO 
	#BudgetsToProcess 
FROM 
	dbo.[BudgetsToProcessCurrent]('GBS Budget/Reforecast') BTPC
	
	INNER JOIN
	(
		SELECT
			MIN(ReforecastKey) AS ReforecastKey, -- ReforecastKey and ReforecastEffectivePeriod have the same ordering. ReforecastKey is computed
			ReforecastEffectiveYear				 -- the same as CalendarKey, and is therefore date-based
		FROM
			GrReporting.dbo.Reforecast
		WHERE
			ReforecastQuarterName = 'Q0' -- This is the original budget stored procedure; we can therefore hard-code 'Q0'
		GROUP BY
			ReforecastEffectiveYear
	) Reforecast ON
		BTPC.BudgetYear = Reforecast.ReforecastEffectiveYear
WHERE 
	IsReforecast = 0 -- This stored procedure handles original GBS budgets only (and not reforecasts)

------------------------

DECLARE @BTPRowCount INT = @@rowcount
PRINT ('Rows inserted into #BudgetsToProcess: ' + CONVERT(VARCHAR(10),@BTPRowCount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF (@BTPRowCount = 0)
BEGIN
	PRINT ('*******************************************************')
	PRINT ('	stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS BudgetsToProcess set to be imported.')
	PRINT ('*******************************************************')
	RETURN
END

-- ==============================================================================================================================================
-- Declare Local Variables
-- ==============================================================================================================================================

DECLARE @GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN')
DECLARE	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
DECLARE	@FunctionalDepartmentKeyUnknown	INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
DECLARE	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
DECLARE	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
DECLARE	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
DECLARE	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
DECLARE	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
DECLARE	@OverheadKeyUnknown				INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'UNKNOWN')
DECLARE	@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNKNOWN')
DECLARE	@FeeAdjustmentKeyUnknown		INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'UNKNOWN')--,
--	@CanImportCorporateBudget	INT = (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportCorporateBudget')

DECLARE @EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE @EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@USCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@DevelopmentGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

DECLARE @BudgetReforecastTypeKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = 'GBSBUD')

-- There could be up to three copies of the same GBS data due to three seperate imports, so work with latest GBS import which should have the
-- highest ImportBatchId.

--DECLARE @ImportBatchId INT = (SELECT MAX(BatchId) FROM dbo.Batch WHERE PackageName = 'ETL.Staging.GBS')
DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);

-- ==============================================================================================================================================
-- Source Budget data from GBS
-- ==============================================================================================================================================

CREATE TABLE #BudgetsWithUnknownBudgets(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL
)

--SELECT * FROM #BudgetsToProcess
	
SET @StartTime = GETDATE()

CREATE TABLE #Budget(
	ReforecastKey INT NOT NULL,
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetAllocationSetId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	CreatorStaffId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	HealthyTensionStartDate DATETIME NOT NULL,
	HealthyTensionEndDate DATETIME NOT NULL,
	LastLockedDate DATETIME NULL,
	PriorBudgetId INT NULL,
	IsReforecast BIT NOT NULL,
	CopiedFromBudgetId INT NULL,
	ImportBudgetIntoGR BIT NOT NULL,
	LastImportBudgetIntoGRDate DATETIME NULL,
	SnapshotId INT NOT NULL
)
INSERT INTO #Budget
SELECT
	BTP.ReforecastKey,
	Budget.ImportKey,
	Budget.ImportBatchId,
	Budget.BudgetId,
	Budget.BudgetAllocationSetId,
	Budget.BudgetReportGroupPeriodId,
	Budget.BudgetExchangeRateId,
	Budget.BudgetStatusId,
	Budget.CreatorStaffId,
	Budget.Name,
	Budget.HealthyTensionStartDate,
	Budget.HealthyTensionEndDate,
	Budget.LastLockedDate,
	Budget.PriorBudgetId,
	Budget.IsReforecast,
	Budget.CopiedFromBudgetId,
	Budget.ImportBudgetIntoGR,
	Budget.LastImportBudgetIntoGRDate,
	BTP.SnapshotId
FROM
	GBS.Budget Budget
	
	INNER JOIN #BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
		Budget.BudgetId = BTP.BudgetId AND
		Budget.ImportBatchId = BTP.ImportBatchId
		
WHERE
	Budget.IsActive = 1
	
DECLARE @BudgetRowCount INT = @@rowcount

CREATE UNIQUE CLUSTERED INDEX IX_Budget ON #Budget (SnapshotId, BudgetId)

PRINT ('Rows inserted into #Budget: ' + CONVERT(VARCHAR(10),@BudgetRowCount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



IF (@BudgetRowCount = 0)
BEGIN
	PRINT ('*******************************************************')
	PRINT ('	stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.')
	PRINT ('*******************************************************')
	RETURN
END

-- ==============================================================================================================================================
-- Source Snapshot mapping data from GDM
-- ==============================================================================================================================================

-- GLGlobalAccount --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccount(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NOT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name NVARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	ExpenseCzarStaffId INT NOT NULL,
	ParentCode AS (left(Code,(8))),
	SnapshotId INT NOT NULL
)
INSERT INTO #GLGlobalAccount (
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	Name,
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	ExpenseCzarStaffId,
	SnapshotId
)
SELECT
	GLGA.GLGlobalAccountId,
	GLGA.ActivityTypeId,
	GLGA.GLStatutoryTypeId,
	GLGA.ParentGLGlobalAccountId,
	GLGA.Code,
	GLGA.Name,
	GLGA.[Description],
	GLGA.IsGR,
	GLGA.IsGbs,
	GLGA.IsRegionalOverheadCost,
	GLGA.ExpenseCzarStaffId,
	GLGA.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccount GLGA
	INNER JOIN #Budget B ON
		GLGA.SnapshotId = B.SnapshotId
WHERE
	GLGA.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccount: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLTranslationSubType -----------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLTranslationSubType (
	SnapshotId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL
)
INSERT INTO #GLTranslationSubType
SELECT
	TST.SnapshotId,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code
FROM
	Gdm.SnapshotGLTranslationSubType TST
	INNER JOIN #Budget B ON
		TST.SnapshotId = B.SnapshotId
WHERE
	TST.Code = 'GL' AND -- This limits to the Global translation sub type; for multiple sub types remove this constraint and add TST.Code to SELECT
	TST.IsActive = 1

PRINT ('Rows inserted into ##GLTranslationSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLGlobalAccountTranslationType --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccountTranslationType(
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #GLGlobalAccountTranslationType
SELECT
	GATT.GLGlobalAccountTranslationTypeId, 
	GATT.GLGlobalAccountId, 
	GATT.GLTranslationTypeId, 
	GATT.GLAccountTypeId,	
	CASE WHEN
			GA.ActivityTypeId = 99
		 THEN 
				-- GC :: CC1 >>
				-- Unallocated overhead expenses will be grouped under the “Overhead” expense 
				-- type and not “Non-Payroll”. This will be based on the activity of the 
				-- transaction; all transactions that have a corporate overhead activity 
				-- will have an expense type of “Overhead”.
			
			AST.GLAccountSubTypeId
			
					
		 ELSE
			GATT.GLAccountSubTypeId
	END AS GLAccountSubTypeId,
	GATT.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationType GATT
	
	INNER JOIN #Budget B ON
		GATT.SnapshotId = B.SnapshotId	

	LEFT OUTER JOIN (
						SELECT
							GA.*
						FROM
							#GLGlobalAccount GA
							
					 ) GA ON
							GA.GLGlobalAccountId = GATT.GLGlobalAccountId AND
							GA.SnapshotId = GATT.SnapshotId
	
	LEFT OUTER JOIN (
						SELECT
							GST.GLAccountSubTypeId,
							B.BudgetId,
							gst.SnapshotId
							--GST.GLAccountSubTypeId 
						FROM
							Gdm.SnapshotGLAccountSubType GST 
							INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
								GTT.GLTranslationTypeId = GST.GLTranslationTypeId
							INNER JOIN #Budget B ON
								GST.SnapshotId = B.SnapshotId AND
								GTT.SnapshotId = B.SnapshotId
						WHERE
							GTT.Code = 'GL' AND
							GST.Code = 'GRPOHD'	AND
							GST.IsActive = 1 AND
							GTT.IsActive = 1
					) AST ON
							GATT.SnapshotId = AST.SnapshotId AND
							B.BudgetId = AST.BudgetId
	
WHERE
	GATT.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccountTranslationType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- SnapshotGLGlobalAccountTranslationSubType -------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccountTranslationSubType (
	SnapshotId INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL
)
INSERT INTO #GLGlobalAccountTranslationSubType
SELECT
	GATST.SnapshotId,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationSubType GATST
	INNER JOIN #Budget B ON
		GATST.SnapshotId = B.SnapshotId
WHERE
	GATST.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccountTranslationSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLMinorCategory -----------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLMinorCategory (
	SnapshotId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL
)
INSERT INTO #GLMinorCategory
SELECT
	MinC.SnapshotId,
	MinC.GLMinorCategoryId,
	MinC.GLMajorCategoryId
FROM
	Gdm.SnapshotGLMinorCategory MinC
	INNER JOIN #Budget B ON
		MinC.SnapshotId = B.SnapshotId
WHERE
	MinC.IsActive = 1

PRINT ('Rows inserted into #GLMinorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLMajorCategory ---------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLMajorCategory (
	SnapshotId int NOT NULL,
	GLMajorCategoryId int NOT NULL,
	GLTranslationSubTypeId int NOT NULL
)
INSERT INTO #GLMajorCategory
SELECT
	MajC.SnapshotId,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId
FROM
	Gdm.SnapshotGLMajorCategory MajC
	INNER JOIN #Budget B ON
		MajC.SnapshotId = B.SnapshotId
WHERE
	MajC.IsActive = 1

PRINT ('Rows inserted into #GLMajorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ReportingEntityCorporateDepartment --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ReportingEntityCorporateDepartment(
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO	#ReportingEntityCorporateDepartment
SELECT
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.SnapshotId
FROM
	Gdm.SnapshotReportingEntityCorporateDepartment RECD
	INNER JOIN #Budget B ON
		RECD.SnapshotId = B.SnapshotId
WHERE
	RECD.IsDeleted = 0

PRINT ('Rows inserted into #ReportingEntityCorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ConsolidationRegionCorporateDepartment (CC16) -----------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ConsolidationRegionCorporateDepartment
(
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	GlobalRegionId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #ConsolidationRegionCorporateDepartment
SELECT
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.CorporateDepartmentCode,
	CRCD.SourceCode,
	CRCD.GlobalRegionId,
	CRCD.SnapshotId
FROM 
	Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
	INNER JOIN #Budget B ON
		CRCD.SnapshotId = B.SnapshotId

PRINT ('Rows inserted into #ConsolidationRegionCorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- PropertyFund --------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #PropertyFund(
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #PropertyFund
SELECT
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.Name,
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.SnapshotId
FROM
	Gdm.SnapshotPropertyFund PF
	INNER JOIN #Budget B ON
		B.SnapshotId = PF.SnapshotId
WHERE
	PF.IsActive = 1

PRINT ('Rows inserted into #PropertyFund: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ActivityType --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ActivityType(
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #ActivityType
SELECT
	ActivityTypeId,
	Code,
	AT.SnapshotId
FROM
	Gdm.SnapshotActivityType AT
	INNER JOIN #Budget B ON
		AT.SnapshotId = B.SnapshotId
WHERE
	AT.IsActive = 1

PRINT ('Rows inserted into #ActivityType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Department -----------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #CorporateDepartment(
	Code CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL,
	IsTsCost BIT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO	#CorporateDepartment
SELECT
	D.Code,
	D.SourceCode,
	D.FunctionalDepartmentId,
	D.IsTsCost,
	D.SnapshotId
FROM
	Gdm.SnapshotCorporateDepartment D
	INNER JOIN #Budget B ON
		D.SnapshotId = B.SnapshotId
WHERE
	D.IsActive = 1

PRINT ('Rows inserted into #CorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- FunctionalDepartment -------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #FunctionalDepartment (
	FunctionalDepartmentId INT NOT NULL,
	Code VARCHAR(20) NULL,
	GlobalCode VARCHAR(30) NULL
)

INSERT INTO #FunctionalDepartment
SELECT
	FunctionalDepartmentId,
	Code,
	GlobalCode
FROM
	Gdm.SnapshotFunctionalDepartment FD
	INNER JOIN #Budget B ON
		FD.SnapshotId = B.SnapshotId
WHERE
	FD.IsActive = 1

PRINT ('Rows inserted into #FunctionalDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- AllocationSubRegion -----------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #AllocationSubRegion (
	SnapshotId int NOT NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	Code varchar(10) NOT NULL,
	Name varchar(50) NOT NULL,
	AllocationRegionGlobalRegionId int NULL,
	DefaultCorporateSourceCode char(2) NOT NULL
)
INSERT INTO #AllocationSubRegion
SELECT
	ASR.SnapshotId,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.Name,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCorporateSourceCode
FROM
	Gdm.SnapshotAllocationSubRegion ASR
	INNER JOIN #Budget B ON
		ASR.SnapshotId = B.SnapshotId
WHERE
	ASR.IsActive = 1

PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Master GL Account Category mapping table -----------------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLAccountCategoryMapping (
	SnapshotId INT NOT NULL,
	GLAccountKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)
INSERT INTO #GLAccountCategoryMapping
SELECT
	Budget.SnapshotId,
	Gla.GlAccountKey,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	MinC.GLMajorCategoryId,
	GLATST.GLMinorCategoryId,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId
FROM
	#Budget Budget

	INNER JOIN #GLTranslationSubType TST ON
		Budget.SnapshotId = TST.SnapshotId

	INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
		TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
		Budget.SnapshotId = GLATST.SnapshotId
	
	INNER JOIN #GLGlobalAccountTranslationType GLATT ON
		GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
		TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
		Budget.SnapshotId = GLATT.SnapshotId

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId AND
		Budget.SnapshotId = Gla.SnapshotId		

	INNER JOIN #GLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		Budget.SnapshotId = MinC.SnapshotId

	INNER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		Budget.SnapshotId = MajC.SnapshotId

PRINT ('Rows inserted into #GLAccountCategoryMapping: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Corporate Property Sources --------------------------------------------------------------------------------

CREATE TABLE #CorporatePropertySourceCodes (
	CorporateSourceCode CHAR(2) NOT NULL,
	PropertySourceCode CHAR(2) NOT NULL
)

INSERT INTO #CorporatePropertySourceCodes
SELECT
	'UC', 'US'
UNION ALL
SELECT
	'EC', 'EU'
UNION ALL
SELECT
	'IC', 'IN'
UNION ALL
SELECT
	'BC', 'BR'
UNION ALL
SELECT
	'CC', 'CN'

-- ==============================================================================================================================================
-- Get Non-Payroll Expense Budget items from GBS
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilitySource (
	ImportBatchId INT NOT NULL,
	ReforecastKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	BudgetAmount MONEY NOT NULL,
	GLGlobalAccountId INT NULL,
	FunctionalDepartmentCode VARCHAR(20) NULL,
	JobCode VARCHAR(20) NULL,
	Reimbursable VARCHAR(3) NULL, -- NULL because this field is determined via an outer join
	ActivityTypeId INT NULL, -- NULL because for Fees this field is determined via an outer join
	PropertyFundId INT NULL, -- NULL because this field is determined via an outer join
	AllocationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
	ConsolidationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
	OriginatingGlobalRegionId INT NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	LockedDate DATETIME NULL,
	IsExpense BIT NOT NULL,
	UnallocatedOverhead CHAR(7) NULL, -- NULL because this field is determined via an outer join
	FeeAdjustment VARCHAR(9) NOT NULL
)

-- Insert original budget amounts
INSERT INTO #ProfitabilitySource (
	ImportBatchId,
	ReforecastKey,
	SnapshotId,
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	JobCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment
)

SELECT
	Budget.ImportBatchId,
	Budget.ReforecastKey,
	Budget.SnapshotId,
	Budget.BudgetId, -- BudgetId
	'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) + '&NonPayrollExpenseBreakdownId=' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
	NPEB.Period, -- ExpensePeriod: Period is actually a foreign key to PeriodExtended but is also the implied period value, e.g.: 201009
	CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
	NPEB.Amount, -- BudgetAmount
	ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
	FD.GlobalCode, -- FunctionalDepartmentCode
	NPEB.JobCode, -- JobCode
	CASE WHEN CD.IsTsCost = 0 THEN 'YES' ELSE 'NO' END, -- Reimbursable
	NPEB.ActivityTypeId, -- ActivityTypeId: this Id should correspond to the correct Id in GDM
	RECD.PropertyFundId, -- PropertyFundId
	PF.AllocationSubRegionGlobalRegionId, -- AllocationSubRegionGlobalRegionId
	CRCD.GlobalRegionId, -- Consolidation Sub-Region GlobalRegionId (CC16)
	NPEB.OriginatingSubRegionGlobalRegionId, -- OriginatingGlobalRegionId
	NPEB.CurrencyCode, -- LocalCurrencyCode
	Budget.LastLockedDate, -- LockedDate
	1, -- IsExpense
	CASE WHEN AT.Code = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END, -- UnallocatedOverhead
	'NORMAL' -- FeeAdjustment
FROM
	#Budget Budget
	
	INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
		Budget.BudgetId = NPEB.BudgetId AND
		Budget.ImportBatchId = NPEB.ImportBatchId
	
	INNER JOIN #CorporatePropertySourceCodes CPSC ON
		NPEB.CorporateSourceCode = CPSC.CorporateSourceCode
	
	LEFT OUTER JOIN ( -- these NonPayrollExpenses need to be excluded because they are in dispute
	
		/* Disputes are created at the level of a budget project. A budget project will dispute the portion of a non-payroll expense that is
		   allocated to them (via the NonPayrollExpenseBreakdown table, which includes the NonPayrollExpenseId and BudgetProjectId fields,
		   allowing for the portion of the non-payroll expense that has been allocated to the budget project to be determined).
		   
		   If, for example, a non-payroll expense is split between two budget projects, and one of these budget projects is disputing their
		   allocation, the portion of the non-payroll expense that is allocated to the budget project that is not disputing must still be
		   included. Only thet portion of the non-payroll expense that is currently being disputed must be excluded.	   
		*/
	
		SELECT DISTINCT
			NPED.ImportBatchId,
			NPED.NonPayrollExpenseId,
			NPED.BudgetProjectId
		FROM
			GBS.NonPayrollExpenseDispute NPED
			INNER JOIN GBS.DisputeStatus DS ON
				NPED.DisputeStatusId = DS.DisputeStatusId AND
				NPED.ImportBatchId = DS.ImportBatchId
		WHERE
			DS.Name <> 'Resolved' AND
			DS.IsActive = 1
			
	) DisputedNonPayrollExpenseItems ON
		NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
		NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
		NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

	-- PropertyFundId
	LEFT OUTER JOIN #ReportingEntityCorporateDepartment RECD ON				-- Only corporate budgets should be handled by GBS, so when we map
		 NPEB.CorporateDepartmentCode = RECD.CorporateDepartmentCode AND	-- to find a Reporting Entity we assume that the source is corporate
		 NPEB.CorporateSourceCode = RECD.SourceCode AND
		 Budget.SnapshotId = RECD.SnapshotId
		 
	-- Consolidation Sub Region GlobalRegionId (CC16)
	LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
		NPEB.CorporateDepartmentCode = CRCD.CorporateDepartmentCode AND
		NPEB.CorporateSourceCode = CRCD.SourceCode AND
		Budget.SnapshotId = CRCD.SnapshotId
	
	-- AllocationRegionId
	LEFT OUTER JOIN #PropertyFund PF ON
		RECD.PropertyFundId = PF.PropertyFundId AND
		RECD.SnapshotId = PF.SnapshotId
	
	-- Overhead Type
	LEFT OUTER JOIN #ActivityType AT ON
		NPEB.ActivityTypeId = AT.ActivityTypeId AND
		Budget.SnapshotId = AT.SnapshotId -- 
	
	-- Reimbursable
	LEFT OUTER JOIN #CorporateDepartment CD ON
		NPEB.CorporateSourceCode = CD.SourceCode AND
		NPEB.CorporateDepartmentCode = CD.Code AND
		Budget.SnapshotId = CD.SnapshotId --

	-- FunctionalDepartmentCode
	LEFT OUTER JOIN #FunctionalDepartment FD ON
		NPEB.FunctionalDepartmentId = FD.FunctionalDepartmentId
WHERE
	NPEB.IsActive = 1 AND
	DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL -- Exclude all disputed items

PRINT ('Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--select * from #ProfitabilitySource

-- ==============================================================================================================================================
-- Get Fee Budget items from GBS
-- ==============================================================================================================================================


SET @StartTime = GETDATE()

INSERT INTO #ProfitabilitySource (
	ImportBatchId,
	ReforecastKey,
	SnapshotId,
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	JobCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment
)
SELECT
	Budget.ImportBatchId,
	Budget.ReforecastKey,
	Budget.SnapshotId,
	Budget.BudgetId, -- BudgetId
	'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) + '&FeeId=' + LTRIM(RTRIM(STR(Fee.FeeId))) + '&FeeDetailId=' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
	FeeDetail.Period,
	ASR.DefaultCorporateSourceCode, -- SourceCode
	FeeDetail.Amount,
	GA.GLGlobalAccountId, -- GLGlobalAccountId
	NULL, -- FunctionalDepartmentId
	NULL, -- JobCode
	'NO', -- Reimbursable
	GA.ActivityTypeId, -- ActivityType: determined by finding Fee.GLGlobalAccountId on GrReportingStaging.dbo.GLGlobalAccount
	Fee.PropertyFundId, -- PropertyFundId
	Fee.AllocationSubRegionGlobalRegionId, -- AllocationSubRegionGlobalRegionId
	Fee.AllocationSubRegionGlobalRegionId, -- Assumption is that there will be no EU Funds for Fee Data so Allocation and Consolidation region would be the same
	Fee.AllocationSubRegionGlobalRegionId, -- OriginatingGlobalRegionId: allocation region = originating region for fee income
	Fee.CurrencyCode,
	Budget.LastLockedDate, -- LockedDate
	0,  -- IsExpense
	'UNKNOWN', -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
	CASE WHEN FeeDetail.IsAdjustment = 1 THEN 'FEEADJUST' ELSE 'NORMAL' END -- IsFeeAdjustment, field isn't NULLABLE
FROM
	#Budget Budget

	INNER JOIN GBS.Fee Fee ON
		Budget.BudgetId = Fee.BudgetId AND
		Budget.ImportBatchId = Fee.ImportBatchId

	INNER JOIN GBS.FeeDetail FeeDetail ON
		Fee.FeeId = FeeDetail.FeeId AND
		Fee.ImportBatchId = FeeDetail.ImportBatchId

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		Fee.GLGlobalAccountId = GA.GLGlobalAccountId AND
		Budget.SnapshotId = GA.SnapshotId

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		Fee.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId

WHERE
	Fee.IsDeleted = 0 AND
	FeeDetail.Amount <> 0

PRINT ('Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--select distinct COUNT(*) from #ProfitabilitySource
RAISERROR( 'Completed inserting budget portions into #ProfitabilitySource',0,1) WITH NOWAIT

------------------------------------------------------------------------------------------------------------------
RAISERROR( 'Starting to update #ProfitabilitySource GLGlobalAccountId',0,1) WITH NOWAIT

SET @StartTime = GETDATE()

UPDATE
	PS
SET
	PS.GLGlobalAccountId = GLGA2.GLGlobalAccountId
FROM
	#ProfitabilitySource PS

	INNER JOIN #GLGlobalAccount GLGA1 ON
		PS.GLGlobalAccountId = GLGA1.GLGlobalAccountId

	INNER JOIN #GLGlobalAccount GLGA2 ON
		(LEFT(GLGA1.Code, 10 - LEN(PS.ActivityTypeId)) + LTRIM(RTRIM(STR(PS.ActivityTypeId)))) = GLGA2.Code
WHERE
	LEN(GLGA1.Code) = 10 AND -- A code of 10 characters excludes the account prefix (CP, TS) and includes the activity type code, i.e.: 5020100012
	RIGHT(GLGA1.Code, 2) = '00' -- where the header account has been budgeted against

PRINT ('Rows updated in #ProfitabilitySource (GLAccount update from head to activity-specific GL Account: ' + LTRIM(RTRIM(STR(@@rowcount))))

------------------------------------------------------------------------------------------------------------------

-- Perhaps create index for #ProfitabilitySource here

-- ==============================================================================================================================================
-- Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
-- ==============================================================================================================================================

RAISERROR( 'Starting to insert into #ProfitabilityBudget',0,1) WITH NOWAIT

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityBudget(
	ImportBatchId INT NOT NULL,
	ReforecastKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	ConsolidationRegionKey INT NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	FeeAdjustmentKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	IsExpense BIT NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
)

INSERT INTO #ProfitabilityBudget 
(
	ImportBatchId,
	ReforecastKey,
	SnapshotId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	IsExpense
)

SELECT
	PS.ImportBatchId,
	PS.ReforecastKey,
	PS.SnapshotId,
	DATEDIFF(DD, '1900-01-01', LEFT(PS.ExpensePeriod, 4)+'-' + RIGHT(PS.ExpensePeriod, 2) + '-01'), -- CalendarKey,
	CASE WHEN GA.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GA.GlAccountKey END, -- GlAccountKey,
	CASE WHEN S.SourceKey IS NULL THEN @SourceKeyUnknown ELSE S.SourceKey END, -- SourceKey,
	CASE WHEN
		ISNULL(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey) IS NULL
		THEN
			@FunctionalDepartmentKeyUnknown
		ELSE
			ISNULL(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey) END,	-- FunctionalDepartmentKey,
	CASE WHEN R.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE R.ReimbursableKey END, -- ReimbursableKey,
	CASE WHEN AT.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE AT.ActivityTypeKey END, -- ActivityTypeKey,
	CASE WHEN PF.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE PF.PropertyFundKey END, -- PropertyFundKey,
	CASE WHEN AR.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE AR.AllocationRegionKey END, -- AllocationRegionKey,
	CASE WHEN CR.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE CR.AllocationRegionKey END, -- ConsolidationRegionKey
	CASE WHEN
		PS.IsExpense = 1
		THEN
			CASE WHEN
				ORR.OriginatingRegionKey IS NULL
			THEN
				@OriginatingRegionKeyUnknown
			ELSE
				ORR.OriginatingRegionKey
			END
		ELSE
			CASE WHEN
				ORRFee.OriginatingRegionKey IS NULL
			THEN
				@OriginatingRegionKeyUnknown
			ELSE
				ORRFee.OriginatingRegionKey
			END
	END, -- OriginatingRegionKey,
	CASE WHEN O.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE O.OverheadKey END, -- OverheadKey,
	CASE WHEN FA.FeeAdjustmentKey IS NULL THEN @FeeAdjustmentKeyUnknown ELSE FA.FeeAdjustmentKey END, -- FeeAdjustmentKey,
	CASE WHEN C.CurrencyKey IS NULL THEN @LocalCurrencyKeyUnknown ELSE C.CurrencyKey END, -- LocalCurrencyKey,
	PS.BudgetAmount, -- LocalBudget,
	PS.ReferenceCode, -- ReferenceCode,
	PS.BudgetId, -- BudgetId,
	PS.IsExpense
FROM
	#ProfitabilitySource PS

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GA ON
		PS.GLGlobalAccountId = GA.GLGlobalAccountId AND
		PS.SnapshotId = GA.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] S ON -- dbo.Source is not snapshotted; this is why there's no join on a SnapshotId field
		PS.SourceCode = S.SourceCode	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable R ON -- dbo.Reimbursable is not snapshotted; this is why there's no join on a SnapshotId field
		PS.Reimbursable = R.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
		PS.ActivityTypeId = AT.ActivityTypeId AND
		PS.SnapshotId = AT.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
		PS.PropertyFundId = PF.PropertyFundId AND
		PS.SnapshotId = PF.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
		PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId AND 
		PS.SnapshotId = AR.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion CR ON -- Consolidation Regions are the same as allocation regions, therefore join to the same table (CC16)
		PS.ConsolidationSubRegionGlobalRegionId = CR.GlobalRegionId AND
		PS.SnapshotId = CR.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
		PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId AND
		PS.SnapshotId = ORRFee.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
		PS.OriginatingGlobalRegionId = ORR.GlobalRegionId AND
		PS.SnapshotId = ORR.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.Currency C ON -- dbo.Currency is not snapshotted; this is why there's no join on a SnapshotId field
		PS.LocalCurrencyCode = C.CurrencyCode
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead O ON -- dbo.Overhead is not snapshotted; this is why there's no join on a SnapshotId field
		PS.UnallocatedOverhead = O.OverheadCode
	
	LEFT OUTER JOIN GrReporting.dbo.FeeAdjustment FA ON -- dbo.FeeAdjustment is not snapshotted; this is why there's no join on a SnapshotId field
		PS.FeeAdjustment = FA.FeeAdjustmentCode

	-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							FunctionalDepartmentCode <> SubFunctionalDepartmentCode
	) FDJobCode ON
		PS.JobCode = FDJobCode.SubFunctionalDepartmentCode AND -- dbo.FunctionalDepartment is not snapshotted but should be! When we do make this
															   -- change we should be also joining on SnapshotId
		PS.FunctionalDepartmentCode = FDJobCode.FunctionalDepartmentCode 

	-- Parent Level
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							SubFunctionalDepartmentCode = FunctionalDepartmentCode
	) FD ON
		PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode
WHERE
	PS.BudgetAmount <> 0

PRINT ('Rows inserted into #ProfitabilityBudget: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

PRINT ('Creating Unique INDEX  IX_ProfitabilityBudget on #ProfitabilityBudget on ReferenceCode')
SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityBudget ON #ProfitabilityBudget (ReferenceCode)

PRINT ('Created Unique INDEX  IX_ProfitabilityBudget on #ProfitabilityBudget ')
PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- ==============================================================================================================================================
-- Update #ProfitabilityBudget.GlobalGlAccountCategoryKey
-- ==============================================================================================================================================

--select * from #ProfitabilitySource
RAISERROR( 'Updating #ProfitabilityBudget GlobalGlAccountCategoryKey',0,1) WITH NOWAIT


SET @StartTime = GETDATE()

UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
		Gl.GlAccountKey = GLACM.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		--Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLACM.SnapshotId = GLAC.SnapshotId AND
		GLAC.GlobalGlAccountCategoryCode =  CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLACM.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLACM.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountSubTypeId))

PRINT ('Rows updated from #ProfitabilityBudget: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ==============================================================================================================================================
-- Delete budgets to insert that have UNKNOWNS in their mapping
-- ==============================================================================================================================================

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns
DELETE
FROM
	dbo.ProfitabilityBudgetUnknowns
WHERE
	BudgetReforecastTypeKey = @BudgetReforecastTypeKey -- Only delete GBS records, leave TAPAS records

INSERT INTO dbo.ProfitabilityBudgetUnknowns (
	ImportBatchId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey, -- (CC 16)
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	EUCorporateGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	BudgetId,
	BudgetReforecastTypeKey,
	OverheadKey,
	FeeAdjustmentKey,
	SnapshotId
)
SELECT
	ImportBatchId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey, -- (CC16)
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	EUCorporateGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	BudgetId,
	@BudgetReforecastTypeKey,
	OverheadKey,
	FeeAdjustmentKey,
	SnapshotId
FROM
	#ProfitabilityBudget

WHERE
	GlAccountKey = @GlAccountKeyUnknown OR
	SourceKey = @SourceKeyUnknown OR
	(FunctionalDepartmentKey = @FunctionalDepartmentKeyUnknown AND IsExpense = 1) OR	
	ReimbursableKey = @ReimbursableKeyUnknown OR
	ActivityTypeKey = @ActivityTypeKeyUnknown OR
	PropertyFundKey = @PropertyFundKeyUnknown OR
	AllocationRegionKey = @AllocationRegionKeyUnknown OR 
	OriginatingRegionKey = @OriginatingRegionKeyUnknown OR
	FeeAdjustmentKey = @FeeAdjustmentKeyUnknown OR
	LocalCurrencyKey = @LocalCurrencyKeyUnknown OR
	GlobalGlAccountCategoryKey = @GlobalGlAccountCategoryKeyUnknown 
	
	-- LocalBudget
	-- OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
	-- CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
	-- ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
	-- BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a 'not null' dbase constraint in source system)
	-- SourceSystemId

DECLARE @RowsInserted INT = @@rowcount

IF (@RowsInserted > 0)
BEGIN
	PRINT ('Oh no - there are ' + CONVERT(VARCHAR(10), @RowsInserted) + ' unknowns in #ProfitabilityBudget. They have been inserted into dbo.ProfitabilityBudgetUnknowns.')
	PRINT ('Deleting records associated with budgets that have unknowns...')
	
	INSERT INTO #BudgetsWithUnknownBudgets
	SELECT DISTINCT
		Budget.ImportKey,
		Budget.BudgetId,
		Budget.ImportBatchId
	FROM
		#Budget Budget
		INNER JOIN (
			SELECT DISTINCT
				PBU.BudgetId
			FROM
				dbo.ProfitabilityBudgetUnknowns PBU
		) UnknownBudgets ON
			UnknownBudgets.BudgetId = Budget.BudgetId
	
	-- delete budgets with unknowns from #ProfitabilityBudget	
	DELETE
		PB
	FROM
		#ProfitabilityBudget PB
		INNER JOIN dbo.ProfitabilityBudgetUnknowns PBU ON
			PB.BudgetId = PBU.BudgetId
	
	PRINT ('Deleting #ProfitabilityBudget records associated with budgets that have unknowns: ' + LTRIM(RTRIM(STR(@@rowcount))) + ' (completed) ')
	
	-- delete these budgets and their associated data from GrReportingStaging
	DECLARE @BudgetsWithUnknowns AS GBSBudgetImportBatchType
	
	INSERT INTO @BudgetsWithUnknowns
	SELECT
		*
	FROM
		#BudgetsWithUnknownBudgets
	
	EXEC dbo.stp_D_GBSBudget @BudgetsWithUnknowns

	PRINT ('Deleting GrReportingStaging GBS records associated with budgets that have unknowns: ' + LTRIM(RTRIM(STR(@@rowcount))) + ' (completed)')
END

-- ==============================================================================================================================================
-- Delete existing budgets that we are about to insert
-- ==============================================================================================================================================

CREATE TABLE #BudgetsToImportOriginal( -- an original copy of the budgets that are to be imported is kept here - the budgets in the table below will be deleted during insertion into the warehouse
	BudgetId INT NOT NULL
)

CREATE TABLE #BudgetsToImport(
	BudgetId INT NOT NULL
)

INSERT INTO #BudgetsToImportOriginal
SELECT DISTINCT
	BudgetId
FROM
	#ProfitabilityBudget

INSERT INTO #BudgetsToImport
SELECT DISTINCT
	BudgetId
FROM
	#BudgetsToImportOriginal


DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #BudgetsToImport) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #BudgetsToImport)

	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		
				DELETE TOP (100000)
				FROM
					GrReporting.dbo.ProfitabilityBudget 
				WHERE
					BudgetId = @BudgetId AND
					BudgetReforecastTypeKey = @BudgetReforecastTypeKey

			SET @row = @@rowcount
			SET @deleteCnt = @deleteCnt + @row
			
			PRINT '>>>:'+CONVERT(VARCHAR(10),@row)
			PRINT CONVERT(VARCHAR(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityBudget:'+CONVERT(VARCHAR(10),@deleteCnt)
	PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
	DELETE FROM #BudgetsToImport WHERE BudgetId = @BudgetId
	
	PRINT 'Rows Deleted from #DeletingBudget:'+CONVERT(VARCHAR(10),@@ROWCOUNT)
	PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
END

-- ==============================================================================================================================================
-- Insert budget records into GrReporting.dbo.ProfitabilityBudget
-- ==============================================================================================================================================

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	SnapshotId,
	ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey, -- (CC16)
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	BudgetReforecastTypeKey,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	SnapshotId,
	ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey, -- (CC16)
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	@BudgetReforecastTypeKey,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget
	
	
PRINT ('Rows inserted into GrReporting.dbo.ProfitabilityBudget: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	

-- ==============================================================================================================================================
-- Mark budgets as being successfully processed into the warehouse
-- ==============================================================================================================================================
DECLARE @ImportErrorText VARCHAR(500)
SELECT @ImportErrorText = COALESCE(@ImportErrorText + ', ', '') + Error from @ImportErrorTable

BEGIN TRY		

	SELECT
		BTP.BudgetsToProcessId,
		CASE WHEN BWUB.BudgetId IS NULL THEN 1 ELSE 0 END AS OriginalBudgetProcessedIntoWarehouse, -- 0 if import fails, 1 if import succeeds
		@ImportErrorText AS ReasonForFailure,
		GETDATE() AS DateBudgetProcessedIntoWarehouse-- date that the buget import either failed or succeeded (depending on 0 or 1 above)
	INTO 
		#BudgetsToProcessToUpdate
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcess BTPT ON
			BTP.BudgetsToProcessId = BTPT.BudgetsToProcessId	
		
		LEFT OUTER JOIN #BudgetsWithUnknownBudgets BWUB ON
			BTP.BudgetId = BWUB.BudgetId 

	UPDATE
		BTP
	SET
		BTP.OriginalBudgetProcessedIntoWarehouse = BTPTU.OriginalBudgetProcessedIntoWarehouse,
		BTP.ReasonForFailure = BTPTU.ReasonForFailure,
		BTP.DateBudgetProcessedIntoWarehouse = BTPTU.DateBudgetProcessedIntoWarehouse
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcessToUpdate BTPTU ON
			BTPTU.BudgetsToProcessId = BTP.BudgetsToProcessId
		
	PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10),@@rowcount))

END TRY
BEGIN CATCH
	
	SET @ImportErrorText = NULL
		SELECT @ImportErrorText =  
			COALESCE(@ImportErrorText + ', ', '') + 
			'BudgetsToProcessId:'+ LTRIM(STR(BTPTU.BudgetsToProcessId)) + 
			' ReforecastBudgetsProcessedIntoWarehouse:' + LTRIM(STR(BTPTU.ReforecastBudgetsProcessedIntoWarehouse))  +
			' ReforecastActualsProcessedIntoWarehouse:' + LTRIM(STR(BTPTU.ReforecastActualsProcessedIntoWarehouse))  +
			' ReasonForFailure:' + ReasonForFailure +
			' DateBudgetProcessedIntoWarehouse:' + CONVERT(VARCHAR(27), BTPTU.DateBudgetProcessedIntoWarehouse)
			
		from #BudgetsToProcessToUpdate BTPTU

	PRINT 'Error updating budgets to pricess, The Values were:'
	PRINT @ImportErrorText
	
	
    DECLARE @ErrorSeverity  INT = ERROR_SEVERITY(), @ErrorMessage NVARCHAR(4000) =
		'Error updating BudgetsToProcess: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 	
    RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
END CATCH

-- ==============================================================================================================================================
-- Delete archived budgets: only keep the last three budgets - older budgets must be deleted
-- ==============================================================================================================================================

/*
DECLARE @BudgetsToDelete AS GBSBudgetImportBatchType

INSERT INTO @BudgetsToDelete
SELECT
	Budget.ImportKey,
	Budget.BudgetId,
	Budget.ImportBatchId
FROM
	GBS.Budget Budget
	LEFT OUTER JOIN (
						SELECT
							B1.*,
							B4.ranknum
						FROM
							GBS.Budget B1
							INNER JOIN (
								SELECT
									B2.ImportKey,
									COUNT(*) AS ranknum
								FROM
									GBS.Budget B2
									INNER JOIN GBS.Budget B3 ON
										B2.BudgetId = B3.BudgetId AND
										B2.ImportKey <= B3.ImportKey
								GROUP BY
									B2.ImportKey
								HAVING
									COUNT(*) <= 3 -- the number of version of a given budget that are to be archived (including the current budget)
							) B4 ON
								B1.ImportKey = B4.ImportKey
	) BudgetsToKeep ON
		Budget.ImportKey = BudgetsToKeep.ImportKey
WHERE
	BudgetsToKeep.ImportKey IS NULL

EXEC dbo.stp_D_GBSBudget @BudgetsToDelete
*/

-- ==============================================================================================================================================
-- Clean up: drop temp tables
-- ==============================================================================================================================================

IF 	OBJECT_ID('tempdb..#Budget') IS NOT NULL
    DROP TABLE #Budget

IF 	OBJECT_ID('tempdb..#GLGlobalAccount') IS NOT NULL
    DROP TABLE #GLGlobalAccount

IF 	OBJECT_ID('tempdb..#GLTranslationSubType') IS NOT NULL
    DROP TABLE #GLTranslationSubType

IF 	OBJECT_ID('tempdb..#GLGlobalAccountTranslationSubType') IS NOT NULL
    DROP TABLE #GLGlobalAccountTranslationSubType
    
IF 	OBJECT_ID('tempdb..#GLMinorCategory') IS NOT NULL
    DROP TABLE #GLMinorCategory
    
IF 	OBJECT_ID('tempdb..#GLMajorCategory') IS NOT NULL
    DROP TABLE #GLMajorCategory

IF 	OBJECT_ID('tempdb..#GLGlobalAccountTranslationType') IS NOT NULL
    DROP TABLE #GLGlobalAccountTranslationType

IF 	OBJECT_ID('tempdb..#ReportingEntityCorporateDepartment') IS NOT NULL
    DROP TABLE #ReportingEntityCorporateDepartment

IF 	OBJECT_ID('tempdb..#PropertyFund') IS NOT NULL
    DROP TABLE #PropertyFund

IF 	OBJECT_ID('tempdb..#ActivityType') IS NOT NULL
    DROP TABLE #ActivityType

IF 	OBJECT_ID('tempdb..#CorporateDepartment') IS NOT NULL
    DROP TABLE #CorporateDepartment

IF 	OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
    DROP TABLE #FunctionalDepartment

IF 	OBJECT_ID('tempdb..#AllocationSubRegion') IS NOT NULL
    DROP TABLE #AllocationSubRegion

IF 	OBJECT_ID('tempdb..#GLAccountCategoryMapping') IS NOT NULL
    DROP TABLE #GLAccountCategoryMapping

IF 	OBJECT_ID('tempdb..#ProfitabilitySource') IS NOT NULL
    DROP TABLE #ProfitabilitySource

IF 	OBJECT_ID('tempdb..#ProfitabilityBudget') IS NOT NULL
    DROP TABLE #ProfitabilityBudget

IF 	OBJECT_ID('tempdb..#BudgetsToImport') IS NOT NULL
    DROP TABLE #BudgetsToImport

IF 	OBJECT_ID('tempdb..#BudgetsToImportOriginal') IS NOT NULL
	DROP TABLE #BudgetsToImportOriginal

IF 	OBJECT_ID('tempdb..#BudgetsToDelete') IS NOT NULL
    DROP TABLE #BudgetsToDelete

IF 	OBJECT_ID('tempdb..#CorporatePropertySourceCodes') IS NOT NULL
    DROP TABLE #CorporatePropertySourceCodes

IF 	OBJECT_ID('tempdb..#BudgetsWithUnknowns') IS NOT NULL
    DROP TABLE #BudgetsWithUnknowns

IF 	OBJECT_ID('tempdb..#PreviousBudgetsLastLockedDate') IS NOT NULL
    DROP TABLE #PreviousBudgetsLastLockedDate

IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
    DROP TABLE #BudgetsToProcess

IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownBudgets') IS NOT NULL
    DROP TABLE #BudgetsWithUnknownBudgets
    
IF 	OBJECT_ID('tempdb..#ConsolidatonRegionCorporateDepartment') IS NOT NULL
    DROP TABLE #ConsolidatonRegionCorporateDepartment

GO




/*
3. dbo.stp_IU_LoadGrProfitabiltyGBSReforecast
*/ 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_IU_LoadGrProfitabiltyGBSReforecast') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.stp_IU_LoadGrProfitabiltyGBSReforecast
GO

/*********************************************************************************************************************
Description
	This stored procedure processes non-payroll and fee budget reforecast information and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]
AS

SET NOCOUNT ON


PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGBSReforecast'
PRINT '####'

--DECLARE @LatestImportBatchId INT = (SELECT MAX(ImportBatchId) FROM dbo.BudgetsToProcess WHERE IsReforecast = 1 and SourceSystemName = 'Global Budgeting System' AND BudgetProcessedIntoWarehouse IS NULL AND DateBudgetProcessedIntoWarehouse IS NULL)

DECLARE @DataPriorToDate DATETIME=NULL
IF (@DataPriorToDate IS NULL)
	BEGIN
		SET @DataPriorToDate = CONVERT(DATETIME, 
			(
				SELECT 
					ConfiguredValue 
				FROM 
					SSISConfigurations 
				WHERE 
					ConfigurationFilter = 'ActualDataPriorToDate'
			)
		)
	END



DECLARE @CanImportGBSReforecast INT = (SELECT ConfiguredValue FROM [GrReportingStaging].[dbo].[SSISConfigurations] WHERE ConfigurationFilter = 'CanImportGBSReforecast')

IF (@CanImportGBSReforecast <> 1)
BEGIN
	PRINT ('Import of GBS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations')
	RETURN
END


DECLARE @StartTime DATETIME = GETDATE()

-- ==============================================================================================================================================
-- Get Budgets to Process
-- ==============================================================================================================================================

SELECT 
	BTPC.*, 
	CRR.ReforecastKey
INTO 
	#BudgetsToProcess 
FROM 
	dbo.[BudgetsToProcessCurrent]('GBS Budget/Reforecast') BTPC
	INNER JOIN GrReporting.dbo.GetCurrentReforecastRecord() CRR ON
		BTPC.BudgetYear = CRR.ReforecastEffectiveYear AND
		BTPC.BudgetQuarter = CRR.ReforecastQuarterName
WHERE 
	IsReforecast = 1

DECLARE @BTPRowCount INT = @@rowcount
PRINT ('Rows inserted into #BudgetsToProcess: ' + CONVERT(VARCHAR(10),@BTPRowCount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


IF (@BTPRowCount = 0)
BEGIN
	PRINT ('*******************************************************')
	PRINT ('	stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS BudgetsToProcess set to be imported.')
	PRINT ('*******************************************************')
	RETURN
END


-- ==============================================================================================================================================
-- Declare Local Variables
-- ==============================================================================================================================================
DECLARE @DebugMode BIT = 1 --- Running some extra test queries for debugging purposes. Start comment DEBUG MODE for search and check this variable.

DECLARE @ReasonsForFailure VARCHAR(500) = 'Success'
DECLARE @GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN')
DECLARE	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
DECLARE	@FunctionalDepartmentKeyUnknown	INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
DECLARE	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
DECLARE	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
DECLARE	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
DECLARE	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
DECLARE	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
DECLARE	@OverheadKeyUnknown				INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = 'UNKNOWN')
DECLARE	@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')

IF (@LocalCurrencyKeyUnknown IS NULL)
BEGIN
	PRINT ('Cant find unknown currency key, quitting...')
	RETURN
END


DECLARE	@FeeAdjustmentKeyUnknown		INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'UNKNOWN')--,
--	@CanImportCorporateBudget	INT = (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportCorporateBudget')

DECLARE @EUFundGlAccountCategoryKeyUnknown		INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE @EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@USCorporateGlAccountCategoryKeyUnknown	INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@DevelopmentGlAccountCategoryKeyUnknown	INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
DECLARE	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT TOP 1 GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

--DECLARE @SourceSystemId INT = (SELECT SourceSystemId FROM GrReporting.dbo.SourceSystem WHERE Name = 'Global Budgeting System')
-- There could be up to three copies of the same GBS data due to three seperate imports, so work with latest GBS import which should have the
-- highest ImportBatchId.

--DECLARE @ImportBatchId INT = (SELECT MAX(ImportBatchId) FROM #BudgetsToProcess)
--DECLARE @BudgetCategoryFeesId INT = (SELECT BudgetCategoryId  from GBS.BudgetCategory WHERE Name = 'Fee-Income' and ImportBatchId = @ImportBatchId)
--DECLARE @BudgetCategoryNonPayrollId INT = (SELECT BudgetCategoryId from GBS.BudgetCategory WHERE Name = 'Non-Payroll' and ImportBatchId = @ImportBatchId)
--DECLARE @ReforecastKey INT = (SELECT ReforecastKey FROM GrReporting.dbo.GetCurrentReforecastRecord())

DECLARE @ReforecastTypeIsGBSBUDKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType where BudgetReforecastTypeCode = 'GBSBUD')
DECLARE @ReforecastTypeIsGBSACTKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType where BudgetReforecastTypeCode = 'GBSACT')
--DECLARE	@OverheadTypeIdUnAllocated INT = (Select [OverheadTypeId] From GrReportingStaging.GBS.OverheadType Where [Code] = 'UNALLOC' AND ImportBatchID = @ImportBatchId)


DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);

-- ==============================================================================================================================================
-- Source Budget data from GBS
-- ==============================================================================================================================================

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetAllocationSetId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	CreatorStaffId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	HealthyTensionStartDate DATETIME NOT NULL,
	HealthyTensionEndDate DATETIME NOT NULL,
	LastLockedDate DATETIME NULL,
	PriorBudgetId INT NULL,
	IsReforecast BIT NOT NULL,
	CopiedFromBudgetId INT NULL,
	ImportBudgetIntoGR BIT NOT NULL,
	LastImportBudgetIntoGRDate DATETIME NULL,
	SnapshotId INT NOT NULL,
	Period INT NOT NULL,
	FirstProjectedPeriodFees INT NOT NULL,
	FirstProjectedPeriodNonPayroll INT NOT NULL,
	MustImportAllActualsIntoWarehouse BIT NOT NULL,
	ReforecastKey INT NOT NULL
);

WITH GetFirstProjectedPeriodFees
AS
(
	SELECT
		BudgetId,
		Period AS ProjectedPeriod,
		ImportBatchId
	FROM
		GBS.BudgetPeriod
	WHERE
		IsFeeFirstProjectedPeriod = 1 
),
GetFirstProjectedPeriodNonPayRoll
AS
(
	SELECT
		BudgetId,
		Period AS ProjectedPeriod,
		ImportBatchId
	FROM
		GBS.BudgetPeriod
	WHERE
		IsNonPayrollFirstProjectedPeriod = 1 
)

INSERT INTO #Budget
SELECT
	Budget.ImportKey,
	BTP.ImportBatchId,
	Budget.BudgetId,
	Budget.BudgetAllocationSetId,
	Budget.BudgetReportGroupPeriodId,
	Budget.BudgetExchangeRateId,
	Budget.BudgetStatusId,
	Budget.CreatorStaffId,
	Budget.Name,
	Budget.HealthyTensionStartDate,
	Budget.HealthyTensionEndDate,
	Budget.LastLockedDate,
	Budget.PriorBudgetId,
	Budget.IsReforecast,
	Budget.CopiedFromBudgetId,
	Budget.ImportBudgetIntoGR,
	Budget.LastImportBudgetIntoGRDate,
	BTP.SnapshotId,
	BRGP.Period,
	FPPF.ProjectedPeriod AS FirstProjectedPeriodFees,
	FPPNP.ProjectedPeriod AS FirstProjectedPeriodNonPayroll,
	BTP.MustImportAllActualsIntoWarehouse,
	BTP.ReforecastKey
FROM
  GBS.Budget Budget

	INNER JOIN #BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
		Budget.BudgetId = BTP.BudgetId AND
		Budget.ImportBatchId = BTP.ImportBatchId
		
    INNER JOIN GDM.BudgetReportGroupPeriod BRGP ON
		BRGP.BudgetReportGroupPeriodId = Budget.BudgetReportGroupPeriodId 
		
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey	
		
		
    INNER JOIN GetFirstProjectedPeriodFees FPPF ON
		FPPF.BudgetId = Budget.BudgetId AND
		FPPF.ImportBatchId = BTP.ImportBatchId
		
    INNER JOIN GetFirstProjectedPeriodNonPayRoll FPPNP ON
		FPPNP.BudgetId = Budget.BudgetId AND
		FPPNP.ImportBatchId = BTP.ImportBatchId
    
WHERE
	Budget.IsActive = 1 
	
DECLARE @BudgetRowCount INT = @@rowcount
PRINT ('Rows inserted into #Budget: ' + CONVERT(VARCHAR(10),@BudgetRowCount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF (@BudgetRowCount = 0)
BEGIN
	PRINT ('*******************************************************')
	PRINT ('	stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.')
	PRINT ('*******************************************************')
	RETURN
END

CREATE UNIQUE CLUSTERED INDEX IX_Budget ON #Budget (SnapshotId, BudgetId)

--SELECT * FROM #Budget rollback return

--select * from #Budget ROLLBACK RETURN
-- ==============================================================================================================================================
-- Source Snapshot mapping data from GDM
-- ==============================================================================================================================================


-- GLGlobalAccount --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccount(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NOT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name NVARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	ExpenseCzarStaffId INT NOT NULL,
	ParentCode AS (left(Code,(8))),
	SnapshotId INT NOT NULL
)
INSERT INTO #GLGlobalAccount (
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	Name,
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	ExpenseCzarStaffId,
	SnapshotId
)
SELECT
	GLGA.GLGlobalAccountId,
	GLGA.ActivityTypeId,
	GLGA.GLStatutoryTypeId,
	GLGA.ParentGLGlobalAccountId,
	GLGA.Code,
	GLGA.Name,
	GLGA.[Description],
	GLGA.IsGR,
	GLGA.IsGbs,
	GLGA.IsRegionalOverheadCost,
	GLGA.ExpenseCzarStaffId,
	GLGA.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccount GLGA
	
	INNER JOIN #Budget B ON
		GLGA.SnapshotId = B.SnapshotId
WHERE
	GLGA.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccount: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLTranslationSubType -----------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLTranslationSubType (
	[SnapshotId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL,
	[GLTranslationTypeId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL
)
INSERT INTO #GLTranslationSubType
SELECT
	TST.SnapshotId,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code
FROM
	Gdm.SnapshotGLTranslationSubType TST
	INNER JOIN #Budget B ON
		TST.SnapshotId = B.SnapshotId
WHERE
	TST.Code = 'GL' AND -- This limits to the Global translation sub type; for multiple sub types remove this constraint and add TST.Code to SELECT
	TST.IsActive = 1

PRINT ('Rows inserted into ##GLTranslationSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLGlobalAccountTranslationType --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccountTranslationType(
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #GLGlobalAccountTranslationType
SELECT
	GATT.GLGlobalAccountTranslationTypeId, 
	GATT.GLGlobalAccountId, 
	GATT.GLTranslationTypeId, 
	GATT.GLAccountTypeId,	
	CASE WHEN
			GA.ActivityTypeId = 99
		 THEN 
				-- GC :: CC1 >>
				-- Unallocated overhead expenses will be grouped under the “Overhead” expense 
				-- type and not “Non-Payroll”. This will be based on the activity of the 
				-- transaction; all transactions that have a corporate overhead activity 
				-- will have an expense type of “Overhead”.
			
			AST.GLAccountSubTypeId
			
				--(
				--	SELECT
				--		*--GST.GLAccountSubTypeId 
				--	FROM
				--		Gdm.SnapshotGLAccountSubType GST 
				--		INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
				--			GTT.GLTranslationTypeId = GST.GLTranslationTypeId
				--		INNER JOIN #Budget B ON
				--			GST.SnapshotId = B.SnapshotId AND
				--			GTT.SnapshotId = B.SnapshotId
				--	WHERE
				--		GTT.Code = 'GL' AND
				--		GST.Code = 'GRPOHD'	AND
				--		GST.IsActive = 1 AND
				--		GTT.IsActive = 1
				--)				
		 ELSE
			GATT.GLAccountSubTypeId
	END AS GLAccountSubTypeId,
	GATT.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationType GATT
	
	INNER JOIN #Budget B ON
		GATT.SnapshotId = B.SnapshotId	

	LEFT OUTER JOIN (
						SELECT
							GA.*
						FROM
							#GLGlobalAccount GA
							
					 ) GA ON
							GA.GLGlobalAccountId = GATT.GLGlobalAccountId AND
							GA.SnapshotId = GATT.SnapshotId
	
	LEFT OUTER JOIN (
						SELECT
							GST.GLAccountSubTypeId,
							B.BudgetId,
							gst.SnapshotId
							--GST.GLAccountSubTypeId 
						FROM
							Gdm.SnapshotGLAccountSubType GST 
							INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
								GTT.GLTranslationTypeId = GST.GLTranslationTypeId
							INNER JOIN #Budget B ON
								GST.SnapshotId = B.SnapshotId AND
								GTT.SnapshotId = B.SnapshotId
						WHERE
							GTT.Code = 'GL' AND
							GST.Code = 'GRPOHD'	AND
							GST.IsActive = 1 AND
							GTT.IsActive = 1
					) AST ON
							GATT.SnapshotId = AST.SnapshotId AND
							B.BudgetId = AST.BudgetId
	
WHERE
	GATT.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccountTranslationType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- SnapshotGLGlobalAccountTranslationSubType -------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #GLGlobalAccountTranslationSubType (
	SnapshotId INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL
)
INSERT INTO #GLGlobalAccountTranslationSubType
SELECT
	GATST.SnapshotId,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationSubType GATST
	INNER JOIN #Budget B ON
		GATST.SnapshotId = B.SnapshotId
WHERE
	GATST.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccountTranslationSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLMinorCategory

SET @StartTime = GETDATE()

CREATE TABLE #GLMinorCategory (
	SnapshotId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL
)
INSERT INTO #GLMinorCategory
SELECT
	MinC.SnapshotId,
	MinC.GLMinorCategoryId,
	MinC.GLMajorCategoryId
FROM
	Gdm.SnapshotGLMinorCategory MinC
	INNER JOIN #Budget B ON
		MinC.SnapshotId = B.SnapshotId
WHERE
	MinC.IsActive = 1

PRINT ('Rows inserted into #GLMinorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLMajorCategory

SET @StartTime = GETDATE()

CREATE TABLE #GLMajorCategory (
	[SnapshotId] [int] NOT NULL,
	[GLMajorCategoryId] [int] NOT NULL,
	[GLTranslationSubTypeId] [int] NOT NULL
)
INSERT INTO #GLMajorCategory
SELECT
	MajC.SnapshotId,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId
FROM
	Gdm.SnapshotGLMajorCategory MajC
	INNER JOIN #Budget B ON
		MajC.SnapshotId = B.SnapshotId
WHERE
	MajC.IsActive = 1

PRINT ('Rows inserted into #GLMajorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ReportingEntityCorporateDepartment --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ReportingEntityCorporateDepartment(
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO	#ReportingEntityCorporateDepartment
SELECT
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.SnapshotId
FROM
	Gdm.SnapshotReportingEntityCorporateDepartment RECD
	INNER JOIN #Budget B ON
		RECD.SnapshotId = B.SnapshotId
WHERE
	RECD.IsDeleted = 0

PRINT ('Rows inserted into #ReportingEntityCorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ConsolidationRegionCorporateDepartment (CC16) -----------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ConsolidationRegionCorporateDepartment
(
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	GlobalRegionId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #ConsolidationRegionCorporateDepartment
SELECT
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.CorporateDepartmentCode,
	CRCD.SourceCode,
	CRCD.GlobalRegionId,
	CRCD.SnapshotId
FROM 
	Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
	INNER JOIN #Budget B ON
		CRCD.SnapshotId = B.SnapshotId

PRINT ('Rows inserted into #ConsolidationRegionCorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- PropertyFund --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #PropertyFund(
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #PropertyFund
SELECT
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.Name,
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.SnapshotId
FROM
	Gdm.SnapshotPropertyFund PF
	INNER JOIN #Budget B ON
		B.SnapshotId = PF.SnapshotId
WHERE
	PF.IsActive = 1

PRINT ('Rows inserted into #PropertyFund: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ActivityType --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #ActivityType(
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #ActivityType
SELECT
	ActivityTypeId,
	Code,
	AT.SnapshotId
FROM
	Gdm.SnapshotActivityType AT
	INNER JOIN #Budget B ON
		AT.SnapshotId = B.SnapshotId
WHERE
	AT.IsActive = 1

PRINT ('Rows inserted into #ActivityType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Department --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #CorporateDepartment(
	Code CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL,
	IsTsCost BIT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO	#CorporateDepartment
SELECT
	D.Code,
	D.SourceCode,
	D.FunctionalDepartmentId,
	D.IsTsCost,
	D.SnapshotId
FROM
	Gdm.SnapshotCorporateDepartment D
	INNER JOIN #Budget B ON
		D.SnapshotId = B.SnapshotId
WHERE
	D.IsActive = 1

PRINT ('Rows inserted into #CorporateDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- FunctionalDepartment --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #FunctionalDepartment (
    SnapshotId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Code VARCHAR(20) NULL,
	GlobalCode VARCHAR(30) NULL
)

INSERT INTO #FunctionalDepartment
SELECT
    B.SnapshotId,
	FunctionalDepartmentId,
	Code,
	GlobalCode
FROM
	Gdm.SnapshotFunctionalDepartment FD
	INNER JOIN #Budget B ON
		FD.SnapshotId = B.SnapshotId
WHERE
	FD.IsActive = 1

PRINT ('Rows inserted into #FunctionalDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- AllocationSubRegion --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #AllocationSubRegion (
	[SnapshotId] [int] NOT NULL,
	[AllocationSubRegionGlobalRegionId] [int] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[AllocationRegionGlobalRegionId] [int] NULL,
	[DefaultCorporateSourceCode] [char](2) NOT NULL
)
INSERT INTO #AllocationSubRegion
SELECT
	ASR.SnapshotId,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.Name,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCorporateSourceCode
FROM
	Gdm.SnapshotAllocationSubRegion ASR
	INNER JOIN #Budget B ON
		ASR.SnapshotId = B.SnapshotId
WHERE
	ASR.IsActive = 1

PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Master GL Account Category mapping table

SET @StartTime = GETDATE()

CREATE TABLE #GLAccountCategoryMapping (
	SnapshotId INT NOT NULL,
	GLAccountKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)
INSERT INTO #GLAccountCategoryMapping
SELECT
	Budget.SnapshotId,
	Gla.GlAccountKey,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	MinC.GLMajorCategoryId,
	GLATST.GLMinorCategoryId,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId
FROM
	#Budget Budget

	INNER JOIN #GLTranslationSubType TST ON
		Budget.SnapshotId = TST.SnapshotId

	INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
		TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
		Budget.SnapshotId = GLATST.SnapshotId
	
	INNER JOIN #GLGlobalAccountTranslationType GLATT ON
		GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
		TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
		Budget.SnapshotId = GLATT.SnapshotId

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

	INNER JOIN #GLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		Budget.SnapshotId = MinC.SnapshotId

	INNER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		Budget.SnapshotId = MajC.SnapshotId

PRINT ('Rows inserted into #GLAccountCategoryMapping: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Corporate Property Sources

CREATE TABLE #CorporatePropertySourceCodes (
	CorporateSourceCode CHAR(2) NOT NULL,
	PropertySourceCode CHAR(2) NOT NULL
)

INSERT INTO #CorporatePropertySourceCodes
SELECT 'UC', 'US' UNION ALL
SELECT 'EC', 'EU' UNION ALL
SELECT 'IC', 'IN' UNION ALL
SELECT 'BC', 'BR' UNION ALL
SELECT 'CC', 'CN'


-- ==============================================================================================================================================
-- Get Non-Payroll Expense Budget items from GBS
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilitySource (
	ImportBatchId INT NOT NULL,
    SourceName varchar(20),
    BudgetReforecastTypeKey INT NOT NULL,
    SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	BudgetAmount MONEY NOT NULL,
	GLGlobalAccountId INT NULL,
	FunctionalDepartmentCode VARCHAR(20) NULL,
	JobCode VARCHAR(20) NULL,
	Reimbursable VARCHAR(3) NULL, -- NULL because this field is determined via an outer join
	ActivityTypeId INT NULL, -- NULL because for Fees this field is determined via an outer join
	PropertyFundId INT NULL, -- NULL because this field is determined via an outer join
	AllocationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
	ConsolidationSubRegionGlobalRegionId INT NULL,
	OriginatingGlobalRegionId INT NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	LockedDate DATETIME NULL,
	IsExpense BIT NOT NULL,
	UnallocatedOverhead CHAR(7) NULL, -- NULL because this field is determined via an outer join
	FeeAdjustment VARCHAR(9) NOT NULL,
	ReforecastKey INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilitySource (
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
    SnapshotId,
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	JobCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment,
	ReforecastKey
)

SELECT --TOP 100
	Budget.ImportBatchId,
    'NPEB' as SourceName,
    @ReforecastTypeIsGBSBUDKey,
    Budget.SnapshotId,
	Budget.BudgetId, -- BudgetId
	'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) + '&NonPayrollExpenseBreakdownId=' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
	NPEB.Period, -- ExpensePeriod: Period is actually a foreign key to PeriodExtended but is also the implied period value, e.g.: 201009
	CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
	NPEB.Amount, -- BudgetAmount
	ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
	FD.GlobalCode, -- FunctionalDepartmentCode
	NPEB.JobCode, -- JobCode
	CASE WHEN CD.IsTsCost = 0 THEN 'YES' ELSE 'NO' END, -- Reimbursable
	NPEB.ActivityTypeId, -- ActivityTypeId: this Id should correspond to the correct Id in GDM
	RECD.PropertyFundId, -- PropertyFundId
	PF.AllocationSubRegionGlobalRegionId, -- AllocationSubRegionGlobalRegionId
	CRCD.GlobalRegionId, -- ConsolidationSubRegionGlobalRegionId,
	NPEB.OriginatingSubRegionGlobalRegionId, -- OriginatingGlobalRegionId
	NPEB.CurrencyCode, -- LocalCurrencyCode
	Budget.LastLockedDate, -- LockedDate
	1, -- IsExpense
	CASE WHEN AT.Code = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END, -- UnallocatedOverhead
	'NORMAL', -- FeeAdjustment,
	Budget.ReforecastKey
FROM
	#Budget Budget
	
	INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
		Budget.BudgetId = NPEB.BudgetId AND
		Budget.ImportBatchId = NPEB.ImportBatchId
	
	INNER JOIN #CorporatePropertySourceCodes CPSC ON
		NPEB.CorporateSourceCode = CPSC.CorporateSourceCode
	
	LEFT OUTER JOIN ( -- these NonPayrollExpenses need to be excluded because they are in dispute
	
		/* Disputes are created at the level of a budget project. A budget project will dispute the portion of a non-payroll expense that is
		   allocated to them (via the NonPayrollExpenseBreakdown table, which includes the NonPayrollExpenseId and BudgetProjectId fields,
		   allowing for the portion of the non-payroll expense that has been allocated to the budget project to be determined).
		   
		   If, for example, a non-payroll expense is split between two budget projects, and one of these budget projects is disputing their
		   allocation, the portion of the non-payroll expense that is allocated to the budget project that is not disputing must still be
		   included. Only thet portion of the non-payroll expense that is currently being disputed must be excluded.	   
		*/
	
		SELECT DISTINCT
			NPED.ImportBatchId,
			NPED.NonPayrollExpenseId,
			NPED.BudgetProjectId
		FROM
			GBS.NonPayrollExpenseDispute NPED
			INNER JOIN GBS.DisputeStatus DS ON
				NPED.DisputeStatusId = DS.DisputeStatusId AND
				NPED.ImportBatchId = DS.ImportBatchId
		WHERE
			DS.Name <> 'Resolved' AND
			DS.IsActive = 1
			
	) DisputedNonPayrollExpenseItems ON
		NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
		NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
		NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

	-- PropertyFundId
	LEFT OUTER JOIN #ReportingEntityCorporateDepartment RECD ON				-- Only corporate budgets should be handled by GBS, so when we map
		 NPEB.CorporateDepartmentCode = RECD.CorporateDepartmentCode AND	-- to find a Reporting Entity we assume that the source is corporate
		 NPEB.CorporateSourceCode = RECD.SourceCode AND
		 Budget.SnapshotId = RECD.SnapshotId
		 
	LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
		NPEB.CorporateDepartmentCode = CRCD.CorporateDepartmentCode AND
		NPEB.CorporateSourceCode = CRCD.SourceCode AND
		Budget.SnapshotId = CRCD.SnapshotId
	
	-- AllocationRegionId
	LEFT OUTER JOIN #PropertyFund PF ON
		RECD.PropertyFundId = PF.PropertyFundId AND
		RECD.SnapshotId = PF.SnapshotId
	
	-- Overhead Type
	LEFT OUTER JOIN #ActivityType AT ON
		NPEB.ActivityTypeId = AT.ActivityTypeId AND
		Budget.SnapshotId = AT.SnapshotId -- 
	
	-- Reimbursable
	LEFT OUTER JOIN #CorporateDepartment CD ON
		NPEB.CorporateSourceCode = CD.SourceCode AND
		NPEB.CorporateDepartmentCode = CD.Code AND
		Budget.SnapshotId = CD.SnapshotId --

	-- FunctionalDepartmentCode
	LEFT OUTER JOIN #FunctionalDepartment FD ON
		NPEB.FunctionalDepartmentId = FD.FunctionalDepartmentId 

WHERE
	NPEB.IsActive = 1 
	AND DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL -- Exclude all disputed items
    AND NPEB.Period >= Budget.FirstProjectedPeriodNonPayroll

PRINT ('Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



--select 'NonPayrollExpenseBreakDown' as DataSource, * from #ProfitabilitySource

-- ==============================================================================================================================================
-- Get Fee Budget items from GBS
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

INSERT INTO #ProfitabilitySource (
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
    SnapshotId,
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	JobCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment,
	ReforecastKey
)
SELECT --TOP 100
	Budget.ImportBatchId,
    'Fees' as SourceName,
    @ReforecastTypeIsGBSBUDKey,
    Budget.Snapshotid,
	Budget.BudgetId, -- BudgetId
	'GBS:BudgetId=' + LTRIM(RTRIM(STR(Budget.BudgetId))) + '&FeeId=' + LTRIM(RTRIM(STR(Fee.FeeId))) + '&FeeDetailId=' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
	FeeDetail.Period,
	ASR.DefaultCorporateSourceCode, -- SourceCode
	FeeDetail.Amount,
	GA.GLGlobalAccountId, -- GLGlobalAccountId
	NULL, -- FunctionalDepartmentId
	NULL, -- JobCode
	'NO', -- Reimbursable
	GA.ActivityTypeId, -- ActivityType: determined by finding Fee.GLGlobalAccountId on GrReportingStaging.dbo.GLGlobalAccount
	Fee.PropertyFundId, -- PropertyFundId
	Fee.AllocationSubRegionGlobalRegionId, -- AllocationSubRegionGlobalRegionId
	Fee.AllocationSubRegionGlobalRegionId, -- ConsolidationSubRegionGlobalRegionId (CC16)
	Fee.AllocationSubRegionGlobalRegionId, -- OriginatingGlobalRegionId: allocation region = originating region for fee income
	Fee.CurrencyCode,
	Budget.LastLockedDate, -- LockedDate
	0,  -- IsExpense
	'UNKNOWN', -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
	CASE WHEN FeeDetail.IsAdjustment = 1 THEN 'FEEADJUST' ELSE 'NORMAL' END, -- IsFeeAdjustment, field isn't NULLABLE
	Budget.ReforecastKey
FROM
	#Budget Budget

	INNER JOIN GBS.Fee Fee ON
		Budget.BudgetId = Fee.BudgetId AND
		Budget.ImportBatchId = Fee.ImportBatchId

	INNER JOIN GBS.FeeDetail FeeDetail ON
		Fee.FeeId = FeeDetail.FeeId AND
		Fee.ImportBatchId = FeeDetail.ImportBatchId

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		Fee.GLGlobalAccountId = GA.GLGlobalAccountId AND
		Budget.SnapshotId = GA.SnapshotId

	-- SourceCode
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		Fee.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId

WHERE
	Fee.IsDeleted = 0 AND
	FeeDetail.Amount <> 0 AND
	FeeDetail.Period >= Budget.FirstProjectedPeriodFees

PRINT ('Fee Budgets inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--select 'Fee' as DataSource, * from #ProfitabilitySource

------------------------------------------------------------------------------------------------------------------

-- ==============================================================================================================================================
-- Get ProfitibilityActuals from GBS
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

;WITH CTE_UncallocatedOverhead
AS
(
	SELECT 
		BTP.ImportBatchId,
		OverheadTypeId
	FROM 
		GrReportingStaging.GBS.OverheadType  OHT
		INNER JOIN #BudgetsToProcess BTP ON
			BTP.ImportBatchId = OHT.ImportBatchId
	WHERE [Code] = 'UNALLOC'
),
CTE_BudgetCategory
AS
(
	SELECT 
	    BTP.ImportBatchId,
		BudgetCategoryId,
		OverheadTypeId,
		Name
	FROM 
		GBS.BudgetCategory BC
		INNER JOIN #BudgetsToProcess BTP ON
			BTP.ImportBatchId = BC.ImportBatchId		
			
		LEFT OUTER JOIN CTE_UncallocatedOverhead UAOHT ON
			BC.ImportBatchId = UAOHT.ImportBatchId
)
SELECT
     'Actual-Fees' AS SourceName, 
     0 as IsExpense,
     BPA.* 
INTO 
	#Actuals 
FROM
	GBS.BudgetProfitabilityActual BPA
	
    INNER JOIN #Budget B ON		
		b.BudgetId = BPA.BudgetId AND
		B.ImportBatchId = BPA.ImportBatchId
		
    INNER JOIN CTE_BudgetCategory BC ON 
		BC.BudgetCategoryId = BPA.BudgetCategoryId AND
		BC.Name = 'Fee-Income' 

WHERE
	BPA.Period < B.FirstProjectedPeriodFees 
UNION ALL
SELECT
	'Actual-NonPayroll' AS SourceName,
	1 as IsExpense,
	BPA.*
FROM
	GBS.BudgetProfitabilityActual BPA 

    INNER JOIN #Budget B ON
		B.BudgetId = BPA.BudgetId AND
		B.ImportBatchId = BPA.ImportBatchId AND 
		B.MustImportAllActualsIntoWarehouse = 1
    
    INNER JOIN CTE_BudgetCategory BC ON 
		BC.BudgetCategoryId = BPA.BudgetCategoryId AND
		(
		    (BC.Name = 'Non-Payroll') OR 
            (BC.Name = 'Overhead' AND BPA.OverheadTypeId = BC.OverheadTypeId)
        )  AND
        BC.ImportBatchId = BPA.ImportBatchId
		
WHERE
	BPA.Period < B.FirstProjectedPeriodNonPayroll
	
	
PRINT ('Actuals Queried')
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



INSERT INTO #ProfitabilitySource (
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
    SnapshotId,
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	JobCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	UnallocatedOverhead,
	FeeAdjustment,
	ReforecastKey
)
SELECT  
	BPA.ImportBatchId,
    BC.Name AS SourceName,  
    @ReforecastTypeIsGBSACTKey,
    b.SnapshotId,
	b.BudgetId, 
	'GBS:BudgetId=' + LTRIM(RTRIM(STR(b.BudgetId))) + '&BudgetProfitabilityActualId=' + LTRIM(RTRIM(STR(bpa.BudgetProfitabilityActualId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(b.SnapshotId))) AS ReferenceCode, -- ReferenceCode
	BPA.Period,
	ASR.DefaultCorporateSourceCode, -- SourceCode
	BPA.Amount,
	GA.GLGlobalAccountId, -- GLGlobalAccountId
	FD.GlobalCode,
	BPA.CorporateJobCode,
	CASE WHEN BPA.IsTsCost = 0 THEN 'YES' ELSE 'NO' END,
	BPA.ActivityTypeId,
	PF.PropertyFundId,
	BPA.AllocationSubRegionGlobalRegionId,
	BPA.ConsolidationSubRegionGlobalRegionId, -- ConsolidationSubRegionGlobalRegionId (CC16)
	BPA.OriginatingSubRegionGlobalRegionId,	
	BPA.CurrencyCode,
	B.LastLockedDate,
	BPA.IsExpense,
	CASE WHEN AT.Code = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END, -- UnallocatedOverhead
	'Normal' AS FeeAdjustment,
	B.ReforecastKey
FROM 
    #Actuals BPA

    INNER JOIN  #Budget B ON
		B.BudgetId = BPA.BudgetId
    
    INNER JOIN [GBS].[BudgetCategory] BC ON 
		BC.BudgetCategoryId = BPA.BudgetCategoryId AND
		BC.ImportBatchId = B.ImportBatchId		
    
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		BPA.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId
		
	LEFT OUTER JOIN #GLGlobalAccount GA ON
		BPA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		B.SnapshotId = GA.SnapshotId

	LEFT OUTER JOIN #FunctionalDepartment FD on 
		FD.FunctionalDepartmentId = BPA.FunctionalDepartmentId
		and b.SnapshotId = FD.SnapshotId

    LEFT OUTER JOIN  #PropertyFund PF
		on PF.PropertyFundId = BPA.ReportingEntityPropertyFundId
		and B.SnapshotId = PF.SnapshotId
		
	-- Overhead Type
	LEFT OUTER JOIN #ActivityType AT ON
		BPA.ActivityTypeId = AT.ActivityTypeId AND
		B.SnapshotId = AT.SnapshotId -- 
		


PRINT ('ProfitibilityActuals Rows inserted into #ProfitabilitySource: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
				
--where    
 --   ((BC.BudgetCategoryId = @BudgetCategoryFeesId) AND (BPA.Period < B.FirstProjectedPeriodFees)) 
 --  OR ((BC.BudgetCategoryId = @BudgetCategoryNonPayrollId) AND (BPA.Period < B.FirstProjectedPeriodNonPayroll))

  --  ((BC.Name = 'Fee-Income') AND (BPA.Period < B.FirstProjectedPeriodFees)) 
  -- OR ((BC.Name = 'Non-Payroll') AND (BPA.Period < B.FirstProjectedPeriodNonPayroll))
   -- (BC.Name = 'Fee-Income') AND (BPA.Period < B.FirstProjectedPeriodFees)
    
UPDATE
	PS
SET
	PS.GLGlobalAccountId = GLGA2.GLGlobalAccountId
FROM
	#ProfitabilitySource PS

	INNER JOIN #GLGlobalAccount GLGA1 ON
		PS.GLGlobalAccountId = GLGA1.GLGlobalAccountId

	INNER JOIN #GLGlobalAccount GLGA2 ON
		(LEFT(GLGA1.Code, 10 - LEN(PS.ActivityTypeId)) + LTRIM(RTRIM(STR(PS.ActivityTypeId)))) = GLGA2.Code
WHERE
	LEN(GLGA1.Code) = 10 AND -- A code of 10 characters excludes the account prefix (CP, TS) and includes the activity type code, i.e.: 5020100012
	RIGHT(GLGA1.Code, 2) = '00' -- where the header account has been budgeted against

PRINT ('Rows updated in #ProfitabilitySource (GLAccount update from head to activity-specific GL Account: ' + LTRIM(RTRIM(STR(@@rowcount))))

------------------------------------------------------------------------------------------------------------------

-- Perhaps create index for #ProfitabilitySource here

-- ==============================================================================================================================================
-- Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityReforecast(
	ImportBatchId INT NOT NULL,
    SourceName varchar(20),
    BudgetReforecastTypeKey INT NOT NULL,
    SnapshotId INT NOT NULL,
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	ConsolidationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	FeeAdjustmentKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	--SourceSystemId int NOT NULL,
	IsExpense BIT NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL,
	ReforecastKey INT NOT NULL	
	
)
INSERT INTO #ProfitabilityReforecast 
(
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
    SnapshotId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	--SourceSystemId,
	IsExpense,
	PS.ReforecastKey
)

SELECT
	PS.ImportBatchId,
    PS.SourceName,
    PS.BudgetReforecastTypeKey,
    PS.SnapshotId,
	DATEDIFF(DD, '1900-01-01', LEFT(PS.ExpensePeriod, 4)+'-' + RIGHT(PS.ExpensePeriod, 2) + '-01'), -- CalendarKey,
	CASE WHEN GA.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GA.GlAccountKey END, -- GlAccountKey,
	CASE WHEN S.SourceKey IS NULL THEN @SourceKeyUnknown ELSE S.SourceKey END, -- SourceKey,
	CASE WHEN
		ISNULL(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey) IS NULL
		THEN
			@FunctionalDepartmentKeyUnknown
		ELSE
			ISNULL(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey) END,	-- FunctionalDepartmentKey,
	CASE WHEN R.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE R.ReimbursableKey END, -- ReimbursableKey,
	CASE WHEN AT.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE AT.ActivityTypeKey END, -- ActivityTypeKey,
	CASE WHEN PF.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE PF.PropertyFundKey END, -- PropertyFundKey,
	CASE WHEN AR.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE AR.AllocationRegionKey END, -- AllocationRegionKey,
	CASE WHEN CR.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE CR.AllocationRegionKey END, -- ConsolidationRegionKey,
	CASE WHEN
		PS.IsExpense = 1
		THEN
			CASE WHEN
				ORR.OriginatingRegionKey IS NULL
			THEN
				@OriginatingRegionKeyUnknown
			ELSE
				ORR.OriginatingRegionKey
			END
		ELSE
			CASE WHEN
				ORRFee.OriginatingRegionKey IS NULL
			THEN
				@OriginatingRegionKeyUnknown
			ELSE
				ORRFee.OriginatingRegionKey
			END
	END, -- OriginatingRegionKey,
	CASE WHEN O.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE O.OverheadKey END, -- OverheadKey,
	CASE WHEN FA.FeeAdjustmentKey IS NULL THEN @FeeAdjustmentKeyUnknown ELSE FA.FeeAdjustmentKey END, -- FeeAdjustmentKey,
	CASE WHEN C.CurrencyKey IS NULL THEN @LocalCurrencyKeyUnknown ELSE C.CurrencyKey END, -- LocalCurrencyKey,
	PS.BudgetAmount, -- LocalBudget,
	PS.ReferenceCode, -- ReferenceCode,
	PS.BudgetId, -- BudgetId,
	--@SourceSystemId, -- SourceSystemId
	PS.IsExpense,
	PS.ReforecastKey
FROM
	#ProfitabilitySource PS

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GA ON
		PS.GLGlobalAccountId = GA.GLGlobalAccountId AND
		PS.SnapshotId = GA.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] S ON
		PS.SourceCode = S.SourceCode 

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable R ON
		PS.Reimbursable = R.ReimbursableCode 
		

	LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
		PS.ActivityTypeId = AT.ActivityTypeId AND
		PS.SnapshotId = AT.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
		PS.PropertyFundId = PF.PropertyFundId AND
		PS.SnapshotId = PF.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
		PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId AND 
		PS.SnapshotId = AR.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion CR ON
		PS.ConsolidationSubRegionGlobalRegionId = CR.GlobalRegionId AND
		PS.SnapshotId = CR.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
		PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId AND
		PS.SnapshotId = ORRFee.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
		PS.OriginatingGlobalRegionId = ORR.GlobalRegionId AND
		PS.SnapshotId = ORR.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.Currency C ON
		PS.LocalCurrencyCode = C.CurrencyCode
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead O ON
		PS.UnallocatedOverhead = O.OverheadCode 
		
	
	LEFT OUTER JOIN GrReporting.dbo.FeeAdjustment FA ON
		PS.FeeAdjustment = FA.FeeAdjustmentCode 

	-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							FunctionalDepartmentCode <> SubFunctionalDepartmentCode
							
	) FDJobCode ON
		PS.JobCode = FDJobCode.SubFunctionalDepartmentCode AND
		PS.FunctionalDepartmentCode = FDJobCode.FunctionalDepartmentCode 
		

	-- Parent Level
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							SubFunctionalDepartmentCode = FunctionalDepartmentCode
	) FD ON
		PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode

WHERE
	PS.BudgetAmount <> 0

PRINT ('Rows inserted into #ProfitabilityReforecast: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

PRINT ('Creating Unique INDEX  IX_ProfitibilityRecforecast1 on #ProfitabilityReforecast on ReferenceCode')
SET @StartTime = GETDATE()
CREATE UNIQUE CLUSTERED INDEX IX_ProfitibilityRecforecast1 ON #ProfitabilityReforecast (ReferenceCode)
PRINT ('Created Unique INDEX  IX_ProfitibilityRecforecast1 on #ProfitabilityReforecast ')
PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))




-- ==============================================================================================================================================
-- Update #ProfitibilityReforecast.GlobalGlAccountCategoryKey
-- ==============================================================================================================================================

--select * from #ProfitabilitySource

SET @StartTime = GETDATE()

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
		Gl.GlAccountKey = GLACM.GlAccountKey AND
		Gl.SnapshotId = GLACM.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode =  CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLACM.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLACM.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountSubTypeId)) AND
		Gl.SnapshotId = GLAC.SnapshotId

PRINT ('Rows updated from #ProfitibilityReforecast.GlobalGlAccountCategoryKey: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- ==============================================================================================================================================
-- Delete budgets to insert that have UNKNOWNS in their mapping
-- ==============================================================================================================================================

SET @StartTime = GETDATE()

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns
DELETE
FROM
	dbo.ProfitabilityReforecastUnknowns
WHERE
	BudgetReforecastTypeKey IN (@ReforecastTypeIsGBSBUDKey, @ReforecastTypeIsGBSActKey) -- Only delete GBS records, leave TAPAS records

PRINT ('Rows deleted from ProfitabilityReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

INSERT INTO dbo.ProfitabilityReforecastUnknowns (
	ImportBatchId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	EUCorporateGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	BudgetId,
	--SourceSystemId,
	OverheadKey,
	FeeAdjustmentKey,
	BudgetReforecastTypeKey,
	SnapshotId
)
SELECT
	ImportBatchId,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	EUCorporateGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	BudgetId,
	--SourceSystemId,
	OverheadKey,
	FeeAdjustmentKey,
	BudgetReforecastTypeKey,
	SnapshotId
FROM
	#ProfitabilityReforecast

WHERE
	GlAccountKey = @GlAccountKeyUnknown OR
	SourceKey = @SourceKeyUnknown OR
	(FunctionalDepartmentKey = @FunctionalDepartmentKeyUnknown AND IsExpense = 1) OR	
	ReimbursableKey = @ReimbursableKeyUnknown OR
	ActivityTypeKey = @ActivityTypeKeyUnknown OR
	PropertyFundKey = @PropertyFundKeyUnknown OR
	AllocationRegionKey = @AllocationRegionKeyUnknown OR
	OriginatingRegionKey = @OriginatingRegionKeyUnknown OR
	FeeAdjustmentKey = @FeeAdjustmentKeyUnknown OR
	LocalCurrencyKey = @LocalCurrencyKeyUnknown OR
	GlobalGlAccountCategoryKey = @GlobalGlAccountCategoryKeyUnknown
	-- LocalBudget
	-- OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
	-- CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
	-- ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
	-- BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a 'not null' dbase constraint in source system)
	-- SourceSystemId

DECLARE @RowsInserted INT = @@rowcount
PRINT ('Rows inserted into ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@RowsInserted))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--------------------------------------------------
---  BUILD Unknown Budgets
--------------------------------------------------
SET @StartTime = GETDATE()

SELECT DISTINCT
	PRU.ImportBatchId,
	B.SnapshotId, 
	B.BudgetId,
	B.ImportKey,
	PRU.BudgetReforecastTypeKey
INTO
   #BudgetsWithUnknownBudgets
FROM 
   dbo.ProfitabilityReforecastUnknowns  PRU
   INNER JOIN #Budget B ON
		B.SnapshotId = PRU.SnapshotId AND
		B.BudgetId = PRU.BudgetId 
WHERE
  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsGBSBudKey

DECLARE @RowsToDeleteFromPRBudgets INT = @@rowcount

PRINT ('Rows inserted into #BudgetsWithUnknownBudgets: ' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRBudgets))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--------------------------------------------------
---  BUILD Unknown Actuals
--------------------------------------------------

SET @StartTime = GETDATE()

SELECT DISTINCT
	PRU.ImportBatchId,
	B.SnapshotId, 
	B.BudgetId,
	B.ImportKey,
	PRU.BudgetReforecastTypeKey
INTO
   #BudgetsWithUnknownActuals
FROM 
   dbo.ProfitabilityReforecastUnknowns  PRU
   INNER JOIN #Budget B ON
		B.SnapshotId = PRU.SnapshotId AND
		B.BudgetId = PRU.BudgetId 
	
WHERE
  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsGBSActKey

DECLARE @RowsToDeleteFromPRActuals INT = @@rowcount
PRINT ('Rows inserted into #BudgetsWithUnknownActuals: ' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRActuals))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
  
--------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
---  BUILD ALL Unknown Budgets - Now merge them into one unique budget set and these are all budgets that need deleting
------------------------------------------------------------------------------------------------------------------------------------------------------
SET @StartTime = GETDATE()

SELECT 
   BUA.ImportBatchId,
   BUA.SnapshotId, 
   BUA.BudgetId,
   BUA.ImportKey
INTO 
	#AllUnknownBudgets
FROM 
	#BudgetsWithUnknownActuals BUA
	INNER JOIN #BudgetsWithUnknownBudgets BUB ON
		BUB.BudgetId = BUA.BudgetId AND
		BUB.SnapshotId = BUA.SnapshotId AND
		BUB.ImportKey = BUA.ImportKey		
   
PRINT ('Rows INSERTED INTO #AllUnknownBudgets that have Unknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
   

--------------------------------------------------


IF (@RowsInserted > 0)
BEGIN
	PRINT ('Oh no - there are ' + CONVERT(VARCHAR(10), @RowsInserted) + ' unknowns in #ProfitibilityReforecast. They have been inserted into dbo.ProfitabilityBudgetUnknowns.')
	PRINT ('Deleting records associated with budgets that have unknowns...')
	
	PRINT 'WARNING WARNING: DELETE UNKNOWNS COMMENTED OUT'
	/*	
	INSERT INTO @ImportErrorTable (Error) SELECT 'Unknowns'
	
	IF @RowsToDeleteFromPRBudgets > 0 BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Budgets'
	END
	IF @RowsToDeleteFromPRActuals > 0 BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Actuals'
	END	
	
	
	---------------- Delete the unknown budget portions
	SET @StartTime = GETDATE()

	DELETE
		PR
	FROM
		#ProfitabilityReforecast PR
		INNER JOIN #BudgetsWithUnknownBudgets AUB ON
		  PR.BudgetId = AUB.BudgetId AND
		  PR.SnapshotId = AUB.SnapshotId AND
		  PR.BudgetReforecastTypeKey = AUB.BudgetReforecastTypeKey
	  
	PRINT ('Rows DELETED from #ProfitabilityReforecast that have Unknown Budgets: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	---------------- Delete the unknown actual portions
	SET @StartTime = GETDATE()

	
	
	DELETE 
		PR
	FROM 
		#ProfitabilityReforecast PR
		INNER JOIN #BudgetsWithUnknownActuals AUB ON
		  PR.BudgetId = AUB.BudgetId AND
		  PR.SnapshotId = AUB.SnapshotId AND
		  PR.BudgetReforecastTypeKey = AUB.BudgetReforecastTypeKey		  
	
	
	PRINT ('Rows DELETED from #ProfitabilityReforecast that have Unknown Actuals: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
	SET @StartTime = GETDATE()	
    
	DECLARE @BudgetsWithUnknowns AS GBSBudgetImportBatchType
	INSERT INTO 
		@BudgetsWithUnknowns (
			ImportBatchId,
			BudgetId,
			ImportKey
		)	
	SELECT 
			ImportBatchId,
			BudgetId,
			ImportKey
	FROM
		#AllUnknownBudgets
		
	PRINT ('Rows INSERTED INTO @BudgetsWithUnknowns That are all Unknown: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
	
	-- delete these budgets and their associated data from GrReportingStaging
	-- EXEC dbo.stp_D_GBSBudget @BudgetsWithUnknowns

	--PRINT ('Deleting GrReportingStaging GBS records associated with budgets that have unknowns: ' + LTRIM(RTRIM(STR(@@rowcount))) + ' (completed)')
	*/
END

-- ==============================================================================================================================================
-- Delete existing Reforecasts that we are about to insert
-- ==============================================================================================================================================

/*CREATE TABLE #ReforecastsToImportOriginal( -- an original copy of the Reforecasts that are to be imported is kept here - the Reforecasts in the table below will be deleted during insertion into the warehouse
	BudgetId INT NOT NULL
)*/

CREATE TABLE #ReforecastsToImport(
	BudgetId INT NOT NULL
)
INSERT INTO #ReforecastsToImport
SELECT DISTINCT
	BudgetId
FROM
	#ProfitabilityReforecast


/*INSERT INTO #ReforecastsToImportOriginal
SELECT DISTINCT
	BudgetId
FROM
	#ProfitabilityReforecast*/


/*
SELECT DISTINCT
	BudgetId
FROM
	#RecorecastsBudgetsToImportOnly
WHERE 
	BudgetReforecastTypeKey = @ReforecastTypeIsGBSBudKey

SELECT DISTINCT
	BudgetId
FROM
	#RecorecastsActualsToImportOnly
WHERE 
	BudgetReforecastTypeKey = @ReforecastTypeIsGBSActKey
*/
SET @StartTime = GETDATE()

DECLARE @ReforecastId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
DECLARE @TotalDeleteCount INT = 0
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #ReforecastsToImport) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @ReforecastId = (SELECT TOP 1 BudgetId FROM #ReforecastsToImport)

	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		
			DELETE TOP (100000) -- Remove old facts
			FROM
				GrReporting.dbo.ProfitabilityReforecast 
			WHERE
				BudgetId = @ReforecastId AND
				BudgetReforecastTypeKey in (@ReforecastTypeIsGBSBUDKey, @ReforecastTypeIsGBSACTKey)
				--SourceSystemId = @SourceSystemId
			
			SET @row = @@rowcount
			SET @deleteCnt = @deleteCnt + @row
			SET @TotalDeleteCount = @TotalDeleteCount + @row
			
			PRINT 'Deleted OLD rows from dbo.ProfitabilityReforecast >>>:'+CONVERT(VARCHAR(10),@row)
			PRINT CONVERT(VARCHAR(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted FOR BudgetID (' + STR(@ReforecastId) + ') FROM  ProfitabilityReforecast:'+CONVERT(VARCHAR(10),@deleteCnt)
	
	PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
	DELETE FROM #ReforecastsToImport WHERE BudgetId = @ReforecastId
	
	PRINT 'Rows Deleted from #DeletingReforecast:'+CONVERT(VARCHAR(10),@@ROWCOUNT)
	PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
END
PRINT 'TOTAL Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@TotalDeleteCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



-- ==============================================================================================================================================
-- Insert budget records into GrReporting.dbo.ProfitabilityBudget
-- ==============================================================================================================================================

------------------------------------------------ DEBUG MODE ----------------------------------------
if @DebugMode = 1 BEGIN
	DECLARE @DebugMaxReforecastIdBefore INT = (SELECT MAX(ProfitabilityReforecastKey) from GrReporting.dbo.ProfitabilityReforecast)
	DECLARE @DebugDuplicateReferenceCodesBefore INT = (
		SELECT TOP 1
			COUNT(*) 
		FROM
			GrReporting.dbo.ProfitabilityReforecast PR
			INNER JOIN #Budget B ON
				B.BudgetId = PR.BudgetId AND
				B.SnapshotId = PR.SnapshotId
		GROUP BY 
			PR.ReferenceCode			
	)
END

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
    SnapshotId,
	BudgetReforecastTypeKey,
    ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	--SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
    SnapshotId,
	BudgetReforecastTypeKey,
    ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	--SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast

DECLARE @RowsInsertedIntoProfitabilityReforecastWH INT = @@ROWCOUNT
PRINT 'Rows Inserted into GrReporting.dbo.ProfitabilityReforecast:'+CONVERT(VARCHAR(10),@RowsInsertedIntoProfitabilityReforecastWH)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------ DEBUG MODE ----------------------------------------
IF @DebugMode = 1 BEGIN
	DECLARE @DebugMaxReforecastIdAfter INT = (SELECT MAX(ProfitabilityReforecastKey) from GrReporting.dbo.ProfitabilityReforecast)

	DECLARE @DebugDuplicateReferenceCodesAfter INT = (
		SELECT TOP 1
			COUNT(*) 
		FROM
			GrReporting.dbo.ProfitabilityReforecast PR
			INNER JOIN #Budget B ON
				B.BudgetId = PR.BudgetId AND
				B.SnapshotId = PR.SnapshotId
		GROUP BY 
			PR.ReferenceCode			
	)
	DECLARE @DebugDuplicateReferenceCodesDelta INT = @DebugDuplicateReferenceCodesAfter - @DebugDuplicateReferenceCodesBefore
	
	IF (@DebugDuplicateReferenceCodesDelta <> 0) BEGIN
		PRINT 'Number Of Duplicate ReferenceCodes DELTA = ' + STR(@DebugDuplicateReferenceCodesDelta)
	    PRINT 'WARNING!!: Some duplicate reference codes may be inserted'
	END
	DECLARE @DebugNewProfitabilityReforecastKeyCount INT = (
		SELECT COUNT(*) FROM GrReporting.dbo.ProfitabilityReforecast where (ProfitabilityReforecastKey > @DebugMaxReforecastIdBefore AND ProfitabilityReforecastKey <= @DebugMaxReforecastIdAfter)
	)
	DECLARE @RowsInsertedIntoProfitabilityReforecastWHNewPRKeyCountDelta INT =  @RowsInsertedIntoProfitabilityReforecastWH - @DebugNewProfitabilityReforecastKeyCount
	IF @RowsInsertedIntoProfitabilityReforecastWHNewPRKeyCountDelta <> 0 BEGIN
		PRINT 'WARNING: Max ProfitabilityReforecastKey count does not match the insertions (POSSIBLY concurrent inserts happened?) DELTA: ' + STR(@RowsInsertedIntoProfitabilityReforecastWHNewPRKeyCountDelta)
	END	
	ELSE  BEGIN
	   PRINT 'Max ProfitabilityReforecastKey matches count of insertions'
	END
END
--------------------------------------------------------------------------------------------------------

-- ==============================================================================================================================================
-- Mark budgets as being successfully processed into the warehouse
-- ==============================================================================================================================================

DECLARE @ImportErrorText VARCHAR(500)
SELECT @ImportErrorText = COALESCE(@ImportErrorText + ', ', '') + Error from @ImportErrorTable

BEGIN TRY		

	SELECT
		--- Note Slight reverse logic from originally, original it looked if there are anything left in the temp table, now it looks:
		--- IS THERE ANYTHING THAT WAS UNKNOWN for Budgets and Actuals Seperately
		BTP.BudgetsToProcessId,
		CASE WHEN BWUB.BudgetId IS NULL THEN 1 ELSE 0 END AS ReforecastBudgetsProcessedIntoWarehouse, -- 0 if import fails, 1 if import succeeds
		CASE WHEN BWUA.BudgetId IS NULL THEN 1 ELSE 0 END AS ReforecastActualsProcessedIntoWarehouse, -- 0 if import fails, 1 if import succeeds
		@ImportErrorText AS ReasonForFailure,
		GETDATE() AS DateBudgetProcessedIntoWarehouse-- date that the buget import either failed or succeeded (depending on 0 or 1 above)
	INTO 
		#BudgetsToProcessToUpdate
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcess BTPT ON
			BTP.BudgetsToProcessId = BTPT.BudgetsToProcessId	
		
		LEFT OUTER JOIN #BudgetsWithUnknownBudgets BWUB ON
			BTP.BudgetId = BWUB.BudgetId 

		LEFT OUTER JOIN #BudgetsWithUnknownActuals BWUA ON
			BTP.BudgetId = BWUA.BudgetId 

	UPDATE
		BTP
	SET
		BTP.ReforecastBudgetsProcessedIntoWarehouse = BTPTU.ReforecastBudgetsProcessedIntoWarehouse,
		BTP.ReforecastActualsProcessedIntoWarehouse = BTPTU.ReforecastActualsProcessedIntoWarehouse,
		BTP.ReasonForFailure = BTPTU.ReasonForFailure,
		BTP.DateBudgetProcessedIntoWarehouse = BTPTU.DateBudgetProcessedIntoWarehouse
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcessToUpdate BTPTU ON
			BTPTU.BudgetsToProcessId = BTP.BudgetsToProcessId
		
	PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10),@@rowcount))

END TRY
BEGIN CATCH
	
	SET @ImportErrorText = NULL
		SELECT @ImportErrorText =  
			COALESCE(@ImportErrorText + ', ', '') + 
			'BudgetsToProcessId:'+ LTRIM(STR(BTPTU.BudgetsToProcessId)) + 
			' ReforecastBudgetsProcessedIntoWarehouse:' + LTRIM(STR(BTPTU.ReforecastBudgetsProcessedIntoWarehouse))  +
			' ReforecastActualsProcessedIntoWarehouse:' + LTRIM(STR(BTPTU.ReforecastActualsProcessedIntoWarehouse))  +
			' ReasonForFailure:' + ReasonForFailure +
			' DateBudgetProcessedIntoWarehouse:' + CONVERT(VARCHAR(27), BTPTU.DateBudgetProcessedIntoWarehouse)
			
		from #BudgetsToProcessToUpdate BTPTU

	PRINT 'Error updating budgets to pricess, The Values were:'
	PRINT @ImportErrorText
	
	
    DECLARE @ErrorSeverity  INT = ERROR_SEVERITY(), @ErrorMessage NVARCHAR(4000) =
		'Error updating BudgetsToProcess: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 	
    RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
END CATCH




-- ==============================================================================================================================================
-- Delete archived budgets: only keep the last three budgets - older budgets must be deleted
-- ==============================================================================================================================================

/* COMMENTED OUT FOR NOW, PLEASE REVISIT AS POTENTIAL TO SPLIT TO A DIFFERENT PROC OR RE ENABLE
DECLARE @BudgetsToDelete AS GBSBudgetImportBatchType

INSERT INTO @BudgetsToDelete
SELECT
	Budget.ImportKey,
	Budget.BudgetId,
	Budget.ImportBatchId
FROM
	GBS.Budget Budget
	LEFT OUTER JOIN (
						SELECT
							B1.*,
							B4.ranknum
						FROM
							GBS.Budget B1
							INNER JOIN (
								SELECT
									B2.ImportKey,
									COUNT(*) AS ranknum
								FROM
									GBS.Budget B2
									INNER JOIN GBS.Budget B3 ON
										B2.BudgetId = B3.BudgetId AND
										B2.ImportKey <= B3.ImportKey
								GROUP BY
									B2.ImportKey
								HAVING
									COUNT(*) <= 3 -- the number of version of a given budget that are to be archived (including the current budget)
							) B4 ON
								B1.ImportKey = B4.ImportKey
	) BudgetsToKeep ON
		Budget.ImportKey = BudgetsToKeep.ImportKey
WHERE
	BudgetsToKeep.ImportKey IS NULL

EXEC dbo.stp_D_GBSBudget @BudgetsToDelete
*/



IF 	OBJECT_ID('tempdb..#Budget') IS NOT NULL
    DROP TABLE #Budget

IF 	OBJECT_ID('tempdb..#GLGlobalAccount') IS NOT NULL
    DROP TABLE #GLGlobalAccount

IF 	OBJECT_ID('tempdb..#GLTranslationSubType') IS NOT NULL
    DROP TABLE #GLTranslationSubType

IF 	OBJECT_ID('tempdb..#GLGlobalAccountTranslationSubType') IS NOT NULL
    DROP TABLE #GLGlobalAccountTranslationSubType
    
IF 	OBJECT_ID('tempdb..#GLMinorCategory') IS NOT NULL
    DROP TABLE #GLMinorCategory
    
IF 	OBJECT_ID('tempdb..#GLMajorCategory') IS NOT NULL
    DROP TABLE #GLMajorCategory

IF 	OBJECT_ID('tempdb..#GLGlobalAccountTranslationType') IS NOT NULL
    DROP TABLE #GLGlobalAccountTranslationType

IF 	OBJECT_ID('tempdb..#ReportingEntityCorporateDepartment') IS NOT NULL
    DROP TABLE #ReportingEntityCorporateDepartment

IF 	OBJECT_ID('tempdb..#PropertyFund') IS NOT NULL
    DROP TABLE #PropertyFund

IF 	OBJECT_ID('tempdb..#ActivityType') IS NOT NULL
    DROP TABLE #ActivityType

IF 	OBJECT_ID('tempdb..#CorporateDepartment') IS NOT NULL
    DROP TABLE #CorporateDepartment

IF 	OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
    DROP TABLE #FunctionalDepartment

IF 	OBJECT_ID('tempdb..#AllocationSubRegion') IS NOT NULL
    DROP TABLE #AllocationSubRegion

IF 	OBJECT_ID('tempdb..#GLAccountCategoryMapping') IS NOT NULL
    DROP TABLE #GLAccountCategoryMapping

IF 	OBJECT_ID('tempdb..#ProfitabilitySource') IS NOT NULL
    DROP TABLE #ProfitabilitySource

IF 	OBJECT_ID('tempdb..#ProfitabilityBudget') IS NOT NULL
    DROP TABLE #ProfitabilityBudget

IF 	OBJECT_ID('tempdb..#BudgetsToImport') IS NOT NULL
    DROP TABLE #BudgetsToImport

IF 	OBJECT_ID('tempdb..#BudgetsToImportOriginal') IS NOT NULL
	DROP TABLE #BudgetsToImportOriginal

IF 	OBJECT_ID('tempdb..#BudgetsToDelete') IS NOT NULL
    DROP TABLE #BudgetsToDelete

IF 	OBJECT_ID('tempdb..#CorporatePropertySourceCodes') IS NOT NULL
    DROP TABLE #CorporatePropertySourceCodes

IF 	OBJECT_ID('tempdb..#BudgetsWithUnknowns') IS NOT NULL
    DROP TABLE #BudgetsWithUnknowns


IF 	OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
    DROP TABLE #FunctionalDepartment

IF 	OBJECT_ID('tempdb..#Actuals') IS NOT NULL
    DROP TABLE #Actuals

IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownBudgets') IS NOT NULL
    DROP TABLE #BudgetsWithUnknownBudgets

IF 	OBJECT_ID('tempdb..#BudgetsWithUnknownActuals') IS NOT NULL
    DROP TABLE #BudgetsWithUnknownActuals

IF 	OBJECT_ID('tempdb..#AllUnknownBudgets') IS NOT NULL
    DROP TABLE #AllUnknownBudgets

IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
    DROP TABLE #BudgetsToProcess

IF 	OBJECT_ID('tempdb..#BudgetsToProcessToUpdate') IS NOT NULL
    DROP TABLE #BudgetsToProcessToUpdate
    
IF 	OBJECT_ID('tempdb..#ConsolidationRegionCorporateDepartment') IS NOT NULL
    DROP TABLE #ConsolidationRegionCorporateDepartment

GO

/*
4. dbo.stp_IU_LoadGrProfitabiltyPayrollOriginalBudget
*/ 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO

/*********************************************************************************************************************
Description
	This stored procedure processes payroll original budget data and uploads it to the
	ProfitabilityBudget table in the data warehouse (GrReporting.dbo.ProfitabilityBudget)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-07		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]	
	@DataPriorToDate	DateTime=NULL
AS
SET NOCOUNT ON
--DECLARE	@runId int
--EXEC @return_value = dbo.LogMessage 'Now that''s what I call a message!', 'stp_IU_LoadGrProfitabiltyPayrollOriginalBudget.#BEPADa', 1, @Time1, 900, True


PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollOriginalBudget'
PRINT '####'

-- Check whether the stored procedure should be run
DECLARE @StartTime DATETIME
DECLARE @StartTime2 DATETIME
DECLARE @RowCount INT
DECLARE @CanImportTapasBudget INT = (SELECT ConfiguredValue FROM [GrReportingStaging].[dbo].[SSISConfigurations] WHERE ConfigurationFilter = 'CanImportTapasBudget')
DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);



IF (@CanImportTapasBudget = 0)
BEGIN
	PRINT ('Import TapasBudget not scheduled in SSISConfigurations')
	RETURN
END

CREATE TABLE #BudgetsToProcess
(
	BudgetsToProcessId INT NOT NULL,
	BatchId INT NOT NULL,
	ImportBatchId INT NOT NULL,
	BudgetReforecastTypeName VARCHAR(50) NOT NULL,
	BudgetId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	ImportBudgetFromSourceSystem bit NOT NULL,
	IsReforecast bit NOT NULL,
	SnapshotId INT NOT NULL,
	ImportSnapshotFromSourceSystem BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	MustImportAllActualsIntoWarehouse BIT NULL,
	OriginalBudgetProcessedIntoWarehouse SMALLINT NULL,
	ReforecastActualsProcessedIntoWarehouse SMALLINT NULL,
	ReforecastBudgetsProcessedIntoWarehouse SMALLINT NULL,
	ReasonForFailure VARCHAR(512) NULL,
	DateBudgetProcessedIntoWarehouse DATETIME NULL,
	ReforecastKey INT NOT NULL
)

INSERT #BudgetsToProcess
SELECT 
	BudgetsToProcessId,
	CurrentBatchId,
	ImportBatchId,
	BudgetReforecastTypeName,
	BudgetId,
	BudgetExchangeRateId,
	BudgetReportGroupPeriodId,
	ImportBudgetFromSourceSystem,
	IsReforecast,
	SnapshotId,
	ImportSnapshotFromSourceSystem,
	InsertedDate,
	MustImportAllActualsIntoWarehouse,
	OriginalBudgetProcessedIntoWarehouse,
	ReforecastActualsProcessedIntoWarehouse,
	ReforecastBudgetsProcessedIntoWarehouse,
	ReasonForFailure,
	DateBudgetProcessedIntoWarehouse,
	RR.ReforecastKey
FROM 
	BudgetsToProcessCurrent('TGB Budget/Reforecast') BTPC
	
	INNER JOIN (	
		SELECT 
			MIN(ReforecastEffectiveMonth) AS ReforecastEffectiveMonth,
			ReforecastQuarterName,
			ReforecastEffectiveYear
		FROM 		 
			Grreporting.dbo.Reforecast 	
		GROUP BY
			ReforecastQuarterName,
			ReforecastEffectiveYear
	) CRR ON
	CRR.ReforecastEffectiveYear = BTPC.BudgetYear AND
	CRR.ReforecastQuarterName = BTPC.BudgetQuarter
	
	INNER JOIN Grreporting.dbo.Reforecast RR ON
		RR.ReforecastEffectiveMonth = CRR.ReforecastEffectiveMonth AND
		RR.ReforecastQuarterName = CRR.ReforecastQuarterName AND
		RR.ReforecastEffectiveYear = CRR.ReforecastEffectiveYear
		
WHERE 
	IsReforecast = 0

PRINT 'Completed inserting records into #BudgetsToProcess: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


IF NOT EXISTS (SELECT 1 FROM #BudgetsToProcess)
BEGIN
	PRINT ('*******************************************************')
	PRINT ('	stp_IU_LoadGrProfitabiltyPayrollOriginalBudget is quitting because there are no TAPAS budgets set to be imported.')
	PRINT ('*******************************************************')
	RETURN
END

-- finshed checks

IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'PayrollBudgetDataPriorToDate'))
END

--DECLARE	 @LastImportBatchId INT = (SELECT MAX(BatchId) FROM Batch WHERE PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND BatchEndDate IS NOT NULL)

/*
exec [stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)
INSERT INTO #SystemSettingRegion(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM
		TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
			ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM
				TapasGlobal.SystemSetting ss
				INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
					ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON
		ssr.SystemSettingId = ss.SystemSettingId
		
PRINT 'Completed getting system settings'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsGLMajorCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1
	
DECLARE 
	@GlAccountKey			 INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
	@SourceKey				 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@FunctionalDepartmentKey INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@ReimbursableKey		 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
	@ActivityTypeKey		 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@OverheadKey			 INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
    @LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')


DECLARE @BudgetReforecastTypeKey INT = (
	SELECT 
		BudgetReforecastTypeKey 
	FROM 
		GrReporting.dbo.BudgetReforecastType 
	WHERE 
		BudgetReforecastTypeCode = 'TGBBUD')



-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsGLMajorCategoryId = GLMajorCategoryId
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryName = 'Salaries/Taxes/Benefits'

print (@SalariesTaxesBenefitsGLMajorCategoryId)

--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Base Salary'

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Benefits'

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Bonus'

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryName = 'General Overhead'

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'External General Overhead'


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

CREATE TABLE #BudgetAllocationSetSnapshots(
	BudgetAllocationSetId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #BudgetAllocationSetSnapshots(
	BudgetAllocationSetId,
	SnapshotId
)
SELECT
	CAST(GroupKey AS INT),
	SnapshotId
FROM 
	Gdm.Snapshot
WHERE
	GroupName = 'BudgetAllocationSet'
	
SET @StartTime = GETDATE()

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for 'Map account categories' section
CREATE TABLE #GLAccountCategoryTranslations(
	SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsPayroll BIT NOT NULL,
	IsOverhead BIT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslations(
	SnapshotId,
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId,
	IsPayroll,
	IsOverhead
)
SELECT
	TST.SnapshotId,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId,
	CASE WHEN AST.Code LIKE '%PYR' THEN 1 ELSE 0 END IsPayroll,
	CASE WHEN AST.Code LIKE '%OHD' THEN 1 ELSE 0 END IsOverhead	
FROM
	Gdm.SnapshotGLTranslationSubType TST

	INNER JOIN Gdm.SnapshotGLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		TT.SnapshotId = TST.SnapshotId

	INNER JOIN Gdm.SnapshotGLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		TST.SnapshotId = AT.SnapshotId

	INNER JOIN Gdm.SnapshotGLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		TST.SnapshotId = AST.SnapshotId
	
WHERE	
	(AST.Code LIKE '%PYR' OR AST.Code LIKE '%OHD') AND
	TST.Code = 'GL' AND	
	AT.Code LIKE '%EXP' AND
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1


PRINT 'Completed inserting records into #GLAccountCategoryTranslations: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


CREATE TABLE #DistinctImports
(
	ImportBatchId INT NOT NULL
)
INSERT INTO #DistinctImports
SELECT DISTINCT
	ImportBatchId
FROM 
	#BudgetsToProcess BTP

SET @StartTime = GETDATE()


CREATE TABLE #Budget(	
	SnapshotId INT NOT NULL,
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,	
	CurrencyCode VARCHAR(3) NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriod	INT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	ReforecastKey INT NOT NULL
)

INSERT INTO #Budget(
	SnapshotId,	
	ImportKey,
	ImportBatchId,
	BudgetId,
	RegionId,	
	CurrencyCode,
	BudgetReportGroupId,
	BudgetReportGroupPeriod,
	GroupStartPeriod,
	GroupEndPeriod,
	ReforecastKey
	
)
SELECT 		
	btp.SnapshotId,
	Budget.ImportKey,
	Budget.ImportBatchId,
	Budget.BudgetId,
	Budget.RegionId,
	Budget.CurrencyCode,		
	brg.BudgetReportGroupId,
	brgp.Period AS BudgetReportGroupPeriod,
	brg.StartPeriod AS GroupStartPeriod,
	brg.EndPeriod AS GroupEndPeriod,
	BTP.ReforecastKey
FROM
	#BudgetsToProcess btp 
	
	INNER JOIN TapasGlobalBudgeting.Budget Budget ON
		Budget.BudgetId = btp.BudgetId AND
		Budget.ImportBatchId = btp.ImportBatchId

	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId AND
		Budget.ImportBatchId = brgd.ImportBatchId
		
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId AND
		brgd.ImportBatchId = brg.ImportBatchId	
	
	INNER JOIN Gdm.BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId
		
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey

PRINT 'Completed inserting records into #Budget: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (SnapshotId, BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


CREATE TABLE #GLAccountSubTypeIdBudgetMappings
(
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,	
	GLAccountSubTypeId INT NOT NULL,	
	IsPayroll BIT NOT NULL,
	IsOverhead BIT NOT NULL 
)
INSERT INTO #GLAccountSubTypeIdBudgetMappings
SELECT 
	B.SnapshotId, 
	BudgetId, 
	GLAccountSubTypeId, 
	IsPayroll, 
	IsOverhead
FROM 
	#GLAccountCategoryTranslations GLCTO	
	INNER JOIN #Budget B ON
		B.SnapshotId = GLCTO.SnapshotId
WHERE 
	GLTranslationSubTypeCode = 'GL'


SET @RowCount = @@ROWCOUNT

PRINT 'Completed inserting records into #GLAccountSubTypeIdBudgetMappings: '+CONVERT(char(10),@RowCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF (@RowCount = 0)
BEGIN
   RAISERROR('#GLAccountSubTypeIdBudgetMappings: NO Records inserted, please check there are rows in Gdm.SnapshotGLTranslationType for the Budgets in BudgetsToProcess', 16, -1)
   RETURN
END



--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------


SET @StartTime = GETDATE()

--/*
-- Source budget project
-- Get all the budget projects that are associated with the budgets that will be pulled, as per code above
CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	[Name] VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL, --“NonPayrollReimbursable” 
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)

INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	[Name],
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.* 
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId AND
		BudgetProject.ImportBatchId = b.ImportBatchId

PRINT 'Completed inserting records into #BudgetProject: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


CREATE CLUSTERED INDEX IX_ImportBatchId_BudgetID ON #BudgetProject (ImportBatchId, BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source region
SET @StartTime = GETDATE()

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	[Name],
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.* 
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT 'Completed inserting records into #Region: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Budget Employee
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	[Name] VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)

INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	[Name],
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId AND
		BudgetEmployee.ImportBatchId = b.ImportBatchId

PRINT 'Completed inserting records into #BudgetEmployee: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

PRINT 'Completed creating indexes on #BudgetEmployee'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Budget Employee Functional Department
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)

SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId AND
		efd.ImportBatchId = be.ImportBatchId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
CREATE INDEX IX_BudgetEmployeeFunctionalDepartment2 ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)


PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Location
SET @StartTime = GETDATE()

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)

PRINT 'Completed creating indexes on #Location'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source region extended
SET @StartTime = GETDATE()

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.* 
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)

PRINT 'Completed creating indexes on #RegionExtended'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- Source project
SET @StartTime = GETDATE()

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	[Name],
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

PRINT 'Completed creating indexes on #Project'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation


	INNER JOIN #DistinctImports DI ON
		Allocation.ImportBatchId = DI.ImportBatchId

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)

PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN #DistinctImports DI ON
		B2.ImportBatchId = DI.ImportBatchId
		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailBatches ON #BudgetEmployeePayrollAllocationDetailBatches (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetailBatches'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

----------
SET @StartTime = GETDATE()

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.ImportBatchId = B1.ImportBatchId AND
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId
		

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

SET @StartTime = GETDATE()

PRINT 'Completed inserting records into #BEPADa: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE INDEX IX_BEPADa1 ON #BEPADa (ImportKey)

PRINT 'Completed creating indexes on #BEPADa'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
    --data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		Allocation.ImportBatchId = TaxDetail.ImportBatchId AND
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId
		
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget tax type
SET @StartTime = GETDATE()

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId AND
		BudgetTaxType.ImportBatchId = b.ImportBatchId

PRINT 'Completed inserting records into #BudgetTaxType: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source tax type
SET @StartTime = GETDATE()

CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.* 
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = TaxType.ImportBatchId


PRINT 'Completed inserting records into #TaxType: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_TaxType ON #TaxType (ImportBatchId, TaxTypeId)

PRINT 'Completed creating indexes on #TaxType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- Classifies tax types into minor categories, see CASE statement; gets set here because it can be overwritten later in the stored procedure

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId AND
		Allocation.ImportBatchId = TaxDetail.ImportBatchId
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON -- rather pull through as unknown than exclude, therefore LEFT JOIN
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
		TaxDetail.ImportBatchId = BudgetTaxType.ImportBatchId
		
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
		BudgetTaxType.ImportBatchId = TaxType.ImportBatchId
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)

PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--*/
-- Source payroll overhead allocation
SET @StartTime = GETDATE()

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId AND
		OverheadAllocation.ImportBatchId = b.ImportBatchId

PRINT 'Completed inserting records into #BudgetOverheadAllocation: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source overhead allocation detail
SET @StartTime = GETDATE()

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail

	INNER JOIN #DistinctImports DI ON
		OverheadDetail.ImportBatchId = DI.ImportBatchId

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)


PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId, -- Hardcode to a specific minor category, could be changed later in the stored proc
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId AND
		OverheadAllocation.ImportBatchId = OverheadDetail.ImportBatchId
			
PRINT 'Completed inserting records into #OverheadAllocationDetail: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)


PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()

--Calculate effective functional department
-- What was the last period before an employee changed her functional department, finds all functional departments that an employee is associated with
CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	ISNULL((
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT
					Allocation2.ImportBatchId,
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.ImportBatchId = EFD.ImportBatchId AND
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
						
		
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					Allocation.ImportBatchId = Allocation2.ImportBatchId AND
					EFD.EffectivePeriod <= Allocation.Period
			  
				GROUP BY
					Allocation2.ImportBatchId,
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.ImportBatchId = EFDo.ImportBatchId AND
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND				
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ), -1) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.ImportBatchId = BudgetProject.ImportBatchId AND
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId 
		

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

PRINT 'Completed creating indexes on #EffectiveFunctionalDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))




SET @StartTime = GETDATE()

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	ImportBatchId INT NOT NULL,
	BudgetReforecastTypeKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode Varchar(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
-- links everything that we have pulled above (applying linking logic to tax, pre-tax and overhead data)
INSERT INTO #ProfitabilityPreTaxSource
(
	ImportBatchId,
	BudgetReforecastTypeKey,
	ReforecastKey,
	SnapshotId,
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.ImportBatchId,
	@BudgetReforecastTypeKey,
	Budget.ReforecastKey,
	Budget.SnapshotId,
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	--CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable, -- CC 4 :: GC
	CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
	BudgetProject.ActivityTypeId,
	Att.ActivityTypeCode,
	
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN -- which property fund are we looking at 
					ProjectPropertyFund.PropertyFundId -- fall back
				ELSE -- else it is not @ or null, so use the mapping below (joining property fund from department to source)
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId, -- else use -1, which is UNKNOWN
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
		
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					CASE WHEN GlobalRegion.IsConsolidationRegion = 1 THEN
						ProjectPropertyFund.AllocationSubRegionGlobalRegionId
					ELSE
						NULL
					END
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,	
			
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	Budget.BudgetReportGroupPeriod
	
FROM
	#BudgetEmployeePayrollAllocation Allocation -- tax amount

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId AND
		Allocation.ImportBatchId = BudgetProject.ImportBatchId				
			
	INNER JOIN #Budget Budget ON 
		BudgetProject.ImportBatchId = Budget.ImportBatchId AND
		BudgetProject.BudgetId = Budget.BudgetId
					
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN Gdm.SnapshotFunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId AND
		fd.SnapshotId = Budget.SnapshotId 

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = Budget.SnapshotId 
		
	LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
		ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
		GrSc.SourceCode = SourceRegion.SourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = Budget.SnapshotId  AND
						
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007	
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		RECD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 
				   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		REPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRCD.SourceCode = BudgetProject.CorporateSourceCode AND
		CRCD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRPE.SourceCode = BudgetProject.CorporateSourceCode AND
		CRPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON -- property fund could be coming from multiple sources
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN Gdm.SnapshotPayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId AND
		OriginatingRegion.SnapshotId = Budget.SnapshotId

	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = BudgetProject.ActivityTypeId AND
		Att.SnapshotId = Budget.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotCorporateDepartment Dept ON
		Dept.Code = BudgetProject.CorporateDepartmentCode AND 
		Dept.SourceCode = SourceRegion.SourceCode AND
		Dept.SnapshotId = Budget.SnapshotId

WHERE
	Allocation.Period BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod --AND
	--Change Control 1 : GC 2010-09-01
	--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)

PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--Map Tax Amounts
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityTaxSource
(
	ImportBatchId INT NOT NULL,
	BudgetReforecastTypeKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode Varchar(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL	
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	ImportBatchId,
	BudgetReforecastTypeKey,
	ReforecastKey,
	SnapshotId,
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT
	pts.ImportBatchId,
	pts.BudgetReforecastTypeKey,
	pts.ReforecastKey,
	pts.SnapshotId,
	pts.BudgetId,
	pts.BudgetRegionId,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.ActivityTypeCode,
	pts.PropertyFundId,
	pts.AllocationSubRegionGlobalRegionId,
	pts.ConsolidationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON -- pre tax has already been resolved, above, so join to limit taxdetail
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId


PRINT 'Completed inserting records into #ProfitabilityTaxSource: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_ProfitabilityTaxSource1 ON #ProfitabilityTaxSource (SalaryTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource2 ON #ProfitabilityTaxSource  (ProfitShareTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource3 ON #ProfitabilityTaxSource  (BonusTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource4 ON #ProfitabilityTaxSource  (BonusCapExcessTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource5 ON #ProfitabilityTaxSource  (BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



--Map Overhead Amounts
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityOverheadSource
(
	ImportBatchId INT NOT NULL,
	BudgetReforecastTypeKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	ImportBatchId,
	BudgetReforecastTypeKey,
	ReforecastKey,
	SnapshotId,
	BudgetId,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.ImportBatchId,
	@BudgetReforecastTypeKey,
	Budget.ReforecastKey,
	Budget.SnapshotId,
	Budget.BudgetId AS BudgetId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode,
	 
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE -- allocation region gets sourced from property fund, project region = allocation region
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(CASE
						WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
							ProjectPropertyFund.PropertyFundId
						ELSE
							DepartmentPropertyFund.PropertyFundId 
				   END, -1) 
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,	
			
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					CASE WHEN GlobalRegion.IsConsolidationRegion = 1 THEN
						ProjectPropertyFund.AllocationSubRegionGlobalRegionId
					ELSE
						NULL
					END
				ELSE
					CASE WHEN (GrScC.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,	
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON -- where overhead amount sits
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #Budget Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId AND
		BudgetProject.ImportBatchId = Budget.ImportBatchId		
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN Gdm.SnapshotFunctionalDepartment fd ON
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId AND
		fd.SnapshotId = Budget.SnapshotId 

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = Budget.SnapshotId 
		
	LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
		ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = Budget.SnapshotId AND
		
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDC ON
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDC.SourceCode = BudgetProject.CorporateSourceCode AND
		RECDC.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEC ON
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEC.SourceCode = BudgetProject.CorporateSourceCode AND
		REPEC.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPEC.IsDeleted = 0	
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRCD.SourceCode = BudgetProject.CorporateSourceCode AND
		CRCD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201101
		 
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRPE.SourceCode = BudgetProject.CorporateSourceCode AND
		CRPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = 'YES' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
		GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		opfm.SnapshotId = Budget.SnapshotId AND
		
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDO ON
		GrScO.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDO.SourceCode = BudgetProject.CorporateSourceCode AND
		RECDO.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEO ON
		GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEO.SourceCode = BudgetProject.CorporateSourceCode AND
		REPEO.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPEO.IsDeleted = 0	

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END AND
		OverheadPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN Gdm.SnapshotOverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId AND
		OriginatingRegion.SnapshotId = Budget.SnapshotId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_ProfitabilityOverheadSource1 ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

PRINT 'Completed creating indexes on #ProfitabilityOverheadSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()


CREATE TABLE #ProfitabilityPayrollMapping
(
	ImportBatchId INT NOT NULL,
	BudgetReforecastTypeKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	FeeOrExpense  Varchar(20) NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL,
	GLAccountSubTypeIdGlobal INT NOT NULL,
	GlobalGlAccountCode Varchar(10) NULL	
)

;WITH CTE_GetGLAccountOverheadSubIds
AS
(
	SELECT 
		  GLAccountSubTypeId,
		  BudgetId
	FROM
		#GLAccountSubTypeIdBudgetMappings 
	WHERE
		IsOverhead = 1
),
CTE_GetGLAccountPayrollSubIds
AS
(
	SELECT 
		  GLAccountSubTypeId,
		  BudgetId
	FROM
		#GLAccountSubTypeIdBudgetMappings 
	WHERE
		IsPayroll = 1
)

INSERT INTO #ProfitabilityPayrollMapping
(
	ImportBatchId,
	BudgetReforecastTypeKey,
	ReforecastKey,
	SnapshotId,
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	FeeOrExpense,
	ActivityTypeId,
	PropertyFundId,
	
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	GLAccountSubTypeIdGlobal,
	GlobalGlAccountCode
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps -- pull all pre-tax amounts that are not zero
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitSharePreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = pps.ActivityTypeId AND
		Att.SnapshotId = pps.SnapshotId
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = pps.ActivityTypeId AND
		Att.SnapshotId = pps.SnapshotId
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessPreTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN -- settings logic for bonus cap, override property fund
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
			
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					CASE WHEN GlobalRegion.IsConsolidationRegion = 1 THEN
						ProjectPropertyFund.AllocationSubRegionGlobalRegionId
					ELSE
						NULL
					END
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,	

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps	

	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = pps.ActivityTypeId AND
		Att.SnapshotId = pps.SnapshotId
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = pps.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
		ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = pps.SourceCode
		
	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = pps.SnapshotId AND
		--This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
		ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND --This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		RECD.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		REPE.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRCD.SourceCode = p.CorporateSourceCode AND
		CRCD.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRPE.SourceCode = p.CorporateSourceCode AND
		CRPE.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = pps.SnapshotId
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryTaxTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = pps.ActivityTypeId AND
		Att.SnapshotId = pps.SnapshotId
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitShareTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = pps.ActivityTypeId AND
		Att.SnapshotId = pps.SnapshotId
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.ImportBatchId,
	pps.BudgetReforecastTypeKey,
	pps.ReforecastKey,
	pps.SnapshotId,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,
		   
	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		   
			
		ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					CASE WHEN GlobalRegion.IsConsolidationRegion = 1 THEN
						ProjectPropertyFund.AllocationSubRegionGlobalRegionId
					ELSE
						NULL
					END
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,	

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pps.SnapshotId)
		ELSE (SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsPayroll = 1 AND SnapshotId = pps.SnapshotId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps	
		
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = pps.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
		GlobalRegion.GlobalRegionId = ProjectPropertyFund.AllocationSubRegionGlobalRegionId AND
		GlobalRegion.SnapshotId = pps.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON 
		GrSc.SourceCode = pps.SourceCode

	LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.SnapshotId = pps.SnapshotId AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		RECD.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		REPE.SnapshotId = pps.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0		
	
	LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END AND
		DepartmentPropertyFund.SnapshotId = pps.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRCD.SourceCode = p.CorporateSourceCode AND
		CRCD.SnapshotId = pps.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRPE.SourceCode = p.CorporateSourceCode AND
		CRPE.SnapshotId = pps.SnapshotId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.ImportBatchId,
	pos.BudgetReforecastTypeKey,
	pos.ReforecastKey,
	pos.SnapshotId,
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCode,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	'Overhead' FeeOrExpense,
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.ConsolidationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate,
	(SELECT GLAccountSubTypeId FROM #GLAccountCategoryTranslations WHERE IsOverhead = 1 AND SnapshotId = pos.SnapshotId),
	--General Allocated Overhead Account :: CC8
	'50029500'+RIGHT('0'+LTRIM(STR(pos.ActivityTypeId,3,0)),2)
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0


PRINT 'Completed inserting records into #ProfitabilityPayrollMapping: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityBudget(
	ImportBatchId INT NOT NULL,
	BudgetReforecastTypeKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	ConsolidationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL,
	SnapshotId INT NOT NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	ImportBatchId, 
	BudgetReforecastTypeKey,
	ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SnapshotId
)
SELECT
	pbm.ImportBatchId,
	pbm.BudgetReforecastTypeKey,
	pbm.ReforecastKey,
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') AS CalendarKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKey ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN Grcr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrCr.[AllocationRegionKey] END ConsolidationRegionRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKey ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	pbm.SnapshotId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		GrSc.SourceCode = pbm.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.Code = pbm.GlobalGlAccountCode AND --Gam.GlobalGlAccountId AND
		--pbm.AllocationUpdatedDate BETWEEN GrGa.StartDate AND GrGa.EndDate AND
		GrGa.SnapshotId = pbm.SnapshotId
		
	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
		--GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND --replaced by new logic below
		GrFdm.FunctionalDepartmentCode = pbm.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		--pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = pbm.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		--GC :: Change Control 1
		GrOh.OverheadCode = CASE WHEN pbm.FeeOrExpense = 'Overhead' THEN 'ALLOC' 
									WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' 
									ELSE 'UNKNOWN' END

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		--pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate AND
		GrPf.SnapshotId = pbm.SnapshotId

	LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		ASR.SnapshotId = pbm.SnapshotId 

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		--pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate AND
		GrAr.SnapshotId = pbm.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotConsolidationSubRegion CSR ON -- CC16
		pbm.ConsolidationSubRegionGlobalRegionId = CSR.ConsolidationSubRegionGlobalRegionId AND
		pbm.SnapshotId = CSR.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16
		CSR.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		GrCr.SnapshotId = pbm.SnapshotId
		
	LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = pbm.OriginatingRegionCode AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND 
		ORCE.SnapshotId = pbm.SnapshotId AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = pbm.OriginatingRegionCode AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.SnapshotId = pbm.SnapshotId AND
		ORPD.IsDeleted = 0		
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		--pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate AND
		GrOr.SnapshotId = pbm.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode

PRINT 'Completed inserting records into #ProfitabilityBudget: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityBudget (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey
SET @StartTime = GETDATE()

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)

SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			ACT.GLTranslationTypeId,
			ACT.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			ACT.GLAccountTypeId,
			ACT.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			Gl.SnapshotId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			LEFT OUTER JOIN #GLAccountCategoryTranslations ACT ON 
				ACT.GLAccountSubTypeId = Gl.GLAccountSubTypeIdGlobal AND
				ACT.SnapshotId = Gl.SnapshotId
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0))) AND
			--AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate AND
			GlAcGlobal.SnapshotId = Gl.SnapshotId

PRINT 'Completed inserting records into #GlobalCategoryLookup: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

PRINT 'Completed creating indexes on #GlobalCategoryLookup'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode



PRINT 'Completed converting all GlobalGlAccountCategoryKey keys: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


--=========================================================================================================================================
-- REGISTER UNKNOWNS
--=========================================================================================================================================
/****** Stash unknowns and remove budget groups from import ******/
SET @StartTime = GETDATE()

DELETE [dbo].[ProfitabilityBudgetUnknowns]
WHERE BudgetReforecastTypeKey IN (@BudgetReforecastTypeKey)

INSERT INTO [dbo].[ProfitabilityBudgetUnknowns]
(
   [ImportBatchId]
   ,[CalendarKey]
   ,[GlAccountKey]
   ,[SourceKey]
   ,[FunctionalDepartmentKey]
   ,[ReimbursableKey]
   ,[ActivityTypeKey]
   ,[PropertyFundKey]
   ,[AllocationRegionKey]
   ,[ConsolidationRegionKey] -- CC16
   ,[OriginatingRegionKey]
   ,[LocalCurrencyKey]
   ,[LocalBudget]
   ,[ReferenceCode]
   ,[EUCorporateGlAccountCategoryKey]
   ,[USPropertyGlAccountCategoryKey]
   ,[USFundGlAccountCategoryKey]
   ,[EUPropertyGlAccountCategoryKey]
   ,[USCorporateGlAccountCategoryKey]
   ,[DevelopmentGlAccountCategoryKey]
   ,[EUFundGlAccountCategoryKey]
   ,[GlobalGlAccountCategoryKey]
   ,[BudgetId]
   ,[OverheadKey]
   ,FeeAdjustmentKey,
	BudgetReforecastTypeKey,
	SnapshotId
   )
SELECT
	b.ImportBatchId,
	pb.CalendarKey,
	pb.GlAccountKey,
	pb.SourceKey,
	pb.FunctionalDepartmentKey,
	pb.ReimbursableKey,
	pb.ActivityTypeKey,
	pb.PropertyFundKey,
	pb.AllocationRegionKey,
	pb.ConsolidationRegionKey,
	pb.OriginatingRegionKey,
	pb.LocalCurrencyKey,
	pb.LocalBudget,
	pb.ReferenceCode,
	@EUCorporateGlAccountCategoryKeyUnknown,
	@USPropertyGlAccountCategoryKeyUnknown,	
	@USFundGlAccountCategoryKeyUnknown, 	
	@EUPropertyGlAccountCategoryKeyUnknown,
	@USCorporateGlAccountCategoryKeyUnknown, 
	@DevelopmentGlAccountCategoryKeyUnknown,
	@EUFundGlAccountCategoryKeyUnknown, 
	pb.GlobalGlAccountCategoryKey,	
	pb.BudgetId,
	pb.OverheadKey,
	(Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = 'NORMAL') AS FeeAdjustmentKey,	
	BudgetReforecastTypeKey,
	pb.SnapshotId	
	
FROM 
	#ProfitabilityBudget pb
	INNER JOIN #Budget b ON
		pb.BudgetId = b.BudgetId	
WHERE	
	@SourceKey = pb.SourceKey OR
	@FunctionalDepartmentKey = pb.FunctionalDepartmentKey OR
	@ReimbursableKey = pb.ReimbursableKey OR
	@ActivityTypeKey = pb.ActivityTypeKey OR
	@PropertyFundKey = pb.PropertyFundKey OR
	@AllocationRegionKey = pb.AllocationRegionKey OR
	@OriginatingRegionKey = pb.OriginatingRegionKey OR
	@LocalCurrencyKey = pb.LocalCurrencyKey

PRINT 'Completed inserting records into ProfitabilityBudgetUnknowns: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

/******* Remove rows from staging import batch which are associated with budgets with unknowns ******/
SET @StartTime = GETDATE()

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	[dbo].[ProfitabilityBudgetUnknowns]

SET @RowCount = @@ROWCOUNT
PRINT 'Completed inserting records into #DeletingBudget: ' + CONVERT(CHAR(10), @RowCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF @RowCount > 0 
BEGIN
	INSERT INTO @ImportErrorTable (Error) SELECT 'Unknowns found in budget'
END


--=========================================================================================================================================
-- DELETE UNKNOWNS
--=========================================================================================================================================

PRINT 'WARNING: DELETION OF UNKNOWNS COMMENTED OUT'
/*

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment x
INNER JOIN #BudgetEmployeeFunctionalDepartment xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetEmployee be ON
	be.BudgetEmployeeId = xh.BudgetEmployeeId AND
	be.ImportBatchId = xh.ImportBatchId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = be.BudgetId

PRINT 'Deleted from BudgetEmployeeFunctionalDepartment: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployee x
INNER JOIN #BudgetEmployee xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId

PRINT 'Deleted from BudgetEmployee: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail x
INNER JOIN #BudgetEmployeePayrollAllocationDetail xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetEmployeePayrollAllocation bpa ON
	bpa.BudgetEmployeePayrollAllocationId = xh.BudgetEmployeePayrollAllocationId
INNER JOIN #BudgetProject bp ON
	bp.BudgetProjectId = bpa.BudgetProjectId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = bp.BudgetId

PRINT 'Deleted from BudgetEmployeePayrollAllocationDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocation x
INNER JOIN #BudgetEmployeePayrollAllocation xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetProject bp ON
	bp.BudgetProjectId = xh.BudgetProjectId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = bp.BudgetId

PRINT 'Deleted from BudgetEmployeePayrollAllocation: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetOverheadAllocationDetail x
INNER JOIN #BudgetOverheadAllocationDetail xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #BudgetProject bp ON
	bp.BudgetProjectId = xh.BudgetProjectId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = bp.BudgetId

PRINT 'Deleted from BudgetOverheadAllocationDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetProject x
INNER JOIN #BudgetProject xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId
	
PRINT 'Deleted from BudgetProject: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetTaxType x
INNER JOIN #BudgetTaxType xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId

PRINT 'Deleted from BudgetTaxType: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.BudgetReportGroupDetail x
INNER JOIN #Budget b ON
	b.BudgetId = x.BudgetId AND
	b.ImportBatchId = x.ImportBatchId
INNER JOIN #DeletingBudget d ON
	d.BudgetId = b.BudgetId

PRINT 'Deleted from BudgetReportGroupDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

DELETE x
FROM TapasGlobalBudgeting.Budget x
INNER JOIN #Budget xh ON
	xh.ImportKey = x.ImportKey
INNER JOIN #DeletingBudget d ON
	d.BudgetId = xh.BudgetId

PRINT 'Deleted from Budget: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

/******* Remove rows from budgets in bugdet report groups in which there are budgets with unknowns ****/

SET @StartTime = GETDATE()


DELETE #ProfitabilityBudget
WHERE 
	BudgetId IN (
		SELECT DISTINCT BudgetId 
		FROM #Budget
		WHERE BudgetReportGroupId IN (
			SELECT DISTINCT BudgetReportGroupId
			FROM #Budget 
			WHERE BudgetId IN (
				SELECT DISTINCT BudgetId
				FROM [dbo].[ProfitabilityBudgetUnknowns]
			)			
		)
	)

PRINT 'Completed removing records from #ProfitabilityBudget: ' + CONVERT(CHAR(10), @@ROWCOUNT)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))




*/









-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #BudgetsToImportOriginal ( -- we keep an original copy of the budgets to insert because #BudgetsToImport will always be empty after the loop below
	BudgetId INT NOT NULL
)
INSERT INTO #BudgetsToImportOriginal
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityBudget

CREATE TABLE #BudgetsToImport (
	BudgetId INT NOT NULL
)
INSERT INTO #BudgetsToImport (
	BudgetId
)
SELECT
	BudgetId
FROM
	#BudgetsToImportOriginal


DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard

SET @StartTime = GETDATE()
DECLARE @TotalDeleteCount INT = 0

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #BudgetsToImport) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #BudgetsToImport)
	
	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	SET @StartTime2 = GETDATE()
	WHILE (@row > 0)
	BEGIN
			
			-- Remove old facts
			DELETE TOP (100000)
			FROM GrReporting.dbo.ProfitabilityBudget 
			WHERE 
				BudgetId = @BudgetId AND
				BudgetReforecastTypeKey in (@BudgetReforecastTypeKey)
			
			SET @row = @@rowcount
			SET @deleteCnt = @deleteCnt + @row
			SET @TotalDeleteCount = @TotalDeleteCount + @row
			
			PRINT '>>>: '+CONVERT(char(10),@row)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime2, GETDATE()), 121) + ' ms' + CHAR(13))
		
	END
	
	PRINT 'Rows deleted from ProfitabilityBudget for BudgetID (' + CONVERT(VARCHAR(10),@BudgetId) + ') FROM  ProfitabilityBudget:'+CONVERT(VARCHAR(10),@deleteCnt)		
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime2, GETDATE()), 121) + ' ms' + CHAR(13))

	DELETE
	FROM
		#BudgetsToImport
	WHERE
		BudgetId = @BudgetId
END
PRINT 'Completed deleting records from ProfitabilityBudget. Total Rows Deleted:'+CONVERT(varchar,@TotalDeleteCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	SnapshotId,
	BudgetReforecastTypeKey,
	ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT 
	SnapshotId,
	BudgetReforecastTypeKey,
	ReforecastKey,
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	(Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = 'NORMAL'),
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey

FROM 
	#ProfitabilityBudget

print 'Rows Inserted in ProfitabilityBudget: '+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))












-- ==============================================================================================================================================
-- Mark budgets as being successfully processed into the warehouse
-- ==============================================================================================================================================
DECLARE @ImportErrorText VARCHAR(500)
SELECT @ImportErrorText = COALESCE(@ImportErrorText + ', ', '') + Error from @ImportErrorTable

BEGIN TRY		

	SELECT
		BTP.BudgetsToProcessId,
		CASE WHEN BWUB.BudgetId IS NULL THEN 1 ELSE 0 END AS OriginalBudgetProcessedIntoWarehouse, -- 0 if import fails, 1 if import succeeds
		@ImportErrorText AS ReasonForFailure,
		GETDATE() AS DateBudgetProcessedIntoWarehouse-- date that the buget import either failed or succeeded (depending on 0 or 1 above)
	INTO 
		#BudgetsToProcessToUpdate
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcess BTPT ON
			BTP.BudgetsToProcessId = BTPT.BudgetsToProcessId	
		
		LEFT OUTER JOIN #DeletingBudget BWUB ON
			BTP.BudgetId = BWUB.BudgetId 

	UPDATE
		BTP
	SET
		BTP.OriginalBudgetProcessedIntoWarehouse = BTPTU.OriginalBudgetProcessedIntoWarehouse,
		BTP.ReasonForFailure = BTPTU.ReasonForFailure,
		BTP.DateBudgetProcessedIntoWarehouse = BTPTU.DateBudgetProcessedIntoWarehouse
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcessToUpdate BTPTU ON
			BTPTU.BudgetsToProcessId = BTP.BudgetsToProcessId
		
	PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10),@@rowcount))

END TRY
BEGIN CATCH
	
	SET @ImportErrorText = NULL
		SELECT @ImportErrorText =  
			COALESCE(@ImportErrorText + ', ', '') + 
			'BudgetsToProcessId:'+ LTRIM(STR(BTPTU.BudgetsToProcessId)) + 
			' ReforecastBudgetsProcessedIntoWarehouse:' + LTRIM(STR(BTPTU.ReforecastBudgetsProcessedIntoWarehouse))  +
			' ReforecastActualsProcessedIntoWarehouse:' + LTRIM(STR(BTPTU.ReforecastActualsProcessedIntoWarehouse))  +
			' ReasonForFailure:' + ReasonForFailure +
			' DateBudgetProcessedIntoWarehouse:' + CONVERT(VARCHAR(27), BTPTU.DateBudgetProcessedIntoWarehouse)
			
		from #BudgetsToProcessToUpdate BTPTU

	PRINT 'Error updating budgets to pricess, The Values were:'
	PRINT @ImportErrorText
	
	
    DECLARE @ErrorSeverity  INT = ERROR_SEVERITY(), @ErrorMessage NVARCHAR(4000) =
		'Error updating BudgetsToProcess: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 	
    RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
END CATCH





-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()
IF OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
	DROP TABLE #BudgetsToProcess
IF OBJECT_ID('tempdb..#SystemSettingRegion') IS NOT NULL
	DROP TABLE #SystemSettingRegion
IF OBJECT_ID('tempdb..#BudgetAllocationSetSnapshots') IS NOT NULL
	DROP TABLE #BudgetAllocationSetSnapshots
IF OBJECT_ID('tempdb..#GLAccountCategoryTranslations') IS NOT NULL
	DROP TABLE #GLAccountCategoryTranslations
IF OBJECT_ID('tempdb..#Budget') IS NOT NULL
	DROP TABLE #Budget
IF OBJECT_ID('tempdb..#BudgetProject') IS NOT NULL
	DROP TABLE #BudgetProject
IF OBJECT_ID('tempdb..#Region') IS NOT NULL
	DROP TABLE #Region
IF OBJECT_ID('tempdb..#BudgetEmployee') IS NOT NULL
	DROP TABLE #BudgetEmployee
IF OBJECT_ID('tempdb..#BudgetEmployeeFunctionalDepartment') IS NOT NULL
	DROP TABLE #BudgetEmployeeFunctionalDepartment
IF OBJECT_ID('tempdb..#Location') IS NOT NULL
	DROP TABLE #Location
IF OBJECT_ID('tempdb..#RegionExtended') IS NOT NULL
	DROP TABLE #RegionExtended
IF OBJECT_ID('tempdb..#Project') IS NOT NULL
	DROP TABLE #Project
IF OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocation') IS NOT NULL
	DROP TABLE #BudgetEmployeePayrollAllocation
IF OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocationDetailBatches') IS NOT NULL
	DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
IF OBJECT_ID('tempdb..#BEPADa') IS NOT NULL
	DROP TABLE #BEPADa
IF OBJECT_ID('tempdb..#BudgetEmployeePayrollAllocationDetail') IS NOT NULL
	DROP TABLE #BudgetEmployeePayrollAllocationDetail
IF OBJECT_ID('tempdb..#BudgetTaxType') IS NOT NULL
	DROP TABLE #BudgetTaxType
IF OBJECT_ID('tempdb..#TaxType') IS NOT NULL
	DROP TABLE #TaxType
IF OBJECT_ID('tempdb..#EmployeePayrollAllocationDetail') IS NOT NULL
	DROP TABLE #EmployeePayrollAllocationDetail
IF OBJECT_ID('tempdb..#BudgetOverheadAllocation') IS NOT NULL
	DROP TABLE #BudgetOverheadAllocation
IF OBJECT_ID('tempdb..#BudgetOverheadAllocationDetail') IS NOT NULL
	DROP TABLE #BudgetOverheadAllocationDetail
IF OBJECT_ID('tempdb..#OverheadAllocationDetail') IS NOT NULL
	DROP TABLE #OverheadAllocationDetail
IF OBJECT_ID('tempdb..#EffectiveFunctionalDepartment') IS NOT NULL
	DROP TABLE #EffectiveFunctionalDepartment
IF OBJECT_ID('tempdb..#ProfitabilityPreTaxSource') IS NOT NULL
	DROP TABLE #ProfitabilityPreTaxSource
IF OBJECT_ID('tempdb..#ProfitabilityTaxSource') IS NOT NULL
	DROP TABLE #ProfitabilityTaxSource
IF OBJECT_ID('tempdb..#ProfitabilityOverheadSource') IS NOT NULL
	DROP TABLE #ProfitabilityOverheadSource
IF OBJECT_ID('tempdb..#ProfitabilityPayrollMapping') IS NOT NULL
	DROP TABLE #ProfitabilityPayrollMapping
IF OBJECT_ID('tempdb..#ProfitabilityBudget') IS NOT NULL
	DROP TABLE #ProfitabilityBudget
IF OBJECT_ID('tempdb..#DeletingBudget') IS NOT NULL
	DROP TABLE #DeletingBudget
IF OBJECT_ID('tempdb..#BudgetsToImportOriginal') IS NOT NULL
	DROP TABLE #BudgetsToImportOriginal
IF OBJECT_ID('tempdb..#GlobalCategoryLookup') IS NOT NULL
	DROP TABLE #GlobalCategoryLookup
IF OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL
	DROP TABLE #BudgetsToProcess
IF OBJECT_ID('tempdb..#DistinctImports') IS NOT NULL
	DROP TABLE #DistinctImports
IF OBJECT_ID('tempdb..#GLAccountSubTypeIdBudgetMappings') IS NOT NULL
	DROP TABLE #GLAccountSubTypeIdBudgetMappings
GO
/*
5. dbo.stp_IU_LoadGrProfitabiltyPayrollReforecast
*/ 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_IU_LoadGrProfitabiltyPayrollReforecast') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.stp_IU_LoadGrProfitabiltyPayrollReforecast
GO

/*********************************************************************************************************************
Description
	This stored procedure processes payroll reforecast data and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
AS

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollReforecast'
PRINT '####'

SET NOCOUNT ON

DECLARE @RowCount INT


DECLARE @StartTime DATETIME
DECLARE @DebugMode BIT = 1 --- Running some extra test queries for debugging purposes. Start comment DEBUG MODE for search and check this variable.



DECLARE @DataPriorToDate DATETIME=NULL
IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'PayrollBudgetDataPriorToDate'))
END

DECLARE @CanImportTapasReforecast INT = (SELECT ConfiguredValue FROM [GrReportingStaging].[dbo].[SSISConfigurations] WHERE ConfigurationFilter = 'CanImportTAPASReforecast')

IF (@CanImportTapasReforecast <> 1)
BEGIN
	PRINT ('Import of TAPAS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations')
	RETURN
END
	
--DECLARE @SourceSystemName varchar(50) = 'Tapas Budgeting'
--DECLARE @SourceSystemNameGBS varchar(50) = 'Global Budgeting System'
DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
	
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsMajorGlAccountCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1

DECLARE 
	@GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@OverheadKeyUnknown				INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
    @LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode =  'UNK' )

IF @LocalCurrencyKeyUnknown IS NULL
BEGIN
	PRINT '@LocalCurrencyKeyUnknown is null. No unknown currency key found'
	RETURN
END    
   
DECLARE @ReforecastTypeIsTGBBUDKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType where BudgetReforecastTypeCode = 'TGBBUD')
DECLARE @ReforecastTypeIsTGBACTKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType where BudgetReforecastTypeCode = 'TGBACT')
	
DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);
	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsMajorGlAccountCategoryId = GLMajorCategoryId
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryName = 'Salaries/Taxes/Benefits'

print (@SalariesTaxesBenefitsMajorGlAccountCategoryId)
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Base Salary'

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits'

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Bonus'

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryName = 'General Overhead'

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetSnapshotGlobalGlAccountCategoryTranslation()
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'External General Overhead'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--
-- Setup Bonus Cap Excess Project Setting
--

-- ==============================================================================================================================================
-- Get Budgets to Process
-- ==============================================================================================================================================

SELECT 
	BTPC.*,
	CRR.ReforecastKey
INTO 
	#BudgetsToProcess 
FROM 
	dbo.BudgetsToProcessCurrent('TGB Budget/Reforecast') BTPC
	INNER JOIN GrReporting.dbo.GetCurrentReforecastRecord() CRR ON
		BTPC.BudgetYear = CRR.ReforecastEffectiveYear AND
		BTPC.BudgetQuarter = CRR.ReforecastQuarterName	
WHERE 
	IsReforecast = 1

DECLARE @BTPRowCount INT = @@rowcount

PRINT ('Rows inserted into #BudgetsToProcess: ' + CONVERT(VARCHAR(10),@BTPRowCount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF (@BTPRowCount = 0)
BEGIN
	PRINT ('*******************************************************')
	PRINT ('	stp_IU_LoadGrProfitabiltyPayrollReforecast is quitting because BudgetsToProcess returned no budgets to import.')
	PRINT ('*******************************************************')
	RETURN
END

-- ==============================================================================================================================================
-- Get Budgets
-- ==============================================================================================================================================



SET @StartTime = GETDATE()

SELECT 
	B.ImportBatchId,
	B.BudgetId,
	B.BudgetReportGroupPeriodId
INTO
	#LastImportedGBSBudgets
FROM
	GBS.Budget B
	INNER JOIN (
		SELECT 
			MAX(ImportBatchId) AS ImportBatchId
		FROM
			GBS.Budget
		WHERE 
			IsReforecast = 1
		) MB ON
		MB.ImportBatchId = B.ImportBatchId


SET @RowCount = @@ROWCOUNT
PRINT 'Completed inserting records into #LastImportedGBSBudgets:'+CONVERT(char(10),@RowCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
IF (@RowCount = 0)
BEGIN
	PRINT 'WARNING: No GBS budgets found, so no actuals will be imported'
END

SET @StartTime = GETDATE()

--DECLARE @TempGBSImportBatchId INT = (SELECT MAX(BatchId) FROM dbo.Batch WHERE PackageName = 'ETL.Staging.GBS')

CREATE TABLE #NewBudgets(
	ImportBatchId INT NOT NULL,
	ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	GBSBudgetId INT NULL, -- CAN BE NULL IN WHICH CASE NO ACTUALS WILL BE IMPORTED
	MustImportAllActualsIntoWarehouse BIT NOT NULL,
	ReforecastKey INT NOT NULL,
	BudgetReportGroupId INT NOT NULL
)
INSERT INTO #NewBudgets(
	ImportBatchId,
	ImportKey,
	SnapshotId,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	[Name],
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate,
	BudgetReportGroupPeriodId,
	BudgetReportGroupPeriod,
	GroupEndPeriod,
	GBSBudgetId,
	MustImportAllActualsIntoWarehouse,
	ReforecastKey,
	BudgetReportGroupId
)
SELECT 
	BTP.ImportBatchId,
	Budget.ImportKey,
	BTP.SnapshotId AS SnapshotId,	
	Budget.BudgetId, 
	Budget.RegionId,
	Budget.BudgetTypeId,
	Budget.BudgetStatusId,
	Budget.Name,
	Budget.StartPeriod,
	Budget.EndPeriod,
	Budget.FirstProjectedPeriod,
	Budget.CurrencyCode,
	Budget.CanEmployeesViewBudget,
	Budget.IsReforecast,
	Budget.IsDeleted,
	Budget.InsertedDate,
	Budget.UpdatedDate,
	Budget.UpdatedByStaffId,
	Budget.LastLockedDate,
	Budget.BudgetAllocationSetId,
	Budget.LastAMUpdateDate,
    brg.BudgetReportGroupPeriodId,
    brgp.Period AS BudgetReportGroupPeriod,
    brg.EndPeriod AS GroupEndPeriod,
    GBSBudget.BudgetId AS GBSBudgetId,
    BTP.MustImportAllActualsIntoWarehouse,
    BTP.ReforecastKey, 
    BRGD.BudgetReportGroupId
FROM
	TapasGlobalBudgeting.Budget Budget
		
	INNER JOIN #BudgetsToProcess BTP ON -- All TAPAS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
		Budget.BudgetId = BTP.BudgetId AND
		Budget.ImportBatchId = BTP.ImportBatchId
			
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail BRGD ON
		Budget.BudgetId = brgd.BudgetId AND
		BRGD.ImportBatchId = BTP.ImportBatchId
		
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId	 AND
		BRG.ImportBatchId = BTP.ImportBatchId
		
	INNER JOIN Gdm.BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId
		
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
				   
	LEFT OUTER JOIN #LastImportedGBSBudgets LIGB ON
		LIGB.BudgetReportGroupPeriodId = BRG.BudgetReportGroupPeriodId

	LEFT OUTER JOIN GBS.Budget GBSBudget ON
	   GBSBudget.BudgetReportGroupPeriodId = LIGB.BudgetReportGroupPeriodId AND
	   GBSBudget.BudgetId = LIGB.BudgetId AND
	   GBSBudget.ImportBatchId = LIGB.ImportBatchId
		
DECLARE @NumberOfBudgets INT = @@rowcount
		
PRINT 'Completed inserting records into #NewBudgets:'+CONVERT(char(10),@NumberOfBudgets)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

IF @NumberOfBudgets = 0 BEGIN
	PRINT '#NewBudgets: Found NO Budgets to import. Nothing to do. Quitting...'
	--PRINT 'GBSBudget ImportID: ' + STR(LTRIM(@TempGBSImportBatchId))
	RETURN
END

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetID ON #newBudgets (SnapshotId, BudgetId)

PRINT 'Completed creating indexes on #Budget'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


----------------------------------------------------------------------------------------------
-- Source the GBS Budget
SET @StartTime = GETDATE()

;WITH CteDistinctTapasBudgets
AS
(
   SELECT 
        B.SnapshotId, 
		B.GBSBudgetId AS BudgetId, 
		B.FirstProjectedPeriod,
		B.MustImportAllActualsIntoWarehouse,
		B.ReforecastKey
	FROM 
		#NewBudgets B
		INNER JOIN 
			(	
				SELECT 
					MIN(BudgetId) AS BudgetId,
					MIN(SnapshotId) AS SnapshotId
				FROM 
					#NewBudgets 
				WHERE
					MustImportAllActualsIntoWarehouse = 1
				GROUP BY
					GBSBudgetId, 
					SnapshotId  
			) DB ON
			DB.BudgetId = B.BudgetId AND
			DB.SnapshotId = B.SnapshotId 	   
)
SELECT 
	LIGB.ImportBatchId,
	TB.SnapshotId as SnapshotId, 
	TB.BudgetId as TapasBudgetId,
    TB.FirstProjectedPeriod as FirstProjectedPeriod,	
    TB.MustImportAllActualsIntoWarehouse,
    TB.ReforecastKey,
	GB.BudgetId AS BudgetId,
	GB.ImportKey
INTO 
	#GBSBudgets 
FROM
	GBS.Budget GB
	INNER JOIN CteDistinctTapasBudgets TB ON
		TB.BudgetId = GB.BudgetId 
		
	INNER JOIN #LastImportedGBSBudgets LIGB ON
		LIGB.ImportBatchId = GB.ImportBatchId AND
		LIGB.BudgetReportGroupPeriodId = GB.BudgetReportGroupPeriodId AND
		LIGB.BudgetId = GB.BudgetId		
		
--WHERE 
--	GB.ImportBatchId = @TempGBSImportBatchId				
		
PRINT 'Completed inserting records into #GBSBudgets:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

BEGIN TRY		
	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GBSBudgets (SnapshotId, BudgetId, FirstProjectedPeriod)
	PRINT 'Completed creating indexes on #GBSBudgets'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END TRY
BEGIN CATCH
    DECLARE @ErrorSeverity  INT = ERROR_SEVERITY(), @ErrorMessage   NVARCHAR(4000) =
		'Error creating indexes on #GBSBudgets: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ':' + ERROR_MESSAGE() 
	SELECT * FROM #GBSBudgets
    RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
END CATCH

----------------------------------------------------------------------------------------------
-- DISTINCT Snapshots
----------------------------------------------------------------------------------------------
-- Source the Distinct snapshots

SELECT DISTINCT 
	SnapshotId 
INTO 
	#DistinctSnapshots 
FROM 
	#NewBudgets
	
SELECT DISTINCT
	ImportBatchId
INTO
	#DistinctImports
FROM 
	#BudgetsToProcess BTP

----------------------------------------------------------------------------------------------
-- All combined Budgets GBS + Tapas
----------------------------------------------------------------------------------------------

SELECT 
	SnapshotId, 
	BudgetId,
	ImportKey
INTO
	#AllBudgets	
FROM
	#NewBudgets
UNION ALL 
SELECT 
	SnapshotId, 
	BudgetId,
	ImportKey 
FROM
	#GBSBudgets

--SELECT * FROM #AllBudgets

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)

SET @StartTime = GETDATE()

-- #GLTranslationType
CREATE TABLE #SnapshotGLTranslationType(
	SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLTranslationType(
	SnapshotId,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.SnapshotGLTranslationType TT 
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = TT.SnapshotId

PRINT 'Completed inserting records into #SnapshotGLTranslationType:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE TABLE #SnapshotGLAccountType(
	SnapshotId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #SystemSettingRegion
SET @StartTime = GETDATE()

INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(
		SELECT 
			ssr.* 
		FROM
			TapasGlobal.SystemSettingRegion ssr
			INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
				ssr.ImportKey = ssrA.ImportKey
	 ) ssr

	INNER JOIN
		(
			SELECT
				ss.SystemSettingId,
				ss.Name
			FROM
			(
				SELECT	
					ss.*
				FROM
					TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
						ss.ImportKey = ssA.ImportKey
			 ) ss
		) ss ON ssr.SystemSettingId = ss.SystemSettingId

PRINT 'Completed inserting #SystemSettingRegion'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

-- #GLTranslationSubType
CREATE TABLE #SnapshotGLTranslationSubType(
	SnapshotId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)
INSERT INTO #SnapshotGLTranslationSubType(
	SnapshotId,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	DS.SnapshotId,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.SnapshotGLTranslationSubType TST
	INNER JOIN #DistinctSnapshots DS ON
	  TST.SnapshotId = DS.SnapshotId
WHERE
    TST.Code = 'GL'	  AND
    TST.IsActive = 1

SET @RowCount = @@ROWCOUNT
IF @RowCount = 0
BEGIN
	RAISERROR('#SnapshotGLTranslationSubType: NO Records inserted, please check there are rows in Gdm.SnapshotGLTranslationSubType for the Snapshots in BudgetsToProcess', 16, -1)
	RETURN
END

PRINT 'Completed inserting records to #SnapshotGLTranslationSubType:'+CONVERT(char(10),@RowCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE INDEX IX_SnapshotGLTranslationSubType1 ON #SnapshotGLTranslationSubType (SnapshotId)

PRINT 'Completed creating indexes on #SnapshotGLTranslationSubType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLGlobalAccount(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NOT NULL,
	ParentGLGlobalAccountId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] NVARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	ExpenseCzarStaffId INT NOT NULL,
	ParentCode AS (left(Code,(8))),
	SnapshotId INT NOT NULL
)
INSERT INTO #SnapshotGLGlobalAccount (
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	ParentGLGlobalAccountId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	ExpenseCzarStaffId,
	SnapshotId
)
SELECT
	GLGA.GLGlobalAccountId,
	GLGA.ActivityTypeId,
	GLGA.GLStatutoryTypeId,
	GLGA.ParentGLGlobalAccountId,
	GLGA.Code,
	GLGA.Name,
	GLGA.[Description],
	GLGA.IsGR,
	GLGA.IsGbs,
	GLGA.IsRegionalOverheadCost,
	GLGA.ExpenseCzarStaffId,
	GLGA.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccount GLGA
	INNER JOIN #DistinctSnapshots DS ON
		GLGA.SnapshotId = DS.SnapshotId
WHERE
	GLGA.IsActive = 1

PRINT ('Rows inserted into #SnapshotGLGlobalAccount: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))	

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLGlobalAccount1 ON #SnapshotGLGlobalAccount (SnapshotId, GLGlobalAccountId)

PRINT 'Completed creating indexes on #SnapshotGLGlobalAccount'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



-- AllocationSubRegion --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotAllocationSubRegion (
	SnapshotId int NOT NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	Code varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	AllocationRegionGlobalRegionId int NULL,
	DefaultCorporateSourceCode char(2) NOT NULL
)
INSERT INTO #SnapshotAllocationSubRegion
SELECT
	ASR.SnapshotId,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.Name,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCorporateSourceCode
FROM
	Gdm.SnapshotAllocationSubRegion ASR
	INNER JOIN #DistinctSnapshots DS ON
		ASR.SnapshotId = DS.SnapshotId
WHERE
	ASR.IsActive = 1

PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ConsolidationSubRegion --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotConsolidationSubRegion (
	SnapshotId int NOT NULL,
	ConsolidationSubRegionGlobalRegionId int NOT NULL,
	ConsolidationSubRegionGlobalRegionCode varchar(10) NOT NULL,
	[Name] varchar(50) NOT NULL,
	AllocationRegionGlobalRegionId int NULL,
	DefaultCorporateSourceCode char(2) NOT NULL
)
INSERT INTO #SnapshotConsolidationSubRegion
SELECT
	CSR.SnapshotId,
	CSR.ConsolidationSubRegionGlobalRegionId,
	CSR.ConsolidationSubRegionGlobalRegionCode,
	CSR.Name,
	CSR.ConsolidationRegionGlobalRegionId,
	CSR.DefaultCorporateSourceCode
FROM
	Gdm.SnapshotConsolidationSubRegion CSR
	INNER JOIN #DistinctSnapshots DS ON
		CSR.SnapshotId = DS.SnapshotId
WHERE
	CSR.IsActive = 1

PRINT ('Rows inserted into #AllocationSubRegion: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- #GLMajorCategory

CREATE TABLE #SnapshotGLMajorCategory(
	SnapshotId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLMajorCategory(
	SnapshotId,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.SnapshotGLMajorCategory MajC
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = MajC.SnapshotId


PRINT ('Rows inserted into #SnapshotGLMajorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLMajorCategory ON #SnapshotGLMajorCategory (SnapshotId, GLMajorCategoryId)

PRINT 'Completed creating indexes on #SnapshotGLMajorCategory'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- #GLMinorCategory

CREATE TABLE #SnapshotGLMinorCategory(
	SnapshotId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLMinorCategory(
	SnapshotId,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.SnapshotGLMinorCategory MinC
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = MinC.SnapshotId
		
PRINT ('Rows inserted into #SnapshotGLMinorCategory: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
		
SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_SnapshotGLMinorCategory1 ON #SnapshotGLMinorCategory (SnapshotId, GLMinorCategoryId)

PRINT 'Completed creating indexes on #SnapshotGLMinorCategory'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
		
-- #GLAccountType
SET @StartTime = GETDATE()

INSERT INTO #SnapshotGLAccountType(
	SnapshotId,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.SnapshotGLAccountType AT
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = AT.SnapshotId

PRINT ('Rows inserted into #SnapshotGLAccountType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
-- #GLAccountSubType

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLAccountSubType(
	SnapshotId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
INSERT INTO #SnapshotGLAccountSubType(
	SnapshotId,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	DS.SnapshotId,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.SnapshotGLAccountSubType AST
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = AST.SnapshotId

PRINT ('Rows inserted into #SnapshotGLAccountSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLGlobalAccount --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLGlobalAccountTranslationSubType (
	SnapshotId INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL
)
INSERT INTO #SnapshotGLGlobalAccountTranslationSubType
SELECT
	GATST.SnapshotId,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationSubType GATST
	INNER JOIN #DistinctSnapshots B ON
		GATST.SnapshotId = B.SnapshotId
WHERE
	GATST.IsActive = 1

PRINT ('Rows inserted into #SnapshotGLGlobalAccountTranslationSubType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- GLGlobalAccountTranslationType --------------------------------------------------

CREATE INDEX IX_SnapshotGLGlobalAccountTranslationSubType1 ON #SnapshotGLGlobalAccountTranslationSubType (GLGlobalAccountId, SnapshotId)

PRINT 'Completed creating indexes on #SnapshotGLGlobalAccountTranslationSubType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLGlobalAccountTranslationType(
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	SnapshotId INT NOT NULL
)

INSERT INTO #SnapshotGLGlobalAccountTranslationType
SELECT
	GATT.GLGlobalAccountTranslationTypeId, 
	GATT.GLGlobalAccountId, 
	GATT.GLTranslationTypeId, 
	GATT.GLAccountTypeId,	
	CASE WHEN
			GA.ActivityTypeId = 99
		 THEN 
				-- GC :: CC1 >>
				-- Unallocated overhead expenses will be grouped under the “Overhead” expense 
				-- type and not “Non-Payroll”. This will be based on the activity of the 
				-- transaction; all transactions that have a corporate overhead activity 
				-- will have an expense type of “Overhead”.
			
			AST.GLAccountSubTypeId
			
				--(
				--	SELECT
				--		*--GST.GLAccountSubTypeId 
				--	FROM
				--		Gdm.SnapshotGLAccountSubType GST 
				--		INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
				--			GTT.GLTranslationTypeId = GST.GLTranslationTypeId
				--		INNER JOIN #Budget B ON
				--			GST.SnapshotId = B.SnapshotId AND
				--			GTT.SnapshotId = B.SnapshotId
				--	WHERE
				--		GTT.Code = 'GL' AND
				--		GST.Code = 'GRPOHD'	AND
				--		GST.IsActive = 1 AND
				--		GTT.IsActive = 1
				--)				
		 ELSE
			GATT.GLAccountSubTypeId
	END AS GLAccountSubTypeId,
	GATT.SnapshotId
FROM
	Gdm.SnapshotGLGlobalAccountTranslationType GATT
	
	INNER JOIN #GBSBudgets DS ON
		GATT.SnapshotId = DS.SnapshotId	

	LEFT OUTER JOIN (
						SELECT
							GA.*
						FROM
							#SnapshotGLGlobalAccount GA

					 ) GA ON
							GA.GLGlobalAccountId = GATT.GLGlobalAccountId AND
							GA.SnapshotId = GATT.SnapshotId

	LEFT OUTER JOIN (
						SELECT
							GST.GLAccountSubTypeId,
							B.BudgetId,
							GST.SnapshotId
						FROM
							Gdm.SnapshotGLAccountSubType GST 
							INNER JOIN Gdm.SnapshotGLTranslationType GTT ON
								GTT.GLTranslationTypeId = GST.GLTranslationTypeId
							INNER JOIN #GBSBudgets B ON
								GST.SnapshotId = B.SnapshotId AND
								GTT.SnapshotId = B.SnapshotId 
						WHERE
							GTT.Code = 'GL' AND
							GST.Code = 'GRPOHD'	AND
							GST.IsActive = 1 AND
							GTT.IsActive = 1
					) AST ON
							GATT.SnapshotId = AST.SnapshotId AND
							DS.BudgetId = AST.BudgetId

WHERE
	GATT.IsActive = 1

PRINT ('Rows inserted into #GLGlobalAccountTranslationType: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------
-- Master GL Account Category mapping table GBS
------------------------------------------------------------------------------
SET @StartTime = GETDATE()

CREATE TABLE #GLAccountCategoryMapping (
	SnapshotId INT NOT NULL,
	GLAccountKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)
INSERT INTO #GLAccountCategoryMapping
SELECT
	DS.SnapshotId,
	Gla.GlAccountKey,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	MinC.GLMajorCategoryId,
	GLATST.GLMinorCategoryId,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId
FROM
	#DistinctSnapshots DS

	INNER JOIN #SnapshotGLTranslationSubType TST ON
		DS.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLGlobalAccountTranslationSubType GLATST ON
		TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
		DS.SnapshotId = GLATST.SnapshotId
	
	INNER JOIN #SnapshotGLGlobalAccountTranslationType GLATT ON
		GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
		TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
		DS.SnapshotId = GLATT.SnapshotId

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId AND
		DS.SnapshotId = GLA.SnapshotId

	INNER JOIN #SnapshotGLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		DS.SnapshotId = MinC.SnapshotId

	INNER JOIN #SnapshotGLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		DS.SnapshotId = MajC.SnapshotId

PRINT ('Rows inserted into #GLAccountCategoryMapping: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for 'Map account categories' section

CREATE TABLE #SnapshotGLAccountCategoryTranslationsPayroll(
	SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #SnapshotGLAccountCategoryTranslationsPayroll(
	SnapshotId,
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
    TST.SnapshotId,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#SnapshotGLTranslationSubType TST

	INNER JOIN #SnapshotGLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		TST.SnapshotId = TT.SnapshotId

	INNER JOIN #SnapshotGLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1 AND
		AT.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1 AND
		AST.SnapshotId = TST.SnapshotId
	
WHERE
	AST.Code LIKE '%PYR' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed inserting records to #SnapshotGLAccountCategoryTranslationsPayroll:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotGLAccountCategoryTranslationsOverhead(
    SnapshotId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #SnapshotGLAccountCategoryTranslationsOverhead(
	SnapshotId,
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
    TST.SnapshotId,
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#SnapshotGLTranslationSubType TST

	INNER JOIN #SnapshotGLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		TT.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1 AND
		AT.SnapshotId = TST.SnapshotId

	INNER JOIN #SnapshotGLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1 AND
		AST.SnapshotId = TST.SnapshotId
	
WHERE
	AST.Code LIKE '%OHD' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed inserting records to #SnapshotGLAccountCategoryTranslationsOverhead:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source tax type
SET @StartTime = GETDATE()


CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.*
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = TaxType.ImportBatchId
	
	
PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_TaxType ON #TaxType (ImportBatchId, TaxTypeId)

PRINT 'Completed creating indexes on #TaxType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- Source budget report group detail. 

SET @StartTime = GETDATE()

CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd

	INNER JOIN #BudgetsToProcess BTP ON
		BRGD.ImportBatchId = BTP.ImportBatchId AND
		BRGD.BudgetId = BTP.BudgetId
	
--select * from #BudgetReportGroupDetail
		
PRINT 'Completed inserting records into #BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget report group.
SET @StartTime = GETDATE()

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	[Name],
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN #BudgetsToProcess BTP ON
		BRG.ImportBatchId = BTP.ImportBatchId
		
	INNER JOIN #NewBudgets B ON
		B.BudgetId = BTP.BudgetId AND
		B.ImportBatchId = BTP.ImportBatchId AND
		B.BudgetReportGroupId = BRG.BudgetReportGroupId
	
--select * from #BudgetReportGroup
	
PRINT 'Completed inserting records into #BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source report group period mapping.
SET @StartTime = GETDATE()

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM    
	Gdm.BudgetReportGroupPeriod brgp -- THIS TABLE HAS NO SNAPSHOT
	

	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
			
--select * from #BudgetReportGroupPeriod

PRINT 'Completed inserting records into #BudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget status
SET @StartTime = GETDATE()

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	[Name],
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = BudgetStatus.ImportBatchId
	
	
PRINT 'Completed inserting records into #BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source budget project
SET @StartTime = GETDATE()

CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	[Name] VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)
INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	[Name],
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.*
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject

	INNER JOIN #BudgetsToProcess BTP ON
		BudgetProject.ImportBatchId = BTP.ImportBatchId AND
		BudgetProject.BudgetId = BTP.BudgetId
		

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
CREATE INDEX IX_BudgetProjectId ON #BudgetProject (BudgetProjectId)

PRINT 'Completed creating indexes on #BudgetProject'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source region
SET @StartTime = GETDATE()

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	[Name],
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.*
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Budget Employee
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	[Name] VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)
INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	[Name],
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	
	INNER JOIN #BudgetsToProcess BTP ON
		BudgetEmployee.BudgetId = BTP.BudgetId AND
		BudgetEmployee.ImportBatchId = BTP.ImportBatchId
	

PRINT 'Completed inserting records into #BudgetEmployee:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

PRINT 'Completed creating indexes on ##BudgetEmployee'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Budget Employee Functional Department
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)
SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	
	INNER JOIN #DistinctImports DI ON
		EFD.ImportBatchId = DI.ImportBatchId
	
	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId)
CREATE INDEX IX_BudgetEmployeeFunctionalDepartment2 ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)


PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- FunctionalDepartment --------------------------------------------------

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotFunctionalDepartment (
    SnapshotId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Code VARCHAR(20) NULL,
	GlobalCode VARCHAR(30) NULL
)

INSERT INTO #SnapshotFunctionalDepartment
SELECT
    DS.SnapshotId,
	FunctionalDepartmentId,
	Code,
	GlobalCode
FROM
	Gdm.SnapshotFunctionalDepartment FD
	INNER JOIN #DistinctSnapshots DS ON
		FD.SnapshotId = DS.SnapshotId
WHERE
	FD.IsActive = 1

PRINT ('Rows inserted into #FunctionalDepartment: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- Source Property Fund
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotPropertyFund(
--	ImportKey INT NOT NULL,
--	ImportBatchId INT NOT NULL,
--	ImportDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
--	SnapshotId INT NOT NULL
)

INSERT INTO #SnapshotPropertyFund(
	--ImportKey,
	--ImportBatchId,
	--ImportDate,
	SnapshotId,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	Name,
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
	--SnapshotId
)
SELECT 
	DS.SnapshotId,
	PropertyFund.PropertyFundId,
	PropertyFund.RelatedFundId,
	PropertyFund.EntityTypeId,
	PropertyFund.AllocationSubRegionGlobalRegionId,
	PropertyFund.BudgetOwnerStaffId,
	PropertyFund.RegionalOwnerStaffId,
	PropertyFund.DefaultGLTranslationSubTypeId,
	PropertyFund.Name,
	PropertyFund.IsReportingEntity,
	PropertyFund.IsPropertyFund,
	PropertyFund.IsActive,
	PropertyFund.InsertedDate,
	PropertyFund.UpdatedDate,
	PropertyFund.UpdatedByStaffId
	--PropertyFund.SnapshotId as SnapshotId
FROM 
	Gdm.SnapshotPropertyFund PropertyFund
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = PropertyFund.SnapshotId
	
	--INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
	--	PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #SnapshotPropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_PropertyFundId ON #SnapshotPropertyFund (SnapshotId, PropertyFundId)

PRINT 'Completed creating indexes on #SnapshotPropertyFund'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Property Fund Mapping
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotPropertyFundMapping(
	--ImportKey INT NOT NULL,
	--ImportBatchId INT NOT NULL,
	--ImportDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #SnapshotPropertyFundMapping(
	--ImportKey,
	--ImportBatchId,
	--ImportDate,
	SnapshotId,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	DS.SnapshotId,
	PropertyFundMapping.PropertyFundMappingId,
	PropertyFundMapping.PropertyFundId,
	PropertyFundMapping.SourceCode,
	PropertyFundMapping.PropertyFundCode,
	PropertyFundMapping.InsertedDate,
	PropertyFundMapping.UpdatedDate,
	PropertyFundMapping.IsDeleted,
	PropertyFundMapping.ActivityTypeId
FROM 
	Gdm.SnapshotPropertyFundMapping PropertyFundMapping
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = PropertyFundMapping.SnapshotId
	
PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_PropertyFundId ON #SnapshotPropertyFundMapping (SnapshotId, PropertyFundCode, SourceCode, IsDeleted, ActivityTypeId)
CREATE INDEX IX_PropertyFundMapping2 ON #SnapshotPropertyFundMapping (PropertyFundId) -- create as a seperate index as this is how its used.

 -- remove property fund id PropertyFundId,

PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ReportingEntityCorporateDepartment
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotReportingEntityCorporateDepartment( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#SnapshotReportingEntityCorporateDepartment(
	--ImportKey,
	SnapshotId,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	--RECD.ImportKey,
	DS.SnapshotId,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.SnapshotReportingEntityCorporateDepartment RECD
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = RECD.SnapshotId
		
PRINT 'Completed inserting records into #SnapshotReportingEntityCorporateDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


CREATE CLUSTERED INDEX IX_SnapshotReportingEntityCorporateDepartment1 ON #SnapshotReportingEntityCorporateDepartment 
	(CorporateDepartmentCode, SourceCode, IsDeleted, SnapshotId)


PRINT 'Completed creating indexes on #SnapshotReportingEntityCorporateDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ReportingEntityPropertyEntity
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotReportingEntityPropertyEntity( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #SnapshotReportingEntityPropertyEntity(
	--ImportKey,
	SnapshotId,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	--REPE.ImportKey,
	DS.SnapshotId,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.SnapshotReportingEntityPropertyEntity REPE
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = REPE.SnapshotId
	
PRINT 'Completed inserting records into #SnapshotReportingEntityPropertyEntity:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_SnapshotReportingEntityPropertyEntity1 ON #SnapshotReportingEntityPropertyEntity (PropertyEntityCode, SourceCode, IsDeleted, SnapshotId)

PRINT 'Completed creating indexes on #SnapshotReportingEntityPropertyEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ConsolidationRegionCorporateDepartment

SET @StartTime = GETDATE()

CREATE TABLE #SnapshotConsolidationRegionCorporateDepartment( -- CC 16
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO	#SnapshotConsolidationRegionCorporateDepartment(
	--ImportKey,
	SnapshotId,
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	--RECD.ImportKey,
	DS.SnapshotId,
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode,
	CRCD.InsertedDate,
	CRCD.UpdatedDate,
	CRCD.UpdatedByStaffId
FROM
	Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = CRCD.SnapshotId
		
PRINT 'Completed inserting records into #SnapshotConsolidationRegionCorporateDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


CREATE CLUSTERED INDEX IX_SnapshotConsolidationRegionCorporateDepartment1 ON #SnapshotConsolidationRegionCorporateDepartment 
	(CorporateDepartmentCode, SourceCode, SnapshotId)


PRINT 'Completed creating indexes on #SnapshotConsolidationRegionCorporateDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source ConsolidationRegionPropertyEntity
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotConsolidationRegionPropertyEntity( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #SnapshotConsolidationRegionPropertyEntity(
	--ImportKey,
	SnapshotId,
	ConsolidationRegionPropertyEntityId,
	GlobalRegionId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	--REPE.ImportKey,
	DS.SnapshotId,
	CRPE.ConsolidationRegionPropertyEntityId,
	CRPE.GlobalRegionId,
	CRPE.SourceCode,
	CRPE.PropertyEntityCode,
	CRPE.InsertedDate,
	CRPE.UpdatedDate,
	CRPE.UpdatedByStaffId
FROM
	Gdm.SnapshotConsolidationRegionPropertyEntity CRPE
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = CRPE.SnapshotId
	
PRINT 'Completed inserting records into #SnapshotConsolidationRegionPropertyEntity:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_SnapshotConsolidationRegionPropertyEntity1 ON #SnapshotConsolidationRegionPropertyEntity (PropertyEntityCode, SourceCode, SnapshotId)

PRINT 'Completed creating indexes on #SnapshotConsolidationRegionPropertyEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Location
SET @StartTime = GETDATE()

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)

PRINT 'Completed creating indexes on #Location'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source region extended
SET @StartTime = GETDATE()

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.*
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)

PRINT 'Completed creating indexes on #RegionExtended'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- Source Payroll Originating Region
SET @StartTime = GETDATE()

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.*
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)

PRINT 'Completed creating indexes on #PayrollRegion'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source Overhead Originating Region
SET @StartTime = GETDATE()

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)

SELECT 
	OverheadRegion.*
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)

PRINT 'Completed creating indexes on #OverheadRegion'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source project
SET @StartTime = GETDATE()

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

PRINT 'Completed creating indexes on #Project'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- #Department
SET @StartTime = GETDATE()


-- #OriginatingRegionPropertyDepartment

CREATE TABLE #SnapshotOriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	--ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)


------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- #OriginatingRegionCorporateEntity
SET @StartTime = GETDATE()

CREATE TABLE #SnapshotOriginatingRegionCorporateEntity( -- GDM 2.0 addition
--	ImportKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #SnapshotOriginatingRegionCorporateEntity(
	--ImportKey,
	SnapshotId,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
--	ORCE.ImportKey,
	DS.SnapshotId,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.SnapshotOriginatingRegionCorporateEntity ORCE
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = ORCE.SnapshotId

PRINT 'Completed inserting into #OriginatingRegionCorporateEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #SnapshotOriginatingRegionCorporateEntity (SnapshotId, CorporateEntityCode, 
	SourceCode, IsDeleted) -- remove GlobalRegionId

PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()


INSERT INTO #SnapshotOriginatingRegionPropertyDepartment(
	--ImportKey,
	SnapshotId,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	--ORPD.ImportKey,
	DS.SnapshotId,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD
	INNER JOIN #DistinctSnapshots DS ON
		DS.SnapShotId = ORPD.SnapshotId

PRINT 'Completed inserting records into #SnapshotOriginatingRegionPropertyDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #SnapshotOriginatingRegionPropertyDepartment (SnapshotId, PropertyDepartmentCode, 
	SourceCode, IsDeleted) --, GlobalRegionId) -- not needed?

PRINT 'Completed Creating Indexes on #SnapshotOriginatingRegionPropertyDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

-- #Department


CREATE TABLE #Department(
	[ImportKey] [int] NOT NULL,
	[Department] [char](8) NOT NULL,
	[Description] [varchar](50) NULL,
	[LastDate] [datetime] NULL,
	[MRIUserID] [char](20) NULL,
	[Source] [char](2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FunctionalDepartmentId] [int] NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsTsCost] [bit] NOT NULL
)


INSERT INTO	#Department 
(ImportKey, Department,Description,LastDate,MRIUserID,Source,IsActive,FunctionalDepartmentId,UpdatedDate,IsTsCost)
SELECT
	Dept.ImportKey, Dept.Department, Dept.Description, Dept.LastDate, Dept.MRIUserID, Dept.Source,
	Dept.IsActive, Dept.FunctionalDepartmentId, Dept.UpdatedDate, Dept.IsTsCost
FROM
	Gacs.Department Dept
	
	INNER JOIN Gacs.DepartmentActive(@DataPriorToDate) DeptA ON
		DeptA.ImportKey = Dept.ImportKey
	

PRINT 'Completed inserting records into #Department:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_Department ON #Department (Department, [Source])

PRINT 'Completed creating indexes on #Department'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
		
------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #DistinctImports DI ON
		Allocation.ImportBatchId = DI.ImportBatchId

	--data limiting join
	INNER JOIN #BudgetProject BP ON
		Allocation.BudgetProjectId = bp.BudgetProjectId 
		


PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
	
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = B2.ImportBatchId

GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId		
		
/*WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId*/

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailBatches ON #BudgetEmployeePayrollAllocationDetailBatches (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

PRINT 'Completed creating indexes IX_BudgetEmployeePayrollAllocationDetailBatches:'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.ImportBatchId = B1.ImportBatchId AND
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId
		

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_BEPADa1 ON #BEPADa (ImportKey)

PRINT 'Completed creating indexes on #Budget'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	/*
	INNER JOIN #DistinctImports DI ON
		DI.ImportBatchId = TaxDetail.ImportBatchId*/
	
    --data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		Allocation.ImportBatchId = TaxDetail.ImportBatchId AND
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId
		
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey
		

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source budget tax type
SET @StartTime = GETDATE()

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	
	INNER JOIN #BudgetsToProcess BTP ON
		BudgetTaxType.ImportBatchId = BTP.ImportBatchId AND
		BudgetTaxType.BudgetId = BTP.BudgetId
	
PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)

PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation


	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId  AND
		Allocation.ImportBatchId = TaxDetail.ImportBatchId
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
		BudgetTaxType.ImportBatchId = Allocation.ImportBatchId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
		BudgetTaxType.ImportBatchId = TaxType.ImportBatchId
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)

PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--*/
-- Source payroll overhead allocation

SET @StartTime = GETDATE()

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetsToProcess BTP ON
		OverheadAllocation.ImportBatchId = BTP.ImportBatchId AND
		OverheadAllocation.BudgetId = BTP.BudgetId

PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source overhead allocation detail
SET @StartTime = GETDATE()

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN #DistinctImports DI ON
		OverheadDetail.ImportBatchId = DI.ImportBatchId
	
	-- data limiting join
	INNER JOIN #BudgetProject B ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)


PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- Source payroll overhead allocation detail
SET @StartTime = GETDATE()

CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)

PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
SET @StartTime = GETDATE()

CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.ImportBatchId,
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId AND
						Allocation2.ImportBatchId = EFD.ImportBatchId
				
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					Allocation.ImportBatchId = Allocation2.ImportBatchId AND
					EFD.EffectivePeriod <= Allocation.Period
					  
				GROUP BY
					Allocation2.ImportBatchId,
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.ImportBatchId = EFDo.ImportBatchId AND
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
				
	 ) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

PRINT 'Completed creating indexes on #EffectiveFunctionalDepartment'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	ImportBatchId,
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.ImportBatchId,
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	--CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable, -- CC 4 :: GC
	CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
	BudgetProject.ActivityTypeId,
	Att.ActivityTypeCode,
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
			
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,
			
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	Budget.BudgetReportGroupPeriod
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	--INNER JOIN  #FilteredModifiedReportBudget fmrb ON
		--BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #NewBudgets Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId 
		

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #SnapshotFunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId and
		fd.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
		GrSc.SourceCode = BudgetProject.CorporateSourceCode 

	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007 AND
		Budget.SnapshotId = pfm.SnapshotId
	
	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 AND
		RECD.SnapshotId = Budget.SnapshotId
		   
	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	 AND
		REPE.SnapshotId = Budget.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRCD.SourceCode = BudgetProject.CorporateSourceCode AND
		CRCD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRPE.SourceCode = BudgetProject.CorporateSourceCode AND
		CRPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		ProjectPropertyFund.SnapshotId = Budget.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ConsolidationSubRegion.SnapshotId = Budget.SnapshotId	
		
	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

	INNER JOIN GrReporting.dbo.ActivityType Att ON 
		Att.ActivityTypeId = BudgetProject.ActivityTypeId and
		Att.SnapshotId = Budget.SnapshotId
	
	LEFT OUTER JOIN #Department Dept ON
		Dept.DEPARTMENT = BudgetProject.CorporateDepartmentCode AND 
		Dept.[Source] = SourceRegion.SourceCode
		
WHERE
	Allocation.Period BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
	--Change Control 1 : GC 2010-09-01
	--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--Map Tax Amounts
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityTaxSource
(
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL,
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	ImportBatchId,
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	B.ImportBatchId,
	pts.BudgetId,
	pts.BudgetRegionId,
	pts.FirstProjectedPeriod,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.ActivityTypeCode,
	pts.PropertyFundId,
	ISNULL(PF.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
	pts.ConsolidationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId
		
	INNER JOIN #NewBudgets B on 
		B.BudgetId = pts.BudgetId
		
	LEFT OUTER JOIN #SnapshotPropertyFund PF ON
		pts.PropertyFundId = PF.PropertyFundId AND
		B.SnapshotId = PF.SnapshotId

PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



SET @StartTime = GETDATE()

CREATE INDEX IX_ProfitabilityTaxSource1 ON #ProfitabilityTaxSource (SalaryTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource2 ON #ProfitabilityTaxSource  (ProfitShareTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource3 ON #ProfitabilityTaxSource  (BonusTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource4 ON #ProfitabilityTaxSource  (BonusCapExcessTaxAmount)
CREATE INDEX IX_ProfitabilityTaxSource5 ON #ProfitabilityTaxSource  (BudgetEmployeePayrollAllocationId)


PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


--Map Overhead Amounts
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityOverheadSource
(
	ImportBatchId INT NOT NULL,
	BudgetId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	ImportBatchId,
	BudgetId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,	
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.ImportBatchId,
	Budget.BudgetId AS BudgetId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode, 
	
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1 
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		ISNULL(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		ISNULL(OverheadPropertyFund.PropertyFundId, -1) 
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		
	
	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,	
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	--INNER JOIN #FilteredModifiedReportBudget fmrb ON
	--	BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #NewBudgets Budget ON 
		BudgetProject.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #SnapshotFunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId and
		fd.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		Budget.SnapshotId = ProjectPropertyFund.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ConsolidationSubRegion.SnapshotId = Budget.SnapshotId	
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007 AND
		Budget.SnapshotId = pfm.SnapshotId
	
	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		RECD.IsDeleted = 0 AND
		RECD.SnapshotID = Budget.SnapshotId
		   
	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		Budget.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	 AND
		Budget.SnapshotId = REPE.SnapshotId

	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRCD.SourceCode = BudgetProject.CorporateSourceCode AND
		CRCD.SnapshotId = Budget.SnapshotId AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		CRPE.SourceCode = BudgetProject.CorporateSourceCode AND
		CRPE.SnapshotId = Budget.SnapshotId  AND
		Budget.BudgetReportGroupPeriod >= 201101
		
	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND DepartmentPropertyFund.SnapshotId = Budget.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #SnapshotPropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		Budget.BudgetReportGroupPeriod < 201007 AND
		Budget.SnapshotId = opfm.SnapshotId
	
	LEFT OUTER JOIN #SnapshotPropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =	
			CASE
				WHEN Budget.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND OverheadPropertyFund.SnapshotId = Budget.SnapshotId
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

CREATE INDEX IX_ProfitabilityOverheadSource1 ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

PRINT 'Completed creating indexes on #ProfitabilityOverheadSource'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

 /*
;WITH CTE_GetGLAccountOverheadSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	SELECT B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsOverhead GLCTO	
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTO.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
),
CTE_GetGLAccountPayrollSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	Select B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsPayroll GLCTP
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTP.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
)
select top 1000
     '#ProfitabilityPreTaxSource' as Source, CASE WHEN PTS.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = PTS.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = PTS.BudgetId)
		END GLAccountSubTypeId, *
   from #ProfitabilityPreTaxSource PTS		
	*/	
SET @StartTime = GETDATE()
		
CREATE TABLE #ProfitabilityPayrollMapping
(
	ImportBatchId INT NOT NULL,
	SourceName varchar(50),
	BudgetId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	BudgetAmount MONEY NOT NULL,
	MajorGlAccountCategoryId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NOT NULL,
	FeeOrExpense  Varchar(20) NOT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	GLAccountSubTypeIdGlobal INT NOT NULL,
	GlobalGlAccountCode Varchar(10) NULL
);
 
WITH CTE_GetGLAccountOverheadSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	SELECT B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsOverhead GLCTO	
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTO.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
),
CTE_GetGLAccountPayrollSubIds(SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode)
AS
(
	Select B.SnapshotId, BudgetId, GLAccountSubTypeId, GLTranslationSubTypeCode From #SnapshotGLAccountCategoryTranslationsPayroll GLCTP
		INNER JOIN #NewBudgets B ON
			B.SnapshotId = GLCTP.SnapshotId
	WHERE 
		GLTranslationSubTypeCode = 'GL'
)
INSERT INTO #ProfitabilityPayrollMapping
(
	ImportBatchId,
    SourceName, 
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	FeeOrExpense,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	GLAccountSubTypeIdGlobal,
	GlobalGlAccountCode
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.ImportBatchId,
	'Budget-SalaryPreTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
	'Budget-ProfitSharePreTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitSharePreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		---ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.ImportBatchId,
    'Budget-BonusPreTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.ImportBatchId,
    'Budget-BonusCapExcessPreTaxAmount' as SourceName,	
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessPreTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,

	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,
			
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
	INNER JOIN #NewBudgets B on
	  PPS.BudgetId = B.BudgetId
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		B.SnapshotId = ProjectPropertyFund.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ProjectPropertyFund.SnapshotId = ConsolidationSubRegion.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007 AND
		B.SnapshotId = pfm.SnapshotId

	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 AND
		RECD.SnapshotId = B.SnapshotId

	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	 AND
		REPE.SnapshotId = B.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRCD.SourceCode = p.CorporateSourceCode AND
		CRCD.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRPE.SourceCode = p.CorporateSourceCode AND
		CRPE.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101

	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
			AND DepartmentPropertyFund.SnapshotId = B.SnapshotId
			
	
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
    pps.ImportBatchId,
    'Budget-SalaryTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryTaxTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
    pps.ImportBatchId,
	'Budget-ProfitShareTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitShareTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
    pps.ImportBatchId,
	'Budget-BonusTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.ConsolidationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
	INNER JOIN #NewBudgets B on
	  PPS.BudgetId = B.BudgetId
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
    pps.ImportBatchId,
	'Budget-BonusCapExcessTaxAmount' as SourceName,
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	ISNULL(CASE -- (CC16)
				-- Use the allocation region if there is no CorporateDepartmentCode, unless its not a Consolidation Region, then it will be null
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId
				ELSE
					CASE WHEN (GrSc.IsProperty = 'YES') THEN 
						CRPE.GlobalRegionId
					ELSE 
						CRCD.GlobalRegionId
					END
			END, -1) AS ConsolidationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		--THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		--ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		THEN (SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pps.BudgetId)
		ELSE  (Select GLAccountSubTypeId From CTE_GetGLAccountPayrollSubIds CTE_SIDP WHERE CTE_SIDP.BudgetId = pps.BudgetId)
		
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
	INNER JOIN #NewBudgets B on
		b.BudgetId = pps.BudgetId
		
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #SnapshotPropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
		b.SnapshotId = ProjectPropertyFund.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion ConsolidationSubRegion ON
		ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationSubRegion.ConsolidationSubRegionGlobalRegionId AND
		ProjectPropertyFund.SnapshotId = ConsolidationSubRegion.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #SnapshotPropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007 AND
		b.SnapshotId = pfm.SnapshotId

	LEFT OUTER JOIN	#SnapshotReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0 AND
		RECD.SnapshotId = B.SnapshotId
		   
	LEFT OUTER JOIN #SnapshotReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0 AND
		B.SnapshotId = REPE.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
		GrSc.IsCorporate = 'YES' AND -- only property MRIs resolved through this
		CRCD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRCD.SourceCode = p.CorporateSourceCode AND
		CRCD.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101
	
	LEFT OUTER JOIN #SnapshotConsolidationRegionPropertyEntity CRPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		CRPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		CRPE.SourceCode = p.CorporateSourceCode AND
		CRPE.SnapshotId = B.SnapshotId AND
		pps.BudgetReportGroupPeriod >= 201101

	LEFT OUTER JOIN #SnapshotPropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		AND DepartmentPropertyFund.SnapshotId = B.SnapshotId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
    pos.ImportBatchId,
	'Budget-OverheadAllocationAmount' as SourceName,
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	'Overhead' FeeOrExpense,
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.ConsolidationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate,
	--(Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL'),
	(SELECT GLAccountSubTypeId from CTE_GetGLAccountOverheadSubIds CTE_SIDO WHERE CTE_SIDO.BudgetId = pos.BudgetId),
	--General Allocated Overhead Account :: CC8
	'50029500'+RIGHT('0'+LTRIM(STR(pos.ActivityTypeId,3,0)),2) as GlobalGlAccountCode
FROM
	#ProfitabilityOverheadSource pos
	INNER JOIN #NewBudgets B on
		b.BudgetId = pos.BudgetId
	
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)

PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityReforecast(
	ImportBatchId INT NOT NULL,
    SourceName varchar(50),
    BudgetReforecastTypeKey INT NOT NULL,
    SnapshotId INT NOT NULL,
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,	
	AllocationRegionKey INT NOT NULL,
	ConsolidationRegionKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalReforecast MONEY NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	BudgetId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL
) 



INSERT INTO #ProfitabilityReforecast 
(
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId
)
SELECT
	PBM.ImportBatchId,
    pbm.SourceName,
    @ReforecastTypeIsTGBBUDKey,
    B.SnapshotId,
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') AS CalendarKey,
	--DATEDIFF(dd, '1900-01-01', LEFT(pbm.FirstProjectedPeriod,4)+'-'+RIGHT(pbm.FirstProjectedPeriod,2)+'-01') AS ReforecastKey,
	B.ReforecastKey AS ReforecastKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrCr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrCr.[AllocationRegionKey] END ConsolidationRegionKey, -- CC16: Consolidation Region Key
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKeyUnknown ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId
FROM
	#ProfitabilityPayrollMapping pbm
	
	INNER JOIN #NewBudgets B on
		B.BudgetId = pbm.BudgetId 
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		pbm.SourceCode = GrSc.SourceCode 

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.Code = pbm.GlobalGlAccountCode AND
		--pbm.AllocationUpdatedDate BETWEEN GrGa.StartDate AND GrGa.EndDate AND
		GrGa.SnapshotId = B.SnapshotId		
		
	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode 
		

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode 		

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		-- THIS IS NO LONGER NEEDED?
		--pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = B.SnapshotId		

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		--GC :: Change Control 1
		GrOh.OverheadCode = CASE WHEN pbm.FeeOrExpense = 'Overhead' THEN 'ALLOC' 
									WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' 
									ELSE 'UNKNOWN' END 
		--AND GrOh.SnapshotId = B.SnapshotId										
								
									
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		--pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate 
		GrPf.SnapshotId = B.SnapshotId

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0
	
		
	LEFT OUTER JOIN #SnapshotAllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		B.SnapshotId = ASR.SnapshotId

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		--pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
		GrAr.SnapshotId = B.SnapshotId
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion CSR ON
		pbm.ConsolidationSubRegionGlobalRegionId = CSR.ConsolidationSubRegionGlobalRegionId AND
		B.SnapshotId = CSR.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
		CSR.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		GrCr.SnapshotId = B.SnapshotId

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0
		
				
	LEFT OUTER JOIN #SnapshotOriginatingRegionCorporateEntity ORCE ON
		ORCE.SnapshotId = B.SnapshotId AND
		ORCE.CorporateEntityCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		
		   
	LEFT OUTER JOIN #SnapshotOriginatingRegionPropertyDepartment ORPD ON
		B.SnapshotId = ORPD.SnapshotId	AND
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0
		
		
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		--pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
		GrOr.SnapshotId = B.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode


PRINT 'Completed inserting budget portions into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

------------------------------------------------------------------------------------------------------
-- INSERT ACTUALS
------------------------------------------------------------------------------------------------------
SET @StartTime = GETDATE()

CREATE TABLE #ProfitabilityActualSource
(
	ImportBatchId INT NOT NULL,
    SourceName VARCHAR(50),
    BudgetReforecastTypeKey INT NOT NULL,
	SnapshotId INT NOT NULL,
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	ConsolidationRegionKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalReforecast MONEY NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	BudgetId INT NOT NULL,
)
INSERT INTO #ProfitabilityActualSource
(
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId
)
SELECT  
	BPA.ImportBatchId AS ImportBatchId,
	'Actuals' as SourceName,
	@ReforecastTypeIsTGBACTKey as BudgetReforecastTypeKey,
    B.SnapshotId,
    DATEDIFF(dd, '1900-01-01', LEFT(BPA.Period,4)+'-'+RIGHT(BPA.Period,2)+'-01') AS CalendarKey,
	--DATEDIFF(dd, '1900-01-01', LEFT(BPA.Period,4)+'-'+RIGHT(BPA.Period,2)+'-01') AS ReforecastKey,
	B.ReforecastKey AS ReforecastKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	--CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	-- New logic use GBS logic instead as this is actuals and from GBS
	CASE WHEN
		ISNULL(FDJobCode.FunctionalDepartmentKey, GrFdm.FunctionalDepartmentKey) IS NULL
		THEN
			@FunctionalDepartmentKeyUnknown
		ELSE
			ISNULL(FDJobCode.FunctionalDepartmentKey, GrFdm.FunctionalDepartmentKey) END AS FunctionalDepartmentKey,	
	
	
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrCr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrCr.AllocationRegionKey END ConsolidationRegionKey, -- CC16: ConsolidationRegionKey
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKeyUnknown ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,	
	BPA.Amount AS LocalReforecast,
   'TGB:GBSBudgetId=' + LTRIM(RTRIM(STR(B.BudgetId))) + '&BudgetProfitabilityActualId=' + LTRIM(RTRIM(STR(bpa.BudgetProfitabilityActualId))) + '&SnapshotId=' + LTRIM(RTRIM(STR(b.SnapshotId))) as ReferenceCode, -- ReferenceCode
	B.BudgetId
FROM 
    GBS.BudgetProfitabilityActual BPA 
    INNER JOIN  #GBSBudgets B ON 
		B.BudgetId = BPA.BudgetId AND 
		B.MustImportAllActualsIntoWarehouse = 1 AND
		B.ImportBatchId = BPA.ImportBatchId
    
	INNER JOIN #SnapshotGLTranslationSubType TST ON
		B.SnapshotId = TST.SnapshotId	

  		
	LEFT OUTER JOIN #SnapshotGLGlobalAccount GA ON
		BPA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		B.SnapshotId = GA.SnapshotId
		
    LEFT OUTER JOIN GBS.OverheadType OHT ON
		BPA.OverheadTypeId = OHT.OverheadTypeId AND
		OHT.ImportBatchId = B.ImportBatchId

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.GLGlobalAccountId = BPA.GLGlobalAccountId AND		
		GrGa.SnapshotId = B.SnapshotId		
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
		GrSc.SourceCode = BPA.SourceCode


	-- FunctionalDepartmentCode
	LEFT OUTER JOIN #SnapshotFunctionalDepartment FD ON
		BPA.FunctionalDepartmentId = FD.FunctionalDepartmentId and
		B.SnapshotId = FD.SnapshotId


	-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							FunctionalDepartmentCode <> SubFunctionalDepartmentCode
							
	) FDJobCode ON
		FD.GlobalCode = FDJobCode.SubFunctionalDepartmentCode AND
		FD.GlobalCode = FDJobCode.FunctionalDepartmentCode 
		

	-- Parent Level
	LEFT OUTER JOIN (
						SELECT
							FunctionalDepartmentKey,
							FunctionalDepartmentCode,
							FunctionalDepartmentName,
							SubFunctionalDepartmentCode,
							SubFunctionalDepartmentName
						FROM
							GrReporting.dbo.FunctionalDepartment
						WHERE
							SubFunctionalDepartmentCode = FunctionalDepartmentCode
	) GrFdm ON
		FD.GlobalCode = GrFdm.FunctionalDepartmentCode

	/* --- Because this is tapas actuals this wont work i think so lets try the logic above from GBS
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE FD.Code +':%' AND
		BPA.UpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode 
		--and GrFdm.SnapshotId = B.SnapshotId			*/
	


	LEFT OUTER JOIN #SnapshotAllocationSubRegion ASR ON
		BPA.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND 
		B.SnapshotId = ASR.SnapshotId
		
		
		
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		--BPA.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
		GrAr.SnapshotId = B.SnapshotId		
		
	LEFT OUTER JOIN #SnapshotConsolidationSubRegion CSR ON
		BPA.ConsolidationSubRegionGlobalRegionId = CSR.ConsolidationSubRegionGlobalRegionId AND 
		B.SnapshotId = CSR.SnapshotId
		
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16: ConsolidationRegions
		CSR.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		--BPA.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
		GrCr.SnapshotId = B.SnapshotId		

    LEFT OUTER JOIN  #SnapshotPropertyFund PF ON
		PF.PropertyFundId = BPA.ReportingEntityPropertyFundId AND
		B.SnapshotId = PF.SnapshotId
		
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON	
	    GrPf.PropertyFundId = BPA.ReportingEntityPropertyFundId AND
	    Grpf.SnapshotId = PF.SnapshotId	      
		
	
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		BPA.ActivityTypeId = GrAt.ActivityTypeId AND
		--BPA.UpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = B.SnapshotId		
		
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
	     GrRi.ReimbursableCode = CASE WHEN BPA.IsTsCost = 0 THEN 'YES' ELSE 'NO' END
	    
    LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON 
		BPA.OriginatingSubRegionGlobalRegionId = GrOr.GlobalRegionId and
		GrOr.SnapshotId = B.SnapshotId
	    
	  
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		OHT.Code = GrOh.OverheadCode
		--GC :: Change Control 1
		--GrOh.OverheadCode =  CASE WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END    
		--GrOh.OverheadCode = 'ALLOC'
		--AND GrOh.SnapshotId = B.SnapshotId					
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		BPA.CurrencyCode = GrCu.CurrencyCode	
		
	LEFT OUTER JOIN #SnapshotGLGlobalAccountTranslationSubType GLATST ON
		GLATST.GLGlobalAccountId = GA.GLGlobalAccountId AND
		B.SnapshotId = GLATST.SnapshotId		

	LEFT OUTER JOIN #SnapshotGLMinorCategory MinC ON
		GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		B.SnapshotId = MinC.SnapshotId

	LEFT OUTER JOIN #SnapshotGLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		B.SnapshotId = MajC.SnapshotId

WHERE 
	BPA.Period < B.FirstProjectedPeriod AND		
	MajC.Name in ('Salaries/Taxes/Benefits', 'General Overhead') AND
	(OHT.Code IS NULL OR OHT.Code = 'ALLOC')
	


PRINT 'Completed inserting Actuals into #ProfitabilityActualSource:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

SET @StartTime = GETDATE()

INSERT INTO #ProfitabilityReforecast 
(
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId
)
SELECT
	ImportBatchId,
    SourceName,
    BudgetReforecastTypeKey,
	SnapshotId,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId
FROM
	#ProfitabilityActualSource

PRINT 'Completed inserting Actuals portions into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#NewBudgets
UNION ALL
SELECT DISTINCT 
	BudgetId
FROM
	#GBSBudgets	

DECLARE @BudgetId INT = -1
DECLARE @LoopCount INT = 0 -- Infinite loop safe guard
DECLARE @TotalDeleteCount INT = 0
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)


	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM 
			GrReporting.dbo.ProfitabilityReforecast 
		WHERE 
			BudgetId = @BudgetId AND
			BudgetReforecastTypeKey in (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey)
		
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		SET @TotalDeleteCount = @TotalDeleteCount + @row
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted FOR BudgetID (' + STR(@BudgetId) + ') FROM  ProfitabilityReforecast:'+CONVERT(VARCHAR(10),@deleteCnt)		
	--PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END
PRINT 'TOTAL Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@TotalDeleteCount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

print 'Cleaned up rows in ProfitabilityReforecast'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey
SET @StartTime = GETDATE()

CREATE TABLE #GlobalCategoryLookup(
    SnapshotId INT NOT NULL,
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
    SnapshotId,
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	 Gl.SnapshotId,
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
		    B.SnapshotId,
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl		
			INNER JOIN #NewBudgets B ON
				B.BudgetId = GL.BudgetId 
				
			LEFT OUTER JOIN (
							SELECT
								ACT.SnapshotId,
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#SnapshotGLAccountCategoryTranslationsPayroll ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL' 
							UNION ALL
							SELECT
								ACT.SnapshotId,
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#SnapshotGLAccountCategoryTranslationsOverhead ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL' 

						) GlAcHg ON 
						GlAcHg.GLAccountSubTypeId = Gl.GLAccountSubTypeIdGlobal AND
						GlAcHg.SnapshotId = B.SnapshotId
						
		 
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			--AND Gl.AllocationUpdatedDate BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate
			AND GlAcGlobal.SnapshotId = Gl.SnapshotId

PRINT 'Completed inserting #GlobalCategoryLookup:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
			
SET @StartTime = GETDATE()

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (SnapshotId, ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode AND
	#ProfitabilityReforecast.BudgetReforecastTypeKey <> @ReforecastTypeIsTGBACTKey


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys for Budgets:'+CONVERT(char(10),@@rowcount)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))








-- ==============================================================================================================================================
-- Update #ProfitibilityReforecast.GlobalGlAccountCategoryKey for Actuals
-- ==============================================================================================================================================

--select * from #ProfitabilitySource

SET @StartTime = GETDATE()

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
		Gl.GlAccountKey = GLACM.GlAccountKey AND
		Gl.SnapshotId = GLACM.SnapshotId
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		--Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode =  CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLACM.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLACM.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLACM.GLAccountSubTypeId)) AND
		Gl.SnapshotId = GLAC.SnapshotId

where
	Gl.BudgetReforecastTypeKey = @ReforecastTypeIsTGBACTKey
	
PRINT ('Rows updated from #ProfitibilityReforecast.GlobalGlAccountCategoryKey for Actuals: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-- ==============================================================================================================================================







---------------------------------------------------------------------------------------------
----  Register Unknowns
---------------------------------------------------------------------------------------------

--- Smoke All OLD TAPAS Unknowns were about to insert new ones (Reforecast Budget + Reforecast Actuals from [dbo].[ProfitabilityBudgetUnknowns])
SET @StartTime = GETDATE()

DELETE 
    PRU
FROM    
	[dbo].[ProfitabilityReforecastUnknowns] PRU
WHERE
  PRU.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey)

PRINT ('Rows Deleted that was OLD from ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------


SET @StartTime = GETDATE()

INSERT INTO [dbo].[ProfitabilityReforecastUnknowns]
	(
		ImportBatchId,
		CalendarKey,
		GlAccountKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		EUCorporateGlAccountCategoryKey,
		USPropertyGlAccountCategoryKey,
		USFundGlAccountCategoryKey,
		EUPropertyGlAccountCategoryKey,
		USCorporateGlAccountCategoryKey,
		DevelopmentGlAccountCategoryKey,
		EUFundGlAccountCategoryKey,
		GlobalGlAccountCategoryKey,	
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId
	)
SELECT
	PR.ImportBatchId,
	PR.CalendarKey,
	PR.GlAccountKey,
	PR.SourceKey,
	PR.FunctionalDepartmentKey,
	PR.ReimbursableKey,
	PR.ActivityTypeKey,
	PR.PropertyFundKey,
	PR.AllocationRegionKey,
	PR.ConsolidationRegionKey,
	PR.OriginatingRegionKey,
	PR.LocalCurrencyKey,
	PR.LocalReforecast,
	PR.ReferenceCode,
	@EUCorporateGlAccountCategoryKeyUnknown,
	@USPropertyGlAccountCategoryKeyUnknown,	
	@USFundGlAccountCategoryKeyUnknown, 	
	@EUPropertyGlAccountCategoryKeyUnknown,
	@USCorporateGlAccountCategoryKeyUnknown, 
	@DevelopmentGlAccountCategoryKeyUnknown,
	@EUFundGlAccountCategoryKeyUnknown, 
	PR.GlobalGlAccountCategoryKey,	
	PR.BudgetId,
	PR.OverheadKey,
	(SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL'),
	BudgetReforecastTypeKey,
	AB.SnapshotId
	
FROM 
	#ProfitabilityReforecast PR
	INNER JOIN #AllBudgets AB ON
		AB.BudgetId = PR.BudgetId AND
		AB.SnapshotId = PR.SnapshotId
WHERE	
	PR.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey) AND
	(
		@FunctionalDepartmentKeyUnknown = PR.FunctionalDepartmentKey OR
		@ReimbursableKeyUnknown = PR.ReimbursableKey OR
		@ActivityTypeKeyUnknown = PR.ActivityTypeKey OR
		@PropertyFundKeyUnknown = PR.PropertyFundKey OR
		@AllocationRegionKeyUnknown = PR.AllocationRegionKey OR
		@OriginatingRegionKeyUnknown = PR.OriginatingRegionKey OR
		@LocalCurrencyKeyUnknown = PR.LocalCurrencyKey
	)

PRINT ('Rows inserted into ProfitabilitReforecastUnknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


--------------------------------------------------------------------------------------------
---  BUILD Unknown Budgets - Get all the budgets for Budget rows that have unknowns
-------------------------------------------------------------------------------------------
SET @StartTime = GETDATE()


SELECT DISTINCT
	B.SnapshotId, 
	B.BudgetId,
	B.ImportKey,
	PRU.BudgetReforecastTypeKey	
INTO
   #BudgetsWithUnknownBudgets
FROM 
   dbo.ProfitabilityReforecastUnknowns  PRU
   INNER JOIN #AllBudgets B ON
		B.SnapshotId = PRU.SnapshotId AND
		B.BudgetId = PRU.BudgetId 
WHERE
  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsTGBBudKey

DECLARE @RowsToDeleteFromPRBudgets INT = @@rowcount

PRINT ('Rows inserted into #BudgetsWithUnknownBudgets: ' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRBudgets))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

----------------------------------------------------------------------------------------------------
---  BUILD Unknown Actuals - Get all the budgets for Budget rows that have unknowns
----------------------------------------------------------------------------------------------------

SELECT DISTINCT
	B.SnapshotId, 
	B.BudgetId,
	B.ImportKey,
	PRU.BudgetReforecastTypeKey
INTO
   #BudgetsWithUnknownActuals
FROM 
   dbo.ProfitabilityReforecastUnknowns  PRU
   INNER JOIN #AllBudgets B ON
		B.SnapshotId = PRU.SnapshotId AND
		B.BudgetId = PRU.BudgetId 
WHERE
  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsTGBActKey




DECLARE @RowsToDeleteFromPRActuals INT = @@rowcount
PRINT ('Rows inserted into #BudgetsWithUnknownActuals: ' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRActuals))
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


------------------------------------------------------------------------------------------------------------------------------------------------------
---  BUILD ALL Unknown Budgets - Now merge them into one unique budget set and these are all budgets that need deleting
------------------------------------------------------------------------------------------------------------------------------------------------------
SET @StartTime = GETDATE()

SELECT 
   BUA.SnapshotId, 
   BUA.BudgetId,
   BUA.ImportKey
INTO 
	#AllUnknownBudgets
FROM 
	#BudgetsWithUnknownActuals BUA
	INNER JOIN #BudgetsWithUnknownBudgets BUB ON
		BUB.BudgetId = BUA.BudgetId AND
		BUB.SnapshotId = BUA.SnapshotId AND
		BUB.ImportKey = BUA.ImportKey		
   
   
     
   
	PRINT ('Rows INSERTED INTO #AllUnknownBudgets that have Unknowns: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	INSERT INTO @ImportErrorTable (Error) SELECT 'Unknowns'
	
	IF @RowsToDeleteFromPRBudgets > 0 BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Budgets'
	END
	IF @RowsToDeleteFromPRActuals > 0 BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT 'Unknown Actuals'
	END	
	
	
	/**************************************************** DELETIONS COMMENTED OUT FOR NOW, DELETE THIS COMMENT **************************
	
	---------------- Delete the unknown budget portions
	SET @StartTime = GETDATE()

	DELETE
		PR
	FROM
		#ProfitabilityReforecast PR
		INNER JOIN #BudgetsWithUnknownBudgets AUB ON
		  PR.BudgetId = AUB.BudgetId AND
		  PR.SnapshotId = AUB.SnapshotId AND
		  PR.BudgetReforecastTypeKey = AUB.BudgetReforecastTypeKey
	  
	PRINT ('Rows DELETED from #ProfitabilityReforecast that have Unknown Budgets: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	---------------- Delete the unknown actual portions
	SET @StartTime = GETDATE()

	DELETE
		PR
	FROM
		#ProfitabilityReforecast PR
		INNER JOIN #BudgetsWithUnknownActuals AUB ON
		  PR.BudgetId = AUB.BudgetId AND
		  PR.SnapshotId = AUB.SnapshotId AND
		  PR.BudgetReforecastTypeKey = AUB.BudgetReforecastTypeKey		  
	
	
	PRINT ('Rows DELETED from #ProfitabilityReforecast that have Unknown Actuals: ' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			SET @StartTime = GETDATE()
			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment x
			INNER JOIN #BudgetEmployeeFunctionalDepartment xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetEmployee be ON
				be.BudgetEmployeeId = xh.BudgetEmployeeId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = be.BudgetId

			PRINT 'Deleted from BudgetEmployeeFunctionalDepartment: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployee x
			INNER JOIN #BudgetEmployee xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId

			PRINT 'Deleted from BudgetEmployee: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail x
			INNER JOIN #BudgetEmployeePayrollAllocationDetail xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetEmployeePayrollAllocation bpa ON
				bpa.BudgetEmployeePayrollAllocationId = xh.BudgetEmployeePayrollAllocationId
			INNER JOIN #BudgetProject bp ON
				bp.BudgetProjectId = bpa.BudgetProjectId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = bp.BudgetId

			PRINT 'Deleted from BudgetEmployeePayrollAllocationDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

			DELETE x
			FROM TapasGlobalBudgeting.BudgetEmployeePayrollAllocation x
			INNER JOIN #BudgetEmployeePayrollAllocation xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetProject bp ON
				bp.BudgetProjectId = xh.BudgetProjectId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = bp.BudgetId

			PRINT 'Deleted from BudgetEmployeePayrollAllocation: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetOverheadAllocationDetail x
			INNER JOIN #BudgetOverheadAllocationDetail xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #BudgetProject bp ON
				bp.BudgetProjectId = xh.BudgetProjectId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = bp.BudgetId

			PRINT 'Deleted from BudgetOverheadAllocationDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetProject x
			INNER JOIN #BudgetProject xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId
				
			PRINT 'Deleted from BudgetProject: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetTaxType x
			INNER JOIN #BudgetTaxType xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId

			PRINT 'Deleted from BudgetTaxType: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.BudgetReportGroupDetail x
			INNER JOIN #AllUnknownBudgets b ON
				b.BudgetId = x.BudgetId 
				--b.ImportBatchId = x.ImportBatchId
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = b.BudgetId

			PRINT 'Deleted from BudgetReportGroupDetail: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

			DELETE x
			FROM TapasGlobalBudgeting.Budget x
			INNER JOIN #AllUnknownBudgets xh ON
				xh.ImportKey = x.ImportKey
			INNER JOIN #AllUnknownBudgets d ON
				d.BudgetId = xh.BudgetId

			PRINT 'Deleted from Budget: ' + CONVERT(CHAR(10), @@ROWCOUNT)
			PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
			
			
	**************************************************** DELETIONS COMMENTED OUT FOR NOW, DELETE THIS COMMENT **************************/








-- ==============================================================================================================================================












-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SET @StartTime = GETDATE()

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	SnapshotId,
	BudgetReforecastTypeKey,
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
    SnapshotId,
    BudgetReforecastTypeKey,
	CalendarKey,
	ReforecastKey, 
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	(Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = 'NORMAL'),
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast
DECLARE @RowsInsertedIntoProfitabilityReforecastWH INT = @@ROWCOUNT

print 'Rows Inserted in GrReporting.dbo.ProfitabilityReforecast:'+CONVERT(char(10),@RowsInsertedIntoProfitabilityReforecastWH)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-- ==============================================================================================================================================
-- Mark budgets as being successfully processed into the warehouse
-- ==============================================================================================================================================

DECLARE @ImportErrorText VARCHAR(500)
SELECT @ImportErrorText = COALESCE(@ImportErrorText + ', ', '') + Error from @ImportErrorTable

UPDATE
	BTP
SET
    --- Note Slight reverse logic from originally, original it looked if there are anything left in the temp table, now it looks:
    --- IS THERE ANYTHING THAT WAS UNKNOWN for Budgets and Actuals Seperately
	BTP.ReforecastBudgetsProcessedIntoWarehouse = CASE WHEN BWUB.BudgetId IS NULL THEN 1 ELSE 0 END, -- 0 if import fails, 1 if import succeeds
	BTP.ReforecastActualsProcessedIntoWarehouse = CASE WHEN BWUA.BudgetId IS NULL THEN 1 ELSE 0 END, -- 0 if import fails, 1 if import succeeds
	ReasonForFailure = @ImportErrorText,
	BTP.DateBudgetProcessedIntoWarehouse = GETDATE() -- date that the buget import either failed or succeeded (depending on 0 or 1 above)
FROM
	dbo.BudgetsToProcess BTP
	
	INNER JOIN #BudgetsToProcess BTPT ON
		BTP.BudgetsToProcessId = BTPT.BudgetsToProcessId	
	
	LEFT OUTER JOIN #BudgetsWithUnknownBudgets BWUB ON
		BTP.BudgetId = BWUB.BudgetId 

	LEFT OUTER JOIN #BudgetsWithUnknownActuals BWUA ON
		BTP.BudgetId = BWUA.BudgetId 
	
PRINT ('Rows updated from dbo.BudgetsToProcess: ' + CONVERT(VARCHAR(10),@@rowcount))



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SET @StartTime = GETDATE()

DROP TABLE #SystemSettingRegion
DROP TABLE #SnapshotGLTranslationType
DROP TABLE #SnapshotGLTranslationSubType
DROP TABLE #SnapshotGLMajorCategory
DROP TABLE #SnapshotGLMinorCategory
DROP TABLE #SnapshotGLAccountType
DROP TABLE #SnapshotGLAccountSubType
DROP TABLE #SnapshotGLAccountCategoryTranslationsPayroll
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #NewBudgets
--DROP TABLE #AllModifiedReportBudget
--DROP TABLE #LockedModifiedReportGroup
--DROP TABLE #FilteredModifiedReportBudget
--DROP TABLE #NewBudgets
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #SnapshotFunctionalDepartment
DROP TABLE #SnapshotPropertyFund
DROP TABLE #SnapshotPropertyFundMapping
DROP TABLE #SnapshotReportingEntityCorporateDepartment
DROP TABLE #SnapshotReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #SnapshotOriginatingRegionCorporateEntity
DROP TABLE #SnapshotOriginatingRegionPropertyDepartment
DROP TABLE #SnapshotAllocationSubRegion
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget

DROP TABLE #GLAccountCategoryMapping
DROP TABLE #SnapshotGLGlobalAccountTranslationType
DROP TABLE #SnapshotGLGlobalAccount
DROP TABLE #SnapshotGLGlobalAccountTranslationSubType


--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup

DROP TABLE #BudgetsToProcess 

print 'Cleanup Completed:'+CONVERT(char(10),@RowsInsertedIntoProfitabilityReforecastWH)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
PRINT 'ALL DONE'

GO
--ROLLBACK
/*
6. dbo.stp_IU_LoadGrProfitabiltyOverhead.sql
*/ 

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
GO

USE [GrReportingStaging]
GO

/*********************************************************************************************************************
Description
	This stored procedure processes overhead transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
      @ImportStartDate  DateTime=NULL,
      @ImportEndDate          DateTime=NULL,
      @DataPriorToDate  DateTime=NULL
AS
IF (@ImportStartDate IS NULL)
      BEGIN
      SET @ImportStartDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'ActualImportStartDate'))
      END

IF (@ImportEndDate IS NULL)
      BEGIN
      SET @ImportEndDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'ActualImportEndDate'))
      END

IF (@DataPriorToDate IS NULL)
      BEGIN
      SET @DataPriorToDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'ActualDataPriorToDate'))
      END

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

DECLARE 
	@GlAccountKeyUnknown INT,
	--@OverheadGlAccountKeyUnknown INT,
	@FunctionalDepartmentKeyUnknown INT,
	@ReimbursableKeyUnknown INT,
	@ActivityTypeKeyUnknown INT,
	@SourceKeyUnknown INT,
	@OriginatingRegionKeyUnknown INT,
	@AllocationRegionKeyUnknown INT,
	@PropertyFundKeyUnknown INT,
	@OverheadKeyUnknown INT,
		--@CurrencyKey INT,
	@EUFundGlAccountCategoryKeyUnknown INT,
	@EUCorporateGlAccountCategoryKeyUnknown INT,
	@EUPropertyGlAccountCategoryKeyUnknown	INT,
	@USFundGlAccountCategoryKeyUnknown	INT,
	@USPropertyGlAccountCategoryKeyUnknown	INT,
	@USCorporateGlAccountCategoryKeyUnknown INT,
	@DevelopmentGlAccountCategoryKeyUnknown INT,
	@GlobalGlAccountCategoryKeyUnknown INT

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyOverhead'
PRINT '####'
SET NOCOUNT ON
  
--Default FK for the Fact table
/*

DECLARE	@ImportStartDate DateTime
DECLARE	@ImportEndDate DateTime
DECLARE	@DataPriorToDate DateTime

SET	@ImportStartDate = '1900-01-01'
SET	@ImportEndDate = '2010-12-31'
SET	@DataPriorToDate = '2010-12-31'

exec [stp_IU_LoadGrProfitabiltyOverhead]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/  
     
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN')
--SET @OverheadGlAccountKeyUnknown	= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = '5002950000  ') -- Only log against header account (This might be changed back so only commented out)
SET @FunctionalDepartmentKeyUnknown	= (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown			= (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown			= (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
SET @AllocationRegionKeyUnknown		= (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
SET @PropertyFundKeyUnknown			= (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey					= (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')


----- Temp table creation and data inserts - Change Control 7

CREATE TABLE #ManageType(
	ImportKey INT NOT NULL,
	ManageTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #ManageCorporateDepartment(
	ImportKey INT NOT NULL,
	ManageCorporateDepartmentId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #ManageCorporateEntity(
	ImportKey INT NOT NULL,
	ManageCorporateEntityId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)


CREATE TABLE #ManagePropertyDepartment(
	ImportKey INT NOT NULL,
	ManagePropertyDepartmentId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	PropertyDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #ManagePropertyEntity(
	ImportKey INT NOT NULL,
	ManagePropertyEntityId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
----

-- #ManageType

INSERT INTO #ManageType(
	ImportKey,
	ManageTypeId,
	Code,
	Name,
	[Description],
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MT.ImportKey,
	MT.ManageTypeId,
	MT.Code,
	MT.Name,
	MT.[Description],
	MT.IsDeleted,
	MT.InsertedDate,
	MT.UpdatedDate
FROM
	Gdm.ManageType MT
	INNER JOIN Gdm.ManageTypeActive(@DataPriorToDate) MTA ON
		MT.ImportKey = MTA.ImportKey
		
-- #ManageCorporateDepartment

INSERT INTO #ManageCorporateDepartment(
	ImportKey,
	ManageCorporateDepartmentId,
	ManageTypeId,
	CorporateDepartmentCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MCD.ImportKey,
	MCD.ManageCorporateDepartmentId,
	MCD.ManageTypeId,
	MCD.CorporateDepartmentCode,
	MCD.SourceCode,
	MCD.IsDeleted,
	MCD.InsertedDate,
	MCD.UpdatedDate 
FROM
	Gdm.ManageCorporateDepartment MCD
	INNER JOIN Gdm.ManageCorporateDepartmentActive(@DataPriorToDate) MCDA ON
		MCD.ImportKey = MCDA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MCD.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- #ManageCorporateEntity

INSERT INTO #ManageCorporateEntity(
	ImportKey,
	ManageCorporateEntityId,
	ManageTypeId,
	CorporateEntityCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MCE.ImportKey,
	MCE.ManageCorporateEntityId,
	MCE.ManageTypeId,
	MCE.CorporateEntityCode,
	MCE.SourceCode,
	MCE.IsDeleted,
	MCE.InsertedDate,
	MCE.UpdatedDate 
FROM
	Gdm.ManageCorporateEntity MCE
	INNER JOIN Gdm.ManageCorporateEntityActive(@DataPriorToDate) MCEA ON
		MCE.ImportKey = MCEA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MCE.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- #ManagePropertyDepartment

INSERT INTO #ManagePropertyDepartment(
	ImportKey,
	ManagePropertyDepartmentId,
	ManageTypeId,
	PropertyDepartmentCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MPD.ImportKey,
	MPD.ManagePropertyDepartmentId,
	MPD.ManageTypeId,
	MPD.PropertyDepartmentCode,
	MPD.SourceCode,
	MPD.IsDeleted,
	MPD.InsertedDate,
	MPD.UpdatedDate 
FROM
	Gdm.ManagePropertyDepartment MPD
	INNER JOIN Gdm.ManagePropertyDepartmentActive(@DataPriorToDate) MPDA ON
		MPD.ImportKey = MPDA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MPD.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- #ManagePropertyEntity

INSERT INTO #ManagePropertyEntity(
	ImportKey,
	ManagePropertyEntityId,
	ManageTypeId,
	PropertyEntityCode,
	SourceCode,
	IsDeleted,
	InsertedDate,
	UpdatedDate  
)
SELECT
	MPE.ImportKey,
	MPE.ManagePropertyEntityId,
	MPE.ManageTypeId,
	MPE.PropertyEntityCode,
	MPE.SourceCode,
	MPE.IsDeleted,
	MPE.InsertedDate,
	MPE.UpdatedDate 
FROM
	Gdm.ManagePropertyEntity MPE
	INNER JOIN Gdm.ManagePropertyEntityActive(@DataPriorToDate) MPEA ON
		MPE.ImportKey = MPEA.ImportKey
	INNER JOIN #ManageType MT ON
		MT.ManageTypeId = MPE.ManageTypeId
WHERE
	MT.Code = 'GMREXCL'

-- change control 7 end


CREATE TABLE #ActivityTypeGLAccount(
	ActivityTypeId INT,
	GLAccountCode VARCHAR(12)
)

INSERT INTO #ActivityTypeGLAccount (
	ActivityTypeId, 
	GLAccountCode
)
SELECT NULL AS ActivityTypeId, '5002950000' AS GLAccountCode UNION ALL --header (NULL in on hierarchy)
SELECT 1, '5002950001' UNION ALL --Leasing
SELECT 2, '5002950002' UNION ALL --Acquisitions
SELECT 3, '5002950003' UNION ALL --Asset Management
SELECT 4, '5002950004' UNION ALL --Development
SELECT 5, '5002950005' UNION ALL --Property Management Escalatable
SELECT 6, '5002950006' UNION ALL --Property Management Non-Escalatable
SELECT 7, '5002950007' UNION ALL --Syndication (Investment and Fund)
SELECT 8, '5002950008' UNION ALL --Fund Organization
SELECT 9, '5002950009' UNION ALL --Fund Operations
SELECT 10, '5002950010' UNION ALL --Property Management TI
SELECT 11, '5002950011' UNION ALL --Property Management CapEx
SELECT 12, '5002950012' UNION ALL --Corporate
SELECT 99, '5002950099' --Corporate Overhead (No corporate overhead (5002950099) account  use header instead)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Create the temp tables used on the "active" records for optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #AllocationRegion(
	ImportKey INT NOT NULL,
	AllocationRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	DefaultCurrencyCode CHAR(3) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)


CREATE TABLE #BillingUpload(
	ImportKey INT  NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadBatchId INT NULL,
	BillingUploadTypeId INT NOT NULL,
	TimeAllocationId INT NOT NULL,
	CostTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalRegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	PayrollId INT NULL,
	OverheadId INT NULL,
	PayGroupId INT NULL,
	UnionCodeId INT NULL,
	OverheadRegionId INT NULL,
	HREmployeeId INT NOT NULL,
	ProjectId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	PayrollDescription NVARCHAR(100) NULL,
	OverheadDescription NVARCHAR(100) NULL,
	ProjectCode VARCHAR(50) NOT NULL,
	ReversalPeriod INT NULL,
	AllocationPeriod INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	IsReversable BIT NOT NULL,
	IsReversed BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	HasNoInactiveProjects BIT NOT NULL,
	LocationId INT NOT NULL,
	ProjectGroupAllocationAdjustmentId INT NULL,
	AdjustedTimeAllocationDetailId INT NULL,
	PayrollPayDate DATETIME NULL,
	PayrollFromDate DATETIME NULL,
	PayrollToDate DATETIME NULL,
	FunctionalDepartmentId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NULL,
)

CREATE TABLE #BillingUploadDetail(
	ImportKey INT NOT NULL,
	BillingUploadDetailId INT NOT NULL,
	BillingUploadBatchId INT NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadDetailTypeId INT NOT NULL,
	ExpenseTypeId INT NULL,
	GLAccountCode VARCHAR(15) NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateDepartmentIsRechargedToAr BIT NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	AllocationAmount DECIMAL(18, 9) NOT NULL,
	CurrencyCode CHAR(3) NOT NULL,
	IsUnion BIT NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	CorporateDepartmentIsRechargedToAp BIT NOT NULL
)

CREATE TABLE #Overhead(
	ImportKey INT NOT NULL,
	OverheadId INT NOT NULL,
	RegionId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationStartPeriod INT NOT NULL,
	AllocationEndPeriod INT NULL,
	[Description] NVARCHAR(60) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	InsertedByStaffId INT NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	InvoiceNumber VARCHAR(13) NULL
)

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

CREATE TABLE #PropertyFund( -- GDM 2.0 change
	ImportKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

CREATE TABLE #ConsolidationRegionCorporateDepartment( -- CC16
	ImportKey INT NOT NULL,
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #GLGlobalAccount(
	ImportKey INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ActivityType(
	ImportKey INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	GLSuffix CHAR(2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	[Name] VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

--======================================================================================================================================

INSERT INTO #BillingUpload (
	ImportKey,
	BillingUploadId,
	BillingUploadBatchId,
	BillingUploadTypeId,
	TimeAllocationId,
	CostTypeId,
	RegionId,
	ExternalRegionId,
	ExternalSubRegionId,
	PayrollId,
	OverheadId,
	PayGroupId,
	UnionCodeId,
	OverheadRegionId,
	HREmployeeId,
	ProjectId,
	SubDepartmentId,
	ExpensePeriod,
	PayrollDescription,
	OverheadDescription,
	ProjectCode,
	ReversalPeriod,
	AllocationPeriod,
	AllocationValue,
	IsReversable,
	IsReversed,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	HasNoInactiveProjects,
	LocationId,
	ProjectGroupAllocationAdjustmentId,
	AdjustedTimeAllocationDetailId,
	PayrollPayDate,
	PayrollFromDate,
	PayrollToDate,
	FunctionalDepartmentId,
	ActivityTypeId,
	OverheadFunctionalDepartmentId
)
SELECT 
	Bu.ImportKey,
	Bu.BillingUploadId,
	Bu.BillingUploadBatchId,
	Bu.BillingUploadTypeId,
	Bu.TimeAllocationId,
	Bu.CostTypeId,
	Bu.RegionId,
	Bu.ExternalRegionId,
	Bu.ExternalSubRegionId,
	Bu.PayrollId,
	Bu.OverheadId,
	Bu.PayGroupId,
	Bu.UnionCodeId,
	Bu.OverheadRegionId,
	Bu.HREmployeeId,
	Bu.ProjectId,
	Bu.SubDepartmentId,
	Bu.ExpensePeriod,
	Bu.PayrollDescription,
	Bu.OverheadDescription,
	Bu.ProjectCode,
	Bu.ReversalPeriod,
	Bu.AllocationPeriod,
	Bu.AllocationValue,
	Bu.IsReversable,
	Bu.IsReversed,
	Bu.InsertedDate,
	Bu.UpdatedDate,
	Bu.UpdatedByStaffId,
	Bu.HasNoInactiveProjects,
	Bu.LocationId,
	Bu.ProjectGroupAllocationAdjustmentId,
	Bu.AdjustedTimeAllocationDetailId,
	Bu.PayrollPayDate,
	Bu.PayrollFromDate,
	Bu.PayrollToDate,
	Bu.FunctionalDepartmentId,
	Bu.ActivityTypeId,
	Bu.OverheadFunctionalDepartmentId
FROM
	TapasGlobal.BillingUpload	Bu
	INNER JOIN TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA ON
		BuA.ImportKey = Bu.ImportKey

------------

INSERT INTO #BillingUploadDetail (
	ImportKey,
	BillingUploadDetailId,
	BillingUploadBatchId,
	BillingUploadId,
	BillingUploadDetailTypeId,
	ExpenseTypeId,
	GLAccountCode,
	CorporateEntityRef,
	CorporateDepartmentCode,
	CorporateDepartmentIsRechargedToAr,
	CorporateSourceCode,
	AllocationAmount,
	CurrencyCode,
	IsUnion,
	UpdatedByStaffId,
	InsertedDate,
	UpdatedDate,
	CorporateDepartmentIsRechargedToAp
)
SELECT 
	Bud.ImportKey,
	Bud.BillingUploadDetailId,
	Bud.BillingUploadBatchId,
	Bud.BillingUploadId,
	Bud.BillingUploadDetailTypeId,
	Bud.ExpenseTypeId,
	Bud.GLAccountCode,
	Bud.CorporateEntityRef,
	Bud.CorporateDepartmentCode,
	Bud.CorporateDepartmentIsRechargedToAr,
	Bud.CorporateSourceCode,
	Bud.AllocationAmount,
	Bud.CurrencyCode,
	Bud.IsUnion,
	Bud.UpdatedByStaffId,
	Bud.InsertedDate,
	Bud.UpdatedDate,
	Bud.CorporateDepartmentIsRechargedToAp
FROM
	TapasGlobal.BillingUploadDetail Bud
	INNER JOIN TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA ON
		BudA.ImportKey = Bud.ImportKey

----------

INSERT INTO #Overhead (
	ImportKey,
	OverheadId,
	RegionId,
	ExpensePeriod,
	AllocationStartPeriod,
	AllocationEndPeriod,
	[Description],
	InsertedDate,
	InsertedByStaffId,
	UpdatedDate,
	UpdatedByStaffId,
	InvoiceNumber
)
SELECT 
	 Oh.ImportKey,
	 Oh.OverheadId,
	 Oh.RegionId,
	 Oh.ExpensePeriod,
	 Oh.AllocationStartPeriod,
	 Oh.AllocationEndPeriod,
	 Oh.[Description],
	 Oh.InsertedDate,
	 Oh.InsertedByStaffId,
	 Oh.UpdatedDate,
	 Oh.UpdatedByStaffId,
	 Oh.InvoiceNumber
FROM
	TapasGlobal.Overhead Oh 
	INNER JOIN TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
		OhA.ImportKey = Oh.ImportKey

----------

INSERT INTO #FunctionalDepartment (
	ImportKey,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT
	Fd.ImportKey,
	Fd.FunctionalDepartmentId,
	Fd.Name,
	Fd.Code,
	Fd.IsActive,
	Fd.InsertedDate,
	Fd.UpdatedDate,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd 
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		FdA.ImportKey = Fd.ImportKey

----------

INSERT INTO #Project (
	ImportKey,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	P2.ImportKey,
	P2.ProjectId,
	P2.RegionId,
	P2.ActivityTypeId,
	P2.ProjectOwnerId,
	P2.CorporateDepartmentCode,
	P2.CorporateSourceCode,
	P2.Code,
	P2.Name,
	P2.StartPeriod,
	P2.EndPeriod,
	P2.InsertedDate,
	P2.UpdatedDate,
	P2.UpdatedByStaffId,
	P2.PropertyOverheadGLAccountCode,
	P2.PropertyOverheadDepartmentCode,
	P2.PropertyOverheadJobCode,
	P2.PropertyOverheadSourceCode,
	P2.CorporateUnionPayrollIncomeCategoryCode,
	P2.CorporateNonUnionPayrollIncomeCategoryCode,
	P2.CorporateOverheadIncomeCategoryCode,
	P2.PropertyFundId,
	P2.MarkUpPercentage,
	P2.HistoricalProjectCode,
	P2.IsTSCost,
	P2.CanAllocateOverheads,
	P2.AllocateOverheadsProjectId
FROM
	TapasGlobal.Project P2
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) P2A ON
		P2A.ImportKey = P2.ImportKey

----------------------------------------------------------------------------------------------

-- #AllocationRegion

INSERT INTO #AllocationRegion(
	ImportKey,
	AllocationRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	DefaultCurrencyCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AR.ImportKey,
	AR.AllocationRegionGlobalRegionId,
	AR.Code,
	AR.[Name],
	AR.ProjectCodePortion,
	AR.DefaultCurrencyCode,
	AR.IsActive,
	AR.InsertedDate,
	AR.UpdatedDate,
	AR.UpdatedByStaffId
FROM
	Gdm.AllocationRegion AR
	INNER JOIN Gdm.AllocationRegionActive(@DataPriorToDate) ARA ON
		ARA.ImportKey = AR.ImportKey

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey


-- #ConsolidationRegionCorporateDepartment
INSERT INTO #ConsolidationRegionCorporateDepartment
(
	ImportKey,
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	CRCD.ImportKey,
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode,
	CRCD.InsertedDate,
	CRCD.UpdatedDate,
	CRCD.UpdatedByStaffId
FROM
	Gdm.ConsolidationRegionCorporateDepartment CRCD 
	INNER JOIN Gdm.ConsolidationRegionCorporateDepartmentActive(@DataPriorToDate) CRCDA ON
		CRCDA.ImportKey = CRCD.ImportKey
	
-- #PropertyFund
	
INSERT INTO #PropertyFund(
	ImportKey,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	[Name],
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	PF.ImportKey,
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.[Name],
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.IsActive,
	PF.InsertedDate,
	PF.UpdatedDate,
	PF.UpdatedByStaffId
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PFA.ImportKey = PF.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (PropertyFundId)

-- #PropertyFundMapping

INSERT INTO #PropertyFundMapping(
	ImportKey,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT
	Pfm.ImportKey,
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- #ReportingEntityCorporateDepartment

INSERT INTO #ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

-- #ReportingEntityPropertyEntity

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

-- #ActivityType

INSERT INTO #ActivityType(
	ImportKey,
	ActivityTypeId,
	ActivityTypeCode,
	[Name],
	GLSuffix,
	InsertedDate,
	UpdatedDate
)
SELECT
	At.ImportKey,
	At.ActivityTypeId,
	At.Code,
	At.Name,
	At.GLAccountSuffix,
	At.InsertedDate,
	At.UpdatedDate
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

-- #GLGlobalAccount

INSERT INTO #GLGlobalAccount(
	ImportKey,
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GLA.ImportKey,
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.GLStatutoryTypeId,
	GLA.Code,
	GLA.[Name], 
	GLA.[Description],
	GLA.IsGR,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.IsActive,
	GLA.InsertedDate,
	GLA.UpdatedDate,
	GLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLAA.ImportKey = GLA.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

INSERT INTO #OverheadRegion(
	ImportKey,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Ovr.ImportKey,
	Ovr.OverheadRegionId,
	Ovr.RegionId,
	Ovr.CorporateEntityRef,
	Ovr.CorporateSourceCode,
	Ovr.Name,
	Ovr.InsertedDate,
	Ovr.UpdatedDate,
	Ovr.UpdatedByStaffId
FROM	TapasGlobal.OverheadRegion Ovr 
		INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
			OvrA.ImportKey = Ovr.ImportKey

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType(
	ImportKey,
	GLGlobalAccountTranslationTypeId,
	GLGlobalAccountId,
	GLTranslationTypeId,
	GLAccountTypeId,
	GLAccountSubTypeId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATT.ImportKey,
	GATT.GLGlobalAccountTranslationTypeId,
	GATT.GLGlobalAccountId,
	GATT.GLTranslationTypeId,
	GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId,
	GATT.IsActive,
	GATT.InsertedDate,
	GATT.UpdatedDate,
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO #GLGlobalAccountTranslationSubType(
	ImportKey,
	GLGlobalAccountTranslationSubTypeId,
	GLGlobalAccountId,
	GLTranslationSubTypeId,
	GLMinorCategoryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GATST.ImportKey,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId,
	GATST.IsActive,
	GATST.InsertedDate,
	GATST.UpdatedDate,
	GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.[Name],
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

PRINT 'Completed inserting Active records into temp table'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Now use the temp tables and load the #ProfitabilityOverhead
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityOverhead(
	BillingUploadDetailId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8)  NULL,
	CorporateSourceCode VARCHAR(2)  NULL,
	CanAllocateOverheads Bit NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationRegionCode VARCHAR(6) NULL,
	ConsolidationSubRegionGlobalRegionId INT NULL,
	OriginatingRegionCode VARCHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	PropertyFundCode char(12) NULL,
	PropertyFundId INT NOT NULL,
	FunctionalDepartmentCode CHAR(3) NULL,
	ActivityTypeCode VARCHAR(10) NULL,
	ExpenseType VARCHAR(8) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual DECIMAL(18,12) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL
)

INSERT INTO #ProfitabilityOverhead(
	BillingUploadDetailId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	CanAllocateOverheads,
	ExpensePeriod,
	AllocationRegionCode,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	PropertyFundId,
	FunctionalDepartmentCode,
	ActivityTypeCode,
	ExpenseType,
	LocalCurrency,
	LocalActual,
	UpdatedDate,
	InsertedDate,
	PropertyFundCode
)
SELECT 
	Bud.BillingUploadDetailId,
	
	CASE
		WHEN P1.AllocateOverheadsProjectId IS NULL THEN Bud.CorporateDepartmentCode
		ELSE P2.CorporateDepartmentCode
	END AS CorporateDepartmentCode,
	
	Bud.CorporateSourceCode,
	
	CASE
		WHEN P1.AllocateOverheadsProjectId IS NULL THEN P1.CanAllocateOverheads
		ELSE P2.CanAllocateOverheads
	END AS CanAllocateOverheads,
	
	Bu.ExpensePeriod,
	GrAr.RegionCode AllocationRegionCode, --Pr.Code AllocationRegionCode,
	CRCDC.GlobalRegionId ConsolidationSubRegionGlobalRegionId, 
	Ovr.CorporateEntityRef OriginatingRegionCode,
	Ovr.CorporateSourceCode OriginatingRegionSourceCode,
	
	CASE
		WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId, --This is seen as the Gdm.Gr.GlobalPropertyFundId
	
	Fd.GlobalCode FunctionalDepartmentCode,
	At.ActivityTypeCode,
	'Overhead' ExpenseType,
	Bud.CurrencyCode ForeignCurrency,
	Bud.AllocationAmount ForeignActual,
	Bud.UpdatedDate,
	Bud.InsertedDate,
	P1.CorporateDepartmentCode as PropertyFundCode
FROM
	#BillingUpload Bu
		
	INNER JOIN #BillingUploadDetail Bud ON
		Bud.BillingUploadId = Bu.BillingUploadId

	INNER JOIN #Overhead Oh ON
		Oh.OverheadId = Bu.OverheadId

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Fd.FunctionalDepartmentId = Bu.OverheadFunctionalDepartmentId

	LEFT OUTER JOIN #Project P1 ON
		P1.ProjectId = Bu.ProjectId

	LEFT OUTER JOIN #Project P2 ON
		P2.ProjectId = P1.AllocateOverheadsProjectId

	-- P1 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = P1.CorporateSourceCode

	/*
		2010-11-23
		The commented code below is what was previously used to determine the corporate department of an overhead actual.
		The join criteria shows that the budget project's corporate department is used for this. This approach isn't suitable as this field
		could change at any time (and has). A more stable strategy is to use the corporate department that is saved in the budget upload
		detail table, as this is guaranteed to never change (unless someone manually changes it via the back end).
	*/


	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON -- added
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(Bud.CorporateDepartmentCode)) AND
		RECDC.SourceCode = Bud.CorporateSourceCode AND
		Bu.ExpensePeriod >= 201007 AND		   
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON -- added
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(Bud.CorporateDepartmentCode)) AND
		REPEC.SourceCode = Bud.CorporateSourceCode AND
		Bu.ExpensePeriod >= 201007 AND
		REPEC.IsDeleted = 0
		
	LEFT OUTER JOIN	#ConsolidationRegionCorporateDepartment CRCDC ON -- CC16 : It is assumed that overheads are to come from corproate departemtns only
		CRCDC.CorporateDepartmentCode = 
			CASE
				WHEN P1.AllocateOverheadsProjectId IS NULL THEN 
					Bud.CorporateDepartmentCode
				ELSE 
					P2.CorporateDepartmentCode
			END AND
		CRCDC.SourceCode = Bud.CorporateSourceCode AND
		Bu.ExpensePeriod >= 201101
		   
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		pfm.PropertyFundCode = Bud.CorporateDepartmentCode AND -- Combination of entity and corporate department
		pfm.SourceCode = Bud.CorporateSourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
			)
		) AND Bu.ExpensePeriod < 201007

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Bu.ExpensePeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = 'YES' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END AND
		Bu.UpdatedDate BETWEEN DepartmentPropertyFund.StartDate AND DepartmentPropertyFund.EndDate AND
		DepartmentPropertyFund.SnapshotId = 0

	-- P1 end -----------------------
	-- P2 begin ---------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO
		ON GrScO.SourceCode = P2.CorporateSourceCode

    /*
		2010-11-23
		Unlike the previous three joins used to determine the reporting entity, the joins below are still required to used the budget project's
		corporate department code when determining the reporting entity for the case when the AllocatedOverheadProjectID is not null. This is
		not ideal as again, the corporate department associated with this project could change, but it's GR's best effort as it stands as TAPAS
		is unable to snapshot data. When the GR rolling window begins to be used as it was intended, the potential inconsistencies that this
		may cause will be limited as the window will be much smaller than what it is currently set to.
    */
    
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDO ON -- added
		GrScO.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
		RECDO.SourceCode = P2.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007'  AND			   
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON -- added
		GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
		REPEO.SourceCode = P2.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007'  AND
		REPEO.IsDeleted = 0
		

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		P2.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		P2.CorporateSourceCode = opfm.SourceCode AND
		opfm.IsDeleted = 0  AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL) 
			)	
		) AND Bu.ExpensePeriod < '201007' 

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN Bu.ExpensePeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END AND
		Bu.UpdatedDate BETWEEN OverheadPropertyFund.StartDate AND OverheadPropertyFund.EndDate AND
		OverheadPropertyFund.SnapshotId = 0

	-- P2 end -----------------------

	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = (
								CASE
									WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
										ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
									ELSE
										ISNULL(OverheadPropertyFund.PropertyFundId, -1)
								END
							) --AND
		--PF.IsActive = 1
		
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		Bu.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate AND
		GrAr.SnapshotId = 0

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = Bu.ActivityTypeId

	LEFT OUTER JOIN #OverheadRegion Ovr ON
		Ovr.OverheadRegionId = Bu.OverheadRegionId

WHERE
	Bu.BillingUploadBatchId IS NOT NULL AND
	Bud.BillingUploadDetailTypeId <> 2 
	--AND ISNULL(Bu.UpdatedDate, Bu.UpdatedDate) BETWEEN @ImportStartDate AND @ImportEndDate --NOTE:: GC I am note sure it can work with the date filter

--IMS 48953 - Exclude overhead mark up from the import

PRINT 'Rows Inserted into #ProfitabilityOverhead:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Change control 7 - begin

PRINT 'Deleting records in #ProfitabilityOverhead which are associated with entries in the ManageCorporateEntity and ManageCorporateDepartment tables'
PRINT CONVERT(Varchar(27), getdate(), 121)

DELETE
	PO
FROM
	#ProfitabilityOverhead PO
	INNER JOIN #ManageCorporateEntity MCE ON
		PO.OriginatingRegionCode = MCE.CorporateEntityCode AND
		PO.CorporateSourceCode = MCE.SourceCode
WHERE
	MCE.IsDeleted = 0 AND
	RIGHT(MCE.SourceCode, 1) = 'C' AND
	RIGHT(PO.CorporateSourceCode, 1) = 'C'	

PRINT (CONVERT(char(10),@@rowcount) + ' records deleted from #ProfitabilityOverhead')

DELETE
	PO
FROM
	#ProfitabilityOverhead PO
	INNER JOIN #ManageCorporateDepartment MCD ON
		PO.PropertyFundCode = MCD.CorporateDepartmentCode AND
		PO.CorporateSourceCode = MCD.SourceCode
WHERE
	MCD.IsDeleted = 0 AND
	RIGHT(MCD.SourceCode, 1) = 'C' AND	
	RIGHT(PO.CorporateSourceCode, 1) = 'C'	

PRINT (CONVERT(char(10),@@rowcount) + ' records deleted from #ProfitabilityOverhead')

PRINT 'Finished deleting from #ProfitabilityOverhead'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Change control 7 - end

--------------------------------------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
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
	ProfitabilityActualSourceTableId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL,
	
	OriginatingRegionCode char(6) NULL,
	PropertyFundCode char(12) NULL,
	FunctionalDepartmentCode char(15) NULL 
) 

INSERT INTO #ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
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
	ProfitabilityActualSourceTableId,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode
)
SELECT 
	DATEDIFF(dd, '1900-01-01', LEFT(Gl.ExpensePeriod, 4) + '-' + RIGHT(Gl.ExpensePeriod, 2) + '-01') CalendarKey,
	--,ISNULL(@OverheadGlAccountKeyUnknown, @GlAccountKeyUnknown) GlAccountKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKeyUnknown ELSE GrSc.SourceKey END SourceKey,
	CASE WHEN GrFdm.FunctionalDepartmentKey IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.FunctionalDepartmentKey END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.ActivityTypeKey END ActivityTypeKey,
	CASE WHEN GrOr.OriginatingRegionKey IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.OriginatingRegionKey END OriginatingRegionKey,
	CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END AllocationRegionKey,
	CASE 
		WHEN Gl.ExpensePeriod < 201101 THEN
			CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END
		ELSE
			CASE WHEN GrCr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrCr.AllocationRegionKey END
	END ConsolidationRegionKey,
	CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.PropertyFundKey END PropertyFundKey,
	CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE GrOh.OverheadKey END OverheadKey,
		'BillingUploadDetailId=' + LTRIM(STR(Gl.BillingUploadDetailId, 10, 0)),
	Cu.CurrencyKey,
	Gl.LocalActual,
	3 ProfitabilityActualSourceTableId, --BillingUploadDetail
	Gl.OriginatingRegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode
	

FROM
	#ProfitabilityOverhead Gl

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Cu.CurrencyCode = Gl.LocalCurrency

	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.FunctionalDepartmentCode = Gl.FunctionalDepartmentCode AND
		GrFdm.SubFunctionalDepartmentCode = Gl.FunctionalDepartmentCode AND
		Gl.UpdatedDate BETWEEN GrFdm.StartDate AND ISNULL(GrFdm.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeCode = Gl.ActivityTypeCode 
		
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		Gl.UpdatedDate BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate) AND
		GrAt.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = 'ALLOC'
		
	LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
		AtGla.ActivityTypeId = At.ActivityTypeId

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		GA.Code = AtGla.GLAccountCode AND
		ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGA ON
		GrGA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		Gl.UpdatedDate BETWEEN GrGA.StartDate AND GrGA.EndDate AND
		GrGA.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.CorporateSourceCode
	
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = Gl.PropertyFundId AND
		Gl.UpdatedDate BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate) AND
		GrPf.SnapshotId = 0

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
			   
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ORCE.GlobalRegionId AND
		--GrOr.GlobalRegionId = ORPD.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate) AND
		GrOr.SnapshotId = 0
	
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = Gl.PropertyFundId --AND
		--PF.IsActive = 1

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate) AND
		GrAr.SnapshotId = 0
		

		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
		GrCr.GlobalRegionId = Gl.ConsolidationSubRegionGlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrCr.StartDate AND ISNULL(GrCr.EndDate, Gl.UpdatedDate) AND
		GrCr.SnapshotId = 0

	LEFT OUTER JOIN (
						SELECT 'UC' SOURCECODE, DEPARTMENT, NETTSCOST FROM USCorp.GDEP UNION ALL
						SELECT 'EC' SOURCECODE, DEPARTMENT, NETTSCOST FROM EUCorp.GDEP UNION ALL
						SELECT 'IC' SOURCECODE, DEPARTMENT, NETTSCOST FROM INCorp.GDEP UNION ALL
						SELECT 'BC' SOURCECODE, DEPARTMENT, NETTSCOST FROM BRCorp.GDEP UNION ALL
						SELECT 'CC' SOURCECODE, DEPARTMENT, NETTSCOST FROM CNCorp.GDEP
					) RiCo ON
		RiCo.DEPARTMENT = Gl.CorporateDepartmentCode AND
		RiCo.SOURCECODE = Gl.CorporateSourceCode	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE
									WHEN ISNULL(RiCo.NETTSCOST, 'N') = 'Y' THEN 'NO' ELSE 'YES'
								END								

WHERE
	Gl.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate

----Prepare data for later Clean-up of Key's that have changed and 
----as such left the current record to be not required anymore	
--Update GrReporting.dbo.ProfitabilityActual
--SET 	
--Actual						= 0
--Where	SourceKey	IN (Select DISTINCT SourceKey From #ProfitabilityActual)
--AND		CalendarKey	BETWEEN DATEDIFF(dd,'1900-01-01', @ImportStartDate) AND 
--							 DATEDIFF(dd,'1900-01-01', @ImportEndDate)
--Transfer the updated rows
	
-------------------------------------------------------------------------------------------------------------------
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId AND
				Gla.SnapshotId = 0

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'GL' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId)) AND
		GLAC.SnapshotId = 0


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(Varchar(27), getdate(), 121)

UPDATE
	GrReporting.dbo.ProfitabilityActual
SET 	
	CalendarKey						 = Pro.CalendarKey,
	GlAccountKey					 = Pro.GlAccountKey,
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
	ProfitabilityActualSourceTableId = Pro.ProfitabilityActualSourceTableId,
		
	EUCorporateGlAccountCategoryKey	 = @EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey	 = @EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey		 = @EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey	 = @USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey	 = @USCorporateGlAccountCategoryKeyUnknown, --Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey		 = @USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey		 = Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey	 = @DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	OriginatingRegionCode			 = Pro.OriginatingRegionCode,
	PropertyFundCode				 = Pro.PropertyFundCode,
	FunctionalDepartmentCode		 = Pro.FunctionalDepartmentCode
	
FROM
	#ProfitabilityActual Pro
WHERE
	ProfitabilityActual.SourceKey = Pro.SourceKey AND
	ProfitabilityActual.ReferenceCode = Pro.ReferenceCode

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode
)
SELECT
	Pro.CalendarKey,
	Pro.GlAccountKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.ConsolidationRegionKey,
	Pro.PropertyFundKey,
	Pro.OverheadKey,
	Pro.ReferenceCode, 
	Pro.LocalCurrencyKey, 
	Pro.LocalActual,
	Pro.ProfitabilityActualSourceTableId, --BillingUploadDetail

	@EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----Pro.USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	Pro.GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	Pro.OriginatingRegionCode,
	Pro.PropertyFundCode,
	Pro.FunctionalDepartmentCode				
FROM
	#ProfitabilityActual Pro
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		ProExists.SourceKey	= Pro.SourceKey AND
		ProExists.ReferenceCode	= Pro.ReferenceCode

WHERE
	ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
--Uploaded BillingUploads should never be deleted ....
--hence we should never have to delete records

-- remove orphan rows from the warehouse that have been removed in the source data systems
EXEC stp_IU_ArchiveProfitabilityOverheadActual @ImportStartDate=@ImportStartDate, @ImportEndDate=@ImportEndDate, @DataPriorToDate=@DataPriorToDate

DROP TABLE #ManageType
DROP TABLE #ManageCorporateDepartment
DROP TABLE #ManageCorporateEntity
DROP TABLE #ManagePropertyDepartment
DROP TABLE #ManagePropertyEntity

DROP TABLE #ActivityTypeGLAccount
DROP TABLE #AllocationRegion
DROP TABLE #AllocationSubRegion
DROP TABLE #BillingUpload
DROP TABLE #BillingUploadDetail
DROP TABLE #Overhead
DROP TABLE #FunctionalDepartment
DROP TABLE #Project
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #GLGlobalAccount
DROP TABLE #ActivityType
DROP TABLE #OverheadRegion
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #ProfitabilityOverhead
DROP TABLE #ProfitabilityActual

DROP TABLE #ConsolidationRegionCorporateDepartment

GO


/*
7. dbo.stp_IU_ArchiveProfitabilityMRIActual.sql
*/ 

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityMRIActual]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    Description
	This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive 
	table. These rows no longer exist in the source data systems.

	This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, 
	given that access to its #ProfitabilityActual temporary table is required.

	┌─────────────────┬─────────────────┬──────────────────────────────────────────────────────────────────────────────────┐
	│   YYYY-MM-DD    │      PERSON     │                          DETAILS OF CHANGES MADE                                 │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-06-07    │    P Kayongo    │ Added ConsolidationRegionKey mapping from the ProfitabilityActual table to the   │
	│                 │                 │ ProfitabilityActualArchive table.                                                │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-06-30    │    I Saunder    │ Updated logic used to determine which fact records are no longer valid.          │
	└─────────────────┴─────────────────┴──────────────────────────────────────────────────────────────────────────────────┘

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

-- Get all records from all MRIs

SELECT
	*
INTO
	#AllGeneralLedgers
FROM
	(
		SELECT SourcePrimaryKey, 'US' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[USProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'UC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[USCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'EU' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[EUProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'EC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[EUCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'BR' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[BRProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'BC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[BRCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'IN' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[INProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'IC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[INCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'CN' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[CNProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'CC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[CNCorp].[GeneralLedger]		
	)
	AS AllGeneralLedgers
WHERE
	LastDate BETWEEN @ImportStartDate AND @ImportEndDate

CREATE UNIQUE CLUSTERED INDEX IX_AllGeneralLedgers_Clustered ON #AllGeneralLedgers(SourcePrimaryKey, SourceCode)

-- Find orphan rows using #ProfitabilityActual, which exists in the scope of the stored proc that executed this stored proc

SELECT
	GRPA.*
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA
	
	-- Need to join on Source because reference code is not source specific (we could have identical reference codes for different sources)
	INNER JOIN GrReporting.dbo.[Source] S ON
		GRPA.SourceKey = S.SourceKey
	
	-- Need to join here because we only consider JOURNAL and GHIS sources (not BillingUploadDetail from TAPAS)
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable PAST ON
		GRPA.ProfitabilityActualSourceTableId = PAST.ProfitabilityActualSourceTableId
	
	-- This join will determine all transactions in GrReporting.dbo.ProfitabilityActual that have been deleted in MRI	
	LEFT OUTER JOIN #AllGeneralLedgers AGL ON
		GRPA.ReferenceCode = AGL.SourcePrimaryKey AND
		S.SourceCode = AGL.SourceCode
	
	-- This join will determine all transactions in GrReporting.dbo.ProfitabilityActual that should no longer be there because of changes in
	-- business rules (i.e.: a new record in a ManageType table)
	LEFT OUTER JOIN #ProfitabilityActual PA ON
		GRPA.ReferenceCode = PA.ReferenceCode AND
		GRPA.SourceKey = PA.SourceKey
	
WHERE
	PAST.SourceTable IN ('JOURNAL', 'GHIS') AND
	(AGL.SourcePrimaryKey IS NULL OR PA.ReferenceCode IS NULL) -- If either a transaction as been deleted in MRI or a transaction in
															   -- dbo.ProfitabilityActual needs to be smoked because business rules have changed.

-- Update dbo.ProfitabilityActualArchive - it could be possible that we are archiving a record for the second time (although this is unlikely -
-- more to protect against duplicate inserts while running on DEV/TEST). If this is the case, update the record.

UPDATE
	PAA
SET
	PAA.CalendarKey = NPAAR.CalendarKey,
	PAA.GlAccountKey = NPAAR.GlAccountKey,
	PAA.SourceKey = NPAAR.SourceKey,
	PAA.FunctionalDepartmentKey = NPAAR.FunctionalDepartmentKey,
	PAA.ReimbursableKey = NPAAR.ReimbursableKey,
	PAA.ActivityTypeKey = NPAAR.ActivityTypeKey,
	PAA.PropertyFundKey = NPAAR.PropertyFundKey,
	PAA.OriginatingRegionKey = NPAAR.OriginatingRegionKey,
	PAA.AllocationRegionKey = NPAAR.AllocationRegionKey,
	PAA.LocalCurrencyKey = NPAAR.LocalCurrencyKey,
	PAA.LocalActual = NPAAR.LocalActual,
	PAA.ReferenceCode = NPAAR.ReferenceCode,
	PAA.ProfitabilityActualSourceTableId = NPAAR.ProfitabilityActualSourceTableId,
	PAA.EUCorporateGlAccountCategoryKey = NPAAR.EUCorporateGlAccountCategoryKey,
	PAA.USPropertyGlAccountCategoryKey = NPAAR.USPropertyGlAccountCategoryKey,
	PAA.USFundGlAccountCategoryKey = NPAAR.USFundGlAccountCategoryKey,
	PAA.EUPropertyGlAccountCategoryKey = NPAAR.EUPropertyGlAccountCategoryKey,
	PAA.USCorporateGlAccountCategoryKey = NPAAR.USCorporateGlAccountCategoryKey,
	PAA.DevelopmentGlAccountCategoryKey = NPAAR.DevelopmentGlAccountCategoryKey,
	PAA.EUFundGlAccountCategoryKey = NPAAR.EUFundGlAccountCategoryKey,
	PAA.GlobalGlAccountCategoryKey = NPAAR.GlobalGlAccountCategoryKey,
	PAA.EntryDate = NPAAR.EntryDate,
	PAA.[User] = NPAAR.[User],
	PAA.[Description] = NPAAR.[Description],
	PAA.AdditionalDescription = NPAAR.AdditionalDescription,
	PAA.OriginatingRegionCode = NPAAR.OriginatingRegionCode,
	PAA.PropertyFundCode = NPAAR.PropertyFundCode,
	PAA.FunctionalDepartmentCode = NPAAR.FunctionalDepartmentCode,
	PAA.OverheadKey = NPAAR.OverheadKey,
	PAA.InsertedDate = GETDATE(),
	PAA.ConsolidationRegionKey = NPAAR.ConsolidationRegionKey
FROM
	GrReporting.dbo.ProfitabilityActualArchive PAA
	
	INNER JOIN #NewProfitabilityActualArchiveRecords NPAAR ON
		PAA.ReferenceCode = NPAAR.ReferenceCode AND
		PAA.SourceKey = NPAAR.SourceKey

-- Insert new orphan rows into dbo.ProfitabilityActualArchive table. We do not want to insert duplicate records; hence the LEFT OUTER JOIN and NULL

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive
(
	ProfitabilityActualArchiveKey,
    CalendarKey,
    GlAccountKey,
    SourceKey,
    FunctionalDepartmentKey,
    ReimbursableKey,
    ActivityTypeKey,
    PropertyFundKey,
    OriginatingRegionKey,
    AllocationRegionKey,
    LocalCurrencyKey,
    LocalActual,
    ReferenceCode,
    ProfitabilityActualSourceTableId,
    EUCorporateGlAccountCategoryKey,
    USPropertyGlAccountCategoryKey,
    USFundGlAccountCategoryKey,
    EUPropertyGlAccountCategoryKey,
    USCorporateGlAccountCategoryKey,
    DevelopmentGlAccountCategoryKey,
    EUFundGlAccountCategoryKey,
    GlobalGlAccountCategoryKey,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
    OriginatingRegionCode,
    PropertyFundCode,
    FunctionalDepartmentCode,
    OverheadKey,
    InsertedDate,
    ConsolidationRegionKey
)
SELECT
	NPAAR.ProfitabilityActualKey,
    NPAAR.CalendarKey,
    NPAAR.GlAccountKey,
    NPAAR.SourceKey,
    NPAAR.FunctionalDepartmentKey,
    NPAAR.ReimbursableKey,
    NPAAR.ActivityTypeKey,
    NPAAR.PropertyFundKey,
    NPAAR.OriginatingRegionKey,
    NPAAR.AllocationRegionKey,
    NPAAR.LocalCurrencyKey,
    NPAAR.LocalActual,
    NPAAR.ReferenceCode,
    NPAAR.ProfitabilityActualSourceTableId,
    NPAAR.EUCorporateGlAccountCategoryKey,
    NPAAR.USPropertyGlAccountCategoryKey,
    NPAAR.USFundGlAccountCategoryKey,
    NPAAR.EUPropertyGlAccountCategoryKey,
    NPAAR.USCorporateGlAccountCategoryKey,
    NPAAR.DevelopmentGlAccountCategoryKey,
    NPAAR.EUFundGlAccountCategoryKey,
    NPAAR.GlobalGlAccountCategoryKey,
    NPAAR.EntryDate,
    NPAAR.[User],
    NPAAR.[Description],
    NPAAR.AdditionalDescription,
    NPAAR.OriginatingRegionCode,
    NPAAR.PropertyFundCode,
    NPAAR.FunctionalDepartmentCode,
    NPAAR.OverheadKey,
    GETDATE(),
    NPAAR.ConsolidationRegionKey
FROM
	#NewProfitabilityActualArchiveRecords NPAAR
 
	LEFT JOIN GrReporting.dbo.ProfitabilityActualArchive PAA ON
		NPAAR.ReferenceCode = PAA.ReferenceCode AND
		NPAAR.SourceKey = PAA.SourceKey
WHERE
	PAA.ReferenceCode IS NULL

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE
FROM
	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

--

PRINT 'Completed removing all orphan records from GrReporting.dbo.ProfitabilityActual: '+ LTRIM(RTRIM(CONVERT(char(20),@@rowcount)))
PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #AllGeneralLedgers
DROP TABLE #NewProfitabilityActualArchiveRecords

GO




