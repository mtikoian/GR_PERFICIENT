 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,
	@IsGross bit = 1,
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
 
-- TODO: Remove test
/*
DECLARE @ReportExpensePeriod   INT,
        @DestinationCurrency   VARCHAR(3),
        @MajorGlAccountCategoryList VARCHAR(8000),
        @HierarchyName         VARCHAR(50)

SET @ReportExpensePeriod = 201002
SET @DestinationCurrency = 'USD'
SET @MajorGlAccountCategoryList = 'Salaries/Taxes/Benefits,Occupancy Costs'
SET @HierarchyName = 'Global'
*/ 
/*
EXEC stp_R_ExpenseCzarTotalComparison
	@ReportExpensePeriod = 201002,
	@DestinationCurrency = 'USD',
	@MajorGlAccountCategoryList = 'Salaries/Taxes/Benefits|Occupancy Costs',
	@HierarchyName = 'Global'
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
	
 
 -- Combine budget and actual values
IF OBJECT_ID('tempdb..#TotalComparison') IS NOT NULL
    DROP TABLE #TotalComparison

CREATE TABLE #TotalComparison
(
	ExpenseType              VARCHAR(50),
	HierarchyName            VARCHAR(50),
	MajorName                VARCHAR(100),
	MinorName                VARCHAR(100),
	CalendarPeriod           INT,
	MtdGrossBudget           MONEY,
	MtdGrossActual           MONEY,
	MtdNetBudget			 MONEY,
	MtdNetActual			 MONEY,
	YtdGrossBudget           MONEY,
	YtdGrossActual           MONEY,
	YtdNetBudget			 MONEY,
	YtdNetActual			 MONEY,
	AnualGrossBudget		 MONEY,
	AnualEstGrossActual      MONEY,
	AnualNetBudget			 MONEY,
	AnualEstNetActual		 MONEY
)


CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)


SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select '
INSERT INTO #TotalComparison
SELECT 
	gac.Expensetype,
    gac.HierarchyName,
    gac.MajorName,
    gac.MinorName,
    c.CalendarPeriod,
    NULL as MtdGrossBudget,
    (
		(
			er.Rate *
			CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN
				pa.LocalActual
			ELSE
				0
			END
		)
	) as MtdGrossActual,
	NULL as MtdNetBudget,
    (
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'' AND c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pa.LocalActual
            ELSE 
				0
            END
        )
    ) as MtdNetActual,
    NULL as YtdGrossBudget,
    (
		(
			er.Rate *
			CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
				pa.LocalActual
			ELSE
				0
			END
		)
		
	) as YtdGrossActual,
	NULL as YtdNetBudget,
	(
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'' AND c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pa.LocalActual
            ELSE 
				0
            END
        )
    ) as YtdNetActual,
	NULL as AnualGrossBudget,
	(
            er.Rate *
            CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pa.LocalActual
            ELSE 
				0
            END
	) as AnualEstGrossActual,
	NULL as AnualNetBudget,
	(
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'' AND c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pa.LocalActual
            ELSE 
				0
            END
        )
    ) as AnualEstNetActual
    
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
	' +	
		
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '
		
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
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
print @cmdString
EXEC (@cmdString)


SET @cmdString = (Select '
INSERT INTO #TotalComparison
SELECT 
	gac.Expensetype,
    gac.HierarchyName,
    gac.MajorName,
    gac.MinorName,
    c.CalendarPeriod,
    (
		(
			er.Rate *
			CASE WHEN (c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN
				pb.LocalBudget
			ELSE
				0
			END
		)
	) as MtdGrossBudget,
    NULL as MtdGrossActual,
	(
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'' AND c.CalendarPeriod = '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pb.LocalBudget
            ELSE 
				0
            END
        )
    ) as MtdNetBudget,
    NULL as MtdNetActual,
    (
		(
			er.Rate *
			CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
				pb.LocalBudget
			ELSE
				0
			END
		)
	) as YtdGrossBudget,
    NULL as YtdGrossActual,
	(
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'' AND c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pb.LocalBudget
            ELSE 
				0
            END
        )
    ) as YtdNetBudget,
	NULL as YtdNetActual,
	(
		(
			er.Rate * pb.LocalBudget
		)
	) as AnualGrossBudget,
	(
		(
			er.Rate *
			CASE WHEN (c.CalendarPeriod > '+STR(@ReportExpensePeriod,10,0)+') THEN
				pb.LocalBudget
			ELSE
				0
			END
		)
	) as AnualEstGrossActual,
	(
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'') THEN 
				pb.LocalBudget
            ELSE 
				0
            END
        )
    ) as AnualNetBudget,
	(
        (
            er.Rate *
            CASE WHEN (r.ReimbursableCode = ''NO'' AND c.CalendarPeriod > '+STR(@ReportExpensePeriod,10,0)+') THEN 
				pb.LocalBudget
            ELSE 
				0
            END
        )
    ) as AnualEstNetActual
    
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

	' +	
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
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

print @cmdString
EXEC (@cmdString)


-- Return results
SELECT
	ExpenseType,
	HierarchyName as [Account Category Mapping],
    MajorName as [Major Account Category],
    MinorName as [Minor Account Category],
    CalendarPeriod as [Expense Period],
	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) ELSE ISNULL(MtdNetBudget,0) END) AS [MTD Original Budget],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetActual,0) END) AS [MTD Actual],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(MtdGrossBudget,0) - ISNULL(MtdGrossActual,0) ELSE ISNULL(MtdNetBudget,0) - ISNULL(MtdNetActual,0) END) AS [MTD Variance],
	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) ELSE ISNULL(YtdNetBudget,0) END) AS [YTD Original Budget],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetActual,0) END) AS [YTD Actual],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(YtdGrossBudget,0) - ISNULL(YtdGrossActual,0) ELSE ISNULL(YtdNetBudget,0) - ISNULL(YtdNetActual,0) END) AS [YTD Variance],
	
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnualGrossBudget,0) ELSE ISNULL(AnualNetBudget,0) END) AS [Anual Budget],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnualEstGrossActual,0) ELSE ISNULL(AnualEstNetActual,0) END) AS [Anual Estimated Actual],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(AnualGrossBudget,0) - ISNULL(AnualEstGrossActual,0) ELSE ISNULL(AnualNetBudget,0) - ISNULL(AnualEstNetActual,0) END) AS [Anual Estimaged Variance],
	
	MajorName as [Major Account Category Display]
FROM
	#TotalComparison
GROUP BY
	ExpenseType,
	HierarchyName,
    MajorName,
    MinorName,
    CalendarPeriod



 GO
/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarDetail]    Script Date: 12/21/2009 12:45:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarDetail]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarDetail]    Script Date: 12/21/2009 12:45:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_R_ExpenseCzarDetail]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,
	@IsGross bit = 1,
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
	DECLARE @ReportExpensePeriod   INT,
	@AccountCategoryList   VARCHAR(8000),
	@DestinationCurrency   VARCHAR(3),
	@HierarchyName         VARCHAR(50),
	@FunctionalDepartmentList VARCHAR(8000),
	@AllocationRegionList VARCHAR(8000),
	@EntityList VARCHAR(8000)
	
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = 'IT Costs & Telecommunications'
	SET @DestinationCurrency ='USD'
	SET @HierarchyName = 'Global'
	SET @FunctionalDepartmentList = 'Information Technologies'
	SET @AllocationRegionList = NULL
	SET @EntityList = NULL
	
EXEC stp_R_ExpenseCzarDetail
		@ReportExpensePeriod = 201011,
		@AccountCategoryList = 'IT Costs & Telecommunications|Legal & Professional Fees|Marketing',
		@DestinationCurrency = 'USD',
		@HierarchyName = 'Global',
		@FunctionalDepartmentList = 'Information Technology',
		@AllocationRegionList = null,
		@EntityList = NULL,
		@MinorAccountCategoryList = 'Architects & Engineering|Legal - Immigration',
		@ActivityTypeList = 'Corporate Overhead|Corporate'
	
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

IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
    DROP TABLE #ExpenseCzarTotalComparisonDetail

CREATE TABLE #ExpenseCzarTotalComparisonDetail
(
	GlAccountCategoryKey	Int,
    FunctionalDepartmentKey	Int,
    AllocationRegionKey		Int,
    PropertyFundKey			Int,
	GrossActual             MONEY,
	NetActual               MONEY,
	GrossBudget				MONEY,
	NetBudget               MONEY
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)


SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select '
	
	INSERT INTO #ExpenseCzarTotalComparisonDetail
	SELECT 
		pagacb.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey,
	    SUM(er.Rate * pa.LocalActual) AS GrossActual,
	    SUM(er.Rate * pa.LocalActual * r.MultiplicationFactor) AS NetActual,
	    NULL AS GrossBudget,
	    NULL AS NetBudget
	FROM
		ProfitabilityActual pa
		INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey ' ELSE '' END +
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '

	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
			
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
	Group By
		pagacb.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey
')
print @cmdString
EXEC (@cmdString)


SET @cmdString = (Select '	

	INSERT INTO #ExpenseCzarTotalComparisonDetail
	SELECT 
		pbgacb.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey,
	    NULL AS GrossActual,
	    NULL AS NetActual,
	    SUM(er.Rate * pb.LocalBudget) AS GrossBudget,
	    SUM(er.Rate * pb.LocalBudget * r.MultiplicationFactor) AS NetBudget
	FROM
		ProfitabilityBudget pb
		INNER JOIN (
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey ' ELSE '' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
		
	    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
	    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey
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
	Group By
		pbgacb.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey
	    ')

print @cmdString
EXEC (@cmdString)

CREATE CLUSTERED INDEX IX ON #ExpenseCzarTotalComparisonDetail(PropertyFundKey,AllocationRegionKey,FunctionalDepartmentKey,GlAccountCategoryKey)

	SELECT 

		gac.ExpenseType,
		gac.MajorName [Major Expense Category],
	    gac.MinorName [Minor Expense Category],
	    fd.FunctionalDepartmentName [Functional Department],
	    fd.FunctionalDepartmentName [Functional Department Filter],
	    ar.SubRegionName [Allocation Sub Region],
	    ar.SubRegionName [Allocation Sub Region Filter],
	    pf.PropertyFundName [Entity],
	    SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossActual, 0) ELSE ISNULL(NetActual, 0) END) AS [YTDActual],
	    SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) ELSE ISNULL(NetBudget, 0) END) AS [YTDOriginalBudget],
	    SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS [Variance]
	FROM
		#ExpenseCzarTotalComparisonDetail res
				INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
				INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
				INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
				INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
		
	GROUP BY
		gac.ExpenseType,
		gac.MajorName,
	    gac.MinorName,
	    fd.FunctionalDepartmentName,
	    ar.SubRegionName,
	    pf.PropertyFundName
	
	IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
	    DROP TABLE #ExpenseCzarTotalComparisonDetail


GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 12/14/2009 11:40:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 12/14/2009 11:40:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_R_ExpenseCzar]
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
	DECLARE @ReportExpensePeriod	AS INT,
	@AccountCategoryList	AS TEXT,
	@DestinationCurrency	AS VARCHAR(3),
	@HierarchyName			VARCHAR(50)
	
	SET @ReportExpensePeriod = 201011
	SET @AccountCategoryList = 'IT Costs & Telecommunications|Legal & Professional Fees|Marketing'
	SET @DestinationCurrency ='USD'
	SET @HierarchyName = 'Global'
	
[dbo].[stp_R_ExpenseCzar]
	@ReportExpensePeriod = 201011,
	@AccountCategoryList = 'IT Costs & Telecommunications|Legal & Professional Fees|Marketing',
	@MinorAccountCategoryList = 'Architects & Engineering|Legal - Immigration',
	@DestinationCurrency = 'USD',
	@HierarchyName = 'Global',
	@ActivityTypeList = 'Corporate Overhead|Corporate'


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
		
	CREATE TABLE #ExpenseCzar
	(
		GlAccountCategoryKey		Int,
		AllocationRegionKey			Int,
		FunctionalDepartmentKey		Int,
		PropertyFundKey				Int,
		CalendarPeriod				INT,
		ConvertedActual				MONEY,
		NetActual					MONEY,
		ConvertedBudget				MONEY,
		NetBudget					MONEY
	)
	
CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)


SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select '

INSERT INTO #ExpenseCzar
SELECT 
	pagacb.GlAccountCategoryKey,
	pa.AllocationRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    c.CalendarPeriod,
    SUM(er.Rate * pa.LocalActual) AS ConvertedActual,
    SUM(er.Rate * r.MultiplicationFactor * pa.LocalActual) AS NetActual,
    NULL AS ConvertedBudget,
    NULL AS NetBudget
FROM
	ProfitabilityActual pa
    INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey' +	
    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey ' ELSE '' END +
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '
    
    INNER JOIN ExchangeRate er ON  
		er.SourceCurrencyKey = pa.LocalCurrencyKey AND
		er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON  
		er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  
		c.CalendarKey = pa.CalendarKey
    INNER JOIN Reimbursable r ON  
		r.ReimbursableKey = pa.ReimbursableKey
		
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
	Group By
		pagacb.GlAccountCategoryKey,
		pa.AllocationRegionKey,
		pa.FunctionalDepartmentKey,
		pa.PropertyFundKey,
		c.CalendarPeriod

	
')
print @cmdString
EXEC (@cmdString)

SET @cmdString = (Select '
INSERT INTO #ExpenseCzar
SELECT 
	pbgacb.GlAccountCategoryKey,
	pb.AllocationRegionKey,
	pb.FunctionalDepartmentKey,
	pb.PropertyFundKey,
	c.CalendarPeriod,
    NULL AS ConvertedActual,
    NULL AS NetActual,
    SUM(er.Rate * pb.LocalBudget) AS ConvertedBudget,
    SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) AS NetBudget
FROM
	ProfitabilityBudget pb
    INNER JOIN (
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey ' ELSE '' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
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
	Group By
			pbgacb.GlAccountCategoryKey,
			pb.AllocationRegionKey,
			pb.FunctionalDepartmentKey,
			pb.PropertyFundKey,
			c.CalendarPeriod
')
print @cmdString
EXEC (@cmdString)


SELECT 

	gac.ExpenseType,
	ar.RegionName,
    fd.FunctionalDepartmentName,
    gac.MajorName,
    gac.MinorName,
    pf.PropertyFundName,

    SUM(ISNULL(ConvertedActual, 0)) AS ConvertedActual,
    SUM(ISNULL(NetActual, 0)) AS NetActual,
    SUM(ISNULL(ConvertedBudget, 0)) AS ConvertedBudget,
    SUM(ISNULL(NetBudget, 0)) AS NetBudget,
    SUM(ISNULL(ConvertedBudget, 0) - ISNULL(ConvertedActual, 0)) AS GrossVariance,
    SUM(ISNULL(NetBudget, 0) - ISNULL(NetActual, 0)) AS NetVariance
FROM
	#ExpenseCzar res
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
GROUP BY
	gac.ExpenseType,
	ar.RegionName,
    fd.FunctionalDepartmentName,
    gac.MajorName,
    gac.MinorName,
    pf.PropertyFundName



	IF 	OBJECT_ID('tempdb..#AccountCategoryFilterTable') IS NOT NULL
	    DROP TABLE #AccountCategoryFilterTable
	    
	IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
	    DROP TABLE #ActivityTypeFilterTable
	    
	IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL
		DROP TABLE #MinorAccountCategoryFilterTable

	IF 	OBJECT_ID('tempdb..#ExpenseCzar') IS NOT NULL
	    DROP TABLE #ExpenseCzar
GO
/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 12/21/2009 12:46:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 12/21/2009 12:46:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,
	@IsGross bit = 1,
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
DECLARE @ReportExpensePeriod		AS INT,
        @FunctionalDepartmentList  AS VARCHAR(8000),
        @DestinationCurrency		AS VARCHAR(3),
        @HierarchyName				VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @FunctionalDepartmentList = 'Information Technologies'
SET @DestinationCurrency = 'USD'
SET @HierarchyName = 'Global'

--EXEC stp_R_BudgetOriginatorOwnerFunctionalDepartment
--	@ReportExpensePeriod = 201011,
--	@FunctionalDepartmentList = 'Information Technologies',
--	@DestinationCurrency = 'USD',
--	@HierarchyName = 'Global'
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
	
IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwner') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner

CREATE TABLE #BudgetOriginatorOwner
(
	AllocationRegionKey		Int,
	OriginatingRegionKey	INT,
    PropertyFundKey			Int,
    FunctionalDepartmentKey Int,
	GlAccountCategoryKey	Int,
	GrossActual             MONEY,
	NetActual               MONEY,
	GrossBudget             MONEY,
	NetBudget               MONEY
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)

SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select '

INSERT INTO #BudgetOriginatorOwner
SELECT 
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	pagacb.GlAccountCategoryKey,
    SUM(er.Rate * pa.LocalActual) AS GrossActual,
    SUM(r.MultiplicationFactor * er.Rate * pa.LocalActual) AS NetActual,
    NULL AS GrossBudget,
    NULL AS NetBudget
FROM
	ProfitabilityActual pa
    INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey' +	
		
    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey ' ELSE '' END +
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '

    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey

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
Group By
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	pagacb.GlAccountCategoryKey


	')
print @cmdString
EXEC (@cmdString)


SET @cmdString = (Select '

INSERT INTO #BudgetOriginatorOwner
SELECT 
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	pbgacb.GlAccountCategoryKey,
    NULL AS GrossActual,
    NULL AS NetActual,
    SUM(er.Rate * pb.LocalBudget) AS GrossBudget,
    SUM(r.MultiplicationFactor * er.Rate * pb.LocalBudget) AS NetBudget
FROM
	ProfitabilityBudget pb
    INNER JOIN (
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey ' ELSE '' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
		
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
WHERE  1 = 1 
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
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
Group By
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	pbgacb.GlAccountCategoryKey')

print @cmdString
EXEC (@cmdString)
  
--Functional Department Mode
SELECT 
	gac.ExpenseType,
	ar.RegionName AS [Allocation Region],
    ar.SubRegionName AS [Allocation Sub Region],
    ar.SubRegionName AS [Allocation Sub Region Filter],
    orr.RegionName AS [Originating Region],
    orr.SubRegionName AS [Originating Sub Region],
    orr.SubRegionName AS [Originating Sub Region Filter],
	gac.MajorName AS [Major Expense Category],
	gac.MinorName AS [Minor Expense Category],
	pf.PropertyFundName AS [Entity],
	fd.FunctionalDepartmentName as [Functional Department],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossActual, 0) ELSE ISNULL(NetActual, 0) END) AS Actual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) ELSE ISNULL(NetBudget, 0) END) AS Budget,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS Variance
FROM
	#BudgetOriginatorOwner res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
GROUP BY
	gac.ExpenseType,
	ar.RegionName,
    ar.SubRegionName, 
    orr.RegionName,
    orr.SubRegionName,
	gac.MajorName,
	gac.MinorName,
	pf.PropertyFundName,
	fd.FunctionalDepartmentName
	
IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwner') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner




GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 12/21/2009 12:46:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 12/21/2009 12:46:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,
	@IsGross bit = 1,
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
DECLARE @ReportExpensePeriod		AS INT,
        @DestinationCurrency		AS VARCHAR(3),
        @HierarchyName				VARCHAR(50)
				
SET @ReportExpensePeriod = 201011
SET @DestinationCurrency = 'USD'
SET @EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
SET @HierarchyName = 'Global'

--EXEC stp_R_BudgetOriginatorOwnerEntity
--	@ReportExpensePeriod = 201011,
--	@DestinationCurrency = 'USD',
--	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)',
--	@HierarchyName = 'Global'
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
	

IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwnerEntity') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

CREATE TABLE #BudgetOriginatorOwnerEntity
(
    GlAccountCategoryKey		Int,
    AllocationRegionKey			Int,
    OriginatingRegionKey		Int,
    FunctionalDepartmentKey		Int,
    PropertyFundKey				INT,
	GrossActual					MONEY,
	NetActual					MONEY,
	GrossBudget					MONEY,
	NetBudget					MONEY
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString	Varchar(8000)

SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)

SET @cmdString = (Select '

INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
    pagacb.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    SUM(er.Rate * pa.LocalActual) AS GrossActual,
    SUM(r.MultiplicationFactor * er.Rate * pa.LocalActual) AS NetActual,
    NULL AS GrossBudget,
    NULL AS NetBudget
FROM
	ProfitabilityActual pa
	
    INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey ' +	
    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey ' ELSE '' END +
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '
	
    INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pa.CalendarKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
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
Group by
    pagacb.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey

')
	
print @cmdString
EXEC (@cmdString)

SET @cmdString = (Select '
INSERT INTO #BudgetOriginatorOwnerEntity
SELECT 
    pbgacb.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    NULL AS GrossActual,
    NULL AS NetActual,
    SUM(er.Rate * pb.LocalBudget) AS GrossBudget,
    SUM(r.MultiplicationFactor * er.Rate * pb.LocalBudget) AS NetBudget
FROM
	ProfitabilityBudget pb
    INNER JOIN (
				
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey ' +	
    
    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey ' ELSE '' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
	
	INNER JOIN ExchangeRate er ON  er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
    INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey
    INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey

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
	Group By
    pbgacb.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey
')
	
print @cmdString
EXEC (@cmdString)
  
--Entity Mode
SELECT 
    gac.ExpenseType,
    ar.RegionName AS [Allocation Region],
    ar.SubRegionName AS [Allocation Sub Region],
    ar.SubRegionName AS [Allocation Sub Region Filter],
    orr.RegionName AS [Originating Region],
    orr.SubRegionName AS [Originating Sub Region],
    orr.SubRegionName AS [Originating Sub Region Filter],
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is curtail that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorName = 'Salaries/Taxes/Benefits') THEN 'Payroll' ELSE fd.FunctionalDepartmentName END [Functional Department],
    gac.MajorName [Major Expense Category],
    gac.MinorName [Minor Expense Category],
    pf.PropertyFundName [Entity],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossActual, 0) ELSE ISNULL(NetActual, 0) END) AS Actual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) ELSE ISNULL(NetBudget, 0) END) AS Budget,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS Variance
FROM
	#BudgetOriginatorOwnerEntity res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
GROUP BY
    gac.ExpenseType,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    --NB!!!!!!!
    --The roll up to payroll is very sensitive information. It is curtail that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorName = 'Salaries/Taxes/Benefits') THEN 'Payroll' ELSE fd.FunctionalDepartmentName END,
    gac.MajorName,
    gac.MinorName,
    pf.PropertyFundName


IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwnerEntity') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity

GO




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
    (pa.LocalActual * er.Rate * gac.FeeOrExpenseMultiplicationFactor) AS ConvertedActual,
    (pa.LocalActual * er.Rate * r.MultiplicationFactor * gac.FeeOrExpenseMultiplicationFactor) AS NetActual,
    NULL AS ConvertedBudget,
    NULL AS NetBudget,
    (CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
				pa.LocalActual
			ELSE
				0
			END) * er.Rate * gac.FeeOrExpenseMultiplicationFactor as YTD,
	(CASE WHEN (c.CalendarPeriod <= '+STR(@ReportExpensePeriod,10,0)+') THEN
				pa.LocalActual
			ELSE
				0
			END) * er.Rate * gac.FeeOrExpenseMultiplicationFactor * r.MultiplicationFactor as NetYTD
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
    (pb.LocalBudget * er.Rate * gac.FeeOrExpenseMultiplicationFactor) AS ConvertedActual,
    (pb.LocalBudget * er.Rate * r.MultiplicationFactor * gac.FeeOrExpenseMultiplicationFactor) AS NetActual,
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
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 12/21/2009 12:46:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail1]    Script Date: 12/21/2009 12:46:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
	@ReportExpensePeriod INT = NULL,
	@DestinationCurrency VARCHAR(3) = NULL,
	@HierarchyName VARCHAR(50) = NULL,
	@IsGross bit = 1,
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


print 'This version have been updated to increase query performance, but is not tested yet. 
Once that is done, these changes should be applied to all reporting stp'


/*
DECLARE @ReportExpensePeriod   AS INT,
        @FunctionalDepartment  AS VARCHAR(50),
        @DestinationCurrency   AS VARCHAR(3),
        @AllocationRegion      AS VARCHAR(50),
        @HierarchyName         VARCHAR(50)
				
		
SET @ReportExpensePeriod = 201011
SET @FunctionalDepartment = 'Information Technologies'
SET @DestinationCurrency = 'USD'
SET @AllocationRegion = 'CHICAGO'
SET @EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)'
SET @HierarchyName = 'Global'



EXEC stp_R_BudgetOriginatorJobCodeDetail
	@ReportExpensePeriod = 201011,
	@FunctionalDepartment = 'Information Technologies',
	@DestinationCurrency = 'USD',
	@AllocationRegion = 'CHICAGO',
	@EntityList = 'Aldgate|Centrium (St Cathrine House/Pegasus)',
	@HierarchyName = 'Global'
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
	

IF 	OBJECT_ID('tempdb..#BudgetOriginator') IS NOT NULL
    DROP TABLE #BudgetOriginator

CREATE TABLE #BudgetOriginator
(
	GlAccountCategoryKey		Int,
    AllocationRegionKey			Int,
    OriginatingRegionKey		Int,
    FunctionalDepartmentKey		Int,
    PropertyFundKey				Int,
	CalendarPeriod				INT,
	GrossActual					MONEY,
	NetActual					MONEY,
	GrossBudget					MONEY,
	NetBudget					MONEY
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)


SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
	')

print @cmdString
Insert Into #Gac
EXEC (@cmdString)


SET @cmdString = (Select '
INSERT INTO #BudgetOriginator
SELECT 
	pagacb.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    c.CalendarPeriod,
    SUM(er.Rate * pa.LocalActual) AS GrossActual,
    SUM(er.Rate * r.MultiplicationFactor * pa.LocalActual) AS NetActual,
    NULL AS GrossBudget,
    NULL AS NetBudget
FROM
	ProfitabilityActual pa
    INNER JOIN (
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridge pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				UNION ALL
				Select pagacb.* From dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pagacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey
				) pagacb ON  
		pa.ProfitabilityActualKey = pagacb.ProfitabilityActualKey' +	
    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pagacb.GlAccountCategoryKey ' ELSE '' END +
    + CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pa.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pa.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pa.PropertyFundKey' ELSE '' END + '
    
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pa.LocalCurrencyKey AND er.CalendarKey = pa.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pa.CalendarKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey

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
	
	Group By
			pagacb.GlAccountCategoryKey,
			pa.AllocationRegionKey,
			pa.OriginatingRegionKey,
			pa.FunctionalDepartmentKey,
			pa.PropertyFundKey,
			c.CalendarPeriod
')

print @cmdString
EXEC (@cmdString)


SET @cmdString = (Select '
INSERT INTO #BudgetOriginator
SELECT 
	pbgacb.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    NULL AS GrossActual,
    NULL AS NetActual,
    SUM(er.Rate * pb.LocalBudget) AS GrossBudget,
    SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) AS NetBudget
FROM
	(
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb
    INNER JOIN ProfitabilityBudget pb ON  pbgacb.ProfitabilityBudgetKey = pb.ProfitabilityBudgetKey	' +	
    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey ' ELSE '' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '

	INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey
	INNER JOIN Currency dc ON er.DestinationCurrencyKey = dc.CurrencyKey
	INNER JOIN Calendar c ON c.CalendarKey = pb.CalendarKey
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
Group by
    pbgacb.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod
	
')

print @cmdString
EXEC (@cmdString)

    
SELECT 
	gac.ExpenseType,
    ar.RegionName [Allocation Region],
    ar.SubRegionName [Allocation Sub Region],
    orr.RegionName [Originating Region],
    orr.SubRegionName [Originating Sub Region],
    fd.FunctionalDepartmentName [Functional Department],
    fd.SubFunctionalDepartmentName [JobCode],
    gac.MajorName [Major Expense Category],
    gac.MinorName [Minor Expense Category],
    pf.PropertyFundType [Entity Type],
    pf.PropertyFundName [Entity],
	--This case statement is bad for performance, can coulc still be removed
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossActual, 0) ELSE ISNULL(NetActual, 0) END) AS Actual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) ELSE ISNULL(NetBudget, 0) END) AS Budget,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS Variance,
	
    res.CalendarPeriod
FROM
	#BudgetOriginator res
		INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = res.AllocationRegionKey
		INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = res.OriginatingRegionKey
		INNER JOIN PropertyFund pf ON pf.PropertyFundKey = res.PropertyFundKey
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = res.FunctionalDepartmentKey
		INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = res.GlAccountCategoryKey 
GROUP BY
	gac.ExpenseType,
    ar.RegionName,
    ar.SubRegionName,
    orr.RegionName,
    orr.SubRegionName,
    fd.FunctionalDepartmentName,
    fd.SubFunctionalDepartmentName,
    gac.MajorName,
    gac.MinorName,
    pf.PropertyFundType,
    pf.PropertyFundName,
    res.CalendarPeriod
	
IF OBJECT_ID('tempdb..#BudgetOriginator') IS NOT NULL
    DROP TABLE #BudgetOriginator



GO







