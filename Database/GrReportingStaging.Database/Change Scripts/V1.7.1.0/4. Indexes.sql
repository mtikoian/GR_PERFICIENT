 USE GrReportingStaging
 GO
 
 -- New Indexes to be Created
 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployee]') AND name = N'IX_BudgetEmployee_BudgetId_ImportBatchId')
DROP INDEX [IX_BudgetEmployee_BudgetId_ImportBatchId] ON [TapasGlobalBudgeting].[BudgetEmployee] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetEmployee_BudgetId_ImportBatchId] ON [TapasGlobalBudgeting].[BudgetEmployee] 
(
	[ImportBatchId] ASC,
	[BudgetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation]') AND name = N'IX_BudgetEmployeePayrollAllocation_ImportDate')
DROP INDEX [IX_BudgetEmployeePayrollAllocation_ImportDate] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetEmployeePayrollAllocation_ImportDate] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] 
(
	[ImportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]') AND name = N'IX_BudgetOverheadAllocationDetail_ImportDate')
DROP INDEX [IX_BudgetOverheadAllocationDetail_ImportDate] ON [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetOverheadAllocationDetail_ImportDate] ON [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] 
(
	[ImportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProject]') AND name = N'IX_BudgetProject_ImportDate')
DROP INDEX [IX_BudgetProject_ImportDate] ON [TapasGlobalBudgeting].[BudgetProject] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetProject_ImportDate] ON [TapasGlobalBudgeting].[BudgetProject] 
(
	[ImportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocation]') AND name = N'IX_BudgetOverheadAllocation_ImportDate')
DROP INDEX [IX_BudgetOverheadAllocation_ImportDate] ON [TapasGlobalBudgeting].[BudgetOverheadAllocation] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetOverheadAllocation_ImportDate] ON [TapasGlobalBudgeting].[BudgetOverheadAllocation] 
(
	[ImportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetTaxType]') AND name = N'IX_BudgetTaxType_ImportDate')
DROP INDEX [IX_BudgetTaxType_ImportDate] ON [TapasGlobalBudgeting].[BudgetTaxType] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetTaxType_ImportDate] ON [TapasGlobalBudgeting].[BudgetTaxType] 
(
	[ImportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetOverheadAllocation]') AND name = N'IX_BudgetOverheadAllocation_ImportBatchId_BudgetId')
DROP INDEX [IX_BudgetOverheadAllocation_ImportBatchId_BudgetId] ON [TapasGlobalBudgeting].[BudgetOverheadAllocation] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetOverheadAllocation_ImportBatchId_BudgetId] ON [TapasGlobalBudgeting].[BudgetOverheadAllocation] 
(
	[ImportBatchId] ASC,
	[BudgetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]') AND name = N'IX_BudgetEmployeePayrollAllocationDetail_ImportBatchId')
DROP INDEX [IX_BudgetEmployeePayrollAllocationDetail_ImportBatchId] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_BudgetEmployeePayrollAllocationDetail_ImportBatchId] ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] 
(
	[ImportBatchId] ASC,
	[BudgetEmployeePayrollAllocationId] ASC
)
INCLUDE ( [BudgetEmployeePayrollAllocationDetailId]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO