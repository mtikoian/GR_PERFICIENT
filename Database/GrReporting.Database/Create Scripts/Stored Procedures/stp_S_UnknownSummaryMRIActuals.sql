 USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActuals]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActuals]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime,
@StartPeriod varchar(6),
@EndPeriod varchar(6),
@BudgetAllocationSetId int,
@GBSAccounts bit = 0
AS

--SET @StartPeriod = 201001
--SET @EndPeriod = 201009
--SET @BudgetYear = 2010
--SET @BudgetQuater = 'Q2'
--SET @DataPriorToDate = '2010-12-31'

--ActivityType
--GlAccount
--GlAccountCategory
--AllocationRegion
--OriginatingRegion
--FunctionalDepartment
--<<not included>>Overhead
--PropertyFund



IF OBJECT_ID('tempdb..#ValidationSummary') IS NOT NULL
	DROP TABLE #ValidationSummary
	
CREATE TABLE #ValidationSummary
(
	SourceCode CHAR(2) NOT NULL,
	ProfitabilityActualKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	HasActivityTypeUnknown TINYINT NULL,
	HasAllocationRegionUnknown TINYINT NULL,
	HasFunctionalDepartmentUnknown TINYINT NULL,
	HasGlAccountUnknown TINYINT NULL,
	HasGlAccountCategoryUnknown TINYINT NULL,
	HasOriginatingRegionUnknown TINYINT NULL,
	--HasOverheadUnknown TinyInt NULL,
	HasPropertyFundUnknown TINYINT NULL,
	InValidOriginatingRegionAndFunctionalDepartment TINYINT NULL DEFAULT(0),
	InValidActivityTypeAndEntity  TINYINT NULL DEFAULT(0)
)

--Step 1 :: Get all the unknowns

INSERT INTO #ValidationSummary
(
	SourceCode,
	ProfitabilityActualKey, 
	ReferenceCode, 
	HasActivityTypeUnknown,
	HasAllocationRegionUnknown, 
	HasFunctionalDepartmentUnknown,
	HasGlAccountUnknown,
	HasGlAccountCategoryUnknown, 
	HasOriginatingRegionUnknown,
	--HasOverheadUnknown, 
	HasPropertyFundUnknown
)

SELECT 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	CASE 
		WHEN pa.ActivityTypeKey = -1 THEN 1 
		ELSE 0 
	END HasActivityTypeUnknown, 
	CASE 
		WHEN pa.AllocationRegionKey = -1 THEN 1 
		ELSE 0 
	END HasAllocationRegionUnknown, 
	CASE 
		WHEN pa.FunctionalDepartmentKey = -1 AND 
			gac.FeeOrExpense <> 'INCOME' THEN 1 
		ELSE 0 
	END HasFunctionalDepartmentUnknown,
	CASE 
		WHEN pa.GlAccountKey = -1 THEN 1 
		ELSE 0 
	END HasGlAccountUnknown, 
	CASE 
		WHEN gac.MajorCategoryName LIKE '%unknown%' THEN 1 
		ELSE 0 
	END HasGlAccountCategoryUnknown, 
	CASE 
		WHEN pa.OriginatingRegionKey = -1 AND 
			gac.FeeOrExpense <> 'INCOME' THEN 1 
		ELSE 0 
	END HasOriginatingRegionUnknown,
	--CASE 
	--	WHEN pa.OverheadKey = -1 THEN 1 
	--	ELSE 0 
	-- END HasOverheadUnknown, 
	CASE 
		WHEN pa.PropertyFundKey = -1 THEN 1 
		ELSE 0 
	END HasPropertyFundUnknown
FROM ProfitabilityActual pa
INNER JOIN Calendar ca ON 
	ca.CalendarKey = pa.CalendarKey
INNER JOIN GlAccountCategory gac ON 
	gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
INNER JOIN [Source] ss ON 
	ss.SourceKey = pa.SourceKey
INNER JOIN ProfitabilityActualSourceTable pas ON 
	pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
WHERE
	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
	pas.SourceTable IN ('GHIS','JOURNAL') AND
	gac.MinorCategoryName <> 'Architects & Engineering' AND 
--Only WHERE one of the DimensionKey's are unknown
	(
		CASE 
			WHEN pa.ActivityTypeKey = -1 THEN 1 
			ELSE 0 
		END = 1 OR 
		CASE 
			WHEN pa.AllocationRegionKey = -1 THEN 1 
			ELSE 0 
		END = 1 OR
		CASE 
			WHEN pa.FunctionalDepartmentKey = -1 THEN 1 
			ELSE 0 
		END = 1 OR
		CASE 
			WHEN pa.GlAccountKey = -1 THEN 1 
			ELSE 0 
		END = 1 OR
		CASE 
			WHEN gac.MajorCategoryName LIKE '%unknown%' THEN 1 
			ELSE 0 
		END = 1 OR 
		CASE 
			WHEN pa.OriginatingRegionKey = -1 THEN 1 
			ELSE 0 
		END = 1 OR
		--CASE 
		--	WHEN pa.OverheadKey = -1 THEN 1 
		--	ELSE 0 
		--END = 1 OR
		CASE 
			WHEN pa.PropertyFundKey = -1 THEN 1 
			ELSE 0 
		END = 1
	)

-- Get all the MRI General Ledger Details. They are used to remove re-classed MRI items

IF OBJECT_ID('tempdb..#GeneralLedger') IS NOT NULL
	DROP TABLE #GeneralLedger
	
---------------------------------------------------------------------------------------
-- US
---------------------------------------------------------------------------------------

-- US Prop
SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
	
INTO #GeneralLedger

FROM GrReportingStaging.USProp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
	SourcePrimaryKey,
	MAX(SourceTableId) SourceTableId
	FROM
	GrReportingStaging.USProp.GeneralLedger Gl
	GROUP BY 
	SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId
		
