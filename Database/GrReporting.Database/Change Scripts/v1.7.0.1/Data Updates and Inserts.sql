 USE GrReporting
 GO
 
UPDATE
	dbo.Reforecast
SET
	ReforecastQuarterName = 'Q1'
WHERE
	ReforecastEffectivePeriod = 201106