INSERT INTO [GrReportingStaging].[dbo].[SSISConfigurations]
           ([ConfigurationFilter]
           ,[ConfiguredValue]
           ,[PackagePath]
           ,[ConfiguredValueType])
		select     'CanImportTimeAllocationActuals',1 ,'','Boolean'
union	select     'CanImportTimeAllocationBudget',1 ,'','Boolean'
union	select     'CanImportTimeAllocationReforecast',1 ,'','Boolean'
GO
