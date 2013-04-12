USE GrReportingStaging
GO

IF NOT EXISTS (SELECT 1 FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportGBSBudget')
BEGIN
	INSERT INTO dbo.SSISConfigurations (
		ConfigurationFilter,
		ConfiguredValue,
		PackagePath,
		ConfiguredValueType
	)
	VALUES (
		'CanImportGBSBudget',
		0,
		N'\Package.Variables[User::CanImportGBSBudget].Properties[Value]',
		'Boolean'
	)
END
ELSE
BEGIN
	PRINT ('Cannot insert "CanImportGBSBudget" into dbo.SSISConfigurations because it already exists.')
END

GO
------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportGBSReforecast')
BEGIN
	INSERT INTO dbo.SSISConfigurations (
		ConfigurationFilter,
		ConfiguredValue,
		PackagePath,
		ConfiguredValueType
	)
	VALUES (
		'CanImportGBSReforecast',
		'0',
		N'\Package.Variables[User::CanImportGBSReforecast].Properties[Value]',
		'Boolean'
	)
END
ELSE
BEGIN
	PRINT ('Cannot insert "CanImportGBSReforecast" into dbo.SSISConfigurations because it already exists.')
END

GO
------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportTapasReforecast')
BEGIN
	INSERT INTO dbo.SSISConfigurations (
		ConfigurationFilter,
		ConfiguredValue,
		PackagePath,
		ConfiguredValueType
	)
	VALUES (
		'CanImportTapasReforecast',
		'0',
		N'\Package.Variables[User::CanImportTapasReforecast].Properties[Value]',
		'Boolean'
	)
END
ELSE
BEGIN
	PRINT ('Cannot insert "CanImportTapasReforecast" into dbo.SSISConfigurations because it already exists.')
END

GO
------------------------------------------------------------------------------------------------------------
USE GrReportingStaging
GO

UPDATE
	dbo.SSISConfigurations
SET
	ConfiguredValue = '31 May 2011'
WHERE
	ConfigurationFilter IN ('ActualImportEndDate', 'ActualDataPriorToDate', 'PayrollBudgetImportEndDate', 'PayrollBudgetDataPriorToDate')
