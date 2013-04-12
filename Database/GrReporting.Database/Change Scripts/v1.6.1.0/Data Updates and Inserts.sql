-- Changes the Reforecast Quarter Name in March from Q1 to Q0 to allow for accurate variance amounts

USE GrReporting
GO

IF (SELECT ReforecastQuarterName FROM Reforecast WHERE ReforecastEffectivePeriod = 201103) <> 'Q0'

BEGIN

UPDATE Reforecast
SET ReforecastQuarterName = 'Q0'
WHERE ReforecastMonthName = 'March' and ReforecastEffectiveYear = 2011
END
