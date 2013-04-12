
--------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @RFID int = (Select MAX(ReforecastKey) From GrReporting.dbo.Reforecast)

BEGIN  TRAN
IF NOT EXISTS(select * From GrReporting.dbo.Reforecast t1 Where ReforecastEffectiveYear = 2011)
	BEGIN
	Insert Into Reforecast
	(ReforecastKey, ReforecastEffectiveMonth,ReforecastEffectiveQuarter,ReforecastEffectiveYear,
	ReforecastMonthName,ReforecastQuarterName,ReforecastEffectivePeriod)
	Select 
			ROW_NUMBER() OVER(ORDER BY ReforecastKey ASC) + @RFID,
			ReforecastEffectiveMonth,
			ReforecastEffectiveQuarter,
			2011 ReforecastEffectiveYear,
			ReforecastMonthName,
			ReforecastQuarterName,
			REPLACE(ReforecastEffectivePeriod,'2010','2011')
	From GrReporting.dbo.Reforecast t1
	Where ReforecastEffectiveYear = 2010
	Order By 1

	COMMIT TRAN
	END

GO
