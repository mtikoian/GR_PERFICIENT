USE GrReporting
GO

-- New Dimension
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'GLCategorizationHierarchy')
BEGIN
	CREATE TABLE dbo.GLCategorizationHierarchy(
		GLCategorizationHierarchyKey INT NOT NULL IDENTITY(1,1),
		GLCategorizationHierarchyCode VARCHAR(50) NOT NULL,
		GLCategorizationTypeName VARCHAR(50) NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		GLMajorCategoryName VARCHAR(400) NOT NULL,
		GLMinorCategoryName VARCHAR(400) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL,
		GLAccountCode VARCHAR(10) NOT NULL,
		InflowOutflow VARCHAR(7) NOT NULL,
		FeeOrExpenseMultiplicationFactor AS (CASE WHEN InflowOutflow = 'Inflow' THEN (1) ELSE (-1) END),
		SnapshotId INT NOT NULL,
		StartDate DATETIME NOT NULL,
		EndDate DATETIME NOT NULL,
		ReasonForChange NVARCHAR(1024) NULL
	CONSTRAINT [PK_GLCategorizationHierarchy] PRIMARY KEY CLUSTERED(
			GLCategorizationHierarchyKey ASC
		)
	) ON [PRIMARY]
	

	ALTER TABLE dbo.GLCategorizationHierarchy
		ADD CONSTRAINT [DF_GLCategorizationHierarchy_GLCategorizationTypeName] DEFAULT ('') FOR GLCategorizationTypeName
		
	ALTER TABLE dbo.GLCategorizationHierarchy
		ADD CONSTRAINT [DF_GLCategorizationHierarchy_GLCategorizationName] DEFAULT ('') FOR GLCategorizationName
		
	ALTER TABLE dbo.GLCategorizationHierarchy
		ADD CONSTRAINT [DF_GLCategorizationHierarchy_GLFinancialCategoryName] DEFAULT ('') FOR GLFinancialCategoryName

	ALTER TABLE dbo.GLCategorizationHierarchy
		ADD CONSTRAINT [DF_GLCategorizationHierarchy_GLMajorCategoryName] DEFAULT ('') FOR GLMajorCategoryName

	ALTER TABLE dbo.GLCategorizationHierarchy
		ADD CONSTRAINT [DF_GLCategorizationHierarchy_GLMinorCategoryName] DEFAULT ('') FOR GLMinorCategoryName

END	
		
IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_GLCategorizationHierarchy_GLCategorizationHierarchyCode')
DROP INDEX IX_GLCategorizationHierarchy_GLCategorizationHierarchyCode ON dbo.GLCategorizationHierarchy
GO

CREATE NONCLUSTERED INDEX IX_GLCategorizationHierarchy_GLCategorizationHierarchyCode ON
	dbo.GLCategorizationHierarchy
	(	
		GLCategorizationHierarchyCode,
		SnapshotId
	
	)
GO

