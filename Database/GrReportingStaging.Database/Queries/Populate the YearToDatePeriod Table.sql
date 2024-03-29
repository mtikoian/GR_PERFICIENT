DECLARE	@dtStart DateTime,
		@dtStop DateTime,
		@CalendarPeriod Int,
		@CalendarDate DateTime,
		@CalendarMonthName Varchar(50)


SET @dtStart = '2000-01-01'
SET @dtStop = '2016-01-01'
SET NOCOUNT ON

DELETE FROM [YearToDatePeriod]

DECLARE CC SCROLL Cursor FOR

Select CalendarPeriod,CalendarMonthName, MIN(CalendarDate) From Calendar Group by CalendarPeriod,CalendarMonthName

OPEN CC
FETCH NEXT From CC INTO @CalendarPeriod,@CalendarMonthName,@CalendarDate

WHILE (@@fetch_status <> -1)
	BEGIN
	IF (@@fetch_status <> -2)
		BEGIN

		INSERT INTO YearToDatePeriod
		(YearToDatePeriod,YearToDateYear,YearToDateQuater,YearToDateMonth
		,YearToDateMonthName,EffectiveDate)
		VALUES(@CalendarPeriod, YEAR(@CalendarDate),
				DATEPART(QQ, @CalendarDate), MONTH(@CalendarDate),
				@CalendarMonthName,@CalendarDate)
		END
	FETCH NEXT From CC INTO @CalendarPeriod,@CalendarMonthName,@CalendarDate
	END
CLOSE CC
DEALLOCATE CC


