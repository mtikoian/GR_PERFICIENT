--Increment change dates and period by one year	
UPDATE 
	Admin.ExchangeRateDetail
SET 
	Period = (Period + 100),
    InsertedDate = DATEADD(yy, 1, InsertedDate),
    UpdatedDate = DATEADD(yy, 1, UpdatedDate)
WHERE  
	UpdatedDate < '2010-01-01' AND
	Period < 201001
	
UPDATE 
	Admin.ExchangeRate
SET 
	StartPeriod = (StartPeriod + 100),
    EndPeriod = (EndPeriod + 100),
    InsertedDate = DATEADD(yy, 1, InsertedDate),
    UpdatedDate = DATEADD(yy, 1, UpdatedDate)
WHERE  
	UpdatedDate < '2010-01-01' AND
	StartPeriod < 201001 AND
	EndPeriod < 201001
	  
UPDATE 
	Admin.BudgetReportGroup
SET 
	StartPeriod = StartPeriod + 100,
    EndPeriod = EndPeriod + 100,
    FirstProjectedPeriod = FirstProjectedPeriod + 100,
    GRChangedDate = DATEADD(yy, 1, GRChangedDate),
    ExchangeRateChangedDate = DATEADD(yy, 1, ExchangeRateChangedDate),
    InsertedDate = DATEADD(yy, 1, InsertedDate),
    UpdatedDate = DATEADD(yy, 1, UpdatedDate)
WHERE  
	UpdatedDate < '2010-01-01' AND
	StartPeriod < 201001 AND
	EndPeriod < 201001


UPDATE 
	Admin.BudgetReportGroupDetail
SET 
	InsertedDate = DATEADD(yy, 1, InsertedDate),
    UpdatedDate = DATEADD(yy, 1, UpdatedDate)
WHERE  
	UpdatedDate < '2010-01-01'

UPDATE 
	Budget.Budget
SET 
	StartPeriod = (StartPeriod + 100),
    EndPeriod = (EndPeriod + 100),
    FirstProjectedPeriod = (FirstProjectedPeriod + 100),
    InsertedDate = DATEADD(yy, 1, InsertedDate),
    UpdatedDate = DATEADD(yy, 1, UpdatedDate),
    LastLockedDate = DATEADD(yy, 1, LastLockedDate)
WHERE  
	UpdatedDate < '2010-01-01' AND
	StartPeriod < 201001 AND
	EndPeriod < 201001

UPDATE 
	Budget.BudgetStatus
SET 
	InsertedDate = DATEADD(yy, 1, InsertedDate)
WHERE  
	InsertedDate < '2010-01-01'