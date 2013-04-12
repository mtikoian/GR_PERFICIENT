USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_ValidPayrollRegionAndFunctionalDepartment]
GO

CREATE PROCEDURE [dbo].[stp_S_ValidPayrollRegionAndFunctionalDepartment]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime
AS

--SET @BudgetYear = 2010
--SET @BudgetQuarter = 'Q2'
--SET @DataPriorToDate = '2010-12-31'

DECLARE @BudgetQuarterNumber INT
SET @BudgetQuarterNumber = CAST(SUBSTRING(@BudgetQuater, 2, 1) AS INT) + 1

/*
Setup Temp tables
*/

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
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
	Name,
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
	GrReportingStaging.TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
		
PRINT 'Completed inserting records from BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



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
	GrReportingStaging.TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
		
PRINT 'Completed inserting records from BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



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
	GrReportingStaging.Gdm.BudgetReportGroupPeriod brgp
	INNER JOIN GrReportingStaging.Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
		
PRINT 'Completed inserting records from GRBudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status

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
	GrReportingStaging.TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
		
PRINT 'Completed inserting records from BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE TABLE #AllActiveBudget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
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
	ImportBudgetIntoGR BIT NOT NULL,  
	LastImportBudgetIntoGRDate DATETIME NULL
)

INSERT INTO #AllActiveBudget(
	ImportKey,
	ImportBatchId,
	ImportDate,
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
	ImportBudgetIntoGR,
	LastImportBudgetIntoGRDate
)
SELECT 
	Budget.*
FROM
	GrReportingStaging.TapasGlobalBudgeting.Budget Budget
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
		
PRINT 'Completed inserting records into ##AllActiveBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #AllActiveBudget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)


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
	GrReportingStaging.TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #BudgetReportGroupDetail b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT CONVERT(Varchar(27), getdate(), 121)

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
	GrReportingStaging.TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #BudgetReportGroupDetail b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


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
	GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT 
	fd.* 
FROM 
	GrReportingStaging.HR.FunctionalDepartment fd
	INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

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
	GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)


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
	GrReportingStaging.HR.Location Location
	INNER JOIN GrReportingStaging.HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT 'Completed creating indexes on #Location'
PRINT CONVERT(Varchar(27), getdate(), 121)

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
	GrReportingStaging.TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN GrReportingStaging.TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT 'Completed creating indexes on #PayrollRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)


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
	GrReportingStaging.Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN GrReportingStaging.Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

PRINT 'Completed inserting records into #OriginatingRegionCorporateEntity:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionCorporateEntity (CorporateEntityCode, SourceCode, IsDeleted, GlobalRegionId)
PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)



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
	GrReportingStaging.Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN GrReportingStaging.Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

PRINT 'Completed inserting records into #OriginatingRegionPropertyDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionPropertyDepartment (PropertyDepartmentCode, SourceCode, IsDeleted, GlobalRegionId)
PRINT 'Completed creating indexes on #OriginatingRegionPropertyDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)



------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE #AllModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL
)

INSERT INTO #AllModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted
)

SELECT 
	Brgd.BudgetId, 
	Brgd.BudgetReportGroupId,
	Brgp.BudgetReportGroupPeriodId,
	B.IsDeleted AS IsBudgetDeleted,
	B.IsReforecast AS IsBugetReforecast,
	B.BudgetStatusId, 
	Brgd.IsDeleted AS IsDetailDeleted, 
	Brg.IsReforecast AS IsGroupReforecast, 
	Brg.StartPeriod AS GroupStartPeriod, 
	Brg.EndPeriod AS GroupEndPeriod, 
	Brg.IsDeleted AS IsGroupDeleted,
	Brgp.IsDeleted AS IsPeriodDeleted
	
From	#AllActiveBudget B
			INNER JOIN #BudgetStatus Bs ON Bs.BudgetStatusId = B.BudgetStatusId
			
			INNER JOIN #BudgetReportGroupDetail BrGd ON BrGd.BudgetId = B.BudgetId
			
			INNER JOIN #BudgetReportGroup BrG ON BrG.BudgetReportGroupId = BrGd.BudgetReportGroupId
			
			INNER JOIN #BudgetReportGroupPeriod BrGp ON BrGp.BudgetReportGroupPeriodId = BrG.BudgetReportGroupPeriodId

