  DECLARE	@dtStart DateTime,
		@dtStop DateTime


SET @dtStart = '2009-01-01'
SET @dtStop = '2015-01-01'

Delete from Reforecast
SET NOCOUNT ON

WHILE (@dtStart < @dtStop)
	BEGIN
	Insert Into Reforecast
	(
		ReforecastKey, 
		ReforecastEffectiveMonth, 
		ReforecastEffectiveQuater, 
		ReforecastEffectiveYear, 
		ReforecastMonthName, 
		ReforecastQuaterName, 
		ReforecastEffectivePeriod
	 )
	SELECT 
			DATEDIFF(dd, '1900-01-01', @dtStart), 
			DATEPART(mm, @dtStart),
			DATEPART(QQ, @dtStart),
			YEAR(@dtStart),
			DATENAME(MM, @dtStart),
			'Q' + CONVERT(varchar(2),DATEPART(QQ, @dtStart) - 1),
			CONVERT(Varchar(6), @dtStart,112)
	

	SET @dtStart = DATEADD(mm,1, @dtStart)
	END

