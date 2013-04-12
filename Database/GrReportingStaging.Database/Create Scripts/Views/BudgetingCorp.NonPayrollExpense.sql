USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BudgetingCorp].[GrNonPayrollExpense]'))
DROP VIEW [BudgetingCorp].[GrNonPayrollExpense]
GO
CREATE VIEW [BudgetingCorp].[GrNonPayrollExpense]
AS 

SELECT [NonPayrollExpenseId]
      ,[BudgetId]
      ,[ProjectId]
      ,[ProjectGroupId]
      ,[OriginatingEmployeeSubRegionId]
      ,[OriginatingFunctionalDepartmentId]
      ,[VendorName]
      ,[ExpenseDescription]
      ,[ExpenseCategoryId]
      ,[GLTypeId]
      ,[JobCodeId]
      ,[PeriodGroup]
      ,[CurrencyId]
      ,[Amount]
      ,[ExchangeRate]
      ,[DollarAmount]
      ,[CompletedByEmployeeId]
      ,[DirectCost]
      ,[SubmittedDate]
      ,[DataSource]
      ,[Comments]
      ,[MiscellaneousComments]
      ,[IsActive]
      ,[InsertedDate]
      ,[UpdatedDate]
      ,[InsertedByStaffId]
  FROM [BudgetingCorp].[NonPayrollExpense]
  WHERE [InsertedDate] >= CONVERT(DateTime, '2010-01-01 00:00:00', 120)
  --NO Where clauses allowed here, that should be in relevant stp
