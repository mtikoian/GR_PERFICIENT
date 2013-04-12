/*
Stored Proc List of what needs to be added to this list:

[stp_IU_ArchiveProfitabilityMRIActual]
[stp_IU_ArchiveProfitabilityOverheadActual]
[stp_IU_LoadGrProfitabiltyGeneralLedger]
[stp_IU_LoadGrProfitabiltyOverhead]

ALL GeneralLedger view must be deployed

*/ 

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityMRIActual]    Script Date: 11/01/2010 07:08:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityMRIActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityMRIActual]    Script Date: 11/01/2010 07:08:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive table. These rows no longer exist in
the source data systems.

This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, given that access to its
#ProfitabilityActual temporary table is required.
*/

/*

DECLARE	@ImportStartDate DateTime
DECLARE	@ImportEndDate DateTime
DECLARE	@DataPriorToDate DateTime

SET	@ImportStartDate = '1900-01-01'
SET	@ImportEndDate = '2010-12-31'
SET	@DataPriorToDate = '2010-12-31'

*/

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

CREATE UNIQUE CLUSTERED INDEX IX_AllGeneralLedgers_Clustered ON #AllGeneralLedgers(SourcePrimaryKey, SourceCode)

-- Find orphan rows using #ProfitabilityActual, which exists in the scope of the stored proc that executed this stored proc

SELECT
	GRPA.*
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA

	INNER JOIN GrReporting.dbo.Source S ON
		S.SourceKey = GRPA.SourceKey
	
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable PAST ON
		GRPA.ProfitabilityActualSourceTableId = PAST.ProfitabilityActualSourceTableId	
	
	INNER JOIN #AllGeneralLedgers AGL ON
		S.SourceCode = AGL.SourceCode AND
		GRPA.ReferenceCode = AGL.SourcePrimaryKey
			
	LEFT OUTER JOIN #ProfitabilityActual GRSPA ON
		GRPA.ReferenceCode = GRSPA.ReferenceCode AND
		GRPA.SourceKey = GRSPA.SourceKey

WHERE
	GRSPA.ReferenceCode IS NULL AND
	PAST.SourceTable IN ('JOURNAL', 'GHIS') AND
	AGL.LastDate BETWEEN @ImportStartDate AND @ImportEndDate

-- Insert orphan rows into dbo.ProfitabilityActualArchive table

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive

SELECT
	NPAAR.*,
	GETDATE()
FROM
	#NewProfitabilityActualArchiveRecords NPAAR

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE
FROM
	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

--

PRINT 'Completed removing all orphan records from GrReporting.dbo.ProfitabilityActual:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #AllGeneralLedgers
DROP TABLE #NewProfitabilityActualArchiveRecords


GO


-------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]    Script Date: 11/01/2010 07:09:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityOverheadActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]    Script Date: 11/01/2010 07:09:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive table. These rows no longer exist in
the source data systems.

This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyOverhead, given that access to its
#ProfitabilityActual temporary table is required.
*/

/*

DECLARE	@ImportStartDate DateTime
DECLARE	@ImportEndDate DateTime
DECLARE	@DataPriorToDate DateTime

SET	@ImportStartDate = '1900-01-01'
SET	@ImportEndDate = '2010-12-31'
SET	@DataPriorToDate = '2010-12-31'

*/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

SELECT
	BUD.*,
	('BillingUploadDetailId=' + CONVERT(VARCHAR(20), BUD.BillingUploadDetailId)) AS ReferenceCode
INTO
	#ActiveBillingUploadDetail
FROM
	GrReportingStaging.TapasGlobal.BillingUploadDetail BUD
	INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BUDA ON
		BUDA.ImportKey = BUD.ImportKey


SELECT
	GRPA.*
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA

	INNER JOIN GrReporting.dbo.Source S ON
		S.SourceKey = GRPA.SourceKey
	
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable PAST ON
		GRPA.ProfitabilityActualSourceTableId = PAST.ProfitabilityActualSourceTableId	
	
	INNER JOIN #ActiveBillingUploadDetail ABUD ON
		GRPA.ReferenceCode = ABUD.ReferenceCode
			
	LEFT OUTER JOIN #ProfitabilityActual GRSPA ON
		GRPA.ReferenceCode = GRSPA.ReferenceCode AND
		GRPA.SourceKey = GRSPA.SourceKey

WHERE
	GRSPA.ReferenceCode IS NULL AND
	PAST.SourceTable = 'BillingUploadDetail' AND
	ABUD.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive

SELECT
	NPAAR.*,
	GETDATE()
FROM
	#NewProfitabilityActualArchiveRecords NPAAR

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE
FROM
	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

DROP TABLE #ActiveBillingUploadDetail
DROP TABLE #NewProfitabilityActualArchiveRecords


GO


----------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 11/01/2010 07:09:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 11/01/2010 07:09:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*

DECLARE	@ImportStartDate DateTime
DECLARE	@ImportEndDate DateTime
DECLARE	@DataPriorToDate DateTime

SET	@ImportStartDate = '1900-01-01'
SET	@ImportEndDate = '2010-12-31'
SET	@DataPriorToDate = '2010-12-31'

