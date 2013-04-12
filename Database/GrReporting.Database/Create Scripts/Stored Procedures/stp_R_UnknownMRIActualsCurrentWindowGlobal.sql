﻿
/****** Object:  StoredProcedure [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]    Script Date: 01/23/2012 17:54:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]
GO

--exec stp_S_UnknownSummaryMRIActuals @BudgetYear=2010, @BudgetQuarter='Q2', @DataPriorToDate='2010-12-31', @StartPeriod=201001, @EndPeriod=201002

CREATE PROCEDURE [dbo].[stp_S_UnknownMRIActualsCurrentWindowGlobal]
	@BudgetAllocationSetId int,
	@GBSAccounts bit = 0,
	@StartPeriod int,
	@EndPeriod int,
	@Sources varchar(max)
AS

BEGIN

DECLARE @DataPriorToDate DATETIME
SET @DataPriorToDate = 
(
	SELECT
		ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = 'ActualDataPriorToDate'
)

-- Get the period in int form from a datetime
DECLARE @WindowStartPeriod INT
SET @WindowStartPeriod = 
(
	SELECT
		CONVERT(INT, (YEAR(ConfiguredValue) + MONTH(ConfiguredValue)*0.01)*100)  AS ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = 'ActualImportStartDate'
)

-- Get the period in int form from a datetime
DECLARE @WindowEndPeriod INT
SET @WindowEndPeriod = 
(
	SELECT
		CONVERT(INT, (YEAR(ConfiguredValue) + MONTH(ConfiguredValue)*0.01)*100)  AS ConfiguredValue
	FROM GrReportingStaging.dbo.SSISConfigurations
	WHERE ConfigurationFilter = 'ActualImportEndDate'
)

IF @StartPeriod < @WindowStartPeriod
	SET @StartPeriod = @WindowStartPeriod
	
IF @EndPeriod > @WindowEndPeriod
	SET @EndPeriod = @WindowEndPeriod

EXECUTE [stp_S_UnknownSummaryMRIActualsGlobal] 
   @DataPriorToDate
  ,@StartPeriod
  ,@EndPeriod
  ,@BudgetAllocationSetId
  ,@GBSAccounts
  ,@Sources


END








GO


