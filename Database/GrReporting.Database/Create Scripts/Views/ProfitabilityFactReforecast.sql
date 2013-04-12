GO

/****** Object:  View [dbo].[ProfitabilityFactReforecast]    Script Date: 07/08/2010 09:55:55 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFactReforecast]'))
DROP VIEW [dbo].[ProfitabilityFactReforecast]
GO

/****** Object:  View [dbo].[ProfitabilityFactReforecast]    Script Date: 07/08/2010 09:55:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ProfitabilityFactReforecast]
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
	
	  ,ReforecastQ1
	  ,ReforecastQ2
	  ,0 ReforecastQ3
	  ,0 ReforecastQ4
	  
	  ,NetReforecastQ1
	  ,NetReforecastQ2
	  ,0 NetReforecastQ3
	  ,0 NetReforecastQ4

From
	(
	 	--Payroll & Overhead ProfitabilityActual
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

			--Gross
			,CASE WHEN	ca.CalendarPeriod <= (Select MAX(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 1)
				THEN 
					(pa.LocalActual * ExchangeRateUSD.Rate) 
				ELSE 
					NULL 
				END ReforecastQ1
				
			,CASE WHEN	ca.CalendarPeriod <= (Select MAX(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 2)
				THEN 
					(pa.LocalActual * ExchangeRateUSD.Rate) 
				ELSE 
					NULL 
				END ReforecastQ2
			
			--Net
			,CASE WHEN	ca.CalendarPeriod <= (Select MAX(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 1)
				THEN 
					(pa.LocalActual * ExchangeRateUSD.Rate * r.MultiplicationFactor) 
				ELSE 
					NULL 
				END NetReforecastQ1
				
			,CASE WHEN	ca.CalendarPeriod <= (Select MAX(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 2)
				THEN 
					(pa.LocalActual * ExchangeRateUSD.Rate * r.MultiplicationFactor) 
				ELSE 
					NULL 
				END NetReforecastQ2


	FROM dbo.ProfitabilityActual pa
			INNER JOIN Calendar ca ON ca.CalendarKey = pa.CalendarKey							
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pa.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')
			LEFT OUTER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
	Where gac.AccountSubTypeName not like '%Non-Payroll%'

	UNION ALL

	--Payroll & Overhead ProfitabilityReforecast
	SELECT 
			--Primary Keys
			pr.ProfitabilityReforecastKey ProfitabilityKey
			,3 ProfitabilityTypeKey
			--Dimensions
			,pr.CalendarKey
			,pr.GlAccountKey
			,pr.SourceKey
			,pr.FunctionalDepartmentKey
			,pr.ReimbursableKey
			,pr.ActivityTypeKey
			,pr.PropertyFundKey
			,pr.AllocationRegionKey
			,pr.OriginatingRegionKey
			,pr.LocalCurrencyKey
			,pr.GlobalGlAccountCategoryKey

			--Gross
			,CASE WHEN	ca.CalendarPeriod > (Select MIN(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 1)
						
				THEN 
					(pr.LocalReforecast * ExchangeRateUSD.Rate) 
				ELSE 
					NULL 
				END ReforecastQ1
				
			,CASE WHEN	ca.CalendarPeriod > (Select MIN(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 2)
						
				THEN 
					(pr.LocalReforecast * ExchangeRateUSD.Rate) 
				ELSE 
					NULL 
				END ReforecastQ2

			--NetReforecast
			,CASE WHEN	ca.CalendarPeriod > (Select MIN(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 1)
				THEN 
					(pr.LocalReforecast * ExchangeRateUSD.Rate * r.MultiplicationFactor) 
				ELSE 
					NULL 
				END NetReforecastQ1
				
			,CASE WHEN	ca.CalendarPeriod > (Select MIN(ReforecastEffectivePeriod) 
												From Reforecast 
												Where ReforecastEffectiveYear = ca.CalendarYear 
												AND ReforecastEffectiveQuarter = 2)
				THEN 
					(pr.LocalReforecast * ExchangeRateUSD.Rate * r.MultiplicationFactor) 
				ELSE 
					NULL 
				END NetReforecastQ2


		FROM dbo.ProfitabilityReforecast pr
			INNER JOIN Calendar ca ON ca.CalendarKey = pr.CalendarKey
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pr.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pr.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')
			LEFT OUTER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pr.GlobalGlAccountCategoryKey
		Where gac.AccountSubTypeName not like '%Non-Payroll%'
				
		 UNION All
		 
		 -- Non-Payroll ProfitabilityReforecast
		 SELECT 
		--Primary Keys
		  pr.ProfitabilityReforecastKey
		  ,3 ProfitabilityTypeKey
		--Dimensions
		  ,pr.CalendarKey
		  ,pr.GlAccountKey
		  ,pr.SourceKey
		  ,pr.FunctionalDepartmentKey
		  ,pr.ReimbursableKey
		  ,pr.ActivityTypeKey
		  ,pr.PropertyFundKey
		  ,pr.AllocationRegionKey
		  ,pr.OriginatingRegionKey
		  ,pr.LocalCurrencyKey
		  ,pr.GlobalGlAccountCategoryKey
	
			--Gross
   		  ,(pr.LocalReforecast * ExchangeRateUSD.Rate) ReforecastQ1
						
		  ,(pr.LocalReforecast * ExchangeRateUSD.Rate) ReforecastQ2

			--Net
   		  ,(pr.LocalReforecast * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetReforecastQ1
						
		  ,(pr.LocalReforecast * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetReforecastQ2
						
		  
	FROM  dbo.ProfitabilityReforecast pr
			INNER JOIN Calendar ca ON ca.CalendarKey = pr.CalendarKey
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pr.ReimbursableKey
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pr.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pr.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')
			LEFT OUTER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pr.GlobalGlAccountCategoryKey
	Where gac.AccountSubTypeName not like '%Non-Payroll%'
		 
	) t1









GO

