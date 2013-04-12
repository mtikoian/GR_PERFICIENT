USE [GrReporting]
GO

/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 03/11/2010 14:39:29 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityFact]'))
DROP VIEW [dbo].[ProfitabilityFact]
GO

USE [GrReporting]
GO

/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 03/11/2010 14:39:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ProfitabilityFact]
AS
Select
		CalendarKey
      ,ReforecastKey
      ,GlAccountKey
      ,SourceKey
      ,FunctionalDepartmentKey
      ,ReimbursableKey
      ,ActivityTypeKey
      ,PropertyFundKey
      ,AllocationRegionKey
      ,OriginatingRegionKey
      ,USCorporateGlAccountCategoryKey
      ,USPropertyGlAccountCategoryKey
      ,USFundGlAccountCategoryKey
      ,EUCorporateGlAccountCategoryKey
      ,EUPropertyGlAccountCategoryKey
      ,EUFundGlAccountCategoryKey
      ,GlobalGlAccountCategoryKey
      ,DevelopmentGlAccountCategoryKey
      
      ,SUM(ActualLocal) ActualLocal
      ,SUM(ActualUSD) ActualUSD
      ,SUM(ActualBRL) ActualBRL
      ,SUM(ActualCNY) ActualCNY
      ,SUM(ActualINR) ActualINR
      ,SUM(ActualAUD) ActualAUD
      ,SUM(ActualCHF) ActualCHF
      ,SUM(ActualEUR) ActualEUR
      ,SUM(ActualGBP) ActualGBP
      ,SUM(ActualHUF) ActualHUF
      ,SUM(ActualKRW) ActualKRW
      ,SUM(ActualOMR) ActualOMR
      ,SUM(ActualPLN) ActualPLN
      ,SUM(ActualTLR) ActualTLR
      ,SUM(ActualDEF) ActualDEF
      ,SUM(ActualZAR) ActualZAR
      
      ,SUM(NetActualLocal) NetActualLocal
      ,SUM(NetActualUSD) NetActualUSD
      ,SUM(NetActualBRL) NetActualBRL
      ,SUM(NetActualCNY) NetActualCNY
      ,SUM(NetActualINR) NetActualINR
      ,SUM(NetActualAUD) NetActualAUD
      ,SUM(NetActualCHF) NetActualCHF
      ,SUM(NetActualEUR) NetActualEUR
      ,SUM(NetActualGBP) NetActualGBP
      ,SUM(NetActualHUF) NetActualHUF
      ,SUM(NetActualKRW) NetActualKRW
      ,SUM(NetActualOMR) NetActualOMR
      ,SUM(NetActualPLN) NetActualPLN
      ,SUM(NetActualTLR) NetActualTLR
      ,SUM(NetActualDEF) NetActualDEF
      ,SUM(NetActualZAR) NetActualZAR

      ,SUM(BudgetLocal) BudgetLocal
      ,SUM(BudgetUSD) BudgetUSD
      ,SUM(BudgetBRL) BudgetBRL
      ,SUM(BudgetCNY) BudgetCNY
      ,SUM(BudgetINR) BudgetINR
      ,SUM(BudgetAUD) BudgetAUD
      ,SUM(BudgetCHF) BudgetCHF
      ,SUM(BudgetEUR) BudgetEUR
      ,SUM(BudgetGBP) BudgetGBP
      ,SUM(BudgetHUF) BudgetHUF
      ,SUM(BudgetKRW) BudgetKRW
      ,SUM(BudgetOMR) BudgetOMR
      ,SUM(BudgetPLN) BudgetPLN
      ,SUM(BudgetTLR) BudgetTLR
      ,SUM(BudgetDEF) BudgetDEF
      ,SUM(BudgetZAR) BudgetZAR
      
      ,SUM(NetBudgetLocal) NetBudgetLocal
      ,SUM(NetBudgetUSD) NetBudgetUSD
      ,SUM(NetBudgetBRL) NetBudgetBRL
      ,SUM(NetBudgetCNY) NetBudgetCNY
      ,SUM(NetBudgetINR) NetBudgetINR
      ,SUM(NetBudgetAUD) NetBudgetAUD
      ,SUM(NetBudgetCHF) NetBudgetCHF
      ,SUM(NetBudgetEUR) NetBudgetEUR
      ,SUM(NetBudgetGBP) NetBudgetGBP
      ,SUM(NetBudgetHUF) NetBudgetHUF
      ,SUM(NetBudgetKRW) NetBudgetKRW
      ,SUM(NetBudgetOMR) NetBudgetOMR
      ,SUM(NetBudgetPLN) NetBudgetPLN
      ,SUM(NetBudgetTLR) NetBudgetTLR
      ,SUM(NetBudgetDEF) NetBudgetDEF
      ,SUM(NetBudgetZAR) NetBudgetZAR
