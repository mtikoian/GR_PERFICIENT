


IF NOT EXISTS(Select * From [GrReportingStaging].[dbo].[SSISConfigurations]
Where ConfigurationFilter = 'CanImportCorporateBudget')
	BEGIN
	INSERT INTO [GrReportingStaging].[dbo].[SSISConfigurations]
			   ([ConfigurationFilter]
			   ,[ConfiguredValue]
			   ,[PackagePath]
			   ,[ConfiguredValueType])
	VALUES('CanImportCorporateBudget',0,'\Package.Variables[User::CanImportCorporateBudget].Properties[Value]','Boolean')

	END
GO



IF NOT EXISTS(Select * From [GrReportingStaging].[dbo].[SSISConfigurations]
Where ConfigurationFilter = 'CanImportTapasBudget')
	BEGIN
	INSERT INTO [GrReportingStaging].[dbo].[SSISConfigurations]
			   ([ConfigurationFilter]
			   ,[ConfiguredValue]
			   ,[PackagePath]
			   ,[ConfiguredValueType])
	VALUES('CanImportTapasBudget',0,'\Package.Variables[User::CanImportTapasBudget].Properties[Value]','Boolean')

	END
GO