
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_TapasGlobalBudgeting_ProfitabilityBudgetEmployeePayrollAllocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_TapasGlobalBudgeting_ProfitabilityBudgetEmployeePayrollAllocation]
GO

CREATE PROCEDURE [dbo].[stp_IU_TapasGlobalBudgeting_ProfitabilityBudgetEmployeePayrollAllocation]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime
AS
SET NOCOUNT ON

-- Populate Payroll Tax Budget

CREATE TABLE #BudgetEmployeePayrollAllocationTotals
(
	BudgetEmployeePayrollAllocationId int NOT NULL,
	SalaryTaxAmount money NOT NULL,
	BonusTaxAmount money NOT NULL,
	BonusCapExcessTaxAmount money NOT NULL,
	UpdatedDate DateTime NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationTotals
(
	BudgetEmployeePayrollAllocationId,
	SalaryTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	UpdatedDate
)
SELECT 
	AllocationDetail.BudgetEmployeePayrollAllocationId,
	Sum(IsNull(AllocationDetail.SalaryAmount,0)) as SalaryTaxAmount,
	Sum(IsNull(AllocationDetail.BonusAmount,0)) as BonusTaxAmount,
	Sum(IsNull(AllocationDetail.BonusCapExcessAmount,0)) as BonusCapExcessTaxAmount,
	Max(AllocationDetail.UpdatedDate) as UpdatedDate
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail AllocationDetail
GROUP BY
	BudgetEmployeePayrollAllocationId

-- Populate Payroll Budget

CREATE TABLE #ProfitabilityBudgetEmployeePayrollAllocation
(
	BudgetEmployeePayrollAllocationId int NOT NULL,
	SourceCode varchar(2) NULL,
	Period char(6) NULL,
	CurrencyCode varchar(3) NULL,
	FunctionalDepartmentCode char(15) NULL,
	PropertyFundCode char(12) NULL,
	AllocationRegionCode char(6) NULL,
	OriginatingRegionCode char(6) NULL,
	ActivityTypeCode varchar(10) NULL,
	PreTaxSalaryAmount money NULL,
	PreTaxProfitShareAmount money NULL,
	PreTaxBonusAmount money NULL,
	PreTaxBonusCapExcessAmount money NULL,
	SalaryTaxAmount money NULL,
	BonusTaxAmount money NULL,
	BonusCapExcessTaxAmount money NULL,
	IsReimbursable bit NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL
)

INSERT INTO #ProfitabilityBudgetEmployeePayrollAllocation
(
	BudgetEmployeePayrollAllocationId,
	SourceCode,
	Period,
	CurrencyCode,
	FunctionalDepartmentCode,
	PropertyFundCode,
	AllocationRegionCode,
	OriginatingRegionCode,
	ActivityTypeCode,
	PreTaxSalaryAmount,
	PreTaxProfitShareAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	SalaryTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	IsReimbursable,
	InsertedDate,
	UpdatedDate
)
SELECT top 10
	Allocation.BudgetEmployeePayrollAllocationId,
	BudgetRegion.SourceCode,
	Allocation.Period,
	Budget.CurrencyCode,
	FunctionalDepartment.Code,
	PropertyFundMapping.PropertyFundCode,
	ProjectRegion.Code,
	ExternalSubRegion.Code,
	ActivityType.Code,
	Allocation.PreTaxSalaryAmount,
	Allocation.PreTaxProfitShareAmount,
	Allocation.PreTaxBonusAmount,
	Allocation.PreTaxBonusCapExcessAmount,
	TaxDetail.SalaryTaxAmount,
	TaxDetail.BonusTaxAmount,
	TaxDetail.BonusCapExcessTaxAmount,
	BudgetProject.IsTsCost,
	GetDate(),
	IsNull(Budget.UpdatedDate, Budget.InsertedDate) AS UpdatedDate
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation
	
	LEFT OUTER JOIN TapasGlobalBudgeting.BudgetProject BudgetProject ON
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
		
	LEFT OUTER JOIN TapasGlobalBudgeting.Budget Budget ON
		BudgetProject.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment EFD ON --TODO: Effective date ???
		Allocation.BudgetEmployeeId = EFD.BudgetEmployeeId
		
	LEFT OUTER JOIN HR.FunctionalDepartment FunctionalDepartment ON 
		EFD.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId

	LEFT OUTER JOIN #BudgetEmployeePayrollAllocationTotals TaxDetail ON 
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId	
		
	LEFT OUTER JOIN Gdm.PropertyFundMapping PropertyFundMapping ON
		BudgetProject.PropertyFundId = PropertyFundMapping.PropertyFundId
	
	LEFT OUTER JOIN TapasGlobal.Project Project ON
		BudgetProject.ProjectId = Project.ProjectId

	LEFT OUTER JOIN Gdm.ActivityType ActivityType ON
		Project.ActivityTypeId = ActivityType.ActivityTypeId

	LEFT OUTER JOIN TapasGlobal.ProjectRegion ProjectRegion ON
		Project.RegionId = ProjectRegion.ProjectRegionId

	LEFT OUTER JOIN HR.Region BudgetRegion ON 
		Budget.RegionId = BudgetRegion.RegionId
	
	LEFT OUTER JOIN TapasGlobalBudgeting.BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN HR.Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN HR.Region ExternalSubRegion ON 
		Location.ExternalSubRegionId = ExternalSubRegion.RegionId
WHERE
	IsNull(Budget.UpdatedDate, Budget.InsertedDate) BETWEEN @ImportStartDate AND @ImportEndDate

-- Drop tables

DROP TABLE #BudgetEmployeePayrollAllocationTotals
DROP TABLE #ProfitabilityBudgetEmployeePayrollAllocation
				
GO

--select * from TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment
--exec stp_IU_TapasGlobalBudgeting_ProfitabilityBudgetEmployeePayrollAllocation '2000-01-01', '2011-01-01'


