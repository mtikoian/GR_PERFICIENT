USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 11/22/2011 09:42:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
GO



/***********************************************************************************************************************************************
Description
	This stored procedure processes overhead transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
	1.	Set the default unknown values to be used in the fact tables
	2.	Get data exclusion lists (Manage Type tables) from GDM
	3.	Map Global GL Accounts to Activity Types
	4.	Obtain source transaction data from Tapas Global
	5.	Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
	6.	Obtain GL Account mapping data from GDM
	7.	Map the source transaction data to mapping data from GDM, HR and GACS
	8.	Remove records from the #ProfitabilityOverhead table mapped to records in the exclusion tables
	9.	Take the different sources and combine them into the #ProfitabilityActual table
	10. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
	11. Clean Up
	
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
			2011-10-04		: PKayongo	:	Updated the stored procedure with the new GL Account Categorization 
											mapping (CC16)
************************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
      @ImportStartDate	DATETIME = NULL,
      @ImportEndDate	DATETIME = NULL,
      @DataPriorToDate	DATETIME = NULL
AS

SET NOCOUNT ON

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyOverhead'
PRINT '####'

IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportOverheadActuals') <> 1)
BEGIN
	PRINT ('Import of Overhead Actuals is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...')
	RETURN
END

IF (@ImportStartDate IS NULL)
BEGIN
	SET @ImportStartDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportStartDate'))
END

IF (@ImportEndDate IS NULL)
BEGIN
	SET @ImportEndDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportEndDate'))
END

IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
END

/* ==============================================================================================================================================
	1. Set the default unknown values to be used in the fact tables - these are used when a join can't be made to a dimension
   =========================================================================================================================================== */
BEGIN

DECLARE @FunctionalDepartmentKeyUnknown		 INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
DECLARE @ReimbursableKeyUnknown				 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
DECLARE @ActivityTypeKeyUnknown				 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
DECLARE @SourceKeyUnknown					 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN')
DECLARE @OriginatingRegionKeyUnknown		 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
DECLARE @AllocationRegionKeyUnknown			 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
DECLARE @PropertyFundKeyUnknown				 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
DECLARE @OverheadKeyUnknown					 INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')
DECLARE @GlCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'UNKNOWN' AND SnapshotId = 0)
DECLARE	@LocalCurrencyKeyUnknown			 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Property' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Fund' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Property' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'EU Fund' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'US Development' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = 'UNKNOWN' AND GLCategorizationName = 'Global' AND SnapshotId = 0)



END

/* ==============================================================================================================================================
	2. Get data exclusion lists (Manage Type tables) from GDM
   =========================================================================================================================================== */
BEGIN

	/* Temp table creation and data inserts - Change Control 7
		The ManageType tables are used to exclude certain data from being inserted into the ProfitabilityActual fact table.
		ManageCorporateDepartment excludes Corporate Departments.
		ManageCorporateEntity excludes Corporate Entities.
		
		ManagePropertyDepartment and ManagePropertyEntity are not included in the stored procedure because they are not required.

	*/

-- #ManageType
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
WHERE
	MT.IsDeleted = 0

