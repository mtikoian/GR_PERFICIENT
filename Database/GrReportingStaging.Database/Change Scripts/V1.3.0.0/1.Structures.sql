ALTER TABLE BudgetingCorp.GlobalReportingCorporateBudget ALTER Column SourceUniqueKey Varchar(450) NOT NULL
GO 

IF NOT EXISTS(SELECT 1 FROM information_schema.columns WHERE COLUMN_NAME = 'IsExpense' AND TABLE_NAME = 'GlobalReportingCorporateBudget')
BEGIN
    ALTER TABLE BudgetingCorp.GlobalReportingCorporateBudget
    ADD IsExpense bit
END
GO

UPDATE BudgetingCorp.GlobalReportingCorporateBudget
SET IsExpense = 1
WHERE SourceUniqueKey LIKE '%&FeeIncomeId=0&%'

GO

UPDATE BudgetingCorp.GlobalReportingCorporateBudget
SET IsExpense = 0
WHERE IsExpense IS NULL

GO

ALTER TABLE [GDM].[PropertyFund]
ALTER COLUMN RelatedFundId int NULL
GO