From
	(
	SELECT 
		  pa.CalendarKey
		  ,NULL ReforecastKey
		  ,pa.GlAccountKey
		  ,pa.SourceKey
		  ,pa.FunctionalDepartmentKey
		  ,pa.ReimbursableKey
		  ,pa.ActivityTypeKey
		  ,pa.PropertyFundKey
		  ,pa.AllocationRegionKey
		  ,pa.OriginatingRegionKey
		  ,pa.USCorporateGlAccountCategoryKey
		  ,pa.USPropertyGlAccountCategoryKey
		  ,pa.USFundGlAccountCategoryKey
		  ,pa.EUCorporateGlAccountCategoryKey
		  ,pa.EUPropertyGlAccountCategoryKey
		  ,pa.EUFundGlAccountCategoryKey
		  ,pa.GlobalGlAccountCategoryKey
		  ,pa.DevelopmentGlAccountCategoryKey
	      
		  ,SUM(pa.LocalActual) ActualLocal
		  ,SUM(pa.LocalActual * ExchangeRateUSD.Rate) ActualUSD
		  ,SUM(pa.LocalActual * ExchangeRateBRL.Rate) ActualBRL
		  ,SUM(pa.LocalActual * ExchangeRateCNY.Rate) ActualCNY
		  ,SUM(pa.LocalActual * ExchangeRateINR.Rate) ActualINR
		  ,SUM(pa.LocalActual * ExchangeRateAUD.Rate) ActualAUD
		  ,SUM(pa.LocalActual * ExchangeRateCHF.Rate) ActualCHF
		  ,SUM(pa.LocalActual * ExchangeRateEUR.Rate) ActualEUR
		  ,SUM(pa.LocalActual * ExchangeRateGBP.Rate) ActualGBP
		  ,SUM(pa.LocalActual * ExchangeRateHUF.Rate) ActualHUF
		  ,SUM(pa.LocalActual * ExchangeRateKRW.Rate) ActualKRW
		  ,SUM(pa.LocalActual * ExchangeRateOMR.Rate) ActualOMR
		  ,SUM(pa.LocalActual * ExchangeRatePLN.Rate) ActualPLN
		  ,SUM(pa.LocalActual * ExchangeRateTLR.Rate) ActualTLR
		  ,SUM(pa.LocalActual * ExchangeRateDEF.Rate) ActualDEF
		  ,SUM(pa.LocalActual * ExchangeRateZAR.Rate) ActualZAR
		  
		  ,SUM(pa.LocalActual * r.MultiplicationFactor) NetActualLocal
		  ,SUM(pa.LocalActual * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetActualUSD
		  ,SUM(pa.LocalActual * ExchangeRateBRL.Rate * r.MultiplicationFactor) NetActualBRL
		  ,SUM(pa.LocalActual * ExchangeRateCNY.Rate * r.MultiplicationFactor) NetActualCNY
		  ,SUM(pa.LocalActual * ExchangeRateINR.Rate * r.MultiplicationFactor) NetActualINR
		  ,SUM(pa.LocalActual * ExchangeRateAUD.Rate * r.MultiplicationFactor) NetActualAUD
		  ,SUM(pa.LocalActual * ExchangeRateCHF.Rate * r.MultiplicationFactor) NetActualCHF
		  ,SUM(pa.LocalActual * ExchangeRateEUR.Rate * r.MultiplicationFactor) NetActualEUR
		  ,SUM(pa.LocalActual * ExchangeRateGBP.Rate * r.MultiplicationFactor) NetActualGBP
		  ,SUM(pa.LocalActual * ExchangeRateHUF.Rate * r.MultiplicationFactor) NetActualHUF
		  ,SUM(pa.LocalActual * ExchangeRateKRW.Rate * r.MultiplicationFactor) NetActualKRW
		  ,SUM(pa.LocalActual * ExchangeRateOMR.Rate * r.MultiplicationFactor) NetActualOMR
		  ,SUM(pa.LocalActual * ExchangeRatePLN.Rate * r.MultiplicationFactor) NetActualPLN
		  ,SUM(pa.LocalActual * ExchangeRateTLR.Rate * r.MultiplicationFactor) NetActualTLR
		  ,SUM(pa.LocalActual * ExchangeRateDEF.Rate * r.MultiplicationFactor) NetActualDEF
		  ,SUM(pa.LocalActual * ExchangeRateZAR.Rate * r.MultiplicationFactor) NetActualZAR

		  ,0.00 BudgetLocal
		  ,0.00 BudgetUSD
		  ,0.00 BudgetBRL
		  ,0.00 BudgetCNY
		  ,0.00 BudgetINR
		  ,0.00 BudgetAUD
		  ,0.00 BudgetCHF
		  ,0.00 BudgetEUR
		  ,0.00 BudgetGBP
		  ,0.00 BudgetHUF
		  ,0.00 BudgetKRW
		  ,0.00 BudgetOMR
		  ,0.00 BudgetPLN
		  ,0.00 BudgetTLR
		  ,0.00 BudgetDEF
		  ,0.00 BudgetZAR
	      
	      ,0.00 NetBudgetLocal
		  ,0.00 NetBudgetUSD
		  ,0.00 NetBudgetBRL
		  ,0.00 NetBudgetCNY
		  ,0.00 NetBudgetINR
		  ,0.00 NetBudgetAUD
		  ,0.00 NetBudgetCHF
		  ,0.00 NetBudgetEUR
		  ,0.00 NetBudgetGBP
		  ,0.00 NetBudgetHUF
		  ,0.00 NetBudgetKRW
		  ,0.00 NetBudgetOMR
		  ,0.00 NetBudgetPLN
		  ,0.00 NetBudgetTLR
		  ,0.00 NetBudgetDEF
		  ,0.00 NetBudgetZAR
		  
	FROM  dbo.ProfitabilityActual pa
	  
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey
	
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pa.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')

			LEFT OUTER JOIN ExchangeRate ExchangeRateBRL ON  ExchangeRateBRL.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateBRL.CalendarKey = pa.CalendarKey AND ExchangeRateBRL.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'BRL')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCNY ON  ExchangeRateCNY.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateCNY.CalendarKey = pa.CalendarKey AND ExchangeRateCNY.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'CNY')

			LEFT OUTER JOIN ExchangeRate ExchangeRateINR ON  ExchangeRateINR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateINR.CalendarKey = pa.CalendarKey AND ExchangeRateINR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'INR')

			LEFT OUTER JOIN ExchangeRate ExchangeRateAUD ON  ExchangeRateAUD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateAUD.CalendarKey = pa.CalendarKey AND ExchangeRateAUD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'AUD')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCAD ON  ExchangeRateCAD.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateCAD.CalendarKey = pa.CalendarKey AND ExchangeRateCAD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'CAD')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCHF ON  ExchangeRateCHF.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateCHF.CalendarKey = pa.CalendarKey AND ExchangeRateCHF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'CHF')

			LEFT OUTER JOIN ExchangeRate ExchangeRateEUR ON  ExchangeRateEUR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateEUR.CalendarKey = pa.CalendarKey AND ExchangeRateEUR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'EUR')

			LEFT OUTER JOIN ExchangeRate ExchangeRateGBP ON  ExchangeRateGBP.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateGBP.CalendarKey = pa.CalendarKey AND ExchangeRateGBP.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'GBP')

			LEFT OUTER JOIN ExchangeRate ExchangeRateHUF ON  ExchangeRateHUF.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateHUF.CalendarKey = pa.CalendarKey AND ExchangeRateHUF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'HUF')

			LEFT OUTER JOIN ExchangeRate ExchangeRateKRW ON  ExchangeRateKRW.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateKRW.CalendarKey = pa.CalendarKey AND ExchangeRateKRW.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'KRW')

			LEFT OUTER JOIN ExchangeRate ExchangeRateOMR ON  ExchangeRateOMR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateOMR.CalendarKey = pa.CalendarKey AND ExchangeRateOMR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'OMR')

			LEFT OUTER JOIN ExchangeRate ExchangeRatePLN ON  ExchangeRatePLN.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRatePLN.CalendarKey = pa.CalendarKey AND ExchangeRatePLN.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'PLN')

			LEFT OUTER JOIN ExchangeRate ExchangeRateTLR ON  ExchangeRateTLR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateTLR.CalendarKey = pa.CalendarKey AND ExchangeRateTLR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'TLR')

			LEFT OUTER JOIN ExchangeRate ExchangeRateDEF ON  ExchangeRateDEF.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateDEF.CalendarKey = pa.CalendarKey AND ExchangeRateDEF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'DEF')

			LEFT OUTER JOIN ExchangeRate ExchangeRateZAR ON  ExchangeRateZAR.SourceCurrencyKey = pa.LocalCurrencyKey AND ExchangeRateZAR.CalendarKey = pa.CalendarKey AND ExchangeRateZAR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'ZAR')
			
