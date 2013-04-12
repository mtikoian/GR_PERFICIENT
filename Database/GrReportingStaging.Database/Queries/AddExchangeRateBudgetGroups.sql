BEGIN TRANSACTION
 
DECLARE @ExchangeRateIds TABLE (ExchangeRateId INT)

INSERT INTO Admin.ExchangeRate
(
	-- ExchangeRateId -- this column value is auto-generated,
	[Name],
	StartPeriod,
	EndPeriod,
	IsLocked,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
VALUES
(
	'Nick''s Exchange Rate'				/* [Name]	*/,
	201001								/* StartPeriod	*/,
	201012								/* EndPeriod	*/,
	1									/* IsLocked	*/,
	'2010-05-05'						/* InsertedDate	*/,
	'2010-05-05'						/* UpdatedDate	*/,
	1									/* UpdatedByStaffId	*/
)
INSERT INTO @ExchangeRateIds (ExchangeRateId) VALUES (SCOPE_IDENTITY())

INSERT INTO Admin.ExchangeRate
(
	-- ExchangeRateId -- this column value is auto-generated,
	[Name],
	StartPeriod,
	EndPeriod,
	IsLocked,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
VALUES
(
	'Nick''s Exchange Rate 2'				/* [Name]	*/,
	201001								/* StartPeriod	*/,
	201012								/* EndPeriod	*/,
	1									/* IsLocked	*/,
	'2010-05-05'						/* InsertedDate	*/,
	'2010-05-05'						/* UpdatedDate	*/,
	1									/* UpdatedByStaffId	*/
)
INSERT INTO @ExchangeRateIds (ExchangeRateId) VALUES (SCOPE_IDENTITY())

INSERT INTO Admin.ExchangeRate
(
	-- ExchangeRateId -- this column value is auto-generated,
	[Name],
	StartPeriod,
	EndPeriod,
	IsLocked,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
VALUES
(
	'Nick''s Exchange Rate 3'				/* [Name]	*/,
	201001								/* StartPeriod	*/,
	201012								/* EndPeriod	*/,
	1									/* IsLocked	*/,
	'2010-05-05'						/* InsertedDate	*/,
	'2010-05-05'						/* UpdatedDate	*/,
	1									/* UpdatedByStaffId	*/
)
INSERT INTO @ExchangeRateIds (ExchangeRateId) VALUES (SCOPE_IDENTITY())

DECLARE ExchangeRateCursor CURSOR FOR 
SELECT ExchangeRateId
FROM @ExchangeRateIds

OPEN ExchangeRateCursor

DECLARE @ExchangeRateId INT

FETCH NEXT FROM ExchangeRateCursor 
INTO @ExchangeRateId

WHILE @@FETCH_STATUS = 0
BEGIN
	
	DECLARE @COUNT INT
	SET @COUNT = 0

	WHILE @COUNT < 13
	BEGIN
		INSERT INTO Admin.ExchangeRateDetail
		(
			-- ExchangeRateDetailId -- this column value is auto-generated,
			ExchangeRateId,
			CurrencyCode,
			Period,
			Rate,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId
		)
		VALUES
		(
			@ExchangeRateId		/* ExchangeRateId	*/,
			'EUR'				/* CurrencyCode	*/,
			(201000 + @COUNT) /* Period	*/,
			ROUND(0.5 + (RAND(CHECKSUM(NEWID())) * (20-0.5)), 2) /* Rate	*/,
			'2010-05-05'/* InsertedDate	*/,
			'2010-05-05'/* UpdatedDate	*/,
			1/* UpdatedByStaffId	*/
		)

		SET @COUNT = @COUNT + 1
	END
	
	DECLARE @BudgetReportGroupId INT
	
	INSERT INTO Admin.BudgetReportGroup
	(
		-- BudgetReportGroupId -- this column value is auto-generated,
		[Name],
		ExchangeRateId,
		IsReforecast,
		StartPeriod,
		EndPeriod,
		FirstProjectedPeriod,
		IsDeleted,
		GRChangedDate,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES
	(
		'Nick''s Budget ' + CAST(@ExchangeRateId AS VARCHAR(50))	/* [Name]	*/,
		@ExchangeRateId												/* ExchangeRateId	*/,
		0															/* IsReforecast	*/,
		201001														/* StartPeriod	*/,
		201012														/* EndPeriod	*/,
		NULL														/* FirstProjectedPeriod	*/,
		0															/* IsDeleted	*/,
		'2010-05-05'												/* GRChangedDate	*/,
		'2010-05-05'												/* InsertedDate	*/,
		'2010-05-05'												/* UpdatedDate	*/,
		1															/* UpdatedByStaffId	*/
	)
	
	SET @BudgetReportGroupId = SCOPE_IDENTITY()
	
	INSERT INTO Admin.GRBudgetReportGroupPeriod
	(
		-- GRBudgetReportGroupPeriodId -- this column value is auto-generated,
		[Year],
		Period,
		BudgetReportGroupId,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES
	(
		2010						/* [Year]	*/,
		201001						/* Period	*/,
		@BudgetReportGroupId		/* BudgetReportGroupId	*/,
		0							/* IsDeleted	*/,
		'2010-05-05'				/* InsertedDate	*/,
		'2010-05-05'				/* UpdatedDate	*/,
		1							/* UpdatedByStaffId	*/
	)
	
	SET @COUNT = 0
	
	WHILE @COUNT < 3
	BEGIN
		
		DECLARE @BudgetId INT
		
		SELECT TOP 1 @BudgetId = BudgetId FROM Budget.Budget b ORDER BY NEWID()
		
		UPDATE Budget.Budget SET BudgetStatusId=5 WHERE BudgetId=@BudgetId
		
		INSERT INTO Admin.BudgetReportGroupDetail
		(
			-- BudgetReportGroupDetailId -- this column value is auto-generated,
			BudgetReportGroupId,
			RegionId,
			BudgetId,
			IsDeleted,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId
		)
		VALUES
		(
			@BudgetReportGroupId/* BudgetReportGroupId	*/,
			7/* RegionId	*/,
			@BudgetId/* BudgetId	*/,
			0/* IsDeleted	*/,
			'2010-05-05'/* InsertedDate	*/,
			'2010-05-05'/* UpdatedDate	*/,
			1/* UpdatedByStaffId	*/
		)
		SET @COUNT = @COUNT + 1
	END
	
    
    FETCH NEXT FROM ExchangeRateCursor 
    INTO @ExchangeRateId
END 
CLOSE ExchangeRateCursor
DEALLOCATE ExchangeRateCursor

ROLLBACK