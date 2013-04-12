/*

Functions that need to be created:

	GrReporting.dbo.GetCurrentReforecastRecord()

*/

USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[GetCurrentReforecastRecord]    Script Date: 05/02/2011 09:54:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCurrentReforecastRecord]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCurrentReforecastRecord]
GO

USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[GetCurrentReforecastRecord]    Script Date: 05/02/2011 09:54:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

	DECLARE @ReportExpensePeriod INT = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)
	DECLARE @ReforecastQuarterName VARCHAR(2) = (SELECT ReforecastQuarterName FROM Reforecast WHERE ReforecastEffectivePeriod =  @ReportExpensePeriod)
	DECLARE @CalendarYear INT = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)

	INSERT INTO @CurrentReforecastRecord
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
		ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
	 ORDER BY
		ReforecastEffectivePeriod ASC

	RETURN
	
END

GO
