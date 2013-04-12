
USE [GrReporting]
GO

--
--  Generate dbo.Source
--

-- Disable all check on table
ALTER TABLE dbo.Source NOCHECK CONSTRAINT ALL

-- Remove first all records
DELETE FROM dbo.Source
SET IDENTITY_INSERT Source ON

-- Insert new records
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (8, 'BC', 'BRCorp', 'Brazil Corporate', 'YES', 'NO')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (7, 'BR', 'BRProp', 'Brazil Property', 'NO', 'YES')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (6, 'CC', 'CNCorp', 'China Corporate', 'YES', 'NO')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (5, 'CN', 'CNProp', 'China Property', 'NO', 'YES')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (4, 'EC', 'EUCorp', 'Europe Corporate', 'YES', 'NO')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (3, 'EU', 'EUProp', 'Europe Property', 'NO', 'YES')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (10, 'IC', 'INCorp', 'India Corporate', 'YES', 'NO')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (9, 'IN', 'INProp', 'India Property', 'NO', 'YES')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (2, 'UC', 'USCorp', 'USA Corporate', 'YES', 'NO')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (-1, 'UN', 'UNKNOWN', 'Unknown', 'NO', 'NO')
INSERT INTO dbo.Source ([SourceKey], [SourceCode], [SourceSystem], [SourceName], [IsCorporate], [IsProperty]) VALUES (1, 'US', 'USProp', 'USA Property', 'NO', 'YES')
-- Enable all check on table
ALTER TABLE dbo.Source CHECK CONSTRAINT ALL

SET IDENTITY_INSERT Source OFF
--
--  Generate dbo.Reimbursable
--

-- Disable all check on table
ALTER TABLE dbo.Reimbursable NOCHECK CONSTRAINT ALL

-- Remove first all records
DELETE FROM dbo.Reimbursable


-- Insert new records
INSERT INTO dbo.Reimbursable ([ReimbursableKey], [ReimbursableCode], [ReimbursableName],MultiplicationFactor) VALUES (2, 'NO', 'Not Reimbursable',1)
INSERT INTO dbo.Reimbursable ([ReimbursableKey], [ReimbursableCode], [ReimbursableName],MultiplicationFactor) VALUES (-1, 'UNKNOWN', 'UNKNOWN',0)
INSERT INTO dbo.Reimbursable ([ReimbursableKey], [ReimbursableCode], [ReimbursableName],MultiplicationFactor) VALUES (3, 'YES', 'Reimbursable', 0)
-- Enable all check on table
ALTER TABLE dbo.Reimbursable CHECK CONSTRAINT ALL


--
--  Generate dbo.Currency
--

-- Disable all check on table
ALTER TABLE dbo.Currency NOCHECK CONSTRAINT ALL

-- Remove first all records
DELETE FROM dbo.Currency

SET IDENTITY_INSERT Currency ON
-- Insert new records
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (17, 'AUD', 'Australian Dollar')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (3, 'BRL', 'Brazil Real')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (18, 'CAD', 'Canadian Dollar')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (19, 'CHF', 'Swiss Franc')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (4, 'CNY', 'Chinese Yuan')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (21, 'EUR', 'Euro')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (22, 'GBP', 'British Pound')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (23, 'HUF', 'Hungarian Forint')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (5, 'INR', 'Indian Rupee')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (24, 'KRW', 'South Korean Won')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (25, 'OMR', 'Omani Rial')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (26, 'PLN', 'Polish Zloty')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (27, 'TLR', 'Turkish Lira')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (-1, 'UNK', 'UNKNOWN')
INSERT INTO dbo.Currency ([CurrencyKey], [CurrencyCode], [Name]) VALUES (2, 'USD', 'U.S. Dollar')
-- Enable all check on table
ALTER TABLE dbo.Currency CHECK CONSTRAINT ALL

SET IDENTITY_INSERT Currency OFF

GO

DECLARE	@dtStart DateTime,
		@dtStop DateTime

Delete from Calendar

SET @dtStart = '2000-01-01'
SET @dtStop = '2016-01-01'

--select count(*) from Calendar
SET NOCOUNT ON

WHILE (@dtStart < @dtStop)
	BEGIN
	Insert Into Calendar
	(CalendarKey, CalendarDate, CalendarYear, CalendarQuarter, CalendarMonth, CalendarMonthName, CalendarPeriod, FinancialPeriod)
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

GO


-- populate reforecast 
DECLARE @dtStart DateTime,
		@dtStop DateTime

SET @dtStart = '2010-01-01'
SET @dtStop = '2010-12-31'

Delete from Reforecast

INSERT INTO dbo.Reforecast 
	(ReforecastKey, ReforecastEffectiveMonth, ReforecastEffectiveQuarter, ReforecastEffectiveYear, ReforecastMonthName, ReforecastQuarterName, ReforecastEffectivePeriod)
VALUES
	(-1, 0,	0, -1, 'UNKNOWN', 'UNKNOWN', -1)

SET NOCOUNT ON

