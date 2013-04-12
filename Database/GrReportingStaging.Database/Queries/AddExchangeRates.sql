DECLARE @ExchangeRateId INT
SET @ExchangeRateId = 13

DECLARE @Period INT
SET @Period = 201000

DECLARE @InsertedDate DATETIME
SET @InsertedDate = '2010-05-05 00:00:00.000'

DECLARE @CurrencyList TABLE
(
	CurrencyCode CHAR(3),
	ExchangeRate DECIMAL(18,4)
)

INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('USD', 1)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('BRL', 1.70000085)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('CNY', 6.8271036)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('INR', 45.9601066)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('AUD', 1.08401084)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('CAD', 1.02349955)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('CHF', 1.01270027)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('EUR', 0.669209663)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('GBP', 0.617436404)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('HUF', 178.73101)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('KRW', 1152.07373)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('OMR', 0.385009279)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('PLN', 2.80760074)
INSERT INTO @CurrencyList (CurrencyCode, ExchangeRate) VALUES ('TLR', 1)

DELETE FROM Admin.ExchangeRateDetail WHERE ExchangeRateId = @ExchangeRateId

DECLARE @i INT
SET @i = 1

WHILE (@i<=12)
BEGIN

	INSERT INTO Admin.ExchangeRateDetail
	(
		ExchangeRateId,
		CurrencyCode,
		Period,
		Rate,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	SELECT 
		@ExchangeRateId AS ExchangeRateId,
		CurrencyCode, 
		@Period + @i AS Period,
		ExchangeRate + ROUND(RAND(CHECKSUM(NEWID())), 4) AS Rate,
		@InsertedDate,
		@InsertedDate,
		-1
	FROM 
		@CurrencyList
	
	SET @i = @i + 1
END

SELECT * FROM Admin.ExchangeRateDetail erd WHERE erd.ExchangeRateId=@ExchangeRateId