Group By
		pa.CalendarKey
	  ,pa.GlAccountKey
	  ,pa.SourceKey
	  ,pa.FunctionalDepartmentKey
	  ,pa.ReimbursableKey
	  ,pa.ActivityTypeKey
	  ,pa.PropertyFundKey
	  ,pa.AllocationRegionKey
	  ,pa.OriginatingRegionKey
	  ,pa.USCorporateGlAccountCategoryKey
	  ,pa.USPropertyGlAccountCategoryKey
	  ,pa.USFundGlAccountCategoryKey
	  ,pa.EUCorporateGlAccountCategoryKey
	  ,pa.EUPropertyGlAccountCategoryKey
	  ,pa.EUFundGlAccountCategoryKey
	  ,pa.GlobalGlAccountCategoryKey
	  ,pa.DevelopmentGlAccountCategoryKey

	UNION ALL

	SELECT 
			pb.CalendarKey
		  ,pb.ReforecastKey
		  ,pb.GlAccountKey
		  ,pb.SourceKey
		  ,pb.FunctionalDepartmentKey
		  ,pb.ReimbursableKey
		  ,pb.ActivityTypeKey
		  ,pb.PropertyFundKey
		  ,pb.AllocationRegionKey
		  ,pb.OriginatingRegionKey
		  ,pb.USCorporateGlAccountCategoryKey
		  ,pb.USPropertyGlAccountCategoryKey
		  ,pb.USFundGlAccountCategoryKey
		  ,pb.EUCorporateGlAccountCategoryKey
		  ,pb.EUPropertyGlAccountCategoryKey
		  ,pb.EUFundGlAccountCategoryKey
		  ,pb.GlobalGlAccountCategoryKey
		  ,pb.DevelopmentGlAccountCategoryKey
	      
		  ,NULL ActualLocal
		  ,NULL ActualUSD
		  ,NULL ActualBRL
		  ,NULL ActualCNY
		  ,NULL ActualINR
		  ,NULL ActualAUD
		  ,NULL ActualCHF
		  ,NULL ActualEUR
		  ,NULL ActualGBP
		  ,NULL ActualHUF
		  ,NULL ActualKRW
		  ,NULL ActualOMR
		  ,NULL ActualPLN
		  ,NULL ActualTLR
		  ,NULL ActualDEF
		  ,NULL ActualZAR
	      
	      ,NULL NetActualLocal
		  ,NULL NetActualUSD
		  ,NULL NetActualBRL
		  ,NULL NetActualCNY
		  ,NULL NetActualINR
		  ,NULL NetActualAUD
		  ,NULL NetActualCHF
		  ,NULL NetActualEUR
		  ,NULL NetActualGBP
		  ,NULL NetActualHUF
		  ,NULL NetActualKRW
		  ,NULL NetActualOMR
		  ,NULL NetActualPLN
		  ,NULL NetActualTLR
		  ,NULL NetActualDEF
		  ,NULL NetActualZAR
		  
		  ,SUM(pb.LocalBudget) BudgetLocal
		  ,SUM(pb.LocalBudget * ExchangeRateUSD.Rate) BudgetUSD
		  ,SUM(pb.LocalBudget * ExchangeRateBRL.Rate) BudgetBRL
		  ,SUM(pb.LocalBudget * ExchangeRateCNY.Rate) BudgetCNY
		  ,SUM(pb.LocalBudget * ExchangeRateINR.Rate) BudgetINR
		  ,SUM(pb.LocalBudget * ExchangeRateAUD.Rate) BudgetAUD
		  ,SUM(pb.LocalBudget * ExchangeRateCHF.Rate) BudgetCHF
		  ,SUM(pb.LocalBudget * ExchangeRateEUR.Rate) BudgetEUR
		  ,SUM(pb.LocalBudget * ExchangeRateGBP.Rate) BudgetGBP
		  ,SUM(pb.LocalBudget * ExchangeRateHUF.Rate) BudgetHUF
		  ,SUM(pb.LocalBudget * ExchangeRateKRW.Rate) BudgetKRW
		  ,SUM(pb.LocalBudget * ExchangeRateOMR.Rate) BudgetOMR
		  ,SUM(pb.LocalBudget * ExchangeRatePLN.Rate) BudgetPLN
		  ,SUM(pb.LocalBudget * ExchangeRateTLR.Rate) BudgetTLR
		  ,SUM(pb.LocalBudget * ExchangeRateDEF.Rate) BudgetDEF
		  ,SUM(pb.LocalBudget * ExchangeRateZAR.Rate) BudgetZAR
		  
		  ,SUM(pb.LocalBudget * r.MultiplicationFactor) NetBudgetLocal
		  ,SUM(pb.LocalBudget * ExchangeRateUSD.Rate * r.MultiplicationFactor) NetBudgetUSD
		  ,SUM(pb.LocalBudget * ExchangeRateBRL.Rate * r.MultiplicationFactor) NetBudgetBRL
		  ,SUM(pb.LocalBudget * ExchangeRateCNY.Rate * r.MultiplicationFactor) NetBudgetCNY
		  ,SUM(pb.LocalBudget * ExchangeRateINR.Rate * r.MultiplicationFactor) NetBudgetINR
		  ,SUM(pb.LocalBudget * ExchangeRateAUD.Rate * r.MultiplicationFactor) NetBudgetAUD
		  ,SUM(pb.LocalBudget * ExchangeRateCHF.Rate * r.MultiplicationFactor) NetBudgetCHF
		  ,SUM(pb.LocalBudget * ExchangeRateEUR.Rate * r.MultiplicationFactor) NetBudgetEUR
		  ,SUM(pb.LocalBudget * ExchangeRateGBP.Rate * r.MultiplicationFactor) NetBudgetGBP
		  ,SUM(pb.LocalBudget * ExchangeRateHUF.Rate * r.MultiplicationFactor) NetBudgetHUF
		  ,SUM(pb.LocalBudget * ExchangeRateKRW.Rate * r.MultiplicationFactor) NetBudgetKRW
		  ,SUM(pb.LocalBudget * ExchangeRateOMR.Rate * r.MultiplicationFactor) NetBudgetOMR
		  ,SUM(pb.LocalBudget * ExchangeRatePLN.Rate * r.MultiplicationFactor) NetBudgetPLN
		  ,SUM(pb.LocalBudget * ExchangeRateTLR.Rate * r.MultiplicationFactor) NetBudgetTLR
		  ,SUM(pb.LocalBudget * ExchangeRateDEF.Rate * r.MultiplicationFactor) NetBudgetDEF
		  ,SUM(pb.LocalBudget * ExchangeRateZAR.Rate * r.MultiplicationFactor) NetBudgetZAR
	      
	  FROM dbo.ProfitabilityBudget pb
	  
			LEFT OUTER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
	  
			LEFT OUTER JOIN ExchangeRate ExchangeRateUSD ON  ExchangeRateUSD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateUSD.CalendarKey = pb.CalendarKey AND ExchangeRateUSD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'USD')

			LEFT OUTER JOIN ExchangeRate ExchangeRateBRL ON  ExchangeRateBRL.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateBRL.CalendarKey = pb.CalendarKey AND ExchangeRateBRL.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'BRL')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCNY ON  ExchangeRateCNY.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateCNY.CalendarKey = pb.CalendarKey AND ExchangeRateCNY.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'CNY')

			LEFT OUTER JOIN ExchangeRate ExchangeRateINR ON  ExchangeRateINR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateINR.CalendarKey = pb.CalendarKey AND ExchangeRateINR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'INR')

			LEFT OUTER JOIN ExchangeRate ExchangeRateAUD ON  ExchangeRateAUD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateAUD.CalendarKey = pb.CalendarKey AND ExchangeRateAUD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'AUD')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCAD ON  ExchangeRateCAD.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateCAD.CalendarKey = pb.CalendarKey AND ExchangeRateCAD.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'CAD')

			LEFT OUTER JOIN ExchangeRate ExchangeRateCHF ON  ExchangeRateCHF.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateCHF.CalendarKey = pb.CalendarKey AND ExchangeRateCHF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'CHF')

			LEFT OUTER JOIN ExchangeRate ExchangeRateEUR ON  ExchangeRateEUR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateEUR.CalendarKey = pb.CalendarKey AND ExchangeRateEUR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'EUR')

			LEFT OUTER JOIN ExchangeRate ExchangeRateGBP ON  ExchangeRateGBP.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateGBP.CalendarKey = pb.CalendarKey AND ExchangeRateGBP.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'GBP')

			LEFT OUTER JOIN ExchangeRate ExchangeRateHUF ON  ExchangeRateHUF.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateHUF.CalendarKey = pb.CalendarKey AND ExchangeRateHUF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'HUF')

			LEFT OUTER JOIN ExchangeRate ExchangeRateKRW ON  ExchangeRateKRW.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateKRW.CalendarKey = pb.CalendarKey AND ExchangeRateKRW.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'KRW')

			LEFT OUTER JOIN ExchangeRate ExchangeRateOMR ON  ExchangeRateOMR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateOMR.CalendarKey = pb.CalendarKey AND ExchangeRateOMR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'OMR')

			LEFT OUTER JOIN ExchangeRate ExchangeRatePLN ON  ExchangeRatePLN.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRatePLN.CalendarKey = pb.CalendarKey AND ExchangeRatePLN.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'PLN')

			LEFT OUTER JOIN ExchangeRate ExchangeRateTLR ON  ExchangeRateTLR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateTLR.CalendarKey = pb.CalendarKey AND ExchangeRateTLR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'TLR')

			LEFT OUTER JOIN ExchangeRate ExchangeRateDEF ON  ExchangeRateDEF.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateDEF.CalendarKey = pb.CalendarKey AND ExchangeRateDEF.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'DEF')

			LEFT OUTER JOIN ExchangeRate ExchangeRateZAR ON  ExchangeRateZAR.SourceCurrencyKey = pb.LocalCurrencyKey AND ExchangeRateZAR.CalendarKey = pb.CalendarKey AND ExchangeRateZAR.DestinationCurrencyKey = (Select CurrencyKey From Currency Where CurrencyCode = 'ZAR')

		Group By
			  pb.CalendarKey
			  ,pb.ReforecastKey
			  ,pb.GlAccountKey
			  ,pb.SourceKey
			  ,pb.FunctionalDepartmentKey
			  ,pb.ReimbursableKey
			  ,pb.ActivityTypeKey
			  ,pb.PropertyFundKey
			  ,pb.AllocationRegionKey
			  ,pb.OriginatingRegionKey
			  ,pb.USCorporateGlAccountCategoryKey
			  ,pb.USPropertyGlAccountCategoryKey
			  ,pb.USFundGlAccountCategoryKey
			  ,pb.EUCorporateGlAccountCategoryKey
			  ,pb.EUPropertyGlAccountCategoryKey
			  ,pb.EUFundGlAccountCategoryKey
			  ,pb.GlobalGlAccountCategoryKey
			  ,pb.DevelopmentGlAccountCategoryKey

	) Summary

	Group By
		CalendarKey
      ,ReforecastKey
      ,GlAccountKey
      ,SourceKey
      ,FunctionalDepartmentKey
      ,ReimbursableKey
      ,ActivityTypeKey
      ,PropertyFundKey
      ,AllocationRegionKey
      ,OriginatingRegionKey
      ,USCorporateGlAccountCategoryKey
      ,USPropertyGlAccountCategoryKey
      ,USFundGlAccountCategoryKey
      ,EUCorporateGlAccountCategoryKey
      ,EUPropertyGlAccountCategoryKey
      ,EUFundGlAccountCategoryKey
      ,GlobalGlAccountCategoryKey
      ,DevelopmentGlAccountCategoryKey

GO
--select * from ProfitabilityFact

