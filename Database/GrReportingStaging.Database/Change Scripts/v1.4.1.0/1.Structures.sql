USE [GrReportingStaging]
GO
CREATE NONCLUSTERED INDEX IX_ImportBatchIdBudgetProjectId
ON [TapasGlobalBudgeting].[BudgetProject] ([ImportBatchId],[BudgetProjectId])
INCLUDE ([ImportKey])
GO
USE [GrReportingStaging]
GO
CREATE NONCLUSTERED INDEX IX_ImportBatchIdBudgetEmployeeFunctionalDepartmentId
ON [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] ([ImportBatchId],[BudgetEmployeeFunctionalDepartmentId])
INCLUDE ([ImportKey])
GO
USE [GrReportingStaging]
GO

CREATE NONCLUSTERED INDEX [IX_ImportBatchIdBudgetEmployeePayrollAllocationId]
ON [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] ([ImportBatchId],[BudgetEmployeePayrollAllocationId])
INCLUDE ([ImportKey])
GO

GO
USE [GrReportingStaging]
GO
CREATE NONCLUSTERED INDEX [IX_PackageName] ON [dbo].[Batch] 
(
	[PackageName] ASC,
	[ImportEndDate] ASC,
	[BatchEndDate] ASC
)
INCLUDE ( [BatchId]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


----------------------------------------------------------------------------------------------------------------------------------
--Remove the non used columns
----------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where 
	TABLE_NAME = 'GLGlobalAccount' 
	AND COLUMN_NAME = 'ParentGLGlobalAccountId')
	BEGIN
	ALTER TABLE Gdm.GLGlobalAccount DROP COLUMN ParentGLGlobalAccountId
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where 
	TABLE_NAME = 'ActivityType' 
	AND COLUMN_NAME = 'ActivityTypeCode')
	BEGIN
	ALTER TABLE Gdm.ActivityType DROP COLUMN ActivityTypeCode
	END
GO
IF EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where 
	TABLE_NAME = 'ActivityType' 
	AND COLUMN_NAME = 'GLSuffix')
	BEGIN
	ALTER TABLE Gdm.ActivityType DROP COLUMN GLSuffix
	END
GO

ALTER TABLE USProp.Entity ALTER COLUMN Phone char(15) NULL
GO
 