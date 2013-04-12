 /*
 
 1. Create dbo.BudgetReforecastType
 2. Add ReforecastKey to dbo.ProfitabilityBudget
 
 
 
 Tables to create:
 
	GrReporting.dbo.BudgetReforecastType
 
 Tables to modify:
 
	GrReporting.dbo.ProfitabilityBudget
	GrReporting.dbo.ProfitabilityReforecast
	GrReporting.dbo.ExchangeRate + data update
 
 Update dbo.ProfitabilityBudget/Reforecast.SourceSystem data
 
 */

-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| Update dbo.Reforecast data||||||||||||||||||||||||||||||||||||||||||||||||||||||--
------------------------------------------------------------------------------------------------------------------------------------------------

-- Although this is not a structural change, the dbo.Reforecast table has to be updated before any other updates are made to avoid potential
-- disaster.

USE [GrReporting]
GO

UPDATE
	dbo.Reforecast
SET
	ReforecastKey = DATEDIFF(DD, '1900-01-01 00:00:00', LEFT(ReforecastEffectivePeriod, 4) + '-' + RIGHT(ReforecastEffectivePeriod, 2) + '-01')
WHERE
	ReforecastEffectiveYear = 2011

------------------------------------------------------------------------------------------------------------------------------------------------
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| BudgetReforecastType |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
------------------------------------------------------------------------------------------------------------------------------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BudgetReforecastType]') AND type in (N'U'))
DROP TABLE [dbo].[BudgetReforecastType]
GO

