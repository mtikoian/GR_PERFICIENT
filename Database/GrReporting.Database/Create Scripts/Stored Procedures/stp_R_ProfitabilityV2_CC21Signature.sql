  USE [GrReporting]
GO

USE GrReporting
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--/*

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ProfitabilityV2_CC21Signature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ProfitabilityV2_CC21Signature]
GO


CREATE PROCEDURE [dbo].[stp_R_ProfitabilityV2_CC21Signature]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList TEXT,
	@ActivityTypeList TEXT,
	@OriginatingSubRegionList TEXT,
	@DontSensitizeMRIPayrollData BIT = 1,
	@IncludeGrossNonPayrollExpenses BIT = 1,
	@IncludeFeeAdjustments BIT = 1,
	@DisplayOverheadBy TEXT,
	@OverheadOriginatingSubRegionList TEXT,
	@ConsolidationRegionList TEXT,
	--@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY
	@CategorizationName VARCHAR(250)
AS 

--*/



/* ======================================================================================================================================
	Test Data
========================================================================================================================================= */	
/*
BEGIN
	DECLARE	
		@ReportExpensePeriod INT = 201101,
		@ReforecastQuarterName VARCHAR(2) = 'Q0', --'Q0' or 'Q1' or 'Q2' or 'Q3'
		@DestinationCurrency VARCHAR(3) = 'USD',
		@EntityList VARCHAR(255) = 'All',
		@ActivityTypeList VARCHAR(255) = 'All',
		@AllocationSubRegionList VARCHAR(255) = 'All',
		@OriginatingSubRegionList VARCHAR(255) = 'Atlanta',
		@DontSensitizeMRIPayrollData BIT = 1,
		@IncludeGrossNonPayrollExpenses BIT = 1,
		@IncludeFeeAdjustments BIT = 1,
		@DisplayOverheadBy VARCHAR(255) = 'Allocated Overhead',
		@ConsolidationRegionList VARCHAR(255) = 'Atlanta',
		@CategorizationName VARCHAR(250) = 'Global'
		/*@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail 
		INSERT INTO @HierarchyReportParameter 
		SELECT 
		  2,
		  'Expense Czar Report',
		  -1,
		  '',
		  233,
		  'Global',
		  -1, -- finc
		  'Payroll',
		  -1, --majc
		  'All',
		  -1, -- minc
		  'All',
		  2, -- activity typeid
		  'Activity type',
		  1*/
		  
	

	
END

*/
	--SELECT 0 AS 'NumberOfSpacesToPad', 'REVENUE' AS 'GroupDisplayCode', 'REVENUE' AS 'GroupDisplayName', 100 AS 'DisplayOrderNumber', 0.00 AS 'MtdActual', 0.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecastQ1', 0.00 AS 'MtdReforecastQ2', 0.00 AS 'MtdReforecastQ3', 0.00 AS 'MtdVarianceQ0', 0.00 AS 'MtdVarianceQ1', 0.00 AS 'MtdVarianceQ2', 0.00 AS 'MtdVarianceQ3', 0.00 AS 'MtdVariancePercentageQ0', 0.00 AS 'MtdVariancePercentageQ1', 0.00 AS 'MtdVariancePercentageQ2', 0.00 AS 'MtdVariancePercentageQ3', 0.00 AS 'YtdActual', 0.00 AS 'YtdOriginalBudget', 0.00 AS 'YtdReforecastQ1', 0.00 AS 'YtdReforecastQ2', 0.00 AS 'YtdReforecastQ3', 0.00 AS 'YtdVarianceQ0', 0.00 AS 'YtdVarianceQ1', 0.00 AS 'YtdVarianceQ2', 0.00 AS 'YtdVarianceQ3', 0.00 AS 'YtdVariancePercentageQ0', 0.00 AS 'YtdVariancePercentageQ1', 0.00 AS 'YtdVariancePercentageQ2', 0.00 AS 'YtdVariancePercentageQ3', 0.00 AS 'AnnualOriginalBudget', 0.00 AS 'AnnualReforecastQ1', 0.00 AS 'AnnualReforecastQ2', 0.00 AS 'AnnualReforecastQ3' UNION ALL
	--SELECT 0, 'FEEREVENUE', 'Fee Revenue', 200, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
																																																																																																																																																																																																																																																																																																																																																																																			

	--SELECT 'Non-Payroll' AS 'ExpenseType', 'EXPENSE' AS 'FeeOrExpense', 'Charitable Contributions' AS 'MajorExpenseCategoryName', 'Charitable Contributions' AS 'MinorExpenseCategoryName', '6301000012' AS 'GlobalGlAccountCode', 'Charitable Contributions (CORP)  ' AS 'GlobalGlAccountName', 'Corporate' AS 'BusinessLine', 'Corporate' AS 'ActivityType', 'TSP Corporate' AS 'ReportingEntityName', 'Corporate' AS 'ReportingEntityType', '001000     ' AS 'PropertyFundCode', 'DNC            ' AS 'FunctionalDepartmentCode', 'US Corporate' AS 'AllocationSubRegionName', 'New York' AS 'OriginatingSubRegionName', '201101' AS 'ActualsExpensePeriod', '01/01/1900' AS 'EntryDate', 'DRUSCING' AS 'User', 'Reverse JE 22974L 2010 ACC                                   ' AS 'Description', '' AS 'AdditionalDescription', 'Not Reimbursable' AS 'ReimbursableName', 'NORMAL' AS 'FeeAdjustmentCode', 'USA Corporate' AS 'SourceName', '989' AS 'GlAccountCategoryKey', 10000.00 AS 'MtdActual', 0.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecastQ1', 0.00 AS 'MtdReforecastQ2', 0.00 AS 'MtdReforecastQ3', -10000.00 AS 'MtdVarianceQ0', 0.00 AS 'MtdVarianceQ1', 0.00 AS 'MtdVarianceQ2', 0.00 AS 'MtdVarianceQ3', 10000.00 AS 'YtdActual', 0.00 AS 'YtdOriginalBudget', 0.00 AS 'YtdReforecastQ1', 0.00 AS 'YtdReforecastQ2', 0.00 AS 'YtdReforecastQ3', -10000.00 AS 'YtdVarianceQ0', 0.00 AS 'YtdVarianceQ1', 0.00 AS 'YtdVarianceQ2', 0.00 AS 'YtdVarianceQ3', 0.00 AS 'AnnualOriginalBudget', 0.00 AS 'AnnualReforecastQ1', 0.00 AS 'AnnualReforecastQ2', 0.00 AS 'AnnualReforecastQ3', 'US Corporate' AS 'ConsolidationSubRegionName' UNION ALL
	--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    10014 1/19/2011 IN LIEU 1/20 CELEBRA SCHNEIDERMAN FOR   ', 'ATTORNEY GENERAL  ', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -10000.00, 0.00, 0.00, 0.00, 0.00, 10000.00, 0.00, 0.00, 0.00, -10000.00, 0.00, 0.00, 0.00, 0.00, 10000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate' UNION ALL
	--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    60893 1/1/2011 02/1/11-01/31/12DUES COUNCIL ON FOREIGN  ', 'RELATIONS  ', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -30000.00, 0.00, 0.00, 0.00, 0.00, 30000.00, 0.00, 0.00, 0.00, -30000.00, 0.00, 0.00, 0.00, 0.00, 30000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate' UNION ALL
	--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    60908 1/5/2011 InLieu2/28/11Benefit GRACIE MANSION      ', 'CONSERVANCY  ', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -25000.00, 0.00, 0.00, 0.00, 0.00, 25000.00, 0.00, 0.00, 0.00, -25000.00, 0.00, 0.00, 0.00, 0.00, 25000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate' UNION ALL
	--SELECT 'Non-Payroll', 'EXPENSE', 'Charitable Contributions', 'Charitable Contributions', '6301000012', 'Charitable Contributions (CORP)  ', 'Corporate', 'Corporate', 'TSP Corporate', 'Corporate', '001000     ', 'CEX            ', 'US Corporate', 'New York', '201101', '01/25/2011', 'JASHTON', '    60909 1/7/2011 IN LIEU 3/10/11EVENT AMERICAN FRIENDS OF ', '', 'Not Reimbursable', 'NORMAL', 'USA Corporate', '989', -6000.00, 0.00, 0.00, 0.00, 0.00, 6000.00, 0.00, 0.00, 0.00, -6000.00, 0.00, 0.00, 0.00, 0.00, 6000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'US Corporate'


IF 	OBJECT_ID('tempdb..#DetailResult') IS NOT NULL
    DROP TABLE #DetailResult

IF 	OBJECT_ID('tempdb..#Result') IS NOT NULL
    DROP TABLE #Result


/* ======================================================================================================================================
	Setup Variables
========================================================================================================================================= */	
BEGIN
	--DECLARE @CategorizationName VARCHAR(250) = (SELECT DISTINCT TOP 1 GLCategorizationName from @HierarchyReportParameter)
	DECLARE @_DisplayOverheadBy VARCHAR(250) = @DisplayOverheadBy
	DECLARE @AllocatedOverhead VARCHAR(50) = 'Allocated Overhead'
	DECLARE @UnAllocatedOverhead VARCHAR(50) = 'Unallocated Overhead'
END



IF ISNULL(@_DisplayOverheadBy,'') NOT IN (@AllocatedOverhead,@UnAllocatedOverhead)
	BEGIN
	RAISERROR ('@DisplayOverheadBy have invalid value (Must be one of:Allocated,Unallocated)',18,1)
	RETURN
	END

/*
IF (@IncludeFeeAdjustments = 1 AND ISNULL(@DisplayFeeAdjustmentsBy,'') NOT IN ('AllocationRegion','ReportingEntity'))
	BEGIN
	RAISERROR ('@DisplayFeeAdjustmentsBy have invalid value (Must be one of:AllocationRegion,ReportingEntity)',18,1)
	RETURN
	END
*/
	
