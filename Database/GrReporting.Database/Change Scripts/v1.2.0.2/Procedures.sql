USe GrReporting
GO
USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 03/01/2010 14:38:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorJobCodeDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorJobCodeDetail]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 03/01/2010 14:38:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerEntity]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 03/01/2010 14:38:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 03/01/2010 14:38:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzar]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarDetail]    Script Date: 03/01/2010 14:38:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarDetail]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 03/01/2010 14:38:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ExpenseCzarTotalComparison]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ExpenseCzarTotalComparison]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorJobCodeDetail]    Script Date: 03/01/2010 14:38:02 ******/
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
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
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
	NetBudget					MONEY,
	SourceName					Varchar(50)
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
    NULL AS NetBudget,
    s.SourceName
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
	INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pa.ReimbursableKey

WHERE  1 = 1
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
	
	Group By
			pagacb.GlAccountCategoryKey,
			pa.AllocationRegionKey,
			pa.OriginatingRegionKey,
			pa.FunctionalDepartmentKey,
			pa.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
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
    SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) AS NetBudget,
    s.SourceName
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
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey 
    
WHERE  1 = 1 
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group by
    pbgacb.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    c.CalendarPeriod,
    s.SourceName
	
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
	
    res.CalendarPeriod,
    res.SourceName as [Source Name]
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
    res.CalendarPeriod,
    res.SourceName
	
IF OBJECT_ID('tempdb..#BudgetOriginator') IS NOT NULL
    DROP TABLE #BudgetOriginator




GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerEntity]    Script Date: 03/01/2010 14:38:03 ******/
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
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList

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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
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
	NetBudget					MONEY,
	SourceName					VarChar(50)
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
    NULL AS NetBudget,
    s.SourceName
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
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
WHERE  1 = 1
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
Group by
    pagacb.GlAccountCategoryKey,
    pa.AllocationRegionKey,
    pa.OriginatingRegionKey,
    pa.FunctionalDepartmentKey,
    pa.PropertyFundKey,
    s.SourceName

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
    SUM(r.MultiplicationFactor * er.Rate * pb.LocalBudget) AS NetBudget,
    s.SourceName
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
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey

WHERE  1 = 1 
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
 	AND dc.CurrencyCode = ''' + @DestinationCurrency + ''' 
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
	Group By
    pbgacb.GlAccountCategoryKey,
    pb.AllocationRegionKey,
    pb.OriginatingRegionKey,
    pb.FunctionalDepartmentKey,
    pb.PropertyFundKey,
    s.SourceName
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
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorName = 'Salaries/Taxes/Benefits') THEN 'Payroll' ELSE fd.FunctionalDepartmentName END [Functional Department],
    gac.MajorName [Major Expense Category],
    gac.MinorName [Minor Expense Category],
    pf.PropertyFundName [Entity],
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossActual, 0) ELSE ISNULL(NetActual, 0) END) AS Actual,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) ELSE ISNULL(NetBudget, 0) END) AS Budget,
	SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS Variance,
	res.SourceName [Source Name]
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
    --The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
    --get communicated to TS employees.
    CASE WHEN (gac.MajorName = 'Salaries/Taxes/Benefits') THEN 'Payroll' ELSE fd.FunctionalDepartmentName END,
    gac.MajorName,
    gac.MinorName,
    pf.PropertyFundName,
    res.SourceName


IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwnerEntity') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwnerEntity


GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOriginatorOwnerFunctionalDepartment]    Script Date: 03/01/2010 14:38:03 ******/
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

DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
	
if LEN(@_FunctionalDepartmentList) > 7998 OR
	LEN(@_ActivityTypeList) > 7998 OR
	LEN(@_EntityList) > 7998 OR
	LEN(@_MajorAccountCategoryList) > 7998 OR
	LEN(@_MinorAccountCategoryList) > 7998 OR
	LEN(@_AllocationRegionList) > 7998 OR
	LEN(@_AllocationSubRegionList) > 7998 OR
	LEN(@_OriginatingRegionList) > 7998 OR
	LEN(@_OriginatingSubRegionList) > 7998
	BEGIN
	RAISERROR('Filter List parameter is to big',19,1)
	END
	
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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
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
	NetBudget               MONEY,
	SourceName				VarChar(50)
)

