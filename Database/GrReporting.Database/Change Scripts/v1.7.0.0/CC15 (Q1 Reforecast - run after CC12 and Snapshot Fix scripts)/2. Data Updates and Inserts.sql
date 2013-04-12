 /*

1. Add 'Global Budgeting' to GrReporting.dbo.SourceSystem

*/

-- 1: BEGIN -----------------------------------------------------------------------------------------------------------

USE GrReporting
GO

IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE Name = 'Global Reporting')
BEGIN
	
	DECLARE @NextSourceSystemId INT = ISNULL((SELECT MAX(SourceSystemId) FROM dbo.SourceSystem), 0) + 1
	
	INSERT INTO dbo.SourceSystem (
		SourceSystemId,
		Name
	)
	SELECT
		@NextSourceSystemId AS SourceSystemId,
		'Global Reporting' AS Name

	PRINT ('Source system "Global Reporting" inserted into dbo.SourceSystem')

END
ELSE
BEGIN
	PRINT ('Cannot insert source system "Global Reporting" into dbo.SourceSystem as it already exists.')
END

GO

-- 1: END -----------------------------------------------------------------------------------------------------------
















------------------------------------------------------------------------------------------------------------------------------------------------
--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 2010 Data Migration ||||||||||||||||||||||||||||||||||||||||||||||||||||||||--
------------------------------------------------------------------------------------------------------------------------------------------------


 USE GrReporting
 GO
 
 IF OBJECT_ID('tempdb..#LoadPayrollActualsToReforecast') IS NOT NULL
	DROP PROCEDURE #LoadPayrollActualsToReforecast
 GO
 
 CREATE PROCEDURE #LoadPayrollActualsToReforecast
	@ReforecastQuarter VARCHAR(2)
	
 AS
 
 DECLARE @ReforecastKey INT = (SELECT TOP 1 ReforecastKey FROM Reforecast WHERE ReforecastQuarterName = @ReforecastQuarter AND ReforecastEffectiveYear = 2010 ORDER BY ReforecastEffectivePeriod ASC)
 DECLARE @QuarterStartPeriod INT = (SELECT TOP 1 ReforecastEffectivePeriod FROM Reforecast WHERE ReforecastQuarterName = @ReforecastQuarter AND ReforecastEffectiveYear = 2010 ORDER BY ReforecastEffectivePeriod ASC)
 DECLARE @SourceSystemId INT = (SELECT TOP 1 SourceSystemId FROM SourceSystem WHERE [Name] = 'Global Reporting')
 DECLARE @FeeAdjustmentKey INT = (SELECT TOP 1 FeeAdjustmentKey FROM FeeAdjustment WHERE FeeAdjustmentCode = 'NORMAL')
 DECLARE @BudgetReforecastTypeKey INT = (SELECT TOP 1 BudgetReforecastTypeKey FROM BudgetReforecastType WHERE BudgetReforecastTypeCode = 'TGBACT')

 
 IF NOT EXISTS (	
					SELECT * 
					FROM ProfitabilityReforecast PR 
						INNER JOIN GlAccountCategory GAC 
							ON PR.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey 
					WHERE PR.ReforecastKey = @ReforecastKey 
						AND GAC.MajorCategoryName IN ('Salaries/Taxes/Benefits', 'General Overhead') 
						AND pr.BudgetReforecastTypeKey=@BudgetReforecastTypeKey
				)
 BEGIN
 
 INSERT INTO dbo.ProfitabilityReforecast
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
	EUCorporateGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	BudgetId,
	SourceSystemId,
	OverheadKey,
	FeeAdjustmentKey,
	SnapshotId,
	BudgetReforecastTypeKey
 )
 SELECT
	PA.CalendarKey,
	@ReforecastKey AS ReforecastKey,
	PA.GlAccountKey,
	PA.SourceKey,
	PA.FunctionalDepartmentKey,
	PA.ReimbursableKey,
	PA.ActivityTypeKey,
	PA.PropertyFundKey,
	PA.AllocationRegionKey,
	PA.OriginatingRegionKey,
	PA.LocalCurrencyKey,
	PA.LocalActual AS LocalReforecast,
	('TGB:ProfitabilityActualKey=' + RTRIM(LTRIM(STR(PA.ProfitabilityActualKey))) + '&Quarter=' + @ReforecastQuarter) AS ReferenceCode,
	PA.EUCorporateGlAccountCategoryKey,
	PA.USPropertyGlAccountCategoryKey,
	PA.USFundGlAccountCategoryKey,
	PA.EUPropertyGlAccountCategoryKey,
	PA.USCorporateGlAccountCategoryKey,
	PA.DevelopmentGlAccountCategoryKey,
	PA.EUFundGlAccountCategoryKey,
	PA.GlobalGlAccountCategoryKey,
	CASE @ReforecastQuarter
		WHEN 'Q1' THEN 2
		WHEN 'Q2' THEN 3
		WHEN 'Q3' THEN 4
	END AS BudgetId,
	@SourceSystemId AS SourceSystemId,
	PA.OverheadKey,
	@FeeAdjustmentKey AS FeeAdjustmentKey,
	0 AS SnapshotId,
	@BudgetReforecastTypeKey
	
	FROM ProfitabilityActual PA
		INNER JOIN GlAccountCategory GAC
			ON PA.GlobalGlAccountCategoryKey = GAC.GlAccountCategoryKey
		INNER JOIN Calendar C
			ON PA.CalendarKey = C.CalendarKey
			
	WHERE 
		C.CalendarPeriod >= 201001
		AND C.CalendarPeriod < @QuarterStartPeriod
		AND GAC.MajorCategoryName IN ('Salaries/Taxes/Benefits', 'General Overhead')

PRINT 'Actual amounts for ' + @ReforecastQuarter + ' inserted into the ProfitabilityReforecast table'
END
ELSE
PRINT 'Actual amounts for ' + @ReforecastQuarter + ' already exist in the ProfitabilityReforecast table'

GO

--Q1
EXEC #LoadPayrollActualsToReforecast N'Q1';
GO

--Q2
EXEC #LoadPayrollActualsToReforecast N'Q2';
GO

--Q3
EXEC #LoadPayrollActualsToReforecast N'Q3';
GO

IF OBJECT_ID('tempdb..#LoadPayrollActualsToReforecast') IS NOT NULL
	DROP PROCEDURE #LoadPayrollActualsToReforecast
GO