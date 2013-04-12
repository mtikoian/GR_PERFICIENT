/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 12/21/2009 12:46:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_J_UpdateSSISConfigurationsImportWindow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
GO

/****** Object:  StoredProcedure [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]    Script Date: 12/21/2009 12:46:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

CREATE PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
	@JobName varchar(500),
	@SucessfulStepCount int
AS

DECLARE @JobId uniqueidentifier

SELECT
	@JobId = j.job_id
FROM
	msdb.dbo.sysjobhistory h
	
	INNER JOIN msdb.dbo.sysjobs j ON
		h.job_id = j.job_id
WHERE
	j.name 	= @JobName AND
	h.run_status = 4 AND -- In Progress
	h.run_date = CONVERT(varchar, getdate(), 112)
	
IF @JobId IS NOT NULL
BEGIN
	
	DECLARE @SucessfulSteps int
	SELECT
		@SucessfulSteps = COUNT(*)
	FROM
		msdb.dbo.sysjobsteps 
	WHERE 
		job_id = @JobId AND
		last_run_outcome = 1 -- Succeeded
	
	DECLARE @StopDate datetime,
			@NewStartDate datetime,
			@Yesterday datetime
			
	-- Only updates the imports dates if all steps have run sucesfully		
	IF @SucessfulSteps = @SucessfulStepCount
	BEGIN
			
		SELECT
			@StopDate = CONVERT(datetime, [ConfiguredValue])
		FROM
			[GrReportingStaging].[dbo].[SSISConfigurations]
		WHERE
			[ConfigurationFilter] = 'ImportEndDate'
			
		SET @NewStartDate = DATEADD(DAY, 1, @StopDate)
		SET @Yesterday = DATEADD(day, -1, getdate())
		
		-- Sets the ImportStartDate to one day after the last import end date
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT('00' + DATENAME(DAY,@NewStartDate),2) + ' ' + -- two digit day value
								LEFT(CONVERT(varchar, @NewStartDate),3) + ' ' + -- Abbreviated month description
								DATENAME(YEAR,@NewStartDate)
		WHERE
			[ConfigurationFilter] = 'ImportStartDate'
			
		
		-- Sets the ImportEndDate and DataPriorToDate to yesterday	
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT('00' + DATENAME(DAY,@Yesterday),2) + ' ' + -- two digit day value
								LEFT(CONVERT(varchar, @Yesterday),3) + ' ' + -- Abbreviated month description
								DATENAME(YEAR,@Yesterday)
		WHERE
			[ConfigurationFilter] = 'ImportEndDate' OR 
			[ConfigurationFilter] = 'DataPriorToDate'
	END
		
		
		
END

GO