CREATE TABLE #Gac (GlAccountCategoryKey Int NOT NULL)

DECLARE @cmdString Varchar(8000)

SET @cmdString = (Select '
	Select GlAccountCategoryKey
	From GlAccountCategory gac
	Where 1 = 1
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @_HierarchyName + '''
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
    NULL AS NetBudget,
    s.SourceName
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
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey

WHERE  1 = 1
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
 	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
Group By
	pa.AllocationRegionKey,
	pa.OriginatingRegionKey,
    pa.PropertyFundKey,
    pa.FunctionalDepartmentKey,
	pagacb.GlAccountCategoryKey,
	s.SourceName
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
    SUM(r.MultiplicationFactor * er.Rate * pb.LocalBudget) AS NetBudget,
    s.SourceName
FROM
	(
				Select pbgacb.* From dbo.ProfitabilityBudgetGlAccountCategoryBridge pbgacb
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey
				UNION ALL
				Select pbgacbv.* From dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('+STR(@CalendarYear,10,0)+','+STR(@ReportExpensePeriod,10,0)+','''+ @HierarchyName + ''') pbgacbv
					INNER JOIN #Gac gac on gac.GlAccountCategoryKey = pbgacbv.GlAccountCategoryKey
				) pbgacb
    INNER JOIN ProfitabilityBudget pb ON  
		pb.ProfitabilityBudgetKey = pbgacb.ProfitabilityBudgetKey' +	

    + CASE WHEN @MajorAccountCategoryList IS NOT NULL OR @MinorAccountCategoryList IS NOT NULL THEN ' INNER JOIN GlAccountCategory gac ON  gac.GlAccountCategoryKey = pbgacb.GlAccountCategoryKey ' ELSE '' END +
	+ CASE WHEN @AllocationRegionList IS NOT NULL OR @AllocationSubRegionList IS NOT NULL THEN ' INNER JOIN AllocationRegion ar ON  ar.AllocationRegionKey = pb.AllocationRegionKey ' ELSE '' END +
    + CASE WHEN @FunctionalDepartmentList IS NOT NULL THEN ' INNER JOIN FunctionalDepartment fd ON  fd.FunctionalDepartmentKey = pb.FunctionalDepartmentKey ' ELSE '' END +
    + CASE WHEN @OriginatingRegionList IS NOT NULL OR @OriginatingSubRegionList IS NOT NULL THEN ' INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pb.OriginatingRegionKey ' ELSE '' END +
    + CASE WHEN @ActivityTypeList IS NOT NULL THEN ' INNER JOIN ActivityType a ON  a.ActivityTypeKey = pb.ActivityTypeKey' ELSE '' END +
	+ CASE WHEN @EntityList IS NOT NULL THEN ' INNER JOIN PropertyFund pf ON pf.PropertyFundKey = pb.PropertyFundKey' ELSE '' END + '
		
    INNER JOIN ExchangeRate er ON er.SourceCurrencyKey = pb.LocalCurrencyKey AND er.CalendarKey = pb.CalendarKey 
	INNER JOIN Currency dc ON  er.DestinationCurrencyKey = dc.CurrencyKey    
	INNER JOIN Calendar c ON  c.CalendarKey = pb.CalendarKey
	INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
WHERE  1 = 1 
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
Group By
	pb.AllocationRegionKey,
	pb.OriginatingRegionKey,
    pb.PropertyFundKey,
    pb.FunctionalDepartmentKey,
	pbgacb.GlAccountCategoryKey,
	s.SourceName')

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
	SUM(CASE WHEN (@_IsGross = 1) THEN ISNULL(GrossActual, 0) ELSE ISNULL(NetActual, 0) END) AS Actual,
	SUM(CASE WHEN (@_IsGross = 1) THEN ISNULL(GrossBudget, 0) ELSE ISNULL(NetBudget, 0) END) AS Budget,
	SUM(CASE WHEN (@_IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS Variance,
	res.SourceName as [Source Name]
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
	fd.FunctionalDepartmentName,
	res.SourceName
	
IF 	OBJECT_ID('tempdb..#BudgetOriginatorOwner') IS NOT NULL
    DROP TABLE #BudgetOriginatorOwner





GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzar]    Script Date: 03/01/2010 14:38:03 ******/
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
	DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
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
		NetBudget					MONEY,
		SourceName					VarChar(50)
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
    NULL AS NetBudget,
    s.SourceName
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
	INNER JOIN Source s ON
		s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  
		r.ReimbursableKey = pa.ReimbursableKey
		
WHERE  1 = 1 
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'	
	Group By
		pagacb.GlAccountCategoryKey,
		pa.AllocationRegionKey,
		pa.FunctionalDepartmentKey,
		pa.PropertyFundKey,
		c.CalendarPeriod,
		s.SourceName

	
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
    SUM(er.Rate * r.MultiplicationFactor * pb.LocalBudget) AS NetBudget,
    s.SourceName
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
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey
		
WHERE  1 = 1 
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'    
	Group By
			pbgacb.GlAccountCategoryKey,
			pb.AllocationRegionKey,
			pb.FunctionalDepartmentKey,
			pb.PropertyFundKey,
			c.CalendarPeriod,
			s.SourceName
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
    SUM(ISNULL(NetBudget, 0) - ISNULL(NetActual, 0)) AS NetVariance,
    
    res.SourceName as [Source Name]
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
    pf.PropertyFundName,
    res.SourceName



	IF 	OBJECT_ID('tempdb..#AccountCategoryFilterTable') IS NOT NULL
	    DROP TABLE #AccountCategoryFilterTable
	    
	IF 	OBJECT_ID('tempdb..#ActivityTypeFilterTable') IS NOT NULL
	    DROP TABLE #ActivityTypeFilterTable
	    
	IF 	OBJECT_ID('tempdb..#MinorAccountCategoryFilterTable') IS NOT NULL
		DROP TABLE #MinorAccountCategoryFilterTable

	IF 	OBJECT_ID('tempdb..#ExpenseCzar') IS NOT NULL
	    DROP TABLE #ExpenseCzar

GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarDetail]    Script Date: 03/01/2010 14:38:03 ******/
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
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
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
	NetBudget               MONEY,
	SourceName				VarChar(50)
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
	    NULL AS NetBudget,
	    s.SourceName
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
	    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
			
WHERE  1 = 1
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
'
	Group By
		pagacb.GlAccountCategoryKey,
	    pa.FunctionalDepartmentKey,
	    pa.AllocationRegionKey,
	    pa.PropertyFundKey,
	    s.SourceName
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
	    SUM(er.Rate * pb.LocalBudget * r.MultiplicationFactor) AS NetBudget,
	    s.SourceName
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
	    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
	    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pb.ReimbursableKey
WHERE  1 = 1 
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
'
	Group By
		pbgacb.GlAccountCategoryKey,
	    pb.FunctionalDepartmentKey,
	    pb.AllocationRegionKey,
	    pb.PropertyFundKey,
	    s.SourceName
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
	    SUM(CASE WHEN (@IsGross = 1) THEN ISNULL(GrossBudget, 0) - ISNULL(GrossActual, 0) ELSE ISNULL(NetBudget, 0) - ISNULL(NetActual, 0) END) AS [Variance],
	    res.SourceName [Source Name]
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
	    pf.PropertyFundName,
	    res.SourceName
	
	IF 	OBJECT_ID('tempdb..#ExpenseCzarTotalComparisonDetail') IS NOT NULL
	    DROP TABLE #ExpenseCzarTotalComparisonDetail



GO

/****** Object:  StoredProcedure [dbo].[stp_R_ExpenseCzarTotalComparison]    Script Date: 03/01/2010 14:38:03 ******/
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
 
DECLARE

	@_ReportExpensePeriod INT = @ReportExpensePeriod,
	@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
	@_HierarchyName VARCHAR(50) = @HierarchyName,
	@_IsGross bit = @IsGross,
	@_FunctionalDepartmentList VARCHAR(8000) = @FunctionalDepartmentList,
	@_ActivityTypeList VARCHAR(8000) = @ActivityTypeList,
	@_EntityList VARCHAR(8000) = @EntityList,
	@_MajorAccountCategoryList VARCHAR(8000) = @MajorAccountCategoryList,
	@_MinorAccountCategoryList VARCHAR(8000) = @MinorAccountCategoryList,
	@_AllocationRegionList VARCHAR(8000) = @AllocationRegionList,
	@_AllocationSubRegionList VARCHAR(8000) = @AllocationSubRegionList,
	@_OriginatingRegionList VARCHAR(8000) = @OriginatingRegionList,
	@_OriginatingSubRegionList VARCHAR(8000) = @OriginatingSubRegionList
	
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
	
	CREATE TABLE	#EntityFilterTable	(PropertyFundKey Int NOT NULL)
	CREATE TABLE	#FunctionalDepartmentFilterTable	(FunctionalDepartmentKey Int NOT NULL)
	CREATE TABLE	#ActivityTypeFilterTable(ActivityTypeKey Int NOT NULL)
	CREATE TABLE	#AllocationRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#AllocationSubRegionFilterTable	(AllocationRegionKey Int NOT NULL)
	CREATE TABLE	#MajorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#MinorAccountCategoryFilterTable(GlAccountCategoryKey Int NOT NULL)	
	CREATE TABLE	#OriginatingRegionFilterTable	(OriginatingRegionKey Int NOT NULL)
	CREATE TABLE	#OriginatingSubRegionFilterTable	(OriginatingRegionKey Int NOT NULL)	
		
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable	(PropertyFundKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #ActivityTypeFilterTable(ActivityTypeKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MajorAccountCategoryFilterTable(GlAccountCategoryKey)	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #MinorAccountCategoryFilterTable(GlAccountCategoryKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingRegionFilterTable	(OriginatingRegionKey)
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable	(OriginatingRegionKey)
	
IF (@EntityList IS NOT NULL)
	BEGIN
	Insert Into #EntityFilterTable
	Select pf.PropertyFundKey
	From dbo.Split(@_EntityList) t1
		INNER JOIN PropertyFund pf ON pf.PropertyFundName = t1.item
	
	END
	
IF (@FunctionalDepartmentList IS NOT NULL)
	BEGIN
	Insert Into #FunctionalDepartmentFilterTable
	Select fd.FunctionalDepartmentKey 
	From dbo.Split(@_FunctionalDepartmentList) t1
		INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentName = t1.item
	END

IF 	(@ActivityTypeList IS NOT NULL)
	BEGIN
    INSERT INTO #ActivityTypeFilterTable
    SELECT at.ActivityTypeKey 
    FROM dbo.Split(@_ActivityTypeList) t1
		INNER JOIN ActivityType at ON at.ActivityTypeName = t1.item
	END
	
IF (@AllocationRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationRegionFilterTable
	Select ar.AllocationRegionKey 
	From dbo.Split(@_AllocationRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.RegionName = t1.item
	END

IF (@AllocationSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #AllocationSubRegionFilterTable
	Select ar.AllocationRegionKey
	From dbo.Split(@_AllocationSubRegionList) t1
		INNER JOIN AllocationRegion ar ON ar.SubRegionName = t1.item
	END

IF (@MajorAccountCategoryList IS NOT NULL)
	BEGIN
	Insert Into #MajorAccountCategoryFilterTable
	Select gl.GlAccountCategoryKey 
	From dbo.Split(@_MajorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MajorName = t1.item
	END
	
IF 	(@MinorAccountCategoryList IS NOT NULL)
	BEGIN
    INSERT INTO #MinorAccountCategoryFilterTable
    SELECT gl.GlAccountCategoryKey 
    FROM dbo.Split(@MinorAccountCategoryList) t1
		INNER JOIN GlAccountCategory gl ON gl.MinorName = t1.item
	END	

IF (@OriginatingRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingRegionFilterTable
	Select orr.OriginatingRegionKey 
	From dbo.Split(@_OriginatingRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.RegionName = t1.item
	END

IF (@OriginatingSubRegionList IS NOT NULL)
	BEGIN
	Insert Into #OriginatingSubRegionFilterTable
	Select orr.OriginatingRegionKey  
	From dbo.Split(@OriginatingSubRegionList) t1
		INNER JOIN OriginatingRegion orr ON orr.SubRegionName = t1.item
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
	AnualEstNetActual		 MONEY,
	SourceName				 VarChar(50)
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
    ) as AnualEstNetActual,
    s.SourceName
    
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
    INNER JOIN Source s ON s.SourceKey = pa.SourceKey
    INNER JOIN Reimbursable r ON  r.ReimbursableKey = pa.ReimbursableKey
WHERE  1 = 1 
	AND c.CalendarYear = ' + STR(@CalendarYear,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
	AND gac.FeeOrExpense IN (''EXPENSE'',''UNKNOWN'')
	AND gac.HierarchyName = ''' + @HierarchyName + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select t1.FunctionalDepartmentKey From #FunctionalDepartmentFilterTable t1)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select t1.ActivityTypeKey From #ActivityTypeFilterTable t1)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select t1.PropertyFundKey From #EntityFilterTable t1)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationRegionFilterTable t1)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select t1.AllocationRegionKey From #AllocationSubRegionFilterTable t1)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MajorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select t1.GlAccountCategoryKey From #MinorAccountCategoryFilterTable t1)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingRegionFilterTable t1)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select t1.OriginatingRegionKey From #OriginatingSubRegionFilterTable t1)' END +
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
    ) as AnualEstNetActual, 
    s.SourceName
    
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
    INNER JOIN Source s ON s.SourceKey = pb.SourceKey
    INNER JOIN Reimbursable r ON r.ReimbursableKey = pb.ReimbursableKey

