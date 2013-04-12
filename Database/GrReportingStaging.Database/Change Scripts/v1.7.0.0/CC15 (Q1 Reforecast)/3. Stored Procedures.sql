﻿/*

	1. GrReportingStaging.dbo.stp_I_BudgetsToProcess -- executed in GrReporting -> CC15 (Q1 Reforecast)
	2. GrReportingStaging.dbo.stp_D_GdmSnapshot
	3. GrReportingStaging.dbo.stp_U_SyncBudgetsProcessed
	4. GrReportingStaging.dbo.stp_IU_LoadExchangeRates

*/

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. GrReportingStaging.dbo.stp_D_GdmSnapshot --------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_D_GdmSnapshot]    Script Date: 05/02/2011 11:46:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GdmSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_GdmSnapshot]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_D_GdmSnapshot]    Script Date: 05/02/2011 11:46:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_D_GdmSnapshot]

AS

--------------------------------------------------------------------------------------------------------------------------------------------

-- Find all of the snapshot table names in GrReportingStaging

CREATE TABLE #AllSnapshotTables (
	TableName VARCHAR(128) NOT NULL
)

INSERT INTO #AllSnapshotTables (
	TableName
)
SELECT
	LTRIM(RTRIM(TABLE_NAME))
FROM
	INFORMATION_SCHEMA.TABLES
WHERE
	TABLE_TYPE = 'BASE TABLE' AND
	TABLE_SCHEMA = 'Gdm' AND
	LEFT(TABLE_NAME, 8) = 'Snapshot'

------------------------------------------------------------

DECLARE tableCursor CURSOR FOR SELECT TableName FROM #AllSnapshotTables
DECLARE @CurrentTableName VARCHAR(128)

OPEN tableCursor

FETCH NEXT FROM tableCursor
INTO @CurrentTableName

WHILE @@FETCH_STATUS = 0 -- Loop through all snapshot table names, and execute the delete statement on each of them
BEGIN

	DECLARE @Query VARCHAR(MAX) = '
	DELETE
		S
	FROM
		Gdm.[' + @CurrentTableName + '] S
		INNER JOIN dbo.BudgetsToProcessCurrent(NULL) BTPC ON
			S.SnapshotId = BTPC.SnapshotId
	WHERE
		BTPC.ImportSnapshotFromSourceSystem = 1'

	EXEC(@Query)
	--PRINT(@Query)
	
	FETCH NEXT FROM tableCursor
	INTO @CurrentTableName

END

CLOSE tableCursor
DEALLOCATE tableCursor


GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. GrReportingStaging.dbo.stp_U_SyncBudgetsProcessed -----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_U_SyncBudgetsProcessed]    Script Date: 05/02/2011 11:46:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_SyncBudgetsProcessed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_U_SyncBudgetsProcessed]    Script Date: 05/02/2011 11:46:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_U_SyncBudgetsProcessed]	

AS

-- Update GBS.dbo.Budget  

UPDATE
	Budget
SET
	Budget.ImportBudgetIntoGR = 0,
	Budget.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.GBS.dbo.Budget Budget
	INNER JOIN dbo.BudgetsToProcess BTP ON
		Budget.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND
	BTP.BudgetSourceSystemSyncd IS NULL AND
	Budget.IsActive = 1

-- Update GBS.dbo.Budget  

UPDATE
	TAPAS
SET
	TAPAS.ImportBudgetIntoGR = 0,
	TAPAS.LastImportBudgetIntoGRDate = BTP.DateBudgetProcessedIntoWarehouse
FROM
	SERVER3.TAPASUS_Budgeting.Budget.Budget TAPAS
	INNER JOIN dbo.BudgetsToProcess BTP ON
		TAPAS.BudgetId = BTP.BudgetId

WHERE
	BTP.BudgetReforecastTypeName = 'TGB Budget/Reforecast' AND
	BTP.BudgetSourceSystemSyncd IS NULL AND
	TAPAS.IsDeleted = 0

-- Update GrReportingStaging.dbo.BudgetsToProcess

UPDATE
	dbo.BudgetsToProcess
