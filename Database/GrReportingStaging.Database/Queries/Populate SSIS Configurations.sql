
INSERT INTO dbo.SSISConfigurations 
(
	[ConfigurationFilter]
   ,[ConfiguredValue]
   ,[PackagePath]
   ,[ConfiguredValueType]
)
VALUES
(
	'ImportStartDate',	
	'01 Jan 2010',	
	'\Package.Variables[User::ImportStartDate].Properties[Value]',
	'DateTime'
)


INSERT INTO dbo.SSISConfigurations 
(
	[ConfigurationFilter]
   ,[ConfiguredValue]
   ,[PackagePath]
   ,[ConfiguredValueType]
)
VALUES
(
	'ImportEndDate',	
	'31 Dec 2010',	
	'\Package.Variables[User::ImportEndDate].Properties[Value]',	
	'DateTime'
)


INSERT INTO dbo.SSISConfigurations 
(
	[ConfigurationFilter]
   ,[ConfiguredValue]
   ,[PackagePath]
   ,[ConfiguredValueType]
)
VALUES
(
	'DataPriorToDate',
	'31 Dec 2010',	
	'\Package.Variables[User::DataPriorToDate].Properties[Value]',	
	'DateTime'
)


