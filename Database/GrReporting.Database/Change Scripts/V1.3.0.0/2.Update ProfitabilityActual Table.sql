
--Add the new GlAccountCategoryKey columns with the FK

--EUCorporateGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD EUCorporateGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKEUCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	EUCorporateGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO


--USPropertyGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD USPropertyGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKUSPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	USPropertyGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--USFundGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD USFundGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKUSFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	USFundGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--EUPropertyGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD EUPropertyGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKEUPropertyGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	EUPropertyGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--USCorporateGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD USCorporateGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKUSCorporateGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	USCorporateGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--DevelopmentGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD DevelopmentGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKDevelopmentGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	DevelopmentGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--EUFundGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD EUFundGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKEUFundGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	EUFundGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO
--GlobalGlAccountCategoryKey
ALTER TABLE dbo.ProfitabilityActual ADD GlobalGlAccountCategoryKey int NULL
GO
ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
	FKGlobalGlAccountCategoryKey_ProfitabilityActual_GlAccountCategory FOREIGN KEY
	(
	GlobalGlAccountCategoryKey
	) REFERENCES dbo.GlAccountCategory
	(
	GlAccountCategoryKey
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
GO



Update dbo.Reimbursable Set [ReimbursableName]= 'UNKNOWN' Where [ReimbursableCode] = 'UNKNOWN'
