 USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
PRINT '[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget] stored procedure dropped'
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
PRINT '[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast] stored procedure dropped'
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_BudgetsToProcess]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE [dbo].[stp_I_BudgetsToProcess]
PRINT '[dbo].[stp_I_BudgetsToProcess] stored procedure dropped'
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO



-- Scripted stored procedures start here

USE [GrReportingStaging]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityMRIActual]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityMRIActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityOverheadActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadExchangeRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO
/****** Object:  StoredProcedure [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_J_UpdateSSISConfigurationsImportWindow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
GO
/****** Object:  StoredProcedure [dbo].[stp_U_ImportBatch]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_U_ImportBatch]
GO
/****** Object:  StoredProcedure [dbo].[stp_U_SyncBudgetsProcessed]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_SyncBudgetsProcessed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_TapasBudget]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_TapasBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_TapasBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ImportBatch]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_BudgetsToProcess]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_BudgetsToProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_BudgetsToProcess]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityActual]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityActual]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_GBSBudget]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GBSBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_GBSBudget]
GO
/****** Object:  StoredProcedure [dbo].[stp_D_GdmSnapshot]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GdmSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_GdmSnapshot]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityBudgetIndex]    Script Date: 03/08/2012 12:49:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ProfitabilityBudgetIndex]
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ProfitabilityBudgetIndex]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ProfitabilityBudgetIndex]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_I_ProfitabilityBudgetIndex]
AS

/*
	Indexes:
		- dbo.ProfitabilityBudget.IX_ActivityTypeKey
		- dbo.ProfitabilityBudget.IX_AllocationRegionKey
		- dbo.ProfitabilityBudget.IX_CalendarKey
		- dbo.ProfitabilityBudget.IX_Clustered
		- dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey
		- dbo.ProfitabilityBudget.IX_GlAccountKey
		- dbo.ProfitabilityBudget.IX_OriginatingRegionKey
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget				[don''t recreate]
		- dbo.ProfitabilityBudget.IX_PropertyFundKey
		- dbo.ProfitabilityBudget.IX_ReferenceCode
		- dbo.ProfitabilityBudget.IX_GlobalGlAccountCategoryKey
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType
		- dbo.ProfitabilityBudget.IX_BudgetIdSourceSystemId								[don''t recreate]
		- dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget				[don''t recreate]

*/

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--																	Drop Indexes
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_ActivityTypeKey'')
BEGIN
	DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_ActivityTypeKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_ActivityTypeKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_AllocationRegionKey'')
BEGIN
	DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_AllocationRegionKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_AllocationRegionKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_CalendarKey'')
BEGIN
	DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_CalendarKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_CalendarKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_Clustered'')
BEGIN
	DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_Clustered dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_Clustered as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_FunctionalDepartmentKey'')
BEGIN
	DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_GlAccountKey'')
BEGIN
	DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_GlAccountKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_GlAccountKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_OriginatingRegionKey'')
BEGIN
	DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_OriginatingRegionKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_OriginatingRegionKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_ProfitabilityBudget_SourceSystemBudget'')
BEGIN
	DROP INDEX [IX_ProfitabilityBudget_SourceSystemBudget] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_PropertyFundKey'')
BEGIN
	DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_PropertyFundKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_PropertyFundKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_ReferenceCode'')
BEGIN
	DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_ReferenceCode dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_ReferenceCode as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_GlobalGlAccountCategoryKey'')
BEGIN
	DROP INDEX [IX_GlobalGlAccountCategoryKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_GlobalGlAccountCategoryKey dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_GlobalGlAccountCategoryKey as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_ProfitabilityBudget_Budget_BudgetReforecastType'')
BEGIN
	DROP INDEX [IX_ProfitabilityBudget_Budget_BudgetReforecastType]  ON  [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_BudgetIdSourceSystemId'')
BEGIN
	DROP INDEX [IX_BudgetIdSourceSystemId]  ON  [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_BudgetIdSourceSystemId dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_BudgetIdSourceSystemId as it does not exist.'')
END





----------------------------------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[ProfitabilityBudget]'') AND name = N''IX_ProfitabilityBudget_SourceSystemBudget'')
BEGIN
	DROP INDEX [IX_ProfitabilityBudget_SourceSystemBudget]  ON  [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
	PRINT (''Index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget dropped.'')
END
ELSE
BEGIN
	PRINT (''Cannot drop index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_SourceSystemBudget as it does not exist.'')
END

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
--																	Create Indexes
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

DECLARE @StartTime DATETIME = GETDATE()

CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[AllocationRegionKey] ASC,
	[GlobalGlAccountCategoryKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[PropertyFundKey] ASC,
	[GlAccountKey] ASC,
	[SourceKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[LocalCurrencyKey] ASC,
	[OverheadKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_Clustered created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] 
(
	[ActivityTypeKey] ASC
)
INCLUDE (
	[ProfitabilityBudgetKey],
	[CalendarKey],
	[GlAccountKey],
	[SourceKey],
	[FunctionalDepartmentKey],
	[ReimbursableKey],
	[PropertyFundKey],
	[AllocationRegionKey],
	[OriginatingRegionKey],
	[LocalCurrencyKey],
	[LocalBudget],
	[GlobalGlAccountCategoryKey],
	[BudgetReforecastTypeKey],
	[OverheadKey],
	[FeeAdjustmentKey]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_ActivityTypeKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[AllocationRegionKey] ASC
)
INCLUDE (
	[ProfitabilityBudgetKey],
	[CalendarKey],
	[GlAccountKey],
	[SourceKey],
	[FunctionalDepartmentKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[PropertyFundKey],
	[OriginatingRegionKey],
	[LocalCurrencyKey],
	[LocalBudget],
	[GlobalGlAccountCategoryKey],
	[BudgetReforecastTypeKey],
	[OverheadKey],
	[FeeAdjustmentKey]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_AllocationRegionKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] 
(
	[CalendarKey] ASC
)
INCLUDE (
	[LocalBudget],
	[ProfitabilityBudgetKey],
	[PropertyFundKey],
	[FunctionalDepartmentKey],
	[ReimbursableKey],
	[AllocationRegionKey],
	[OriginatingRegionKey],
	[LocalCurrencyKey],
	[GlAccountKey],
	[SourceKey],
	[ActivityTypeKey],
	[GlobalGlAccountCategoryKey],
	[BudgetReforecastTypeKey],
	[OverheadKey],
	[FeeAdjustmentKey]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_CalendarKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityBudget] 
(
	[FunctionalDepartmentKey] ASC
)
INCLUDE (
	[ProfitabilityBudgetKey],
	[CalendarKey],
	[ReimbursableKey],
	[PropertyFundKey],
	[AllocationRegionKey],
	[LocalCurrencyKey],
	[LocalBudget],
	[GlAccountKey],
	[SourceKey],
	[ActivityTypeKey],
	[OriginatingRegionKey],
	[GlobalGlAccountCategoryKey],
	[BudgetReforecastTypeKey],
	[OverheadKey],
	[FeeAdjustmentKey]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_FunctionalDepartmentKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityBudget] 
(
	[GlAccountKey] ASC
)
INCLUDE (
	[ProfitabilityBudgetKey],
	[CalendarKey],
	[SourceKey],
	[FunctionalDepartmentKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[PropertyFundKey],
	[AllocationRegionKey],
	[OriginatingRegionKey],
	[LocalCurrencyKey],
	[LocalBudget],
	[GlobalGlAccountCategoryKey],
	[BudgetReforecastTypeKey],
	[OverheadKey],
	[FeeAdjustmentKey]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_GlAccountKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] 
(
	[OriginatingRegionKey] ASC,
	[CalendarKey] ASC,
	[GlAccountKey] ASC,
	[SourceKey] ASC,
	[FunctionalDepartmentKey] ASC,
	[ReimbursableKey] ASC,
	[ActivityTypeKey] ASC,
	[PropertyFundKey] ASC,
	[AllocationRegionKey] ASC,
	[LocalCurrencyKey] ASC,
	[GlobalGlAccountCategoryKey] ASC,
	[BudgetReforecastTypeKey] ASC,
	[OverheadKey] ASC,
	[FeeAdjustmentKey] ASC
)
INCLUDE ( [LocalBudget],
[ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_OriginatingRegionKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_ProfitabilityBudget_Budget_BudgetReforecastType] ON [dbo].[ProfitabilityBudget] 
(
	[BudgetId] ASC,
	[BudgetReforecastTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_ProfitabilityBudget_Budget_BudgetReforecastType created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] 
(
	[PropertyFundKey] ASC
)
INCLUDE (
	[LocalBudget],
	[ProfitabilityBudgetKey],
	[CalendarKey],
	[GlAccountKey],
	[SourceKey],
	[FunctionalDepartmentKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[AllocationRegionKey],
	[OriginatingRegionKey],
	[LocalCurrencyKey],
	[GlobalGlAccountCategoryKey],
	[BudgetReforecastTypeKey],
	[OverheadKey],
	[FeeAdjustmentKey]
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

PRINT (''Index dbo.ProfitabilityBudget.IX_PropertyFundKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityBudget] 
(
	[ReferenceCode] ASC
)
INCLUDE ( [ProfitabilityBudgetKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
 
PRINT (''Index dbo.ProfitabilityBudget.IX_ReferenceCode created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))




 ----------------------------------------------------------------------------------------------------------------------------------------

SET @StartTime = GETDATE()

CREATE INDEX [IX_GlobalGlAccountCategoryKey] ON [GrReporting].[dbo].[ProfitabilityBudget]
(
	[GlobalGlAccountCategoryKey]
)
INCLUDE (
	[CalendarKey],
	[GlAccountKey], 
	[SourceKey], 
	[ReimbursableKey], 
	[ActivityTypeKey], 
	[LocalCurrencyKey], 
	[LocalBudget], 
	[OverheadKey]
)

PRINT (''Index dbo.ProfitabilityBudget.IX_GlobalGlAccountCategoryKey created in '' + CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_GdmSnapshot]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GdmSnapshot]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	Deletes snapshot data from the GrReportingStaging database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_D_GdmSnapshot]
	@SnapshotId INT
AS

BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------

-- Find all of the snapshot table names in GrReportingStaging

IF (@SnapshotId IS NULL)
BEGIN
	PRINT ''There is no snapshot to delete''
	RETURN
END

CREATE TABLE #AllSnapshotTables (
	TableName VARCHAR(128) NOT NULL
)

INSERT INTO #AllSnapshotTables (
	TableName
)
SELECT
	LTRIM(RTRIM(TABLE_NAME))
FROM
	INFORMATION_SCHEMA.TABLES
WHERE
	TABLE_TYPE = ''BASE TABLE'' AND
	TABLE_SCHEMA = ''Gdm'' AND
	LEFT(TABLE_NAME, 8) = ''Snapshot''

------------------------------------------------------------

DECLARE tableCursor CURSOR FOR SELECT TableName FROM #AllSnapshotTables
DECLARE @CurrentTableName VARCHAR(128)

OPEN tableCursor

FETCH NEXT FROM tableCursor
INTO @CurrentTableName

WHILE @@FETCH_STATUS = 0 -- Loop through all snapshot table names, and execute the delete statement on each of them
BEGIN

	DECLARE @Query VARCHAR(MAX) = ''
	DELETE
		S
	FROM
		Gdm.['' + @CurrentTableName + ''] S
	WHERE
		S.SnapshotId = '' + CONVERT(VARCHAR(3), @SnapshotId)

	EXEC(@Query)
	--PRINT(@Query)
	
	FETCH NEXT FROM tableCursor
	INTO @CurrentTableName

END

CLOSE tableCursor
DEALLOCATE tableCursor

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_GBSBudget]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GBSBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	Deletes GBS Budget data from the GrReportingStaging database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_D_GBSBudget]
	@BudgetId INT

AS

BEGIN

IF @BudgetId IS NULL
BEGIN
	PRINT ''There is no budget to delete''
	RETURN
END

--------------------------------------------------------------------------
-- delete GBS.DisputeStatus
--------------------------------------------------------------------------

DELETE DS
FROM 
	GBS.DisputeStatus DS
WHERE
	DS.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM GBS.Budget WHERE BudgetId <> @BudgetId)

DELETE FROM GBS.BudgetPeriod
WHERE
	BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.OverheadType
--------------------------------------------------------------------------

DELETE OT
FROM
	GBS.OverheadType OT 
WHERE
	OT.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM GBS.Budget WHERE BudgetId <> @BudgetId)

--------------------------------------------------------------------------
-- delete GBS.BudgetProfitabilityActual
--------------------------------------------------------------------------

DELETE FROM GBS.BudgetProfitabilityActual
WHERE
	BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.FeeDetail
--------------------------------------------------------------------------

DELETE FD
FROM 
	GBS.FeeDetail FD
	INNER JOIN GBS.Fee F ON
		FD.FeeId = F.FeeId AND
		FD.ImportBatchId = F.ImportBatchId
WHERE
	F.BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.Fee
--------------------------------------------------------------------------
		
DELETE FROM GBS.Fee
WHERE
	BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpenseDispute
--------------------------------------------------------------------------

DELETE NPED
FROM 
	GBS.NonPayrollExpenseDispute NPED
	INNER JOIN GBS.NonPayrollExpense NPE ON
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
		NPED.ImportBatchId = NPE.ImportBatchId
WHERE
	NPE.BudgetId = @BudgetId

--------------------------------------------------------------------------
-- delete GBS.NonPayrollExpenseBreakdown
--------------------------------------------------------------------------
		
DELETE FROM GBS.NonPayrollExpense
WHERE
	BudgetId = @BudgetId

DELETE FROM GBS.NonPayrollExpenseBreakdown
WHERE
	BudgetId = @BudgetId
	

--------------------------------------------------------------------------
-- delete GBS.Budget
--------------------------------------------------------------------------

DELETE FROM GBS.Budget
WHERE
	BudgetId = @BudgetId
	
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityActual]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityActual]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/* 

This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive table. These rows no longer exist in
the source data systems.

This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, given that access to its
#ProfitabilityActual temporary table is required.

*/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

SELECT
	GRPA.*
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA

	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable PAST ON
		GRPA.ProfitabilityActualSourceTableId = PAST.ProfitabilityActualSourceTableId

	LEFT OUTER JOIN #ProfitabilityActual GRSPA ON
		GRPA.ReferenceCode = GRSPA.ReferenceCode AND
		GRPA.SourceKey = GRSPA.SourceKey
WHERE
	GRSPA.ReferenceCode IS NULL AND
	PAST.ProfitabilityActualSourceTableId IN (1, 2) AND -- only consider transactions from GHIS and JOURNAL
	GRPA.EntryDate BETWEEN @ImportStartDate AND @ImportEndDate

-- Insert orphan rows into dbo.ProfitabilityActualArchive table

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive

SELECT
	NPAAR.*,
	GETDATE()
FROM
	#NewProfitabilityActualArchiveRecords NPAAR

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE
FROM
	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

--

PRINT ''Completed removing all orphan records from GrReporting.dbo.ProfitabilityActual:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #NewProfitabilityActualArchiveRecords


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_BudgetsToProcess]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_BudgetsToProcess]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_BudgetsToProcess]
	@IsTestExecution BIT = 0,
	@ForceSnapshotsToBeReimported BIT = 0,
	@ForceReforecastActualsToBeProcessed BIT = 0,
	@GBSBudgetIdsToForcefullyProcess VARCHAR(MAX) = NULL,
	@TAPASBudgetIdsToForcefullyProcess VARCHAR(MAX) = NULL
	
AS

	/*
		It is sometimes the case that we want to manually specificy certain budgets to be (re)processed without (re)processing other budgets
			that are legitimately ready to be loaded into the warehouse (for instance, a new budget has just been locked in GBS on live but we
			need to run the job for a minor support release and process an existing budget, and need to put the processing of the new GBSbudget
			on hold for the time being).

		The @GBSBudgetIdsToForcefullyProcess and @TAPASBudgetIdsToForcefullyProcess parameters allow for a pipe-separated list of budget Ids for
			each system to be passed to this stored procedure. These budgets are then forced to be (re)processed.

		The @ForceSnapshotsToBeReimported parameter indicates whether the snapshots associated with budgets that are to be forcefully reprocessed
			should be reimported.

		The @ForceReforecastActualsToBeProcessed parameter indicates whether the actuals of the reforecasts that are to be forcefully reprocessed
			should themselves be reprocessed. This is required as these actuals will typically only be processed into the warehouse once (ever).
	*/

/* =============================================================================================================================================
	Process stored procedure parameters
   =========================================================================================================================================== */
BEGIN

	IF (@IsTestExecution = 1)
	BEGIN
		PRINT (''dbo.stp_I_BudgetsToProcess is executing in test mode ...'')
	END

	CREATE TABLE #GBSBudgetIdsToForcefullyProcess
	(
		BudgetId INT NOT NULL
	)

	CREATE TABLE #TAPASBudgetIdsToForcefullyProcess
	(
		BudgetId INT NOT NULL
	)

	DECLARE @ErrorMessage NVARCHAR(MAX)

	IF (@GBSBudgetIdsToForcefullyProcess IS NOT NULL)
	BEGIN

		BEGIN TRY

			INSERT INTO #GBSBudgetIdsToForcefullyProcess
			SELECT
				CONVERT(INT, LTRIM(RTRIM(item)))
			FROM
				GrReporting.dbo.SPLIT(@GBSBudgetIdsToForcefullyProcess)

		END TRY
		
		BEGIN CATCH

			SET @ErrorMessage = ERROR_MESSAGE()
			RAISERROR(N''An error was thrown while trying to split and cast " %s ". %s. If multiple budget ids are being passed, make sure they are | seperated. Aborting ...'', 10, 1, @GBSBudgetIdsToForcefullyProcess, @ErrorMessage)

			RETURN; -- Quit as it was the intention of the executor to exclude certain budgets, and there is no guarantee that this will now happen.

		END CATCH
		
	END

	IF (@TAPASBudgetIdsToForcefullyProcess IS NOT NULL)
	BEGIN

		BEGIN TRY

			INSERT INTO #TAPASBudgetIdsToForcefullyProcess
			SELECT
				CONVERT(INT, LTRIM(RTRIM(item)))
			FROM
				GrReporting.dbo.SPLIT(@TAPASBudgetIdsToForcefullyProcess)

		END TRY
		
		BEGIN CATCH

			SET @ErrorMessage = ERROR_MESSAGE()
			RAISERROR(N''An error was thrown while trying to split and cast " %s ". %s. If multiple budget ids are being passed, make sure they are | seperated. Aborting ...'', 10, 1, @TAPASBudgetIdsToForcefullyProcess, @ErrorMessage)

			RETURN; -- Quit as it was the intention of the executor to exclude certain budgets, and there is no guarantee that this will now happen.

		END CATCH
		
	END

END

/* =============================================================================================================================================
	Perform validity check on dbo.BudgetsToProcess table
   =========================================================================================================================================== */
IF (@IsTestExecution = 0) -- Only apply updates to the BudgetsToProcess table if this is not a test execution
BEGIN

	/*
		Make sure that no records currently have their IsCurrentBatch flags set to 1 as there is a chance that we will be inserting a new batch
			of budgets to (re)process.
	*/

	UPDATE
		dbo.BudgetsToProcess
	SET
		IsCurrentBatch = 0
	WHERE
		IsCurrentBatch = 1

	/*
		The ''BudgetProcessedIntoWarehouse'' and ''DateBudgetProcessedIntoWarehouse'' fields for all records in dbo.BudgetsToProcess should no
			longer be null. ''BudgetProcessedIntoWarehouse'' should be either:
				- -1: The import of the budget failed because of a technical error (stored procedure failure etc)
				-  0: The budget was not imported because of unknowns
				-  1: The budget was imported successfully
			
		If any of the records still have ''BudgetProcessedIntoWarehouse'' or ''DateBudgetProcessedIntoWarehouse'' set to null, then
			it is likely that there was some sort of failure during the previous import that was not handled correctly. As such,
			set: ''BudgetProcessedIntoWarehouse'' = -1, and ''DateBudgetProcessedIntoWarehouse'' = current time [GetDate()]
	*/

	UPDATE
		dbo.BudgetsToProcess
	SET
		OriginalBudgetProcessedIntoWarehouse = ISNULL(OriginalBudgetProcessedIntoWarehouse, -1),
		ImportBatchId = ISNULL(ImportBatchId, -1),
		BudgetSourceSystemSyncd = ISNULL(BudgetSourceSystemSyncd, 0),
		DateBudgetProcessedIntoWarehouse = ISNULL(DateBudgetProcessedIntoWarehouse, GETDATE()),
		ReasonForFailure = ISNULL(ReasonForFailure, '''') +
						   ''Validity check in stp_I_BudgetsToProcess failed|'' + -- NULL + string returns NULL, which is not what we want
						   CASE WHEN OriginalBudgetProcessedIntoWarehouse IS NULL THEN ''OriginalBudgetProcessedIntoWarehouse IS NULL|'' ELSE '''' END +
						   CASE WHEN ImportBatchId IS NULL THEN ''ImportBatchId IS NULL|'' ELSE '''' END +
						   CASE WHEN BudgetSourceSystemSyncd IS NULL THEN ''BudgetSourceSystemSyncd IS NULL|'' ELSE '''' END +
						   CASE WHEN DateBudgetProcessedIntoWarehouse IS NULL THEN ''DateBudgetProcessedIntoWarehouse IS NULL|'' ELSE '''' END
	WHERE
		IsReforecast = 0 AND
		(
			OriginalBudgetProcessedIntoWarehouse IS NULL OR
			DateBudgetProcessedIntoWarehouse IS NULL OR
			ImportBatchId IS NULL OR
			BudgetSourceSystemSyncd IS NULL
		)

	UPDATE
		dbo.BudgetsToProcess
	SET
		ReforecastActualsProcessedIntoWarehouse = ISNULL(ReforecastActualsProcessedIntoWarehouse, -1),
		ReforecastBudgetsProcessedIntoWarehouse = ISNULL(ReforecastBudgetsProcessedIntoWarehouse, -1),
		DateBudgetProcessedIntoWarehouse = ISNULL(DateBudgetProcessedIntoWarehouse, GETDATE()),
		ImportBatchId = ISNULL(ImportBatchId, -1),
		BudgetSourceSystemSyncd = ISNULL(BudgetSourceSystemSyncd, 0),
		ReasonForFailure = ISNULL(ReasonForFailure, '''') + ''Validity check in stp_I_BudgetsToProcess failed|'' + -- NULL + string returns NULL, which is not what we want
						   CASE WHEN ReforecastActualsProcessedIntoWarehouse IS NULL THEN ''ReforecastActualsProcessedIntoWarehouse IS NULL|'' ELSE '''' END +
						   CASE WHEN ReforecastBudgetsProcessedIntoWarehouse IS NULL THEN ''ReforecastBudgetsProcessedIntoWarehouse IS NULL|'' ELSE '''' END +
						   CASE WHEN DateBudgetProcessedIntoWarehouse IS NULL THEN ''DateBudgetProcessedIntoWarehouse IS NULL|'' ELSE '''' END +
						   CASE WHEN ImportBatchId IS NULL THEN ''ImportBatchId IS NULL|'' ELSE '''' END +
						   CASE WHEN BudgetSourceSystemSyncd IS NULL THEN ''BudgetSourceSystemSyncd IS NULL|'' ELSE '''' END
	WHERE
		IsReforecast = 1 AND
		(
			ReforecastBudgetsProcessedIntoWarehouse IS NULL OR
			ReforecastActualsProcessedIntoWarehouse IS NULL OR
			DateBudgetProcessedIntoWarehouse IS NULL OR
			ImportBatchId IS NULL OR
			BudgetSourceSystemSyncd IS NULL
		)
	
	PRINT (''"ReforecastActualsProcessedIntoWarehouse" and "ReforecastBudgetsProcessedIntoWarehouse" updated to -1 and "DateBudgetProcessedIntoWarehouse" updated to GETDATE() where either is currently NULL.'')

END

/* =============================================================================================================================================
	Declare variables and create common tables
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Find all possible Budget-to-Snapshot mappings that are possible for both GBS and TAPAS
	*/

	CREATE TABLE #BudgetSnapshotMapping
	(
		BudgetSnapshotMappingId INT IDENTITY(1,1) NOT NULL,
		[Year] INT NOT NULL,
		Period INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(32) NOT NULL,
		BudgetId INT NOT NULL,
		Name VARCHAR (100) NOT NULL,
		IsReforecast BIT NOT NULL,
		LastLockedDate DATETIME NULL,
		LastImportBudgetIntoGRDate DATETIME NULL,
		ImportBudgetIntoGR BIT NOT NULL,
		BudgetReportGroupId INT NULL,
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		BudgetAllocationSetId INT NOT NULL,
		SnapshotId INT NOT NULL,
		SnapshotIsLocked BIT NOT NULL,
		SnapshotLastSyncDate DATETIME NULL,
		SnapshotManualUpdatedDate DATETIME NULL
	)
	INSERT INTO #BudgetSnapshotMapping
	(
		[Year],
		Period,
		BudgetReforecastTypeName,
		BudgetId,
		Name,
		IsReforecast,
		LastLockedDate,
		LastImportBudgetIntoGRDate,
		ImportBudgetIntoGR,
		BudgetReportGroupId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		BudgetAllocationSetId,
		SnapshotId,
		SnapshotIsLocked,
		SnapshotLastSyncDate,
		SnapshotManualUpdatedDate
	)
	SELECT
		BRGP.[Year],
		BRGP.Period,
		TAPASGBSBudgets.BudgetReforecastTypeName,
		TAPASGBSBudgets.BudgetId,
		TAPASGBSBudgets.Name,
		TAPASGBSBudgets.IsReforecast,
		TAPASGBSBudgets.LastLockedDate,
		TAPASGBSBudgets.LastImportBudgetIntoGRDate,
		TAPASGBSBudgets.ImportBudgetIntoGR,
		TAPASGBSBudgets.BudgetReportGroupId,
		TAPASGBSBudgets.BudgetExchangeRateId,
		TAPASGBSBudgets.BudgetReportGroupPeriodId,
		TAPASGBSBudgets.BudgetAllocationSetId,
		S.SnapshotId,
		S.IsLocked,
		S.LastSyncDate,
		S.ManualUpdatedDate
	FROM
		SERVER3.GDM.dbo.BudgetReportGroupPeriod BRGP
		
		INNER JOIN
		(
			SELECT DISTINCT
				''TGB Budget/Reforecast'' AS BudgetReforecastTypeName,
				BudgetTAPAS.BudgetId,
				BudgetTAPAS.Name,
				BudgetTAPAS.IsReforecast,
				BudgetTAPAS.LastLockedDate,
				BudgetTAPAS.LastImportBudgetIntoGRDate,
				BudgetTAPAS.ImportBudgetIntoGR,
				BudgetTAPAS.BudgetAllocationSetId,
				BRG.BudgetReportGroupId,
				BRG.BudgetReportGroupPeriodId,
				BRG.BudgetExchangeRateId
			FROM
				SERVER3.TAPASUS_Budgeting.Budget.Budget BudgetTAPAS

				INNER JOIN SERVER3.TAPASUS_Budgeting.[Admin].BudgetReportGroupDetail BRGD ON
					BudgetTAPAS.BudgetId = BRGD.BudgetId

				INNER JOIN SERVER3.TAPASUS_Budgeting.[Admin].BudgetReportGroup BRG ON
					BRGD.BudgetReportGroupId = BRG.BudgetReportGroupId

				INNER JOIN SERVER3.GDM.dbo.BudgetReportGroupPeriod BRGP ON
					BRG.BudgetReportGroupPeriodId = BRGP.BudgetReportGroupPeriodId
			WHERE
				BudgetTAPAS.IsDeleted = 0 AND
				BRGD.IsDeleted = 0 AND
				BRG.IsDeleted = 0 AND
				BRGP.IsDeleted = 0 AND
				BRGP.[Year] > 2010
		
			UNION ALL

			SELECT
				''GBS Budget/Reforecast'' AS BudgetReforecastTypeName,
				BudgetGBS.BudgetId,
				BudgetGBS.Name,
				BudgetGBS.IsReforecast,
				BudgetGBS.LastLockedDate,
				BudgetGBS.LastImportBudgetIntoGRDate,
				BudgetGBS.CanImportBudgetIntoGR,
				BudgetGBS.BudgetAllocationSetId,
				NULL AS BudgetReportGroupId,
				BudgetGBS.BudgetReportGroupPeriodId,
				BudgetGBS.BudgetExchangeRateId
			FROM
				SERVER3.GBS.dbo.Budget BudgetGBS
			WHERE
				BudgetGBS.IsActive = 1
		
		) TAPASGBSBudgets ON
			BRGP.BudgetReportGroupPeriodId = TAPASGBSBudgets.BudgetReportGroupPeriodId
			
		INNER JOIN SERVER3.GDM.dbo.[Snapshot] S ON
			TAPASGBSBudgets.BudgetAllocationSetId = S.GroupKey	
	WHERE
		BRGP.[Year] > 2010 AND
		BRGP.IsDeleted = 0 AND
		S.GroupName = ''BudgetAllocationSet''

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Find all budgets and reforecasts for 2011 that have already been processed into the warehouse
	*/

	CREATE TABLE #ExistingBudgetsReforecasts
	(
		BudgetId INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(32) NOT NULL,
		IsReforecast BIT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ExistingBudgetsReforecasts
	SELECT DISTINCT -- this DISTINCT shouldn''t be necessary, but there''s a ''bug'' that needs looking into (ReferenceCodes LIKE ''TGB:GBSBudgetId=3&BudgetProfitabilityActualId=...'')
		ExistingBudgetsReforecasts.BudgetId,
		BRT.BudgetReforecastTypeName,
		ExistingBudgetsReforecasts.IsReforecast,
		ExistingBudgetsReforecasts.SnapshotId
	FROM
	(
		-- Get Original Budgets in the warehouse (after 2010)
		SELECT DISTINCT
			PB.BudgetId,
			PB.BudgetReforecastTypeKey,
			0 AS IsReforecast,
			PB.SnapshotId
		FROM
			GrReporting.dbo.ProfitabilityBudget PB
			INNER JOIN GrReporting.dbo.Calendar C ON
				PB.CalendarKey = C.CalendarKey
		WHERE
			C.CalendarYear > 2010
			
		UNION ALL

		-- Get Reforecasts in the warehouse (after 2010)
		SELECT DISTINCT
			PR.BudgetId,
			PR.BudgetReforecastTypeKey,
			1 AS IsReforecast,
			PR.SnapshotId
		FROM
			GrReporting.dbo.ProfitabilityReforecast PR
			INNER JOIN GrReporting.dbo.Calendar C ON
				PR.CalendarKey = C.CalendarKey
		WHERE
			C.CalendarYear > 2010

	) ExistingBudgetsReforecasts
		INNER JOIN GrReporting.dbo.BudgetReforecastType BRT ON
			ExistingBudgetsReforecasts.BudgetReforecastTypeKey = BRT.BudgetReforecastTypeKey

END

/* =============================================================================================================================================
	Check that, for all the budgets (both original and reforecast) that have been processed into the warehouse, the LastImportBudgetIntoGRDate
		field for these budgets in GBS.dbo.Budget and TAPASUS_Budgeting.Budget.Budget is not NULL (which implies that, according to
		GBS/TAPASUS_Budgeting the budget has never been processed into the warehouse before) - this is a problem as the logic that follows in
		this stored procedure assumes that this is not the case.
	=========================================================================================================================================== */
BEGIN

	SELECT
		EBR.BudgetReforecastTypeName,
		EBR.BudgetId,
		EBR.IsReforecast,
		EBR.SnapshotId
	INTO
		#ProcessedBudgetsNotReflectingAsProcessedInSource
	FROM
		#ExistingBudgetsReforecasts EBR

		INNER JOIN #BudgetSnapshotMapping BSM ON
			EBR.BudgetReforecastTypeName = BSM.BudgetReforecastTypeName AND
			EBR.BudgetId = BSM.BudgetId
	WHERE
		BSM.LastImportBudgetIntoGRDate IS NULL

	IF EXISTS (SELECT TOP 1 * FROM #ProcessedBudgetsNotReflectingAsProcessedInSource)
	BEGIN

		SELECT
			*
		FROM
			#ProcessedBudgetsNotReflectingAsProcessedInSource
		ORDER BY
			BudgetReforecastTypeName,
			BudgetId,
			IsReforecast

		RAISERROR (''Budget(s) that have been processed into the warehouse are not reflected as such in the budget source tables (LastImportBudgetIntoGRDate IS NULL). Aborting ...'', 16, -1)
		RETURN -- just to make sure we don''t continue execution at this point
	
	END

END

/* =============================================================================================================================================
	A: Find all budgets that are to be processed into the warehouse because they have been flagged to be imported:
		1. An unlocked budget''s ImportBudgetIntoGR field is set to 1 (In either the GBS.dbo.Budget or TAPASUS_Budgeting.dbo.Budget tables)
		2. A locked budget''s LastLockedDate in the GBS/TAPAS Budget table is greater than the budget''s LastLockedDate in
			GrReportingStaging.GBS/TAPAS.Budget (or if the budget has been locked for the first time)
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The ImportBudgetFromSourceSystem and ImportSnapshotFromSourceSystem fields are of data type INT and not BIT because aggregate functions
			are to be applied to them.
	*/

	CREATE TABLE #BudgetsToProcess
	(
		BudgetReforecastTypeName VARCHAR(32) NOT NULL, -- ''GBS Budget/Reforecast'' or ''TGB Budget/Reforecast''
		BudgetId INT NOT NULL,						   -- either the GBS or TAPAS budget id	
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		BudgetAllocationSetId INT NOT NULL,
		ImportBudgetFromSourceSystem INT NOT NULL,		/*
															True if the budget is required to be imported/reimported from GBS AND reprocessed
																into the warehouse because of changes to the budget. If False, then the budget
																only requires reprocessing into the warehouse, and not reimporting from the
																source system as well.
														*/
		IsReforecast BIT NOT NULL,				       -- will be set to 1 when reforecasts are processed
		SnapshotId INT NULL,
		ImportSnapshotFromSourceSystem INT NOT NULL,
		MustImportAllActualsIntoWarehouse INT NULL,    -- Initially set to null because we will determine whether actuals need to be imported later
		ReasonForProcessing VARCHAR(1024) NOT NULL
	)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		These include:
			1. All locked _budgets_ that have been processed into the warehouse whose LastLockedDates have changed since they were last imported
			2. All locked _budgets_ that have never been processed into the warehouse before
			3. All unlocked _budgets_ whose ImportBudgetIntoGR fields are set to 1
	*/

	INSERT INTO #BudgetsToProcess
	SELECT
		BSM.BudgetReforecastTypeName,			  -- SourceSystemId
		BSM.BudgetId,							  -- BudgetId
		BSM.BudgetExchangeRateId,				  -- BudgetExchangeRateId
		BSM.BudgetReportGroupPeriodId,			  -- BudgetReportGroupPeriodId
		BSM.BudgetAllocationSetId,				  -- BudgetAllocationSet
		1 AS ImportBudgetFromSourceSystem,		  -- ImportBudgetFromSourceSystem: the budget needs to be reimported from GBS because the budget has changed since it was last imported
		BSM.IsReforecast,						  -- IsReforecast: budget is not a reforecast
		BSM.SnapshotId,							  -- SnapshotId
		-----
		CASE
			WHEN
				@GBSBudgetIdsToForcefullyProcess IS NOT NULL OR @TAPASBudgetIdsToForcefullyProcess IS NOT NULL
			THEN
				@ForceSnapshotsToBeReimported -- if we''re forcing budgets to be (re)processed, use the value of @ForceSnapshotsToBeReimported
			ELSE
				0	-- ImportSnapshotFromSourceSystem: don''t know whether the snapshot has changed and needs repimporting - assume it doesn''t
		END AS ImportSnapshotFromSourceSystem,	  
		-----
		CASE
			WHEN
				BSM.IsReforecast = 1			  -- If the budget is a reforecast ...
			THEN
				CASE	 -- If we are forcefully processing a reforecast and the reforecast actuals need to be (re)processed
					WHEN (@GBSBudgetIdsToForcefullyProcess IS NOT NULL OR @TAPASBudgetIdsToForcefullyProcess IS NOT NULL) AND
						 @ForceReforecastActualsToBeProcessed = 1
					THEN
						1
					ELSE -- Else we aren''t forcefully processing reforecasts, or we are but we don''t want to force the reforecast actuals to be (re)processed			
						CASE -- ... so follow business rules as normal:
							WHEN
								BSM.LastLockedDate IS NULL			  -- If the budget is not locked ...
							THEN
								1									  --  ... keep reimporting all of its actuals
							ELSE
								0									  -- if the budget is locked, assume that all of its actuals have already been imported
						END
				END
			ELSE								   -- Else the budget must be an original budget, so use NULL because of the check constraint
				NULL
		END	AS MustImportAllActualsIntoWarehouse,  -- MustImportAllActualsIntoWarehouse: don''t know whether all actuals need importing, assume they don''t (i.e.: only import fee actuals)	
		-----
		CASE
			WHEN -- -- If we aren''t forcefully processing a budget/reforecast
				@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL
			THEN
				CASE
					WHEN -- If the budget/reforecast is locked
						BSM.LastLockedDate IS NOT NULL
					THEN
						CASE
							WHEN -- If the budget has never been processed into the warehouse before
								BSM.LastImportBudgetIntoGRDate IS NULL
							THEN
								''Budget is locked but has never been processed (LastImportBudgetIntoGRDate IS NULL)''
							ELSE -- If the budget/reforecast has been processed into the warehouse before
								CASE
									WHEN -- And the budget has been locked again after it was processed into the warehouse
										BSM.LastLockedDate > BSM.LastImportBudgetIntoGRDate
									THEN
										''Budget has been relocked (LastLockedDate = '' + CONVERT(VARCHAR, BSM.LastLockedDate) + '') since it was last processed (LastImportBudgetIntoGRDate = '' + CONVERT(VARCHAR, BSM.LastImportBudgetIntoGRDate) + '')''
								END
						END
					WHEN -- If the budget/reforecast is unlocked but has been flagged to be processed into the warehouse
						BSM.LastLockedDate IS NULL AND
						BSM.ImportBudgetIntoGR = 1					
					THEN
						''Budget is unlocked and has been flagged for processing (ImportBudgetIntoGR = 1)''
					ELSE
						''Not sure - something strange has happened''
				END
			ELSE -- We''re forcefully processing a budget/reforecast
				''Budget has been set to be forcefully processed''		
		END AS ReasonForProcessing
	FROM
		#BudgetSnapshotMapping BSM
		
		LEFT OUTER JOIN
		(	/*
				This join caters for the case when either GBS and/or TAPAS budgets are being forcefully (re)processed.
				Look in the WHERE clause below for details of how this table is used if this is the case.	
			*/		
			SELECT
				''GBS Budget/Reforecast'' AS BudgetReforecastTypeName,
				BudgetId
			FROM
				#GBSBudgetIdsToForcefullyProcess
			
			UNION ALL
			
			SELECT
				''TGB Budget/Reforecast'' AS BudgetReforecastTypeName,
				BudgetId
			FROM
				#TAPASBudgetIdsToForcefullyProcess

		) BudgetsToForcefullyProcess ON
			BSM.BudgetReforecastTypeName = BudgetsToForcefullyProcess.BudgetReforecastTypeName AND
			BSM.BudgetId = BudgetsToForcefullyProcess.BudgetId
	WHERE
		(	
			--	If neither GBS nor TAPAS budgets have been marked to be forecefully reprocessed AND ...
			(@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL) AND
			(	/*
					The budget has been relocked since it was originally processed into the warehouse, or it is locked but has never been
						imported (point 2. above) - (i.e.: LastLockedDate IS NOT NULL AND LastImportBudgetIntoGR IS NULL)
				*/	
				(
					BSM.LastLockedDate IS NOT NULL AND
					BSM.LastLockedDate > ISNULL(BSM.LastImportBudgetIntoGRDate, ''1900-01-01'')
				)
				OR
				(
					BSM.LastLockedDate IS NULL AND
					BSM.ImportBudgetIntoGR = 1				
				)
			)
		)
		OR
		(
			--	Either GBS or TAPAS budgets (or both) are to be forefully (re)processed ...
			(@GBSBudgetIdsToForcefullyProcess IS NOT NULL OR @TAPASBudgetIdsToForcefullyProcess IS NOT NULL) AND
			(
				-- Only consider those budgets in #BudgetSnapshotMapping that could join onto the budgets that are to be forecefully (re)processed
				BudgetsToForcefullyProcess.BudgetId IS NOT NULL
			)
		)

END

/* =============================================================================================================================================
	B: Find all budgets in the warehouse that are associated with snapshots that have been resync''d (if the snapshot is unlocked) or manually
	   changed (if the snapshot is locked) since these budgets were last imported.
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		But first ...
			For all snapshots that are linked to budgets that are to be processed into the warehosue, set these snapshots to be imported
				(set ImportSnapshotFromSourceSystem = 1) where the snapshot has never been used before to processed a budget into either
				dbo.ProfitabilityBudget or dbo.ProfitabilityReforecast
	*/

	UPDATE
		BTP
	SET
		BTP.ImportSnapshotFromSourceSystem = 1
	FROM
		#BudgetsToProcess BTP
		
		LEFT OUTER JOIN #ExistingBudgetsReforecasts ExistingBudgetsReforecasts ON
			BTP.SnapshotId = ExistingBudgetsReforecasts.SnapshotId
	WHERE
		ExistingBudgetsReforecasts.BudgetId IS NULL

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		If an unlocked snapshot has changed it is only reimported if it is used by a budget that is to be imported.
		Determine which snapshots (that are used by budgets in the warehouse) require reimporting and which budgets (that have previously been
			processed into the warehouse) require reprocessing as a result.

		Note: Locked snapshots should not be resyncd. If a locked snapshot is resyncd that is associated with a budget that has already been
			processed into the warehouse, we will not automatically reprocess the budget (as this is a special case that theoretically should not
			happen - if it does, we will have to manually cater for this)
	*/

	/*
		If we aren''t trying to inject budgets for either TAPAS or GBS that need to be forcefully (re)processed.
		The check below is necessary as the code beneath might include additional budgets that aren''t specified in the
			@GBSBudgetIdsToForcefullyProcess and @TAPASBudgetIdsToForcefullyProcess parameters.
	*/
	IF (@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL)
	BEGIN

		INSERT INTO #BudgetsToProcess
		SELECT DISTINCT
			BSM.BudgetReforecastTypeName,		   -- SourceSystemId
			BSM.BudgetId,						   -- BudgetId: The Budgets that are linked to the snapshots that have changed [from 2]. 
			BSM.BudgetExchangeRateId,			   -- BudgetExchangeRateId,
			BSM.BudgetReportGroupPeriodId,		   -- BudgetReportGroupPeriodId
			BSM.BudgetAllocationSetId,			   -- BudgetAllocationSetId	
			0 AS ImportBudgetFromSourceSystem,	   -- ImportBudgetFromSourceSystem: Assume that the budget doesn''t require importing. If it does it should have been identified in [A] above
			BSM.IsReforecast,					   -- IsReforecast
			BSM.SnapshotId,						   -- SnapshotId
			1 AS ImportSnapshotFromSourceSystem,   -- ImportSnapshotFromSourceSystem: we know from the joins below that these snapshots have been modified and need to be reimported
			-----
			CASE
				WHEN
					BSM.IsReforecast = 0
				THEN
					NULL							 -- NULL because of the check constraint on the dbo.BudgetsToProcess
				ELSE
					0
			END AS MustImportAllActualsIntoWarehouse,-- MustImportAllActualsIntoWarehouse: changes in snapshot should not have any affect on the budget
													 -- If a budget is locked, its snapshot has to be locked
			-----
			CASE
				WHEN
					@GBSBudgetIdsToForcefullyProcess IS NULL AND @TAPASBudgetIdsToForcefullyProcess IS NULL
				THEN
					CASE
						WHEN
							BSM.SnapshotIsLocked = 0 AND
							ISNULL(BSM.SnapshotLastSyncDate, ''1900-01-01'') > ISNULL(SnapshotStaging.LastSyncDate, ''1900-01-01'')
						THEN
							''Unlocked snapshot (LastSyncDate = '' + CONVERT(VARCHAR, ISNULL(BSM.SnapshotLastSyncDate, ''1900-01-01'')) + '') associated with an unlocked budget in the warehouse has been resynced (LastSyncDate in GrReportingStaging = '' + CONVERT(VARCHAR, ISNULL(SnapshotStaging.LastSyncDate, ''1900-01-01'')) + '')''
						WHEN
							BSM.SnapshotIsLocked <> SnapshotStaging.IsLocked
						THEN
							''Unlocked snapshot associated with an unlocked budget in the warehouse has been locked in GDM''
						ELSE
							''Not sure - something strange has happened''
					END	
			END AS ReasonForProcessing
		FROM
			#ExistingBudgetsReforecasts ExistingBudgetsReforecasts
			
			INNER JOIN #BudgetSnapshotMapping BSM ON
				ExistingBudgetsReforecasts.BudgetId = BSM.BudgetId AND
				ExistingBudgetsReforecasts.BudgetReforecastTypeName = BSM.BudgetReforecastTypeName AND
				ExistingBudgetsReforecasts.IsReforecast = BSM.IsReforecast
				
			INNER JOIN GrReportingStaging.GDM.[Snapshot] SnapshotStaging ON
				BSM.SnapshotId = SnapshotStaging.SnapshotId
		WHERE
			/*
				If the snapshot is unlocked and GDM_Support.dbo.Snapshot.LastSyncDate > GrReportingStaging.GDM.Snapshot.LastSyncDate (i.e.: has
					changed), AND the snapshot is being used by a budget that is to be imported, the snapshot must be reimported and the budgets in
					the warehouse that use it must be reprocessed.
				This is because a budget must not be reprocessed purely because the unlocked snapshot that it uses has changed. Only if the
					snapshot is being used by a budget that is set to be imported must the budgets in the warehouse that use this snapshot be
					reprocessed.
			*/
			(
				BSM.SnapshotIsLocked = 0 AND
				ISNULL(BSM.SnapshotLastSyncDate, ''1900-01-01'') > ISNULL(SnapshotStaging.LastSyncDate, ''1900-01-01'')
			)
			-- If the snapshot is unlocked in Staging but has since been locked in GDM_Support.dbo.Snapshot 
			OR	
			(
				BSM.SnapshotIsLocked <> SnapshotStaging.IsLocked
			)

	END

END

/* =============================================================================================================================================
	C: For reforecasts, determine whether reforecast actuals require processing into the warehouse
   =========================================================================================================================================== */
BEGIN

	UPDATE
		BTP
	SET
		BTP.MustImportAllActualsIntoWarehouse = 1
	FROM
		#BudgetsToProcess BTP
		
		LEFT OUTER JOIN
		(	/*
				Find all reforecasts that have previously been processed whose actuals were marked for import
					(MustImportAllActualsIntoWarehouse = 1), and were subsequently processed successfully into the warehouse
					(ReforecastActualsProcessedIntoWarehouse = 1).
				We don''t want to import these budgets'' actuals again (hence the LEFT OUTER JOIN and WHERE clause below)
			*/
			SELECT
				BudgetReforecastTypeName,
				BudgetId
			FROM
				GrReportingStaging.dbo.BudgetsToProcess			
			WHERE
				IsReforecast = 1 AND -- Only consider reforecasts because original budgets do not have ''Actual'' components
				(
					MustImportAllActualsIntoWarehouse = 1 AND
					ReforecastActualsProcessedIntoWarehouse = 1
				)

		) ReforecastActualsPreviouslyProcessed ON
			BTP.BudgetReforecastTypeName = ReforecastActualsPreviouslyProcessed.BudgetReforecastTypeName AND
			BTP.BudgetId = ReforecastActualsPreviouslyProcessed.BudgetId
	WHERE
		ReforecastActualsPreviouslyProcessed.BudgetId IS NULL AND
		BTP.IsReforecast = 1

END

/* =============================================================================================================================================
	D: Determine whether budget and snapshot data require importing from the source system
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #BudgetsToProcessPreInsert
	(
		BudgetReforecastTypeName VARCHAR(32) NOT NULL, -- ''GBS Budget/Reforecast'' or ''Tapas Budgeting''
		BudgetId INT NOT NULL,						   -- Either the GBS or TAPAS budget id	
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		BudgetAllocationSetId INT NOT NULL,
		ImportBudgetFromSourceSystem INT NOT NULL,	   -- True if the budget is required to be imported/reimported from GBS because of changes to the budget
		IsReforecast BIT NOT NULL,					   -- Will be set to 1 when reforecasts are processed
		SnapshotId INT NULL,
		ImportSnapshotFromSourceSystem INT NOT NULL,
		MustImportAllActualsIntoWarehouse INT NULL,   -- Initially set to 0 because we will determine whether actuals need to be imported in D
		ReasonForProcessing VARCHAR(1024)
	)

	INSERT INTO #BudgetsToProcessPreInsert
	SELECT
		BTP.BudgetReforecastTypeName,
		BTP.BudgetId,
		BTP.BudgetExchangeRateId,
		BTP.BudgetReportGroupPeriodId,
		BTP.BudgetAllocationSetId,
		BTPBudgets.ImportBudgetFromSourceSystem,
		BTP.IsReforecast,
		BTP.SnapshotId,
		BTPSnapshot.ImportSnapshotFromSourceSystem,
		BTPBudgets.MustImportAllActualsIntoWarehouse,
		ReasonForProcessingConcatenated.ReasonForProcessing
	FROM
		#BudgetsToProcess BTP
		
		INNER JOIN
		(
			SELECT
				SnapshotId,
				CAST(MAX(ImportSnapshotFromSourceSystem) AS BIT) AS ImportSnapshotFromSourceSystem
			FROM
				#BudgetsToProcess
			GROUP BY
				SnapshotId

		) BTPSnapshot ON
			BTP.SnapshotId = BTPSnapshot.SnapshotId

		INNER JOIN
		(
			SELECT
				BudgetReforecastTypeName,
				BudgetReportGroupPeriodId,	
				CAST(MAX(MustImportAllActualsIntoWarehouse) AS BIT) AS MustImportAllActualsIntoWarehouse,
				CAST(MAX(ImportBudgetFromSourceSystem) AS BIT) AS ImportBudgetFromSourceSystem
			FROM
				#BudgetsToProcess
			GROUP BY
				BudgetReforecastTypeName,
				BudgetReportGroupPeriodId

		) BTPBudgets ON
			BTP.BudgetReforecastTypeName = BTPBudgets.BudgetReforecastTypeName AND
			BTP.BudgetReportGroupPeriodId = BTPBudgets.BudgetReportGroupPeriodId

		INNER JOIN
		(
			SELECT DISTINCT
				BudgetReforecastTypeName,
				BudgetId,
				(	/*
						The code below concatenates ReasonForProcessing where there is more than one ReasonForProcessing value per BudgetId and
							BudgetReforecastTypeName combination.

						For instance:
						
							BudgetReforecastTypeName	BudgetId	ReasonForProcessing
							''GBS Budget/Reforecast''		1			Reason 1
							''GBS Budget/Reforecast''		1			Reason 2
							
							BECOMES
							
							BudgetReforecastTypeName	BudgetId	ReasonForProcessing
							''GBS Budget/Reforecast''		1			Reason 1|Reason 2						
					*/				
					STUFF
					(
						(
							SELECT
								''|'' + ReasonForProcessing
							FROM
								#BudgetsToProcess BTP2
							WHERE
								BTP1.BudgetReforecastTypeName = BTP2.BudgetReforecastTypeName AND
								BTP1.BudgetId = BTP2.BudgetId
							ORDER BY
								ReasonForProcessing
							FOR XML PATH (''''), TYPE, ROOT

						).value(''root[1]'', ''NVARCHAR(MAX)''), 1, 1, ''''
					)
				) AS ReasonForProcessing
			FROM
				#BudgetsToProcess BTP1

		) ReasonForProcessingConcatenated ON
			BTP.BudgetReforecastTypeName = ReasonForProcessingConcatenated.BudgetReforecastTypeName AND
			BTP.BudgetId = ReasonForProcessingConcatenated.BudgetId

END

/* =============================================================================================================================================
	E: Insert data into GrReportingStaging.dbo.BudgetsToProcess
   =========================================================================================================================================== */
BEGIN

	DECLARE @NextBatchId INT = (ISNULL((SELECT MAX(BatchId) FROM dbo.BudgetsToProcess), 0) + 1)

	SELECT DISTINCT
		@NextBatchId AS BatchId,
		-------
		CASE
			WHEN
				/*
					If the budget is to be imported from the source system, the ImportBatchId for that import will be determine after the budget
						data has been imported by the SSIS package(s) (the final step of the GBS and TAPAS master packages updates the
						ImportBatchId field in dbo.BudgetsToProcess - the step before this finalizes the entry into dbo.Batch)
				*/
				BTP.ImportBudgetFromSourceSystem = 1
			THEN
				NULL
			ELSE
				/*
					If the budget does not need importing from the budget source system, then this implies that a budget batch that already
						exists in either GrReportingStaging.GBS... or GrReportingStaging.TapasGlobalBudgeting... will be used and reprocessed
						into the warehouse. The last budget set to be imported into GrReportingStaging will be used for reprocessing into the
						warehouse, as this is the last budget set to be processed (into the warehouse).
				*/			
				CASE
					WHEN
						BTP.BudgetReforecastTypeName = ''GBS Budget/Reforecast''
					THEN
						(SELECT MAX(ImportBatchId) FROM GrReportingStaging.GBS.Budget WHERE BudgetId = BTP.BudgetId)
					ELSE -- BTP.BudgetReforecastTypeName must be ''TGB Budget/Reforecast''
						(SELECT MAX(ImportBatchId) FROM GrReportingStaging.TapasGlobalBudgeting.Budget WHERE BudgetId = BTP.BudgetId)
				END
		END AS ImportBatchId,
		-------
		BTP.BudgetReforecastTypeName,
		BTP.BudgetId,
		BTP.BudgetExchangeRateId,
		BTP.BudgetReportGroupPeriodId,
		BTP.ImportBudgetFromSourceSystem,
		BTP.IsReforecast,
		BTP.SnapshotId,
		BTP.ImportSnapshotFromSourceSystem,
		BTP.MustImportAllActualsIntoWarehouse,
		BASYQM.BudgetYear,
		BASYQM.BudgetQuarter,
		BTP.ReasonForProcessing
	INTO
		#BudgetsToProcessToInsert
	FROM
		#BudgetsToProcessPreInsert BTP

		LEFT OUTER JOIN dbo.BudgetAllocationSetYearQuarterMapping BASYQM ON
			BTP.BudgetAllocationSetId = BASYQM.BudgetAllocationSetId

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		If this is a test execution, display the results with a SELECT.
		If this is not a test execution, insert the results into the GrReportingStaging.dbo.BudgetsToProcess table
	*/

	IF (@IsTestExecution = 1)
	BEGIN

		SELECT
			BatchId,
			ImportBatchId,
			BudgetReforecastTypeName,
			BudgetId,
			BudgetExchangeRateId,
			BudgetReportGroupPeriodId,
			ImportBudgetFromSourceSystem,
			IsReforecast,
			SnapshotId,
			ImportSnapshotFromSourceSystem,
			MustImportAllActualsIntoWarehouse,
			BudgetYear,
			BudgetQuarter,
			1 AS IsCurrentBatch,
			ReasonForProcessing
		FROM
			#BudgetsToProcessToInsert

	END
	ELSE
	BEGIN

		INSERT INTO dbo.BudgetsToProcess (
			BatchId,
			ImportBatchId,
			BudgetReforecastTypeName,
			BudgetId,
			BudgetExchangeRateId,
			BudgetReportGroupPeriodId,
			ImportBudgetFromSourceSystem,
			IsReforecast,
			SnapshotId,
			ImportSnapshotFromSourceSystem,
			MustImportAllActualsIntoWarehouse,
			BudgetYear,
			BudgetQuarter,
			IsCurrentBatch,
			ReasonForProcessing
		)
		SELECT
			BatchId,
			ImportBatchId,
			BudgetReforecastTypeName,
			BudgetId,
			BudgetExchangeRateId,
			BudgetReportGroupPeriodId,
			ImportBudgetFromSourceSystem,
			IsReforecast,
			SnapshotId,
			ImportSnapshotFromSourceSystem,
			MustImportAllActualsIntoWarehouse,
			BudgetYear,
			BudgetQuarter,
			1, -- set all records that are inserted as being part of the current batch.
			ReasonForProcessing
		FROM
			#BudgetsToProcessToInsert

	END

END

/* =============================================================================================================================================
	Clean up
   ========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID(''tempdb..#BudgetSnapshotMapping'') IS NOT NULL
		DROP TABLE #BudgetSnapshotMapping
		
	IF 	OBJECT_ID(''tempdb..#BudgetsToProcessPreInsert'') IS NOT NULL
		DROP TABLE #BudgetsToProcessPreInsert

	IF 	OBJECT_ID(''tempdb..#ExistingBudgetsReforecasts'') IS NOT NULL	
		DROP TABLE #ExistingBudgetsReforecasts

	IF 	OBJECT_ID(''tempdb..#ProcessedBudgetsNotReflectingAsProcessedInSource'') IS NOT NULL	
		DROP TABLE #ProcessedBudgetsNotReflectingAsProcessedInSource

END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_I_ImportBatch]
	@PackageName		VARCHAR(100)
AS
	DECLARE @ImportStartDate DateTime
	DECLARE @ImportEndDate DateTime
	DECLARE @DataPriorToDate DateTime
	
	
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualImportStartDate'')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualImportEndDate'')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate'')

	
	
	INSERT INTO Batch
	(
		PackageName,
		BatchStartDate,
		ImportStartDate,
		ImportEndDate,
		DataPriorToDate
	)
	VALUES
	(
		@PackageName,	/* PackageName	*/
		GetDate(),
		@ImportStartDate,
		@ImportEndDate,
		@DataPriorToDate
	)
	
	SELECT SCOPE_IDENTITY() AS BatchId

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_D_TapasBudget]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_TapasBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	Deletes Tapas Budget data from the GrReportingStaging database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_D_TapasBudget]
	@BudgetId INT

AS

BEGIN

IF @BudgetId IS NULL
BEGIN
	PRINT ''There is no budget to delete''
	RETURN
END

-- TapasGlobalBudgeting.BenefitOption

DELETE BE
FROM 
	TapasGlobalBudgeting.BenefitOption BE
WHERE
	BE.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail

DELETE BEPAD
FROM 
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail BEPAD
	
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocation BEPA ON
		BEPAD.BudgetEmployeePayrollAllocationId = BEPA.BudgetEmployeePayrollAllocationId AND
		BEPAD.ImportBatchId = BEPA.ImportBatchId
		
	INNER JOIN TapasGlobalBudgeting.BudgetEmployee BE ON
		BEPA.BudgetEmployeeId = BE.BudgetEmployeeId AND
		BEPA.ImportBatchId = BE.ImportBatchId
WHERE
	BE.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetEmployeePayrollAllocation

DELETE BEPA
FROM 
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation BEPA
		
	INNER JOIN TapasGlobalBudgeting.BudgetEmployee BE ON
		BEPA.BudgetEmployeeId = BE.BudgetEmployeeId AND
		BEPA.ImportBatchId = BE.ImportBatchId
WHERE
	BE.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment

DELETE BEFD
FROM	
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment BEFD
	
	INNER JOIN TapasGlobalBudgeting.BudgetEmployee BE ON
		BEFD.BudgetEmployeeId = BE.BudgetEmployeeId AND
		BEFD.ImportBatchId = BE.ImportBatchId
WHERE
	BE.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetEmployee

DELETE FROM TapasGlobalBudgeting.BudgetEmployee
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetOverheadAllocationDetail

DELETE BOAD
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail BOAD
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocation BOA ON
		BOAD.BudgetOverheadAllocationId = BOA.BudgetOverheadAllocationId AND
		BOAD.ImportBatchId = BOA.ImportBatchId
WHERE
	BOA.BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetOverheadAllocation

DELETE FROM TapasGlobalBudgeting.BudgetOverheadAllocation 
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetProject

DELETE FROM TapasGlobalBudgeting.BudgetProject
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetReportGroup
	
DELETE BRG
FROM	
	TapasGlobalBudgeting.BudgetReportGroup BRG	
	
WHERE
	BRG.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.BudgetReportGroupDetail

DELETE TapasGlobalBudgeting.BudgetReportGroupDetail
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.BudgetStatus

DELETE BS
FROM
	TapasGlobalBudgeting.BudgetStatus BS
WHERE
	BS.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.BudgetTaxType 

DELETE TapasGlobalBudgeting.BudgetTaxType 
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.ReforecastActualBilledPayroll

DELETE TapasGlobalBudgeting.ReforecastActualBilledPayroll
WHERE
	BudgetId = @BudgetId

-- TapasGlobalBudgeting.TaxType

DELETE TT
FROM
	TapasGlobalBudgeting.TaxType TT
WHERE
	TT.ImportBatchId NOT IN (SELECT DISTINCT ImportBatchId FROM TapasGlobalBudgeting.Budget WHERE BudgetId <> @BudgetId)

-- TapasGlobalBudgeting.Budget

DELETE FROM TapasGlobalBudgeting.Budget
WHERE
	BudgetId = @BudgetId
	
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_U_SyncBudgetsProcessed]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_SyncBudgetsProcessed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]	

AS

-- Update GBS.dbo.Budget  

UPDATE
	Budget
SET
	Budget.CanImportBudgetIntoGR = 0,
	Budget.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.GBS.dbo.Budget Budget
	INNER JOIN dbo.BudgetsToProcess BTP ON
		Budget.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetReforecastTypeName = ''GBS Budget/Reforecast'' AND
	BTP.IsCurrentBatch = 1 AND
	Budget.IsActive = 1

-- Update GBS.dbo.Budget  

UPDATE
	TAPAS
SET
	TAPAS.ImportBudgetIntoGR = 0,
	TAPAS.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.TAPASUS_Budgeting.Budget.Budget TAPAS
	INNER JOIN dbo.BudgetsToProcess BTP ON
		TAPAS.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetReforecastTypeName = ''TGB Budget/Reforecast'' AND
	BTP.IsCurrentBatch = 1 AND
	TAPAS.IsDeleted = 0

-- Update GrReportingStaging.dbo.BudgetsToProcess

UPDATE
	dbo.BudgetsToProcess
SET
	BudgetSourceSystemSyncd = 1
WHERE
	BudgetSourceSystemSyncd IS NULL AND
	IsCurrentBatch = 1

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_U_ImportBatch]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_ImportBatch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_U_ImportBatch]
	@BatchId INT
AS
	UPDATE 
		Batch
	SET 
	    BatchEndDate = GETDATE()
	WHERE BatchId=@BatchId

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_J_UpdateSSISConfigurationsImportWindow]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
	@JobName varchar(500),
	@SucessfulStepCount int
AS

DECLARE @JobId uniqueidentifier

SELECT
	@JobId = j.job_id
FROM
	msdb.dbo.sysjobhistory h
	
	INNER JOIN msdb.dbo.sysjobs j ON
		h.job_id = j.job_id
WHERE
	j.name 	= @JobName AND
	h.run_status = 4 AND -- In Progress
	h.run_date = CONVERT(varchar, getdate(), 112)
	
IF @JobId IS NOT NULL
BEGIN
	
	DECLARE @SucessfulSteps int
	SELECT
		@SucessfulSteps = COUNT(*)
	FROM
		msdb.dbo.sysjobsteps 
	WHERE 
		job_id = @JobId AND
		last_run_outcome = 1 -- Succeeded
	
	DECLARE @StopDate datetime,
			@NewStartDate datetime,
			@Yesterday datetime
			
	-- Only updates the imports dates if all steps have run sucesfully		
	IF @SucessfulSteps = @SucessfulStepCount
	BEGIN
			
		SELECT
			@StopDate = CONVERT(datetime, [ConfiguredValue])
		FROM
			[GrReportingStaging].[dbo].[SSISConfigurations]
		WHERE
			[ConfigurationFilter] = ''ImportEndDate''
			
		SET @NewStartDate = DATEADD(DAY, 1, @StopDate)
		SET @Yesterday = DATEADD(day, -1, getdate())
		
		-- Sets the ImportStartDate to one day after the last import end date
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT(''00'' + DATENAME(DAY,@NewStartDate),2) + '' '' + -- two digit day value
								LEFT(CONVERT(varchar, @NewStartDate),3) + '' '' + -- Abbreviated month description
								DATENAME(YEAR,@NewStartDate)
		WHERE
			[ConfigurationFilter] = ''ImportStartDate''
			
		
		-- Sets the ImportEndDate and DataPriorToDate to yesterday	
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT(''00'' + DATENAME(DAY,@Yesterday),2) + '' '' + -- two digit day value
								LEFT(CONVERT(varchar, @Yesterday),3) + '' '' + -- Abbreviated month description
								DATENAME(YEAR,@Yesterday)
		WHERE
			[ConfigurationFilter] = ''ImportEndDate'' OR 
			[ConfigurationFilter] = ''DataPriorToDate''
	END
		
		
		
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/***************************************************************************************************************************************
Description
	This stored procedure processes payroll reforecast data and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast). 
	The stored procedure works as follows:
	1.	Source budgets that are to be processed from the BudgetsToProcessTable
	2.	Source Budgets from TapasGlobalBudgeting.Budget table
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
	6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
	7.	Create Global and Local Categorization mapping table
	8.	Map table to the #ProfitabilityReforecast table with the same structure as the GrReporting.dbo.ProfitabilityReforecast table
	9.	Insert Actuals from the Budget Profitability Actual table in GBS
	10.	Insert records with unknowns into the ProfitabilityReforecastUnknowns table.
	11. Insert budget records into the GrReporting.dbo.ProfitabilityReforecast table
	12. Mark budgets as being successfully processed into the warehouse
	13. Clean up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-07		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
****************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@DataPriorToDate DATETIME=NULL
AS

BEGIN

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollReforecast''
PRINT ''####''

SET NOCOUNT ON

DECLARE
	@RowCount INT,
	@StartTime DATETIME

IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate''))
END

	/*
		Check to see if the TAPAS reforecasts are scheduled to be run.
	*/

DECLARE @CanImportTapasReforecast INT = (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportTAPASReforecast'')

IF (@CanImportTapasReforecast <> 1)
BEGIN
	PRINT (''Import of TAPAS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations'')
	RETURN
END
	
/* ================================================================================================================================================
	 1. Get Budgets to Process
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #BudgetsToProcess
	(
		BudgetsToProcessId INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(50) NOT NULL,
		BudgetId INT NOT NULL,
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		ImportBudgetFromSourceSystem BIT NOT NULL,
		IsReforecast BIT NOT NULL,
		SnapshotId INT NOT NULL,
		ImportSnapshotFromSourceSystem BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		MustImportAllActualsIntoWarehouse BIT NULL,
		OriginalBudgetProcessedIntoWarehouse SMALLINT NULL,
		ReforecastActualsProcessedIntoWarehouse SMALLINT NULL,
		ReforecastBudgetsProcessedIntoWarehouse SMALLINT NULL,
		ReasonForFailure VARCHAR(512) NULL,
		DateBudgetProcessedIntoWarehouse DATETIME NULL,
		ReforecastKey INT NOT NULL
	)

	INSERT #BudgetsToProcess
	SELECT 
		BudgetsToProcessId,
		ImportBatchId,
		BudgetReforecastTypeName,
		BudgetId,
		BudgetExchangeRateId,
		BudgetReportGroupPeriodId,
		ImportBudgetFromSourceSystem,
		IsReforecast,
		SnapshotId,
		ImportSnapshotFromSourceSystem,
		InsertedDate,
		MustImportAllActualsIntoWarehouse,
		OriginalBudgetProcessedIntoWarehouse,
		ReforecastActualsProcessedIntoWarehouse,
		ReforecastBudgetsProcessedIntoWarehouse,
		ReasonForFailure,
		DateBudgetProcessedIntoWarehouse,
		RR.ReforecastKey
	FROM
		dbo.BudgetsToProcess BTPC

		INNER JOIN
		(
			SELECT
				MIN(ReforecastEffectiveMonth) AS ReforecastEffectiveMonth,
				ReforecastQuarterName,
				ReforecastEffectiveYear
			FROM
				Grreporting.dbo.Reforecast
			GROUP BY
				ReforecastQuarterName,
				ReforecastEffectiveYear
		) CRR ON
			CRR.ReforecastEffectiveYear = BTPC.BudgetYear AND
			CRR.ReforecastQuarterName = BTPC.BudgetQuarter
		
		INNER JOIN Grreporting.dbo.Reforecast RR ON
			CRR.ReforecastEffectiveMonth = RR.ReforecastEffectiveMonth AND
			CRR.ReforecastQuarterName =  RR.ReforecastQuarterName AND
			CRR.ReforecastEffectiveYear = RR.ReforecastEffectiveYear
	WHERE 
		IsReforecast = 1 AND
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = ''TGB Budget/Reforecast''

	DECLARE @BTPRowCount INT = @@rowcount

	PRINT (''Rows inserted into #BudgetsToProcess: '' + CONVERT(VARCHAR(10),@BTPRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@BTPRowCount = 0)
	BEGIN
		PRINT (''*******************************************************'')
		PRINT (''	stp_IU_LoadGrProfitabiltyPayrollReforecast is quitting because BudgetsToProcess returned no budgets to import.'')
		PRINT (''*******************************************************'')
		RETURN
	END

END
	
/* ===============================================================================================================================================
	Setup Variables 
   ============================================================================================================================================= */
BEGIN

	DECLARE 
		@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN''),
		@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN''),
		@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN''),
		@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN''),
		@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN''),
		@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN''),
		@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN''),
		@OverheadKeyUnknown				INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = ''UNKNOWN''),
		@LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode =  ''UNK'' ),
		@NormalFeeAdjustmentKey			INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''NORMAL''),
		@GLCategorizationHierarchyKeyUnknown	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''UNKNOWN'' AND SnapshotId = 0)

	DECLARE
		@UnknownUSPropertyGLCategorizationKey	 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Property'' AND SnapshotId = 0),
		@UnknownUSFundGLCategorizationKey		 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Fund'' AND SnapshotId = 0),
		@UnknownEUPropertyGLCategorizationKey	 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Property'' AND SnapshotId = 0),
		@UnknownEUFundGLCategorizationKey		 INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Fund'' AND SnapshotId = 0),
		@UnknownUSDevelopmentGLCategorizationKey INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Development'' AND SnapshotId = 0),
		@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''Global'' AND SnapshotId = 0)


	DECLARE @FeeAdjustmentKey		   INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''NORMAL'')
	DECLARE @ReforecastTypeIsTGBBUDKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = ''TGBBUD'')
	DECLARE @ReforecastTypeIsTGBACTKey INT = (SELECT BudgetReforecastTypeKey from GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = ''TGBACT'')
		
	DECLARE @ImportErrorTable TABLE
	(
		Error varchar(50)
	);

END

/* ================================================================================================================================================
	2. Source Budgets
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	-- Get the last GBS budgets that were imported into the warehouse.

	CREATE TABLE #LastImportedGBSBudgets
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL
	)
	INSERT INTO #LastImportedGBSBudgets
	(
		ImportBatchId,
		BudgetId,
		BudgetReportGroupPeriodId
	)
	SELECT 
		B.ImportBatchId,
		B.BudgetId,
		B.BudgetReportGroupPeriodId
	FROM
		GBS.Budget B
		INNER JOIN
		(
			SELECT 
				MAX(ImportBatchId) AS ImportBatchId
			FROM
				GBS.Budget
			WHERE 
				IsReforecast = 1
		) MB ON
			B.ImportBatchId = MB.ImportBatchId

	SET @RowCount = @@ROWCOUNT

	PRINT ''Completed inserting records into #LastImportedGBSBudgets:''+CONVERT(char(10),@RowCount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@RowCount = 0)
	BEGIN
		PRINT ''WARNING: No GBS budgets found, so no actuals will be imported''
	END

	SET @StartTime = GETDATE()

	CREATE TABLE #NewBudgets
	(
		ImportBatchId INT NOT NULL,
		ImportKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		RegionId INT NOT NULL,
		FirstProjectedPeriod INT NULL,
		CurrencyCode VARCHAR(3) NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		GroupEndPeriod INT NOT NULL,
		GBSBudgetId INT NULL, -- CAN BE NULL IN WHICH CASE NO ACTUALS WILL BE IMPORTED
		MustImportAllActualsIntoWarehouse BIT NOT NULL,
		ReforecastKey INT NOT NULL,
		BudgetReportGroupId INT NOT NULL
	)
	INSERT INTO #NewBudgets
	(
		ImportBatchId,
		ImportKey,
		SnapshotId,
		BudgetId,
		RegionId,
		FirstProjectedPeriod,
		CurrencyCode,
		BudgetReportGroupPeriodId,
		BudgetReportGroupPeriod,
		GroupEndPeriod,
		GBSBudgetId,
		MustImportAllActualsIntoWarehouse,
		ReforecastKey,
		BudgetReportGroupId
	)
	SELECT 
		BTP.ImportBatchId,
		Budget.ImportKey,
		BTP.SnapshotId AS SnapshotId,	
		Budget.BudgetId, 
		Budget.RegionId,
		Budget.FirstProjectedPeriod,
		Budget.CurrencyCode,
		brg.BudgetReportGroupPeriodId,
		brgp.Period AS BudgetReportGroupPeriod,
		brg.EndPeriod AS GroupEndPeriod,
		GBSBudget.BudgetId AS GBSBudgetId,
		BTP.MustImportAllActualsIntoWarehouse,
		BTP.ReforecastKey, 
		BRGD.BudgetReportGroupId
	FROM
		TapasGlobalBudgeting.Budget Budget

		INNER JOIN #BudgetsToProcess BTP ON -- All TAPAS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
			Budget.BudgetId = BTP.BudgetId AND
			Budget.ImportBatchId = BTP.ImportBatchId

		INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail BRGD ON
			Budget.BudgetId = BRGD.BudgetId AND
			BTP.ImportBatchId = BRGD.ImportBatchId

		INNER JOIN TapasGlobalBudgeting.BudgetReportGroup BRG ON
			BRGD.BudgetReportGroupId = BRG.BudgetReportGroupId	 AND
			BTP.ImportBatchId = BRG.ImportBatchId

		INNER JOIN Gdm.BudgetReportGroupPeriod BRGP ON
			BRG.BudgetReportGroupPeriodId = BRGP.BudgetReportGroupPeriodId

		INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
			BRGP.ImportKey = BRGPA.ImportKey
		/*
			Actuals are imported from GBS. These actuals have GBS Budget Ids. To determine the corresponding GBS Budget Id of a TAPAS budget,
			the BudgetReportGroupPeriod is used. 
		*/			   
		LEFT OUTER JOIN #LastImportedGBSBudgets LIGB ON
			BRG.BudgetReportGroupPeriodId = LIGB.BudgetReportGroupPeriodId  

		LEFT OUTER JOIN GBS.Budget GBSBudget ON
		   LIGB.BudgetReportGroupPeriodId = GBSBudget.BudgetReportGroupPeriodId AND
		   LIGB.BudgetId = GBSBudget.BudgetId AND
		   LIGB.ImportBatchId = GBSBudget.ImportBatchId
			
	DECLARE @NumberOfBudgets INT = @@rowcount
			
	PRINT ''Completed inserting records into #NewBudgets:''+CONVERT(char(10),@NumberOfBudgets)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@NumberOfBudgets = 0)
	BEGIN
		PRINT ''#NewBudgets: Found NO Budgets to import. Nothing to do. Quitting...''
		RETURN
	END

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetID ON #NewBudgets (SnapshotId, BudgetId)

	PRINT ''Completed creating indexes on #Budget''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	----------------------------------------------------------------------------------------------
	-- Source the GBS Budget
	SET @StartTime = GETDATE()

	-- Source GBS Budgets which will be used for the Actuals
	;WITH CteDistinctTapasBudgets
	AS
	(
	   SELECT 
			B.SnapshotId, 
			B.GBSBudgetId AS BudgetId, 
			B.FirstProjectedPeriod,
			B.MustImportAllActualsIntoWarehouse,
			B.ReforecastKey
		FROM 
			#NewBudgets B
			INNER JOIN 
			(	
				SELECT 
					MIN(BudgetId) AS BudgetId,
					MIN(SnapshotId) AS SnapshotId
				FROM 
					#NewBudgets 
				WHERE
					MustImportAllActualsIntoWarehouse = 1
				GROUP BY
					GBSBudgetId,
					SnapshotId
			) DB ON
				DB.BudgetId = B.BudgetId AND
				DB.SnapshotId = B.SnapshotId
	)
	SELECT
		LIGB.ImportBatchId,
		TB.SnapshotId as SnapshotId,
		TB.BudgetId as TapasBudgetId,
		TB.FirstProjectedPeriod as FirstProjectedPeriod,
		TB.MustImportAllActualsIntoWarehouse,
		TB.ReforecastKey,
		GB.BudgetId AS BudgetId,
		GB.ImportKey
	INTO
		#GBSBudgets
	FROM
		GBS.Budget GB

		INNER JOIN CteDistinctTapasBudgets TB ON
			GB.BudgetId = TB.BudgetId 

		INNER JOIN #LastImportedGBSBudgets LIGB ON
			GB.ImportBatchId = LIGB.ImportBatchId AND
			GB.BudgetReportGroupPeriodId = LIGB.BudgetReportGroupPeriodId AND
			GB.BudgetId = LIGB.BudgetId		

	PRINT ''Completed inserting records into #GBSBudgets:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	BEGIN TRY		
		CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GBSBudgets (SnapshotId, BudgetId, FirstProjectedPeriod)
		PRINT ''Completed creating indexes on #GBSBudgets''
		PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	END TRY
	BEGIN CATCH
		DECLARE @ErrorSeverity  INT = ERROR_SEVERITY(), @ErrorMessage   NVARCHAR(4000) =
			''Error creating indexes on #GBSBudgets: '' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + '':'' + ERROR_MESSAGE() 
		SELECT * FROM #GBSBudgets
		RAISERROR ( @ErrorMessage, @ErrorSeverity, 1)
	END CATCH

	----------------------------------------------------------------------------------------------
	-- All combined Budgets GBS + Tapas
	----------------------------------------------------------------------------------------------

	SELECT DISTINCT
		ImportBatchId
	INTO
		#DistinctImports
	FROM 
		#BudgetsToProcess BTP
		
	SELECT 
		SnapshotId, 
		BudgetId,
		ImportKey
	INTO
		#AllBudgets	
	FROM
		#NewBudgets
	UNION ALL 
	SELECT 
		SnapshotId, 
		BudgetId,
		ImportKey 
	FROM
		#GBSBudgets

END

/* ===============================================================================================================================================
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
   ============================================================================================================================================= */
BEGIN
	/*
		-------------------------------------------------------------------------------------------------------------------------------
		BudgetProject
		
		In TAPAS Budgeting, when a Budget is created, projects are copied from the Budget Allocation set to the BudgetProject table where
		the project is in the same source as the budget''s region and the project is set up for payroll usage.
		
		The #BudgetProject table gets all the budget projects that are associated with the budgets that will be pulled, as per code above.
		The Projects are used to determine the Property Funds which records are assigned to (either using the Corporate Department Code 
		and SourceCode combination, or the PropertyFund associated to the project if there is no Corporate Department assigned).
		The #Budget table is also used to determine the Activity Type to assign to records.
		The IsTsCost is used to determine if budgeted amounts are reimbursable or not.
		The project to be used for Overhead records is determined by the AllocateOverheadsProjectId
	*/
	
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetProject
	(
		BudgetProjectId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectId INT NULL,
		PropertyFundId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(6) NULL,
		CorporateSourceCode VARCHAR(2) NULL,
		IsReimbursable BIT NOT NULL,
		IsTsCost BIT NOT NULL,
		CanAllocateOverheads BIT NOT NULL,
		AllocateOverheadsProjectId INT NULL
	)
	INSERT INTO #BudgetProject
	(
		BudgetProjectId,
		BudgetId,
		ProjectId,
		PropertyFundId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		IsReimbursable,
		IsTsCost,
		CanAllocateOverheads,
		AllocateOverheadsProjectId
	)
	SELECT 
		BudgetProject.BudgetProjectId,
		BudgetProject.BudgetId,
		BudgetProject.ProjectId,
		BudgetProject.PropertyFundId,
		BudgetProject.ActivityTypeId,
		BudgetProject.CorporateDepartmentCode,
		BudgetProject.CorporateSourceCode,
		BudgetProject.IsReimbursable,
		BudgetProject.IsTsCost,
		BudgetProject.CanAllocateOverheads,
		BudgetProject.AllocateOverheadsProjectId
	FROM 
		TapasGlobalBudgeting.BudgetProject BudgetProject

		INNER JOIN #BudgetsToProcess BTP ON
			BudgetProject.ImportBatchId = BTP.ImportBatchId AND
			BudgetProject.BudgetId = BTP.BudgetId

	PRINT ''Completed inserting records into #BudgetProject:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
	CREATE INDEX IX_BudgetProjectId ON #BudgetProject (BudgetProjectId)

	PRINT ''Completed creating indexes on #BudgetProject''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------
		/*
			The #Region table is used to determine the Source Codes of budgets (using the RegionId field in the Budget table).
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #Region
	(
		RegionId INT NOT NULL,
		SourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #Region
	(
		RegionId,
		SourceCode
	)
	SELECT 
		SourceRegion.RegionId,
		SourceRegion.SourceCode
	FROM 
		HR.Region SourceRegion

		INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
			SourceRegion.ImportKey = SourceRegionA.ImportKey

	PRINT ''Completed inserting records into #Region:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------
		/*
			The #BudgetEmployee table holds details of employees which are allocated to a specified budget.
			The table is also used to determine the Location (from the LocationId field) of the employee, which will determine 
			the Originating Region of Budget records.
		*/	
		
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployee
	(
		BudgetEmployeeId INT NOT NULL,
		BudgetId INT NOT NULL,
		HrEmployeeId INT NULL,
		LocationId INT NOT NULL
	)
	INSERT INTO #BudgetEmployee(
		BudgetEmployeeId,
		BudgetId,
		HrEmployeeId,
		LocationId
	)
	SELECT 
		BudgetEmployee.BudgetEmployeeId,
		BudgetEmployee.BudgetId,
		BudgetEmployee.HrEmployeeId,
		BudgetEmployee.LocationId
	FROM
		TapasGlobalBudgeting.BudgetEmployee BudgetEmployee

		INNER JOIN #BudgetsToProcess BTP ON
			BudgetEmployee.BudgetId = BTP.BudgetId AND
			BudgetEmployee.ImportBatchId = BTP.ImportBatchId

	PRINT ''Completed inserting records into #BudgetEmployee:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
	CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

	PRINT ''Completed creating indexes on ##BudgetEmployee''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------

			The #BudgetEmployeeFunctionalDepartment table stores the combination of Employees included in a Budget, and 
			the Functional Departments they belong to.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeeFunctionalDepartment
	(
		ImportBatchId INT NOT NULL,
		BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		EffectivePeriod INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeeFunctionalDepartment
	(
		ImportBatchId,
		BudgetEmployeeFunctionalDepartmentId,
		BudgetEmployeeId,
		EffectivePeriod,
		FunctionalDepartmentId
	)
	SELECT 
		EFD.ImportBatchId,
		EFD.BudgetEmployeeFunctionalDepartmentId,
		EFD.BudgetEmployeeId,
		EFD.EffectivePeriod,
		EFD.FunctionalDepartmentId
	FROM 
		TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment EFD
		
		INNER JOIN #DistinctImports DI ON
			EFD.ImportBatchId = DI.ImportBatchId
		
		-- data limiting join
		INNER JOIN #BudgetEmployee BE ON
			EFD.BudgetEmployeeId = BE.BudgetEmployeeId

	PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId)
	CREATE INDEX IX_BudgetEmployeeFunctionalDepartment2 ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)

	PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------

			The #Location table is used to determine the OriginatingRegion of a Budget record.
			Each BudgetEmployee record has a LocationId to determine where an employee is based.
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #Location
	(
		LocationId INT NOT NULL,
		ExternalSubRegionId INT NOT NULL
	)

	INSERT INTO #Location
	(
		LocationId,
		ExternalSubRegionId
	)
	SELECT 
		Location.LocationId,
		Location.ExternalSubRegionId 
	FROM 
		HR.Location Location

		INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
			Location.ImportKey = LocationA.ImportKey

	PRINT ''Completed inserting records into #Location:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)

	PRINT ''Completed creating indexes on #Location''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------

			The #FunctionalDepartment table is used to determine the Functional Department of a Budget record.
		*/

	CREATE TABLE #FunctionalDepartment
	(
		FunctionalDepartmentId INT NOT NULL,
		GlobalCode CHAR(3) NULL
	)
	INSERT INTO #FunctionalDepartment
	(
		FunctionalDepartmentId,
		GlobalCode
	)
	SELECT
		FunctionalDepartmentId,
		GlobalCode
	FROM
		HR.FunctionalDepartment FD
		
		INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDa ON
			FD.ImportKey = FDa.ImportKey
	WHERE
		FD.IsActive = 1

	PRINT ''Completed inserting records into #FunctionalDepartment: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)

	PRINT ''Completed creating indexes on #FunctionalDepartment''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			--------------------------------------------------------------------------------------------
			
			The #RegionExtended table is used to determine the Functional Department of Overhead transactions.
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #RegionExtended
	(
		RegionId INT NOT NULL,
		OverheadFunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #RegionExtended
	(
		RegionId,
		OverheadFunctionalDepartmentId
	)
	SELECT 
		RegionExtended.RegionId,
		RegionExtended.OverheadFunctionalDepartmentId
	FROM 
		TapasGlobal.RegionExtended RegionExtended

		INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
			RegionExtended.ImportKey = RegionExtendedA.ImportKey

	PRINT ''Completed inserting records into #RegionExtended:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)

	PRINT ''Completed creating indexes on #RegionExtended''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-------------------------------------------------------------------------------------------
		/*
			The #Project table is used to get Property Fund and Activity Type information for Overhead projects, and default projects where
			the Bonus Cap has been exceeded.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #Project
	(
		ProjectId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(8) NOT NULL,
		CorporateSourceCode CHAR(2) NOT NULL,
		PropertyFundId INT NOT NULL
	)

	INSERT INTO #Project
	(
		ProjectId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		PropertyFundId
	)
	SELECT 
		Project.ProjectId,
		Project.ActivityTypeId,
		Project.CorporateDepartmentCode,
		Project.CorporateSourceCode,
		Project.PropertyFundId
	FROM 
		TapasGlobal.Project Project

		INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
			Project.ImportKey = ProjectA.ImportKey 

	PRINT ''Completed inserting records into #Project:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE TABLE #SystemSettingRegion
	(
		SystemSettingId INT NOT NULL,
		SystemSettingName VARCHAR(50) NOT NULL,
		SystemSettingRegionId INT NOT NULL,
		RegionId INT,
		SourceCode VARCHAR(2),
		BonusCapExcessProjectId INT
	)

		/*
			-------------------------------------------------------------------------------------------------
			System Setting Region - Bonus Cap Excess
			If a project exceeds its Bonus Cap amount, a single project is selected in place of that project.
			The project Id is determined by the System Setting Region table.
		*/

	SET @StartTime = GETDATE()

	INSERT INTO #SystemSettingRegion
	(
		SystemSettingId,
		SystemSettingName,
		SystemSettingRegionId,
		RegionId,
		SourceCode,
		BonusCapExcessProjectId
	)
	SELECT 
		ss.SystemSettingId,
		ss.Name,
		ssr.SystemSettingRegionId,
		ssr.RegionId,
		ssr.SourceCode,
		ssr.BonusCapExcessProjectId
	FROM
		(
			SELECT 
				ssr.SystemSettingRegionId,
				ssr.RegionId,
				ssr.SourceCode,
				ssr.BonusCapExcessProjectId,
				ssr.SystemSettingId
			FROM
				TapasGlobal.SystemSettingRegion ssr

				INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
					ssr.ImportKey = ssrA.ImportKey
		 ) ssr

		INNER JOIN
		(
			SELECT
				ss.SystemSettingId,
				ss.Name
			FROM
			(
				SELECT	
					ss.SystemSettingId,
					ss.Name
				FROM
					TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
						ss.ImportKey = ssA.ImportKey
				WHERE
					ss.Name = ''BonusCapExcess'' -- Previously this was done in the joins, but it''s now being done here to limit the data being processed.
			 ) ss
		) ss ON 
			ssr.SystemSettingId = ss.SystemSettingId

	PRINT ''Completed inserting #SystemSettingRegion''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

	PRINT ''Completed creating indexes on #Project''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*	-------------------------------------------------------------------------------------------------------------------------
			Global Categorization Payroll Mappings
			
			The following table is used to store Minor Category and Major Category Ids which records will be associated with.
			The reason it''s stored as a table and not as variables is because there may be more than one Snapshot being processed at the
			time, and different snapshots may have different Ids.
			
			NB!!!!!!!
			The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
			communicated to TS employees on certain reports. Changing the category mappings to the data below will have ramifications because 
			some reports check for this name.
		*/

	CREATE TABLE #PayrollGlobalMappings
	(
		GLMinorCategoryName VARCHAR(120) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(120) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		SnapshotId INT NOT NULL	
	)

	INSERT INTO #PayrollGlobalMappings
	(
		GLMinorCategoryName,
		GLMinorCategoryId,
		GLMajorCategoryName,
		GLMajorCategoryId,
		SnapshotId
	)
	SELECT DISTINCT
		GLMinorCategoryName,
		GLMinorCategoryId,
		GLMajorCategoryName,
		GLMajorCategoryId,
		SnapshotId
	FROM
		Gr.GetSnapshotGLCategorizationHierarchyExpanded()
	WHERE
		(
			GLMajorCategoryName = ''Salaries/Taxes/Benefits'' OR
			(
				GLMinorCategoryName = ''External General Overhead'' AND
				GLMajorCategoryName = ''General Overhead''
			)
		) AND
		GLCategorizationName = ''Global''

	SET @StartTime = GETDATE()

END		

		/*	-------------------------------------------------------------------------------------------------------------------------

			The MRI Server Source table is used to link Corporate Source codes to Property Source codes. This is for actuals from
			GBS which only use Corporate source codes.
		*/


CREATE TABLE #MRIServerSource
(
	SourceCode CHAR(2) NOT NULL,
	MappingSourceCode CHAR(2) NULL
)
INSERT INTO #MRIServerSource
(
	SourceCode,
	MappingSourceCode
)
SELECT
	SourceCode,
	MappingSourceCode
FROM
	Gdm.MRIServerSource MSS
	
	INNER JOIN Gdm.MRIServerSourceActive(@DataPriorToDate) MSSa ON
		MSS.ImportKey = MSSa.ImportKey
		
/* ===============================================================================================================================================
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
   ============================================================================================================================================= */
BEGIN
	/*
		---------------------------------------------------------------------
		BudgetEmployeePayrollAllocation
		The #BudgetEmployeePayrollAllocation table stores budget payroll allocations for employees.
		The table is used to determine the Base Salary, the Bonus and the Profit Share amounts for each employee.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocation
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		BudgetProjectGroupId INT NULL,
		Period INT NOT NULL,
		SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
		BonusAllocationValue DECIMAL(18, 9) NULL,
		BonusCapAllocationValue DECIMAL(18, 9) NULL,
		ProfitShareAllocationValue DECIMAL(18, 9) NULL,
		PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
		PreTaxBonusAmount DECIMAL(18, 2) NULL,
		PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
		PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetEmployeePayrollAllocationId INT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeePayrollAllocation
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeeId,
		BudgetProjectId,
		BudgetProjectGroupId,
		Period,
		SalaryAllocationValue,
		BonusAllocationValue,
		BonusCapAllocationValue,
		ProfitShareAllocationValue,
		PreTaxSalaryAmount,
		PreTaxBonusAmount,
		PreTaxBonusCapExcessAmount,
		PreTaxProfitShareAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		OriginalBudgetEmployeePayrollAllocationId,
		SnapshotId
	)
	SELECT
		Allocation.ImportKey,
		Allocation.ImportBatchId,
		Allocation.ImportDate,
		Allocation.BudgetEmployeePayrollAllocationId,
		Allocation.BudgetEmployeeId,
		Allocation.BudgetProjectId,
		Allocation.BudgetProjectGroupId,
		Allocation.Period,
		Allocation.SalaryAllocationValue,
		Allocation.BonusAllocationValue,
		Allocation.BonusCapAllocationValue,
		Allocation.ProfitShareAllocationValue,
		Allocation.PreTaxSalaryAmount,
		Allocation.PreTaxBonusAmount,
		Allocation.PreTaxBonusCapExcessAmount,
		Allocation.PreTaxProfitShareAmount,
		Allocation.InsertedDate,
		Allocation.UpdatedDate,
		Allocation.UpdatedByStaffId,
		Allocation.OriginalBudgetEmployeePayrollAllocationId,
		B.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #DistinctImports DI ON
			Allocation.ImportBatchId = DI.ImportBatchId

		--data limiting join
		INNER JOIN #BudgetProject BP ON
			Allocation.BudgetProjectId = bp.BudgetProjectId 
		
		-- Used to get the snapshot from the budgets currently being processed.	
		INNER JOIN #NewBudgets B ON
			BP.BudgetId = B.BudgetId

	PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	---------------------------------------------------------------------
	-- Source payroll tax detail
		/*
			The #BudgetEmployeePayrollDetail table stores budget payroll allocations for employee taxes.
		*/
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocationDetail
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BenefitOptionId INT NULL,
		BudgetTaxTypeId INT NULL,
		SalaryAmount DECIMAL(18, 2) NULL,
		BonusAmount DECIMAL(18, 2) NULL,
		ProfitShareAmount DECIMAL(18, 2) NULL,
		BonusCapExcessAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeePayrollAllocationDetail
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		BenefitOptionId,
		BudgetTaxTypeId,
		SalaryAmount,
		BonusAmount,
		ProfitShareAmount,
		BonusCapExcessAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		TaxDetail.ImportKey,
		TaxDetail.ImportBatchId,
		TaxDetail.ImportDate,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		TaxDetail.BudgetEmployeePayrollAllocationId,
		TaxDetail.BenefitOptionId,
		TaxDetail.BudgetTaxTypeId,
		TaxDetail.SalaryAmount,
		TaxDetail.BonusAmount,
		TaxDetail.ProfitShareAmount,
		TaxDetail.BonusCapExcessAmount,
		TaxDetail.InsertedDate,
		TaxDetail.UpdatedDate,
		TaxDetail.UpdatedByStaffId,
		Allocation.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail

		--data limiting join
		INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
			TaxDetail.ImportBatchId = Allocation.ImportBatchId AND
			TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

	PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

	PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			The #BudgetTaxType determines the tax types associated with budgets.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetTaxType
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetTaxTypeId INT NOT NULL,
		BudgetId INT NOT NULL,
		TaxTypeId INT NOT NULL,
		FixedTaxTypeId INT NOT NULL,
		RateCalculationMethodId INT NOT NULL,
		Name VARCHAR(100) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetTaxTypeId INT NULL
	)

	INSERT INTO #BudgetTaxType
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetTaxTypeId,
		BudgetId,
		TaxTypeId,
		FixedTaxTypeId,
		RateCalculationMethodId,
		Name,
		InsertedDate,
		UpdatedByStaffId,
		OriginalBudgetTaxTypeId
	)
	SELECT 
		BudgetTaxType.ImportKey,
		BudgetTaxType.ImportBatchId,
		BudgetTaxType.ImportDate,
		BudgetTaxType.BudgetTaxTypeId,
		BudgetTaxType.BudgetId,
		BudgetTaxType.TaxTypeId,
		BudgetTaxType.FixedTaxTypeId,
		BudgetTaxType.RateCalculationMethodId,
		BudgetTaxType.Name,
		BudgetTaxType.InsertedDate,
		BudgetTaxType.UpdatedByStaffId,
		BudgetTaxType.OriginalBudgetTaxTypeId 
	FROM
		TapasGlobalBudgeting.BudgetTaxType BudgetTaxType

		INNER JOIN #BudgetsToProcess BTP ON
			BudgetTaxType.ImportBatchId = BTP.ImportBatchId AND
			BudgetTaxType.BudgetId = BTP.BudgetId
		
	PRINT ''Completed inserting records into #BudgetTaxType:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)

	PRINT ''Completed creating indexes on #BudgetTaxType''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

			/*
				The #TaxType table is used to determine the Minor Category for the tax records sourced from the #BudgetEmployeePayrollAllocationDetail
				table.
			*/

	SET @StartTime = GETDATE()

	CREATE TABLE #TaxType
	(
		ImportBatchId INT NOT NULL,
		TaxTypeId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL
	)

	INSERT INTO #TaxType
	(
		ImportBatchId,
		TaxTypeId,
		MinorGlAccountCategoryId
	)
	SELECT 
		TaxType.ImportBatchId,
		TaxType.TaxTypeId,
		TaxType.MinorGlAccountCategoryId
	FROM 
		TapasGlobalBudgeting.TaxType TaxType

		INNER JOIN #DistinctImports DI ON
			TaxType.ImportBatchId = DI.ImportBatchId

	PRINT ''Completed inserting records into #TaxType:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_TaxType ON #TaxType (ImportBatchId, TaxTypeId)

	PRINT ''Completed creating indexes on #TaxType''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	-- Source payroll allocation Tax detail
		/*
			The #EmployeePayrollAllocationDetail table stores budget payroll allocations for employees for taxes and employee benefits.
			This adds to the #BudgetEmployeePayrollAllocation table by adding the Minor Category mapping.
		*/

	CREATE TABLE #EmployeePayrollAllocationDetail
	(
		ImportKey INT NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		MinorGlAccountCategoryId INT NULL,
		BudgetTaxTypeId INT NULL,
		SalaryAmount DECIMAL(18, 2) NULL,
		BonusAmount DECIMAL(18, 2) NULL,
		ProfitShareAmount DECIMAL(18, 2) NULL,
		BonusCapExcessAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #EmployeePayrollAllocationDetail
	(
		ImportKey,
		BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		MinorGlAccountCategoryId,
		BudgetTaxTypeId,
		SalaryAmount,
		BonusAmount,
		ProfitShareAmount,
		BonusCapExcessAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		TaxDetail.ImportKey,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		TaxDetail.BudgetEmployeePayrollAllocationId,
		CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN GlCategory.GLMinorCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
		TaxDetail.BudgetTaxTypeId,
		TaxDetail.SalaryAmount,
		TaxDetail.BonusAmount,
		TaxDetail.ProfitShareAmount,
		TaxDetail.BonusCapExcessAmount,
		TaxDetail.InsertedDate,
		TaxDetail.UpdatedDate,
		TaxDetail.UpdatedByStaffId,
		TaxDetail.SnapshotId
	FROM
		-- Joining on allocation to limit amount of data
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId AND
			Allocation.ImportBatchId = TaxDetail.ImportBatchId

		-- This join is used to determine the Minor Category if the Benefit Option is not specified.
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			Allocation.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''

		LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
			TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
			Allocation.ImportBatchId = BudgetTaxType.ImportBatchId

		-- Used to determine the Minor Category
		LEFT OUTER JOIN #TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
			BudgetTaxType.ImportBatchId = TaxType.ImportBatchId

	PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail:''+CONVERT(char(10),@@rowcount)

	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
	CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------------
	-- Source overhead allocations

		/*
			The #BudgetOverheadAllocation table stores overhead budget data.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocation
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetId INT NOT NULL,
		OverheadRegionId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetPeriod INT NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetOverheadAllocationId INT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetOverheadAllocation
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetOverheadAllocationId,
		BudgetId,
		OverheadRegionId,
		BudgetEmployeeId,
		BudgetPeriod,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		OriginalBudgetOverheadAllocationId,
		SnapshotId
	)
	SELECT
		OverheadAllocation.ImportKey,
		OverheadAllocation.ImportBatchId,
		OverheadAllocation.ImportDate,
		OverheadAllocation.BudgetOverheadAllocationId,
		OverheadAllocation.BudgetId,
		OverheadAllocation.OverheadRegionId,
		OverheadAllocation.BudgetEmployeeId,
		OverheadAllocation.BudgetPeriod,
		OverheadAllocation.AllocationAmount,
		OverheadAllocation.InsertedDate,
		OverheadAllocation.UpdatedDate,
		OverheadAllocation.UpdatedByStaffId,
		OverheadAllocation.OriginalBudgetOverheadAllocationId,
		BTP.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation

		INNER JOIN #BudgetsToProcess BTP ON
			OverheadAllocation.ImportBatchId = BTP.ImportBatchId AND
			OverheadAllocation.BudgetId = BTP.BudgetId

	PRINT ''Completed inserting records into #BudgetOverheadAllocation:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)

	PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			The #BudgetOverheadAllocationDetail table stores overhead budget data for the individual projects.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocationDetail(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		AllocationValue DECIMAL(18, 9) NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetOverheadAllocationDetail
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetOverheadAllocationDetailId,
		BudgetOverheadAllocationId,
		BudgetProjectId,
		AllocationValue,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT 
		OverheadDetail.ImportKey,
		OverheadDetail.ImportBatchId,
		OverheadDetail.ImportDate,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetProjectId,
		OverheadDetail.AllocationValue,
		OverheadDetail.AllocationAmount,
		OverheadDetail.InsertedDate,
		OverheadDetail.UpdatedDate,
		OverheadDetail.UpdatedByStaffId,
		B.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail

		INNER JOIN #DistinctImports DI ON
			OverheadDetail.ImportBatchId = DI.ImportBatchId

		-- Limits the data to records associated with budgets currently being processed.
		INNER JOIN #BudgetProject BP ON
			OverheadDetail.BudgetProjectId = BP.BudgetProjectId

		-- Used to determine the snapshot the records are associated with.	
		INNER JOIN #NewBudgets B ON
			BP.BudgetId = B.BudgetId	

	PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			The #OverheadAllocationDetail table stores overhead budget data for the individual projects, and includes the GL Minor Category
			mapping.
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #OverheadAllocationDetail
	(
		ImportKey INT NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		AllocationValue DECIMAL(18, 9) NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #OverheadAllocationDetail
	(
		ImportKey,
		BudgetOverheadAllocationDetailId,
		BudgetOverheadAllocationId,
		BudgetProjectId,
		MinorGlAccountCategoryId,
		AllocationValue,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		OverheadDetail.ImportKey,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetProjectId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId,
		OverheadDetail.AllocationValue,
		OverheadDetail.AllocationAmount,
		OverheadDetail.InsertedDate,
		OverheadDetail.UpdatedDate,
		OverheadDetail.UpdatedByStaffId,
		OverheadDetail.SnapshotId
	FROM
		-- Joining on allocation to limit amount of data
		#BudgetOverheadAllocation OverheadAllocation

		INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

		-- Used to determine the Minor Category of the records
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			OverheadDetail.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''External General Overhead''

	PRINT ''Completed inserting records into #OverheadAllocationDetail:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT ''Completed creating indexes on #OverheadAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ================================================================================================================================================
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
   ============================================================================================================================================= */
BEGIN
	/*
		Calculate effective functional department.
		Finds the last period before an employee changed her functional department, and finds all functional departments 
		that an employee is associated with.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #EffectiveFunctionalDepartment
	(
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #EffectiveFunctionalDepartment
	(
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeeId,
		FunctionalDepartmentId
	)
	SELECT 
		Allocation.BudgetEmployeePayrollAllocationId,
		Allocation.BudgetEmployeeId,
		(
			SELECT 
				EFD.FunctionalDepartmentId
			FROM 
				(
					SELECT 
						Allocation2.ImportBatchId,
						Allocation2.BudgetEmployeeId,
						MAX(EFD.EffectivePeriod) AS EffectivePeriod
					FROM
						#BudgetEmployeePayrollAllocation Allocation2

						INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
							Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId AND
							Allocation2.ImportBatchId = EFD.ImportBatchId
					
					WHERE
						Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
						Allocation.ImportBatchId = Allocation2.ImportBatchId AND
						EFD.EffectivePeriod <= Allocation.Period

					GROUP BY
						Allocation2.ImportBatchId,
						Allocation2.BudgetEmployeeId
				) EFDo
			
				LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
					EFD.ImportBatchId = EFDo.ImportBatchId AND
					EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
					EFD.EffectivePeriod = EFDo.EffectivePeriod

		 ) AS FunctionalDepartmentId
	FROM
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

	PRINT ''Completed inserting records into #EffectiveFunctionalDepartment:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #EffectiveFunctionalDepartment''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-------------------------------------------------------------------------------------------------------
	-- Map Payroll data

		/*
			--------------------------------------------
			Pre-Tax Payroll Data
			Map Pre-Tax payroll budget amounts from the #BudgetEmployeePayrollAllocation table to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityPreTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
		FirstProjectedPeriod char(6) NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		SalaryPreTaxAmount MONEY NOT NULL,
		ProfitSharePreTaxAmount MONEY NOT NULL,
		BonusPreTaxAmount MONEY NOT NULL,
		BonusCapExcessPreTaxAmount MONEY NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode VARCHAR(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		SnapshotId INT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	-- Insert original budget amounts
	INSERT INTO #ProfitabilityPreTaxSource
	(
		ImportBatchId,
		BudgetId,
		BudgetRegionId,
		FirstProjectedPeriod,
		ProjectId,
		HrEmployeeId,
		BudgetEmployeePayrollAllocationId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		SalaryPreTaxAmount,
		ProfitSharePreTaxAmount,
		BonusPreTaxAmount,
		BonusCapExcessPreTaxAmount,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		SnapshotId,
		
		SourceTableName
	)
	SELECT 
		Budget.ImportBatchId,
		Budget.BudgetId AS BudgetId,
		Budget.RegionId AS BudgetRegionId,
		Budget.FirstProjectedPeriod,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		Allocation.BudgetEmployeePayrollAllocationId,
		(
			''TGB:BudgetId='' + CONVERT(VARCHAR, Budget.BudgetId) +
			''&ProjectId='' + CONVERT(VARCHAR, ISNULL(BudgetProject.ProjectId, 0)) +
			''&HrEmployeeId='' + CONVERT(VARCHAR, ISNULL(BudgetEmployee.HrEmployeeId, 0)) +
			''&BudgetEmployeePayrollAllocationId='' + CONVERT(VARCHAR, Allocation.BudgetEmployeePayrollAllocationId) +
			''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0''
		) AS ReferenceCode,
		Allocation.Period AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
		ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
		ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount,
		ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
		ISNULL(EFD.FunctionalDepartmentId, -1),
		fd.GlobalCode AS FunctionalDepartmentCode, 
		CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
		BudgetProject.ActivityTypeId,
		Att.ActivityTypeCode,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		Allocation.UpdatedDate,
		Budget.BudgetReportGroupPeriod,
		Allocation.SnapshotId,
		
		''BudgetEmployeePayrollAllocation''
	FROM
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetProject BudgetProject ON
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

		INNER JOIN #NewBudgets Budget ON 
			BudgetProject.BudgetId = Budget.BudgetId 

		LEFT OUTER JOIN #Region SourceRegion ON 
			SourceRegion.RegionId = Budget.RegionId 

		-- Maps the Functional Department 
		LEFT OUTER JOIN #EffectiveFunctionalDepartment EFD ON
			Allocation.BudgetEmployeePayrollAllocationId = EFD.BudgetEmployeePayrollAllocationId

		-- Resolves the Functional Department Code
		LEFT OUTER JOIN #FunctionalDepartment FD ON 
			EFD.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- Maps the source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
			BudgetProject.CorporateSourceCode = GrSc.SourceCode 
		/*
			A Property Fund can either be mapped using the PropertyFundId in the BudgetProject table, or using the CorporateDepartmentCode and
			SourceCode combination in the BudgetProject table to determine the PropertyFundId through the ReportingEntityCorproateDepartment table
			or the ReportingEntityPropertyEntity table.
			The Property Fund using the CorporateDepartmentCode and SourceCode is the first option, but if this is null, the PropertyFundId is used
			directly from the BudgetProject table.
		*/
		-- Gets the Property Fund a Project''s Corporate Department is mapped to for transaction before period 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			BudgetProject.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = ''YES'' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		-- Used to resolve the Property Fund a Project''s Corporate Department is mapped to.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND			   
			Budget.SnapshotId = RECD.SnapshotId

		-- Used to resolve the Property Fund a Project''s Property Entity is mapped to.	   
		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode  = REPE.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId

		-- Maps the Property Fund a Project''s Corporate Department / Reporting Entity is mapped to.
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = ''YES''
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.IsActive = 1
			
		-- Gets the Property Fund a Project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1
			
		-- 	Used to resolve the Consolidation Sub Region a Project''s Corporate Department is mapped to.	
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- 	Used to resolve the Consolidation Sub Region a Project''s Property Entity is mapped to.		
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode  AND
			BudgetProject.CorporateSourceCode  = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = ConsolidationRegion.GlobalRegionId AND
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
			Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		LEFT OUTER JOIN #Location Location ON 
			BudgetEmployee.LocationId = Location.LocationId

		-- Used to dtermine the Originating Region Code and Source Code	
		LEFT OUTER JOIN Gdm.SnapshotPayrollRegion OriginatingRegion ON 
			Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
			Budget.RegionId = OriginatingRegion.RegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			BudgetProject.ActivityTypeId = Att.ActivityTypeId AND
			Budget.SnapshotId = Att.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotCorporateDepartment Dept ON
			BudgetProject.CorporateDepartmentCode = Dept.Code AND 
			SourceRegion.SourceCode = Dept.SourceCode AND
			Budget.SnapshotId = Dept.SnapshotId
	WHERE
		Allocation.Period BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
		--Change Control 1 : GC 2010-09-01
		--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

	PRINT ''Completed inserting records into #ProfitabilityPreTaxSource:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
	CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
	CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
	CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
	CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--Map Tax Amounts
	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
		FirstProjectedPeriod CHAR(6) NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		SalaryTaxAmount MONEY NOT NULL,
		ProfitShareTaxAmount MONEY NOT NULL,
		BonusTaxAmount MONEY NOT NULL,
		BonusCapExcessTaxAmount MONEY NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode VARCHAR(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		SnapshotId INT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	--/*
	-- Insert original budget amounts
	INSERT INTO #ProfitabilityTaxSource
	(
		ImportBatchId,
		BudgetId,
		BudgetRegionId,
		FirstProjectedPeriod,
		ProjectId,
		HrEmployeeId,
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeePayrollAllocationDetailId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		SalaryTaxAmount,
		ProfitShareTaxAmount,
		BonusTaxAmount,
		BonusCapExcessTaxAmount,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		SnapshotId,
		
		SourceTableName
	)
	SELECT 
		B.ImportBatchId,
		pts.BudgetId,
		pts.BudgetRegionId,
		pts.FirstProjectedPeriod,
		ISNULL(pts.ProjectId,0) AS ProjectId,
		ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
		pts.BudgetEmployeePayrollAllocationId,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		''TGB:BudgetId='' + CONVERT(varchar,pts.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + ''&BudgetOverheadAllocationDetailId=0'' AS ReferenceCode,
		pts.ExpensePeriod,
		pts.SourceCode,
		ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
		ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
		ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
		ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
		TaxDetail.MinorGlAccountCategoryId,
		ISNULL(pts.FunctionalDepartmentId, -1),
		pts.FunctionalDepartmentCode, 
		pts.Reimbursable,
		pts.ActivityTypeId,
		pts.ActivityTypeCode,
		pts.PropertyFundId,
		ISNULL(PF.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		pts.ConsolidationSubRegionGlobalRegionId,
		pts.OriginatingRegionCode,
		pts.OriginatingRegionSourceCode,
		pts.LocalCurrencyCode,
		pts.AllocationUpdatedDate,
		pts.BudgetReportGroupPeriod,
		TaxDetail.SnapshotId,
		
		''BudgetEmployeePayrollAllocationDetail''
	FROM
		#EmployeePayrollAllocationDetail TaxDetail

		INNER JOIN #ProfitabilityPreTaxSource PTS ON
			TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

		INNER JOIN #NewBudgets B ON
			PTS.BudgetId = B.BudgetId 

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			PTS.PropertyFundId = PF.PropertyFundId AND
			B.SnapshotId = PF.SnapshotId AND
			PF.IsActive = 1

	PRINT ''Completed inserting records into #ProfitabilityTaxSource:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityTaxSource_SalaryTaxAmount ON #ProfitabilityTaxSource (SalaryTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_ProfitShareTaxAmount ON #ProfitabilityTaxSource  (ProfitShareTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_BonusTaxAmount ON #ProfitabilityTaxSource  (BonusTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_BonusCapExcessTaxAmount ON #ProfitabilityTaxSource  (BonusCapExcessTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource_BudgetEmployeePayrollAllocationId ON #ProfitabilityTaxSource  (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			------------------------------------------------------------------------------------------
			Overhead data
			Map Tax Overhead budget amounts to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityOverheadSource
	(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		FirstProjectedPeriod CHAR(6) NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		OverheadAllocationAmount MONEY NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		OverheadUpdatedDate DATETIME NOT NULL,
		SnapshotId INT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	-- Insert original overhead amounts
	INSERT INTO #ProfitabilityOverheadSource
	(
		ImportBatchId,
		BudgetId,
		FirstProjectedPeriod,
		ProjectId,
		HrEmployeeId,
		BudgetOverheadAllocationDetailId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		OverheadAllocationAmount,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,	
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		OverheadUpdatedDate,
		SnapshotId,
		
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		Budget.BudgetId AS BudgetId,
		Budget.FirstProjectedPeriod,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) AS ReferenceCode,
		OverheadAllocation.BudgetPeriod AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
		OverheadDetail.MinorGlAccountCategoryId,
		ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
		fd.GlobalCode AS FunctionalDepartmentCode,
		CASE
			WHEN
				(BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0)
			THEN 
				CASE
					WHEN -- Where ISTSCost is False the cost will be reimbursable
						(BudgetProject.IsTsCost = 0)
					THEN
						1
					ELSE
						0
				END
			ELSE
				0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
		END AS Reimbursable,
		BudgetProject.ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(OverheadPropertyFund.PropertyFundId, DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		OverheadDetail.UpdatedDate,
		OverheadAllocation.SnapshotId,
		
		''BudgetOverheadAllocation''
	FROM
		#BudgetOverheadAllocation OverheadAllocation 

		INNER JOIN #BudgetEmployee BudgetEmployee ON
			OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		INNER JOIN #OverheadAllocationDetail OverheadDetail ON
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId

		INNER JOIN #BudgetProject BudgetProject ON 
			OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId

		INNER JOIN #NewBudgets Budget ON 
			BudgetProject.BudgetId = Budget.BudgetId

		LEFT OUTER JOIN #Region SourceRegion ON 
			Budget.RegionId = SourceRegion.RegionId

		LEFT OUTER JOIN #RegionExtended RegionExtended ON 
			SourceRegion.RegionId = RegionExtended.RegionId

		LEFT OUTER JOIN #FunctionalDepartment FD ON 
			RegionExtended.OverheadFunctionalDepartmentId = FD.FunctionalDepartmentId

		LEFT OUTER JOIN	#Project OverheadProject ON
			BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

		-- Maps the Property Fund based on the BudgetProject mapping
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Maps the Source of the Budget Project
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
			BudgetProject.CorporateSourceCode = GrSc.SourceCode

		-- Maps the Property Fund of the Budget Project based on the CorporateDepartmentCode and SourceCode for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			BudgetProject.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = ''YES'' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		-- Maps the Budget Project to a Property Fund using the Corporate Department Code and Corporate Source Code combinations.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = RECD.SnapshotId 

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = REPE.SourceCode AND
			Budget.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode  AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode  AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = ''YES''
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END
			AND Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
			OverheadProject.CorporateSourceCode = GrScO.SourceCode

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping OPFM ON
			OverheadProject.CorporateDepartmentCode = OPFM.PropertyFundCode AND -- Combination of entity and corporate department
			OverheadProject.CorporateSourceCode = OPFM.SourceCode AND
			OPFM.IsDeleted = 0 AND
			(
				(GrScO.IsProperty = ''YES'' AND OPFM.ActivityTypeId IS NULL)
				OR
				(
					(GrScO.IsCorporate = ''YES'' AND OPFM.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrScO.IsCorporate = ''YES'' AND OPFM.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = OPFM.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund OverheadPropertyFund ON
			OverheadPropertyFund.PropertyFundId =	
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						OPFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = ''YES''
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND 
			OverheadPropertyFund.SnapshotId = Budget.SnapshotId AND
			OverheadPropertyFund.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotOverheadRegion OriginatingRegion ON 
			OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId
	WHERE
		OverheadAllocation.BudgetPeriod BETWEEN Budget.FirstProjectedPeriod AND Budget.GroupEndPeriod
			
	PRINT ''Completed inserting records into #ProfitabilityOverheadSource:''+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityOverheadSource_OverheadAllocationAmount ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

	PRINT ''Completed creating indexes on #ProfitabilityOverheadSource''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
	6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()
			
	CREATE TABLE #ProfitabilityPayrollMapping
	(
		ImportBatchId INT NOT NULL,
		SourceName varchar(50),
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		FirstProjectedPeriod CHAR(6) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		MajorGlAccountCategoryId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NOT NULL,
		FeeOrExpense  Varchar(20) NOT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		GlobalGlAccountCode Varchar(10) NULL,
		IsCorporateOverhead BIT NOT NULL,
		
		SourceTableName VARCHAR(128)
	)
	 
	INSERT INTO #ProfitabilityPayrollMapping
	(
		ImportBatchId,
		SourceName, 
		BudgetId,
		ReferenceCode,
		FirstProjectedPeriod,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		MajorGlAccountCategoryId,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		FeeOrExpense,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		GlobalGlAccountCode,
		IsCorporateOverhead,
		
		SourceTableName
	)
	-- Get Base Salary Payroll pre tax mappings and budget
	SELECT
		PPS.ImportBatchId,
		''Budget-SalaryPreTaxAmount'' as SourceName,
		PPS.BudgetId,
		PPS.ReferenceCode + ''&Type=SalaryPreTax'' AS ReferenceCode,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.SalaryPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		PPS.Reimbursable,  
		''SalaryPreTax'' FeeOrExpense,
		PPS.ActivityTypeId,
		PPS.PropertyFundId,
		PPS.AllocationSubRegionGlobalRegionId,
		PPS.ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		
		''N/A'' GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Base Salary''
	WHERE
		PPS.SalaryPreTaxAmount <> 0

	-- Get Profit Share Benefit pre tax mappings and budget
	UNION ALL

	SELECT
		PPS.ImportBatchId,
		''Budget-ProfitSharePreTaxAmount'' as SourceName,
		PPS.BudgetId,
		PPS.ReferenceCode + ''&Type=ProfitSharePreTax'' AS ReferenceCod,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.ProfitSharePreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		PPS.Reimbursable,  
		''ProfitSharePreTax'' FeeOrExpense,
		PPS.ActivityTypeId,
		PPS.PropertyFundId,
		PPS.AllocationSubRegionGlobalRegionId,
		PPS.ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		-- Used to map the Major and Minor Category Ids based on the SnapshotId	
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits'' -- Profit Share maps to the Benefits GL Minor Category	
	WHERE
		PPS.ProfitSharePreTaxAmount <> 0

	-- Get Bonus pre tax mappings and budget
	UNION ALL

	SELECT
		PPS.ImportBatchId,
		''Budget-BonusPreTaxAmount'' as SourceName,
		PPS.BudgetId,
		PPS.ReferenceCode + ''&Type=BonusPreTax'' AS ReferenceCod,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.BonusPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		PPS.Reimbursable,  
		''BonusPreTax'' FeeOrExpense,
		PPS.ActivityTypeId,
		PPS.PropertyFundId,
		PPS.AllocationSubRegionGlobalRegionId,
		PPS.ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		-- Used to map the Major and Minor Category Ids based on the SnapshotId		
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Bonus''
	WHERE
		PPS.BonusPreTaxAmount <> 0

	--Get bonus cap pre tax mappings
	UNION ALL

	SELECT
		PPS.ImportBatchId,
		''Budget-BonusCapExcessPreTaxAmount'' AS SourceName,	
		PPS.BudgetId,
		PPS.ReferenceCode + ''&Type=BonusCapExcessPreTax'' AS ReferenceCod,
		PPS.FirstProjectedPeriod,
		PPS.ExpensePeriod,
		PPS.SourceCode,
		PPS.BonusCapExcessPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		PPS.FunctionalDepartmentId,
		PPS.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		''BonusCapExcessPreTax'' AS FeeOrExpense,
		ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		PPS.OriginatingRegionCode,
		PPS.OriginatingRegionSourceCode,
		PPS.LocalCurrencyCode,
		PPS.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				PPS.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		PPS.SourceTableName
	FROM
		#ProfitabilityPreTaxSource PPS

		INNER JOIN #NewBudgets Budget on
		  PPS.BudgetId = Budget.BudgetId

		-- Used to determine the Major and Minor Categories of records
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			PPS.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Bonus''

		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			PPS.SourceCode = ssr.SourceCode AND
			PPS.BudgetRegionId = ssr.RegionId AND
			ssr.SystemSettingName = ''BonusCapExcess''

		LEFT OUTER JOIN #Project P ON
			ssr.BonusCapExcessProjectId = P.ProjectId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			P.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			P.CorporateSourceCode = GrSc.SourceCode

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			P.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			P.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = ''YES'' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId = p.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
				)
			) AND
			PPS.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode  AND
			p.CorporateSourceCode  = RECD.SourceCode AND
			PPS.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = RECD.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = REPE.PropertyEntityCode  AND
			p.CorporateSourceCode = REPE.SourceCode AND
			PPS.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			p.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			PPS.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode))  = CRPE.PropertyEntityCode AND
			p.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			PPS.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			PPS.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						PPS.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = ''YES''
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.IsActive = 1
	WHERE
		PPS.BonusCapExcessPreTaxAmount <> 0

	UNION ALL

	-- Get Base Salary Payroll Tax mappings and budget
	SELECT
		TaxSource.ImportBatchId,
		''Budget-SalaryTaxAmount'' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + ''&Type=SalaryTax'' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.SalaryTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		TaxSource.Reimbursable,  
		''SalaryTaxTax'' FeeOrExpense,
		TaxSource.ActivityTypeId,
		TaxSource.PropertyFundId,
		TaxSource.AllocationSubRegionGlobalRegionId,
		TaxSource.ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource
		
		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''
	WHERE
		TaxSource.SalaryTaxAmount <> 0

	-- Get Profit Share Benefit Tax mappings and budget
	UNION ALL

	SELECT
		TaxSource.ImportBatchId,
		''Budget-ProfitShareTaxAmount'' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + ''&Type=ProfitShareTax'' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.ProfitShareTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		TaxSource.Reimbursable,  
		''ProfitShareTax'' FeeOrExpense,
		TaxSource.ActivityTypeId,
		TaxSource.PropertyFundId,
		TaxSource.AllocationSubRegionGlobalRegionId,
		TaxSource.ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource

		-- Used to map the Major and Minor Category Ids based on the SnapshotId						
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''
	WHERE
		TaxSource.ProfitShareTaxAmount <> 0

	-- Get Bonus Tax mappings and budget
	UNION ALL

	SELECT
		TaxSource.ImportBatchId,
		''Budget-BonusTaxAmount'' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + ''&Type=BonusTax'' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.BonusTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		TaxSource.Reimbursable,  
		''BonusTax'' FeeOrExpense,
		TaxSource.ActivityTypeId,
		TaxSource.PropertyFundId,
		TaxSource.AllocationSubRegionGlobalRegionId,
		TaxSource.ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource

		INNER JOIN #NewBudgets Budget ON
		  TaxSource.BudgetId = Budget.BudgetId

		-- Used to map the Major and Minor Category Ids based on the SnapshotId  					
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''
	WHERE
		TaxSource.BonusTaxAmount <> 0

	-- Get Bonus cap Tax mappings 
	UNION ALL

	SELECT
		TaxSource.ImportBatchId,
		''Budget-BonusCapExcessTaxAmount'' AS SourceName,
		TaxSource.BudgetId,
		TaxSource.ReferenceCode + ''&Type=BonusCapExcessTax'' AS ReferenceCod,
		TaxSource.FirstProjectedPeriod,
		TaxSource.ExpensePeriod,
		TaxSource.SourceCode,
		TaxSource.BonusCapExcessTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		TaxSource.MinorGlAccountCategoryId, 
		TaxSource.FunctionalDepartmentId,
		TaxSource.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		''BonusCapExcessTax'' AS FeeOrExpense,
		ISNULL(BonusCapExcessProject.ActivityTypeId, -1) AS ActivityTypeId,
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		TaxSource.OriginatingRegionCode,
		TaxSource.OriginatingRegionSourceCode,
		TaxSource.LocalCurrencyCode,
		TaxSource.AllocationUpdatedDate,
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				TaxSource.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverhead,
		
		TaxSource.SourceTableName
	FROM
		#ProfitabilityTaxSource TaxSource

		INNER JOIN #NewBudgets Budget on
			TaxSource.BudgetId = Budget.BudgetId 

		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			TaxSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''

		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			TaxSource.SourceCode = ssr.SourceCode AND
			TaxSource.BudgetRegionId = ssr.RegionId AND
			ssr.SystemSettingName = ''BonusCapExcess''

		LEFT OUTER JOIN #Project BonusCapExcessProject ON
			ssr.BonusCapExcessProjectId = BonusCapExcessProject.ProjectId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BonusCapExcessProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			BonusCapExcessProject.CorporateSourceCode = GrSc.SourceCode  

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping PFM ON
			BonusCapExcessProject.CorporateDepartmentCode = PFM.PropertyFundCode AND -- Combination of entity and corporate department
			BonusCapExcessProject.CorporateSourceCode = PFM.SourceCode AND
			PFM.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = ''YES'' AND PFM.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId = BonusCapExcessProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND PFM.ActivityTypeId IS NULL AND BonusCapExcessProject.ActivityTypeId IS NULL)
				)
			) AND
			TaxSource.BudgetReportGroupPeriod < 201007 AND
			Budget.SnapshotId = PFM.SnapshotId

		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BonusCapExcessProject.CorporateSourceCode  = RECD.SourceCode AND
			TaxSource.BudgetReportGroupPeriod >= 201007 AND			   
			Budget.SnapshotId = RECD.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode))  = REPE.PropertyEntityCode AND
			BonusCapExcessProject.CorporateSourceCode  = REPE.SourceCode AND
			TaxSource.BudgetReportGroupPeriod >= 201007 AND
			Budget.SnapshotId = REPE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BonusCapExcessProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId  = CRCD.SnapshotId AND
			TaxSource.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BonusCapExcessProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BonusCapExcessProject.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId = CRPE.SnapshotId AND
			TaxSource.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			Budget.SnapshotId = DepartmentPropertyFund.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						TaxSource.BudgetReportGroupPeriod < 201007
					THEN
						PFM.PropertyFundId
					ELSE
						CASE
							WHEN
								GrSc.IsCorporate = ''YES''
							THEN
								RECD.PropertyFundId
							ELSE
								REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			TaxSource.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1
	WHERE
		TaxSource.BonusCapExcessTaxAmount <> 0
		
	-- Get Overhead mappings
	UNION ALL

	SELECT
		OverheadSource.ImportBatchId,
		''Budget-OverheadAllocationAmount'' AS SourceName,
		OverheadSource.BudgetId,
		OverheadSource.ReferenceCode + ''&Type=OverheadAllocation'' AS ReferenceCod,
		OverheadSource.FirstProjectedPeriod,
		OverheadSource.ExpensePeriod,
		OverheadSource.SourceCode,
		OverheadSource.OverheadAllocationAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MinorGlAccountCategoryId,
		OverheadSource.MinorGlAccountCategoryId,
		OverheadSource.FunctionalDepartmentId,
		OverheadSource.FunctionalDepartmentCode,
		OverheadSource.Reimbursable,
		''Overhead'' FeeOrExpense,
		OverheadSource.ActivityTypeId,
		OverheadSource.PropertyFundId,
		OverheadSource.AllocationSubRegionGlobalRegionId,
		OverheadSource.ConsolidationSubRegionGlobalRegionId,
		OverheadSource.OriginatingRegionCode,
		OverheadSource.OriginatingRegionSourceCode,
		OverheadSource.LocalCurrencyCode,
		OverheadSource.OverheadUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''50029500'' + RIGHT(''0'' + LTRIM(STR(OverheadSource.ActivityTypeId, 3, 0)), 2) AS GlobalGlAccountCode,
		1 AS IsCorporateOverhead,
		
		OverheadSource.SourceTableName
	FROM
		#ProfitabilityOverheadSource OverheadSource

		INNER JOIN #NewBudgets Budget ON
			Budget.BudgetId = OverheadSource.BudgetId

		-- Maps the Major Category of the Overhead transaction
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			OverheadSource.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''External General Overhead''
	WHERE
		OverheadSource.OverheadAllocationAmount <> 0

	PRINT ''Completed inserting records into #ProfitabilityPayrollMapping:''+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)

	PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
	7.	Create Global and Local Categorization mapping tables
   ============================================================================================================================================= */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Global Categorization Mapping

		The table below is used to map Gl Accounts to their Categorization Hierarchies for the Global Categorization.
		The GlobalGL Accounts used are the list from the #ActivityTypeGLAccount table created earlier.
	*/

	CREATE TABLE #GlGlobalAccount
	(
		GLGlobalAccountId INT NOT NULL,
		Code VARCHAR(10) NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GlGlobalAccount
	(
		GLGlobalAccountId,
		Code,
		SnapshotId
	)
	SELECT 
		GGA.GLGlobalAccountId,
		GGA.Code,
		GGA.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccount GGA
	WHERE
		GGA.Code LIKE ''50029500%'' AND
		GGA.IsActive = 1
		
	UNION
	SELECT -- This is the record to be used for Payroll transactions.
		0,
		''N/A'',
		S.SnapshotId
	FROM
		Gdm.[Snapshot] S

	CREATE TABLE #GlobalGLCategorizationMapping
	(
		GlobalGLCategorizationHierarchyKey VARCHAR(50) NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GlGlobalAccountCode VARCHAR(10) NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GlobalGLCategorizationMapping
	(
		GlobalGLCategorizationHierarchyKey,
		GLMajorCategoryId,
		GLMinorCategoryId,
		GlGlobalAccountCode,
		SnapshotId	
	)
	SELECT
		DIM.GLCategorizationHierarchyKey,
		GdmMappings.GLMajorCategoryId,
		GdmMappings.GLMinorCategoryId,
		GGA.Code AS GlGlobalAccountCode,
		GdmMappings.SnapshotId		
	FROM
		#GlGlobalAccount GGA
		INNER JOIN
		(
			SELECT
				GCT.GLCategorizationTypeId,
				GC.GLCategorizationId,
				GFC.GLFinancialCategoryId,
				MajC.GLMajorCategoryId GLMajorCategoryId,
				MinC.GLMinorCategoryId GLMinorCategoryId,
				GCT.SnapshotId
			FROM
				Gdm.SnapshotGLMinorCategory MinC
					
				INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1
					
				INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
					MajC.GLFinancialCategoryId = GFC.GLFinancialCategoryId AND
					MajC.SnapshotId  = GFC.SnapshotId  
					
				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					GFC.GLCategorizationId = GC.GLCategorizationId AND
					GFC.SnapshotId = GC.SnapshotId AND
					GC.GLCategorizationId = 233
					
				INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId AND
					GC.SnapshotId = GCT.SnapshotId 
			WHERE -- Limits it to the major categories and minor categories that are relevant to the budgets being processed
				(	
					MajC.Name = ''Salaries/Taxes/Benefits'' OR
					(
						MinC.Name = ''External General Overhead'' AND
						MajC.Name = ''General Overhead''
					)
				) AND
				MinC.IsActive = 1
				
		) GdmMappings ON
			GGA.SnapshotId = GdmMappings.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
			GdmMappings.SnapshotId = DIM.SnapshotId AND
			DIM.GLCategorizationHierarchyCode = CONVERT(VARCHAR(32),
				LTRIM(STR(GdmMappings.GLCategorizationTypeId, 10, 0)) + '':'' + 
				LTRIM(STR(GdmMappings.GLCategorizationId, 10, 0)) + '':'' +
				LTRIM(STR(GdmMappings.GLFinancialCategoryId, 10, 0)) + '':'' +
				LTRIM(STR(GdmMappings.GLMajorCategoryId, 10, 0)) + '':'' + 
				LTRIM(STR(GdmMappings.GLMinorCategoryId, 10, 0)) + '':'' +
				LTRIM(STR(ISNULL(GGA.GLGlobalAccountId, 0), 10, 0)))

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GlobalGLCategorizationMapping(SnapshotId, GlGlobalAccountCode, GLMajorCategoryId, GLMinorCategoryId)

		/*  ----------------------------------------------------------------------------------------------------------------------------------------
			Local Payroll Categorization Mappings

			The #LocalPayrollGLCategorizationMapping table below is used to determine the local GLCategorizationHierchy Codes.
			The table is pivoted (i.e. each of the GLCategorizationHierchy Codes for each GLCategorization appear as a separate column for each
				ActivityType-FunctionalDepartment combination)so that it only joins to the #ProfitabilityActual table below once.
			The Businss Logic for how Local Categorizations can be found at GR Change Control 21 [3.4.3.3]		
		*/

	CREATE TABLE #LocalPayrollGLCategorizationMapping
	(
		FunctionalDepartmentId INT NULL,
		ActivityTypeId INT NULL,
		PayrollTypeId INT NULL,
		GlobalGLMinorCategoryId INT NULL,
		SnapshotId INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL
	)
	INSERT INTO #LocalPayrollGLCategorizationMapping(
		FunctionalDepartmentId,
		ActivityTypeId,
		PayrollTypeId,
		GlobalGLMinorCategoryId,
		SnapshotId,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.FunctionalDepartmentId,
		PivotTable.ActivityTypeId,
		PivotTable.PayrollTypeId,
		PivotTable.GLMinorCategoryId,
		PivotTable.SnapshotId,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(
			SELECT DISTINCT
				FD.FunctionalDepartmentId,
				AType.ActivityTypeId,
				PPPGA.PayrollTypeId,
				MinCa.GLMinorCategoryId,
				PPPGA.SnapshotId,
				GC.Name AS GLCategorizationName,
				ISNULL(DIM.GLCategorizationHierarchyKey, UnknownDIM.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey
			FROM
				Gdm.SnapshotPropertyPayrollPropertyGLAccount PPPGA

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(PPPGA.ActivityTypeId, 0) = CASE WHEN PPPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					PPPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1

				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(PPPGA.FunctionalDepartmentId, 0) = CASE WHEN PPPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					PPPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLMinorCategory MinCa ON
					MinCa.GLMinorCategoryId IN (SELECT GLMinorCategoryId FROM #PayrollGlobalMappings) AND
					ISNULL(PPPGA.GLMinorCategoryId, 0) = CASE WHEN PPPGA.GLMinorCategoryId IS NULL THEN 0 ELSE MinCa.GLMinorCategoryId END AND
					PPPGA.SnapshotId = MinCa.SnapshotId AND
					MinCa.IsActive = 1

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					PPPGA.GLCategorizationId = GC.GLCategorizationId AND
					PPPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					PPPGA.PropertyGLAccountId = GA.GLAccountId AND
					PPPGA.SnapshotId = GA.SnapshotID AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount 
						local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyPayrollPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					PPPGA.SnapshotId = GGA.SnapshotId AND
					GGA.GLGlobalAccountId = 
						CASE 
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GA.GLGlobalAccountId
							ELSE
								PPPGA.GLGlobalAccountId
						END AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
					PPPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId 

				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.GLMinorCategoryId =
						CASE 
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END	AND
					MinC.IsActive = 1	

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId  = FinC.GLFinancialCategoryId AND
					MajC.SnapshotId = FinC.SnapshotId AND
					GC.GLCategorizationId  = FinC.GLCategorizationId

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					FinC.SnapshotId = DIM.SnapshotId AND
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId ) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))
				
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownDIM ON
					UnknownDIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						'':-1:-1:-1:'' + CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					PPPGA.SnapshotId = UnknownDIM.SnapshotId
			WHERE
				ISNULL(PPPGA.IsActive, 1) = 1
		) LocalMappings
		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #LocalPayrollGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId, PayrollTypeId, GlobalGLMinorCategoryId,	SnapshotId)

		/*
			Overhead Budget transactions are mapped differently from the Payroll transactions.
			Overhead transactions use the SnapshotPropertyOverheadPropertyGLAccount table instead of the SnapshotPropertyPayrollPropertyGLAccount
			table. They are mapped in the same way as overhead actuals except Snapshot tables are used.
			The details of the Overhead mappings can be found in Change Control 21 [3.4.3.3.3]
		*/

	CREATE TABLE #LocalOverheadGLCategorizationMapping
	(
		FunctionalDepartmentId INT NULL,
		ActivityTypeId INT NULL,
		SnapshotId INT NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL
	)
	INSERT INTO #LocalOverheadGLCategorizationMapping
	(
		FunctionalDepartmentId,
		ActivityTypeId,
		SnapshotId,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.FunctionalDepartmentId,
		PivotTable.ActivityTypeId,
		PivotTable.SnapshotId,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(
			SELECT DISTINCT
				FD.FunctionalDepartmentId,
				AType.ActivityTypeId,
				POPGA.SnapshotId,
				GC.Name as GLCategorizationName,
				ISNULL(DIM.GLCategorizationHierarchyKey, UnknownDIM.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey
			FROM
				Gdm.SnapshotPropertyOverheadPropertyGLAccount POPGA

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					POPGA.GLCategorizationId = GC.GLCategorizationId AND
					POPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(POPGA.ActivityTypeId, 0) = CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					POPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1

				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(POPGA.FunctionalDepartmentId, 0) = CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					POPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					POPGA.PropertyGLAccountId = GA.GLAccountId AND
					POPGA.SnapshotId = GA.SnapshotId AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyOverheadPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					POPGA.SnapshotId = GGA.SnapshotId AND
					GGA.GLGlobalAccountId = 
						CASE
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GA.GLGlobalAccountId
							ELSE
								POPGA.GLGlobalAccountId
						END AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
					POPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId AND
					GGA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.IsActive = 1 AND
					MinC.GLMinorCategoryId =
						CASE 
							WHEN
								GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1
							THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END 

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1 

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
					GC.GLCategorizationId  = FinC.GLCategorizationId AND
					GC.SnapshotId = FinC.SnapshotId  

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					FinC.SnapshotId = DIM.SnapshotId AND
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))
						
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownDIM ON
					UnknownDIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						''-1:-1:-1:'' + CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					POPGA.SnapshotId = UnknownDIM.SnapshotId

			WHERE
				ISNULL(POPGA.IsActive, 1) = 1

		) LocalMappings
		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #LocalOverheadGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId, SnapshotId)

END

/* ================================================================================================================================================
	8.	Map table to the #ProfitabilityBudget table with the same structure as the GrReporting.dbo.ProfitabilityBudget table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityReforecast
	(
		ImportBatchId INT NOT NULL,
		SourceName VARCHAR(50),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SourceKey INT NOT NULL,
		FunctionalDepartmentKey INT NOT NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeKey INT NOT NULL,
		PropertyFundKey INT NOT NULL,	
		AllocationRegionKey INT NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey INT NOT NULL,
		OverheadKey INT NOT NULL,
		LocalCurrencyKey INT NOT NULL,
		LocalReforecast MONEY NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		BudgetId INT NOT NULL,
		
		GlobalGLCategorizationHierarchyKey INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey INT NOT NULL,
		USFundGLCategorizationHierarchyKey INT NOT NULL,
		EUPropertyGLCategorizationHierarchyKey INT NOT NULL,
		EUFundGLCategorizationHierarchyKey INT NOT NULL,
		USDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		EUDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		ReportingGLCategorizationHierarchyKey INT NOT NULL,
		
		SourceSystemKey INT NOT NULL
	) 

	INSERT INTO #ProfitabilityReforecast 
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		PBM.ImportBatchId,
		pbm.SourceName,
		@ReforecastTypeIsTGBBUDKey,
		Budget.SnapshotId,
		DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod, 4) + ''-'' + RIGHT(pbm.ExpensePeriod, 2) + ''-01'') AS CalendarKey,
		Budget.ReforecastKey AS ReforecastKey,
		ISNULL(GrSc.SourceKey, @SourceKeyUnknown) SourceKey,
		ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) PropertyFundKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AllocationRegionKey,
		ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown) ConsolidationRegionKey, -- CC16: Consolidation Region Key
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKeyUnknown) OriginatingRegionKey,
		ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown) OverheadKey,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKeyUnknown) LocalCurrencyKey,
		pbm.BudgetAmount,
		pbm.ReferenceCode,
		pbm.BudgetId,

		COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey), -- GlobalGLCategorizationHierarchyKey
			/*
				For local categorizations, if it is an overhead transaction, it maps to the #LocalOverheadGLCategorizationMapping table. If it
				is a payroll budget record, it maps to the #LocalPayrollGLCategorizationMapping table.
				THe Global Account Code is used to determine if a transaction is an overhead transaction or not. It will have a Global Account
				code if it''s an overhead transaction. If it is a payroll transaction, it will have a placeholder(''N/A'') as the Global Account.
			*/
		COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey), -- USPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey), -- USFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey), -- EUPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey), -- EUFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey), -- USDevelopmentGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown), -- EUDevelopmentGLCategorizationHierarchyKey
		/*
			The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
			when a local report is generated.
		*/

		CASE
			WHEN
				ReportingGC.GLCategorizationId IS NOT NULL
			THEN
				CASE
					WHEN
						ReportingGC.Name = ''US Property'' 
					THEN
						COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''US Fund'' 
					THEN
						COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''EU Property'' 
					THEN
						COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''EU Fund'' 
					THEN
						COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''US Development'' 
					THEN
						COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''EU Development'' 
					THEN
						COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					WHEN
						ReportingGC.Name = ''Global''
					THEN
						COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
					ELSE
						@GLCategorizationHierarchyKeyUnknown
				END
			ELSE
				@GLCategorizationHierarchyKeyUnknown
		END, --  ReportingGLCategorizationHierarchyKey
		
		SSystem.SourceSystemKey
	FROM
		#ProfitabilityPayrollMapping pbm

		INNER JOIN #NewBudgets Budget on
			Budget.BudgetId = pbm.BudgetId 

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			Budget.SnapshotId = SShot.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			pbm.SourceCode = GrSc.SourceCode 

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			pbm.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = ''TapasGlobalBudgeting''

		--Parent Level (No job code for payroll)
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
			GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +'':%'' AND
			SShot.LastSyncDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
			GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode 

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
			pbm.ActivityTypeId = GrAt.ActivityTypeId AND
			Budget.SnapshotId = GrAt.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
			--GC :: Change Control 1
			GrOh.OverheadCode =
				CASE
					WHEN
						pbm.FeeOrExpense = ''Overhead''
					THEN
						''ALLOC'' 
					WHEN
						GrAt.ActivityTypeCode = ''CORPOH''
					THEN
						''UNALLOC'' 
					ELSE
						''N/A''
				END	

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
			pbm.PropertyFundId = GrPf.PropertyFundId AND
			Budget.SnapshotId = GrPf.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
			pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			Budget.SnapshotId = ASR.SnapshotId AND
			ASR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
			ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
			Budget.SnapshotId = GrAr.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion CSR ON
			pbm.ConsolidationSubRegionGlobalRegionId = CSR.GlobalRegionId AND
			CSR.IsConsolidationRegion = 1 AND
			Budget.SnapshotId = CSR.SnapshotId AND
			CSR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
			CSR.GlobalRegionId = GrCr.GlobalRegionId AND
			Budget.SnapshotId = GrCr.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionCorporateEntity ORCE ON
			Budget.SnapshotId  = ORCE.SnapshotId AND
			LTRIM(RTRIM(pbm.OriginatingRegionCode)) = ORCE.CorporateEntityCode AND
			pbm.OriginatingRegionSourceCode = ORCE.SourceCode

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD ON
			Budget.SnapshotId = ORPD.SnapshotId	AND
			LTRIM(RTRIM(pbm.OriginatingRegionCode)) = ORPD.PropertyDepartmentCode AND
			pbm.OriginatingRegionSourceCode = ORPD.SourceCode

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
			ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) = GrOr.GlobalRegionId AND
			Budget.SnapshotId = GrOr.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
			pbm.LocalCurrencyCode = GrCu.CurrencyCode

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategoryPayrollType MCPT ON
			pbm.MinorGlAccountCategoryId = MCPT.GLMinorCategoryId AND
			Budget.SnapshotId = MCPT.SnapshotId

		LEFT OUTER JOIN #GlobalGLCategorizationMapping GlobalMapping ON
			Budget.SnapshotId = GlobalMapping.SnapshotId AND
			pbm.GlobalGlAccountCode  = GlobalMapping.GlGlobalAccountCode AND
			pbm.MinorGlAccountCategoryId = GlobalMapping.GLMinorCategoryId AND
			pbm.MajorGlAccountCategoryId = GlobalMapping.GLMajorCategoryId

		LEFT OUTER JOIN #LocalPayrollGLCategorizationMapping LocalPayrollMapping ON
			pbm.FunctionalDepartmentId = LocalPayrollMapping.FunctionalDepartmentId AND
			pbm.ActivityTypeId  = LocalPayrollMapping.ActivityTypeId AND
			MCPT.PayrollTypeId  = LocalPayrollMapping.PayrollTypeId AND
			pbm.MinorGlAccountCategoryId = LocalPayrollMapping.GlobalGLMinorCategoryId AND
			Budget.SnapshotId = LocalPayrollMapping.SnapshotId AND
			pbm.IsCorporateOverhead = 0

		LEFT OUTER JOIN #LocalOverheadGLCategorizationMapping LocalOverheadMapping ON
			pbm.FunctionalDepartmentId  = LocalOverheadMapping.FunctionalDepartmentId AND
			pbm.ActivityTypeId = LocalOverheadMapping.ActivityTypeId AND
			Budget.SnapshotId = LocalOverheadMapping.SnapshotId AND
			pbm.IsCorporateOverhead = 1

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownMapping ON
			Budget.SnapshotId  = UnknownMapping.SnapshotId AND
			pbm.GlobalGlAccountCode = UnknownMapping.GLAccountCode AND
			UnknownMapping.GLCategorizationName = ''Global'' AND
			UnknownMapping.GLMajorCategoryName = ''UNKNOWN''

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			Budget.SnapshotId  = PF.SnapshotID AND
			pbm.PropertyFundId = PF.PropertyFundId  

		LEFT OUTER JOIN Gdm.SnapshotReportingCategorization RC ON
			Budget.SnapshotId  = RC.SnapshotId AND
			pbm.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId  

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization ReportingGC ON
			RC.SnapshotId = ReportingGC.SnapshotId AND
			RC.GLCategorizationId = ReportingGC.GLCategorizationId




	PRINT ''Completed inserting budget portions into #ProfitabilityReforecast:''+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ================================================================================================================================================
	9.	Insert Actuals from the Budget Profitability Actual table in GBS
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityActualSource
	(
		ImportBatchId INT NOT NULL,
		SourceName VARCHAR(50),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SourceKey INT NOT NULL,
		FunctionalDepartmentKey INT NOT NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeKey INT NOT NULL,
		PropertyFundKey INT NOT NULL,
		AllocationRegionKey INT NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey INT NOT NULL,
		OverheadKey INT NOT NULL,
		LocalCurrencyKey INT NOT NULL,
		LocalReforecast MONEY NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		BudgetId INT NOT NULL,
		
		GlobalGLCategorizationHierarchyKey INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey INT NOT NULL,
		USFundGLCategorizationHierarchyKey INT NOT NULL,
		EUPropertyGLCategorizationHierarchyKey INT NOT NULL,
		EUFundGLCategorizationHierarchyKey INT NOT NULL,
		USDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		EUDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		ReportingGLCategorizationHierarchyKey INT NOT NULL,
		
		SourceSystemKey INT NOT NULL
	)
	INSERT INTO #ProfitabilityActualSource
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT  
		BPA.ImportBatchId AS ImportBatchId,
		''Actuals'' as SourceName,
		@ReforecastTypeIsTGBACTKey as BudgetReforecastTypeKey,
		GBSBudget.SnapshotId,
		DATEDIFF(dd, ''1900-01-01'', LEFT(BPA.Period,4)+''-''+RIGHT(BPA.Period,2)+''-01'') AS CalendarKey,
		GBSBudget.ReforecastKey AS ReforecastKey,
		ISNULL(GrSc.SourceKey,  @SourceKeyUnknown) SourceKey,
		COALESCE(FDJobCode.FunctionalDepartmentKey, GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) AS FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) PropertyFundKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AllocationRegionKey,
		ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown) ConsolidationRegionKey, -- CC16: ConsolidationRegionKey
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKeyUnknown)OriginatingRegionKey,
		ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown)OverheadKey,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKeyUnknown) LocalCurrencyKey,	
		BPA.Amount AS LocalReforecast,
	    (
			''TGB:GBSBudgetId='' + LTRIM(RTRIM(STR(GBSBudget.BudgetId))) +
			''&BudgetProfitabilityActualId='' + LTRIM(RTRIM(STR(bpa.BudgetProfitabilityActualId))) +
			''&IsGBS='' + LTRIM(RTRIM(STR(BPA.IsGBS))) +
			''&SnapshotId='' + LTRIM(RTRIM(STR(GBSBudget.SnapshotId)))
		) AS ReferenceCode, -- ReferenceCode
		GBSBudget.BudgetId,
		COALESCE(GlobalMapping.GLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey), -- GlobalGLCategorizationHierarchyKey
			/*
				For local categorizations, if it is an overhead transaction, it maps to the #LocalOverheadGLCategorizationMapping table. If it
				is a payroll budget record, it maps to the #LocalPayrollGLCategorizationMapping table.
				THe Global Account Code is used to determine if a transaction is an overhead transaction or not. It will have a Global Account
				code if it''s an overhead transaction. If it is a payroll transaction, it will have a placeholder(''N/A'') as the Global Account.
			*/
		COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey), -- USPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey), -- USFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey), -- EUPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey), -- EUFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey), -- USDevelopmentGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown), -- EUDevelopmentGLCategorizationHierarchyKey
		/*
			The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
			when a local report is generated.
		*/
		CASE
			WHEN
				ReportingGC.GLCategorizationId IS NOT NULL
			THEN
				CASE
					WHEN
						ReportingGC.Name = ''US Property''
					THEN
						COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''US Fund'' 
					THEN
						COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''EU Property'' 
					THEN
						COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''EU Fund'' 
					THEN
						COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''US Development'' 
					THEN
						COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
					WHEN
						ReportingGC.Name = ''EU Development'' 
					THEN
						COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					WHEN
						ReportingGC.Name = ''Global''
					THEN
						COALESCE(GlobalMapping.GLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
					ELSE
						@GLCategorizationHierarchyKeyUnknown
				END
			ELSE
				@GLCategorizationHierarchyKeyUnknown
		END, --  ReportingGLCategorizationHierarchyKey
		
		SSystem.SourceSystemKey
	FROM
		GBS.BudgetProfitabilityActual BPA

		INNER JOIN  #GBSBudgets GBSBudget ON 
			BPA.BudgetId = GBSBudget.BudgetId AND 
			GBSBudget.MustImportAllActualsIntoWarehouse = 1 AND
			BPA.ImportBatchId = GBSBudget.ImportBatchId 
		
		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			GBSBudget.SnapshotId = SShot.SnapshotId

		LEFT OUTER JOIN GBS.OverheadType OHT ON
			BPA.OverheadTypeId = OHT.OverheadTypeId  AND
			GBSBudget.ImportBatchId = OHT.ImportBatchId  

		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON 
			BPA.SourceCode = GrSc.SourceCode 

		LEFT OUTER JOIN #MRIServerSource MSS ON
			BPA.SourceCode = MSS.SourceCode

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			SSystem.SourceSystemName = ''GBS'' AND
			SSystem.SourceTableName = ''BudgetProfitabilityActual''
		
		-- FunctionalDepartmentCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON
			BPA.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentKey,
				FunctionalDepartmentCode,
				FunctionalDepartmentName,
				SubFunctionalDepartmentCode,
				SubFunctionalDepartmentName,
				StartDate,
				EndDate
			FROM
				GrReporting.dbo.FunctionalDepartment
			WHERE
				FunctionalDepartmentCode <> SubFunctionalDepartmentCode
			
		) FDJobCode ON
			FD.GlobalCode = FDJobCode.SubFunctionalDepartmentCode AND
			FD.GlobalCode = FDJobCode.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN FDJobCode.StartDate AND FDJobCode.EndDate

		-- Parent Level
		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentKey,
				FunctionalDepartmentCode,
				FunctionalDepartmentName,
				SubFunctionalDepartmentCode,
				SubFunctionalDepartmentName,
				StartDate,
				EndDate
			FROM
				GrReporting.dbo.FunctionalDepartment
			WHERE
				SubFunctionalDepartmentCode = FunctionalDepartmentCode
		) GrFdm ON
			FD.GlobalCode = GrFdm.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate

		LEFT OUTER JOIN  Gdm.SnapshotPropertyFund PF ON
			BPA.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			GBSBudget.SnapshotId = PF.SnapshotId AND
			PF.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
			PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND 
			GBSBudget.SnapshotId = ASR.SnapshotId AND
			ASR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
			ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
			GBSBudget.SnapshotId = GrAr.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRCD.CorporateDepartmentCode)) AND
			BPA.SourceCode = CRCD.SourceCode AND
			GBSBudget.SnapshotId = CRCD.SnapshotId
			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRPE.PropertyEntityCode)) AND
			MSS.MappingSourceCode = CRPE.SourceCode AND
			GBSBudget.SnapshotId = CRPE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion CSR ON
			ISNULL(CRCD.GlobalRegionId, CRPE.GlobalRegionId) = CSR.GlobalRegionId AND
			GBSBudget.SnapshotId = CSR.SnapshotId AND
			CSR.IsConsolidationRegion = 1 AND
			CSR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16: ConsolidationRegions
			CSR.GlobalRegionId = GrCr.GlobalRegionId AND
			GBSBudget.SnapshotId = GrCr.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON	
			PF.PropertyFundId = GrPf.PropertyFundId  AND
			PF.SnapshotId = Grpf.SnapshotId       

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
			BPA.ActivityTypeId = GrAt.ActivityTypeId AND
			GBSBudget.SnapshotId = GrAt.SnapshotId 		

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			 GrRi.ReimbursableCode = CASE WHEN BPA.IsTsCost = 0 THEN ''YES'' ELSE ''NO'' END

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON 
			BPA.OriginatingSubRegionGlobalRegionId = GrOr.GlobalRegionId and
			GBSBudget.SnapshotId = GrOr.SnapshotId  

		LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
			ISNULL(OHT.Code, ''N/A'') = GrOh.OverheadCode

		LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
			BPA.CurrencyCode = GrCu.CurrencyCode	

		LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
			GBSBudget.SnapshotId = GGAC.SnapshotId AND
			BPA.GLGlobalAccountId  = GGAC.GLGlobalAccountId AND
			GGAC.GLCategorizationId = 233 -- Limit to the Global Categorization

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
			MinC.GLMinorCategoryId = CASE WHEN BPA.IsDirectCost = 1 THEN GGAC.DirectGLMinorCategoryId ELSE GGAC.IndirectGLMinorCategoryId END AND
			GBSBudget.SnapshotId = MinC.SnapshotId AND
			MinC.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
			GBSBudget.SnapshotId = MajC.SnapshotId AND
			MajC.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
			MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
			MajC.SnapshotId = FinC.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization GC ON
			FinC.GLCategorizationId = GC.GLCategorizationId AND
			FinC.SnapshotId = GC.SnapshotId 

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalMapping ON
			GC.SnapshotId = GlobalMapping.SnapshotId AND
			GlobalMapping.GLCategorizationHierarchyCode = 
				CONVERT(VARCHAR(32),
					LTRIM(STR(GC.GLCategorizationTypeId, 10, 0)) + '':'' + 
					LTRIM(STR(GC.GLCategorizationId, 10, 0)) + '':'' +
					LTRIM(STR(FinC.GLFinancialCategoryId, 10, 0)) + '':'' +
					LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
					LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' +
					LTRIM(STR(ISNULL(BPA.GLGlobalAccountId, 0), 10, 0)))

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategoryPayrollType MCPT ON
			MinC.GLMinorCategoryId = MCPT.GLMinorCategoryId AND
			MinC.SnapshotId = MCPT.SnapshotId
						
		LEFT OUTER JOIN  #LocalPayrollGLCategorizationMapping LocalPayrollMapping ON
			BPA.FunctionalDepartmentId = LocalPayrollMapping.FunctionalDepartmentId AND
			BPA.ActivityTypeId = LocalPayrollMapping.ActivityTypeId AND
			MCPT.PayrollTypeId = LocalPayrollMapping.PayrollTypeId AND
			MinC.GLMinorCategoryId = LocalPayrollMapping.GlobalGLMinorCategoryId AND
			GBSBudget.SnapshotId = LocalPayrollMapping.SnapshotId AND
			ISNULL(OHT.Code, '''') <> ''ALLOC''

		LEFT OUTER JOIN #LocalOverheadGLCategorizationMapping LocalOverheadMapping ON
			BPA.FunctionalDepartmentId = LocalOverheadMapping.FunctionalDepartmentId AND
			BPA.ActivityTypeId = LocalOverheadMapping.ActivityTypeId AND
			GBSBudget.SnapshotId = LocalOverheadMapping.SnapshotId AND
			OHT.Code = ''ALLOC''

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownMapping ON
			GBSBudget.SnapshotId = UnknownMapping.SnapshotId AND
			UnknownMapping.GLCategorizationHierarchyCode = ''1:233:-1:-1:-1:'' +  LTRIM(STR(ISNULL(BPA.GLGlobalAccountId, 0), 10, 0))

		LEFT OUTER JOIN Gdm.SnapshotReportingCategorization RC ON
			GBSBudget.SnapshotId = RC.SnapshotId AND
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId 

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization ReportingGC ON
			RC.SnapshotId = ReportingGC.SnapshotId AND
			RC.GLCategorizationId = ReportingGC.GLCategorizationId AND
			ReportingGC.IsActive = 1
	WHERE 
		BPA.IsDeleted = 0 AND
		BPA.Period < GBSBudget.FirstProjectedPeriod AND
		MajC.Name in (''Salaries/Taxes/Benefits'', ''General Overhead'') AND -- Only want Actuals for Payroll and General Overhead transactions
		(OHT.Code IS NULL OR OHT.Code = ''ALLOC'')

	PRINT ''Completed inserting Actuals into #ProfitabilityActualSource:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilityReforecast 
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		ReforecastKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	FROM
		#ProfitabilityActualSource

	PRINT ''Completed inserting Actuals portions into #ProfitabilityReforecast:''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
	CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

	PRINT ''Completed creating indexes on #OriginatingRegionMapping''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	-- Remove existing data for modified budget projects
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetsToImport
	(
		BudgetId INT NOT NULL
	)

	INSERT INTO #BudgetsToImport
	(
		BudgetId
	)
	SELECT DISTINCT 
		BudgetId
	FROM
		#NewBudgets
	UNION ALL
	SELECT DISTINCT 
		BudgetId
	FROM
		#GBSBudgets	

END

/* ================================================================================================================================================
	10.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
   ============================================================================================================================================= */
BEGIN

	--- Smoke All OLD TAPAS Unknowns as were about to insert new ones (Reforecast Budget + Reforecast Actuals from [dbo].[ProfitabilityBudgetUnknowns])
	SET @StartTime = GETDATE()

	DELETE 
		PRU
	FROM
		dbo.ProfitabilityReforecastUnknowns PRU
	WHERE
	  PRU.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey)

	PRINT (''Rows Deleted that was OLD from ProfitabilitReforecastUnknowns: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-------------

	SET @StartTime = GETDATE()

	INSERT INTO dbo.ProfitabilityReforecastUnknowns
	(
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
			
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId,
		
		SourceSystemKey
	)
	SELECT
		PR.ImportBatchId,
		PR.CalendarKey,
		PR.SourceKey,
		PR.FunctionalDepartmentKey,
		PR.ReimbursableKey,
		PR.ActivityTypeKey,
		PR.PropertyFundKey,
		PR.AllocationRegionKey,
		PR.ConsolidationRegionKey,
		PR.OriginatingRegionKey,
		PR.LocalCurrencyKey,
		PR.LocalReforecast,
		PR.ReferenceCode,
		PR.GlobalGLCategorizationHierarchyKey,
		PR.USPropertyGLCategorizationHierarchyKey,
		PR.USFundGLCategorizationHierarchyKey,
		PR.EUPropertyGLCategorizationHierarchyKey,
		PR.EUFundGLCategorizationHierarchyKey,
		PR.USDevelopmentGLCategorizationHierarchyKey,
		PR.EUDevelopmentGLCategorizationHierarchyKey,
		PR.ReportingGLCategorizationHierarchyKey,
		PR.BudgetId,
		PR.OverheadKey,
		@NormalFeeAdjustmentKey,
		BudgetReforecastTypeKey,
		AB.SnapshotId,
		
		PR.SourceSystemKey
	FROM 
		#ProfitabilityReforecast PR

		INNER JOIN #AllBudgets AB ON
			PR.BudgetId = AB.BudgetId AND
			PR.SnapshotId = AB.SnapshotId
	WHERE
		PR.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey) AND
		(
			@FunctionalDepartmentKeyUnknown = PR.FunctionalDepartmentKey OR
			@ReimbursableKeyUnknown = PR.ReimbursableKey OR
			@ActivityTypeKeyUnknown = PR.ActivityTypeKey OR
			@PropertyFundKeyUnknown = PR.PropertyFundKey OR
			@AllocationRegionKeyUnknown = PR.AllocationRegionKey OR
			@OriginatingRegionKeyUnknown = PR.OriginatingRegionKey OR
			@LocalCurrencyKeyUnknown = PR.LocalCurrencyKey
		)

	PRINT (''Rows inserted into ProfitabilitReforecastUnknowns: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			BUILD Unknown Budgets - Get all the budgets for Budget rows that have unknowns
		*/
		
	SET @StartTime = GETDATE()

	SELECT DISTINCT
		B.SnapshotId, 
		B.BudgetId,
		B.ImportKey,
		PRU.BudgetReforecastTypeKey	
	INTO
	   #BudgetsWithUnknownBudgets
	FROM 
	   dbo.ProfitabilityReforecastUnknowns  PRU

	   INNER JOIN #AllBudgets B ON
			B.SnapshotId = PRU.SnapshotId AND
			B.BudgetId = PRU.BudgetId 
	WHERE
	  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsTGBBudKey

	DECLARE @RowsToDeleteFromPRBudgets INT = @@rowcount

	PRINT (''Rows inserted into #BudgetsWithUnknownBudgets: '' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRBudgets))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			BUILD Unknown Actuals - Get all the budgets for Budget rows that have unknowns
		*/
		
	SELECT DISTINCT
		B.SnapshotId, 
		B.BudgetId,
		B.ImportKey,
		PRU.BudgetReforecastTypeKey
	INTO
	   #BudgetsWithUnknownActuals
	FROM
	   dbo.ProfitabilityReforecastUnknowns  PRU

	   INNER JOIN #AllBudgets B ON
			B.SnapshotId = PRU.SnapshotId AND
			B.BudgetId = PRU.BudgetId 
	WHERE
	  PRU.BudgetReforecastTypeKey = @ReforecastTypeIsTGBActKey

	DECLARE @RowsToDeleteFromPRActuals INT = @@rowcount

	PRINT (''Rows inserted into #BudgetsWithUnknownActuals: '' + CONVERT(VARCHAR(10),@RowsToDeleteFromPRActuals))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*
		BUILD ALL Unknown Budgets - Now merge them into one unique budget set and these are all budgets that need deleting
	*/

	SET @StartTime = GETDATE()

	SELECT 
	   BUA.SnapshotId, 
	   BUA.BudgetId,
	   BUA.ImportKey
	INTO 
		#AllUnknownBudgets
	FROM 
		#BudgetsWithUnknownActuals BUA

		INNER JOIN #BudgetsWithUnknownBudgets BUB ON
			BUB.BudgetId = BUA.BudgetId AND
			BUB.SnapshotId = BUA.SnapshotId AND
			BUB.ImportKey = BUA.ImportKey		
    
	PRINT (''Rows INSERTED INTO #AllUnknownBudgets that have Unknowns: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	INSERT INTO @ImportErrorTable (Error) SELECT ''Unknowns''
	
	IF (@RowsToDeleteFromPRBudgets > 0)
	BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT ''Unknown Budgets''
	END
	IF (@RowsToDeleteFromPRActuals > 0)
	BEGIN
	    INSERT INTO @ImportErrorTable (Error) SELECT ''Unknown Actuals''
	END	

END

/* ===============================================================================================================================================
	11.	Insert records into the GrReporting.dbo.ProfitabilityReforecast fact table.
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #SummaryOfChanges
	(
		Change VARCHAR(20)
	)

	MERGE
		GrReporting.dbo.ProfitabilityReforecast FACT
	USING
		#ProfitabilityReforecast AS SRC ON
			FACT.ReferenceCode = SRC.ReferenceCode
	WHEN
		MATCHED AND
		(
			FACT.CalendarKey <> SRC.CalendarKey OR
			FACT.SourceKey <> SRC.SourceKey OR
			FACT.FunctionalDepartmentKey <> SRC.FunctionalDepartmentKey OR
			FACT.ReimbursableKey <> SRC.ReimbursableKey OR
			FACT.ActivityTypeKey <> SRC.ActivityTypeKey OR
			FACT.PropertyFundKey <> SRC.PropertyFundKey OR
			FACT.AllocationRegionKey <> SRC.AllocationRegionKey OR
			FACT.OriginatingRegionKey <> SRC.OriginatingRegionKey OR
			FACT.LocalCurrencyKey <> SRC.LocalCurrencyKey OR
			FACT.LocalReforecast <> SRC.LocalReforecast OR
			FACT.OverheadKey <> SRC.OverheadKey OR
			FACT.FeeAdjustmentKey <> @FeeAdjustmentKey OR
			FACT.SnapshotId <> SRC.SnapshotId OR
			FACT.ReforecastKey <> SRC.ReforecastKey OR
			FACT.ConsolidationRegionKey <> SRC.ConsolidationRegionKey OR
			ISNULL(FACT.GlobalGLCategorizationHierarchyKey, '''') <> SRC.GlobalGLCategorizationHierarchyKey OR
			ISNULL(FACT.EUDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.EUDevelopmentGLCategorizationHierarchyKey OR
			ISNULL(FACT.EUPropertyGLCategorizationHierarchyKey, '''') <> SRC.EUPropertyGLCategorizationHierarchyKey OR
			ISNULL(FACT.EUFundGLCategorizationHierarchyKey, '''') <> SRC.EUFundGLCategorizationHierarchyKey OR
			ISNULL(FACT.USDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.USDevelopmentGLCategorizationHierarchyKey OR
			ISNULL(FACT.USPropertyGLCategorizationHierarchyKey, '''') <> SRC.USPropertyGLCategorizationHierarchyKey OR
			ISNULL(FACT.USFundGLCategorizationHierarchyKey, '''') <> SRC.USFundGLCategorizationHierarchyKey OR
			ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '''') <> SRC.ReportingGLCategorizationHierarchyKey OR
			
			ISNULL(FACT.SourceSystemKey, '''') <> SRC.SourceSystemKey
		)
	THEN
		UPDATE
		SET
			FACT.CalendarKey = SRC.CalendarKey,
			FACT.SourceKey = SRC.SourceKey,
			FACT.FunctionalDepartmentKey = SRC.FunctionalDepartmentKey,
			FACT.ReimbursableKey = SRC.ReimbursableKey,
			FACT.ActivityTypeKey = SRC.ActivityTypeKey,
			FACT.PropertyFundKey = SRC.PropertyFundKey,
			FACT.AllocationRegionKey = SRC.AllocationRegionKey,
			FACT.OriginatingRegionKey = SRC.OriginatingRegionKey,
			FACT.LocalCurrencyKey = SRC.LocalCurrencyKey,
			FACT.LocalReforecast = SRC.LocalReforecast,
			FACT.OverheadKey = SRC.OverheadKey,
			FACT.FeeAdjustmentKey = @FeeAdjustmentKey,
			FACT.SnapshotId = SRC.SnapshotId,
			FACT.ReforecastKey = SRC.ReforecastKey,
			FACT.ConsolidationRegionKey = SRC.ConsolidationRegionKey,
			FACT.GlobalGLCategorizationHierarchyKey = SRC.GlobalGLCategorizationHierarchyKey,
			FACT.EUDevelopmentGLCategorizationHierarchyKey = SRC.EUDevelopmentGLCategorizationHierarchyKey,
			FACT.EUPropertyGLCategorizationHierarchyKey = SRC.EUPropertyGLCategorizationHierarchyKey,
			FACT.EUFundGLCategorizationHierarchyKey = SRC.EUFundGLCategorizationHierarchyKey,
			FACT.USDevelopmentGLCategorizationHierarchyKey = SRC.USDevelopmentGLCategorizationHierarchyKey,
			FACT.USPropertyGLCategorizationHierarchyKey = SRC.USPropertyGLCategorizationHierarchyKey,
			FACT.USFundGLCategorizationHierarchyKey = SRC.USFundGLCategorizationHierarchyKey,
			FACT.ReportingGLCategorizationHierarchyKey = SRC.ReportingGLCategorizationHierarchyKey,
			FACT.UpdatedDate = @StartTime,
			FACT.SourceSystemKey = SRC.SourceSystemKey
	WHEN
		NOT MATCHED BY TARGET
	THEN
		INSERT
		(
			SnapshotId,
			BudgetReforecastTypeKey,
			ReforecastKey,
			CalendarKey,
			SourceKey,
			FunctionalDepartmentKey,
			ReimbursableKey,
			ActivityTypeKey,
			PropertyFundKey,
			AllocationRegionKey,
			ConsolidationRegionKey,
			OriginatingRegionKey,
			OverheadKey,
			FeeAdjustmentKey,
			LocalCurrencyKey,
			LocalReforecast,
			ReferenceCode,
			BudgetId,
			
			GlobalGLCategorizationHierarchyKey,
			USPropertyGLCategorizationHierarchyKey,
			USFundGLCategorizationHierarchyKey,
			EUPropertyGLCategorizationHierarchyKey,
			EUFundGLCategorizationHierarchyKey,
			USDevelopmentGLCategorizationHierarchyKey,
			EUDevelopmentGLCategorizationHierarchyKey,
			ReportingGLCategorizationHierarchyKey,
			InsertedDate,
			UpdatedDate,
			
			SourceSystemKey
		)
		VALUES
		(
			SRC.SnapshotId,
			SRC.BudgetReforecastTypeKey,
			SRC.ReforecastKey,
			SRC.CalendarKey,
			SRC.SourceKey,
			SRC.FunctionalDepartmentKey,
			SRC.ReimbursableKey,
			SRC.ActivityTypeKey,
			SRC.PropertyFundKey,
			SRC.AllocationRegionKey,
			SRC.ConsolidationRegionKey,
			SRC.OriginatingRegionKey,
			SRC.OverheadKey,
			@FeeAdjustmentKey,
			SRC.LocalCurrencyKey,
			SRC.LocalReforecast,
			SRC.ReferenceCode,
			SRC.BudgetId,
			
			SRC.GlobalGLCategorizationHierarchyKey,
			SRC.USPropertyGLCategorizationHierarchyKey,
			SRC.USFundGLCategorizationHierarchyKey,
			SRC.EUPropertyGLCategorizationHierarchyKey,
			SRC.EUFundGLCategorizationHierarchyKey,
			SRC.USDevelopmentGLCategorizationHierarchyKey,
			SRC.EUDevelopmentGLCategorizationHierarchyKey,
			SRC.ReportingGLCategorizationHierarchyKey,
			@StartTime,
			@StartTime,
			
			SRC.SourceSystemKey
		)
	WHEN
		NOT MATCHED BY SOURCE AND
		FACT.BudgetId IN (SELECT BudgetId FROM #AllBudgets) AND
		FACT.BudgetReforecastTypeKey IN (@ReforecastTypeIsTGBBUDKey, @ReforecastTypeIsTGBACTKey) THEN
		DELETE
	OUTPUT
			$action
		INTO
			#SummaryOfChanges;

	CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

	DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''INSERT'')
	DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''UPDATE'')
	DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''DELETE'')

	PRINT ''Rows added to ProfitabilityReforecast: ''+ CONVERT(char(10), @InsertedRows)
	PRINT ''Rows updated in ProfitabilityReforecast: ''+ CONVERT(char(10),@UpdatedRows)
	PRINT ''Rows deleted from ProfitabilityReforecast: ''+ CONVERT(char(10),@DeletedRows)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
   12. Mark budgets as being successfully processed into the warehouse
   ============================================================================================================================================= */
BEGIN

	DECLARE @ImportErrorText VARCHAR(500)
	SELECT @ImportErrorText = COALESCE(@ImportErrorText + '', '', '''') + Error FROM @ImportErrorTable

	UPDATE
		BTP
	SET
		--- Note Slight reverse logic from originally, original it looked if there are anything left in the temp table, now it looks:
		--- IS THERE ANYTHING THAT WAS UNKNOWN for Budgets and Actuals Seperately
		BTP.ReforecastBudgetsProcessedIntoWarehouse = CASE WHEN BWUB.BudgetId IS NULL THEN 1 ELSE 0 END, -- 0 if import fails, 1 if import succeeds
		BTP.ReforecastActualsProcessedIntoWarehouse = CASE WHEN BWUA.BudgetId IS NULL THEN 1 ELSE 0 END, -- 0 if import fails, 1 if import succeeds
		ReasonForFailure = @ImportErrorText,
		BTP.DateBudgetProcessedIntoWarehouse = GETDATE() -- date that the buget import either failed or succeeded (depending on 0 or 1 above)
	FROM
		dbo.BudgetsToProcess BTP

		INNER JOIN #BudgetsToProcess BTPT ON
			BTP.BudgetsToProcessId = BTPT.BudgetsToProcessId	

		LEFT OUTER JOIN #BudgetsWithUnknownBudgets BWUB ON
			BTP.BudgetId = BWUB.BudgetId 

		LEFT OUTER JOIN #BudgetsWithUnknownActuals BWUA ON
			BTP.BudgetId = BWUA.BudgetId 

	PRINT (''Rows updated from dbo.BudgetsToProcess: '' + CONVERT(VARCHAR(10),@@rowcount))

END

/* ===============================================================================================================================================
	13.	Clean up
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess 

	IF 	OBJECT_ID(''tempdb..#LastImportedGBSBudgets'') IS NOT NULL
		DROP TABLE #LastImportedGBSBudgets
			
	IF 	OBJECT_ID(''tempdb..#NewBudgets'') IS NOT NULL
		DROP TABLE #NewBudgets

	IF 	OBJECT_ID(''tempdb..#SystemSettingRegion'') IS NOT NULL
		DROP TABLE #SystemSettingRegion

	IF 	OBJECT_ID(''tempdb..#AllBudgets'') IS NOT NULL
		DROP TABLE #AllBudgets

	IF 	OBJECT_ID(''tempdb..#GBSBudgets'') IS NOT NULL
		DROP TABLE #GBSBudgets

	IF 	OBJECT_ID(''tempdb..#TaxType'') IS NOT NULL
		DROP TABLE #TaxType

	IF 	OBJECT_ID(''tempdb..#BudgetProject'') IS NOT NULL
		DROP TABLE #BudgetProject

	IF 	OBJECT_ID(''tempdb..#Region'') IS NOT NULL
		DROP TABLE #Region

	IF 	OBJECT_ID(''tempdb..#BudgetEmployee'') IS NOT NULL
		DROP TABLE #BudgetEmployee

	IF 	OBJECT_ID(''tempdb..#BudgetEmployeeFunctionalDepartment'') IS NOT NULL
		DROP TABLE #BudgetEmployeeFunctionalDepartment

	IF 	OBJECT_ID(''tempdb..#Location'') IS NOT NULL
		DROP TABLE #Location

	IF 	OBJECT_ID(''tempdb..#RegionExtended'') IS NOT NULL
		DROP TABLE #RegionExtended

	IF 	OBJECT_ID(''tempdb..#Project'') IS NOT NULL
		DROP TABLE #Project

	IF 	OBJECT_ID(''tempdb..#Department'') IS NOT NULL
		DROP TABLE #Department

	IF 	OBJECT_ID(''tempdb..#PayrollGlobalMappings'') IS NOT NULL
		DROP TABLE #PayrollGlobalMappings

	IF 	OBJECT_ID(''tempdb..#BudgetEmployeePayrollAllocation'') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocation

	IF 	OBJECT_ID(''tempdb..#BudgetEmployeePayrollAllocationDetail'') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocationDetail

	IF 	OBJECT_ID(''tempdb..#BudgetTaxType'') IS NOT NULL
		DROP TABLE #BudgetTaxType

	IF 	OBJECT_ID(''tempdb..#EmployeePayrollAllocationDetail'') IS NOT NULL
		DROP TABLE #EmployeePayrollAllocationDetail

	IF 	OBJECT_ID(''tempdb..#BudgetOverheadAllocation'') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocation

	IF 	OBJECT_ID(''tempdb..#BudgetOverheadAllocationDetail'') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocationDetail

	IF 	OBJECT_ID(''tempdb..#OverheadAllocationDetail'') IS NOT NULL
		DROP TABLE #OverheadAllocationDetail

	IF 	OBJECT_ID(''tempdb..#EffectiveFunctionalDepartment'') IS NOT NULL
		DROP TABLE #EffectiveFunctionalDepartment

	IF 	OBJECT_ID(''tempdb..#ProfitabilityPreTaxSource'') IS NOT NULL
		DROP TABLE #ProfitabilityPreTaxSource

	IF 	OBJECT_ID(''tempdb..#ProfitabilityTaxSource'') IS NOT NULL
		DROP TABLE #ProfitabilityTaxSource

	IF 	OBJECT_ID(''tempdb..#ProfitabilityOverheadSource'') IS NOT NULL
		DROP TABLE #ProfitabilityOverheadSource

	IF 	OBJECT_ID(''tempdb..#ProfitabilityPayrollMapping'') IS NOT NULL
		DROP TABLE #ProfitabilityPayrollMapping

	IF 	OBJECT_ID(''tempdb..#SnapshotGLGlobalAccount'') IS NOT NULL
		DROP TABLE #SnapshotGLGlobalAccount

	IF 	OBJECT_ID(''tempdb..#GlobalGLCategorizationMapping'') IS NOT NULL
		DROP TABLE #GlobalGLCategorizationMapping

	IF 	OBJECT_ID(''tempdb..#LocalPayrollGLCategorizationMapping'') IS NOT NULL
		DROP TABLE #LocalPayrollGLCategorizationMapping

	IF 	OBJECT_ID(''tempdb..#LocalOverheadGLCategorizationMapping'') IS NOT NULL
		DROP TABLE #LocalOverheadGLCategorizationMapping

	IF 	OBJECT_ID(''tempdb..#ProfitabilityReforecast'') IS NOT NULL
		DROP TABLE #ProfitabilityReforecast

	IF 	OBJECT_ID(''tempdb..#ProfitabilityActualSource'') IS NOT NULL
		DROP TABLE #ProfitabilityActualSource

	IF 	OBJECT_ID(''tempdb..#BudgetsToImport'') IS NOT NULL
		DROP TABLE #BudgetsToImport

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknownBudgets'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknownActuals'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownActuals

	IF 	OBJECT_ID(''tempdb..#AllUnknownBudgets'') IS NOT NULL
		DROP TABLE #AllUnknownBudgets

	IF 	OBJECT_ID(''tempdb..#AllUnknownBudgets'') IS NOT NULL
		DROP TABLE #AllUnknownBudgets
				
	PRINT ''Cleanup Completed:''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	PRINT ''ALL DONE''

END

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/***************************************************************************************************************************************
Description
	This stored procedure processes payroll original budget data and uploads it to the
	ProfitabilityBudget table in the data warehouse (GrReporting.dbo.ProfitabilityBudget). 
	The stored procedure works as follows:
	1.	Source budgets that are to be processed from the BudgetsToProcessTable
	2.	Source Budgets from TapasGlobalBudgeting.Budget table
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
	6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
	7.	Create Global and Local Categorization mapping table
	8.	Map table to the #ProfitabilityBudget table with the same structure as the GrReporting.dbo.ProfitabilityBudget table
	9.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
	10. Insert budget records into the GrReporting.dbo.ProfitabilityBudget table
	11. Mark budgets as being successfully processed into the warehouse
	12. Clean Up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-07		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
****************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]	
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyPayrollOriginalBudget''
PRINT ''####''


-- Check whether the stored procedure should be run
DECLARE @StartTime DATETIME
DECLARE @StartTime2 DATETIME
DECLARE @RowCount INT
DECLARE @ImportErrorTable TABLE (
	Error varchar(50)
);

/* ===============================================================================================================================================
  1.	Source budgets that are to be processed from the BudgetsToProcessTable
   ============================================================================================================================================= */
BEGIN
	-- If the budget is not scheduled to be run according to the SSIS configurations, the stored procedure ends.

	IF ((SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportTapasBudget'') = 0)
	BEGIN
		PRINT (''Import TapasBudget not scheduled in SSISConfigurations'')
		RETURN
	END

	CREATE TABLE #BudgetsToProcess
	(
		BudgetsToProcessId INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeName VARCHAR(50) NOT NULL,
		BudgetId INT NOT NULL,
		BudgetExchangeRateId INT NOT NULL,
		BudgetReportGroupPeriodId INT NOT NULL,
		ImportBudgetFromSourceSystem bit NOT NULL,
		IsReforecast BIT NOT NULL,
		SnapshotId INT NOT NULL,
		ImportSnapshotFromSourceSystem BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		MustImportAllActualsIntoWarehouse BIT NULL,
		OriginalBudgetProcessedIntoWarehouse SMALLINT NULL,
		ReforecastActualsProcessedIntoWarehouse SMALLINT NULL,
		ReforecastBudgetsProcessedIntoWarehouse SMALLINT NULL,
		ReasonForFailure VARCHAR(512) NULL,
		DateBudgetProcessedIntoWarehouse DATETIME NULL,
		ReforecastKey INT NOT NULL
	)

	INSERT #BudgetsToProcess
	SELECT 
		BTPC.BudgetsToProcessId,
		BTPC.ImportBatchId,
		BTPC.BudgetReforecastTypeName,
		BTPC.BudgetId,
		BTPC.BudgetExchangeRateId,
		BTPC.BudgetReportGroupPeriodId,
		BTPC.ImportBudgetFromSourceSystem,
		BTPC.IsReforecast,
		BTPC.SnapshotId,
		BTPC.ImportSnapshotFromSourceSystem,
		BTPC.InsertedDate,
		BTPC.MustImportAllActualsIntoWarehouse,
		BTPC.OriginalBudgetProcessedIntoWarehouse,
		BTPC.ReforecastActualsProcessedIntoWarehouse,
		BTPC.ReforecastBudgetsProcessedIntoWarehouse,
		BTPC.ReasonForFailure,
		BTPC.DateBudgetProcessedIntoWarehouse,
		RR.ReforecastKey
	FROM 
		dbo.BudgetsToProcess BTPC
		
		INNER JOIN
		(	
			SELECT 
				MIN(ReforecastEffectiveMonth) AS ReforecastEffectiveMonth,
				ReforecastQuarterName,
				ReforecastEffectiveYear
			FROM 		 
				Grreporting.dbo.Reforecast 	
			GROUP BY
				ReforecastQuarterName,
				ReforecastEffectiveYear
		) CRR ON
		BTPC.BudgetYear = CRR.ReforecastEffectiveYear AND
		BTPC.BudgetQuarter = CRR.ReforecastQuarterName
		
		INNER JOIN Grreporting.dbo.Reforecast RR ON
			CRR.ReforecastEffectiveMonth = RR.ReforecastEffectiveMonth  AND
			CRR.ReforecastQuarterName = RR.ReforecastQuarterName  AND
			CRR.ReforecastEffectiveYear = RR.ReforecastEffectiveYear 
	WHERE 
		BTPC.IsReforecast = 0 AND
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = ''TGB Budget/Reforecast''

	PRINT ''Completed inserting records into #BudgetsToProcess: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-- If there are no TAPAS budgets from the BudgetsToProcess table, the stored procedure ends.

	IF NOT EXISTS (SELECT 1 FROM #BudgetsToProcess)
	BEGIN
		PRINT (''*******************************************************'')
		PRINT (''	stp_IU_LoadGrProfitabiltyPayrollOriginalBudget is quitting because there are no TAPAS budgets set to be imported.'')
		PRINT (''*******************************************************'')
		RETURN
	END

	IF (@DataPriorToDate IS NULL)
	BEGIN
		SET @DataPriorToDate = 
			CONVERT
				(
					DATETIME,
					(
						SELECT 
							ConfiguredValue 
						FROM 
							dbo.SSISConfigurations 
						WHERE 
							ConfigurationFilter = ''ActualDataPriorToDate''
					)
				)
	END

END

/* ===============================================================================================================================================
	Setup Variables
   ============================================================================================================================================= */
BEGIN
	
	DECLARE 
		@SourceKey				 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN''),
		@FunctionalDepartmentKey INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN''),
		@ReimbursableKey		 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN''),
		@ActivityTypeKey		 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN''),
		@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN''),
		@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN''),
		@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN''),
		@OverheadKey			 INT = (SELECT OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = ''UNKNOWN''),
		@LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNK''),
		@NormalFeeAdjustmentKey	 INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''NORMAL''),
		@GLCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''UNKNOWN'' AND SnapshotId = 0)

	DECLARE
		@UnknownUSPropertyGLCategorizationKey		INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Property'' AND SnapshotId = 0),
		@UnknownUSFundGLCategorizationKey			INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Fund'' AND SnapshotId = 0),
		@UnknownEUPropertyGLCategorizationKey		INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Property'' AND SnapshotId = 0),
		@UnknownEUFundGLCategorizationKey			INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Fund'' AND SnapshotId = 0),
		@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Development'' AND SnapshotId = 0),
		@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''Global'' AND SnapshotId = 0)

		
	DECLARE @BudgetReforecastTypeKey INT = 
		(
			SELECT 
				BudgetReforecastTypeKey 
			FROM 
				GrReporting.dbo.BudgetReforecastType 
			WHERE 
				BudgetReforecastTypeCode = ''TGBBUD''
		)

	DECLARE @FeeAdjustmentKey INT = 
		(
			SELECT 
				FeeAdjustmentKey 
			FROM 
				GrReporting.dbo.FeeAdjustment 
			WHERE 
				FeeAdjustmentCode = ''NORMAL''
		)

END

/* ===============================================================================================================================================
	2. Source Budgets from TapasGlobalBudgeting.Budget table
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #DistinctImports
	(
		ImportBatchId INT NOT NULL
	)
	INSERT INTO #DistinctImports
	SELECT DISTINCT
		ImportBatchId
	FROM 
		#BudgetsToProcess BTP

	SET @StartTime = GETDATE()

		/*
			The #Budget table stored the budgets that are going to be processed from Tapas Global Budgeting
		*/

	CREATE TABLE #Budget(	
		SnapshotId INT NOT NULL,
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		RegionId INT NOT NULL,	
		CurrencyCode VARCHAR(3) NOT NULL,
		BudgetReportGroupId INT NOT NULL,
		BudgetReportGroupPeriod	INT NOT NULL,
		GroupStartPeriod INT NOT NULL,
		GroupEndPeriod INT NOT NULL,
		ReforecastKey INT NOT NULL
	)

	INSERT INTO #Budget
	(
		SnapshotId,	
		ImportKey,
		ImportBatchId,
		BudgetId,
		RegionId,	
		CurrencyCode,
		BudgetReportGroupId,
		BudgetReportGroupPeriod,
		GroupStartPeriod,
		GroupEndPeriod,
		ReforecastKey
		
	)
	SELECT 		
		btp.SnapshotId,
		Budget.ImportKey,
		Budget.ImportBatchId,
		Budget.BudgetId,
		Budget.RegionId,
		Budget.CurrencyCode,		
		brg.BudgetReportGroupId,
		brgp.Period AS BudgetReportGroupPeriod,
		brg.StartPeriod AS GroupStartPeriod,
		brg.EndPeriod AS GroupEndPeriod,
		BTP.ReforecastKey
	FROM
		#BudgetsToProcess btp 
		
		INNER JOIN TapasGlobalBudgeting.Budget Budget ON
			btp.BudgetId = Budget.BudgetId AND
			btp.ImportBatchId = Budget.ImportBatchId  

		INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON
			Budget.BudgetId = brgd.BudgetId AND
			Budget.ImportBatchId = brgd.ImportBatchId
			
		INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON
			brgd.BudgetReportGroupId = brg.BudgetReportGroupId AND
			brgd.ImportBatchId = brg.ImportBatchId	
		
		INNER JOIN Gdm.BudgetReportGroupPeriod brgp ON
			brg.BudgetReportGroupPeriodId = brgp.BudgetReportGroupPeriodId  
			
		INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
			brgp.ImportKey = brgpA.ImportKey

	PRINT ''Completed inserting records into #Budget: ''+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX UX_#Budget_SnapshotId_BudgetId ON #Budget (SnapshotId, BudgetId)
	PRINT ''Completed creating indexes on #Budget''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
	3.	Source records associated to the Payroll Allocation data (e.g. BudgetProject and BudgetEmployee)
   ============================================================================================================================================= */
BEGIN
	/*
		-------------------------------------------------------------------------------------------------------------------------------
		BudgetProject
		
		In TAPAS Budgeting, when a Budget is created, projects are copied from the Budget Allocation set to the BudgetProject table where
		the project is in the same source as the budget''s region and the project is set up for payroll usage.
		
		The #BudgetProject table gets all the budget projects that are associated with the budgets that will be pulled, as per code above.
		The Projects are used to determine the Property Funds which records are assigned to (either using the Corporate Department Code 
		and SourceCode combination, or the PropertyFund associated to the project if there is no Corporate Department assigned).
		The #Budget table is also used to determine the Activity Type to assign to records.
		The IsTsCost is used to determine if budgeted amounts are reimbursable or not.
		The project to be used for Overhead records is determined by the AllocateOverheadsProjectId
	*/
	
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetProject
	(
		ImportBatchId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectId INT NULL,
		PropertyFundId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(6) NULL,
		CorporateSourceCode VARCHAR(2) NULL,
		IsTsCost BIT NOT NULL,
		CanAllocateOverheads BIT NOT NULL,
		AllocateOverheadsProjectId INT NULL
	)

	INSERT INTO #BudgetProject
	(
		ImportBatchId,
		BudgetProjectId,
		BudgetId,
		ProjectId,
		PropertyFundId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		IsTsCost,
		CanAllocateOverheads,
		AllocateOverheadsProjectId
	)
	SELECT 
		BudgetProject.ImportBatchId,
		BudgetProject.BudgetProjectId,
		BudgetProject.BudgetId,
		BudgetProject.ProjectId,
		BudgetProject.PropertyFundId,
		BudgetProject.ActivityTypeId,
		BudgetProject.CorporateDepartmentCode,
		BudgetProject.CorporateSourceCode,
		BudgetProject.IsTsCost,
		BudgetProject.CanAllocateOverheads,
		BudgetProject.AllocateOverheadsProjectId
	FROM 
		TapasGlobalBudgeting.BudgetProject BudgetProject
			
		-- Limits records to those associated with budgets currently being processed
		INNER JOIN #Budget Budget ON
			BudgetProject.BudgetId = Budget.BudgetId AND
			BudgetProject.ImportBatchId = Budget.ImportBatchId

	PRINT ''Completed inserting records into #BudgetProject: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ImportBatchId_BudgetID ON #BudgetProject (ImportBatchId, BudgetId)
	PRINT ''Completed creating indexes on #BudgetProject''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------
	/*
		The #Region table is used to determine the Source Codes of budgets (using the RegionId field in the Budget table).
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #Region
	(
		RegionId INT NOT NULL,
		SourceCode CHAR(2) NOT NULL
	)

	INSERT INTO #Region
	(
		RegionId,
		SourceCode
	)
	SELECT 
		SourceRegion.RegionId,
		SourceRegion.SourceCode
	FROM 
		HR.Region SourceRegion
		INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
			SourceRegion.ImportKey = SourceRegionA.ImportKey

	PRINT ''Completed inserting records into #Region: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------
	/*
		The #BudgetEmployee table holds details of employees which are allocated to a specified budget.
		The table is also used to determine the Location (from the LocationId field) of the employee, which will determine 
		the Originating Region of Budget records.
	*/	
		
	SET @StartTime = GETDATE()
		
	CREATE TABLE #BudgetEmployee
	(
		ImportBatchId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetId INT NOT NULL,
		HrEmployeeId INT NULL,
		LocationId INT NOT NULL
	)

	INSERT INTO #BudgetEmployee
	(
		ImportBatchId,
		BudgetEmployeeId,
		BudgetId,
		HrEmployeeId,
		LocationId
	)
	SELECT 
		BudgetEmployee.ImportBatchId,
		BudgetEmployee.BudgetEmployeeId,
		BudgetEmployee.BudgetId,
		BudgetEmployee.HrEmployeeId,
		BudgetEmployee.LocationId
	FROM 
		TapasGlobalBudgeting.BudgetEmployee BudgetEmployee

		-- Limits records to those associated with budgets currently being processed
		INNER JOIN #Budget b ON
			BudgetEmployee.BudgetId = b.BudgetId AND
			BudgetEmployee.ImportBatchId = b.ImportBatchId

	PRINT ''Completed inserting records into #BudgetEmployee: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX UX_#BudgetEmployee_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
	CREATE INDEX IX_#BudgetEmployee_BudgetId ON #BudgetEmployee (BudgetId)

	PRINT ''Completed creating indexes on #BudgetEmployee''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*
		--------------------------------------------------------------------------------------------

		The #BudgetEmployeeFunctionalDepartment table stores the combination of Employees included in a Budget, and 
		the Functional Departments they belong to.
	*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeeFunctionalDepartment(
		ImportBatchId INT NOT NULL,
		BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		EffectivePeriod INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeeFunctionalDepartment(
		ImportBatchId,
		BudgetEmployeeFunctionalDepartmentId,
		BudgetEmployeeId,
		EffectivePeriod,
		FunctionalDepartmentId
	)
	SELECT 
		EFD.ImportBatchId,
		EFD.BudgetEmployeeFunctionalDepartmentId,
		EFD.BudgetEmployeeId,
		EFD.EffectivePeriod,
		EFD.FunctionalDepartmentId
	FROM 
		TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment EFD

		-- Limits the data to those associated with the budget currently being processed
		INNER JOIN #BudgetEmployee BE ON
			EFD.BudgetEmployeeId = BE.BudgetEmployeeId AND
			EFD.ImportBatchId = BE.ImportBatchId

	PRINT ''Completed inserting records into #BudgetEmployeeFunctionalDepartment: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_#BudgetEmployeeFunctionalDepartment_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
	CREATE INDEX IX_#BudgetEmployeeFunctionalDepartment_EffectivePeriod ON #BudgetEmployeeFunctionalDepartment (ImportBatchId, BudgetEmployeeId, EffectivePeriod)

	PRINT ''Completed creating indexes on #BudgetEmployeeFunctionalDepartment''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*
		--------------------------------------------------------------------------------------------

		The #Location table is used to determine the OriginatingRegion of a Budget record.
		Each BudgetEmployee record has a LocationId to determine where an employee is based.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #Location
	(
		LocationId INT NOT NULL,
		ExternalSubRegionId INT NOT NULL
	)

	INSERT INTO #Location
	(
		LocationId,
		ExternalSubRegionId
	)
	SELECT 
		Location.LocationId,
		Location.ExternalSubRegionId
	FROM 
		HR.Location Location
		INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
			Location.ImportKey = LocationA.ImportKey
		
	PRINT ''Completed inserting records into #Location: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)

	PRINT ''Completed creating indexes on #Location''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*
		--------------------------------------------------------------------------------------------

		The #FunctionalDepartment table is used to determine the Functional Department of a Budget record.
	*/

	CREATE TABLE #FunctionalDepartment
	(
		FunctionalDepartmentId INT NOT NULL,
		GlobalCode CHAR(3) NULL
	)
	INSERT INTO #FunctionalDepartment
	(
		FunctionalDepartmentId,
		GlobalCode
	)
	SELECT
		FunctionalDepartmentId,
		GlobalCode
	FROM
		HR.FunctionalDepartment FD
		INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDa ON
			FD.ImportKey = FDa.ImportKey
	WHERE
		FD.IsActive = 1

	PRINT ''Completed inserting records into #FunctionalDepartment: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)

	PRINT ''Completed creating indexes on #FunctionalDepartment''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------
	/*
		The #RegionExtended table is used to determine the Functional Department of Overhead transactions.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #RegionExtended
	(
		RegionId INT NOT NULL,
		OverheadFunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #RegionExtended
	(
		RegionId,
		OverheadFunctionalDepartmentId
	)
	SELECT 
		RegionExtended.RegionId,
		RegionExtended.OverheadFunctionalDepartmentId 
	FROM 
		TapasGlobal.RegionExtended RegionExtended
		INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
			RegionExtended.ImportKey = RegionExtendedA.ImportKey

	PRINT ''Completed inserting records into #RegionExtended: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)

	PRINT ''Completed creating indexes on #RegionExtended''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------
	/*
		The #Project table is used to get Property Fund and Activity Type information for Overhead projects, and default projects where
		the Bonus Cap has been exceeded.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #Project
	(
		ProjectId INT NOT NULL,
		ActivityTypeId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(8) NOT NULL,
		CorporateSourceCode CHAR(2) NOT NULL,
		PropertyFundId INT NOT NULL
	)

	INSERT INTO #Project
	(
		ProjectId,
		ActivityTypeId,
		CorporateDepartmentCode,
		CorporateSourceCode,
		PropertyFundId
	)
	SELECT 
		Project.ProjectId,
		Project.ActivityTypeId,
		Project.CorporateDepartmentCode,
		Project.CorporateSourceCode,
		Project.PropertyFundId
	FROM 
		TapasGlobal.Project Project
		INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
			Project.ImportKey = ProjectA.ImportKey 

	PRINT ''Completed inserting records into #Project: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)

	PRINT ''Completed creating indexes on #Project''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-------------------------------------------------------------------------------------------------
	/*
		System Setting Region - Bonus Cap Excess
		If a project exceeds its Bonus Cap amount, a single project is selected in place of that project.
		The project Id is determined by the System Setting Region table.
	*/

	CREATE TABLE #SystemSettingRegion
	(
		SystemSettingId INT NOT NULL,
		SystemSettingName VARCHAR(50) NOT NULL,
		SystemSettingRegionId INT NOT NULL,
		RegionId INT,
		SourceCode VARCHAR(2),
		BonusCapExcessProjectId INT
	)
	INSERT INTO #SystemSettingRegion
	(
		SystemSettingId,
		SystemSettingName,
		SystemSettingRegionId,
		RegionId,
		SourceCode,
		BonusCapExcessProjectId
	)
	SELECT
		ss.SystemSettingId,
		ss.Name,
		ssr.SystemSettingRegionId,
		ssr.RegionId,
		ssr.SourceCode,
		ssr.BonusCapExcessProjectId
	FROM
		(
			SELECT 
				ssr.SystemSettingRegionId,
				ssr.RegionId,
				ssr.SourceCode,
				ssr.BonusCapExcessProjectId,
				ssr.SystemSettingId
			FROM
				TapasGlobal.SystemSettingRegion ssr
			
				INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
					ssr.ImportKey = ssrA.ImportKey
		 ) ssr

		INNER JOIN
			(
				SELECT
					ss.SystemSettingId,
					ss.Name
				FROM
					TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
						ss.ImportKey = ssA.ImportKey
				WHERE
					ss.Name = ''BonusCapExcess'' -- Previously this was done in the joins, but it''s now being done here to limit the data being processed.
			) ss ON
				ssr.SystemSettingId = ss.SystemSettingId
			
	PRINT ''Completed getting system settings''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*	-------------------------------------------------------------------------------------------------------------------------
		Global Categorization Payroll Mappings
		
		The following table is used to store Minor Category and Major Category Ids which records will be associated with.
		The reason it''s stored as a table and not as variables is because there may be more than one Snapshot being processed at the
		time, and different snapshots may have different Ids.
		
		NB!!!!!!!
		The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
		communicated to TS employees on certain reports. Changing the category mappings to the data below will have ramifications because 
		some reports check for this name.
	*/

	CREATE TABLE #PayrollGlobalMappings
	(
		GLMinorCategoryName VARCHAR(120) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(120) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		SnapshotId INT NOT NULL	
	)

	INSERT INTO #PayrollGlobalMappings
	(
		GLMinorCategoryName,
		GLMinorCategoryId,
		GLMajorCategoryName,
		GLMajorCategoryId,
		SnapshotId
	)
	SELECT DISTINCT
		GLMinorCategoryName,
		GLMinorCategoryId,
		GLMajorCategoryName,
		GLMajorCategoryId,
		SnapshotId
	FROM
		Gr.GetSnapshotGLCategorizationHierarchyExpanded()
	WHERE
		(
			GLMajorCategoryName = ''Salaries/Taxes/Benefits'' OR
			(
				GLMinorCategoryName = ''External General Overhead'' AND
				GLMajorCategoryName = ''General Overhead''
			)
		) AND
		GLCategorizationName = ''Global''

END

/* ===============================================================================================================================================
	4.	Source Payroll and Overhead Allocation Data from TAPAS Global Budgeting
   ============================================================================================================================================= */
BEGIN

	/*
		---------------------------------------------------------------------
		BudgetEmployeePayrollAllocation
		The #BudgetEmployeePayrollAllocation table stores budget payroll allocations for employees.
		The table is used to determine the Base Salary, the Bonus and the Profit Share amounts for each employee.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocation
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		BudgetProjectGroupId INT NULL,
		Period INT NOT NULL,
		SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
		BonusAllocationValue DECIMAL(18, 9) NULL,
		BonusCapAllocationValue DECIMAL(18, 9) NULL,
		ProfitShareAllocationValue DECIMAL(18, 9) NULL,
		PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
		PreTaxBonusAmount DECIMAL(18, 2) NULL,
		PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
		PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetEmployeePayrollAllocationId INT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #BudgetEmployeePayrollAllocation
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeeId,
		BudgetProjectId,
		BudgetProjectGroupId,
		Period,
		SalaryAllocationValue,
		BonusAllocationValue,
		BonusCapAllocationValue,
		ProfitShareAllocationValue,
		PreTaxSalaryAmount,
		PreTaxBonusAmount,
		PreTaxBonusCapExcessAmount,
		PreTaxProfitShareAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		OriginalBudgetEmployeePayrollAllocationId,
		SnapshotId
	)
	SELECT
		Allocation.ImportKey,
		Allocation.ImportBatchId,
		Allocation.ImportDate,
		Allocation.BudgetEmployeePayrollAllocationId,
		Allocation.BudgetEmployeeId,
		Allocation.BudgetProjectId,
		Allocation.BudgetProjectGroupId,
		Allocation.Period,
		Allocation.SalaryAllocationValue,
		Allocation.BonusAllocationValue,
		Allocation.BonusCapAllocationValue,
		Allocation.ProfitShareAllocationValue,
		Allocation.PreTaxSalaryAmount,
		Allocation.PreTaxBonusAmount,
		Allocation.PreTaxBonusCapExcessAmount,
		Allocation.PreTaxProfitShareAmount,
		Allocation.InsertedDate,
		Allocation.UpdatedDate,
		Allocation.UpdatedByStaffId,
		Allocation.OriginalBudgetEmployeePayrollAllocationId,
		B.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #DistinctImports DI ON
			Allocation.ImportBatchId = DI.ImportBatchId

		-- Used to limit to the budgets currently being processed.
		INNER JOIN #BudgetProject bp ON
			Allocation.BudgetProjectId = bp.BudgetProjectId
		
		-- Used to get the snapshot from the budgets currently being processed.
		INNER JOIN #Budget B ON
			BP.BudgetId = B.BudgetId

	PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocation: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (ImportBatchId, BudgetEmployeePayrollAllocationId)
	CREATE NONCLUSTERED INDEX IX_BudgetEmployeePayrollAllocation_BudgetProject ON #BudgetEmployeePayrollAllocation(ImportBatchId, BudgetProjectId)

	PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocation''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	---------------------------------------------------------------------
	-- Source payroll tax detail
		
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetEmployeePayrollAllocationDetail
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BenefitOptionId INT NULL,
		BudgetTaxTypeId INT NULL,
		SalaryAmount DECIMAL(18, 2) NULL,
		BonusAmount DECIMAL(18, 2) NULL,
		ProfitShareAmount DECIMAL(18, 2) NULL,
		BonusCapExcessAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetEmployeePayrollAllocationDetail
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		BenefitOptionId,
		BudgetTaxTypeId,
		SalaryAmount,
		BonusAmount,
		ProfitShareAmount,
		BonusCapExcessAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		TaxDetail.ImportKey,
		TaxDetail.ImportBatchId,
		TaxDetail.ImportDate,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		TaxDetail.BudgetEmployeePayrollAllocationId,
		TaxDetail.BenefitOptionId,
		TaxDetail.BudgetTaxTypeId,
		TaxDetail.SalaryAmount,
		TaxDetail.BonusAmount,
		TaxDetail.ProfitShareAmount,
		TaxDetail.BonusCapExcessAmount,
		TaxDetail.InsertedDate,
		TaxDetail.UpdatedDate,
		TaxDetail.UpdatedByStaffId,
		Allocation.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
		
		-- Limits the data to records associated with the budgets currently being processed.
		INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
			TaxDetail.ImportBatchId = Allocation.ImportBatchId AND
			TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId  


	PRINT ''Completed inserting records into #BudgetEmployeePayrollAllocationDetail: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (ImportBatchId, BudgetEmployeePayrollAllocationDetailId)

	PRINT ''Completed creating indexes on #BudgetEmployeePayrollAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*
		The #BudgetTaxType determines the tax types associated with budgets.
	*/

	-- Source budget tax type
	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetTaxType
	(
		ImportBatchId INT NOT NULL,
		BudgetTaxTypeId INT NOT NULL,
		BudgetId INT NOT NULL,
		TaxTypeId INT NOT NULL
	)

	INSERT INTO #BudgetTaxType
	(
		ImportBatchId,
		BudgetTaxTypeId,
		BudgetId,
		TaxTypeId
	)
	SELECT 
		BudgetTaxType.ImportBatchId,
		BudgetTaxType.BudgetTaxTypeId,
		BudgetTaxType.BudgetId,
		BudgetTaxType.TaxTypeId 
	FROM 
		TapasGlobalBudgeting.BudgetTaxType BudgetTaxType

		-- Limits to the data to the those associated with the budgets currently being processed.
		INNER JOIN #Budget b ON
			BudgetTaxType.BudgetId = b.BudgetId AND
			BudgetTaxType.ImportBatchId = b.ImportBatchId

	PRINT ''Completed inserting records into #BudgetTaxType: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
	PRINT ''Completed creating indexes on #BudgetTaxType''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/*
		The #TaxType table is used to determine the Minor Category for the tax records sourced from the #BudgetEmployeePayrollAllocationDetail
		table.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #TaxType
	(
		ImportBatchId INT NOT NULL,
		TaxTypeId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL
	)

	INSERT INTO #TaxType
	(
		ImportBatchId,
		TaxTypeId,
		MinorGlAccountCategoryId
	)
	SELECT 
		TaxType.ImportBatchId,
		TaxType.TaxTypeId,
		TaxType.MinorGlAccountCategoryId
	FROM 
		TapasGlobalBudgeting.TaxType TaxType
		
		INNER JOIN #DistinctImports DI ON
			TaxType.ImportBatchId = DI.ImportBatchId  

	PRINT ''Completed inserting records into #TaxType: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE CLUSTERED INDEX IX_TaxType ON #TaxType (ImportBatchId, TaxTypeId)

	PRINT ''Completed creating indexes on #TaxType''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	-- Source payroll allocation Tax detail

	/*
		The #EmployeePayrollAllocationDetail table stores budget payroll allocations for employees for taxes and employee benefits.
		This adds to the #BudgetEmployeePayrollAllocation table by adding the Minor Category mapping.
	*/

	CREATE TABLE #EmployeePayrollAllocationDetail
	(
		ImportKey INT NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		MinorGlAccountCategoryId INT NULL,
		BudgetTaxTypeId INT NULL,
		SalaryAmount DECIMAL(18, 2) NULL,
		BonusAmount DECIMAL(18, 2) NULL,
		ProfitShareAmount DECIMAL(18, 2) NULL,
		BonusCapExcessAmount DECIMAL(18, 2) NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	-- Classifies tax types into minor categories, see CASE statement; gets set here because it can be overwritten later in the stored procedure

	INSERT INTO #EmployeePayrollAllocationDetail
	(
		ImportKey,
		BudgetEmployeePayrollAllocationDetailId,
		BudgetEmployeePayrollAllocationId,
		MinorGlAccountCategoryId,
		BudgetTaxTypeId,
		SalaryAmount,
		BonusAmount,
		ProfitShareAmount,
		BonusCapExcessAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		TaxDetail.ImportKey,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		TaxDetail.BudgetEmployeePayrollAllocationId,
		CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN GlCategory.GLMinorCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
		TaxDetail.BudgetTaxTypeId,
		TaxDetail.SalaryAmount,
		TaxDetail.BonusAmount,
		TaxDetail.ProfitShareAmount,
		TaxDetail.BonusCapExcessAmount,
		TaxDetail.InsertedDate,
		TaxDetail.UpdatedDate,
		TaxDetail.UpdatedByStaffId,
		TaxDetail.SnapshotId
	FROM
		-- Joining on allocation to limit amount of data to that associated with bugets urrently being prcessed.
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId AND
			Allocation.ImportBatchId = TaxDetail.ImportBatchId

		-- This join is used to determine the Minor Category if the Benefit Option is not specified.		
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			Allocation.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''	

		LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON -- rather pull through as unknown than exclude, therefore LEFT JOIN
			TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId AND
			TaxDetail.ImportBatchId = BudgetTaxType.ImportBatchId

		-- Used to determine the Minor Category
		LEFT OUTER JOIN #TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	AND
			BudgetTaxType.ImportBatchId = TaxType.ImportBatchId

	PRINT ''Completed inserting records into #EmployeePayrollAllocationDetail: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,  BudgetEmployeePayrollAllocationId)
	CREATE INDEX IX_EmployeePayrollAllocationDetail2 ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #EmployeePayrollAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--------------------------------------------------------------------------------------------------
	-- Source overhead allocations

		/*
			The #BudgetOverheadAllocation table stores overhead budget data.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocation
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetId INT NOT NULL,
		OverheadRegionId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		BudgetPeriod INT NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		OriginalBudgetOverheadAllocationId INT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetOverheadAllocation
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetOverheadAllocationId,
		BudgetId,
		OverheadRegionId,
		BudgetEmployeeId,
		BudgetPeriod,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		OriginalBudgetOverheadAllocationId,
		SnapshotId
	)
	SELECT
		OverheadAllocation.ImportKey,
		OverheadAllocation.ImportBatchId,
		OverheadAllocation.ImportDate,
		OverheadAllocation.BudgetOverheadAllocationId,
		OverheadAllocation.BudgetId,
		OverheadAllocation.OverheadRegionId,
		OverheadAllocation.BudgetEmployeeId,
		OverheadAllocation.BudgetPeriod,
		OverheadAllocation.AllocationAmount,
		OverheadAllocation.InsertedDate,
		OverheadAllocation.UpdatedDate,
		OverheadAllocation.UpdatedByStaffId,
		OverheadAllocation.OriginalBudgetOverheadAllocationId,
		b.SnapshotId
	FROM
		TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation

		-- Limits the data to records associated with budgets currently being processed.
		INNER JOIN #Budget b ON
			OverheadAllocation.BudgetId = b.BudgetId AND
			OverheadAllocation.ImportBatchId = b.ImportBatchId

	PRINT ''Completed inserting records into #BudgetOverheadAllocation: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
	PRINT ''Completed creating indexes on #BudgetOverheadAllocation''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-- Source overhead allocation detail

		/*
			The #BudgetOverheadAllocationDetail table stores overhead budget data for the individual projects.
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #BudgetOverheadAllocationDetail
	(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		ImportDate DATETIME NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		AllocationValue DECIMAL(18, 9) NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #BudgetOverheadAllocationDetail
	(
		ImportKey,
		ImportBatchId,
		ImportDate,
		BudgetOverheadAllocationDetailId,
		BudgetOverheadAllocationId,
		BudgetProjectId,
		AllocationValue,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT 
		OverheadDetail.ImportKey,
		OverheadDetail.ImportBatchId,
		OverheadDetail.ImportDate,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetProjectId,
		OverheadDetail.AllocationValue,
		OverheadDetail.AllocationAmount,
		OverheadDetail.InsertedDate,
		OverheadDetail.UpdatedDate,
		OverheadDetail.UpdatedByStaffId,
		B.SnapshotId
	FROM			
		TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail

		INNER JOIN #DistinctImports DI ON
			OverheadDetail.ImportBatchId = DI.ImportBatchId

		-- Limits the data to records associated with budgets currently being processed.
		INNER JOIN #BudgetProject BP ON
			OverheadDetail.BudgetProjectId = BP.BudgetProjectId
			
		-- Used to determine the snapshot the records are associated with.	
		INNER JOIN #Budget B ON
			BP.BudgetId = B.BudgetId  

	PRINT ''Completed inserting records into #BudgetOverheadAllocationDetail: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_BudgetOverheadAllocationDetail2 ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT ''Completed creating indexes on #BudgetOverheadAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

		/*
			The #OverheadAllocationDetail table stores overhead budget data for the individual projects, and includes the GL Minor Category
			mapping.
		*/

	CREATE TABLE #OverheadAllocationDetail
	(
		ImportKey INT NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetProjectId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		AllocationValue DECIMAL(18, 9) NOT NULL,
		AllocationAmount DECIMAL(18, 2) NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL,
		UpdatedByStaffId INT NOT NULL,
		SnapshotId INT NOT NULL
	)

	INSERT INTO #OverheadAllocationDetail
	(
		ImportKey,
		BudgetOverheadAllocationDetailId,
		BudgetOverheadAllocationId,
		BudgetProjectId,
		MinorGlAccountCategoryId,
		AllocationValue,
		AllocationAmount,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		SnapshotId
	)
	SELECT
		OverheadDetail.ImportKey,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetProjectId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, -- Hardcode to a specific minor category, could be changed later in the stored proc
		OverheadDetail.AllocationValue,
		OverheadDetail.AllocationAmount,
		OverheadDetail.InsertedDate,
		OverheadDetail.UpdatedDate,
		OverheadDetail.UpdatedByStaffId,
		OverheadDetail.SnapshotId
	FROM
		-- Joining on allocation to limit amount of data
		#BudgetOverheadAllocation OverheadAllocation

		INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId AND
			OverheadAllocation.ImportBatchId = OverheadDetail.ImportBatchId

		-- Used to determine the Minor Category of the records	
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			OverheadDetail.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''External General Overhead''

	PRINT ''Completed inserting records into #OverheadAllocationDetail: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
	CREATE INDEX IX_OverheadAllocationDetail2 ON #OverheadAllocationDetail (BudgetOverheadAllocationId)

	PRINT ''Completed creating indexes on #OverheadAllocationDetail''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
	5.	Map the Pre-Tax, Tax and Overhead data to their associated records (step 4) from Tapas Global Budgeting
   ============================================================================================================================================= */
BEGIN
	/*
		Calculate effective functional department.
		Finds the last period before an employee changed her functional department, and finds all functional departments 
		that an employee is associated with.
	*/

	SET @StartTime = GETDATE()

	CREATE TABLE #EffectiveFunctionalDepartment
	(
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeeId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL
	)

	INSERT INTO #EffectiveFunctionalDepartment
	(
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeeId,
		FunctionalDepartmentId
	)
	SELECT 
		Allocation.BudgetEmployeePayrollAllocationId,
		Allocation.BudgetEmployeeId,
		ISNULL
		(
			(
				SELECT 
					EFD.FunctionalDepartmentId
				FROM 
					(
						SELECT
							Allocation2.ImportBatchId,
							Allocation2.BudgetEmployeeId,
							MAX(EFD.EffectivePeriod) AS EffectivePeriod
						FROM
							#BudgetEmployeePayrollAllocation Allocation2

							INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
								Allocation2.ImportBatchId = EFD.ImportBatchId AND
								Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
						WHERE
							Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
							Allocation.ImportBatchId = Allocation2.ImportBatchId AND
							EFD.EffectivePeriod <= Allocation.Period

						GROUP BY
							Allocation2.ImportBatchId,
							Allocation2.BudgetEmployeeId
					) EFDo

					LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						EFDo.ImportBatchId = EFD.ImportBatchId AND
						EFDo.BudgetEmployeeId = EFD.BudgetEmployeeId AND
						EFDo.EffectivePeriod = EFD.EffectivePeriod
			),
			-1
		) AS FunctionalDepartmentId
	FROM
		#BudgetEmployeePayrollAllocation Allocation

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.ImportBatchId = BudgetProject.ImportBatchId AND
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

	PRINT ''Completed inserting records into #EffectiveFunctionalDepartment: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_EffectiveFunctionalDepartment_AllocId ON #EffectiveFunctionalDepartment (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #EffectiveFunctionalDepartment''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-------------------------------------------------------------------------------------------------------
	-- Map Payroll data

		/*
			--------------------------------------------
			Pre-Tax Payroll Data
			Map Pre-Tax payroll budget amounts from the #BudgetEmployeePayrollAllocation table to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityPreTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		SalaryPreTaxAmount MONEY NOT NULL,
		ProfitSharePreTaxAmount MONEY NOT NULL,
		BonusPreTaxAmount MONEY NOT NULL,
		BonusCapExcessPreTaxAmount MONEY NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode Varchar(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		SourceTableName VARCHAR(128) NOT NULL
	)
	-- Insert original budget amounts
	-- links everything that we have pulled above (applying linking logic to tax, pre-tax and overhead data)
	INSERT INTO #ProfitabilityPreTaxSource
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		BudgetRegionId,
		ProjectId,
		HrEmployeeId,
		BudgetEmployeePayrollAllocationId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		SalaryPreTaxAmount,
		ProfitSharePreTaxAmount,
		BonusPreTaxAmount,
		BonusCapExcessPreTaxAmount,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		
		SourceTableName
	)
	SELECT 
		Budget.ImportBatchId,
		@BudgetReforecastTypeKey,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId AS BudgetId,
		Budget.RegionId AS BudgetRegionId,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		Allocation.BudgetEmployeePayrollAllocationId,
		''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId='' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + ''&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0'' AS ReferenceCode,
		Allocation.Period AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
		ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
		ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
		ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
		ISNULL(EFD.FunctionalDepartmentId, -1),
		fd.GlobalCode AS FunctionalDepartmentCode, 
		--CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable, -- CC 4 :: GC
		CASE WHEN Dept.IsTsCost = 0 THEN 1 ELSE 0 END Reimbursable,
		BudgetProject.ActivityTypeId,
		Att.ActivityTypeCode,
		
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
			
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		Allocation.UpdatedDate,
		Budget.BudgetReportGroupPeriod,
		
		''BudgetEmployeePayrollAllocation''
	FROM
		#BudgetEmployeePayrollAllocation Allocation -- tax amount

		INNER JOIN #BudgetProject BudgetProject ON 
			Allocation.BudgetProjectId = BudgetProject.BudgetProjectId AND
			Allocation.ImportBatchId = BudgetProject.ImportBatchId

		INNER JOIN #Budget Budget ON
			BudgetProject.ImportBatchId = Budget.ImportBatchId AND
			BudgetProject.BudgetId = Budget.BudgetId

		LEFT OUTER JOIN #Region SourceRegion ON
			Budget.RegionId = SourceRegion.RegionId

		-- Maps the source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			SourceRegion.SourceCode = GrSc.SourceCode

		-- Maps the Functional Department
		LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
			Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

		-- Resolves the Functional Department Code
		LEFT OUTER JOIN #FunctionalDepartment fd ON
			efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

		/*
			A Property Fund can either be mapped using the PropertyFundId in the BudgetProject table, or using the CorporateDepartmentCode and
			SourceCode combination in the BudgetProject table to determine the PropertyFundId through the ReportingEntityCorproateDepartment table
			or the ReportingEntityPropertyEntity table.
			The Property Fund using the CorporateDepartmentCode and SourceCode is the first option, but if this is null, the PropertyFundId is used
			directly from the BudgetProject table.
		*/

		-- Gets the Property Fund a Project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Gets the Allocation Region from the Property Fund a project is mapped to
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId AND
			GlobalRegion.IsActive = 1

		-- Gets the Property Fund a Project''s Corporate Department is mapped to for transaction before period 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = pfm.SourceCode AND
			pfm.SnapshotId = Budget.SnapshotId  AND
			pfm.IsDeleted = 0 AND
			(
				(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL)
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007

		-- Used to resolve the Property Fund a Project''s Corporate Department is mapped to.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECD.SourceCode  AND
			Budget.SnapshotId  = RECD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Used to resolve the Property Fund a Project''s Property Entity is mapped to.				   
		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode  = REPE.SourceCode AND
			Budget.SnapshotId  = REPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Maps the Property Fund a Project''s Corporate Department / Reporting Entity is mapped to.
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON -- property fund could be coming from multiple sources
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN Budget.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
					ELSE
						CASE
							WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
							ELSE REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.SnapshotId = Budget.SnapshotId AND
			DepartmentPropertyFund.IsActive = 1

		-- 	Used to resolve the Consolidation Sub Region a Project''s Corporate Department is mapped to.			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId  AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- 	Used to resolve the Consolidation Sub Region a Project''s Property Entity is mapped to.			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = CRPE.SourceCode AND
			Budget.SnapshotId  = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		/*
			The Originating Region of a budget record is detrmined through the Location of an Employee (LocationId of BudgetEmployee table).
		*/	
		LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
			Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		-- Used to determine the Location an employee is based in
		LEFT OUTER JOIN #Location Location ON 
			BudgetEmployee.LocationId = Location.LocationId 

		-- Used to dtermine the Originating Region Code and Source Code
		LEFT OUTER JOIN Gdm.SnapshotPayrollRegion OriginatingRegion ON 
			Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
			Budget.RegionId = OriginatingRegion.RegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId

		INNER JOIN GrReporting.dbo.ActivityType Att ON
			BudgetProject.ActivityTypeId = Att.ActivityTypeId AND
			Budget.SnapshotId = Att.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotCorporateDepartment Dept ON
			BudgetProject.CorporateDepartmentCode = Dept.Code AND 
			SourceRegion.SourceCode = Dept.SourceCode AND
			Budget.SnapshotId = Dept.SnapshotId
	WHERE
		Allocation.Period BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod --AND
		--Change Control 1 : GC 2010-09-01
		--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

	PRINT ''Completed inserting records into #ProfitabilityPreTaxSource: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
	CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
	CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
	CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
	CREATE INDEX IX_ProfitabilityPreTaxSource5 ON #ProfitabilityPreTaxSource (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			----------------------------------------------------------------------------------------
			Tax Data
			Map Tax (includes Benefits) payroll budget amounts to GDM and HR data
		*/

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityTaxSource
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetRegionId INT NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetEmployeePayrollAllocationId INT NOT NULL,
		BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		SalaryTaxAmount MONEY NOT NULL,
		ProfitShareTaxAmount MONEY NOT NULL,
		BonusTaxAmount MONEY NOT NULL,
		BonusCapExcessTaxAmount MONEY NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		ActivityTypeCode Varchar(50) NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		BudgetReportGroupPeriod INT NOT NULL,
		
		SourceTableName VARCHAR(128) NOT NULL
	)
	-- Insert original budget amounts
	INSERT INTO #ProfitabilityTaxSource
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		BudgetRegionId,
		ProjectId,
		HrEmployeeId,
		BudgetEmployeePayrollAllocationId,
		BudgetEmployeePayrollAllocationDetailId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		SalaryTaxAmount,
		ProfitShareTaxAmount,
		BonusTaxAmount,
		BonusCapExcessTaxAmount,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		ActivityTypeCode,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		BudgetReportGroupPeriod,
		
		SourceTableName
	)
	SELECT
		pts.ImportBatchId,
		pts.BudgetReforecastTypeKey,
		pts.ReforecastKey,
		pts.SnapshotId,
		pts.BudgetId,
		pts.BudgetRegionId,
		ISNULL(pts.ProjectId,0) AS ProjectId,
		ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
		pts.BudgetEmployeePayrollAllocationId,
		TaxDetail.BudgetEmployeePayrollAllocationDetailId,
		(
			''TGB:BudgetId='' + CONVERT(VARCHAR, pts.BudgetId) +
			''&ProjectId='' + CONVERT(VARCHAR, ISNULL(pts.ProjectId, 0)) +
			''&HrEmployeeId='' + CONVERT(VARCHAR, ISNULL(pts.HrEmployeeId, 0)) +
			''&BudgetEmployeePayrollAllocationId='' + CONVERT(VARCHAR, pts.BudgetEmployeePayrollAllocationId) +
			''&BudgetEmployeePayrollAllocationDetailId='' + CONVERT(VARCHAR, TaxDetail.BudgetEmployeePayrollAllocationDetailId) +
			''&BudgetOverheadAllocationDetailId=0''
		) AS ReferenceCode,
		pts.ExpensePeriod,
		pts.SourceCode,
		ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
		ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
		ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
		ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
		TaxDetail.MinorGlAccountCategoryId,
		ISNULL(pts.FunctionalDepartmentId, -1),
		pts.FunctionalDepartmentCode, 
		pts.Reimbursable,
		pts.ActivityTypeId,
		pts.ActivityTypeCode,
		pts.PropertyFundId,
		pts.AllocationSubRegionGlobalRegionId,
		pts.ConsolidationSubRegionGlobalRegionId,
		pts.OriginatingRegionCode,
		pts.OriginatingRegionSourceCode,
		pts.LocalCurrencyCode,
		pts.AllocationUpdatedDate,
		pts.BudgetReportGroupPeriod,
		
		''BudgetEmployeePayrollAllocationDetail''
	FROM
		#EmployeePayrollAllocationDetail TaxDetail

		INNER JOIN #ProfitabilityPreTaxSource pts ON -- pre tax has already been resolved, above, so join to limit taxdetail
			TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

	PRINT ''Completed inserting records into #ProfitabilityTaxSource: ''+CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityTaxSource1 ON #ProfitabilityTaxSource (SalaryTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource2 ON #ProfitabilityTaxSource (ProfitShareTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource3 ON #ProfitabilityTaxSource (BonusTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource4 ON #ProfitabilityTaxSource (BonusCapExcessTaxAmount)
	CREATE INDEX IX_ProfitabilityTaxSource5 ON #ProfitabilityTaxSource (BudgetEmployeePayrollAllocationId)

	PRINT ''Completed creating indexes on #ProfitabilityPreTaxSource''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

		/*
			------------------------------------------------------------------------------------------
			Overhead data
			Map Tax Overhead budget amounts to GDM and HR data
		*/
		
	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityOverheadSource
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ProjectId INT NOT NULL,
		HrEmployeeId INT NOT NULL,
		BudgetOverheadAllocationId INT NOT NULL,
		BudgetOverheadAllocationDetailId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		OverheadAllocationAmount MONEY NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		OverheadUpdatedDate DATETIME NOT NULL,
		
		SourceTableName VARCHAR(128) NOT NULL
	)
	-- Insert original overhead amounts
	INSERT INTO #ProfitabilityOverheadSource
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ProjectId,
		HrEmployeeId,
		BudgetOverheadAllocationId,
		BudgetOverheadAllocationDetailId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		OverheadAllocationAmount,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		OverheadUpdatedDate,
		
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		@BudgetReforecastTypeKey,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId AS BudgetId,
		ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
		ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
		OverheadDetail.BudgetOverheadAllocationId,
		OverheadDetail.BudgetOverheadAllocationDetailId,
		''TGB:BudgetId='' + CONVERT(varchar,Budget.BudgetId) + ''&ProjectId='' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + ''&HrEmployeeId='' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + ''&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0'' + ''&BudgetOverheadAllocationDetailId='' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) AS ReferenceCode,
		OverheadAllocation.BudgetPeriod AS ExpensePeriod,
		SourceRegion.SourceCode,
		ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
		OverheadDetail.MinorGlAccountCategoryId,
		ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
		fd.GlobalCode AS FunctionalDepartmentCode,
		CASE
			WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
				CASE
					WHEN
						BudgetProject.IsTsCost = 0 -- Where ISTSCost is False the cost will be reimbursable
					THEN
						1
					ELSE
						0
				END
			ELSE
				0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
		END AS Reimbursable,
		BudgetProject.ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(OverheadPropertyFund.PropertyFundId, DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		OriginatingRegion.CorporateEntityRef,
		OriginatingRegion.CorporateSourceCode,
		Budget.CurrencyCode AS LocalCurrencyCode,
		OverheadDetail.UpdatedDate,
		
		''BudgetOverheadAllocation''
	FROM
		#BudgetOverheadAllocation OverheadAllocation 

		INNER JOIN #BudgetEmployee BudgetEmployee ON
			OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

		INNER JOIN #OverheadAllocationDetail OverheadDetail ON -- where overhead amount sits
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId

		INNER JOIN #BudgetProject BudgetProject ON 
			OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId

		INNER JOIN #Budget Budget ON 
			BudgetProject.BudgetId = Budget.BudgetId AND
			BudgetProject.ImportBatchId = Budget.ImportBatchId		

		LEFT OUTER JOIN #Region SourceRegion ON 
			Budget.RegionId = SourceRegion.RegionId

		LEFT OUTER JOIN #RegionExtended RegionExtended ON 
			SourceRegion.RegionId = RegionExtended.RegionId

		LEFT OUTER JOIN #FunctionalDepartment fd ON
			RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId 

		-- Maps the Property Fund based on the BudgetProject mapping
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			Budget.SnapshotId  = ProjectPropertyFund.SnapshotId  AND
			ProjectPropertyFund.IsActive = 1

		-- Maps the Allocation Sub Region of the Budget Project''s property fund
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion GlobalRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = GlobalRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = GlobalRegion.SnapshotId AND
			GlobalRegion.IsActive = 1
			
		-- Maps the Source of the Budget Project
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
			BudgetProject.CorporateSourceCode = GrScC.SourceCode  

		-- Maps the Property Fund of the Budget Project based on the CorporateDepartmentCode and SourceCode for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			BudgetProject.CorporateSourceCode = pfm.SourceCode AND
			Budget.SnapshotId = pfm.SnapshotId AND

			pfm.IsDeleted = 0 AND 
			(
				(GrScC.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007

		-- Maps the Budget Project to a Property Fund using the Corporate Department Code and Corporate Source Code combinations.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDC ON
			GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = RECDC.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = RECDC.SourceCode AND
			Budget.SnapshotId = RECDC.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEC ON
			GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = REPEC.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = REPEC.SourceCode AND
			Budget.SnapshotId = REPEC.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Maps the Budget Project to a Proeprty Fund
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.SnapshotId = Budget.SnapshotId AND
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN
						Budget.BudgetReportGroupPeriod < 201007
					THEN
						pfm.PropertyFundId
					ELSE
						ISNULL(RECDC.PropertyFundId, REPEC.PropertyFundId)
				END AND
			DepartmentPropertyFund.IsActive = 1
		/*
			Some BudgetProjects which overehead budget records are assigned to assign the overhead transactions to other projects to determine
			the Property Fund and the Allocation Sub Region of the project. This Overhead Specific project is determined using the 
			AllocateOverheadsProjectId from the BudgetProject table.
		*/

		LEFT OUTER JOIN	#Project OverheadProject ON
			BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId 

		-- Gets the Source of the Overhead Project
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
			OverheadProject.CorporateSourceCode = GrScO.SourceCode  

		-- Maps the Property Fund of the Overhead Project for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping opfm ON
			OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
			OverheadProject.CorporateSourceCode = opfm.SourceCode AND
			opfm.SnapshotId = Budget.SnapshotId AND
			
			opfm.IsDeleted = 0 AND 
			(
				(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
					OR
					(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
				)
			) AND
			Budget.BudgetReportGroupPeriod < 201007

		/*
			The SnapshotReportingEntityCorporateDepartment and SnapshotReportingEntityPropertyEntity tables map the Overhead Project to a 
			Property Fund using the Corporate Department Code and Corporate Source Code combinations.
			This previously BudgetProject.CorporateDepartmentCode and BudgetProject.CorporateSourceCode but was changed to OverheadProject.xx 
			to show that it''s the Property Fund that the Overhead Project is mapped to.
		*/	

		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECDO ON
			GrScO.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(OverheadProject.CorporateDepartmentCode)) = RECDO.CorporateDepartmentCode AND 
			OverheadProject.CorporateSourceCode = RECDO.SourceCode AND
			Budget.SnapshotId = RECDO.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPEO ON
			GrScO.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(OverheadProject.CorporateDepartmentCode)) = REPEO.PropertyEntityCode AND
			OverheadProject.CorporateSourceCode = REPEO.SourceCode AND
			Budget.SnapshotId = REPEO.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201007

		-- Maps the Property Fund for the Overhead Project for transactions before 201007
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund OverheadPropertyFund ON
			OverheadPropertyFund.PropertyFundId =
				CASE
					WHEN Budget.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
					ELSE
						CASE
							WHEN GrScO.IsCorporate = ''YES'' THEN RECDO.PropertyFundId
							ELSE REPEO.PropertyFundId
						END
				END AND
			OverheadPropertyFund.SnapshotId = Budget.SnapshotId AND
			OverheadPropertyFund.IsActive = 1

		-- Maps the Consolidaiton Reigon of the Budget Project''s Corporate Department
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			BudgetProject.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		-- Maps the Consolidaiton region of the Budget Project''s Property Entity
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON -- (CC16)
			GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			BudgetProject.CorporateSourceCode = CRPE.SourceCode  AND
			Budget.SnapshotId  = CRPE.SnapshotId AND
			Budget.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			Budget.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1

		LEFT OUTER JOIN Gdm.SnapshotOverheadRegion OriginatingRegion ON 
			OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId AND
			Budget.SnapshotId = OriginatingRegion.SnapshotId  
	WHERE
		OverheadAllocation.BudgetPeriod BETWEEN Budget.GroupStartPeriod AND Budget.GroupEndPeriod

	PRINT ''Completed inserting records into #ProfitabilityOverheadSource: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE INDEX IX_ProfitabilityOverheadSource1 ON #ProfitabilityOverheadSource (OverheadAllocationAmount)

	PRINT ''Completed creating indexes on #ProfitabilityOverheadSource''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
		6.	Combine tables into #ProfitabilityPayrollMapping table and map to GDM data
   ============================================================================================================================================ */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityPayrollMapping
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		MajorGlAccountCategoryId INT NOT NULL,
		MinorGlAccountCategoryId INT NOT NULL,
		FunctionalDepartmentId INT NOT NULL,
		FunctionalDepartmentCode VARCHAR(31) NULL,
		Reimbursable BIT NOT NULL,
		FeeOrExpense  VARCHAR(20) NOT NULL,
		ActivityTypeId INT NOT NULL,
		PropertyFundId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NOT NULL,
		OriginatingRegionCode CHAR(6) NULL,
		OriginatingRegionSourceCode VARCHAR(2) NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		AllocationUpdatedDate DATETIME NOT NULL,
		GlobalGlAccountCode VARCHAR(10) NULL,
		IsCorporateOverheadOverhead BIT NOT NULL,
		
		SourceTableName VARCHAR(128) NOT NULL
	)

	INSERT INTO #ProfitabilityPayrollMapping
	(
		ImportBatchId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		MajorGlAccountCategoryId,
		MinorGlAccountCategoryId,
		FunctionalDepartmentId,
		FunctionalDepartmentCode,
		Reimbursable,
		FeeOrExpense,
		ActivityTypeId,
		PropertyFundId,
		
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingRegionCode,
		OriginatingRegionSourceCode,
		LocalCurrencyCode,
		AllocationUpdatedDate,
		GlobalGlAccountCode,
		IsCorporateOverheadOverhead,
		
		SourceTableName
	)
	-- Get Base Salary Payroll pre tax mappings and budget
	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=SalaryPreTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.SalaryPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		''SalaryPreTax'' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,

		''N/A'' AS GlobalGlAccountCode, -- No GL Global Accounts for Payroll Data 
		
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps -- pull all pre-tax amounts that are not zero

		-- Used to map the Major and Minor Category Ids based on the SnapshotId
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			GlCategory.SnapshotId = pps.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Base Salary''
	WHERE
		pps.SalaryPreTaxAmount <> 0 -- Records which have a Base Salary amount

	-- Get Profit Share Benefit pre tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=ProfitSharePreTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.ProfitSharePreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		''ProfitSharePreTax'' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		''N/A'' AS GlobalGlAccountCode,
		
		CASE WHEN pps.ActivityTypeCode = ''CORPOH'' THEN
			1
		ELSE
			0
		END AS IsCorporateOverheadOverhead ,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId  

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits'' -- Profit Share maps to the Benefits GL Minor Category
	WHERE
		pps.ProfitSharePreTaxAmount <> 0 -- Records which have a Profit Share Amount

	-- Get Bonus pre tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=BonusPreTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		''BonusPreTax'' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,

		''N/A'' AS GlobalGlAccountCode,
		
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Bonus''
	WHERE
		pps.BonusPreTaxAmount <> 0 -- Records which have a bonus amount

	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=BonusCapExcessPreTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		GlCategory.GLMinorCategoryId AS MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		''BonusCapExcessPreTax'' FeeOrExpense,
		ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityPreTaxSource pps	

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId  

		-- Used to determine the Major and Minor Categories of records
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Bonus''

		/* If a project exceeds its Bonus Cap amount, a single project is selected in place of that project.
			The project Id is determined by the System Setting Region table.*/		
		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			pps.SourceCode = ssr.SourceCode AND
			pps.BudgetRegionId = ssr.RegionId

		LEFT OUTER JOIN #Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId

		-- Maps the Property Fund of the Bonus Cap Excess project		
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			pps.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1

		-- Maps the Allocation Sub Region of the Bonus Cap Excess project
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion AllocationRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = AllocationRegion.GlobalRegionId AND
			ProjectPropertyFund.SnapshotId = AllocationRegion.SnapshotId AND
			AllocationRegion.IsActive = 1

		-- Maps the Source of the record
		LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
			pps.SourceCode = GrSc.SourceCode  

		-- Maps the Property Fund for records with a period of before 201007	
		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			p.CorporateSourceCode = pfm.SourceCode AND
			pps.SnapshotId = pfm.SnapshotId AND
			--This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
			ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND --This is a bypass for the ''NULL'' scenario, for only CORP have ActivityTypeId''s set
			pfm.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
				)
			) AND
			pps.BudgetReportGroupPeriod < 201007

		-- Maps the Property Fund of the project based on the Corporate Department of the project.
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			p.CorporateSourceCode = RECD.SourceCode  AND
			pps.SnapshotId = RECD.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			p.CorporateSourceCode = REPE.SourceCode AND
			pps.SnapshotId = REPE.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
					ELSE
						CASE
							WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
							ELSE REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.SnapshotId = pps.SnapshotId AND 
			DepartmentPropertyFund.IsActive = 1
			
		-- Maps the Consolidation Region of a project based on the Corporate Department of the project
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON -- (CC16)
			GrSc.IsCorporate = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			p.CorporateSourceCode = CRCD.SourceCode  AND
			pps.SnapshotId  = CRCD.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201101

		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRPE.PropertyEntityCode AND
			p.CorporateSourceCode = CRPE.SourceCode AND
			pps.SnapshotId  = CRPE.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201101	

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			PPS.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, AllocationRegion.GlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1
	WHERE
		pps.BonusCapExcessPreTaxAmount <> 0

	UNION ALL

	-- Get Base Salary Payroll Tax mappings and budget
	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=SalaryTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.SalaryTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		''SalaryTaxTax'' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
	
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''
	WHERE
		pps.SalaryTaxAmount <> 0

	-- Get Profit Share Benefit Tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=ProfitShareTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.ProfitShareTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		''ProfitShareTax'' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityTaxSource pps

		INNER JOIN GrReporting.dbo.ActivityType Att ON 
			pps.ActivityTypeId = Att.ActivityTypeId AND
			pps.SnapshotId = Att.SnapshotId 

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId  = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''
	WHERE
		pps.ProfitShareTaxAmount <> 0

	-- Get Bonus Tax mappings and budget
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=BonusTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		pps.Reimbursable,  
		''BonusTax'' FeeOrExpense,
		pps.ActivityTypeId,
		pps.PropertyFundId,
		pps.AllocationSubRegionGlobalRegionId,
		pps.ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName 
	FROM
		#ProfitabilityTaxSource pps
	
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId  AND
			GlCategory.GLMinorCategoryName = ''Benefits''
	WHERE
		pps.BonusTaxAmount <> 0

	-- Get Bonus cap Tax mappings 
	UNION ALL

	SELECT
		pps.ImportBatchId,
		pps.BudgetReforecastTypeKey,
		pps.ReforecastKey,
		pps.SnapshotId,
		pps.BudgetId,
		pps.ReferenceCode + ''&Type=BonusCapExcessTax'' AS ReferenceCode,
		pps.ExpensePeriod,
		pps.SourceCode,
		pps.BonusCapExcessTaxAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MajorGlAccountCategoryId,
		pps.MinorGlAccountCategoryId, 
		pps.FunctionalDepartmentId,
		pps.FunctionalDepartmentCode,
		0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
		''BonusCapExcessTax'' FeeOrExpense,
		ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
			/*
				When selecting a Property Fund, the first option is is the Property Fund assigned to the Corporate Department of
				the Project - DepartmentPropertyFund. If the CorporateDepartmentCode field of the project is NULL or ''@'', the
				next option is the project''s PropertyFundId field - the ProjectPropertyFund.
			*/
		COALESCE(DepartmentPropertyFund.PropertyFundId, ProjectPropertyFund.PropertyFundId, -1) AS PropertyFundId,
		COALESCE(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId, ProjectPropertyFund.AllocationSubRegionGlobalRegionId -1) AS AllocationSubRegionGlobalRegionId,	
		ISNULL(ConsolidationRegion.GlobalRegionId, -1) AS ConsolidationSubRegionGlobalRegionId,
		pps.OriginatingRegionCode,
		pps.OriginatingRegionSourceCode,
		pps.LocalCurrencyCode,
		pps.AllocationUpdatedDate,
		
		''N/A'' AS GlobalGlAccountCode,
		CASE
			WHEN
				pps.ActivityTypeCode = ''CORPOH''
			THEN
				1
			ELSE
				0
		END AS IsCorporateOverheadOverhead,
		
		pps.SourceTableName
	FROM
		#ProfitabilityTaxSource pps	

		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pps.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''Benefits''
			
		-- This follows the same Bonus Cap Excess logic as before
					
		LEFT OUTER JOIN #SystemSettingRegion ssr ON
			pps.SourceCode = ssr.SourceCode AND
			pps.BudgetRegionId = ssr.RegionId

		LEFT OUTER JOIN #Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund ProjectPropertyFund ON
			p.PropertyFundId = ProjectPropertyFund.PropertyFundId AND
			pps.SnapshotId = ProjectPropertyFund.SnapshotId AND
			ProjectPropertyFund.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion AllocationRegion ON
			ProjectPropertyFund.AllocationSubRegionGlobalRegionId = AllocationRegion.GlobalRegionId  AND
			ProjectPropertyFund.SnapshotId = AllocationRegion.SnapshotId  AND
			AllocationRegion.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON 
			pps.SourceCode = GrSc.SourceCode 

		LEFT OUTER JOIN Gdm.SnapshotPropertyFundMapping pfm ON
			p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			p.CorporateSourceCode = pfm.SourceCode AND
			pps.SnapshotId = pfm.SnapshotId  AND
			pfm.IsDeleted = 0 AND 
			(
				(GrSc.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
				OR
				(
					(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId = p.ActivityTypeId)
					OR
					(GrSc.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
				)
			) AND
			pps.BudgetReportGroupPeriod < 201007
		
		LEFT OUTER JOIN	Gdm.SnapshotReportingEntityCorporateDepartment RECD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = RECD.CorporateDepartmentCode AND
			p.CorporateSourceCode = RECD.SourceCode AND
			pps.SnapshotId = RECD.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007
			   
		LEFT OUTER JOIN Gdm.SnapshotReportingEntityPropertyEntity REPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = REPE.PropertyEntityCode AND
			p.CorporateSourceCode = REPE.SourceCode AND
			pps.SnapshotId = REPE.SnapshotId AND
			pps.BudgetReportGroupPeriod >= 201007	
		
		LEFT OUTER JOIN Gdm.SnapshotPropertyFund DepartmentPropertyFund ON
			DepartmentPropertyFund.PropertyFundId =
				CASE
					WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
					ELSE
						CASE
							WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
							ELSE REPE.PropertyFundId
						END
				END AND
			DepartmentPropertyFund.SnapshotId = pps.SnapshotId AND
			DepartmentPropertyFund.IsActive = 1
			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD ON
			GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRCD.CorporateDepartmentCode AND
			p.CorporateSourceCode  = CRCD.SourceCode AND
			pps.SnapshotId = CRCD.SnapshotId  
			
		LEFT OUTER JOIN Gdm.SnapshotConsolidationRegionPropertyEntity CRPE ON
			GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
			LTRIM(RTRIM(p.CorporateDepartmentCode)) = CRPE.PropertyEntityCode  AND
			p.CorporateSourceCode = CRPE.SourceCode  AND
			pps.SnapshotId = CRPE.SnapshotId  
			
		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion ConsolidationRegion ON
			PPS.SnapshotId = ConsolidationRegion.SnapshotId AND
			ConsolidationRegion.GlobalRegionId = COALESCE(CRCD.GlobalRegionId, CRPE.GlobalRegionId, AllocationRegion.GlobalRegionId) AND
			ConsolidationRegion.IsConsolidationRegion = 1 AND
			ConsolidationRegion.IsActive = 1
	WHERE
		pps.BonusCapExcessTaxAmount <> 0
		
	-- Get Overhead mappings	
	UNION ALL

	SELECT
		pos.ImportBatchId,
		pos.BudgetReforecastTypeKey,
		pos.ReforecastKey,
		pos.SnapshotId,
		pos.BudgetId,
		pos.ReferenceCode + ''&Type=OverheadAllocation'' AS ReferenceCode,
		pos.ExpensePeriod,
		pos.SourceCode,
		pos.OverheadAllocationAmount AS BudgetAmount,
		GlCategory.GLMajorCategoryId AS MinorGlAccountCategoryId,
		pos.MinorGlAccountCategoryId, 
		pos.FunctionalDepartmentId,
		pos.FunctionalDepartmentCode,
		pos.Reimbursable,  
		''Overhead'' FeeOrExpense,
		pos.ActivityTypeId,
		pos.PropertyFundId,
		pos.AllocationSubRegionGlobalRegionId,
		pos.ConsolidationSubRegionGlobalRegionId,
		pos.OriginatingRegionCode,
		pos.OriginatingRegionSourceCode,
		pos.LocalCurrencyCode,
		pos.OverheadUpdatedDate,
		--General Allocated Overhead Account :: CC8
		''50029500''+RIGHT(''0''+LTRIM(STR(pos.ActivityTypeId,3,0)),2),
		1 AS IsCorporateOverhead,
		
		pos.SourceTableName
	FROM
		#ProfitabilityOverheadSource pos
		
		-- Maps the Major Category of the Overhead transaction
		INNER JOIN #PayrollGlobalMappings GlCategory ON
			pos.SnapshotId = GlCategory.SnapshotId AND
			GlCategory.GLMinorCategoryName = ''External General Overhead''
	WHERE
		pos.OverheadAllocationAmount <> 0

	PRINT ''Completed inserting records into #ProfitabilityPayrollMapping: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX UX_ProfitabilityPayrollMapping_ReferenceCode ON #ProfitabilityPayrollMapping(ReferenceCode)
	CREATE NONCLUSTERED INDEX IX_ProfitabilityPayrollMapping_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(AllocationUpdatedDate)

	PRINT ''Completed creating indexes on #ProfitabilityPayrollMapping''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ================================================================================================================================================
		7.	Create Global and Local Categorization mapping table
   ============================================================================================================================================= */
BEGIN
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Global Categorization Mapping

		The table below is used to map Gl Accounts to their Categorization Hierarchies for the Global Categorization.
		The GlobalGL Accounts used are the list from the #ActivityTypeGLAccount table created earlier.
	*/

	CREATE TABLE #GlGlobalAccount
	(
		GLGlobalAccountId INT NOT NULL,
		Code VARCHAR(10) NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GlGlobalAccount
	(
		GLGlobalAccountId,
		Code,
		SnapshotId
	)
	SELECT 
		GGA.GLGlobalAccountId,
		GGA.Code,
		GGA.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccount GGA
	WHERE
			GGA.Code LIKE ''50029500%'' AND
			GGA.IsActive = 1
	UNION
	SELECT
		0,
		''N/A'',
		S.SnapshotId
	FROM
		Gdm.[Snapshot] S

	CREATE TABLE #GlobalGLCategorizationMapping
	(
		GlobalGLCategorizationHierarchyKey VARCHAR(50) NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GlGlobalAccountCode VARCHAR(10) NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GlobalGLCategorizationMapping
	(
		GlobalGLCategorizationHierarchyKey,
		GLMajorCategoryId,
		GLMinorCategoryId,
		GlGlobalAccountCode,
		SnapshotId	
	)
	SELECT
		DIM.GLCategorizationHierarchyKey,
		GdmMappings.GLMajorCategoryId,
		GdmMappings.GLMinorCategoryId,
		GGA.Code AS GlGlobalAccountCode,
		GdmMappings.SnapshotId		
	FROM
		#GlGlobalAccount GGA
		INNER JOIN
		(
			SELECT
				GCT.GLCategorizationTypeId,
				GC.GLCategorizationId,
				GFC.GLFinancialCategoryId,
				MajC.GLMajorCategoryId GLMajorCategoryId,
				MinC.GLMinorCategoryId GLMinorCategoryId,
				GCT.SnapshotId
			FROM
				Gdm.SnapshotGLMinorCategory MinC
					
				INNER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId  = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1 
					
				INNER JOIN Gdm.SnapshotGLFinancialCategory GFC ON
					MajC.GLFinancialCategoryId  = GFC.GLFinancialCategoryId AND
					MajC.SnapshotId  = GFC.SnapshotId  
					
				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					GFC.GLCategorizationId = GC.GLCategorizationId AND
					GFC.SnapshotId = GC.SnapshotId AND
					GC.GLCategorizationId = 233
					
				INNER JOIN Gdm.SnapshotGLCategorizationType GCT ON
					GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId  AND
					GC.SnapshotId = GCT.SnapshotId  
			WHERE -- Limits it to the major categories and minor categories that are relevant to the budgets being processed
				(
					MajC.Name = ''Salaries/Taxes/Benefits'' OR
					(
						MinC.Name = ''External General Overhead'' AND
						MajC.Name = ''General Overhead''
					)
				) AND
				MinC.IsActive = 1
				
		) GdmMappings ON
			GGA.SnapshotId = GdmMappings.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
			DIM.GLCategorizationHierarchyCode = 
				CONVERT(VARCHAR(32),
					LTRIM(STR(GdmMappings.GLCategorizationTypeId, 10, 0)) + '':'' + 
					LTRIM(STR(GdmMappings.GLCategorizationId, 10, 0)) + '':'' +
					LTRIM(STR(GdmMappings.GLFinancialCategoryId, 10, 0)) + '':'' +
					LTRIM(STR(GdmMappings.GLMajorCategoryId, 10, 0)) + '':'' + 
					LTRIM(STR(GdmMappings.GLMinorCategoryId, 10, 0)) + '':'' +
					LTRIM(STR(ISNULL(GGA.GLGlobalAccountId, 0), 10, 0))) AND
			DIM.SnapshotId = GdmMappings.SnapshotId

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GlobalGLCategorizationMapping(SnapshotId, GlGlobalAccountCode, GLMajorCategoryId, GLMinorCategoryId)

		/*  ----------------------------------------------------------------------------------------------------------------------------------------
			Local Payroll Categorization Mappings

			The #LocalPayrollGLCategorizationMapping table below is used to determine the local GLCategorizationHierchy Codes.
			The table is pivoted (i.e. each of the GLCategorizationHierchy Codes for each GLCategorization appear as a separate column for each
				ActivityType-FunctionalDepartment combination)so that it only joins to the #ProfitabilityActual table below once.
			The Businss Logic for how Local Categorizations can be found at GR Change Control 21 [3.4.3.3]		
		*/

	CREATE TABLE #LocalPayrollGLCategorizationMapping(
		FunctionalDepartmentId INT NULL,
		ActivityTypeId INT NULL,
		PayrollTypeId INT NULL,
		GlobalGLMinorCategoryId INT NULL,
		SnapshotId INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL
	)
	INSERT INTO #LocalPayrollGLCategorizationMapping
	(
		FunctionalDepartmentId,
		ActivityTypeId,
		PayrollTypeId,
		GlobalGLMinorCategoryId,
		SnapshotId,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.FunctionalDepartmentId,
		PivotTable.ActivityTypeId,
		PivotTable.PayrollTypeId,
		PivotTable.GLMinorCategoryId,
		PivotTable.SnapshotId,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(
			SELECT DISTINCT
				FD.FunctionalDepartmentId,
				AType.ActivityTypeId,
				PPPGA.PayrollTypeId,
				MinCa.GLMinorCategoryId,
				PPPGA.SnapshotId,
				GC.Name as GLCategorizationName,
				ISNULL(DIM.GLCategorizationHierarchyKey, UnknownDIM.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey
			FROM
				Gdm.SnapshotPropertyPayrollPropertyGLAccount PPPGA

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(PPPGA.ActivityTypeId, 0) = CASE WHEN PPPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					PPPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1
					
				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(PPPGA.FunctionalDepartmentId, 0) = CASE WHEN PPPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					PPPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLMinorCategory MinCa ON
					MinCa.GLMinorCategoryId IN (SELECT GLMinorCategoryId FROM #PayrollGlobalMappings) AND
					ISNULL(PPPGA.GLMinorCategoryId, 0) = CASE WHEN PPPGA.GLMinorCategoryId IS NULL THEN 0 ELSE MinCa.GLMinorCategoryId END AND
					PPPGA.SnapshotId = MinCa.SnapshotId AND
					MinCa.IsActive = 1

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					PPPGA.GLCategorizationId = GC.GLCategorizationId AND
					PPPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					PPPGA.PropertyGLAccountId = GA.GLAccountId  AND
					PPPGA.SnapshotId = GA.SnapshotID  AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount 
						local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyPayrollPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					GGA.GLGlobalAccountId = 
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GA.GLGlobalAccountId
							ELSE
								PPPGA.GLGlobalAccountId
						END AND
					PPPGA.SnapshotId = GGA.SnapshotId  AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId   AND
					PPPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId  
				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					MinC.GLMinorCategoryId =
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END AND
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.IsActive = 1  

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1  

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
					GC.GLCategorizationId  = FinC.GLCategorizationId AND
					MajC.SnapshotId = FinC.SnapshotId  

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), FinC.GLFinancialCategoryId) END + '':'' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), MajC.GLMajorCategoryId) END + '':'' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), MinC.GLMinorCategoryId) END + '':'' +
						(CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))) AND
					FinC.SnapshotId = DIM.SnapshotId 

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownDIM ON
					UnknownDIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						'':-1:-1:-1:'' + CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					PPPGA.SnapshotId = UnknownDIM.SnapshotId
			WHERE
				ISNULL(PPPGA.IsActive, 1) = 1
		) LocalMappings
		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #LocalPayrollGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId, PayrollTypeId, GlobalGLMinorCategoryId,	SnapshotId)

		/*
			Overhead Budget transactions are mapped differently from the Payroll transactions.
			Overhead transactions use the SnapshotPropertyOverheadPropertyGLAccount table instead of the SnapshotPropertyPayrollPropertyGLAccount
			table. They are mapped in the same way as overhead actuals except Snapshot tables are used.
			The details of the Overhead mappings can be found in Change Control 21 [3.4.3.3.3]
		*/

	CREATE TABLE #LocalOverheadGLCategorizationMapping
	(
		FunctionalDepartmentId INT NULL,
		ActivityTypeId INT NULL,
		SnapshotId INT NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL
	)
	INSERT INTO #LocalOverheadGLCategorizationMapping
	(
		FunctionalDepartmentId,
		ActivityTypeId,
		SnapshotId,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.FunctionalDepartmentId,
		PivotTable.ActivityTypeId,
		PivotTable.SnapshotId,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(
			SELECT DISTINCT
				FD.FunctionalDepartmentId,
				AType.ActivityTypeId,
				POPGA.SnapshotId,
				GC.Name as GLCategorizationName,
				ISNULL(DIM.GLCategorizationHierarchyKey, UnknownDIM.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey
			FROM
				Gdm.SnapshotPropertyOverheadPropertyGLAccount POPGA

				INNER JOIN Gdm.SnapshotActivityType AType ON
					ISNULL(POPGA.ActivityTypeId, 0) = CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END AND
					POPGA.SnapshotId = AType.SnapshotId AND
					AType.IsActive = 1

				INNER JOIN Gdm.SnapshotFunctionalDepartment FD ON
					ISNULL(POPGA.FunctionalDepartmentId, 0) = CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END AND
					POPGA.SnapshotId = FD.SnapshotId AND
					FD.IsActive = 1

				INNER JOIN Gdm.SnapshotGLCategorization GC ON
					POPGA.GLCategorizationId = GC.GLCategorizationId AND
					POPGA.SnapshotId = GC.SnapshotId AND
					GC.IsActive = 1

				INNER JOIN Gdm.SnapshotGLAccount GA ON
					POPGA.PropertyGLAccountId = GA.GLAccountId  AND
					POPGA.SnapshotId = GA.SnapshotId  AND
					GA.IsActive = 1
				/*
					If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
					If the local Categorization is not configured for recharge, the Global account is determined directly from the 
						#PropertyOverheadPropertyGLAccount table
				*/
				INNER JOIN Gdm.SnapshotGLGlobalAccount GGA ON
					GGA.GLGlobalAccountId = 
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GA.GLGlobalAccountId
							ELSE
								POPGA.GLGlobalAccountId
						END AND
					GGA.SnapshotId = POPGA.SnapshotId AND
					GGA.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLGlobalAccountCategorization GGAC ON
					GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
					POPGA.GLCategorizationId = GGAC.GLCategorizationId AND
					GGA.SnapshotId = GGAC.SnapshotId  
				/*
					If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
						in the #GLGlobalAccountCategorization table.
					If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
						field in the #GLGlobalAccountCategorization table.
				*/	
				LEFT OUTER JOIN Gdm.SnapshotGLMinorCategory MinC ON
					MinC.GLMinorCategoryId =
						CASE 
							WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
								GGAC.CoAGLMinorCategoryId
							ELSE
								GGAC.DirectGLMinorCategoryId
						END AND
					GGAC.SnapshotId = MinC.SnapshotId AND
					MinC.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
					MinC.SnapshotId = MajC.SnapshotId AND
					MajC.IsActive = 1

				LEFT OUTER JOIN Gdm.SnapshotGLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					GC.GLCategorizationId = FinC.GLCategorizationId AND
					GC.SnapshotId = FinC.SnapshotId  

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
					DIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), FinC.GLFinancialCategoryId) END + '':'' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), MajC.GLMajorCategoryId) END + '':'' +
						CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), MinC.GLMinorCategoryId) END + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					FinC.SnapshotId = DIM.SnapshotId 

				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownDIM ON
					UnknownDIM.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
						''-1:-1:-1:'' + CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					POPGA.SnapshotId = UnknownDIM.SnapshotId
			WHERE
				ISNULL(POPGA.IsActive, 1) = 1
		) LocalMappings
		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #LocalOverheadGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId, SnapshotId)

END

/* ===============================================================================================================================================
	8.	Map table to the #ProfitabilityBudget table with the same structure as the GrReporting.dbo.ProfitabilityBudget table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityBudget
	(
		ImportBatchId INT NOT NULL,
		BudgetReforecastTypeKey INT NOT NULL,
		ReforecastKey INT NOT NULL,
		CalendarKey INT NOT NULL,
		SourceKey INT NOT NULL,
		FunctionalDepartmentKey INT NOT NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeKey INT NOT NULL,
		PropertyFundKey INT NOT NULL,	
		AllocationRegionKey INT NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey INT NOT NULL,
		OverheadKey INT NOT NULL,
		LocalCurrencyKey INT NOT NULL,
		LocalBudget MONEY NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId INT NOT NULL,
		SnapshotId INT NOT NULL,
		GlobalGLCategorizationHierarchyKey INT NOT NULL,
		USPropertyGLCategorizationHierarchyKey INT NOT NULL,
		USFundGLCategorizationHierarchyKey INT NOT NULL,
		EUPropertyGLCategorizationHierarchyKey INT NOT NULL,
		EUFundGLCategorizationHierarchyKey INT NOT NULL,
		USDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		EUDevelopmentGLCategorizationHierarchyKey INT NOT NULL,
		ReportingGLCategorizationHierarchyKey INT NOT NULL,
		
		SourceSystemKey INT NOT NULL
	) 

	INSERT INTO #ProfitabilityBudget 
	(
		ImportBatchId, 
		BudgetReforecastTypeKey,
		ReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		SnapshotId,
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		pbm.ImportBatchId,
		pbm.BudgetReforecastTypeKey,
		pbm.ReforecastKey,
		DATEDIFF(dd, ''1900-01-01'', LEFT(pbm.ExpensePeriod, 4) + ''-'' + RIGHT(pbm.ExpensePeriod, 2) + ''-01'') AS CalendarKey,
		ISNULL(GrSc.SourceKey, @SourceKey) SourceKey,
		ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKey) FunctionalDepartmentKey,
		ISNULL(GrRi.ReimbursableKey, @ReimbursableKey) ReimbursableKey,
		ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKey) ActivityTypeKey,
		ISNULL(GrPf.PropertyFundKey, @PropertyFundKey)PropertyFundKey,
		ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKey) AllocationRegionKey,
		ISNULL(Grcr.AllocationRegionKey, @AllocationRegionKey) ConsolidationRegionRegionKey,
		ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKey) OriginatingRegionKey,
		ISNULL(GrOh.OverheadKey, @OverheadKey) OverheadKey,
		ISNULL(GrCu.CurrencyKey, @LocalCurrencyKey) LocalCurrencyKey,
		pbm.BudgetAmount,
		pbm.ReferenceCode,
		pbm.BudgetId,
		pbm.SnapshotId,
		COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey), -- GlobalGLCategorizationHierarchyKey
			/*
				For local categorizations, if it is an overhead transaction, it maps to the #LocalOverheadGLCategorizationMapping table. If it
				is a payroll budget record, it maps to the #LocalPayrollGLCategorizationMapping table.
				A record will only join to the #LocalOverheadGLCategorizationMapping table if it''s an Overhead transaction (and therefore
				be NULL if its a Payroll transaction). Similarly, a record will only join to the #LocalPayrollGLCategorizationMapping table
				if its an Overhead transaction.
			*/
		COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey), -- USPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey), -- USFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey), -- EUPropertyGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey), -- EUFundGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey), -- USDevelopmentGLCategorizationHierarchyKey
		COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown), -- EUDevelopmentGLCategorizationHierarchyKey
		/*
			The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
			when a local report is generated.
		*/
		CASE 
			WHEN
				GC.GLCategorizationId IS NOT NULL
			THEN
				CASE
					WHEN
						GC.Name = ''US Property'' 
					THEN
						COALESCE(LocalPayrollMapping.USPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
					WHEN
						GC.Name = ''US Fund'' 
					THEN
						COALESCE(LocalPayrollMapping.USFundGLCategorizationHierarchyKey, LocalOverheadMapping.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
					WHEN
						GC.Name = ''EU Property'' 
					THEN
						COALESCE(LocalPayrollMapping.EUPropertyGLCategorizationHierarchyKey, LocalOverheadMapping.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
					WHEN
						GC.Name = ''EU Fund'' 
					THEN
						COALESCE(LocalPayrollMapping.EUFundGLCategorizationHierarchyKey, LocalOverheadMapping.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
					WHEN
						GC.Name = ''US Development'' 
					THEN
						COALESCE(LocalPayrollMapping.USDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
					WHEN
						GC.Name = ''EU Development'' 
					THEN
						COALESCE(LocalPayrollMapping.EUDevelopmentGLCategorizationHierarchyKey, LocalOverheadMapping.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					WHEN
						GC.Name = ''Global''
					THEN
						COALESCE(GlobalMapping.GlobalGLCategorizationHierarchyKey, UnknownMapping.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
					ELSE
						@GLCategorizationHierarchyKeyUnknown
				END
				
			ELSE @GLCategorizationHierarchyKeyUnknown
		END, --  ReportingGLCategorizationHierarchyKey
		
		SSystem.SourceSystemKey
	FROM
		#ProfitabilityPayrollMapping pbm

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			pbm.SnapshotId = SSHot.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
			pbm.SourceCode = GrSc.SourceCode  

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			pbm.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = ''TapasGlobalBudgeting''

		--Parent Level (No job code for payroll)
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
			SShot.LastSyncDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
			GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
			pbm.FunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode  

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN pbm.Reimbursable = 1 THEN ''YES'' ELSE ''NO'' END = GrRi.ReimbursableCode

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
			pbm.ActivityTypeId = GrAt.ActivityTypeId AND
			pbm.SnapshotId = GrAt.SnapshotId  

		LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
			--GC :: Change Control 1
			GrOh.OverheadCode =
				CASE
					WHEN
						pbm.FeeOrExpense = ''Overhead''
					THEN
						''ALLOC''
					WHEN
						GrAt.ActivityTypeCode = ''CORPOH''
					THEN
						''UNALLOC''
					ELSE
						''N/A''
				END

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
			pbm.PropertyFundId = GrPf.PropertyFundId AND
			pbm.SnapshotId = GrPf.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotAllocationSubRegion ASR ON
			pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			pbm.SnapshotId  = ASR.SnapshotId AND
			ASR.IsActive = 1  

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
			ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
			pbm.SnapshotId = GrAr.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotGlobalRegion CSR ON -- CC16
			pbm.ConsolidationSubRegionGlobalRegionId = CSR.GlobalRegionId AND
			pbm.SnapshotId = CSR.SnapshotId AND
			CSR.IsConsolidationRegion = 1 AND
			CSR.IsActive = 1

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- CC16
			CSR.GlobalRegionId = GrCr.GlobalRegionId AND
			pbm.SnapshotId = GrCr.SnapshotId  

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionCorporateEntity ORCE ON
			pbm.OriginatingRegionCode = ORCE.CorporateEntityCode  AND
			pbm.OriginatingRegionSourceCode = ORCE.SourceCode  AND
			pbm.SnapshotId  = ORCE.SnapshotId

		LEFT OUTER JOIN Gdm.SnapshotOriginatingRegionPropertyDepartment ORPD ON
			pbm.OriginatingRegionCode = ORPD.PropertyDepartmentCode AND
			pbm.OriginatingRegionSourceCode = ORPD.SourceCode AND
			pbm.SnapshotId = ORPD.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
			ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) = GrOr.GlobalRegionId AND
			pbm.SnapshotId = GrOr.SnapshotId  

		LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
			pbm.LocalCurrencyCode = GrCu.CurrencyCode

		LEFT OUTER JOIN Gdm.SnapshotGLMinorCategoryPayrollType MCPT ON
			pbm.MinorGlAccountCategoryId = MCPT.GLMinorCategoryId AND
			pbm.SnapshotId = MCPT.SnapshotId  

		LEFT OUTER JOIN #FunctionalDepartment FD ON
			pbm.FunctionalDepartmentCode = FD.GlobalCode 

		LEFT OUTER JOIN #GlobalGLCategorizationMapping GlobalMapping ON
			pbm.SnapshotId = GlobalMapping.SnapshotId  AND
			pbm.GlobalGlAccountCode = GlobalMapping.GlGlobalAccountCode AND
			pbm.MinorGlAccountCategoryId = GlobalMapping.GLMinorCategoryId AND
			pbm.MajorGlAccountCategoryId = GlobalMapping.GLMajorCategoryId  

		LEFT OUTER JOIN  #LocalPayrollGLCategorizationMapping LocalPayrollMapping ON
			FD.FunctionalDepartmentId = LocalPayrollMapping.FunctionalDepartmentId AND
			pbm.ActivityTypeId = LocalPayrollMapping.ActivityTypeId AND
			MCPT.PayrollTypeId = LocalPayrollMapping.PayrollTypeId AND
			pbm.MinorGlAccountCategoryId  = LocalPayrollMapping.GlobalGLMinorCategoryId AND
			pbm.SnapshotId = LocalPayrollMapping.SnapshotId AND
			pbm.IsCorporateOverheadOverhead = 0 -- Only records that aren''t Corporate Overhead records

		LEFT OUTER JOIN #LocalOverheadGLCategorizationMapping LocalOverheadMapping ON
			FD.FunctionalDepartmentId = LocalOverheadMapping.FunctionalDepartmentId  AND
			pbm.ActivityTypeId = LocalOverheadMapping.ActivityTypeId AND
			pbm.SnapshotId = LocalOverheadMapping.SnapshotId AND
			pbm.IsCorporateOverheadOverhead = 1 -- Corporate Overhead records only

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownMapping ON
			pbm.SnapshotId = UnknownMapping.SnapshotId AND
			pbm.GlobalGlAccountCode = UnknownMapping.GLAccountCode AND
			UnknownMapping.GLCategorizationName = ''Global'' AND
			UnknownMapping.GLMajorCategoryName = ''UNKNOWN''

		LEFT OUTER JOIN Gdm.SnapshotPropertyFund PF ON
			pbm.SnapshotId = PF.SnapshotID AND
			pbm.PropertyFundId = PF.PropertyFundId 

		LEFT OUTER JOIN Gdm.SnapshotReportingCategorization RC ON
			pbm.SnapshotId = RC.SnapshotId AND
			pbm.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId  

		LEFT OUTER JOIN Gdm.SnapshotGLCategorization GC ON
			RC.SnapshotId = GC.SnapshotId AND
			RC.GLCategorizationId = GC.GLCategorizationId  

	PRINT ''Completed inserting records into #ProfitabilityBudget: ''+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)

	PRINT ''Completed creating indexes on #OriginatingRegionMapping''
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ===============================================================================================================================================
	9.	Insert records with unknowns into the ProfitabilityBudgetUnknowns table.
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	DELETE
		dbo.ProfitabilityBudgetUnknowns
	WHERE
		BudgetReforecastTypeKey = @BudgetReforecastTypeKey

	INSERT INTO dbo.ProfitabilityBudgetUnknowns
	(
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey, -- CC16
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,

		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,

		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId,
		
		SourceSystemKey
	   )
	SELECT
		b.ImportBatchId,
		pb.CalendarKey,
		pb.SourceKey,
		pb.FunctionalDepartmentKey,
		pb.ReimbursableKey,
		pb.ActivityTypeKey,
		pb.PropertyFundKey,
		pb.AllocationRegionKey,
		pb.ConsolidationRegionKey,
		pb.OriginatingRegionKey,
		pb.LocalCurrencyKey,
		pb.LocalBudget,
		pb.ReferenceCode,
		
		pb.GlobalGLCategorizationHierarchyKey,
		pb.USPropertyGLCategorizationHierarchyKey,
		pb.USFundGLCategorizationHierarchyKey,
		pb.EUPropertyGLCategorizationHierarchyKey,
		pb.EUFundGLCategorizationHierarchyKey,
		pb.USDevelopmentGLCategorizationHierarchyKey,
		pb.EUDevelopmentGLCategorizationHierarchyKey,
		pb.ReportingGLCategorizationHierarchyKey,
		
		pb.BudgetId,
		pb.OverheadKey,
		@NormalFeeAdjustmentKey AS FeeAdjustmentKey,	
		BudgetReforecastTypeKey,
		pb.SnapshotId,
		
		pb.SourceSystemKey
	FROM 
		#ProfitabilityBudget pb
		INNER JOIN #Budget b ON
			pb.BudgetId = b.BudgetId	
	WHERE	
		@SourceKey = pb.SourceKey OR
		@FunctionalDepartmentKey = pb.FunctionalDepartmentKey OR
		@ReimbursableKey = pb.ReimbursableKey OR
		@ActivityTypeKey = pb.ActivityTypeKey OR
		@PropertyFundKey = pb.PropertyFundKey OR
		@AllocationRegionKey = pb.AllocationRegionKey OR
		@OriginatingRegionKey = pb.OriginatingRegionKey OR
		@LocalCurrencyKey = pb.LocalCurrencyKey OR
		@GLCategorizationHierarchyKeyUnknown = GlobalGLCategorizationHierarchyKey

	PRINT ''Completed inserting records into ProfitabilityBudgetUnknowns: '' + CONVERT(CHAR(10), @@ROWCOUNT)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	/******* Remove rows from staging import batch which are associated with budgets with unknowns ******/
	SET @StartTime = GETDATE()

	CREATE TABLE #DeletingBudget
	(
		BudgetId INT NOT NULL
	)

	INSERT INTO #DeletingBudget
	(
		BudgetId
	)
	SELECT DISTINCT 
		BudgetId
	FROM
		dbo.ProfitabilityBudgetUnknowns

	SET @RowCount = @@ROWCOUNT
	PRINT ''Completed inserting records into #DeletingBudget: '' + CONVERT(CHAR(10), @RowCount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@RowCount > 0)
	BEGIN
		INSERT INTO @ImportErrorTable (Error) SELECT ''Unknowns found in budget''
	END

	CREATE TABLE #BudgetsToImportOriginal
	(   -- we keep an original copy of the budgets to insert because #BudgetsToImport will always be empty after the loop below
		BudgetId INT NOT NULL
	)
	INSERT INTO #BudgetsToImportOriginal
	(
		BudgetId
	)
	SELECT DISTINCT 
		BudgetId
	FROM
		#ProfitabilityBudget

	CREATE TABLE #BudgetsToImport
	(
		BudgetId INT NOT NULL
	)
	INSERT INTO #BudgetsToImport
	(
		BudgetId
	)
	SELECT
		BudgetId
	FROM
		#BudgetsToImportOriginal

END

/* ================================================================================================================================================
	10. Insert budget records into the GrReporting.dbo.ProfitabilityBudget table
   ============================================================================================================================================= */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #SummaryOfChanges
	(
		Change VARCHAR(20)
	)
	INSERT INTO #SummaryOfChanges
	(
		Change
	)
	SELECT
		Change
	FROM
	(
		MERGE 
			GrReporting.dbo.ProfitabilityBudget FACT
		USING
			#ProfitabilityBudget AS SRC ON
				FACT.ReferenceCode = SRC.ReferenceCode
		WHEN
			MATCHED AND
			(
				FACT.CalendarKey <> SRC.CalendarKey OR
				FACT.SourceKey <> SRC.SourceKey OR
				FACT.FunctionalDepartmentKey <> SRC.FunctionalDepartmentKey OR
				FACT.ReimbursableKey <> SRC.ReimbursableKey OR
				FACT.ActivityTypeKey <> SRC.ActivityTypeKey OR
				FACT.PropertyFundKey <> SRC.PropertyFundKey OR
				FACT.AllocationRegionKey <> SRC.AllocationRegionKey OR
				FACT.OriginatingRegionKey <> SRC.OriginatingRegionKey OR
				FACT.LocalCurrencyKey <> SRC.LocalCurrencyKey OR
				FACT.LocalBudget <> SRC.LocalBudget OR
				FACT.OverheadKey <> SRC.OverheadKey OR
				FACT.FeeAdjustmentKey <> @FeeAdjustmentKey OR
				FACT.SnapshotId <> SRC.SnapshotId OR
				FACT.ReforecastKey <> SRC.ReforecastKey OR
				FACT.ConsolidationRegionKey <> SRC.ConsolidationRegionKey OR
				ISNULL(FACT.GlobalGLCategorizationHierarchyKey, '''') <> SRC.GlobalGLCategorizationHierarchyKey OR
				ISNULL(FACT.EUDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.EUDevelopmentGLCategorizationHierarchyKey OR
				ISNULL(FACT.EUPropertyGLCategorizationHierarchyKey, '''') <> SRC.EUPropertyGLCategorizationHierarchyKey OR
				ISNULL(FACT.EUFundGLCategorizationHierarchyKey, '''') <> SRC.EUFundGLCategorizationHierarchyKey OR
				ISNULL(FACT.USDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.USDevelopmentGLCategorizationHierarchyKey OR
				ISNULL(FACT.USPropertyGLCategorizationHierarchyKey, '''') <> SRC.USPropertyGLCategorizationHierarchyKey OR
				ISNULL(FACT.USFundGLCategorizationHierarchyKey, '''') <> SRC.USFundGLCategorizationHierarchyKey OR
				ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '''') <> SRC.ReportingGLCategorizationHierarchyKey OR 
				ISNULL(FACT.SourceSystemKey, '''') <> SRC.SourceSystemKey
			)
		THEN
			UPDATE
			SET
				FACT.CalendarKey = SRC.CalendarKey,
				FACT.SourceKey = SRC.SourceKey,
				FACT.FunctionalDepartmentKey = SRC.FunctionalDepartmentKey,
				FACT.ReimbursableKey = SRC.ReimbursableKey,
				FACT.ActivityTypeKey = SRC.ActivityTypeKey,
				FACT.PropertyFundKey = SRC.PropertyFundKey,
				FACT.AllocationRegionKey = SRC.AllocationRegionKey,
				FACT.OriginatingRegionKey = SRC.OriginatingRegionKey,
				FACT.LocalCurrencyKey = SRC.LocalCurrencyKey,
				FACT.LocalBudget = SRC.LocalBudget,
				FACT.OverheadKey = SRC.OverheadKey,
				FACT.FeeAdjustmentKey = @FeeAdjustmentKey,
				FACT.SnapshotId = SRC.SnapshotId,
				FACT.ReforecastKey = SRC.ReforecastKey,
				FACT.ConsolidationRegionKey = SRC.ConsolidationRegionKey,
				FACT.GlobalGLCategorizationHierarchyKey = SRC.GlobalGLCategorizationHierarchyKey,
				FACT.EUDevelopmentGLCategorizationHierarchyKey = SRC.EUDevelopmentGLCategorizationHierarchyKey,
				FACT.EUPropertyGLCategorizationHierarchyKey = SRC.EUPropertyGLCategorizationHierarchyKey,
				FACT.EUFundGLCategorizationHierarchyKey = SRC.EUFundGLCategorizationHierarchyKey,
				FACT.USDevelopmentGLCategorizationHierarchyKey = SRC.USDevelopmentGLCategorizationHierarchyKey,
				FACT.USPropertyGLCategorizationHierarchyKey = SRC.USPropertyGLCategorizationHierarchyKey,
				FACT.USFundGLCategorizationHierarchyKey = SRC.USFundGLCategorizationHierarchyKey,
				FACT.ReportingGLCategorizationHierarchyKey = SRC.ReportingGLCategorizationHierarchyKey,
				FACT.UpdatedDate = @StartTime,
				FACT.SourceSystemKey = SRC.SourceSystemKey
		WHEN
			NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				SnapshotId,
				BudgetReforecastTypeKey,
				ReforecastKey,
				CalendarKey,
				SourceKey,
				FunctionalDepartmentKey,
				ReimbursableKey,
				ActivityTypeKey,
				PropertyFundKey,
				AllocationRegionKey,
				ConsolidationRegionKey,
				OriginatingRegionKey,
				OverheadKey,
				FeeAdjustmentKey,
				LocalCurrencyKey,
				LocalBudget,
				ReferenceCode,
				BudgetId,
				
				GlobalGLCategorizationHierarchyKey,
				USPropertyGLCategorizationHierarchyKey,
				USFundGLCategorizationHierarchyKey,
				EUPropertyGLCategorizationHierarchyKey,
				EUFundGLCategorizationHierarchyKey,
				USDevelopmentGLCategorizationHierarchyKey,
				EUDevelopmentGLCategorizationHierarchyKey,
				ReportingGLCategorizationHierarchyKey,
				InsertedDate,
				UpdatedDate,
				
				SourceSystemKey
			)
			VALUES
			(
				SRC.SnapshotId,
				SRC.BudgetReforecastTypeKey,
				SRC.ReforecastKey,
				SRC.CalendarKey,
				SRC.SourceKey,
				SRC.FunctionalDepartmentKey,
				SRC.ReimbursableKey,
				SRC.ActivityTypeKey,
				SRC.PropertyFundKey,
				SRC.AllocationRegionKey,
				SRC.ConsolidationRegionKey,
				SRC.OriginatingRegionKey,
				SRC.OverheadKey,
				@FeeAdjustmentKey,
				SRC.LocalCurrencyKey,
				SRC.LocalBudget,
				SRC.ReferenceCode,
				SRC.BudgetId,
				
				SRC.GlobalGLCategorizationHierarchyKey,
				SRC.USPropertyGLCategorizationHierarchyKey,
				SRC.USFundGLCategorizationHierarchyKey,
				SRC.EUPropertyGLCategorizationHierarchyKey,
				SRC.EUFundGLCategorizationHierarchyKey,
				SRC.USDevelopmentGLCategorizationHierarchyKey,
				SRC.EUDevelopmentGLCategorizationHierarchyKey,
				SRC.ReportingGLCategorizationHierarchyKey,
				@StartTime,
				@StartTime,
				
				SRC.SourceSystemKey
			)
		WHEN
			NOT MATCHED BY SOURCE AND
			FACT.BudgetId IN (SELECT BudgetId FROM #BudgetsToImport) AND
			FACT.BudgetReforecastTypeKey = @BudgetReforecastTypeKey
		THEN
			DELETE
		OUTPUT
				$action AS Change
	) AS InsertedData

	CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

	DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''INSERT'')
	DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''UPDATE'')
	DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''DELETE'')

	PRINT ''Rows added to ProfitabilityBudget: ''+ CONVERT(char(10), @InsertedRows)
	PRINT ''Rows updated in ProfitabilityBudget: ''+ CONVERT(char(10),@UpdatedRows)
	PRINT ''Rows deleted from ProfitabilityBudget: ''+ CONVERT(char(10),@DeletedRows)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ================================================================================================================================================
	11. Mark budgets as being successfully processed into the warehouse
   ============================================================================================================================================= */
BEGIN

	UPDATE
		BTP
	SET
		OriginalBudgetProcessedIntoWarehouse = 1,
		DateBudgetProcessedIntoWarehouse = GETDATE()
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcess BTPTemp ON
			BTP.BudgetsToProcessId = BTPTemp.BudgetsToProcessId		
	
	PRINT (''Rows updated from dbo.BudgetsToProcess: '' + CONVERT(VARCHAR(10), @@rowcount))

END

/* ================================================================================================================================================
	12. Clean Up
   ============================================================================================================================================= */
BEGIN

	IF OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF OBJECT_ID(''tempdb..#SystemSettingRegion'') IS NOT NULL
		DROP TABLE #SystemSettingRegion

	IF OBJECT_ID(''tempdb..#BudgetAllocationSetSnapshots'') IS NOT NULL
		DROP TABLE #BudgetAllocationSetSnapshots

	IF OBJECT_ID(''tempdb..#Budget'') IS NOT NULL
		DROP TABLE #Budget

	IF OBJECT_ID(''tempdb..#BudgetProject'') IS NOT NULL
		DROP TABLE #BudgetProject

	IF OBJECT_ID(''tempdb..#Region'') IS NOT NULL
		DROP TABLE #Region

	IF OBJECT_ID(''tempdb..#BudgetEmployee'') IS NOT NULL
		DROP TABLE #BudgetEmployee

	IF OBJECT_ID(''tempdb..#BudgetEmployeeFunctionalDepartment'') IS NOT NULL
		DROP TABLE #BudgetEmployeeFunctionalDepartment

	IF OBJECT_ID(''tempdb..#Location'') IS NOT NULL
		DROP TABLE #Location

	IF OBJECT_ID(''tempdb..#RegionExtended'') IS NOT NULL
		DROP TABLE #RegionExtended

	IF OBJECT_ID(''tempdb..#Project'') IS NOT NULL
		DROP TABLE #Project

	IF OBJECT_ID(''tempdb..#BudgetEmployeePayrollAllocation'') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocation

	IF OBJECT_ID(''tempdb..#BudgetEmployeePayrollAllocationDetail'') IS NOT NULL
		DROP TABLE #BudgetEmployeePayrollAllocationDetail

	IF OBJECT_ID(''tempdb..#BudgetTaxType'') IS NOT NULL
		DROP TABLE #BudgetTaxType

	IF OBJECT_ID(''tempdb..#TaxType'') IS NOT NULL
		DROP TABLE #TaxType

	IF OBJECT_ID(''tempdb..#EmployeePayrollAllocationDetail'') IS NOT NULL
		DROP TABLE #EmployeePayrollAllocationDetail

	IF OBJECT_ID(''tempdb..#BudgetOverheadAllocation'') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocation

	IF OBJECT_ID(''tempdb..#BudgetOverheadAllocationDetail'') IS NOT NULL
		DROP TABLE #BudgetOverheadAllocationDetail

	IF OBJECT_ID(''tempdb..#OverheadAllocationDetail'') IS NOT NULL
		DROP TABLE #OverheadAllocationDetail

	IF OBJECT_ID(''tempdb..#EffectiveFunctionalDepartment'') IS NOT NULL
		DROP TABLE #EffectiveFunctionalDepartment

	IF OBJECT_ID(''tempdb..#ProfitabilityPreTaxSource'') IS NOT NULL
		DROP TABLE #ProfitabilityPreTaxSource

	IF OBJECT_ID(''tempdb..#ProfitabilityTaxSource'') IS NOT NULL
		DROP TABLE #ProfitabilityTaxSource

	IF OBJECT_ID(''tempdb..#ProfitabilityOverheadSource'') IS NOT NULL
		DROP TABLE #ProfitabilityOverheadSource

	IF OBJECT_ID(''tempdb..#ProfitabilityPayrollMapping'') IS NOT NULL
		DROP TABLE #ProfitabilityPayrollMapping

	IF OBJECT_ID(''tempdb..#ProfitabilityBudget'') IS NOT NULL
		DROP TABLE #ProfitabilityBudget

	IF OBJECT_ID(''tempdb..#DeletingBudget'') IS NOT NULL
		DROP TABLE #DeletingBudget

	IF OBJECT_ID(''tempdb..#BudgetsToImportOriginal'') IS NOT NULL
		DROP TABLE #BudgetsToImportOriginal

	IF OBJECT_ID(''tempdb..#GlobalCategoryLookup'') IS NOT NULL
		DROP TABLE #GlobalCategoryLookup

	IF OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF OBJECT_ID(''tempdb..#DistinctImports'') IS NOT NULL
		DROP TABLE #DistinctImports

	IF OBJECT_ID(''tempdb..#GlGlobalAccount'') IS NOT NULL
		DROP TABLE #GlGlobalAccount

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*********************************************************************************************************************
Description
	This stored procedure processes non-payroll and fee budget reforecast information and uploads it to the
	ProfitabilityReforecast table in the data warehouse (GrReporting.dbo.ProfitabilityReforecast)
	
		1.	Get Budgets to Process
		2.	Declare local variables and create common tables
		3.	Source Budget data from GBS.Budget
		4.	Source Snapshot mapping data from GDM
		5.	Create master GL Account Category mapping table
		6.	Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
		7.	Get Non-Payroll Expense BUDGET items from GBS 
		8.	Get Fee BUDGET items from GBS 
		9.	Get Fee Income and Non-Payroll Expense ACTUALS from GBS.BudgetProfitabilityActual 
		10.	Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
		11.	Update #ProfitibilityReforecast.GlobalGlCategorizationHierarchyKey
		12.	Delete budgets to insert that have UNKNOWNS in their mapping
		13.	Insert, Update and Delete records from Fact table
		14.	Mark budgets as being successfully processed into the warehouse
		15.	Clean up	
	
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSReforecast]
		@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyGBSReforecast''
PRINT ''####''

IF (CONVERT(INT, (SELECT TOP 1 ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportGBSReforecast'')) <> 1)
BEGIN
	PRINT (''Import of GBS Reforecasts is not scheduled in GrReportingStaging.dbo.SSISConfigurations'')
	RETURN
END

DECLARE @StartTime DATETIME = GETDATE()

/* ==============================================================================================================================================
	1.	Get Budgets to Process
   =========================================================================================================================================== */
BEGIN

	SELECT 
		BTPC.*, 
		Reforecast.ReforecastKey
	INTO 
		#BudgetsToProcess 
	FROM 
		dbo.BudgetsToProcess BTPC
		INNER JOIN 
		(
			SELECT
				MIN(ReforecastKey) AS ReforecastKey,
				ReforecastQuarterName,
				ReforecastEffectiveYear
			FROM
				GrReporting.dbo.Reforecast
			GROUP BY
				ReforecastQuarterName,
				ReforecastEffectiveYear

		) Reforecast ON
			BTPC.BudgetYear = Reforecast.ReforecastEffectiveYear AND
			BTPC.BudgetQuarter = Reforecast.ReforecastQuarterName
	WHERE
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = ''GBS Budget/Reforecast'' AND
		IsReforecast = 1

	DECLARE @BTPRowCount INT = @@rowcount
	PRINT (''Rows inserted into #BudgetsToProcess: '' + CONVERT(VARCHAR(10),@BTPRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@BTPRowCount = 0)
	BEGIN
		PRINT (''stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS BudgetsToProcess set to be imported.'')
		RETURN
	END

END

/* ==============================================================================================================================================
	2.	Declare local variables and create common tables
   =========================================================================================================================================== */
BEGIN

	DECLARE @ReasonsForFailure VARCHAR(500) = ''''
	DECLARE	@SourceKeyUnknown					 INT = (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = ''UNKNOWN'')
	DECLARE	@FunctionalDepartmentKeyUnknown		 INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN'')
	DECLARE	@ReimbursableKeyUnknown				 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN'')
	DECLARE	@ActivityTypeKeyUnknown				 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN'')
	DECLARE	@PropertyFundKeyUnknown				 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN'')
	DECLARE	@AllocationRegionKeyUnknown			 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN'')
	DECLARE	@OriginatingRegionKeyUnknown		 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN'')
	DECLARE	@OverheadKeyUnknown					 INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = ''UNKNOWN'')
	DECLARE	@LocalCurrencyKeyUnknown			 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNK'')
	DECLARE @GLCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''UNKNOWN'' AND SnapshotId = 0)


	DECLARE	@FeeAdjustmentKeyUnknown			 INT = (SELECT FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''UNKNOWN'')--,
	DECLARE @ReforecastTypeIsGBSBUDKey			 INT = (SELECT BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = ''GBSBUD'')
	DECLARE @ReforecastTypeIsGBSACTKey			 INT = (SELECT BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = ''GBSACT'')
	--DECLARE	@OverheadTypeIdUnAllocated INT = (Select [OverheadTypeId] From GrReportingStaging.GBS.OverheadType Where [Code] = ''UNALLOC'' AND ImportBatchID = @ImportBatchId)

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Property'' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Fund'' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Property'' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Fund'' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Development'' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''Global'' AND SnapshotId = 0)


-- Corporate Property Sources

	CREATE TABLE #CorporatePropertySourceCodes (
		CorporateSourceCode CHAR(2) NOT NULL,
		PropertySourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #CorporatePropertySourceCodes
	VALUES
		(''UC'', ''US''),
		(''EC'', ''EU''),
		(''IC'', ''IN''),
		(''BC'', ''BR''),
		(''CC'', ''CN'')

	IF (@DataPriorToDate IS NULL)
		BEGIN
		SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate''))
		END
END

/* ==============================================================================================================================================
	3.	Source Budget data from GBS.Budget
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #Budget(
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		BudgetStatusId INT NOT NULL,
		LastLockedDate DATETIME NULL,
		SnapshotId INT NOT NULL,
		FirstProjectedPeriodFees INT NOT NULL,
		FirstProjectedPeriodNonPayroll INT NOT NULL,
		ReforecastKey INT NOT NULL
	)
	INSERT INTO #Budget
	SELECT
		BTP.ImportBatchId,
		Budget.BudgetId,
		Budget.BudgetStatusId,
		Budget.LastLockedDate,
		BTP.SnapshotId,
		FirstProjectedPeriodFees.ProjectedPeriod AS FirstProjectedPeriodFees,
		FirstProjectedPeriodNonPayRoll.ProjectedPeriod AS FirstProjectedPeriodNonPayroll,
		BTP.ReforecastKey
	FROM
		GBS.Budget Budget

		INNER JOIN #BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
			Budget.BudgetId = BTP.BudgetId AND
			Budget.ImportBatchId = BTP.ImportBatchId

		INNER JOIN GDM.BudgetReportGroupPeriod BRGP ON
			Budget.BudgetReportGroupPeriodId  = BRGP.BudgetReportGroupPeriodId

		INNER JOIN GDM.BudgetReportGroupPeriodActive(@DataPriorToDate) BRGPA ON
			BRGP.ImportKey = BRGPA.ImportKey	

		-- Join on ImportBatchId below because there could be multiple copies of the same budget in the GrReportingStaging.GBS.xxx tables

		INNER JOIN
		(
			SELECT
				BudgetId,
				Period AS ProjectedPeriod,
				ImportBatchId
			FROM
				GBS.BudgetPeriod
			WHERE
				IsFeeFirstProjectedPeriod = 1

		) FirstProjectedPeriodFees ON
			Budget.BudgetId = FirstProjectedPeriodFees.BudgetId AND
			BTP.ImportBatchId = FirstProjectedPeriodFees.ImportBatchId 

		INNER JOIN
		(
			SELECT
				BudgetId,
				Period AS ProjectedPeriod,
				ImportBatchId
			FROM
				GBS.BudgetPeriod
			WHERE
				IsNonPayrollFirstProjectedPeriod = 1

		) FirstProjectedPeriodNonPayRoll ON
			Budget.BudgetId = FirstProjectedPeriodNonPayRoll.BudgetId AND
			BTP.ImportBatchId = FirstProjectedPeriodNonPayRoll.ImportBatchId
	WHERE
		Budget.IsActive = 1 
		
	DECLARE @BudgetRowCount INT = @@rowcount
	PRINT (''Rows inserted into #Budget: '' + CONVERT(VARCHAR(10),@BudgetRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@BudgetRowCount = 0)
	BEGIN
		PRINT (''stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.'')
		RETURN
	END

	CREATE UNIQUE CLUSTERED INDEX IX_Budget ON #Budget (SnapshotId, BudgetId)

END

/* ==============================================================================================================================================
	4.	Source Snapshot mapping data from GDM
   =========================================================================================================================================== */
BEGIN

-- GLGlobalAccount --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccount(
		GLGlobalAccountId INT NOT NULL,
		ActivityTypeId INT NULL,
		Code VARCHAR(10) NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccount (
		GLGlobalAccountId,
		ActivityTypeId,
		Code,
		SnapshotId
	)
	SELECT DISTINCT
		GLGA.GLGlobalAccountId,
		GLGA.ActivityTypeId,
		GLGA.Code,
		GLGA.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccount GLGA
		INNER JOIN #Budget B ON
			GLGA.SnapshotId = B.SnapshotId
	WHERE
		GLGA.IsActive = 1

	PRINT (''Rows inserted into #GLGlobalAccount: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount
	(
		GLGlobalAccountId,
		SnapshotId
	)

-- GLGlobalAccountCategorization -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccountCategorization(
		GLGlobalAccountId INT NOT NULL,
		DirectGLMinorCategoryId INT NULL,
		IndirectGLMinorCategoryId INT NULL,
		GLCategorizationId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccountCategorization(
		GLGlobalAccountId,
		DirectGLMinorCategoryId,
		IndirectGLMinorCategoryId,
		GLCategorizationId,
		SnapshotId
	)
	SELECT DISTINCT
		GGAC.GLGlobalAccountId,
		GGAC.DirectGLMinorCategoryId,
		GGAC.IndirectGLMinorCategoryId,
		GGAC.GLCategorizationId,
		GGAC.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC
		INNER JOIN #Budget B ON
			GGAC.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #GLGlobalAccountCategorization '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccountCategorization_GLGlobalAccountId_GLCategorizationId ON #GLGlobalAccountCategorization
	(
		GLGlobalAccountId,
		GLCategorizationId,
		SnapshotId
	)

-- GLMinorCategory -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMinorCategory (
		SnapshotId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMajorCategoryId INT NOT NULL
	)
	INSERT INTO #GLMinorCategory
	SELECT DISTINCT
		MinC.SnapshotId,
		MinC.GLMinorCategoryId,
		MinC.GLMajorCategoryId
	FROM
		Gdm.SnapshotGLMinorCategory MinC
		INNER JOIN #Budget B ON
			MinC.SnapshotId = B.SnapshotId
	WHERE
		MinC.IsActive = 1

	PRINT (''Rows inserted into #GLMinorCategory: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLMinorCategory_GLMinorCategoryId ON #GLMinorCategory(SnapshotId, GLMinorCategoryId)

-- GLMajorCategory -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMajorCategory (
		[SnapshotId] INT NOT NULL,
		[GLMajorCategoryId] INT NOT NULL,
		Name VARCHAR(400) NOT NULL,
		GLFinancialCategoryId INT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #GLMajorCategory
	(
		SnapshotId,
		GLMajorCategoryId,
		Name,
		GLFinancialCategoryId,
		GLCategorizationId
	)
	SELECT DISTINCT
		MajC.SnapshotId,
		MajC.GLMajorCategoryId,
		Name,
		MajC.GLFinancialCategoryId,
		MajC.GLCategorizationId
	FROM
		Gdm.SnapshotGLMajorCategory MajC
		INNER JOIN #Budget B ON
			MajC.SnapshotId = B.SnapshotId
	WHERE
		MajC.IsActive = 1

	PRINT (''Rows inserted into #GLMajorCategory: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLMajorCategory_GLMajorCategoryId ON #GLMajorCategory(SnapshotId, GLMajorCategoryId)

-- GLFinancialCategory ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLFinancialCategory
	(
		SnapshotId INT NOT NULL,
		GLFinancialCategoryId INT NOT NULL,
		Name VARCHAR(50) NOT NULL,
		GLCategorizationId INT NOT NULL,
		InflowOutflow VARCHAR(7) NOT NULL
	)
	INSERT INTO #GLFinancialCategory(
		SnapshotId,
		GLFinancialCategoryId,
		Name,
		GLCategorizationId,
		InflowOutflow
	)
	SELECT DISTINCT
		FinC.SnapshotId,
		FinC.GLFinancialCategoryId,
		FinC.Name,
		FinC.GLCategorizationId,
		FinC.InflowOutflow
	FROM
		Gdm.SnapshotGLFinancialCategory FinC
		INNER JOIN #Budget B ON
			FinC.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #GLFinancialCategory '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLFinancialCategory_GLFinancialCategoryId ON #GLFinancialCategory(SnapshotId, GLFinancialCategoryId)

-- GLCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorization
	(
		SnapshotId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		GLCategorizationTypeId INT NOT NULL,
		Name VARCHAR(50) NOT NULL
	)
	INSERT INTO #GLCategorization(
		SnapshotId,
		GLCategorizationId,
		GLCategorizationTypeId,
		Name
	)
	SELECT DISTINCT
		GC.SnapshotId,
		GC.GLCategorizationId,
		GC.GLCategorizationTypeId,
		GC.Name
	FROM
		Gdm.SnapshotGLCategorization GC
		INNER JOIN #Budget B ON
			GC.SnapshotId = B.SnapshotId
	WHERE
		GC.IsActive = 1	

	PRINT (''Rows inserted into #GLCategorization '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLCategorizationType ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorizationType(
		SnapshotId INT NOT NULL,
		GLCategorizationTypeId INT NOT NULL
	)
	INSERT INTO #GLCategorizationType(
		SnapshotId,
		GLCategorizationTypeId
	)
	SELECT DISTINCT
		GCT.SnapshotId,
		GCT.GLCategorizationTypeId
	FROM
		Gdm.SnapshotGLCategorizationType GCT
		INNER JOIN #Budget B ON
			GCT.SnapshotId = B.SnapshotId
	WHERE
		GCT.IsActive = 1	

	PRINT (''Rows inserted into #GLCategorizationType '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ReportingCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ReportingCategorization
	(
		SnapshotId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #ReportingCategorization(
		SnapshotId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId,
		GLCategorizationId
	)
	SELECT DISTINCT
		RC.SnapshotId,
		RC.EntityTypeId,
		RC.AllocationSubRegionGlobalRegionId,
		RC.GLCategorizationId
	FROM
		Gdm.SnapshotReportingCategorization RC
		INNER JOIN #Budget B ON
			RC.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #ReportingCategorization '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ReportingCategorization_EntityTypeId_AllocationSubRegionGlobalRegionId ON #ReportingCategorization
	(
		SnapshotId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId
	)

-- ConsolidationRegionCorporateDepartment (CC16) -----------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ConsolidationRegionCorporateDepartment
	(
		ConsolidationRegionCorporateDepartmentId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(10) NOT NULL,
		SourceCode VARCHAR(2) NOT NULL,
		GlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ConsolidationRegionCorporateDepartment
	SELECT DISTINCT
		CRCD.ConsolidationRegionCorporateDepartmentId,
		CRCD.CorporateDepartmentCode,
		CRCD.SourceCode,
		CRCD.GlobalRegionId,
		CRCD.SnapshotId
	FROM
		Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
		INNER JOIN #Budget B ON
			CRCD.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #ConsolidationRegionCorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartmentCode ON #ConsolidationRegionCorporateDepartment
	(
		CorporateDepartmentCode,
		SourceCode,
		SnapshotId
		
	)
	
-- ConsolidationRegionPropertyEntity (CC16) -----------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ConsolidationRegionPropertyEntity
	(
		ConsolidationRegionPropertyEntityId INT NOT NULL,
		PropertyEntityCode VARCHAR(10) NOT NULL,
		SourceCode VARCHAR(2) NOT NULL,
		GlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ConsolidationRegionPropertyEntity
	SELECT DISTINCT
		CRPE.ConsolidationRegionPropertyEntityId,
		CRPE.PropertyEntityCode,
		CRPE.SourceCode,
		CRPE.GlobalRegionId,
		CRPE.SnapshotId
	FROM
		Gdm.SnapshotConsolidationRegionPropertyEntity CRPE
		INNER JOIN #Budget B ON
			CRPE.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #ConsolidationRegionCorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionPropertyEntity_PropertyEntityCode ON #ConsolidationRegionPropertyEntity
	(
		PropertyEntityCode,
		SourceCode,
		SnapshotId
		
	)
-- PropertyFund --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #PropertyFund
	(
		PropertyFundId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		IsReportingEntity BIT NOT NULL,
		IsPropertyFund BIT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #PropertyFund
	SELECT DISTINCT
		PF.PropertyFundId,
		PF.EntityTypeId,
		PF.AllocationSubRegionGlobalRegionId,
		PF.IsReportingEntity,
		PF.IsPropertyFund,
		PF.SnapshotId
	FROM
		Gdm.SnapshotPropertyFund PF
		INNER JOIN #Budget B ON
			B.SnapshotId = PF.SnapshotId
	WHERE
		PF.IsActive = 1

	PRINT (''Rows inserted into #PropertyFund: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_PropertyFund_PropertyFundId ON #PropertyFund(PropertyFundId, SnapshotId)

-- ActivityType --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ActivityType(
		ActivityTypeId INT NOT NULL,
		Code VARCHAR(10) NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ActivityType
	SELECT DISTINCT
		ActivityTypeId,
		Code,
		AT.SnapshotId
	FROM
		Gdm.SnapshotActivityType AT
		INNER JOIN #Budget B ON
			AT.SnapshotId = B.SnapshotId
	WHERE
		AT.IsActive = 1

	PRINT (''Rows inserted into #ActivityType: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_ActivityType_ActivityTypeId ON #ActivityType(ActivityTypeId, SnapshotId)

-- Department --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #CorporateDepartment(
		Code CHAR(8) NOT NULL,
		SourceCode CHAR(2) NOT NULL,
		FunctionalDepartmentId INT NULL,
		IsTsCost BIT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO	#CorporateDepartment
	SELECT DISTINCT
		D.Code,
		D.SourceCode,
		D.FunctionalDepartmentId,
		D.IsTsCost,
		D.SnapshotId
	FROM
		Gdm.SnapshotCorporateDepartment D
		INNER JOIN #Budget B ON
			D.SnapshotId = B.SnapshotId
	WHERE
		D.IsActive = 1

	PRINT (''Rows inserted into #CorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_CorporateDeparment_Code ON #CorporateDepartment(Code, SourceCode, SnapshotId)

-- FunctionalDepartment --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #FunctionalDepartment
	(
		FunctionalDepartmentId INT NOT NULL,
		Code VARCHAR(20) NULL,
		GlobalCode VARCHAR(30) NULL
	)

	INSERT INTO #FunctionalDepartment
	SELECT DISTINCT
		FunctionalDepartmentId,
		Code,
		GlobalCode
	FROM
		HR.FunctionalDepartment FD
	
		INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDa ON
			FD.ImportKey = FDa.ImportKey
	WHERE
		FD.IsActive = 1

	PRINT (''Rows inserted into #FunctionalDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)

-- AllocationSubRegion --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #AllocationSubRegion
	(
		SnapshotId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		Code VARCHAR(10) NOT NULL,
		Name VARCHAR(50) NOT NULL,
		AllocationRegionGlobalRegionId INT NULL,
		DefaultCorporateSourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #AllocationSubRegion
	SELECT DISTINCT
		ASR.SnapshotId,
		ASR.AllocationSubRegionGlobalRegionId,
		ASR.Code,
		ASR.Name,
		ASR.AllocationRegionGlobalRegionId,
		ASR.DefaultCorporateSourceCode
	FROM
		Gdm.SnapshotAllocationSubRegion ASR
		INNER JOIN #Budget B ON
			ASR.SnapshotId = B.SnapshotId
	WHERE
		ASR.IsActive = 1

	PRINT (''Rows inserted into #AllocationSubRegion: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_AllocationSubRegion_AllocationSubRegionGlobalRegionId ON #AllocationSubRegion
	(
		AllocationSubRegionGlobalRegionId,
		SnapshotId
	)

		/*	-------------------------------------------------------------------------------------------------------------------------

			The MRI Server Source table is used to link Corporate Source codes to Property Source codes. This is for actuals from
			GBS which only use Corporate source codes.
		*/

	CREATE TABLE #MRIServerSource
	(
		SourceCode CHAR(2) NOT NULL,
		MappingSourceCode CHAR(2) NULL
	)
	INSERT INTO #MRIServerSource
	(
		SourceCode,
		MappingSourceCode
	)
	SELECT
		SourceCode,
		MappingSourceCode
	FROM
		Gdm.MRIServerSource MSS
		
		INNER JOIN Gdm.MRIServerSourceActive(@DataPriorToDate) MSSa ON
			MSS.ImportKey = MSSa.ImportKey
			
END


/* ==============================================================================================================================================
	5.	Create master GL Account Category mapping table
   ============================================================================================================================================ */
BEGIN

	-- Should only relate to the snapshot associated with the budget that is currently being processed

	SET @StartTime = GETDATE()

	CREATE TABLE #GlAccountCategoryMapping (
		SnapshotId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		IsDirect BIT NOT NULL,
		GlobalGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL		
	)
	INSERT INTO #GlAccountCategoryMapping
	(
		SnapshotId,
		GLGlobalAccountId,
		IsDirect,
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.SnapshotId,
		PivotTable.GLGlobalAccountId,
		PivotTable.IsDirectCost,
		PivotTable.[Global] AS GlobalGLCategorizationHierarchyKey,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(	
			-- Indirect Minor Categories
			SELECT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				0 AS IsDirectCost
			FROM
				#GLGlobalAccount GGA
				
				INNER JOIN #GLCategorization GLC ON
					GGA.SnapshotId = GLC.SnapshotId  
				
				INNER JOIN #GLCategorizationType GLCT ON
					GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId AND
					GLC.SnapshotId = GLCT.SnapshotId 			
				
				LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
					GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId   AND
					GGA.SnapshotId = GLGAC.SnapshotId  AND
					GLC.GLCategorizationId = GLGAC.GLCategorizationId					

				LEFT OUTER JOIN #GLMinorCategory MinC ON
					GLGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
					GLGAC.SnapshotId  = MinC.SnapshotId  
					
				LEFT OUTER JOIN #GLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	AND
					MinC.SnapshotId = MajC.SnapshotId
				
				LEFT OUTER JOIN #GLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					MajC.SnapshotId = FinC.SnapshotId  
				
 				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GCH ON
					GCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GLCT.SnapshotId = GCH.SnapshotId
					
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
					UnknownGCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':-1:-1:-1:'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GGA.SnapshotId = UnknownGCH.SnapshotId
					
			UNION

			-- Direct Minor Categories
			SELECT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				1 AS IsDirectCost
			FROM
				#GLGlobalAccount GGA
				
				INNER JOIN #GLCategorization GLC ON
					GGA.SnapshotId = GLC.SnapshotId  
				
				LEFT OUTER JOIN #GLCategorizationType GLCT ON
					GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId AND
					GLC.SnapshotId = GLCT.SnapshotId 			
				
				LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
					GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId   AND
					GGA.SnapshotId = GLGAC.SnapshotId  AND
					GLC.GLCategorizationId = GLGAC.GLCategorizationId					

				LEFT OUTER JOIN #GLMinorCategory MinC ON
					GLGAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
					GLGAC.SnapshotId  = MinC.SnapshotId  
					
				LEFT OUTER JOIN #GLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	AND
					MinC.SnapshotId = MajC.SnapshotId
				
				LEFT OUTER JOIN #GLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					MajC.SnapshotId = FinC.SnapshotId  
				
 				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GCH ON
					GCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GLCT.SnapshotId = GCH.SnapshotId
					
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
					UnknownGCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':-1:-1:-1:'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GGA.SnapshotId = UnknownGCH.SnapshotId
		) Mappings

		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR
				GLCategorizationName IN ([Global], [US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	PRINT (''Rows inserted into #GLAccountCategoryMapping: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GlAccountCategoryMapping_GLGlobalAccountId ON #GlAccountCategoryMapping(GLGlobalAccountId, SnapshotId, IsDirect)

END

/* ==============================================================================================================================================
	6.	Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilitySource
	(
		ImportBatchId INT NOT NULL,
		SourceName varchar(20),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		GLGlobalAccountId INT NULL,
		FunctionalDepartmentCode VARCHAR(20) NULL,
		JobCode VARCHAR(20) NULL,
		Reimbursable VARCHAR(3) NULL, -- NULL because this field is determined via an outer join
		ActivityTypeId INT NULL, -- NULL because for Fees this field is determined via an outer join
		PropertyFundId INT NULL, -- NULL because this field is determined via an outer join
		AllocationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
		ConsolidationSubRegionGlobalRegionId INT NULL,
		OriginatingGlobalRegionId INT NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		LockedDate DATETIME NULL,
		IsExpense BIT NOT NULL,
		UnallocatedOverhead CHAR(7) NULL, -- NULL because this field is determined via an outer join
		FeeAdjustment VARCHAR(9) NOT NULL,
		ReforecastKey INT NOT NULL,
		IsDirectCost BIT NULL,
		DefaultGLCategorizationId INT NULL,
		SourceTableName VARCHAR(255) NOT NULL
	)

END

/* ==============================================================================================================================================
	7.	Get Non-Payroll Expense BUDGET items from GBS (NB: these are BUDGET figures only, not ACTUAL figures)
   =========================================================================================================================================== */
BEGIN

-- Insert original budget amounts ------------

	INSERT INTO #ProfitabilitySource
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		UnallocatedOverhead,
		FeeAdjustment,
		ReforecastKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		''NPEB'' as SourceName,
		@ReforecastTypeIsGBSBUDKey,
		Budget.SnapshotId,
		Budget.BudgetId,                                                        -- BudgetId
		''GBS:BudgetId='' + LTRIM(RTRIM(STR(Budget.BudgetId))) +
			''&NonPayrollExpenseBreakdownId='' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) +
			''&SnapshotId='' + LTRIM(RTRIM(STR(Budget.SnapshotId))),              -- ReferenceCode
		NPEB.Period,                                                            -- ExpensePeriod: Period is actually a foreign key to
		                                                                        --    PeriodExtended but is also the implied period value,
		                                                                        --    e.g.: 201009
		CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
		NPEB.Amount,                                                            -- BudgetAmount
		ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
		FD.GlobalCode,                                                          -- FunctionalDepartmentCode
		NPEB.JobCode,                                                           -- JobCode
		CASE WHEN CD.IsTsCost = 0 THEN ''YES'' ELSE ''NO'' END,                     -- Reimbursable
		NPEB.ActivityTypeId,                                                    -- ActivityTypeId: this Id should correspond to the correct Id
		                                                                        --     in GDM
		PF.PropertyFundId,                                                      -- PropertyFundId
		PF.AllocationSubRegionGlobalRegionId,                                   -- AllocationSubRegionGlobalRegionId
		CRCD.GlobalRegionId,                                                    -- ConsolidationSubRegionGlobalRegionId,
		NPEB.OriginatingSubRegionGlobalRegionId,                                -- OriginatingGlobalRegionId
		NPEB.CurrencyCode,                                                      -- LocalCurrencyCode
		Budget.LastLockedDate,                                                  -- LockedDate
		1,                                                                      -- IsExpense
		CASE WHEN AT.Code = ''CORPOH'' THEN ''UNALLOC'' ELSE ''N/A'' END,         -- UnallocatedOverhead
		''NORMAL'',                                                               -- FeeAdjustment,
		Budget.ReforecastKey,
		NPEB.IsDirectCost,
		RC.GLCategorizationId,
		''NonPayrollExpenseBreakdown''
	FROM
		#Budget Budget

		INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
			Budget.BudgetId = NPEB.BudgetId AND
			Budget.ImportBatchId = NPEB.ImportBatchId
			
		INNER JOIN GBS.NonPayrollExpense NPE ON
			NPEB.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
			NPEB.ImportBatchId = NPE.ImportBatchId

		-- Corporate and Property MRI source codes
		INNER JOIN #CorporatePropertySourceCodes CPSC ON
			NPEB.CorporateSourceCode = CPSC.CorporateSourceCode

		LEFT OUTER JOIN
		(	-- these NonPayrollExpenses need to be excluded because they are in dispute

			/* Disputes are created at the level of a budget project. A budget project will dispute the portion of a non-payroll expense that is
			   allocated to them (via the NonPayrollExpenseBreakdown table, which includes the NonPayrollExpenseId and BudgetProjectId fields,
			   allowing for the portion of the non-payroll expense that has been allocated to the budget project to be determined).
			   
			   If, for example, a non-payroll expense is split between two budget projects, and one of these budget projects is disputing their
			   allocation, the portion of the non-payroll expense that is allocated to the budget project that is not disputing must still be
			   included. Only thet portion of the non-payroll expense that is currently being disputed must be excluded.	   
			*/

			SELECT DISTINCT
				NPED.ImportBatchId,
				NPED.NonPayrollExpenseId,
				NPED.BudgetProjectId
			FROM
				GBS.NonPayrollExpenseDispute NPED
				INNER JOIN GBS.DisputeStatus DS ON
					NPED.DisputeStatusId = DS.DisputeStatusId AND
					NPED.ImportBatchId = DS.ImportBatchId
			WHERE
				DS.Name <> ''Resolved'' AND
				DS.IsActive = 1
				
		) DisputedNonPayrollExpenseItems ON
			NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
			NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
			NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

		LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
			NPEB.CorporateDepartmentCode = CRCD.CorporateDepartmentCode AND
			NPEB.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId

		-- AllocationRegionId
		LEFT OUTER JOIN #PropertyFund PF ON
			NPEB.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId

		-- Overhead Type
		LEFT OUTER JOIN #ActivityType AT ON
			NPEB.ActivityTypeId = AT.ActivityTypeId AND
			Budget.SnapshotId = AT.SnapshotId -- 

		-- Reimbursable
		LEFT OUTER JOIN #CorporateDepartment CD ON
			NPEB.CorporateSourceCode = CD.SourceCode AND
			NPEB.CorporateDepartmentCode = CD.Code AND
			Budget.SnapshotId = CD.SnapshotId --

		-- FunctionalDepartmentCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON
			NPEB.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- 	ReportingCategorization
		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId  
	WHERE
		DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL AND -- Exclude all disputed items
		NPEB.Period >= Budget.FirstProjectedPeriodNonPayroll AND
		NPE.IsDeleted = 0

	PRINT (''Rows inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	8.	Get Fee BUDGET items from GBS (NB: these are BUDGET figures only, not ACTUAL figures)
============================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilitySource
	(
		ImportBatchId,
		SourceName, -- [!!]
		BudgetReforecastTypeKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		UnallocatedOverhead,
		FeeAdjustment,
		ReforecastKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		''Fees'' as SourceName,
		@ReforecastTypeIsGBSBUDKey,
		Budget.Snapshotid,
		Budget.BudgetId,                                                         -- BudgetId
		''GBS:BudgetId='' + LTRIM(RTRIM(STR(Budget.BudgetId))) +
			''&FeeId='' + LTRIM(RTRIM(STR(Fee.FeeId))) +
			''&FeeDetailId='' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) +
			''&SnapshotId='' + LTRIM(RTRIM(STR(Budget.SnapshotId))),               -- ReferenceCode
		FeeDetail.Period,                                                        -- ExpensePeriod
		ASR.DefaultCorporateSourceCode,                                          -- SourceCode
		FeeDetail.Amount,
		GA.GLGlobalAccountId,                                                    -- GLGlobalAccountId
		NULL,                                                                    -- FunctionalDepartmentId
		NULL,                                                                    -- JobCode
		''NO'',                                                                    -- Reimbursable
		GA.ActivityTypeId,                                                       -- ActivityType: determined by finding Fee.GLGlobalAccountId
		                                                                         --     on GrReportingStaging.dbo.GLGlobalAccount
		Fee.PropertyFundId,                                                      -- PropertyFundId
		PF.AllocationSubRegionGlobalRegionId,                                   -- AllocationSubRegionGlobalRegionId
		PF.AllocationSubRegionGlobalRegionId,                                   -- ConsolidationSubRegionGlobalRegionId (CC16)
		PF.AllocationSubRegionGlobalRegionId,                                   -- OriginatingGlobalRegionId: allocation region = originating
                                                                                 --     region for Fee Income
		Fee.CurrencyCode,
		Budget.LastLockedDate,                                                   -- LockedDate
		0,                                                                       -- IsExpense
		''N/A'',                                                               -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
		CASE WHEN FeeDetail.IsAdjustment = 1 THEN ''FEEADJUST'' ELSE ''NORMAL'' END, -- IsFeeAdjustment, field isn''t NULLABLE
		Budget.ReforecastKey,
		NULL,                                                                    -- IsDirectCost
		RC.GLCategorizationId,                                                    -- DefaultGLCategorizationId
		''Fee''
	FROM
		#Budget Budget

		INNER JOIN GBS.Fee Fee ON
			Budget.BudgetId = Fee.BudgetId AND
			Budget.ImportBatchId = Fee.ImportBatchId

		INNER JOIN GBS.FeeDetail FeeDetail ON
			Fee.FeeId = FeeDetail.FeeId AND
			Fee.ImportBatchId = FeeDetail.ImportBatchId

		LEFT OUTER JOIN #GLGlobalAccount GA ON
			Fee.GLGlobalAccountId = GA.GLGlobalAccountId AND
			Budget.SnapshotId = GA.SnapshotId

		-- SourceCode


		LEFT OUTER JOIN #PropertyFund PF ON
			Fee.PropertyFundId  = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId  

		LEFT OUTER JOIN #AllocationSubRegion ASR ON
			PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			Budget.SnapshotID = ASR.SnapshotId
			
		LEFT OUTER JOIN #ReportingCategorization RC ON
			ASR.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId  
	WHERE
		Fee.IsDeleted = 0 AND
		FeeDetail.Amount <> 0 AND
		FeeDetail.Period >= Budget.FirstProjectedPeriodFees

	PRINT (''Fee Budgets inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	9.	Get Fee Income and Non-Payroll Expense ACTUALS from GBS.BudgetProfitabilityActual (NB: these are ACTUAL figures only, not BUDGET figures)
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

-- Filter the GBS.BudgetProfitabilityActual table so that only Fee Income and Non-Payroll Expense transactions that are for a period that is
--     before their associated first projected periods are considered

	CREATE TABLE #BudgetProfitabilityActual
	(
		ImportBatchId INT NOT NULL,
		BudgetProfitabilityActualId INT NOT NULL,
		BudgetId INT NOT NULL,
		Period INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		SourceCode CHAR(2) NOT NULL, -- ?????
		FunctionalDepartmentId INT NOT NULL,
		CorporateJobCode VARCHAR(20) NULL,
		IsTsCost BIT NOT NULL,
		ActivityTypeId INT NOT NULL,
		ReportingEntityPropertyFundId INT NOT NULL,
		OriginatingSubRegionGlobalRegionId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		CurrencyCode CHAR(3) NOT NULL,
		Amount MONEY NOT NULL,
		ConsolidationSubRegionGlobalRegionId INT NULL,
		IsDirectCost BIT NULL,
		SnapshotId INT NOT NULL,
		IsExpense BIT NOT NULL, -- 0 if Fee Income, 1 if Non-Payroll Expense
		OverheadTypeCode VARCHAR(20) NULL,
		IsGBS BIT NULL,
		PropertyFundCode CHAR(12),
		SourceTableName VARCHAR(255) NOT NULL
	)
	INSERT INTO #BudgetProfitabilityActual
	SELECT DISTINCT
		BPA.ImportBatchId,
		BPA.BudgetProfitabilityActualId,
		BPA.BudgetId,
		BPA.Period,
		BPA.GLGlobalAccountId,
		BPA.SourceCode,
		BPA.FunctionalDepartmentId,
		BPA.CorporateJobCode,
		BPA.IsTsCost,
		BPA.ActivityTypeId,
		BPA.ReportingEntityPropertyFundId,
		BPA.OriginatingSubRegionGlobalRegionId,
		BPA.AllocationSubRegionGlobalRegionId,
		BPA.CurrencyCode,
		BPA.Amount,
		BPA.ConsolidationSubRegionGlobalRegionId,
		BPA.IsDirectCost,
		B.SnapshotId,
		CASE WHEN FinC.InflowOutflow = ''Inflow'' THEN 0 ELSE 1 END, -- IF ''Inflow'' THEN Income/Not Expense, ELSE Expense
		ISNULL(OHT.Code, ''N/A''), -- OverheadTypeCode
		BPA.IsGBS,
		BPA.PropertyFundCode,
		''BudgetProfitabilityActual''
	FROM
		GBS.BudgetProfitabilityActual BPA

		INNER JOIN #Budget B ON
			BPA.BudgetId = B.BudgetId AND
			BPA.ImportBatchId = B.ImportBatchId
		
		LEFT OUTER JOIN GBS.OverheadType OHT ON
			BPA.OverheadTypeId = OHT.OverheadTypeId AND
			BPA.ImportBatchId = OHT.ImportBatchId
		
		LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
			BPA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
			B.SnapshotId = GGAC.SnapshotId AND
			GGAC.GLCategorizationId = 233 -- This is just used to find the Global Financial Category, so limit it to Global
		
		LEFT OUTER JOIN #GLMinorCategory MinC ON
			GGAC.SnapshotId = MinC.SnapshotId AND
			GLMinorCategoryId = CASE WHEN BPA.IsDirectCost = 1 THEN GGAC.DirectGLMinorCategoryId ELSE GGAC.IndirectGLMinorCategoryId END
			
		LEFT OUTER JOIN #GLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
			MinC.SnapshotId = MajC.SnapshotId
			
		LEFT OUTER JOIN #GLFinancialCategory FinC ON
			MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
			MajC.SnapshotId = FinC.SnapshotId

	WHERE
		BPA.IsDeleted = 0 AND
		(
			(-- Fee Income
				FinC.InflowOutflow  = ''Inflow'' AND
				BPA.Period < B.FirstProjectedPeriodFees
			)
			OR
			(-- Non-Payroll Expenses
				FinC.InflowOutflow = ''Outflow'' AND
				MajC.Name NOT IN (''Salaries/Taxes/Benefits'', ''General Overhead'') AND
				BPA.Period < B.FirstProjectedPeriodNonPayroll
			)
		) AND
		(OHT.Code IS NULL OR OHT.Code = ''UNALLOC'')

	PRINT (''Actuals for Fee Income and Non-Payroll inserted: '' + CONVERT(NVARCHAR, @@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	INSERT INTO #ProfitabilitySource (
		ImportBatchId,
		BudgetReforecastTypeKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		Reimbursable,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		UnallocatedOverhead,
		FeeAdjustment,
		ReforecastKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		B.ImportBatchId,
		@ReforecastTypeIsGBSACTKey,
		B.SnapshotId,
		B.BudgetId, 
		''GBS:BudgetId='' + LTRIM(RTRIM(STR(B.BudgetId))) +
			''&BudgetProfitabilityActualId='' + LTRIM(RTRIM(STR(BPA.BudgetProfitabilityActualId))) +
			''&IsGBS='' + LTRIM(RTRIM(STR(BPA.IsGBS))) +
			''&SnapshotId='' + LTRIM(RTRIM(STR(b.SnapshotId))) AS ReferenceCode, -- ReferenceCode
		BPA.Period,
		ASR.DefaultCorporateSourceCode, -- SourceCode
		BPA.Amount,
		BPA.GLGlobalAccountId, -- GLGlobalAccountId
		FD.GlobalCode,
		BPA.CorporateJobCode,
		CASE WHEN BPA.IsTsCost = 0 THEN ''YES'' ELSE ''NO'' END,
		BPA.ActivityTypeId,
		PF.PropertyFundId,
		PF.AllocationSubRegionGlobalRegionId,
		ISNULL(CRCD.GlobalRegionId, CRPE.GlobalRegionId) AS ConsolidationSubRegionGlobalRegionId, -- ConsolidationSubRegionGlobalRegionId (CC16)
		BPA.OriginatingSubRegionGlobalRegionId,	
		BPA.CurrencyCode,
		B.LastLockedDate,
		BPA.IsExpense,
		BPA.OverheadTypeCode, -- UnallocatedOverhead
		''Normal'' AS FeeAdjustment,
		B.ReforecastKey,
		BPA.IsDirectCost,
		RC.GLCategorizationId, -- DefaultGLCategorizationId
		BPA.SourceTableName
	FROM 
		#BudgetProfitabilityActual BPA

		INNER JOIN  #Budget B ON
			BPA.BudgetId = B.BudgetId
	
			/*
				GBS only uses the corporate sources. It may have transactions mapped to Property Entities which should have Property 
				source codes. To handle this, we use the #MRIServerSource table to find the associated Property source code of the mapped 
				Corporate source code
			*/
		LEFT OUTER JOIN #MRIServerSource MSS ON
			BPA.SourceCode = MSS.SourceCode
	
		LEFT OUTER JOIN  #PropertyFund PF ON
			BPA.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			B.SnapshotId = PF.SnapshotId
			
		LEFT OUTER JOIN #AllocationSubRegion ASR ON
			PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
			B.SnapshotId = ASR.SnapshotId

		LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRCD.CorporateDepartmentCode)) AND
			BPA.SourceCode = CRCD.SourceCode AND
			B.SnapshotId = CRCD.SnapshotId	
			
		LEFT OUTER JOIN #ConsolidationRegionPropertyEntity CRPE ON
			LTRIM(RTRIM(BPA.PropertyFundCode)) = LTRIM(RTRIM(CRPE.PropertyEntityCode)) AND		
			MSS.MappingSourceCode = CRPE.SourceCode AND
			B.SnapshotId = CRPE.SnapshotId

		-- FunctionalDepartmentCode -> FD.GlobalCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON 
			BPA.FunctionalDepartmentId = FD.FunctionalDepartmentId

		-- Overhead Type
		LEFT OUTER JOIN #ActivityType AT ON
			BPA.ActivityTypeId = AT.ActivityTypeId AND
			B.SnapshotId = AT.SnapshotId -- 

		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			B.SnapshotId = RC.SnapshotId

	PRINT (''ProfitibilityActuals Rows inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	-- GBS budgets against header accounts, but specifies an activity type for each record.
	-- Use this header account / activity type combination to determine the correct activity type-specific account

	UPDATE
		PS
	SET
		PS.GLGlobalAccountId = GLGA2.GLGlobalAccountId
	FROM
		#ProfitabilitySource PS

		INNER JOIN #GLGlobalAccount GLGA1 ON
			PS.GLGlobalAccountId = GLGA1.GLGlobalAccountId

		INNER JOIN #GLGlobalAccount GLGA2 ON
			(LEFT(GLGA1.Code, 10 - LEN(PS.ActivityTypeId)) + LTRIM(RTRIM(STR(PS.ActivityTypeId)))) = GLGA2.Code
	WHERE
		LEN(GLGA1.Code) = 10 AND -- A code of 10 characters excludes the account prefix (CP, TS) and includes the activity type code, i.e.: 5020100012
		RIGHT(GLGA1.Code, 2) = ''00'' -- where the header account has been budgeted against

	PRINT (''Rows updated in #ProfitabilitySource (GLAccount update from head to activity-specific GL Account: '' + LTRIM(RTRIM(STR(@@rowcount))))

	CREATE NONCLUSTERED INDEX IX_ProfitabilitySource ON
		#ProfitabilitySource
		(
			PropertyFundId,
			AllocationSubRegionGlobalRegionId,
			ConsolidationSubRegionGlobalRegionId,
			OriginatingGlobalRegionId,
			JobCode,
			FunctionalDepartmentCode,
			ExpensePeriod
		)

END

/* ==============================================================================================================================================
	10.	Join to dimension tables in GrReporting and attempt to resolve keys, otherwise default to UNKNOWN if NULL
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #ProfitabilityReforecast(
		ImportBatchId INT NOT NULL,
		SourceName varchar(20),
		BudgetReforecastTypeKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey int NOT NULL,
		SourceKey int NOT NULL,
		FunctionalDepartmentKey int NOT NULL,
		ReimbursableKey int NOT NULL,
		ActivityTypeKey int NOT NULL,
		PropertyFundKey int NOT NULL,	
		AllocationRegionKey int NOT NULL,
		ConsolidationRegionKey int NOT NULL,
		OriginatingRegionKey int NOT NULL,
		OverheadKey int NOT NULL,
		FeeAdjustmentKey int NOT NULL,
		LocalCurrencyKey int NOT NULL,
		LocalReforecast money NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId int NOT NULL,
		--SourceSystemId int NOT NULL,
		IsExpense BIT NOT NULL,
		ReforecastKey INT NOT NULL,
		IsDirectCost BIT NULL,
		GlGlobalAccountId INT NULL,
		DefaultGLCategorizationId INT NULL,
		
		GlobalGLCategorizationHierarchyKey			INT NULL,
		USPropertyGLCategorizationHierarchyKey		INT NULL,
		USFundGLCategorizationHierarchyKey			INT NULL,
		EUPropertyGLCategorizationHierarchyKey		INT NULL,
		EUFundGLCategorizationHierarchyKey			INT NULL,
		USDevelopmentGLCategorizationHierarchyKey	INT NULL,
		EUDevelopmentGLCategorizationHierarchyKey	INT NULL,
		ReportingGLCategorizationHierarchyKey		INT NULL,
		
		SourceSystemKey INT NOT NULL
	)
	INSERT INTO #ProfitabilityReforecast 
	(
		ImportBatchId,
		SourceName,
		BudgetReforecastTypeKey,
		SnapshotId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		FeeAdjustmentKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		--SourceSystemId,
		IsExpense,
		PS.ReforecastKey,
		IsDirectCost,
		GlGlobalAccountId,
		DefaultGLCategorizationId,
		
		SourceSystemKey
	)

	SELECT
		PS.ImportBatchId,
		PS.SourceName,
		PS.BudgetReforecastTypeKey,
		PS.SnapshotId,
		DATEDIFF(DD, ''1900-01-01'', LEFT(PS.ExpensePeriod, 4)+''-'' + RIGHT(PS.ExpensePeriod, 2) + ''-01''), -- CalendarKey,
		ISNULL(S.SourceKey, @SourceKeyUnknown),-- SourceKey,
		COALESCE(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown), -- FunctionalDepartmentKey,                        
		ISNULL(R.ReimbursableKey, @ReimbursableKeyUnknown),                    -- ReimbursableKey,
		ISNULL(AT.ActivityTypeKey, @ActivityTypeKeyUnknown),                   -- ActivityTypeKey,
		ISNULL(PF.PropertyFundKey, @PropertyFundKeyUnknown),                   -- PropertyFundKey,
		ISNULL(AR.AllocationRegionKey, @AllocationRegionKeyUnknown),       -- AllocationRegionKey,
		ISNULL(CR.AllocationRegionKey, @AllocationRegionKeyUnknown),       -- ConsolidationRegionKey,
		CASE
			WHEN PS.IsExpense = 1
			THEN
				ISNULL(ORR.OriginatingRegionKey, @OriginatingRegionKeyUnknown)
			ELSE
				ISNULL(ORRFee.OriginatingRegionKey, @OriginatingRegionKeyUnknown)
		END,                                                                                            -- OriginatingRegionKey,
		ISNULL(O.OverheadKey, @OverheadKeyUnknown),                                -- OverheadKey,
		ISNULL(FA.FeeAdjustmentKey, @FeeAdjustmentKeyUnknown),                -- FeeAdjustmentKey,
		ISNULL(C.CurrencyKey, @LocalCurrencyKeyUnknown),                            -- LocalCurrencyKey,
		PS.BudgetAmount,                                                                                -- LocalBudget,
		PS.ReferenceCode,                                                                               -- ReferenceCode,
		PS.BudgetId,                                                                                    -- BudgetId,
		--@SourceSystemId,                                                                              -- SourceSystemId
		PS.IsExpense,
		PS.ReforecastKey,
		PS.IsDirectCost,
		PS.GLGlobalAccountId,
		PS.DefaultGLCategorizationId,
		
		SSystem.SourceSystemKey
	FROM
		#ProfitabilitySource PS

		LEFT OUTER JOIN GrReporting.dbo.[Source] S ON
			PS.SourceCode = S.SourceCode 

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SSystem ON
			PS.SourceTableName = SSystem.SourceTableName AND
			SSystem.SourceSystemName = ''GBS''
			
		LEFT OUTER JOIN GrReporting.dbo.Reimbursable R ON
			PS.Reimbursable = R.ReimbursableCode 

		LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
			PS.ActivityTypeId = AT.ActivityTypeId AND
			PS.SnapshotId = AT.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
			PS.PropertyFundId = PF.PropertyFundId AND
			PS.SnapshotId = PF.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
			PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId AND 
			PS.SnapshotId = AR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion CR ON
			PS.ConsolidationSubRegionGlobalRegionId = CR.GlobalRegionId AND
			PS.SnapshotId = CR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
			PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId AND
			PS.SnapshotId = ORRFee.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
			PS.OriginatingGlobalRegionId = ORR.GlobalRegionId AND
			PS.SnapshotId = ORR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.Currency C ON
			PS.LocalCurrencyCode = C.CurrencyCode

		LEFT OUTER JOIN GrReporting.dbo.Overhead O ON
			PS.UnallocatedOverhead = O.OverheadCode 


		LEFT OUTER JOIN GrReporting.dbo.FeeAdjustment FA ON
			PS.FeeAdjustment = FA.FeeAdjustmentCode 

		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			PS.SnapshotId = SShot.SnapshotId
		-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentKey,
				FunctionalDepartmentCode,
				FunctionalDepartmentName,
				SubFunctionalDepartmentCode,
				SubFunctionalDepartmentName,
				StartDate,
				EndDate
			FROM
				GrReporting.dbo.FunctionalDepartment
			WHERE
				FunctionalDepartmentCode <> SubFunctionalDepartmentCode

		) FDJobCode ON
			PS.JobCode = FDJobCode.SubFunctionalDepartmentCode AND
			PS.FunctionalDepartmentCode = FDJobCode.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN FDJobCode.StartDate AND FDJobCode.EndDate -- Use the Snapshot Last Sync Date since Functional Department is not snapshoted		

		-- Parent Level
		LEFT OUTER JOIN
		(
			SELECT
				FunctionalDepartmentKey,
				FunctionalDepartmentCode,
				FunctionalDepartmentName,
				SubFunctionalDepartmentCode,
				SubFunctionalDepartmentName,
				StartDate,
				EndDate
			FROM
				GrReporting.dbo.FunctionalDepartment
			WHERE
				SubFunctionalDepartmentCode = FunctionalDepartmentCode

		) FD ON
			PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode AND
			SShot.LastSyncDate BETWEEN FD.StartDate AND FD.EndDate -- Use the Snapshot Last Sync Date since Functional Department is not snapshoted
	WHERE
		PS.BudgetAmount <> 0



	PRINT (''Rows inserted into #ProfitabilityReforecast: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE NONCLUSTERED INDEX IX_ProfitabilityReforecast ON
		#ProfitabilityReforecast
		(
			GLGlobalAccountId,
			SnapshotId
		)
END

/* ==============================================================================================================================================
	11.	Update #ProfitibilityReforecast.GlobalGlCategorizationHierarchyKey
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	-- Global Categorization Mapping

	UPDATE #ProfitabilityReforecast
	SET
		GlobalGLCategorizationHierarchyKey = 
			COALESCE(GLACM.GlobalGLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
	FROM
		#ProfitabilityReforecast Gl
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			GLACM.GLGlobalAccountId = Gl.GLGlobalAccountId AND
			GLACM.SnapshotId = Gl.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN Gl.IsExpense = 0
								THEN
									0
								ELSE
									Gl.IsDirectCost
							END

	RAISERROR( ''Updating #ProfitabilityReforecast GlobalGlCategorizationHierarchyKey'',0,1) WITH NOWAIT

	-- Local Categorization Mapping

	UPDATE
		#ProfitabilityReforecast
	SET
		USPropertyGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),
			
		USFundGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
						
		EUPropertyGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
			
		EUFundGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
			
		USDevelopmentGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey),
					
		EUDevelopmentGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown),

		ReportingGLCategorizationHierarchyKey =
			CASE 
				WHEN GC.GLCategorizationId IS NOT NULL
				THEN
					CASE
						WHEN GC.Name = ''US Property'' THEN ISNULL(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
						WHEN GC.Name = ''US Fund'' THEN ISNULL(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
						WHEN GC.Name = ''EU Property'' THEN ISNULL(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
						WHEN GC.Name = ''EU Fund'' THEN ISNULL(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
						WHEN GC.Name = ''US Development'' THEN ISNULL(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
						WHEN GC.Name = ''EU Development'' THEN ISNULL(GLACM.EUDevelopmentGLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
						WHEN GC.Name = ''Global'' THEN Gl.GlobalGLCategorizationHierarchyKey
						ELSE
							ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
					END
				ELSE
					ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
			END
	FROM
		#ProfitabilityReforecast Gl
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			GLACM.GLGlobalAccountId = Gl.GLGlobalAccountId AND
			GLACM.SnapshotId = Gl.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN Gl.IsExpense = 0
								THEN 1
								ELSE Gl.IsDirectCost
							END
		
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
			UnknownGCH.GLCategorizationHierarchyCode = ''-1:-1:-1:-1:-1:'' + CONVERT(VARCHAR(10), Gl.GLGlobalAccountId) AND
			UnknownGCH.SnapshotId = Gl.SnapshotId

		LEFT OUTER JOIN #GLCategorization GC ON
			GC.GLCategorizationId = Gl.DefaultGLCategorizationId AND
			GC.SnapshotId = Gl.SnapshotId
				
	PRINT (''Rows updated from #ProfitabilityReforecast: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	PRINT (''Creating Unique INDEX  IX_ProfitibilityRecforecast1 on #ProfitabilityReforecast on ReferenceCode'')
	
	SET @StartTime = GETDATE()
	
	CREATE UNIQUE CLUSTERED INDEX IX_ProfitibilityRecforecast ON
		#ProfitabilityReforecast
		(
			ReferenceCode
		)

	PRINT (''Created Unique INDEX  IX_ProfitibilityRecforecast1 on #ProfitabilityReforecast '')
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	12.	Delete budgets to insert that have UNKNOWNS in their mapping
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns

	DELETE
	FROM
		dbo.ProfitabilityReforecastUnknowns
	WHERE
		BudgetReforecastTypeKey IN (@ReforecastTypeIsGBSBUDKey, @ReforecastTypeIsGBSActKey) -- Only delete GBS records, leave TAPAS records

	PRINT (''Rows deleted from ProfitabilityReforecastUnknowns: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	INSERT INTO dbo.ProfitabilityReforecastUnknowns (
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId,
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		OverheadKey,
		FeeAdjustmentKey,
		BudgetReforecastTypeKey,
		SnapshotId,
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	FROM
		#ProfitabilityReforecast
	WHERE
		SourceKey = @SourceKeyUnknown OR
		(FunctionalDepartmentKey = @FunctionalDepartmentKeyUnknown AND IsExpense = 1) OR	
		ReimbursableKey = @ReimbursableKeyUnknown OR
		ActivityTypeKey = @ActivityTypeKeyUnknown OR
		PropertyFundKey = @PropertyFundKeyUnknown OR
		AllocationRegionKey = @AllocationRegionKeyUnknown OR
		OriginatingRegionKey = @OriginatingRegionKeyUnknown OR
		FeeAdjustmentKey = @FeeAdjustmentKeyUnknown OR
		LocalCurrencyKey = @LocalCurrencyKeyUnknown OR
		GlobalGLCategorizationHierarchyKey = @GLCategorizationHierarchyKeyUnknown

		/*
			OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
			CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
			ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
			BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a ''not null'' dbase constraint in source system)
		*/

	DECLARE @RowsInserted INT = @@rowcount
	PRINT (''Rows inserted into ProfitabilitReforecastUnknowns: '' + CONVERT(VARCHAR(10),@RowsInserted))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	13.	Insert, Update and Delete records from Fact table
============================================================================================================================================== */
BEGIN


	CREATE TABLE #ReforecastsToImport
	(
		BudgetId INT NOT NULL
	)
	INSERT INTO #ReforecastsToImport
	SELECT DISTINCT
		BudgetId
	FROM
		#ProfitabilityReforecast

	SET @StartTime = GETDATE()

SET @StartTime = GETDATE()

CREATE TABLE #SummaryOfChanges
(
	Change VARCHAR(20)
)

MERGE
	GrReporting.dbo.ProfitabilityReforecast FACT
USING
	#ProfitabilityReforecast AS SRC ON
		FACT.ReferenceCode = SRC.ReferenceCode
WHEN MATCHED AND
	(
		FACT.CalendarKey <> SRC.CalendarKey OR
		FACT.SourceKey <> SRC.SourceKey OR
		FACT.FunctionalDepartmentKey <> SRC.FunctionalDepartmentKey OR
		FACT.ReimbursableKey <> SRC.ReimbursableKey OR
		FACT.ActivityTypeKey <> SRC.ActivityTypeKey OR
		FACT.PropertyFundKey <> SRC.PropertyFundKey OR
		FACT.AllocationRegionKey <> SRC.AllocationRegionKey OR
		FACT.OriginatingRegionKey <> SRC.OriginatingRegionKey OR
		FACT.LocalCurrencyKey <> SRC.LocalCurrencyKey OR
		FACT.LocalReforecast <> SRC.LocalReforecast OR
		FACT.OverheadKey <> SRC.OverheadKey OR
		FACT.FeeAdjustmentKey <> SRC.FeeAdjustmentKey OR
		FACT.SnapshotId <> SRC.SnapshotId OR
		FACT.ReforecastKey <> SRC.ReforecastKey OR
		FACT.ConsolidationRegionKey <> SRC.ConsolidationRegionKey OR
		ISNULL(FACT.GlobalGLCategorizationHierarchyKey, '''') <> SRC.GlobalGLCategorizationHierarchyKey OR
		ISNULL(FACT.EUDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.EUDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(FACT.EUPropertyGLCategorizationHierarchyKey, '''') <> SRC.EUPropertyGLCategorizationHierarchyKey OR
		ISNULL(FACT.EUFundGLCategorizationHierarchyKey, '''') <> SRC.EUFundGLCategorizationHierarchyKey OR
		ISNULL(FACT.USDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.USDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(FACT.USPropertyGLCategorizationHierarchyKey, '''') <> SRC.USPropertyGLCategorizationHierarchyKey OR
		ISNULL(FACT.USFundGLCategorizationHierarchyKey, '''') <> SRC.USFundGLCategorizationHierarchyKey OR
		ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '''') <> SRC.ReportingGLCategorizationHierarchyKey
	) THEN
	UPDATE
	SET
		FACT.CalendarKey = SRC.CalendarKey,
		FACT.SourceKey = SRC.SourceKey,
		FACT.FunctionalDepartmentKey = SRC.FunctionalDepartmentKey,
		FACT.ReimbursableKey = SRC.ReimbursableKey,
		FACT.ActivityTypeKey = SRC.ActivityTypeKey,
		FACT.PropertyFundKey = SRC.PropertyFundKey,
		FACT.AllocationRegionKey = SRC.AllocationRegionKey,
		FACT.OriginatingRegionKey = SRC.OriginatingRegionKey,
		FACT.LocalCurrencyKey = SRC.LocalCurrencyKey,
		FACT.LocalReforecast = SRC.LocalReforecast,
		FACT.OverheadKey = SRC.OverheadKey,
		FACT.FeeAdjustmentKey = SRC.FeeAdjustmentKey,
		FACT.SnapshotId = SRC.SnapshotId,
		FACT.ReforecastKey = SRC.ReforecastKey,
		FACT.ConsolidationRegionKey = SRC.ConsolidationRegionKey,
		FACT.GlobalGLCategorizationHierarchyKey = SRC.GlobalGLCategorizationHierarchyKey,
		FACT.EUDevelopmentGLCategorizationHierarchyKey = SRC.EUDevelopmentGLCategorizationHierarchyKey,
		FACT.EUPropertyGLCategorizationHierarchyKey = SRC.EUPropertyGLCategorizationHierarchyKey,
		FACT.EUFundGLCategorizationHierarchyKey = SRC.EUFundGLCategorizationHierarchyKey,
		FACT.USDevelopmentGLCategorizationHierarchyKey = SRC.USDevelopmentGLCategorizationHierarchyKey,
		FACT.USPropertyGLCategorizationHierarchyKey = SRC.USPropertyGLCategorizationHierarchyKey,
		FACT.USFundGLCategorizationHierarchyKey = SRC.USFundGLCategorizationHierarchyKey,
		FACT.ReportingGLCategorizationHierarchyKey = SRC.ReportingGLCategorizationHierarchyKey,
		FACT.UpdatedDate = @StartTime,
		FACT.SourceSystemKey = SRC.SourceSystemKey
WHEN NOT MATCHED BY TARGET THEN
	INSERT
	(
		SnapshotId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		FeeAdjustmentKey,
		LocalCurrencyKey,
		LocalReforecast,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		InsertedDate,
		UpdatedDate,
		
		SourceSystemKey
	)
	VALUES
	(
		SRC.SnapshotId,
		SRC.BudgetReforecastTypeKey,
		SRC.ReforecastKey,
		SRC.CalendarKey,
		SRC.SourceKey,
		SRC.FunctionalDepartmentKey,
		SRC.ReimbursableKey,
		SRC.ActivityTypeKey,
		SRC.PropertyFundKey,
		SRC.AllocationRegionKey,
		SRC.ConsolidationRegionKey,
		SRC.OriginatingRegionKey,
		SRC.OverheadKey,
		SRC.FeeAdjustmentKey,
		SRC.LocalCurrencyKey,
		SRC.LocalReforecast,
		SRC.ReferenceCode,
		SRC.BudgetId,
		
		SRC.GlobalGLCategorizationHierarchyKey,
		SRC.USPropertyGLCategorizationHierarchyKey,
		SRC.USFundGLCategorizationHierarchyKey,
		SRC.EUPropertyGLCategorizationHierarchyKey,
		SRC.EUFundGLCategorizationHierarchyKey,
		SRC.USDevelopmentGLCategorizationHierarchyKey,
		SRC.EUDevelopmentGLCategorizationHierarchyKey,
		SRC.ReportingGLCategorizationHierarchyKey,
		@StartTime,
		@StartTime,
		
		SRC.SourceSystemKey
	)
WHEN NOT MATCHED BY SOURCE AND
	FACT.BudgetId IN (SELECT BudgetId FROM #ReforecastsToImport) AND
	FACT.BudgetReforecastTypeKey IN (@ReforecastTypeIsGBSBUDKey, @ReforecastTypeIsGBSACTKey) 
THEN
	DELETE
OUTPUT
		$action AS Change
	INTO
		#SummaryOfChanges;

CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''INSERT'')
DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''UPDATE'')
DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''DELETE'')

PRINT ''Rows added to ProfitabilityReforecast: ''+ CONVERT(char(10), @InsertedRows)
PRINT ''Rows updated in ProfitabilityReforecast: ''+ CONVERT(char(10),@UpdatedRows)
PRINT ''Rows deleted from ProfitabilityReforecast: ''+ CONVERT(char(10),@DeletedRows)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	14.	Mark budgets as being successfully processed into the warehouse
============================================================================================================================================== */
BEGIN

	UPDATE
		dbo.BudgetsToProcess
	SET
		ReforecastBudgetsProcessedIntoWarehouse = 1,
		ReforecastActualsProcessedIntoWarehouse = 1,
		DateBudgetProcessedIntoWarehouse = GETDATE()
	WHERE
		IsCurrentBatch = 1 AND
		IsReforecast = 1 AND
		BudgetReforecastTypeName = ''GBS Budget/Reforecast''

	PRINT (''Rows updated from dbo.BudgetsToProcess: '' + CONVERT(VARCHAR(10),@@rowcount))

END


/* ==============================================================================================================================================
	15.	Clean up
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID(''tempdb..#Budget'') IS NOT NULL
		DROP TABLE #Budget

	IF 	OBJECT_ID(''tempdb..#GLGlobalAccount'') IS NOT NULL
		DROP TABLE #GLGlobalAccount

	IF 	OBJECT_ID(''tempdb..#GLTranslationSubType'') IS NOT NULL
		DROP TABLE #GLTranslationSubType

	IF 	OBJECT_ID(''tempdb..#GLGlobalAccountTranslationSubType'') IS NOT NULL
		DROP TABLE #GLGlobalAccountTranslationSubType
	    
	IF 	OBJECT_ID(''tempdb..#GLMinorCategory'') IS NOT NULL
		DROP TABLE #GLMinorCategory
	    
	IF 	OBJECT_ID(''tempdb..#GLMajorCategory'') IS NOT NULL
		DROP TABLE #GLMajorCategory

	IF 	OBJECT_ID(''tempdb..#GLGlobalAccountTranslationType'') IS NOT NULL
		DROP TABLE #GLGlobalAccountTranslationType

	IF 	OBJECT_ID(''tempdb..#ReportingEntityCorporateDepartment'') IS NOT NULL
		DROP TABLE #ReportingEntityCorporateDepartment

	IF 	OBJECT_ID(''tempdb..#PropertyFund'') IS NOT NULL
		DROP TABLE #PropertyFund

	IF 	OBJECT_ID(''tempdb..#ActivityType'') IS NOT NULL
		DROP TABLE #ActivityType

	IF 	OBJECT_ID(''tempdb..#CorporateDepartment'') IS NOT NULL
		DROP TABLE #CorporateDepartment

	IF 	OBJECT_ID(''tempdb..#FunctionalDepartment'') IS NOT NULL
		DROP TABLE #FunctionalDepartment

	IF 	OBJECT_ID(''tempdb..#AllocationSubRegion'') IS NOT NULL
		DROP TABLE #AllocationSubRegion

	IF 	OBJECT_ID(''tempdb..#GLAccountCategoryMapping'') IS NOT NULL
		DROP TABLE #GLAccountCategoryMapping

	IF 	OBJECT_ID(''tempdb..#ProfitabilitySource'') IS NOT NULL
		DROP TABLE #ProfitabilitySource

	IF 	OBJECT_ID(''tempdb..#ProfitabilityBudget'') IS NOT NULL
		DROP TABLE #ProfitabilityBudget

	IF 	OBJECT_ID(''tempdb..#BudgetsToImport'') IS NOT NULL
		DROP TABLE #BudgetsToImport

	IF 	OBJECT_ID(''tempdb..#BudgetsToImportOriginal'') IS NOT NULL
		DROP TABLE #BudgetsToImportOriginal

	IF 	OBJECT_ID(''tempdb..#BudgetsToDelete'') IS NOT NULL
		DROP TABLE #BudgetsToDelete

	IF 	OBJECT_ID(''tempdb..#CorporatePropertySourceCodes'') IS NOT NULL
		DROP TABLE #CorporatePropertySourceCodes

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknowns'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknowns

	IF 	OBJECT_ID(''tempdb..#FunctionalDepartment'') IS NOT NULL
		DROP TABLE #FunctionalDepartment

	IF 	OBJECT_ID(''tempdb..#Actuals'') IS NOT NULL
		DROP TABLE #Actuals

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknownBudgets'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknownActuals'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownActuals

	IF 	OBJECT_ID(''tempdb..#AllUnknownBudgets'') IS NOT NULL
		DROP TABLE #AllUnknownBudgets

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcessToUpdate'') IS NOT NULL
		DROP TABLE #BudgetsToProcessToUpdate
	    
	IF 	OBJECT_ID(''tempdb..#ConsolidationRegionCorporateDepartment'') IS NOT NULL
		DROP TABLE #ConsolidationRegionCorporateDepartment

END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/*********************************************************************************************************************
	Description
	
	This stored procedure processes non-payroll and fee original budget information and uploads it to the
	ProfitabilityBudget table in the data warehouse (GrReporting.dbo.ProfitabilityBudget)
	
		1. Get Budgets to Process
		2. Declare local variables and create common tables
		3. Source budget data from GrReportingStaging.GBS.Budget
		4. Source Snapshot mapping data from GDM
		5. Create master GL Account Category mapping table
		6. Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
		7. Insert Non-Payroll Expense budget items into the temporary source table
		8. Insert Fee budget items into the temporary source table
		9. Create a temporary ''staging'' table that matches the schema of the GrReporting.dbo.ProfitabilityBudget fact
		10. Update the GL Categorization Hierarchy fields in the ''staging'' temporary table
		11. Delete budgets to insert that have UNKNOWNS in their mapping
		12. Delete existing budgets from GrReporting.dbo.ProfitabilityBudget that we are about to reinsert
		13. Insert budget records into GrReporting.dbo.ProfitabilityBudget from the ''staging'' temporary table
		14. Mark budgets as being successfully processed into the warehouse
		15. Clean up: drop temporary tables

	History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

				2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGBSBudget]
	@DataPriorToDate	DateTime=NULL
AS

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyGBSBudget''
PRINT ''####''

IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportGBSBudget'') <> 1)
BEGIN
	PRINT (''Import of GBS Budget is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...'')
	RETURN
END

DECLARE @RowCount INT
DECLARE @StartTime DATETIME = GETDATE()

/* ==============================================================================================================================================
	1. Get Budgets to Process [perhaps move this to BudgetsToProcess stored procedure?]
   =========================================================================================================================================== */
BEGIN

	SELECT 
		BTPC.BudgetsToProcessId,
		BTPC.BudgetId,
		BTPC.ImportBatchId,
		BTPC.SnapshotId, 
		Reforecast.ReforecastKey
	INTO 
		#BudgetsToProcess 
	FROM 
		dbo.BudgetsToProcess BTPC

		INNER JOIN
		(
			SELECT
				MIN(ReforecastKey) AS ReforecastKey, -- ReforecastKey and ReforecastEffectivePeriod have the same ordering. ReforecastKey is computed
				ReforecastEffectiveYear				 -- the same as CalendarKey, and is therefore date-based
			FROM
				GrReporting.dbo.Reforecast
			WHERE
				ReforecastQuarterName = ''Q0'' -- This is the original budget stored procedure; we can therefore hard-code ''Q0''
			GROUP BY
				ReforecastEffectiveYear

		) Reforecast ON
			BTPC.BudgetYear = Reforecast.ReforecastEffectiveYear
	WHERE 
		BTPC.IsCurrentBatch = 1 AND
		BTPC.BudgetReforecastTypeName = ''GBS Budget/Reforecast'' AND
		BTPC.IsReforecast = 0 -- This stored procedure handles original GBS budgets only (and not reforecasts)

	------------------------

	DECLARE @BTPRowCount INT = @@rowcount
	PRINT (''Rows inserted into #BudgetsToProcess: '' + CONVERT(VARCHAR(10),@BTPRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	IF (@BTPRowCount = 0)
	BEGIN
		PRINT (''stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS BudgetsToProcess set to be imported.'')
		RETURN
	END

END

/* ==============================================================================================================================================
	2. Declare local variables and create common tables
   =========================================================================================================================================== */
BEGIN

DECLARE
	@UnknownSourceKey					 INT = (SELECT TOP 1 SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN''),
	@UnknownFunctionalDepartmentKey		 INT = (SELECT TOP 1 FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN''),
	@UnknownActivityTypeKey				 INT = (SELECT TOP 1 ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN''),
	@UnknownPropertyFundKey				 INT = (SELECT TOP 1 PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN''),
	@UnknownAllocationRegionKey			 INT = (SELECT TOP 1 AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN''),
	@UnknownOriginatingRegionKey		 INT = (SELECT TOP 1 OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN''),
	@UnknownOverheadKey					 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = ''UNKNOWN''),
	@UnknownLocalCurrencyKey			 INT = (SELECT TOP 1 CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNKNOWN''),
	@UnknownGLCategorizationHierarchyKey INT = (SELECT TOP 1 GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''UNKNOWN'' AND SnapshotId = 0),
	@GBSBudgetReforecastTypeKey			 INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode = ''GBSBUD''),

	@FEEADJUSTFeeAdjustmentKey			 INT = (SELECT TOP 1 FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''FEEADJUST''),
	@NORMALFeeAdjustmentKey				 INT = (SELECT TOP 1 FeeAdjustmentKey FROM GrReporting.dbo.FeeAdjustment WHERE FeeAdjustmentCode = ''NORMAL''),

	@ALLOCOverheadKey					 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = ''ALLOC''),
	@UNALLOCOverheadKey					 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = ''UNALLOC''),
	@NAOverheadKey						 INT = (SELECT TOP 1 OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadCode = ''N/A''),

	@NOReimbursableKey					 INT = (SELECT TOP 1 ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''NO''),
	@YESReimbursableKey					 INT = (SELECT TOP 1 ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''YES'')

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Property'' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Fund'' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Property'' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Fund'' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Development'' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''Global'' AND SnapshotId = 0)


	-- There could be up to three copies of the same GBS data due to three seperate imports, so work with latest GBS import which should have the
	-- highest ImportBatchId.

	IF (@DataPriorToDate IS NULL)
		BEGIN
		SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate''))
		END
	
	CREATE TABLE #BudgetsWithUnknownBudgets(
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL
	)

-- Corporate Property Sources

	CREATE TABLE #CorporatePropertySourceCodes (
		CorporateSourceCode CHAR(2) NOT NULL,
		PropertySourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #CorporatePropertySourceCodes
	VALUES
		(''UC'', ''US''),
		(''EC'', ''EU''),
		(''IC'', ''IN''),
		(''BC'', ''BR''),
		(''CC'', ''CN'')

END

/* ==============================================================================================================================================
	3. Source budget data from GrReportingStaging.GBS.Budget [not sure whether this is still necessary] [!!]
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	CREATE TABLE #Budget(
		ReforecastKey INT NOT NULL,
		ImportKey INT NOT NULL,
		ImportBatchId INT NOT NULL,
		BudgetId INT NOT NULL,
		Name VARCHAR(50) NOT NULL,
		LastLockedDate DATETIME NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #Budget
	SELECT
		BTP.ReforecastKey,
		Budget.ImportKey,
		Budget.ImportBatchId,
		Budget.BudgetId,
		Budget.Name,
		Budget.LastLockedDate,
		BTP.SnapshotId
	FROM
		GBS.Budget Budget
		
		INNER JOIN #BudgetsToProcess BTP ON -- All GBS budgets in dbo.BudgetsToProcess must be considered because they are to be processed into the warehouse
			Budget.BudgetId = BTP.BudgetId AND
			Budget.ImportBatchId = BTP.ImportBatchId	
	WHERE
		Budget.IsActive = 1
	
	DECLARE @BudgetRowCount INT = @@rowcount
	
	IF (@BudgetRowCount = 0)
	BEGIN
		PRINT (''stp_IU_LoadGrProfitabiltyGBSBudget is quitting because there are no GBS budgets set to be imported.'')
		RETURN
	END

	CREATE UNIQUE CLUSTERED INDEX IX_Budget ON #Budget (SnapshotId, BudgetId)

	PRINT (''Rows inserted into #Budget: '' + CONVERT(VARCHAR(10),@BudgetRowCount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	4. Source Snapshot mapping data from GDM
   =========================================================================================================================================== */
BEGIN

-- GLGlobalAccount --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccount(
		GLGlobalAccountId INT NOT NULL,
		ActivityTypeId INT NULL,
		Code VARCHAR(10) NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccount (
		GLGlobalAccountId,
		ActivityTypeId,
		Code,
		SnapshotId
	)
	SELECT DISTINCT
		GLGA.GLGlobalAccountId,
		GLGA.ActivityTypeId,
		GLGA.Code,
		GLGA.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccount GLGA
		INNER JOIN #Budget B ON
			GLGA.SnapshotId = B.SnapshotId
	WHERE
		GLGA.IsActive = 1
	
	

	PRINT (''Rows inserted into #GLGlobalAccount: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount(GLGlobalAccountId, SnapshotId)
-- SnapshotGLGlobalAccountCategorization -------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLGlobalAccountCategorization(
		GLGlobalAccountId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		DirectGLMinorCategoryId INT NULL,
		IndirectGLMinorCategoryId INT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #GLGlobalAccountCategorization(
		GLGlobalAccountId,
		GLCategorizationId,
		DirectGLMinorCategoryId,
		IndirectGLMinorCategoryId,
		SnapshotId
	)
	SELECT DISTINCT
		GGAC.GLGlobalAccountId,
		GGAC.GLCategorizationId,
		GGAC.DirectGLMinorCategoryId,
		GGAC.IndirectGLMinorCategoryId,
		GGAC.SnapshotId
	FROM
		Gdm.SnapshotGLGlobalAccountCategorization GGAC
		INNER JOIN #Budget B ON
			GGAC.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #GLGlobalAccountCategorization '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLMinorCategory -----------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMinorCategory (
		SnapshotId INT NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMajorCategoryId INT NOT NULL
	)
	INSERT INTO #GLMinorCategory
	SELECT DISTINCT
		MinC.SnapshotId,
		MinC.GLMinorCategoryId,
		MinC.GLMajorCategoryId
	FROM
		Gdm.SnapshotGLMinorCategory MinC
		INNER JOIN #Budget B ON
			MinC.SnapshotId = B.SnapshotId
	WHERE
		MinC.IsActive = 1

	PRINT (''Rows inserted into #GLMinorCategory: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLMajorCategory ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLMajorCategory (
		SnapshotId INT NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLFinancialCategoryId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #GLMajorCategory
	SELECT DISTINCT
		MajC.SnapshotId,
		MajC.GLMajorCategoryId,
		MajC.GLFinancialCategoryId,
		MajC.GLCategorizationId
	FROM
		Gdm.SnapshotGLMajorCategory MajC
		INNER JOIN #Budget B ON
			MajC.SnapshotId = B.SnapshotId
	WHERE
		MajC.IsActive = 1

	PRINT (''Rows inserted into #GLMajorCategory: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLFinancialCategory ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLFinancialCategory(
		SnapshotId INT NOT NULL,
		GLFinancialCategoryId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #GLFinancialCategory(
		SnapshotId,
		GLFinancialCategoryId,
		GLCategorizationId
	)
	SELECT DISTINCT
		FinC.SnapshotId,
		FinC.GLFinancialCategoryId,
		FinC.GLCategorizationId
	FROM
		Gdm.SnapshotGLFinancialCategory FinC
		INNER JOIN #Budget B ON
			FinC.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #GLFinancialCategory '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorization(
		SnapshotId INT NOT NULL,
		GLCategorizationId INT NOT NULL,
		GLCategorizationTypeId INT NOT NULL,
		Name VARCHAR(50) NOT NULL
	)
	INSERT INTO #GLCategorization(
		SnapshotId,
		GLCategorizationId,
		GLCategorizationTypeId,
		Name
	)
	SELECT DISTINCT
		GC.SnapshotId,
		GC.GLCategorizationId,
		GC.GLCategorizationTypeId,
		GC.Name
	FROM
		Gdm.SnapshotGLCategorization GC
		INNER JOIN #Budget B ON
			GC.SnapshotId = B.SnapshotId
	WHERE
		GC.IsActive = 1	

	PRINT (''Rows inserted into #GLCategorization '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- GLCategorizationType ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #GLCategorizationType(
		SnapshotId INT NOT NULL,
		GLCategorizationTypeId INT NOT NULL
	)
	INSERT INTO #GLCategorizationType(
		SnapshotId,
		GLCategorizationTypeId
	)
	SELECT DISTINCT
		GCT.SnapshotId,
		GCT.GLCategorizationTypeId
	FROM
		Gdm.SnapshotGLCategorizationType GCT
		INNER JOIN #Budget B ON
			GCT.SnapshotId = B.SnapshotId
	WHERE
		GCT.IsActive = 1	

	PRINT (''Rows inserted into #GLCategorizationType '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- ReportingCategorization ---------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ReportingCategorization(
		SnapshotId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		GLCategorizationId INT NOT NULL
	)
	INSERT INTO #ReportingCategorization(
		SnapshotId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId,
		GLCategorizationId
	)
	SELECT DISTINCT
		RC.SnapshotId,
		RC.EntityTypeId,
		RC.AllocationSubRegionGlobalRegionId,
		RC.GLCategorizationId
	FROM
		Gdm.SnapshotReportingCategorization RC
		INNER JOIN #Budget B ON
			RC.SnapshotId = B.SnapshotId

	
	PRINT (''Rows inserted into #ReportingCategorization '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_ReportingCategorization_Clustered ON #ReportingCategorization(AllocationSubRegionGlobalRegionId, EntityTypeId, SnapshotId)

-- ConsolidationRegionCorporateDepartment (CC16) -----------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ConsolidationRegionCorporateDepartment
	(
		ConsolidationRegionCorporateDepartmentId INT NOT NULL,
		CorporateDepartmentCode VARCHAR(10) NOT NULL,
		SourceCode VARCHAR(2) NOT NULL,
		GlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ConsolidationRegionCorporateDepartment
	SELECT DISTINCT
		CRCD.ConsolidationRegionCorporateDepartmentId,
		CRCD.CorporateDepartmentCode,
		CRCD.SourceCode,
		CRCD.GlobalRegionId,
		CRCD.SnapshotId
	FROM 
		Gdm.SnapshotConsolidationRegionCorporateDepartment CRCD
		INNER JOIN #Budget B ON
			CRCD.SnapshotId = B.SnapshotId

	PRINT (''Rows inserted into #ConsolidationRegionCorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartmentCode ON #ConsolidationRegionCorporateDepartment(CorporateDepartmentCode, SourceCode, SnapshotId)

-- PropertyFund --------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #PropertyFund(
		PropertyFundId INT NOT NULL,
		EntityTypeId INT NOT NULL,
		AllocationSubRegionGlobalRegionId INT NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #PropertyFund
	SELECT DISTINCT
		PF.PropertyFundId,
		PF.EntityTypeId,
		PF.AllocationSubRegionGlobalRegionId,
		PF.SnapshotId
	FROM
		Gdm.SnapshotPropertyFund PF
		INNER JOIN #Budget B ON
			PF.SnapshotId = B.SnapshotId  
	WHERE
		PF.IsActive = 1

	PRINT (''Rows inserted into #PropertyFund: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_PropertyFund_PropertyFundId ON #PropertyFund(PropertyFundId, SnapshotId)

-- Global Region ---------------------------------------------------------------------------------

	SET @StartTime = GETDATE()
	
	CREATE TABLE #GlobalRegion
	(
		SnapshotId INT NOT NULL,
		GlobalRegionId INT NOT NULL,
		IsAllocationRegion BIT NOT NULL,
		IsOriginatingRegion BIT NOT NULL,
		IsConsolidationRegion BIT NOT NULL,
		DefaultCorporateSourceCode CHAR(2) NOT NULL
	)
	INSERT INTO #GlobalRegion
	(
		SnapshotId,
		GlobalRegionId,
		IsAllocationRegion,
		IsOriginatingRegion,
		IsConsolidationRegion,
		DefaultCorporateSourceCode
	)
	SELECT DISTINCT
		GR.SnapshotId,
		GR.GlobalRegionId,
		GR.IsAllocationRegion,
		GR.IsOriginatingRegion,
		GR.IsConsolidationRegion,
		GR.DefaultCorporateSourceCode
	FROM
		Gdm.SnapshotGlobalRegion GR
		INNER JOIN #Budget B ON
			GR.SnapshotId = B.SnapshotId
	WHERE
		IsActive = 1
		
	PRINT (''Rows inserted into #GlobalRegion: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_GlobalRegion_GlobalRegionId ON #GlobalRegion(GlobalRegionId, SnapshotId)	
	
-- ActivityType --------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #ActivityType(
		ActivityTypeId INT NOT NULL,
		Code VARCHAR(10) NOT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO #ActivityType
	SELECT DISTINCT
		ActivityTypeId,
		Code,
		AT.SnapshotId
	FROM
		Gdm.SnapshotActivityType AT
		INNER JOIN #Budget B ON
			AT.SnapshotId = B.SnapshotId
	WHERE
		AT.IsActive = 1

	PRINT (''Rows inserted into #ActivityType: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

-- Department -----------------------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #CorporateDepartment(
		Code CHAR(8) NOT NULL,
		SourceCode CHAR(2) NOT NULL,
		FunctionalDepartmentId INT NULL,
		IsTsCost BIT NULL,
		SnapshotId INT NOT NULL
	)
	INSERT INTO	#CorporateDepartment
	SELECT DISTINCT
		D.Code,
		D.SourceCode,
		D.FunctionalDepartmentId,
		D.IsTsCost,
		D.SnapshotId
	FROM
		Gdm.SnapshotCorporateDepartment D
		INNER JOIN #Budget B ON
			D.SnapshotId = B.SnapshotId
	WHERE
		D.IsActive = 1

	PRINT (''Rows inserted into #CorporateDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))
	
	CREATE UNIQUE CLUSTERED INDEX UX_CorporateDepartment_Code ON #CorporateDepartment(Code, SourceCode, SnapshotId)

-- FunctionalDepartment -------------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #FunctionalDepartment (
		FunctionalDepartmentId INT NOT NULL,
		Code VARCHAR(20) NULL,
		GlobalCode VARCHAR(30) NULL
	)

	INSERT INTO #FunctionalDepartment
	SELECT
		FunctionalDepartmentId,
		Code,
		GlobalCode
	FROM
		HR.FunctionalDepartment FD
	
		INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDa ON
			FD.ImportKey = FDa.ImportKey
	WHERE
		FD.IsActive = 1

	PRINT (''Rows inserted into #FunctionalDepartment: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)
-- AllocationSubRegion -----------------------------------------------------------------------------

	SET @StartTime = GETDATE()

	CREATE TABLE #AllocationSubRegion (
		SnapshotId int NOT NULL,
		AllocationSubRegionGlobalRegionId int NOT NULL,
		Code varchar(10) NOT NULL,
		Name varchar(50) NOT NULL,
		AllocationRegionGlobalRegionId int NULL,
		DefaultCorporateSourceCode char(2) NOT NULL
	)
	INSERT INTO #AllocationSubRegion
	SELECT DISTINCT
		ASR.SnapshotId,
		ASR.AllocationSubRegionGlobalRegionId,
		ASR.Code,
		ASR.Name,
		ASR.AllocationRegionGlobalRegionId,
		ASR.DefaultCorporateSourceCode
	FROM
		Gdm.SnapshotAllocationSubRegion ASR
		INNER JOIN #Budget B ON
			ASR.SnapshotId = B.SnapshotId
	WHERE
		ASR.IsActive = 1

	PRINT (''Rows inserted into #AllocationSubRegion: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	5. Create master GL Account Category mapping table
   ============================================================================================================================================ */
BEGIN

	SET @StartTime = GETDATE()

	/*
		The following table gets the Global Account Categorization mapping data from GDM, and pivots the data so that the first row has the 
			Global Account Id and each column represents the a GL Categorization Hierarchy code for one of the GL Categorizations.

		The purpose of having the table like this is to avoid joining onto the fact table multiple times.
	*/

	CREATE TABLE #GlAccountCategoryMapping (
		SnapshotId INT NOT NULL,
		GLGlobalAccountId INT NOT NULL,
		IsDirect BIT NOT NULL,
		GlobalGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUPropertyGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUFundGLCategorizationHierarchyKey VARCHAR(50) NULL,
		USDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL,
		EUDevelopmentGLCategorizationHierarchyKey VARCHAR(50) NULL		
	)
	INSERT INTO #GlAccountCategoryMapping
	(
		SnapshotId,
		GLGlobalAccountId,
		IsDirect,
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey
	)
	SELECT
		PivotTable.SnapshotId,
		PivotTable.GLGlobalAccountId,
		PivotTable.IsDirectCost,
		PivotTable.[Global] AS GlobalGLCategorizationHierarchyKey,
		PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyKey,
		PivotTable.[US Fund] AS USFundGLCategorizationHierarchyKey,
		PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyKey,
		PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyKey,
		PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyKey,
		PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyKey
	FROM
		(	
			-- Indirect Minor Categories
			SELECT DISTINCT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				0 AS IsDirectCost
			FROM
				#GLGlobalAccount GGA
				
				INNER JOIN #GLCategorization GLC ON
					GGA.SnapshotId = GLC.SnapshotId  
				
				INNER JOIN #GLCategorizationType GLCT ON
					GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId AND
					GLC.SnapshotId = GLCT.SnapshotId 			
				
				LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
					GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId   AND
					GGA.SnapshotId = GLGAC.SnapshotId  AND
					GLC.GLCategorizationId = GLGAC.GLCategorizationId					

				LEFT OUTER JOIN #GLMinorCategory MinC ON
					GLGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
					GLGAC.SnapshotId  = MinC.SnapshotId  
					
				LEFT OUTER JOIN #GLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	AND
					MinC.SnapshotId = MajC.SnapshotId
				
				LEFT OUTER JOIN #GLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					MajC.SnapshotId = FinC.SnapshotId  
				
 				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GCH ON
					GCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GLCT.SnapshotId = GCH.SnapshotId
					
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
					UnknownGCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':-1:-1:-1:'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GGA.SnapshotId = UnknownGCH.SnapshotId	
			UNION

			-- Direct Minor Categories
			SELECT DISTINCT
				GGA.SnapshotId,
				GGA.GLGlobalAccountId,
				GLC.Name AS GLCategorizationName,
				ISNULL(GCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey) AS GLCategorizationHierarchyKey,
				1 AS IsDirectCost
			FROM
				#GLGlobalAccount GGA
				
				INNER JOIN #GLCategorization GLC ON
					GGA.SnapshotId = GLC.SnapshotId  
				
				INNER JOIN #GLCategorizationType GLCT ON
					GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId AND
					GLC.SnapshotId = GLCT.SnapshotId 			
				
				LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
					GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId   AND
					GGA.SnapshotId = GLGAC.SnapshotId  AND
					GLC.GLCategorizationId = GLGAC.GLCategorizationId					

				LEFT OUTER JOIN #GLMinorCategory MinC ON
					GLGAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
					GLGAC.SnapshotId  = MinC.SnapshotId  
					
				LEFT OUTER JOIN #GLMajorCategory MajC ON
					MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	AND
					MinC.SnapshotId = MajC.SnapshotId
				
				LEFT OUTER JOIN #GLFinancialCategory FinC ON
					MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  AND
					MajC.SnapshotId = FinC.SnapshotId  
				
 				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GCH ON
					GCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GLCT.SnapshotId = GCH.SnapshotId
					
				LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
					UnknownGCH.GLCategorizationHierarchyCode = 
						CONVERT(VARCHAR(2),  GLCT.GLCategorizationTypeId) + '':'' +
						CONVERT(VARCHAR(10), GLC.GLCategorizationId) + '':-1:-1:-1:'' +
						CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AND
					GGA.SnapshotId = UnknownGCH.SnapshotId
		) Mappings

		PIVOT
		(
			MAX(GLCategorizationHierarchyKey)
			FOR
				GLCategorizationName IN ([Global], [US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
		) AS PivotTable

	
	
	PRINT (''Rows inserted into #GLAccountCategoryMapping: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	CREATE UNIQUE CLUSTERED INDEX UX_GlAccountCategoryMapping_GLGlobalAccountId ON #GlAccountCategoryMapping(GLGlobalAccountId, SnapshotId, IsDirect)
END

/* ==============================================================================================================================================
	6. Create the temporary source table into which Non-Payroll Expense and Fee budgets are to be inserted
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #ProfitabilitySource (
		ImportBatchId INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		BudgetId INT NOT NULL,
		ReferenceCode VARCHAR(300) NOT NULL,
		ExpensePeriod CHAR(6) NOT NULL,	
		SourceCode VARCHAR(2) NULL,
		BudgetAmount MONEY NOT NULL,
		GLGlobalAccountId INT NULL,
		FunctionalDepartmentCode VARCHAR(20) NULL,
		JobCode VARCHAR(20) NULL,
		ReimbursableKey INT NOT NULL,
		ActivityTypeId INT NULL,                       -- NULL because for Fees this field is determined via an outer join
		PropertyFundId INT NULL,                       -- NULL because this field is determined via an outer join
		AllocationSubRegionGlobalRegionId INT NULL,    -- NULL because this field is determined via an outer join
		ConsolidationSubRegionGlobalRegionId INT NULL, -- NULL because this field is determined via an outer join
		OriginatingGlobalRegionId INT NULL,
		LocalCurrencyCode CHAR(3) NOT NULL,
		LockedDate DATETIME NULL,
		IsExpense BIT NOT NULL,
		OverheadKey INT NOT NULL,
		FeeAdjustmentKey INT NOT NULL,
		IsDirectCost BIT NULL,
		DefaultGLCategorizationId INT NULL,
		SourceTableName VARCHAR(255) NOT NULL
	)

END

/* ==============================================================================================================================================
	7. Insert Non-Payroll Expense budget items into the temporary source table
   =========================================================================================================================================== */
BEGIN

	-- These are disputed items which are to be exluded
	
	CREATE TABLE #NonPayrollExpenseDispute
	(
		ImportBatchId INT NOT NULL,
		NonPayrollExpenseId INT NOT NULL,
		BudgetProjectId INT NOT NULL
	)
	INSERT INTO #NonPayrollExpenseDispute
	(
		ImportBatchId,
		NonPayrollExpenseId,
		BudgetProjectId
	)
	SELECT DISTINCT
		NPED.ImportBatchId,
		NPED.NonPayrollExpenseId,
		NPED.BudgetProjectId
	FROM
		GBS.NonPayrollExpenseDispute NPED
		INNER JOIN GBS.DisputeStatus DS ON
			NPED.DisputeStatusId = DS.DisputeStatusId AND
			NPED.ImportBatchId = DS.ImportBatchId
	WHERE
		DS.Name <> ''Resolved'' AND
		DS.IsActive = 1
		
	CREATE UNIQUE CLUSTERED INDEX UX_NonPayrollExpenseDispute_Clustered ON #NonPayrollExpenseDispute(NonPayrollExpenseId, ImportBatchId, BudgetProjectId)
	
				
	SET @StartTime = GETDATE()

	-- Insert original budget amounts
	
	INSERT INTO #ProfitabilitySource (
		ImportBatchId,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		ReimbursableKey,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		OverheadKey,
		FeeAdjustmentKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId,                         -- BudgetId
		''GBS:BudgetId='' + LTRIM(RTRIM(STR(Budget.BudgetId))) + 
			''&NonPayrollExpenseBreakdownId='' + LTRIM(RTRIM(STR(NPEB.NonPayrollExpenseBreakdownId))) + 
			''&SnapshotId='' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
		NPEB.Period,                             -- ExpensePeriod: Period is actually a foreign key to PeriodExtended but is also the implied
												 --		period value, e.g.: 201009
		CASE WHEN NPEB.IsDirectCost = 1 THEN CPSC.PropertySourceCode ELSE NPEB.CorporateSourceCode END AS CorporateSourceCode,	
		NPEB.Amount,                             -- BudgetAmount
		ISNULL(NPEB.ActivitySpecificGLGlobalAccountId, NPEB.GLGlobalAccountId), -- GLGlobalAccountId
		FD.GlobalCode,                           -- FunctionalDepartmentCode
		NPEB.JobCode,                            -- JobCode
		CASE WHEN CD.IsTsCost = 0 THEN @YESReimbursableKey ELSE @NOReimbursableKey END, -- Reimbursable
		NPEB.ActivityTypeId,                     -- ActivityTypeId: this Id should correspond to the correct Id in GDM
		PF.PropertyFundId,						 -- PropertyFundId
		PF.AllocationSubRegionGlobalRegionId,    -- AllocationSubRegionGlobalRegionId
		CRCD.GlobalRegionId,                     -- Consolidation Sub-Region GlobalRegionId (CC16)
		NPEB.OriginatingSubRegionGlobalRegionId, -- OriginatingGlobalRegionId
		NPEB.CurrencyCode,                       -- LocalCurrencyCode
		Budget.LastLockedDate,                   -- LockedDate
		1,                                       -- IsExpense
		CASE WHEN AT.Code = ''CORPOH'' THEN @UNALLOCOverheadKey ELSE @NAOverheadKey END, -- UnallocatedOverhead
		@NORMALFeeAdjustmentKey,                 -- FeeAdjustment
		NPEB.IsDirectCost,                       -- IsDirectCost
		RC.GLCategorizationId,                    -- DefaultGLCategorizationId
		''NonPayrollExpenseBreakdown''
	FROM
	
		#Budget Budget
		
		INNER JOIN GBS.NonPayrollExpenseBreakdown NPEB ON
			Budget.BudgetId = NPEB.BudgetId AND
			Budget.ImportBatchId = NPEB.ImportBatchId
		
		INNER JOIN GBS.NonPayrollExpense NPE ON
			NPEB.NonPayrollExpenseId = NPE.NonPayrollExpenseId AND
			NPEB.ImportBatchId = NPE.ImportBatchId
		
		INNER JOIN #CorporatePropertySourceCodes CPSC ON
			NPEB.CorporateSourceCode = CPSC.CorporateSourceCode
	
			/* Disputes are created at the level of a budget project. A budget project will dispute the portion of a non-payroll expense that is
			   allocated to them (via the NonPayrollExpenseBreakdown table, which includes the NonPayrollExpenseId and BudgetProjectId fields,
			   allowing for the portion of the non-payroll expense that has been allocated to the budget project to be determined).
			   
			   If, for example, a non-payroll expense is split between two budget projects, and one of these budget projects is disputing their
			   allocation, the portion of the non-payroll expense that is allocated to the budget project that is not disputing must still be
			   included. Only thet portion of the non-payroll expense that is currently being disputed must be excluded.	   
			*/
		
		LEFT OUTER JOIN #NonPayrollExpenseDispute DisputedNonPayrollExpenseItems ON -- these NonPayrollExpenses need to be excluded because they are in dispute
			NPEB.NonPayrollExpenseId = DisputedNonPayrollExpenseItems.NonPayrollExpenseId AND
			NPEB.BudgetProjectId = DisputedNonPayrollExpenseItems.BudgetProjectId AND
			NPEB.ImportBatchId = DisputedNonPayrollExpenseItems.ImportBatchId

		-- Consolidation Sub Region GlobalRegionId (CC16)
		LEFT OUTER JOIN #ConsolidationRegionCorporateDepartment CRCD ON
			NPEB.CorporateDepartmentCode = CRCD.CorporateDepartmentCode AND
			NPEB.CorporateSourceCode = CRCD.SourceCode AND
			Budget.SnapshotId = CRCD.SnapshotId
		
		-- AllocationRegionId
		LEFT OUTER JOIN #PropertyFund PF ON
			NPEB.ReportingEntityPropertyFundId = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId
		
		-- Overhead Type
		LEFT OUTER JOIN #ActivityType AT ON
			NPEB.ActivityTypeId = AT.ActivityTypeId AND
			Budget.SnapshotId = AT.SnapshotId -- 
		
		-- Reimbursable
		LEFT OUTER JOIN #CorporateDepartment CD ON
			NPEB.CorporateSourceCode = CD.SourceCode AND
			NPEB.CorporateDepartmentCode = CD.Code AND
			Budget.SnapshotId = CD.SnapshotId --

		-- FunctionalDepartmentCode
		LEFT OUTER JOIN #FunctionalDepartment FD ON
			NPEB.FunctionalDepartmentId = FD.FunctionalDepartmentId
			
		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId  = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId  
	WHERE
		DisputedNonPayrollExpenseItems.NonPayrollExpenseId IS NULL AND -- Exclude all disputed items 
		NPE.IsDeleted = 0

	PRINT (''Rows inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	8. Insert Fee budget items into the temporary source table
   =========================================================================================================================================== */
BEGIN

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilitySource (
		ImportBatchId,
		ReforecastKey,
		SnapshotId,
		BudgetId,
		ReferenceCode,
		ExpensePeriod,
		SourceCode,
		BudgetAmount,
		GLGlobalAccountId,
		FunctionalDepartmentCode,
		JobCode,
		ReimbursableKey,
		ActivityTypeId,
		PropertyFundId,
		AllocationSubRegionGlobalRegionId,
		ConsolidationSubRegionGlobalRegionId,
		OriginatingGlobalRegionId,
		LocalCurrencyCode,
		LockedDate,
		IsExpense,
		OverheadKey,
		FeeAdjustmentKey,
		IsDirectCost,
		DefaultGLCategorizationId,
		SourceTableName
	)
	SELECT
		Budget.ImportBatchId,
		Budget.ReforecastKey,
		Budget.SnapshotId,
		Budget.BudgetId,                       -- BudgetId
		''GBS:BudgetId='' + LTRIM(RTRIM(STR(Budget.BudgetId))) +
			''&FeeId='' + LTRIM(RTRIM(STR(Fee.FeeId))) +
			''&FeeDetailId='' + LTRIM(RTRIM(STR(FeeDetail.FeeDetailId))) +
			''&SnapshotId='' + LTRIM(RTRIM(STR(Budget.SnapshotId))), -- ReferenceCode
		FeeDetail.Period,
		AllocationSubRegion.DefaultCorporateSourceCode,        -- SourceCode
		FeeDetail.Amount,
		GA.GLGlobalAccountId,                  -- GLGlobalAccountId
		NULL,                                  -- FunctionalDepartmentId
		NULL,                                  -- JobCode
		@NOReimbursableKey,                    -- Reimbursable
		GA.ActivityTypeId,                     -- ActivityType: determined by finding Fee.GLGlobalAccountId on GrReportingStaging.dbo.GLGlobalAccount
		Fee.PropertyFundId,                    -- PropertyFundId
		AllocationSubRegion.GlobalRegionId, -- AllocationSubRegionGlobalRegionId
		AllocationSubRegion.GlobalRegionId, -- Assumption is that there will be no EU Funds for Fee Data so Allocation and Consolidation region would be the same
		AllocationSubRegion.GlobalRegionId, -- OriginatingGlobalRegionId: allocation region = originating region for fee income
		Fee.CurrencyCode,
		Budget.LastLockedDate,                 -- LockedDate
		0,                                     -- IsExpense
		@NAOverheadKey,                   -- IsUnallocatedOverhead: defaults to UNKNOWN for fees
		CASE WHEN FeeDetail.IsAdjustment = 1 THEN @FEEADJUSTFeeAdjustmentKey ELSE @NORMALFeeAdjustmentKey END, -- IsFeeAdjustment, field isn''t NULLABLE
		NULL,                                  -- IsDirectCost
		RC.GLCategorizationId,                  -- DefaultGLCategorizationId
		''Fee''
	FROM
		#Budget Budget

		INNER JOIN GBS.Fee Fee ON
			Budget.BudgetId = Fee.BudgetId AND
			Budget.ImportBatchId = Fee.ImportBatchId

		INNER JOIN GBS.FeeDetail FeeDetail ON
			Fee.FeeId = FeeDetail.FeeId AND
			Fee.ImportBatchId = FeeDetail.ImportBatchId

		LEFT OUTER JOIN #GLGlobalAccount GA ON
			Fee.GLGlobalAccountId = GA.GLGlobalAccountId AND
			Budget.SnapshotId = GA.SnapshotId

		LEFT OUTER JOIN #PropertyFund PF ON
			Fee.PropertyFundId = PF.PropertyFundId AND
			Budget.SnapshotId = PF.SnapshotId  
		
		LEFT OUTER JOIN #GlobalRegion AllocationSubRegion ON
			PF.AllocationSubRegionGlobalRegionId = AllocationSubRegion.GlobalRegionId AND
			Budget.SnapshotId = AllocationSubRegion.SnapshotId
		
		LEFT OUTER JOIN #ReportingCategorization RC ON
			PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId AND
			PF.EntityTypeId = RC.EntityTypeId AND
			Budget.SnapshotId = RC.SnapshotId 
	WHERE
		Fee.IsDeleted = 0 AND
		FeeDetail.Amount <> 0

	PRINT (''Rows inserted into #ProfitabilitySource: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	--select distinct COUNT(*) from #ProfitabilitySource
	RAISERROR( ''Completed inserting budget portions into #ProfitabilitySource'',0,1) WITH NOWAIT

	------------------------------------------------------------------------------------------------------------------
	RAISERROR( ''Starting to update #ProfitabilitySource GLGlobalAccountId'',0,1) WITH NOWAIT

	SET @StartTime = GETDATE()

	UPDATE
		PS
	SET
		PS.GLGlobalAccountId = GLGA2.GLGlobalAccountId
	FROM
		#ProfitabilitySource PS

		INNER JOIN #GLGlobalAccount GLGA1 ON
			PS.GLGlobalAccountId = GLGA1.GLGlobalAccountId

		INNER JOIN #GLGlobalAccount GLGA2 ON
			(LEFT(GLGA1.Code, 10 - LEN(PS.ActivityTypeId)) + LTRIM(RTRIM(STR(PS.ActivityTypeId)))) = GLGA2.Code
	WHERE
		LEN(GLGA1.Code) = 10 AND -- A code of 10 characters excludes the account prefix (CP, TS) and includes the activity type code, i.e.: 5020100012
		RIGHT(GLGA1.Code, 2) = ''00'' -- where the header account has been budgeted against

	PRINT (''Rows updated in #ProfitabilitySource (GLAccount update from head to activity-specific GL Account: '' + LTRIM(RTRIM(STR(@@rowcount))))

END

/* ==============================================================================================================================================
	9. Create a temporary ''staging'' table that matches the schema of the GrReporting.dbo.ProfitabilityBudget fact
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #ProfitabilityBudget(
		ImportBatchId INT NOT NULL,
		ReforecastKey INT NOT NULL,
		SnapshotId INT NOT NULL,
		CalendarKey int NOT NULL,
		SourceKey int NOT NULL,
		FunctionalDepartmentKey int NOT NULL,
		ReimbursableKey int NOT NULL,
		ActivityTypeKey int NOT NULL,
		PropertyFundKey int NOT NULL,	
		AllocationRegionKey int NOT NULL,
		ConsolidationRegionKey INT NOT NULL,
		OriginatingRegionKey int NOT NULL,
		OverheadKey int NOT NULL,
		FeeAdjustmentKey int NOT NULL,
		LocalCurrencyKey int NOT NULL,
		LocalBudget money NOT NULL,
		ReferenceCode Varchar(300) NOT NULL,
		BudgetId int NOT NULL,
		IsExpense BIT NOT NULL,
		IsDirectCost BIT NULL,
		GlGlobalAccountId INT NOT NULL,
		DefaultGLCategorizationId INT NULL, -- [!!]
		
		GlobalGLCategorizationHierarchyKey			INT NULL,
		USPropertyGLCategorizationHierarchyKey		INT NULL,
		USFundGLCategorizationHierarchyKey			INT NULL,
		EUPropertyGLCategorizationHierarchyKey		INT NULL,
		EUFundGLCategorizationHierarchyKey			INT NULL,
		USDevelopmentGLCategorizationHierarchyKey	INT NULL,
		EUDevelopmentGLCategorizationHierarchyKey	INT NULL,
		ReportingGLCategorizationHierarchyKey		INT NULL,
		
		SourceSystemKey INT NOT NULL
	)

END

/* ====================================================================================================================================
	Join the temporary source table to the dimension tables in GrReporting and attempt to resolve keys, defaulting to UNKNOWN if NULL.
	The result of these joins will be inserted into the ''staging'' temporary table
   ==================================================================================================================================== */
BEGIN

	RAISERROR( ''Starting to insert into #ProfitabilityBudget'', 0, 1) WITH NOWAIT

	SET @StartTime = GETDATE()

	INSERT INTO #ProfitabilityBudget 
	(
		ImportBatchId,
		ReforecastKey,
		SnapshotId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		FeeAdjustmentKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		IsExpense,
		IsDirectCost,
		GlGlobalAccountId,
		DefaultGLCategorizationId,
		SourceSystemKey
	)
	SELECT
		PS.ImportBatchId,
		PS.ReforecastKey,
		PS.SnapshotId,
		DATEDIFF(DD, ''1900-01-01'', LEFT(PS.ExpensePeriod, 4)+''-'' + RIGHT(PS.ExpensePeriod, 2) + ''-01''), -- CalendarKey,
		ISNULL(S.SourceKey, @UnknownSourceKey), -- SourceKey
		COALESCE(FDJobCode.FunctionalDepartmentKey, FD.FunctionalDepartmentKey, @UnknownFunctionalDepartmentKey), -- FunctionalDepartmentKey
		PS.ReimbursableKey,
		ISNULL(AT.ActivityTypeKey, @UnknownActivityTypeKey),-- ActivityTypeKey
		ISNULL(PF.PropertyFundKey, @UnknownPropertyFundKey), -- PropertyFundKey
		ISNULL(AR.AllocationRegionKey, @UnknownAllocationRegionKey), -- AllocationRegionKey
		ISNULL(CR.AllocationRegionKey, @UnknownAllocationRegionKey), -- ConsolidationRegionKey
		CASE
			WHEN PS.IsExpense = 1
			THEN
				ISNULL(ORR.OriginatingRegionKey, @UnknownOriginatingRegionKey)
			ELSE
				ISNULL(ORRFee.OriginatingRegionKey, @UnknownOriginatingRegionKey)
		END, -- OriginatingRegionKey
		PS.OverheadKey,
		PS.FeeAdjustmentKey,
		ISNULL(C.CurrencyKey, @UnknownLocalCurrencyKey), -- LocalCurrencyKey
		PS.BudgetAmount, -- LocalBudget,
		PS.ReferenceCode, -- ReferenceCode,
		PS.BudgetId, -- BudgetId,
		PS.IsExpense,
		ps.IsDirectCost,
		PS.GLGlobalAccountId,
		PS.DefaultGLCategorizationId,
		SourceSystem.SourceSystemKey
	FROM
		#ProfitabilitySource PS

		LEFT OUTER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
			PS.SourceTableName = SourceSystem.SourceTableName AND
			SourceSystem.SourceSystemName = ''GBS''

		LEFT OUTER JOIN GrReporting.dbo.[Source] S ON -- dbo.Source is not snapshotted; this is why there''s no join on a SnapshotId field
			PS.SourceCode = S.SourceCode	

		LEFT OUTER JOIN GrReporting.dbo.ActivityType AT ON
			PS.ActivityTypeId = AT.ActivityTypeId AND
			PS.SnapshotId = AT.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.PropertyFund PF ON
			PS.PropertyFundId = PF.PropertyFundId AND
			PS.SnapshotId = PF.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion AR ON
			PS.AllocationSubRegionGlobalRegionId = AR.GlobalRegionId AND 
			PS.SnapshotId = AR.SnapshotId
			
		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion CR ON -- Consolidation Regions are the same as allocation regions, therefore join to the same table (CC16)
			PS.ConsolidationSubRegionGlobalRegionId = CR.GlobalRegionId AND
			PS.SnapshotId = CR.SnapshotId

		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORRFee ON -- For fee income, allocation region = originating region
			PS.AllocationSubRegionGlobalRegionId = ORRFee.GlobalRegionId AND
			PS.SnapshotId = ORRFee.SnapshotId
		
		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion ORR ON
			PS.OriginatingGlobalRegionId = ORR.GlobalRegionId AND
			PS.SnapshotId = ORR.SnapshotId
		
		LEFT OUTER JOIN GrReporting.dbo.Currency C ON -- dbo.Currency is not snapshotted; this is why there''s no join on a SnapshotId field
			PS.LocalCurrencyCode = C.CurrencyCode
		
		LEFT OUTER JOIN Gdm.[Snapshot] SShot ON
			PS.SnapshotId = SShot.SnapshotId
		
		-- Detail/Sub Level (Job Code) -- job code is stored as SubFunctionalDepartment in GrReporting.dbo.FunctionalDepartment
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment FDJobCode ON
			PS.JobCode = FDJobCode.SubFunctionalDepartmentCode AND
			PS.FunctionalDepartmentCode = FDJobCode.FunctionalDepartmentCode AND
			FDJobCode.FunctionalDepartmentCode <> FDJobCode.SubFunctionalDepartmentCode AND
			Sshot.LastSyncDate BETWEEN FDJobCode.StartDate AND FDJobCode.EndDate
			
			-- Parent Level
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment FD ON
			PS.FunctionalDepartmentCode = FD.FunctionalDepartmentCode AND
			FD.FunctionalDepartmentCode = FD.SubFunctionalDepartmentCode AND
			Sshot.LastSyncDate BETWEEN FD.StartDate AND FD.EndDate
	WHERE
		PS.BudgetAmount <> 0

	PRINT (''Rows inserted into #ProfitabilityBudget: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

	SET @StartTime = GETDATE()

	CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityBudget ON #ProfitabilityBudget (ReferenceCode)

	PRINT (''Created Unique INDEX  IX_ProfitabilityBudget on #ProfitabilityBudget'')
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	10. Update the GL Categorization Hierarchy fields in the ''staging'' temporary table
   =========================================================================================================================================== */
BEGIN

-- Global Categorization Mapping

	UPDATE
		#ProfitabilityBudget
	SET
		GlobalGLCategorizationHierarchyKey = 
			COALESCE(GLACM.GlobalGLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
	FROM
		#ProfitabilityBudget PB
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			PB.GLGlobalAccountId  = GLACM.GLGlobalAccountId AND
			PB.SnapshotId = GLACM.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN PB.IsExpense = 0 -- If the transaction is a ''Fee'' ...
								THEN
									0                 -- ... Then map to the indirect allocation [3.4.3.2: 1]
								ELSE                  -- Else it must be a Non-Payroll Expense ...
									PB.IsDirectCost   -- ... so use the allocation that the transaction has been assigned in NonPayrollExpenseBreakdown
													  -- [3.4.3.2: 4]
							 END

		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
			UnknownGCH.GLCategorizationHierarchyCode = ''-1:-1:-1:-1:-1:'' + CONVERT(VARCHAR(10), PB.GLGlobalAccountId) AND
			PB.SnapshotId = UnknownGCH.SnapshotId 

	RAISERROR( ''Updating #ProfitabilityBudget Global categorization mapping'',0,1) WITH NOWAIT

-- Local Categorization Mapping

	UPDATE
		#ProfitabilityBudget
	SET
		USPropertyGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),
			
		USFundGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
						
		EUPropertyGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
			
		EUFundGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
			
		USDevelopmentGLCategorizationHierarchyKey = 
			COALESCE(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey),
					
		EUDevelopmentGLCategorizationHierarchyKey = 
			COALESCE(GLACM.EUDevelopmentGLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey),

		ReportingGLCategorizationHierarchyKey =
			CASE 
				WHEN GC.GLCategorizationId IS NOT NULL
				THEN
					CASE
						WHEN GC.Name = ''US Property''	THEN ISNULL(GLACM.USPropertyGLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
						WHEN GC.Name = ''US Fund''		THEN ISNULL(GLACM.USFundGLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
						WHEN GC.Name = ''EU Property''	THEN ISNULL(GLACM.EUPropertyGLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
						WHEN GC.Name = ''EU Fund''		THEN ISNULL(GLACM.EUFundGLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
						WHEN GC.Name = ''US Development'' THEN ISNULL(GLACM.USDevelopmentGLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
						WHEN GC.Name = ''EU Development'' THEN ISNULL (GLACM.EUDevelopmentGLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey)
						WHEN GC.Name = ''Global'' THEN Gl.GlobalGLCategorizationHierarchyKey
						ELSE
							ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey)
					END
				ELSE
					ISNULL(UnknownGCH.GLCategorizationHierarchyKey, @UnknownGLCategorizationHierarchyKey)
			END
	FROM
		#ProfitabilityBudget Gl
		
		LEFT OUTER JOIN #GLAccountCategoryMapping GLACM ON
			Gl.GLGlobalAccountId  = GLACM.GLGlobalAccountId AND
			Gl.SnapshotId  = GLACM.SnapshotId AND
			GLACM.IsDirect = CASE
								WHEN Gl.IsExpense = 0 -- If the transaction is a ''Fee'' ... 
								THEN
									1                 -- ... Then map to the direct allocation [3.4.3.2: 2]
								ELSE                  -- Else it must be a Non-Payroll Expense ...
									Gl.IsDirectCost   -- ... so use the allocation that the transaction has been assigned in NonPayrollExpenseBreakdown
													  -- [3.4.3.2: 4]
							 END
				
		LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
			UnknownGCH.GLCategorizationHierarchyCode = ''-1:-1:-1:-1:-1:'' + CONVERT(VARCHAR(10), Gl.GLGlobalAccountId) AND
			Gl.SnapshotId = UnknownGCH.SnapshotId 

		LEFT OUTER JOIN #GLCategorization GC ON
			Gl.DefaultGLCategorizationId = GC.GLCategorizationId AND
			Gl.SnapshotId = GC.SnapshotId  
				
	RAISERROR( ''Updating #ProfitabilityBudget Local categorization mapping'',0,1) WITH NOWAIT

	PRINT (''Rows updated from #ProfitabilityBudget: '' + CONVERT(VARCHAR(10),@@rowcount))
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))

END

/* ==============================================================================================================================================
	11. Delete budgets to insert that have UNKNOWNS in their mapping
   =========================================================================================================================================== */
BEGIN

-- Delete all existing GBS records from dbo.ProfitabilityBudgetUnknowns
	DELETE
	FROM
		dbo.ProfitabilityBudgetUnknowns
	WHERE
		BudgetReforecastTypeKey = @GBSBudgetReforecastTypeKey -- Only delete GBS records, leave TAPAS records

	INSERT INTO dbo.ProfitabilityBudgetUnknowns (
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey, -- (CC 16)
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		BudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey,
		SnapshotId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		
		SourceSystemKey
	)
	SELECT
		ImportBatchId,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey, -- (CC16)
		OriginatingRegionKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		@GBSBudgetReforecastTypeKey,
		OverheadKey,
		FeeAdjustmentKey,
		SnapshotId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		SourceSystemKey
	FROM
		#ProfitabilityBudget
	WHERE
		SourceKey = @UnknownSourceKey OR
		(FunctionalDepartmentKey = @UnknownFunctionalDepartmentKey AND IsExpense = 1) OR	
		ActivityTypeKey = @UnknownActivityTypeKey OR
		PropertyFundKey = @UnknownPropertyFundKey OR
		AllocationRegionKey = @UnknownAllocationRegionKey OR 
		OriginatingRegionKey = @UnknownOriginatingRegionKey OR
		LocalCurrencyKey = @UnknownLocalCurrencyKey OR
		GlobalGLCategorizationHierarchyKey = @UnknownGLCategorizationHierarchyKey 
		
		-- LocalBudget
		-- OverheadKey: always UNKNOWN for Fees, UNKNOWN from non-payroll if Activity Type code <> CORPOH
		-- CalendarKey: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded	
		-- ReferenceCode: not required to check if UNKNOWN or NULL because CalendarKey is hard-coded
		-- BudgetId: This field is sourced directly from GBS.Budget and cannot be NULL (has a ''not null'' dbase constraint in source system)
		-- SourceSystemId
		
END

/* ==============================================================================================================================================
	12. Delete existing budgets from GrReporting.dbo.ProfitabilityBudget that we are about to reinsert
   =========================================================================================================================================== */
BEGIN

	CREATE TABLE #BudgetsToImportOriginal( -- an original copy of the budgets that are to be imported is kept here - the budgets in the table below will be deleted during insertion into the warehouse
		BudgetId INT NOT NULL
	)

	CREATE TABLE #BudgetsToImport(
		BudgetId INT NOT NULL
	)

	INSERT INTO #BudgetsToImportOriginal
	SELECT DISTINCT
		BudgetId
	FROM
		#ProfitabilityBudget

	INSERT INTO #BudgetsToImport
	SELECT DISTINCT
		BudgetId
	FROM
		#BudgetsToImportOriginal

SET @StartTime = GETDATE()

CREATE TABLE #SummaryOfChanges
(
	Change VARCHAR(20)
)

MERGE
	GrReporting.dbo.ProfitabilityBudget FACT
USING
	#ProfitabilityBudget AS SRC ON
		FACT.ReferenceCode = SRC.ReferenceCode
WHEN MATCHED AND
	(
		FACT.CalendarKey <> SRC.CalendarKey OR
		FACT.SourceKey <> SRC.SourceKey OR
		FACT.FunctionalDepartmentKey <> SRC.FunctionalDepartmentKey OR
		FACT.ReimbursableKey <> SRC.ReimbursableKey OR
		FACT.ActivityTypeKey <> SRC.ActivityTypeKey OR
		FACT.PropertyFundKey <> SRC.PropertyFundKey OR
		FACT.AllocationRegionKey <> SRC.AllocationRegionKey OR
		FACT.OriginatingRegionKey <> SRC.OriginatingRegionKey OR
		FACT.LocalCurrencyKey <> SRC.LocalCurrencyKey OR
		FACT.LocalBudget <> SRC.LocalBudget OR
		FACT.OverheadKey <> SRC.OverheadKey OR
		FACT.FeeAdjustmentKey <> SRC.FeeAdjustmentKey OR
		FACT.SnapshotId <> SRC.SnapshotId OR
		FACT.ReforecastKey <> SRC.ReforecastKey OR
		FACT.ConsolidationRegionKey <> SRC.ConsolidationRegionKey OR
		ISNULL(FACT.GlobalGLCategorizationHierarchyKey, '''') <> SRC.GlobalGLCategorizationHierarchyKey OR
		ISNULL(FACT.EUDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.EUDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(FACT.EUPropertyGLCategorizationHierarchyKey, '''') <> SRC.EUPropertyGLCategorizationHierarchyKey OR
		ISNULL(FACT.EUFundGLCategorizationHierarchyKey, '''') <> SRC.EUFundGLCategorizationHierarchyKey OR
		ISNULL(FACT.USDevelopmentGLCategorizationHierarchyKey, '''') <> SRC.USDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(FACT.USPropertyGLCategorizationHierarchyKey, '''') <> SRC.USPropertyGLCategorizationHierarchyKey OR
		ISNULL(FACT.USFundGLCategorizationHierarchyKey, '''') <> SRC.USFundGLCategorizationHierarchyKey OR
		ISNULL(FACT.ReportingGLCategorizationHierarchyKey, '''') <> SRC.ReportingGLCategorizationHierarchyKey OR 
		FACT.UpdatedDate IS NULL
	) THEN
	UPDATE
	SET
		FACT.CalendarKey = SRC.CalendarKey,
		FACT.SourceKey = SRC.SourceKey,
		FACT.FunctionalDepartmentKey = SRC.FunctionalDepartmentKey,
		FACT.ReimbursableKey = SRC.ReimbursableKey,
		FACT.ActivityTypeKey = SRC.ActivityTypeKey,
		FACT.PropertyFundKey = SRC.PropertyFundKey,
		FACT.AllocationRegionKey = SRC.AllocationRegionKey,
		FACT.OriginatingRegionKey = SRC.OriginatingRegionKey,
		FACT.LocalCurrencyKey = SRC.LocalCurrencyKey,
		FACT.LocalBudget = SRC.LocalBudget,
		FACT.OverheadKey = SRC.OverheadKey,
		FACT.FeeAdjustmentKey = SRC.FeeAdjustmentKey,
		FACT.SnapshotId = SRC.SnapshotId,
		FACT.ReforecastKey = SRC.ReforecastKey,
		FACT.ConsolidationRegionKey = SRC.ConsolidationRegionKey,
		FACT.GlobalGLCategorizationHierarchyKey = SRC.GlobalGLCategorizationHierarchyKey,
		FACT.EUDevelopmentGLCategorizationHierarchyKey = SRC.EUDevelopmentGLCategorizationHierarchyKey,
		FACT.EUPropertyGLCategorizationHierarchyKey = SRC.EUPropertyGLCategorizationHierarchyKey,
		FACT.EUFundGLCategorizationHierarchyKey = SRC.EUFundGLCategorizationHierarchyKey,
		FACT.USDevelopmentGLCategorizationHierarchyKey = SRC.USDevelopmentGLCategorizationHierarchyKey,
		FACT.USPropertyGLCategorizationHierarchyKey = SRC.USPropertyGLCategorizationHierarchyKey,
		FACT.USFundGLCategorizationHierarchyKey = SRC.USFundGLCategorizationHierarchyKey,
		FACT.ReportingGLCategorizationHierarchyKey = SRC.ReportingGLCategorizationHierarchyKey,
		FACT.UpdatedDate = @StartTime,
		FACT.SourceSystemKey = SRC.SourceSystemKey
WHEN NOT MATCHED BY TARGET THEN
	INSERT
	(
		SnapshotId,
		BudgetReforecastTypeKey,
		ReforecastKey,
		CalendarKey,
		SourceKey,
		FunctionalDepartmentKey,
		ReimbursableKey,
		ActivityTypeKey,
		PropertyFundKey,
		AllocationRegionKey,
		ConsolidationRegionKey,
		OriginatingRegionKey,
		OverheadKey,
		FeeAdjustmentKey,
		LocalCurrencyKey,
		LocalBudget,
		ReferenceCode,
		BudgetId,
		
		GlobalGLCategorizationHierarchyKey,
		USPropertyGLCategorizationHierarchyKey,
		USFundGLCategorizationHierarchyKey,
		EUPropertyGLCategorizationHierarchyKey,
		EUFundGLCategorizationHierarchyKey,
		USDevelopmentGLCategorizationHierarchyKey,
		EUDevelopmentGLCategorizationHierarchyKey,
		ReportingGLCategorizationHierarchyKey,
		InsertedDate,
		UpdatedDate,
		
		SourceSystemKey
	)
	VALUES
	(
		SRC.SnapshotId,
		@GBSBudgetReforecastTypeKey,
		SRC.ReforecastKey,
		SRC.CalendarKey,
		SRC.SourceKey,
		SRC.FunctionalDepartmentKey,
		SRC.ReimbursableKey,
		SRC.ActivityTypeKey,
		SRC.PropertyFundKey,
		SRC.AllocationRegionKey,
		SRC.ConsolidationRegionKey,
		SRC.OriginatingRegionKey,
		SRC.OverheadKey,
		SRC.FeeAdjustmentKey,
		SRC.LocalCurrencyKey,
		SRC.LocalBudget,
		SRC.ReferenceCode,
		SRC.BudgetId,
		
		SRC.GlobalGLCategorizationHierarchyKey,
		SRC.USPropertyGLCategorizationHierarchyKey,
		SRC.USFundGLCategorizationHierarchyKey,
		SRC.EUPropertyGLCategorizationHierarchyKey,
		SRC.EUFundGLCategorizationHierarchyKey,
		SRC.USDevelopmentGLCategorizationHierarchyKey,
		SRC.EUDevelopmentGLCategorizationHierarchyKey,
		SRC.ReportingGLCategorizationHierarchyKey,
		@StartTime,
		@StartTime,
		
		SRC.SourceSystemKey
	)
WHEN NOT MATCHED BY SOURCE AND
	FACT.BudgetId IN (SELECT BudgetId FROM #BudgetsToImport) AND
	FACT.BudgetReforecastTypeKey = @GBSBudgetReforecastTypeKey THEN
	DELETE
OUTPUT
		$action
	INTO
		#SummaryOfChanges;

CREATE NONCLUSTERED INDEX UX_SummaryOfChanges_Change ON #SummaryOfChanges(Change)

DECLARE @InsertedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''INSERT'')
DECLARE @UpdatedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''UPDATE'')
DECLARE @DeletedRows INT = (SELECT COUNT(*) FROM #SummaryOfChanges WHERE Change = ''DELETE'')

PRINT ''Rows added to ProfitabilityBudget: ''+ CONVERT(char(10), @InsertedRows)
PRINT ''Rows updated in ProfitabilityBudget: ''+ CONVERT(char(10),@UpdatedRows)
PRINT ''Rows deleted from ProfitabilityBudget: ''+ CONVERT(char(10),@DeletedRows)
PRINT (CONVERT(VARCHAR(27), DATEDIFF(millisecond, @StartTime, GETDATE()), 121) + '' ms'' + CHAR(13))


	
END

/* ==============================================================================================================================================
	14. Mark budgets as being successfully processed into the warehouse
   =========================================================================================================================================== */
BEGIN

	UPDATE
		BTP
	SET
		OriginalBudgetProcessedIntoWarehouse = 1,
		DateBudgetProcessedIntoWarehouse = GETDATE()
	FROM
		dbo.BudgetsToProcess BTP
		INNER JOIN #BudgetsToProcess BTPTemp ON
			BTP.BudgetsToProcessId = BTPTemp.BudgetsToProcessId		
	
	PRINT (''Rows updated from dbo.BudgetsToProcess: '' + CONVERT(VARCHAR(10), @@rowcount))

END

/* ==============================================================================================================================================
	15. Clean up: drop temporary tables
   =========================================================================================================================================== */
BEGIN

	IF 	OBJECT_ID(''tempdb..#Budget'') IS NOT NULL
		DROP TABLE #Budget

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknownBudgets'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets

	IF 	OBJECT_ID(''tempdb..#GLGlobalAccount'') IS NOT NULL
		DROP TABLE #GLGlobalAccount

	IF 	OBJECT_ID(''tempdb..#GLMinorCategory'') IS NOT NULL
		DROP TABLE #GLMinorCategory
	    
	IF 	OBJECT_ID(''tempdb..#GLMajorCategory'') IS NOT NULL
		DROP TABLE #GLMajorCategory

	IF 	OBJECT_ID(''tempdb..#GLFinancialCategory'') IS NOT NULL
		DROP TABLE #GLFinancialCategory

	IF 	OBJECT_ID(''tempdb..#ReportingEntityCorporateDepartment'') IS NOT NULL
		DROP TABLE #ReportingEntityCorporateDepartment

	IF 	OBJECT_ID(''tempdb..#PropertyFund'') IS NOT NULL
		DROP TABLE #PropertyFund

	IF 	OBJECT_ID(''tempdb..#ActivityType'') IS NOT NULL
		DROP TABLE #ActivityType

	IF 	OBJECT_ID(''tempdb..#CorporateDepartment'') IS NOT NULL
		DROP TABLE #CorporateDepartment

	IF 	OBJECT_ID(''tempdb..#FunctionalDepartment'') IS NOT NULL
		DROP TABLE #FunctionalDepartment

	IF 	OBJECT_ID(''tempdb..#AllocationSubRegion'') IS NOT NULL
		DROP TABLE #AllocationSubRegion

	IF 	OBJECT_ID(''tempdb..#GLAccountCategoryMapping'') IS NOT NULL
		DROP TABLE #GLAccountCategoryMapping

	IF 	OBJECT_ID(''tempdb..#ProfitabilitySource'') IS NOT NULL
		DROP TABLE #ProfitabilitySource

	IF 	OBJECT_ID(''tempdb..#ProfitabilityBudget'') IS NOT NULL
		DROP TABLE #ProfitabilityBudget

	IF 	OBJECT_ID(''tempdb..#BudgetsToImport'') IS NOT NULL
		DROP TABLE #BudgetsToImport

	IF 	OBJECT_ID(''tempdb..#BudgetsToImportOriginal'') IS NOT NULL
		DROP TABLE #BudgetsToImportOriginal

	IF 	OBJECT_ID(''tempdb..#BudgetsToDelete'') IS NOT NULL
		DROP TABLE #BudgetsToDelete

	IF 	OBJECT_ID(''tempdb..#CorporatePropertySourceCodes'') IS NOT NULL
		DROP TABLE #CorporatePropertySourceCodes

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknowns'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknowns

	IF 	OBJECT_ID(''tempdb..#PreviousBudgetsLastLockedDate'') IS NOT NULL
		DROP TABLE #PreviousBudgetsLastLockedDate

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID(''tempdb..#BudgetsWithUnknownBudgets'') IS NOT NULL
		DROP TABLE #BudgetsWithUnknownBudgets
	    
	IF 	OBJECT_ID(''tempdb..#ConsolidatonRegionCorporateDepartment'') IS NOT NULL
		DROP TABLE #ConsolidatonRegionCorporateDepartment

	IF 	OBJECT_ID(''tempdb..#CategorizationType'') IS NOT NULL
		DROP TABLE #CategorizationType
	    
	IF 	OBJECT_ID(''tempdb..#Categorization'') IS NOT NULL
		DROP TABLE #Categorization
	    
	IF 	OBJECT_ID(''tempdb..#FinancialCategory'') IS NOT NULL
		DROP TABLE #FinancialCategory
	    
	IF 	OBJECT_ID(''tempdb..#GLGlobalAccountCategorization'') IS NOT NULL
		DROP TABLE #GLGlobalAccountCategorization
	    
	IF 	OBJECT_ID(''tempdb..#ReportingCategorization'') IS NOT NULL
		DROP TABLE #ReportingCategorization

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcessToUpdate'') IS NOT NULL
		DROP TABLE #BudgetsToProcessToUpdate

END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadExchangeRates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
	@ImportStartDate DATETIME = NULL,
	@ImportEndDate DATETIME = NULL,
	@DataPriorToDate DATETIME = NULL
AS

IF (@ImportStartDate IS NULL)
	BEGIN
		SET @ImportStartDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualImportStartDate''))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
		SET @ImportEndDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualImportEndDate''))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
		SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM dbo.SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate''))
	END
	
SET NOCOUNT OFF
PRINT ''####''
PRINT ''stp_IU_LoadExchangeRates''
PRINT ''####''

/* ===============================================================================================================================================
	Generate temp table to prevent repeated function calls

		GrReportingStaging.dbo.BudgetsToProcess shows the budgets that are to be processed into the warehouse.
		Each budget is associated with an exchange rate - when a budget cycle is created, an exchange rate must be selected for that cycle.

   ============================================================================================================================================= */
BEGIN

	SELECT DISTINCT
		BudgetsToProcessCurrent.SnapshotId,
		BudgetsToProcessCurrent.BudgetExchangeRateId,
		BudgetsToProcessCurrent.BudgetReportGroupPeriodId,
		BudgetsToProcessCurrent.BudgetYear,
		BudgetsToProcessCurrent.BudgetQuarter
	INTO
		#BudgetsToProcess
	FROM
	(
		SELECT
			*
		FROM
			dbo.BudgetsToProcess
		WHERE
			IsCurrentBatch = 1
	) BudgetsToProcessCurrent

END

/* ===============================================================================================================================================
	Get all budget report groups which have been modified
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #ExchangeRates 
	(
		SnapshotId INT NOT NULL,
		CurrencyCode CHAR(3),
		Period INT,
		Rate DECIMAL(18, 12),
		BudgetReportGroupPeriodId INT,
		BudgetExchangeRateId INT,
		BudgetExchangeRateDetailId INT,
		ReforecastKey INT NOT NULL
	) 

	INSERT INTO #ExchangeRates
	SELECT
		BTP.SnapshotId,
		BudgetExchangeRateDetail.CurrencyCode,
		BudgetExchangeRateDetail.Period,
		BudgetExchangeRateDetail.Rate,
		BTP.BudgetReportGroupPeriodId,
		BudgetExchangeRateDetail.BudgetExchangeRateId,
		BudgetExchangeRateDetail.BudgetExchangeRateDetailId,
		Reforecast.ReforecastKey
	FROM
		#BudgetsToProcess BTP

		INNER JOIN
		(
			SELECT
				MIN(ReforecastKey) AS ReforecastKey,
				ReforecastEffectiveYear,
				ReforecastQuarterName
			FROM
				GrReporting.dbo.Reforecast
			WHERE
				ReforecastQuarterName <> ''UNKNOWN''
			GROUP BY
				ReforecastEffectiveYear,
				ReforecastQuarterName
		) Reforecast ON
			BTP.BudgetYear = Reforecast.ReforecastEffectiveYear AND
			BTP.BudgetQuarter = Reforecast.ReforecastQuarterName

		INNER JOIN
		(
			SELECT
				BRGP.BudgetReportGroupPeriodId,
				Period
			FROM
				Gdm.BudgetReportGroupPeriod BRGP
				INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) BRGPA ON
					BRGP.ImportKey = BRGPA.ImportKey
			WHERE
				BRGP.IsDeleted = 0

		) BudgetReportGroupPeriod ON
			BTP.BudgetReportGroupPeriodId = BudgetReportGroupPeriod.BudgetReportGroupPeriodId

		INNER JOIN
		(
			SELECT
				BER.*
			FROM
			Gdm.BudgetExchangeRate BER
			INNER JOIN Gdm.BudgetExchangeRateActive(@DataPriorToDate) BERA ON
				BER.ImportKey = BERA.ImportKey

		) BudgetExchangeRate ON
			BTP.BudgetExchangeRateId = BudgetExchangeRate.BudgetExchangeRateId

		INNER JOIN
		(
			SELECT
				BERD.*
			FROM
				Gdm.BudgetExchangeRateDetail BERD
				INNER JOIN Gdm.BudgetExchangeRateDetailActive(@DataPriorToDate) BERDA ON
					BERD.ImportKey = BERDA.ImportKey

		) BudgetExchangeRateDetail ON
			BudgetExchangeRate.BudgetExchangeRateId = BudgetExchangeRateDetail.BudgetExchangeRateId

END

/* ===============================================================================================================================================
	Calculate the cross rates
   ============================================================================================================================================= */
BEGIN

	CREATE TABLE #CrossCurrency
	(
		SourceCurrencyCode CHAR(3) NOT NULL,
		DestinationCurrencyCode CHAR(3) NOT NULL,
		Period INT NOT NULL,
		Rate DECIMAL(18, 12) NOT NULL,
		SourceReferenceCode VARCHAR(127) NOT NULL,
		DestinationReferenceCode VARCHAR(127) NOT NULL,
		BudgetExchangeRateId INT NULL,
		ReforecastKey INT NULL    
	)

	INSERT INTO #CrossCurrency
	SELECT DISTINCT
		CurrencySource.CurrencyCode AS SourceCurrencyCode, 
		CurrencyDestination.CurrencyCode AS DestinationCurrencyCode,
		ExchangeRatesSource.Period, 
		(ExchangeRatesDestination.Rate / ExchangeRatesSource.Rate) AS Rate,
		(
			''SnapshotId='' + LTRIM(RTRIM(STR(ExchangeRatesSource.SnapshotId))) +
			''&BudgetReportGroupPeriodId='' + LTRIM(RTRIM(STR(ExchangeRatesSource.BudgetReportGroupPeriodId))) +
			''&BudgetExchangeRateId='' + LTRIM(RTRIM(STR(ExchangeRatesSource.BudgetExchangeRateId))) +
			''&BudgetExchangeRateDetailId='' + LTRIM(RTRIM(STR(ExchangeRatesSource.BudgetExchangeRateDetailId)))
		) AS SourceReferenceCode,
		(
			''SnapshotId='' + LTRIM(RTRIM(STR(ExchangeRatesDestination.SnapshotId))) +
			''&BudgetReportGroupPeriodId='' + LTRIM(RTRIM(STR(ExchangeRatesDestination.BudgetReportGroupPeriodId))) +    
			''&BudgetExchangeRateId='' + LTRIM(RTRIM(STR(ExchangeRatesDestination.BudgetExchangeRateId))) +
			''&BudgetExchangeRateDetailId='' + LTRIM(RTRIM(STR(ExchangeRatesDestination.BudgetExchangeRateDetailId)))
		) AS DestinationReferenceCode,
		ExchangeRatesSource.BudgetExchangeRateId,
		ExchangeRatesSource.ReforecastKey
	FROM
		GrReporting.dbo.Currency CurrencySource

		CROSS JOIN GrReporting.dbo.Currency CurrencyDestination

		INNER JOIN #ExchangeRates ExchangeRatesSource ON
			ExchangeRatesSource.CurrencyCode = CurrencySource.CurrencyCode

		INNER JOIN #ExchangeRates ExchangeRatesDestination ON
			ExchangeRatesDestination.CurrencyCode = CurrencyDestination.CurrencyCode
	WHERE  
		CurrencySource.CurrencyCode <> ''UNK'' AND 
		CurrencyDestination.CurrencyCode <> ''UNK'' AND
		ExchangeRatesSource.Period = ExchangeRatesDestination.Period AND
		-- The two conditions below prevent different exchange rate sets (BudgetExchangeRateIds) from joining onto each other
		ExchangeRatesSource.BudgetExchangeRateId = ExchangeRatesDestination.BudgetExchangeRateId AND
		ExchangeRatesSource.ReforecastKey = ExchangeRatesDestination.ReforecastKey

	---------------------------------
	DECLARE @USDCurrencyKey INT = (
		SELECT
			CurrencyKey
		FROM
			GrReporting.dbo.Currency
		WHERE
			CurrencyCode = ''USD'' )
		
	IF (@USDCurrencyKey IS NULL)
	BEGIN
		SET @USDCurrencyKey = -1
	END

	---------------------------------

	CREATE TABLE #FactData 
	(
		SourceCurrencyKey INT NOT NULL,
		DestinationCurrencyKey INT NOT NULL,
		CalendarKey INT NOT NULL,
		Rate DECIMAL(18, 12) NOT NULL,
		ReferenceCode VARCHAR(255) NOT NULL,
		BudgetExchangeRateId INT NOT NULL,
		ReforecastKey INT NOT NULL
	)

	---------------------------------

	INSERT INTO #FactData
	SELECT 
		ISNULL(curs.CurrencyKey, -1) AS SourceCurrencyKey,
		ISNULL(curd.CurrencyKey, -1) AS DestinationCurrencyKey,
		c.CalendarKey,
		CASE
			WHEN
				cc.Rate IS NULL
			THEN
				0
			ELSE
				cc.Rate
		END AS Rate,
		(''SRC:'' + LTRIM(RTRIM(cc.SourceReferenceCode)) + '' DST:'' + LTRIM(RTRIM(cc.DestinationReferenceCode))) AS ReferenceCode,
		cc.BudgetExchangeRateId,
		ISNULL(cc.ReforecastKey, -1) AS ReforecastKey
	FROM 
		#CrossCurrency cc

		INNER JOIN GrReporting.dbo.Calendar c ON
			cc.Period = c.CalendarPeriod

		LEFT JOIN GrReporting.dbo.Currency curs ON
			curs.CurrencyCode = cc.SourceCurrencyCode

		LEFT JOIN GrReporting.dbo.Currency curd ON
			curd.CurrencyCode = cc.DestinationCurrencyCode

	---------------------------------

	INSERT INTO #FactData		
	SELECT 
		@USDCurrencyKey AS SourceCurrencyKey,
		ISNULL(cur.CurrencyKey, -1) AS DestinationCurrencyKey,
		c.CalendarKey,
		er.Rate,
		(
			''SnapshotId='' + LTRIM(RTRIM(STR(er.SnapshotId))) +
			''&BudgetReportGroupPeriodId='' + LTRIM(RTRIM(STR(er.BudgetReportGroupPeriodId))) +
			''&BudgetExchangeRateId='' + LTRIM(RTRIM(STR(er.BudgetExchangeRateId))) +
			''&BudgetExchangeRateDetailId='' + LTRIM(RTRIM(STR(er.BudgetExchangeRateDetailId)))
		) AS ReferenceCode,
		er.BudgetExchangeRateId,
		er.ReforecastKey
	FROM
		#ExchangeRates er

		INNER JOIN GrReporting.dbo.Calendar c ON
			er.Period = c.CalendarPeriod

		LEFT JOIN GrReporting.dbo.Currency cur ON
			cur.CurrencyCode = er.CurrencyCode

		LEFT JOIN #FactData fd ON
			fd.SourceCurrencyKey = @USDCurrencyKey AND
			fd.DestinationCurrencyKey = ISNULL(cur.CurrencyKey, -1) AND
			fd.CalendarKey = c.CalendarKey AND
			fd.BudgetExchangeRateId = er.BudgetExchangeRateId AND
			fd.ReforecastKey = er.ReforecastKey
	WHERE
		fd.Rate IS NULL

	---------------------------------

	INSERT INTO #FactData
	SELECT
		ISNULL(cur.CurrencyKey, -1) AS SourceCurrencyKey,
		@USDCurrencyKey AS DestinationCurrencyKey,
		c.CalendarKey,
		CASE
			WHEN
				er.Rate IS NULL
			THEN
				0
			ELSE
				(1 / er.Rate)
		END AS Rate,
		(
			''SnapshotId='' + LTRIM(RTRIM(STR(er.SnapshotId))) +
			''&BudgetReportGroupPeriodId='' + LTRIM(RTRIM(STR(er.BudgetReportGroupPeriodId))) +
			''&BudgetExchangeRateId='' + LTRIM(RTRIM(STR(er.BudgetExchangeRateId))) +
			''&BudgetExchangeRateDetailId='' + LTRIM(RTRIM(STR(er.BudgetExchangeRateDetailId)))
		) AS ReferenceCode,
		er.BudgetExchangeRateId,
		er.ReforecastKey
	FROM
		#ExchangeRates er

		INNER JOIN GrReporting.dbo.Calendar c ON
			er.Period = c.CalendarPeriod

		LEFT JOIN GrReporting.dbo.Currency cur ON
			cur.CurrencyCode = er.CurrencyCode

		LEFT JOIN #FactData fd ON
			fd.SourceCurrencyKey = ISNULL(cur.CurrencyKey, -1) AND
			fd.DestinationCurrencyKey = @USDCurrencyKey AND
			fd.CalendarKey = c.CalendarKey AND
			fd.BudgetExchangeRateId = er.BudgetExchangeRateId AND
			fd.ReforecastKey = er.ReforecastKey
	WHERE
		fd.Rate IS NULL

	---------------------------------

	IF ((SELECT COUNT(*) FROM #FactData WHERE SourceCurrencyKey = @USDCurrencyKey AND DestinationCurrencyKey = @USDCurrencyKey) <= 0)
	BEGIN

		INSERT INTO #FactData
		SELECT DISTINCT
			@USDCurrencyKey AS SourceCurrencyKey,
			@USDCurrencyKey AS DestinationCurrencyKey,
			c.CalendarKey,
			1 AS Rate,
			''Default'' AS ReferenceCode,
			er.BudgetExchangeRateId,
			er.ReforecastKey
		FROM
			#ExchangeRates er

			INNER JOIN GrReporting.dbo.Calendar c ON
				er.Period = c.CalendarPeriod

			LEFT JOIN #FactData fd ON 
				fd.SourceCurrencyKey = @USDCurrencyKey AND
				fd.DestinationCurrencyKey = @USDCurrencyKey AND
				fd.CalendarKey = c.CalendarKey AND
				fd.BudgetExchangeRateId = er.BudgetExchangeRateId AND
				fd.ReforecastKey = er.ReforecastKey
		WHERE
			fd.Rate IS NULL

	END

	---------------------------------

	-- Update the dbo.ExchangeRate fact
	MERGE
		GrReporting.dbo.ExchangeRate AS d
	USING
		#FactData AS s ON  
			d.SourceCurrencyKey = s.SourceCurrencyKey AND 
			d.DestinationCurrencyKey = s.DestinationCurrencyKey AND 
			d.CalendarKey = s.CalendarKey AND
			d.BudgetExchangeRateId = s.BudgetExchangeRateId AND
			d.ReforecastKey = s.ReforecastKey
	WHEN
		MATCHED
	THEN
		UPDATE
		SET 
			d.Rate = s.Rate,
			d.ReferenceCode = s.ReferenceCode
	WHEN
		NOT MATCHED
	THEN
		INSERT 
		VALUES
		  (
				s.SourceCurrencyKey,
				s.DestinationCurrencyKey,
				s.CalendarKey,
				s.Rate,
				s.ReferenceCode,
				s.ReforecastKey,
				s.BudgetExchangeRateId
		  );

END

PRINT ''Rows inserted/updated: ''+CONVERT(CHAR(10),@@rowcount)

/* ===============================================================================================================================================
	Clean Up
   ============================================================================================================================================= */
BEGIN

	IF 	OBJECT_ID(''tempdb..#BudgetsToProcess'') IS NOT NULL
		DROP TABLE #BudgetsToProcess

	IF 	OBJECT_ID(''tempdb..#FactData'') IS NOT NULL
		DROP TABLE #FactData

	IF 	OBJECT_ID(''tempdb..#ExchangeRates'') IS NOT NULL
		DROP TABLE #ExchangeRates

	IF 	OBJECT_ID(''tempdb..#CrossCurrency'') IS NOT NULL
		DROP TABLE #CrossCurrency

END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityOverheadActual]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*********************************************************************************************************************
Description
	This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive 
	table. These rows no longer exist in the source data systems.

	This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, 
	given that access to its #ProfitabilityActual temporary table is required.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegionKey mapping from the ProfitabilityActual table to
											the ProfitabilityActualArchive table			
			2011-10-04		: PKayongo	:	Updated to include the GLCategorizationHierarchy fields (CC21)
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

SELECT
	BUD.UpdatedDate,
	(''BillingUploadDetailId='' + CONVERT(VARCHAR(20), BUD.BillingUploadDetailId)) AS ReferenceCode
INTO
	#ActiveBillingUploadDetail
FROM
	GrReportingStaging.TapasGlobal.BillingUploadDetail BUD
	INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BUDA ON
		BUDA.ImportKey = BUD.ImportKey


SELECT
	GRPA.ProfitabilityActualKey,
    GRPA.CalendarKey,
    GRPA.SourceKey,
    GRPA.FunctionalDepartmentKey,
    GRPA.ReimbursableKey,
    GRPA.ActivityTypeKey,
    GRPA.PropertyFundKey,
    GRPA.OriginatingRegionKey,
    GRPA.AllocationRegionKey,
    GRPA.LocalCurrencyKey,
    GRPA.LocalActual,
    GRPA.ReferenceCode,
    GRPA.SourceSystemKey,
    
	GRPA.GlobalGLCategorizationHierarchyKey,
	GRPA.USPropertyGLCategorizationHierarchyKey,
	GRPA.USFundGLCategorizationHierarchyKey,
	GRPA.EUPropertyGLCategorizationHierarchyKey,
	GRPA.EUFundGLCategorizationHierarchyKey,
	GRPA.USDevelopmentGLCategorizationHierarchyKey,
	GRPA.EUDevelopmentGLCategorizationHierarchyKey,
    
    GRPA.LastDate,
    GRPA.[User],
    GRPA.Description,
    GRPA.AdditionalDescription,
    GRPA.OriginatingRegionCode,
    GRPA.PropertyFundCode,
    GRPA.FunctionalDepartmentCode,
    GRPA.OverheadKey,
    GRPA.ConsolidationRegionKey
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA

	INNER JOIN GrReporting.dbo.Source S ON
		S.SourceKey = GRPA.SourceKey
	
	INNER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
		GRPA.SourceSystemKey = SourceSystem.SourceSystemKey	
	
	LEFT OUTER JOIN #ActiveBillingUploadDetail ABUD ON
		GRPA.ReferenceCode = ABUD.ReferenceCode
			
	LEFT OUTER JOIN #ProfitabilityActual GRSPA ON
		GRPA.ReferenceCode = GRSPA.ReferenceCode AND
		GRPA.SourceKey = GRSPA.SourceKey

WHERE
	GRSPA.ReferenceCode IS NULL AND
	GRPA.LastDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	SourceSystem.SourceTableName = ''BillingUploadDetail'' AND
	(
		ABUD.ReferenceCode IS NULL OR
		(ABUD.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate)		
	)

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive
(
	ProfitabilityActualArchiveKey,
    CalendarKey,
    SourceKey,
    FunctionalDepartmentKey,
    ReimbursableKey,
    ActivityTypeKey,
    PropertyFundKey,
    OriginatingRegionKey,
    AllocationRegionKey,
    LocalCurrencyKey,
    LocalActual,
    ReferenceCode,
    SourceSystemKey,
    
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
    
    LastDate,
    [User],
    Description,
    AdditionalDescription,
    OriginatingRegionCode,
    PropertyFundCode,
    FunctionalDepartmentCode,
    OverheadKey,
    InsertedDate,
    ConsolidationRegionKey
)
SELECT
	NPAAR.ProfitabilityActualKey,
    NPAAR.CalendarKey,
    NPAAR.SourceKey,
    NPAAR.FunctionalDepartmentKey,
    NPAAR.ReimbursableKey,
    NPAAR.ActivityTypeKey,
    NPAAR.PropertyFundKey,
    NPAAR.OriginatingRegionKey,
    NPAAR.AllocationRegionKey,
    NPAAR.LocalCurrencyKey,
    NPAAR.LocalActual,
    NPAAR.ReferenceCode,
    NPAAR.SourceSystemKey,
    
    NPAAR.GlobalGLCategorizationHierarchyKey,
	NPAAR.USPropertyGLCategorizationHierarchyKey,
	NPAAR.USFundGLCategorizationHierarchyKey,
	NPAAR.EUPropertyGLCategorizationHierarchyKey,
	NPAAR.EUFundGLCategorizationHierarchyKey,
	NPAAR.USDevelopmentGLCategorizationHierarchyKey,
	NPAAR.EUDevelopmentGLCategorizationHierarchyKey,
	
    NPAAR.LastDate,
    NPAAR.[User],
    NPAAR.Description,
    NPAAR.AdditionalDescription,
    NPAAR.OriginatingRegionCode,
    NPAAR.PropertyFundCode,
    NPAAR.FunctionalDepartmentCode,
    NPAAR.OverheadKey,
    GETDATE() AS InsertedDate,
    NPAAR.ConsolidationRegionKey
FROM
	#NewProfitabilityActualArchiveRecords NPAAR

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE FROM	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

DROP TABLE #ActiveBillingUploadDetail
DROP TABLE #NewProfitabilityActualArchiveRecords


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_ArchiveProfitabilityMRIActual]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityMRIActual]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    Description
	This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive 
	table. These rows no longer exist in the source data systems.

	This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, 
	given that access to its #ProfitabilityActual temporary table is required.

	┌─────────────────┬─────────────────┬──────────────────────────────────────────────────────────────────────────────────┐
	│   YYYY-MM-DD    │      PERSON     │                          DETAILS OF CHANGES MADE                                 │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-06-07    │    P Kayongo    │ Added ConsolidationRegionKey mapping from the ProfitabilityActual table to the   │
	│                 │                 │ ProfitabilityActualArchive table.                                                │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-06-30    │    I Saunder    │ Updated logic used to determine which fact records are no longer valid.          │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-09-27    │    P Kayongo    │ Updated GLAccount mapping to new Categorizations (CC21).			               │
	└─────────────────┴─────────────────┴──────────────────────────────────────────────────────────────────────────────────┘


──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

-- Get all records from all MRIs

SELECT
	*
INTO
	#AllGeneralLedgers
FROM
	(
		SELECT SourcePrimaryKey, ''US'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[USProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''UC'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[USCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''EU'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[EUProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''EC'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[EUCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''BR'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[BRProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''BC'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[BRCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''IN'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[INProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''IC'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[INCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''CN'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[CNProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, ''CC'' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[CNCorp].[GeneralLedger]		
	)
	AS AllGeneralLedgers
WHERE
	LastDate BETWEEN @ImportStartDate AND @ImportEndDate

CREATE UNIQUE CLUSTERED INDEX IX_AllGeneralLedgers_Clustered ON #AllGeneralLedgers(SourcePrimaryKey, SourceCode)

-- Find orphan rows using #ProfitabilityActual, which exists in the scope of the stored proc that executed this stored proc

SELECT
	GRPA.*
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA
	
	-- Need to join on Source because reference code is not source specific (we could have identical reference codes for different sources)
	INNER JOIN GrReporting.dbo.[Source] S ON
		GRPA.SourceKey = S.SourceKey
	
	-- Need to join here because we only consider JOURNAL and GHIS sources (not BillingUploadDetail from TAPAS)
	INNER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
		GRPA.SourceSystemKey = SourceSystem.SourceSystemKey
	
	-- This join will determine all transactions in GrReporting.dbo.ProfitabilityActual that have been deleted in MRI	
	LEFT OUTER JOIN #AllGeneralLedgers AGL ON
		GRPA.ReferenceCode = AGL.SourcePrimaryKey AND
		S.SourceCode = AGL.SourceCode
	
	-- This join will determine all transactions in GrReporting.dbo.ProfitabilityActual that should no longer be there because of changes in
	-- business rules (i.e.: a new record in a ManageType table)
	LEFT OUTER JOIN #ProfitabilityActual PA ON
		GRPA.ReferenceCode = PA.ReferenceCode AND
		GRPA.SourceKey = PA.SourceKey
	
WHERE
	GRPA.LastDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	SourceSystem.SourceTableName IN (''JOURNAL'', ''GHIS'') AND
	(AGL.SourcePrimaryKey IS NULL OR PA.ReferenceCode IS NULL) -- If either a transaction as been deleted in MRI or a transaction in
															   -- dbo.ProfitabilityActual needs to be smoked because business rules have changed.

-- Update dbo.ProfitabilityActualArchive - it could be possible that we are archiving a record for the second time (although this is unlikely -
-- more to protect against duplicate inserts while running on DEV/TEST). If this is the case, update the record.

UPDATE
	PAA
SET
	PAA.CalendarKey = NPAAR.CalendarKey,
	PAA.SourceKey = NPAAR.SourceKey,
	PAA.FunctionalDepartmentKey = NPAAR.FunctionalDepartmentKey,
	PAA.ReimbursableKey = NPAAR.ReimbursableKey,
	PAA.ActivityTypeKey = NPAAR.ActivityTypeKey,
	PAA.PropertyFundKey = NPAAR.PropertyFundKey,
	PAA.OriginatingRegionKey = NPAAR.OriginatingRegionKey,
	PAA.AllocationRegionKey = NPAAR.AllocationRegionKey,
	PAA.LocalCurrencyKey = NPAAR.LocalCurrencyKey,
	PAA.LocalActual = NPAAR.LocalActual,
	PAA.ReferenceCode = NPAAR.ReferenceCode,
	PAA.SourceSystemKey = NPAAR.SourceSystemKey,
	
	PAA.GlobalGLCategorizationHierarchyKey = NPAAR.GlobalGLCategorizationHierarchyKey,
	PAA.USPropertyGLCategorizationHierarchyKey = NPAAR.USPropertyGLCategorizationHierarchyKey,
	PAA.USFundGLCategorizationHierarchyKey = NPAAR.USFundGLCategorizationHierarchyKey,
	PAA.EUPropertyGLCategorizationHierarchyKey = NPAAR.EUPropertyGLCategorizationHierarchyKey,
	PAA.EUFundGLCategorizationHierarchyKey = NPAAR.EUFundGLCategorizationHierarchyKey,
	PAA.USDevelopmentGLCategorizationHierarchyKey = NPAAR.USDevelopmentGLCategorizationHierarchyKey,
	PAA.EUDevelopmentGLCategorizationHierarchyKey = NPAAR.EUDevelopmentGLCategorizationHierarchyKey,
	PAA.ReportingGLCategorizationHierarchyKey = NPAAR.ReportingGLCategorizationHierarchyKey,
	
	PAA.LastDate = NPAAR.LastDate,
	PAA.[User] = NPAAR.[User],
	PAA.[Description] = NPAAR.[Description],
	PAA.AdditionalDescription = NPAAR.AdditionalDescription,
	PAA.OriginatingRegionCode = NPAAR.OriginatingRegionCode,
	PAA.PropertyFundCode = NPAAR.PropertyFundCode,
	PAA.FunctionalDepartmentCode = NPAAR.FunctionalDepartmentCode,
	PAA.OverheadKey = NPAAR.OverheadKey,
	PAA.InsertedDate = GETDATE(),
	PAA.ConsolidationRegionKey = NPAAR.ConsolidationRegionKey
FROM
	GrReporting.dbo.ProfitabilityActualArchive PAA
	
	INNER JOIN #NewProfitabilityActualArchiveRecords NPAAR ON
		PAA.ReferenceCode = NPAAR.ReferenceCode AND
		PAA.SourceKey = NPAAR.SourceKey

-- Insert new orphan rows into dbo.ProfitabilityActualArchive table. We do not want to insert duplicate records; hence the LEFT OUTER JOIN and NULL

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive
(
	ProfitabilityActualArchiveKey,
    CalendarKey,
    SourceKey,
    FunctionalDepartmentKey,
    ReimbursableKey,
    ActivityTypeKey,
    PropertyFundKey,
    OriginatingRegionKey,
    AllocationRegionKey,
    LocalCurrencyKey,
    LocalActual,
    ReferenceCode,
    SourceSystemKey,
    
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
    ReportingGLCategorizationHierarchyKey,
    LastDate,
    [User],
    [Description],
    AdditionalDescription,
    OriginatingRegionCode,
    PropertyFundCode,
    FunctionalDepartmentCode,
    OverheadKey,
    InsertedDate,
    ConsolidationRegionKey
)
SELECT
	NPAAR.ProfitabilityActualKey,
    NPAAR.CalendarKey,
    NPAAR.SourceKey,
    NPAAR.FunctionalDepartmentKey,
    NPAAR.ReimbursableKey,
    NPAAR.ActivityTypeKey,
    NPAAR.PropertyFundKey,
    NPAAR.OriginatingRegionKey,
    NPAAR.AllocationRegionKey,
    NPAAR.LocalCurrencyKey,
    NPAAR.LocalActual,
    NPAAR.ReferenceCode,
    NPAAR.SourceSystemKey,
    
	NPAAR.GlobalGLCategorizationHierarchyKey,
	NPAAR.USPropertyGLCategorizationHierarchyKey,
	NPAAR.USFundGLCategorizationHierarchyKey,
	NPAAR.EUPropertyGLCategorizationHierarchyKey,
	NPAAR.EUFundGLCategorizationHierarchyKey,
	NPAAR.USDevelopmentGLCategorizationHierarchyKey,
	NPAAR.EUDevelopmentGLCategorizationHierarchyKey,
    NPAAR.ReportingGLCategorizationHierarchyKey,
    NPAAR.LastDate,
    NPAAR.[User],
    NPAAR.[Description],
    NPAAR.AdditionalDescription,
    NPAAR.OriginatingRegionCode,
    NPAAR.PropertyFundCode,
    NPAAR.FunctionalDepartmentCode,
    NPAAR.OverheadKey,
    GETDATE(),
    NPAAR.ConsolidationRegionKey
FROM
	#NewProfitabilityActualArchiveRecords NPAAR
 
	LEFT JOIN GrReporting.dbo.ProfitabilityActualArchive PAA ON
		NPAAR.ReferenceCode = PAA.ReferenceCode AND
		NPAAR.SourceKey = PAA.SourceKey
WHERE
	PAA.ReferenceCode IS NULL

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE
FROM
	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

--

PRINT ''Completed removing all orphan records from GrReporting.dbo.ProfitabilityActual: ''+ LTRIM(RTRIM(CONVERT(char(20),@@rowcount)))
PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #AllGeneralLedgers
DROP TABLE #NewProfitabilityActualArchiveRecords

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


/***********************************************************************************************************************************************
Description
	This stored procedure processes overhead transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
	1.	Set the default unknown values to be used in the fact tables
	2.	Get data exclusion lists (Manage Type tables) from GDM
	3.	Map Global GL Accounts to Activity Types
	4.	Obtain source transaction data from Tapas Global
	5.	Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
	6.	Obtain GL Account mapping data from GDM
	7.	Map the source transaction data to mapping data from GDM, HR and GACS
	8.	Remove records from the #ProfitabilityOverhead table mapped to records in the exclusion tables
	9.	Take the different sources and combine them into the #ProfitabilityActual table
	10. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
	11. Clean Up
	
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
			2011-10-04		: PKayongo	:	Updated the stored procedure with the new GL Account Categorization 
											mapping (CC16)
************************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
      @ImportStartDate	DATETIME = NULL,
      @ImportEndDate	DATETIME = NULL,
      @DataPriorToDate	DATETIME = NULL
AS

SET NOCOUNT ON

PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyOverhead''
PRINT ''####''

IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportOverheadActuals'') <> 1)
BEGIN
	PRINT (''Import of Overhead Actuals is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...'')
	RETURN
END

IF (@ImportStartDate IS NULL)
BEGIN
	SET @ImportStartDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualImportStartDate''))
END

IF (@ImportEndDate IS NULL)
BEGIN
	SET @ImportEndDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualImportEndDate''))
END

IF (@DataPriorToDate IS NULL)
BEGIN
	SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate''))
END

/* ==============================================================================================================================================
	1. Set the default unknown values to be used in the fact tables - these are used when a join can''t be made to a dimension
   =========================================================================================================================================== */
BEGIN

DECLARE @FunctionalDepartmentKeyUnknown		 INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN'')
DECLARE @ReimbursableKeyUnknown				 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN'')
DECLARE @ActivityTypeKeyUnknown				 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN'')
DECLARE @SourceKeyUnknown					 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = ''UNKNOWN'')
DECLARE @OriginatingRegionKeyUnknown		 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN'')
DECLARE @AllocationRegionKeyUnknown			 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN'')
DECLARE @PropertyFundKeyUnknown				 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN'')
DECLARE @OverheadKeyUnknown					 INT = (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = ''UNKNOWN'')
DECLARE @GlCategorizationHierarchyKeyUnknown INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''UNKNOWN'' AND SnapshotId = 0)
DECLARE	@LocalCurrencyKeyUnknown			 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNK'')

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Property'' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Fund'' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Property'' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Fund'' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Development'' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''Global'' AND SnapshotId = 0)



END

/* ==============================================================================================================================================
	2. Get data exclusion lists (Manage Type tables) from GDM
   =========================================================================================================================================== */
BEGIN

	/* Temp table creation and data inserts - Change Control 7
		The ManageType tables are used to exclude certain data from being inserted into the ProfitabilityActual fact table.
		ManageCorporateDepartment excludes Corporate Departments.
		ManageCorporateEntity excludes Corporate Entities.
		
		ManagePropertyDepartment and ManagePropertyEntity are not included in the stored procedure because they are not required.

	*/

-- #ManageType
CREATE TABLE #ManageType
(
	ManageTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL
)
INSERT INTO #ManageType
(
	ManageTypeId,
	Code 
)
SELECT
	MT.ManageTypeId,
	MT.Code
FROM
	Gdm.ManageType MT
	INNER JOIN Gdm.ManageTypeActive(@DataPriorToDate) MTA ON
		MT.ImportKey = MTA.ImportKey
WHERE
	MT.IsDeleted = 0

-- #ManageCorporateDepartment
CREATE TABLE #ManageCorporateDepartment
(
	ManageCorporateDepartmentId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #ManageCorporateDepartment
(
	ManageCorporateDepartmentId,
	ManageTypeId,
	CorporateDepartmentCode,
	SourceCode
)
SELECT
	MCD.ManageCorporateDepartmentId,
	MCD.ManageTypeId,
	MCD.CorporateDepartmentCode,
	MCD.SourceCode
FROM
	Gdm.ManageCorporateDepartment MCD
	INNER JOIN Gdm.ManageCorporateDepartmentActive(@DataPriorToDate) MCDA ON
		MCD.ImportKey = MCDA.ImportKey
	INNER JOIN #ManageType MT ON
		MCD.ManageTypeId = MT.ManageTypeId  
WHERE
	MT.Code = ''GMREXCL'' AND
	MCD.IsDeleted = 0

-- #ManageCorporateEntity
CREATE TABLE #ManageCorporateEntity
(
	ManageCorporateEntityId INT NOT NULL,
	ManageTypeId INT NOT NULL,
	CorporateEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #ManageCorporateEntity
(
	ManageCorporateEntityId,
	ManageTypeId,
	CorporateEntityCode,
	SourceCode
)
SELECT
	MCE.ManageCorporateEntityId,
	MCE.ManageTypeId,
	MCE.CorporateEntityCode,
	MCE.SourceCode
FROM
	Gdm.ManageCorporateEntity MCE
	
	INNER JOIN Gdm.ManageCorporateEntityActive(@DataPriorToDate) MCEA ON
		MCE.ImportKey = MCEA.ImportKey
		
	INNER JOIN #ManageType MT ON
		MCE.ManageTypeId = MT.ManageTypeId  
WHERE
	MT.Code = ''GMREXCL'' AND
	MCE.IsDeleted = 0

-- change control 7 end
END

/* ==============================================================================================================================================
	3. Map Global GL Accounts to Activity Types
   =========================================================================================================================================== */
BEGIN

	/*
		TAPAS does not use MRI GL Accounts.
		The purpose of the #ActivityTypeGLAccount table below is to map the TAPAS Global transactions to GDM Global Accounts based on the
		Activity Type of the record.
	*/

CREATE TABLE #ActivityTypeGLAccount
(
	ActivityTypeId INT NULL,
	GLAccountCode VARCHAR(12) NOT NULL
)

INSERT INTO #ActivityTypeGLAccount 
(
	ActivityTypeId, 
	GLAccountCode
)
VALUES
	(NULL, ''5002950000''),  -- Header
	(1, ''5002950001''),     -- Leasing
	(2, ''5002950002''),     -- Acquisitions
	(3, ''5002950003''),     -- Asset Management
	(4, ''5002950004''),     -- Development
	(5, ''5002950005''),     -- Property Management Escalatable
	(6, ''5002950006''),     -- Property Management Non-Escalatable
	(7, ''5002950007''),     -- Syndication (Investment and Fund)
	(8, ''5002950008''),     -- Fund Organization
	(9, ''5002950009''),     -- Fund Operations
	(10, ''5002950010''),    -- Property Management TI
	(11, ''5002950011''),    -- Property Management CapEx
	(12, ''5002950012''),    -- Corporate
	(99, ''5002950099'')     -- Corporate Overhead (No corporate overhead (5002950099) account  use header instead)
	
PRINT ''Rows Inserted into #ActivityTypeGLAccount:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
END
	
/* ==============================================================================================================================================
	4. Obtain source transaction data from Tapas Global
   =========================================================================================================================================== */
BEGIN

	/*
		The Billing Upload table has an OverheadId field. If this field is not null, it indicates that the transactions within the upload are
		Overhead transactions (and not Payroll transactions). The purpose of the table is to filter the BillingUpload table to make sure only
		Overhead transactions are processed.
	*/

CREATE TABLE #Overhead
(
	OverheadId INT NOT NULL
)
INSERT INTO #Overhead 
(
	OverheadId
)
SELECT 
	 Oh.OverheadId
FROM
	TapasGlobal.Overhead Oh 
	
	INNER JOIN TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
		Oh.ImportKey = OhA.ImportKey

PRINT ''Rows Inserted into #Overhead:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_Overhead_OverheadId ON #Overhead(OverheadId)

	/*
		The BillingUpload table stores information of files that contain Overhead information that have been uploaded to Tapas Global
	*/

CREATE TABLE #BillingUpload
(
	BillingUploadId INT NOT NULL,
	BillingUploadBatchId INT NULL,
	OverheadId INT NULL,
	OverheadRegionId INT NULL,
	ProjectId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	ActivityTypeId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NULL,
	FunctionalDepartmentId INT NULL
)
INSERT INTO #BillingUpload 
(
	BillingUploadId,
	BillingUploadBatchId,
	OverheadId,
	OverheadRegionId,
	ProjectId,
	ExpensePeriod,
	UpdatedDate,
	ActivityTypeId,
	OverheadFunctionalDepartmentId,
	FunctionalDepartmentId
)
SELECT 
	Bu.BillingUploadId,
	Bu.BillingUploadBatchId,
	Bu.OverheadId,
	Bu.OverheadRegionId,
	Bu.ProjectId,
	Bu.ExpensePeriod,
	Bu.UpdatedDate,
	Bu.ActivityTypeId,
	Bu.OverheadFunctionalDepartmentId,
	Bu.FunctionalDepartmentId
FROM
	TapasGlobal.BillingUpload	Bu

	INNER JOIN TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA ON
		Bu.ImportKey = BuA.ImportKey
	/*
		Previously this join was done when all the tables are mapped together into the #ProfitabilityOverhead table. 
		This is done here now to make sure lessen the data that is being processed while the stored procedure is running
	*/	
	INNER JOIN #Overhead Oh ON -- Makes sure that only Ovherhead transactions are stored, and doesn''t include Payroll.
		Bu.OverheadId = Oh.OverheadId 

PRINT ''Rows Inserted into #BillingUpload:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_BillingUpload_BillingUploadId ON #BillingUpload(BillingUploadId)
		
	/*
		The BillingUploadDetail table stores the transactions within the files that have been uploaded to Tapas Global
	*/

CREATE TABLE #BillingUploadDetail
(
	BillingUploadDetailId INT NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadDetailTypeId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	AllocationAmount DECIMAL(18, 9) NOT NULL,
	CurrencyCode CHAR(3) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
)
INSERT INTO #BillingUploadDetail 
(
	BillingUploadDetailId,
	BillingUploadId,
	BillingUploadDetailTypeId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	AllocationAmount,
	CurrencyCode,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Bud.BillingUploadDetailId,
	Bud.BillingUploadId,
	Bud.BillingUploadDetailTypeId,
	Bud.CorporateDepartmentCode,
	Bud.CorporateSourceCode,
	Bud.AllocationAmount,
	Bud.CurrencyCode,
	Bud.InsertedDate,
	Bud.UpdatedDate
FROM
	TapasGlobal.BillingUploadDetail Bud

	INNER JOIN TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA ON
		Bud.ImportKey = BudA.ImportKey
		
PRINT ''Rows Inserted into #BillingUploadDetail:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*
		The #Project table is used to determine the Corporate Department transactions are mapped to
	*/

CREATE TABLE #Project
(
	ProjectId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)
INSERT INTO #Project 
(
	ProjectId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	P.ProjectId,
	P.CorporateDepartmentCode,
	P.CorporateSourceCode,
	P.CanAllocateOverheads,
	P.AllocateOverheadsProjectId
FROM
	TapasGlobal.Project P

	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) PA ON
		P.ImportKey = PA.ImportKey

PRINT ''Rows Inserted into #Project:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_Project_ProjectId ON #Project (ProjectId)

	/*
		The #OverheadRegion region table is used to determine the Originating Region of the overhead transactions
	*/

CREATE TABLE #OverheadRegion
(
	OverheadRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL
)
INSERT INTO #OverheadRegion
(
	OverheadRegionId,
	CorporateEntityRef,
	CorporateSourceCode
)
SELECT
	Ovr.OverheadRegionId,
	Ovr.CorporateEntityRef,
	Ovr.CorporateSourceCode
FROM
	TapasGlobal.OverheadRegion Ovr 

	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
			Ovr.ImportKey = OvrA.ImportKey
PRINT ''Rows Inserted into #OverheadRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
END

/* ==============================================================================================================================================
	5. Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The Functional Department table is used to map the transactions to their relevant Functional Departments.	
	*/ 
 
CREATE TABLE #FunctionalDepartment
(
	FunctionalDepartmentId INT NOT NULL,
	GlobalCode CHAR(3) NULL
)
INSERT INTO #FunctionalDepartment 
(
	FunctionalDepartmentId,
	GlobalCode
)
SELECT
	Fd.FunctionalDepartmentId,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd

	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		Fd.ImportKey = FdA.ImportKey

PRINT ''Rows Inserted into #FunctionalDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The PropertyFundMapping table is used to determine the PropertyFund of Overhead transactions.
		Note: This only maps the PropertyFund for transactions before period 201007	
	*/


CREATE TABLE #PropertyFundMapping
(
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)
INSERT INTO #PropertyFundMapping
(
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm

	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		Pfm.ImportKey = PfmA.ImportKey
WHERE
	IsDeleted = 0

PRINT ''Rows Inserted into #PropertyFundMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_PropertyFundMapping_PropertyFundCode ON #PropertyFundMapping (PropertyFundCode, SourceCode, ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #AllocationSubRegion table is used to filter GlobalRegion to make sure the Allocation Sub Region specified by the #PropertyFund
		table is flagged as an Allocation Region in the GlobalRegion table in GDM.	
	*/

CREATE TABLE #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	AllocationRegionGlobalRegionId INT NULL
)
INSERT INTO #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId,
	AllocationRegionGlobalRegionId
)
SELECT
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.AllocationRegionGlobalRegionId
FROM
	Gdm.AllocationSubRegion ASR

	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON
		ASR.ImportKey = ASRA.ImportKey
WHERE
	ASR.IsActive = 1

PRINT ''Rows Inserted into #AllocationSubRegion:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_AllocationSubRegion_AllocationSubRegionGlobalRegionId ON #AllocationSubRegion(AllocationSubRegionGlobalRegionId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingEntityCorporateDepartment and #ReportingEntityPropertyEntity tables are used to determine the Property Funds of
		transactions (Property Funds are used to determine the Allocation Sub Region).
	*/

CREATE TABLE #ReportingEntityCorporateDepartment
( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL
)
INSERT INTO #ReportingEntityCorporateDepartment
(
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode
)
SELECT
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode
FROM
	Gdm.ReportingEntityCorporateDepartment RECD

	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECD.ImportKey = RECDA.ImportKey

PRINT ''Rows Inserted into #ReportingEntityCorporateDepartment:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityCorporateDepartment_CorporateDepartment ON #ReportingEntityCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ReportingEntityPropertyEntity	
	*/

CREATE TABLE #ReportingEntityPropertyEntity
( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL
)
INSERT INTO #ReportingEntityPropertyEntity
(
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode
)
SELECT
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode
FROM
	Gdm.ReportingEntityPropertyEntity REPE

	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPE.ImportKey = REPEA.ImportKey

PRINT ''Rows Inserted into #ReportingEntityPropertyEntity:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityPropertyEntity_PropertyEntity ON #ReportingEntityPropertyEntity(PropertyEntityCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyFund table is used to determine the Allocation Region of a transaction.	
	*/

CREATE TABLE #PropertyFund
( -- GDM 2.0 change
	PropertyFundId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL
)
INSERT INTO #PropertyFund
(
	PropertyFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId
)
SELECT
	PF.PropertyFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId
FROM
	Gdm.PropertyFund PF

	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PF.ImportKey = PFA.ImportKey
WHERE
	PF.IsActive = 1

PRINT ''Rows Inserted into #PropertyFund:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_PropertyFund_PropertyFundId ON #PropertyFund (PropertyFundId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ConsolidationRegionCorporateDepartment table is used to determine the Consolidation Region of a transaction.
		Note: It''s assumed that Overhead transactions are only from Corporte Departments and not Property Entities, so the 
		ConsolidationRegionPropertyEntity table from Gdm has not been included.
	*/

CREATE TABLE #ConsolidationRegionCorporateDepartment
( -- CC16
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL
)
INSERT INTO #ConsolidationRegionCorporateDepartment
(
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode
)
SELECT
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode
FROM
	Gdm.ConsolidationRegionCorporateDepartment CRCD 
	
	INNER JOIN Gdm.ConsolidationRegionCorporateDepartmentActive(@DataPriorToDate) CRCDA ON
		CRCD.ImportKey = CRCDA.ImportKey

PRINT ''Rows Inserted into #ConsolidationRegionCorporateDepartment:''+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartment ON #ConsolidationRegionCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #OriginatingRegionCorporateEntity and #OriginatingRegionPropertyDepartment tables are used to determine the Originating Regions of 
		transactions.
	*/

-- #OriginatingRegionCorporateEntity
CREATE TABLE #OriginatingRegionCorporateEntity
( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #OriginatingRegionCorporateEntity
(
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode
)
SELECT
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE

	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCE.ImportKey = ORCEA.ImportKey

PRINT ''Rows Inserted into #OriginatingRegionCorporateEntity:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionCorporateEntity_CorporateEntity ON #OriginatingRegionCorporateEntity(CorporateEntityCode, SourceCode)

-- #OriginatingRegionPropertyDepartment

CREATE TABLE #OriginatingRegionPropertyDepartment
( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #OriginatingRegionPropertyDepartment
(
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode
)
SELECT
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPD.ImportKey = ORPDA.ImportKey

PRINT ''Rows Inserted into #OriginatingRegionPropertyDepartment:''+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionPropertyDepartment_PropertyDepartment ON #OriginatingRegionPropertyDepartment(PropertyDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ActivityType table holds Activity Type information to be used for mapping to the Activity Type dimension and for determining the
		Global GL Accounts to be used (based on the #ActivityTypeGLAccount table).
	*/

CREATE TABLE #ActivityType
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL
)
INSERT INTO #ActivityType
(
	ActivityTypeId,
	ActivityTypeCode
)
SELECT
	At.ActivityTypeId,
	At.Code
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		At.ImportKey = Ata.ImportKey
WHERE
	AT.IsActive = 1

PRINT ''Rows Inserted into #ActivityType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_ActivityType_ActivityTypeId ON #ActivityType (ActivityTypeId)

END

/* ==============================================================================================================================================
	6. Obtain GL Account mapping data from GDM
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccount stores Global accounts and their associated Activity Types
	*/

CREATE TABLE #GLGlobalAccount
(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	Code VARCHAR(10) NOT NULL,
	IsActive BIT NOT NULL
)
INSERT INTO #GLGlobalAccount
(
	GLGlobalAccountId,
	ActivityTypeId,
	Code,
	IsActive
)
SELECT
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.Code,
	GLA.IsActive
FROM
	Gdm.GLGlobalAccount GLA

	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLA.ImportKey = GLAA.ImportKey
WHERE
	GLA.IsActive = 1

PRINT ''Rows Inserted into #GLGlobalAccount:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)		
CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccountCategorization table is used to map Global Accounts to Minor Categories for the relevant Categorizations	
	*/

CREATE TABLE #GLGlobalAccountCategorization
(
	GLGlobalAccountId INT NOT NULL,
	DirectGLMinorCategoryId INT NULL,
	IndirectGLMinorCategoryId INT NULL,
	CoAGLMinorCategoryId INT NULL,
	GLCategorizationId INT NOT NULL
)
INSERT INTO #GLGlobalAccountCategorization
(
	GLGlobalAccountId,
	DirectGLMinorCategoryId,
	IndirectGLMinorCategoryId,
	CoAGLMinorCategoryId,
	GLCategorizationId
)
SELECT
	GGAC.GLGlobalAccountId,
	GGAC.DirectGLMinorCategoryId,
	GGAC.IndirectGLMinorCategoryId,
	GGAC.CoAGLMinorCategoryId,
	GGAC.GLCategorizationId
FROM
	Gdm.GLGlobalAccountCategorization GGAC

	INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GGACa ON
		GGAC.ImportKey = GGACa.ImportKey
		
PRINT ''Rows Inserted into #GLGlobalAccountCategorization:''+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMinorCategory	
	*/

CREATE TABLE #GLMinorCategory
(
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL
)
INSERT INTO #GLMinorCategory
(
	GLMinorCategoryId,
	GLMajorCategoryId
)
SELECT
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId
FROM
	Gdm.GLMinorCategory MinC

	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinC.ImportKey = MinCA.ImportKey
WHERE
	MinC.IsActive = 1
	
PRINT ''Rows Inserted into #GLMinorCategory:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
CREATE UNIQUE CLUSTERED INDEX UX_GLMinorCategory_GLMinorCategoryId ON #GLMinorCategory(GLMinorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMajorCategory	
	*/

CREATE TABLE #GLMajorCategory
(
	GLMajorCategoryId INT NOT NULL,
	GLFinancialCategoryId INT NOT NULL
)
INSERT INTO #GLMajorCategory
(
	GLMajorCategoryId,
	GLFinancialCategoryId
)
SELECT
	MajC.GLMajorCategoryId,
	MajC.GLFinancialCategoryId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey
WHERE
	MajC.IsActive = 1

PRINT ''Rows Inserted into #GLMajorCategory:''+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_GLMajorCategory_GLMajorCategoryId ON #GLMajorCategory(GLMajorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLFinancialCategory	
	*/

CREATE TABLE #GLFinancialCategory
(
	GLFinancialCategoryId INT NOT NULL,
	GLCategorizationId INT NOT NULL
)
INSERT INTO #GLFinancialCategory
(
	GLFinancialCategoryId,
	GLCategorizationId
)
SELECT
	GLFinancialCategoryId,
	GLCategorizationId
FROM
	Gdm.GLFinancialCategory FinC

	INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) FinCa ON
		FinC.ImportKey = FinCa.ImportKey

PRINT ''Rows Inserted into #GLFinancialCategory:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)		
CREATE UNIQUE CLUSTERED INDEX UX_GLFinancialCategory_GLFinancialCategoryId ON #GLFinancialCategory(GLFinancialCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorization
	*/

CREATE TABLE #GLCategorization
(
	GLCategorizationId INT NOT NULL,
	GLCategorizationTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	RechargeSourceCode CHAR(2) NULL,
	IsConfiguredForRecharge BIT NULL
)
INSERT INTO #GLCategorization
(
	GLCategorizationId,
	GLCategorizationTypeId,
	[Name],
	RechargeSourceCode,
	IsConfiguredForRecharge
)
SELECT
	GC.GLCategorizationId,
	GC.GLCategorizationTypeId,
	GC.[Name],
	GC.RechargeSourceCode,
	GC.IsConfiguredForRecharge
FROM 
	Gdm.GLCategorization GC 
	INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) GCa ON
		GC.ImportKey = GCa.ImportKey
WHERE
	GC.IsActive = 1

PRINT ''Rows Inserted into #GLCategorization:''+CONVERT(char(10),@@rowcount)	
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorizationType
	*/

CREATE TABLE #GLCategorizationType
(
	GLCategorizationTypeId INT NOT NULL
)
INSERT INTO #GLCategorizationType
(
	GLCategorizationTypeId
)
SELECT
	GCT.GLCategorizationTypeId
FROM
	Gdm.GLCategorizationType GCT 
	INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTa ON
		GCT.ImportKey = GCTa.ImportKey

PRINT ''Rows Inserted into #GLCategorizationType:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyOverheadPropertyGLAccount will be used to determine the GLAccount and GLGlobalAccount for Local Categorizations
	*/

CREATE TABLE #PropertyOverheadPropertyGLAccount
(
	GLCategorizationId INT NOT NULL,
	ActivityTypeId INT NULL,
	FunctionalDepartmentId INT NULL,
	PropertyGLAccountId INT NULL,
	GLGlobalAccountId INT NULL
)
INSERT INTO #PropertyOverheadPropertyGLAccount
(
	GLCategorizationId,
	ActivityTypeId,
	FunctionalDepartmentId,
	PropertyGLAccountId,
	GLGlobalAccountId
)
SELECT
	GLCategorizationId,
	ActivityTypeId,
	FunctionalDepartmentId,
	PropertyGLAccountId,
	GLGlobalAccountId
FROM
	Gdm.PropertyOverheadPropertyGLAccount POPGA 
	INNER JOIN Gdm.PropertyOverheadPropertyGLAccountActive(@DataPriorToDate) POPGAa ON
		POPGA.ImportKey = POPGAa.ImportKey

PRINT ''Rows Inserted into #PropertyOverheadPropertyGLAccount:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLAccount table is used to map local GL Accounts for local GL Categorization mappings.
	*/

CREATE TABLE #GLAccount
(
	GLAccountId INT NOT NULL,
	GLGlobalAccountId INT NULL
)
INSERT INTO #GLAccount
(
	GLAccountId,
	GLGlobalAccountId
)
SELECT
	GA.GLAccountId,
	GA.GLGlobalAccountId
FROM
	Gdm.GLAccount GA
	INNER JOIN Gdm.GlAccountActive(@DataPriorToDate) GAa ON
		GA.ImportKey = GAa.ImportKey
WHERE
	GA.IsActive = 1

PRINT ''Rows Inserted into #GLAccount:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_GLAccount_GLAccountId ON #GLAccount(GLAccountId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingCategorization is used to determine the default categorization to be shown in local reports based on the EntityType and
		Allocation sub region.
	*/

CREATE TABLE #ReportingCategorization
(
	ReportingCategorizationId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	GLCategorizationId INT NOT NULL
)
INSERT INTO #ReportingCategorization
(
	ReportingCategorizationId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	GLCategorizationId
)
SELECT
	RC.ReportingCategorizationId,
	RC.EntityTypeId,
	RC.AllocationSubRegionGlobalRegionId,
	RC.GLCategorizationId
FROM
	Gdm.ReportingCategorization RC 
	INNER JOIN Gdm.ReportingCategorizationActive(@DataPriorToDate) RCa ON
		RC.ImportKey = RCa.ImportKey

PRINT ''Rows Inserted into #ReportingCategorization:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_ReportingCategorization_Categorization ON #ReportingCategorization(EntityTypeId, AllocationSubRegionGlobalRegionId)
		
PRINT ''Completed inserting Active records into temp table''
PRINT CONVERT(Varchar(27), getdate(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Global Categorization Mapping

		The table below is used to map Gl Accounts to their Categorization Hierarchies for the Global Categorization.
		The GlobalGL Accounts used are the list from the #ActivityTypeGLAccount table created earlier.
	*/

CREATE TABLE #GlobalGLCategorizationMapping
(
	GLGlobalAccountId INT NOT NULL,
	GlobalGLCategorizationHierarchyCode VARCHAR(50) NOT NULL
)
INSERT INTO #GlobalGLCategorizationMapping
(
	GLGlobalAccountId,
	GlobalGLCategorizationHierarchyCode
)
SELECT
	GGA.GLGlobalAccountId,
	CONVERT(VARCHAR(2), ISNULL(GCT.GLCategorizationTypeId, -1)) + '':'' +
		CONVERT(VARCHAR(5), ISNULL(GC.GLCategorizationId, -1)) + '':'' +
		CONVERT(VARCHAR(10), ISNULL(FinC.GLFinancialCategoryId, -1)) + '':'' +
		CONVERT(VARCHAR(10), ISNULL(MajC.GLMajorCategoryId, -1)) + '':'' +
		CONVERT(VARCHAR(10), ISNULL(MinC.GLMinorCategoryId, -1)) + '':'' +
		CONVERT(VARCHAR(10), GGA.GLGlobalAccountId)
FROM
	#GLGlobalAccount GGA 
		
	INNER JOIN #ActivityTypeGLAccount ATGA ON
		GGA.Code = ATGA.GLAccountCode
	
	LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
		GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId AND
		GGAC.GLCategorizationId = 233 -- Limit this to the Global Categorization
	
	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId -- Overhead transactions from TAPAS Global are considered indirect transactions
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId  
		
	LEFT OUTER JOIN #GLFinancialCategory FinC ON
		MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId
		
	LEFT OUTER JOIN #GLCategorization GC ON
		FinC.GLCategorizationId = GC.GLCategorizationId  
	
	LEFT OUTER JOIN  #GLCategorizationType GCT ON
		GC.GLCategorizationTypeId = GCT.GLCategorizationTypeId 

PRINT ''Rows Inserted into #GlobalGLCategorizationMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_GlobalGLCategorizationMapping_GLGlobalAccountId ON #GlobalGLCategorizationMapping(GLGlobalAccountId)
-- 

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		Local Categorization Mappings

		The #LocalGLCategorizationMapping table below is used to determine the local GLCategorizationHierchy Codes.
		The table is pivoted (i.e. each of the GLCategorizationHierchy Codes for each GLCategorization appear as a separate column for each
			ActivityType-FunctionalDepartment combination)so that it only joins to the #ProfitabilityActual table below once.		
	*/

CREATE TABLE #LocalGLCategorizationMapping(
	FunctionalDepartmentId INT NULL,
	ActivityTypeId INT NULL,
	USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL
)
INSERT INTO #LocalGLCategorizationMapping(
	FunctionalDepartmentId,
	ActivityTypeId,
	USPropertyGLCategorizationHierarchyCode,
	USFundGLCategorizationHierarchyCode,
	EUPropertyGLCategorizationHierarchyCode,
	EUFundGLCategorizationHierarchyCode,
	USDevelopmentGLCategorizationHierarchyCode,
	EUDevelopmentGLCategorizationHierarchyCode
)
SELECT
	PivotTable.FunctionalDepartmentId,
	PivotTable.ActivityTypeId,
	PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyCode,
	PivotTable.[US Fund] AS USFundGLCategorizationHierarchyCode,
	PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyCode,
	PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyCode,
	PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyCode,
	PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyCode
FROM
	(
		SELECT DISTINCT
			FD.FunctionalDepartmentId,
			AType.ActivityTypeId,
			GC.Name as GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GC.GLCategorizationTypeId, -1)) + '':'' +
			CONVERT(VARCHAR(10), ISNULL(GC.GLCategorizationId, -1)) + '':'' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(FinC.GLFinancialCategoryId, -1) END) + '':'' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MajC.GLMajorCategoryId, -1) END) + '':'' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MinC.GLMinorCategoryId, -1) END) + '':'' +
			CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode
		FROM
			#PropertyOverheadPropertyGLAccount POPGA
			
			INNER JOIN #ActivityType AType ON
				ISNULL(POPGA.ActivityTypeId, 0) = CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END
			
			INNER JOIN #FunctionalDepartment FD ON
				ISNULL(POPGA.FunctionalDepartmentId, 0) = CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END
			
			INNER JOIN #GLCategorization GC ON
				POPGA.GLCategorizationId = GC.GLCategorizationId
				
			INNER JOIN #GLAccount GA ON
				POPGA.PropertyGLAccountId = GA.GLAccountId  
				
			/*
				If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
				If the local Categorization is not configured for recharge, the Global account is determined directly from the 
					#PropertyOverheadPropertyGLAccount table
			*/
			INNER JOIN #GLGlobalAccount GGA ON
				GGA.GLGlobalAccountId = 
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GA.GLGlobalAccountId
						ELSE
							POPGA.GLGlobalAccountId
					END
					
			LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
				GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId  AND
				POPGA.GLCategorizationId = GGAC.GLCategorizationId
			
			/*
				If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
					in the #GLGlobalAccountCategorization table.
				If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
					field in the #GLGlobalAccountCategorization table.
			*/	
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				MinC.GLMinorCategoryId =
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GGAC.CoAGLMinorCategoryId
						ELSE
							GGAC.DirectGLMinorCategoryId
					END
					
			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId  
				
			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
				GC.GLCategorizationId = FinC.GLCategorizationId 

				
	) LocalMappings
	PIVOT
	(
		MAX(GLCategorizationHierarchyCode)
		FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
	) AS PivotTable

PRINT ''Rows Inserted into #LocalGLCategorizationMapping:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
CREATE UNIQUE CLUSTERED INDEX UX_LocalGLCategorizationMapping_Categorization ON #LocalGLCategorizationMapping(FunctionalDepartmentId, ActivityTypeId)

END

/* ==============================================================================================================================================
	7. Map the source transaction data to mapping data from GDM, HR and GACS
   =========================================================================================================================================== */
BEGIN

CREATE TABLE #ProfitabilityOverhead(
	BillingUploadDetailId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8)  NULL,
	CorporateSourceCode VARCHAR(2)  NULL,
	CanAllocateOverheads Bit NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationRegionCode VARCHAR(6) NULL,
	ConsolidationSubRegionGlobalRegionId INT NULL,
	OriginatingRegionCode VARCHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	PropertyFundCode char(12) NULL,
	PropertyFundId INT NOT NULL,
	FunctionalDepartmentId INT NULL,
	FunctionalDepartmentCode CHAR(3) NULL,
	ActivityTypeCode VARCHAR(10) NULL,
	ExpenseType VARCHAR(8) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual DECIMAL(18,9) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL
)

INSERT INTO #ProfitabilityOverhead(
	BillingUploadDetailId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	CanAllocateOverheads,
	ExpensePeriod,
	AllocationRegionCode,
	ConsolidationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	PropertyFundId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	ActivityTypeCode,
	ExpenseType,
	LocalCurrency,
	LocalActual,
	UpdatedDate,
	InsertedDate,
	PropertyFundCode
)
SELECT 
	Bud.BillingUploadDetailId,
	ISNULL(P2.CorporateDepartmentCode, Bud.CorporateDepartmentCode) AS CorporateDepartmentCode,
	
	Bud.CorporateSourceCode,
	ISNULL(P2.CanAllocateOverheads, P1.CanAllocateOverheads) AS CanAllocateOverheads,
	
	Bu.ExpensePeriod,
	GrAr.RegionCode AllocationRegionCode, 
	CRCDC.GlobalRegionId ConsolidationSubRegionGlobalRegionId, 
	Ovr.CorporateEntityRef OriginatingRegionCode,
	Ovr.CorporateSourceCode OriginatingRegionSourceCode,
	
	CASE
		WHEN
			(P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0)
		THEN
			ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId, --This is seen as the Gdm.Gr.GlobalPropertyFundId

	Fd.FunctionalDepartmentId,
	Fd.GlobalCode FunctionalDepartmentCode,
	At.ActivityTypeCode,
	''Overhead'' ExpenseType,
	Bud.CurrencyCode ForeignCurrency,
	Bud.AllocationAmount ForeignActual,
	Bud.UpdatedDate,
	Bud.InsertedDate,
	
	CASE
		WHEN
			(P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0)
		THEN
			Bud.CorporateDepartmentCode
		ELSE
			P2.CorporateDepartmentCode
	END AS PropertyFundCode
	
FROM
	#BillingUpload Bu
		
	INNER JOIN #BillingUploadDetail Bud ON
		Bu.BillingUploadId = Bud.BillingUploadId  

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Bu.FunctionalDepartmentId = Fd.FunctionalDepartmentId -- CC22 - used to look like: Fd.FunctionalDepartmentId = Bu.OverheadFunctiona

	LEFT OUTER JOIN #Project P1 ON
		Bu.ProjectId = P1.ProjectId  

	LEFT OUTER JOIN #Project P2 ON
		P1.AllocateOverheadsProjectId = P2.ProjectId  

	-- P1 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		P1.CorporateSourceCode = GrScC.SourceCode 

	/*
		2010-11-23
		The commented code below is what was previously used to determine the corporate department of an overhead actual.
		The join criteria shows that the budget project''s corporate department is used for this. This approach isn''t suitable as this field
		could change at any time (and has). A more stable strategy is to use the corporate department that is saved in the budget upload
		detail table, as this is guaranteed to never change (unless someone manually changes it via the back end).
	*/


	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON -- added
		GrScC.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(Bud.CorporateDepartmentCode)) = RECDC.CorporateDepartmentCode AND
		Bud.CorporateSourceCode = RECDC.SourceCode AND
		Bu.ExpensePeriod >= 201007
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON -- added
		GrScC.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		LTRIM(RTRIM(Bud.CorporateDepartmentCode)) = REPEC.PropertyEntityCode AND
		Bud.CorporateSourceCode = REPEC.SourceCode AND
		Bu.ExpensePeriod >= 201007
		
	LEFT OUTER JOIN	#ConsolidationRegionCorporateDepartment CRCDC ON -- CC16 : It is assumed that overheads are to come from corproate departemtns only
		CRCDC.CorporateDepartmentCode = 
			CASE
				WHEN
					P1.AllocateOverheadsProjectId IS NULL
				THEN
					Bud.CorporateDepartmentCode
				ELSE 
					P2.CorporateDepartmentCode
			END AND
		Bud.CorporateSourceCode = CRCDC.SourceCode AND
		Bu.ExpensePeriod >= 201101
		   
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		Bud.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		Bud.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = ''YES'' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScC.IsCorporate = ''YES'' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
			)
		) AND Bu.ExpensePeriod < 201007

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN
					Bu.ExpensePeriod < 201007
				THEN
					pfm.PropertyFundId
				ELSE
					ISNULL(RECDC.PropertyFundId, REPEC.PropertyFundId)
			END AND
		Bu.UpdatedDate BETWEEN DepartmentPropertyFund.StartDate AND DepartmentPropertyFund.EndDate AND
		DepartmentPropertyFund.SnapshotId = 0

	-- P1 end -----------------------
	-- P2 begin ---------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
		P2.CorporateSourceCode = GrScO.SourceCode  

    /*
		2010-11-23
		Unlike the previous three joins used to determine the reporting entity, the joins below are still required to used the budget project''s
		corporate department code when determining the reporting entity for the case when the AllocatedOverheadProjectID is not null. This is
		not ideal as again, the corporate department associated with this project could change, but it''s GR''s best effort as it stands as TAPAS
		is unable to snapshot data. When the GR rolling window begins to be used as it was intended, the potential inconsistencies that this
		may cause will be limited as the window will be much smaller than what it is currently set to.
    */
    
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDO ON -- added
		GrScO.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(P2.CorporateDepartmentCode))  = RECDO.CorporateDepartmentCode AND
		P2.CorporateSourceCode = RECDO.SourceCode AND
		Bu.ExpensePeriod >= ''201007'' 
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON -- added
		GrScO.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		LTRIM(RTRIM(P2.CorporateDepartmentCode))  = REPEO.PropertyEntityCode AND
		P2.CorporateSourceCode = REPEO.SourceCode AND
		Bu.ExpensePeriod >= ''201007''
		

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		P2.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		P2.CorporateSourceCode = opfm.SourceCode AND
		opfm.IsDeleted = 0  AND 
		(
			(GrScO.IsProperty = ''YES'' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScO.IsCorporate = ''YES'' AND opfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL) 
			)	
		) AND Bu.ExpensePeriod < ''201007'' 

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN
					Bu.ExpensePeriod < 201007
				THEN
					opfm.PropertyFundId
				ELSE
					CASE
						WHEN
							GrScO.IsCorporate = ''YES'' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END AND
		Bu.UpdatedDate BETWEEN OverheadPropertyFund.StartDate AND OverheadPropertyFund.EndDate AND
		OverheadPropertyFund.SnapshotId = 0

	-- P2 end -----------------------

	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = (
								CASE
									WHEN
										(P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0)
									THEN 
										ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
									ELSE
										ISNULL(OverheadPropertyFund.PropertyFundId, -1)
								END
							) --AND
		--PF.IsActive = 1
		
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		Bu.UpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate AND
		GrAr.SnapshotId = 0

	LEFT OUTER JOIN #ActivityType At ON
		Bu.ActivityTypeId = At.ActivityTypeId  

	LEFT OUTER JOIN #OverheadRegion Ovr ON
		Bu.OverheadRegionId = Ovr.OverheadRegionId  

WHERE
	Bu.BillingUploadBatchId IS NOT NULL AND
	Bud.BillingUploadDetailTypeId <> 2 
	--AND ISNULL(Bu.UpdatedDate, Bu.UpdatedDate) BETWEEN @ImportStartDate AND @ImportEndDate --NOTE:: GC I am note sure it can work with the date filter

--IMS 48953 - Exclude overhead mark up from the import

PRINT ''Rows Inserted into #ProfitabilityOverhead:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

/*==================================================================================================================================
 8. Remove records from the #ProfitabilityOverhead table mapped to records in the exclusion tables popluated above
 ==================================================================================================================================*/

-- Change control 7 - begin

/*
	The approach to this is not the same as that of the MRI script where the records are excluded when getting data from the source
	systems because the data required by the exclusion tables come from different tables in different source systems, making it difficult
	to exclude at the point of the source. Also, some tables such as #Project are used for different purposes, therefore, we may be excluding
	records that need to be included.
*/

PRINT ''Deleting records in #ProfitabilityOverhead which are associated with entries in the ManageCorporateEntity and ManageCorporateDepartment tables''
PRINT CONVERT(Varchar(27), getdate(), 121)

DELETE
	PO
FROM
	#ProfitabilityOverhead PO
	
	INNER JOIN #ManageCorporateEntity MCE ON
		PO.OriginatingRegionCode = MCE.CorporateEntityCode AND
		PO.CorporateSourceCode = MCE.SourceCode
WHERE
	RIGHT(MCE.SourceCode, 1) = ''C'' AND
	RIGHT(PO.CorporateSourceCode, 1) = ''C''	

PRINT (CONVERT(char(10),@@rowcount) + '' records deleted from #ProfitabilityOverhead'')


DELETE
	PO
FROM
	#ProfitabilityOverhead PO
	
	INNER JOIN #ManageCorporateDepartment MCD ON
		PO.PropertyFundCode = MCD.CorporateDepartmentCode AND
		PO.CorporateSourceCode = MCD.SourceCode
WHERE
	RIGHT(MCD.SourceCode, 1) = ''C'' AND	
	RIGHT(PO.CorporateSourceCode, 1) = ''C''	

PRINT (CONVERT(char(10),@@rowcount) + '' records deleted from #ProfitabilityOverhead'')

PRINT ''Finished deleting from #ProfitabilityOverhead''
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Change control 7 - end

END

/* ==============================================================================================================================================
	9. Take the different sources and combine them into the "REAL" fact table
   =========================================================================================================================================== */
BEGIN

	/*
		If the join is not possible, default the link to the ''UNKNOWN'' link	
	*/

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	ConsolidationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	SourceSystemKey INT NOT NULL,
	
	OriginatingRegionCode char(6) NULL,
	PropertyFundCode char(12) NULL,
	FunctionalDepartmentCode char(15) NULL,
	
	GlobalGLCategorizationHierarchyKey INT NULL,
	USPropertyGLCategorizationHierarchyKey INT NULL,
	USFundGLCategorizationHierarchyKey INT NULL,
	EUPropertyGLCategorizationHierarchyKey INT NULL,
	EUFundGLCategorizationHierarchyKey INT NULL,
	USDevelopmentGLCategorizationHierarchyKey INT NULL,
	EUDevelopmentGLCategorizationHierarchyKey INT NULL,
	ReportingGLCategorizationHierarchyKey INT NULL,
	
	LastDate DATETIME NULL
	
) 

INSERT INTO #ProfitabilityActual(
	CalendarKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	SourceSystemKey,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
	ReportingGLCategorizationHierarchyKey,
	
	LastDate
)
SELECT 
	DATEDIFF(dd, ''1900-01-01'', LEFT(Gl.ExpensePeriod, 4) + ''-'' + RIGHT(Gl.ExpensePeriod, 2) + ''-01'') CalendarKey,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown) SourceKey,
	ISNULL(GrFdm.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) FunctionalDepartmentKey,
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
	ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) ActivityTypeKey,
	ISNULL(GrOr.OriginatingRegionKey, @OriginatingRegionKeyUnknown)OriginatingRegionKey,
	ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AllocationRegionKey,
	CASE 
		WHEN Gl.ExpensePeriod < 201101 THEN
			ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) 
		ELSE
			ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown)
	END ConsolidationRegionKey,
	ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) PropertyFundKey,
	ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown) OverheadKey,
		''BillingUploadDetailId='' + LTRIM(STR(Gl.BillingUploadDetailId, 10, 0)),
	ISNULL(Cu.CurrencyKey, @LocalCurrencyKeyUnknown),
	Gl.LocalActual,
	3 AS SourceSystemKey, --SourceSystemKey
	Gl.OriginatingRegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	
	COALESCE(GlobalGCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey) GlobalGLCategorizationHierarchyKey,
	COALESCE(USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey) USPropertyGLCategorizationHierarchyKey,
	COALESCE(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey) USFundGLCategorizationHierarchyKey,
	COALESCE(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey) EUPropertyGLCategorizationHierarchyKey,
	COALESCE(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)	EUFundGLCategorizationHierarchyKey,
	COALESCE(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey) USDevelopmentGLCategorizationHierarchyKey,
	COALESCE(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown) EUDevelopmentGLCategorizationHierarchyKey,
	
	/*
	The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
	when a local report is generated.
	*/
		
	CASE 
		WHEN GC.GLCategorizationId IS NOT NULL THEN
			CASE
				WHEN GC.Name = ''US Property'' THEN ISNULL(USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
				WHEN GC.Name = ''US Fund'' THEN ISNULL(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey)
				WHEN GC.Name = ''EU Property'' THEN ISNULL(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
				WHEN GC.Name = ''EU Fund'' THEN ISNULL(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey)
				WHEN GC.Name = ''US Development'' THEN ISNULL(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey)
				WHEN GC.Name = ''EU Development'' THEN ISNULL(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
				WHEN GC.Name = ''Global'' THEN COALESCE(GlobalGCH.GLCategorizationHierarchyKey, UnknownGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
				ELSE ISNULL(LocalUnknownGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
			END
		ELSE @GLCategorizationHierarchyKeyUnknown
	END ReportingGLCategorizationHierarchyKey,
	
	Gl.UpdatedDate
FROM
	#ProfitabilityOverhead Gl

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Gl.LocalCurrency = Cu.CurrencyCode  

	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		Gl.FunctionalDepartmentCode  = GrFdm.FunctionalDepartmentCode AND
		Gl.FunctionalDepartmentCode  = GrFdm.SubFunctionalDepartmentCode AND
		Gl.UpdatedDate BETWEEN GrFdm.StartDate AND ISNULL(GrFdm.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #ActivityType At ON
		Gl.ActivityTypeCode = At.ActivityTypeCode  
		
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		At.ActivityTypeId = GrAt.ActivityTypeId AND
		Gl.UpdatedDate BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate) AND
		GrAt.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = ''ALLOC''
		
	LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
		At.ActivityTypeId = AtGla.ActivityTypeId  

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		AtGla.GLAccountCode = GA.Code AND
		ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)

	-- CC21 Changes
	/*
	
	The mappings below map the Global and Local categorizations for the various transactions.
	Global Categorizations are mapped based on the GL Global Account mappings in GDM.
	Local Categorizations are mapped based on the Activity Type and Functional Department
	The temp table is joined to the dimension for each Categorization
	
	*/
	LEFT OUTER JOIN #GlobalGLCategorizationMapping GGCM ON
		GA.GLGlobalAccountId = GGCM.GLGlobalAccountId  
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalGCH ON
		GGCM.GlobalGLCategorizationHierarchyCode = GlobalGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN GlobalGCH.StartDate AND GlobalGCH.EndDate AND
		GlobalGCH.SnapshotId = 0
		
	LEFT OUTER JOIN #LocalGLCategorizationMapping LGCM ON
		Gl.FunctionalDepartmentId = LGCM.FunctionalDepartmentId AND
		At.ActivityTypeId = LGCM.ActivityTypeId 
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USPropertyGCH ON
		LGCM.USPropertyGLCategorizationHierarchyCode  = USPropertyGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN USPropertyGCH.StartDate AND USPropertyGCH.EndDate AND
		USPropertyGCH.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USFundGCH ON
		LGCM.USFundGLCategorizationHierarchyCode  = USFundGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN USFundGCH.StartDate AND USFundGCH.EndDate AND
		USFundGCH.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUPropertyGCH ON
		LGCM.EUPropertyGLCategorizationHierarchyCode = EUPropertyGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN EUPropertyGCH.StartDate AND EUPropertyGCH.EndDate AND
		EUPropertyGCH.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUFundGCH ON
		LGCM.EUFundGLCategorizationHierarchyCode = EUFundGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN EUFundGCH.StartDate AND EUFundGCH.EndDate AND
		EUFundGCH.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USDevelopmentGCH ON
		LGCM.USDevelopmentGLCategorizationHierarchyCode = USDevelopmentGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN USDevelopmentGCH.StartDate AND USDevelopmentGCH.EndDate AND
		USDevelopmentGCH.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUDevelopmentGCH ON
		LGCM.EUDevelopmentGLCategorizationHierarchyCode = EUDevelopmentGCH.GLCategorizationHierarchyCode AND
		Gl.UpdatedDate BETWEEN EUDevelopmentGCH.StartDate AND EUDevelopmentGCH.EndDate AND
		EUDevelopmentGCH.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
		UnknownGCH.GLCategorizationHierarchyCode = ''1:233:-1:-1:-1:'' + CONVERT(VARCHAR(10), GA.GLGlobalAccountId) AND
		Gl.UpdatedDate BETWEEN UnknownGCH.StartDate AND UnknownGCH.EndDate AND
		UnknownGCH.SnapshotId = 0		

	-- End of CC21 Changes

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		Gl.CorporateSourceCode = GrSc.SourceCode  
	
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		Gl.PropertyFundId  = GrPf.PropertyFundId AND
		Gl.UpdatedDate BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate) AND
		GrPf.SnapshotId = 0

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		Gl.OriginatingRegionCode = ORCE.CorporateEntityCode AND
		Gl.OriginatingRegionSourceCode = ORCE.SourceCode  

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ORCE.GlobalRegionId  = GrOr.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate) AND
		GrOr.SnapshotId = 0

	LEFT OUTER JOIN #PropertyFund PF ON
		Gl.PropertyFundId = PF.PropertyFundId

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate) AND
		GrAr.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON
		Gl.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrCr.StartDate AND ISNULL(GrCr.EndDate, Gl.UpdatedDate) AND
		GrCr.SnapshotId = 0

	LEFT OUTER JOIN (
						SELECT ''UC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM USCorp.GDEP UNION ALL
						SELECT ''EC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM EUCorp.GDEP UNION ALL
						SELECT ''IC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM INCorp.GDEP UNION ALL
						SELECT ''BC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM BRCorp.GDEP UNION ALL
						SELECT ''CC'' SOURCECODE, DEPARTMENT, NETTSCOST FROM CNCorp.GDEP
					) RiCo ON
		RiCo.DEPARTMENT = Gl.CorporateDepartmentCode AND
		RiCo.SOURCECODE = Gl.CorporateSourceCode	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE
									WHEN ISNULL(RiCo.NETTSCOST, ''N'') = ''Y'' THEN ''NO'' ELSE ''YES''
								END	

	LEFT OUTER JOIN #ReportingCategorization RC ON
		PF.EntityTypeId = RC.EntityTypeId AND
		ASR.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId  

	LEFT OUTER JOIN #GLCategorization GC ON
		RC.GLCategorizationId = GC.GLCategorizationId 

	LEFT OUTER JOIN #PropertyOverheadPropertyGLAccount POPGA ON
		CASE WHEN POPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE Gl.FunctionalDepartmentId END = ISNULL(POPGA.FunctionalDepartmentId, 0) AND
		CASE WHEN POPGA.ActivityTypeId IS NULL THEN 0 ELSE At.ActivityTypeId END = ISNULL(POPGA.ActivityTypeId, 0) AND
		RC.GLCategorizationId = POPGA.GLCategorizationId
	
	LEFT OUTER JOIN #GLAccount LocalGA ON
		POPGA.PropertyGLAccountId = LocalGA.GLAccountId  
		
	/*
		If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount local account
		If the local Categorization is not configured for recharge, the Global account is determined directly from the 
			#PropertyOverheadPropertyGLAccount table
	*/
	LEFT OUTER JOIN #GLGlobalAccount LocalGGA ON
		LocalGGA.GLGlobalAccountId = 
			CASE 
				WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
					LocalGA.GLGlobalAccountId
				ELSE
					POPGA.GLGlobalAccountId
			END
			
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy LocalUnknownGCH ON
		LocalUnknownGCH.GLCategorizationHierarchyCode = ''-1:-1:-1:-1:-1:'' + CONVERT(VARCHAR(10), LocalGGA.GLGlobalAccountId) AND
		Gl.UpdatedDate BETWEEN LocalUnknownGCH.StartDate AND LocalUnknownGCH.EndDate AND
		LocalUnknownGCH.SnapshotId = 0
WHERE
	Gl.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate
	
PRINT ''Rows Inserted into #ProfitabilityActual:''+CONVERT(char(10),@@rowcount)
END

/* ==============================================================================================================================================
	10. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
   =========================================================================================================================================== */
BEGIN	

CREATE UNIQUE CLUSTERED INDEX UX_ProfitabilityActual_ReferenceCode ON #ProfitabilityActual (SourceKey, ReferenceCode)

PRINT ''Completed building clustered index on #ProfitabilityActual''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

UPDATE DIM
SET 	
	DIM.CalendarKey								  = Pro.CalendarKey,
	DIM.FunctionalDepartmentKey					  = Pro.FunctionalDepartmentKey,
	DIM.ReimbursableKey							  = Pro.ReimbursableKey,
	DIM.ActivityTypeKey							  = Pro.ActivityTypeKey,
	DIM.OriginatingRegionKey					  = Pro.OriginatingRegionKey,
	DIM.AllocationRegionKey						  = Pro.AllocationRegionKey,
	DIM.ConsolidationRegionKey					  = Pro.ConsolidationRegionKey,
	DIM.PropertyFundKey							  = Pro.PropertyFundKey,
	DIM.OverheadKey								  = Pro.OverheadKey,
	DIM.LocalCurrencyKey						  = Pro.LocalCurrencyKey,
	DIM.LocalActual								  = Pro.LocalActual,
	DIM.SourceSystemKey		  = Pro.SourceSystemKey,
	
	DIM.GlobalGLCategorizationHierarchyKey		  = Pro.GlobalGLCategorizationHierarchyKey,
	DIM.USPropertyGLCategorizationHierarchyKey	  = Pro.USPropertyGLCategorizationHierarchyKey,
	DIM.USFundGLCategorizationHierarchyKey		  = Pro.USFundGLCategorizationHierarchyKey,
	DIM.EUPropertyGLCategorizationHierarchyKey	  = Pro.EUPropertyGLCategorizationHierarchyKey,
	DIM.EUFundGLCategorizationHierarchyKey		  = Pro.EUFundGLCategorizationHierarchyKey,
	DIM.USDevelopmentGLCategorizationHierarchyKey = Pro.USDevelopmentGLCategorizationHierarchyKey,
	DIM.EUDevelopmentGLCategorizationHierarchyKey = Pro.EUDevelopmentGLCategorizationHierarchyKey,
	DIM.ReportingGLCategorizationHierarchyKey	  = Pro.ReportingGLCategorizationHierarchyKey,
	
	DIM.OriginatingRegionCode					  = Pro.OriginatingRegionCode,
	DIM.PropertyFundCode						  = Pro.PropertyFundCode,
	DIM.FunctionalDepartmentCode				  = Pro.FunctionalDepartmentCode,
	
	UpdatedDate									= GETDATE(),
	DIM.LastDate								= Pro.LastDate
	
FROM
	GrReporting.dbo.ProfitabilityActual DIM
	
	INNER JOIN #ProfitabilityActual Pro ON
		DIM.SourceKey = Pro.SourceKey AND
		DIM.ReferenceCode = Pro.ReferenceCode
WHERE
	(
		DIM.CalendarKey								  <> Pro.CalendarKey OR
		DIM.FunctionalDepartmentKey					  <> Pro.FunctionalDepartmentKey OR
		DIM.ReimbursableKey							  <> Pro.ReimbursableKey OR
		DIM.ActivityTypeKey							  <> Pro.ActivityTypeKey OR
		DIM.OriginatingRegionKey					  <> Pro.OriginatingRegionKey OR
		DIM.AllocationRegionKey						  <> Pro.AllocationRegionKey OR
		DIM.ConsolidationRegionKey					  <> Pro.ConsolidationRegionKey OR
		DIM.PropertyFundKey							  <> Pro.PropertyFundKey OR
		DIM.OverheadKey								  <> Pro.OverheadKey OR
		DIM.LocalCurrencyKey						  <> Pro.LocalCurrencyKey OR
		DIM.LocalActual								  <> Pro.LocalActual OR
		DIM.SourceSystemKey		  <> Pro.SourceSystemKey OR
		
		ISNULL(DIM.GlobalGLCategorizationHierarchyKey, '''')		  <> Pro.GlobalGLCategorizationHierarchyKey OR
		ISNULL(DIM.USPropertyGLCategorizationHierarchyKey, '''')	  <> Pro.USPropertyGLCategorizationHierarchyKey OR
		ISNULL(DIM.USFundGLCategorizationHierarchyKey, '''')		  <> Pro.USFundGLCategorizationHierarchyKey OR
		ISNULL(DIM.EUPropertyGLCategorizationHierarchyKey, '''')	  <> Pro.EUPropertyGLCategorizationHierarchyKey OR
		ISNULL(DIM.EUFundGLCategorizationHierarchyKey, '''')		  <> Pro.EUFundGLCategorizationHierarchyKey OR
		ISNULL(DIM.USDevelopmentGLCategorizationHierarchyKey, '''') <> Pro.USDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(DIM.EUDevelopmentGLCategorizationHierarchyKey, '''') <> Pro.EUDevelopmentGLCategorizationHierarchyKey OR
		ISNULL(DIM.ReportingGLCategorizationHierarchyKey, '''')	  <> Pro.ReportingGLCategorizationHierarchyKey OR
		
		DIM.OriginatingRegionCode					  <> Pro.OriginatingRegionCode OR
		DIM.PropertyFundCode						  <> Pro.PropertyFundCode OR
		DIM.FunctionalDepartmentCode				  <> Pro.FunctionalDepartmentCode OR
		ISNULL(DIM.LastDate, '''')					<> Pro.LastDate
	)
PRINT ''Rows Updated in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual
(
	CalendarKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	SourceSystemKey,
	
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
	ReportingGLCategorizationHierarchyKey,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	InsertedDate,
	UpdatedDate,
	
	LastDate
)
SELECT
	Pro.CalendarKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.ConsolidationRegionKey,
	Pro.PropertyFundKey,
	Pro.OverheadKey,
	Pro.ReferenceCode, 
	Pro.LocalCurrencyKey, 
	Pro.LocalActual,
	Pro.SourceSystemKey, --BillingUploadDetail

	Pro.GlobalGLCategorizationHierarchyKey,
	Pro.USPropertyGLCategorizationHierarchyKey,
	Pro.USFundGLCategorizationHierarchyKey,
	Pro.EUPropertyGLCategorizationHierarchyKey,
	Pro.EUFundGLCategorizationHierarchyKey,
	Pro.USDevelopmentGLCategorizationHierarchyKey,
	Pro.EUDevelopmentGLCategorizationHierarchyKey,
	Pro.ReportingGLCategorizationHierarchyKey,
	
	Pro.OriginatingRegionCode,
	Pro.PropertyFundCode,
	Pro.FunctionalDepartmentCode,
	GETDATE(), -- InsertedDate
	GETDATE(), -- UpdatedDate
	
	Pro.LastDate
FROM
	#ProfitabilityActual Pro

	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		Pro.SourceKey  = ProExists.SourceKey AND
		Pro.ReferenceCode = ProExists.ReferenceCode	 
WHERE
	ProExists.SourceKey IS NULL

PRINT ''Rows Inserted in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*
		Remove orphan rows from the warehouse that have been removed in the source data systems	
	*/

EXEC stp_IU_ArchiveProfitabilityOverheadActual @ImportStartDate=@ImportStartDate, @ImportEndDate=@ImportEndDate, @DataPriorToDate=@DataPriorToDate

END

/* =============================================================================================================================================
	11. Clean Up
   ========================================================================================================================================== */
BEGIN

IF OBJECT_ID(''tempdb..#ManageType'') IS NOT NULL
	DROP TABLE #ManageType

IF OBJECT_ID(''tempdb..#ManageCorporateDepartment'') IS NOT NULL
	DROP TABLE #ManageCorporateDepartment

IF OBJECT_ID(''tempdb..#ManageCorporateEntity'') IS NOT NULL
	DROP TABLE #ManageCorporateEntity

IF OBJECT_ID(''tempdb..#ActivityTypeGLAccount'') IS NOT NULL
	DROP TABLE #ActivityTypeGLAccount

IF OBJECT_ID(''tempdb..#AllocationSubRegion'') IS NOT NULL
	DROP TABLE #AllocationSubRegion

IF OBJECT_ID(''tempdb..#BillingUpload'') IS NOT NULL
	DROP TABLE #BillingUpload

IF OBJECT_ID(''tempdb..#BillingUploadDetail'') IS NOT NULL
	DROP TABLE #BillingUploadDetail

IF OBJECT_ID(''tempdb..#Overhead'') IS NOT NULL
	DROP TABLE #Overhead

IF OBJECT_ID(''tempdb..#FunctionalDepartment'') IS NOT NULL
	DROP TABLE #FunctionalDepartment

IF OBJECT_ID(''tempdb..#Project'') IS NOT NULL
	DROP TABLE #Project

IF OBJECT_ID(''tempdb..#PropertyFund'') IS NOT NULL
	DROP TABLE #PropertyFund

IF OBJECT_ID(''tempdb..#PropertyFundMapping'') IS NOT NULL
	DROP TABLE #PropertyFundMapping

IF OBJECT_ID(''tempdb..#ReportingEntityCorporateDepartment'') IS NOT NULL
	DROP TABLE #ReportingEntityCorporateDepartment

IF OBJECT_ID(''tempdb..#ReportingEntityPropertyEntity'') IS NOT NULL
	DROP TABLE #ReportingEntityPropertyEntity

IF OBJECT_ID(''tempdb..#OriginatingRegionCorporateEntity'') IS NOT NULL
	DROP TABLE #OriginatingRegionCorporateEntity

IF OBJECT_ID(''tempdb..#OriginatingRegionPropertyDepartment'') IS NOT NULL
	DROP TABLE #OriginatingRegionPropertyDepartment

IF OBJECT_ID(''tempdb..#GLGlobalAccount'') IS NOT NULL
	DROP TABLE #GLGlobalAccount

IF OBJECT_ID(''tempdb..#ActivityType'') IS NOT NULL
	DROP TABLE #ActivityType

IF OBJECT_ID(''tempdb..#OverheadRegion'') IS NOT NULL
	DROP TABLE #OverheadRegion

IF OBJECT_ID(''tempdb..#GLAccount'') IS NOT NULL
	DROP TABLE #GLAccount

IF OBJECT_ID(''tempdb..#GLGlobalAccountCategorization'') IS NOT NULL
	DROP TABLE #GLGlobalAccountCategorization

IF OBJECT_ID(''tempdb..#GLFinancialCategory'') IS NOT NULL
	DROP TABLE #GLFinancialCategory

IF OBJECT_ID(''tempdb..#GLMajorCategory'') IS NOT NULL
	DROP TABLE #GLMajorCategory

IF OBJECT_ID(''tempdb..#GLMinorCategory'') IS NOT NULL
	DROP TABLE #GLMinorCategory

IF OBJECT_ID(''tempdb..#GLCategorization'') IS NOT NULL
	DROP TABLE #GLCategorization

IF OBJECT_ID(''tempdb..#GLCategorizationType'') IS NOT NULL
	DROP TABLE #GLCategorizationType

IF OBJECT_ID(''tempdb..#PropertyOverheadPropertyGLAccount'') IS NOT NULL
	DROP TABLE #PropertyOverheadPropertyGLAccount

IF OBJECT_ID(''tempdb..#GlobalGLCategorizationMapping'') IS NOT NULL
	DROP TABLE #GlobalGLCategorizationMapping
	
	IF OBJECT_ID(''tempdb..#LocalGLCategorizationMapping'') IS NOT NULL
	DROP TABLE #LocalGLCategorizationMapping
	
IF OBJECT_ID(''tempdb..#ProfitabilityOverhead'') IS NOT NULL
	DROP TABLE #ProfitabilityOverhead

IF OBJECT_ID(''tempdb..#ProfitabilityActual'') IS NOT NULL
	DROP TABLE #ProfitabilityActual

IF OBJECT_ID(''tempdb..#ConsolidationRegionCorporateDepartment'') IS NOT NULL
	DROP TABLE #ConsolidationRegionCorporateDepartment

END


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 03/08/2012 12:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*********************************************************************************************************************
Description
	This stored procedure processes actual transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
	1. Set the default unknown values to be used in the fact tables
	2. Get data exclusion lists (Manage Type tables) from GDM
	3. Source MRI data from USCORP, USPROP, EUCORP, EUPROP, INCORP, INPROP, BRCORP, BRPROP
	4. Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
	5. Map GDM GL Account Categorization Data
	6. Map General Ledger to GDM, HR and GACS mapping data
	7. Insert data into table representing schema of ProfitabilityActual
	8. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
	9. Clean up
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegion mapping as per CC16. Added the field to the 
											data inserted into the warehouse. 	
			2011-09-27		: PKayongo	:	Changed the General Ledger account mapping to new Categorizations (CC21)
			2011-11-14		: PKayongo	:	
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate	DateTime=NULL,
	@ImportEndDate		DateTime=NULL,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
PRINT ''####''
PRINT ''stp_IU_LoadGrProfitabiltyGeneralLedger''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
PRINT ''####''

IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = ''CanImportMRIActuals'') <> 1)
BEGIN
	PRINT (''Import of MRI Actuals is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...'')
	RETURN
END

IF (@ImportStartDate IS NULL)
	BEGIN
	SET @ImportStartDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualImportStartDate''))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
	SET @ImportEndDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualImportEndDate''))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = ''ActualDataPriorToDate''))
	END

/* ===========================================================================================================================================
	Set the default unknown values to be used in the fact tables - these are used when a join can''t be made to a dimension
   =========================================================================================================================================== */
   
DECLARE 
	@FunctionalDepartmentKeyUnknown INT,
	@ReimbursableKeyUnknown INT,
	@ActivityTypeKeyUnknown INT,
	@SourceKeyUnknown INT,
	@OriginatingRegionKeyUnknown INT,
	@AllocationRegionKeyUnknown INT,
	@PropertyFundKeyUnknown INT,
	@OverheadKeyUnknown INT,
	@GLCategorizationHierarchyKeyUnknown INT,
    @LocalCurrencyKeyUnknown INT
   
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = ''UNKNOWN'')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = ''UNKNOWN'')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = ''UNKNOWN'')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = ''UNKNOWN'')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = ''UNKNOWN'' AND SnapshotId = 0)
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = ''UNKNOWN'' AND SnapshotId = 0)
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = ''UNKNOWN'' AND SnapshotId = 0)
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = ''UNKNOWN'')
SET @LocalCurrencyKeyUnknown		= (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = ''UNK'')
SET @GLCategorizationHierarchyKeyUnknown  = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''UNKNOWN'' AND SnapshotId = 0)

DECLARE
	@UnknownUSPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Property'' AND SnapshotId = 0),
	@UnknownUSFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Fund'' AND SnapshotId = 0),
	@UnknownEUPropertyGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Property'' AND SnapshotId = 0),
	@UnknownEUFundGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''EU Fund'' AND SnapshotId = 0),
	@UnknownUSDevelopmentGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''US Development'' AND SnapshotId = 0),
	@UnknownGlobalGLCategorizationKey	INT = (SELECT GLCategorizationHierarchyKey FROM GrReporting.dbo.GLCategorizationHierarchy WHERE GLAccountName = ''UNKNOWN'' AND GLCategorizationName = ''Global'' AND SnapshotId = 0)




/* ==============================================================================================================================================
	Get data exclusion lists (Manage Type tables) from GDM
   =========================================================================================================================================== */
BEGIN
	
	/* Temp table creation and data inserts - Change Control 7
		The ManageType tables are used to exclude certain data from being inserted into the ProfitabilityActual fact table.
		ManageCorporateDepartment excludes Corporate Departments.
		ManageCorporateEntity excludes Corporate Entities.
		ManagePropertyDepartment excludes Property Departments.
		ManagePropertyEntity excludes Property Entities		
	*/

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManageType
	*/
	
CREATE TABLE #ManageType
(
	ManageTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL
)
INSERT INTO #ManageType
(
	ManageTypeId,
	Code
)
SELECT
	MT.ManageTypeId,
	MT.Code
FROM
	Gdm.ManageType MT
	INNER JOIN Gdm.ManageTypeActive(@DataPriorToDate) MTA ON
		MT.ImportKey = MTA.ImportKey
		
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManageCorporateDepartment
	*/		
		
CREATE TABLE #ManageCorporateDepartment
(
	ManageCorporateDepartmentId INT NOT NULL,
	CorporateDepartmentCode NCHAR(8) NOT NULL,
	SourceCode NCHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL
)
INSERT INTO #ManageCorporateDepartment
(
	ManageCorporateDepartmentId,
	CorporateDepartmentCode,
	SourceCode,
	IsDeleted 
)
SELECT
	MCD.ManageCorporateDepartmentId,
	MCD.CorporateDepartmentCode,
	MCD.SourceCode,
	MCD.IsDeleted 
FROM
	Gdm.ManageCorporateDepartment MCD
	INNER JOIN Gdm.ManageCorporateDepartmentActive(@DataPriorToDate) MCDA ON
		MCD.ImportKey = MCDA.ImportKey
	INNER JOIN #ManageType MT ON
		MCD.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = ''GMREXCL''

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManageCorporateEntity
	*/	
		
CREATE TABLE #ManageCorporateEntity
(
	ManageCorporateEntityId INT NOT NULL,
	CorporateEntityCode NCHAR(6) NOT NULL,
	SourceCode NCHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL
)
INSERT INTO #ManageCorporateEntity
(
	ManageCorporateEntityId,
	CorporateEntityCode,
	SourceCode,
	IsDeleted,
	InsertedDate
)
SELECT
	MCE.ManageCorporateEntityId,
	MCE.CorporateEntityCode,
	MCE.SourceCode,
	MCE.IsDeleted,
	MCE.InsertedDate
FROM
	Gdm.ManageCorporateEntity MCE
	INNER JOIN Gdm.ManageCorporateEntityActive(@DataPriorToDate) MCEA ON
		MCE.ImportKey = MCEA.ImportKey
	INNER JOIN #ManageType MT ON
		MCE.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = ''GMREXCL''

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManagePropertyDepartment
	*/	
	
CREATE TABLE #ManagePropertyDepartment
(
	ManagePropertyDepartmentId INT NOT NULL,
	PropertyDepartmentCode CHAR(8) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL
)
INSERT INTO #ManagePropertyDepartment
(
	ManagePropertyDepartmentId,
	PropertyDepartmentCode,
	SourceCode,
	IsDeleted 
)
SELECT
	MPD.ManagePropertyDepartmentId,
	MPD.PropertyDepartmentCode,
	MPD.SourceCode,
	MPD.IsDeleted
FROM
	Gdm.ManagePropertyDepartment MPD
	INNER JOIN Gdm.ManagePropertyDepartmentActive(@DataPriorToDate) MPDA ON
		MPD.ImportKey = MPDA.ImportKey
	INNER JOIN #ManageType MT ON
		MPD.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = ''GMREXCL''

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ManagePropertyEntity
	*/	
		
CREATE TABLE #ManagePropertyEntity
(
	ManagePropertyEntityId INT NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	IsDeleted BIT NOT NULL,
)
INSERT INTO #ManagePropertyEntity(
	ManagePropertyEntityId,
	PropertyEntityCode,
	SourceCode,
	IsDeleted
)
SELECT
	MPE.ManagePropertyEntityId,
	MPE.PropertyEntityCode,
	MPE.SourceCode,
	MPE.IsDeleted
FROM
	Gdm.ManagePropertyEntity MPE
	INNER JOIN Gdm.ManagePropertyEntityActive(@DataPriorToDate) MPEA ON
		MPE.ImportKey = MPEA.ImportKey
	INNER JOIN #ManageType MT ON
		MPE.ManageTypeId = MT.ManageTypeId
WHERE
	MT.Code = ''GMREXCL''
	
END

/* =============================================================================================================================================
	Source MRI data from USCORP, USPROP, EUCORP, EUPROP, INCORP, INPROP, BRCORP, BRPROP
   =========================================================================================================================================== */

BEGIN   

CREATE TABLE #ProfitabilityGeneralLedger
(
	SourcePrimaryKey VARCHAR(100) NULL,
	SourceTableId INT NOT NULL,
	SourceTableName VARCHAR(20) NULL,
	SourceCode VARCHAR(2) NOT NULL,
	Period CHAR(6) NOT NULL,
	OriginatingRegionCode CHAR(6) NOT NULL,
	PropertyFundCode CHAR(12) NOT NULL,
	FunctionalDepartmentCode CHAR(15) NULL,
	JobCode CHAR(15) NULL,
	GlAccountCode CHAR(12) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual MONEY NOT NULL,
	EnterDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	Basis CHAR(1) NOT NULL,
	LastDate DATETIME NULL,
	GlAccountSuffix VARCHAR(2) NULL,
	NetTSCost CHAR(1) NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		US-PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	''USD'' AS ForeignCurrency,
	Gl.Amount AS ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM 
	USProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.EntityId
				FROM
					USProp.ENTITY En
					INNER JOIN USProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					USProp.GACC Ga
					INNER JOIN USProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM 

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND -- Make sure the transaction is within the window
	Gl.Basis IN (''A'',''B'') AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND -- Ensures that there is no Corporate Department associated with the record
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99'' AND -- Makes sure the transaction is doesn''t have a Corporate Overhead activity type
	( -- Change Control 6
		ISNULL(Ga.IsGR, ''N'') = ''Y'' -- Ensures that the GLAccount is a GR account
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.IsDeleted,
									PEAI.SourceCode
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = ''US'')
	) AND
	
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = ''US'' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = ''US'' AND
			MPD.IsDeleted = 0
	)

PRINT ''US PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		US CORP
	*/	

INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,

	''USD'' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM USCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					USCorp.ENTITY En
					INNER JOIN USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		Gl.RegionCode = En.ENTITYID  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					USCorp.GACC Ga
					INNER JOIN USCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
				
	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					USCorp.GDEP Gd
					INNER JOIN USCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	-- En.Name	NOT LIKE ''%Intercompany%'' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR,0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = ''UC''
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = ''UC''
	)
	
PRINT ''US CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		EU PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = ''PLZ'' THEN ''PLN'' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.Description, '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'',-- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM EUProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID,
					En.CURRCODE
				FROM
					EUProp.ENTITY En
					INNER JOIN EUProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId  

	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					EUProp.GACC Ga
					INNER JOIN EUProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	-- En.Name	NOT LIKE ''%Intercompany%'' AND -- Change Control 7: IS - removed
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99'' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, ''N'') = ''Y''
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.IsDeleted,
									PEAI.SourceCode
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = ''EU'')
	) AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = ''EU'' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = ''EU'' AND
			MPD.IsDeleted = 0
	)

PRINT ''EU PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		EU CORP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode, 
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription, 
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = ''PLZ'' THEN ''PLN'' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount, 0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
	
FROM 
	EUCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID,
					En.CURRCODE
				FROM
					EUCorp.ENTITY En
					INNER JOIN EUCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
				
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					GA.ISGR
				FROM
					EUCorp.GACC Ga
					INNER JOIN EUCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					EUCorp.GDEP Gd
					INNER JOIN EUCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	-- En.Name	NOT LIKE ''%Intercompany%'' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	Gl.BALFOR <> ''B'' --AND
	--Change Control 1 : GC 2010-09-01
	AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = ''EC''
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = ''EC''
	)
	
PRINT ''EU CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		BR PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.Description, '''')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	BRProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					BRProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					BRProp.ENTITY En
					INNER JOIN BRProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					GA.ISGR
				FROM
					BRProp.GACC Ga
					INNER JOIN BRProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND

	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source]	= ''GR'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99'' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, ''N'') = ''Y''
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.IsDeleted,
									PEAI.SourceCode
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = ''BR'')
	) AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = ''BR'' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN 
		( -- exclude Property Department
	
			SELECT
				MPD.PropertyDepartmentCode
			FROM
				#ManagePropertyDepartment MPD
			WHERE
				MPD.SourceCode = ''BR'' AND
				MPD.IsDeleted = 0
		)

PRINT ''BR PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		BR CORP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	''BRL'' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '''')),
	RTRIM(IsNull(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM 
	BRCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
				FROM
						BRCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.EntityId
				FROM
					BRCorp.ENTITY En
					INNER JOIN BRCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					BRCorp.GACC Ga
					INNER JOIN BRCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					BRCorp.GDEP Gd
					INNER JOIN BRCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	ISNULL(Ga.IsGR,0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source] = ''GR''	AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = ''BC''
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = ''BC''
	)
	

PRINT ''BR CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		CN PROP
	*/	
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	ISNULL(Em.LocalEntityRef, Gl.PropertyFundCode) PropertyFundCode, --Generic convert 7char to 6char EntityID
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '''')),
	RTRIM(IsNull(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND
		Gl.SourceTableId = t1.SourceTableId  

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.PropertyFundCode = En.EntityId  
			
	INNER JOIN (
				SELECT
					Em.OriginalEntityRef,
					Em.[Source],
					Em.LocalEntityRef
				FROM
					GACS.EntityMapping Em
					INNER JOIN GACS.EntityMappingActive(@DataPriorToDate) EmA ON
						Em.ImportKey = EmA.ImportKey  
				) Em ON
		Gl.PropertyFundCode = Em.OriginalEntityRef  AND
		Gl.SourceCode = Em.[Source] -- this should filter EntityMapping by source of ''CN'', because Gl.SourceCode will always be this
			
	LEFT OUTER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					CNProp.GACC Ga
					INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	-- En.Name	NOT LIKE ''%Intercompany%'' AND -- Change Control 7: IS - removed
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99'' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, ''N'') = ''Y''
			OR
		Ga.ACCTNUM IN 
			( 
				SELECT
					PEAI.GLAccountCode
				FROM
					(
						SELECT
							PEAI.PropertyEntityCode,
							PEAI.GLAccountCode,
							PEAI.SourceCode,
							PEAI.IsDeleted
						FROM							
							Gdm.PropertyEntityGLAccountInclusion PEAI
							INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
								PEAI.ImportKey = PEAIA.ImportKey
					) PEAI
				WHERE
					PEAI.PropertyEntityCode = 
						CASE --Gl.PropertyFundCode AND
							WHEN LTRIM(RTRIM(Gl.PropertyFundCode)) = LTRIM(RTRIM(Em.OriginalEntityRef)) 
								THEN Em.LocalEntityRef 
							ELSE Gl.PropertyFundCode
						END AND							
					PEAI.IsDeleted = 0 AND
					PEAI.SourceCode = ''CN''
			)
	) AND
	-- Change Control 7: IS - begin
			
	CASE --Gl.PropertyFundCode NOT IN ( -- exclude Property Entity
		WHEN LTRIM(RTRIM(Gl.PropertyFundCode)) = LTRIM(RTRIM(Em.OriginalEntityRef)) THEN Em.LocalEntityRef ELSE Gl.PropertyFundCode
	END NOT IN (

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = ''CN'' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = ''CN'' AND
			MPD.IsDeleted = 0
	)


PRINT ''CH PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		CN CORP
	*/

INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, ''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					CNCorp.ENTITY En
					INNER JOIN CNCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					CNCorp.GACC Ga
					INNER JOIN CNCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  

	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					CNCorp.GDEP Gd
					INNER JOIN CNCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT 
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	ISNULL(Ga.IsGR,0) = ''Y'' AND
	Gl.BALFOR <> ''B'' --AND
	AND

	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = ''CC''
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = ''CC''
	)
	
	
PRINT ''CH CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		IN PROP
	*/
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	''N'', -- Transactions from the Property database are reimbursable
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INProp.GeneralLedger Gl
	INNER JOIN 
		(
			--This allows JOURNAL&GHIS to each have a record with the same PK,
			--but that is incorrect data and as such GR will pick GHIS as the 
			--more accurate data, for it is posted data, where journal data is still open data
			SELECT
				SourcePrimaryKey,
				MAX(SourceTableId) SourceTableId
			FROM
				INProp.GeneralLedger Gl
			GROUP BY
				SourcePrimaryKey
		) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId 

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					INProp.ENTITY En
					INNER JOIN INProp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey 
				) En ON
		Gl.PropertyFundCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					GA.ISGR
				FROM
					INProp.GACC Ga
					INNER JOIN INProp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM 
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	ISNULL(Gl.CorporateDepartmentCode, ''N'') = ''N'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source] = ''GR'' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99'' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, ''N'') = ''Y''
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.GLAccountCode,
									PEAI.PropertyEntityCode,
									PEAI.SourceCode,
									PEAI.IsDeleted
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAI.ImportKey = PEAIA.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = ''IN'')
	) AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Property Entity

		SELECT
			MPE.PropertyEntityCode
		FROM
			#ManagePropertyEntity MPE
		WHERE
			MPE.SourceCode = ''IN'' AND
			MPE.IsDeleted = 0

	) AND
	(LTRIM(RTRIM(Gl.RegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))) NOT IN ( -- exclude Property Department
	
		SELECT
			MPD.PropertyDepartmentCode
		FROM
			#ManagePropertyDepartment MPD
		WHERE
			MPD.SourceCode = ''IN'' AND
			MPD.IsDeleted = 0
	)


PRINT ''IN PROP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		IN CORP
	*/
	
INSERT INTO #ProfitabilityGeneralLedger
(
	SourcePrimaryKey,
	SourceTableId,
	SourceTableName,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceTable,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '''')),
	RTRIM(ISNULL(Gl.[Description], '''')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,''N'') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					INCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		Gl.SourcePrimaryKey = t1.SourcePrimaryKey AND 
		Gl.SourceTableId = t1.SourceTableId  

	INNER JOIN ( -- Restricts to data that is mapped to Entities that exist in MRI
				SELECT
					En.ENTITYID
				FROM
					INCorp.ENTITY En
					INNER JOIN INCorp.EntityActive(@DataPriorToDate) EnA ON
						En.ImportKey = EnA.ImportKey  
				) En ON
		Gl.RegionCode = En.EntityId  
			
	INNER JOIN ( -- Restricts to data that is mapped to GL Accounts that exist in MRI
				SELECT
					Ga.ACCTNUM,
					Ga.ISGR
				FROM
					INCorp.GACC Ga
					INNER JOIN INCorp.GAccActive(@DataPriorToDate) GaA ON
						Ga.ImportKey = GaA.ImportKey  
				) Ga ON
		Gl.GlAccountCode = Ga.ACCTNUM  
				
	INNER JOIN ( -- Restricts to data that is mapped to Departments that exist in MRI
				SELECT
					Gd.DEPARTMENT,
					Gd.NETTSCOST
				FROM
					INCorp.GDEP Gd
					INNER JOIN INCorp.GDepActive(@DataPriorToDate) GdA ON
						Gd.ImportKey = GdA.ImportKey  
				) Gd ON
		Gl.PropertyFundCode = Gd.DEPARTMENT  
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN (''A'',''B'') AND
	-- En.Name	NOT LIKE ''%Intercompany%'' AND -- Change Control 7: IS - removed
	ISNULL(Ga.IsGR, 0) = ''Y'' AND
	Gl.BALFOR <> ''B'' AND
	Gl.[Source] = ''GR'' --AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> ''99''
	AND
	-- Change Control 7: IS - begin
	
	Gl.PropertyFundCode NOT IN ( -- exclude Corporate Department
		
		SELECT
			MCD.CorporateDepartmentCode
		FROM
			#ManageCorporateDepartment MCD
		WHERE
			MCD.IsDeleted = 0 AND
			MCD.SourceCode = ''IC''
	
	) AND
	Gl.RegionCode NOT IN ( -- exclude Corporate Entity
	
		SELECT
			MCE.CorporateEntityCode
		FROM
			#ManageCorporateEntity MCE
		WHERE
			MCE.IsDeleted = 0 AND
			MCE.SourceCode = ''IC''
	)
	

PRINT ''IN CORP:Rows Inserted Into #ProfitabilityGeneralLedger:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityGeneralLedger_Clustered ON #ProfitabilityGeneralLedger (UpdatedDate, FunctionalDepartmentCode, JobCode, GlAccountCode, SourceCode, Period, OriginatingRegionCode, PropertyFundCode, SourcePrimaryKey)

PRINT ''Completed building clustered index on #ProfitabilityGeneralLedger''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

END

/* =============================================================================================================================================
	Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
   =========================================================================================================================================== */
BEGIN

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The Functional Department table is used to map the transactions to their relevant Functional Departments.	
	*/ 
	
CREATE TABLE #FunctionalDepartment
(
	FunctionalDepartmentId INT NOT NULL,
	Code VARCHAR(31) NOT NULL,
	GlobalCode CHAR(3) NULL
)
INSERT INTO #FunctionalDepartment(
	FunctionalDepartmentId,
	Code,
	GlobalCode
)
SELECT
	Fd.FunctionalDepartmentId,
	Fd.Code,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		Fd.ImportKey = FdA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_FunctionalDepartment_FunctionalDepartmentId ON #FunctionalDepartment(FunctionalDepartmentId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#Department
	*/ 
			
CREATE TABLE #Department
(
	Department CHAR(8) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL,
)
INSERT INTO #Department(
	Department,
	[Source],
	FunctionalDepartmentId
)
SELECT
	Dpt.DepartmentCode,
	Dpt.[Source],
	Dpt.FunctionalDepartmentId
FROM Gdm.Department Dpt
	INNER JOIN Gdm.DepartmentActive(@DataPriorToDate) DptA ON
		Dpt.ImportKey = DptA.ImportKey
WHERE
	Dpt.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Department_Department ON #Department (Department, [Source])
	
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#JobCode
	*/ 

CREATE TABLE #JobCode
(
	JobCode VARCHAR(15) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL
) 
INSERT INTO #JobCode
(
	JobCode,
	[Source],
	FunctionalDepartmentId
)
SELECT
	Jc.JobCode,
	Jc.[Source],
	Jc.FunctionalDepartmentId
FROM
	GACS.JobCode Jc
	INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON
		Jc.ImportKey = JcA.ImportKey
WHERE
	Jc.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_JobCode_JobCode ON #JobCode (JobCode, [Source])

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ActivityType
	*/ 
	
CREATE TABLE #ActivityType
(
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	GLAccountSuffix char(2) NULL
)
INSERT INTO #ActivityType(
	ActivityTypeId,
	ActivityTypeCode,
	GLAccountSuffix
)
SELECT
	At.ActivityTypeId,
	At.Code,
	At.GLAccountSuffix
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		At.ImportKey = Ata.ImportKey
WHERE
	AT.IsActive = 1

CREATE UNIQUE CLUSTERED INDEX IX_ActivityType_ActivityTypeId ON #ActivityType (ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #OriginatingRegionCorporateEntity and #OriginatingRegionPropertyDepartment tables are used to determine the Originating Regions of 
		transactions.
	*/
	
CREATE TABLE #OriginatingRegionCorporateEntity
( -- GDM 2.0 addition
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #OriginatingRegionCorporateEntity
(
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode
)
SELECT
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCE.ImportKey = ORCEA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionCorporateEntity_CorporateEntity ON #OriginatingRegionCorporateEntity(CorporateEntityCode, SourceCode)

CREATE TABLE #OriginatingRegionPropertyDepartment
( -- GDM 2.0 addition
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL
)
INSERT INTO #OriginatingRegionPropertyDepartment
(
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode
)
SELECT
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPD.ImportKey = ORPDA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_OriginatingRegionPropertyDepartment_PropertyDepartment ON #OriginatingRegionPropertyDepartment(PropertyDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The PropertyFundMapping table is used to determine the PropertyFund of Overhead transactions.
		Note: This only maps the PropertyFund for transactions before period 201007	
	*/
	
CREATE TABLE #PropertyFundMapping
(
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)
INSERT INTO #PropertyFundMapping(
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	IsDeleted,
	ActivityTypeId
)
SELECT
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		Pfm.ImportKey = PfmA.ImportKey
WHERE
	Pfm.IsDeleted = 0

CREATE UNIQUE CLUSTERED INDEX UX_PropertyFundMapping_PropertyFund ON #PropertyFundMapping (PropertyFundCode, SourceCode, ActivityTypeId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyFund table is used to map transactions to their Property Fund and find the Allocation Sub Region of a transaction.
	*/

CREATE TABLE #PropertyFund
( -- GDM 2.0 change
	PropertyFundId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL
)
INSERT INTO #PropertyFund(
	PropertyFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	[Name]
)
SELECT
	PF.PropertyFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.[Name]
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PF.ImportKey = PFA.ImportKey
WHERE
	PF.IsActive = 1

CREATE UNIQUE CLUSTERED INDEX IX_PropertyFund_PropertyFundId ON #PropertyFund (PropertyFundId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingEntityCorporateDepartment and #ReportingEntityPropertyEntity tables are used to determine the Property Funds of
		transactions (Property Funds are used to determine the Allocation Sub Region).
	*/
	
CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL

)
INSERT INTO	#ReportingEntityCorporateDepartment
(
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode
)
SELECT
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECD.ImportKey = RECDA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityCorporateDepartment_CorporateDepartment ON #ReportingEntityCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ReportingEntityPropertyEntity	
	*/

CREATE TABLE #ReportingEntityPropertyEntity
( -- GDM 2.0 addition
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL
)
INSERT INTO #ReportingEntityPropertyEntity
(
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode
)
SELECT
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPE.ImportKey = REPEA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ReportingEntityPropertyEntity_PropertyEntity ON #ReportingEntityPropertyEntity(PropertyEntityCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ConsolidationRegionCorporateDepartment and #ConsolidationRegionPropertyEntity tables are used to determine the Consolidation 
		Region of a transaction.
	*/
	
CREATE TABLE #ConsolidationRegionCorporateDepartment
( -- GDM 2.0 addition
	ConsolidationRegionCorporateDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL
)
INSERT INTO	#ConsolidationRegionCorporateDepartment
(
	ConsolidationRegionCorporateDepartmentId,
	GlobalRegionId,
	SourceCode,
	CorporateDepartmentCode
)
SELECT
	CRCD.ConsolidationRegionCorporateDepartmentId,
	CRCD.GlobalRegionId,
	CRCD.SourceCode,
	CRCD.CorporateDepartmentCode
FROM
	Gdm.ConsolidationRegionCorporateDepartment CRCD
	INNER JOIN Gdm.ConsolidationRegionCorporateDepartmentActive(@DataPriorToDate) CRCDA ON
		CRCD.ImportKey = CRCDA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionCorporateDepartment_CorporateDepartment ON #ConsolidationRegionCorporateDepartment(CorporateDepartmentCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#ConsolidationRegionPropertyEntity
	*/
	
CREATE TABLE #ConsolidationRegionPropertyEntity
( -- GDM 2.0 addition
	ConsolidationRegionPropertyEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL
)
INSERT INTO #ConsolidationRegionPropertyEntity
(
	ConsolidationRegionPropertyEntityId,
	GlobalRegionId,
	SourceCode,
	PropertyEntityCode
)
SELECT
	CRPE.ConsolidationRegionPropertyEntityId,
	CRPE.GlobalRegionId,
	CRPE.SourceCode,
	CRPE.PropertyEntityCode
FROM
	Gdm.ConsolidationRegionPropertyEntity CRPE
	INNER JOIN Gdm.ConsolidationRegionPropertyEntityActive(@DataPriorToDate) CRPEA ON
		CRPE.ImportKey = CRPEA.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationRegionPropertyEntity_PropertyEntity ON #ConsolidationRegionPropertyEntity(PropertyEntityCode, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #AllocationSubRegion table is used to filter GlobalRegion to make sure the Allocation Sub Region specified by the #PropertyFund
		table is flagged as an Allocation Region in the GlobalRegion table in GDM.	
	*/

CREATE TABLE #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL
)
INSERT INTO #AllocationSubRegion
(
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	AllocationRegionGlobalRegionId
)
SELECT
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.AllocationRegionGlobalRegionId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON 
		ASR.ImportKey = ASRA.ImportKey
WHERE
	ASR.IsActive = 1
	
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ConsolidationSubRegion table is used to filter GlobalRegion to make sure the Consolidation Sub Region specified by the #PropertyFund
		table is flagged as an Consolidation Region in the GlobalRegion table in GDM.	
	*/
		
CREATE TABLE #ConsolidationSubRegion
(
	ConsolidationSubRegionGlobalRegionId INT NOT NULL,
	ConsolidationSubRegionGlobalRegionCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ConsolidationRegionGlobalRegionId INT NULL
)
INSERT INTO #ConsolidationSubRegion
(
	ConsolidationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionCode,
	[Name],
	ConsolidationRegionGlobalRegionId
)
SELECT
	CSR.ConsolidationSubRegionGlobalRegionId,
	CSR.ConsolidationSubRegionGlobalRegionCode,
	CSR.[Name],
	CSR.ConsolidationRegionGlobalRegionId
FROM
	Gdm.ConsolidationSubRegion CSR
	INNER JOIN	Gdm.ConsolidationSubRegionActive(@DataPriorToDate) CSRA ON 
		CSR.ImportKey = CSRA.ImportKey
WHERE
	CSR.IsActive = 1
	
CREATE UNIQUE CLUSTERED INDEX UX_ConsolidationSubRegion_ConsolidationSubRegionGlobalRegionId ON #ConsolidationSubRegion(ConsolidationSubRegionGlobalRegionId)
	
	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #JobCodeFunctionalDepartment gets the Functional Department dimension data in the warehouse. It is used to resolve the dimension
		keys when mapping Job Codes
	*/

CREATE TABLE #JobCodeFunctionalDepartment
(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)
INSERT INTO #JobCodeFunctionalDepartment
(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE
	FunctionalDepartmentCode <> SubFunctionalDepartmentCode
	
CREATE UNIQUE CLUSTERED INDEX IX_JobCodeFunctionalDepartment_ReferenceCode ON #JobCodeFunctionalDepartment(ReferenceCode, StartDate, EndDate)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #JobCodeFunctionalDepartment gets the Functional Department dimension data in the warehouse. It is used to resolve the dimension
		keys when mapping Functional Departments
	*/

CREATE TABLE #ParentFunctionalDepartment
(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)
INSERT INTO #ParentFunctionalDepartment
(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE (
		FunctionalDepartmentCode = SubFunctionalDepartmentCode
		OR 
		ReferenceCode = FunctionalDepartmentCode+'':UNKNOWN''
	  )
	  
END



/* =============================================================================================================================================
	Map GDM GL Account Categorization Data
   =========================================================================================================================================== */
 BEGIN
 
 	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorizationType
	*/
	 
CREATE TABLE #GLCategorizationType
(
	GLCategorizationTypeId INT NOT NULL
)
INSERT INTO #GLCategorizationType
(
	GLCategorizationTypeId
)
SELECT
	GLCategorizationTypeId
FROM
	Gdm.GLCategorizationType GCT
	INNER JOIN Gdm.GLCategorizationTypeActive(@DataPriorToDate) GCTA ON
		GCT.ImportKey = GCTA.ImportKey

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLCategorization
	*/
	
CREATE TABLE #GLCategorization
(
	GLCategorizationId INT NOT NULL,
	GLCategorizationTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	RechargeSourceCode CHAR(2) NULL,
	IsConfiguredForRecharge BIT NULL
)
INSERT INTO #GLCategorization
(
	GLCategorizationId,
	GLCategorizationTypeId,
	Name,
	RechargeSourceCode,
	IsConfiguredForRecharge
)
SELECT
	Cat.GLCategorizationId,
	Cat.GLCategorizationTypeId,
	Cat.Name,
	Cat.RechargeSourceCode,
	Cat.IsConfiguredForRecharge
FROM
	Gdm.GLCategorization Cat
	INNER JOIN Gdm.GLCategorizationActive(@DataPriorToDate) CatA ON
		Cat.ImportKey = CatA.ImportKey


CREATE UNIQUE CLUSTERED INDEX IX_GLCategorization_GLCategorizationId ON #GLCategorization (GLCategorizationId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLFinancialCategory	
	*/
	
CREATE TABLE #GLFinancialCategory
(
	GLFinancialCategoryId INT NOT NULL,
	GLCategorizationId INT NOT NULL
)	

INSERT INTO #GLFinancialCategory
(
	GLFinancialCategoryId,
	GLCategorizationId
)
SELECT
	GFC.GLFinancialCategoryId,
	GFC.GLCategorizationId
FROM
	Gdm.GLFinancialCategory GFC
	INNER JOIN Gdm.GLFinancialCategoryActive(@DataPriorToDate) GFCA ON
		GFC.ImportKey = GFCA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_GLFinancialCategory_GLFinancialCategoryId ON #GLFinancialCategory (GLFinancialCategoryId)


	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMajorCategory	
	*/

CREATE TABLE #GLMajorCategory
(
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(400) NOT NULL,
	GLCategorizationId INT NOT NULL,
	GLFinancialCategoryId INT NOT NULL
)
INSERT INTO #GLMajorCategory
(
	GLMajorCategoryId,
	Name,
	GLCategorizationId,
	GLFinancialCategoryId
)
SELECT
	MajC.GLMajorCategoryId,
	MajC.Name,
	MajC.GLCategorizationId,
	MajC.GLFinancialCategoryId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey
WHERE
	MajC.IsActive = 1
			
CREATE UNIQUE CLUSTERED INDEX IX_GLMajorCategory_GLMajorCategoryId ON #GLMajorCategory (GLMajorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		#GLMinorCategory	
	*/
	
CREATE TABLE #GLMinorCategory
(
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(400) NOT NULL
)
INSERT INTO #GLMinorCategory
(
	GLMinorCategoryId,
	GLMajorCategoryId,
	Name
)
SELECT
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	MinC.Name
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinC.ImportKey = MinCA.ImportKey
WHERE
	MinC.IsActive = 1

CREATE UNIQUE CLUSTERED INDEX IX_GLMinorCategory_GLMinorCategoryId ON #GLMinorCategory (GLMinorCategoryId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccountCategorization table is used to map Global Accounts to Minor Categories for the relevant Categorizations	
	*/
	
CREATE TABLE #GLGlobalAccountCategorization
(
	GLGlobalAccountCategorizationId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLCategorizationId INT NULL,
	DirectGLMinorCategoryId INT NULL,
	IndirectGLMinorCategoryId INT NULL,
	CoAGLMinorCategoryId INT NULL
)
INSERT INTO #GLGlobalAccountCategorization
(
	GLGlobalAccountCategorizationId,
	GLGlobalAccountId,
	GLCategorizationId,
	DirectGLMinorCategoryId,
	IndirectGLMinorCategoryId,
	CoAGLMinorCategoryId
)
SELECT
	GCat.GLGlobalAccountCategorizationId,
	GCat.GLGlobalAccountId,
	GCat.GLCategorizationId,
	GCat.DirectGLMinorCategoryId,
	GCat.IndirectGLMinorCategoryId,
	GCat.CoAGLMinorCategoryId
FROM
	Gdm.GLGlobalAccountCategorization GCat
	INNER JOIN Gdm.GLGlobalAccountCategorizationActive(@DataPriorToDate) GCatA ON
		GCat.ImportKey = GCatA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_GLGlobalAccountCategorization_GLGlobalAccount ON #GLGlobalAccountCategorization (GLGlobalAccountId, GLCategorizationId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLGlobalAccount table is used to map local GL Accounts to their Global accounts.
	*/
	
CREATE TABLE #GLGlobalAccount
(
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	Code VARCHAR(10) NOT NULL
)
INSERT INTO #GLGlobalAccount
(
	GLGlobalAccountId,
	ActivityTypeId,
	Code
)
SELECT
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.Code
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLA.ImportKey = GLAA.ImportKey
WHERE
	GLA.IsActive = 1
	
CREATE UNIQUE CLUSTERED INDEX UX_GLGlobalAccount_GLGlobalAccountId ON #GLGlobalAccount (GLGlobalAccountId)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #GLAccount table is used to map local GL Accounts to their Global accounts.
	*/
	
CREATE TABLE #GLAccount
(
	GLAccountId int NOT NULL,
	GLGlobalAccountId int NULL,
	Code varchar(15) NOT NULL,
	SourceCode char(2) NOT NULL,
	IsGlobalReporting BIT NOT NULL
)
INSERT INTO #GLAccount
(
	GLAccountId,
	GLGlobalAccountId,
	Code,
	SourceCode,
	IsGlobalReporting
)
SELECT
	GLAccountId,
	GLGlobalAccountId,
	Code,
	SourceCode,
	IsGlobalReporting
FROM
	Gdm.GLAccount GL
	
	INNER JOIN Gdm.GLAccountActive(@DataPriorToDate) GLA ON
		GL.ImportKey = GLA.ImportKey
WHERE
	GL.IsActive = 1
	
CREATE UNIQUE CLUSTERED INDEX UX_GLAccount_AccountCode ON #GLAccount(Code, SourceCode)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #ReportingCategorization is used to determine the default categorization to be shown in local reports based on the EntityType and
		Allocation sub region.
	*/
	
CREATE TABLE #ReportingCategorization
(
	ReportingCategorizationId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	GLCategorizationId INT NOT NULL
)
INSERT INTO #ReportingCategorization
(
	ReportingCategorizationId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	GLCategorizationId
)
SELECT
	RC.ReportingCategorizationId,
	RC.EntityTypeId,
	RC.AllocationSubRegionGlobalRegionId,
	RC.GLCategorizationId
FROM
	Gdm.ReportingCategorization RC 
	INNER JOIN Gdm.ReportingCategorizationActive(@DataPriorToDate) RCa ON
		RC.ImportKey = RCa.ImportKey
		
CREATE UNIQUE CLUSTERED INDEX IX_ReportingCategorization_Categorization ON #ReportingCategorization (EntityTypeId, AllocationSubRegionGlobalRegionId)

PRINT ''Completed inserting active records into temp table''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The #PropertyPayrollPropertyGLAccount is used to map payroll transactions to their local GL Accounts for the local categorizations
	*/

CREATE TABLE #PropertyPayrollPropertyGLAccount
(
	GLCategorizationId INT NOT NULL,
	PayrollTypeId INT NOT NULL,
	ActivityTypeId INT NULL,
	FunctionalDepartmentId INT NULL,
	PropertyGLAccountId INT NULL,
	GLGlobalAccountId INT NULL,
	GLMinorCategoryId INT NULL
)
INSERT INTO #PropertyPayrollPropertyGLAccount
(
	GLCategorizationId,
	PayrollTypeId,
	ActivityTypeId,
	FunctionalDepartmentId,
	PropertyGLAccountId,
	GLGlobalAccountId,
	GLMinorCategoryId
)
SELECT
	PPPGA.GLCategorizationId,
	PPPGA.PayrollTypeId,
	PPPGA.ActivityTypeId,
	PPPGA.FunctionalDepartmentId,
	PPPGA.PropertyGLAccountId,
	PPPGA.GLGlobalAccountId,
	PPPGA.GLMinorCategoryId
FROM
	Gdm.PropertyPayrollPropertyGLAccount PPPGA
	
	INNER JOIN Gdm.PropertyPayrollPropertyGLAccountActive(@DataPriorToDate) PPPGAa ON
		PPPGA.ImportKey = PPPGAa.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_PropertyPayrollPropertyGLAccount_Unique ON #PropertyPayrollPropertyGLAccount
	(
		GLCategorizationId,
		PayrollTypeId,
		GLMinorCategoryId,
		ActivityTypeId,
		FunctionalDepartmentId
	)

	/*  ----------------------------------------------------------------------------------------------------------------------------------------
		The ##GLMinorCategoryPayrollType is used to map a GL Minor Category to a payroll type
	*/
	
CREATE TABLE #GLMinorCategoryPayrollType
(
	GLMinorCategoryId INT NOT NULL,
	PayrollTypeId INT NOT NULL
)
INSERT INTO #GLMinorCategoryPayrollType
(
	GLMinorCategoryId,
	PayrollTypeId
)
SELECT
	GLMinorCategoryId,
	PayrollTypeId
FROM
	Gdm.GLMinorCategoryPayrollType MCPT
	
	INNER JOIN Gdm.GLMinorCategoryPayrollTypeActive(@DataPriorToDate) MCPTa	ON
		MCPT.ImportKey = MCPTa.ImportKey

CREATE UNIQUE CLUSTERED INDEX UX_GLMinorCategoryPayrollType_GLMinorCategoryId_PayrollTypeId ON #GLMinorCategoryPayrollType
	(
		GLMinorCategoryId,
		PayrollTypeId
	)
	
	/*	-------------------------------------------------------------------------------------------------------------------------
		Global Categorization Payroll Mappings
		
		Gets global Major and Minor Catetgory combinations
	*/

CREATE TABLE #PayrollGlobalMappings
(
	GLMinorCategoryName VARCHAR(120) NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryName VARCHAR(120) NOT NULL,
	GLMajorCategoryId INT NOT NULL
)

INSERT INTO #PayrollGlobalMappings
(
	GLMinorCategoryName,
	GLMinorCategoryId,
	GLMajorCategoryName,
	GLMajorCategoryId
)
SELECT DISTINCT
	MinC.Name AS GLMinorCategoryName,
	MinC.GLMinorCategoryId AS GLMinorCategoryId,
	MajC.Name AS GLMajorCategoryName,
	MajC.GLMajorCategoryId GLMajorCategoryId
FROM
	#GLMinorCategory MinC
	
	INNER JOIN #GLMajorCategory MajC ON
		MinC.GLMajorCategoryId = MajC.GLMajorCategoryId
WHERE
	(
		MajC.Name = ''Salaries/Taxes/Benefits'' OR
		(
			MinC.Name = ''External General Overhead'' AND
			MajC.Name = ''General Overhead''
		)
	) AND
	MajC.GLCategorizationId = 233

/*

The following table gets the Global Account Categorization mapping data from GDM, and pivots the data so that the first row has the 
Global Account Id and each column represents the a GL Categorization Hierarchy code for one of the GL Categorizations.

The purpose of having the table like this is to avoid joining onto the fact table multiple times.

*/

CREATE TABLE #GlAccountCategoryMapping 
(
	GLGlobalAccountId INT NOT NULL,
	IsDirect BIT NOT NULL,
	GlobalGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	
)
INSERT INTO #GlAccountCategoryMapping
(
	GLGlobalAccountId,
	IsDirect,
	GlobalGLCategorizationHierarchyCode,
	USPropertyGLCategorizationHierarchyCode,
	USFundGLCategorizationHierarchyCode,
	EUPropertyGLCategorizationHierarchyCode,
	EUFundGLCategorizationHierarchyCode,
	USDevelopmentGLCategorizationHierarchyCode,
	EUDevelopmentGLCategorizationHierarchyCode
)
SELECT
	PivotTable.GLGlobalAccountId,
	PivotTable.IsDirectCost,
	PivotTable.[Global] AS GlobalGLCategorizationHierarchyCode,
	PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyCode,
	PivotTable.[US Fund] AS USFundGLCategorizationHierarchyCode,
	PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyCode,
	PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyCode,
	PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyCode,
	PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyCode
FROM
	(	
	-- Union to deal with both Direct mappings and Indirect mappings
		SELECT
			GGA.GLGlobalAccountId,
			GLC.Name AS GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GLCT.GLCategorizationTypeId, -1)) + '':'' +
				CONVERT(VARCHAR(10), ISNULL(GLC.GLCategorizationId, -1)) + '':'' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END)  + '':'' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
				CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode,
			
			0 AS IsDirectCost
		FROM
			#GLGlobalAccount GGA
			
			LEFT OUTER JOIN #GLCategorization GLC ON
				GLC.GLCategorizationId = GLC.GLCategorizationId  
			
			LEFT OUTER JOIN #GLCategorizationType GLCT ON
				GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId 
				
			LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
				GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId AND
				GLC.GLCategorizationId = GLGAC.GLCategorizationId
				
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				GLGAC.IndirectGLMinorCategoryId = MinC.GLMinorCategoryId
				
			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	
			
			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId  
			
				
		UNION
		
		SELECT
			GGA.GLGlobalAccountId,
			GLC.Name AS GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GLCT.GLCategorizationTypeId, -1)) + '':'' +
				CONVERT(VARCHAR(10), ISNULL(GLC.GLCategorizationId, -1)) + '':'' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE FinC.GLFinancialCategoryId END) + '':'' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MajC.GLMajorCategoryId END)  + '':'' +
				CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE MinC.GLMinorCategoryId END) + '':'' +
				CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode,
			
			1 AS IsDirectCost
		FROM
			#GLGlobalAccount GGA
			
			LEFT OUTER JOIN #GLCategorization GLC ON
				GLC.GLCategorizationId = GLC.GLCategorizationId  
			
			LEFT OUTER JOIN #GLCategorizationType GLCT ON
				GLC.GLCategorizationTypeId = GLCT.GLCategorizationTypeId 
				
			LEFT OUTER JOIN #GLGlobalAccountCategorization GLGAC ON
				GGA.GLGlobalAccountId = GLGAC.GLGlobalAccountId AND
				GLC.GLCategorizationId = GLGAC.GLCategorizationId
				
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				GLGAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId
				
			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId	
			
			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId 
	)Mappings
	PIVOT
	(
		MAX(GLCategorizationHierarchyCode)
		FOR GLCategorizationName IN ([Global], [US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
	) AS PivotTable


CREATE UNIQUE CLUSTERED INDEX IX_GlAccountCategoryMapping_GLGlobalAccountId ON #GlAccountCategoryMapping (GLGlobalAccountId, IsDirect)
PRINT ''Completed building clustered index on #GlAccountCategoryMapping''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)	
	
END

CREATE TABLE #LocalPayrollGLCategorizationMapping(
	FunctionalDepartmentId INT NULL,
	ActivityTypeId INT NULL,
	PayrollTypeId INT NULL,
	GlobalGLMinorCategoryId INT NULL,
	USPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUPropertyGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUFundGLCategorizationHierarchyCode VARCHAR(50) NULL,
	USDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL,
	EUDevelopmentGLCategorizationHierarchyCode VARCHAR(50) NULL
)
INSERT INTO #LocalPayrollGLCategorizationMapping
(
	FunctionalDepartmentId,
	ActivityTypeId,
	PayrollTypeId,
	GlobalGLMinorCategoryId,
	USPropertyGLCategorizationHierarchyCode,
	USFundGLCategorizationHierarchyCode,
	EUPropertyGLCategorizationHierarchyCode,
	EUFundGLCategorizationHierarchyCode,
	USDevelopmentGLCategorizationHierarchyCode,
	EUDevelopmentGLCategorizationHierarchyCode
)
SELECT
	PivotTable.FunctionalDepartmentId,
	PivotTable.ActivityTypeId,
	PivotTable.PayrollTypeId,
	PivotTable.GLMinorCategoryId,
	PivotTable.[US Property] AS USPropertyGLCategorizationHierarchyCode,
	PivotTable.[US Fund] AS USFundGLCategorizationHierarchyCode,
	PivotTable.[EU Property] AS EUPropertyGLCategorizationHierarchyCode,
	PivotTable.[EU Fund] AS EUFundGLCategorizationHierarchyCode,
	PivotTable.[US Development] AS USDevelopmentGLCategorizationHierarchyCode,
	PivotTable.[EU Development] AS EUDevelopmentGLCategorizationHierarchyCode
FROM
	(
		SELECT DISTINCT
			FD.FunctionalDepartmentId,
			AType.ActivityTypeId,
			PPPGA.PayrollTypeId,
			MinCa.GLMinorCategoryId,
			GC.Name as GLCategorizationName,
			CONVERT(VARCHAR(2), ISNULL(GC.GLCategorizationTypeId, -1)) + '':'' +
			CONVERT(VARCHAR(10), ISNULL(GC.GLCategorizationId, -1)) + '':'' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(FinC.GLFinancialCategoryId, -1) END) + '':'' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MajC.GLMajorCategoryId, -1) END) + '':'' +
			CONVERT(VARCHAR(10), CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN -1 ELSE ISNULL(MinC.GLMinorCategoryId, -1) END) + '':'' +
			CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1)) AS GLCategorizationHierarchyCode
		FROM
			#PropertyPayrollPropertyGLAccount PPPGA

			INNER JOIN #ActivityType AType ON
				ISNULL(PPPGA.ActivityTypeId, 0) = CASE WHEN PPPGA.ActivityTypeId IS NULL THEN 0 ELSE AType.ActivityTypeId END 
				
			INNER JOIN #FunctionalDepartment FD ON
				ISNULL(PPPGA.FunctionalDepartmentId, 0) = CASE WHEN PPPGA.FunctionalDepartmentId IS NULL THEN 0 ELSE FD.FunctionalDepartmentId END 

			INNER JOIN #GLMinorCategory MinCa ON
				ISNULL(PPPGA.GLMinorCategoryId, 0) = CASE WHEN PPPGA.GLMinorCategoryId IS NULL THEN 0 ELSE MinCa.GLMinorCategoryId END 

			INNER JOIN #GLMajorCategory MajCa ON
				MinCa.GLMajorCategoryId = MajCa.GLMajorCategoryId
			
			INNER JOIN #GLCategorization GC ON
				PPPGA.GLCategorizationId = GC.GLCategorizationId

			INNER JOIN #GLAccount GA ON
				PPPGA.PropertyGLAccountId = GA.GLAccountId
			/*
				If the local Categorization is configured for recharge, the Global account is determined through the PropertyGLAccount 
					local account
				If the local Categorization is not configured for recharge, the Global account is determined directly from the 
					#PropertyPayrollPropertyGLAccount table
			*/
			INNER JOIN #GLGlobalAccount GGA ON
				GGA.GLGlobalAccountId = 
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GA.GLGlobalAccountId
						ELSE
							PPPGA.GLGlobalAccountId
					END 

			LEFT OUTER JOIN #GLGlobalAccountCategorization GGAC ON
				GGA.GLGlobalAccountId = GGAC.GLGlobalAccountId   AND
				PPPGA.GLCategorizationId = GGAC.GLCategorizationId 
			/*
				If the local Categorization is configured for recharge, the Minor Category is determined through the CoAGLMinorCategoryId field
					in the #GLGlobalAccountCategorization table.
				If the local Categorization is not configured for recharge, the Minor Category is determined through the IndirectGLMinorCategoryId 
					field in the #GLGlobalAccountCategorization table.
			*/	
			LEFT OUTER JOIN #GLMinorCategory MinC ON
				MinC.GLMinorCategoryId =
					CASE 
						WHEN (GC.RechargeSourceCode IS NOT NULL AND GC.IsConfiguredForRecharge = 1) THEN
							GGAC.CoAGLMinorCategoryId
						ELSE
							GGAC.DirectGLMinorCategoryId
					END 

			LEFT OUTER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId 

			LEFT OUTER JOIN #GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
				GC.GLCategorizationId  = FinC.GLCategorizationId 

			LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy DIM ON
				DIM.GLCategorizationHierarchyCode = 
					CONVERT(VARCHAR(2), GC.GLCategorizationTypeId) + '':'' +
					CONVERT(VARCHAR(10), GC.GLCategorizationId) + '':'' +
					CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), FinC.GLFinancialCategoryId) END + '':'' +
					CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), MajC.GLMajorCategoryId) END + '':'' +
					CASE WHEN FinC.GLFinancialCategoryId IS NULL THEN ''-1'' ELSE CONVERT(VARCHAR(10), MinC.GLMinorCategoryId) END + '':'' +
					(CONVERT(VARCHAR(10), ISNULL(GGA.GlGlobalAccountId, -1))) 

		WHERE
		(
			MajCa.Name = ''Salaries/Taxes/Benefits'' OR
			(
				MinCa.Name = ''External General Overhead'' AND
				MajCa.Name = ''General Overhead''
			)
		) AND
		MajCa.GLCategorizationId = 233
	) LocalMappings
	PIVOT
	(
		MAX(GLCategorizationHierarchyCode)
		FOR GLCategorizationName IN ([US Property], [US Fund], [EU Property], [EU Fund], [US Development], [EU Development])
	) AS PivotTable
	
/* ===========================================================================================================================================
	Map General Ledger to GDM, HR and GACS mapping data
   =========================================================================================================================================== */
BEGIN

CREATE TABLE #ProfitabilityActualSource
(
	Period CHAR(6) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	FunctionalDepartmentId INT NULL,
	FunctionalDepartmentCode CHAR(15) NULL,
	JobCode CHAR(15) NULL,
	OriginatingRegionCode CHAR(6) NOT NULL,
	OriginatingSubRegionGlobalRegionId INT NULL,
	AllocationSubRegionGlobalRegionId INT NULL,
	ConsolidationSubRegionGlobalRegionId INT NULL,
	PropertyFundId INT NULL,
	EntityTypeId INT NULL,
	ActivityTypeId INT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual MONEY NOT NULL,
	EntryDate DATETIME NOT NULL,
	LastDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	PropertyFundCode CHAR(12) NULL,
	GLGlobalAccountId INT NULL,
	IsGlobalReporting BIT NULL,
	IsReimbursable BIT NULL,
	DefaultGLCategorizationId INT NULL,
	SourceTableName VARCHAR(20) NOT NULL
)
INSERT INTO #ProfitabilityActualSource
(
	Period,
	SourceCode,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	JobCode,
	OriginatingRegionCode,
	OriginatingSubRegionGlobalRegionId,
	AllocationSubRegionGlobalRegionId,
	ConsolidationSubRegionGlobalRegionId,
	PropertyFundId,
	EntityTypeId,
	ActivityTypeId,
	ReferenceCode,
	LocalCurrency,
	LocalActual,
	EntryDate,
	LastDate,
	[User],
	[Description],
	AdditionalDescription,
	PropertyFundCode,
	GLGlobalAccountId,
	IsGlobalReporting,
	IsReimbursable,
	DefaultGLCategorizationId,
	SourceTableName
)
SELECT
	Gl.Period,
	LTRIM(RTRIM(Gl.SourceCode)),
	Fd.FunctionalDepartmentId,
	LTRIM(RTRIM(Fd.GlobalCode)),
	LTRIM(RTRIM(Gl.JobCode)),
	LTRIM(RTRIM(Gl.OriginatingRegionCode)),
	ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId),
	PF.AllocationSubRegionGlobalRegionId,
	ISNULL(CRCD.GlobalRegionId, CRPE.GlobalRegionId),
	PF.PropertyFundId,
	pf.EntityTypeId,
	GA.ActivityTypeId,
	Gl.SourcePrimaryKey,
	Gl.LocalCurrency,
	Gl.LocalActual,
	Gl.EnterDate,
	Gl.LastDate,
	Gl.[User],
	Gl.[Description],
	Gl.AdditionalDescription,
	LTRIM(RTRIM(Gl.PropertyFundCode)),
	GA.GLGlobalAccountId,
	GLA.IsGlobalReporting,
	CASE WHEN Gl.NetTSCost = ''Y'' THEN 0 ELSE 1 END,
	RC.GLCategorizationId,
	Gl.SourceTableName
FROM
	#ProfitabilityGeneralLedger Gl

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON -- Used to determine if the source is a Property or a Corporate source
		Gl.SourceCode = GrSc.SourceCode  

	LEFT OUTER JOIN #JobCode Jc ON --The JobCodes is FunctionalDepartment in Corp
		Gl.JobCode = Jc.JobCode AND
		Gl.SourceCode = Jc.Source AND
		GrSc.IsCorporate = ''YES''
			
	LEFT OUTER JOIN #Department Dp ON --The Department (Region+FunctionalDept) is FunctionalDepartment in Prop
		Dp.Department = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		Gl.SourceCode = Dp.Source AND
		GrSc.IsProperty = ''YES''

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		/*
	      Functional Department Investigation, When running Import and clearing wherehouse data for period 201012
	      some of the history is lost and functional departments cannot be linked again and does not exist in gacs anymore
	      so for period 201012 we want to report on the historic functional department we add a little hack
	      
	      Legal Risk and Records Hack:
          you will find the functional department id hack below, when they split legal risk and records into 3 departments
          the reused the code LGL, so for 2010 data we have to hack it.
          
          Revised:
          Add the property to it too, property is joined in GL FunctionalDepartmentCode rather than the GL JobCode.
	    */		
        Fd.FunctionalDepartmentId = 
			CASE 
				WHEN (GL.Period <= 201012) THEN
					CASE GrSc.IsCorporate	
						WHEN ''YES'' THEN
							  CASE 
									WHEN (LTRIM(RTRIM(GL.JobCode)) IN (''LGL'',''RSK'', ''RIM'')) THEN
										  14
									ELSE 
										  ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
							  END
						ELSE
							CASE
								  WHEN (LTRIM(RTRIM(GL.FunctionalDepartmentCode)) IN (''LGL'',''RSK'',''RIM'')) THEN
										14
								  ELSE	
									ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
							END
					END								 
				ELSE
					  ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
			END
			
	LEFT OUTER JOIN #GLAccount GLA ON
		Gl.GlAccountCode = GLA.Code  AND
		Gl.SourceCode = GLA.SourceCode 
		
	LEFT OUTER JOIN #GLGlobalAccount GA ON
		GLA.GLGlobalAccountId = GA.GLGlobalAccountId

	LEFT OUTER JOIN #PropertyFundMapping Pfm ON
		LTRIM(RTRIM(Gl.PropertyFundCode)) = Pfm.PropertyFundCode AND
		Gl.SourceCode = Pfm.SourceCode AND
		(
			(GrSc.IsProperty = ''YES'' AND Pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = ''YES'' AND Pfm.ActivityTypeId = GA.ActivityTypeId)
				OR
				(GrSc.IsCorporate = ''YES'' AND Pfm.ActivityTypeId IS NULL AND GA.ActivityTypeId IS NULL)
			)
		) AND
		(Gl.Period < ''201007'')

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(Gl.PropertyFundCode)) = RECD.CorporateDepartmentCode  AND
		Gl.SourceCode = RECD.SourceCode AND
		Gl.Period >= ''201007''
		
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		REPE.SourceCode = Gl.SourceCode AND
		Gl.Period >= ''201007''		   
	
	LEFT OUTER JOIN	#ConsolidationRegionCorporateDepartment CRCD ON -- CC16
		GrSc.IsCorporate = ''YES'' AND -- only corporate MRIs resolved through this
		LTRIM(RTRIM(Gl.PropertyFundCode)) = CRCD.CorporateDepartmentCode  AND
		Gl.SourceCode = CRCD.SourceCode AND
		Gl.Period >= ''201101''
	
	LEFT OUTER JOIN #ConsolidationRegionPropertyEntity CRPE ON -- CC16
		GrSc.IsProperty = ''YES'' AND -- only property MRIs resolved through this
		LTRIM(RTRIM(Gl.PropertyFundCode)) = CRPE.PropertyEntityCode AND
		Gl.SourceCode = CRPE.SourceCode AND
		Gl.Period >= ''201007''
	
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		Gl.OriginatingRegionCode = ORCE.CorporateEntityCode AND
		Gl.SourceCode = ORCE.SourceCode  
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) = ORPD.PropertyDepartmentCode  AND
		Gl.SourceCode  = ORPD.SourceCode 
		 
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId =
			CASE
				WHEN Gl.Period < ''201007'' THEN Pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = ''YES'' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END	
			
	LEFT OUTER JOIN #ReportingCategorization RC ON
		PF.EntityTypeId = RC.EntityTypeId AND
		PF.AllocationSubRegionGlobalRegionId = RC.AllocationSubRegionGlobalRegionId  

PRINT ''Rows inserted into ProfitabilityActualSource:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
END			
/* =============================================================================================================================================
	Insert data into table representing schema of ProfitabilityActual
   =========================================================================================================================================== */

/*
The table below resolves the data warehouse keys based on the mapping data from GDM, HR and GACS.
*/

CREATE TABLE #ProfitabilityActual
(
	CalendarKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	ConsolidationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	SourceSystemKey INT NOT NULL,
	
	LastDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	OriginatingRegionCode NCHAR(6) NULL,
	PropertyFundCode NCHAR(12) NULL,
	FunctionalDepartmentCode NCHAR(15) NULL,
	
	GlobalGLCategorizationHierarchyKey INT NULL,
	USPropertyGLCategorizationHierarchyKey INT NULL,
	USFundGLCategorizationHierarchyKey INT NULL,
	EUPropertyGLCategorizationHierarchyKey INT NULL,
	EUFundGLCategorizationHierarchyKey INT NULL,
	USDevelopmentGLCategorizationHierarchyKey INT NULL,
	EUDevelopmentGLCategorizationHierarchyKey INT NULL,
	ReportingGLCategorizationHierarchyKey INT NULL
) 

INSERT INTO #ProfitabilityActual
(
	CalendarKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	SourceSystemKey,
	LastDate,
	[User],
	[Description],
	AdditionalDescription,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
	ReportingGLCategorizationHierarchyKey
)

SELECT 

	DATEDIFF(dd, ''1900-01-01'', LEFT(ActualSource.Period, 4)+''-''+RIGHT(ActualSource.Period, 2)+''-01'')  AS CalendarKey,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown) AS  SourceKey,
	COALESCE(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey, @FunctionalDepartmentKeyUnknown) AS FunctionalDepartmentKey,
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown)AS ReimbursableKey,
	ISNULL(GrAt.ActivityTypeKey, @ActivityTypeKeyUnknown) AS ActivityTypeKey,
	ISNULL(OrR.OriginatingRegionKey, @OriginatingRegionKeyUnknown) AS OriginatingRegionKey,
	ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown) AS AllocationRegionKey,
	
	CASE -- CC16: Before 2011, Consolidation Region Key = Allocation Region Key
		WHEN ActualSource.Period < ''201101'' THEN
			ISNULL(GrAr.AllocationRegionKey, @AllocationRegionKeyUnknown)
		ELSE
				ISNULL(GrCr.AllocationRegionKey, @AllocationRegionKeyUnknown)
	END AS ConsolidationRegionKey,
		
	ISNULL(GrPf.PropertyFundKey, @PropertyFundKeyUnknown) AS PropertyFundKey,
	ISNULL(GrOh.OverheadKey, @OverheadKeyUnknown) AS OverheadKey,
	
	ActualSource.ReferenceCode,
	ISNULL(Cu.CurrencyKey, @LocalCurrencyKeyUnknown),
	ActualSource.LocalActual,
	SourceSystem.SourceSystemKey,
	ISNULL(ActualSource.LastDate, ActualSource.EntryDate),
	ActualSource.[User],
	ActualSource.[Description],
	ActualSource.AdditionalDescription,
	
	ActualSource.OriginatingRegionCode,
	ActualSource.PropertyFundCode,
	ActualSource.FunctionalDepartmentCode,
	
	-- CC21 Changes
	/*
	Each categorization is mapped using the keys from the GLCategorizationHierarchy dimension. If the record cannot be found,
	the unkown record for the respective GL Account is used, and if the GL account is unknown, the global Unknown key is used.
	*/
	COALESCE(GlobalGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey),
	COALESCE (USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey),	
	COALESCE(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey),
	COALESCE(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey),
	COALESCE(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey),
	COALESCE(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey),
	COALESCE(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown),
	
	/*
	The purpose of the ReportingGLCategorizationHierarchy field is to define the default GL Categorization that will be used
	when a local report is generated.
	*/
		
	CASE 
		WHEN GC.GLCategorizationId IS NOT NULL THEN
			CASE
				WHEN (GC.Name = ''US Property'') 
				THEN ISNULL(USPropertyGCH.GLCategorizationHierarchyKey, @UnknownUSPropertyGLCategorizationKey)
				
				WHEN (GC.Name = ''US Fund'')  
				THEN  ISNULL(USFundGCH.GLCategorizationHierarchyKey, @UnknownUSFundGLCategorizationKey) 
				
				WHEN (GC.Name = ''EU Property'')  
				THEN ISNULL(EUPropertyGCH.GLCategorizationHierarchyKey, @UnknownEUPropertyGLCategorizationKey)
				
				WHEN (GC.Name = ''EU Fund'')  
				THEN ISNULL(EUFundGCH.GLCategorizationHierarchyKey, @UnknownEUFundGLCategorizationKey) 
				
				WHEN (GC.Name = ''US Development'')  
				THEN ISNULL(USDevelopmentGCH.GLCategorizationHierarchyKey, @UnknownUSDevelopmentGLCategorizationKey) 
				
				WHEN (GC.Name = ''EU Development'')  
				THEN ISNULL(EUDevelopmentGCH.GLCategorizationHierarchyKey, @GLCategorizationHierarchyKeyUnknown)
				
				WHEN GC.Name = ''Global'' 
				THEN COALESCE(GlobalGCH.GLCategorizationHierarchyKey, @UnknownGlobalGLCategorizationKey)
				ELSE @GLCategorizationHierarchyKeyUnknown
			END
		ELSE @GLCategorizationHierarchyKeyUnknown
	END ReportingGLCategorizationHierarchyKey

FROM
	#ProfitabilityActualSource ActualSource
	
	LEFT OUTER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
		ActualSource.SourceTableName = SourceSystem.SourceTableName AND
		SourceSystem.SourceSystemName = ''MRI''
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = ActualSource.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		ActualSource.LocalCurrency = Cu.CurrencyCode  

	LEFT OUTER JOIN #JobCodeFunctionalDepartment GrFdm1 ON --Detail/Sub Level : JobCode
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate)  BETWEEN GrFdm1.StartDate AND GrFdm1.EndDate AND
		GrFdm1.ReferenceCode = CASE WHEN ActualSource.JobCode IS NOT NULL THEN LTRIM(RTRIM(ActualSource.FunctionalDepartmentCode)) + '':''+ LTRIM(RTRIM(ActualSource.JobCode))
									ELSE LTRIM(RTRIM(ActualSource.FunctionalDepartmentCode)) + '':UNKNOWN'' END

	--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
	--that will be used, should the JobCode not match, but the FunctionalDepartment does match
	LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2 ON
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate AND
		GrFdm2.ReferenceCode = LTRIM(RTRIM(ActualSource.FunctionalDepartmentCode)) +'':'' 
		
	-- Change Control 21: New GL Account Categorization Mappings
	
	-- The join to the mapping table created above for the Global and Local categorizations.		
	LEFT OUTER JOIN #GlAccountCategoryMapping GACM ON
		ActualSource.GLGlobalAccountId = GACM.GLGlobalAccountId AND
		GACM.IsDirect = (CASE WHEN GrSc.IsProperty = ''YES'' THEN 1 ELSE 0 END)
	
	-- The join to the GLCategorizationHierarchy dimension for the Global categorization.	
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy GlobalGCH ON
		GACM.GlobalGLCategorizationHierarchyCode  = GlobalGCH.GLCategorizationHierarchyCode AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GlobalGCH.StartDate AND GlobalGCH.EndDate AND
		GlobalGCH.SnapshotId = 0
		
	LEFT OUTER JOIN #PayrollGlobalMappings PGM ON
		GlobalGCH.GLMinorCategoryName = PGM.GLMinorCategoryName AND
		GlobalGCH.GLMajorCategoryName = PGM.GLMajorCategoryName
		
	LEFT OUTER JOIN #GLMinorCategoryPayrollType MCPT ON
		PGM.GLMinorCategoryId = MCPT.GLMinorCategoryId
		
	LEFT OUTER JOIN #LocalPayrollGLCategorizationMapping LocalPayrollMappings ON
		ActualSource.ActivityTypeId = LocalPayrollMappings.ActivityTypeId AND
		ActualSource.FunctionalDepartmentId = LocalPayrollMappings.FunctionalDepartmentId AND
		MCPT.GLMinorCategoryId = LocalPayrollMappings.GlobalGLMinorCategoryId AND
		MCPT.PayrollTypeId = LocalPayrollMappings.PayrollTypeId	
		
	-- The join to the GLCategorizationHierarchy dimension for the US Property local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USPropertyGCH ON
		USPropertyGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN LocalPayrollMappings.USPropertyGLCategorizationHierarchyCode
				ELSE GACM.USPropertyGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN USPropertyGCH.StartDate AND USPropertyGCH.EndDate AND
		USPropertyGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the US Fund local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USFundGCH ON
		USFundGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN LocalPayrollMappings.USFundGLCategorizationHierarchyCode
				ELSE GACM.USFundGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN USFundGCH.StartDate AND USFundGCH.EndDate AND
		USFundGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the EU Property local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUPropertyGCH ON
		EUPropertyGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN LocalPayrollMappings.EUPropertyGLCategorizationHierarchyCode
				ELSE GACM.EUPropertyGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN EUPropertyGCH.StartDate AND EUPropertyGCH.EndDate AND
		EUPropertyGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the EU Fund local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUFundGCH ON
		EUFundGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN LocalPayrollMappings.EUFundGLCategorizationHierarchyCode
				ELSE GACM.EUFundGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN EUFundGCH.StartDate AND EUFundGCH.EndDate AND
		EUFundGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the US Development local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy USDevelopmentGCH ON
		USDevelopmentGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN LocalPayrollMappings.USDevelopmentGLCategorizationHierarchyCode
				ELSE GACM.USDevelopmentGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN USDevelopmentGCH.StartDate AND USDevelopmentGCH.EndDate AND
		USDevelopmentGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for the EU Development local categorization.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy EUDevelopmentGCH ON
		EUDevelopmentGCH.GLCategorizationHierarchyCode = 
			CASE 
				WHEN GlobalGCH.GLMajorCategoryName = ''Salaries/Taxes/Benefits''
				THEN LocalPayrollMappings.EUDevelopmentGLCategorizationHierarchyCode
				ELSE GACM.EUDevelopmentGLCategorizationHierarchyCode
			END AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN EUDevelopmentGCH.StartDate AND EUDevelopmentGCH.EndDate AND
		EUDevelopmentGCH.SnapshotId = 0
			
	-- The join to the GLCategorizationHierarchy dimension for when the GlAccount is known, but the Categorization details
	-- are unknown.
	LEFT OUTER JOIN GrReporting.dbo.GLCategorizationHierarchy UnknownGCH ON
		UnknownGCH.GLCategorizationHierarchyCode = ''-1:-1:-1:-1:-1:'' + CONVERT(VARCHAR(10), ActualSource.GLGlobalAccountId) AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN UnknownGCH.StartDate AND UnknownGCH.EndDate AND
		UnknownGCH.SnapshotId = 0
		
	-- Change Control 21 End

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ActualSource.ActivityTypeId = GrAt.ActivityTypeId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrAt.StartDate AND GrAt.EndDate AND
		GrAt.SnapshotId = 0

	--GC Change Control 1
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN GrAt.ActivityTypeCode = ''CORPOH'' THEN ''UNALLOC'' ELSE ''N/A'' END
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion OrR ON
		ActualSource.OriginatingSubRegionGlobalRegionId = OrR.GlobalRegionId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN OrR.StartDate AND OrR.EndDate AND
		OrR.SnapshotId = 0

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ActualSource.PropertyFundId = GrPf.PropertyFundId AND 
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrPf.StartDate AND GrPf.EndDate AND
		GrPf.SnapshotId = 0
	
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ActualSource.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrAr.StartDate AND GrAr.EndDate AND 
		GrAr.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrCr ON -- ConsolidationRegion Change Control 16
		ActualSource.ConsolidationSubRegionGlobalRegionId = GrCr.GlobalRegionId AND
		ISNULL(ActualSource.LastDate, ActualSource.EntryDate) BETWEEN GrCr.StartDate AND GrCr.EndDate AND 
		GrCr.SnapshotId = 0
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = 
			CASE 
				WHEN ActualSource.IsReimbursable = 0 
					THEN ''NO'' 
				ELSE ''YES'' 
			END
	
	-- The default categorization to be used in the report
		
	LEFT OUTER JOIN #GLCategorization GC ON
		ActualSource.DefaultGLCategorizationID = GC.GLCategorizationId
		
PRINT ''Rows inserted into ProfitabilityActual:''+CONVERT(char(10),@@rowcount)	
PRINT ''Completed converting all transactional data to star schema keys''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_ProfitabilityActual_ReferenceCode ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT ''Completed building clustered index on #ProfitabilityActual''
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)

/* ==============================================================================================================================================
	Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
   =========================================================================================================================================== */
BEGIN

DECLARE @UpdatedDate DATETIME = GETDATE()

--Transfer the updated rows
UPDATE DIM
SET	
	CalendarKey						 = Pro.CalendarKey,
	FunctionalDepartmentKey			 = Pro.FunctionalDepartmentKey,
	ReimbursableKey					 = Pro.ReimbursableKey,
	ActivityTypeKey					 = Pro.ActivityTypeKey,
	OriginatingRegionKey			 = Pro.OriginatingRegionKey,
	AllocationRegionKey				 = Pro.AllocationRegionKey,
	ConsolidationRegionKey			 = Pro.ConsolidationRegionKey,
	PropertyFundKey					 = Pro.PropertyFundKey,
	OverheadKey						 = Pro.OverheadKey,
	LocalCurrencyKey				 = Pro.LocalCurrencyKey,
	LocalActual						 = Pro.LocalActual,
	SourceSystemKey					 = Pro.SourceSystemKey,
	
	GlobalGLCategorizationHierarchyKey		 = Pro.GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey	 = Pro.USPropertyGLCategorizationHierarchyKey, 
	USFundGLCategorizationHierarchyKey		 = Pro.USFundGLCategorizationHierarchyKey, 
	EUPropertyGLCategorizationHierarchyKey	 = Pro.EUPropertyGLCategorizationHierarchyKey, 
	EUFundGLCategorizationHierarchyKey		 = Pro.EUFundGLCategorizationHierarchyKey, 
	USDevelopmentGLCategorizationHierarchyKey = Pro.USDevelopmentGLCategorizationHierarchyKey, 
	EUDevelopmentGLCategorizationHierarchyKey = Pro.EUDevelopmentGLCategorizationHierarchyKey, 
	ReportingGLCategorizationHierarchyKey	= Pro.ReportingGLCategorizationHierarchyKey,
	
	LastDate						 = Pro.LastDate,
	[User]							 = Pro.[User],
	[Description]					 = Pro.[Description],
	AdditionalDescription			 = Pro.AdditionalDescription,
	
	OriginatingRegionCode			 = Pro.OriginatingRegionCode,
	PropertyFundCode				 = Pro.PropertyFundCode,
	FunctionalDepartmentCode		 = Pro.FunctionalDepartmentCode,
	
	UpdatedDate						= @UpdatedDate
FROM
	GrReporting.dbo.ProfitabilityActual DIM
	
	INNER JOIN #ProfitabilityActual Pro ON
		DIM.SourceKey = Pro.SourceKey AND
		DIM.ReferenceCode = Pro.ReferenceCode
WHERE
	DIM.CalendarKey						 <> Pro.CalendarKey OR
	DIM.FunctionalDepartmentKey			 <> Pro.FunctionalDepartmentKey OR
	DIM.ReimbursableKey					 <> Pro.ReimbursableKey OR
	DIM.ActivityTypeKey					 <> Pro.ActivityTypeKey OR
	DIM.OriginatingRegionKey			 <> Pro.OriginatingRegionKey OR
	DIM.AllocationRegionKey				 <> Pro.AllocationRegionKey OR
	DIM.ConsolidationRegionKey			 <> Pro.ConsolidationRegionKey OR
	DIM.PropertyFundKey					 <> Pro.PropertyFundKey OR
	DIM.OverheadKey						 <> Pro.OverheadKey OR
	DIM.LocalCurrencyKey				 <> Pro.LocalCurrencyKey OR
	DIM.LocalActual						 <> Pro.LocalActual OR
	DIM.SourceSystemKey					 <> Pro.SourceSystemKey OR
	
	ISNULL(DIM.GlobalGLCategorizationHierarchyKey, '''')		 <> Pro.GlobalGLCategorizationHierarchyKey OR
	ISNULL(DIM.USPropertyGLCategorizationHierarchyKey, '''')	 <> Pro.USPropertyGLCategorizationHierarchyKey OR 
	ISNULL(DIM.USFundGLCategorizationHierarchyKey, '''')		 <> Pro.USFundGLCategorizationHierarchyKey OR 
	ISNULL(DIM.EUPropertyGLCategorizationHierarchyKey, '''')	 <> Pro.EUPropertyGLCategorizationHierarchyKey OR 
	ISNULL(DIM.EUFundGLCategorizationHierarchyKey, '''')		 <> Pro.EUFundGLCategorizationHierarchyKey OR 
	ISNULL(DIM.USDevelopmentGLCategorizationHierarchyKey, '''') <> Pro.USDevelopmentGLCategorizationHierarchyKey OR 
	ISNULL(DIM.EUDevelopmentGLCategorizationHierarchyKey, '''') <> Pro.EUDevelopmentGLCategorizationHierarchyKey OR 
	ISNULL(DIM.ReportingGLCategorizationHierarchyKey, '''')	<> Pro.ReportingGLCategorizationHierarchyKey OR
	
	DIM.LastDate						 <> Pro.LastDate OR
	DIM.[User]							 <> Pro.[User] OR
	DIM.[Description]					 <> Pro.[Description] OR
	DIM.AdditionalDescription			 <> Pro.AdditionalDescription OR
	
	DIM.OriginatingRegionCode			 <> Pro.OriginatingRegionCode OR
	DIM.PropertyFundCode				 <> Pro.PropertyFundCode OR
	DIM.FunctionalDepartmentCode		 <> Pro.FunctionalDepartmentCode
	

PRINT ''Rows Updated in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
	
--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual 
(
	CalendarKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	ConsolidationRegionKey,
	PropertyFundKey,
	OverHeadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	SourceSystemKey,
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
	ReportingGLCategorizationHierarchyKey,
	LastDate,
	[User],
	[Description],
	AdditionalDescription,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	InsertedDate,
	UpdatedDate
)
	
SELECT
	Pro.CalendarKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.ConsolidationRegionKey,
	Pro.PropertyFundKey,
	Pro.OverHeadKey,
	Pro.ReferenceCode,
	Pro.LocalCurrencyKey,
	Pro.LocalActual,
	Pro.SourceSystemKey,
	
	Pro.GlobalGLCategorizationHierarchyKey,
	Pro.USPropertyGLCategorizationHierarchyKey,
	Pro.USFundGLCategorizationHierarchyKey,
	Pro.EUPropertyGLCategorizationHierarchyKey,
	Pro.EUFundGLCategorizationHierarchyKey,
	Pro.USDevelopmentGLCategorizationHierarchyKey,
	Pro.EUDevelopmentGLCategorizationHierarchyKey,
	Pro.ReportingGLCategorizationHierarchyKey,
	
	Pro.LastDate,
	Pro.[User],
	Pro.[Description],
	Pro.AdditionalDescription,
	Pro.OriginatingRegionCode, 
	Pro.PropertyFundCode, 
	Pro.FunctionalDepartmentCode,
	
	@UpdatedDate, -- InsertedDate
	@UpdatedDate -- UpdatedDate
FROM
	#ProfitabilityActual Pro
	
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		Pro.SourceKey  = ProExists.SourceKey AND
		Pro.ReferenceCode = ProExists.ReferenceCode  
WHERE
	ProExists.SourceKey IS NULL

PRINT ''Rows Inserted in Profitability:''+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)


-- remove orphan rows from the warehouse that have been removed in the source data systems
EXEC stp_IU_ArchiveProfitabilityMRIActual @ImportStartDate=@ImportStartDate, @ImportEndDate=@ImportEndDate, @DataPriorToDate=@DataPriorToDate

END
/* ==============================================================================================================================================
	Clean up
   =========================================================================================================================================== */
 
BEGIN

IF OBJECT_ID(''tempdb..#ManageType'') IS NOT NULL
	DROP TABLE #ManageType

IF OBJECT_ID(''tempdb..#ManageCorporateDepartment'') IS NOT NULL
	DROP TABLE #ManageCorporateDepartment
	
IF OBJECT_ID(''tempdb..#ManageCorporateEntity'') IS NOT NULL
	DROP TABLE #ManageCorporateEntity
	
IF OBJECT_ID(''tempdb..#ManagePropertyDepartment'') IS NOT NULL	
	DROP TABLE #ManagePropertyDepartment
	
IF OBJECT_ID(''tempdb..#ManagePropertyEntity'') IS NOT NULL
	DROP TABLE #ManagePropertyEntity

IF OBJECT_ID(''tempdb..#ProfitabilityGeneralLedger'') IS NOT NULL
	DROP TABLE #ProfitabilityGeneralLedger
	
IF OBJECT_ID(''tempdb..#FunctionalDepartment'') IS NOT NULL	
	DROP TABLE #FunctionalDepartment
	
IF OBJECT_ID(''tempdb..#Department'') IS NOT NULL	
	DROP TABLE #Department

IF OBJECT_ID(''tempdb..#JobCode'') IS NOT NULL
	DROP TABLE #JobCode

IF OBJECT_ID(''tempdb..#ActivityType'') IS NOT NULL
	DROP TABLE #ActivityType
	
IF OBJECT_ID(''tempdb..#GLGlobalAccount'') IS NOT NULL	
	DROP TABLE #GLGlobalAccount
	
IF OBJECT_ID(''tempdb..#OriginatingRegionCorporateEntity'') IS NOT NULL	
	DROP TABLE #OriginatingRegionCorporateEntity

IF OBJECT_ID(''tempdb..#OriginatingRegionPropertyDepartment'') IS NOT NULL
	DROP TABLE #OriginatingRegionPropertyDepartment

IF OBJECT_ID(''tempdb..#PropertyFundMapping'') IS NOT NULL
	DROP TABLE #PropertyFundMapping

IF OBJECT_ID(''tempdb..#PropertyFund'') IS NOT NULL
	DROP TABLE #PropertyFund

IF OBJECT_ID(''tempdb..#ReportingEntityCorporateDepartment'') IS NOT NULL
	DROP TABLE #ReportingEntityCorporateDepartment

IF OBJECT_ID(''tempdb..#ReportingEntityPropertyEntity'') IS NOT NULL
	DROP TABLE #ReportingEntityPropertyEntity

IF OBJECT_ID(''tempdb..#AllocationSubRegion'') IS NOT NULL
	DROP TABLE #AllocationSubRegion

IF OBJECT_ID(''tempdb..#JobCodeFunctionalDepartment'') IS NOT NULL
	DROP TABLE #JobCodeFunctionalDepartment

IF OBJECT_ID(''tempdb..#ParentFunctionalDepartment'') IS NOT NULL
	DROP TABLE #ParentFunctionalDepartment

IF OBJECT_ID(''tempdb..#GLCategorizationType'') IS NOT NULL
	DROP TABLE #GLCategorizationType

IF OBJECT_ID(''tempdb..#GLCategorization'') IS NOT NULL
	DROP TABLE #GLCategorization

IF OBJECT_ID(''tempdb..#GLGlobalAccountCategorization'') IS NOT NULL
	DROP TABLE #GLGlobalAccountCategorization

IF OBJECT_ID(''tempdb..#GLFinancialCategory'') IS NOT NULL
	DROP TABLE #GLFinancialCategory

IF OBJECT_ID(''tempdb..#GLAccount'') IS NOT NULL
	DROP TABLE #GLAccount

IF OBJECT_ID(''tempdb..#GLMajorCategory'') IS NOT NULL
	DROP TABLE #GLMajorCategory

IF OBJECT_ID(''tempdb..#GLMinorCategory'') IS NOT NULL
	DROP TABLE #GLMinorCategory

IF OBJECT_ID(''tempdb..#ProfitabilityActual'') IS NOT NULL
	DROP TABLE #ProfitabilityActual

IF OBJECT_ID(''tempdb..#GlAccountCategoryMapping'') IS NOT NULL
	DROP TABLE #GlAccountCategoryMapping

IF OBJECT_ID(''tempdb..#ConsolidationRegionCorporateDepartment'') IS NOT NULL
	DROP TABLE #ConsolidationRegionCorporateDepartment

IF OBJECT_ID(''tempdb..#ConsolidationRegionPropertyEntity'') IS NOT NULL
	DROP TABLE #ConsolidationRegionPropertyEntity

IF OBJECT_ID(''tempdb..#ConsolidationSubRegion'') IS NOT NULL
	DROP TABLE #ConsolidationSubRegion

END



' 
END
GO