WHERE  1 = 1  
	AND c.CalendarPeriod >= ' + LEFT(LTRIM(STR(@ReportExpensePeriod,10,0)),4)+'01' + '
	AND c.CalendarPeriod <= ' + STR(@ReportExpensePeriod,10,0) + '
	AND dc.CurrencyCode = ''' + @DestinationCurrency + '''
'
+ CASE WHEN @FunctionalDepartmentList IS NULL THEN '' ELSE ' AND fd.FunctionalDepartmentKey IN (Select FunctionalDepartmentKey From #FunctionalDepartmentFilterTable)' END +
+ CASE WHEN @ActivityTypeList IS NULL THEN '' ELSE ' AND a.ActivityTypeKey IN (Select ActivityTypeKey From #ActivityTypeFilterTable)' END +
+ CASE WHEN @EntityList IS NULL THEN '' ELSE ' AND pf.PropertyFundKey IN (Select PropertyFundKey From #EntityFilterTable)' END +
+ CASE WHEN @AllocationRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationRegionFilterTable)' END +
+ CASE WHEN @AllocationSubRegionList IS NULL THEN '' ELSE ' AND ar.AllocationRegionKey IN (Select AllocationRegionKey From #AllocationSubRegionFilterTable)' END +
+ CASE WHEN @MajorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MajorAccountCategoryFilterTable)' END +
+ CASE WHEN @MinorAccountCategoryList IS NULL THEN '' ELSE ' AND gac.GlAccountCategoryKey IN (Select GlAccountCategoryKey From #MinorAccountCategoryFilterTable)' END +
+ CASE WHEN @OriginatingRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingRegionFilterTable)' END +
+ CASE WHEN @OriginatingSubRegionList IS NULL THEN '' ELSE ' AND orr.OriginatingRegionKey IN (Select OriginatingRegionKey From #OriginatingSubRegionFilterTable)' END +
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
	
	MajorName as [Major Account Category Display],
	SourceName as [Source Name]
FROM
	#TotalComparison
GROUP BY
	ExpenseType,
	HierarchyName,
    MajorName,
    MinorName,
    CalendarPeriod,
    SourceName



GO

 