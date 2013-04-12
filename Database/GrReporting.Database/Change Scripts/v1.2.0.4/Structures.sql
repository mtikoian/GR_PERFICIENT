USE GrReporting
GO

IF (Select COUNT(*) From ProfitabilityActual) > 0 
	BEGIN
	PRINT 'ProfitabilityActual must be cleared before running this' 
	RETURN
	END


IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'ProfitabilityActualSourceTable')
	BEGIN
	CREATE TABLE dbo.ProfitabilityActualSourceTable
		(
		ProfitabilityActualSourceTableId int NOT NULL,
		SourceTable varchar(50) NOT NULL
		)  ON [PRIMARY]
	
	ALTER TABLE dbo.ProfitabilityActualSourceTable ADD CONSTRAINT
		PK_ProfitabilityActualSourceTable PRIMARY KEY CLUSTERED 
		(
		ProfitabilityActualSourceTableId
		) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	END

IF NOT EXISTS(Select * From ProfitabilityActualSourceTable
		Where ProfitabilityActualSourceTableId = 1)
		BEGIN
		Insert Into ProfitabilityActualSourceTable
		(ProfitabilityActualSourceTableId, SourceTable)
		VALUES(1, 'JOURNAL')
		END

IF NOT EXISTS(Select * From ProfitabilityActualSourceTable
		Where ProfitabilityActualSourceTableId = 2)
		BEGIN
		Insert Into ProfitabilityActualSourceTable
		(ProfitabilityActualSourceTableId, SourceTable)
		VALUES(2, 'GHIS')
		END

IF NOT EXISTS(Select * From ProfitabilityActualSourceTable
		Where ProfitabilityActualSourceTableId = 3)
		BEGIN
		Insert Into ProfitabilityActualSourceTable
		(ProfitabilityActualSourceTableId, SourceTable)
		VALUES(3, 'BillingUploadDetail')
		END

IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'ProfitabilityActual'
		AND COLUMN_NAME = 'ProfitabilityActualSourceTableId')
	BEGIN
	
	ALTER TABLE dbo.ProfitabilityActual ADD ProfitabilityActualSourceTableId int NOT NULL

	ALTER TABLE dbo.ProfitabilityActual ADD CONSTRAINT
		FK_ProfitabilityActual_ProfitabilityActualSourceTable FOREIGN KEY
		(
		ProfitabilityActualSourceTableId
		) REFERENCES dbo.ProfitabilityActualSourceTable
		(
		ProfitabilityActualSourceTableId
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END
	


ALTER TABLE ProfitabilityActual ALTER COLUMN ReferenceCode Varchar(100) NOT NULL