SET
	BudgetSourceSystemSyncd = 1
WHERE
	BudgetSourceSystemSyncd IS NULL


GO

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. GrReportingStaging.dbo.stp_IU_LoadExchangeRates -------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 11/19/2009 09:51:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadExchangeRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 11/19/2009 09:51:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
	@ImportStartDate DATETIME = NULL,
	@ImportEndDate DATETIME = NULL,
	@DataPriorToDate DATETIME = NULL
AS

IF (@ImportStartDate IS NULL)
	BEGIN
		SET @ImportStartDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportStartDate'))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
		SET @ImportEndDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportEndDate'))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
		SET @DataPriorToDate = CONVERT(DATETIME, (SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
	END
	
SET NOCOUNT OFF
PRINT '####'
PRINT 'stp_IU_LoadExchangeRates'
PRINT '####'

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
--												Generate temp table to prevent repeated function calls
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||----

-- ..:: GrReportingStaging.dbo.BudgetsToProcess ::..

/* GrReportingStaging.dbo.BudgetsToProcess shows the budgets that are to be processed into the warehouse.
   Each budget is associated with an exchange rate - when a budget cycle is created, an exchange rate must be selected for that cycle. */

-- drop table #BudgetsToProcess

SELECT DISTINCT
	BudgetsToProcessCurrent.SnapshotId,
	BudgetsToProcessCurrent.BudgetExchangeRateId,
	BudgetsToProcessCurrent.BudgetReportGroupPeriodId,
	BudgetsToProcessCurrent.BudgetYear,
	BudgetsToProcessCurrent.BudgetQuarter
INTO
	#BudgetsToProcess
FROM
(
	SELECT
		*
	FROM
		dbo.BudgetsToProcessCurrent('GBS Budget/Reforecast')
	UNION ALL
	SELECT
		*
	FROM
		dbo.BudgetsToProcessCurrent('TGB Budget/Reforecast')
) BudgetsToProcessCurrent

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
--												Get all budget report groups which have been modified
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||----

-- Gdm.BudgetExchangeRate

--drop table #ExchangeRates
CREATE TABLE #ExchangeRates 
(
	SnapshotId INT NOT NULL,
	CurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    BudgetReportGroupPeriodId INT,
    BudgetExchangeRateId INT,
    BudgetExchangeRateDetailId INT,
    ReforecastKey INT NOT NULL
) 

INSERT INTO #ExchangeRates
SELECT
	BTP.SnapshotId,
	BudgetExchangeRateDetail.CurrencyCode,
	BudgetExchangeRateDetail.Period,
	BudgetExchangeRateDetail.Rate,
	BTP.BudgetReportGroupPeriodId,
	BudgetExchangeRateDetail.BudgetExchangeRateId,
	BudgetExchangeRateDetail.BudgetExchangeRateDetailId,
	Reforecast.ReforecastKey
FROM
	#BudgetsToProcess BTP

	INNER JOIN
	(
		SELECT
			MIN(ReforecastKey) AS ReforecastKey,
			ReforecastEffectiveYear,
			ReforecastQuarterName
		FROM
			GrReporting.dbo.Reforecast
		WHERE
			ReforecastQuarterName <> 'UNKNOWN'
		GROUP BY
			ReforecastEffectiveYear,
			ReforecastQuarterName
	) Reforecast ON
		BTP.BudgetYear = Reforecast.ReforecastEffectiveYear AND
		BTP.BudgetQuarter = Reforecast.ReforecastQuarterName

	INNER JOIN
	(
		SELECT
			BRGP.BudgetReportGroupPeriodId,
			Period
		FROM
			Gdm.BudgetReportGroupPeriod BRGP
			INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) BRGPA ON
				BRGP.ImportKey = BRGPA.ImportKey
		WHERE
			BRGP.IsDeleted = 0

	) BudgetReportGroupPeriod ON
		BTP.BudgetReportGroupPeriodId = BudgetReportGroupPeriod.BudgetReportGroupPeriodId

	INNER JOIN
	(
		SELECT
			BER.*
		FROM
		Gdm.BudgetExchangeRate BER
		INNER JOIN Gdm.BudgetExchangeRateActive(@DataPriorToDate) BERA ON
			BER.ImportKey = BERA.ImportKey

	) BudgetExchangeRate ON
		BTP.BudgetExchangeRateId = BudgetExchangeRate.BudgetExchangeRateId

	INNER JOIN
	(
		SELECT
			BERD.*
		FROM
			Gdm.BudgetExchangeRateDetail BERD
			INNER JOIN Gdm.BudgetExchangeRateDetailActive(@DataPriorToDate) BERDA ON
				BERD.ImportKey = BERDA.ImportKey

	) BudgetExchangeRateDetail ON
		BudgetExchangeRate.BudgetExchangeRateId = BudgetExchangeRateDetail.BudgetExchangeRateId
	
--Get the exchange rate for the given groups

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
--															Calculate the cross rates
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||----

CREATE TABLE #CrossCurrency (
	SourceCurrencyCode CHAR(3) NOT NULL,
    DestinationCurrencyCode CHAR(3) NOT NULL,
    Period INT NOT NULL,
    Rate DECIMAL(18, 12) NOT NULL,
    SourceReferenceCode VARCHAR(127) NOT NULL,
    DestinationReferenceCode VARCHAR(127) NOT NULL,
    BudgetExchangeRateId INT NULL,
    ReforecastKey INT NULL    
)
-- drop table #CrossCurrency
INSERT INTO #CrossCurrency
SELECT DISTINCT
	CurrencySource.CurrencyCode AS SourceCurrencyCode, 
	CurrencyDestination.CurrencyCode AS DestinationCurrencyCode,
	ExchangeRatesSource.Period, 
	(ExchangeRatesDestination.Rate / ExchangeRatesSource.Rate) AS Rate,
	
	'SnapshotId=' + LTRIM(RTRIM(STR(ExchangeRatesSource.SnapshotId))) +
	'&BudgetReportGroupPeriodId=' + LTRIM(RTRIM(STR(ExchangeRatesSource.BudgetReportGroupPeriodId))) +
    '&BudgetExchangeRateId=' + LTRIM(RTRIM(STR(ExchangeRatesSource.BudgetExchangeRateId))) +
    '&BudgetExchangeRateDetailId=' + LTRIM(RTRIM(STR(ExchangeRatesSource.BudgetExchangeRateDetailId))) AS SourceReferenceCode,

	'SnapshotId=' + LTRIM(RTRIM(STR(ExchangeRatesDestination.SnapshotId))) +
	'&BudgetReportGroupPeriodId=' + LTRIM(RTRIM(STR(ExchangeRatesDestination.BudgetReportGroupPeriodId))) +    
    '&BudgetExchangeRateId=' + LTRIM(RTRIM(STR(ExchangeRatesDestination.BudgetExchangeRateId))) +
    '&BudgetExchangeRateDetailId=' + LTRIM(RTRIM(STR(ExchangeRatesDestination.BudgetExchangeRateDetailId))) AS DestinationReferenceCode,
    ExchangeRatesSource.BudgetExchangeRateId,
    ExchangeRatesSource.ReforecastKey