PRINT ('Table dbo.BudgetReforecastType dropped.')

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[BudgetReforecastType](
	[BudgetReforecastTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[BudgetReforecastTypeCode] [char](6) NOT NULL,
	[BudgetReforecastTypeName] [varchar](25) NOT NULL,
	[BudgetReforecastSubTypeName] [char](6) NOT NULL,
 CONSTRAINT [PK_BudgetReforecastTypeKey] PRIMARY KEY CLUSTERED 
(
	[BudgetReforecastTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

PRINT ('Table dbo.BudgetReforecastType created.')

SET ANSI_PADDING OFF
GO

-- Insert data into dbo.BudgetReforecastType

USE [GrReporting]
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BudgetReforecastType')
BEGIN

	IF NOT EXISTS (SELECT * FROM dbo.BudgetReforecastType WHERE BudgetReforecastTypeCode IN ('GBSACT', 'GBSBUD', 'BCSACT', 'BCSBUD', 'TGBACT', 'TGBBUD'))
	BEGIN
	
		INSERT INTO
			dbo.BudgetReforecastType
		SELECT
			'GBSACT' AS BudgetReforecastTypeCode,
			'GBS Budget/Reforecast' AS BudgetReforecastTypeName,
			'Actual' AS BudgetReforecastSubTypeName
		UNION ALL
		SELECT
			'GBSBUD' AS BudgetReforecastTypeCode,
			'GBS Budget/Reforecast' AS BudgetReforecastTypeName,
			'Budget' AS BudgetReforecastSubTypeName
		UNION ALL
		SELECT
			'BCSACT' AS BudgetReforecastTypeCode,
			'BC Budget/Reforecast' AS BudgetReforecastTypeName,
			'Actual' AS BudgetReforecastSubTypeName
		UNION ALL
		SELECT
			'BCSBUD' AS BudgetReforecastTypeCode,
			'BC Budget/Reforecast' AS BudgetReforecastTypeName,
			'Budget' AS BudgetReforecastSubTypeName
		UNION ALL
		SELECT
			'TGBACT' AS BudgetReforecastTypeCode,
			'TGB Budget/Reforecast' AS BudgetReforecastTypeName,
			'Actual' AS BudgetReforecastSubTypeName
		UNION ALL
		SELECT
			'TGBBUD' AS BudgetReforecastTypeCode,
			'TGB Budget/Reforecast' AS BudgetReforecastTypeName,
			'Budget' AS BudgetReforecastSubTypeName

		PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' rows inserted into dbo.BudgetReforecastType')
	END
	ELSE
	BEGIN
		PRINT ('Unable to insert into dbo.BudgetReforecastType as some/all of the records have already been inserted.')
	END

END
ELSE
BEGIN
	PRINT ('Unable to insert into dbo.BudgetReforecastType as this table does not exist.')
END

GO

-- GrReportingStaging.dbo.BudgetProfitibilityUnknowns.BudgetReforecastType

USE GrReportingStaging
GO

IF NOT EXISTS 
(
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE 
		COLUMN_NAME = 'BudgetReforecastTypeKey' AND 
		TABLE_NAME = 'ProfitabilityBudgetUnknowns'
)
BEGIN
	ALTER TABLE
		dbo.ProfitabilityBudgetUnknowns
	ADD BudgetReforecastTypeKey INT NULL

	PRINT 'Added Column BudgetReforecastTypeKey to ProfitabilityBudgetUnknowns'
END

GO

---------------------- UPDATE --------------------------------------------------------------------------------------------------------------------
	-- GBS ----------------------

USE GrReportingStaging
GO

	DECLARE @BudgetReforecastTypeGBSBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType  
		WHERE BudgetReforecastTypeCode = 'GBSBUD')

	IF (@BudgetReforecastTypeGBSBudgetKey IS NOT NULL)
	BEGIN

		UPDATE
			dbo.ProfitabilityBudgetUnknowns
		SET
			BudgetReforecastTypeKey = @BudgetReforecastTypeGBSBudgetKey
		WHERE
			ReferenceCode LIKE 'GBS:%' AND
			BudgetReforecastTypeKey IS NULL

		PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityBudgetUnknowns updated for "GBS"')

	END
	ELSE
	BEGIN
		PRINT ('Cannot update "GBS" original budget records in dbo.ProfitabilityBudgetUnknowns because @BudgetReforecastTypeGBSBudgetKey is null.')
	END

GO
	-- TGB ------------------------

USE GrReportingStaging
GO

	DECLARE @BudgetReforecastTypeTAPASBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM GrReporting.dbo.BudgetReforecastType 
		WHERE BudgetReforecastTypeCode = 'TGBBUD')

	IF (@BudgetReforecastTypeTAPASBudgetKey IS NOT NULL)
	BEGIN

		UPDATE
			dbo.ProfitabilityBudgetUnknowns
		SET
			BudgetReforecastTypeKey = @BudgetReforecastTypeTAPASBudgetKey
		WHERE
			ReferenceCode LIKE 'TGB:%' AND
			BudgetReforecastTypeKey IS NULL

		PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityBudgetUnknowns updated for "TGB"')

	END
	ELSE
	BEGIN
		PRINT ('Cannot update "TGB" original budget records in dbo.ProfitabilityBudgetUnknowns because @BudgetReforecastTypeTAPASBudgetKey is null.')
	END

GO

	-- Perform check to see whether there are any records in dbo.ProfitabilityReforecast whose BudgetReforecastTypeKey is null

USE GrReportingStaging
GO

	DECLARE @BudgetReforecastTypeNulls INT = (SELECT COUNT(*) FROM dbo.ProfitabilityBudgetUnknowns WHERE BudgetReforecastTypeKey IS NULL)

	IF (@BudgetReforecastTypeNulls > 0)
	BEGIN
		PRINT ('Disaster: there are ' + LTRIM(RTRIM(STR(@BudgetReforecastTypeNulls))) + ' nulls for dbo.ProfitabilityBudgetUnknowns.BudgetReforecastKey')
	END
	ELSE
	BEGIN
		PRINT ('All dbo.ProfitabilityBudgetUnknowns.BudgetReforecastTypeKey fields set - there are no nulls.')
		 
		-- Add FK constraint to dbo.ProfitabilityBudgetUnknowns to dbo.BudgetReforecastType
		 
		IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudgetUnknowns_BudgetReforecastType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudgetUnknowns]'))
			ALTER TABLE [dbo].[ProfitabilityBudgetUnknowns] DROP CONSTRAINT [FK_ProfitabilityBudgetUnknowns_BudgetReforecastType]
		
		ALTER TABLE
			dbo.ProfitabilityBudgetUnknowns
		ALTER COLUMN
			BudgetReforecastTypeKey INT NOT NULL

	END	

GO

---------------------- UPDATE COMPLETE -----------------------------------------------------------------------------------------------------------

-- Profitability Budget -------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

	-- Attempt to add dbo.ProfitabilityBudget.BudgetReforecastType

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityBudget' AND COLUMN_NAME = 'BudgetReforecastTypeKey')
BEGIN

	ALTER TABLE
		dbo.ProfitabilityBudget
	ADD BudgetReforecastTypeKey INT NULL

	PRINT ('Column dbo.ProfitabilityBudget.BudgetReforecastTypeKey added.')

