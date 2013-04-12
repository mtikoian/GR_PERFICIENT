USE GrReporting
GO

/****** Object:  StoredProcedure dbo.ClearSessionSnapshot    Script Date: 08/21/2009 10:24:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_R_MissingExchangeRates') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_R_MissingExchangeRates
GO

CREATE PROCEDURE dbo.stp_R_MissingExchangeRates
 
AS 
DECLARE @CurrencyCount Int

Select	DISTINCT
		'Actual' DataSource,
		Ca.CalendarDate,
		Scu.CurrencyCode LocalCurrencyCode,
		0 NumberOfCurrencies,
		0 NumberOfDestinationCurrencies
From
		ProfitabilityActual Pa
			INNER JOIN Calendar Ca ON Ca.CalendarKey = Pa.CalendarKey
			INNER JOIN Currency Scu ON Scu.CurrencyKey = Pa.LocalCurrencyKey
			LEFT OUTER JOIN ExchangeRate Ex ON pa.LocalCurrencyKey = Ex.SourceCurrencyKey
								AND pa.CalendarKey = Ex.CalendarKey
Where Ex.SourceCurrencyKey IS NULL
UNION ALL
Select	DISTINCT
		'Budget',
		Ca.CalendarDate,
		Scu.CurrencyCode LocalCurrencyCode,
		0 NumberOfCurrencies,
		0 NumberOfDestinationCurrencies
From
		ProfitabilityBudget Pb
			INNER JOIN Calendar Ca ON Ca.CalendarKey = Pb.CalendarKey
			INNER JOIN Currency Scu ON Scu.CurrencyKey = Pb.LocalCurrencyKey
			LEFT OUTER JOIN ExchangeRate Ex ON pb.LocalCurrencyKey = Ex.SourceCurrencyKey
								AND pb.CalendarKey = Ex.CalendarKey
Where Ex.SourceCurrencyKey IS NULL
Order By 1,2,3

GO