IF @ReforecastQuarterName IS NULL OR @ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
	SET @ReforecastQuarterName = (SELECT TOP 1
									ReforecastQuarterName 
								 FROM
									dbo.Reforecast 
								 WHERE
									ReforecastEffectivePeriod <= @ReportExpensePeriod AND 
									ReforecastEffectiveYear = LEFT(CAST(@ReportExpensePeriod AS VARCHAR(6)),4)
								 ORDER BY
									ReforecastEffectivePeriod DESC)


/* ======================================================================================================================================
	Query Details
========================================================================================================================================= */	

CREATE TABLE #DetailResult(
	ExpenseType varchar(50) NULL,
	InflowOutflow varchar(50) NULL,
	MajorExpenseCategoryName varchar(100) NULL,
	MinorExpenseCategoryName varchar(100) NULL,
	GlobalGlAccountCode varchar(50) NULL,
	GlobalGlAccountName varchar(150) NULL,
	BusinessLine varchar(50) NULL,
	ActivityType varchar(50) NULL,
	ReportingEntityName varchar(100) NULL,
	ReportingEntityType varchar(50) NULL,
	PropertyFundCode varchar(11) NULL,
	FunctionalDepartmentCode varchar(15) NULL,
	AllocationSubRegionName varchar(50) NULL,
	OriginatingSubRegionName varchar(50) NULL,

	ActualsExpensePeriod Varchar(6) NULL,
	EntryDate varchar(10) NULL,
	[User] nvarchar(20) NULL,
	Description nvarchar(60) NULL,
	AdditionalDescription nvarchar(4000) NULL,
	ReimbursableName varchar(50) NULL,
	FeeAdjustmentCode varchar(10) NULL,
	SourceName varchar(50) NULL,
	GLCategorizationHierarchyKey int not null,
	
	MtdActual money NULL,
	MtdOriginalBudget money NULL,
	MtdReforecastQ1 money NULL,
	MtdReforecastQ2 money NULL,
	MtdReforecastQ3 money NULL,
	MtdVarianceQ0 money NULL,
	MtdVarianceQ1 money NULL,
	MtdVarianceQ2 money NULL,
	MtdVarianceQ3 money NULL,
	YtdActual money NULL,
	YtdOriginalBudget money NULL,
	YtdReforecastQ1 money NULL,
	YtdReforecastQ2 money NULL,
	YtdReforecastQ3 money NULL,
	YtdVarianceQ0 money NULL,
	YtdVarianceQ1 money NULL,
	YtdVarianceQ2 money NULL,
	YtdVarianceQ3 money NULL,
	AnnualOriginalBudget money NULL,
	AnnualReforecastQ1 money NULL,
	AnnualReforecastQ2 money NULL,
	AnnualReforecastQ3 money NULL,
	ConsolidationSubRegionName varchar(50) NULL
)

INSERT INTO #DetailResult
(	ExpenseType, 
	InflowOutflow,
    MajorExpenseCategoryName,
    MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
    BusinessLine,
    ActivityType,
	ReportingEntityName,
	ReportingEntityType,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,
	ActualsExpensePeriod,
    EntryDate,
    [User],
    [Description],
    AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GLCategorizationHierarchyKey,

	--Gross
	--Month to date    
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,

	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	
	--Year to date
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,

	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	
	--Annual
	AnnualOriginalBudget,	
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3,
	ConsolidationSubRegionName)
	
exec [stp_R_ProfitabilityDetailV2_CC21Signature]
	@ReportExpensePeriod = @ReportExpensePeriod,
	@ReforecastQuarterName = @ReforecastQuarterName,
	@DestinationCurrency = @DestinationCurrency,
	@GLCategorizationName = @CategorizationName,
	@ActivityTypeList = @ActivityTypeList,
	@EntityList = @EntityList,
	@ConsolidationRegionList = @ConsolidationRegionList,
	@OriginatingSubRegionList = @OriginatingSubRegionList,
	@DisplayOverheadBy = @DisplayOverheadBy,
	--@OverheadOriginatingSubRegionList = @OverheadOriginatingSubRegionList,
	@IncludeFeeAdjustments = @IncludeFeeAdjustments


/* ======================================================================================================================================
	Create Result
========================================================================================================================================= */	
		
CREATE TABLE #Result (
	NumberOfSpacesToPad TinyInt NOT NULL,
	GroupDisplayCode Varchar(500) NOT NULL,
	GroupDisplayName Varchar(500) NOT NULL,
	DisplayOrderNumber Int NOT NULL,
	MtdActual money NOT NULL DEFAULT(0),
	MtdOriginalBudget money NOT NULL DEFAULT(0),
	MtdReforecastQ1 money NOT NULL DEFAULT(0),
	MtdReforecastQ2 money NOT NULL DEFAULT(0),
	MtdReforecastQ3 money NOT NULL DEFAULT(0),
	
	MtdVarianceQ0 money NOT NULL DEFAULT(0),
	MtdVarianceQ1 money NOT NULL DEFAULT(0),
	MtdVarianceQ2 money NOT NULL DEFAULT(0),
	MtdVarianceQ3 money NOT NULL DEFAULT(0),

	MtdVariancePercentageQ0 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ1 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ2 money NOT NULL DEFAULT(0),
	MtdVariancePercentageQ3 money NOT NULL DEFAULT(0),
	
	YtdActual money NOT NULL DEFAULT(0),
	YtdOriginalBudget money NOT NULL DEFAULT(0),
	YtdReforecastQ1 money NOT NULL DEFAULT(0),
	YtdReforecastQ2 money NOT NULL DEFAULT(0),
	YtdReforecastQ3 money NOT NULL DEFAULT(0),
	
	YtdVarianceQ0 money NOT NULL DEFAULT(0),
	YtdVarianceQ1 money NOT NULL DEFAULT(0),
	YtdVarianceQ2 money NOT NULL DEFAULT(0),
	YtdVarianceQ3 money NOT NULL DEFAULT(0),
	
	YtdVariancePercentageQ0 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ1 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ2 money NOT NULL DEFAULT(0),
	YtdVariancePercentageQ3 money NOT NULL DEFAULT(0),
	
	AnnualOriginalBudget money NOT NULL DEFAULT(0),
	AnnualReforecastQ1 money NOT NULL DEFAULT(0),
	AnnualReforecastQ2 money NOT NULL DEFAULT(0),
	AnnualReforecastQ3 money NOT NULL DEFAULT(0),
	
)

INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
VALUES
(
	0,
	'REVENUE',
	'REVENUE',
	100
)

INSERT INTO #Result
(
	NumberOfSpacesToPad,
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
VALUES
(
	0, 
	'FEEREVENUE', 
	'Fee Revenue',
	200
)



INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	GLCategorizationHierarchy.GLMinorCategoryName GroupDisplayCode,
	GLCategorizationHierarchy.GLMinorCategoryName,
	201 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0),
	ISNULL(SUM(t1.MtdOriginalBudget),0),
	ISNULL(SUM(t1.MtdReforecastQ1),0),
	ISNULL(SUM(t1.MtdReforecastQ2),0),
	ISNULL(SUM(t1.MtdReforecastQ3),0),
	ISNULL(SUM(t1.MtdVarianceQ0),0),
	ISNULL(SUM(t1.MtdVarianceQ1),0),
	ISNULL(SUM(t1.MtdVarianceQ2),0),
	ISNULL(SUM(t1.MtdVarianceQ3),0),
	ISNULL(SUM(t1.YtdActual),0),
	ISNULL(SUM(t1.YtdOriginalBudget),0),
	ISNULL(SUM(t1.YtdReforecastQ1),0),
	ISNULL(SUM(t1.YtdReforecastQ2),0),
	ISNULL(SUM(t1.YtdReforecastQ3),0),
	ISNULL(SUM(t1.YtdVarianceQ0),0),
	ISNULL(SUM(t1.YtdVarianceQ1),0),
	ISNULL(SUM(t1.YtdVarianceQ2),0),
	ISNULL(SUM(t1.YtdVarianceQ3),0),
	ISNULL(SUM(t1.AnnualOriginalBudget),0),
	ISNULL(SUM(t1.AnnualReforecastQ1),0),
	ISNULL(SUM(t1.AnnualReforecastQ2),0),
	ISNULL(SUM(t1.AnnualReforecastQ3),0)
FROM 
	GLCategorizationHierarchy
	
	LEFT OUTER JOIN 
	(	SELECT 
			* 
		FROM 
			#DetailResult t1
		WHERE 
			t1.FeeAdjustmentCode = 'NORMAL'
	) t1 ON 
	GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey


WHERE	
	GLCategorizationHierarchy.InflowOutflow		= 'Inflow' AND
	GLCategorizationHierarchy.GLMajorCategoryName	= 'Fee Income' AND
	GLCategorizationHierarchy.GLCategorizationName = @CategorizationName
	--AND  GLCategorizationHierarchy.glca @CategorizationId
	--AND		gac.TranslationSubTypeName	= @TranslationTypeName  -- Join to Categorization
GROUP BY
	GLCategorizationHierarchy.GLMinorCategoryName
		
