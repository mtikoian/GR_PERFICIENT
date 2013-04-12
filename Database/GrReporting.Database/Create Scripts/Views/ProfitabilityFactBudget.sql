
GO

/****** Object:  View [dbo].[ProfitabilityFactBudget]    Script Date: 07/08/2010 09:55:13 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFactBudget]'))
DROP VIEW [dbo].[ProfitabilityFactBudget]
GO
/****** Object:  View [dbo].[ProfitabilityFactBudget]    Script Date: 07/08/2010 09:55:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


	
CREATE VIEW [dbo].[ProfitabilityFactBudget]
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
	
  	  ,IsNull(Budget,0.00) Budget
      ,IsNull(NetBudget,0.00) NetBudget
From
	(
	SELECT 
		--Primary Keys
		  pb.ProfitabilityBudgetKey ProfitabilityKey
		  ,2 ProfitabilityTypeKey
		--Dimensions
		  ,pb.CalendarKey
		  ,pb.GlAccountKey
		  ,pb.SourceKey
		  ,pb.FunctionalDepartmentKey
		  ,pb.ReimbursableKey
		  ,pb.ActivityTypeKey
		  ,pb.PropertyFundKey
		  ,pb.AllocationRegionKey
		  ,pb.OriginatingRegionKey
		  ,pb.LocalCurrencyKey
		  ,pb.GlobalGlAccountCategoryKey
		  ,(pb.LocalBudget * ExchangeRateUSD.Rate) Budget
		  ,(pb.LocalBudget * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetBudget
	      
	  FROM dbo.ProfitabilityBudget pb
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pb.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')

	) t1


GO

