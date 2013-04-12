USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_TapasBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_TapasBudget]
GO

/*********************************************************************************************************************
Description
	Deletes Tapas Budget data from the GrReportingStaging database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_D_TapasBudget]
	@BudgetId INT

AS

BEGIN

IF @BudgetId IS NULL
BEGIN
	PRINT 'There is no budget to delete'
	RETURN
END

-- TapasGlobalBudgeting.BenefitOption

DELETE BE
FROM 
	TapasGlobalBudgeting.BenefitOption BE
WHERE
	BE.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail

DELETE BEPAD
FROM 
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail BEPAD
	
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocation BEPA ON
		BEPAD.BudgetEmployeePayrollAllocationId = BEPA.BudgetEmployeePayrollAllocationId AND
		BEPAD.ImportBatchId = BEPA.ImportBatchId
		
	INNER JOIN TapasGlobalBudgeting.BudgetEmployee BE ON
		BEPA.BudgetEmployeeId = BE.BudgetEmployeeId AND
		BEPA.ImportBatchId = BE.ImportBatchId
WHERE
	BE.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetEmployeePayrollAllocation

DELETE BEPA
FROM 
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation BEPA
		
	INNER JOIN TapasGlobalBudgeting.BudgetEmployee BE ON
		BEPA.BudgetEmployeeId = BE.BudgetEmployeeId AND
		BEPA.ImportBatchId = BE.ImportBatchId
WHERE
	BE.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment

DELETE BEFD
FROM	
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment BEFD
	
	INNER JOIN TapasGlobalBudgeting.BudgetEmployee BE ON
		BEFD.BudgetEmployeeId = BE.BudgetEmployeeId AND
		BEFD.ImportBatchId = BE.ImportBatchId
WHERE
	BE.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetEmployee

DELETE FROM TapasGlobalBudgeting.BudgetEmployee
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetOverheadAllocationDetail

DELETE BOAD
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail BOAD
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocation BOA ON
		BOAD.BudgetOverheadAllocationId = BOA.BudgetOverheadAllocationId AND
		BOAD.ImportBatchId = BOA.ImportBatchId
WHERE
	BOA.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetOverheadAllocation

DELETE FROM TapasGlobalBudgeting.BudgetOverheadAllocation 
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetProject

DELETE FROM TapasGlobalBudgeting.BudgetProject
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetReportGroup
	
DELETE BRG
FROM	
	TapasGlobalBudgeting.BudgetReportGroup BRG	
	
WHERE
	BRG.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.BudgetReportGroupDetail

DELETE TapasGlobalBudgeting.BudgetReportGroupDetail
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetStatus

DELETE BS
FROM
	TapasGlobalBudgeting.BudgetStatus BS
WHERE
	BS.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.BudgetTaxType 

DELETE TapasGlobalBudgeting.BudgetTaxType 
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.ReforecastActualBilledPayroll

DELETE TapasGlobalBudgeting.ReforecastActualBilledPayroll
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.TaxType

DELETE TT
FROM
	TapasGlobalBudgeting.TaxType TT
WHERE
	TT.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.Budget

DELETE FROM TapasGlobalBudgeting.Budget
WHERE
	BudgetId = @BudgetId
	
END
GO