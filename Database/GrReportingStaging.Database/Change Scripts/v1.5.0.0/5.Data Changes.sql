 
 
 USE GrReportingStaging
 GO
 
Update SSISConfigurations Set ConfiguredValue = 1 Where ConfigurationFilter = 'CanImportCorporateBudget'
Update SSISConfigurations Set ConfiguredValue = 1 Where ConfigurationFilter = 'CanImportTapasBudget'
Update SSISConfigurations Set ConfiguredValue = '01 Jun 2010' Where ConfigurationFilter = 'PayrollBudgetImportStartDate'
Update SSISConfigurations Set ConfiguredValue = '31 Dec 2010' Where ConfigurationFilter = 'PayrollBudgetImportEndDate'
Update SSISConfigurations Set ConfiguredValue = '31 Dec 2010' Where ConfigurationFilter = 'PayrollBudgetDataPriorToDate'
Update SSISConfigurations Set ConfiguredValue = '01 Jun 2010' Where ConfigurationFilter = 'NonPayrollBudgetImportStartDate'
Update SSISConfigurations Set ConfiguredValue = '31 Dec 2010' Where ConfigurationFilter = 'NonPayrollBudgetImportEndDate'
Update SSISConfigurations Set ConfiguredValue = '31 Dec 2010' Where ConfigurationFilter = 'NonPayrollBudgetDataPriorToDate'

