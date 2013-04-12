USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[stp_D_ProfitabilityReforecastIndex]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_D_ProfitabilityReforecastIndex]
GO

CREATE PROCEDURE [dbo].[stp_D_ProfitabilityReforecastIndex]
AS

IF (
		( 
			(-- If there are GBS budgets to be processed AND
				SELECT
					COUNT(*)
				FROM
					GrReportingStaging.dbo.BudgetsToProcess
				WHERE
					IsCurrentBatch = 1 AND
					IsReforecast = 1 AND
					BudgetReforecastTypeName = 'GBS Budget/Reforecast'
			) > 0 AND
			(-- The processing of GBS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = 'CanImportGBSReforecast'
			) = '1'
		)
		OR
		(
			(-- If there are TAPAS budgets to be processed AND
				SELECT
					COUNT(*)
				FROM
					GrReportingStaging.dbo.BudgetsToProcess
				WHERE
					IsCurrentBatch = 1 AND
					IsReforecast = 1 AND
					BudgetReforecastTypeName = 'TGB Budget/Reforecast'
			) > 0 AND
			(-- The processing of TAPAS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = 'CanImportTapasReforecast'
			) = '1'
		)
	)
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_ReforecastKey')
		DROP INDEX IX_ReforecastKey ON dbo.ProfitabilityReforecast WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_ActivityTypeKey')
		DROP INDEX IX_ActivityTypeKey ON dbo.ProfitabilityReforecast 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_FeeAdjustmentKey')
		DROP INDEX IX_FeeAdjustmentKey ON dbo.ProfitabilityReforecast WITH ( ONLINE = OFF )

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_AllocationRegionKey')
		DROP INDEX IX_AllocationRegionKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_CalendarKey')
		DROP INDEX IX_CalendarKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_FunctionalDepartmentKey')
		DROP INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_GlAccountKey')
		DROP INDEX IX_GlAccountKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_OriginatingRegionKey')
		DROP INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_ProfitabilityReforecast_SourceSystem')
		DROP INDEX IX_ProfitabilityReforecast_SourceSystem ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_PropertyFundKey')
		DROP INDEX IX_PropertyFundKey ON dbo.ProfitabilityReforecast 

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_ReforecatKey')
		DROP INDEX IX_ReforecatKey ON dbo.ProfitabilityReforecast 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_ProfitabilityReforecast_Budget_BudgetReforecastType')
		DROP INDEX  IX_ProfitabilityReforecast_Budget_BudgetReforecastType ON dbo.ProfitabilityReforecast WITH ( ONLINE = OFF )

	-------------------------------------------
	--Used by loading stp and cannot be dropped
	-------------------------------------------

	IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityReforecast') AND NAME = N'IX_Clustered')
		DROP INDEX IX_Clustered ON dbo.ProfitabilityReforecast 

END

GO
