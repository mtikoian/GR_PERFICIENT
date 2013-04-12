USE GrReporting
GO

UPDATE PA
SET 
	ConsolidationRegionKey = AllocationRegionKey
FROM
	dbo.ProfitabilityActual PA
	INNER JOIN Calendar C ON
		C.CalendarKey = PA.CalendarKey
WHERE
	C.CalendarYear < 2011
	
UPDATE PB
SET 
	ConsolidationRegionKey = AllocationRegionKey
FROM
	dbo.ProfitabilityBudget PB
	INNER JOIN Calendar C ON
		C.CalendarKey = PB.CalendarKey
WHERE
	C.CalendarYear < 2011
	
UPDATE PR
SET 
	ConsolidationRegionKey = AllocationRegionKey
FROM
	dbo.ProfitabilityReforecast PR
	INNER JOIN Calendar C ON
		C.CalendarKey = PR.CalendarKey
WHERE
	C.CalendarYear < 2011
	
UPDATE dbo.Reforecast
SET
	ReforecastQuarterName = 'Q1'
WHERE
	ReforecastEffectiveYear = 2011 AND
	ReforecastEffectiveMonth = 7