-- Fee adjustment Insert queries removed as per Change Request 13

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
		0 NumberOfSpacesToPad,
		'TOTALFEEREVENUE' GroupDisplayCode,
		'Total Fee Revenue',
		203 DisplayOrderNumber,
		ISNULL(SUM(#DetailResult.MtdActual),0),
		ISNULL(SUM(#DetailResult.MtdOriginalBudget),0),
		ISNULL(SUM(#DetailResult.MtdReforecastQ1),0),
		ISNULL(SUM(#DetailResult.MtdReforecastQ2),0),
		ISNULL(SUM(#DetailResult.MtdReforecastQ3),0),
		ISNULL(SUM(#DetailResult.MtdVarianceQ0),0),
		ISNULL(SUM(#DetailResult.MtdVarianceQ1),0),
		ISNULL(SUM(#DetailResult.MtdVarianceQ2),0),
		ISNULL(SUM(#DetailResult.MtdVarianceQ3),0),
		ISNULL(SUM(#DetailResult.YtdActual),0),
		ISNULL(SUM(#DetailResult.YtdOriginalBudget),0),
		ISNULL(SUM(#DetailResult.YtdReforecastQ1),0),
		ISNULL(SUM(#DetailResult.YtdReforecastQ2),0),
		ISNULL(SUM(#DetailResult.YtdReforecastQ3),0),
		ISNULL(SUM(#DetailResult.YtdVarianceQ0),0),
		ISNULL(SUM(#DetailResult.YtdVarianceQ1),0),
		ISNULL(SUM(#DetailResult.YtdVarianceQ2),0),
		ISNULL(SUM(#DetailResult.YtdVarianceQ3),0),
		ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0),
		ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0),
		ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0),
		ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0)
FROM
	#DetailResult
WHERE
	#DetailResult.InflowOutflow				= 'Inflow' AND
	#DetailResult.MajorExpenseCategoryName = 'Fee Income'	

INSERT INTO #Result
(
	NumberOfSpacesToPad,
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
VALUES
(
	0, 
	'OTHERREVENUE', 
	'Other Revenue',
	210
)
	
	
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
	GLCategorizationHierarchy.GLMajorCategoryName,
	211 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0),
	ISNULL(SUM(t1.MtdOriginalBudget),0),
	ISNULL(SUM(t1.MtdReforecastQ1),0),
	ISNULL(SUM(t1.MtdReforecastQ2),0),
	ISNULL(SUM(t1.MtdReforecastQ3),0),
	ISNULL(SUM(t1.MtdVarianceQ0),0),
	ISNULL(SUM(t1.MtdVarianceQ1),0),
	ISNULL(SUM(t1.MtdVarianceQ2),0),
	ISNULL(SUM(t1.MtdVarianceQ3),0),
	ISNULL(SUM(t1.YtdActual),0),
	ISNULL(SUM(t1.YtdOriginalBudget),0),
	ISNULL(SUM(t1.YtdReforecastQ1),0),
	ISNULL(SUM(t1.YtdReforecastQ2),0),
	ISNULL(SUM(t1.YtdReforecastQ3),0),
	ISNULL(SUM(t1.YtdVarianceQ0),0),
	ISNULL(SUM(t1.YtdVarianceQ1),0),
	ISNULL(SUM(t1.YtdVarianceQ2),0),
	ISNULL(SUM(t1.YtdVarianceQ3),0),
	ISNULL(SUM(t1.AnnualOriginalBudget),0),
	ISNULL(SUM(t1.AnnualReforecastQ1),0),
	ISNULL(SUM(t1.AnnualReforecastQ2),0),
	ISNULL(SUM(t1.AnnualReforecastQ3),0)
FROM 
	GLCategorizationHierarchy

	LEFT OUTER JOIN #DetailResult t1 ON 
		GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey

WHERE
	GLCategorizationHierarchy.InflowOutflow		= 'Inflow' AND
	GLCategorizationHierarchy.GLMajorCategoryName	<> 'Fee Income' AND
	GLCategorizationHierarchy.GLMajorCategoryName	<> 'Realized (Gain)/Loss' AND --IMS #61973
	GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName
GROUP BY
		GLCategorizationHierarchy.GLMajorCategoryName
	

INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT 
	0 NumberOfSpacesToPad,
	'TOTALOTHERREVENUE' GroupDisplayCode,
	'Total Other Revenue',
	212 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0),
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0),
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0),
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0),
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ0),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ1),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ2),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ3),0),
	ISNULL(SUM(#DetailResult.YtdActual),0),
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0),
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0),
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0),
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ0),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ1),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ2),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ3),0),
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0),
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0),
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0),
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0)
FROM 
	#DetailResult 
WHERE
	#DetailResult.InflowOutflow				= 'Inflow' AND
	#DetailResult.MajorExpenseCategoryName	<> 'Realized (Gain)/Loss' AND --IMS #61973
	#DetailResult.MajorExpenseCategoryName <> 'Fee Income'	


INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'TOTALREVENUE' GroupDisplayCode,
	'Total Revenue',
	220 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0),
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0),
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0),
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0),
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ0),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ1),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ2),0),
	ISNULL(SUM(#DetailResult.MtdVarianceQ3),0),
	ISNULL(SUM(#DetailResult.YtdActual),0),
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0),
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0),
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0),
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ0),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ1),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ2),0),
	ISNULL(SUM(#DetailResult.YtdVarianceQ3),0),
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0),
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0),
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0),
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0)
FROM 
	#DetailResult
WHERE
	#DetailResult.InflowOutflow				= 'Inflow' AND
	#DetailResult.MajorExpenseCategoryName	<> 'Realized (Gain)/Loss' --IMS #61973


INSERT INTO #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'BLANK' GroupDisplayCode,
		'',
		230 DisplayOrderNumber


INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'EXPENSES' GroupDisplayCode,
	'EXPENSES',
	240 DisplayOrderNumber
		
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'PAYROLLEXPENSES' GroupDisplayCode,
	'Payroll Expenses',
	241 DisplayOrderNumber


		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'Gross ' + #DetailResult.MajorExpenseCategoryName GroupDisplayCode,
	'Gross ' + #DetailResult.MajorExpenseCategoryName,
	242 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
	
	-- Variance amounts adjusted as per IMS 61749
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.MtdVarianceQ0 * -1) ELSE #DetailResult.MtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.MtdVarianceQ1 * -1) ELSE #DetailResult.MtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.MtdVarianceQ2 * -1) ELSE #DetailResult.MtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.MtdVarianceQ3 * -1) ELSE #DetailResult.MtdVarianceQ3 END),0) * -1,
	ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.YtdVarianceQ0 * -1) ELSE #DetailResult.YtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.YtdVarianceQ1 * -1) ELSE #DetailResult.YtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.YtdVarianceQ2 * -1) ELSE #DetailResult.YtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.ReimbursableName = 'Reimbursable' THEN (#DetailResult.YtdVarianceQ3 * -1) ELSE #DetailResult.YtdVarianceQ3 END),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1
FROM 
	#DetailResult
WHERE
	#DetailResult.InflowOutflow	= 'Outflow' AND
	#DetailResult.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits' AND
	#DetailResult.ExpenseType				<> 'Overhead'
GROUP BY
	#DetailResult.MajorExpenseCategoryName
		
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'Reimbursed ' + #DetailResult.MajorExpenseCategoryName GroupDisplayCode,
	'Reimbursed ' + #DetailResult.MajorExpenseCategoryName,
	243 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) * -1,
	ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1

FROM 
	#DetailResult
WHERE	
	#DetailResult.InflowOutflow				= 'Outflow' AND
	#DetailResult.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits' AND
	#DetailResult.ReimbursableName			= 'Reimbursable' AND
	#DetailResult.ExpenseType				<> 'Overhead'
GROUP BY
	#DetailResult.MajorExpenseCategoryName	
		
INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'Total Net ' + #DetailResult.MajorExpenseCategoryName GroupDisplayCode,
	'Total Net ' + #DetailResult.MajorExpenseCategoryName,
	244 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) * -1,
	ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1
FROM 
	#DetailResult
WHERE	
	#DetailResult.InflowOutflow				= 'Outflow' AND
	#DetailResult.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits' AND
	#DetailResult.ReimbursableName			= 'Not Reimbursable' AND
	#DetailResult.ExpenseType				<> 'Overhead' 
GROUP BY
	#DetailResult.MajorExpenseCategoryName	
		
INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT 
	0 NumberOfSpacesToPad,
	'Payroll Reimbursement Rate' GroupDisplayCode,
	'% Recovery',
	245 DisplayOrderNumber,
	ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END,0),
	ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END,0),
	ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END,0),
	ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END,0),
	ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END,0),
	0,
	0,
	0,
	0,
	ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END,0),
	ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END,0),
	ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END,0),
	ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END,0),
	ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END,0),
	0,
	0,
	0,
	0,
	ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END,0),
	ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END,0),
	ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END,0),
	ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END,0)
FROM 
	(
		SELECT 
			ISNULL(SUM(#DetailResult.MtdActual),0) MtdActual,
			ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) MtdOriginalBudget,
			ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) MtdReforecastQ1,
			ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) MtdReforecastQ2,
			ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) MtdReforecastQ3,
			ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) MtdVarianceQ0,
			ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) MtdVarianceQ1,
			ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) MtdVarianceQ2,
			ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) MtdVarianceQ3,
			ISNULL(SUM(#DetailResult.YtdActual),0) YtdActual,
			ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) YtdOriginalBudget,
			ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) YtdReforecastQ1,
			ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) YtdReforecastQ2,
			ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) YtdReforecastQ3,
			ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) YtdVarianceQ0,
			ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) YtdVarianceQ1,
			ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) YtdVarianceQ2,
			ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) YtdVarianceQ3,
			ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) AnnualOriginalBudget,
			ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) AnnualReforecastQ1,
			ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) AnnualReforecastQ2,
			ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) AnnualReforecastQ3

		FROM 
			#DetailResult
		WHERE
			#DetailResult.InflowOutflow				= 'Outflow' AND
			#DetailResult.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits' AND
			#DetailResult.ReimbursableName			= 'Reimbursable' AND
			#DetailResult.ExpenseType				<> 'Overhead'
		) Reimbursed
		CROSS JOIN 
			(
				SELECT 
					ISNULL(SUM(#DetailResult.MtdActual),0) MtdActual,
					ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(#DetailResult.YtdActual),0) YtdActual,
					ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) AnnualReforecastQ3
				FROM 
					#DetailResult
				WHERE
					#DetailResult.InflowOutflow				= 'Outflow' AND
					#DetailResult.MajorExpenseCategoryName = 'Salaries/Bonus/Taxes/Benefits' AND
					#DetailResult.ExpenseType				<> 'Overhead'
			
			) Gross 
	
--Calculate the Payroll Reimbursement Rate Variance Columns
UPDATE	#Result
SET
	MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
	MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
	MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
	MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
	YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
	YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
	YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
	YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)

WHERE 
	GroupDisplayCode = 'Payroll Reimbursement Rate' AND
	DisplayOrderNumber = 245	

	
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	250 DisplayOrderNumber
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'OVERHEADEXPENSE' GroupDisplayCode,
	'Overhead  Expenses',
	260 DisplayOrderNumber

--Removed due to IMS #62074 
/*
INSERT INTO #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'GROSSOVERHEADEXPENSE' GroupDisplayCode,
		'Gross Overhead  Expenses',
		261 DisplayOrderNumber
*/

IF @_DisplayOverheadBy = @UnAllocatedOverhead
BEGIN

	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3
	)
	SELECT 
		0 NumberOfSpacesToPad,
		'Gross ' + GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
		'Gross ' + GLCategorizationHierarchy.GLMajorCategoryName,
		262 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		
		-- Variance amounts adjusted as per IMS 61749
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	FROM 
		GLCategorizationHierarchy

		LEFT OUTER JOIN (
			Select 
				* 
			FROM 
				#DetailResult t1 
			WHERE 
				t1.ExpenseType = 'Overhead'
		) t1 ON 
		GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
				
	WHERE
		GLCategorizationHierarchy.InflowOutflow			= 'Outflow' AND
		GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
		GLCategorizationHierarchy.GLFinancialCategoryName		= 'Overhead' AND
		GLCategorizationHierarchy.GLMajorCategoryName		<> 'Corporate Tax'
	GROUP BY
			GLCategorizationHierarchy.GLMajorCategoryName	
				
