USE GrReporting
GO

UPDATE
	dbo.Reforecast
SET
	ReforecastQuarterName = 'Q1'
WHERE
	ReforecastEffectiveYear = 2011 AND
	ReforecastEffectivePeriod = 201108

GO