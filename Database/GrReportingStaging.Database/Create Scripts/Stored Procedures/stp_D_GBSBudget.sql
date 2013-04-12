USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_GBSBudget]
GO

/*********************************************************************************************************************
Description
	Deletes GBS Budget data from the GrReportingStaging database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_D_GBSBudget]
	@BudgetId INT

AS

BEGIN

IF @BudgetId IS NULL
BEGIN
	PRINT 'There is no budget to delete'
	RETURN
END

--------------------------------------------------------------------------
-- delete GBS.DisputeStatus
--------------------------------------------------------------------------

DELETE DS
FROM 
	GBS.DisputeStatus DS
WHERE
	DS.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM GBS.Budget WHERE BudgetId <> @BudgetId)

DELETE FROM GBS.BudgetPeriod
WHERE
	BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.OverheadType
--------------------------------------------------------------------------

DELETE OT
FROM
	GBS.OverheadType OT 
WHERE
	OT.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM GBS.Budget WHERE BudgetId <> @BudgetId)

--------------------------------------------------------------------------
-- delete GBS.BudgetProfitabilityActual
--------------------------------------------------------------------------

DELETE FROM GBS.BudgetProfitabilityActual
WHERE
	BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.FeeDetail
--------------------------------------------------------------------------

DELETE FD
FROM 
	GBS.FeeDetail FD
	INNER JOIN GBS.Fee F ON
		FD.FeeId = F.FeeId AND
		FD.ImportBatchId = F.ImportBatchId
WHERE
	F.BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.Fee
--------------------------------------------------------------------------
		
DELETE FROM GBS.Fee
WHERE
	BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpenseDispute
--------------------------------------------------------------------------

DELETE NPED
FROM 
	GBS.NonPayrollExpenseDispute NPED
	INNER JOIN GBS.NonPayrollExpense NPE ON
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
		NPED.ImportBatchId = NPE.ImportBatchId
WHERE
	NPE.BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpenseBreakdown
--------------------------------------------------------------------------
		
DELETE FROM GBS.NonPayrollExpense
WHERE
	BudgetId = @BudgetId

DELETE FROM GBS.NonPayrollExpenseBreakdown
WHERE
	BudgetId = @BudgetId
	

--------------------------------------------------------------------------
-- delete GBS.Budget
--------------------------------------------------------------------------

DELETE FROM GBS.Budget
WHERE
	BudgetId = @BudgetId
	
END

GO