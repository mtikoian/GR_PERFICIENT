GO

/****** Object:  View [dbo].[Fact Currency Rate]    Script Date: 07/08/2010 09:53:05 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Fact Currency Rate]'))
DROP VIEW [dbo].[Fact Currency Rate]
GO

CREATE VIEW [dbo].[Fact Currency Rate]
AS
SELECT     dbo.Currency.CurrencyKey, dbo.Currency.CurrencyCode, dbo.ExchangeRate.CalendarKey, dbo.ExchangeRate.Rate
FROM         dbo.Currency INNER JOIN
                      dbo.ExchangeRate ON dbo.Currency.CurrencyKey = dbo.ExchangeRate.DestinationCurrencyKey
Where ExchangeRate.SourceCurrencyKey = (Select CurrencyKey From dbo.Currency Where CurrencyCode = 'USD')




GO

 