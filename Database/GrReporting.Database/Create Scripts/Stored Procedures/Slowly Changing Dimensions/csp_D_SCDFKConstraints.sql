USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_D_SCDFKConstraints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_D_SCDFKConstraints]
GO

CREATE PROCEDURE [dbo].[csp_D_SCDFKConstraints]

AS

/*
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around involves dropping the FKs that are affected, and recreating them after the MERGE operations have completed (stp_IU_SCDFKConstraints)
*/

																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ActivityType                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_ActivityType]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_ActivityType]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_ActivityType]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.AllocationRegion                                                                                                                          ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_AllocationRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccount                                                                                                                                 ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_GlAccount]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_GlAccount]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_GlAccount]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.OriginatingRegion                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.PropertyFund                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_PropertyFund]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]

																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccountCategory                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

	-- dbo.ProfitabilityActual

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityBudget

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityReforecast

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityActualArchive

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Development_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Global_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GlAccountCategory]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GlAccountCategory]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ReportingEntity                                                                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */


																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.FunctionalDepartment                                                                                                                      ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
	ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_FunctionalDepartment]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
	ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_FunctionalDepartment]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
	ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_FunctionalDepartment]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
	ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_FunctionalDepartment]







GO
