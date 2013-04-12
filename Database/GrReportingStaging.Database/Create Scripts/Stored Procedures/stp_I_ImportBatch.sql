
/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 10/20/2009 12:06:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ImportBatch]
GO

CREATE PROCEDURE [dbo].[stp_I_ImportBatch]
	@PackageName		VARCHAR(100)
AS
	DECLARE @ImportStartDate DateTime
	DECLARE @ImportEndDate DateTime
	DECLARE @DataPriorToDate DateTime
	
	
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualImportStartDate')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualImportEndDate')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate')

	
	
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

GO