LEFT OUTER JOIN (
	SELECT
	En.*
	FROM
	GrReportingStaging.USProp.ENTITY En
	INNER JOIN GrReportingStaging.USProp.EntityActive(@DataPriorToDate) EnA ON
	EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.PropertyFundCode

LEFT OUTER JOIN (
	SELECT
	Ga.*
	FROM
	GrReportingStaging.USProp.GACC Ga
	INNER JOIN GrReportingStaging.USProp.GAccActive(@DataPriorToDate) GaA ON
	GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode

LEFT OUTER JOIN (
	SELECT
	Dp.*
	FROM
	GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
	DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.RegionCode + Gl.FunctionalDepartmentCode

LEFT OUTER JOIN (
	SELECT
	Jb.*
	FROM
	GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
	JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
	
WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod		

UNION ALL

-- US Corp
SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.USCorp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.USCorp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId

LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.USCorp.ENTITY En
	INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
En.EntityId = Gl.RegionCode

LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.USCorp.GACC Ga
	INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode

LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode

LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
				
WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod	

UNION ALL

---------------------------------------------------------------------------------------
-- EU
---------------------------------------------------------------------------------------

-- EU Prop
SELECT 
		Gl.Period,
		Gl.Item,
		Gl.Ref,
		Gl.SiteID,
		En.EntityID,
		En.NAME EntityName,
		Gl.GlAccountCode,
		Ga.ACCTNAME GlAccountName,
		Dp.Department,
		Dp.Description DepartmentDescription,
		Jb.JobCode,
		Jb.Description JobCodeDescription,
		gl.Amount,
		gl.Description,
		Gl.EnterDate,
		Gl.Reversal,
		Gl.Status,
		Gl.Basis,
		Gl.UserId,
		Gl.CorporateDepartmentCode,
		Gl.SourceCode,
		Gl.SourcePrimaryKey,
		Gl.[Source]
FROM GrReportingStaging.EUProp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.EUProp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId

LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.EUProp.ENTITY En
	INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.PropertyFundCode

LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.EUProp.GACC Ga
	INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode

LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.RegionCode + Gl.FunctionalDepartmentCode

LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source

WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
	
UNION ALL

-- EU Corp
SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]

FROM GrReportingStaging.EUCorp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.EUCorp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId

LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.EUCorp.ENTITY En
	INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.RegionCode

LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.EUCorp.GACC Ga
	INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode

LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode

LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source

WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
	
UNION ALL
	
---------------------------------------------------------------------------------------
-- BR
---------------------------------------------------------------------------------------

-- BR Prop

SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	NULL JobCode,
	NULL JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.BRProp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.BRProp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId
LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.BRProp.ENTITY En
	INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.PropertyFundCode
LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.BRProp.GACC Ga
	INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode
LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.RegionCode + Gl.FunctionalDepartmentCode
WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
	
UNION ALL

-- BR Corp

SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.BRCorp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.BRCorp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId

LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.BRCorp.ENTITY En
	INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.RegionCode

LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.BRCorp.GACC Ga
	INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode

LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode

LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source

WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod	

UNION ALL

---------------------------------------------------------------------------------------
-- IN
---------------------------------------------------------------------------------------

-- IN Prop

SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	NULL JobCode,
	NULL JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.INProp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
	SourcePrimaryKey,
	MAX(SourceTableId) SourceTableId
	FROM
	GrReportingStaging.INProp.GeneralLedger Gl
	GROUP BY 
	SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId
LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.INProp.ENTITY En
	INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) EnA ON
	EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.PropertyFundCode
LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.INProp.GACC Ga
	INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode
LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.RegionCode + Gl.FunctionalDepartmentCode
WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod
		
UNION ALL

-- IN Corp
SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.INCorp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.INCorp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId
LEFT OUTER JOIN (
	SELECT
		En.*
	FROM
		GrReportingStaging.INCorp.ENTITY En
	INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.RegionCode
LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.INCorp.GACC Ga
	INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode
LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode
LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod
		
UNION ALL

---------------------------------------------------------------------------------------
-- CN
---------------------------------------------------------------------------------------

-- CN Prop

SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.CNProp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.CNProp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId
LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.CNProp.ENTITY En
	INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) EnA ON
		EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.PropertyFundCode
LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.CNProp.GACC Ga
	INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode
LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.RegionCode + Gl.FunctionalDepartmentCode
LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
WHERE 
	Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
	
UNION ALL

-- CN Corp
SELECT 
	Gl.Period,
	Gl.Item,
	Gl.Ref,
	Gl.SiteID,
	En.EntityID,
	En.NAME EntityName,
	Gl.GlAccountCode,
	Ga.ACCTNAME GlAccountName,
	Dp.Department,
	Dp.Description DepartmentDescription,
	Jb.JobCode,
	Jb.Description JobCodeDescription,
	gl.Amount,
	gl.Description,
	Gl.EnterDate,
	Gl.Reversal,
	Gl.Status,
	Gl.Basis,
	Gl.UserId,
	Gl.CorporateDepartmentCode,
	Gl.SourceCode,
	Gl.SourcePrimaryKey,
	Gl.[Source]
FROM GrReportingStaging.CNCorp.GeneralLedger Gl
INNER JOIN (
	--This allows JOURNAL&GHIS to each have a record with the same PK,
	--but that is incorrect data and as such GR will pick GHIS as the 
	--more accurate data, for it is posted data, WHERE journal data is still open data
	SELECT 
		SourcePrimaryKey,
		MAX(SourceTableId) SourceTableId
	FROM GrReportingStaging.CNCorp.GeneralLedger Gl
	GROUP BY 
		SourcePrimaryKey
) t1 ON
	t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
	t1.SourceTableId = Gl.SourceTableId
LEFT OUTER JOIN (
	SELECT
		En.*
	FROM GrReportingStaging.CNCorp.ENTITY En
	INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
	EnA.ImportKey = En.ImportKey
) En ON
	En.EntityId = Gl.RegionCode
LEFT OUTER JOIN (
	SELECT
		Ga.*
	FROM GrReportingStaging.CNCorp.GACC Ga
	INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) GaA ON
		GaA.ImportKey = Ga.ImportKey
) Ga ON
	Ga.ACCTNUM = Gl.GlAccountCode
LEFT OUTER JOIN (
	SELECT
		Dp.*
	FROM GrReportingStaging.Gacs.Department  Dp
	INNER JOIN GrReportingStaging.Gacs.DepartmentActive(@DataPriorToDate) DpA ON
		DpA.ImportKey = Dp.ImportKey
) Dp ON
	Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode

LEFT OUTER JOIN (
	SELECT
		Jb.*
	FROM GrReportingStaging.Gacs.JobCode Jb
	INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
		JbA.ImportKey = Jb.ImportKey
) Jb ON
	Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source



IF OBJECT_ID('tempdb..#PropertyHeaderSum') IS NOT NULL
	DROP TABLE #PropertyHeaderSum

SELECT 
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode, 
	SUM(LEDGER.Amount) Amount
INTO #PropertyHeaderSum
FROM GrReportingStaging.USPROP.GeneralLedger LEDGER 
LEFT OUTER JOIN (
	SELECT 
		GACC.ACCTNUM, 
		GACC.ISGR
	FROM GrReportingStaging.USPROP.GACC
	INNER JOIN GrReportingStaging.USPROP.GAccActive(@DataPriorToDate) GaA ON 
		GaA.ImportKey = GACC.ImportKey
) GACC ON 
	LEDGER.GlAccountCode = GACC.ACCTNUM
WHERE 
	LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
	LEDGER.Basis IN ('A','B') AND 
	GACC.ISGR = 'Y' AND 
	EXISTS(
		SELECT 
			NULL 
		FROM GrReportingStaging.USPROP.GACC G
		WHERE 
			G.ISGR = 'Y' AND 
			LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
			G.ACCTNUM <> GACC.ACCTNUM
	) AND 
	RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
GROUP BY
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode
	
UNION ALL
 
SELECT 
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode, 
	SUM(LEDGER.Amount)
FROM GrReportingStaging.EUPROP.GeneralLedger LEDGER 
LEFT OUTER JOIN (
	SELECT 
		GACC.ACCTNUM, 
		GACC.ISGR
	FROM GrReportingStaging.EUPROP.GACC
	INNER JOIN GrReportingStaging.EUPROP.GAccActive(@DataPriorToDate) GaA ON 
		GaA.ImportKey = GACC.ImportKey
) GACC ON 
	LEDGER.GlAccountCode = GACC.ACCTNUM
WHERE 
	LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
	LEDGER.Basis IN ('A','B') AND 
	GACC.ISGR = 'Y' AND 
	EXISTS(
		SELECT 
			NULL 
		FROM GrReportingStaging.EUPROP.GACC G
		WHERE 
			G.ISGR = 'Y' AND 
			LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
			G.ACCTNUM <> GACC.ACCTNUM
	)
	AND RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
GROUP BY
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode
	
UNION ALL 

SELECT 
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode, 
	SUM(LEDGER.Amount)
FROM GrReportingStaging.CNPROP.GeneralLedger LEDGER 
LEFT OUTER JOIN (
	SELECT 
		GACC.ACCTNUM, 
		GACC.ISGR
	FROM GrReportingStaging.CNCorp.GACC
	INNER JOIN GrReportingStaging.CNPROP.GAccActive(@DataPriorToDate) GaA ON 
		GaA.ImportKey = GACC.ImportKey
) GACC ON 
	LEDGER.GlAccountCode = GACC.ACCTNUM
WHERE 
	LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
	LEDGER.Basis IN ('A','B') AND
	GACC.ISGR = 'Y' AND 
	EXISTS(
		SELECT 
			NULL 
		FROM GrReportingStaging.CNPROP.GACC G
		WHERE 
			G.ISGR = 'Y' AND 
			LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
			G.ACCTNUM <> GACC.ACCTNUM
	)AND 
	RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
GROUP BY
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode
	
UNION ALL 

SELECT 
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode, 
	SUM(LEDGER.Amount) 
FROM GrReportingStaging.INPROP.GeneralLedger LEDGER 
LEFT OUTER JOIN (
	SELECT 
		GACC.ACCTNUM, 
		GACC.ISGR
	FROM GrReportingStaging.INPROP.GACC
	INNER JOIN GrReportingStaging.INPROP.GAccActive(@DataPriorToDate) GaA ON 
		GaA.ImportKey = GACC.ImportKey
) GACC ON 
	LEDGER.GlAccountCode = GACC.ACCTNUM
WHERE 
	LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
	LEDGER.Basis IN ('A','B') AND 
	GACC.ISGR = 'Y' AND 
	EXISTS(
		SELECT 
			NULL 
		FROM GrReportingStaging.INPROP.GACC G
		WHERE 
			G.ISGR = 'Y' AND 
			LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
			G.ACCTNUM <> GACC.ACCTNUM
	) AND 
	RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
GROUP BY
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode
	
UNION ALL 

SELECT 
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode, 
	SUM(LEDGER.Amount) 
FROM GrReportingStaging.BRPROP.GeneralLedger LEDGER 
LEFT OUTER JOIN (
	SELECT 
		GACC.ACCTNUM, 
		GACC.ISGR
	FROM GrReportingStaging.BRPROP.GACC
	INNER JOIN GrReportingStaging.BRPROP.GAccActive(@DataPriorToDate) GaA ON 
		GaA.ImportKey = GACC.ImportKey
) GACC ON 
	LEDGER.GlAccountCode = GACC.ACCTNUM
WHERE 
	LEDGER.Period BETWEEN @StartPeriod AND @EndPeriod AND 
	LEDGER.Basis IN ('A','B') AND 
	GACC.ISGR = 'Y' AND 
	EXISTS(
		SELECT 
			NULL 
		FROM GrReportingStaging.BRPROP.GACC G
		WHERE 
			G.ISGR = 'Y' AND 
			LEFT(G.ACCTNUM, 10) = LEFT(GACC.ACCTNUM, 10) AND 
			G.ACCTNUM <> GACC.ACCTNUM
	) AND 
	RIGHT(RTRIM(GACC.ACCTNUM), 2) = '00'
GROUP BY
	LEDGER.SourceCode, 
	LEDGER.EntityID, 
	LEDGER.GlAccountCode	

IF OBJECT_ID('tempdb..#CorporateDescSum') IS NOT NULL
	DROP TABLE #CorporateDescSum
	
SELECT
	gl.SourceCode,
	gl.EntityID,
	gl.Source,
	ISNULL(gl.JobCode,'') JobCode,
	ISNULL(gl.Description,'') Description,
	SUM(gl.Amount) AS Amount
INTO
	#CorporateDescSum
FROM					
	#GeneralLedger gl	
WHERE
	RIGHT(gl.SourceCode, 1) = 'C'
GROUP BY
	gl.SourceCode,
	gl.EntityID,
	gl.Source,
	gl.JobCode,
	gl.Description
		
--Step 2 :: Remove ActivityType unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0

UPDATE #ValidationSummary
SET	
	HasActivityTypeUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasActivityTypeUnknown = 1
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE	
	#ValidationSummary.HasActivityTypeUnknown = 1 AND
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND
	#ValidationSummary.SourceCode = gl.SourceCode
 
--Step 3 :: Remove GlAccount unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0

UPDATE #ValidationSummary
SET	
	HasGlAccountUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasGlAccountUnknown = 1
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE 
	#ValidationSummary.HasGlAccountUnknown = 1 AND 
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND	
	#ValidationSummary.SourceCode = gl.SourceCode

--Step 4 :: Remove GlAccountCategory unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0
UPDATE #ValidationSummary
SET	
	HasGlAccountCategoryUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasGlAccountCategoryUnknown = 1
	GROUP BY 
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE 
	#ValidationSummary.HasGlAccountCategoryUnknown = 1 AND
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND	
	#ValidationSummary.SourceCode = gl.SourceCode

--Step 4 :: Remove AllocationRegion unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0
UPDATE #ValidationSummary
SET	
	HasAllocationRegionUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasAllocationRegionUnknown = 1
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE	
	#ValidationSummary.HasAllocationRegionUnknown = 1 AND
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND	
	#ValidationSummary.SourceCode = gl.SourceCode

--Step 5 :: Remove OriginatingRegion unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0
UPDATE #ValidationSummary
SET	
	HasOriginatingRegionUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasOriginatingRegionUnknown = 1
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE	
	#ValidationSummary.HasOriginatingRegionUnknown = 1 AND
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND
	#ValidationSummary.SourceCode = gl.SourceCode

--Step 6 :: Remove FunctionalDepartment unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0
UPDATE #ValidationSummary
SET	
	HasFunctionalDepartmentUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
 	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasFunctionalDepartmentUnknown = 1
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE	
	#ValidationSummary.HasFunctionalDepartmentUnknown = 1 AND
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND
	#ValidationSummary.SourceCode = gl.SourceCode

--Step 7 :: Remove PropertyFund unknowns FROM #ValidationSummary, that have been re-classed and now net out to 0
UPDATE #ValidationSummary
SET	
	HasPropertyFundUnknown = 0
FROM #GeneralLedger gl 
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #ValidationSummary vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	WHERE 
		vs.HasPropertyFundUnknown = 1
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
WHERE	
	#ValidationSummary.HasPropertyFundUnknown = 1 AND
	#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey AND
	#ValidationSummary.SourceCode = gl.SourceCode

-----------------------------------------------------------------------------------------------------------------------------------------------
--Step 8 :: OriginatingRegion & FunctionalDepartment Combination
--Sheet 1 :: OriginatingSubRegion And FunctionalDepartment

IF OBJECT_ID('tempdb..#ValidRegionAndFunctionalDepartment') IS NOT NULL
	DROP TABLE #ValidRegionAndFunctionalDepartment

CREATE TABLE #ValidRegionAndFunctionalDepartment
(
	OriginatingSubRegionName Varchar(50) NOT NULL,
	FunctionalDepartmentName Varchar(50) NOT NULL
)
INSERT INTO #ValidRegionAndFunctionalDepartment
(
	FunctionalDepartmentName,
	OriginatingSubRegionName
)
EXEC [stp_S_ValidPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuarter,
	@DataPriorToDate = @DataPriorToDate

INSERT INTO #ValidRegionAndFunctionalDepartment
(
	FunctionalDepartmentName,
	OriginatingSubRegionName
)
EXEC [stp_S_ValidNonPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuarter,
	@DataPriorToDate = @DataPriorToDate

--Add additional entries provided by Martin: IMS 56718
INSERT INTO #ValidRegionAndFunctionalDepartment
(
	OriginatingSubRegionName, 
	FunctionalDepartmentName
)
SELECT 
	t1.OriginatingSubRegionName, 
	t1.FunctionalDepartmentName 
FROM AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment t1
LEFT OUTER JOIN #ValidRegionAndFunctionalDepartment t2 ON 
	t2.OriginatingSubRegionName = t1.OriginatingSubRegionName AND
	t2.FunctionalDepartmentName = t1.FunctionalDepartmentName
WHERE 
	t2.FunctionalDepartmentName IS NULL

IF OBJECT_ID('tempdb..#InvalidRegionAndFunctDeptCombination') IS NOT NULL
	DROP TABLE #InvalidRegionAndFunctDeptCombination
	
SELECT  
	s.SourceCode,
	pa.ReferenceCode,
	fd.FunctionalDepartmentName,
	orr.SubRegionName
INTO #InvalidRegionAndFunctDeptCombination
FROM ProfitabilityActual pa
INNER JOIN ProfitabilityActualSourceTable pas ON 
	pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
INNER JOIN [Source] s ON 
	s.SourceKey = pa.SourceKey
LEFT OUTER JOIN FunctionalDepartment fd ON 
	fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
LEFT OUTER JOIN OriginatingRegion orr ON 
	orr.OriginatingRegionKey = pa.OriginatingRegionKey
LEFT OUTER JOIN GlAccountCategory gac ON 
	gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
LEFT OUTER JOIN #ValidRegionAndFunctionalDepartment vs ON 
	vs.FunctionalDepartmentName = fd.FunctionalDepartmentName
AND vs.OriginatingSubRegionName = orr.SubRegionName
WHERE	
	vs.FunctionalDepartmentName IS NULL AND
	pas.SourceTable IN ('GHIS','JOURNAL') AND
	--IMS 56718 : Revenue should not be validated against a specific functional department/originating region 		
	gac.FeeOrExpense <> 'INCOME' AND
	gac.MinorCategoryName <> 'Architects & Engineering'

--Remove FROM this table the items, that the reclass logic already fixed the issue at hand
DELETE t1 
FROM #InvalidRegionAndFunctDeptCombination t1
INNER JOIN #GeneralLedger gl ON 
	gl.SourcePrimaryKey = t1.ReferenceCode AND 
	gl.SourceCode = t1.SourceCode
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #InvalidRegionAndFunctDeptCombination vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode

--UPDATEd the existing rows in #ValidationSummary WHERE FunctionalDepartment&OriginatingRegion combination is not valid
UPDATE #ValidationSummary
SET	
	InValidOriginatingRegionAndFunctionalDepartment = 1
FROM #InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination
WHERE
	#ValidationSummary.ReferenceCode = InvalidRegionAndFunctDeptCombination.ReferenceCode AND
	#ValidationSummary.SourceCode = InvalidRegionAndFunctDeptCombination.SourceCode

--Insert only WHERE FunctionalDepartment&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
INSERT INTO #ValidationSummary
(
	SourceCode,
	ProfitabilityActualKey, 
	ReferenceCode, 
	HasActivityTypeUnknown, 
	HasAllocationRegionUnknown, 
	HasFunctionalDepartmentUnknown,
	HasGlAccountUnknown, 
	HasGlAccountCategoryUnknown, 
	HasOriginatingRegionUnknown,
	--HasOverheadUnknown, 
	HasPropertyFundUnknown,
	InValidOriginatingRegionAndFunctionalDepartment
)
SELECT 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	0 HasActivityTypeUnknown, 
	0 HasAllocationRegionUnknown, 
	0 HasFunctionalDepartmentUnknown,
	0 HasGlAccountUnknown, 
	0 HasGlAccountCategoryUnknown, 
	0 HasOriginatingRegionUnknown,
	--1 HasOverheadUnknown, 
	0 HasPropertyFundUnknown,
	1 InValidOriginatingRegionAndFunctionalDepartment
FROM ProfitabilityActual pa
INNER JOIN ProfitabilityActualSourceTable pas ON 
	pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
INNER JOIN Calendar ca ON 
	ca.CalendarKey = pa.CalendarKey
INNER JOIN GlAccountCategory gac ON 
	gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
INNER JOIN [Source] ss ON 
ss.SourceKey = pa.SourceKey
LEFT OUTER JOIN #ValidationSummary existing ON 
	existing.SourceCode = ss.SourceCode AND 
	existing.ReferenceCode = pa.ReferenceCode
INNER JOIN #InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination ON
	InvalidRegionAndFunctDeptCombination.ReferenceCode = pa.ReferenceCode AND 
	InvalidRegionAndFunctDeptCombination.SourceCode = ss.SourceCode
WHERE
	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND 
	existing.ReferenceCode IS NULL AND--Not in table yet 		
	pas.SourceTable IN ('GHIS','JOURNAL') AND
	gac.MinorCategoryName <> 'Architects & Engineering'

---------------------------------------------------------------------------------------------------------------------------------------
--Sheet 2 :: Entity ActivityType Validation

IF OBJECT_ID('tempdb..#HolisticReviewExportTemp') IS NOT NULL
	DROP TABLE #HolisticReviewExportTemp

CREATE TABLE #HolisticReviewExportTemp
(	
	ProjectCode VARCHAR(20) NULL,
	ProjectName VARCHAR(100) NULL,
	ProjectEndPeriod INT NULL,
	ActivityType VARCHAR(50) NULL,
	PropertyFund VARCHAR(100) NULL,
	PropertyFundAllocationSubRegionName VARCHAR(50) NULL,
	Source CHAR(2) NULL,
	AllocationType VARCHAR(100) NULL,
	CorporateDepartment CHAR(8) NULL,
	CorporateDepartmentDescription VARCHAR(50) NULL,
	ReportingEntity VARCHAR(100) NULL,
	ReportingEntityAllocationSubRegionName varchar(50) NULL,
	EntityType VARCHAR(50) NULL,
	BudgetOwner VARCHAR(255) NULL,
	RegionalOwner VARCHAR(255) NULL,
	BudgetCoordinatorDisplayNames nvarchar(MAX) NULL,
	IsTSCost VARCHAR(3) NULL,
	PropertyEntity CHAR(6) NULL,
	PropertyEntityName NVARCHAR(264) NULL
)

SET XACT_ABORT ON

-- Get actuals
INSERT INTO #HolisticReviewExportTemp
EXEC SERVER3.GDM_GR.dbo.HolisticReviewExport

-- Get budget
INSERT INTO #HolisticReviewExportTemp
EXEC SERVER3.GDM_GR.dbo.HolisticReviewExport @BudgetAllocationSetId=@BudgetAllocationSetId

IF OBJECT_ID('tempdb..#HolisticReviewExport') IS NOT NULL
	DROP TABLE #HolisticReviewExport

-- Get a distinct list of rows
SELECT DISTINCT
	*
INTO
	#HolisticReviewExport
FROM
	#HolisticReviewExportTemp


IF OBJECT_ID('tempdb..#ValidActivityTypeEntity') IS NOT NULL
	DROP TABLE #ValidActivityTypeEntity
	
SELECT DISTINCT 
	list.ActivityType ActivityTypeName,
	list.AllocationType AllocationTypeName,
	list.ReportingEntity ReportingEntityName
INTO #ValidActivityTypeEntity
FROM #HolisticReviewExport list

--Add additional entries provided by Martin: IMS 56718
INSERT INTO #ValidActivityTypeEntity
(
ReportingEntityName, 
ActivityTypeName, 
AllocationTypeName
)
SELECT 
	t1.ReportingEntityName, 
	t1.ActivityTypeName, 
	t1.AllocationTypeName 
FROM AdditionalValidCombinationsForEntityActivity t1
LEFT OUTER JOIN #ValidActivityTypeEntity t2 ON 
	t2.ReportingEntityName = t1.ReportingEntityName AND
	t2.ActivityTypeName = t1.ActivityTypeName AND
	t2.AllocationTypeName = t1.AllocationTypeName
WHERE 
	t2.AllocationTypeName IS NULL

IF OBJECT_ID('tempdb..#InValidActivityTypeAndEntityCombination') IS NOT NULL
	DROP TABLE #InValidActivityTypeAndEntityCombination
	
SELECT  
	s.SourceCode,
	pa.ReferenceCode,
	vs.AllocationTypeName,
	REPLACE(gac.AccountSubTypeName,'-','') AccountSubTypeName,
	vs.ActivityTypeName LocalActivityTypeName,
	at.ActivityTypeName ValidationActivityTypeName,
	vs.ReportingEntityName,
	pf.PropertyFundName
INTO #InValidActivityTypeAndEntityCombination
FROM ProfitabilityActual pa
INNER JOIN ProfitabilityActualSourceTable pas ON 
	pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
INNER JOIN [Source] s ON 
	s.SourceKey = pa.SourceKey
INNER JOIN PropertyFund pf ON 
	pf.PropertyFundKey = pa.PropertyFundKey
INNER JOIN ActivityType at ON 
	at.ActivityTypeKey = pa.ActivityTypeKey
INNER JOIN GlAccountCategory gac ON 
	gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
INNER JOIN Overhead oh ON 
	oh.OverheadKey = pa.OverheadKey
INNER JOIN Calendar ca ON 
	ca.CalendarKey = pa.CalendarKey
LEFT OUTER JOIN #ValidActivityTypeEntity vs 
ON 
(	--GR
	gac.MajorCategoryName <> 'Salaries/Taxes/Benefits' AND
	oh.OverheadCode = 'UNALLOC' AND
	gac.AccountSubTypeName = 'Overhead' AND	
	--AM
	vs.AllocationTypeName = 'NonPayroll' AND
	vs.ActivityTypeName = 'Corporate Overhead' AND
	vs.ReportingEntityName = pf.PropertyFundName
)
OR
(	--GR
	gac.MajorCategoryName = 'Salaries/Taxes/Benefits' AND 
	oh.OverheadCode = 'UNALLOC' AND		
	gac.AccountSubTypeName = 'Overhead' AND
	--AM
	vs.AllocationTypeName = 'Payroll' AND
	vs.ActivityTypeName = 'Corporate Overhead' AND
	vs.ReportingEntityName = pf.PropertyFundName
)
OR
(	--Default Match	
	vs.AllocationTypeName = REPLACE(gac.AccountSubTypeName,'-','') AND
	vs.ActivityTypeName = at.ActivityTypeName AND
	vs.ReportingEntityName = pf.PropertyFundName
)
WHERE	
	vs.ActivityTypeName	IS NULL AND 
	pas.SourceTable	IN ('GHIS','JOURNAL') AND 
	NOT(
		oh.OverheadCode = 'ALLOC' AND 
		gac.AccountSubTypeName = 'Overhead'
	) AND
	gac.MinorCategoryName <> 'Architects & Engineering' AND	
	ca.CalendarPeriod >= 201007 AND 
	gac.FeeOrExpense <> 'INCOME' AND
	NOT (
		pf.PropertyFundType IN ('Property', '3rd party property') AND 
		at.ActivityTypeCode IN ('PMN', 'AMA', 'PME', 'LEASE')
	) --IMS #62502

--Remove FROM this table the items, that the reclass logic already fixed the issue at hand
DELETE t1 
FROM #InValidActivityTypeAndEntityCombination t1
INNER JOIN #GeneralLedger gl ON 
	gl.SourcePrimaryKey = t1.ReferenceCode AND 
	gl.SourceCode = t1.SourceCode
INNER JOIN 
(
	SELECT  
		gl.GlAccountCode,
		gl.EntityID
	FROM #InValidActivityTypeAndEntityCombination vs
	INNER JOIN #GeneralLedger gl ON 
		vs.ReferenceCode = gl.SourcePrimaryKey AND 
		vs.SourceCode = gl.SourceCode
	GROUP BY
		gl.GlAccountCode,
		gl.EntityID
	HAVING 
		SUM(gl.Amount) = 0.00
) UnknownAfterReclass ON 
	UnknownAfterReclass.EntityID = gl.EntityID AND 
	UnknownAfterReclass.GlAccountCode = gl.GlAccountCode

--Delete the old Reporting Entity Names
DELETE FROM #InValidActivityTypeAndEntityCombination
WHERE 
	LTRIM(RTRIM(PropertyFundName)) IN (
		SELECT 'ECM Business Development' ReportingEntity UNION
		SELECT 'Employee Reimbursables' ReportingEntity UNION
		SELECT 'US CORP TBD' ReportingEntity
)

--UPDATEd the existing rows in #ValidationSummary WHERE FunctionalDepartment&OriginatingRegion combination is not valid
UPDATE #ValidationSummary
SET	
	InValidActivityTypeAndEntity = 1
FROM #InValidActivityTypeAndEntityCombination InValidActivityTypeAndEntityCombination
WHERE	
	#ValidationSummary.ReferenceCode = InValidActivityTypeAndEntityCombination.ReferenceCode AND	
	#ValidationSummary.SourceCode = InValidActivityTypeAndEntityCombination.SourceCode


--Insert only WHERE FunctionalDepartment&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
INSERT INTO #ValidationSummary
(
	SourceCode,
	ProfitabilityActualKey, 
	ReferenceCode, 
	HasActivityTypeUnknown, 
	HasAllocationRegionUnknown, 
	HasFunctionalDepartmentUnknown,
	HasGlAccountUnknown, 
	HasGlAccountCategoryUnknown, 
	HasOriginatingRegionUnknown,
	--HasOverheadUnknown, 
	HasPropertyFundUnknown,
	InValidActivityTypeAndEntity
)
SELECT
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	0 HasActivityTypeUnknown, 
	0 HasAllocationRegionUnknown, 
	0 HasFunctionalDepartmentUnknown,
	0 HasGlAccountUnknown, 
	0 HasGlAccountCategoryUnknown, 
	0 HasOriginatingRegionUnknown,
	--1 HasOverheadUnknown, 
	0 HasPropertyFundUnknown,
	1 InValidActivityTypeAndEntity
FROM ProfitabilityActual pa
INNER JOIN Calendar ca ON 
	ca.CalendarKey = pa.CalendarKey
INNER JOIN GlAccountCategory gac ON 
	gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
INNER JOIN [Source] ss ON 
	ss.SourceKey = pa.SourceKey
LEFT OUTER JOIN #ValidationSummary existing ON 
	existing.SourceCode = ss.SourceCode AND 
	existing.ReferenceCode = pa.ReferenceCode
INNER JOIN #InValidActivityTypeAndEntityCombination InValidActivityTypeAndEntityCombination ON
	InValidActivityTypeAndEntityCombination.ReferenceCode = pa.ReferenceCode AND	
	InValidActivityTypeAndEntityCombination.SourceCode = ss.SourceCode
WHERE	
	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod AND
	ca.CalendarPeriod >= 201007 AND		
	existing.ReferenceCode IS NULL AND --Not in table yet
	gac.MinorCategoryName <> 'Architects & Engineering'

------------------------------------------------------------------------------------------------------------------------------------------
--Now Remove the rows FROM #ValidationSummary, WHERE the re-class of items cause the to be valid now
DELETE FROM #ValidationSummary
WHERE	
HasActivityTypeUnknown = 0 AND
HasAllocationRegionUnknown = 0 AND
HasFunctionalDepartmentUnknown = 0 AND
HasGlAccountUnknown = 0 AND
HasGlAccountCategoryUnknown = 0 AND
HasOriginatingRegionUnknown = 0 AND
--		HasOverheadUnknown = 0 AND
HasPropertyFundUnknown = 0 AND		
InValidOriginatingRegionAndFunctionalDepartment = 0 AND
InValidActivityTypeAndEntity = 0

IF @GBSAccounts = 1 
BEGIN
	
-- Delete everything except for the following conditions:

-- GLAccount = 'Unknown' OR
--SubType = 'Payroll' OR
--(SubType = 'Overhead' AND OverheadType = 'Allocated') OR
--GlobalAccount.Header.IsGBS = 1 OR
--(MajorCategory = 'Fee Income' AND GlobalAccount.IsGBS = 1)

DELETE vs
FROM #ValidationSummary vs
INNER JOIN ProfitabilityActual pa ON 
	pa.ProfitabilityActualKey = vs.ProfitabilityActualKey	
INNER JOIN GlAccount gla ON 
	gla.GlAccountKey = pa.GlAccountKey
INNER JOIN GlAccountCategory glac ON 
	glac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
INNER JOIN Overhead o ON 
	o.OverheadKey = pa.OverheadKey
WHERE
	gla.GLGlobalAccountId NOT IN (
	SELECT DISTINCT
		GLA.GLGlobalAccountId
	FROM SERVER3.Gdm_Support.dbo.GLTranslationSubType TST 
	INNER JOIN SERVER3.Gdm_Support.dbo.GLGlobalAccountTranslationSubType GLATST ON
		TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId
	INNER JOIN SERVER3.Gdm_Support.dbo.GLGlobalAccountTranslationType GLATT ON
		GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
		TST.GLTranslationTypeId = GLATT.GLTranslationTypeId
	INNER JOIN SERVER3.Gdm_Support.dbo.GLAccountSubType AST ON
		GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId
	INNER JOIN SERVER3.Gdm_Support.dbo.GLTranslationType TT ON
		GLATT.GLTranslationTypeId = TT.GLTranslationTypeId
	INNER JOIN SERVER3.Gdm_Support.dbo.GLGlobalAccount GLA ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId
	INNER JOIN SERVER3.Gdm_Support.dbo.GLGlobalAccount GLAH ON
		GLA.ParentCode = GLAH.ParentCode AND
		GLAH.ActivityTypeId IS NULL
	INNER JOIN SERVER3.Gdm_Support.dbo.GLMinorCategory MC ON
		GLATST.GLMinorCategoryId = MC.GLMinorCategoryId
	INNER JOIN SERVER3.Gdm_Support.dbo.GLMajorCategory MajC ON
		MC.GLMajorCategoryId = MajC.GLMajorCategoryId
	WHERE
		GLA.IsActive = 1 AND
		GLATT.IsActive = 1 AND
		GLATST.IsActive = 1 AND
		TST.Code = 'GL' AND
		TT.Code = 'GL' AND
		(
			GLAH.IsGbs = 1 OR		
			(
				MajC.Name = 'Fee Income' AND 
				GLA.IsGbs = 1
			)
		)
	) AND 
	NOT	glac.AccountSubTypeName = 'Payroll' AND 
	NOT	(
		glac.AccountSubTypeName = 'Overhead' AND 
		o.OverheadCode = 'ALLOC'
	) AND 
	NOT	vs.HasGlAccountUnknown = 1
		
END

SELECT
	CASE 
	WHEN 
		vs.HasActivityTypeUnknown = 1 OR 
		vs.HasFunctionalDepartmentUnknown = 1 OR
		vs.HasOriginatingRegionUnknown = 1 OR
		vs.InValidOriginatingRegionAndFunctionalDepartment = 1 OR
		vs.InValidActivityTypeAndEntity = 1
	THEN 
		CASE WHEN
			vs.HasPropertyFundUnknown = 1 OR
			vs.HasAllocationRegionUnknown = 1 OR
			vs.HasGlAccountUnknown = 1 OR
			vs.HasGlAccountCategoryUnknown = 1
		THEN 
			'Both Corporate Finance and Accounting'
		ELSE
			'Accounting - Re-class'
		END
	ELSE 
		'Corporate Finance - Mapping'
	END AS ResolvedBy,
	vs.SourceCode,
	--MRI
	gl.Period,
	gl.Ref,
	gl.Item,
	gl.EntityID,
	gl.EntityName,
	gl.GlAccountCode,
	gl.GlAccountName,
	gl.Department,
	gl.DepartmentDescription,
	gl.JobCode,
	gl.JobCodeDescription,
	gl.Amount,
	gl.Description,
	gl.EnterDate,
	gl.Reversal,
	gl.Status,
	gl.Basis,
	gl.UserId,
	gl.CorporateDepartmentCode,
	gl.[Source],
	CASE 
		WHEN vs.HasActivityTypeUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasActivityTypeUnknown,
	CASE 
		WHEN vs.HasFunctionalDepartmentUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasFunctionalDepartmentUnknown,
	CASE 
		WHEN vs.HasOriginatingRegionUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasOriginatingRegionUnknown,
	CASE 
		WHEN vs.HasPropertyFundUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasPropertyFundUnknown,
	CASE 
		WHEN vs.HasAllocationRegionUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasAllocationRegionUnknown,
	CASE 
		WHEN vs.HasGlAccountUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasGlAccountUnknown,
	CASE 
		WHEN vs.HasGlAccountCategoryUnknown = 1 THEN 'YES' 
		ELSE 'NO' 
	END HasGlAccountCategoryUnknown,
	CASE 
		WHEN vs.InValidOriginatingRegionAndFunctionalDepartment = 1 THEN 'YES' 
		ELSE 'NO' 
	END InValidOriginatingRegionAndFunctionalDepartment,
	CASE 
		WHEN vs.InValidActivityTypeAndEntity = 1 THEN 'YES' 
		ELSE 'NO' 
	END InValidActivityTypeAndEntity,
	--DW
	ph.Amount [PropertyParentAccountTotal],
	cd.Amount [CorporateTotalByDescription],
	gac.MajorCategoryName [Gr MajorCategoryName],
	gac.MinorCategoryName [Gr MinorCategoryName],
	gac.FeeOrExpense [Gr FeeOrExpense],
	pf.PropertyFundName [Gr ReportingEntityName],
	at.ActivityTypeName [Gr ActivityTypeName],		
	orr.SubRegionName [Gr OriginatingSubRegionName],		
	ar.SubRegionName [Gr AllocationSubRegionName],
	fd.FunctionalDepartmentName [GR FunctionalDepartmentName]
FROM #ValidationSummary vs
INNER JOIN ProfitabilityActual pa ON 
	pa.ProfitabilityActualKey = vs.ProfitabilityActualKey
INNER JOIN GlAccountCategory gac ON 
	gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
INNER JOIN PropertyFund pf ON 
	pf.PropertyFundKey = pa.PropertyFundKey
INNER JOIN ActivityType at ON 
	at.ActivityTypeKey = pa.ActivityTypeKey
INNER JOIN OriginatingRegion orr ON 
	orr.OriginatingRegionKey = pa.OriginatingRegionKey
INNER JOIN AllocationRegion ar ON 
	ar.AllocationRegionKey = pa.AllocationRegionKey
INNER JOIN Overhead oh ON 
	Oh.OverheadKey = pa.OverheadKey
INNER JOIN GlAccount gla ON 
	gla.GlAccountKey = pa.GlAccountKey
INNER JOIN FunctionalDepartment fd ON 
	fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey	
INNER JOIN #GeneralLedger gl ON 
	vs.ReferenceCode = gl.SourcePrimaryKey and vs.SourceCode = gl.SourceCode
LEFT OUTER JOIN #PropertyHeaderSum ph ON 
	gl.SourceCode = ph.SourceCode AND
	gl.EntityID = ph.EntityID AND 
	gl.GlAccountCode = ph.GlAccountCode
LEFT OUTER JOIN #CorporateDescSum cd ON 
	gl.SourceCode = cd.SourceCode AND
	gl.EntityID = cd.EntityID AND
	gl.Source = cd.Source AND
	ISNULL(gl.JobCode,'') = cd.JobCode AND
	ISNULL(gl.Description,'') = cd.Description		
ORDER BY 
	vs.SourceCode, 
	vs.ReferenceCode




GO


