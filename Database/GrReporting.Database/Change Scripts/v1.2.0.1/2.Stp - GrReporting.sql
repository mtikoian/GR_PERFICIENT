/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 12/29/2009 11:20:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_Profitability]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_Profitability]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_Profitability]    Script Date: 12/29/2009 11:20:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[stp_R_Profitability]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,

	@FunctionalDepartmentList TEXT = NULL,
	@ActivityTypeList TEXT = NULL,
	@EntityList TEXT = NULL,
	@MajorAccountCategoryList TEXT = NULL,
	@MinorAccountCategoryList TEXT = NULL,
	@AllocationRegionList TEXT = NULL,
	@AllocationSubRegionList TEXT = NULL,
	@OriginatingRegionList TEXT = NULL,
	@OriginatingSubRegionList TEXT = NULL
AS

/*
DECLARE @ReportExpensePeriod  AS INT,
        @DestinationCurrency  AS VARCHAR(3),
        @HierarchyName        VARCHAR(50),
        @ActivityType         VARCHAR(50),
        @Entity               VARCHAR(100),
        @@AllocationSubRegion     VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @DestinationCurrency = 'USD'
SET @HierarchyName = 'Global'
SET @ActivityType = NULL
SET @Entity = NULL
SET @AllocationSubRegion = NULL

--EXEC stp_R_Profitability
--	@ReportExpensePeriod = 201011,
--	@DestinationCurrency = 'USD',
--	@HierarchyName = 'Global',
--	@ActivityType = null,
--	@Entity = 'Aldgate',
--	@AllocationSubRegion = NULL
*/

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Variable defaults		*/
--------------------------------------------------------------------------

IF @ReportExpensePeriod IS NULL
	SET @ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + CAST(MONTH(GETDATE()) AS VARCHAR(2))AS INT)

IF @DestinationCurrency IS NULL
	SET @DestinationCurrency = 'USD'

IF 	@HierarchyName IS NULL
	SET @HierarchyName = 'Global'

	DECLARE @CalendarYear AS INT
	SET @CalendarYear = CAST(SUBSTRING(CAST(@ReportExpensePeriod AS VARCHAR(10)), 1, 4) AS INT)				

--------------------------------------------------------------------------
/*	COMMON Block to setup the Report Filter Tables		*/
--------------------------------------------------------------------------
	
	CREATE TABLE	#EntityFilterTable	(Name Varchar(100) NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(Name Varchar(100) NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(Name VARCHAR(100) NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(Name Varchar(100) NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(Name Varchar(100) NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(Name VARCHAR(100) NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(Name VARCHAR(100) NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(Name Varchar(100) NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(Name Varchar(100) NOT NULL)	
		
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select item From dbo.Split(@EntityList)
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select item From dbo.Split(@FunctionalDepartmentList)
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT item FROM dbo.Split(@ActivityTypeList)
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select item From dbo.Split(@AllocationRegionList)
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select item From dbo.Split(@AllocationSubRegionList)
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select item From dbo.Split(@MajorAccountCategoryList)
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT item FROM dbo.Split(@MinorAccountCategoryList)
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select item From dbo.Split(@OriginatingRegionList)
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select item From dbo.Split(@OriginatingSubRegionList)
	END		
--------------------------------------------------------------------------
/*	COMMON END															*/
--------------------------------------------------------------------------
IF 	OBJECT_ID('tempdb..#ProfitabilityBudgetGlAccountCategoryBridgeTemp') IS NOT NULL
    DROP TABLE #ProfitabilityBudgetGlAccountCategoryBridgeTemp



IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
    DROP TABLE #ProfitabilityReport

CREATE TABLE #ProfitabilityReport
(
	ExpenseType                 VARCHAR(50),
	FeeOrExpense				VARCHAR(50),
	MajorName					VARCHAR(100),
	MinorName					VARCHAR(100),
	ActivityTypeName			VARCHAR(50),
	PropertyFundName			VARCHAR(100),
	AllocationSubRegionName		VARCHAR(50),
	ConvertedActual				MONEY,
	NetActual					MONEY,
	ConvertedBudget				MONEY,
	NetBudget					MONEY,
	YTD							MONEY,
	NetYTD						MONEY
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)


SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 
	gac.ExpenseType,
	gac.FeeOrExpense,
    gac.MajorName,
    gac.MinorName,
    a.ActivityTypeName,
    pf.PropertyFundName,
    ar.SubRegionName AS AllocationSubRegionName,
    (pa.LocalActual * er.Rate * -1) AS ConvertedActual, -- Expenses must be displayed as negative an Income is saved in MRI as negative
    (pa.LocalActual * er.Rate * r.MultiplicationFactor * -1) AS NetActual,
    NULL AS ConvertedBudget,
    NULL AS NetBudget,
    (CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
				pa.LocalActual
			ELSE
				0
			END) * er.Rate * -1 as YTD,
	(CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
				pa.LocalActual
			ELSE
				0
			END) * er.Rate * -1 * r.MultiplicationFactor as NetYTD
FROM
	ProfitabilityActual pa
    INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
		) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey
		
    INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey
    INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  dc.CurrencyKey = er.DestinationCurrencyKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey

WHERE  1 = 1
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentName IN (Select Name From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeName IN (Select Name From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundName IN (Select Name From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.RegionName IN (Select Name From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.SubRegionName IN (Select Name From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.MajorName IN (Select Name From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.MinorName IN (Select Name From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.RegionName IN (Select Name From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.SubRegionName IN (Select Name From #OriginatingSubRegionFilterTable)' END +
'
')
	
EXEC (@cmdString)

SET @cmdString = (Select '

INSERT INTO #ProfitabilityReport
SELECT 
	gac.ExpenseType,
	gac.FeeOrExpense,
    gac.MajorName,
    gac.MinorName,
    a.ActivityTypeName,
    pf.PropertyFundName,
    ar.SubRegionName AS AllocationSubRegionName,
    NULL AS ConvertedActual,
    NULL AS NetActual,
    (pb.LocalBudget * er.Rate * -1) AS ConvertedActual,  -- Expenses must be displayed as negative an Income is saved in MRI as negative
    (pb.LocalBudget * er.Rate * r.MultiplicationFactor * -1) AS NetActual,
	NULL as YTD,
	NULL as NetYTD
FROM
	ProfitabilityBudget pb

    INNER JOIN (
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
    ) pbgacb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey
		
    INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
    INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey
    INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey
    INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey
    INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey
    INNER JOIN ActivityType a ON a.ActivityTypeKey = pb.ActivityTypeKey
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey

WHERE  1 = 1
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentName IN (Select Name From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeName IN (Select Name From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundName IN (Select Name From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.RegionName IN (Select Name From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.SubRegionName IN (Select Name From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.MajorName IN (Select Name From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.MinorName IN (Select Name From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.RegionName IN (Select Name From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.SubRegionName IN (Select Name From #OriginatingSubRegionFilterTable)' END +
'
')
	
EXEC (@cmdString)

SELECT 
	ExpenseType, 
	FeeOrExpense,
    MajorName [Major Expense Category],
    MinorName [Minor Expense Category],
    --MajorName [Account Category],
    ActivityTypeName [Activity],
	PropertyFundName [Entity],
	AllocationSubRegionName [Allocation Sub Region],
    SUM(ISNULL(ConvertedActual, 0)) AS ConvertedActual,
    SUM(ISNULL(NetActual, 0)) AS NetActual,
    SUM(ISNULL(ConvertedBudget, 0)) AS ConvertedBudget,
    SUM(ISNULL(NetBudget, 0)) AS NetBudget,
    SUM(ISNULL(ConvertedBudget, 0) - ISNULL(ConvertedActual, 0)) AS GrossVariance,
    SUM(ISNULL(NetBudget, 0) - ISNULL(NetActual, 0)) AS NetVariance,
    SUM(ISNULL(YTD, 0)) AS YTD,
    SUM(ISNULL(NetYTD, 0)) AS NetYTD
FROM
	#ProfitabilityReport
GROUP BY
    ExpenseType,
    FeeOrExpense,
    MajorName,
    MinorName,
    ActivityTypeName,
    PropertyFundName,
    AllocationSubRegionName
ORDER BY
	CASE WHEN FeeOrExpense = 'INCOME' THEN 1 WHEN FeeOrExpense = 'EXPENSE' THEN 2 ELSE 3 END
	
IF 	OBJECT_ID('tempdb..#ProfitabilityReport') IS NOT NULL
    DROP TABLE #ProfitabilityReport





GO


