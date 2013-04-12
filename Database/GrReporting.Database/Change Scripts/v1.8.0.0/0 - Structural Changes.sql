-- Add RasonForChange field to all SCDs
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GLAccountCategory' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.GLAccountCategory
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.GLAccountCategory')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.GLAccountCategory as it already exists')
END

GO
-----------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ActivityType' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.ActivityType
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.ActivityType')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.ActivityType as it already exists')
END

GO
-----------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AllocationRegion' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.AllocationRegion
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.AllocationRegion')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.AllocationRegion as it already exists')
END

GO
-----------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OriginatingRegion' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.OriginatingRegion
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.OriginatingRegion')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.OriginatingRegion as it already exists')
END

GO
-----------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FunctionalDepartment' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.FunctionalDepartment
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.FunctionalDepartment')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.FunctionalDepartment as it already exists')
END

GO
-----------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccount' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.GlAccount
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.GlAccount')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.GlAccount as it already exists')
END

GO
-----------------------------------------
USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PropertyFund' AND COLUMN_NAME = 'ReasonForChange')
BEGIN

	ALTER TABLE
		dbo.PropertyFund
	ADD
		ReasonForChange NVARCHAR(1024) NULL

	PRINT ('Field "ReasonForChange" added to dbo.PropertyFund')
END
ELSE
BEGIN
	PRINT ('Cannot add field "ReasonForChange" to dbo.PropertyFund as it already exists')
END

GO
-----------------------------------------


































------------------------------------------------------------------------------------------
-- Rename various foreign keys for consistency and to adhere to OB naming standards
------------------------------------------------------------------------------------------

USE [GrReporting]
GO

----------------------------------------------------------------------------------------
-- Rename [FK_ProfitabilityBudget_Activity] to
-- [FK_ProfitabilityBudget_ActivityType]
----------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Activity]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Activity]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_ActivityType]
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_ActivityType] FOREIGN KEY([ActivityTypeKey])
REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_ActivityType]
GO

----------------------------------------------------------------------------------------
-- Rename [FK_ProfitabilityReforecast_Activity] to
-- [FK_ProfitabilityReforecast_Activity]
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_Activity]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Activity]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_ActivityType]
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_ActivityType] FOREIGN KEY([ActivityTypeKey])
REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_ActivityType]
GO

-----------------------------------------------------------------------------------------------------------------------------
--PROFITABILITY ACTUAL
-----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
-- Rename 
-- FKDevelopmentGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_Development_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKDevelopmentGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_EUCorporate_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_EUFund_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_EUProperty_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKGlobalGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_Global_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKGlobalGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_USCorporate_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_USFund_GlAccountCategory
----------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory
-- FK_ProfitabilityActual_USProperty_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory]
GO

-----------------------------------------------------------------------------------------------------------------------------
--PROFITABILITY BUDGET
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
-- Rename 
-- FKDevelopmentGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_Development_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKDevelopmentGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_EUCorporate_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_EUFund_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_EUProperty_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKGlobalGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_Global_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKGlobalGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_USCorporate_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_USFund_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory
-- FK_ProfitabilityBudget_USProperty_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory]
GO

-----------------------------------------------------------------------------------------------------------------------------
--PROFITABILITY REFORECAST
-----------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
-- Rename 
-- FKDevelopmentGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforeCast_Development_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKDevelopmentGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforeCast_Development_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforeCast_Development_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforeCast_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforeCast_Development_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforeCast_EUCorporate_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforeCast_EUCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforeCast_EUCorporate_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforeCast_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforeCast_EUCorporate_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforecast_EUFund_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_EUFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKEUPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforecast_EUProperty_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKGlobalGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforecast_Global_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKGlobalGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_Global_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforecast_USCorporate_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]
GO


----------------------------------------------------------------------------------------
-- Rename 
-- FKUSFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforecast_USFund_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_USFund_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory]
GO

----------------------------------------------------------------------------------------
-- Rename 
-- FKUSPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory
-- FK_ProfitabilityReforecast_USProperty_GlAccountCategory
----------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_USProperty_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory]
GO

------------------------------------------------------------------------
-- Check if newly added foreign keys exist
------------------------------------------------------------------------
SELECT 'Check if newly added foreign keys exist'

SELECT
ParentObject.Name AS 'Table',
ForeignKey.Name AS 'Foreign Key'
FROM SYS.FOREIGN_KEYS ForeignKey
INNER JOIN SYS.ALL_OBJECTS FKObject ON
ForeignKey.Object_Id = FKObject.Object_Id
INNER JOIN SYS.ALL_OBJECTS ParentObject ON
	ForeignKey.Parent_Object_Id = ParentObject.Object_Id
WHERE
ParentObject.Name IN 
(
	'ProfitabilityActual',
	'ProfitabilityBudget',
	'ProfitabilityReforecast'
) AND
ForeignKey.Name IN (
'FK_ProfitabilityReforecast_ActivityType',
'FK_ProfitabilityBudget_ActivityType'
)
ORDER BY 
	ParentObject.Name,
	ForeignKey.Name
	
