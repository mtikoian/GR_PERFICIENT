  
  
  
  
  --replication tables--  
  alter table [TAPASUS].[Admin].[SystemSettingRegion] drop column BankLetterAddress;
 
  alter table GDM.dbo.Department with nocheck add IsDeleted bit not null default(0);
  
  --staging tables--
  
  alter table [GrReportingStaging].Gdm.Department with nocheck add IsDeleted bit not null default(0);
  alter table [GrReportingStaging].TapasGlobal.SystemSettingRegion drop column BankLetterAddress;
  
  
  