END
ELSE
BEGIN
	PRINT ('Cannot add column dbo.ProfitabilityBudget.BudgetReforecastTypeKey as it already exists.')
END

GO

	-- BC ----------------------

DECLARE @BudgetReforecastTypeBCBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM dbo.BudgetReforecastType WHERE BudgetReforecastTypeName = 'BC Budget/Reforecast' AND BudgetReforecastSubTypeName = 'Budget') 

IF (@BudgetReforecastTypeBCBudgetKey IS NOT NULL)
BEGIN

	UPDATE
		dbo.ProfitabilityBudget
	SET
		BudgetReforecastTypeKey = @BudgetReforecastTypeBCBudgetKey
	WHERE
		ReferenceCode LIKE 'BC:%'

	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityBudget updated for "BC"')

END
ELSE
BEGIN
	PRINT ('Cannot update "BC" original budget records in dbo.ProfitabilityBudget because @BudgetReforecastTypeTAPASBudgetKey is null.')
END

GO

	-- GBS ----------------------

DECLARE @BudgetReforecastTypeGBSBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM dbo.BudgetReforecastType WHERE BudgetReforecastTypeName = 'GBS Budget/Reforecast' AND BudgetReforecastSubTypeName = 'Budget')

IF (@BudgetReforecastTypeGBSBudgetKey IS NOT NULL)
BEGIN

	UPDATE
		dbo.ProfitabilityBudget
	SET
		BudgetReforecastTypeKey = @BudgetReforecastTypeGBSBudgetKey
	WHERE
		ReferenceCode LIKE 'GBS:%'

	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityBudget updated for "GBS"')

END
ELSE
BEGIN
	PRINT ('Cannot update "GBS" original budget records in dbo.ProfitabilityBudget because @BudgetReforecastTypeTAPASBudgetKey is null.')
END

GO

	-- TGB ------------------------

DECLARE @BudgetReforecastTypeTAPASBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM dbo.BudgetReforecastType WHERE BudgetReforecastTypeName = 'TGB Budget/Reforecast' AND BudgetReforecastSubTypeName = 'Budget')

IF (@BudgetReforecastTypeTAPASBudgetKey IS NOT NULL)
BEGIN

	UPDATE
		dbo.ProfitabilityBudget
	SET
		BudgetReforecastTypeKey = @BudgetReforecastTypeTAPASBudgetKey
	WHERE
		ReferenceCode LIKE 'TGB:%'

	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityBudget updated for "TGB"')

END
ELSE
BEGIN
	PRINT ('Cannot update "TGB" original budget records in dbo.ProfitabilityBudget because @BudgetReforecastTypeTAPASBudgetKey is null.')
END

GO

	-- Perform check to see whether there are any records in dbo.ProfitabilityReforecast whose BudgetReforecastTypeKey is null

DECLARE @BudgetReforecastTypeNulls INT = (SELECT COUNT(*) FROM dbo.ProfitabilityBudget WHERE BudgetReforecastTypeKey IS NULL)

IF (@BudgetReforecastTypeNulls > 0)
BEGIN
	PRINT ('Disaster: there are ' + LTRIM(RTRIM(STR(@BudgetReforecastTypeNulls))) + ' nulls for dbo.ProfitabilityBudget.BudgetReforecastKey')
END
ELSE
BEGIN
	PRINT ('All dbo.ProfitabilityBudget.BudgetReforecastKey fields set - there are no nulls.')
	 
	-- Add FK constraint to dbo.ProfitabilityBudget to dbo.BudgetReforecastType
	 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_BudgetReforecastType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
		ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_BudgetReforecastType]
	
	ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_BudgetReforecastType] FOREIGN KEY([BudgetReforecastTypeKey])
		REFERENCES [dbo].[BudgetReforecastType] ([BudgetReforecastTypeKey])

	ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_BudgetReforecastType]

	PRINT ('FK constraint [FK_ProfitabilityBudget_BudgetReforecastType] added.')
	
	ALTER TABLE
		dbo.ProfitabilityBudget
	ALTER COLUMN
		BudgetReforecastTypeKey INT NOT NULL

END

GO