-- #ManageCorporateDepartment
CREATE TABLE #ManageCorporateDepartment
(
	ManageCorporateDepartmentId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #ManageCorporateDepartment
(
	ManageCorporateDepartmentId,
	ManageTypeId,
	CorporateDepartmentCode,
	SourceCode
)
SELECT
	MCD.ManageCorporateDepartmentId,
	MCD.ManageTypeId,
	MCD.CorporateDepartmentCode,
	MCD.SourceCode
FROM
	Gdm.ManageCorporateDepartment MCD
	INNER JOIN Gdm.ManageCorporateDepartmentActive(@DataPriorToDate) MCDA ON
		MCD.ImportKey = MCDA.ImportKey
	INNER JOIN #ManageType MT ON
		MCD.ManageTypeId = MT.ManageTypeId  
WHERE
	MT.Code = 'GMREXCL' AND
	MCD.IsDeleted = 0

-- #ManageCorporateEntity
CREATE TABLE #ManageCorporateEntity
(
	ManageCorporateEntityId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #ManageCorporateEntity
(
	ManageCorporateEntityId,
	ManageTypeId,
	CorporateEntityCode,
	SourceCode
)
SELECT
	MCE.ManageCorporateEntityId,
	MCE.ManageTypeId,
	MCE.CorporateEntityCode,
	MCE.SourceCode
FROM
	Gdm.ManageCorporateEntity MCE
	
	INNER JOIN Gdm.ManageCorporateEntityActive(@DataPriorToDate) MCEA ON
		MCE.ImportKey = MCEA.ImportKey
		
	INNER JOIN #ManageType MT ON
		MCE.ManageTypeId = MT.ManageTypeId  
WHERE
	MT.Code = 'GMREXCL' AND
	MCE.IsDeleted = 0

-- change control 7 end
END

/* ==============================================================================================================================================
	3. Map Global GL Accounts to Activity Types
   =========================================================================================================================================== */
BEGIN

	/*
		TAPAS does not use MRI GL Accounts.
		The purpose of the #ActivityTypeGLAccount table below is to map the TAPAS Global transactions to GDM Global Accounts based on the
		Activity Type of the record.
	*/

CREATE TABLE #ActivityTypeGLAccount
(
	ActivityTypeId INT NULL,
	GLAccountCode VARCHAR(12) NOT NULL
)

INSERT INTO #ActivityTypeGLAccount 
(
	ActivityTypeId, 
	GLAccountCode
)
VALUES
	(NULL, '5002950000'),  -- Header
	(1, '5002950001'),     -- Leasing
	(2, '5002950002'),     -- Acquisitions
	(3, '5002950003'),     -- Asset Management
	(4, '5002950004'),     -- Development
	(5, '5002950005'),     -- Property Management Escalatable
	(6, '5002950006'),     -- Property Management Non-Escalatable
	(7, '5002950007'),     -- Syndication (Investment and Fund)
	(8, '5002950008'),     -- Fund Organization
	(9, '5002950009'),     -- Fund Operations
	(10, '5002950010'),    -- Property Management TI
	(11, '5002950011'),    -- Property Management CapEx
	(12, '5002950012'),    -- Corporate
	(99, '5002950099')     -- Corporate Overhead (No corporate overhead (5002950099) account  use header instead)
	
PRINT 'Rows Inserted into #ActivityTypeGLAccount:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
END
	
/* ==============================================================================================================================================
	4. Obtain source transaction data from Tapas Global
   =========================================================================================================================================== */
BEGIN

	/*
		The Billing Upload table has an OverheadId field. If this field is not null, it indicates that the transactions within the upload are
		Overhead transactions (and not Payroll transactions). The purpose of the table is to filter the BillingUpload table to make sure only
		Overhead transactions are processed.
	*/

CREATE TABLE #Overhead
(
	OverheadId INT NOT NULL
)
INSERT INTO #Overhead 
(
	OverheadId
)
SELECT 
	 Oh.OverheadId
FROM
	TapasGlobal.Overhead Oh 
	
	INNER JOIN TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
		Oh.ImportKey = OhA.ImportKey

PRINT 'Rows Inserted into #Overhead:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_Overhead_OverheadId ON #Overhead(OverheadId)

	/*
		The BillingUpload table stores information of files that contain Overhead information that have been uploaded to Tapas Global
	*/

CREATE TABLE #BillingUpload
(
	BillingUploadId INT NOT NULL,
	BillingUploadBatchId INT NULL,
	OverheadId INT NULL,
	OverheadRegionId INT NULL,
	ProjectId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	ActivityTypeId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NULL,
	FunctionalDepartmentId INT NULL
)
INSERT INTO #BillingUpload 
(
	BillingUploadId,
	BillingUploadBatchId,
	OverheadId,
	OverheadRegionId,
	ProjectId,
	ExpensePeriod,
	UpdatedDate,
	ActivityTypeId,
	OverheadFunctionalDepartmentId,
	FunctionalDepartmentId
)
SELECT 
	Bu.BillingUploadId,
	Bu.BillingUploadBatchId,
	Bu.OverheadId,
	Bu.OverheadRegionId,
	Bu.ProjectId,
	Bu.ExpensePeriod,
	Bu.UpdatedDate,
	Bu.ActivityTypeId,
	Bu.OverheadFunctionalDepartmentId,
	Bu.FunctionalDepartmentId
FROM
	TapasGlobal.BillingUpload	Bu

	INNER JOIN TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA ON
		Bu.ImportKey = BuA.ImportKey
	/*
		Previously this join was done when all the tables are mapped together into the #ProfitabilityOverhead table. 
		This is done here now to make sure lessen the data that is being processed while the stored procedure is running
	*/	
	INNER JOIN #Overhead Oh ON -- Makes sure that only Ovherhead transactions are stored, and doesn't include Payroll.
		Bu.OverheadId = Oh.OverheadId 

PRINT 'Rows Inserted into #BillingUpload:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_BillingUpload_BillingUploadId ON #BillingUpload(BillingUploadId)
		
	/*
		The BillingUploadDetail table stores the transactions within the files that have been uploaded to Tapas Global
	*/

CREATE TABLE #BillingUploadDetail
(
	BillingUploadDetailId INT NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadDetailTypeId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	AllocationAmount DECIMAL(18, 9) NOT NULL,
	CurrencyCode CHAR(3) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
)
INSERT INTO #BillingUploadDetail 
(
	BillingUploadDetailId,
	BillingUploadId,
	BillingUploadDetailTypeId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	AllocationAmount,
	CurrencyCode,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Bud.BillingUploadDetailId,
	Bud.BillingUploadId,
	Bud.BillingUploadDetailTypeId,
	Bud.CorporateDepartmentCode,
	Bud.CorporateSourceCode,
	Bud.AllocationAmount,
	Bud.CurrencyCode,
	Bud.InsertedDate,
	Bud.UpdatedDate
FROM
	TapasGlobal.BillingUploadDetail Bud

	INNER JOIN TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA ON
		Bud.ImportKey = BudA.ImportKey
		
PRINT 'Rows Inserted into #BillingUploadDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*
		The #Project table is used to determine the Corporate Department transactions are mapped to
	*/

CREATE TABLE #Project
(
	ProjectId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)
INSERT INTO #Project 
(
	ProjectId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	P.ProjectId,
	P.CorporateDepartmentCode,
	P.CorporateSourceCode,
	P.CanAllocateOverheads,
	P.AllocateOverheadsProjectId
FROM
	TapasGlobal.Project P

	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) PA ON
		P.ImportKey = PA.ImportKey

PRINT 'Rows Inserted into #Project:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_Project_ProjectId ON #Project (ProjectId)

	/*
		The #OverheadRegion region table is used to determine the Originating Region of the overhead transactions
	*/

CREATE TABLE #OverheadRegion
(
	OverheadRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL
)
INSERT INTO #OverheadRegion
(
	OverheadRegionId,
	CorporateEntityRef,
	CorporateSourceCode
)
SELECT
	Ovr.OverheadRegionId,
	Ovr.CorporateEntityRef,
	Ovr.CorporateSourceCode
FROM
	TapasGlobal.OverheadRegion Ovr 

	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
			Ovr.ImportKey = OvrA.ImportKey
PRINT 'Rows Inserted into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
END

/* ==============================================================================================================================================
	5. Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The Functional Department table is used to map the transactions to their relevant Functional Departments.	
	*/ 
 
CREATE TABLE #FunctionalDepartment
(
	FunctionalDepartmentId INT NOT NULL,
	GlobalCode CHAR(3) NULL
)
INSERT INTO #FunctionalDepartment 
(
	FunctionalDepartmentId,
	GlobalCode
)
SELECT
	Fd.FunctionalDepartmentId,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd

	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		Fd.ImportKey = FdA.ImportKey

PRINT 'Rows Inserted into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)

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
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)
INSERT INTO #PropertyFundMapping
(
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
		Pfm.ImportKey = PfmA.ImportKey
WHERE
	IsDeleted = 0

PRINT 'Rows Inserted into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_PropertyFundMapping_PropertyFundCode ON #PropertyFundMapping (PropertyFundCode, SourceCode, ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #AllocationSubRegion table is used to filter GlobalRegion to make sure the Allocation Sub Region specified by the #PropertyFund
		table is flagged as an Allocation Region in the GlobalRegion table in GDM.	
	*/

CREATE TABLE #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	AllocationRegionGlobalRegionId INT NULL
)
INSERT INTO #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId,
	AllocationRegionGlobalRegionId
)
SELECT
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.AllocationRegionGlobalRegionId
FROM
	Gdm.AllocationSubRegion ASR

	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON
		ASR.ImportKey = ASRA.ImportKey
WHERE
	ASR.IsActive = 1

PRINT 'Rows Inserted into #AllocationSubRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_AllocationSubRegion_AllocationSubRegionGlobalRegionId ON #AllocationSubRegion(AllocationSubRegionGlobalRegionId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingEntityCorporateDepartment and #ReportingEntityPropertyEntity tables are used to determine the Property Funds of
		transactions (Property Funds are used to determine the Allocation Sub Region).
	*/

CREATE TABLE #ReportingEntityCorporateDepartment
( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL
)
INSERT INTO #ReportingEntityCorporateDepartment
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

PRINT 'Rows Inserted into #ReportingEntityCorporateDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityCorporateDepartment_CorporateDepartment ON #ReportingEntityCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ReportingEntityPropertyEntity	
	*/

CREATE TABLE #ReportingEntityPropertyEntity
( -- GDM 2.0 addition - used to be AllocationRegionMapping
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

PRINT 'Rows Inserted into #ReportingEntityPropertyEntity:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityPropertyEntity_PropertyEntity ON #ReportingEntityPropertyEntity(PropertyEntityCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyFund table is used to determine the Allocation Region of a transaction.	
	*/

CREATE TABLE #PropertyFund
( -- GDM 2.0 change
	PropertyFundId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL
)
INSERT INTO #PropertyFund
(
	PropertyFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId
)
SELECT
	PF.PropertyFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId
FROM
	Gdm.PropertyFund PF

	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PF.ImportKey = PFA.ImportKey
WHERE
	PF.IsActive = 1

PRINT 'Rows Inserted into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_PropertyFund_PropertyFundId ON #PropertyFund (PropertyFundId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ConsolidationRegionCorporateDepartment table is used to determine the Consolidation Region of a transaction.
		Note: It's assumed that Overhead transactions are only from Corporte Departments and not Property Entities, so the 
		ConsolidationRegionPropertyEntity table from Gdm has not been included.
	*/

CREATE TABLE #ConsolidationRegionCorporateDepartment
( -- CC16
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL
)
INSERT INTO #ConsolidationRegionCorporateDepartment
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

PRINT 'Rows Inserted into #ConsolidationRegionCorporateDepartment:'+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartment ON #ConsolidationRegionCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #OriginatingRegionCorporateEntity and #OriginatingRegionPropertyDepartment tables are used to determine the Originating Regions of 
		transactions.
	*/

-- #OriginatingRegionCorporateEntity
CREATE TABLE #OriginatingRegionCorporateEntity
( -- GDM 2.0 addition - used to be OriginatingRegionMapping
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

PRINT 'Rows Inserted into #OriginatingRegionCorporateEntity:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionCorporateEntity_CorporateEntity ON #OriginatingRegionCorporateEntity(CorporateEntityCode, SourceCode)

-- #OriginatingRegionPropertyDepartment

CREATE TABLE #OriginatingRegionPropertyDepartment
( -- GDM 2.0 addition - used to be OriginatingRegionMapping
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

PRINT 'Rows Inserted into #OriginatingRegionPropertyDepartment:'+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionPropertyDepartment_PropertyDepartment ON #OriginatingRegionPropertyDepartment(PropertyDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ActivityType table holds Activity Type information to be used for mapping to the Activity Type dimension and for determining the
		Global GL Accounts to be used (based on the #ActivityTypeGLAccount table).
	*/

CREATE TABLE #ActivityType
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL
)
INSERT INTO #ActivityType
(
	ActivityTypeId,
	ActivityTypeCode
)
SELECT
	At.ActivityTypeId,
	At.Code
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		At.ImportKey = Ata.ImportKey
WHERE
	AT.IsActive = 1

PRINT 'Rows Inserted into #ActivityType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_ActivityType_ActivityTypeId ON #ActivityType (ActivityTypeId)

END

/* ==============================================================================================================================================
	6. Obtain GL Account mapping data from GDM
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccount stores Global accounts and their associated Activity Types
	*/

CREATE TABLE #GLGlobalAccount
(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	Code VARCHAR(10) NOT NULL,
	IsActive BIT NOT NULL
)
INSERT INTO #GLGlobalAccount
(
	GLGlobalAccountId,
	ActivityTypeId,
	Code,
	IsActive
)
SELECT
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.Code,
	GLA.IsActive
FROM
	Gdm.GLGlobalAccount GLA

	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLA.ImportKey = GLAA.ImportKey
WHERE
	GLA.IsActive = 1

PRINT 'Rows Inserted into #GLGlobalAccount:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)		
CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccountCategorization table is used to map Global Accounts to Minor Categories for the relevant Categorizations	
	*/

CREATE TABLE #GLGlobalAccountCategorization
(
	GLGlobalAccountId INT NOT NULL,
	DirectGLMinorCategoryId INT NULL,
	IndirectGLMinorCategoryId INT NULL,
	CoAGLMinorCategoryId INT NULL,
	GLCategorizationId INT NOT NULL
)
INSERT INTO #GLGlobalAccountCategorization
(
	GLGlobalAccountId,
	DirectGLMinorCategoryId,
	IndirectGLMinorCategoryId,
	CoAGLMinorCategoryId,
	GLCategorizationId
)
SELECT
	GGAC.GLGlobalAccountId,
	GGAC.DirectGLMinorCategoryId,
	GGAC.IndirectGLMinorCategoryId,
	GGAC.CoAGLMinorCategoryId,
	GGAC.GLCategorizationId
FROM
	Gdm.GLGlobalAccountCategorization GGAC

	INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACa ON
		GGAC.ImportKey = GGACa.ImportKey
		
PRINT 'Rows Inserted into #GLGlobalAccountCategorization:'+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMinorCategory	
	*/

CREATE TABLE #GLMinorCategory
(
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL
)
INSERT INTO #GLMinorCategory
(
	GLMinorCategoryId,
	GLMajorCategoryId
)
SELECT
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId
FROM
	Gdm.GLMinorCategory MinC

	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinC.ImportKey = MinCA.ImportKey
WHERE
	MinC.IsActive = 1
	
PRINT 'Rows Inserted into #GLMinorCategory:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_GLMinorCategory_GLMinorCategoryId ON #GLMinorCategory(GLMinorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMajorCategory	
	*/

CREATE TABLE #GLMajorCategory
(
	GLMajorCategoryId INT NOT NULL,
	GLFinancialCategoryId INT NOT NULL
)
INSERT INTO #GLMajorCategory
(
	GLMajorCategoryId,
	GLFinancialCategoryId
)
SELECT
	MajC.GLMajorCategoryId,
	MajC.GLFinancialCategoryId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey
WHERE
	MajC.IsActive = 1

PRINT 'Rows Inserted into #GLMajorCategory:'+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_GLMajorCategory_GLMajorCategoryId ON #GLMajorCategory(GLMajorCategoryId)

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
	GLFinancialCategoryId,
	GLCategorizationId
FROM
	Gdm.GLFinancialCategory FinC

	INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) FinCa ON
		FinC.ImportKey = FinCa.ImportKey

PRINT 'Rows Inserted into #GLFinancialCategory:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)		
CREATE UNIQUE CLUSTERED INDEX UX_GLFinancialCategory_GLFinancialCategoryId ON #GLFinancialCategory(GLFinancialCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorization
	*/

CREATE TABLE #GLCategorization
(
	GLCategorizationId INT NOT NULL,
	GLCategorizationTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	RechargeSourceCode CHAR(2) NULL,
	IsConfiguredForRecharge BIT NULL
)
INSERT INTO #GLCategorization
(
	GLCategorizationId,
	GLCategorizationTypeId,
	[Name],
	RechargeSourceCode,
	IsConfiguredForRecharge
)
SELECT
	GC.GLCategorizationId,
	GC.GLCategorizationTypeId,
	GC.[Name],
	GC.RechargeSourceCode,
	GC.IsConfiguredForRecharge
FROM 
	Gdm.GLCategorization GC 
	INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCa ON
		GC.ImportKey = GCa.ImportKey
WHERE
	GC.IsActive = 1

PRINT 'Rows Inserted into #GLCategorization:'+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
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
	GCT.GLCategorizationTypeId
FROM
	Gdm.GLCategorizationType GCT 
	INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTa ON
		GCT.ImportKey = GCTa.ImportKey

PRINT 'Rows Inserted into #GLCategorizationType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyOverheadPropertyGLAccount will be used to determine the GLAccount and GLGlobalAccount for Local Categorizations
	*/

CREATE TABLE #PropertyOverheadPropertyGLAccount
(
	GLCategorizationId INT NOT NULL,
	ActivityTypeId INT NULL,
	FunctionalDepartmentId INT NULL,
	PropertyGLAccountId INT NULL,
	GLGlobalAccountId INT NULL
)
INSERT INTO #PropertyOverheadPropertyGLAccount
(
	GLCategorizationId,
	ActivityTypeId,
	FunctionalDepartmentId,
	PropertyGLAccountId,
	GLGlobalAccountId
)
SELECT
	GLCategorizationId,
	ActivityTypeId,
	FunctionalDepartmentId,
	PropertyGLAccountId,
	GLGlobalAccountId
FROM
	Gdm.PropertyOverheadPropertyGLAccount POPGA 
	INNER JOIN Gdm.PropertyOverheadPropertyGLAccountActive(@DataPriorToDate) POPGAa ON
		POPGA.ImportKey = POPGAa.ImportKey

PRINT 'Rows Inserted into #PropertyOverheadPropertyGLAccount:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLAccount table is used to map local GL Accounts for local GL Categorization mappings.
	*/

CREATE TABLE #GLAccount
(
	GLAccountId INT NOT NULL,
	GLGlobalAccountId INT NULL
)
INSERT INTO #GLAccount
(
	GLAccountId,
	GLGlobalAccountId
)
SELECT
	GA.GLAccountId,
	GA.GLGlobalAccountId
FROM
	Gdm.GLAccount GA
	INNER JOIN Gdm.GlAccountActive(@DataPriorToDate) GAa ON
		GA.ImportKey = GAa.ImportKey
WHERE
	GA.IsActive = 1

PRINT 'Rows Inserted into #GLAccount:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_GLAccount_GLAccountId ON #GLAccount(GLAccountId)

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

PRINT 'Rows Inserted into #ReportingCategorization:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_ReportingCategorization_Categorization ON #ReportingCategorization(EntityTypeId, AllocationSubRegionGlobalRegionId)
		
PRINT 'Completed inserting Active records into temp table'
PRINT CONVERT(Varchar(27), getdate(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Global Categorization Mapping

		The table below is used to map Gl Accounts to their Categorization Hierarchies for the Global Categorization.
		The GlobalGL Accounts used are the list from the #ActivityTypeGLAccount table created earlier.
	*/

CREATE TABLE #GlobalGLCategorizationMapping
(
	GLGlobalAccountId INT NOT NULL,
	GlobalGLCategorizationHierarchyCode VARCHAR(50) NOT NULL
)
INSERT INTO #GlobalGLCategorizationMapping
(
	GLGlobalAccountId,
	GlobalGLCategorizationHierarchyCode
)
SELECT
	GGA.GLGlobalAccountId,
	CONVERT(VARCHAR(2), ISNULL(GCT.GLCategorizationTypeId, -1)) + ':' +
		CONVERT(VARCHAR(5), ISNULL(GC.GLCategorizationId, -1)) + ':' +
		CONVERT(VARCHAR(10), ISNULL(FinC.GLFinancialCategoryId, -1)) + ':' +
		CONVERT(VARCHAR(10), ISNULL(MajC.GLMajorCategoryId, -1)) + ':' +
		CONVERT(VARCHAR(10), ISNULL(MinC.GLMinorCategoryId, -1)) + ':' +
		CONVERT(VARCHAR(10), GGA.GLGlobalAccountId)
FROM
	#GLGlobalAccount GGA 
		
	INNER JOIN #ActivityTypeGLAccount ATGA ON
		GGA.Code = ATGA.GLAccountCode
	
	LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
		GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
		GGAC.GLCategorizationId = 233 -- Limit this to the Global Categorization
	
	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId -- Overhead transactions from TAPAS Global are considered indirect transactions
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId  
		
	LEFT OUTER JOIN #GLFinancialCategory FinC ON
		MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId
		
	LEFT OUTER JOIN #GLCategorization GC ON
		FinC.GLCategorizationId = GC.GLCategorizationId  
	
	LEFT OUTER JOIN  #GLCategorizationType GCT ON
		GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId 

PRINT 'Rows Inserted into #GlobalGLCategorizationMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_GlobalGLCategorizationMapping_GLGlobalAccountId ON #GlobalGLCategorizationMapping(GLGlobalAccountId)
-- 

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Local Categorization Mappings

		The #LocalGLCategorizationMapping table below is used to determine the local GLCategorizationHierchy Codes.
		The table is pivoted (i.e. each of the GLCategorizationHierchy Codes for each GLCategorization appear as a separate column for each
			ActivityType-FunctionalDepartment combination)so that it only joins to the #ProfitabilityActual table below once.		
	*/

CREATE TABLE #LocalGLCategorizationMapping(
	FunctionalDepartmentId INT NULL,
	ActivityTypeId INT NULL,
	USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL
)
INSERT INTO #LocalGLCategorizationMapping(
	FunctionalDepartmentId,
	ActivityTypeId,
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
			GC.Name as GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GC.GLCategorizationTypeId, -1)) + ':' +
			CONVERT(VARCHAR(10), ISNULL(GC.GLCategorizationId, -1)) + ':' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(FinC.GLFinancialCategoryId, -1) END) + ':' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MajC.GLMajorCategoryId, -1) END) + ':' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MinC.GLMinorCategoryId, -1) END) + ':' +
			CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode
		FROM
			#PropertyOverheadPropertyGLAccount POPGA
			
			INNER JOIN #ActivityType AType ON
				ISNULL(POPGA.ActivityTypeId, 0) = CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END
			
			INNER JOIN #FunctionalDepartment FD ON
				ISNULL(POPGA.FunctionalDepartmentId, 0) = CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END
			
			INNER JOIN #GLCategorization GC ON
				POPGA.GLCategorizationId = GC.GLCategorizationId
				
			INNER JOIN #GLAccount GA ON
				POPGA.PropertyGLAccountId = GA.GLAccountId  
				
			/*
				If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
				If the local Categorization is not configured for recharge, the Global account is determined directly from the 
					#PropertyOverheadPropertyGLAccount table
			*/
			INNER JOIN #GLGlobalAccount GGA ON
				GGA.GLGlobalAccountId = 
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GA.GLGlobalAccountId
						ELSE
							POPGA.GLGlobalAccountId
					END
					
			LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
				GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId  AND
				POPGA.GLCategorizationId = GGAC.GLCategorizationId
			
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
				GC.GLCategorizationId = FinC.GLCategorizationId 

				
	) LocalMappings
	PIVOT
	(
		MAX(GLCategorizationHierarchyCode)
		FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
	) AS PivotTable