WHILE (@dtStart < @dtStop)
	BEGIN
	Insert Into Reforecast
	(
		ReforecastKey, 
		ReforecastEffectiveMonth, 
		ReforecastEffectiveQuarter, 
		ReforecastEffectiveYear, 
		ReforecastMonthName, 
		ReforecastQuarterName, 
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
GO

--Update 201003 to also be part of the Q1 reforecasts.
UPDATE Reforecast 
SET ReforecastEffectiveQuarter = 2,
ReforecastQuarterName = 'Q1'
WHERE ReforecastKey = 40236

GO

--Update 201003 to also be part of the Q1 reforecasts.
UPDATE Reforecast 
SET ReforecastEffectiveQuarter = 3,
ReforecastQuarterName = 'Q2'
WHERE ReforecastMonthName = 'June'

GO

IF NOT EXISTS(Select * From GlAccount Where Code = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT GLACCOUNT ON 
	INSERT INTO GLACCOUNT
	(GlAccountKey, GLGlobalAccountId, Code, [Name], StartDate, EndDate, AccountType)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','1900-01-01','9999-01-01', 'UNKNOWN')
	SET IDENTITY_INSERT GLACCOUNT OFF
	END

--IF NOT EXISTS(Select * From GlAccountCategory Ac Where Ac.HierarchyName = 'DEFAULT')
--	BEGIN
--	SET IDENTITY_INSERT GlAccountCategory ON 
--	INSERT INTO GlAccountCategory
--	(GlAccountCategoryKey,GlobalGlAccountCategoryCode, TranslationTypeName, TranslationSubTypeName, MajorCategoryName, MinorCategoryName, 
--			AccountTypeName, AccountSubTypeName, StartDate, EndDate)
--	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN', 'UNKNOWN','UNKNOWN', '1900-01-01','9999-01-01')
--	SET IDENTITY_INSERT GlAccountCategory OFF
--	END

IF NOT EXISTS(Select * From ActivityType At Where At.ActivityTypeCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT ActivityType ON 
	INSERT INTO ActivityType
	(ActivityTypeKey, ActivityTypeId, ActivityTypeCode,ActivityTypeName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT ActivityType OFF
	END
	
IF NOT EXISTS(Select * From AllocationRegion Ar Where Ar.RegionCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT AllocationRegion ON 
	INSERT INTO AllocationRegion
	(AllocationRegionKey,GlobalRegionId,RegionCode,RegionName,SubRegionCode,SubRegionName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT AllocationRegion OFF
	END
	
IF NOT EXISTS(Select * From PropertyFund Pf Where Pf.PropertyFundName = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT PropertyFund ON 
	INSERT INTO PropertyFund
	(PropertyFundKey,PropertyFundId,PropertyFundName,PropertyFundType, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT PropertyFund OFF
	END
	

IF NOT EXISTS(Select * From FunctionalDepartment Fd Where Fd.FunctionalDepartmentCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT FunctionalDepartment ON 
	INSERT INTO FunctionalDepartment
	(FunctionalDepartmentKey, ReferenceCode, FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT FunctionalDepartment OFF
	END

IF NOT EXISTS(Select * From OriginatingRegion Ar Where Ar.RegionCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT OriginatingRegion ON 
	INSERT INTO OriginatingRegion
	(OriginatingRegionKey,GlobalRegionId,RegionCode,RegionName,SubRegionCode,SubRegionName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT OriginatingRegion OFF
	END
IF NOT EXISTS(Select * From Reimbursable Re Where Re.ReimbursableCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT Reimbursable ON 
	INSERT INTO Reimbursable
	(ReimbursableKey,ReimbursableCode,ReimbursableName)
	VALUES(-1,'UNKNOWN','UNKNOWN')
	SET IDENTITY_INSERT Reimbursable OFF
	END
	
IF NOT EXISTS(Select * From Reimbursable Re Where Re.ReimbursableCode = 'YES')
	BEGIN
	SET IDENTITY_INSERT Reimbursable ON 
	INSERT INTO Reimbursable
	(ReimbursableKey,ReimbursableCode,ReimbursableName)
	VALUES(2,'YES','Reimbursable')
	SET IDENTITY_INSERT Reimbursable OFF
	END
	
IF NOT EXISTS(Select * From Reimbursable Re Where Re.ReimbursableCode = 'NO')
	BEGIN
	SET IDENTITY_INSERT Reimbursable ON 
	INSERT INTO Reimbursable
	(ReimbursableKey,ReimbursableCode,ReimbursableName)
	VALUES(3,'NO','Not Reimbursable')
	SET IDENTITY_INSERT Reimbursable OFF
	END

GO

IF NOT EXISTS(Select * From ProfitabilityActualSourceTable
		Where ProfitabilityActualSourceTableId = 1)
		BEGIN
		Insert Into ProfitabilityActualSourceTable
		(ProfitabilityActualSourceTableId, SourceTable)
		VALUES(1, 'JOURNAL')
		END

IF NOT EXISTS(Select * From ProfitabilityActualSourceTable
		Where ProfitabilityActualSourceTableId = 2)
		BEGIN
		Insert Into ProfitabilityActualSourceTable
		(ProfitabilityActualSourceTableId, SourceTable)
		VALUES(2, 'GHIS')
		END

IF NOT EXISTS(Select * From ProfitabilityActualSourceTable
		Where ProfitabilityActualSourceTableId = 3)
		BEGIN
		Insert Into ProfitabilityActualSourceTable
		(ProfitabilityActualSourceTableId, SourceTable)
		VALUES(3, 'BillingUploadDetail')
		END
		
GO
-- Add rows to [dbo].[YearToDate]
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (-1, 'UNKNOWN', 'UNKNOWN', -1, -1)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40177, 'January', 'Q0', 201001, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40208, 'February', 'Q0', 201002, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40236, 'March', 'Q0', 201003, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40267, 'April', 'Q1', 201004, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40297, 'May', 'Q1', 201005, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40328, 'June', 'Q1', 201006, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40358, 'July', 'Q2', 201007, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40389, 'August', 'Q2', 201008, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40420, 'September', 'Q2', 201009, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40450, 'October', 'Q3', 201010, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40481, 'November', 'Q3', 201011, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40511, 'December', 'Q3', 201012, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40542, 'January', 'Q0', 201101, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40573, 'February', 'Q0', 201102, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40601, 'March', 'Q0', 201103, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40632, 'April', 'Q1', 201104, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40662, 'May', 'Q1', 201105, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40693, 'June', 'Q1', 201106, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40723, 'July', 'Q2', 201107, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40754, 'August', 'Q2', 201108, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40785, 'September', 'Q2', 201109, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40815, 'October', 'Q3', 201110, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40846, 'November', 'Q3', 201111, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40876, 'December', 'Q3', 201112, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40907, 'January', 'Q0', 201201, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40938, 'February', 'Q0', 201202, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40967, 'March', 'Q0', 201203, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40998, 'April', 'Q1', 201204, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41028, 'May', 'Q1', 201205, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41059, 'June', 'Q1', 201206, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41089, 'July', 'Q2', 201207, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41120, 'August', 'Q2', 201208, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41151, 'September', 'Q2', 201209, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41181, 'October', 'Q3', 201210, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41212, 'November', 'Q3', 201211, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41242, 'December', 'Q3', 201212, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41273, 'January', 'Q0', 201301, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41304, 'February', 'Q0', 201302, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41332, 'March', 'Q0', 201303, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41363, 'April', 'Q1', 201304, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41393, 'May', 'Q1', 201305, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41424, 'June', 'Q1', 201306, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41454, 'July', 'Q2', 201307, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41485, 'August', 'Q2', 201308, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41516, 'September', 'Q2', 201309, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41546, 'October', 'Q3', 201310, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41577, 'November', 'Q3', 201311, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41607, 'December', 'Q3', 201312, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41638, 'January', 'Q0', 201401, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41669, 'February', 'Q0', 201402, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41697, 'March', 'Q0', 201403, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41728, 'April', 'Q1', 201404, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41758, 'May', 'Q1', 201405, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41789, 'June', 'Q1', 201406, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41819, 'July', 'Q2', 201407, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41850, 'August', 'Q2', 201408, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41881, 'September', 'Q2', 201409, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41911, 'October', 'Q3', 201410, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41942, 'November', 'Q3', 201411, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41972, 'December', 'Q3', 201412, 2014)
-- Operation applied to 61 rows out of 61

GO

IF NOT EXISTS(Select * From SourceSystem
		Where SourceSystemId = 1)
		BEGIN
		Insert Into SourceSystem
		(SourceSystemId, [Name])
		VALUES(1, 'Corporate Budgeting')
		END

IF NOT EXISTS(Select * From SourceSystem
		Where SourceSystemId = 2)
		BEGIN
		Insert Into SourceSystem
		(SourceSystemId, [Name])
		VALUES(2, 'Tapas Budgeting')
		END
	
GO



IF NOT EXISTS(sElect * From [Overhead] Where [OverheadCode] = 'UNKNOWN' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[Overhead]
			   ([OverheadKey]
			   ,[OverheadCode]
			   ,[OverheadName])
		 VALUES
			   (-1
			   ,'UNKNOWN'
			   ,'UNKNOWN')
	END
GO
IF NOT EXISTS(sElect * From [Overhead] Where [OverheadCode] = 'ALLOC' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[Overhead]
			   ([OverheadKey]
			   ,[OverheadCode]
			   ,[OverheadName])
		 VALUES
			   (1
			   ,'ALLOC'
			   ,'Allocated')
	END
GO

IF NOT EXISTS(Select * From [Overhead] Where [OverheadCode] = 'UNALLOC' )
	BEGIN
	INSERT INTO [GrReporting].[dbo].[Overhead]
			   ([OverheadKey]
			   ,[OverheadCode]
			   ,[OverheadName])
		 VALUES
			   (2
			   ,'UNALLOC'
			   ,'Unallocated')
	END
GO