-- Profitability Reforecast --------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

	-- Attempt to add dbo.ProfitabilityReforecast.BudgetReforecastType

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityReforecast' AND COLUMN_NAME = 'BudgetReforecastTypeKey')
BEGIN

	ALTER TABLE
		dbo.ProfitabilityReforecast
	ADD BudgetReforecastTypeKey INT NULL

	PRINT ('Column dbo.ProfitabilityReforecast.BudgetReforecastTypeKey added.')

END
ELSE
BEGIN
	PRINT ('Cannot add column dbo.ProfitabilityReforecast.BudgetReforecastTypeKey as it already exists.')
END

GO

	-- BC ----------------------------

DECLARE @BudgetReforecastTypeBCBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM dbo.BudgetReforecastType WHERE BudgetReforecastTypeName = 'BC Budget/Reforecast' AND BudgetReforecastSubTypeName = 'Budget')

IF (@BudgetReforecastTypeBCBudgetKey IS NOT NULL)
BEGIN

	UPDATE
		dbo.ProfitabilityReforecast
	SET
		BudgetReforecastTypeKey = @BudgetReforecastTypeBCBudgetKey
	WHERE
		ReferenceCode LIKE 'BC:%'

	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityReforecast updated for "BC"')

END
ELSE
BEGIN
	PRINT ('Cannot update BC reforecast records in dbo.ProfitabilityReforecast because @BudgetReforecastTypeBCBudgetKey is null.')
END

GO

	-- TGB ---------------------------

DECLARE @BudgetReforecastTypeTAPASBudgetKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM dbo.BudgetReforecastType WHERE BudgetReforecastTypeName = 'TGB Budget/Reforecast' AND BudgetReforecastSubTypeName = 'Budget')

IF (@BudgetReforecastTypeTAPASBudgetKey IS NOT NULL)
BEGIN

	UPDATE
		dbo.ProfitabilityReforecast
	SET
		BudgetReforecastTypeKey = @BudgetReforecastTypeTAPASBudgetKey
	WHERE
		ReferenceCode LIKE 'TGB:%'

	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records in dbo.ProfitabilityReforecast updated for "TGB"')

END
ELSE
BEGIN
	PRINT ('Cannot update BC reforecast records in dbo.ProfitabilityReforecast because @BudgetReforecastTypeTAPASBudgetKey is null.')
END

GO
--

	-- Perform check to see whether there are any records in dbo.ProfitabilityReforecast whose BudgetReforecastTypeKey is null

DECLARE @BudgetReforecastTypeNulls INT = (SELECT COUNT(*) FROM dbo.ProfitabilityReforecast WHERE BudgetReforecastTypeKey IS NULL)

IF (@BudgetReforecastTypeNulls > 0)
BEGIN
	PRINT ('Disaster: there are ' + LTRIM(RTRIM(STR(@BudgetReforecastTypeNulls))) + ' nulls for dbo.ProfitabilityReforecast.BudgetReforecastKey')
END
ELSE
BEGIN
	PRINT ('All dbo.ProfitabilityReforecast.BudgetReforecastKey fields set - there are no nulls.')
	 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_BudgetReforecastType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
		ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_BudgetReforecastType]
	
	ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_BudgetReforecastType] FOREIGN KEY([BudgetReforecastTypeKey])
		REFERENCES [dbo].[BudgetReforecastType] ([BudgetReforecastTypeKey])

	ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_BudgetReforecastType]
	
	PRINT ('FK constraint [FK_ProfitabilityReforecast_BudgetReforecastType] added.')
	
	ALTER TABLE
		dbo.ProfitabilityReforecast
	ALTER COLUMN
		BudgetReforecastTypeKey INT NOT NULL
	
END


GO
--



------------------------------------------------------------------------------------------------------------------------------------------------
--|||||||||||||||||||||||||||||||||||||||||||||||||||| dbo.ProfitabilityBudget.ReforecastKey |||||||||||||||||||||||||||||||||||||||||||||||||--
------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProfitabilityBudget' AND COLUMN_NAME = 'ReforecastKey')
BEGIN

	ALTER TABLE
		dbo.ProfitabilityBudget
	ADD ReforecastKey INT NULL

	PRINT ('Column "ReforecastKey" added to table "dbo.ProfitabilityBudget."')
	
