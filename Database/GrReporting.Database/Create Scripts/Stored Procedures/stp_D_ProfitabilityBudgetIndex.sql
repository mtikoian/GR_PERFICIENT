USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_D_ProfitabilityBudgetIndex') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.stp_D_ProfitabilityBudgetIndex

GO

CREATE PROCEDURE dbo.stp_D_ProfitabilityBudgetIndex
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
					IsReforecast = 0 AND
					BudgetReforecastTypeName = 'GBS Budget/Reforecast'
			) > 0 AND
			(-- The processing of GBS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = 'CanImportGBSBudget'
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
					IsReforecast = 0 AND
					BudgetReforecastTypeName = 'TGB Budget/Reforecast'
			) > 0 AND
			(-- The processing of TAPAS Budgets is permitted
				SELECT
					ConfiguredValue
				FROM
					GrReportingStaging.dbo.SSISConfigurations
				WHERE
					ConfigurationFilter = 'CanImportTapasBudget'
			) = '1'
		)
	)
BEGIN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_ActivityTypeKey')
		DROP INDEX IX_ActivityTypeKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_AllocationRegionKey')
		DROP INDEX IX_AllocationRegionKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_CalendarKey')
		DROP INDEX IX_CalendarKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_FunctionalDepartmentKey')
		DROP INDEX IX_FunctionalDepartmentKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_GlAccountKey')
		DROP INDEX IX_GlAccountKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_OriginatingRegionKey')
		DROP INDEX IX_OriginatingRegionKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_ProfitabilityBudget_SourceSystemBudget')
		DROP INDEX IX_ProfitabilityBudget_SourceSystemBudget ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_PropertyFundKey')
		DROP INDEX IX_PropertyFundKey ON dbo.ProfitabilityBudget 

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_GlobalGlAccountCategoryKey')
		DROP INDEX IX_GlobalGlAccountCategoryKey ON dbo.ProfitabilityBudget WITH ( ONLINE = OFF )

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_ProfitabilityBudget_SourceSystemBudget')
		DROP INDEX IX_ProfitabilityBudget_SourceSystemBudget ON dbo.ProfitabilityBudget WITH ( ONLINE = OFF )

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.ProfitabilityBudget') AND name = N'IX_Clustered')
		DROP INDEX IX_Clustered ON dbo.ProfitabilityBudget 

END

GO
