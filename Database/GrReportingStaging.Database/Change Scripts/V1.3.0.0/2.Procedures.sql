﻿USE [GrReportingStaging]
GO
/****** Object:  StoredProcedure [dbo].[stp_U_ImportBatch]    Script Date: 05/04/2010 16:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_U_ImportBatch]
	@BatchId INT
AS
	UPDATE 
		Batch
	SET 
	    BatchEndDate = GETDATE()
	WHERE BatchId=@BatchId
GO
/****** Object:  StoredProcedure [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]    Script Date: 05/04/2010 16:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_J_UpdateSSISConfigurationsImportWindow]
	@JobName varchar(500),
	@SucessfulStepCount int
AS

DECLARE @JobId uniqueidentifier

SELECT
	@JobId = j.job_id
FROM
	msdb.dbo.sysjobhistory h
	
	INNER JOIN msdb.dbo.sysjobs j ON
		h.job_id = j.job_id
WHERE
	j.name 	= @JobName AND
	h.run_status = 4 AND -- In Progress
	h.run_date = CONVERT(varchar, getdate(), 112)
	
IF @JobId IS NOT NULL
BEGIN
	
	DECLARE @SucessfulSteps int
	SELECT
		@SucessfulSteps = COUNT(*)
	FROM
		msdb.dbo.sysjobsteps 
	WHERE 
		job_id = @JobId AND
		last_run_outcome = 1 -- Succeeded
	
	DECLARE @StopDate datetime,
			@NewStartDate datetime,
			@Yesterday datetime
			
	-- Only updates the imports dates if all steps have run sucesfully		
	IF @SucessfulSteps = @SucessfulStepCount
	BEGIN
			
		SELECT
			@StopDate = CONVERT(datetime, [ConfiguredValue])
		FROM
			[GrReportingStaging].[dbo].[SSISConfigurations]
		WHERE
			[ConfigurationFilter] = 'ImportEndDate'
			
		SET @NewStartDate = DATEADD(DAY, 1, @StopDate)
		SET @Yesterday = DATEADD(day, -1, getdate())
		
		-- Sets the ImportStartDate to one day after the last import end date
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT('00' + DATENAME(DAY,@NewStartDate),2) + ' ' + -- two digit day value
								LEFT(CONVERT(varchar, @NewStartDate),3) + ' ' + -- Abbreviated month description
								DATENAME(YEAR,@NewStartDate)
		WHERE
			[ConfigurationFilter] = 'ImportStartDate'
			
		
		-- Sets the ImportEndDate and DataPriorToDate to yesterday	
		UPDATE [GrReportingStaging].[dbo].[SSISConfigurations]
		SET
			[ConfiguredValue] = RIGHT('00' + DATENAME(DAY,@Yesterday),2) + ' ' + -- two digit day value
								LEFT(CONVERT(varchar, @Yesterday),3) + ' ' + -- Abbreviated month description
								DATENAME(YEAR,@Yesterday)
		WHERE
			[ConfigurationFilter] = 'ImportEndDate' OR 
			[ConfigurationFilter] = 'DataPriorToDate'
	END
		
		
		
END
GO
/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 05/04/2010 16:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_I_ImportBatch]
	@PackageName		VARCHAR(100)
AS
	DECLARE @ImportStartDate DateTime
	DECLARE @ImportEndDate DateTime
	DECLARE @DataPriorToDate DateTime
	
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ImportStartDate')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ImportEndDate')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'DataPriorToDate')
	
	INSERT INTO Batch
	(
		PackageName,
		BatchStartDate,
		ImportStartDate,
		ImportEndDate,
		DataPriorToDate
	)
	VALUES
	(
		@PackageName,	/* PackageName	*/
		GetDate(),
		@ImportStartDate,
		@ImportEndDate,
		@DataPriorToDate
	)
	
	SELECT SCOPE_IDENTITY() AS BatchId
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 05/04/2010 16:52:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()
	
SET NOCOUNT OFF
PRINT '####'
PRINT 'stp_IU_LoadExchangeRates'
PRINT '####'

--Generate temp table to prevent repeated function calls

CREATE TABLE #BudgetProjectActive
(
	ImportKey INT
)
INSERT INTO #BudgetProjectActive
SELECT * FROM TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate)


CREATE TABLE #BudgetReportGroupActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupActive
SELECT * FROM TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate)
 
CREATE TABLE #BudgetReportGroupDetailActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupDetailActive
SELECT * FROM TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate)
 
CREATE TABLE #BudgetActive
(
	ImportKey INT
)
INSERT INTO #BudgetActive
SELECT * FROM TapasGlobalBudgeting.BudgetActive(@DataPriorToDate)

CREATE TABLE #ExchangeRateActive
(
	ImportKey INT
)
INSERT INTO #ExchangeRateActive
SELECT * FROM TapasGlobalBudgeting.ExchangeRateActive(@DataPriorToDate)

CREATE TABLE #ExchangeRateDetailActive
(
	ImportKey INT
)
INSERT INTO #ExchangeRateDetailActive
SELECT * FROM TapasGlobalBudgeting.ExchangeRateDetailActive(@DataPriorToDate)

CREATE TABLE #BudgetStatusActive
(
	ImportKey INT
)
INSERT INTO #BudgetStatusActive
SELECT * FROM TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate)

CREATE TABLE #GRBudgetReportGroupPeriodActive
(
	ImportKey INT
)
INSERT INTO #GRBudgetReportGroupPeriodActive
SELECT * FROM TapasGlobalBudgeting.GRBudgetReportGroupPeriodActive(@DataPriorToDate)

--Get all budget report groups which have been modified
DECLARE @UpdatedBudgetReportGroupIds  TABLE 
        (BudgetReportGroupId INT)

INSERT INTO @UpdatedBudgetReportGroupIds
SELECT 
	DISTINCT brg.BudgetReportGroupId
FROM
	TapasGlobalBudgeting.ExchangeRateDetail erd
    INNER JOIN TapasGlobalBudgeting.ExchangeRate er ON  
		er.ExchangeRateId = erd.ExchangeRateId
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.ExchangeRateId = er.ExchangeRateId
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON  
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    INNER JOIN TapasGlobalBudgeting.Budget b ON  
		b.BudgetId = brgd.BudgetId
    INNER JOIN TapasGlobalBudgeting.BudgetStatus bs ON  
		bs.BudgetStatusId = b.BudgetStatusId
