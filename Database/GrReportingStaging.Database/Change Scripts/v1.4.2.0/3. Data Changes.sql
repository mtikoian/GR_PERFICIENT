

Delete From SSISConfigurations Where ConfigurationFilter IN ('ImportStartDate','ImportEndDate','DataPriorToDate')


IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'ActualImportStartDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('ActualImportStartDate','01 Jan 1900','\Package.Variables[User::ActualImportStartDate].Properties[Value]','DateTime')
	END
IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'ActualImportEndDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('ActualImportEndDate','31 Dec 2010','\Package.Variables[User::ActualImportEndDate].Properties[Value]','DateTime')
	END
IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'ActualDataPriorToDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('ActualDataPriorToDate','31 Dec 2010','\Package.Variables[User::ActualDataPriorToDate].Properties[Value]','DateTime')
	END

GO

IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'PayrollBudgetImportStartDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('PayrollBudgetImportStartDate','01 Jun 2010','\Package.Variables[User::PayrollBudgetImportStartDate].Properties[Value]','DateTime')
	END
IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'PayrollBudgetImportEndDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('PayrollBudgetImportEndDate','15 Sep 2010','\Package.Variables[User::PayrollBudgetImportEndDate].Properties[Value]','DateTime')
	END
IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'PayrollBudgetDataPriorToDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('PayrollBudgetDataPriorToDate','15 Sep 2010','\Package.Variables[User::PayrollBudgetDataPriorToDate].Properties[Value]','DateTime')
	END

GO

IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'NonPayrollBudgetImportStartDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('NonPayrollBudgetImportStartDate','01 Jun 2010','\Package.Variables[User::NonPayrollBudgetImportStartDate].Properties[Value]','DateTime')
	END
IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'NonPayrollBudgetImportEndDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('NonPayrollBudgetImportEndDate','15 Sep 2010','\Package.Variables[User::NonPayrollBudgetImportEndDate].Properties[Value]','DateTime')
	END
IF NOT EXISTS(Select * From SSISConfigurations Where ConfigurationFilter = 'NonPayrollBudgetDataPriorToDate')
	BEGIN
	Insert Into SSISConfigurations
	(ConfigurationFilter,ConfiguredValue,PackagePath,ConfiguredValueType)
	VALUES('NonPayrollBudgetDataPriorToDate','15 Sep 2010','\Package.Variables[User::NonPayrollBudgetDataPriorToDate].Properties[Value]','DateTime')
	END

GO 