PRINT 'Rows Inserted into #LocalGLCategorizationMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_LocalGLCategorizationMapping_Categorization ON #LocalGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId)

END

/* ==============================================================================================================================================
	7. Map the source transaction data to mapping data from GDM, HR and GACS
   =========================================================================================================================================== */
BEGIN

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
	FunctionalDepartmentId INT NULL,
	FunctionalDepartmentCode CHAR(3) NULL,
	ActivityTypeCode VARCHAR(10) NULL,
	ExpenseType VARCHAR(8) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual DECIMAL(18,9) NOT NULL,
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
	FunctionalDepartmentId,
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
	ISNULL(P2.CorporateDepartmentCode, Bud.CorporateDepartmentCode) AS CorporateDepartmentCode,
	
	Bud.CorporateSourceCode,
	ISNULL(P2.CanAllocateOverheads, P1.CanAllocateOverheads) AS CanAllocateOverheads,
	
	Bu.ExpensePeriod,
	GrAr.RegionCode AllocationRegionCode, 
	CRCDC.GlobalRegionId ConsolidationSubRegionGlobalRegionId, 
	Ovr.CorporateEntityRef OriginatingRegionCode,
	Ovr.CorporateSourceCode OriginatingRegionSourceCode,
	
	CASE
		WHEN
			(P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0)
		THEN
			ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId, --This is seen as the Gdm.Gr.GlobalPropertyFundId

	Fd.FunctionalDepartmentId,
	Fd.GlobalCode FunctionalDepartmentCode,
	At.ActivityTypeCode,
	'Overhead' ExpenseType,
	Bud.CurrencyCode ForeignCurrency,
	Bud.AllocationAmount ForeignActual,
	Bud.UpdatedDate,
	Bud.InsertedDate,
	
	CASE
		WHEN
			(P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0)
		THEN
			Bud.CorporateDepartmentCode
		ELSE
			P2.CorporateDepartmentCode
	END AS PropertyFundCode
	
