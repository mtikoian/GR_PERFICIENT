USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 12/05/2011 14:13:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_BudgetOwner_CC21Signature]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_BudgetOwner_CC21Signature]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_BudgetOwner]    Script Date: 12/05/2011 14:13:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*********************************************************************************************************************
Description
	The stored procedure is used for generating the data for the Budget Owner Report.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-08		: PKayongo	:	Sensitized payroll data for the MRI Source, Originating Region Code and 
											Property Fund fields. (CC20)
			2011-07-11		: PKayongo	:	Allowed reforecast values to be dynamically selected from the 
											@ReforecastQuarterName variable. Only 1 reforecast dynamic query remained
											and only the different reforecast fields at the end (i.e. Q1, Q2, Q3)
											were consolidated into 1.
			2011-08-08		: SNothling	:	Set sensitized strings to 'Sensitized' instead of ''

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_R_BudgetOwner_CC21Signature]
	@ReportExpensePeriod INT,
	@ReforecastQuarterName VARCHAR(2), --'Q0' or 'Q1' or 'Q2' or 'Q3'
	@DestinationCurrency VARCHAR(3),
	@EntityList VARCHAR(8000),
	@DontSensitizeMRIPayrollData BIT,
	@CalculationMethod VARCHAR(50),
	@OriginatingSubRegionList VARCHAR(8000),
	@AllocationSubRegionList VARCHAR(8000),
	@FunctionalDepartmentList VARCHAR(8000),	
	@HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail READONLY

AS
BEGIN
	--------------------------------------------------------------------------
	/*	Declare local variables - this makes debugging and testing easier	*/
	--------------------------------------------------------------------------
--PRINT 'Report Filter Variable Defaults '
--PRINT CONVERT(VARCHAR(8),GETDATE(),108) 

--	DECLARE @HierarchyReportParameter dbo.ReportParameterGLCategorizationHierarchyDetail  
--	INSERT INTO @HierarchyReportParameter 
--	VALUES(
--		N'7',
--		N'Budget Owner Report',
--		N'374',
--		N'Budget Owner: Marnix',
--		N'233',
--		N'Global',
--		N'0',
--		N'Non-Payroll',
--		N'0',
--		N'Travel, Meals & Lodging',
--		N'0',
--		N'Lodging',
--		NULL,
--		NULL,
--		N''
--	) 
	 
	----insert INTo @HierarchyReportParameter values(N'7',N'Budget Owner Report',N'374',N'Budget Owner: Marnix',N'233',N'Global',N'0',N'All',N'0',N'Fee Income',N'0',N'Asset Mgmt Fees',N'374',N'1',N'')  
	
	--SELECT 
	--*
	--FROM 
	--	@HierarchyReportParameter
			
	DECLARE
		@_ReportExpensePeriod INT = @ReportExpensePeriod,
		@_ReforecastQuarterName VARCHAR(10) = @ReforecastQuarterName,
		@_DestinationCurrency VARCHAR(3) = @DestinationCurrency,
		@_EntityList VARCHAR(max) = @EntityList,
		@_DontSensitizeMRIPayrollData BIT = @DontSensitizeMRIPayrollData,
		@_CalculationMethod VARCHAR(max) = @CalculationMethod,
		@_FunctionalDepartmentList VARCHAR (MAX) = @FunctionalDepartmentList,
		@_OriginatingSubRegionList VARCHAR(max)=@OriginatingSubRegionList,
		@_AllocationSubRegionList  VARCHAR(max)=@AllocationSubRegionList
				
	--IF LEN(@_EntityList) > 7998 OR
	--	LEN(@_AllocationSubRegionList) > 7998 OR
	--	LEN(@_OriginatingSubRegionList) > 7998
	--BEGIN
	--	RAISERROR('Filter List parameter is too big',9,1)
	--END

	--------------------------------------------------------------------------
	/*	Set up the Report Filter Variable defaults							*/
	--------------------------------------------------------------------------
PRINT 'Report Filter Variable Defaults '
PRINT CONVERT(VARCHAR(8),GETDATE(),108) 

	-- Calculate default report expense period if none specified
	IF @_ReportExpensePeriod IS NULL
	SET @_ReportExpensePeriod = CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + REPLACE(STR(MONTH(GETDATE()),2 ),' ','0')AS INT)

	-- Calculate destination currency if none specified
	IF @_DestinationCurrency IS NULL
	SET @_DestinationCurrency = 'USD'
	
	-- Pre-format Report Expense period string
	DECLARE @ReportExpensePeriodParameter VARCHAR(6)
	SET @ReportExpensePeriodParameter = STR(@_ReportExpensePeriod, 6, 0)

	-- Calculate default calendar year if none specified
	DECLARE @CalendarYear AS VARCHAR(10)
	SET @CalendarYear = SUBSTRING(CAST(@_ReportExpensePeriod AS VARCHAR(10)), 1, 4)

	-- Calculate default reforecast quarter name if not specified
	IF @_ReforecastQuarterName IS NULL OR 
	   @_ReforecastQuarterName NOT IN ('Q0', 'Q1', 'Q2', 'Q3')
		SET @_ReforecastQuarterName = (
			SELECT TOP 1
				ReforecastQuarterName 
			FROM 
				dbo.Reforecast 
			WHERE
				ReforecastEffectivePeriod <= @_ReportExpensePeriod AND 
				ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4)
			ORDER BY 
				ReforecastEffectivePeriod DESC
		)
									 
	---- Calculate reforecast effective period from reforecast name
	DECLARE @ReforecastEffectivePeriod INT

	SET @ReforecastEffectivePeriod = (
		SELECT TOP 1
			ReforecastEffectivePeriod 
		FROM 
			dbo.Reforecast 
		WHERE
			ReforecastEffectiveYear = LEFT(CAST(@_ReportExpensePeriod AS VARCHAR(6)),4) AND 
			ReforecastQuarterName = @_ReforecastQuarterName
		ORDER BY
			ReforecastEffectivePeriod
	)			

	-- Determine the ReforecastKey of the reforecast that is currently active (i.e.: 2011 Q1, 2011 Q2, 2012 Q0 etc)
	DECLARE @ActiveReforecastKey INT = (
		SELECT 
			ReforecastKey 
		FROM 
			dbo.GetReforecastRecord(@_ReportExpensePeriod, @_ReforecastQuarterName)
	)

	-- Safeguard against NULL ReforecastKey returned from previous statement
	BEGIN
	IF (@ActiveReforecastKey IS NULL) 
		SET @ActiveReforecastKey = (
			SELECT 
				MAX(ReforecastKey) 
			FROM 
				dbo.ExchangeRate
		)
		PRINT ('Near disaster: @ActiveReforecastKey is NULL, so reverting to the largest/most recent ReforecastKey in dbo.ExchangeRate: ' + CONVERT(VARCHAR(10), @ActiveReforecastKey))
	END
	
	--SELECT 'ActiveReforecastKey ' + CONVERT(varchar(20), @ActiveReforecastKey )
	
	--------------------------------------------------------------------------
	/*	Determine Report Exchange Rates	*/
	--------------------------------------------------------------------------

	SELECT
		SourceCurrencyKey,
		DestinationCurrencyKey,
		CalendarKey,
		Rate
	INTO #ExchangeRate
	FROM
		dbo.ExchangeRate
	WHERE
		ReforecastKey = @ActiveReforecastKey -- We will use the exchange rate set that is active for the current reforecast.

	--SELECT @ActiveReforecastKey
	--SELECT
	--*
	--FROM #ExchangeRate
	
	--------------------------------------------------------------------------
	--/*    Set Up Direct/Indirect Mapping Data            */
	--------------------------------------------------------------------------

	-- Change Control 14. CC Ref 5.4 Create Direct or Indirect field and map Direct to all the properties, and Indirect to all the Corporates	
	CREATE TABLE #DirectIndirectMapping
	(
		SourceName varchar(50) PRIMARY KEY ,
		DirectIndirect varchar (10),
	)
	
	INSERT INTO #DirectIndirectMapping
	SELECT 
		SourceName, 
		'Direct' AS 'DirectIndirect' 
	FROM 
		Source 
	WHERE 
		IsProperty = 'YES'
		
	UNION
	
	SELECT 
		SourceName, 
		'Indirect' AS 'DirectIndirect' 
	FROM 
		Source 
	WHERE 
		IsCorporate = 'YES'	
		
	UNION
	
	SELECT 
		SourceName, 
		'-' AS 'DirectIndirect'
	FROM 
		Source 
	WHERE 
		IsCorporate = 'NO' AND 
		IsProperty = 'NO'

	------------------------------------------------------------------------
	/*    Set Up Local/Non-Local Mapping Data					           */
	------------------------------------------------------------------------
	
