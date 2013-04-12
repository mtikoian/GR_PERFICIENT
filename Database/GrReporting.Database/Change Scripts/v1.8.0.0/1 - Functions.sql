 /*
 1. dbo.GetReforecastRecord.sql
 2. dbo.GetCurrentReforecastRecord.sql
 */
 
-- 1. dbo.GetReforecastRecord.sql
  
USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetReforecastRecord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetReforecastRecord]
GO

/*********************************************************************************************************************
Description
	The function gets the Reforecast record based on the Expense Period and Quarter Name paramters passed in.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-25		: PKayongo	:	The function was created.

**********************************************************************************************************************/

CREATE FUNCTION [dbo].[GetReforecastRecord] 
	(	
		@ReportExpensePeriod INT = NULL,
		@ReforecastQuarterName VARCHAR(2) = NULL
	)

RETURNS @ReforecastRecord TABLE (
		ReforecastKey INT NOT NULL,
		ReforecastEffectiveMonth INT NOT NULL,
		ReforecastEffectiveQuarter INT NOT NULL,
		ReforecastEffectiveYear INT NOT NULL,
		ReforecastMonthName VARCHAR(10) NOT NULL,
		ReforecastQuarterName VARCHAR(10) NOT NULL,
		ReforecastEffectivePeriod INT NOT NULL
	)

AS
BEGIN

	IF @ReportExpensePeriod IS NULL
	BEGIN
		SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)
	END
	
	IF (@ReforecastQuarterName IS NULL)
	BEGIN
		SET @ReforecastQuarterName = (SELECT ReforecastQuarterName FROM Reforecast WHERE ReforecastEffectivePeriod =  @ReportExpensePeriod)
	END
	
	DECLARE @CalendarYear INT = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)

	INSERT INTO @ReforecastRecord
	SELECT TOP 1
		ReforecastKey,
		ReforecastEffectiveMonth,
		ReforecastEffectiveQuarter,
		ReforecastEffectiveYear,
		ReforecastMonthName,
		ReforecastQuarterName,
		ReforecastEffectivePeriod
	 FROM
		dbo.Reforecast 
	 WHERE
		ReforecastQuarterName = @ReforecastQuarterName AND 
		ReforecastEffectiveYear = @CalendarYear
	 ORDER BY
		ReforecastEffectivePeriod ASC

	RETURN
	
END

GO

-- 2. dbo.GetCurrentReforecastRecord.sql

USE [GrReporting]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCurrentReforecastRecord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCurrentReforecastRecord]
GO

/*********************************************************************************************************************
Description
	The function gets the current Reforecast record.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-25		: PKayongo	:	The body was removed and moved to the GetReforecastRecord function. This
											was because parameters were needed to be passed into the function, but
											the extent of the function dependencies were unknown. If the function
											requires paramters, but none are passed in, the function breaks when 
											executed.

**********************************************************************************************************************/

CREATE FUNCTION [dbo].[GetCurrentReforecastRecord] ()
RETURNS @CurrentReforecastRecord TABLE (
		ReforecastKey INT NOT NULL,
		ReforecastEffectiveMonth INT NOT NULL,
		ReforecastEffectiveQuarter INT NOT NULL,
		ReforecastEffectiveYear INT NOT NULL,
		ReforecastMonthName VARCHAR(10) NOT NULL,
		ReforecastQuarterName VARCHAR(10) NOT NULL,
		ReforecastEffectivePeriod INT NOT NULL
	)

AS
BEGIN

	INSERT INTO @CurrentReforecastRecord
	(
		ReforecastKey,
		ReforecastEffectiveMonth,
		ReforecastEffectiveQuarter,
		ReforecastEffectiveYear,
		ReforecastMonthName,
		ReforecastQuarterName,
		ReforecastEffectivePeriod
	)
	SELECT 
		ReforecastKey,
		ReforecastEffectiveMonth,
		ReforecastEffectiveQuarter,
		ReforecastEffectiveYear,
		ReforecastMonthName,
		ReforecastQuarterName,
		ReforecastEffectivePeriod
	FROM 
		dbo.GetReforecastRecord(DEFAULT, DEFAULT)

	RETURN
	
END

GO