FROM
	#BillingUpload Bu
		
	INNER JOIN #BillingUploadDetail Bud ON
		Bu.BillingUploadId = Bud.BillingUploadId  

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Bu.FunctionalDepartmentId = Fd.FunctionalDepartmentId -- CC22 - used to look like: Fd.FunctionalDepartmentId = Bu.OverheadFunctiona

	LEFT OUTER JOIN #Project P1 ON
		Bu.ProjectId = P1.ProjectId  

	LEFT OUTER JOIN #Project P2 ON
		P1.AllocateOverheadsProjectId = P2.ProjectId  

	-- P1 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		P1.CorporateSourceCode = GrScC.SourceCode 

	/*
		2010-11-23
		The commented code below is what was previously used to determine the corporate department of an overhead actual.
		The join criteria shows that the budget project's corporate department is used for this. This approach isn't suitable as this field
		could change at any time (and has). A more stable strategy is to use the corporate department that is saved in the budget upload
		detail table, as this is guaranteed to never change (unless someone manually changes it via the back end).
	*/


	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON -- added
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(Bud.CorporateDepartmentCode)) = RECDC.CorporateDepartmentCode AND
		Bud.CorporateSourceCode = RECDC.SourceCode AND
		Bu.ExpensePeriod >= 201007
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON -- added
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		LTRIM(RTRIM(Bud.CorporateDepartmentCode)) = REPEC.PropertyEntityCode AND
		Bud.CorporateSourceCode = REPEC.SourceCode AND
		Bu.ExpensePeriod >= 201007
		
	LEFT OUTER JOIN	#ConsolidationRegionCorporateDepartment CRCDC ON -- CC16 : It is assumed that overheads are to come from corproate departemtns only
		CRCDC.CorporateDepartmentCode = 
			CASE
				WHEN
					P1.AllocateOverheadsProjectId IS NULL
				THEN
					Bud.CorporateDepartmentCode
				ELSE 
					P2.CorporateDepartmentCode
			END AND
		Bud.CorporateSourceCode = CRCDC.SourceCode AND
		Bu.ExpensePeriod >= 201101
		   
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		Bud.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		Bud.CorporateSourceCode = pfm.SourceCode AND
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
				WHEN
					Bu.ExpensePeriod < 201007
				THEN
					pfm.PropertyFundId
				ELSE
					ISNULL(RECDC.PropertyFundId, REPEC.PropertyFundId)
			END AND
		Bu.UpdatedDate BETWEEN DepartmentPropertyFund.StartDate AND DepartmentPropertyFund.EndDate AND
		DepartmentPropertyFund.SnapshotId = 0

	-- P1 end -----------------------
	-- P2 begin ---------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
		P2.CorporateSourceCode = GrScO.SourceCode  

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
		LTRIM(RTRIM(P2.CorporateDepartmentCode))  = RECDO.CorporateDepartmentCode AND
		P2.CorporateSourceCode = RECDO.SourceCode AND
		Bu.ExpensePeriod >= '201007' 
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON -- added
		GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
		LTRIM(RTRIM(P2.CorporateDepartmentCode))  = REPEO.PropertyEntityCode AND
		P2.CorporateSourceCode = REPEO.SourceCode AND
		Bu.ExpensePeriod >= '201007'
		

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
				WHEN
					Bu.ExpensePeriod < 201007
				THEN
					opfm.PropertyFundId
				ELSE
					CASE
						WHEN
							GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END AND
		Bu.UpdatedDate BETWEEN OverheadPropertyFund.StartDate AND OverheadPropertyFund.EndDate AND
		OverheadPropertyFund.SnapshotId = 0

	-- P2 end -----------------------

	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = (
								CASE
									WHEN
										(P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0)
									THEN 
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
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		Bu.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate AND
		GrAr.SnapshotId = 0

	LEFT OUTER JOIN #ActivityType At ON
		Bu.ActivityTypeId = At.ActivityTypeId  

	LEFT OUTER JOIN #OverheadRegion Ovr ON
		Bu.OverheadRegionId = Ovr.OverheadRegionId  

WHERE
	Bu.BillingUploadBatchId IS NOT NULL AND
	Bud.BillingUploadDetailTypeId <> 2 
	--AND ISNULL(Bu.UpdatedDate, Bu.UpdatedDate) BETWEEN @ImportStartDate AND @ImportEndDate --NOTE:: GC I am note sure it can work with the date filter

--IMS 48953 - Exclude overhead mark up from the import

PRINT 'Rows Inserted into #ProfitabilityOverhead:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

/*==================================================================================================================================
 8. Remove records from the #ProfitabilityOverhead table mapped to records in the exclusion tables popluated above
 ==================================================================================================================================*/

-- Change control 7 - begin

/*
	The approach to this is not the same as that of the MRI script where the records are excluded when getting data from the source
	systems because the data required by the exclusion tables come from different tables in different source systems, making it difficult
	to exclude at the point of the source. Also, some tables such as #Project are used for different purposes, therefore, we may be excluding
	records that need to be included.
*/

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
	RIGHT(MCD.SourceCode, 1) = 'C' AND	
	RIGHT(PO.CorporateSourceCode, 1) = 'C'	

PRINT (CONVERT(char(10),@@rowcount) + ' records deleted from #ProfitabilityOverhead')

PRINT 'Finished deleting from #ProfitabilityOverhead'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Change control 7 - end

END

/* ==============================================================================================================================================
	9. Take the different sources and combine them into the "REAL" fact table
   =========================================================================================================================================== */
BEGIN

	/*
		If the join is not possible, default the link to the 'UNKNOWN' link	
	*/

CREATE TABLE #ProfitabilityActual(
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
	
	OriginatingRegionCode char(6) NULL,
	PropertyFundCode char(12) NULL,
	FunctionalDepartmentCode char(15) NULL,
	
	GlobalGLCategorizationHierarchyKey INT NULL,
	USPropertyGLCategorizationHierarchyKey INT NULL,
	USFundGLCategorizationHierarchyKey INT NULL,
	EUPropertyGLCategorizationHierarchyKey INT NULL,
	EUFundGLCategorizationHierarchyKey INT NULL,
	USDevelopmentGLCategorizationHierarchyKey INT NULL,
	EUDevelopmentGLCategorizationHierarchyKey INT NULL,
	ReportingGLCategorizationHierarchyKey INT NULL,
	
	LastDate DATETIME NULL
	
) 

