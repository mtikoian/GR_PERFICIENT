/*
	Drop indexes

	1. dbo.OriginatingRegion.IX_Name_SubName
	2. dbo.OriginatingRegion.IX_SubName
	3. dbo.AllocationRegion.IX_Name_SubName
	4. dbo.ActivityType.IX_Unique
	5. dbo.GlAccount.IX_Code
	6. dbo.GlAccountCategory.IX_Composite
	7. dbo.GlAccountCategory.IX_GlAccountCategoryKey_MinorCategoryName
	8. dbo.GlAccountCategory.IX_MinorName
	9. dbo.ExchangeRate.IX_Unique
	10. dbo.ExchangeRate.IX_DestinationCurrencyKey
	11. dbo.ExchangeRate.IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey
	12. dbo.ExchangeRate.IX_SourceToDestination

*/

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. GrReportingStaging.dbo.OriginatingRegion.IX_Name_SubName ----------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegion]') AND name = N'IX_Name_SubName')
BEGIN
	DROP INDEX [IX_Name_SubName] ON [dbo].[OriginatingRegion] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.OriginatingRegion.IX_Name_SubName" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.OriginatingRegion.IX_Name_SubName" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. GrReportingStaging.dbo.OriginatingRegion.IX_SubName ----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegion]') AND name = N'IX_SubName')
BEGIN
	DROP INDEX [IX_SubName] ON [dbo].[OriginatingRegion] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.OriginatingRegion.IX_SubName" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.OriginatingRegion.IX_SubName" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. GrReportingStaging.dbo.AllocationRegion.IX_Name_SubName -----------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AllocationRegion]') AND name = N'IX_Name_SubName')
BEGIN
	DROP INDEX [IX_Name_SubName] ON [dbo].[AllocationRegion] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.AllocationRegion.IX_Name_SubName" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.AllocationRegion.IX_Name_SubName" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. GrReportingStaging.dbo.ActivityType.IX_Unique ---------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ActivityType]') AND name = N'IX_Unique')
BEGIN
	DROP INDEX [IX_Unique] ON [dbo].[ActivityType] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.ActivityType.IX_Unique" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.ActivityType.IX_Unique" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. GrReportingStaging.dbo.GlAccount.IX_Code --------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GlAccount]') AND name = N'IX_Code')
BEGIN
	DROP INDEX [IX_Code] ON [dbo].[GlAccount] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.GlAccount.IX_Code" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.GlAccount.IX_Code" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 6. GrReportingStaging.dbo.GlAccountCategory.IX_Composite -------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND name = N'IX_Composite')
BEGIN
	DROP INDEX [IX_Composite] ON [dbo].[GlAccountCategory] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.GlAccountCategory.IX_Composite" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.GlAccountCategory.IX_Composite" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. GrReportingStaging.dbo.GlAccountCategory.IX_GlAccountCategoryKey_MinorCategoryName --------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND name = N'IX_GlAccountCategoryKey_MinorCategoryName')
BEGIN
	DROP INDEX [IX_GlAccountCategoryKey_MinorCategoryName] ON [dbo].[GlAccountCategory] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.GlAccountCategory.IX_GlAccountCategoryKey_MinorCategoryName" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.GlAccountCategory.IX_GlAccountCategoryKey_MinorCategoryName" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 8. GrReportingStaging.dbo.GlAccountCategory.IX_MinorName -------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND name = N'IX_MinorName')
BEGIN
	DROP INDEX [IX_MinorName] ON [dbo].[GlAccountCategory] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.GlAccountCategory.IX_MinorName" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.GlAccountCategory.IX_MinorName" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. GrReportingStaging.dbo.ExchangeRate.IX_Clustered ------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_Clustered')
BEGIN
	DROP INDEX [IX_Clustered] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.ExchangeRate.IX_Clustered" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.ExchangeRate.IX_Clustered" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 10. GrReportingStaging.dbo.ExchangeRate.IX_DestinationCurrencyKey ----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_DestinationCurrencyKey')
BEGIN
	DROP INDEX [IX_DestinationCurrencyKey] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.ExchangeRate.IX_DestinationCurrencyKey" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.ExchangeRate.IX_DestinationCurrencyKey" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 11. GrReportingStaging.dbo.ExchangeRate.IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey ----------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey')
BEGIN
	DROP INDEX [IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.ExchangeRate.IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.ExchangeRate.IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey" as it does not exist.')
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 12. GrReportingStaging.dbo.ExchangeRate.IX_SourceToDestination -------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ExchangeRate]') AND name = N'IX_SourceToDestination')
BEGIN
	DROP INDEX [IX_SourceToDestination] ON [dbo].[ExchangeRate] WITH ( ONLINE = OFF )
	
	PRINT ('Index "dbo.ExchangeRate.IX_SourceToDestination" dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop index "dbo.ExchangeRate.IX_SourceToDestination" as it does not exist.')
END
GO