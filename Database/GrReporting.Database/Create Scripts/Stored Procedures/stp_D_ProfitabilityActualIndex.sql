USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = 
OBJECT_ID(N'[dbo].[stp_D_ProfitabilityActualIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_ProfitabilityActualIndex]
GO

CREATE PROCEDURE [dbo].[stp_D_ProfitabilityActualIndex]

AS

IF
		(
			((-- The processing of MRI Actuals is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = 'CanImportMRIActuals'
			) = '1')
			
			OR
			
			((-- The processing of MRI Actuals is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = 'CanImportOverheadActuals'
			) = '1')
		)
BEGIN

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_ActivityTypeKey')
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_AllocationRegionKey')
DROP  INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_CalendarKey')
DROP  INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_FunctionalDepartmentKey')
DROP  INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_GlAccountKey')
DROP  INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_OriginatingRegionKey')
DROP  INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_PropertyFundKey')
DROP  INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_Clustered')
DROP  INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] 

END
ELSE
PRINT 'Actuals not set to be imported'

GO