INSERT INTO #ProfitabilityActual(
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
	ReportingGLCategorizationHierarchyKey,
	
	LastDate
)
SELECT 
	DATEDIFF(dd, '1900-01-01', LEFT(Gl.ExpensePeriod, 4) + '-' + RIGHT(Gl.ExpensePeriod, 2) + '-01') CalendarKey,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown) SourceKey,
	ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) FunctionalDepartmentKey,
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
	ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) ActivityTypeKey,
	ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKeyUnknown)OriginatingRegionKey,
	ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AllocationRegionKey,
	CASE 
		WHEN Gl.ExpensePeriod < 201101 THEN
			ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) 
		ELSE
			ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown)
	END ConsolidationRegionKey,
	ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) PropertyFundKey,
	ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown) OverheadKey,
		'BillingUploadDetailId=' + LTRIM(STR(Gl.BillingUploadDetailId, 10, 0)),
	ISNULL(Cu.CurrencyKey, @LocalCurrencyKeyUnknown),
	Gl.LocalActual,
	3 AS SourceSystemKey, --SourceSystemKey
	Gl.OriginatingRegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	
	COALESCE(GlobalGCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey) GlobalGLCategorizationHierarchyKey,
	COALESCE(USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey) USPropertyGLCategorizationHierarchyKey,
	COALESCE(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey) USFundGLCategorizationHierarchyKey,
	COALESCE(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey) EUPropertyGLCategorizationHierarchyKey,
	COALESCE(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)	EUFundGLCategorizationHierarchyKey,
	COALESCE(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey) USDevelopmentGLCategorizationHierarchyKey,
	COALESCE(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown) EUDevelopmentGLCategorizationHierarchyKey,
	
	/*
	The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
	when a local report is generated.
	*/
		
	CASE 
		WHEN GC.GLCategorizationId IS NOT NULL THEN
			CASE
				WHEN GC.Name = 'US Property' THEN ISNULL(USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
				WHEN GC.Name = 'US Fund' THEN ISNULL(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
				WHEN GC.Name = 'EU Property' THEN ISNULL(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
				WHEN GC.Name = 'EU Fund' THEN ISNULL(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
				WHEN GC.Name = 'US Development' THEN ISNULL(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
				WHEN GC.Name = 'EU Development' THEN ISNULL(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
				WHEN GC.Name = 'Global' THEN COALESCE(GlobalGCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
				ELSE ISNULL(LocalUnknownGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
			END
		ELSE @GLCategorizationHierarchyKeyUnknown
	END ReportingGLCategorizationHierarchyKey,
	
	Gl.UpdatedDate
FROM
	#ProfitabilityOverhead Gl

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Gl.LocalCurrency = Cu.CurrencyCode  

	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		Gl.FunctionalDepartmentCode  = GrFdm.FunctionalDepartmentCode AND
		Gl.FunctionalDepartmentCode  = GrFdm.SubFunctionalDepartmentCode AND
		Gl.UpdatedDate BETWEEN GrFdm.StartDate AND ISNULL(GrFdm.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #ActivityType At ON
		Gl.ActivityTypeCode = At.ActivityTypeCode  
		
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		At.ActivityTypeId = GrAt.ActivityTypeId AND
		Gl.UpdatedDate BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate) AND
		GrAt.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = 'ALLOC'
		
	LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
		At.ActivityTypeId = AtGla.ActivityTypeId  

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		AtGla.GLAccountCode = GA.Code AND
		ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)

	-- CC21 Changes
	/*
	
	The mappings below map the Global and Local categorizations for the various transactions.
	Global Categorizations are mapped based on the GL Global Account mappings in GDM.
	Local Categorizations are mapped based on the Activity Type and Functional Department
	The temp table is joined to the dimension for each Categorization
	
	*/
	LEFT OUTER JOIN #GlobalGLCategorizationMapping GGCM ON
		GA.GLGlobalAccountId = GGCM.GLGlobalAccountId  
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalGCH ON
		GGCM.GlobalGLCategorizationHierarchyCode = GlobalGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN GlobalGCH.StartDate AND GlobalGCH.EndDate AND
		GlobalGCH.SnapshotId = 0
		
	LEFT OUTER JOIN #LocalGLCategorizationMapping LGCM ON
		Gl.FunctionalDepartmentId = LGCM.FunctionalDepartmentId AND
		At.ActivityTypeId = LGCM.ActivityTypeId 
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USPropertyGCH ON
		LGCM.USPropertyGLCategorizationHierarchyCode  = USPropertyGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN USPropertyGCH.StartDate AND USPropertyGCH.EndDate AND
		USPropertyGCH.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USFundGCH ON
		LGCM.USFundGLCategorizationHierarchyCode  = USFundGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN USFundGCH.StartDate AND USFundGCH.EndDate AND
		USFundGCH.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUPropertyGCH ON
		LGCM.EUPropertyGLCategorizationHierarchyCode = EUPropertyGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN EUPropertyGCH.StartDate AND EUPropertyGCH.EndDate AND
		EUPropertyGCH.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUFundGCH ON
		LGCM.EUFundGLCategorizationHierarchyCode = EUFundGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN EUFundGCH.StartDate AND EUFundGCH.EndDate AND
		EUFundGCH.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USDevelopmentGCH ON
		LGCM.USDevelopmentGLCategorizationHierarchyCode = USDevelopmentGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN USDevelopmentGCH.StartDate AND USDevelopmentGCH.EndDate AND
		USDevelopmentGCH.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUDevelopmentGCH ON
		LGCM.EUDevelopmentGLCategorizationHierarchyCode = EUDevelopmentGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN EUDevelopmentGCH.StartDate AND EUDevelopmentGCH.EndDate AND
		EUDevelopmentGCH.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
		UnknownGCH.GLCategorizationHierarchyCode = '1:233:-1:-1:-1:' + CONVERT(VARCHAR(10), GA.GLGlobalAccountId) AND
		Gl.UpdatedDate BETWEEN UnknownGCH.StartDate AND UnknownGCH.EndDate AND
		UnknownGCH.SnapshotId = 0		

	-- End of CC21 Changes

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		Gl.CorporateSourceCode = GrSc.SourceCode  
	
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		Gl.PropertyFundId  = GrPf.PropertyFundId AND
		Gl.UpdatedDate BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate) AND
		GrPf.SnapshotId = 0

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		Gl.OriginatingRegionCode = ORCE.CorporateEntityCode AND
		Gl.OriginatingRegionSourceCode = ORCE.SourceCode  

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ORCE.GlobalRegionId  = GrOr.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate) AND
		GrOr.SnapshotId = 0

	LEFT OUTER JOIN #PropertyFund PF ON
		Gl.PropertyFundId = PF.PropertyFundId

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate) AND
		GrAr.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
		Gl.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
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

	LEFT OUTER JOIN #ReportingCategorization RC ON
		PF.EntityTypeId = RC.EntityTypeId AND
		ASR.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId  

	LEFT OUTER JOIN #GLCategorization GC ON
		RC.GLCategorizationId = GC.GLCategorizationId 

	LEFT OUTER JOIN #PropertyOverheadPropertyGLAccount POPGA ON
		CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE Gl.FunctionalDepartmentId END = ISNULL(POPGA.FunctionalDepartmentId, 0) AND
		CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE At.ActivityTypeId END = ISNULL(POPGA.ActivityTypeId, 0) AND
		RC.GLCategorizationId = POPGA.GLCategorizationId
	
	LEFT OUTER JOIN #GLAccount LocalGA ON
		POPGA.PropertyGLAccountId = LocalGA.GLAccountId  
		
	/*
		If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
		If the local Categorization is not configured for recharge, the Global account is determined directly from the 
			#PropertyOverheadPropertyGLAccount table
	*/
	LEFT OUTER JOIN #GLGlobalAccount LocalGGA ON
		LocalGGA.GLGlobalAccountId = 
			CASE 
				WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
					LocalGA.GLGlobalAccountId
				ELSE
					POPGA.GLGlobalAccountId
			END
			
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy LocalUnknownGCH ON
		LocalUnknownGCH.GLCategorizationHierarchyCode = '-1:-1:-1:-1:-1:' + CONVERT(VARCHAR(10), LocalGGA.GLGlobalAccountId) AND
		Gl.UpdatedDate BETWEEN LocalUnknownGCH.StartDate AND LocalUnknownGCH.EndDate AND
		LocalUnknownGCH.SnapshotId = 0
WHERE
	Gl.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate
	
PRINT 'Rows Inserted into #ProfitabilityActual:'+CONVERT(char(10),@@rowcount)
END

/* ==============================================================================================================================================
	10. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
   =========================================================================================================================================== */
BEGIN	

CREATE UNIQUE CLUSTERED INDEX UX_ProfitabilityActual_ReferenceCode ON #ProfitabilityActual (SourceKey, ReferenceCode)

PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

UPDATE DIM
SET 	
	DIM.CalendarKey								  = Pro.CalendarKey,
	DIM.FunctionalDepartmentKey					  = Pro.FunctionalDepartmentKey,
	DIM.ReimbursableKey							  = Pro.ReimbursableKey,
	DIM.ActivityTypeKey							  = Pro.ActivityTypeKey,
	DIM.OriginatingRegionKey					  = Pro.OriginatingRegionKey,
	DIM.AllocationRegionKey						  = Pro.AllocationRegionKey,
	DIM.ConsolidationRegionKey					  = Pro.ConsolidationRegionKey,
	DIM.PropertyFundKey							  = Pro.PropertyFundKey,
	DIM.OverheadKey								  = Pro.OverheadKey,
	DIM.LocalCurrencyKey						  = Pro.LocalCurrencyKey,
	DIM.LocalActual								  = Pro.LocalActual,
	DIM.SourceSystemKey		  = Pro.SourceSystemKey,
	
	DIM.GlobalGLCategorizationHierarchyKey		  = Pro.GlobalGLCategorizationHierarchyKey,
	DIM.USPropertyGLCategorizationHierarchyKey	  = Pro.USPropertyGLCategorizationHierarchyKey,
	DIM.USFundGLCategorizationHierarchyKey		  = Pro.USFundGLCategorizationHierarchyKey,
	DIM.EUPropertyGLCategorizationHierarchyKey	  = Pro.EUPropertyGLCategorizationHierarchyKey,
	DIM.EUFundGLCategorizationHierarchyKey		  = Pro.EUFundGLCategorizationHierarchyKey,
	DIM.USDevelopmentGLCategorizationHierarchyKey = Pro.USDevelopmentGLCategorizationHierarchyKey,
	DIM.EUDevelopmentGLCategorizationHierarchyKey = Pro.EUDevelopmentGLCategorizationHierarchyKey,
	DIM.ReportingGLCategorizationHierarchyKey	  = Pro.ReportingGLCategorizationHierarchyKey,
	
	DIM.OriginatingRegionCode					  = Pro.OriginatingRegionCode,
	DIM.PropertyFundCode						  = Pro.PropertyFundCode,
	DIM.FunctionalDepartmentCode				  = Pro.FunctionalDepartmentCode,
	
	UpdatedDate									= GETDATE(),
	DIM.LastDate								= Pro.LastDate
	
FROM
	GrReporting.dbo.ProfitabilityActual DIM
	
	INNER JOIN #ProfitabilityActual Pro ON
		DIM.SourceKey = Pro.SourceKey AND
		DIM.ReferenceCode = Pro.ReferenceCode
WHERE
	(
		DIM.CalendarKey								  <> Pro.CalendarKey OR
		DIM.FunctionalDepartmentKey					  <> Pro.FunctionalDepartmentKey OR
		DIM.ReimbursableKey							  <> Pro.ReimbursableKey OR
		DIM.ActivityTypeKey							  <> Pro.ActivityTypeKey OR
		DIM.OriginatingRegionKey					  <> Pro.OriginatingRegionKey OR
		DIM.AllocationRegionKey						  <> Pro.AllocationRegionKey OR
		DIM.ConsolidationRegionKey					  <> Pro.ConsolidationRegionKey OR
		DIM.PropertyFundKey							  <> Pro.PropertyFundKey OR
		DIM.OverheadKey								  <> Pro.OverheadKey OR
		DIM.LocalCurrencyKey						  <> Pro.LocalCurrencyKey OR
		DIM.LocalActual								  <> Pro.LocalActual OR
		DIM.SourceSystemKey		  <> Pro.SourceSystemKey OR
		
		ISNULL(DIM.GlobalGLCategorizationHierarchyKey, '')		  <> Pro.GlobalGLCategorizationHierarchyKey OR
		ISNULL(DIM.USPropertyGLCategorizationHierarchyKey, '')	  <> Pro.USPropertyGLCategorizationHierarchyKey OR
		ISNULL(DIM.USFundGLCategorizationHierarchyKey, '')		  <> Pro.USFundGLCategorizationHierarchyKey OR
		ISNULL(DIM.EUPropertyGLCategorizationHierarchyKey, '')	  <> Pro.EUPropertyGLCategorizationHierarchyKey OR
		ISNULL(DIM.EUFundGLCategorizationHierarchyKey, '')		  <> Pro.EUFundGLCategorizationHierarchyKey OR
		ISNULL(DIM.USDevelopmentGLCategorizationHierarchyKey, '') <> Pro.USDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(DIM.EUDevelopmentGLCategorizationHierarchyKey, '') <> Pro.EUDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(DIM.ReportingGLCategorizationHierarchyKey, '')	  <> Pro.ReportingGLCategorizationHierarchyKey OR
		
		DIM.OriginatingRegionCode					  <> Pro.OriginatingRegionCode OR
		DIM.PropertyFundCode						  <> Pro.PropertyFundCode OR
		DIM.FunctionalDepartmentCode				  <> Pro.FunctionalDepartmentCode OR
		ISNULL(DIM.LastDate, '')					<> Pro.LastDate
	)
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
	OverheadKey,
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
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	InsertedDate,
	UpdatedDate,
	
	LastDate
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
	Pro.OverheadKey,
	Pro.ReferenceCode, 
	Pro.LocalCurrencyKey, 
	Pro.LocalActual,
	Pro.SourceSystemKey, --BillingUploadDetail

	Pro.GlobalGLCategorizationHierarchyKey,
	Pro.USPropertyGLCategorizationHierarchyKey,
	Pro.USFundGLCategorizationHierarchyKey,
	Pro.EUPropertyGLCategorizationHierarchyKey,
	Pro.EUFundGLCategorizationHierarchyKey,
	Pro.USDevelopmentGLCategorizationHierarchyKey,
	Pro.EUDevelopmentGLCategorizationHierarchyKey,
	Pro.ReportingGLCategorizationHierarchyKey,
	
	Pro.OriginatingRegionCode,
	Pro.PropertyFundCode,
	Pro.FunctionalDepartmentCode,
	GETDATE(), -- InsertedDate
	GETDATE(), -- UpdatedDate
	
	Pro.LastDate
FROM
	#ProfitabilityActual Pro

	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		Pro.SourceKey  = ProExists.SourceKey AND
		Pro.ReferenceCode = ProExists.ReferenceCode	 
WHERE
	ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*
		Remove orphan rows from the warehouse that have been removed in the source data systems	
	*/

EXEC stp_IU_ArchiveProfitabilityOverheadActual @ImportStartDate=@ImportStartDate, @ImportEndDate=@ImportEndDate, @DataPriorToDate=@DataPriorToDate

END

/* =============================================================================================================================================
	11. Clean Up
   ========================================================================================================================================== */
BEGIN

IF OBJECT_ID('tempdb..#ManageType') IS NOT NULL
	DROP TABLE #ManageType

IF OBJECT_ID('tempdb..#ManageCorporateDepartment') IS NOT NULL
	DROP TABLE #ManageCorporateDepartment

IF OBJECT_ID('tempdb..#ManageCorporateEntity') IS NOT NULL
	DROP TABLE #ManageCorporateEntity

IF OBJECT_ID('tempdb..#ActivityTypeGLAccount') IS NOT NULL
	DROP TABLE #ActivityTypeGLAccount

IF OBJECT_ID('tempdb..#AllocationSubRegion') IS NOT NULL
	DROP TABLE #AllocationSubRegion

IF OBJECT_ID('tempdb..#BillingUpload') IS NOT NULL
	DROP TABLE #BillingUpload

IF OBJECT_ID('tempdb..#BillingUploadDetail') IS NOT NULL
	DROP TABLE #BillingUploadDetail

IF OBJECT_ID('tempdb..#Overhead') IS NOT NULL
	DROP TABLE #Overhead

IF OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
	DROP TABLE #FunctionalDepartment

IF OBJECT_ID('tempdb..#Project') IS NOT NULL
	DROP TABLE #Project

IF OBJECT_ID('tempdb..#PropertyFund') IS NOT NULL
	DROP TABLE #PropertyFund

IF OBJECT_ID('tempdb..#PropertyFundMapping') IS NOT NULL
	DROP TABLE #PropertyFundMapping

IF OBJECT_ID('tempdb..#ReportingEntityCorporateDepartment') IS NOT NULL
	DROP TABLE #ReportingEntityCorporateDepartment

IF OBJECT_ID('tempdb..#ReportingEntityPropertyEntity') IS NOT NULL
	DROP TABLE #ReportingEntityPropertyEntity

IF OBJECT_ID('tempdb..#OriginatingRegionCorporateEntity') IS NOT NULL
	DROP TABLE #OriginatingRegionCorporateEntity

IF OBJECT_ID('tempdb..#OriginatingRegionPropertyDepartment') IS NOT NULL
	DROP TABLE #OriginatingRegionPropertyDepartment

IF OBJECT_ID('tempdb..#GLGlobalAccount') IS NOT NULL
	DROP TABLE #GLGlobalAccount

IF OBJECT_ID('tempdb..#ActivityType') IS NOT NULL
	DROP TABLE #ActivityType

IF OBJECT_ID('tempdb..#OverheadRegion') IS NOT NULL
	DROP TABLE #OverheadRegion

IF OBJECT_ID('tempdb..#GLAccount') IS NOT NULL
	DROP TABLE #GLAccount

IF OBJECT_ID('tempdb..#GLGlobalAccountCategorization') IS NOT NULL
	DROP TABLE #GLGlobalAccountCategorization

IF OBJECT_ID('tempdb..#GLFinancialCategory') IS NOT NULL
	DROP TABLE #GLFinancialCategory

IF OBJECT_ID('tempdb..#GLMajorCategory') IS NOT NULL
	DROP TABLE #GLMajorCategory

IF OBJECT_ID('tempdb..#GLMinorCategory') IS NOT NULL
	DROP TABLE #GLMinorCategory

IF OBJECT_ID('tempdb..#GLCategorization') IS NOT NULL
	DROP TABLE #GLCategorization

IF OBJECT_ID('tempdb..#GLCategorizationType') IS NOT NULL
	DROP TABLE #GLCategorizationType

IF OBJECT_ID('tempdb..#PropertyOverheadPropertyGLAccount') IS NOT NULL
	DROP TABLE #PropertyOverheadPropertyGLAccount

IF OBJECT_ID('tempdb..#GlobalGLCategorizationMapping') IS NOT NULL
	DROP TABLE #GlobalGLCategorizationMapping
	
	IF OBJECT_ID('tempdb..#LocalGLCategorizationMapping') IS NOT NULL
	DROP TABLE #LocalGLCategorizationMapping
	
IF OBJECT_ID('tempdb..#ProfitabilityOverhead') IS NOT NULL
	DROP TABLE #ProfitabilityOverhead

IF OBJECT_ID('tempdb..#ProfitabilityActual') IS NOT NULL
	DROP TABLE #ProfitabilityActual

IF OBJECT_ID('tempdb..#ConsolidationRegionCorporateDepartment') IS NOT NULL
	DROP TABLE #ConsolidationRegionCorporateDepartment

END


GO