END
ELSE
BEGIN

	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3
	)
	SELECT 
		0 NumberOfSpacesToPad,
		'Gross ' + GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
		'Gross ' + GLCategorizationHierarchy.GLMajorCategoryName,
		262 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		-- Variance amounts adjusted as per IMS 61749
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	FROM 
		GLCategorizationHierarchy
		INNER JOIN (
			SELECT
				* 
			FROM 
				#DetailResult t1 
			WHERE
				t1.ExpenseType = 'Overhead'
		) t1 ON 
		GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
				
	WHERE
		GLCategorizationHierarchy.InflowOutflow	= 'Outflow' AND
		GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
		GLCategorizationHierarchy.GLFinancialCategoryName = 'Overhead' AND
		GLCategorizationHierarchy.GLMajorCategoryName <> 'Corporate Tax' 
	GROUP BY
		GLCategorizationHierarchy.GLMajorCategoryName	
	END

--IMS #62074
/*
IF @DisplayOverheadBy = 'Unallocated'
	BEGIN
	INSERT INTO #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Gross Overhead Expense' GroupDisplayCode,
			'Total Gross Overhead Expense',
			263 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			-- Variance amounts adjusted as per IMS 61749
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
			ISNULL(SUM(CASE WHEN t1.ReimbursableName = 'Reimbursable' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Overhead'
	AND		t1.MajorExpenseCategoryName <>  'Corporate Tax'

END
*/


--Removed due to IMS #62074 
/*
INSERT INTO #Result
(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
Select 
		0 NumberOfSpacesToPad,
		'REIMBERSEDOVERHEADEXPENSE' GroupDisplayCode,
		'Reimbursed Overhead  Expenses',
		270 DisplayOrderNumber
*/

IF @_DisplayOverheadBy = @UnAllocatedOverhead
BEGIN
		
	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3
	)
	SELECT 
		0 NumberOfSpacesToPad,
		'Reimbursed ' + GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
		'Reimbursed ' + GLCategorizationHierarchy.GLMajorCategoryName,
		271 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	FROM
		GLCategorizationHierarchy
		LEFT OUTER JOIN (
			SELECT
				* 
			FROM 
				#DetailResult t1
			WHERE 
				t1.ExpenseType		= 'Overhead' AND
				t1.ReimbursableName	= 'Reimbursable'
		) t1 ON 
		GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
				
	WHERE
		GLCategorizationHierarchy.InflowOutflow		= 'Outflow' AND
		GLCategorizationHierarchy.GLCategorizationName = @CategorizationName AND
		GLCategorizationHierarchy.GLFinancialCategoryName		= 'Overhead' AND
		GLCategorizationHierarchy.GLMajorCategoryName		<> 'Corporate Tax'
	GROUP BY
		GLCategorizationHierarchy.GLMajorCategoryName	
	END
ELSE
BEGIN
	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3
	)
	SELECT 
		0 NumberOfSpacesToPad,
		'Reimbursed ' + GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
		'Reimbursed ' + GLCategorizationHierarchy.GLMajorCategoryName,
		271 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.YtdActual),0) * -1,
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	FROM 
		GLCategorizationHierarchy

		INNER JOIN (
			SELECT 
				* 
			FROM 
				#DetailResult t1
			WHERE	
				t1.ExpenseType		= 'Overhead' AND
				t1.ReimbursableName	= 'Reimbursable'
		) t1 ON
		GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
				
	WHERE
		GLCategorizationHierarchy.InflowOutflow		= 'Outflow' AND
		GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
		GLCategorizationHierarchy.GLFinancialCategoryName		= 'Overhead' AND
		GLCategorizationHierarchy.GLMajorCategoryName		<> 'Corporate Tax'
	GROUP BY
		GLCategorizationHierarchy.GLMajorCategoryName	
	END

--IMS #62074
/*			
IF @DisplayOverheadBy = 'Unallocated'
	BEGIN

	INSERT INTO #Result
	(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber,
	MtdActual,MtdOriginalBudget,MtdReforecastQ1,MtdReforecastQ2,MtdReforecastQ3,
	MtdVarianceQ0,MtdVarianceQ1,MtdVarianceQ2,MtdVarianceQ3,
	YtdActual,	YtdOriginalBudget,YtdReforecastQ1,YtdReforecastQ2,YtdReforecastQ3,
	YtdVarianceQ0,YtdVarianceQ1,YtdVarianceQ2,YtdVarianceQ3,
	AnnualOriginalBudget,AnnualReforecastQ1,AnnualReforecastQ2,AnnualReforecastQ3)

	Select 
			0 NumberOfSpacesToPad,
			'Total Reimbursed Overhead Expense' GroupDisplayCode,
			'Total Reimbursed Overhead Expense',
			272 DisplayOrderNumber,
			ISNULL(SUM(t1.MtdActual),0) * -1,
			ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.YtdActual),0) * -1,
			ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
			ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
			ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	From #DetailResult t1
	Where	t1.FeeOrExpense		= 'Expense'
	AND		t1.ExpenseType		= 'Overhead'
	AND		ReimbursableName	= 'Reimbursable'
	AND		t1.MajorExpenseCategoryName <> 'Corporate Tax'
END
*/
		
INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'Total Net Overhead Expense' GroupDisplayCode,
	'Total Net Overhead Expense',
	273 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) * -1,
	ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1

FROM 
	#DetailResult
WHERE	
	#DetailResult.InflowOutflow		= 'Outflow' AND
	#DetailResult.ExpenseType		= 'Overhead' AND
	#DetailResult.ReimbursableName = 'Not Reimbursable' AND
	#DetailResult.MajorExpenseCategoryName <> 'Corporate Tax'


INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'Overhead Reimbursement Rate' GroupDisplayCode,
	'% Recovery',
	274 DisplayOrderNumber,
	ISNULL(Reimbursed.MtdActual / CASE WHEN Gross.MtdActual = 0 THEN NULL ELSE Gross.MtdActual END,0),
	ISNULL(Reimbursed.MtdOriginalBudget / CASE WHEN Gross.MtdOriginalBudget = 0 THEN NULL ELSE Gross.MtdOriginalBudget END,0),
	ISNULL(Reimbursed.MtdReforecastQ1 / CASE WHEN Gross.MtdReforecastQ1 = 0 THEN NULL ELSE Gross.MtdReforecastQ1 END,0),
	ISNULL(Reimbursed.MtdReforecastQ2 / CASE WHEN Gross.MtdReforecastQ2 = 0 THEN NULL ELSE Gross.MtdReforecastQ2 END,0),
	ISNULL(Reimbursed.MtdReforecastQ3 / CASE WHEN Gross.MtdReforecastQ3 = 0 THEN NULL ELSE Gross.MtdReforecastQ3 END,0),
	0,
	0,
	0,
	0,
	ISNULL(Reimbursed.YtdActual / CASE WHEN Gross.YtdActual = 0 THEN NULL ELSE Gross.YtdActual END,0),
	ISNULL(Reimbursed.YtdOriginalBudget / CASE WHEN Gross.YtdOriginalBudget = 0 THEN NULL ELSE Gross.YtdOriginalBudget END,0),
	ISNULL(Reimbursed.YtdReforecastQ1 / CASE WHEN Gross.YtdReforecastQ1 = 0 THEN NULL ELSE Gross.YtdReforecastQ1 END,0),
	ISNULL(Reimbursed.YtdReforecastQ2 / CASE WHEN Gross.YtdReforecastQ2 = 0 THEN NULL ELSE Gross.YtdReforecastQ2 END,0),
	ISNULL(Reimbursed.YtdReforecastQ3 / CASE WHEN Gross.YtdReforecastQ3 = 0 THEN NULL ELSE Gross.YtdReforecastQ3 END,0),
	0,
	0,
	0,
	0,
	ISNULL(Reimbursed.AnnualOriginalBudget / CASE WHEN Gross.AnnualOriginalBudget = 0 THEN NULL ELSE Gross.AnnualOriginalBudget END,0),
	ISNULL(Reimbursed.AnnualReforecastQ1 / CASE WHEN Gross.AnnualReforecastQ1 = 0 THEN NULL ELSE Gross.AnnualReforecastQ1 END,0),
	ISNULL(Reimbursed.AnnualReforecastQ2 / CASE WHEN Gross.AnnualReforecastQ2 = 0 THEN NULL ELSE Gross.AnnualReforecastQ2 END,0),
	ISNULL(Reimbursed.AnnualReforecastQ3 / CASE WHEN Gross.AnnualReforecastQ3 = 0 THEN NULL ELSE Gross.AnnualReforecastQ3 END,0)