------------------------------------------------------------------------
-- Check if deleted foreign keys were removed
------------------------------------------------------------------------
SELECT 'Check if deleted foreign keys were removed. (The result set should be empty)'
SELECT
ParentObject.Name AS 'Table',
ForeignKey.Name AS 'Foreign Key'
FROM SYS.FOREIGN_KEYS ForeignKey
INNER JOIN SYS.ALL_OBJECTS FKObject ON
ForeignKey.Object_Id = FKObject.Object_Id
INNER JOIN SYS.ALL_OBJECTS ParentObject ON
	ForeignKey.Parent_Object_Id = ParentObject.Object_Id
WHERE
ParentObject.Name IN 
(
	'ProfitabilityActual',
	'ProfitabilityBudget',
	'ProfitabilityReforecast'
) AND
ForeignKey.Name IN (
'FK_ProfitabilityReforecast_Activity',
'FK_ProfitabilityBudget_Activity'
)
ORDER BY 
	ParentObject.Name,
	ForeignKey.Name
	
	
------------------------------------------------------------------------
-- Check if newly added foreign keys exist
------------------------------------------------------------------------
SELECT 'Check if newly added foreign keys exist'

SELECT
ParentObject.Name AS 'Table',
ForeignKey.Name AS 'Foreign Key'
FROM SYS.FOREIGN_KEYS ForeignKey
INNER JOIN SYS.ALL_OBJECTS FKObject ON
ForeignKey.Object_Id = FKObject.Object_Id
INNER JOIN SYS.ALL_OBJECTS ParentObject ON
	ForeignKey.Parent_Object_Id = ParentObject.Object_Id
WHERE
ParentObject.Name IN 
(
	'ProfitabilityActual',
	'ProfitabilityBudget',
	'ProfitabilityReforecast'
) AND
ForeignKey.Name IN (
'FK_ProfitabilityActual_Development_GlAccountCategory',
'FK_ProfitabilityActual_EUCorporate_GlAccountCategory',
'FK_ProfitabilityActual_EUFund_GlAccountCategory',
'FK_ProfitabilityActual_EUProperty_GlAccountCategory',
'FK_ProfitabilityActual_Global_GlAccountCategory',
'FK_ProfitabilityActual_USCorporate_GlAccountCategory',
'FK_ProfitabilityActual_USFund_GlAccountCategory',
'FK_ProfitabilityActual_USProperty_GlAccountCategory',
'FK_ProfitabilityBudget_Development_GlAccountCategory',
'FK_ProfitabilityBudget_EUCorporate_GlAccountCategory',
'FK_ProfitabilityBudget_EUFund_GlAccountCategory',
'FK_ProfitabilityBudget_EUProperty_GlAccountCategory',
'FK_ProfitabilityBudget_Global_GlAccountCategory',
'FK_ProfitabilityBudget_USCorporate_GlAccountCategory',
'FK_ProfitabilityBudget_USFund_GlAccountCategory',
'FK_ProfitabilityBudget_USProperty_GlAccountCategory',
'FK_ProfitabilityReforeCast_Development_GlAccountCategory',
'FK_ProfitabilityReforeCast_EUCorporate_GlAccountCategory',
'FK_ProfitabilityReforeCast_EUFund_GlAccountCategory',
'FK_ProfitabilityReforeCast_EUProperty_GlAccountCategory',
'FK_ProfitabilityReforeCast_Global_GlAccountCategory',
'FK_ProfitabilityReforeCast_USCorporate_GlAccountCategory',
'FK_ProfitabilityReforeCast_USFund_GlAccountCategory',
'FK_ProfitabilityReforeCast_USProperty_GlAccountCategory'
)
ORDER BY 
	ParentObject.Name,
	ForeignKey.Name
	
------------------------------------------------------------------------
-- Check if deleted foreign keys were removed
------------------------------------------------------------------------
SELECT 'Check if deleted foreign keys were removed. (The result set should be empty)'
SELECT
ParentObject.Name AS 'Table',
ForeignKey.Name AS 'Foreign Key'
FROM SYS.FOREIGN_KEYS ForeignKey
INNER JOIN SYS.ALL_OBJECTS FKObject ON
ForeignKey.Object_Id = FKObject.Object_Id
INNER JOIN SYS.ALL_OBJECTS ParentObject ON
	ForeignKey.Parent_Object_Id = ParentObject.Object_Id
WHERE
ParentObject.Name IN 
(
	'ProfitabilityActual',
	'ProfitabilityBudget',
	'ProfitabilityReforecast'
) AND
ForeignKey.Name IN (
'FKDevelopmentGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKEUCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKEUFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKEUPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKGlobalGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKUSCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKUSFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKUSPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory',
'FKDevelopmentGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKEUCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKEUFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKEUPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKGlobalGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKUSCorporateGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKUSFundGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKUSPropertyGlAccountCategoryKey_ProfitabilityBudget_GlAccountCategory',
'FKDevelopmentGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKEUCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKEUFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKEUPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKGlobalGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKUSCorporateGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKUSFundGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory',
'FKUSPropertyGlAccountCategoryKey_ProfitabilityReforecast_GlAccountCategory'
)
ORDER BY 
	ParentObject.Name,
	ForeignKey.Name
	
