USE [GrReportingStaging]
GO

/****** Object:  View [dbo].[PeriodExchangeRateLatestForPeriod]    Script Date: 09/02/2009 12:39:27 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PeriodExchangeRateLatestForPeriod]'))
DROP VIEW [dbo].[PeriodExchangeRateLatestForPeriod]
GO

USE [GrReportingStaging]
GO

/****** Object:  View [dbo].[PeriodExchangeRateLatestForPeriod]    Script Date: 09/02/2009 12:39:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*

CREATE VIEW [dbo].[PeriodExchangeRateLatestForPeriod]
AS
Select 
		Ex.ImportKey,
		Ex.PeriodExchangeRateId,
		Ex.Period,
		Ex.CurrencyCode,
		Ex.Rate,
		Ex.InsertedDate,
		Ex.UpdatedDate,
		Ex.UpdatedByStaffId
From TapasGlobal.PeriodExchangeRate Ex
		INNER JOIN (
					Select  
						Exi.CurrencyCode,
						Exi.Period,
						MAX(Exi.ImportKey) ImportKey
					From TapasGlobal.PeriodExchangeRate Exi
							INNER JOIN(
										Select  
											CurrencyCode,
											Period,
											MAX(UpdatedDate) UpdatedDate
										From TapasGlobal.PeriodExchangeRate
										Group By
											CurrencyCode,
											Period
										) t1 ON t1.CurrencyCode = Exi.CurrencyCode
										AND t1.Period = Exi.Period
										AND t1.UpdatedDate = Exi.UpdatedDate
					Group By
						Exi.CurrencyCode,
						Exi.Period
					) t1 ON t1.CurrencyCode = Ex.CurrencyCode
					AND t1.Period = Ex.Period
					AND t1.ImportKey = Ex.ImportKey

*/
GO


 