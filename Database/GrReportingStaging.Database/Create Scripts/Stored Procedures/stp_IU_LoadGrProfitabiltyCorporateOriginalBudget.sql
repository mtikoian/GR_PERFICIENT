
--/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	DateTime=NULL,
	@ImportEndDate		DateTime=NULL,
	@DataPriorToDate	DateTime=NULL
AS
IF (@ImportStartDate IS NULL)
	BEGIN
	SET @ImportStartDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'NonPayrollBudgetImportStartDate'))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
	SET @ImportEndDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'NonPayrollBudgetImportEndDate'))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(select ConfiguredValue From SSISConfigurations Where ConfigurationFilter = 'NonPayrollBudgetDataPriorToDate'))
	END

	
SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyCorporateOriginalBudget'
PRINT '####'
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

DECLARE 
      @GlAccountKey				Int = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @OverheadKey				Int = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN'),
      @FeeAdjustmentKey			Int = (Select FeeAdjustmentKey From GrReporting.dbo.FeeAdjustment Where FeeAdjustmentCode = 'UNKNOWN'),
	  @CanImportCorporateBudget	Int = (Select ConfiguredValue From [GrReportingStaging].[dbo].[SSISConfigurations] Where ConfigurationFilter = 'CanImportCorporateBudget')


IF (@CanImportCorporateBudget = 0)
	BEGIN
	print 'Import CorporateBudget not scheduled in SSISConfigurations'
	RETURN
	END


DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
	
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT 'Start'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT	
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode = 'Q0' -- Original budget values only

PRINT 'Rows Inserted into #Budget::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GLGlobalAccount gla
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT 'Rows Inserted into #GlAccount::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Rows Inserted into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*, Code as ActivityTypeCode
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT 'Rows Inserted into #ActvityType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT 'Rows Inserted into #GlobalRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mappings (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT
	pfm.*
INTO
	#PropertyFundMapping
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey
		
PRINT 'Rows Inserted into #PropertyFundMapping'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

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

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType 
(ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
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

INSERT INTO #GLGlobalAccountTranslationSubType (
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

INSERT INTO #GLTranslationType (
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

INSERT INTO #GLTranslationSubType (
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

INSERT INTO #GLMajorCategory (
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

INSERT INTO #GLMinorCategory (
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


INSERT INTO	#Department (
	ImportKey,
	Department,
	Description,
	LastDate,
	MRIUserID,
	Source,
	IsActive,
	FunctionalDepartmentId,
	UpdatedDate,
	IsTsCost
)
SELECT
	Dept.ImportKey,
	Dept.Department,
	Dept.Description,
	Dept.LastDate,
	Dept.MRIUserID,
	Dept.Source,
	Dept.IsActive,
	Dept.FunctionalDepartmentId,
	Dept.UpdatedDate,
	Dept.IsTsCost
FROM
	Gacs.Department Dept
	INNER JOIN Gacs.DepartmentActive(@DataPriorToDate) DeptA ON
		DeptA.ImportKey = Dept.ImportKey

	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GLGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL,
	IsUnallocatedOverhead bit NOT NULL,
	IsFeeAdjustment bit NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GlGlobalAccountCode,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	IsUnallocatedOverhead,
	IsFeeAdjustment
)

SELECT 
	b.BudgetId,
	'BC:' + b.SourceUniqueKey + '&ImportKey=' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as BudgetAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	--b.IsReimbursable as Reimbursable, -- CC 4 :: GC
	CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
	at.Code,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as AllocationSubRegionGlobalRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense,
	b.IsUnallocatedOverhead,
	b.IsFeeAdjustment
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		--GC Change Control 1
		gla.Code = CASE WHEN b.IsUnallocatedOverhead = 1 AND LEN(b.GlobalGlAccountCode) >= 10 THEN LEFT(b.GlobalGlAccountCode,10)+'99' ELSE b.GlobalGlAccountCode END
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		fd.GlobalCode = b.FunctionalDepartmentGlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		at.ActivityTypeId = gla.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		pfm.PropertyFundCode = b.NonPayrollCorporateMRIDepartmentCode AND -- Combination of entity and corporate department
		pfm.SourceCode = b.SourceCode AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) OR
			(
			 (GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
			 (GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId = pfm.PropertyFundId

	LEFT OUTER JOIN #GlobalRegion gr ON
		gr.Code = b.OriginatingSubRegionCode
	
	LEFT OUTER JOIN #Department Dept ON
		Dept.DEPARTMENT = b.NonPayrollCorporateMRIDepartmentCode AND Dept.Source = b.SourceCode
WHERE
	b.LocalAmount <> 0

PRINT 'Rows Inserted into #ProfitabilitySource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE NONCLUSTERED INDEX IX_LocalAmount ON [#Budget] ([LocalAmount])
INCLUDE ([ImportKey],[SourceUniqueKey],[BudgetId],[SourceCode],[LockedDate],[Period],[InternationalCurrencyCode],[GlobalGlAccountCode],[FunctionalDepartmentGlobalCode],[OriginatingSubRegionCode],[NonPayrollCorporateMRIDepartmentCode],[AllocationSubRegionProjectRegionId],[IsReimbursable],[JobCode])

PRINT 'Created Index on GlAccountKey #ProfitabilitySource'
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT 'Rows Inserted into #AllocationSubRegion'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	FeeAdjustmentKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

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
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(ps.ExpensePeriod,4)+'-'+RIGHT(ps.ExpensePeriod,2)+'-01') as CalendarKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKey ELSE GrOh.OverheadKey END OverheadKey
		,CASE WHEN GrFe.FeeAdjustmentKey IS NULL THEN @FeeAdjustmentKey ELSE GrFe.FeeAdjustmentKey END FeeAdjustmentKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.BudgetAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId 
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN (
				Select 
					*
				From GrReporting.dbo.FunctionalDepartment
				Where SubFunctionalDepartmentCode <> FunctionalDepartmentCode
				) GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		--GrFdmD.ReferenceCode LIKE '%:'+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN (
			Select 
				* 
			From 
			GrReporting.dbo.FunctionalDepartment
			Where SubFunctionalDepartmentCode = FunctionalDepartmentCode
			) GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +':%' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = ps.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = ps.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		Asr.AllocationSubRegionGlobalRegionId = ps.AllocationSubRegionGlobalRegionId --AND 
		--Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = Asr.AllocationSubRegionGlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		GrOrFee.GlobalRegionId = Asr.AllocationSubRegionGlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ps.OriginatingGlobalRegionId AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		GrCu.CurrencyCode  = ps.LocalCurrencyCode

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN ps.IsUnallocatedOverhead = 1 THEN 'UNALLOC' ELSE 'UNKNOWN' END

	LEFT OUTER JOIN GrReporting.dbo.FeeAdjustment  GrFe ON
		CASE ps.IsFeeAdjustment WHEN 1 THEN 'FEEADJUST' WHEN 0 THEN 'NORMAL' ELSE 'UNKNOWN' END = GrFe.FeeAdjustmentCode


PRINT 'Rows Inserted into #ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityBudget (GlAccountKey)
PRINT 'Created Index on GlAccountKey #ProfitabilityBudget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityBudget

PRINT 'Rows Inserted into #DeletingBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
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
		FROM GrReporting.dbo.ProfitabilityBudget 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT 'Rows Deleted from #DeletingBudget:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print 'Cleaned up rows in ProfitabilityBudget'


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
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
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	FeeAdjustmentKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
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


PRINT 'Rows Inserted into ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityBudget
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory


GO