CREATE TABLE #LocalNonLocalMapping
	(
      OriginatingRegionName varchar (50),
      OriginatingSubRegionName varchar(50),
      AllocationRegionName varchar (50),
      AllocationSubRegionName varchar(50),
      LocalNonLocal varchar (10),
	)
	
INSERT INTO #LocalNonLocalMapping
	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Local' 
	FROM 
		ProfitabilityActual
	INNER JOIN OriginatingRegion ON 
		ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
	INNER JOIN AllocationRegion ON 
		ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)
	
	UNION
	
	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Non-Local' 
	FROM 
		ProfitabilityActual
	INNER JOIN OriginatingRegion ON 
		ProfitabilityActual.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
	INNER JOIN AllocationRegion ON 
		ProfitabilityActual.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)
		
	UNION
	
	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Local' 
	FROM 
		ProfitabilityBudget
	INNER JOIN OriginatingRegion ON 
		ProfitabilityBudget.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
	INNER JOIN AllocationRegion ON 
		ProfitabilityBudget.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)
	
	UNION
	
	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Non-Local' 
	FROM 
		ProfitabilityBudget
	INNER JOIN OriginatingRegion ON 
		ProfitabilityBudget.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
	INNER JOIN AllocationRegion ON 
		ProfitabilityBudget.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)
		
	UNION
	
	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Local' 
	FROM 
		ProfitabilityReforecast
	INNER JOIN OriginatingRegion ON 
		ProfitabilityReforecast.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
	INNER JOIN AllocationRegion ON 
		ProfitabilityReforecast.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)
	
	UNION
	
	SELECT 
		OriginatingRegion.RegionName, 
		OriginatingRegion.SubRegionName, 
		AllocationRegion.RegionName, 
		AllocationRegion.SubRegionName, 
		'Non-Local' 
	FROM ProfitabilityReforecast
	INNER JOIN OriginatingRegion ON 
		ProfitabilityReforecast.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey 
	INNER JOIN AllocationRegion ON 
		ProfitabilityReforecast.AllocationRegionKey = AllocationRegion.AllocationRegionKey
	WHERE
		(
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName = 'China' AND 
			OriginatingRegion.RegionName <> 'China'
		)
		OR (
			OriginatingRegion.SubRegionName <> AllocationRegion.SubRegionName AND 
			AllocationRegion.RegionName <> 'China' AND 
			OriginatingRegion.RegionName = 'China'
		)
		
	--SELECT
	--*
	--FROM #LocalNonLocalMapping

	------------------------------------------------------------------------
	/*	Set up the Report Filter Tables										*/
	--------------------------------------------------------------------------

	-- Reporting Entities
	CREATE TABLE #EntityFilterTable	
	(
	PropertyFundKey INT NOT NULL,
	PropertyFundName VARCHAR(MAX) NOT NULL
	)

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #EntityFilterTable (PropertyFundKey)

	IF (@_EntityList IS NOT NULL)
	BEGIN	
		IF (@_EntityList <> 'All')
		BEGIN
			INSERT INTO #EntityFilterTable
			SELECT 
				PropertyFund.PropertyFundKey,
				PropertyFund.PropertyFundName
			FROM 
				dbo.Split(@_EntityList) EntityListParameters
			INNER JOIN PropertyFund ON 
				PropertyFund.PropertyFundName = EntityListParameters.item
		END
		ELSE IF (@_EntityList = 'All')
		BEGIN
			INSERT INTO #EntityFilterTable
			SELECT 
				PropertyFund.PropertyFundKey,
				PropertyFund.PropertyFundName
			FROM 
				PropertyFund
		END
	END
	
	--SELECT @_EntityList
	--SELECT
	--*
	--FROM #EntityFilterTable
	
	-- Originating Sub Regions
	CREATE TABLE #OriginatingSubRegionFilterTable 
	(
		OriginatingRegionKey INT NOT NULL,
		OriginatingRegionName VARCHAR(MAX) NOT NULL
	)	

	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #OriginatingSubRegionFilterTable (OriginatingRegionKey)
	
	IF (@_OriginatingSubRegionList IS NOT NULL)
	BEGIN	
		IF (@_OriginatingSubRegionList <> 'All')
		BEGIN
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT 
				OriginatingRegion.OriginatingRegionKey,
				OriginatingRegion.SubRegionName
			FROM 
				dbo.Split(@_OriginatingSubRegionList) OriginatingSubRegionParameters
			INNER JOIN OriginatingRegion ON 
				OriginatingRegion.SubRegionName = OriginatingSubRegionParameters.item
		END
		ELSE IF (@_OriginatingSubRegionList = 'All')
		BEGIN
			INSERT INTO #OriginatingSubRegionFilterTable
			SELECT 
				OriginatingRegion.OriginatingRegionKey,
				OriginatingRegion.SubRegionName
			FROM 
				OriginatingRegion
		END
	END
	
	--SELECT @_OriginatingSubRegionList
	--SELECT
	--*
	--FROM #OriginatingSubRegionFilterTable
	
	-- Allocation Sub Regions
	CREATE TABLE #AllocationSubRegionFilterTable 
	(
		AllocationRegionKey INT NOT NULL,
		AllocationRegionName VARCHAR(MAX) NOT NULL
	)
	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #AllocationSubRegionFilterTable	(AllocationRegionKey)
	
	IF (@_AllocationSubRegionList IS NOT NULL)
	BEGIN	
		IF (@_AllocationSubRegionList <> 'All')
		BEGIN
			INSERT INTO #AllocationSubRegionFilterTable
			SELECT
				AllocationRegion.AllocationRegionKey,
				AllocationRegion.SubRegionName
			FROM 
				dbo.Split(@_AllocationSubRegionList) AllocationSubRegionParameters
			INNER JOIN AllocationRegion ON
				AllocationRegion.SubRegionName = AllocationSubRegionParameters.item		
		END
		ELSE IF (@_AllocationSubRegionList = 'All')
		BEGIN
			INSERT INTO #AllocationSubRegionFilterTable
			SELECT 
				AllocationRegion.AllocationRegionKey,
				AllocationRegion.SubRegionName
			FROM 
				AllocationRegion
		END
	END
	
	--SELECT @_AllocationSubRegionList
	--SELECT
	--*
	--FROM #AllocationSubRegionFilterTable
	
	-- Functional Departments
	CREATE TABLE #FunctionalDepartmentFilterTable 
	(
		FunctionalDepartmentKey INT NOT NULL,
		FunctionalDepartmentName VARCHAR(MAX) NOT NULL
	)
	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #FunctionalDepartmentFilterTable	(FunctionalDepartmentKey)
	
	IF (@_FunctionalDepartmentList IS NOT NULL)
	BEGIN	
		IF (@_FunctionalDepartmentList <> 'All')
		BEGIN
			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT
				FunctionalDepartment.FunctionalDepartmentKey,
				FunctionalDepartment.FunctionalDepartmentName
			FROM 
				dbo.Split(@_FunctionalDepartmentList) FunctionalDepartmentParameters
			INNER JOIN FunctionalDepartment ON
				FunctionalDepartment.FunctionalDepartmentName = FunctionalDepartmentParameters.item		
		END
		ELSE IF (@_FunctionalDepartmentList = 'All')
		BEGIN
			INSERT INTO #FunctionalDepartmentFilterTable
			SELECT 
				FunctionalDepartment.FunctionalDepartmentKey,
				FunctionalDepartment.FunctionalDepartmentName
			FROM 
				FunctionalDepartment
		END
	END
	
	--SELECT @@_FunctionalDepartmentList
	--SELECT
	--*
	--FROM #FunctionalDepartmentFilterTable

	-- Categorization Hierarchy
	CREATE TABLE #CategorizationHierarchyFilterTable
	(
		CategorizationHierarchyKey INT NOT NULL,
		GLCategorizationName VARCHAR(50) NOT NULL,
		GLFinancialCategoryName VARCHAR(50) NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryName VARCHAR(50) NOT NULL,
		GLAccountCode VARCHAR(15) NOT NULL,
		GLAccountName VARCHAR(300) NOT NULL
	)
	
	CREATE UNIQUE CLUSTERED INDEX IX_CL ON #CategorizationHierarchyFilterTable (CategorizationHierarchyKey)
	
	INSERT INTO #CategorizationHierarchyFilterTable
	SELECT
		GLCategorizationHierarchy.GLCategorizationHierarchyKey,
		GLCategorizationHierarchy.GLCategorizationName,
		GLCategorizationHierarchy.GLFinancialCategoryName,
		GLCategorizationHierarchy.GLMajorCategoryName,
		GLCategorizationHierarchy.GLMinorCategoryName,
		GLCategorizationHierarchy.GLAccountCode,
		GLCategorizationHierarchy.GlAccountName
	FROM 
		@HierarchyReportParameter HierarchyReportParameter
	INNER JOIN GLCategorizationHierarchy ON
		(
			HierarchyReportParameter.FinancialCategoryName = 'All' OR
			HierarchyReportParameter.FinancialCategoryName = GLCategorizationHierarchy.GLFinancialCategoryName
		) AND
		(
			HierarchyReportParameter.GLMajorCategoryName = 'All' OR
			HierarchyReportParameter.GLMajorCategoryName = GLCategorizationHierarchy.GLMajorCategoryName
		) AND
		(
			HierarchyReportParameter.GLMinorCategoryName = 'All' OR
			HierarchyReportParameter.GLMinorCategoryName = GLCategorizationHierarchy.GLMinorCategoryName
		)
	WHERE
		-- IMS 51655
		GLCategorizationHierarchy.GLMinorCategoryName <> 'Architects & Engineering' AND
		InflowOutflow = 'Outflow'
		
		
	--SELECT
	--*
	--FROM @HierarchyReportParameter
	
	--SELECT
	--*
	--FROM #CategorizationHierarchyFilterTable
	
	--------------------------------------------------------------------------
	/*	Create results temp table											*/
	--------------------------------------------------------------------------

	CREATE TABLE #BudgetOwnerEntity
	(
		ActivityTypeKey					INT,	
		GlobalGLCategorizationKey		INT,
		ReportingGLCategorizationKey	INT,
		AllocationRegionKey				INT,
		OriginatingRegionKey			INT,
		FunctionalDepartmentKey			INT,
		PropertyFundKey					INT,
		SourceName						VARCHAR(50),
		EntryDate						VARCHAR(10),
		[User]							NVARCHAR(20),
		[Description]					NVARCHAR(60),
		AdditionalDescription			NVARCHAR(4000),
		PropertyFundCode				VARCHAR(11) DEFAULT(''), --VARCHAR, for this helps to keep reports size smaller
		OriginatingRegionCode			VARCHAR(30) DEFAULT(''), --VARCHAR, for this helps to keep reports size smaller
		FunctionalDepartmentCode		VARCHAR(15) DEFAULT(''),
		GlAccountCode					VARCHAR(15) DEFAULT(''),
		GlAccountName					VARCHAR(250) DEFAULT(''),
		CalendarPeriod					VARCHAR(6) DEFAULT(''),

		--Month to date	
		MtdGrossActual					MONEY,
		MtdGrossBudget					MONEY,
		MtdGrossReforecast				MONEY,
		
		MtdNetActual					MONEY,
		MtdNetBudget					MONEY,
		MtdNetReforecast				MONEY,
		
		--Year to date
		YtdGrossActual					MONEY,	
		YtdGrossBudget					MONEY, 
		YtdGrossReforecast				MONEY,
		
		YtdNetActual					MONEY, 
		YtdNetBudget					MONEY, 
		YtdNetReforecast				MONEY, 

		--Annual	
		AnnualGrossBudget				MONEY,
		AnnualGrossReforecast			MONEY,
		AnnualNetBudget					MONEY,
		AnnualNetReforecast				MONEY,

		--Annual estimated
		AnnualEstGrossBudget			MONEY,
		AnnualEstGrossReforecast		MONEY,
		AnnualEstNetBudget				MONEY,
		AnnualEstNetReforecast			MONEY
	)

	--------------------------------------------------------------------------
	/*	Get Profitability Actual Data											*/
	--------------------------------------------------------------------------
	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.ReportingGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END AS 'SourceName',
		--Source.SourceName,
		CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101) AS EntryDate,
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.PropertyFundCode
		END AS 'PropertyFundCode',
		--ProfitabilityActual.PropertyFundCode,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.OriginatingRegionCode
		END AS 'OriginatingRegionCode',
		--ProfitabilityActual.OriginatingRegionCode,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,
		Calendar.CalendarPeriod,
		SUM (
			#ExchangeRate.Rate *
			CASE WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN ProfitabilityActual.LocalActual 
			ELSE 0.0
			END
		) AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforeCast',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		SUM (
			#ExchangeRate.Rate *
			CASE 
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'YtdGrossActual',
		NULL AS 'YtdGrossBudget',
		NULL AS 'YtdGrossReforecast',
		SUM(
			#ExchangeRate.Rate * 
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'YtdNetActual',
		NULL AS 'YtdNetBudget',
		NULL AS 'YtdNetReforecast',
		NULL AS 'AnnualGrossBudget',
		NULL AS 'AnnualGrossReforecast',
		NULL AS 'AnnualNetBudget',
		NULL AS 'AnnualNetReforecast',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END 
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityActual.LocalActual
				ELSE 0.0
			END
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
				
	FROM 
		ProfitabilityActual 
	
	INNER JOIN #EntityFilterTable ON
		ProfitabilityActual.PropertyFundKey = #EntityFilterTable.PropertyFundKey
		
	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityActual.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityActual.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
		
	INNER JOIN #FunctionalDepartmentFilterTable ON
		ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
		
	INNER JOIN #ExchangeRate ON
		ProfitabilityActual.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityActual.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Overhead ON
		ProfitabilityActual.Overheadkey = Overhead.OverheadKey
		
	INNER JOIN Calendar ON
		ProfitabilityActual.CalendarKey = Calendar.CalendarKey
	
	INNER JOIN Source ON
		ProfitabilityActual.SourceKey = Source.SourceKey
	
	INNER JOIN Reimbursable ON
		ProfitabilityActual.ReimbursableKey = Reimbursable.ReimbursableKey
					
	INNER JOIN #CategorizationHierarchyFilterTable GlobalHierarchy ON
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
		
	WHERE 

		Overhead.OverheadName IN 
		(
			'Allocated',
			'UNKNOWN'
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityActual.ActivityTypeKey,
		ProfitabilityActual.GlobalGLCategorizationHierarchyKey,
		ProfitabilityActual.ReportingGLCategorizationHierarchyKey,
		ProfitabilityActual.AllocationRegionKey,
		ProfitabilityActual.OriginatingRegionKey,
		ProfitabilityActual.FunctionalDepartmentKey,
		ProfitabilityActual.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		--Source.SourceName,
		CONVERT(varchar(10),ISNULL(ProfitabilityActual.EntryDate,''), 101),
		ProfitabilityActual.[User],
		ProfitabilityActual.Description,
		ProfitabilityActual.AdditionalDescription,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.PropertyFundCode
		END,
		--ProfitabilityActual.PropertyFundCode,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE ProfitabilityActual.OriginatingRegionCode
		END,
		--ProfitabilityActual.OriginatingRegionCode,
		ProfitabilityActual.FunctionalDepartmentCode,
		GlobalHierarchy.GLAccountCode,
		GlobalHierarchy.GLAccountName,
		Calendar.CalendarPeriod

	--SELECT 
	--*
	--FROM #BudgetOwnerEntity

	--------------------------------------------------------------------------
	/*	Get Profitability Budget Data										*/
	--------------------------------------------------------------------------
	
	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.ReportingGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END AS 'SourceName',
		'' AS 'EntryDate',
		'' AS 'User',
		'' AS 'Description',
		'' AS 'AdditionalDescription',
		'' AS 'PropertyFundCode',
		'' AS 'OriginatingRegionCode',
		'' AS 'FunctionalDepartmentCode',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountCode
		END AS 'GLAccountCode',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountName
		END AS 'GLAccountName',	
		Calendar.CalendarPeriod,
		NULL AS 'MtdGrossActual',
		SUM (
			#ExchangeRate.Rate *
			CASE WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN ProfitabilityBudget.LocalBudget 
			ELSE 0.0
			END
		) AS 'MtdGrossBudget',
		NULL AS 'MtdGrossReforeCast',
		NULL AS 'MtdNetActual',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'MtdNetBudget',
		NULL AS 'MtdNetReforecast',
		NULL AS 'YtdGrossActual',
		SUM (
			#ExchangeRate.Rate *
			CASE 
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'YtdGrossBudget',
		NULL AS 'YtdGrossReforecast',
		NULL AS 'YtdNetActual',
		SUM(
			#ExchangeRate.Rate * 
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'YtdNetBudget',
		NULL AS 'YtdNetReforecast',
		SUM (
			#ExchangeRate.Rate *
			ProfitabilityBudget.LocalBudget	
		) AS 'AnnualGrossBudget',
		NULL AS 'AnnualGrossReforecast',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityBudget.LocalBudget
		) AS 'AnnualNetBudget',
		NULL AS 'AnnualNetReforecast',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN (Calendar.CalendarPeriod > @ReportExpensePeriodParameter) THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END 
		) AS 'AnnualEstGrossBudget',
		NULL AS 'AnnualEstGrossReforecast',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN (Calendar.CalendarPeriod > @ReportExpensePeriodParameter) THEN ProfitabilityBudget.LocalBudget
				ELSE 0.0
			END
		) AS 'AnnualEstNetBudget',
		NULL AS 'AnnualEstNetReforecast'
		
	FROM ProfitabilityBudget 
	
	INNER JOIN #EntityFilterTable ON
		ProfitabilityBudget.PropertyFundKey = #EntityFilterTable.PropertyFundKey
		
	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityBudget.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityBudget.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
		
	INNER JOIN #FunctionalDepartmentFilterTable ON
		ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
		
		
	INNER JOIN #ExchangeRate ON
		ProfitabilityBudget.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityBudget.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Overhead ON
		ProfitabilityBudget.Overheadkey = Overhead.OverheadKey
		
	INNER JOIN Calendar ON
		ProfitabilityBudget.CalendarKey = Calendar.CalendarKey
	
	INNER JOIN Source ON
		ProfitabilityBudget.SourceKey = Source.SourceKey
	
	INNER JOIN Reimbursable ON
		ProfitabilityBudget.ReimbursableKey = Reimbursable.ReimbursableKey
					
	INNER JOIN  #CategorizationHierarchyFilterTable GlobalHierarchy ON
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
		
	WHERE 
		Overhead.OverheadName IN 
		(
			'Allocated',
			'UNKNOWN'
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityBudget.ActivityTypeKey,
		ProfitabilityBudget.GlobalGLCategorizationHierarchyKey,
		ProfitabilityBudget.ReportingGLCategorizationHierarchyKey,
		ProfitabilityBudget.AllocationRegionKey,
		ProfitabilityBudget.OriginatingRegionKey,
		ProfitabilityBudget.FunctionalDepartmentKey,
		ProfitabilityBudget.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountCode
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountName
		END,	
		Calendar.CalendarPeriod
		
	--SELECT 
	--*
	--FROM #BudgetOwnerEntity
		
	--------------------------------------------------------------------------
	/*	Get Profitability Reforecast Data										*/
	--------------------------------------------------------------------------
	IF @_ReforecastQuarterName IN ('Q1', 'Q2', 'Q3')
	BEGIN

	INSERT INTO #BudgetOwnerEntity
	SELECT
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
		ProfitabilityReforecast.ReportingGLCategorizationHierarchyKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END AS 'SourceName',
		'' AS 'EntryDate',
		'' AS 'User',
		'' AS 'Description',
		'' AS 'AdditionalDescription',
		'' AS 'PropertyFundCode',
		'' AS 'OriginatingRegionCode',
		'' AS 'FunctionalDepartmentCode',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountCode
		END AS 'GLAccountCode',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountName
		END AS 'GLAccountName',	
		'' AS 'CalendarPeriod',
		NULL AS 'MtdGrossActual',
		NULL AS 'MtdGrossBudget',
		SUM (
			#ExchangeRate.Rate *
			CASE WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN ProfitabilityReforecast.LocalReforecast 
			ELSE 0.0
			END
		)  AS 'MtdGrossReforeCast',
		NULL AS 'MtdNetActual',
		NULL AS 'MtdNetBudget',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			CASE 
				WHEN (Calendar.CalendarPeriod = @ReportExpensePeriodParameter) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END
		) AS 'MtdNetReforecast',
		NULL AS 'YtdGrossActual',
		NULL AS 'YtdGrossBudget',
		SUM (
			#ExchangeRate.Rate *
			CASE 
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END
		) AS 'YtdGrossReforecast',
		NULL AS 'YtdNetActual',
		NULL AS 'YtdNetBudget',
		SUM(
			#ExchangeRate.Rate * 
			Reimbursable.MultiplicationFactor *
			CASE
				WHEN (Calendar.CalendarPeriod <= @ReportExpensePeriodParameter) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END
		) AS 'YtdNetReforecast',
		NULL AS 'AnnualGrossBudget',
		SUM (
			#ExchangeRate.Rate *
			ProfitabilityReforecast.LocalReforecast
		) AS 'AnnualGrossReforecast',
		NULL AS 'AnnualNetBudget',
		SUM (
			#ExchangeRate.Rate *
			Reimbursable.MultiplicationFactor *
			ProfitabilityReforecast.LocalReforecast
		) AS 'AnnualNetReforecast',
		NULL AS 'AnnualEstGrossBudget',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN (
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
					(
						LEFT (ProfitabilityReforecast.ReferenceCode, 3) = 'BC:' AND
						STR(@ReforecastEffectivePeriod,6,0) IN 
						(
							201003, 
							201006, 
							201009
						)
					)
				) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END 
		) AS 'AnnualEstGrossReforecast',
		NULL AS 'AnnualEstNetBudget',
		SUM (
			#ExchangeRate.Rate *
			CASE
				WHEN (
					Calendar.CalendarPeriod > @ReportExpensePeriodParameter OR 
					(
						LEFT (ProfitabilityReforecast.ReferenceCode, 3) = 'BC:' AND
						STR(@ReforecastEffectivePeriod,6,0) IN 
						(
							201003, 
							201006, 
							201009
						)
					)
				) THEN ProfitabilityReforecast.LocalReforecast
				ELSE 0.0
			END 
		) AS 'AnnualEstNetReforecast'
		
	FROM ProfitabilityReforecast 
	
	INNER JOIN #EntityFilterTable ON
		ProfitabilityReforecast.PropertyFundKey = #EntityFilterTable.PropertyFundKey
		
	INNER JOIN #OriginatingSubRegionFilterTable ON
		ProfitabilityReforecast.OriginatingRegionKey = #OriginatingSubRegionFilterTable.OriginatingRegionKey
		
	INNER JOIN #AllocationSubRegionFilterTable ON
		ProfitabilityReforecast.AllocationRegionKey = #AllocationSubRegionFilterTable.AllocationRegionKey
		
	INNER JOIN #FunctionalDepartmentFilterTable ON
		ProfitabilityActual.FunctionalDepartmentKey = #FunctionalDepartmentFilterTable.FunctionalDepartmentKey
				
	INNER JOIN #ExchangeRate ON
		ProfitabilityReforecast.LocalCurrencyKey = #ExchangeRate.SourceCurrencyKey AND
		ProfitabilityReforecast.CalendarKey = #ExchangeRate.CalendarKey
		
	INNER JOIN Currency ON
		#ExchangeRate.DestinationCurrencyKey = Currency.CurrencyKey
		
	INNER JOIN Overhead ON
		ProfitabilityReforecast.Overheadkey = Overhead.OverheadKey
		
	INNER JOIN Calendar ON
		ProfitabilityReforecast.CalendarKey = Calendar.CalendarKey
	
	INNER JOIN Source ON
		ProfitabilityReforecast.SourceKey = Source.SourceKey
	
	INNER JOIN Reimbursable ON
		ProfitabilityReforecast.ReimbursableKey = Reimbursable.ReimbursableKey
					
	INNER JOIN  #CategorizationHierarchyFilterTable GlobalHierarchy ON
		ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey = GlobalHierarchy.CategorizationHierarchyKey
		
	WHERE 
		Overhead.OverheadName IN 
		(
			'Allocated',
			'UNKNOWN'
		) AND
		Calendar.CalendarYear = STR(@CalendarYear, 10, 0) AND
		Currency.CurrencyCode = @_DestinationCurrency	
	GROUP BY
		ProfitabilityReforecast.ActivityTypeKey,
		ProfitabilityReforecast.GlobalGLCategorizationHierarchyKey,
		ProfitabilityReforecast.ReportingGLCategorizationHierarchyKey,
		ProfitabilityReforecast.AllocationRegionKey,
		ProfitabilityReforecast.OriginatingRegionKey,
		ProfitabilityReforecast.FunctionalDepartmentKey,
		ProfitabilityReforecast.PropertyFundKey,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'	
			ELSE Source.SourceName
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountCode
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchy.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized'
			ELSE GlobalHierarchy.GLAccountName
		END,	
		Calendar.CalendarPeriod

	END
	
	--SELECT 
	--*
	--FROM #BudgetOwnerEntity
	
	------------------------------------------------------------------------
	/*    ENTITY MODE					    						         */
	--------------------------------------------------------------------------
	
	--Entity Mode
	SELECT 
		ActivityType.ActivityTypeName AS 'ActivityTypeName',
		ActivityType.ActivityTypeName AS 'ActivityTypeFilterName',
		GlobalHierarchyInWarehouse.GLFinancialCategoryName AS 'GlobalFinancialCategory',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE GlobalHierarchyInWarehouse.GLMajorCategoryName 
		END AS 'GlobalMajorExpenseCategoryName',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE GlobalHierarchyInWarehouse.GLMinorCategoryName 
		END AS 'GlobalMinorExpenseCategoryName',
		ReportingHierarchyInWarehouse.GLFinancialCategoryName AS 'ReportingFinancialCategory',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE ReportingHierarchyInWarehouse.GLMajorCategoryName 
		END AS 'ReportingMajorExpenseCategoryName',
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE ReportingHierarchyInWarehouse.GLMinorCategoryName
		END AS 'ReportingMinorExpenseCategoryName',
		AllocationRegion.RegionName AS 'AllocationRegionName',
		AllocationRegion.SubRegionName AS 'AllocationSubRegionName',
		AllocationRegion.SubRegionName AS 'AllocationSubRegionFilterName',
		OriginatingRegion.RegionName AS 'OriginatingRegionName',
		OriginatingRegion.SubRegionName AS 'OriginatingSubRegionName',
		OriginatingRegion.SubRegionName AS 'OriginatingSubRegionFilterName',
		--NB!!!!!!!
		--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
		--get communicated to TS employees.
		CASE 
			WHEN 
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' 
			THEN 'Payroll' 
			ELSE FunctionalDepartment.FunctionalDepartmentName 
		END AS 'FunctionalDepartmentName',
		PropertyFund.PropertyFundType AS 'EntityType',
		PropertyFund.PropertyFundName AS 'EntityName',
		#BudgetOwnerEntity.CalendarPeriod AS 'ActualsExpensePeriod',
		#BudgetOwnerEntity.EntryDate AS 'EntryDate',
		#BudgetOwnerEntity.[User] AS 'User',
		#BudgetOwnerEntity.[Description] AS 'Description',
		#BudgetOwnerEntity.AdditionalDescription AS 'AdditionalDescription',
		#BudgetOwnerEntity.SourceName AS 'SourceName',
		#BudgetOwnerEntity.PropertyFundCode AS 'PropertyFundCode',
		CASE 
			WHEN 
				(SUBSTRING(#BudgetOwnerEntity.SourceName, CHARINDEX(' ', #BudgetOwnerEntity.SourceName) +1, 8) = 'Property') 
			THEN RTRIM(#BudgetOwnerEntity.OriginatingRegionCode) + LTRIM(#BudgetOwnerEntity.FunctionalDepartmentCode) 
			ELSE #BudgetOwnerEntity.OriginatingRegionCode 
		END AS 'OriginatingRegionCode',	    
		ISNULL(#BudgetOwnerEntity.GLAccountCode, '') AS 'GlAccountCode',
		ISNULL(#BudgetOwnerEntity.GLAccountName, '') AS 'GlAccountName',
		
		--Month to date    
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') THEN ISNULL(MtdGrossActual,0) 
				ELSE ISNULL(MtdNetActual,0) 
			END
		) AS 'MtdActual',
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') THEN ISNULL(MtdGrossBudget,0) 
				ELSE ISNULL(MtdNetBudget,0) 
			END
		) AS 'MtdOriginalBudget',
		
		----------
		
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') 
				THEN ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN MtdGrossBudget 
								ELSE MtdGrossReforecast
							END, 
							0
						) 
				ELSE ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN MtdNetBudget 
								ELSE MtdNetReforecast
							END,
							0
						) 
			END
		) AS 'MtdReforecast',
		
		----------
		
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') 
				THEN ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN MtdGrossBudget 
								ELSE MtdGrossReforecast
							END, 
							0
						) - ISNULL(MtdGrossActual, 0) 
				ELSE ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN MtdNetBudget 
								ELSE MtdNetReforecast
							END, 
							0
						) - ISNULL(MtdNetActual, 0) 
			END
		) AS 'MtdVariance',	
		
		----------
		
		--Year to date
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') THEN ISNULL(YtdGrossActual,0) 
				ELSE ISNULL(YtdNetActual,0) 
			END
		) AS 'YtdActual',
			
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') THEN ISNULL(YtdGrossBudget,0) 
				ELSE ISNULL(YtdNetBudget,0) 
			END
		) AS 'YtdOriginalBudget',
		
		----------
		
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') 
				THEN ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN YtdGrossBudget 
								ELSE YtdGrossReforecast 
							END,
							0
						) 
				ELSE ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN YtdNetBudget 
								ELSE YtdNetReforecast
							END,
							0
						) 
			END
		) AS 'YtdReforecast',

		----------
		
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') 
				THEN ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN YtdGrossBudget 
								ELSE YtdGrossReforecast
							END, 
							0
						) - ISNULL(YtdGrossActual, 0) 
				ELSE ISNULL(
							CASE 
								WHEN @_ReforecastQuarterName = 'Q0' THEN YtdNetBudget 
								ELSE YtdNetReforecast
							END, 
							0
						) - ISNULL(YtdNetActual, 0) 
			END
		) AS 'YtdVariance',

		----------
		
		--Annual
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') THEN ISNULL(AnnualGrossBudget,0) 
				ELSE ISNULL(AnnualNetBudget,0) 
			END
		) AS 'AnnualOriginalBudget',	
		
		----------
		
		SUM(
			CASE 
				WHEN (@_CalculationMethod = 'Gross') 
				THEN ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN 0 
							ELSE AnnualGrossReforecast
						END,
						0
					) 
				ELSE ISNULL(
						CASE 
							WHEN @_ReforecastQuarterName = 'Q0' THEN 0 
							ELSE AnnualNetReforecast
						END,
						0
					) 
			END
		) AS 'AnnualReforecast',
		#LocalNonLocalMapping.LocalNonLocal AS 'LocalNonLocal',
		#DirectIndirectMapping.DirectIndirect AS 'DirectIndirect'
		--
	INTO #Output
	FROM
		#BudgetOwnerEntity
		
		INNER JOIN AllocationRegion ON 
			#BudgetOwnerEntity.AllocationRegionKey = AllocationRegion.AllocationRegionKey
			
		INNER JOIN OriginatingRegion ON 
			#BudgetOwnerEntity.OriginatingRegionKey = OriginatingRegion.OriginatingRegionKey
			
		INNER JOIN FunctionalDepartment ON 
			#BudgetOwnerEntity.FunctionalDepartmentKey = FunctionalDepartment.FunctionalDepartmentKey
			
		INNER JOIN GLCategorizationHierarchy GlobalHierarchyInWarehouse ON
			#BudgetOwnerEntity.GlobalGLCategorizationKey = GlobalHierarchyInWarehouse.GLCategorizationHierarchyKey
		
		INNER JOIN GLCategorizationHierarchy ReportingHierarchyInWarehouse ON
			#BudgetOwnerEntity.ReportingGLCategorizationKey = ReportingHierarchyInWarehouse.GLCategorizationHierarchyKey
				
		INNER JOIN PropertyFund ON 
			#BudgetOwnerEntity.PropertyFundKey = PropertyFund.PropertyFundKey
			
		INNER JOIN ActivityType ON 
			#BudgetOwnerEntity.ActivityTypeKey = ActivityType.ActivityTypeKey
					
		INNER JOIN #LocalNonLocalMapping ON
			AllocationRegion.SubRegionName = #LocalNonLocalMapping.AllocationSubRegionName AND
			AllocationRegion.RegionName = #LocalNonLocalMapping.AllocationRegionName AND
			OriginatingRegion.SubRegionName = #LocalNonLocalMapping.OriginatingSubRegionName AND
			OriginatingRegion.RegionName = #LocalNonLocalMapping.OriginatingRegionName
			
		INNER JOIN #DirectIndirectMapping ON
			#BudgetOwnerEntity.SourceName = #DirectIndirectMapping.SourceName
			
	GROUP BY
		ActivityType.ActivityTypeName,
		ActivityType.ActivityTypeName,
		GlobalHierarchyInWarehouse.GLFinancialCategoryName,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE GlobalHierarchyInWarehouse.GLMajorCategoryName 
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE GlobalHierarchyInWarehouse.GLMinorCategoryName 
		END,
		ReportingHierarchyInWarehouse.GLFinancialCategoryName,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE ReportingHierarchyInWarehouse.GLMajorCategoryName 
		END,
		CASE
			WHEN @_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' THEN 'Sensitized' 
			ELSE ReportingHierarchyInWarehouse.GLMinorCategoryName
		END,
		AllocationRegion.RegionName,
		AllocationRegion.SubRegionName,
		AllocationRegion.SubRegionName,
		OriginatingRegion.RegionName,
		OriginatingRegion.SubRegionName,
		OriginatingRegion.SubRegionName,
		--NB!!!!!!!
		--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not 
		--get communicated to TS employees.
		CASE 
			WHEN 
				@_DontSensitizeMRIPayrollData = 0 AND GlobalHierarchyInWarehouse.GLMajorCategoryName = 'Salaries/Taxes/Benefits' 
			THEN 'Payroll' 
			ELSE FunctionalDepartment.FunctionalDepartmentName 
		END,
		PropertyFund.PropertyFundType,
		PropertyFund.PropertyFundName,
		#BudgetOwnerEntity.CalendarPeriod,
		#BudgetOwnerEntity.EntryDate,
		#BudgetOwnerEntity.[User],
		#BudgetOwnerEntity.[Description],
		#BudgetOwnerEntity.AdditionalDescription,
		#BudgetOwnerEntity.SourceName,
		#BudgetOwnerEntity.PropertyFundCode,
		CASE 
			WHEN 
				(SUBSTRING(#BudgetOwnerEntity.SourceName, CHARINDEX(' ', #BudgetOwnerEntity.SourceName) +1, 8) = 'Property') 
			THEN RTRIM(#BudgetOwnerEntity.OriginatingRegionCode) + LTRIM(#BudgetOwnerEntity.FunctionalDepartmentCode) 
			ELSE #BudgetOwnerEntity.OriginatingRegionCode 
		END,	    
		ISNULL(#BudgetOwnerEntity.GLAccountCode, ''),
		ISNULL(#BudgetOwnerEntity.GLAccountName, ''),
		#LocalNonLocalMapping.LocalNonLocal,
		#DirectIndirectMapping.DirectIndirect
		
	--------------------------------------------------------------------------
	/*    SELECT FINAL OUTPUT			    						         */
	--------------------------------------------------------------------------

	SELECT
		ActivityTypeName,
		ActivityTypeFilterName,
		GlobalFinancialCategory,
		GlobalMajorExpenseCategoryName,
		GlobalMinorExpenseCategoryName,
		ReportingFinancialCategory,
		ReportingMajorExpenseCategoryName,
		ReportingMinorExpenseCategoryName,
		AllocationRegionName,
		AllocationSubRegionName,
		AllocationSubRegionFilterName,
		OriginatingRegionName,
		OriginatingSubRegionName,
		OriginatingSubRegionFilterName,
		FunctionalDepartmentName,
		EntityType,
		EntityName,
		ActualsExpensePeriod,
		EntryDate,
		[User] AS 'User',
		CASE 
			WHEN (
					AnnualOriginalBudget <> 0 OR 
					AnnualReforecast <> 0
				) AND  
				(
					MtdActual = 0 OR 
					YtdActual = 0
				) THEN '[BUDGET/REFORECAST]' 
			ELSE Description 
		END AS 'Description',
		AdditionalDescription,
		SourceName,
		PropertyFundCode,
		OriginatingRegionCode,
		GlAccountCode,
		GlAccountName,
		--Month to date    
		MtdActual,
		MtdOriginalBudget,
		MtdReforecast,
		MtdVariance,
		
		--Year to date
		YtdActual,
		YtdOriginalBudget,
		YtdReforecast,
		YtdVariance,

		--Annual
		AnnualOriginalBudget,
		AnnualReforecast,
		LocalNonLocal AS 'LocalNonLocal',
		DirectIndirect AS 'DirectIndirect'
	FROM 
		#Output
	WHERE
		--Month to date    
		MtdActual <> 0.00 OR
		MtdOriginalBudget <> 0.00 OR
		MtdReforecast <> 0.00 OR
		MtdVariance <> 0.00 OR
		
		YtdActual <> 0.00 OR
		YtdOriginalBudget <> 0.00 OR
		YtdReforecast <> 0.00 OR
		YtdVariance <> 0.00 OR

		AnnualOriginalBudget <> 0.00 OR
		AnnualReforecast <> 0.00 
		
	--------------------------------------------------------------------------
	/*    CLEAN UP TEMP TABLES			    						         */
	--------------------------------------------------------------------------

	IF OBJECT_ID('tempdb..#EntityFilterTable') IS NOT NULL
		DROP TABLE #EntityFilterTable

	IF OBJECT_ID('tempdb..#ExchangeRate') IS NOT NULL
		DROP TABLE #ExchangeRate
		
	IF OBJECT_ID('tempdb..#OriginatingSubRegionFilterTable') IS NOT NULL
		DROP TABLE #OriginatingSubRegionFilterTable

	IF OBJECT_ID('tempdb..#AllocationSubRegionFilterTable') IS NOT NULL
		DROP TABLE #AllocationSubRegionFilterTable

	IF OBJECT_ID('tempdb..#CategorizationHierarchyFilterTable') IS NOT NULL
		DROP TABLE #CategorizationHierarchyFilterTable

	IF 	OBJECT_ID('tempdb..#BudgetOwnerEntity') IS NOT NULL
		DROP TABLE #BudgetOwnerEntity

	IF  OBJECT_ID('tempdb..#LocalNonLocalMapping') IS NOT NULL
		DROP TABLE #LocalNonLocalMapping
		
	IF  OBJECT_ID('tempdb..#DirectIndirectMapping') IS NOT NULL
		DROP TABLE #DirectIndirectMapping

	IF  OBJECT_ID('tempdb..#Output') IS NOT NULL
		DROP TABLE #Output
			
--SELECT 'Development' AS 'ActivityTypeName', 'Development' AS 'ActivityTypeFilterName', 'Non-Payroll' AS 'ExpenseType', 'USA' AS 'AllocationRegionName', 'Southern California' AS 'AllocationSubRegionName', 'Southern California' AS 'AllocationSubRegionFilterName', 'USA' AS 'OriginatingRegionName', 'New York' AS 'OriginatingSubRegionName', 'New York' AS 'OriginatingSubRegionFilterName', 'Accounting' AS 'FunctionalDepartmentName', 'Legal & Professional Fees' AS 'MajorExpenseCategoryName', 'Audit/Compliance Fees' AS 'MinorExpenseCategoryName', 'Property' AS 'EntityType', 'Playa Vista' AS 'EntityName', '201004' AS 'ActualsExpensePeriod', '04/30/2010' AS 'EntryDate', '' AS 'User', 'Reclass for global reporting                                ' AS 'Description', '' AS 'AdditionalDescription', 'USA Property' AS 'SourceName', 'CA8006     ' AS 'PropertyFundCode', 'NYSACC            ' AS 'OriginatingRegionCode', '6043110004' AS 'GLAccountCode', 'Audit/Compliance Fees (DEV)' AS 'GLAccountName', 0.00 AS 'MtdActual', 0.00 AS 'MtdOriginalBudget', 0.00 AS 'MtdReforecast', 0.00 AS 'MtdVariance', -4603.00 AS 'YtdActual', 0.00 AS 'YtdOriginalBudget', 0.00 AS 'YtdReforecast', 4603.00 AS 'YtdVariance', 0.00 AS 'AnnualOriginalBudget', 0.00 AS 'AnnualReforecast', 'Non-Local' AS 'LocalNonLocal', 'Direct' AS 'DirectIndirect' UNION ALL
--SELECT 'Property Management Escalatable',	 'Property Management Escalatable',			'Non-Payroll',					 'Europe',						 'United Kingdom',									 'United Kingdom',											 'USA',							 'New York',								 'New York',								 'Information Technology',					 'IT Costs & Telecommunications',							 'IT Infrastructure',									 '3rd party property',		 'LB Immo Investment', '201006', '06/30/2010', '', '    55052 6/25/2010 DS3 COLOMBUS         AT&T               ', '', 'USA Corporate', '008010     ', 'NY0200', '6550400005', 'IT Infrastructure (PME)', 0.00, 0.00, 0.00, 0.00, 9.60, 0.00, 0.00, -9.60, 0.00, 0.00, 'Non-Local', 'Indirect'  UNION ALL
--SELECT 'Property Management Escalatable',	 'Property Management Escalatable',			'Non-Payroll',					 'Europe',						 'United Kingdom',									 'United Kingdom',											 'USA',							 'New York',								 'New York',								 'Information Technology',					 'IT Costs & Telecommunications',							 'IT Infrastructure',									 '3rd party property',		 'LB Immo Investment', '201008', '08/31/2010', '', '    56766 8/30/2010 DS3 - COLUMBUS       AT&T               ', '', 'USA Corporate', '008015     ', 'NY0200', '6550400005', 'IT Infrastructure (PME)', 9.59, 0.00, 0.00, -9.59, 9.59, 0.00, 0.00, -9.59, 0.00, 0.00, 'Non-Local', 'Indirect'  UNION ALL
--SELECT 'Property Management Escalatable',	 'Property Management Escalatable',			'Non-Payroll',					 'Europe',						 'United Kingdom',									 'United Kingdom',											 'USA',							 'New York',								 'New York',								 'Information Technology',					 'IT Costs & Telecommunications',							 'IT Infrastructure',									 '3rd party property',		 'LB Immo Investment', '201008', '08/31/2010', '', '    56788 8/30/2010 Offsite Storage Tape IRON MOUNTAIN  -   ', '  OSDP  ', 'USA Corporate', '008015     ', 'NY0200', '6550400005', 'IT Infrastructure (PME)', 3.25, 0.00, 0.00, -3.25, 3.25, 0.00, 0.00, -3.25, 0.00, 0.00, 'Non-Local', 'Indirect'  UNION ALL
--SELECT 'Property Management Escalatable',	 'Property Management Escalatable',			'Non-Payroll',					 'Europe',						 'United Kingdom',									 'United Kingdom',											 'USA',							 'New York',								 'New York',								 'Information Technology',					 'IT Costs & Telecommunications',							 'IT Infrastructure',									 '3rd party property',		 'RREEF', '201008', '08/31/2010', '', '    56766 8/30/2010 UK SHARE - FRANKFURT AT&T               ', '', 'USA Corporate', '008001     ', 'NY0200', '6550400005', 'IT Infrastructure (PME)', 364.33, 0.00, 0.00, -364.33, 364.33, 0.00, 0.00, -364.33, 0.00, 0.00, 'Non-Local', 'Indirect'

END









GO