FROM
	GrReporting.dbo.Currency CurrencySource

    CROSS JOIN GrReporting.dbo.Currency CurrencyDestination

    INNER JOIN #ExchangeRates ExchangeRatesSource ON
		ExchangeRatesSource.CurrencyCode = CurrencySource.CurrencyCode

    INNER JOIN #ExchangeRates ExchangeRatesDestination ON
		ExchangeRatesDestination.CurrencyCode = CurrencyDestination.CurrencyCode
WHERE  
	CurrencySource.CurrencyCode <> 'UNK' AND 
	CurrencyDestination.CurrencyCode <> 'UNK' AND
	ExchangeRatesSource.Period = ExchangeRatesDestination.Period AND
	-- The two conditions below prevent different exchange rate sets (BudgetExchangeRateIds) from joining onto each other
	ExchangeRatesSource.BudgetExchangeRateId = ExchangeRatesDestination.BudgetExchangeRateId AND
	ExchangeRatesSource.ReforecastKey = ExchangeRatesDestination.ReforecastKey

---------------------------------
-- Drop table #FactData
-- Build the fact
DECLARE @USDCurrencyKey INT

SELECT 
	@USDCurrencyKey = CurrencyKey
FROM
	GrReporting.dbo.Currency cur
WHERE  
	cur.CurrencyCode = 'USD'
	