WHERE  
	(
		(erd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(er.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brg.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(b.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate)
	) AND
	er.IsDeleted = 0
	  

--Filter items that are deleted or not global
DECLARE @FirstFilterBudgetReportGroupIds TABLE 
        (BudgetReportGroupId INT)

INSERT INTO @FirstFilterBudgetReportGroupIds
SELECT 
	brg.BudgetReportGroupId
FROM
	@UpdatedBudgetReportGroupIds ubrgi
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetReportGroupId = ubrgi.BudgetReportGroupId
    INNER JOIN #BudgetReportGroupActive bprga ON  
		bprga.ImportKey = brg.ImportKey
	INNER JOIN TapasGlobalBudgeting.GRBudgetReportGroupPeriod grgp ON 
		grgp.BudgetReportGroupId = ubrgi.BudgetReportGroupId
	INNER JOIN #GRBudgetReportGroupPeriodActive grbrgpa ON 
		grbrgpa.ImportKey = grgp.ImportKey
WHERE  
	brg.IsDeleted = 0 AND
	grgp.IsDeleted = 0

--Get the budgets that are locked

CREATE TABLE #FilteredBudgetGroups 
(
    BudgetReportGroupId INT,
    StartPeriod INT,
    EndPeriod INT,
    FirstProjectedPeriod INT,
	ExchangeRateId INT
)

INSERT INTO #FilteredBudgetGroups
SELECT 
	brg.BudgetReportGroupId,
    MAX(brg.StartPeriod),
    MAX(brg.EndPeriod),
    MAX(brg.FirstProjectedPeriod),
    MAX(brg.ExchangeRateId)
FROM
	@FirstFilterBudgetReportGroupIds ffbrgi
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetReportGroupId = ffbrgi.BudgetReportGroupId
    INNER JOIN #BudgetReportGroupActive brga ON  
		brga.ImportKey = brg.ImportKey
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON  
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId AND 
		brgd.IsDeleted = 0
    INNER JOIN #BudgetReportGroupDetailActive brgda ON  
		brgda.ImportKey = brgd.ImportKey
    INNER JOIN TapasGlobalBudgeting.Budget b ON  
		b.BudgetId = brgd.BudgetId AND 
		b.IsDeleted = 0
	INNER JOIN #BudgetActive ba ON  
		ba.ImportKey = b.ImportKey
    INNER JOIN TapasGlobalBudgeting.BudgetStatus bs ON  
		b.BudgetStatusId = bs.BudgetStatusId
	INNER JOIN #BudgetStatusActive bsa ON 
		bsa.ImportKey = bs.ImportKey
GROUP BY
    brg.BudgetReportGroupId
HAVING  COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) 

--Get only the latest budgets
CREATE TABLE #LatestBudgetGroups 
(
	BudgetReportGroupId INT,
    StartPeriod INT,
    EndPeriod INT,
    ExchangeRateId INT
)
        
--Number the budgetgroups with no first projected date
UPDATE #FilteredBudgetGroups
SET FirstProjectedPeriod = NumberedRows.RowNumber
FROM
(
	SELECT BudgetReportGroupId, StartPeriod, EndPeriod, ExchangeRateId, ROW_NUMBER() OVER (ORDER BY ExchangeRateId) AS RowNumber
	FROM #FilteredBudgetGroups
) NumberedRows
INNER JOIN #FilteredBudgetGroups lbg ON
	NumberedRows.BudgetReportGroupId = lbg.BudgetReportGroupId AND
	NumberedRows.StartPeriod = lbg.StartPeriod AND
	NumberedRows.EndPeriod = lbg.EndPeriod AND
	NumberedRows.ExchangeRateId = lbg.ExchangeRateId
WHERE FirstProjectedPeriod IS NULL

;with FilteredBudgetGroupsRank as
(
    SELECT  
		fbg.BudgetReportGroupId,
		fbg.StartPeriod,
		fbg.EndPeriod,
		fbg.FirstProjectedPeriod,
		fbg.ExchangeRateId,
        RANK() OVER (PARTITION BY fbg.StartPeriod, fbg.EndPeriod ORDER BY fbg.FirstProjectedPeriod DESC) AS GroupRank
    FROM #FilteredBudgetGroups fbg
)
INSERT INTO #LatestBudgetGroups
SELECT DISTINCT
	fbgr.BudgetReportGroupId,
	fbgr.StartPeriod,
	fbgr.EndPeriod,
	fbgr.ExchangeRateId
FROM
	FilteredBudgetGroupsRank fbgr
WHERE 
	fbgr.GroupRank <= 1
	
--Get the exchange rate for the given groups
CREATE TABLE #ExchangeRates 
(
	CurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    BudgetReportGroupId INT,
    ExchangeRateId INT,
    ExchangeRateDetailId INT
)

INSERT INTO #ExchangeRates
SELECT 
	erd.CurrencyCode,
    erd.Period,
    erd.Rate,
    lbg.BudgetReportGroupId,
    lbg.ExchangeRateId,
    erd.ExchangeRateDetailId
FROM
	#LatestBudgetGroups lbg
    INNER JOIN TapasGlobalBudgeting.ExchangeRate er ON  
		er.ExchangeRateId = lbg.ExchangeRateId
    INNER JOIN #ExchangeRateActive era ON  
		era.ImportKey = er.ImportKey
    INNER JOIN TapasGlobalBudgeting.ExchangeRateDetail erd ON  
		er.ExchangeRateId = erd.ExchangeRateId
    INNER JOIN #ExchangeRateDetailActive erda ON  
		erda.ImportKey = erd.ImportKey
WHERE  
	erd.Period BETWEEN lbg.StartPeriod AND lbg.EndPeriod
	
--Calculate the cross rates
DECLARE @CrossCurrency TABLE 
(
	SourceCurrencyCode CHAR(3),
    DestinationCurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    SourceReferenceCode VARCHAR(127),
    DestinationReferenceCode VARCHAR(127)
)
        
INSERT INTO @CrossCurrency
SELECT 
	s.CurrencyCode AS SourceCurrencyCode, 
	d.CurrencyCode AS DestinationCurrencyCode,
	es.Period, 
	(ed.Rate / es.Rate) AS Rate,
	'BudgetReportGroupId=' + CAST(es.BudgetReportGroupId AS VARCHAR(50)) +
    '&ExchangeRateId=' + CAST(es.ExchangeRateId AS VARCHAR(50)) +
    '&ExchangeRateDetailId=' + CAST(es.ExchangeRateDetailId AS VARCHAR(50)) AS 
    SourceReferenceCode,
    'BudgetReportGroupId=' + CAST(ed.BudgetReportGroupId AS VARCHAR(50)) +
    '&ExchangeRateId=' + CAST(ed.ExchangeRateId AS VARCHAR(50)) +
    '&ExchangeRateDetailId=' + CAST(ed.ExchangeRateDetailId AS VARCHAR(50)) AS 
    DestinationReferenceCode
FROM
	GrReporting.dbo.Currency s
    CROSS JOIN GrReporting.dbo.Currency d
    INNER JOIN #ExchangeRates es ON es.CurrencyCode = s.CurrencyCode
    INNER JOIN #ExchangeRates ed ON ed.CurrencyCode = d.CurrencyCode
WHERE  
	s.CurrencyCode <> 'UNK' AND 
	d.CurrencyCode <> 'UNK' AND
	es.Period = ed.Period
	
--Build the fact
DECLARE @USDCurrencyKey INT
SELECT 
	@USDCurrencyKey = CurrencyKey
FROM
	GrReporting.dbo.Currency cur
WHERE  
	cur.CurrencyCode = 'USD'
	
IF (@USDCurrencyKey IS NULL)
BEGIN
	SET @USDCurrencyKey = -1
END

CREATE TABLE #FactData 
(
	SourceCurrencyKey INT,
    DestinationCurrencyKey INT,
    CalendarKey INT,
    Rate DECIMAL(18, 12),
    ReferenceCode VARCHAR(255)
)

INSERT INTO #FactData
SELECT 
	 ISNULL(curs.CurrencyKey, -1) AS SourceCurrencyKey,
	 ISNULL(curd.CurrencyKey, -1) AS DestinationCurrencyKey,
	 c.CalendarKey,
	 CASE 
         WHEN cc.Rate IS NULL THEN 0
         ELSE cc.Rate
    END AS Rate,
    ('SRC:' + cc.SourceReferenceCode + ' DST:' + cc.DestinationReferenceCode) AS ReferenceCode
FROM 
	@CrossCurrency cc 
	INNER JOIN GrReporting.dbo.Calendar c ON  
		cc.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency curs ON  
		curs.CurrencyCode = cc.SourceCurrencyCode
	LEFT JOIN GrReporting.dbo.Currency curd ON
		curd.CurrencyCode = cc.DestinationCurrencyCode
		
INSERT INTO #FactData		
SELECT 
	@USDCurrencyKey AS SourceCurrencyKey,
    ISNULL(cur.CurrencyKey, -1) AS DestinationCurrencyKey,
    c.CalendarKey,
    er.Rate,
    'BudgetReportGroupId=' + CAST(er.BudgetReportGroupId AS VARCHAR(50)) +
    '&ExchangeRateId=' + CAST(er.ExchangeRateId AS VARCHAR(50)) +
    '&ExchangeRateDetailId=' + CAST(er.ExchangeRateDetailId AS VARCHAR(50)) AS 
    ReferenceCode
FROM
	#ExchangeRates er
    INNER JOIN GrReporting.dbo.Calendar c ON  
		er.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency cur ON  
		cur.CurrencyCode = er.CurrencyCode
	LEFT JOIN #FactData fd ON 
		fd.SourceCurrencyKey=@USDCurrencyKey AND
		fd.DestinationCurrencyKey=ISNULL(cur.CurrencyKey, -1) AND
		fd.CalendarKey = c.CalendarKey
WHERE fd.Rate IS NULL

INSERT INTO #FactData
SELECT 
	ISNULL(cur.CurrencyKey, -1) AS SourceCurrencyKey,
    @USDCurrencyKey AS DestinationCurrencyKey,
    c.CalendarKey,
    CASE 
         WHEN er.Rate IS NULL THEN 0
         ELSE (1 / er.Rate)
    END AS Rate,
    'BudgetReportGroupId=' + CAST(er.BudgetReportGroupId AS VARCHAR(50)) +
    '&ExchangeRateId=' + CAST(er.ExchangeRateId AS VARCHAR(50)) +
    '&ExchangeRateDetailId=' + CAST(er.ExchangeRateDetailId AS VARCHAR(50)) AS 
    ReferenceCode
FROM
	#ExchangeRates er
    INNER JOIN GrReporting.dbo.Calendar c ON  
		er.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency cur ON  
		cur.CurrencyCode = er.CurrencyCode
	LEFT JOIN #FactData fd ON 
		fd.SourceCurrencyKey=ISNULL(cur.CurrencyKey, -1) AND
		fd.DestinationCurrencyKey=@USDCurrencyKey AND
		fd.CalendarKey = c.CalendarKey
WHERE fd.Rate IS NULL

IF ((SELECT COUNT(*) FROM #FactData WHERE SourceCurrencyKey = @USDCurrencyKey AND DestinationCurrencyKey = @USDCurrencyKey)<=0)
BEGIN
	INSERT INTO #FactData
	SELECT DISTINCT
		@USDCurrencyKey AS SourceCurrencyKey,
		@USDCurrencyKey AS DestinationCurrencyKey,
		c.CalendarKey,
		1 AS Rate,
		'Default' AS ReferenceCode
	FROM
		#ExchangeRates er
		INNER JOIN GrReporting.dbo.Calendar c ON  
			er.Period = c.CalendarPeriod
		LEFT JOIN #FactData fd ON 
			fd.SourceCurrencyKey=@USDCurrencyKey AND
			fd.DestinationCurrencyKey=@USDCurrencyKey AND
			fd.CalendarKey = c.CalendarKey
	WHERE fd.Rate IS NULL
END

--Update the star schema
MERGE GrReporting.dbo.ExchangeRate AS d
USING #FactData AS s ON  
	d.SourceCurrencyKey = s.SourceCurrencyKey AND 
	d.DestinationCurrencyKey = s.DestinationCurrencyKey AND 
	d.CalendarKey = s.CalendarKey
WHEN MATCHED
THEN
	UPDATE
	SET 
		d.Rate = s.Rate,
		d.ReferenceCode = s.ReferenceCode
WHEN NOT MATCHED
THEN
	INSERT 
	VALUES
	  (
		s.SourceCurrencyKey,
		s.DestinationCurrencyKey,
		s.CalendarKey,
		s.Rate,
		s.ReferenceCode
	  );

DROP TABLE #FilteredBudgetGroups
DROP TABLE #LatestBudgetGroups
DROP TABLE #ExchangeRates
DROP TABLE #FactData

DROP TABLE #BudgetProjectActive
DROP TABLE #BudgetReportGroupActive 
DROP TABLE #BudgetReportGroupDetailActive 
DROP TABLE #BudgetActive
DROP TABLE #ExchangeRateActive
DROP TABLE #ExchangeRateDetailActive
DROP TABLE #BudgetStatusActive
DROP TABLE #GRBudgetReportGroupPeriodActive
  
print 'Rows inserted/updated: '+CONVERT(char(10),@@rowcount)
GO
/****** Object:  StoredProcedure dbo.ClearSessionSnapshot    Script Date: 08/21/2009 10:24:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_IU_LoadGrProfitabiltyOverhead') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_IU_LoadGrProfitabiltyOverhead
GO

CREATE PROCEDURE dbo.stp_IU_LoadGrProfitabiltyOverhead
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()


DECLARE 
		@GlAccountKey				Int,
		@OverheadGlAccountKey		Int,
		@FunctionalDepartmentKey	Int,
		@ReimbursableKey			Int,
		@ActivityTypeKey			Int,
		@SourceKey				Int,
		@OriginatingRegionKey		Int,
		@AllocationRegionKey		Int,
		@PropertyFundKey			Int,
      --@CurrencyKey				Int,
		@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int
            
--Default FK for the Fact table
/*
[stp_IU_LoadGrProfitabiltyOverheadVer2]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/       
SET @GlAccountKey				= (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN')
SET @OverheadGlAccountKey		= (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = '5002950000  ')
SET @FunctionalDepartmentKey	= (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKey			= (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKey			= (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN')
SET @SourceKey					= (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN')
SET @OriginatingRegionKey		= (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN')
SET @AllocationRegionKey		= (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN')
SET @PropertyFundKey			= (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey				= (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNK')

SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Development' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Global' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')

	
PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyOverhead'
PRINT '####'
SET NOCOUNT ON
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Create the temp tables used on the "active" records for optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #BillingUpload(
	ImportKey int  NOT NULL,
	BillingUploadId int NOT NULL,
	BillingUploadBatchId int NULL,
	BillingUploadTypeId int NOT NULL,
	TimeAllocationId int NOT NULL,
	CostTypeId int NOT NULL,
	RegionId int NOT NULL,
	ExternalRegionId int NOT NULL,
	ExternalSubRegionId int NOT NULL,
	PayrollId int NULL,
	OverheadId int NULL,
	PayGroupId int NULL,
	UnionCodeId int NULL,
	OverheadRegionId int NULL,
	HREmployeeId int NOT NULL,
	ProjectId int NOT NULL,
	SubDepartmentId int NOT NULL,
	ExpensePeriod int NOT NULL,
	PayrollDescription nvarchar(100) NULL,
	OverheadDescription nvarchar(100) NULL,
	ProjectCode varchar(50) NOT NULL,
	ReversalPeriod int NULL,
	AllocationPeriod int NOT NULL,
	AllocationValue decimal(18, 9) NOT NULL,
	IsReversable bit NOT NULL,
	IsReversed bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL,
	HasNoInactiveProjects bit NOT NULL,
	LocationId int NOT NULL,
	ProjectGroupAllocationAdjustmentId int NULL,
	AdjustedTimeAllocationDetailId int NULL,
	PayrollPayDate datetime NULL,
	PayrollFromDate datetime NULL,
	PayrollToDate datetime NULL,
	FunctionalDepartmentId int NOT NULL,
	ActivityTypeId int NOT NULL,
	OverheadFunctionalDepartmentId int NULL,
)

CREATE TABLE #BillingUploadDetail(
	ImportKey int NOT NULL,
	BillingUploadDetailId int NOT NULL,
	BillingUploadBatchId int NOT NULL,
	BillingUploadId int NOT NULL,
	BillingUploadDetailTypeId int NOT NULL,
	ExpenseTypeId int NULL,
	GLAccountCode varchar(15) NOT NULL,
	CorporateEntityRef varchar(6) NULL,
	CorporateDepartmentCode varchar(8) NOT NULL,
	CorporateDepartmentIsRechargedToAr bit NOT NULL,
	CorporateSourceCode varchar(2) NOT NULL,
	AllocationAmount decimal(18, 9) NOT NULL,
	CurrencyCode char(3) NOT NULL,
	IsUnion bit NOT NULL,
	UpdatedByStaffId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	CorporateDepartmentIsRechargedToAp bit NOT NULL
)

CREATE TABLE #Overhead(
	ImportKey int NOT NULL,
	OverheadId int NOT NULL,
	RegionId int NOT NULL,
	ExpensePeriod int NOT NULL,
	AllocationStartPeriod int NOT NULL,
	AllocationEndPeriod int NULL,
	Description nvarchar(60) NOT NULL,
	InsertedDate datetime NOT NULL,
	InsertedByStaffId int NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL,
	InvoiceNumber varchar(13) NULL
)

CREATE TABLE #FunctionalDepartment(
	ImportKey int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	Name varchar(50) NOT NULL,
	Code varchar(20) NOT NULL,
	IsActive bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	GlobalCode char(3) NULL
)

CREATE TABLE #Project(
	ImportKey int NOT NULL,
	ProjectId int NOT NULL,
	RegionId int NOT NULL,
	ActivityTypeId int NOT NULL,
	ProjectOwnerId int NULL,
	CorporateDepartmentCode varchar(8) NOT NULL,
	CorporateSourceCode char(2) NOT NULL,
	Code varchar(50) NOT NULL,
	Name varchar(100) NOT NULL,
	StartPeriod int NOT NULL,
	EndPeriod int NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL,
	PropertyOverheadGLAccountCode varchar(15) NULL,
	PropertyOverheadDepartmentCode varchar(6) NULL,
	PropertyOverheadJobCode varchar(15) NULL,
	PropertyOverheadSourceCode char(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode varchar(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode varchar(6) NULL,
	CorporateOverheadIncomeCategoryCode varchar(6) NULL,
	PropertyFundId int NOT NULL,
	MarkUpPercentage decimal(5, 4) NULL,
	HistoricalProjectCode varchar(50) NULL,
	IsTSCost bit NOT NULL,
	CanAllocateOverheads bit NOT NULL,
	AllocateOverheadsProjectId int NULL
)

CREATE TABLE #PropertyFund(
	ImportKey int NOT NULL,
	PropertyFundId int NOT NULL,
	Name varchar(100) NOT NULL,
	RelatedFundId int NULL,
	ProjectRegionId int NOT NULL,
	EntityTypeId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL
)

CREATE TABLE #PropertyFundMapping(
	ImportKey int NOT NULL,
	PropertyFundMappingId int NOT NULL,
	PropertyFundId int NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode varchar(8) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL,
	ActivityTypeId Int NULL
)

CREATE TABLE #ProjectRegion(
	ImportKey int NOT NULL,
	ProjectRegionId int NOT NULL,
	GlobalProjectRegionId int NOT NULL,
	Name varchar(100) NOT NULL,
	Code varchar(6) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

CREATE TABLE #AllocationRegionMapping(
	ImportKey int NOT NULL,
	AllocationRegionMappingId int NOT NULL,
	GlobalRegionId int NOT NULL,
	SourceCode char(2) NOT NULL,
	RegionCode varchar(10) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL
)

CREATE TABLE #OriginatingRegionMapping(
	ImportKey int NOT NULL,
	OriginatingRegionMappingId int NOT NULL,
	GlobalRegionId int NOT NULL,
	SourceCode char(2) NOT NULL,
	RegionCode varchar(10) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL
)

CREATE TABLE #ActivityType(
	ImportKey int NOT NULL,
	ActivityTypeId int NOT NULL,
	ActivityTypeCode varchar(10) NOT NULL,
	Name varchar(50) NOT NULL,
	GLSuffix char(2) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL
)

CREATE TABLE #OverheadRegion(
	ImportKey int NOT NULL,
	OverheadRegionId int NOT NULL,
	RegionId int NOT NULL,
	CorporateEntityRef varchar(6) NULL,
	CorporateSourceCode varchar(2) NULL,
	Name varchar(50) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)


CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

--Insert / Update / Delete the records in the bridge table :: ProfitabilityActualGlAccountCategoryBridge
CREATE TABLE #GlobalGlAccountCategoryHierarchy
(
	GlobalGlAccountCategoryHierarchyId int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	GlobalGlAccountId int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL,
	AccountType varchar(50) NOT NULL
)

INSERT INTO #BillingUpload
(ImportKey,BillingUploadId,BillingUploadBatchId,BillingUploadTypeId,TimeAllocationId
,CostTypeId,RegionId,ExternalRegionId,ExternalSubRegionId,PayrollId,OverheadId
,PayGroupId,UnionCodeId,OverheadRegionId,HREmployeeId,ProjectId,SubDepartmentId
,ExpensePeriod,PayrollDescription,OverheadDescription,ProjectCode
,ReversalPeriod,AllocationPeriod
,AllocationValue,IsReversable,IsReversed,InsertedDate,UpdatedDate,UpdatedByStaffId
,HasNoInactiveProjects,LocationId,ProjectGroupAllocationAdjustmentId,AdjustedTimeAllocationDetailId
,PayrollPayDate,PayrollFromDate,PayrollToDate,FunctionalDepartmentId
,ActivityTypeId,OverheadFunctionalDepartmentId)
Select 
		Bu.ImportKey,Bu.BillingUploadId,Bu.BillingUploadBatchId,Bu.BillingUploadTypeId,Bu.TimeAllocationId
		,Bu.CostTypeId,Bu.RegionId,Bu.ExternalRegionId,Bu.ExternalSubRegionId,Bu.PayrollId,Bu.OverheadId
		,Bu.PayGroupId,Bu.UnionCodeId,Bu.OverheadRegionId,Bu.HREmployeeId,Bu.ProjectId,Bu.SubDepartmentId
		,Bu.ExpensePeriod,Bu.PayrollDescription,Bu.OverheadDescription,Bu.ProjectCode,Bu.ReversalPeriod,Bu.AllocationPeriod
		,Bu.AllocationValue,Bu.IsReversable,Bu.IsReversed,Bu.InsertedDate,Bu.UpdatedDate,Bu.UpdatedByStaffId
		,Bu.HasNoInactiveProjects,Bu.LocationId,Bu.ProjectGroupAllocationAdjustmentId,Bu.AdjustedTimeAllocationDetailId
		,Bu.PayrollPayDate,Bu.PayrollFromDate,Bu.PayrollToDate,Bu.FunctionalDepartmentId
		,Bu.ActivityTypeId,Bu.OverheadFunctionalDepartmentId
From TapasGlobal.BillingUpload	Bu
		INNER JOIN TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA ON BuA.ImportKey = Bu.ImportKey


INSERT INTO #BillingUploadDetail
(ImportKey,BillingUploadDetailId,BillingUploadBatchId,BillingUploadId
,BillingUploadDetailTypeId,ExpenseTypeId,GLAccountCode,CorporateEntityRef,CorporateDepartmentCode
,CorporateDepartmentIsRechargedToAr,CorporateSourceCode,AllocationAmount,CurrencyCode
,IsUnion,UpdatedByStaffId,InsertedDate,UpdatedDate,CorporateDepartmentIsRechargedToAp)
Select 
	Bud.ImportKey,Bud.BillingUploadDetailId,Bud.BillingUploadBatchId,Bud.BillingUploadId
	,Bud.BillingUploadDetailTypeId,Bud.ExpenseTypeId,Bud.GLAccountCode,Bud.CorporateEntityRef,Bud.CorporateDepartmentCode
	,Bud.CorporateDepartmentIsRechargedToAr,Bud.CorporateSourceCode,Bud.AllocationAmount,Bud.CurrencyCode
	,Bud.IsUnion,Bud.UpdatedByStaffId,Bud.InsertedDate,Bud.UpdatedDate,Bud.CorporateDepartmentIsRechargedToAp
From  TapasGlobal.BillingUploadDetail Bud
		INNER JOIN TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA ON BudA.ImportKey = Bud.ImportKey

INSERT INTO #Overhead
(ImportKey,OverheadId,RegionId,ExpensePeriod,AllocationStartPeriod
,AllocationEndPeriod,Description,InsertedDate,InsertedByStaffId,UpdatedDate
,UpdatedByStaffId,InvoiceNumber)
Select 
	 Oh.ImportKey,Oh.OverheadId,Oh.RegionId,Oh.ExpensePeriod,Oh.AllocationStartPeriod
	,Oh.AllocationEndPeriod,Oh.Description,Oh.InsertedDate,Oh.InsertedByStaffId,Oh.UpdatedDate
	,Oh.UpdatedByStaffId,Oh.InvoiceNumber
From TapasGlobal.Overhead Oh 
		INNER JOIN TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON OhA.ImportKey = Oh.ImportKey


INSERT INTO #FunctionalDepartment
(ImportKey,FunctionalDepartmentId,Name,Code,IsActive,InsertedDate,UpdatedDate,GlobalCode)
Select Fd.ImportKey,Fd.FunctionalDepartmentId,Fd.Name,Fd.Code,Fd.IsActive,Fd.InsertedDate,Fd.UpdatedDate,Fd.GlobalCode
From HR.FunctionalDepartment Fd 
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey

INSERT INTO #Project
(ImportKey,ProjectId,RegionId,ActivityTypeId,ProjectOwnerId,CorporateDepartmentCode
,CorporateSourceCode,Code,Name,StartPeriod,EndPeriod,InsertedDate,UpdatedDate,UpdatedByStaffId
,PropertyOverheadGLAccountCode,PropertyOverheadDepartmentCode,PropertyOverheadJobCode,PropertyOverheadSourceCode
,CorporateUnionPayrollIncomeCategoryCode,CorporateNonUnionPayrollIncomeCategoryCode
,CorporateOverheadIncomeCategoryCode,PropertyFundId,MarkUpPercentage,HistoricalProjectCode
,IsTSCost,CanAllocateOverheads,AllocateOverheadsProjectId)
Select 
		P2.ImportKey,P2.ProjectId,P2.RegionId,P2.ActivityTypeId,P2.ProjectOwnerId,P2.CorporateDepartmentCode
           ,P2.CorporateSourceCode,P2.Code,P2.Name,P2.StartPeriod,P2.EndPeriod,P2.InsertedDate,P2.UpdatedDate,P2.UpdatedByStaffId
           ,P2.PropertyOverheadGLAccountCode,P2.PropertyOverheadDepartmentCode,P2.PropertyOverheadJobCode,P2.PropertyOverheadSourceCode
           ,P2.CorporateUnionPayrollIncomeCategoryCode,P2.CorporateNonUnionPayrollIncomeCategoryCode
           ,P2.CorporateOverheadIncomeCategoryCode,P2.PropertyFundId,P2.MarkUpPercentage,P2.HistoricalProjectCode
           ,P2.IsTSCost,P2.CanAllocateOverheads,P2.AllocateOverheadsProjectId
From TapasGlobal.Project P2
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) P2A ON P2A.ImportKey = P2.ImportKey

		
INSERT INTO #PropertyFund
(ImportKey,PropertyFundId,Name,RelatedFundId,ProjectRegionId,EntityTypeId,InsertedDate,UpdatedDate)
Select
	Pf.ImportKey,Pf.PropertyFundId,Pf.Name,Pf.RelatedFundId,Pf.ProjectRegionId,Pf.EntityTypeId,Pf.InsertedDate,Pf.UpdatedDate
From	Gdm.PropertyFund Pf 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PfA ON PfA.ImportKey = Pf.ImportKey


Insert Into #PropertyFundMapping
(ImportKey, PropertyFundMappingId,PropertyFundId,SourceCode,PropertyFundCode,InsertedDate,UpdatedDate,IsDeleted,ActivityTypeId)
Select Pfm.ImportKey, Pfm.PropertyFundMappingId,Pfm.PropertyFundId,Pfm.SourceCode,Pfm.PropertyFundCode,Pfm.InsertedDate,Pfm.UpdatedDate,Pfm.IsDeleted,Pfm.ActivityTypeId
From Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)


INSERT INTO #ProjectRegion
(ImportKey,ProjectRegionId,GlobalProjectRegionId,Name,Code,InsertedDate,UpdatedDate,UpdatedByStaffId)
Select 
	Pr.ImportKey,Pr.ProjectRegionId,Pr.GlobalProjectRegionId,Pr.Name,Pr.Code,Pr.InsertedDate,Pr.UpdatedDate,Pr.UpdatedByStaffId
From Gdm.ProjectRegion Pr 
	INNER JOIN Gdm.ProjectRegionActive(@DataPriorToDate) PrA ON PrA.ImportKey = Pr.ImportKey

INSERT INTO #AllocationRegionMapping
(ImportKey,AllocationRegionMappingId,GlobalRegionId,SourceCode,RegionCode,InsertedDate,UpdatedDate,IsDeleted)
Select 
	Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,IsDeleted
From Gdm.AllocationRegionMapping Arm 
		INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

Insert Into #OriginatingRegionMapping
(ImportKey,OriginatingRegionMappingId,GlobalRegionId,SourceCode,RegionCode,InsertedDate,UpdatedDate,IsDeleted)
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId)

INSERT INTO #ActivityType
(ImportKey,ActivityTypeId,ActivityTypeCode,Name,GLSuffix,InsertedDate,UpdatedDate)
Select 
	At.ImportKey,At.ActivityTypeId,At.ActivityTypeCode,At.Name,At.GLSuffix,At.InsertedDate,At.UpdatedDate
From	Gdm.ActivityType At 
		INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) AtA ON AtA.ImportKey = At.ImportKey

INSERT INTO #OverheadRegion
(ImportKey,OverheadRegionId,RegionId,CorporateEntityRef,CorporateSourceCode,Name,InsertedDate,UpdatedDate,UpdatedByStaffId)
Select
	Ovr.ImportKey,Ovr.OverheadRegionId,Ovr.RegionId,Ovr.CorporateEntityRef,Ovr.CorporateSourceCode,Ovr.Name,Ovr.InsertedDate,Ovr.UpdatedDate,Ovr.UpdatedByStaffId
From	TapasGlobal.OverheadRegion Ovr 
		INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON OvrA.ImportKey = Ovr.ImportKey


INSERT INTO #GlobalGlAccountCategoryHierarchy
(GlobalGlAccountCategoryHierarchyId,GlobalGlAccountCategoryHierarchyGroupId,GlobalGlAccountId,
MajorGlAccountCategoryId,MinorGlAccountCategoryId,InsertedDate,UpdatedDate,IsDeleted,AccountType)
Select GlH.GlobalGlAccountCategoryHierarchyId,GlH.GlobalGlAccountCategoryHierarchyGroupId,GlH.GlobalGlAccountId,
		GlH.MajorGlAccountCategoryId,GlH.MinorGlAccountCategoryId,GlH.InsertedDate,GlH.UpdatedDate,GlH.IsDeleted,GlH.AccountType
From Gdm.GlobalGlAccountCategoryHierarchy GlH
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHa ON GlHa.ImportKey = GlH.ImportKey


INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey

PRINT 'Completed inserting Active records into temp table'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Now use the temp tables and load the #ProfitabilityOverhead
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityOverhead(
	BillingUploadDetailId int NOT NULL,
	CorporateDepartmentCode varchar(8)  NULL,
	CorporateSourceCode varchar(2)  NULL,
	CanAllocateOverheads Bit NOT NULL,
	ExpensePeriod int NOT NULL,
	AllocationRegionCode varchar(6) NULL,
	OriginatingRegionCode varchar(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	PropertyFundId int NOT NULL,
	FunctionalDepartmentCode char(3) NULL,
	ActivityTypeCode varchar(10) NULL,
	ExpenseType varchar(8) NOT NULL,
	LocalCurrency char(3) NOT NULL,
	LocalActual Decimal(18,12) NOT NULL,
	UpdatedDate datetime NOT NULL,
	InsertedDate datetime NOT NULL
)
Insert Into #ProfitabilityOverhead
(	BillingUploadDetailId,CorporateDepartmentCode,CorporateSourceCode,CanAllocateOverheads, ExpensePeriod,AllocationRegionCode,OriginatingRegionCode,
	OriginatingRegionSourceCode,PropertyFundId,FunctionalDepartmentCode,ActivityTypeCode,ExpenseType,LocalCurrency,
	LocalActual,UpdatedDate,InsertedDate
)
Select 
	Bud.BillingUploadDetailId,
	CASE WHEN P1.AllocateOverheadsProjectId IS NULL THEN Bud.CorporateDepartmentCode ELSE P2.CorporateDepartmentCode END CorporateDepartmentCode,
	Bud.CorporateSourceCode,
	CASE WHEN P1.AllocateOverheadsProjectId IS NULL THEN P1.CanAllocateOverheads ELSE P2.CanAllocateOverheads END CanAllocateOverheads,
	Bu.ExpensePeriod,
	Pr.Code AllocationRegionCode,
	Ovr.CorporateEntityRef OriginatingRegionCode,
	Ovr.CorporateSourceCode OriginatingRegionSourceCode,
	CASE WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
		IsNull(DepartmentPropertyFund.PropertyFundId, -1)
	ELSE 
		IsNull(OverheadPropertyFund.PropertyFundId, -1)
	END as PropertyFundId, --This is seen as the Gdm.Gr.GlobalPropertyFundId
	Fd.GlobalCode FunctionalDepartmentCode,
	At.ActivityTypeCode,
	'Overhead' ExpenseType,
	Bud.CurrencyCode ForeignCurrency,
	Bud.AllocationAmount ForeignActual,
	Bud.UpdatedDate,
	Bud.InsertedDate

From 
		#BillingUpload Bu
		
		INNER JOIN #BillingUploadDetail Bud ON Bud.BillingUploadId = Bu.BillingUploadId

		INNER JOIN #Overhead Oh ON Oh.OverheadId = Bu.OverheadId

		LEFT OUTER JOIN #FunctionalDepartment Fd ON Fd.FunctionalDepartmentId = Bu.OverheadFunctionalDepartmentId

		LEFT OUTER JOIN #Project P1 ON P1.ProjectId = Bu.ProjectId

		LEFT OUTER JOIN #Project P2 ON P2.ProjectId = P1.AllocateOverheadsProjectId

		LEFT OUTER JOIN GrReporting.dbo.Source GrScC ON GrScC.SourceCode = P1.CorporateSourceCode

		LEFT OUTER JOIN #PropertyFundMapping pfm ON
			P1.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
			P1.CorporateSourceCode = pfm.SourceCode AND
			pfm.IsDeleted = 0 AND 
			(
			(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
			(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
			OR
			(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
			)
			)
			
		LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
			pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

		LEFT OUTER JOIN GrReporting.dbo.Source GrScO ON GrScO.SourceCode = P2.CorporateSourceCode

		LEFT OUTER JOIN #PropertyFundMapping opfm ON
			P2.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
			P2.CorporateSourceCode = opfm.SourceCode AND
			opfm.IsDeleted = 0  AND 
			(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
			(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = Bu.ActivityTypeId)
			OR
			(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL) 
			)	
			)
			

		LEFT OUTER JOIN #PropertyFund OverheadPropertyFund ON
			opfm.PropertyFundId = OverheadPropertyFund.PropertyFundId

		LEFT OUTER JOIN #ProjectRegion Pr ON Pr.ProjectRegionId = (
								-- Same logic as above
								CASE WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
									IsNull(DepartmentPropertyFund.ProjectRegionId, -1) 
								ELSE 
									IsNull(OverheadPropertyFund.ProjectRegionId, -1) 
								END
							)

		LEFT OUTER JOIN #AllocationRegionMapping Arm ON Arm.RegionCode = Pr.Code
								AND Arm.IsDeleted = 0

		LEFT OUTER JOIN #ActivityType At ON At.ActivityTypeId = Bu.ActivityTypeId

		LEFT OUTER JOIN #OverheadRegion Ovr ON Ovr.OverheadRegionId = Bu.OverheadRegionId

--NOTE:: GC I am note sure it can work with the date filter
Where	--ISNULL(Bu.UpdatedDate, Bu.UpdatedDate) BETWEEN @ImportStartDate AND @ImportEndDate
Bu.BillingUploadBatchId IS NOT NULL 
AND Bud.BillingUploadDetailTypeId <> 2 

--IMS 48953 - Exclude overhead mark up from the import

PRINT 'Rows Inserted into #ProfitabilityOverhead:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityActual(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	AllocationRegionKey int NOT NULL,
	PropertyFundKey int NOT NULL,
	ReferenceCode Varchar(100) NOT NULL,
	LocalCurrencyKey Int NOT NULL,
	LocalActual money NOT NULL,
	ProfitabilityActualSourceTableId Int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

Insert Into #ProfitabilityActual
           (CalendarKey
           ,GlAccountKey
           ,SourceKey
           ,FunctionalDepartmentKey
           ,ReimbursableKey
           ,ActivityTypeKey
           ,OriginatingRegionKey
           ,AllocationRegionKey
           ,PropertyFundKey
           ,ReferenceCode
           ,LocalCurrencyKey
           ,LocalActual
           ,ProfitabilityActualSourceTableId)

SELECT 
		DATEDIFF(dd, '1900-01-01', LEFT(Gl.ExpensePeriod,4)+'-'+RIGHT(Gl.ExpensePeriod,2)+'-01') CalendarKey
		,ISNULL(@OverheadGlAccountKey, @GlAccountKey) GlAccountKey
		,CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKey ELSE GrSc.SourceKey END SourceKey
		,CASE WHEN GrFdm.FunctionalDepartmentKey IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.FunctionalDepartmentKey END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKey ELSE GrAt.ActivityTypeKey END ActivityTypeKey
		,CASE WHEN GrOr.OriginatingRegionKey IS NULL THEN @OriginatingRegionKey ELSE GrOr.OriginatingRegionKey END OriginatingRegionKey
		,CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKey ELSE GrAr.AllocationRegionKey END AllocationRegionKey
		,CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKey ELSE GrPf.PropertyFundKey END PropertyFundKey
		,'BillingUploadDetailId='+LTRIM(STR(Gl.BillingUploadDetailId,10,0))
		,Cu.CurrencyKey
		,Gl.LocalActual,
		3 ProfitabilityActualSourceTableId --BillingUploadDetail


From #ProfitabilityOverhead Gl

		LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON Cu.CurrencyCode = Gl.LocalCurrency

		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm 
			ON GrFdm.FunctionalDepartmentCode = Gl.FunctionalDepartmentCode 
			AND GrFdm.SubFunctionalDepartmentCode = Gl.FunctionalDepartmentCode 
			AND Gl.UpdatedDate  BETWEEN GrFdm.StartDate AND ISNULL(GrFdm.EndDate, Gl.UpdatedDate)
	
		LEFT OUTER JOIN #ActivityType At 
			ON At.ActivityTypeCode = Gl.ActivityTypeCode 
			
		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt 
			ON GrAt.ActivityTypeId = At.ActivityTypeId
			AND Gl.UpdatedDate  BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate)
		
		LEFT OUTER JOIN GrReporting.dbo.Source GrSc 
			ON GrSc.SourceCode = Gl.CorporateSourceCode
		
		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf 
			ON GrPf.PropertyFundId = Gl.PropertyFundId
			AND Gl.UpdatedDate  BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate)

		LEFT OUTER JOIN #OriginatingRegionMapping Orm 
			ON Orm.RegionCode = Gl.OriginatingRegionCode 
			AND Orm.SourceCode = Gl.CorporateSourceCode
			AND Orm.IsDeleted = 0
			
		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr 
			ON GrOr.GlobalRegionId = Orm.GlobalRegionId
			AND Gl.UpdatedDate  BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate)
		
		LEFT OUTER JOIN #PropertyFund Pf 
			ON Pf.PropertyFundId = Gl.PropertyFundId
			
		LEFT OUTER JOIN #ProjectRegion Pr 
			ON Pr.ProjectRegionId = Pf.ProjectRegionId	
				
		LEFT OUTER JOIN #AllocationRegionMapping Arm 
			ON Arm.RegionCode = Pr.Code
			AND Arm.IsDeleted = 0
			
		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr 
			ON GrAr.GlobalRegionId = Arm.GlobalRegionId
			AND Gl.UpdatedDate  BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate)

		LEFT OUTER JOIN (
						Select 'UC' SOURCECODE, DEPARTMENT, NETTSCOST From USCorp.GDEP UNION ALL
						Select 'EC' SOURCECODE, DEPARTMENT, NETTSCOST From EUCorp.GDEP UNION ALL
						Select 'IC' SOURCECODE, DEPARTMENT, NETTSCOST From INCorp.GDEP UNION ALL
						Select 'BC' SOURCECODE, DEPARTMENT, NETTSCOST From BRCorp.GDEP UNION ALL
						Select 'CC' SOURCECODE, DEPARTMENT, NETTSCOST From CNCorp.GDEP
					) RiCo 
			ON RiCo.DEPARTMENT = Gl.CorporateDepartmentCode 
			AND RiCo.SOURCECODE = Gl.CorporateSourceCode	

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi 
			ON GrRi.ReimbursableCode = CASE WHEN Gl.CanAllocateOverheads = 1 THEN 
											CASE WHEN ISNULL(RiCo.NETTSCOST, 'N') = 'Y' THEN 'NO' ELSE 'YES' END
										ELSE 'NO' END
												

Where	Gl.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate

----Prepare data for later Clean-up of Key's that have changed and 
----as such left the current record to be not required anymore	
--Update GrReporting.dbo.ProfitabilityActual
--SET 	
--Actual						= 0
--Where	SourceKey	IN (Select DISTINCT SourceKey From #ProfitabilityActual)
--AND		CalendarKey	BETWEEN DATEDIFF(dd,'1900-01-01', @ImportStartDate) AND 
--							 DATEDIFF(dd,'1900-01-01', @ImportEndDate)
--Transfer the updated rows
	

--EUCorporateGlAccountCategoryKey
Update #ProfitabilityActual
SET	EUCorporateGlAccountCategoryKey = CASE WHEN GlAcEUCorp.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE GlAcEUCorp.GlAccountCategoryKey END 
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUCorp ON MaGlAcEUCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUCorp ON MiGlAcEUCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate

PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Update #ProfitabilityActual
SET	EUPropertyGlAccountCategoryKey = CASE WHEN GlAcEUProp.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE GlAcEUProp.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUProp ON MaGlAcEUProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUProp ON MiGlAcEUProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Update #ProfitabilityActual
SET EUFundGlAccountCategoryKey = CASE WHEN GlAcEUFund.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE GlAcEUFund.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUFund ON MaGlAcEUFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUFund ON MiGlAcEUFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate
	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Update #ProfitabilityActual
SET	USPropertyGlAccountCategoryKey = CASE WHEN GlAcUSProp.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE GlAcUSProp.GlAccountCategoryKey END
From #ProfitabilityActual Gl
		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSProp ON MaGlAcUSProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSProp ON MiGlAcUSProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
Update #ProfitabilityActual
SET	USCorporateGlAccountCategoryKey = CASE WHEN GlAcUSCorp.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE GlAcUSCorp.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSCorp ON MaGlAcUSCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSCorp ON MiGlAcUSCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Update #ProfitabilityActual
SET	USFundGlAccountCategoryKey = CASE WHEN GlAcUSFund.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE GlAcUSFund.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSFund ON MaGlAcUSFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSFund ON MiGlAcUSFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Update #ProfitabilityActual
SET	GlobalGlAccountCategoryKey = CASE WHEN GlAcGlobal.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE GlAcGlobal.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Global')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcGlobal ON MaGlAcGlobal.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcGlobal ON MiGlAcGlobal.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)




--DevelopmentGlAccountCategoryKey
Update #ProfitabilityActual
SET	DevelopmentGlAccountCategoryKey = CASE WHEN GlAcDevel.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE GlAcDevel.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Development')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcDevel ON MaGlAcDevel.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcDevel ON MiGlAcDevel.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(Varchar(27), getdate(), 121)


	
Update GrReporting.dbo.ProfitabilityActual
SET 	
	CalendarKey					= Pro.CalendarKey,
	GlAccountKey				= Pro.GlAccountKey,
	FunctionalDepartmentKey		= Pro.FunctionalDepartmentKey,
	ReimbursableKey				= Pro.ReimbursableKey,
	ActivityTypeKey				= Pro.ActivityTypeKey,
	OriginatingRegionKey		= Pro.OriginatingRegionKey,
	AllocationRegionKey			= Pro.AllocationRegionKey,
	PropertyFundKey				= Pro.PropertyFundKey,
	LocalCurrencyKey			= Pro.LocalCurrencyKey,
	LocalActual					= Pro.LocalActual,
	ProfitabilityActualSourceTableId	= Pro.ProfitabilityActualSourceTableId,
		
	EUCorporateGlAccountCategoryKey		= Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey		= Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey			= Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey		= Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey		= Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey			= Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey			= Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey		= Pro.DevelopmentGlAccountCategoryKey
From
	#ProfitabilityActual Pro
Where	ProfitabilityActual.SourceKey					= Pro.SourceKey
AND		ProfitabilityActual.ReferenceCode				= Pro.ReferenceCode

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Transfer the new rows
Insert Into GrReporting.dbo.ProfitabilityActual
(CalendarKey,GlAccountKey,FunctionalDepartmentKey,ReimbursableKey,
ActivityTypeKey,SourceKey,OriginatingRegionKey,AllocationRegionKey,PropertyFundKey,
ReferenceCode, LocalCurrencyKey, LocalActual,ProfitabilityActualSourceTableId,
EUCorporateGlAccountCategoryKey,EUPropertyGlAccountCategoryKey,EUFundGlAccountCategoryKey,
USPropertyGlAccountCategoryKey,USCorporateGlAccountCategoryKey,USFundGlAccountCategoryKey,
GlobalGlAccountCategoryKey,DevelopmentGlAccountCategoryKey)

Select
		Pro.CalendarKey,Pro.GlAccountKey,Pro.FunctionalDepartmentKey,Pro.ReimbursableKey,
		Pro.ActivityTypeKey,Pro.SourceKey,Pro.OriginatingRegionKey,Pro.AllocationRegionKey,Pro.PropertyFundKey,
		Pro.ReferenceCode, Pro.LocalCurrencyKey, Pro.LocalActual,
		Pro.ProfitabilityActualSourceTableId, --BillingUploadDetail

		Pro.EUCorporateGlAccountCategoryKey,
		Pro.EUPropertyGlAccountCategoryKey,
		Pro.EUFundGlAccountCategoryKey,

		Pro.USPropertyGlAccountCategoryKey,
		Pro.USCorporateGlAccountCategoryKey,
		Pro.USFundGlAccountCategoryKey,

		Pro.GlobalGlAccountCategoryKey,
		Pro.DevelopmentGlAccountCategoryKey
									
From	#ProfitabilityActual Pro
			LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON 
										ProExists.SourceKey						= Pro.SourceKey
									AND	ProExists.ReferenceCode					= Pro.ReferenceCode
Where ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
--Uploaded BillingUploads should never be deleted ....
--hence we should never have to delete records



DROP TABLE #BillingUpload
DROP TABLE #BillingUploadDetail
DROP TABLE #Overhead
DROP TABLE #FunctionalDepartment
DROP TABLE #Project
DROP TABLE #PropertyFund
DROP TABLE #ProjectRegion
DROP TABLE #AllocationRegionMapping
DROP TABLE #ActivityType
DROP TABLE #OverheadRegion
DROP TABLE #ProfitabilityOverhead
DROP TABLE #ProfitabilityActual
DROP TABLE #GlobalGlAccountCategoryHierarchy
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory
DROP TABLE #PropertyFundMapping
DROP TABLE #OriginatingRegionMapping

GO
/****** Object:  StoredProcedure dbo.ClearSessionSnapshot    Script Date: 08/21/2009 10:24:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_IU_LoadGrProfitabiltyGeneralLedger') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_IU_LoadGrProfitabiltyGeneralLedger
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime
AS

DECLARE 
		@GlAccountKey					Int,
		@GlAccountCategoryKey			Int,
		@FunctionalDepartmentKey		Int,
		@ReimbursableKey				Int,
		@ActivityTypeKey				Int,
		@SourceKey						Int,
		@OriginatingRegionKey			Int,
		@AllocationRegionKey			Int,
		@PropertyFundKey				Int,
		-- @CurrencyKey					Int,
		@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int
      
--Default FK for the Fact table
/*
[stp_IU_LoadGrProfitabiltyGeneralLedgerVer2]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/       
SET @GlAccountKey				= (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN')
SET @FunctionalDepartmentKey	= (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKey			= (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKey			= (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN')
SET @SourceKey					= (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN')
SET @OriginatingRegionKey		= (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN')
SET @AllocationRegionKey		= (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN')
SET @PropertyFundKey			= (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey				= (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNK')

SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Development' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Global' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')



IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()

IF 	(@DataPriorToDate < '2010-01-01')
	SET @DataPriorToDate = '2010-01-01'
	
SET NOCOUNT ON
PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGeneralLedger'
PRINT CONVERT(Varchar(27), getdate(), 121)
PRINT '####'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Master Temp table for the combined ledger results from MRI Sources
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityGeneralLedger(
	SourcePrimaryKey varchar(100) NULL,
	SourceTableId Int NOT NULL,
	SourceCode varchar(2) NOT NULL,
	Period char(6) NOT NULL,
	OriginatingRegionCode char(6) NOT NULL,
	PropertyFundCode char(12) NOT NULL,
	FunctionalDepartmentCode char(15) NULL,
	JobCode char(15) NULL,
	GlAccountCode char(12) NOT NULL,
	LocalCurrency char(3) NOT NULL,
	LocalActual money NOT NULL,
	EnterDate datetime NULL,
	Description char(60) NULL,
	Basis char(1) NOT NULL,
	LastDate datetime NULL,
	GlAccountSuffix varchar(2) NULL,
	NetTSCost char(1) NOT NULL,
	UpdatedDate DateTime NOT NULL
)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	'USD' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From 
		USProp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							USProp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From USProp.ENTITY En
					INNER JOIN USProp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.PropertyFundCode
				
		INNER JOIN (
					Select Ga.*
					From USProp.GACC Ga
							INNER JOIN USProp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode

Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N'
AND		Gl.BALFOR			<> 'B'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'US PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
	

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,

	'USD' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From USCorp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							USCorp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From USCorp.ENTITY En
					INNER JOIN USCorp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.RegionCode
				
		INNER JOIN (
					Select Ga.*
					From USCorp.GACC Ga
							INNER JOIN USCorp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode
		INNER JOIN (
					Select Gd.*
					From USCorp.GDEP Gd
							INNER JOIN USCorp.GDepActive(@DataPriorToDate) GdA ON 
								GdA.ImportKey = Gd.ImportKey
					) Gd  ON Gd.DEPARTMENT = Gl.PropertyFundCode
										
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		Gl.BALFOR			<> 'B'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'US CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = 'PLZ' THEN 'PLN' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From EUProp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							EUProp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From EUProp.ENTITY En
					INNER JOIN EUProp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.PropertyFundCode

		INNER JOIN (
					Select Ga.*
					From EUProp.GACC Ga
							INNER JOIN EUProp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode

Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N'
AND		Gl.BALFOR			<> 'B'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'EU PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = 'PLZ' THEN 'PLN' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
	
From EUCorp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							EUCorp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From EUCorp.ENTITY En
					INNER JOIN EUCorp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.RegionCode
		INNER JOIN (
					Select Ga.*
					From EUCorp.GACC Ga
							INNER JOIN EUCorp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode		

		INNER JOIN (
					Select Gd.*
					From EUCorp.GDEP Gd
							INNER JOIN EUCorp.GDepActive(@DataPriorToDate) GdA ON 
								GdA.ImportKey = Gd.ImportKey
					) Gd  ON Gd.DEPARTMENT = Gl.PropertyFundCode

Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		Gl.BALFOR			<> 'B'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'EU CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From BRProp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							BRProp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From BRProp.ENTITY En
					INNER JOIN BRProp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.PropertyFundCode
				
		INNER JOIN (
					Select Ga.*
					From BRProp.GACC Ga
							INNER JOIN BRProp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode
					
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N'
AND		Gl.BALFOR			<> 'B'
AND		Gl.Source			= 'GR'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'BR PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	'BRL' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From BRCorp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							BRCorp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From BRCorp.ENTITY En
					INNER JOIN BRCorp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.RegionCode
				
		INNER JOIN (
					Select Ga.*
					From BRCorp.GACC Ga
							INNER JOIN BRCorp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode

		INNER JOIN (
					Select Gd.*
					From BRCorp.GDEP Gd
							INNER JOIN BRCorp.GDepActive(@DataPriorToDate) GdA ON 
								GdA.ImportKey = Gd.ImportKey
					) Gd  ON Gd.DEPARTMENT = Gl.PropertyFundCode
															
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		Gl.BALFOR			<> 'B'
AND		Gl.Source			= 'GR'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'


PRINT 'BR CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	ISNULL(Em.LocalEntityRef, Gl.PropertyFundCode) PropertyFundCode, --Generic convert 7char to 6char EntityID
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From CNProp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							CNProp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.PropertyFundCode
				
		INNER JOIN 
				(Select Em.*
				From GACS.EntityMapping Em
					INNER JOIN GACS.EntityMappingActive(@DataPriorToDate) EmA ON EmA.ImportKey = Em.ImportKey
				) Em ON Em.OriginalEntityRef = Gl.PropertyFundCode
						AND Em.Source = Gl.SourceCode
				
		LEFT OUTER JOIN (
					Select Ga.*
					From CNProp.GACC Ga
							INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode
					
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N'
AND		Gl.BALFOR			<> 'B'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'CH PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From CNCorp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							CNCorp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From CNCorp.ENTITY En
					INNER JOIN CNCorp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.RegionCode
				
		INNER JOIN (
					Select Ga.*
					From CNCorp.GACC Ga
							INNER JOIN CNCorp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode

		INNER JOIN (
					Select Gd.*
					From CNCorp.GDEP Gd
							INNER JOIN CNCorp.GDepActive(@DataPriorToDate) GdA ON 
								GdA.ImportKey = Gd.ImportKey
					) Gd  ON Gd.DEPARTMENT = Gl.PropertyFundCode
															
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		Gl.BALFOR			<> 'B'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'CH CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From INProp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							INProp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From INProp.ENTITY En
					INNER JOIN INProp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.PropertyFundCode
				
		INNER JOIN (
					Select Ga.*
					From INProp.GACC Ga
							INNER JOIN INProp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode
					
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N'
AND		Gl.BALFOR			<> 'B'
AND		Gl.Source			= 'GR'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'IN PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceTableId,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From INCorp.GeneralLedger Gl
		INNER JOIN (
					--This allows JOURNAL&GHIS to each have a record with the same PK,
					--but that is incorrect data and as such GR will pick GHIS as the 
					--more accurate data, for it is posted data, where journal data is still open data
					Select 
							SourcePrimaryKey,
							MAX(SourceTableId) SourceTableId
					From
							INCorp.GeneralLedger Gl
					Group By 
							SourcePrimaryKey
					) t1 ON
					t1.SourcePrimaryKey = Gl.SourcePrimaryKey
					AND t1.SourceTableId = Gl.SourceTableId

		INNER JOIN 
				(Select En.*
				From INCorp.ENTITY En
					INNER JOIN INCorp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.RegionCode
				
		INNER JOIN (
					Select Ga.*
					From INCorp.GACC Ga
							INNER JOIN INCorp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode
					
		INNER JOIN (
					Select Gd.*
					From INCorp.GDEP Gd
							INNER JOIN INCorp.GDepActive(@DataPriorToDate) GdA ON 
								GdA.ImportKey = Gd.ImportKey
					) Gd  ON Gd.DEPARTMENT = Gl.PropertyFundCode
										
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		Gl.BALFOR			<> 'B'
AND		Gl.Source			= 'GR'
AND		RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)),2) <> '99'

PRINT 'IN CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityGeneralLedger (UpdatedDate, FunctionalDepartmentCode,JobCode,GlAccountCode, SourceCode,Period,OriginatingRegionCode,PropertyFundCode,SourcePrimaryKey)

PRINT 'Completed building clustered index on #ProfitabilityGeneralLedger'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Prepare the # tables used for performance optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE TABLE #FunctionalDepartment(
	ImportKey int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	Name varchar(50) NOT NULL,
	Code varchar(31) NOT NULL,
	IsActive bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	GlobalCode char(3) NULL
)
CREATE TABLE #Department(
	ImportKey int NOT NULL,
	Department char(8) NOT NULL,
	Description varchar(50) NULL,
	LastDate datetime NULL,
	MRIUserID char(20) NULL,
	Source char(2) NOT NULL,
	IsActive bit NOT NULL,
	FunctionalDepartmentId int NULL,
	UpdatedDate datetime NOT NULL
)

CREATE TABLE #JobCode(
	ImportKey int NOT NULL,
	JobCode varchar(15) NOT NULL,
	Source char(2) NOT NULL,
	JobType varchar(15) NOT NULL,
	BuildingRef varchar(6) NULL,
	LastDate datetime NOT NULL,
	IsActive bit NOT NULL,
	Reference varchar(50) NOT NULL,
	MRIUserID char(20) NOT NULL,
	Description varchar(50) NULL,
	StartDate datetime NULL,
	EndDate datetime NULL,
	AccountingComment varchar(5000) NULL,
	PMComment varchar(5000) NULL,
	LeaseRef varchar(20) NULL,
	Area int NULL,
	AreaType varchar(20) NULL,
	RMPropertyRef varchar(6) NULL,
	IsAssumption bit NOT NULL,
	FunctionalDepartmentId int NULL
) 

CREATE TABLE #ActivityType(
	ImportKey int NOT NULL,
	ActivityTypeId int NOT NULL,
	ActivityTypeCode varchar(10) NOT NULL,
	Name varchar(50) NOT NULL,
	GLSuffix char(2) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL
)
CREATE TABLE #GlobalGlAccount(
	ImportKey int NOT NULL,
	GlobalGlAccountId int NOT NULL,
	GlAccountCode char(12) NOT NULL,
	Name nvarchar(250) NOT NULL,
	AccountType varchar(50) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	ActivityTypeId int NULL
) 
CREATE TABLE #GlAccountMapping(
	ImportKey int NOT NULL,
	GlAccountMappingId int NOT NULL,
	GlobalGlAccountId int NOT NULL,
	SourceCode char(2) NOT NULL,
	GlAccountCode char(14) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL
)
CREATE TABLE #OriginatingRegionMapping(
	ImportKey int NOT NULL,
	OriginatingRegionMappingId int NOT NULL,
	GlobalRegionId int NOT NULL,
	SourceCode char(2) NOT NULL,
	RegionCode varchar(10) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL
)
CREATE TABLE #PropertyFundMapping(
	ImportKey int NOT NULL,
	PropertyFundMappingId int NOT NULL,
	PropertyFundId int NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode varchar(8) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL,
	ActivityTypeId Int NULL
)
CREATE TABLE #PropertyFund(
	ImportKey int NOT NULL,
	PropertyFundId int NOT NULL,
	Name varchar(100) NOT NULL,
	RelatedFundId int NULL,
	ProjectRegionId int NOT NULL,
	EntityTypeId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL
)
CREATE TABLE #ProjectRegion(
	ImportKey int NOT NULL,
	ProjectRegionId int NOT NULL,
	GlobalProjectRegionId int NOT NULL,
	Name varchar(100) NOT NULL,
	Code varchar(6) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)
CREATE TABLE #AllocationRegionMapping(
	ImportKey int NOT NULL,
	AllocationRegionMappingId int NOT NULL,
	GlobalRegionId int NOT NULL,
	SourceCode char(2) NOT NULL,
	RegionCode varchar(10) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL
)

CREATE TABLE #JobCodeFunctionalDepartment(
	FunctionalDepartmentKey int NOT NULL,
	ReferenceCode varchar(20) NOT NULL,
	FunctionalDepartmentCode varchar(20) NOT NULL,
	FunctionalDepartmentName varchar(50) NOT NULL,
	SubFunctionalDepartmentCode varchar(20) NOT NULL,
	SubFunctionalDepartmentName varchar(100) NOT NULL,
	StartDate datetime NOT NULL,
	EndDate datetime NOT NULL
)

CREATE TABLE #ParentFunctionalDepartment(
	FunctionalDepartmentKey int NOT NULL,
	ReferenceCode varchar(20) NOT NULL,
	FunctionalDepartmentCode varchar(20) NOT NULL,
	FunctionalDepartmentName varchar(50) NOT NULL,
	SubFunctionalDepartmentCode varchar(20) NOT NULL,
	SubFunctionalDepartmentName varchar(100) NOT NULL,
	StartDate datetime NOT NULL,
	EndDate datetime NOT NULL
)

Insert Into #FunctionalDepartment
(ImportKey,FunctionalDepartmentId,Name,Code,IsActive,InsertedDate,UpdatedDate,GlobalCode)
Select Fd.ImportKey,Fd.FunctionalDepartmentId,Fd.Name,Fd.Code,Fd.IsActive,Fd.InsertedDate,Fd.UpdatedDate,Fd.GlobalCode
From HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey

Insert Into #Department
(ImportKey,Department,Description,LastDate,MRIUserID,Source,IsActive,FunctionalDepartmentId,UpdatedDate)
Select Dpt.ImportKey,Dpt.Department,Dpt.Description,Dpt.LastDate,Dpt.MRIUserID,Dpt.Source,Dpt.IsActive,Dpt.FunctionalDepartmentId,Dpt.UpdatedDate
From GACS.Department Dpt
	INNER JOIN GACS.DepartmentActive(@DataPriorToDate) DptA ON DptA.ImportKey = Dpt.ImportKey
Where Dpt.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #Department (Department,Source)

Insert Into #JobCode
(ImportKey,JobCode,Source,JobType,BuildingRef,LastDate,IsActive,Reference,MRIUserID,Description,StartDate,EndDate,AccountingComment,
PMComment,LeaseRef,Area,AreaType,RMPropertyRef,IsAssumption,FunctionalDepartmentId)
Select Jc.ImportKey,Jc.JobCode,Jc.Source,Jc.JobType,Jc.BuildingRef,Jc.LastDate,Jc.IsActive,Jc.Reference,Jc.MRIUserID,Jc.Description,
		Jc.StartDate,Jc.EndDate,Jc.AccountingComment,
		Jc.PMComment,Jc.LeaseRef,Jc.Area,Jc.AreaType,Jc.RMPropertyRef,Jc.IsAssumption,Jc.FunctionalDepartmentId
From GACS.JobCode Jc
	INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON JcA.ImportKey = Jc.ImportKey
Where Jc.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #JobCode (JobCode,Source)

Insert Into #ActivityType
(ImportKey,ActivityTypeId,ActivityTypeCode,Name,GLSuffix,InsertedDate,UpdatedDate)
Select At.ImportKey,At.ActivityTypeId,At.ActivityTypeCode,At.Name,At.GLSuffix,At.InsertedDate,At.UpdatedDate
From Gdm.ActivityType At
			INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

Insert Into #GlobalGlAccount
(ImportKey,	GlobalGlAccountId,GlAccountCode,Name,AccountType,InsertedDate,UpdatedDate,ActivityTypeId)
Select Glo.ImportKey,Glo.GlobalGlAccountId,Glo.GlAccountCode,Glo.Name,Glo.AccountType,Glo.InsertedDate,Glo.UpdatedDate,Glo.ActivityTypeId
From Gdm.GlobalGlAccount Glo
		INNER JOIN Gdm.GlobalGlAccountActive(@DataPriorToDate) GlA ON GlA.ImportKey = Glo.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GlobalGlAccount (GlobalGlAccountId,ActivityTypeId)
	
Insert Into #GlAccountMapping
(ImportKey,GlAccountMappingId,GlobalGlAccountId,SourceCode,GlAccountCode,InsertedDate,UpdatedDate,IsDeleted)
Select Gam.ImportKey,Gam.GlAccountMappingId,Gam.GlobalGlAccountId,Gam.SourceCode,Gam.GlAccountCode,Gam.InsertedDate,Gam.UpdatedDate,Gam.IsDeleted			
From Gdm.GlAccountMapping Gam 
		INNER JOIN Gdm.GlAccountMappingActive(@DataPriorToDate) GamA ON GamA.ImportKey = Gam.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GlAccountMapping (GlAccountCode,SourceCode,IsDeleted,GlobalGlAccountId)

Insert Into #PropertyFundMapping
(ImportKey, PropertyFundMappingId,PropertyFundId,SourceCode,PropertyFundCode,InsertedDate,UpdatedDate,IsDeleted,ActivityTypeId)
Select Pfm.ImportKey, Pfm.PropertyFundMappingId,Pfm.PropertyFundId,Pfm.SourceCode,Pfm.PropertyFundCode,Pfm.InsertedDate,Pfm.UpdatedDate,Pfm.IsDeleted, Pfm.ActivityTypeId
From Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,PropertyFundMappingId,ActivityTypeId)

Insert Into #OriginatingRegionMapping
(ImportKey,OriginatingRegionMappingId,GlobalRegionId,SourceCode,RegionCode,InsertedDate,UpdatedDate,IsDeleted)
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId, OriginatingRegionMappingId)

Insert Into #PropertyFund
(ImportKey,PropertyFundId,Name,RelatedFundId,ProjectRegionId,EntityTypeId,InsertedDate,UpdatedDate)
Select Pf.ImportKey,Pf.PropertyFundId,Pf.Name,Pf.RelatedFundId,Pf.ProjectRegionId,Pf.EntityTypeId,Pf.InsertedDate,Pf.UpdatedDate
From Gdm.PropertyFund Pf 
		INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PfA ON PfA.ImportKey = Pf.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (ProjectRegionId,PropertyFundId)

Insert Into #ProjectRegion
(ImportKey,ProjectRegionId,GlobalProjectRegionId,Name,Code,InsertedDate,UpdatedDate,UpdatedByStaffId)
Select Pr.ImportKey,Pr.ProjectRegionId,Pr.GlobalProjectRegionId,Pr.Name,Pr.Code,Pr.InsertedDate,Pr.UpdatedDate,Pr.UpdatedByStaffId
From Gdm.ProjectRegion Pr 
	INNER JOIN Gdm.ProjectRegionActive(@DataPriorToDate) PrA ON PrA.ImportKey = Pr.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProjectRegion (ProjectRegionId)

Insert Into #AllocationRegionMapping
(ImportKey,AllocationRegionMappingId,GlobalRegionId,SourceCode,RegionCode,InsertedDate,UpdatedDate,IsDeleted)
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #AllocationRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId,AllocationRegionMappingId)
	
--JobCodes
Insert Into #JobCodeFunctionalDepartment
(FunctionalDepartmentKey,ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,StartDate,EndDate)
Select FunctionalDepartmentKey,ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,StartDate,EndDate
From GrReporting.dbo.FunctionalDepartment
Where FunctionalDepartmentCode <> SubFunctionalDepartmentCode

--Parent Level
Insert Into #ParentFunctionalDepartment
(FunctionalDepartmentKey,ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,StartDate,EndDate)
Select FunctionalDepartmentKey,ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,StartDate,EndDate
From GrReporting.dbo.FunctionalDepartment
Where 
(
FunctionalDepartmentCode = SubFunctionalDepartmentCode
OR 
ReferenceCode = FunctionalDepartmentCode+':UNKNOWN'
)



CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

--Insert / Update / Delete the records in the bridge table :: ProfitabilityActualGlAccountCategoryBridge
CREATE TABLE #GlobalGlAccountCategoryHierarchy
(
	GlobalGlAccountCategoryHierarchyId int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	GlobalGlAccountId int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL,
	AccountType varchar(50) NOT NULL
)

INSERT INTO #GlobalGlAccountCategoryHierarchy
(GlobalGlAccountCategoryHierarchyId,GlobalGlAccountCategoryHierarchyGroupId,GlobalGlAccountId,
MajorGlAccountCategoryId,MinorGlAccountCategoryId,InsertedDate,UpdatedDate,IsDeleted,AccountType)
Select GlH.GlobalGlAccountCategoryHierarchyId,GlH.GlobalGlAccountCategoryHierarchyGroupId,GlH.GlobalGlAccountId,
		GlH.MajorGlAccountCategoryId,GlH.MinorGlAccountCategoryId,GlH.InsertedDate,GlH.UpdatedDate,GlH.IsDeleted,GlH.AccountType
From Gdm.GlobalGlAccountCategoryHierarchy GlH
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHa ON GlHa.ImportKey = GlH.ImportKey


INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey


PRINT 'Completed inserting Active records into temp table'
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #ProfitabilityActual(
	CalendarKey int NOT NULL,GlAccountKey int NOT NULL,SourceKey int NOT NULL,FunctionalDepartmentKey int NOT NULL,ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,OriginatingRegionKey int NOT NULL,AllocationRegionKey int NOT NULL,PropertyFundKey int NOT NULL,
	ReferenceCode Varchar(100) NOT NULL,LocalCurrencyKey Int NOT NULL,LocalActual money NOT NULL,
	ProfitabilityActualSourceTableId Int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
	) 

Insert Into #ProfitabilityActual
           (CalendarKey,GlAccountKey,SourceKey,FunctionalDepartmentKey,ReimbursableKey,ActivityTypeKey,OriginatingRegionKey,AllocationRegionKey,
			PropertyFundKey,ReferenceCode,LocalCurrencyKey,LocalActual,
			ProfitabilityActualSourceTableId
			)

SELECT 
		DATEDIFF(dd, '1900-01-01', LEFT(Gl.PERIOD,4)+'-'+RIGHT(Gl.PERIOD,2)+'-01') CalendarKey
		,CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKey ELSE GrGa.GlAccountKey END GlAccountKey
		,CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKey ELSE GrSc.SourceKey END SourceKey
		,CASE WHEN ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKey ELSE GrAt.ActivityTypeKey END ActivityTypeKey
		,CASE WHEN GrOr.OriginatingRegionKey IS NULL THEN @OriginatingRegionKey ELSE GrOr.OriginatingRegionKey END OriginatingRegionKey
		,CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKey ELSE GrAr.AllocationRegionKey END AllocationRegionKey
		,CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKey ELSE GrPf.PropertyFundKey END PropertyFundKey
		,Gl.SourcePrimaryKey
		,Cu.CurrencyKey
		,Gl.LocalActual
		,Gl.SourceTableId

From #ProfitabilityGeneralLedger Gl
		
		LEFT OUTER JOIN GrReporting.dbo.Source GrSc 
			ON GrSc.SourceCode = Gl.SourceCode

		LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON Cu.CurrencyCode = Gl.LocalCurrency

		--The JobCodes is FunctionalDepartment in Corp
		LEFT OUTER JOIN #JobCode Jc ON 
										Jc.JobCode = Gl.JobCode
									AND Jc.Source = Gl.SourceCode
									AND GrSc.IsCorporate = 'YES'
									
		--The Department (Region+FunctionalDept) is FunctionalDepartment in Prop
		LEFT OUTER JOIN #Department Dp ON Dp.Department = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode))
									AND Dp.Source = Gl.SourceCode
									AND GrSc.IsProperty = 'YES'

		LEFT OUTER JOIN #FunctionalDepartment Fd ON Fd.FunctionalDepartmentId = ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)
						
		--Detail/Sub Level : JobCode
		LEFT OUTER JOIN #JobCodeFunctionalDepartment GrFdm1 
			ON ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm1.StartDate AND GrFdm1.EndDate
			AND GrFdm1.ReferenceCode = CASE WHEN Gl.JobCode IS NOT NULL THEN Fd.GlobalCode + ':'+ LTRIM(RTRIM(Gl.JobCode))
												ELSE Fd.GlobalCode + ':UNKNOWN' END

		--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
		--that will be used, should the JobCode not match, but the FunctionalDepartment does match
		LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2
			ON ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate
			AND GrFdm2.ReferenceCode = Fd.GlobalCode +':' 

			
		LEFT OUTER JOIN #GlAccountMapping Gam
			ON Gam.GlAccountCode = Gl.GlAccountCode 
			AND Gam.SourceCode = Gl.SourceCode 
			AND Gam.IsDeleted = 0
			
		LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa 
			ON GrGa.GlobalGlAccountId = Gam.GlobalGlAccountId
			AND ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrGa.StartDate AND GrGa.EndDate

		LEFT OUTER JOIN #GlobalGlAccount Glo
			ON Glo.GlobalGlAccountId = Gam.GlobalGlAccountId

		LEFT OUTER JOIN #ActivityType At 
			ON At.ActivityTypeId = Glo.ActivityTypeId

		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt 
			ON GrAt.ActivityTypeId = At.ActivityTypeId
			AND ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrAt.StartDate AND GrAt.EndDate
			
		LEFT OUTER JOIN #PropertyFundMapping Pfm
			ON Pfm.PropertyFundCode = LTRIM(RTRIM(Gl.PropertyFundCode)) 
			AND Pfm.SourceCode = Gl.SourceCode 
			AND Pfm.IsDeleted = 0
			AND (
				(GrSc.IsProperty = 'YES' AND Pfm.ActivityTypeId IS NULL) 
				OR
				(
				(GrSc.IsCorporate = 'YES' AND Pfm.ActivityTypeId = Glo.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND Pfm.ActivityTypeId IS NULL AND Glo.ActivityTypeId IS NULL)
				)
				)
				
		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf 
			ON GrPf.PropertyFundId = Pfm.PropertyFundId
			AND ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrPf.StartDate AND GrPf.EndDate

		LEFT OUTER JOIN #OriginatingRegionMapping Orm
			ON Orm.RegionCode = CASE WHEN RIGHT(Gl.SourceCode,1) = 'C' THEN LTRIM(RTRIM(Gl.OriginatingRegionCode))
									ELSE LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) END
			AND Orm.SourceCode = Gl.SourceCode 
			AND Orm.IsDeleted = 0
			
		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr 
			ON GrOr.GlobalRegionId = Orm.GlobalRegionId
			AND ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrOr.StartDate AND GrOr.EndDate
		
		LEFT OUTER JOIN #PropertyFund Pf
			ON Pf.PropertyFundId = Pfm.PropertyFundId
			
		LEFT OUTER JOIN #ProjectRegion Pr
			ON Pr.ProjectRegionId = Pf.ProjectRegionId	
				
		LEFT OUTER JOIN #AllocationRegionMapping Arm
			ON Arm.RegionCode = Pr.Code
			AND Arm.IsDeleted = 0
			
		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr 
			ON GrAr.GlobalRegionId = Arm.GlobalRegionId
			AND ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrAr.StartDate AND GrAr.EndDate

		LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi 
			ON GrRi.ReimbursableCode = CASE WHEN Gl.NetTSCost = 'Y' THEN 'NO' ELSE 'YES' END
			
--This is NOT needed for the temp table selects at the top already filter the inserts!
--/*Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate*/

PRINT 'Completed converting all transactional data to star schema keys'
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUCorporateGlAccountCategoryKey
Update #ProfitabilityActual
SET	EUCorporateGlAccountCategoryKey = CASE WHEN GlAcEUCorp.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE GlAcEUCorp.GlAccountCategoryKey END 
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUCorp ON MaGlAcEUCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUCorp ON MiGlAcEUCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate

PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Update #ProfitabilityActual
SET	EUPropertyGlAccountCategoryKey = CASE WHEN GlAcEUProp.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE GlAcEUProp.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUProp ON MaGlAcEUProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUProp ON MiGlAcEUProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Update #ProfitabilityActual
SET EUFundGlAccountCategoryKey = CASE WHEN GlAcEUFund.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE GlAcEUFund.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUFund ON MaGlAcEUFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUFund ON MiGlAcEUFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate
	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Update #ProfitabilityActual
SET	USPropertyGlAccountCategoryKey = CASE WHEN GlAcUSProp.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE GlAcUSProp.GlAccountCategoryKey END
From #ProfitabilityActual Gl
		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSProp ON MaGlAcUSProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSProp ON MiGlAcUSProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
Update #ProfitabilityActual
SET	USCorporateGlAccountCategoryKey = CASE WHEN GlAcUSCorp.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE GlAcUSCorp.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSCorp ON MaGlAcUSCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSCorp ON MiGlAcUSCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Update #ProfitabilityActual
SET	USFundGlAccountCategoryKey = CASE WHEN GlAcUSFund.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE GlAcUSFund.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSFund ON MaGlAcUSFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSFund ON MiGlAcUSFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Update #ProfitabilityActual
SET	GlobalGlAccountCategoryKey = CASE WHEN GlAcGlobal.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE GlAcGlobal.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Global')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcGlobal ON MaGlAcGlobal.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcGlobal ON MiGlAcGlobal.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)




--DevelopmentGlAccountCategoryKey
Update #ProfitabilityActual
SET	DevelopmentGlAccountCategoryKey = CASE WHEN GlAcDevel.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE GlAcDevel.GlAccountCategoryKey END
From #ProfitabilityActual Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Development')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcDevel ON MaGlAcDevel.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcDevel ON MiGlAcDevel.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Transfer the updated rows
Update GrReporting.dbo.ProfitabilityActual
SET 	
	CalendarKey							= Pro.CalendarKey,
	GlAccountKey						= Pro.GlAccountKey,
	FunctionalDepartmentKey				= Pro.FunctionalDepartmentKey,
	ReimbursableKey						= Pro.ReimbursableKey,
	ActivityTypeKey						= Pro.ActivityTypeKey,
	OriginatingRegionKey				= Pro.OriginatingRegionKey,
	AllocationRegionKey					= Pro.AllocationRegionKey,
	PropertyFundKey						= Pro.PropertyFundKey,
	LocalCurrencyKey					= Pro.LocalCurrencyKey,
	LocalActual							= Pro.LocalActual,
	ProfitabilityActualSourceTableId	= Pro.ProfitabilityActualSourceTableId,
	
	EUCorporateGlAccountCategoryKey		= Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey		= Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey			= Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey		= Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey		= Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey			= Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey			= Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey		= Pro.DevelopmentGlAccountCategoryKey
From
	#ProfitabilityActual Pro
Where	ProfitabilityActual.SourceKey					= Pro.SourceKey
AND		ProfitabilityActual.ReferenceCode				= Pro.ReferenceCode

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

	
--Transfer the new rows
Insert Into GrReporting.dbo.ProfitabilityActual
(CalendarKey,GlAccountKey,FunctionalDepartmentKey,ReimbursableKey,
ActivityTypeKey,SourceKey,OriginatingRegionKey,AllocationRegionKey,PropertyFundKey,
ReferenceCode, LocalCurrencyKey, LocalActual,
ProfitabilityActualSourceTableId,

EUCorporateGlAccountCategoryKey,
EUPropertyGlAccountCategoryKey,
EUFundGlAccountCategoryKey,

USPropertyGlAccountCategoryKey,
USCorporateGlAccountCategoryKey,
USFundGlAccountCategoryKey,

GlobalGlAccountCategoryKey,
DevelopmentGlAccountCategoryKey)

Select
		Pro.CalendarKey,Pro.GlAccountKey,Pro.FunctionalDepartmentKey,Pro.ReimbursableKey,
		Pro.ActivityTypeKey,Pro.SourceKey,Pro.OriginatingRegionKey,Pro.AllocationRegionKey,Pro.PropertyFundKey,
		Pro.ReferenceCode, Pro.LocalCurrencyKey, Pro.LocalActual,
		Pro.ProfitabilityActualSourceTableId,
		
		Pro.EUCorporateGlAccountCategoryKey,
		Pro.EUPropertyGlAccountCategoryKey,
		Pro.EUFundGlAccountCategoryKey,

		Pro.USPropertyGlAccountCategoryKey,
		Pro.USCorporateGlAccountCategoryKey,
		Pro.USFundGlAccountCategoryKey,

		Pro.GlobalGlAccountCategoryKey,
		Pro.DevelopmentGlAccountCategoryKey
											
From	#ProfitabilityActual Pro
			LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON 
										ProExists.SourceKey						= Pro.SourceKey
									AND	ProExists.ReferenceCode					= Pro.ReferenceCode
Where ProExists.SourceKey IS NULL
PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--MRI should never delete rows from the GeneralLedger....
--hence we should never have to delete records
--PRINT 'Orphan Rows Delete in Profitability:'+CONVERT(char(10),@@rowcount)
--PRINT CONVERT(Varchar(27), getdate(), 121)


	

DROP TABLE #ProfitabilityGeneralLedger
DROP TABLE #ProfitabilityActual
DROP TABLE #JobCode
DROP TABLE #ActivityType
DROP TABLE #GlAccountMapping
DROP TABLE #GlobalGlAccount
DROP TABLE #PropertyFundMapping
DROP TABLE #OriginatingRegionMapping
DROP TABLE #PropertyFund
DROP TABLE #ProjectRegion
DROP TABLE #AllocationRegionMapping
DROP TABLE #GlobalGlAccountCategoryHierarchy
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory
DROP TABLE #FunctionalDepartment
DROP TABLE #Department
DROP TABLE #JobCodeFunctionalDepartment
DROP TABLE #ParentFunctionalDepartment
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollReforecast'
PRINT '####'


	
/*
[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId int NOT NULL,
	SystemSettingName varchar(50) NOT NULL,
	SystemSettingRegionId int NOT NULL,
	RegionId int,
	SourceCode varchar(2),
	BonusCapExcessProjectId int
)
INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT 'Completed getting system settings'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
		@SalariesTaxesBenefitsMajorGlAccountCategoryId	 int = -1,
		@BaseSalaryMinorGlAccountCategoryId				 int = -1,
		@BenefitsMinorGlAccountCategoryId				 int = -1,
		@BonusMinorGlAccountCategoryId					 int = -1,
		@ProfitShareMinorGlAccountCategoryId			 int = -1,
		@OccupancyCostsMajorGlAccountCategoryId			 int = -1,
		@OverheadMinorGlAccountCategoryId				 int = -1

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN')

DECLARE	@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int

SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Development' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Global' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
		
-- Set gl account categories
SELECT TOP 1 @SalariesTaxesBenefitsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = 'Salaries/Taxes/Benefits'
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT @BaseSalaryMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Base Salary'

SELECT @BenefitsMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Benefits'

SELECT @BonusMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Bonus'

SELECT @ProfitShareMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1 @OccupancyCostsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = 'General Overhead'

SELECT @OverheadMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'External General Overhead'

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey

PRINT 'Completed getting GlAccountCategory records'
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 
SELECT
	brgd.*
INTO
	#BudgetReportGroupDetail
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
PRINT 'Completed inserting records from BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group. 
SELECT 
	brg.* 
INTO
	#BudgetReportGroup
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
PRINT 'Completed inserting records from BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.
SELECT
	brgp.*
INTO
	#BudgetReportGroupPeriod
FROM
	TapasGlobalBudgeting.GRBudgetReportGroupPeriod brgp
	INNER JOIN TapasGlobalBudgeting.GRBudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
PRINT 'Completed inserting records from GRBudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status
SELECT 
	BudgetStatus.* 
INTO
	#BudgetStatus
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
PRINT 'Completed inserting records from BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget
SELECT 
	Budget.*
INTO
	#AllActiveBudget
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
PRINT 'Completed inserting records from Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.GRBudgetReportGroupPeriodId,
	Budget.IsDeleted as IsBudgetDeleted,
	Budget.IsReforecast as IsBugetReforecast,
	Budget.BudgetStatusId, 
	Budget.FirstProjectedPeriod as BudgetFirstProjectedPeriod,
	brgd.IsDeleted as IsDetailDeleted, 
	brg.IsReforecast as IsGroupReforecast, 
	brg.StartPeriod as GroupStartPeriod, 
	brg.EndPeriod as GroupEndPeriod, 
	brg.IsDeleted as IsGroupDeleted,
	brgp.IsDeleted as IsPeriodDeleted
INTO
	#AllModifiedReportBudget
FROM

	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupId = brgp.BudgetReportGroupId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

PRINT 'Completed inserting records into #AllModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

SELECT
	amrb.BudgetReportGroupId
INTO
	#LockedModifiedReportGroup
FROM

	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) 

PRINT 'Completed inserting records into #LockedModifiedReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information
SELECT
	amrb.*
INTO
	#FilteredModifiedReportBudget
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 1 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 1 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0

PRINT 'Completed inserting records into #FilteredModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget information that meet criteria
SELECT 
	Budget.* 
INTO
	#Budget
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT 'Completed inserting records into #Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
SELECT 
	BudgetProject.* 
INTO 
	#BudgetProject
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source region
SELECT 
	SourceRegion.* 
INTO
	#Region
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee
SELECT 
	BudgetEmployee.* 
INTO
	#BudgetEmployee
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT 'Completed creating indexes on ##BudgetEmployee'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Budget Employee Functional Department
SELECT 
	efd.* 
INTO
	#BudgetEmployeeFunctionalDepartment
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Property Fund Mapping

SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location
SELECT 
	Location.* 
INTO
	#Location
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT 'Completed creating indexes on #Location'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended
SELECT 
	RegionExtended.* 
INTO
	#RegionExtended
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT 'Completed creating indexes on #RegionExtended'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region
SELECT 
	PayrollRegion.* 
INTO
	#PayrollRegion
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT 'Completed creating indexes on #PayrollRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region
SELECT 
	OverheadRegion.* 
INTO
	#OverheadRegion
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT 'Completed creating indexes on #OverheadRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project
SELECT 
	Project.* 
INTO
	#Project
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT 'Completed creating indexes on #Project'
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SELECT
	Allocation.*
INTO
	#BudgetEmployeePayrollAllocation
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) as ImportBatchId
Into #BudgetEmployeePayrollAllocationDetailBatches
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY B2.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

SELECT 
	MAX(B1.ImportKey) ImportKey
Into #BEPADa
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


SELECT 
	TaxDetail.*
INTO
	#BudgetEmployeePayrollAllocationDetail
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type
SELECT 
	BudgetTaxType.* 
INTO
	#BudgetTaxType
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type
SELECT 
	TaxType.* 
INTO
	#TaxType
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	MinorGlAccountCategoryId int NULL,
	BudgetTaxTypeId int NULL,
	SalaryAmount decimal(18, 2) NULL,
	BonusAmount decimal(18, 2) NULL,
	ProfitShareAmount decimal(18, 2) NULL,
	BonusCapExcessAmount decimal(18, 2) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END as MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN 	
		#BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN 
		#BudgetTaxType BudgetTaxType ON
				TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN 
		#TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation
SELECT
	OverheadAllocation.*
INTO
	#BudgetOverheadAllocation
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail
SELECT 
	OverheadDetail.*
INTO
	#BudgetOverheadAllocationDetail
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	BudgetOverheadAllocationId int NOT NULL,
	BudgetProjectId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	AllocationValue decimal(18, 9) NOT NULL,
	AllocationAmount decimal(18, 2) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId as MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN 	
		#BudgetOverheadAllocationDetail OverheadDetail ON
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(SELECT 
		EFD.FunctionalDepartmentId
	 FROM 
		(SELECT 
			Allocation2.BudgetEmployeeId,
			MAX(EFD.EffectivePeriod) as EffectivePeriod
		 FROM
			#BudgetEmployeePayrollAllocation Allocation2

			INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
			WHERE
			  Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
			  EFD.EffectivePeriod <= Allocation.Period
			  
			GROUP BY
				Allocation2.BudgetEmployeeId
		) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ) as FunctionalDepartmentId
INTO
	#EffectiveFunctionalDepartment
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryPreTaxAmount money NOT NULL,
	ProfitSharePreTaxAmount money NOT NULL,
	BonusPreTaxAmount money NOT NULL,
	BonusCapExcessPreTaxAmount money NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	Budget.BudgetId as BudgetId,
	Budget.RegionId as BudgetRegionId,
	Budget.FirstProjectedPeriod,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) as ReferenceCode,
	Allocation.Period as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(Allocation.PreTaxSalaryAmount,0) as SalaryPreTaxAmount,
	IsNull(Allocation.PreTaxProfitShareAmount, 0) as ProfitSharePreTaxAmount,
	IsNull(Allocation.PreTaxBonusAmount,0) as BonusPreTaxAmount, 
	IsNull(Allocation.PreTaxBonusCapExcessAmount,0) as BonusCapExcessPreTaxAmount,
	IsNull(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END as Reimbursable,
	BudgetProject.ActivityTypeId,
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	Allocation.UpdatedDate
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryTaxAmount money NOT NULL,
	ProfitShareTaxAmount money NOT NULL,
	BonusTaxAmount money NOT NULL,
	BonusCapExcessTaxAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	pts.FirstProjectedPeriod,
	IsNull(pts.ProjectId,0) as ProjectId,
	IsNull(pts.HrEmployeeId,0) as HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,IsNull(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,IsNull(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) as ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	IsNull(TaxDetail.SalaryAmount, 0) as SalaryTaxAmount,
	IsNull(TaxDetail.ProfitShareAmount, 0) as ProfitShareTaxAmount,
	IsNull(TaxDetail.BonusAmount, 0) as BonusTaxAmount,
	IsNull(TaxDetail.BonusCapExcessAmount, 0) as BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	IsNull(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	IsNull(pts.ProjectRegionId, -1),
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate

FROM

	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId int NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	OverheadAllocationAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	OverheadUpdatedDate datetime NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId as BudgetId,
	Budget.FirstProjectedPeriod,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) as ReferenceCode,
	OverheadAllocation.BudgetPeriod as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(OverheadDetail.AllocationAmount,0) as OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	IsNull(RegionExtended.OverheadFunctionalDepartmentId, -1) as FunctionalDepartmentId,
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		CASE WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
			1 
		ELSE 
			0
		END
	ELSE 
		0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END as Reimbursable,
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.PropertyFundId, -1) 
	END as PropertyFundId,
	-- Same case logic as above
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.ProjectRegionId
				ELSE 
					DepartmentPropertyFund.ProjectRegionId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.ProjectRegionId, -1) 
	END as ProjectRegionId,
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM

	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
		(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN 
		#PropertyFund OverheadPropertyFund ON
				opfm.PropertyFundId = OverheadPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' as ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN 
		#Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' as ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' as ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount as BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.ProjectRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- Originating region mapping
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
Into #OriginatingRegionMapping
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey


PRINT 'Completed inserting records into #OriginatingRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId)
PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- See hack below. 
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
Into #AllocationRegionMapping
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

PRINT 'Completed inserting records into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey int NOT NULL,
	ReforecastKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') as CalendarKey
		,DATEDIFF(dd, '1900-01-01', LEFT(pbm.FirstProjectedPeriod,4)+'-'+RIGHT(pbm.FirstProjectedPeriod,2)+'-01') as ReforecastKey
		,@GlAccountKey GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,pbm.BudgetAmount
		,pbm.ReferenceCode
		,pbm.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	LEFT OUTER JOIN #AllocationRegionMapping Arm ON
		Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
		Arm.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Arm.GlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
		Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
								ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
		Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
		Orm.IsDeleted = 0
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = Orm.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT 'Completed inserting records into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityReforecast 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
	
	PRINT 'Completed deleting records from ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print 'Cleaned up rows in ProfitabilityReforecast'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------
--EUCorporateGlAccountCategoryKey

Select 
		GlAcEUCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Corporate') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END 
From #EUCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Select 
		GlAcEUProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Property') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Select 
		GlAcEUFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Fund') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Select 
		GlAcUSProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Property') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--USCorporateGlAccountCategoryKey
Select 
		GlAcUSCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Corporate') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Select 
		GlAcUSFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Fund') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Select 
		GlAcGlobal.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #GlobalCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Global') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #GlobalCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode



PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
Select 
		GlAcDevel.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #DevelCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Development') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

Update #ProfitabilityReforecast
SET	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #DevelCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode


PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast

print 'Rows Inserted in ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Setup data
DROP TABLE #SystemSettingRegion
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #Budget
DROP TABLE #BudgetStatus
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
-- Source data
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BEPADa
drop table #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #BudgetEmployee
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
-- Mapping mapping
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget
-- Account Category Mapping
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory
-- Additional Mappings
DROP TABLE #OriginatingRegionMapping
DROP TABLE #AllocationRegionMapping
-- Hierarchy Lookups
DROP TABLE #EUCorpCategoryLookup
DROP TABLE #EUPropCategoryLookup
DROP TABLE #EUFundCategoryLookup
DROP TABLE #USCorpCategoryLookup
DROP TABLE #USPropCategoryLookup
DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
DROP TABLE #DevelCategoryLookup

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollOriginalBudget'
PRINT '####'

	
/*
[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId int NOT NULL,
	SystemSettingName varchar(50) NOT NULL,
	SystemSettingRegionId int NOT NULL,
	RegionId int,
	SourceCode varchar(2),
	BonusCapExcessProjectId int
)
INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT 'Completed getting system settings'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
		@SalariesTaxesBenefitsMajorGlAccountCategoryId	 int = -1,
		@BaseSalaryMinorGlAccountCategoryId				 int = -1,
		@BenefitsMinorGlAccountCategoryId				 int = -1,
		@BonusMinorGlAccountCategoryId					 int = -1,
		@ProfitShareMinorGlAccountCategoryId			 int = -1,
		@OccupancyCostsMajorGlAccountCategoryId			 int = -1,
		@OverheadMinorGlAccountCategoryId				 int = -1

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN')

DECLARE	@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int

SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Development' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Global' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
		
-- Set gl account categories
SELECT TOP 1 @SalariesTaxesBenefitsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = 'Salaries/Taxes/Benefits'
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT @BaseSalaryMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Base Salary'

SELECT @BenefitsMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Benefits'

SELECT @BonusMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Bonus'

SELECT @ProfitShareMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1 @OccupancyCostsMajorGlAccountCategoryId = MajorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryName = 'General Overhead'

SELECT @OverheadMinorGlAccountCategoryId = MinorGlAccountCategoryId 
FROM Gr.GetGlobalGlAccountCategoryHierarchy(@DataPriorToDate) 
WHERE MajorGlAccountCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	  MinorGlAccountCategoryName = 'External General Overhead'

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey

PRINT 'Completed getting GlAccountCategory records'
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 
SELECT
	brgd.*
INTO
	#BudgetReportGroupDetail
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
PRINT 'Completed inserting records from BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group. 
SELECT 
	brg.* 
INTO
	#BudgetReportGroup
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
PRINT 'Completed inserting records from BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.
SELECT
	brgp.*
INTO
	#BudgetReportGroupPeriod
FROM
	TapasGlobalBudgeting.GRBudgetReportGroupPeriod brgp
	INNER JOIN TapasGlobalBudgeting.GRBudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
PRINT 'Completed inserting records from GRBudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status
SELECT 
	BudgetStatus.* 
INTO
	#BudgetStatus
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
PRINT 'Completed inserting records from BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget
SELECT 
	Budget.*
INTO
	#AllActiveBudget
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
PRINT 'Completed inserting records from Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.GRBudgetReportGroupPeriodId,
	Budget.IsDeleted as IsBudgetDeleted,
	Budget.IsReforecast as IsBugetReforecast,
	Budget.BudgetStatusId, 
	brgd.IsDeleted as IsDetailDeleted, 
	brg.IsReforecast as IsGroupReforecast, 
	brg.StartPeriod as GroupStartPeriod, 
	brg.EndPeriod as GroupEndPeriod, 
	brg.IsDeleted as IsGroupDeleted,
	brgp.IsDeleted as IsPeriodDeleted
INTO
	#AllModifiedReportBudget
FROM

	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupId = brgp.BudgetReportGroupId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

PRINT 'Completed inserting records into #AllModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

SELECT
	amrb.BudgetReportGroupId
INTO
	#LockedModifiedReportGroup
FROM

	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) 

PRINT 'Completed inserting records into #LockedModifiedReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information
SELECT
	amrb.*
INTO
	#FilteredModifiedReportBudget
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 0 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 0 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0

PRINT 'Completed inserting records into #FilteredModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget information that meet criteria
SELECT 
	Budget.* 
INTO
	#Budget
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT 'Completed inserting records into #Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
SELECT 
	BudgetProject.* 
INTO 
	#BudgetProject
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source region
SELECT 
	SourceRegion.* 
INTO
	#Region
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee
SELECT 
	BudgetEmployee.* 
INTO
	#BudgetEmployee
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT 'Completed creating indexes on ##BudgetEmployee'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Budget Employee Functional Department
SELECT 
	efd.* 
INTO
	#BudgetEmployeeFunctionalDepartment
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Property Fund Mapping

SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location
SELECT 
	Location.* 
INTO
	#Location
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT 'Completed creating indexes on #Location'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended
SELECT 
	RegionExtended.* 
INTO
	#RegionExtended
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT 'Completed creating indexes on #RegionExtended'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region
SELECT 
	PayrollRegion.* 
INTO
	#PayrollRegion
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT 'Completed creating indexes on #PayrollRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region
SELECT 
	OverheadRegion.* 
INTO
	#OverheadRegion
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT 'Completed creating indexes on #OverheadRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project
SELECT 
	Project.* 
INTO
	#Project
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT 'Completed creating indexes on #Project'
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation
SELECT
	Allocation.*
INTO
	#BudgetEmployeePayrollAllocation
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) as ImportBatchId
Into #BudgetEmployeePayrollAllocationDetailBatches
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY B2.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

SELECT 
	MAX(B1.ImportKey) ImportKey
Into #BEPADa
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


SELECT 
	TaxDetail.*
INTO
	#BudgetEmployeePayrollAllocationDetail
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type
SELECT 
	BudgetTaxType.* 
INTO
	#BudgetTaxType
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type
SELECT 
	TaxType.* 
INTO
	#TaxType
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	MinorGlAccountCategoryId int NULL,
	BudgetTaxTypeId int NULL,
	SalaryAmount decimal(18, 2) NULL,
	BonusAmount decimal(18, 2) NULL,
	ProfitShareAmount decimal(18, 2) NULL,
	BonusCapExcessAmount decimal(18, 2) NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END as MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN 	
		#BudgetEmployeePayrollAllocationDetail TaxDetail ON
			Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN 
		#BudgetTaxType BudgetTaxType ON
				TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN 
		#TaxType TaxType ON
			BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation
SELECT
	OverheadAllocation.*
INTO
	#BudgetOverheadAllocation
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail
SELECT 
	OverheadDetail.*
INTO
	#BudgetOverheadAllocationDetail
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	BudgetOverheadAllocationId int NOT NULL,
	BudgetProjectId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	AllocationValue decimal(18, 9) NOT NULL,
	AllocationAmount decimal(18, 2) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	UpdatedByStaffId int NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId as MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN 	
		#BudgetOverheadAllocationDetail OverheadDetail ON
			OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 
			
PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(SELECT 
		EFD.FunctionalDepartmentId
	 FROM 
		(SELECT 
			Allocation2.BudgetEmployeeId,
			MAX(EFD.EffectivePeriod) as EffectivePeriod
		 FROM
			#BudgetEmployeePayrollAllocation Allocation2

			INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
			WHERE
			  Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
			  EFD.EffectivePeriod <= Allocation.Period
			  
			GROUP BY
				Allocation2.BudgetEmployeeId
		) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ) as FunctionalDepartmentId
INTO
	#EffectiveFunctionalDepartment
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryPreTaxAmount money NOT NULL,
	ProfitSharePreTaxAmount money NOT NULL,
	BonusPreTaxAmount money NOT NULL,
	BonusCapExcessPreTaxAmount money NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	Budget.BudgetId as BudgetId,
	Budget.RegionId as BudgetRegionId,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) as ReferenceCode,
	Allocation.Period as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(Allocation.PreTaxSalaryAmount,0) as SalaryPreTaxAmount,
	IsNull(Allocation.PreTaxProfitShareAmount, 0) as ProfitSharePreTaxAmount,
	IsNull(Allocation.PreTaxBonusAmount,0) as BonusPreTaxAmount, 
	IsNull(Allocation.PreTaxBonusCapExcessAmount,0) as BonusCapExcessPreTaxAmount,
	IsNull(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END as Reimbursable,
	BudgetProject.ActivityTypeId,
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	Allocation.UpdatedDate
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = SourceRegion.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

WHERE
	Allocation.Period BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod AND
	BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId int NOT NULL,
	BudgetRegionId int NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetEmployeePayrollAllocationId int NOT NULL,
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	SalaryTaxAmount money NOT NULL,
	ProfitShareTaxAmount money NOT NULL,
	BonusTaxAmount money NOT NULL,
	BonusCapExcessTaxAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	IsNull(pts.ProjectId,0) as ProjectId,
	IsNull(pts.HrEmployeeId,0) as HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,IsNull(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,IsNull(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) as ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	IsNull(TaxDetail.SalaryAmount, 0) as SalaryTaxAmount,
	IsNull(TaxDetail.ProfitShareAmount, 0) as ProfitShareTaxAmount,
	IsNull(TaxDetail.BonusAmount, 0) as BonusTaxAmount,
	IsNull(TaxDetail.BonusCapExcessAmount, 0) as BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	IsNull(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.PropertyFundId,
	IsNull(pts.ProjectRegionId, -1),
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate

FROM

	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId int NOT NULL,
	ProjectId int NOT NULL,
	HrEmployeeId int NOT NULL,
	BudgetOverheadAllocationId int NOT NULL,
	BudgetOverheadAllocationDetailId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	OverheadAllocationAmount money NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	OverheadUpdatedDate datetime NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId as BudgetId,
	IsNull(BudgetProject.ProjectId,0) as ProjectId,
	IsNull(BudgetEmployee.HrEmployeeId,0) as HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,IsNull(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,IsNull(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) as ReferenceCode,
	OverheadAllocation.BudgetPeriod as ExpensePeriod,
	SourceRegion.SourceCode,
	IsNull(OverheadDetail.AllocationAmount,0) as OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	IsNull(RegionExtended.OverheadFunctionalDepartmentId, -1) as FunctionalDepartmentId,
	fd.GlobalCode as FunctionalDepartmentCode, 
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		CASE WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
			1 
		ELSE 
			0
		END
	ELSE 
		0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END as Reimbursable,
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.PropertyFundId, -1) 
	END as PropertyFundId,
	-- Same case logic as above
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		IsNull(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.ProjectRegionId
				ELSE 
					DepartmentPropertyFund.ProjectRegionId 
				END, -1) 
	ELSE 
		IsNull(OverheadPropertyFund.ProjectRegionId, -1) 
	END as ProjectRegionId,
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode as LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM

	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrScC ON GrScC.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
		(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
		OR
		(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN 
		#PropertyFund OverheadPropertyFund ON
				opfm.PropertyFundId = OverheadPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' as ReferenceCode,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId as MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN 
		#Project p ON
			ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = pps.SourceCode
		
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
		ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		) 
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' as ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount as BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 as Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	IsNull(p.ActivityTypeId, -1) as ActivityTypeId,
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.PropertyFundId
			ELSE 
				DepartmentPropertyFund.PropertyFundId 
			END, -1) as PropertyFundId,
	-- Same case logic as above
	IsNull(CASE WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
				ProjectPropertyFund.ProjectRegionId
			ELSE 
				DepartmentPropertyFund.ProjectRegionId 
			END, -1) as ProjectRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = pps.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
		)
		)
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' as ReferenceCod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount as BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId as MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.ProjectRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0


PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- Originating region mapping
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
Into #OriginatingRegionMapping
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey


PRINT 'Completed inserting records into #OriginatingRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId)
PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- See hack below. 
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
Into #AllocationRegionMapping
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

PRINT 'Completed inserting records into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') as CalendarKey
		,@GlAccountKey GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,pbm.BudgetAmount
		,pbm.ReferenceCode
		,pbm.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
		--GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND --replaced by new logic below
		GrFdm.FunctionalDepartmentCode = pbm.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	LEFT OUTER JOIN #AllocationRegionMapping Arm ON
		Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
		Arm.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Arm.GlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
		Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
								ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
		Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
		Orm.IsDeleted = 0
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = Orm.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT 'Completed inserting records into #ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityBudget (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityBudget 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
	
	PRINT 'Completed deleting records from ProfitabilityBudget:BudgetId='+CONVERT(varchar,@BudgetId)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print 'Cleaned up rows in ProfitabilityBudget'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------
--EUCorporateGlAccountCategoryKey

Select 
		GlAcEUCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Corporate') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate
				
CREATE UNIQUE CLUSTERED INDEX IX ON #EUCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	EUCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END 
From #EUCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Select 
		GlAcEUProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Property') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUPropCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	EUPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Select 
		GlAcEUFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #EUFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Fund') GlAcHg
		) Gl
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #EUFundCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET EUFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #EUFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Select 
		GlAcUSProp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USPropCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Property') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USPropCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	USPropertyGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USPropCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--USCorporateGlAccountCategoryKey
Select 
		GlAcUSCorp.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USCorpCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Corporate') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USCorpCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	USCorporateGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USCorpCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Select 
		GlAcUSFund.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #USFundCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Fund') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #USFundCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	USFundGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #USFundCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Select 
		GlAcGlobal.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #GlobalCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Global') GlAcHg
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #GlobalCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode



PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
Select 
		GlAcDevel.GlAccountCategoryKey,
		Gl.ReferenceCode
Into #DevelCategoryLookup
From
	(SELECT 
			Gl.MajorGlAccountCategoryId,
			Gl.MinorGlAccountCategoryId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode,
			GlAcHg.GlobalGlAccountCategoryHierarchyGroupId
		 FROM	
			#ProfitabilityPayrollMapping Gl				
				CROSS JOIN (Select * From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Development') GlAcHg
		) Gl

		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(Gl.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0))
				AND Gl.AllocationUpdatedDate  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #DevelCategoryLookup (ReferenceCode)

Update #ProfitabilityBudget
SET	DevelopmentGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE t1.GlAccountCategoryKey END
From #DevelCategoryLookup t1
Where t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode


PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget

print 'Rows Inserted in ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Setup data
DROP TABLE #SystemSettingRegion
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #Budget
DROP TABLE #BudgetStatus
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
-- Source data
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BEPADa
drop table #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #BudgetEmployee
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
-- Mapping mapping
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #ProfitabilityBudget
DROP TABLE #DeletingBudget
-- Account Category Mapping
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory
-- Additional Mappings
DROP TABLE #OriginatingRegionMapping
DROP TABLE #AllocationRegionMapping
-- Hierarchy Lookups
DROP TABLE #EUCorpCategoryLookup
DROP TABLE #EUPropCategoryLookup
DROP TABLE #EUFundCategoryLookup
DROP TABLE #USCorpCategoryLookup
DROP TABLE #USPropCategoryLookup
DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
DROP TABLE #DevelCategoryLookup

GO

 
--/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyCorporateReforecast'
PRINT '####'
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN')

DECLARE
		@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int
		
SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Development' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Global' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT 'Start'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT
	CAST(Budget.BudgetYear AS VARCHAR(4)) + CASE Budget.BudgetPeriodCode 
												WHEN 'Q1' THEN CASE WHEN Budget.BudgetYear = 2010 THEN '03' /*March isn Q1 start in 2010 - Ask Mike Caracciolo why*/ ELSE '04' END --Q1 - April (04)
												WHEN 'Q2' THEN '07' --Q2 - Jul (07)
												WHEN 'Q3' THEN '10' --Q3 - Oct (10)
												ELSE '01' -- Default to Q0 Jan (01)
											END as FirstProjectedPeriod,
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode <> 'Q0' -- Reforecast budget values only

PRINT 'Rows Inserted into #Budget::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GlobalGlAccount gla
	INNER JOIN Gdm.GlobalGlAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT 'Rows Inserted into #GlAccount::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Rows Inserted into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT 'Rows Inserted into #ActvityType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT 'Rows Inserted into #GlobalRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping

SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Rows Inserted into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Get hierarchy group
CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

--Insert / Update / Delete the records in the bridge table :: ProfitabilityActualGlAccountCategoryBridge
CREATE TABLE #GlobalGlAccountCategoryHierarchy
(
	GlobalGlAccountCategoryHierarchyId int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	GlobalGlAccountId int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL,
	AccountType varchar(50) NOT NULL
)

INSERT INTO #GlobalGlAccountCategoryHierarchy
(GlobalGlAccountCategoryHierarchyId,GlobalGlAccountCategoryHierarchyGroupId,GlobalGlAccountId,
MajorGlAccountCategoryId,MinorGlAccountCategoryId,InsertedDate,UpdatedDate,IsDeleted,AccountType)
Select GlH.GlobalGlAccountCategoryHierarchyId,GlH.GlobalGlAccountCategoryHierarchyGroupId,GlH.GlobalGlAccountId,
		GlH.MajorGlAccountCategoryId,GlH.MinorGlAccountCategoryId,GlH.InsertedDate,GlH.UpdatedDate,GlH.IsDeleted,GlH.AccountType
From Gdm.GlobalGlAccountCategoryHierarchy GlH
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHa ON GlHa.ImportKey = GlH.ImportKey


INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map reforecast budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	ReforecastAmount money NOT NULL,
	GlobalGlAccountCode varchar(21) NOT NULL,
	GlobalGlAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL
)
-- Insert reforecast budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	ReforecastAmount,
	GlobalGlAccountCode,
	GlobalGlAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense
)

SELECT 
	b.BudgetId,
	'BC:' + b.SourceUniqueKey + '&ImportKey=' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.FirstProjectedPeriod,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as ReforecastAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlobalGlAccountCode,
	IsNull(gla.GlobalGlAccountId,-1) as GlobalGlAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.ProjectRegionId,-1) as ProjectRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		b.GlobalGlAccountCode = gla.GlAccountCode
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		b.FunctionalDepartmentGlobalCode = fd.GlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		gla.ActivityTypeId = at.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		b.NonPayrollCorporateMRIDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		b.SourceCode = pfm.SourceCode
		AND (
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = at.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
		)
		) AND
		pfm.IsDeleted = 0
		
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN #GlobalRegion gr ON
		b.OriginatingSubRegionCode = gr.RegionCode