END
ELSE
BEGIN
	PRINT ('Cannot add column "ReforecastKey" to table "dbo.ProfitabilityBudget" as it already exists.')
END

GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

DECLARE @ReforecastKey2010OriginalBudget INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast WHERE ReforecastEffectiveYear = 2010 AND ReforecastQuarterName = 'Q0')
DECLARE @ReforecastKey2011OriginalBudget INT = (SELECT MIN(ReforecastKey) FROM dbo.Reforecast WHERE ReforecastEffectiveYear = 2011 AND ReforecastQuarterName = 'Q0')

IF (@ReforecastKey2010OriginalBudget IS NOT NULL AND @ReforecastKey2011OriginalBudget IS NOT NULL)
BEGIN
		
	UPDATE
		PB
	SET
		PB.ReforecastKey = @ReforecastKey2010OriginalBudget
	FROM
		dbo.ProfitabilityBudget PB
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey
	WHERE
		C.CalendarYear = 2010
	
	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records updated in dbo.ProfitabilityBudget.ReforecastKey for 2010 Q0')
	
	UPDATE
		PB
	SET
		PB.ReforecastKey = @ReforecastKey2011OriginalBudget
	FROM
		dbo.ProfitabilityBudget PB
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey
	WHERE
		C.CalendarYear = 2011

	PRINT (LTRIM(RTRIM(STR(@@rowcount))) + ' records updated in dbo.ProfitabilityBudget.ReforecastKey for 2011 Q0')

END
ELSE
BEGIN
	PRINT('Cannot update dbo.ProfitabilityBudget.ReforecastKey as either (or both) "@ReforecastKey2010OriginalBudget" or "@ReforecastKey2011OriginalBudget" is (are) null.')
END

GO

------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_ProfitabilityBudget_Reforecast') AND parent_object_id = OBJECT_ID(N'dbo.ProfitabilityBudget'))
BEGIN
	ALTER TABLE dbo.ProfitabilityBudget DROP CONSTRAINT FK_ProfitabilityBudget_Reforecast
	PRINT ('Constraint "FK_ProfitabilityBudget_Reforecast" dropped.')
END
GO

USE GrReporting
GO

ALTER TABLE dbo.ProfitabilityBudget  WITH CHECK ADD  CONSTRAINT FK_ProfitabilityBudget_Reforecast FOREIGN KEY(ReforecastKey)
	REFERENCES dbo.Reforecast (ReforecastKey)
GO

ALTER TABLE dbo.ProfitabilityBudget CHECK CONSTRAINT FK_ProfitabilityBudget_Reforecast
GO

PRINT ('Constraint "FK_ProfitabilityBudget_Reforecast" created.')

ALTER TABLE dbo.ProfitabilityBudget
ALTER COLUMN ReforecastKey INT NOT NULL

PRINT ('Column "dbo.ProfitabilityBudget.ReforecastKey" changed to be: INT NOT NULL.')

GO






------------------------------------------------------------------------------------------------------------------------------------------------
--|||||||||||||||||||||||||||||||||||||||||||| dbo.ExchangeRate.ReforecastKey and BudgetExchangeRateId |||||||||||||||||||||||||||||||||||||||--
------------------------------------------------------------------------------------------------------------------------------------------------

-- There should be 35770 records in dbo.ExchangeRate before this script runs for the first time.
-- If the number of records is not 35770, this script has possibly been executed before and should not be executed again.
--  #UpdateInsertAlreadyExecuted is used to determine whether this is the case (a temp table is used as it is not affected by the GO statements)

CREATE TABLE #UpdateInsertAlreadyExecuted(
	Value BIT NOT NULL
)
INSERT INTO #UpdateInsertAlreadyExecuted
SELECT
	CASE WHEN
		(SELECT COUNT(*) FROM dbo.ExchangeRate) = 35770
	THEN
		0
	ELSE
		1
	END

IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 1)
BEGIN
	PRINT ('This script has been executed before - most of the updates will not take place because of this ...')
END

-- Try make script re-runnable: drop FK constraint if it exists


IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 0)
BEGIN

	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExchangeRate_Reforecast]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExchangeRate]'))
	BEGIN
		ALTER TABLE [dbo].[ExchangeRate] DROP CONSTRAINT [FK_ExchangeRate_Reforecast]
		PRINT ('FK "FK_ExchangeRate_Reforecast" dropped.')
	END