FROM 
	(
		SELECT 
			ISNULL(SUM(t1.MtdActual),0) MtdActual,
			ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
			ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
			ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
			ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
			ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
			ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
			ISNULL(SUM(t1.YtdActual),0) YtdActual,
			ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
			ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
			ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
			ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
			ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
			ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		FROM 
			#DetailResult t1
		WHERE	
			t1.InflowOutflow		= 'Outflow' AND
			t1.ExpenseType		= 'Overhead' AND
			t1.ReimbursableName	= 'Reimbursable' AND
			t1.MajorExpenseCategoryName <> 'Corporate Tax'
		) Reimbursed
		CROSS JOIN 
			(
				SELECT 
					ISNULL(SUM(t1.MtdActual),0) MtdActual,
					ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
					ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
					ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
					ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
					ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
					ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
					ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
					ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
					ISNULL(SUM(t1.YtdActual),0) YtdActual,
					ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
					ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
					ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
					ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
					ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
					ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
					ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
					ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
					ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
					ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
					ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
					ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

				FROM 
					#DetailResult t1
				WHERE 
					t1.InflowOutflow		= 'Outflow' AND
					t1.ExpenseType		= 'Overhead' AND
					t1.MajorExpenseCategoryName <> 'Corporate Tax'
			) Gross 

--Calculate the Overhead Reimbursement Rate Variance Columns
UPDATE	#Result
SET		
	MtdVarianceQ0 = (MtdActual - MtdOriginalBudget),
	MtdVarianceQ1 = (MtdActual - MtdReforecastQ1),
	MtdVarianceQ2 = (MtdActual - MtdReforecastQ2),
	MtdVarianceQ3 = (MtdActual - MtdReforecastQ3),
	YtdVarianceQ0 = (YtdActual - YtdOriginalBudget),
	YtdVarianceQ1 = (YtdActual - YtdReforecastQ1),
	YtdVarianceQ2 = (YtdActual - YtdReforecastQ2),
	YtdVarianceQ3 = (YtdActual - YtdReforecastQ3)

WHERE 
	GroupDisplayCode = 'Overhead Reimbursement Rate' AND
	DisplayOrderNumber = 274

	
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	280 DisplayOrderNumber
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT 
	0 NumberOfSpacesToPad,
	'NONPAYROLLEXPENSE' GroupDisplayCode,
	'Non-Payroll Expenses',
	290 DisplayOrderNumber

IF @IncludeGrossNonPayrollExpenses = 1
BEGIN
	
	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber
	)
	SELECT
		0 NumberOfSpacesToPad,
		'GROSSNONPAYROLLEXPENSE' GroupDisplayCode,
		'Gross Non-Payroll  Expenses',
		291 DisplayOrderNumber

	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3
	)
	SELECT 
		0 NumberOfSpacesToPad,
		CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchy.GLMajorCategoryName END as GroupDisplayCode,
		--gac.MajorCategoryName GroupDisplayCode,
		CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchy.GLMajorCategoryName END as MajorCategoryName,
		--gac.MajorCategoryName,
		292 DisplayOrderNumber,
		ISNULL(SUM(t1.MtdActual),0) * -1,
		ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.YtdActual),0) * -1,			
		ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
		--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

	FROM 
		GLCategorizationHierarchy

		LEFT OUTER JOIN (
			SELECT 
				*
			FROM
				#DetailResult t1
			WHERE
				t1.ExpenseType		= 'Non-Payroll'
		) t1 ON 
		GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
			
	WHERE
		GLCategorizationHierarchy.InflowOutflow	= (CASE WHEN GLCategorizationHierarchy.GLMajorCategoryName <> 'Realized (Gain)/Loss' THEN 'Outflow' ELSE GLCategorizationHierarchy.InflowOutflow END) AND --IMS #61973
		GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
		GLCategorizationHierarchy.GLFinancialCategoryName		= 'Non-Payroll' AND
		GLCategorizationHierarchy.GLMajorCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

	GROUP BY
			CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchy.GLMajorCategoryName END	
					

	INSERT INTO #Result
	(
		NumberOfSpacesToPad, 
		GroupDisplayCode, 
		GroupDisplayName, 
		DisplayOrderNumber,
		MtdActual,
		MtdOriginalBudget,
		MtdReforecastQ1,
		MtdReforecastQ2,
		MtdReforecastQ3,
		MtdVarianceQ0,
		MtdVarianceQ1,
		MtdVarianceQ2,
		MtdVarianceQ3,
		YtdActual,	
		YtdOriginalBudget,
		YtdReforecastQ1,
		YtdReforecastQ2,
		YtdReforecastQ3,
		YtdVarianceQ0,
		YtdVarianceQ1,
		YtdVarianceQ2,
		YtdVarianceQ3,
		AnnualOriginalBudget,
		AnnualReforecastQ1,
		AnnualReforecastQ2,
		AnnualReforecastQ3
	)
	SELECT 
		0 NumberOfSpacesToPad,
		'Total Gross Non-Payroll Expense' GroupDisplayCode,
		'Total Gross Non-Payroll Expense',
		293 DisplayOrderNumber,
		ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
		ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
		ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
		ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
		ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ0 * -1) ELSE #DetailResult.MtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ1 * -1) ELSE #DetailResult.MtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ2 * -1) ELSE #DetailResult.MtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ3 * -1) ELSE #DetailResult.MtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) * -1,
		--ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) * -1,
		--ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) * -1,
		--ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
		ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
		ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
		ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
		ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
		
		--IMS #61973
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ0 * -1) ELSE #DetailResult.YtdVarianceQ0 END),0) * -1,
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ1 * -1) ELSE #DetailResult.YtdVarianceQ1 END),0) * -1,
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ2 * -1) ELSE #DetailResult.YtdVarianceQ2 END),0) * -1,
		ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ3 * -1) ELSE #DetailResult.YtdVarianceQ3 END),0) * -1,
		
		--ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) * -1,
		--ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) * -1,
		--ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) * -1,
		--ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) * -1,
		
		ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
		ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
		ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
		ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1

	FROM
		 #DetailResult
	WHERE
		#DetailResult.InflowOutflow		= (CASE WHEN #DetailResult.MajorExpenseCategoryName <> 'Realized (Gain)/Loss' THEN 'Outflow' ELSE #DetailResult.InflowOutflow END) AND --IMS #61973
		#DetailResult.ExpenseType		= 'Non-Payroll' AND
		#DetailResult.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

END

INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'NETNONPAYROLLEXPENSE' GroupDisplayCode,
	'Net Non-Payroll  Expenses',
	301 DisplayOrderNumber

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchy.GLMajorCategoryName END as GroupDisplayCode,
	--gac.MajorCategoryName GroupDisplayCode,
	CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchy.GLMajorCategoryName END as MajorCategoryName,
	--gac.MajorCategoryName,
	302 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0) * -1,
	ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
	
	--IMS #61973
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ0 * -1) ELSE t1.MtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ1 * -1) ELSE t1.MtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ2 * -1) ELSE t1.MtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.MtdVarianceQ3 * -1) ELSE t1.MtdVarianceQ3 END),0) * -1,
		
	--ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
	--ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
	--ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
	--ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
	
	ISNULL(SUM(t1.YtdActual),0) * -1,
	ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
	
	
	--IMS #61973
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ0 * -1) ELSE t1.YtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ1 * -1) ELSE t1.YtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ2 * -1) ELSE t1.YtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN t1.InflowOutflow = 'Inflow' THEN (t1.YtdVarianceQ3 * -1) ELSE t1.YtdVarianceQ3 END),0) * -1,
		
	--ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
	--ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
	--ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
	--ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
	
	ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

FROM
	GLCategorizationHierarchy

	LEFT OUTER JOIN (
		SELECT 
			* 
		FROM 
			#DetailResult t1
		WHERE
			t1.ExpenseType		= 'Non-Payroll' AND
			t1.ReimbursableName = 'Not Reimbursable'

	) t1 ON 
	GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
			
WHERE
	GLCategorizationHierarchy.InflowOutflow			= (CASE WHEN GLCategorizationHierarchy.GLMajorCategoryName <> 'Realized (Gain)/Loss' THEN 'Outflow' ELSE GLCategorizationHierarchy.InflowOutflow END) AND --IMS #61973
	GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
	GLCategorizationHierarchy.GLFinancialCategoryName		= 'Non-Payroll' AND
	GLCategorizationHierarchy.GLMinorCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

GROUP BY
		CASE WHEN (GLCategorizationHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits') THEN 'Salaries/Bonus/Taxes/Benefits' ELSE GLCategorizationHierarchy.GLMajorCategoryName END	
				

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'Total Net Non-Payroll Expense' GroupDisplayCode,
	'Total Net Non-Payroll Expense',
	303 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
	
	
	--IMS #61973
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ0 * -1) ELSE #DetailResult.MtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ1 * -1) ELSE #DetailResult.MtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ2 * -1) ELSE #DetailResult.MtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ3 * -1) ELSE #DetailResult.MtdVarianceQ3 END),0) * -1,
	
	--ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) * -1,
	--ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) * -1,
	--ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) * -1,
	--ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) * -1,
	
	ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
	
	--IMS #61973
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ0 * -1) ELSE #DetailResult.YtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ1 * -1) ELSE #DetailResult.YtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ2 * -1) ELSE #DetailResult.YtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ3 * -1) ELSE #DetailResult.YtdVarianceQ3 END),0) * -1,
	
	--ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) * -1,
	--ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) * -1,
	--ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) * -1,
	--ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) * -1,
	
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1

FROM
	 #DetailResult 
WHERE 
	#DetailResult.InflowOutflow		= (CASE WHEN #DetailResult.MajorExpenseCategoryName <> 'Realized (Gain)/Loss' THEN 'Outflow' ELSE #DetailResult.InflowOutflow END) AND --IMS #61973
	#DetailResult.ExpenseType		= 'Non-Payroll' AND
	#DetailResult.ReimbursableName = 'Not Reimbursable' AND
	#DetailResult.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')


INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	310 DisplayOrderNumber
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,	
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'TOTALNETEXPENSE' GroupDisplayCode,
	'Total Net Expenses',
	320 DisplayOrderNumber,
	ISNULL(SUM(#DetailResult.MtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.MtdReforecastQ3),0) * -1,
	
	--IMS #61973
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ0 * -1) ELSE #DetailResult.MtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ1 * -1) ELSE #DetailResult.MtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ2 * -1) ELSE #DetailResult.MtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.MtdVarianceQ3 * -1) ELSE #DetailResult.MtdVarianceQ3 END),0) * -1,
	
	--ISNULL(SUM(#DetailResult.MtdVarianceQ0),0) * -1,
	--ISNULL(SUM(#DetailResult.MtdVarianceQ1),0) * -1,
	--ISNULL(SUM(#DetailResult.MtdVarianceQ2),0) * -1,
	--ISNULL(SUM(#DetailResult.MtdVarianceQ3),0) * -1,
	
	ISNULL(SUM(#DetailResult.YtdActual),0) * -1,
	ISNULL(SUM(#DetailResult.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.YtdReforecastQ3),0) * -1,
	
	--IMS #61973
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ0 * -1) ELSE #DetailResult.YtdVarianceQ0 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ1 * -1) ELSE #DetailResult.YtdVarianceQ1 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ2 * -1) ELSE #DetailResult.YtdVarianceQ2 END),0) * -1,
	ISNULL(SUM(CASE WHEN #DetailResult.InflowOutflow = 'Inflow' THEN (#DetailResult.YtdVarianceQ3 * -1) ELSE #DetailResult.YtdVarianceQ3 END),0) * -1,
	
	--ISNULL(SUM(#DetailResult.YtdVarianceQ0),0) * -1,
	--ISNULL(SUM(#DetailResult.YtdVarianceQ1),0) * -1,
	--ISNULL(SUM(#DetailResult.YtdVarianceQ2),0) * -1,
	--ISNULL(SUM(#DetailResult.YtdVarianceQ3),0) * -1,
	
	ISNULL(SUM(#DetailResult.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(#DetailResult.AnnualReforecastQ3),0) * -1

FROM
	 #DetailResult
WHERE
	#DetailResult.InflowOutflow		= (CASE WHEN #DetailResult.MajorExpenseCategoryName <> 'Realized (Gain)/Loss' THEN 'Outflow' ELSE #DetailResult.InflowOutflow END) AND --IMS #61973
	#DetailResult.ReimbursableName = 'Not Reimbursable' AND
	#DetailResult.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')

INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	321 DisplayOrderNumber

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT 
	0 NumberOfSpacesToPad,
	'INCOMELOSSBEFOREDEPRECIATIONANDTAX' GroupDisplayCode,
	'Income / (Loss) Before Taxes and Depreciation',
	322 DisplayOrderNumber,
	(INC.MtdActual + EP.MtdActual) AS MtdActual,
	(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
	(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
	(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
	(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
	(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
	(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
	(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
	(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
	(INC.YtdActual + EP.YtdActual) AS YtdActual,
	(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
	(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
	(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
	(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
	(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
	(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
	(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
	(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
	(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
	(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
	(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
	(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
	
		
FROM (
		SELECT 
			ISNULL(SUM(t1.MtdActual),0) MtdActual,
			ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
			ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
			ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
			ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
			ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
			ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
			ISNULL(SUM(t1.YtdActual),0) YtdActual,
			ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
			ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
			ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
			ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
			ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
			ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		FROM
			#DetailResult t1
		WHERE
			t1.InflowOutflow				= 'Inflow'
		) INC
		CROSS JOIN (
			Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			FROM
				#DetailResult t1
			WHERE 
				t1.InflowOutflow		= 'Outflow' AND
				t1.ReimbursableName = 'Not Reimbursable' AND
				t1.MajorExpenseCategoryName NOT IN ('Depreciation Expense', 'Corporate Tax', 'Unrealized (Gain)/Loss')
		) EP
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	323 DisplayOrderNumber



INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
	GLCategorizationHierarchy.GLMajorCategoryName,
	324 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0) * -1,
	ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
	ISNULL(SUM(t1.YtdActual),0) * -1,
	ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
	ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

FROM
	 GLCategorizationHierarchy

	LEFT OUTER JOIN (
		SELECT
			* 
		FROM 
			#DetailResult t1
		WHERE
			t1.ExpenseType		= 'Non-Payroll' AND
			t1.ReimbursableName = 'Not Reimbursable'

	) t1 ON 
	GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
			
WHERE
	GLCategorizationHierarchy.InflowOutflow			= 'Ouflow' AND
	GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
	GLCategorizationHierarchy.GLFinancialCategoryName		= 'Non-Payroll' AND
	GLCategorizationHierarchy.GLMinorCategoryName = 'Depreciation Expense'
GROUP BY
		GLCategorizationHierarchy.GLMajorCategoryName	
		
INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT 
	0 NumberOfSpacesToPad,
	'INCOMELOSSBEFORETAX' GroupDisplayCode,
	'Income / (Loss) Before Taxes',
	325 DisplayOrderNumber,
	(INC.MtdActual + EP.MtdActual) AS MtdActual,
	(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
	(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
	(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
	(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
	(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
	(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
	(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
	(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
	(INC.YtdActual + EP.YtdActual) AS YtdActual,
	(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
	(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
	(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
	(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
	(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
	(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
	(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
	(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
	(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
	(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
	(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
	(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
	
		
FROM	(
			Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		FROM
			 #DetailResult t1
		WHERE	
			t1.InflowOutflow				= 'Inflow'
		) INC
		CROSS JOIN (
			Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			FROM
				 #DetailResult t1
			WHERE
				t1.InflowOutflow		= 'Outflow' AND
				t1.ReimbursableName = 'Not Reimbursable' AND
				t1.MajorExpenseCategoryName NOT IN ('Corporate Tax', 'Unrealized (Gain)/Loss')
			
		) EP
		
INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	326 DisplayOrderNumber

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
	GLCategorizationHierarchy.GLMajorCategoryName,
	327 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0) * -1,
	ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
	ISNULL(SUM(t1.YtdActual),0) * -1,
	ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
	ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

FROM
	GLCategorizationHierarchy

	LEFT OUTER JOIN (
		SELECT
			* 
		FROM
			#DetailResult t1
		WHERE
			t1.ExpenseType		= 'Non-Payroll' AND
			t1.ReimbursableName = 'Not Reimbursable'

	) t1 ON 
	GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
			
WHERE
	GLCategorizationHierarchy.InflowOutflow			= 'Outflow' AND
	GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
	GLCategorizationHierarchy.GLFinancialCategoryName		= 'Non-Payroll' AND
	GLCategorizationHierarchy.GLMinorCategoryName = 'Unrealized (Gain)/Loss'
GROUP BY
	GLCategorizationHierarchy.GLMajorCategoryName
	
INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	GLCategorizationHierarchy.GLMajorCategoryName GroupDisplayCode,
	GLCategorizationHierarchy.GLMajorCategoryName,
	328 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0) * -1,
	ISNULL(SUM(t1.MtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.MtdReforecastQ3),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ0),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ1),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ2),0) * -1,
	ISNULL(SUM(t1.MtdVarianceQ3),0) * -1,
	ISNULL(SUM(t1.YtdActual),0) * -1,
	ISNULL(SUM(t1.YtdOriginalBudget),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ1),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ2),0) * -1,
	ISNULL(SUM(t1.YtdReforecastQ3),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ0),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ1),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ2),0) * -1,
	ISNULL(SUM(t1.YtdVarianceQ3),0) * -1,
	ISNULL(SUM(t1.AnnualOriginalBudget),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ1),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ2),0) * -1,
	ISNULL(SUM(t1.AnnualReforecastQ3),0) * -1

FROM
	GLCategorizationHierarchy

	LEFT OUTER JOIN (
		SELECT 
			* 
		FROM
			#DetailResult t1
		WHERE
			t1.ExpenseType		= 'Non-Payroll' AND
			t1.ReimbursableName = 'Not Reimbursable'

	) t1 ON 
	GLCategorizationHierarchy.GLCategorizationHierarchyKey = t1.GLCategorizationHierarchyKey
			
WHERE
	GLCategorizationHierarchy.InflowOutflow			= 'Outflow' AND
	GLCategorizationHierarchy.GLCategorizationName	= @CategorizationName AND
	GLCategorizationHierarchy.GLFinancialCategoryName		= 'Non-Payroll' AND
	GLCategorizationHierarchy.GLMinorCategoryName = 'Corporate Tax'
GROUP BY
	GLCategorizationHierarchy.GLMajorCategoryName

--INSERT INTO #Result
--(NumberOfSpacesToPad, GroupDisplayCode, GroupDisplayName, DisplayOrderNumber)
--Select 
--		0 NumberOfSpacesToPad,
--		'BLANK' GroupDisplayCode,
--		'',
--		321 DisplayOrderNumber

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'NETINCOMELOSS' GroupDisplayCode,
	'NET INCOME / (LOSS)',
	330 DisplayOrderNumber,
	(INC.MtdActual + EP.MtdActual) AS MtdActual,
	(INC.MtdOriginalBudget + EP.MtdOriginalBudget) AS MtdOriginalBudget,
	(INC.MtdReforecastQ1 + EP.MtdReforecastQ1) AS MtdReforecastQ1,
	(INC.MtdReforecastQ2 + EP.MtdReforecastQ2) AS MtdReforecastQ2,
	(INC.MtdReforecastQ3 + EP.MtdReforecastQ3) AS MtdReforecastQ3,
	(INC.MtdVarianceQ0 - EP.MtdVarianceQ0) AS MtdVarianceQ0,
	(INC.MtdVarianceQ1 - EP.MtdVarianceQ1) AS MtdVarianceQ1,
	(INC.MtdVarianceQ2 - EP.MtdVarianceQ2) AS MtdVarianceQ2,
	(INC.MtdVarianceQ3 - EP.MtdVarianceQ3) AS MtdVarianceQ3,
	(INC.YtdActual + EP.YtdActual) AS YtdActual,
	(INC.YtdOriginalBudget + EP.YtdOriginalBudget) AS YtdOriginalBudget,
	(INC.YtdReforecastQ1 + EP.YtdReforecastQ1) AS YtdReforecastQ1,
	(INC.YtdReforecastQ2 + EP.YtdReforecastQ2) AS YtdReforecastQ2,
	(INC.YtdReforecastQ3 + EP.YtdReforecastQ3) AS YtdReforecastQ3,
	(INC.YtdVarianceQ0 - EP.YtdVarianceQ0) AS YtdVarianceQ0,
	(INC.YtdVarianceQ1 - EP.YtdVarianceQ1) AS YtdVarianceQ1,
	(INC.YtdVarianceQ2 - EP.YtdVarianceQ2) AS YtdVarianceQ2,
	(INC.YtdVarianceQ3 - EP.YtdVarianceQ3) AS YtdVarianceQ3,
	(INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) AS AnnualOriginalBudget,
	(INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) AS AnnualReforecastQ1,
	(INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) AS AnnualReforecastQ2,
	(INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) AS AnnualReforecastQ3
		
		
FROM (
		SELECT
			ISNULL(SUM(t1.MtdActual),0) MtdActual,
			ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
			ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
			ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
			ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
			ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
			ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
			ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
			ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
			ISNULL(SUM(t1.YtdActual),0) YtdActual,
			ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
			ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
			ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
			ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
			ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
			ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
			ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
			ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
			ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
			ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
			ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
			ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		FROM
			 #DetailResult t1
		WHERE
			t1.InflowOutflow				= 'Inflow'
		) INC
		CROSS JOIN (
			Select 
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			FROM
				#DetailResult t1
			WHERE
				t1.InflowOutflow		= 'Outflow' AND
				t1.ReimbursableName = 'Not Reimbursable'
		) EP


INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'PROFITMARGIN' GroupDisplayCode,
	'Profit Margin (Net Income/(Loss)/ Total Revenue)',
	331 DisplayOrderNumber,
	ISNULL(((INC.MtdActual + EP.MtdActual) / CASE WHEN INC.MtdActual <> 0 THEN INC.MtdActual ELSE NULL END),0) AS MtdActual,
	ISNULL(((INC.MtdOriginalBudget + EP.MtdOriginalBudget) / CASE WHEN INC.MtdOriginalBudget <> 0 THEN INC.MtdOriginalBudget ELSE NULL END),0) AS MtdOriginalBudget,
	ISNULL(((INC.MtdReforecastQ1 + EP.MtdReforecastQ1) / CASE WHEN INC.MtdReforecastQ1 <> 0 THEN INC.MtdReforecastQ1 ELSE NULL END),0) AS MtdReforecastQ1,
	ISNULL(((INC.MtdReforecastQ2 + EP.MtdReforecastQ2) / CASE WHEN INC.MtdReforecastQ2 <> 0 THEN INC.MtdReforecastQ2 ELSE NULL END),0) AS MtdReforecastQ2,
	ISNULL(((INC.MtdReforecastQ3 + EP.MtdReforecastQ3) / CASE WHEN INC.MtdReforecastQ3 <> 0 THEN INC.MtdReforecastQ3 ELSE NULL END),0) AS MtdReforecastQ3,
	0 AS MtdVarianceQ0, --Done Below for it use these results to sub calculate
	0 AS MtdVarianceQ1, --Done Below for it use these results to sub calculate
	0 AS MtdVarianceQ2, --Done Below for it use these results to sub calculate
	0 AS MtdVarianceQ3, --Done Below for it use these results to sub calculate
	ISNULL(((INC.YtdActual + EP.YtdActual) / CASE WHEN INC.YtdActual <> 0 THEN INC.YtdActual ELSE NULL END),0) AS YtdActual,
	ISNULL(((INC.YtdOriginalBudget + EP.YtdOriginalBudget) / CASE WHEN INC.YtdOriginalBudget <> 0 THEN INC.YtdOriginalBudget ELSE NULL END),0) AS YtdOriginalBudget,
	ISNULL(((INC.YtdReforecastQ1 + EP.YtdReforecastQ1) / CASE WHEN INC.YtdReforecastQ1 <> 0 THEN INC.YtdReforecastQ1 ELSE NULL END),0) AS YtdReforecastQ1,
	ISNULL(((INC.YtdReforecastQ2 + EP.YtdReforecastQ2) / CASE WHEN INC.YtdReforecastQ2 <> 0 THEN INC.YtdReforecastQ2 ELSE NULL END),0) AS YtdReforecastQ2,
	ISNULL(((INC.YtdReforecastQ3 + EP.YtdReforecastQ3) / CASE WHEN INC.YtdReforecastQ3 <> 0 THEN INC.YtdReforecastQ3 ELSE NULL END),0) AS YtdReforecastQ3,
	0 AS YtdVarianceQ0, --Done Below for it use these results to sub calculate
	0 AS YtdVarianceQ1, --Done Below for it use these results to sub calculate
	0 AS YtdVarianceQ2, --Done Below for it use these results to sub calculate
	0 AS YtdVarianceQ3, --Done Below for it use these results to sub calculate
	ISNULL(((INC.AnnualOriginalBudget + EP.AnnualOriginalBudget) / CASE WHEN INC.AnnualOriginalBudget <> 0 THEN INC.AnnualOriginalBudget ELSE NULL END),0) AS AnnualOriginalBudget,
	ISNULL(((INC.AnnualReforecastQ1 + EP.AnnualReforecastQ1) / CASE WHEN INC.AnnualReforecastQ1 <> 0 THEN INC.AnnualReforecastQ1 ELSE NULL END),0) AS AnnualReforecastQ1,
	ISNULL(((INC.AnnualReforecastQ2 + EP.AnnualReforecastQ2) / CASE WHEN INC.AnnualReforecastQ2 <> 0 THEN INC.AnnualReforecastQ2 ELSE NULL END),0) AS AnnualReforecastQ2,
	ISNULL(((INC.AnnualReforecastQ3 + EP.AnnualReforecastQ3) / CASE WHEN INC.AnnualReforecastQ3 <> 0 THEN INC.AnnualReforecastQ3 ELSE NULL END),0) AS AnnualReforecastQ3
	
FROM	(
			SELECT
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

		FROM
			 #DetailResult t1
		WHERE
			t1.InflowOutflow				= 'Inflow'
		) INC
		CROSS JOIN (
			SELECT
				ISNULL(SUM(t1.MtdActual),0) MtdActual,
				ISNULL(SUM(t1.MtdOriginalBudget),0) MtdOriginalBudget,
				ISNULL(SUM(t1.MtdReforecastQ1),0) MtdReforecastQ1,
				ISNULL(SUM(t1.MtdReforecastQ2),0) MtdReforecastQ2,
				ISNULL(SUM(t1.MtdReforecastQ3),0) MtdReforecastQ3,
				ISNULL(SUM(t1.MtdVarianceQ0),0) MtdVarianceQ0,
				ISNULL(SUM(t1.MtdVarianceQ1),0) MtdVarianceQ1,
				ISNULL(SUM(t1.MtdVarianceQ2),0) MtdVarianceQ2,
				ISNULL(SUM(t1.MtdVarianceQ3),0) MtdVarianceQ3,
				ISNULL(SUM(t1.YtdActual),0) YtdActual,
				ISNULL(SUM(t1.YtdOriginalBudget),0) YtdOriginalBudget,
				ISNULL(SUM(t1.YtdReforecastQ1),0) YtdReforecastQ1,
				ISNULL(SUM(t1.YtdReforecastQ2),0) YtdReforecastQ2,
				ISNULL(SUM(t1.YtdReforecastQ3),0) YtdReforecastQ3,
				ISNULL(SUM(t1.YtdVarianceQ0),0) YtdVarianceQ0,
				ISNULL(SUM(t1.YtdVarianceQ1),0) YtdVarianceQ1,
				ISNULL(SUM(t1.YtdVarianceQ2),0) YtdVarianceQ2,
				ISNULL(SUM(t1.YtdVarianceQ3),0) YtdVarianceQ3,
				ISNULL(SUM(t1.AnnualOriginalBudget),0) AnnualOriginalBudget,
				ISNULL(SUM(t1.AnnualReforecastQ1),0) AnnualReforecastQ1,
				ISNULL(SUM(t1.AnnualReforecastQ2),0) AnnualReforecastQ2,
				ISNULL(SUM(t1.AnnualReforecastQ3),0) AnnualReforecastQ3

			FROM
				#DetailResult t1
			WHERE
				t1.InflowOutflow		= 'Ouflow' AND
				t1.ReimbursableName = 'Not Reimbursable'
		) EP

--Calculate the Profit Variance Columns
UPDATE #Result
SET		
	MtdVarianceQ0 = MtdActual - MtdOriginalBudget,
	MtdVarianceQ1 = MtdActual - MtdReforecastQ1,
	MtdVarianceQ2 = MtdActual - MtdReforecastQ2,
	MtdVarianceQ3 = MtdActual - MtdReforecastQ3,
	YtdVarianceQ0 = YtdActual - YtdOriginalBudget,
	YtdVarianceQ1 = YtdActual - YtdReforecastQ1,
	YtdVarianceQ2 = YtdActual - YtdReforecastQ2,
	YtdVarianceQ3 = YtdActual - YtdReforecastQ3

WHERE
	GroupDisplayCode = 'PROFITMARGIN' AND
	DisplayOrderNumber = 331	
		
		
--------------------------------------------------------------------------------------------------------------------------------------	
--Final Common block to set the Variance% columns
--------------------------------------------------------------------------------------------------------------------------------------	
		
UPDATE #Result
SET
	MtdVariancePercentageQ0 = ISNULL(MtdVarianceQ0 / CASE WHEN MtdOriginalBudget <> 0 THEN MtdOriginalBudget ELSE NULL END,0) ,
	MtdVariancePercentageQ1 = ISNULL(MtdVarianceQ1 / CASE WHEN MtdReforecastQ1 <> 0 THEN MtdReforecastQ1 ELSE NULL END,0) ,
	MtdVariancePercentageQ2 = ISNULL(MtdVarianceQ2 / CASE WHEN MtdReforecastQ2 <> 0 THEN MtdReforecastQ2 ELSE NULL END,0) ,
	MtdVariancePercentageQ3 = ISNULL(MtdVarianceQ3 / CASE WHEN MtdReforecastQ3 <> 0 THEN MtdReforecastQ3 ELSE NULL END,0) ,

	YtdVariancePercentageQ0 = ISNULL(YtdVarianceQ0 / CASE WHEN YtdOriginalBudget <> 0 THEN YtdOriginalBudget ELSE NULL END,0) ,
	YtdVariancePercentageQ1 = ISNULL(YtdVarianceQ1 / CASE WHEN YtdReforecastQ1 <> 0 THEN YtdReforecastQ1 ELSE NULL END,0) ,
	YtdVariancePercentageQ2 = ISNULL(YtdVarianceQ2 / CASE WHEN YtdReforecastQ2 <> 0 THEN YtdReforecastQ2 ELSE NULL END,0) ,
	YtdVariancePercentageQ3 = ISNULL(YtdVarianceQ3 / CASE WHEN YtdReforecastQ3 <> 0 THEN YtdReforecastQ3 ELSE NULL END,0) 
WHERE
	GroupDisplayCode NOT IN('Payroll Reimbursement Rate','Overhead Reimbursement Rate','PROFITMARGIN')

--UNKNOWN MajorCategory

INSERT INTO #Result
(
	NumberOfSpacesToPad, 
	GroupDisplayCode, 
	GroupDisplayName, 
	DisplayOrderNumber
)
SELECT
	0 NumberOfSpacesToPad,
	'BLANK' GroupDisplayCode,
	'',
	340 DisplayOrderNumber

INSERT INTO #Result
(
    NumberOfSpacesToPad, 
    GroupDisplayCode, 
    GroupDisplayName, 
    DisplayOrderNumber,
    MtdActual,
    MtdOriginalBudget,
    MtdReforecastQ1,
    MtdReforecastQ2,
    MtdReforecastQ3,
    MtdVarianceQ0,
    MtdVarianceQ1,
    MtdVarianceQ2,
    MtdVarianceQ3,
    YtdActual,	
    YtdOriginalBudget,
    YtdReforecastQ1,
    YtdReforecastQ2,
    YtdReforecastQ3,
    YtdVarianceQ0,
    YtdVarianceQ1,
    YtdVarianceQ2,
    YtdVarianceQ3,
    AnnualOriginalBudget,
    AnnualReforecastQ1,
    AnnualReforecastQ2,
    AnnualReforecastQ3
)
SELECT
	0 NumberOfSpacesToPad,
	'UNKNOWN' GroupDisplayCode,
	'Unknown',
	341 DisplayOrderNumber,
	ISNULL(SUM(t1.MtdActual),0),
	ISNULL(SUM(t1.MtdOriginalBudget),0),
	ISNULL(SUM(t1.MtdReforecastQ1),0),
	ISNULL(SUM(t1.MtdReforecastQ2),0),
	ISNULL(SUM(t1.MtdReforecastQ3),0),
	ISNULL(SUM(t1.MtdVarianceQ0),0),
	ISNULL(SUM(t1.MtdVarianceQ1),0),
	ISNULL(SUM(t1.MtdVarianceQ2),0),
	ISNULL(SUM(t1.MtdVarianceQ3),0),
	ISNULL(SUM(t1.YtdActual),0),
	ISNULL(SUM(t1.YtdOriginalBudget),0),
	ISNULL(SUM(t1.YtdReforecastQ1),0),
	ISNULL(SUM(t1.YtdReforecastQ2),0),
	ISNULL(SUM(t1.YtdReforecastQ3),0),
	ISNULL(SUM(t1.YtdVarianceQ0),0),
	ISNULL(SUM(t1.YtdVarianceQ1),0),
	ISNULL(SUM(t1.YtdVarianceQ2),0),
	ISNULL(SUM(t1.YtdVarianceQ3),0),
	ISNULL(SUM(t1.AnnualOriginalBudget),0),
	ISNULL(SUM(t1.AnnualReforecastQ1),0),
	ISNULL(SUM(t1.AnnualReforecastQ2),0),
	ISNULL(SUM(t1.AnnualReforecastQ3),0)

FROM
	#DetailResult t1
WHERE
	t1.MajorExpenseCategoryName	= 'UNKNOWN'
HAVING (
	ISNULL(SUM(t1.MtdActual),0) <> 0 OR 
	ISNULL(SUM(t1.MtdOriginalBudget),0) <> 0 OR 
	ISNULL(SUM(t1.MtdReforecastQ1),0) <> 0 OR 
	ISNULL(SUM(t1.MtdReforecastQ2),0) <> 0 OR 
	ISNULL(SUM(t1.MtdReforecastQ3),0) <> 0 OR 
	ISNULL(SUM(t1.MtdVarianceQ0),0) <> 0 OR 
	ISNULL(SUM(t1.MtdVarianceQ1),0) <> 0 OR 
	ISNULL(SUM(t1.MtdVarianceQ2),0) <> 0 OR 
	ISNULL(SUM(t1.MtdVarianceQ3),0) <> 0 OR 
	ISNULL(SUM(t1.YtdActual),0) <> 0 OR 
	ISNULL(SUM(t1.YtdOriginalBudget),0) <> 0 OR 
	ISNULL(SUM(t1.YtdReforecastQ1),0) <> 0 OR 
	ISNULL(SUM(t1.YtdReforecastQ2),0) <> 0 OR 
	ISNULL(SUM(t1.YtdReforecastQ3),0) <> 0 OR 
	ISNULL(SUM(t1.YtdVarianceQ0),0) <> 0 OR 
	ISNULL(SUM(t1.YtdVarianceQ1),0) <> 0 OR 
	ISNULL(SUM(t1.YtdVarianceQ2),0) <> 0 OR 
	ISNULL(SUM(t1.YtdVarianceQ3),0) <> 0 OR 
	ISNULL(SUM(t1.AnnualOriginalBudget),0) <> 0 OR 
	ISNULL(SUM(t1.AnnualReforecastQ1),0) <> 0 OR 
	ISNULL(SUM(t1.AnnualReforecastQ2),0) <> 0 OR 
	ISNULL(SUM(t1.AnnualReforecastQ3),0) <> 0
)




--------------------------------------------------------------------------------------------------------------------------------------	
--Final Result
--------------------------------------------------------------------------------------------------------------------------------------	

SELECT
	NumberOfSpacesToPad,
	GroupDisplayCode,
	REPLICATE(' ', NumberOfSpacesToPad) + GroupDisplayName AS GroupDisplayName,
	DisplayOrderNumber,
	MtdActual,
	MtdOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ1 END AS MtdReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ2 END AS MtdReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE MtdReforecastQ3 END AS MtdReforecastQ3,
	
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,

	MtdVariancePercentageQ0,
	MtdVariancePercentageQ1,
	MtdVariancePercentageQ2,
	MtdVariancePercentageQ3,
	
	YtdActual,
	YtdOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ1 END AS YtdReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ2 END AS YtdReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE YtdReforecastQ3 END AS YtdReforecastQ3,
	
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,

	YtdVariancePercentageQ0,
	YtdVariancePercentageQ1,
	YtdVariancePercentageQ2,
	YtdVariancePercentageQ3,
		
	AnnualOriginalBudget,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ1 END AS AnnualReforecastQ1,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ2 END AS AnnualReforecastQ2,
	CASE WHEN @ReforecastQuarterName = 'Q0' THEN 0 ELSE AnnualReforecastQ3 END AS AnnualReforecastQ3
FROM
	#Result
ORDER BY
	DisplayOrderNumber,
	#Result.GroupDisplayCode

--Second Resultset for Excel
--Select * From #DetailResult



SELECT
	ExpenseType,
	InflowOutflow,
	MajorExpenseCategoryName,
	MinorExpenseCategoryName,
	GlobalGlAccountCode,
	GlobalGlAccountName,
	BusinessLine,
	ActivityType,
	ReportingEntityName,
	ReportingEntityType,
	PropertyFundCode,
	FunctionalDepartmentCode,
	AllocationSubRegionName,
	OriginatingSubRegionName,

	ActualsExpensePeriod,
	EntryDate,
	[User],
	Description,
	AdditionalDescription,
	ReimbursableName,
	FeeAdjustmentCode,
	SourceName,
	GLCategorizationHierarchyKey,
	
	MtdActual,
	MtdOriginalBudget,
	MtdReforecastQ1,
	MtdReforecastQ2,
	MtdReforecastQ3,
	MtdVarianceQ0,
	MtdVarianceQ1,
	MtdVarianceQ2,
	MtdVarianceQ3,
	YtdActual,
	YtdOriginalBudget,
	YtdReforecastQ1,
	YtdReforecastQ2,
	YtdReforecastQ3,
	YtdVarianceQ0,
	YtdVarianceQ1,
	YtdVarianceQ2,
	YtdVarianceQ3,
	AnnualOriginalBudget,
	AnnualReforecastQ1,
	AnnualReforecastQ2,
	AnnualReforecastQ3,
	ConsolidationSubRegionName
FROM
	#DetailResult


   
IF 	OBJECT_ID('tempdb..#DetailResult') IS NOT NULL
    DROP TABLE #DetailResult
    
IF 	OBJECT_ID('tempdb..#Result') IS NOT NULL
    DROP TABLE #Result


--END




GO