-- ProfitabilityActual

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'GlobalGLCategorizationHierarchyKey' AND TABLE_NAME = 'ProfitabilityActual')
BEGIN
	
	ALTER TABLE dbo.ProfitabilityActual 
		DROP CONSTRAINT 
			FK_ProfitabilityActual_EUCorporate_GlAccountCategory,
			FK_ProfitabilityActual_USCorporate_GlAccountCategory,
			FK_ProfitabilityActual_Development_GlAccountCategory,
			FK_ProfitabilityActual_EUFund_GlAccountCategory,
			FK_ProfitabilityActual_EUProperty_GlAccountCategory,
			FK_ProfitabilityActual_USFund_GlAccountCategory,
			FK_ProfitabilityActual_USProperty_GlAccountCategory
	
	ALTER TABLE dbo.ProfitabilityActual 
		ALTER COLUMN GlAccountKey INT NULL
		
	ALTER TABLE dbo.ProfitabilityActual 
		ALTER COLUMN GlobalGlAccountCategoryKey INT NULL
	
	ALTER TABLE dbo.ProfitabilityActual
		ADD 
			[GlobalGLCategorizationHierarchyKey] [int] NULL,
			[EUDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[EUPropertyGLCategorizationHierarchyKey] [int] NULL,
			[EUFundGLCategorizationHierarchyKey] [int] NULL,
			[USDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[USPropertyGLCategorizationHierarchyKey] [int] NULL,
			[USFundGLCategorizationHierarchyKey] [int] NULL,
			[ReportingGLCategorizationHierarchyKey] [int] NULL,
			InsertedDate DATETIME NULL,
			UpdatedDate DATETIME NULL
	
	PRINT 'EUDevelopmentGlAccountCategoryKey & USDevelopmentGlAccountCategoryKey columns added to the dbo.ProfitabilityActual table'
			
	ALTER TABLE dbo.ProfitabilityActual
		DROP COLUMN
			--[GlAccountKey],
			--[GlobalGlAccountCategoryKey],
			[EUCorporateGlAccountCategoryKey],
			[USPropertyGlAccountCategoryKey],
			[USFundGlAccountCategoryKey],
			[EUPropertyGlAccountCategoryKey],
			[USCorporateGlAccountCategoryKey],
			[DevelopmentGlAccountCategoryKey],
			[EUFundGlAccountCategoryKey]
			
	
	PRINT 'EUCorporateGlAccountCategoryKey, USCorporateGlAccountCategoryKey & DevelopmentGlAccountCategoryKey columns dropped from the dbo.ProfitabilityActual table'	

	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Reporting_GLCategorizationHierarchy] FOREIGN KEY([ReportingGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
		
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUDevelopment_GLCategorizationHierarchy] FOREIGN KEY([EUDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USDevelopment_GLCategorizationHierarchy] FOREIGN KEY([USDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USProperty_GLCategorizationHierarchy] FOREIGN KEY([USPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_USFund_GLCategorizationHierarchy] FOREIGN KEY([USFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUProperty_GLCategorizationHierarchy] FOREIGN KEY([EUPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_EUFund_GLCategorizationHierarchy] FOREIGN KEY([EUFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_Global_GLCategorizationHierarchy] FOREIGN KEY([GlobalGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])	
	
	ALTER TABLE [dbo].[ProfitabilityActual]  
		ADD  CONSTRAINT [DF_ProfitabilityActual_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
		
END

-- ProfitabilityBudget

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'GlobalGLCategorizationHierarchyKey' AND TABLE_NAME = 'ProfitabilityBudget')
BEGIN
	
	ALTER TABLE dbo.ProfitabilityBudget 
		DROP CONSTRAINT 
			FK_ProfitabilityBudget_EUCorporate_GlAccountCategory,
			FK_ProfitabilityBudget_USCorporate_GlAccountCategory,
			FK_ProfitabilityBudget_Development_GlAccountCategory,
			FK_ProfitabilityBudget_EUFund_GlAccountCategory,
			FK_ProfitabilityBudget_EUProperty_GlAccountCategory,
			FK_ProfitabilityBudget_USFund_GlAccountCategory,
			FK_ProfitabilityBudget_USProperty_GlAccountCategory
	
	ALTER TABLE dbo.ProfitabilityBudget
		ADD 
			[GlobalGLCategorizationHierarchyKey] [int] NULL,
			[EUDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[EUPropertyGLCategorizationHierarchyKey] [int] NULL,
			[EUFundGLCategorizationHierarchyKey] [int] NULL,
			[USDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[USPropertyGLCategorizationHierarchyKey] [int] NULL,
			[USFundGLCategorizationHierarchyKey] [int] NULL,
			[ReportingGLCategorizationHierarchyKey] [int] NULL,
			InsertedDate DATETIME NULL,
			UpdatedDate DATETIME NULL
	
	ALTER TABLE dbo.ProfitabilityBudget 
		ALTER COLUMN GlAccountKey INT NULL
		
	ALTER TABLE dbo.ProfitabilityBudget 
		ALTER COLUMN GlobalGlAccountCategoryKey INT NULL
	
	PRINT 'EUDevelopmentGlAccountCategoryKey & USDevelopmentGlAccountCategoryKey columns added to the dbo.ProfitabilityBudget table'
			
	ALTER TABLE dbo.ProfitabilityBudget
		DROP COLUMN
			--[GlAccountKey],
			--[GlobalGlAccountCategoryKey],
			[EUCorporateGlAccountCategoryKey],
			[USPropertyGlAccountCategoryKey],
			[USFundGlAccountCategoryKey],
			[EUPropertyGlAccountCategoryKey],
			[USCorporateGlAccountCategoryKey],
			[DevelopmentGlAccountCategoryKey],
			[EUFundGlAccountCategoryKey]
	
	PRINT 'EUCorporateGlAccountCategoryKey, USCorporateGlAccountCategoryKey & DevelopmentGlAccountCategoryKey columns dropped from the dbo.ProfitabilityBudget table'	
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Reporting_GLCategorizationHierarchy] FOREIGN KEY([ReportingGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUDevelopment_GLCategorizationHierarchy] FOREIGN KEY([EUDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USDevelopment_GLCategorizationHierarchy] FOREIGN KEY([USDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USProperty_GLCategorizationHierarchy] FOREIGN KEY([USPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_USFund_GLCategorizationHierarchy] FOREIGN KEY([USFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUProperty_GLCategorizationHierarchy] FOREIGN KEY([EUPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_EUFund_GLCategorizationHierarchy] FOREIGN KEY([EUFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_Global_GLCategorizationHierarchy] FOREIGN KEY([GlobalGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])	
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  
		ADD  CONSTRAINT [DF_ProfitabilityBudget_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
			
END

-- ProfitabilityReforecast

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'GlobalGLCategorizationHierarchyKey' AND TABLE_NAME = 'ProfitabilityReforecast')
BEGIN
	
	ALTER TABLE dbo.ProfitabilityReforecast 
		DROP CONSTRAINT 
			FK_ProfitabilityReforecast_EUCorporate_GlAccountCategory,
			FK_ProfitabilityReforecast_USCorporate_GlAccountCategory,
			FK_ProfitabilityReforecast_Development_GlAccountCategory,
			FK_ProfitabilityReforecast_EUFund_GlAccountCategory,
			FK_ProfitabilityReforecast_EUProperty_GlAccountCategory,
			FK_ProfitabilityReforecast_USFund_GlAccountCategory,
			FK_ProfitabilityReforecast_USProperty_GlAccountCategory
	
	ALTER TABLE dbo.ProfitabilityReforecast
		ALTER COLUMN GlAccountKey INT NULL
		
	ALTER TABLE dbo.ProfitabilityReforecast
		ALTER COLUMN GlobalGlAccountCategoryKey INT NULL
	
	ALTER TABLE dbo.ProfitabilityReforecast
		ADD 
			[GlobalGLCategorizationHierarchyKey] [int] NULL,
			[EUDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[EUPropertyGLCategorizationHierarchyKey] [int] NULL,
			[EUFundGLCategorizationHierarchyKey] [int] NULL,
			[USDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[USPropertyGLCategorizationHierarchyKey] [int] NULL,
			[USFundGLCategorizationHierarchyKey] [int] NULL,
			[ReportingGLCategorizationHierarchyKey] [int] NULL,
			InsertedDate DATETIME NULL,
			UpdatedDate DATETIME NULL
	
	PRINT 'EUDevelopmentGlAccountCategoryKey & USDevelopmentGlAccountCategoryKey columns added to the dbo.ProfitabilityReforecast table'
			
	ALTER TABLE dbo.ProfitabilityReforecast
		DROP COLUMN
			--[GlAccountKey],
			--[GlobalGlAccountCategoryKey],
			[EUCorporateGlAccountCategoryKey],
			[USPropertyGlAccountCategoryKey],
			[USFundGlAccountCategoryKey],
			[EUPropertyGlAccountCategoryKey],
			[USCorporateGlAccountCategoryKey],
			[DevelopmentGlAccountCategoryKey],
			[EUFundGlAccountCategoryKey]
	
	PRINT 'EUCorporateGlAccountCategoryKey, USCorporateGlAccountCategoryKey & DevelopmentGlAccountCategoryKey columns dropped from the dbo.ProfitabilityReforecast table'	

	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Reporting_GLCategorizationHierarchy] FOREIGN KEY([ReportingGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
		
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUDevelopment_GLCategorizationHierarchy] FOREIGN KEY([EUDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USDevelopment_GLCategorizationHierarchy] FOREIGN KEY([USDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USProperty_GLCategorizationHierarchy] FOREIGN KEY([USPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_USFund_GLCategorizationHierarchy] FOREIGN KEY([USFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUProperty_GLCategorizationHierarchy] FOREIGN KEY([EUPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_EUFund_GLCategorizationHierarchy] FOREIGN KEY([EUFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_Global_GLCategorizationHierarchy] FOREIGN KEY([GlobalGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])

	ALTER TABLE [dbo].[ProfitabilityReforecast]  
		ADD  CONSTRAINT [DF_ProfitabilityReforecast_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]			
END

-- ProfitabilityActual

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'GlobalGLCategorizationHierarchyKey' AND TABLE_NAME = 'ProfitabilityActualArchive')
BEGIN

	ALTER TABLE dbo.ProfitabilityActualArchive 
		DROP CONSTRAINT 
			FKDevelopmentGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory,
			FKEUCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory,
			FKEUFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory,
			FKEUPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory,
			FKUSCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory,
			FKUSFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory,
			FKUSPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory

	ALTER TABLE dbo.ProfitabilityActualArchive
		ALTER COLUMN GlAccountKey INT NULL
		
	ALTER TABLE dbo.ProfitabilityActualArchive
		ALTER COLUMN GlobalGlAccountCategoryKey INT NULL
					
	ALTER TABLE dbo.ProfitabilityActualArchive
		ADD 
			[GlobalGLCategorizationHierarchyKey] [int] NULL,
			[EUDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[EUPropertyGLCategorizationHierarchyKey] [int] NULL,
			[EUFundGLCategorizationHierarchyKey] [int] NULL,
			[USDevelopmentGLCategorizationHierarchyKey] [int] NULL,
			[USPropertyGLCategorizationHierarchyKey] [int] NULL,
			[USFundGLCategorizationHierarchyKey] [int] NULL,
			[ReportingGLCategorizationHierarchyKey] [int] NULL
	
	PRINT 'EUDevelopmentGlAccountCategoryKey & USDevelopmentGlAccountCategoryKey columns added to the dbo.ProfitabilityActualArchive table'
			
	ALTER TABLE dbo.ProfitabilityActualArchive
		DROP COLUMN
			--[GlAccountKey],
			--[GlobalGlAccountCategoryKey],
			[EUCorporateGlAccountCategoryKey],
			[USPropertyGlAccountCategoryKey],
			[USFundGlAccountCategoryKey],
			[EUPropertyGlAccountCategoryKey],
			[USCorporateGlAccountCategoryKey],
			[DevelopmentGlAccountCategoryKey],
			[EUFundGlAccountCategoryKey]
			
	
	PRINT 'EUCorporateGlAccountCategoryKey, USCorporateGlAccountCategoryKey & DevelopmentGlAccountCategoryKey columns dropped from the dbo.ProfitabilityActualArchive table'	

	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Reporting_GLCategorizationHierarchy] FOREIGN KEY([ReportingGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
		
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUDevelopment_GLCategorizationHierarchy] FOREIGN KEY([EUDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USDevelopment_GLCategorizationHierarchy] FOREIGN KEY([USDevelopmentGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USProperty_GLCategorizationHierarchy] FOREIGN KEY([USPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_USFund_GLCategorizationHierarchy] FOREIGN KEY([USFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActuaArchivel_EUProperty_GLCategorizationHierarchy] FOREIGN KEY([EUPropertyGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_EUFund_GLCategorizationHierarchy] FOREIGN KEY([EUFundGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])
	
	ALTER TABLE [dbo].[ProfitabilityActualArchive]  
		WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Global_GLCategorizationHierarchy] FOREIGN KEY([GlobalGLCategorizationHierarchyKey])
	REFERENCES [dbo].[GLCategorizationHierarchy] ([GLCategorizationHierarchyKey])	
	
		
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'LastDate' AND TABLE_NAME = 'ProfitabilityActual')
BEGIN
	EXEC sp_rename '[dbo].[ProfitabilityActual].[EntryDate]', 'LastDate', 'COLUMN';
	PRINT 'Column EntryDate of ProfitabilityActual renamed to LastDate'
END

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'LastDate' AND TABLE_NAME = 'ProfitabilityActualArchive')
BEGIN
	EXEC sp_rename '[dbo].[ProfitabilityActualArchive].[EntryDate]', 'LastDate', 'COLUMN';
	PRINT 'Column EntryDate of ProfitabilityActualArchive renamed to LastDate'
END

IF (EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SourceSystem') AND EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProfitabilityActualSourceTable'))
BEGIN

	DROP TABLE dbo.SourceSystem
	
	PRINT 'dbo.SourceSystem table dropped' 
END
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_ProfitabilityActualSourceTable]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
BEGIN
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_ProfitabilityActualSourceTable]
PRINT '[FK_ProfitabilityActual_ProfitabilityActualSourceTable] foreign key constraint dropped'
END
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
BEGIN
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable]
PRINT '[FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable] foreign key constraint dropped'
END
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualSourceTable]') AND name = N'PK_ProfitabilityActualSourceTable')
BEGIN
	ALTER TABLE [dbo].[ProfitabilityActualSourceTable] DROP CONSTRAINT [PK_ProfitabilityActualSourceTable]
	PRINT '[PK_ProfitabilityActualSourceTable] primary key constraint dropped'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SourceSystem')
BEGIN

	EXEC sp_rename 'dbo.[ProfitabilityActualSourceTable]', 'SourceSystem';
	PRINT 'ProfitabilityActualSourceTable renamed to SourceSystem' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'SourceSystem')
BEGIN

	EXEC sp_rename '[dbo].[SourceSystem].[ProfitabilityActualSourceTableId]', 'SourceSystemKey', 'COLUMN';
	PRINT 'ProfitabilityActualSourceTableId renamed to SourceSystemKey in ProfitabilityActualSourceTable' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SourceSystem]') AND name = N'PK_SourceSystem')
BEGIN
	ALTER TABLE [dbo].[SourceSystem] 
	ADD CONSTRAINT [PK_SourceSystem] PRIMARY KEY CLUSTERED 
	(
		[SourceSystemKey] ASC
	)
	PRINT 'PK_SourceSystem Primary Key Constraint created'
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceTableName' AND TABLE_NAME = 'SourceSystem')
BEGIN

	EXEC sp_rename 'dbo.SourceSystem.SourceTable', 'SourceTableName', 'COLUMN';
	PRINT 'SourceTable column renamed to SourceTableName' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemName' AND TABLE_NAME = 'SourceSystem')
BEGIN
	ALTER TABLE dbo.SourceSystem
		ADD SourceSystemName VARCHAR(256) NULL
	PRINT 'SourceSystemName column added' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'ProfitabilityActual')
BEGIN

	EXEC sp_rename 'dbo.ProfitabilityActual.ProfitabilityActualSourceTableId', 'SourceSystemKey', 'COLUMN';
	
	PRINT 'ProfitabilityActualSourceTableId column renamed to SourceSystemKey in the ProfitabilityActual table' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'ProfitabilityActualArchive')
BEGIN

	EXEC sp_rename 'dbo.ProfitabilityActualArchive.ProfitabilityActualSourceTableId', 'SourceSystemKey', 'COLUMN';

	PRINT 'ProfitabilityActualSourceTableId column renamed to SourceSystemKey in the ProfitabilityActualArchive table' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'ProfitabilityBudget')
BEGIN

	EXEC sp_rename 'dbo.ProfitabilityBudget.SourceSystemId', 'SourceSystemKey', 'COLUMN';
	
	PRINT 'SourceSystemId column renamed to SourceSystemKey in the ProfitabilityBudget table' 
END
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemKey' AND TABLE_NAME = 'ProfitabilityReforecast')
BEGIN


	EXEC sp_rename 'dbo.ProfitabilityReforecast.SourceSystemId', 'SourceSystemKey', 'COLUMN';
	
	PRINT 'SourceSystemId column renamed to SourceSystemKey in the ProfitabilityReforecast table' 
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_SourceSystem]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
BEGIN
	ALTER TABLE dbo.ProfitabilityActual
		ADD CONSTRAINT [FK_ProfitabilityActual_SourceSystem] FOREIGN KEY (SourceSystemKey)
			REFERENCES dbo.SourceSystem(SourceSystemKey)
			
	PRINT 'FK_ProfitabilityActual_SourceSystem foreign key constraint created'
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_SourceSystem]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
BEGIN
	ALTER TABLE dbo.ProfitabilityActualArchive
		ADD CONSTRAINT [FK_ProfitabilityActualArchive_SourceSystem] FOREIGN KEY (SourceSystemKey)
			REFERENCES dbo.SourceSystem(SourceSystemKey)
			
	PRINT 'FK_ProfitabilityActualArchive_SourceSystem foreign key constraint created'
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__FeeAd__61DC42C1]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__FeeAd__61DC42C1], [DF_ProfitabilityBudget_FeeAdjustmentKey]
	
	PRINT 'CONSTRAINT [DF__Profitabi__FeeAd__61DC42C1] on the ProfitabilityBudget table renamed to [DF_ProfitabilityBudget_FeeAdjustmentKey]'
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Overh__1590F0F1]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__Overh__1590F0F1], [DF_ProfitabilityBudget_OverheadKey]
	
	PRINT 'CONSTRAINT [DF__Profitabi__Overh__1590F0F1] on the ProfitabilityBudget table renamed to [DF_ProfitabilityBudget_OverheadKey]'
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__FeeAd__63C48B33]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__FeeAd__63C48B33], [DF_ProfitabilityReforecast_FeeAdjustmentKey]
	
	PRINT 'CONSTRAINT [DF__Profitabi__FeeAd__63C48B33] on the ProfitabilityReforecast table renamed to [DF_ProfitabilityReforecast_FeeAdjustmentKey]'
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Overh__17793963]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__Overh__17793963], [DF_ProfitabilityReforecast_OverheadKey]
	
	PRINT 'CONSTRAINT [DF__Profitabi__Overh__17793963] on the ProfitabilityReforecast table renamed to [DF_ProfitabilityReforecast_OverheadKey]'
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Overh__27AFA12C]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__Overh__27AFA12C], [DF_ProfitabilityActual_OverheadKey]
	
	PRINT 'CONSTRAINT [DF__Profitabi__Overh__27AFA12C] on the ProfitabilityActual table renamed to [DF_ProfitabilityActual_OverheadKey]'
END

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Inser__05257EFE]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__Inser__05257EFE], [DF_ProfitabilityActualArchive_InsertedDate]
	
	PRINT 'CONSTRAINT [DF__Profitabi__Inser__05257EFE] on the ProfitabilityActualArchive table renamed to [DF_ProfitabilityActualArchive_InsertedDate]'
END


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Overh__04315AC5]') AND type = 'D')
BEGIN
	EXEC sp_rename [DF__Profitabi__Overh__04315AC5], [DF_ProfitabilityActualArchive_OverheadKey]
	
	PRINT 'CONSTRAINT [DF__Profitabi__Overh__04315AC5] on the ProfitabilityActualArchive table renamed to [DF_ProfitabilityActualArchive_OverheadKey]'
END

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[OriginatingRegion]') AND name = N'IX_Name_SubName')
DROP INDEX [IX_Name_SubName] ON [dbo].[OriginatingRegion] WITH ( ONLINE = OFF )
GO

USE [GrReporting]
GO

CREATE NONCLUSTERED INDEX [IX_Name_SubName] ON [dbo].[OriginatingRegion] 
(
      [RegionName] ASC,
      [SubRegionName] ASC,
      [SnapshotId] ASC
)
INCLUDE ( [OriginatingRegionKey],
[RegionCode],
[SubRegionCode]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