IF (@USDCurrencyKey IS NULL)
BEGIN
	SET @USDCurrencyKey = -1
END

---------------------------------

CREATE TABLE #FactData 
(
	SourceCurrencyKey INT NOT NULL,
    DestinationCurrencyKey INT NOT NULL,
    CalendarKey INT NOT NULL,
    Rate DECIMAL(18, 12) NOT NULL,
    ReferenceCode VARCHAR(255) NOT NULL,
    BudgetExchangeRateId INT NOT NULL,
    ReforecastKey INT NOT NULL
)

---------------------------------

INSERT INTO #FactData

SELECT 
	ISNULL(curs.CurrencyKey, -1) AS SourceCurrencyKey,
	ISNULL(curd.CurrencyKey, -1) AS DestinationCurrencyKey,
	c.CalendarKey,
	CASE WHEN
		cc.Rate IS NULL
	THEN
		0
    ELSE
		cc.Rate
    END AS Rate,
	('SRC:' + LTRIM(RTRIM(cc.SourceReferenceCode)) + ' DST:' + LTRIM(RTRIM(cc.DestinationReferenceCode))) AS ReferenceCode,
	cc.BudgetExchangeRateId,
	ISNULL(cc.ReforecastKey, -1) AS ReforecastKey
FROM 
	#CrossCurrency cc

	INNER JOIN GrReporting.dbo.Calendar c ON
		cc.Period = c.CalendarPeriod

    LEFT JOIN GrReporting.dbo.Currency curs ON
		curs.CurrencyCode = cc.SourceCurrencyCode

	LEFT JOIN GrReporting.dbo.Currency curd ON
		curd.CurrencyCode = cc.DestinationCurrencyCode

---------------------------------

INSERT INTO #FactData		
SELECT 
	@USDCurrencyKey AS SourceCurrencyKey,
    ISNULL(cur.CurrencyKey, -1) AS DestinationCurrencyKey,
    c.CalendarKey,
    er.Rate,

	'SnapshotId=' + LTRIM(RTRIM(STR(er.SnapshotId))) +
    '&BudgetReportGroupPeriodId=' + LTRIM(RTRIM(STR(er.BudgetReportGroupPeriodId))) +
    '&BudgetExchangeRateId=' + LTRIM(RTRIM(STR(er.BudgetExchangeRateId))) +
    '&BudgetExchangeRateDetailId=' + LTRIM(RTRIM(STR(er.BudgetExchangeRateDetailId))) AS ReferenceCode,
    er.BudgetExchangeRateId,
    er.ReforecastKey
FROM
	#ExchangeRates er

    INNER JOIN GrReporting.dbo.Calendar c ON
		er.Period = c.CalendarPeriod

    LEFT JOIN GrReporting.dbo.Currency cur ON
		cur.CurrencyCode = er.CurrencyCode

	LEFT JOIN #FactData fd ON
		fd.SourceCurrencyKey = @USDCurrencyKey AND
		fd.DestinationCurrencyKey = ISNULL(cur.CurrencyKey, -1) AND
		fd.CalendarKey = c.CalendarKey AND
		fd.BudgetExchangeRateId = er.BudgetExchangeRateId AND
		fd.ReforecastKey = er.ReforecastKey
WHERE
	fd.Rate IS NULL

---------------------------------