*/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

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
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN') -- GDM: changed GlAccountCode to Code
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey			 = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNK')
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

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
		Em.[Source] = Gl.SourceCode
			
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
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'CN')
	) AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

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
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
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
	PostingPropertyGLAccountCode,
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
	GATST.PostingPropertyGLAccountCode,
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

PRINT 'Completed inserting Active records INTo temp table'
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
		Fd.FunctionalDepartmentId = ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)

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
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrGa.StartDate AND GrGa.EndDate

	LEFT OUTER JOIN #GLGlobalAccount GA ON --#GlobalGlAccount Glo
		GA.GLGlobalAccountId = GAGLA.GLGlobalAccountId
		--ON Glo.GlobalGlAccountId = Gam.GlobalGlAccountId

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = GA.ActivityTypeId

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAt.StartDate AND GrAt.EndDate

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
		ISNULL(Gl.LastDate, EnterDate) BETWEEN OrR.StartDate AND OrR.EndDate
	
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
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		--ON GrAr.GlobalRegionId = Arm.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate

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
		Gla.GlAccountKey = Gl.GlAccountKey

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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'EU CORP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
		
			
PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'EU PROP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'EU FUND' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'US PROP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'US CORP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'US FUND' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		


--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'DEV' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
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
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/

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


GO


-------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 11/01/2010 07:09:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 11/01/2010 07:09:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

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
	Name VARCHAR(50) NOT NULL,
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
	Name VARCHAR(50) NOT NULL,
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
	Name VARCHAR(50) NOT NULL,
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
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
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
	PostingPropertyGLAccountCode,
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
	GATST.PostingPropertyGLAccountCode,
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

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON -- added
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
		RECDC.SourceCode = P1.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007' AND		   
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON -- added
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
		REPEC.SourceCode = P1.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007' AND
		REPEC.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		pfm.PropertyFundCode = P1.CorporateDepartmentCode AND -- Combination of entity and corporate department
		pfm.SourceCode = P1.CorporateSourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
			)
		) AND Bu.ExpensePeriod < '201007' 
		
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Bu.ExpensePeriod < '201007' THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = 'YES' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END -- extra condition? re: date

	-- P1 end -----------------------
	-- P2 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO
		ON GrScO.SourceCode = P2.CorporateSourceCode

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
				WHEN Bu.ExpensePeriod < '201007' THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END	

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
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		-- ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate ???????

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
		Gl.UpdatedDate BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate)
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = 'ALLOC'
		
	LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
		AtGla.ActivityTypeId = At.ActivityTypeId

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		GA.Code = AtGla.GLAccountCode AND
		ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGA ON
		GrGA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		Gl.UpdatedDate BETWEEN GrGA.StartDate AND GrGA.EndDate
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.CorporateSourceCode
	
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = Gl.PropertyFundId AND
		Gl.UpdatedDate BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
	
	-- Overheads should only be sourced from Corporate, but the mapping for property below has been included	
	--LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
	--	ORPD.PropertyDepartmentCode = Gl.OriginatingRegionCode AND
	--	ORPD.SourceCode = Gl.OriginatingRegionSourceCode AND
	--	ORPD.IsDeleted = 0		  
		   
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ORCE.GlobalRegionId AND
		--GrOr.GlobalRegionId = ORPD.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate)
	
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = Gl.PropertyFundId --AND
		--PF.IsActive = 1

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate)

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
									WHEN Gl.CanAllocateOverheads = 1 THEN 
										CASE
											WHEN ISNULL(RiCo.NETTSCOST, 'N') = 'Y' THEN 'NO' ELSE 'YES'
										END
									ELSE 'NO'
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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityActual Gl

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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU CORP' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU PROP' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU FUND' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US PROP' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityActual Gl

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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US CORP' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US FUND' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		
--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
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
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'DEV' AND 
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
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/
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


GO


-------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
DROP VIEW [BRCorp].[GeneralLedger]
GO
/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
DROP VIEW [BRProp].[GeneralLedger]
GO
/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
DROP VIEW [CNCorp].[GeneralLedger]
GO
/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
DROP VIEW [CNProp].[GeneralLedger]
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
DROP VIEW [EUCorp].[GeneralLedger]
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
DROP VIEW [EUProp].[GeneralLedger]
GO
/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
DROP VIEW [INCorp].[GeneralLedger]
GO
/****** Object:  View [INProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
DROP VIEW [INProp].[GeneralLedger]
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
DROP VIEW [USCorp].[GeneralLedger]
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
DROP VIEW [USProp].[GeneralLedger]
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From USProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableId,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From USProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [USCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From USCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From USCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


'
GO
/****** Object:  View [INProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [INProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From INProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From INProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [INCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From INCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From INCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
create VIEW [EUProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From EUProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From EUProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [EUCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From EUCorp.GrGHis
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From EUCorp.GrJournal 

'
GO
/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From CNProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From CNProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [CNCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From CNCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp

UNION ALL
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From CNCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


'
GO
/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From BRProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From BRProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 11/01/2010 07:14:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From BRCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp

UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From BRCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


'
GO

