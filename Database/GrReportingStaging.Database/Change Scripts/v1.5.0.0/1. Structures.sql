
IF NOT EXISTS (Select * From INFORMATION_SCHEMA.COLUMNS t1 Where t1.TABLE_SCHEMA = 'GACS' AND TABLE_NAME = 'Department' AND COLUMN_NAME = 'IsTsCost')
	BEGIN
	ALTER TABLE GACS.Department ADD IsTsCost bit NOT NULL CONSTRAINT DF_Department_IsTsCost DEFAULT 0
	END
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_SCHEMA = 'BudgetingCorp' AND  TABLE_NAME = 'GlobalReportingCorporateBudget' AND COLUMN_NAME = 'IsFeeAdjustment')
	BEGIN
	ALTER TABLE BudgetingCorp.GlobalReportingCorporateBudget ADD IsFeeAdjustment bit NOT NULL CONSTRAINT DF_GlobalReportingCorporateBudget_IsFeeAdjustment DEFAULT 0
	END
GO

 