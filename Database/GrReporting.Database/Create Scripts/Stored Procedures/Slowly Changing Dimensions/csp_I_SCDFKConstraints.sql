USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_I_SCDFKConstraints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_I_SCDFKConstraints]
GO

CREATE PROCEDURE [dbo].[csp_I_SCDFKConstraints]

AS
																																			 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ActivityType                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_ActivityType]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_ActivityType]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_ActivityType]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType] FOREIGN KEY([ActivityTypeKey])
	REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.AllocationRegion                                                                                                                          ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_AllocationRegion]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_AllocationRegion]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_AllocationRegion]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
	REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccount                                                                                                                                 ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_GlAccount]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_GlAccount]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_GlAccount]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount] FOREIGN KEY([GlAccountKey])
	REFERENCES [dbo].[GlAccount] ([GlAccountKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.OriginatingRegion                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_OriginatingRegion]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_OriginatingRegion]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_OriginatingRegion]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
	REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.PropertyFund                                                                                                                              ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_PropertyFund]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund] FOREIGN KEY([PropertyFundKey])
	REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.GLAccountCategory                                                                                                                         ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

	-- dbo.ProfitabilityActual
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityBudget
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_USProperty_GlAccountCategory]

	-- dbo.ProfitabilityReforecast
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GlAccountCategory]

-- dbo.ProfitabilityActualArchive
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Development_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Development_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_EUCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_EUProperty_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Global_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Global_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_USCorporate_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GlAccountCategory]
--
ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
	REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GlAccountCategory]
																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.ReportingEntity                                                                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */


																																				 /*
╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ dbo.FunctionalDepartment                                                                                                                      ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝ */

GO
