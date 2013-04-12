USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProject]') AND name = N'IX_BudgetProject')
DROP INDEX [IX_BudgetProject] ON [TapasGlobalBudgeting].[BudgetProject] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetProject] ON [TapasGlobalBudgeting].[BudgetProject] 
(
	[ImportBatchId] ASC,
	[BudgetProjectId] ASC,
	[BudgetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployee]') AND name = N'IX_BudgetEmployee')
DROP INDEX [IX_BudgetEmployee] ON [TapasGlobalBudgeting].[BudgetEmployee] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetEmployee] ON [TapasGlobalBudgeting].[BudgetEmployee] 
(
	[ImportBatchId] ASC,
	[BudgetEmployeeId] ASC,
	[BudgetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment]') AND name = N'IX_BudgetEmployeeFunctionalDepartment')
DROP INDEX [IX_BudgetEmployeeFunctionalDepartment] ON [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetEmployeeFunctionalDepartment] ON [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] 
(
	[ImportBatchId] ASC,
	[BudgetEmployeeId] ASC,
	[BudgetEmployeeFunctionalDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation]') AND name = N'IX_BudgetEmployeePayrollAllocation')
DROP INDEX [IX_BudgetEmployeePayrollAllocation] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetEmployeePayrollAllocation] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] 
(
	[ImportBatchId] ASC,
	[BudgetEmployeeId] ASC,
	[BudgetEmployeePayrollAllocationId] ASC,
	[BudgetProjectId] ASC,
	[BudgetProjectGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]') AND name = N'IX_BudgetEmployeePayrollAllocationDetail')
DROP INDEX [IX_BudgetEmployeePayrollAllocationDetail] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetEmployeePayrollAllocationDetail] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] 
(
	[ImportKey] ASC,
	[ImportBatchId] ASC,
	[BudgetEmployeePayrollAllocationDetailId] ASC,
	[BudgetEmployeePayrollAllocationId] ASC,
	[BenefitOptionId] ASC,
	[BudgetTaxTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocation]') AND name = N'IX_BudgetOverheadAllocation')
DROP INDEX [IX_BudgetOverheadAllocation] ON [TapasGlobalBudgeting].[BudgetOverheadAllocation] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetOverheadAllocation] ON [TapasGlobalBudgeting].[BudgetOverheadAllocation]
(
	[ImportBatchId] ASC,
	[BudgetOverheadAllocationId] ASC,
	[BudgetId] ASC,
	[BudgetEmployeeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]') AND name = N'IX_BudgetOverheadAllocationDetail')
DROP INDEX [IX_BudgetOverheadAllocationDetail] ON [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] WITH ( ONLINE = OFF )
GO

USE [GrReportingStaging]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_BudgetOverheadAllocationDetail] ON [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]
(
	[ImportBatchId] ASC,
	[BudgetOverheadAllocationDetailId] ASC,
	[BudgetOverheadAllocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

------------------------------------------------------------------------------------------------------------------------------------------------
 