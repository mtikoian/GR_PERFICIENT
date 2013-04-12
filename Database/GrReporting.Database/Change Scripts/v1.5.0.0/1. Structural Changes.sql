--Correct the Q3 EffectivePeriod's

--update Reforecast 
--Set ReforecastEffectiveQuarter = 3, 
	--ReforecastQuarterName = 'Q2'
--Where ReforecastEffectivePeriod = 201009


GO

update Reforecast 
Set ReforecastEffectiveQuarter = 4, 
	ReforecastQuarterName = 'Q3'
Where ReforecastEffectivePeriod = 201009

GO

 IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'FeeAdjustment')
	BEGIN

	CREATE TABLE dbo.FeeAdjustment
		(
		FeeAdjustmentKey int NOT NULL,
		FeeAdjustmentCode varchar(10) NOT NULL,
		FeeAdjustmentName varchar(50) NOT NULL
		)  ON [PRIMARY]
	
	ALTER TABLE dbo.FeeAdjustment ADD CONSTRAINT
		PK_FeeAdjustment PRIMARY KEY CLUSTERED 
		(
		FeeAdjustmentKey
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	END
GO

IF NOT EXISTS(sElect * From [FeeAdjustment] Where [FeeAdjustmentCode] = 'UNKNOWN' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[FeeAdjustment]
			   ([FeeAdjustmentKey]
			   ,[FeeAdjustmentCode]
			   ,[FeeAdjustmentName])
		 VALUES
			   (-1
			   ,'UNKNOWN'
			   ,'UNKNOWN')
	END
GO
IF NOT EXISTS(sElect * From [FeeAdjustment] Where [FeeAdjustmentCode] = 'NORMAL' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[FeeAdjustment]
			   ([FeeAdjustmentKey]
			   ,[FeeAdjustmentCode]
			   ,[FeeAdjustmentName])
		 VALUES
			   (1
			   ,'NORMAL'
			   ,'Normal Transaction')
	END
GO

IF NOT EXISTS(Select * From [FeeAdjustment] Where [FeeAdjustmentCode] = 'FEEADJUST' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[FeeAdjustment]
			   ([FeeAdjustmentKey]
			   ,[FeeAdjustmentCode]
			   ,[FeeAdjustmentName])
		 VALUES
			   (2
			   ,'FEEADJUST'
			   ,'Fee Adjustment')
	END
GO


/*IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityActual' 
AND COLUMN_NAME = 'FeeAdjustmentKey')
	BEGIN
	ALTER TABLE dbo.ProfitabilityActual ADD FeeAdjustmentKey int NOT NULL DEFAULT(-1)

	ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
		FK_ProfitabilityActual_FeeAdjustment FOREIGN KEY
		(
		FeeAdjustmentKey
		) REFERENCES dbo.FeeAdjustment
		(
		FeeAdjustmentKey
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
*/	
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityBudget' 
AND COLUMN_NAME = 'FeeAdjustmentKey')
	BEGIN
	ALTER TABLE dbo.ProfitabilityBudget ADD FeeAdjustmentKey int NOT NULL DEFAULT(-1)

	ALTER TABLE dbo.ProfitabilityBudget ADD CONSTRAINT
		FK_ProfitabilityBudget_FeeAdjustment FOREIGN KEY
		(
		FeeAdjustmentKey
		) REFERENCES dbo.FeeAdjustment
		(
		FeeAdjustmentKey
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityReforecast' 
AND COLUMN_NAME = 'FeeAdjustmentKey')
	BEGIN
	ALTER TABLE dbo.ProfitabilityReforecast ADD FeeAdjustmentKey int NOT NULL DEFAULT(-1)

	ALTER TABLE dbo.ProfitabilityReforecast ADD CONSTRAINT
		FK_ProfitabilityReforecast_FeeAdjustment FOREIGN KEY
		(
		FeeAdjustmentKey
		) REFERENCES dbo.FeeAdjustment
		(
		FeeAdjustmentKey
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
GO 

--Previosuly we never had any FeeAdjustments
Update GrReporting.dbo.ProfitabilityReforecast Set FeeAdjustmentKey = 1 
Update GrReporting.dbo.ProfitabilityBudget Set FeeAdjustmentKey = 1 

