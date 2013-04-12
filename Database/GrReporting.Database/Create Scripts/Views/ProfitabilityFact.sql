
/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 07/08/2010 09:54:03 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFact]'))
DROP VIEW [dbo].[ProfitabilityFact]
GO

/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 07/08/2010 09:54:03 ******/
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[ProfitabilityFact]
AS
Select
	'ProfitabilityTypeKey='+LTRIM(STR(ProfitabilityTypeKey,10,0))+'&ProfitabilityKey='+LTRIM(STR(ProfitabilityKey,10,0)) ProfitabilityFactKey,
     ProfitabilityKey
	  ,ProfitabilityTypeKey

	  ,CalendarKey
      ,IsNull(ReforecastKey,-1) ReforecastKey
      ,GlAccountKey
      ,SourceKey
      ,FunctionalDepartmentKey
      ,ReimbursableKey
      ,ActivityTypeKey
      ,PropertyFundKey
      ,AllocationRegionKey
      ,OriginatingRegionKey
      ,2 CurrencyKey
	  ,USCorporateGlAccountCategoryKey
      ,USPropertyGlAccountCategoryKey
      ,USFundGlAccountCategoryKey
      ,EUCorporateGlAccountCategoryKey
      ,EUPropertyGlAccountCategoryKey
      ,EUFundGlAccountCategoryKey
      ,GlobalGlAccountCategoryKey
      ,DevelopmentGlAccountCategoryKey
	
	  ,IsNull(Actual,0.00) Actual
      ,IsNull(NetActual,0.00) NetActual
  	  ,IsNull(Budget,0.00) Budget
      ,IsNull(NetBudget,0.00) NetBudget
      ,IsNull(Reforecast,0.00) Reforecast
      ,IsNull(NetReforecast,0.00) NetReforecast
From
	(
	SELECT 
		--Primary Keys
		  pa.ProfitabilityActualKey ProfitabilityKey
		  ,1 ProfitabilityTypeKey
		--Dimensions
		  ,pa.CalendarKey
		  ,NULL ReforecastKey
		  ,pa.GlAccountKey
		  ,pa.SourceKey
		  ,pa.FunctionalDepartmentKey
		  ,pa.ReimbursableKey
		  ,pa.ActivityTypeKey
		  ,pa.PropertyFundKey
		  ,pa.AllocationRegionKey
		  ,pa.OriginatingRegionKey
		  ,pa.LocalCurrencyKey
		  ,pa.USCorporateGlAccountCategoryKey
		  ,pa.USPropertyGlAccountCategoryKey
		  ,pa.USFundGlAccountCategoryKey
		  ,pa.EUCorporateGlAccountCategoryKey
		  ,pa.EUPropertyGlAccountCategoryKey
		  ,pa.EUFundGlAccountCategoryKey
		  ,pa.GlobalGlAccountCategoryKey
		  ,pa.DevelopmentGlAccountCategoryKey
	
		  ,(pa.LocalActual * ExchangeRateUSD.Rate) Actual
		  ,(pa.LocalActual * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetActual
		  ,NULL Budget
	      ,NULL NetBudget
		  ,NULL Reforecast
		  ,NULL NetReforecast
		  
	FROM  dbo.ProfitabilityActual pa
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pa.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')

	UNION ALL

	SELECT 
		--Primary Keys
		  pb.ProfitabilityBudgetKey ProfitabilityKey
		  ,2 ProfitabilityTypeKey
		--Dimensions
		  ,pb.CalendarKey
		  ,NULL ReforecastKey
		  ,pb.GlAccountKey
		  ,pb.SourceKey
		  ,pb.FunctionalDepartmentKey
		  ,pb.ReimbursableKey
		  ,pb.ActivityTypeKey
		  ,pb.PropertyFundKey
		  ,pb.AllocationRegionKey
		  ,pb.OriginatingRegionKey
		  ,pb.LocalCurrencyKey
		  ,pb.USCorporateGlAccountCategoryKey
		  ,pb.USPropertyGlAccountCategoryKey
		  ,pb.USFundGlAccountCategoryKey
		  ,pb.EUCorporateGlAccountCategoryKey
		  ,pb.EUPropertyGlAccountCategoryKey
		  ,pb.EUFundGlAccountCategoryKey
		  ,pb.GlobalGlAccountCategoryKey
		  ,pb.DevelopmentGlAccountCategoryKey
		  ,NULL Actual
	      ,NULL NetActual
		  ,(pb.LocalBudget * ExchangeRateUSD.Rate) Budget
		  ,(pb.LocalBudget * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetBudget
		  ,NULL Reforecast
		  ,NULL NetReforecast
	      
	  FROM dbo.ProfitabilityBudget pb
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pb.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')

	UNION ALL

	SELECT 
		--Primary Keys
		  pr.ProfitabilityReforecastKey ProfitabilityKey
		  ,3 ProfitabilityTypeKey
		--Dimensions
		  ,pr.CalendarKey
		  ,pr.ReforecastKey
		  ,pr.GlAccountKey
		  ,pr.SourceKey
		  ,pr.FunctionalDepartmentKey
		  ,pr.ReimbursableKey
		  ,pr.ActivityTypeKey
		  ,pr.PropertyFundKey
		  ,pr.AllocationRegionKey
		  ,pr.OriginatingRegionKey
		  ,pr.LocalCurrencyKey
		  ,pr.USCorporateGlAccountCategoryKey
		  ,pr.USPropertyGlAccountCategoryKey
		  ,pr.USFundGlAccountCategoryKey
		  ,pr.EUCorporateGlAccountCategoryKey
		  ,pr.EUPropertyGlAccountCategoryKey
		  ,pr.EUFundGlAccountCategoryKey
		  ,pr.GlobalGlAccountCategoryKey
		  ,pr.DevelopmentGlAccountCategoryKey
		  ,NULL Actual
	      ,NULL NetActual
		  ,NULL Budget
		  ,NULL NetBudget
		  ,(pr.LocalReforecast * ExchangeRateUSD.Rate) Reforecast
		  ,(pr.LocalReforecast * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetReforecastLocal

	  FROM dbo.ProfitabilityReforecast pr
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pr.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pr.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')
	) P










GO