END

GO

-- Add dbo.ExchangeRate.ReforecastKey ---------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 0)
BEGIN

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'ReforecastKey' AND TABLE_NAME = 'ExchangeRate')
	BEGIN
		ALTER TABLE
			dbo.ExchangeRate
		DROP COLUMN
			ReforecastKey
			
		PRINT ('Column "ReforecastKey" dropped from table "dbo.ExchangeRate".')
	END

END

GO

USE GrReporting
GO

IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 0)
BEGIN

	ALTER TABLE
		dbo.ExchangeRate
	ADD
		ReforecastKey INT NULL

	PRINT ('Column "ReforecastKey" added to table "dbo.ExchangeRate".')

END

GO

-- Add dbo.ExchangeRate.BudgetExchangeRateId ---------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 0)
BEGIN

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'BudgetExchangeRateId' AND TABLE_NAME = 'ExchangeRate')
	BEGIN
		ALTER TABLE
			dbo.ExchangeRate
		DROP COLUMN
			BudgetExchangeRateId
			
		PRINT ('Column "BudgetExchangeRateId" dropped from table "dbo.ExchangeRate".')
	END

END

GO

USE GrReporting
GO

IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 0)
BEGIN

	ALTER TABLE
		dbo.ExchangeRate
	ADD
		BudgetExchangeRateId INT NULL

	PRINT ('Column "BudgetExchangeRateId" added to table "dbo.ExchangeRate".')

END

GO

--------------------------------------------------------------------------------------------------------------------------


USE GrReporting
GO

/*
	The existing dbo.ExchangeRate design assumes that two exchange rate groupings (i.e.: BudgetExchangeRates) applies for all data in the
	data warehouse. The first group applies to 2010 data (Q0, Q1, Q2, and Q3), while the other applies to 2011 Q0 data:
	
		1.1: 2010 Q0 [ReforecastKey=40177; BudgetExchangeRateId=1]
		1.2: 2010 Q1 [ReforecastKey=40236; BudgetExchangeRateId=1]
		1.3: 2010 Q2 [ReforecastKey=40328; BudgetExchangeRateId=1]
		1.4: 2010 Q3 [ReforecastKey=40420; BudgetExchangeRateId=1]
	
		2.1: 2011 Q0 [ReforecastKey=40512; BudgetExchangeRateId=3]
	
	Given that TAPAS and GBS budgets can now be linked to the same budget cycle and exchange rate, it is now possible to have
	a different exchange rate set associated with each budget cycle.

	To implement this, a ReforecastKey foreign key has been added to the dbo.ExchangeRate table, allowing each budget and reforecast to be
	associated with its own exchange rate set.
	
	Given that four different reforecasts each use the same single 2010 exchange rate, an additional three copies of this exchange rate must
	be loaded into dbo.ExchangeRate to cater for the addition of the dbo.ExchangeRate.ReforecastKey field. The existing exchange rate for 2010 is
	assigned to 2010 Q0 - the extra three copies of this exchange rate that will be inserted into dbo.ExchangeRate will be associated with the
	2010 reforecasts (Q1, Q2, and Q3).
*/

-------------