WHERE
	b.LocalAmount <> 0 AND
	(b.Period >= b.FirstProjectedPeriod OR b.FirstProjectedPeriod = '201003') -- Get only reforecasted budgeted amounts 
	--(UPDATED: Hack the planet: Now also source actuals for non payroll (including fees) for reforecast Q1, 201003 from the grinder (Yes Q1 201003 - Ask MikeC))


PRINT 'Rows Inserted into #ProfitabilitySource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- See hack below. 
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
Into #AllocationRegionMapping
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

PRINT 'Rows Inserted into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey int NOT NULL,
	ReforecastKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(ps.ExpensePeriod,4)+'-'+RIGHT(ps.ExpensePeriod,2)+'-01') as CalendarKey
		,DATEDIFF(dd, '1900-01-01', LEFT(ps.FirstProjectedPeriod,4)+'-'+RIGHT(ps.FirstProjectedPeriod,2)+'-01') as ReforecastKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.ReforecastAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlobalGlAccountId = GrGl.GlobalGlAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		GrFdmD.SubFunctionalDepartmentCode <> GrFdmD.FunctionalDepartmentCode AND
		--GrFdmD.ReferenceCode LIKE '%:'+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		GrFdmP.SubFunctionalDepartmentCode = GrFdmP.FunctionalDepartmentCode AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +':%' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	LEFT OUTER JOIN #AllocationRegionMapping Arm ON
		Arm.RegionCode = ps.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
		Arm.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Arm.GlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Arm.GlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate

/*
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ps.ProjectRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingRegionCode = GrOr.SubRegionCode AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 


PRINT 'Rows Inserted into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityReforecast (GlAccountKey)
PRINT 'Created Index on GlAccountKey #ProfitabilityReforecast'
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUCorporateGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	EUCorporateGlAccountCategoryKey = CASE WHEN GlAcEUCorp.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE GlAcEUCorp.GlAccountCategoryKey END 
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUCorp ON MaGlAcEUCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUCorp ON MiGlAcEUCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate

PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	EUPropertyGlAccountCategoryKey = CASE WHEN GlAcEUProp.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE GlAcEUProp.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUProp ON MaGlAcEUProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUProp ON MiGlAcEUProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Update #ProfitabilityReforecast
SET EUFundGlAccountCategoryKey = CASE WHEN GlAcEUFund.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE GlAcEUFund.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUFund ON MaGlAcEUFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUFund ON MiGlAcEUFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate
	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	USPropertyGlAccountCategoryKey = CASE WHEN GlAcUSProp.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE GlAcUSProp.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl
		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSProp ON MaGlAcUSProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSProp ON MiGlAcUSProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	USCorporateGlAccountCategoryKey = CASE WHEN GlAcUSCorp.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE GlAcUSCorp.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSCorp ON MaGlAcUSCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSCorp ON MiGlAcUSCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	USFundGlAccountCategoryKey = CASE WHEN GlAcUSFund.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE GlAcUSFund.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSFund ON MaGlAcUSFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSFund ON MiGlAcUSFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	GlobalGlAccountCategoryKey = CASE WHEN GlAcGlobal.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE GlAcGlobal.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Global')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcGlobal ON MaGlAcGlobal.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcGlobal ON MiGlAcGlobal.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)




--DevelopmentGlAccountCategoryKey
Update #ProfitabilityReforecast
SET	DevelopmentGlAccountCategoryKey = CASE WHEN GlAcDevel.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE GlAcDevel.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Development')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcDevel ON MaGlAcDevel.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcDevel ON MiGlAcDevel.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified reforecast budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityReforecast

PRINT 'Rows Inserted into #DeletingReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityReforecast 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
	PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT 'Rows Deleted from #DeletingBudget:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print 'Cleaned up rows in ProfitabilityReforecast'


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast


PRINT 'Rows Inserted into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityReforecast
-- Account Category Mapping
DROP TABLE #GlobalGlAccountCategoryHierarchy
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory


GO


--/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
GO

CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyCorporateOriginalBudget'
PRINT '####'
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN')

DECLARE
		@EUFundGlAccountCategoryKey						Int,
		@EUCorporateGlAccountCategoryKey				Int,
		@EUPropertyGlAccountCategoryKey					Int,
		@USFundGlAccountCategoryKey						Int,
		@USPropertyGlAccountCategoryKey					Int,
		@USCorporateGlAccountCategoryKey				Int,
		@DevelopmentGlAccountCategoryKey				Int,
		@GlobalGlAccountCategoryKey						Int
		
SET @EUFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'EU Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USFundGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Fund' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKey		= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Property' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'US Corporate' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKey	= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Development' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKey			= (Select GlAccountCategoryKey From GrReporting.dbo.GlAccountCategory Where HierarchyName = 'Global' AND MajorName = 'UNKNOWN' AND MinorName = 'UNKNOWN')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT 'Start'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode = 'Q0' -- Original budget values only

PRINT 'Rows Inserted into #Budget::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GlobalGlAccount gla
	INNER JOIN Gdm.GlobalGlAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT 'Rows Inserted into #GlAccount::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Rows Inserted into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT 'Rows Inserted into #ActvityType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT 'Rows Inserted into #GlobalRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping

SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Rows Inserted into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Get hierarchy group
CREATE TABLE #GlobalGlAccountCategoryHierarchyGroup
(
	ImportKey int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	Name varchar(50) NOT NULL,
	IsDefault bit NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MajorGlAccountCategory(
	ImportKey int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

CREATE TABLE #MinorGlAccountCategory(
	ImportKey int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	Name varchar(100) NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
)

--Insert / Update / Delete the records in the bridge table :: ProfitabilityActualGlAccountCategoryBridge
CREATE TABLE #GlobalGlAccountCategoryHierarchy
(
	GlobalGlAccountCategoryHierarchyId int NOT NULL,
	GlobalGlAccountCategoryHierarchyGroupId int NOT NULL,
	GlobalGlAccountId int NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	InsertedDate datetime NOT NULL,
	UpdatedDate datetime NOT NULL,
	IsDeleted bit NOT NULL,
	AccountType varchar(50) NOT NULL
)

INSERT INTO #GlobalGlAccountCategoryHierarchy
(GlobalGlAccountCategoryHierarchyId,GlobalGlAccountCategoryHierarchyGroupId,GlobalGlAccountId,
MajorGlAccountCategoryId,MinorGlAccountCategoryId,InsertedDate,UpdatedDate,IsDeleted,AccountType)
Select GlH.GlobalGlAccountCategoryHierarchyId,GlH.GlobalGlAccountCategoryHierarchyGroupId,GlH.GlobalGlAccountId,
		GlH.MajorGlAccountCategoryId,GlH.MinorGlAccountCategoryId,GlH.InsertedDate,GlH.UpdatedDate,GlH.IsDeleted,GlH.AccountType
From Gdm.GlobalGlAccountCategoryHierarchy GlH
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHa ON GlHa.ImportKey = GlH.ImportKey


INSERT INTO #GlobalGlAccountCategoryHierarchyGroup
(ImportKey,GlobalGlAccountCategoryHierarchyGroupId,Name,IsDefault,InsertedDate,UpdatedDate)
Select GlHg.ImportKey,GlHg.GlobalGlAccountCategoryHierarchyGroupId,GlHg.Name,GlHg.IsDefault,GlHg.InsertedDate,GlHg.UpdatedDate
From Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
		INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHga ON GlHga.ImportKey = GlHg.ImportKey

INSERT INTO #MajorGlAccountCategory
(ImportKey,MajorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MaGlAc.ImportKey,MaGlAc.MajorGlAccountCategoryId,MaGlAc.Name,MaGlAc.InsertedDate,MaGlAc.UpdatedDate
From	Gdm.MajorGlAccountCategory MaGlAc
		INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) MaGlAcA ON MaGlAcA.ImportKey = MaGlAc.ImportKey

INSERT INTO #MinorGlAccountCategory
(ImportKey,MinorGlAccountCategoryId,Name,InsertedDate,UpdatedDate)
Select MiGlAc.ImportKey,MiGlAc.MinorGlAccountCategoryId,MiGlAc.Name,MiGlAc.InsertedDate,MiGlAc.UpdatedDate
From	Gdm.MinorGlAccountCategory MiGlAc
		INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) MiGlAcA ON MiGlAcA.ImportKey = MiGlAc.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	GlobalGlAccountCode varchar(21) NOT NULL,
	GlobalGlAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	ProjectRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GlobalGlAccountCode,
	GlobalGlAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	ProjectRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense
)

SELECT 
	b.BudgetId,
	'BC:' + b.SourceUniqueKey + '&ImportKey=' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as BudgetAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlobalGlAccountCode,
	IsNull(gla.GlobalGlAccountId,-1) as GlobalGlAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.ProjectRegionId,-1) as ProjectRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		b.GlobalGlAccountCode = gla.GlAccountCode
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		b.FunctionalDepartmentGlobalCode = fd.GlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		gla.ActivityTypeId = at.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode
		
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		b.NonPayrollCorporateMRIDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		b.SourceCode = pfm.SourceCode AND 
		(
		(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
		OR
		(
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = at.ActivityTypeId)
		OR
		(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
		)
		) AND
		pfm.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId

	LEFT OUTER JOIN #GlobalRegion gr ON
		b.OriginatingSubRegionCode = gr.RegionCode

WHERE
	b.LocalAmount <> 0

PRINT 'Rows Inserted into #ProfitabilitySource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE NONCLUSTERED INDEX IX_LocalAmount ON [#Budget] ([LocalAmount])
INCLUDE ([ImportKey],[SourceUniqueKey],[BudgetId],[SourceCode],[LockedDate],[Period],[InternationalCurrencyCode],[GlobalGlAccountCode],[FunctionalDepartmentGlobalCode],[OriginatingSubRegionCode],[NonPayrollCorporateMRIDepartmentCode],[AllocationSubRegionProjectRegionId],[IsReimbursable],[JobCode])

PRINT 'Created Index on GlAccountKey #ProfitabilitySource'
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- See hack below. 
Select Arm.ImportKey,Arm.AllocationRegionMappingId,Arm.GlobalRegionId,Arm.SourceCode,Arm.RegionCode,Arm.InsertedDate,Arm.UpdatedDate,Arm.IsDeleted
Into #AllocationRegionMapping
From Gdm.AllocationRegionMapping Arm 
	INNER JOIN Gdm.AllocationRegionMappingActive(@DataPriorToDate) ArmA ON ArmA.ImportKey = Arm.ImportKey

PRINT 'Rows Inserted into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(ps.ExpensePeriod,4)+'-'+RIGHT(ps.ExpensePeriod,2)+'-01') as CalendarKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.BudgetAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId 
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlobalGlAccountId = GrGl.GlobalGlAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN (
				Select 
					*
				From GrReporting.dbo.FunctionalDepartment
				Where SubFunctionalDepartmentCode <> FunctionalDepartmentCode
				) GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		--GrFdmD.ReferenceCode LIKE '%:'+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN (
			Select 
				* 
			From 
			GrReporting.dbo.FunctionalDepartment
			Where SubFunctionalDepartmentCode = FunctionalDepartmentCode
			) GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +':%' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	LEFT OUTER JOIN #AllocationRegionMapping Arm ON
		Arm.RegionCode = ps.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
		Arm.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Arm.GlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Arm.GlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate

/*
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ps.ProjectRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingRegionCode = GrOr.SubRegionCode AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 


PRINT 'Rows Inserted into #ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityBudget (GlAccountKey)
PRINT 'Created Index on GlAccountKey #ProfitabilityBudget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUCorporateGlAccountCategoryKey
Update #ProfitabilityBudget
SET	EUCorporateGlAccountCategoryKey = CASE WHEN GlAcEUCorp.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKey ELSE GlAcEUCorp.GlAccountCategoryKey END 
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUCorp ON MaGlAcEUCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUCorp ON MiGlAcEUCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUCorp ON GlAcEUCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUCorp.StartDate AND GlAcEUCorp.EndDate

PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
Update #ProfitabilityBudget
SET	EUPropertyGlAccountCategoryKey = CASE WHEN GlAcEUProp.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKey ELSE GlAcEUProp.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUProp ON MaGlAcEUProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUProp ON MiGlAcEUProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUProp ON GlAcEUProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcEUProp.StartDate AND GlAcEUProp.EndDate

PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--EUFundGlAccountCategoryKey
Update #ProfitabilityBudget
SET EUFundGlAccountCategoryKey = CASE WHEN GlAcEUFund.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKey ELSE GlAcEUFund.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'EU Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcEUFund ON MaGlAcEUFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcEUFund ON MiGlAcEUFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcEUFund ON GlAcEUFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey BETWEEN GlAcEUFund.StartDate AND GlAcEUFund.EndDate
	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
Update #ProfitabilityBudget
SET	USPropertyGlAccountCategoryKey = CASE WHEN GlAcUSProp.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKey ELSE GlAcUSProp.GlAccountCategoryKey END
From #ProfitabilityBudget Gl
		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Property')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSProp ON MaGlAcUSProp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSProp ON MiGlAcUSProp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSProp ON GlAcUSProp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSProp.StartDate AND GlAcUSProp.EndDate

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
Update #ProfitabilityBudget
SET	USCorporateGlAccountCategoryKey = CASE WHEN GlAcUSCorp.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKey ELSE GlAcUSCorp.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Corporate')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSCorp ON MaGlAcUSCorp.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSCorp ON MiGlAcUSCorp.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSCorp ON GlAcUSCorp.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSCorp.StartDate AND GlAcUSCorp.EndDate


PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--USFundGlAccountCategoryKey
Update #ProfitabilityBudget
SET	USFundGlAccountCategoryKey = CASE WHEN GlAcUSFund.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKey ELSE GlAcUSFund.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'US Fund')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcUSFund ON MaGlAcUSFund.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcUSFund ON MiGlAcUSFund.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcUSFund ON GlAcUSFund.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcUSFund.StartDate AND GlAcUSFund.EndDate

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

		
--GlobalGlAccountCategoryKey
Update #ProfitabilityBudget
SET	GlobalGlAccountCategoryKey = CASE WHEN GlAcGlobal.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKey ELSE GlAcGlobal.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Global')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcGlobal ON MaGlAcGlobal.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcGlobal ON MiGlAcGlobal.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)




--DevelopmentGlAccountCategoryKey
Update #ProfitabilityBudget
SET	DevelopmentGlAccountCategoryKey = CASE WHEN GlAcDevel.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKey ELSE GlAcDevel.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

		INNER JOIN GrReporting.dbo.GlAccount Gla ON Gla.GlAccountKey = Gl.GlAccountKey
		
		LEFT OUTER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = Gla.GlobalGlAccountId  
						AND GlAcH.IsDeleted = 0
						AND GlAcH.GlobalGlAccountCategoryHierarchyGroupId = (Select GlobalGlAccountCategoryHierarchyGroupId From #GlobalGlAccountCategoryHierarchyGroup Where Name = 'Development')
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAcDevel ON MaGlAcDevel.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAcDevel ON MiGlAcDevel.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcDevel ON GlAcDevel.GlobalGlAccountCategoryCode = 
				LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
						LTRIM(STR(GlAcH.MajorGlAccountCategoryId,10,0))+':'+
						LTRIM(STR(GlAcH.MinorGlAccountCategoryId,10,0))
				AND Gl.CalendarKey  BETWEEN GlAcDevel.StartDate AND GlAcDevel.EndDate

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityBudget

PRINT 'Rows Inserted into #DeletingBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	-- Remove old facts
	DELETE 
	FROM GrReporting.dbo.ProfitabilityBudget 
	Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
	PRINT 'Rows Deleted from ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT 'Rows Deleted from #DeletingBudget:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print 'Cleaned up rows in ProfitabilityBudget'


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget


PRINT 'Rows Inserted into ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityBudget
-- Account Category Mapping
DROP TABLE #GlobalGlAccountCategoryHierarchy
DROP TABLE #GlobalGlAccountCategoryHierarchyGroup
DROP TABLE #MajorGlAccountCategory
DROP TABLE #MinorGlAccountCategory


GO