Where	BrGp.[Year] = @BudgetYear
AND		BrGp.Period = (Select MIN(ReforecastEffectivePeriod) 
						From GrReporting.dbo.Reforecast 
						Where ReforecastEffectiveYear = @BudgetYear
						 AND ReforecastEffectiveQuarter = @BudgetQuarterNumber
						)


CREATE TABLE #LockedModifiedReportGroup( -- All budgets in a particular group need to be locked before the group can be pulled
	BudgetReportGroupId INT NOT NULL
)

INSERT INTO #LockedModifiedReportGroup(
	BudgetReportGroupId
)

SELECT
	amrb.BudgetReportGroupId
FROM
	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING
	COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) -- Are all budgets locked within this group? If not, no budgets get imported 

PRINT 'Completed inserting records into #LockedModifiedReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)




CREATE TABLE #FilteredModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)

INSERT INTO #FilteredModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted,
	BudgetReportGroupPeriod 
)
SELECT
	amrb.*,
	brgp.Period BudgetReportGroupPeriod
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = amrb.BudgetReportGroupPeriodId
		
WHERE
	amrb.IsBudgetDeleted = 0 AND
	--amrb.IsBugetReforecast = 0 AND --This is only applicable if you are looking a a Budget and not a Reforecast
	amrb.IsDetailDeleted = 0 AND
	--amrb.IsGroupReforecast = 0 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0 AND
	brgp.IsDeleted = 0



PRINT 'Completed inserting records into #FilteredModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)




CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
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
	ImportBudgetIntoGR BIT NOT NULL,  
	LastImportBudgetIntoGRDate DATETIME NULL
)

INSERT INTO #Budget(
	ImportKey,
	ImportBatchId,
	ImportDate,
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
	ImportBudgetIntoGR,	
	LastImportBudgetIntoGRDate 
)
SELECT 
	Budget.* 
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId

PRINT 'Completed inserting records into #Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)




SELECT 
		DISTINCT
		--Fd.Code	
		--GrOr.Code,
		--OriginatingRegion.CorporateEntityRef,
		--OriginatingRegion.CorporateSourceCode,
		Fd.Name FunctionalDepartmentName,
		GrOr.Name OriginatingSubRegionName

FROM

		#BudgetReportGroup Brg
		
		INNER JOIN #BudgetReportGroupDetail Brgd ON Brgd.BudgetReportGroupId = Brg.BudgetReportGroupId

		INNER JOIN #BudgetEmployee Be ON Be.BudgetId = Brgd.BudgetId

		INNER JOIN #BudgetEmployeeFunctionalDepartment BeFd ON BeFd.BudgetEmployeeId = Be.BudgetEmployeeId
          
		INNER JOIN #FunctionalDepartment Fd ON Fd.FunctionalDepartmentId = BeFd.FunctionalDepartmentId

          --This is to ensure an employee has time/payroll allocated
		INNER JOIN #BudgetEmployeePayrollAllocation BePa ON Be.BudgetEmployeeId = Be.BudgetEmployeeId

		INNER JOIN #Budget B ON B.BudgetId = Brgd.BudgetId
					
		INNER JOIN #Location L ON L.LocationId = BE.LocationId


		INNER JOIN #PayrollRegion OriginatingRegion ON
				OriginatingRegion.ExternalSubRegionId = L.ExternalSubRegionId AND
				OriginatingRegion.RegionId = B.RegionId
				
		INNER JOIN #OriginatingRegionCorporateEntity OrCe ON OrCe.CorporateEntityCode = OriginatingRegion.CorporateEntityRef AND
							OrCe.SourceCode = OriginatingRegion.CorporateSourceCode
        INNER JOIN (
					SELECT 
						Gr.* 
					FROM 
						GrReportingStaging.Gdm.GlobalRegion Gr
						INNER JOIN GrReportingStaging.Gdm.GlobalRegionActive(@DataPriorToDate) GrA ON
							Gr.ImportKey = GrA.ImportKey
					) GrOr ON GrOr.GlobalRegionId = Orce.GlobalRegionId




---------------------------------------- CLEAN UP ------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #AllModifiedReportBudget
DROP TABLE #AllActiveBudget
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #FunctionalDepartment
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #Location
DROP TABLE #PayrollRegion
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #FilteredModifiedReportBudget