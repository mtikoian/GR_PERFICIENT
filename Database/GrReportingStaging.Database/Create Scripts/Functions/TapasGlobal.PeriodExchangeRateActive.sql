USE [GrReportingStaging]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PeriodExchangeRateActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[PeriodExchangeRateActive]
GO
/*
CREATE   FUNCTION [TapasGlobal].[PeriodExchangeRateActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[TapasGlobal].[PeriodExchangeRate] Gl1
		INNER JOIN (
		Select 
				PeriodExchangeRateId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[TapasGlobal].[PeriodExchangeRate]
		Where	UpdatedDate <= @DataPriorToDate
		Group By PeriodExchangeRateId
		) t1 ON t1.PeriodExchangeRateId = Gl1.PeriodExchangeRateId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.PeriodExchangeRateId	

RETURN 
END
*/
GO


