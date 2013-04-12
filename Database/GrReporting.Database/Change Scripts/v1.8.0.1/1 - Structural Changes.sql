 USE GrReporting
GO
-- Creating foregin key constraints for the ConsolidationRegionKey column for the fact tables

-- dbo.ProfitabilityActual

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_ConsolidationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_ConsolidationRegion]
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_ConsolidationRegion] FOREIGN KEY([ConsolidationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_ConsolidationRegion]
GO

--dbo.ProfitabilityBudget

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_ConsolidationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_ConsolidationRegion]
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_ConsolidationRegion] FOREIGN KEY([ConsolidationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_ConsolidationRegion]
GO

--dbo.ProfitabilityReforecast

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_ConsolidationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_ConsolidationRegion]
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_ConsolidationRegion] FOREIGN KEY([ConsolidationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_ConsolidationRegion]
GO

--dbo.ProfitabilityActualArchive

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_ConsolidationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_ConsolidationRegion]
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_ConsolidationRegion] FOREIGN KEY([ConsolidationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_ConsolidationRegion]
GO