DECLARE @ActualDataPriorToDate DATETIME = CONVERT(DATETIME, (SELECT ConfiguredValue FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
DECLARE @BudgetExchangeRateId2010 INT = (
											SELECT DISTINCT
												BudgetExchangeRateId
											FROM
												SERVER3.GDM.dbo.BudgetExchangeRate BER -- Use linked server as this record will not yet exist in GrReportingStaging.Gdm, as the job is yet to execute
											WHERE
												BER.Name = '2010 Budget Exchange Rates'
										)
DECLARE @BudgetExchangeRateId2011Q0 INT = (
											SELECT DISTINCT
												BudgetExchangeRateId
											FROM
												SERVER3.GDM.dbo.BudgetExchangeRate BER
											WHERE
												BER.Name = '2011 Budget' -- 2011 Q0
										)

PRINT ('@ActualDataPriorToDate: ' + CONVERT(VARCHAR(64), @ActualDataPriorToDate))
PRINT ('@BudgetExchangeRateId2010: ' + CONVERT(VARCHAR(64), @BudgetExchangeRateId2010))
PRINT ('@BudgetExchangeRateId2011Q0: ' + CONVERT(VARCHAR(64), @BudgetExchangeRateId2011Q0))

--

IF ((SELECT TOP 1 Value FROM #UpdateInsertAlreadyExecuted) = 0)
BEGIN

	CREATE TABLE #ReforecastKeysUsed (
		CalendarYear INT NOT NULL,
		IsReforecast BIT NOT NULL,
		ReforecastKey INT NOT NULL,
		BudgetExchangeRateId INT NOT NULL
	)

	INSERT INTO #ReforecastKeysUsed (
		CalendarYear,
		IsReforecast,
		ReforecastKey,
		BudgetExchangeRateId
	)
	--select * from #ReforecastKeysUsed
	SELECT DISTINCT
		C.CalendarYear,
		0 AS IsReforecast,
		PB.ReforecastKey,
		CASE WHEN C.CalendarYear = 2010 THEN @BudgetExchangeRateId2010 ELSE @BudgetExchangeRateId2011Q0 END AS BudgetExchangeRateId
	FROM
		dbo.ProfitabilityBudget PB
		INNER JOIN dbo.Calendar C ON
			PB.CalendarKey = C.CalendarKey

	UNION ALL

	SELECT DISTINCT
		C.CalendarYear,
		1 AS IsReforecast,
		PR.ReforecastKey,
		@BudgetExchangeRateId2010 -- There should only be 2010 reforecasts loaded at present
	FROM
		dbo.ProfitabilityReforecast PR

		INNER JOIN dbo.Calendar C ON
			PR.CalendarKey = C.CalendarKey
	WHERE
		C.CalendarYear = 2010 -- Limit to 2010 as there should only be 2010 Reforecasts in the warehouse


	-- Update dbo.ExchangeRate.ReforecastKey and dbo.ExchangeRate.BudgetExchangeRateId ------------------------------------------------------------


	-- There should be 35770 records in dbo.ExchangeRate before the script below is executed. If this is not the case, the script could have already
	-- executed - do not let it execute again. This is an attempt to make the script re-runnable.

	DECLARE @UpdateInsertAlreadyExecuted BIT = CASE WHEN (SELECT COUNT(*) FROM dbo.ExchangeRate) = 35770 THEN 0 ELSE 1 END

	UPDATE
		ER
	SET
		ER.ReforecastKey = RKU.ReforecastKey,
		ER.BudgetExchangeRateId = RKU.BudgetExchangeRateId
	FROM
		dbo.ExchangeRate ER

		INNER JOIN dbo.Calendar C ON
			ER.CalendarKey = C.CalendarKey

		INNER JOIN #ReforecastKeysUsed RKU ON
			C.CalendarYear = RKU.CalendarYear
	WHERE
		RKU.IsReforecast = 0

	PRINT('Rows updated in dbo.ExchangeRate:' + LTRIM(RTRIM(STR(@@rowcount))))

	-- Insert three additional copies of the 2010 Exchange Rate data - one for each of the 2010 reforecasts

	CREATE TABLE #ExchangeRate( -- This is the copy of the original exchange rate set that has been used in the data warehouse so far
		SourceCurrencyKey INT NOT NULL,
		DestinationCurrencyKey INT NOT NULL,
		CalendarKey INT NOT NULL,
		Rate DECIMAL(18, 12) NOT NULL,
		ReferenceCode VARCHAR(255) NOT NULL,
		BudgetExchangeRateId INT NOT NULL
	)

	INSERT INTO #ExchangeRate (
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate,
		ReferenceCode,
		BudgetExchangeRateId
	)
	SELECT
		ER.SourceCurrencyKey,
		ER.DestinationCurrencyKey,
		ER.CalendarKey,
		ER.Rate,
		ER.ReferenceCode,
		ER.BudgetExchangeRateId
	FROM
		dbo.ExchangeRate ER
		INNER JOIN dbo.Calendar C ON
			ER.CalendarKey = C.CalendarKey
	WHERE
		C.CalendarYear = 2010

	----

	INSERT INTO dbo.ExchangeRate (
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate,
		ReferenceCode,
		BudgetExchangeRateId,
		ReforecastKey
	)

	SELECT
		ER.SourceCurrencyKey,
		ER.DestinationCurrencyKey,
		ER.CalendarKey,
		ER.Rate,
		ER.ReferenceCode,
		ER.BudgetExchangeRateId,
		ReforecastKeys.ReforecastKey
	FROM
		#ExchangeRate ER
		
		CROSS JOIN (
		
			SELECT DISTINCT
				RKU.ReforecastKey
			FROM
				#ReforecastKeysUsed RKU
			WHERE
				IsReforecast = 1	
		) ReforecastKeys

	PRINT('Rows inserted into dbo.ExchangeRate:' + LTRIM(RTRIM(STR(@@rowcount))))

