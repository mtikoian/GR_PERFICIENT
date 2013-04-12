USE GrReportingStaging
GO

IF NOT EXISTS (SELECT * FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportMRIActuals' )
BEGIN 
	INSERT INTO dbo.SSISConfigurations
	(
		ConfigurationFilter,
		ConfiguredValue,
		PackagePath,
		ConfiguredValueType
	)
	VALUES
	(
		'CanImportMRIActuals',
		1,
		'\Package.Variables[User::CanImportMRIActuals].Properties[Value]',
		'Boolean'
	)
	
	PRINT 'CanImportMRIActuals added to the SSIS Configurations'
END

IF NOT EXISTS (SELECT * FROM dbo.SSISConfigurations WHERE  ConfigurationFilter = 'CanImportOverheadActuals' )
BEGIN 
	INSERT INTO dbo.SSISConfigurations
	(
		ConfigurationFilter,
		ConfiguredValue,
		PackagePath,
		ConfiguredValueType
	)
	VALUES
	(
		'CanImportOverheadActuals',
		1,
		'\Package.Variables[User::CanImportOverheadActuals].Properties[Value]',
		'Boolean'
	)
	
	PRINT 'CanImportOverheadActuals added to the SSIS Configurations'
END

DELETE dbo.SSISConfigurations
WHERE
	ConfigurationFilter IN
	(
		'PayrollBudgetImportStartDate',
		'PayrollBudgetImportEndDate',
		'PayrollBudgetDataPriorToDate',
		'NonPayrollBudgetImportStartDate',
		'NonPayrollBudgetImportEndDate',
		'NonPayrollBudgetDataPriorToDate',
		'CanImportCorporateBudget'
	)
	
UPDATE dbo.SSISConfigurations
SET	
	PackagePath = ''
WHERE
	ConfigurationFilter IN
	(
		'CanImportTapasBudget',
		'CanImportGBSBudget',
		'CanImportGBSReforecast',
		'CanImportTapasReforecast',
		'CanImportMRIActuals',
		'CanImportOverheadActuals'
	)
	
/*
	Inserts for dbo.BudgetAllocationSetYearQuarterMapping table
*/

IF object_id('tempdb..#BudgetAllocationSetYearQuarterMapping') IS NULL
BEGIN
	CREATE TABLE #BudgetAllocationSetYearQuarterMapping
	(
		BudgetAllocationSetId INT NOT NULL,
		BudgetYear INT NOT NULL,
		BudgetQuarter CHAR(2) NOT NULL
	)

	INSERT INTO #BudgetAllocationSetYearQuarterMapping
	(
		BudgetAllocationSetId,
		BudgetYear,
		BudgetQuarter
	)
	VALUES
		(1, 2011, 'Q0'),
		(9, 2011, 'Q1'),
		(10, 2011, 'Q2'),
		(13, 2011, 'Q3'),
		(11, 2012, 'Q0')
END

INSERT INTO dbo.BudgetAllocationSetYearQuarterMapping
(
	BudgetAllocationSetId,
	BudgetYear,
	BudgetQuarter
)
SELECT
	NEW.BudgetAllocationSetId,
	NEW.BudgetYear,
	NEW.BudgetQuarter
FROM
	#BudgetAllocationSetYearQuarterMapping NEW
	
	LEFT OUTER JOIN dbo.BudgetAllocationSetYearQuarterMapping Existing ON
		NEW.BudgetAllocationSetId = Existing.BudgetAllocationSetId
WHERE
	Existing.BudgetAllocationSetId IS NULL
	
IF object_id('tempdb..#BudgetAllocationSetYearQuarterMapping') IS NOT NULL
BEGIN
   DROP TABLE #BudgetAllocationSetYearQuarterMapping
END