DECLARE	@dtStart DateTime,
		@dtStop DateTime


SET @dtStart = '2000-01-01'
SET @dtStop = '2016-01-01'

--select count(*) from Calendar
SET NOCOUNT ON

WHILE (@dtStart < @dtStop)
	BEGIN
	Insert Into Calendar
	(CalendarKey, CalendarDate, CalendarYear, CalendarQuater, CalendarMonth, CalendarMonthName, CalendarPeriod, FinancialPeriod)
	SELECT 
			DATEDIFF(dd, '1900-01-01', @dtStart), 
			@dtStart, 
			YEAR(@dtStart),
			DATEPART(QQ, @dtStart),
			DATEPART(mm, @dtStart),
			DATENAME(MM, @dtStart),
			CONVERT(Varchar(6), @dtStart,112),
			CONVERT(Varchar(6), @dtStart,112)
	

	SET @dtStart = DATEADD(dd,1, @dtStart)
	END