END

GO

---- Create FK constraint on dbo.ExchangeRate.ReforecastKey

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExchangeRate_Reforecast]') AND parent_object_id = OBJECT_ID(N'[dbo].[ExchangeRate]'))
BEGIN
	ALTER TABLE [dbo].[ExchangeRate] DROP CONSTRAINT [FK_ExchangeRate_Reforecast]
	PRINT ('FK constraint "FK_ExchangeRate_Reforecast" dropped')
END
GO

USE [GrReporting]
GO

ALTER TABLE [dbo].[ExchangeRate]  WITH CHECK ADD  CONSTRAINT [FK_ExchangeRate_Reforecast] FOREIGN KEY([ReforecastKey])
	REFERENCES [dbo].[Reforecast] ([ReforecastKey])
GO

ALTER TABLE [dbo].[ExchangeRate] CHECK CONSTRAINT [FK_ExchangeRate_Reforecast]
GO

PRINT ('FK constraint "FK_ExchangeRate_Reforecast" created.')

---- Make dbo.ExchangeRate.ReforecastKey and BudgetExchangeRateId NOT NULL: needs to be executed before INDEX updates on dbo.ExchangeRate

USE [GrReporting]
GO

ALTER TABLE
	dbo.ExchangeRate
ALTER COLUMN ReforecastKey INT NOT NULL

PRINT ('dbo.ExchangeRate.ReforecastKey updated to: INT NOT NULL')

ALTER TABLE
	dbo.ExchangeRate
ALTER COLUMN BudgetExchangeRateId INT NOT NULL

PRINT ('dbo.ExchangeRate.BudgetExchangeRateId updated to: INT NOT NULL')

GO

-- Clean up

IF 	OBJECT_ID('tempdb..#ExchangeRate') IS NOT NULL
    DROP TABLE #ExchangeRate

IF 	OBJECT_ID('tempdb..#ReforecastKeysUsed') IS NOT NULL
    DROP TABLE #ReforecastKeysUsed

IF 	OBJECT_ID('tempdb..#UpdateInsertAlreadyExecuted') IS NOT NULL
    DROP TABLE #UpdateInsertAlreadyExecuted









------------------------------------------------------------------------------------------------------------------------------------------------
--||||||||||||||||||||||||||||||||||||||| Update dbo.ProfitabilityBudget/Reforecast.SourceSystem data ||||||||||||||||||||||||||||||||||||||||--
------------------------------------------------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID('FK_ProfitabilityBudget_SourceSystem') AND parent_object_id = OBJECT_ID('ProfitabilityBudget'))
BEGIN

  ALTER TABLE [ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_SourceSystem]
  PRINT 'SourceSystemId constraint exists, and has been dropped'

END

GO

USE GrReporting
GO

IF EXISTS (	SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemId'  AND TABLE_NAME = 'ProfitabilityBudget' AND IS_NULLABLE = 'NO')
BEGIN

	ALTER TABLE dbo.[ProfitabilityBudget] ALTER COLUMN SourceSystemId INT NULL
	PRINT 'SourceSystem Id updated from NOT NULLABLE to IS NULLABLE'

END

GO

USE GrReporting
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID('FK_ProfitabilityReforecast_SourceSystem') AND parent_object_id = OBJECT_ID('ProfitabilityReforecast'))
BEGIN

  ALTER TABLE [ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_SourceSystem]
  PRINT 'SourceSystemId constraint exists, and has been dropped'

END

GO

USE GrReporting
GO

IF EXISTS (	SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'SourceSystemId' AND TABLE_NAME = 'ProfitabilityReforecast' AND IS_NULLABLE = 'NO')
BEGIN

	ALTER TABLE dbo.[ProfitabilityReforecast] ALTER COLUMN SourceSystemId INT NULL
	PRINT 'SourceSystem Id updated from NOT NULLABLE to IS NULLABLE'

END

GO

