IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'Overhead')
	BEGIN

	CREATE TABLE dbo.Overhead
		(
		OverheadKey int NOT NULL,
		OverheadCode varchar(10) NOT NULL,
		OverheadName varchar(50) NOT NULL
		)  ON [PRIMARY]
	
	ALTER TABLE dbo.Overhead ADD CONSTRAINT
		PK_Overhead PRIMARY KEY CLUSTERED 
		(
		OverheadKey
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	END
GO

IF NOT EXISTS(sElect * From [Overhead] Where [OverheadCode] = 'UNKNOWN' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[Overhead]
			   ([OverheadKey]
			   ,[OverheadCode]
			   ,[OverheadName])
		 VALUES
			   (-1
			   ,'UNKNOWN'
			   ,'UNKNOWN')
	END
GO
IF NOT EXISTS(sElect * From [Overhead] Where [OverheadCode] = 'ALLOC' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[Overhead]
			   ([OverheadKey]
			   ,[OverheadCode]
			   ,[OverheadName])
		 VALUES
			   (1
			   ,'ALLOC'
			   ,'Allocated')
	END
GO

IF NOT EXISTS(Select * From [Overhead] Where [OverheadCode] = 'UNALLOC' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[Overhead]
			   ([OverheadKey]
			   ,[OverheadCode]
			   ,[OverheadName])
		 VALUES
			   (2
			   ,'UNALLOC'
			   ,'Unallocated')
	END
GO


IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityActual' 
AND COLUMN_NAME = 'OverheadKey')
	BEGIN
	ALTER TABLE dbo.ProfitabilityActual ADD OverheadKey int NOT NULL DEFAULT(-1)

	ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
		FK_ProfitabilityActual_Overhead FOREIGN KEY
		(
		OverheadKey
		) REFERENCES dbo.Overhead
		(
		OverheadKey
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityBudget' 
AND COLUMN_NAME = 'OverheadKey')
	BEGIN
	ALTER TABLE dbo.ProfitabilityBudget ADD OverheadKey int NOT NULL DEFAULT(-1)

	ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
		FK_ProfitabilityBudget_Overhead FOREIGN KEY
		(
		OverheadKey
		) REFERENCES dbo.Overhead
		(
		OverheadKey
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityReforecast' 
AND COLUMN_NAME = 'OverheadKey')
	BEGIN
	ALTER TABLE dbo.ProfitabilityReforecast ADD OverheadKey int NOT NULL DEFAULT(-1)

	ALTER TABLE dbo.ProfitabilityReforecast ADD CONSTRAINT
		FK_ProfitabilityReforecast_Overhead FOREIGN KEY
		(
		OverheadKey
		) REFERENCES dbo.Overhead
		(
		OverheadKey
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
GO