INSERT INTO #FactData
SELECT
	ISNULL(cur.CurrencyKey, -1) AS SourceCurrencyKey,
    @USDCurrencyKey AS DestinationCurrencyKey,
    c.CalendarKey,

    CASE WHEN
		er.Rate IS NULL
	THEN
		0
    ELSE
		(1 / er.Rate)
    END AS Rate,

    'SnapshotId=' + LTRIM(RTRIM(STR(er.SnapshotId))) +
    '&BudgetReportGroupPeriodId=' + LTRIM(RTRIM(STR(er.BudgetReportGroupPeriodId))) +
    '&BudgetExchangeRateId=' + LTRIM(RTRIM(STR(er.BudgetExchangeRateId))) +
    '&BudgetExchangeRateDetailId=' + LTRIM(RTRIM(STR(er.BudgetExchangeRateDetailId))) AS ReferenceCode,
    er.BudgetExchangeRateId,
    er.ReforecastKey
FROM
	#ExchangeRates er

    INNER JOIN GrReporting.dbo.Calendar c ON
		er.Period = c.CalendarPeriod

    LEFT JOIN GrReporting.dbo.Currency cur ON
		cur.CurrencyCode = er.CurrencyCode

	LEFT JOIN #FactData fd ON
		fd.SourceCurrencyKey = ISNULL(cur.CurrencyKey, -1) AND
		fd.DestinationCurrencyKey = @USDCurrencyKey AND
		fd.CalendarKey = c.CalendarKey AND
		fd.BudgetExchangeRateId = er.BudgetExchangeRateId AND
		fd.ReforecastKey = er.ReforecastKey
WHERE
	fd.Rate IS NULL

---------------------------------

IF ((SELECT COUNT(*) FROM #FactData WHERE SourceCurrencyKey = @USDCurrencyKey AND DestinationCurrencyKey = @USDCurrencyKey) <= 0)
BEGIN
	INSERT INTO #FactData
	SELECT DISTINCT
		@USDCurrencyKey AS SourceCurrencyKey,
		@USDCurrencyKey AS DestinationCurrencyKey,
		c.CalendarKey,
		1 AS Rate,
		'Default' AS ReferenceCode,
		er.BudgetExchangeRateId,
		er.ReforecastKey
	FROM
		#ExchangeRates er

		INNER JOIN GrReporting.dbo.Calendar c ON
			er.Period = c.CalendarPeriod

		LEFT JOIN #FactData fd ON 
			fd.SourceCurrencyKey = @USDCurrencyKey AND
			fd.DestinationCurrencyKey = @USDCurrencyKey AND
			fd.CalendarKey = c.CalendarKey AND
			fd.BudgetExchangeRateId = er.BudgetExchangeRateId AND
			fd.ReforecastKey = er.ReforecastKey
	WHERE
		fd.Rate IS NULL
END

---------------------------------

--Update the star schema
MERGE
	GrReporting.dbo.ExchangeRate AS d
USING
	#FactData AS s ON  
		d.SourceCurrencyKey = s.SourceCurrencyKey AND 
		d.DestinationCurrencyKey = s.DestinationCurrencyKey AND 
		d.CalendarKey = s.CalendarKey AND
		d.BudgetExchangeRateId = s.BudgetExchangeRateId AND
		d.ReforecastKey = s.ReforecastKey
WHEN MATCHED
THEN
	UPDATE
	SET 
		d.Rate = s.Rate,
		d.ReferenceCode = s.ReferenceCode
WHEN NOT MATCHED
THEN
	INSERT 
	VALUES
	  (
			s.SourceCurrencyKey,
			s.DestinationCurrencyKey,
			s.CalendarKey,
			s.Rate,
			s.ReferenceCode,
			s.ReforecastKey,
			s.BudgetExchangeRateId
	  );

PRINT 'Rows inserted/updated: '+CONVERT(CHAR(10),@@rowcount)
GO

--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
--																	Clean Up
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||----

IF 	OBJECT_ID('tempdb..#BudgetsToProcess') IS NOT NULL	
	DROP TABLE #BudgetsToProcess

IF 	OBJECT_ID('tempdb..#FactData') IS NOT NULL	
	DROP TABLE #FactData

IF 	OBJECT_ID('tempdb..#ExchangeRates') IS NOT NULL	
	DROP TABLE #ExchangeRates

IF 	OBJECT_ID('tempdb..#CrossCurrency') IS NOT NULL	
	DROP TABLE #CrossCurrency

-------------------------------------------------------------------------------------------------------------------------------------------------
-- .  --------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
