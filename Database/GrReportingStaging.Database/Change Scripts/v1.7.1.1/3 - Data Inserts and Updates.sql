USE GrReportingStaging
GO

 UPDATE dbo.SSISConfigurations
SET 
      ConfiguredValue = '31 Dec 2011'
WHERE 
      ConfigurationFilter IN 
		(
			'PayrollBudgetDataPriorToDate',
			'PayrollBudgetImportEndDate'
		)
