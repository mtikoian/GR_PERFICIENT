GO

/****** Object:  View [dbo].[ProfitabilityFactActual]    Script Date: 07/08/2010 09:54:42 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFactActual]'))
DROP VIEW [dbo].[ProfitabilityFactActual]
GO

/****** Object:  View [dbo].[ProfitabilityFactActual]    Script Date: 07/08/2010 09:54:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ProfitabilityFactActual]
AS
Select
	  'ProfitabilityTypeKey='+LTRIM(STR(ProfitabilityTypeKey,10,0))+'&ProfitabilityKey='+LTRIM(STR(ProfitabilityKey,10,0)) ProfitabilityFactKey,
      ProfitabilityKey
	  ,ProfitabilityTypeKey

	  ,CalendarKey
      ,GlAccountKey
      ,SourceKey
      ,FunctionalDepartmentKey
      ,ReimbursableKey
      ,ActivityTypeKey
      ,PropertyFundKey
      ,AllocationRegionKey
      ,OriginatingRegionKey
      ,2 CurrencyKey
      ,GlobalGlAccountCategoryKey
	
	  ,IsNull(Actual,0.00) Actual
      ,IsNull(NetActual,0.00) NetActual
From
	(
	SELECT 
		--Primary Keys
		  pa.ProfitabilityActualKey ProfitabilityKey
		  ,1 ProfitabilityTypeKey
		--Dimensions
		  ,pa.CalendarKey
		  ,pa.GlAccountKey
		  ,pa.SourceKey
		  ,pa.FunctionalDepartmentKey
		  ,pa.ReimbursableKey
		  ,pa.ActivityTypeKey
		  ,pa.PropertyFundKey
		  ,pa.AllocationRegionKey
		  ,pa.OriginatingRegionKey
		  ,pa.LocalCurrencyKey
		  ,pa.GlobalGlAccountCategoryKey
	
		  ,(pa.LocalActual * ExchangeRateUSD.Rate) Actual
		  ,(pa.LocalActual * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetActual

	FROM  dbo.ProfitabilityActual pa
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pa.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')
			LEFT OUTER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

	) t1




GO

