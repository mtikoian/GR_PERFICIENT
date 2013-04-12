  

-- update configuredvalue from '01 Jan 1900' to '01 Jan 2012'
  update [GrReportingStaging].[dbo].[SSISConfigurations] 
  set ConfiguredValue = '01 Jan 2012' 
  where ConfigurationFilter = 'ActualImportStartDate';
  
 
-- add column 'ISFUND' to [GrReportingStaging].EUProp.ENTITY
  ALTER TABLE [GrReportingStaging].EUProp.ENTITY
  ADD ISFUND char(1)  ;
  