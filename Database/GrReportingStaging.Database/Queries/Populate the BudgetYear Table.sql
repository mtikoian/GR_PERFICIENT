 DECLARE	@dtStart DateTime,
		@dtStop DateTime


SET @dtStart = '2009-01-01'
SET @dtStop = '2015-01-01'

Delete from BudgetYear
SET NOCOUNT ON

WHILE (@dtStart < @dtStop)
	BEGIN
	Insert Into BudgetYear
	(
		BudgetYearKey, 
		BudgetStartMonth,
		BudgetYearDescription,
		BudgetStartPeriod
	 )
	SELECT 
			DATEDIFF(dd, '1900-01-01', @dtStart), 
			DATEPART(mm, @dtStart),
			YEAR(@dtStart),
			CONVERT(Varchar(6), @dtStart,112)
	

	SET @dtStart = DATEADD(yy,1, @dtStart)
	END

 