USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActuals]    Script Date: 10/25/2010 10:00:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryMRIActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActuals]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_S_UnknownSummaryMRIActuals]    Script Date: 10/25/2010 10:00:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryMRIActuals]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime,
@StartPeriod int,
@EndPeriod int
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
SourceCode Char(2) NOT NULL,
ProfitabilityActualKey Int NOT NULL,
ReferenceCode varchar(100) NOT NULL,
HasActivityTypeUnknown TinyInt NULL,
HasAllocationRegionUnknown TinyInt NULL,
HasFunctionalDepartmentUnknown TinyInt NULL,
HasGlAccountUnknown TinyInt NULL,
HasGlAccountCategoryUnknown TinyInt NULL,
HasOriginatingRegionUnknown TinyInt NULL,
--HasOverheadUnknown TinyInt NULL,
HasPropertyFundUnknown TinyInt NULL,
InValidOriginatingRegionAndFunctionalDepartment TinyInt NULL DEFAULT(0),
InValidActivityTypeAndEntity  TinyInt NULL DEFAULT(0)
)

--Step 1 :: Get all the unknowns
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown)

Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	CASE WHEN pa.ActivityTypeKey = -1 THEN 1 ELSE 0 END HasActivityTypeUnknown, 
	CASE WHEN pa.AllocationRegionKey = -1 THEN 1 ELSE 0 END HasAllocationRegionUnknown, 
	CASE WHEN pa.FunctionalDepartmentKey = -1 THEN 1 ELSE 0 END HasFunctionalDepartmentUnknown,
	CASE WHEN pa.GlAccountKey = -1 THEN 1 ELSE 0 END HasGlAccountUnknown, 
	CASE WHEN gac.MajorCategoryName like '%unknown%' THEN 1 ELSE 0 END HasGlAccountCategoryUnknown, 
	CASE WHEN pa.OriginatingRegionKey = -1 THEN 1 ELSE 0 END HasOriginatingRegionUnknown,
	--CASE WHEN pa.OverheadKey = -1 THEN 1 ELSE 0 END HasOverheadUnknown, 
	CASE WHEN pa.PropertyFundKey = -1 THEN 1 ELSE 0 END HasPropertyFundUnknown

From	ProfitabilityActual pa
			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey
			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey
			INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND		pas.SourceTable IN ('GHIS','JOURNAL')
--Only where one of the DimensionKey's are unknown
AND (
	CASE WHEN pa.ActivityTypeKey = -1 THEN 1 ELSE 0 END = 1 OR 
	CASE WHEN pa.AllocationRegionKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.FunctionalDepartmentKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.GlAccountKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN gac.MajorCategoryName like '%unknown%' THEN 1 ELSE 0 END = 1 OR 
	CASE WHEN pa.OriginatingRegionKey = -1 THEN 1 ELSE 0 END = 1 OR
	--CASE WHEN pa.OverheadKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.PropertyFundKey = -1 THEN 1 ELSE 0 END = 1
	)

IF OBJECT_ID('tempdb..#GeneralLedger') IS NOT NULL
	DROP TABLE #GeneralLedger
	
--Step 1 :: Get all the MRI GeneralLedger Details, used to removed re-classed MRI items
--US
Select 
		Gl.Period,
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

Into #GeneralLedger
From GrReportingStaging.USProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
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
		
		
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod		

UNION ALL
Select 
		Gl.Period,
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

From GrReportingStaging.USCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.USCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USCorp.ENTITY En
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.USCorp.GACC Ga
					INNER JOIN GrReportingStaging.USCorp.GAccActive(@DataPriorToDate) GaA ON
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
		Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode
	
	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.Gacs.JobCode Jb
					INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
--EU
UNION ALL
Select 
		Gl.Period,
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
 
From GrReportingStaging.EUProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUProp.ENTITY En
					INNER JOIN GrReportingStaging.EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUProp.GACC Ga
					INNER JOIN GrReportingStaging.EUProp.GAccActive(@DataPriorToDate) GaA ON
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
				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
UNION ALL
Select 
		Gl.Period,
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

From GrReportingStaging.EUCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.EUCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUCorp.ENTITY En
					INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.EUCorp.GACC Ga
					INNER JOIN GrReportingStaging.EUCorp.GAccActive(@DataPriorToDate) GaA ON
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
		Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode
	
LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.Gacs.JobCode Jb
					INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
--BR
UNION ALL
Select 
		Gl.Period,
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

From GrReportingStaging.BRProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRProp.ENTITY En
					INNER JOIN GrReportingStaging.BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRProp.GACC Ga
					INNER JOIN GrReportingStaging.BRProp.GAccActive(@DataPriorToDate) GaA ON
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
	

				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
UNION ALL
Select 
		Gl.Period,
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
 
From GrReportingStaging.BRCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.BRCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRCorp.ENTITY En
					INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.BRCorp.GACC Ga
					INNER JOIN GrReportingStaging.BRCorp.GAccActive(@DataPriorToDate) GaA ON
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
		Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode
	
LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.Gacs.JobCode Jb
					INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
--IN
UNION ALL
Select 
		Gl.Period,
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
 
From GrReportingStaging.INProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
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
				FROM
					GrReportingStaging.INProp.ENTITY En
					INNER JOIN GrReportingStaging.INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.INProp.GACC Ga
					INNER JOIN GrReportingStaging.INProp.GAccActive(@DataPriorToDate) GaA ON
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
	
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
UNION ALL
Select 
		Gl.Period,
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

From GrReportingStaging.INCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.INCorp.GeneralLedger Gl
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
				FROM
					GrReportingStaging.INCorp.GACC Ga
					INNER JOIN GrReportingStaging.INCorp.GAccActive(@DataPriorToDate) GaA ON
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
		Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode
	
LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.Gacs.JobCode Jb
					INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source
				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
--CN
UNION ALL
Select 
		Gl.Period,
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

From GrReportingStaging.CNProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNProp.ENTITY En
					INNER JOIN GrReportingStaging.CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNProp.GACC Ga
					INNER JOIN GrReportingStaging.CNProp.GAccActive(@DataPriorToDate) GaA ON
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
				
Where Gl.Period BETWEEN @StartPeriod AND @EndPeriod	
UNION ALL
Select 
		Gl.Period,
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
 
From GrReportingStaging.CNCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					GrReportingStaging.CNCorp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNCorp.ENTITY En
					INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
	
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					GrReportingStaging.CNCorp.GACC Ga
					INNER JOIN GrReportingStaging.CNCorp.GAccActive(@DataPriorToDate) GaA ON
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
		Dp.[Source] = Gl.SourceCode AND Dp.Department = Gl.PropertyFundCode
	
LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.Gacs.JobCode Jb
					INNER JOIN GrReportingStaging.Gacs.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JOBCODE = Gl.JobCode AND Gl.SourceCode = Jb.Source

	
		
		
--Step 2 :: Remove ActivityType unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasActivityTypeUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasActivityTypeUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasActivityTypeUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode
 
--Step 3 :: Remove GlAccount unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasGlAccountUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasGlAccountUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasGlAccountUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode


--Step 4 :: Remove GlAccountCategory unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasGlAccountCategoryUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasGlAccountCategoryUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasGlAccountCategoryUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode


--Step 4 :: Remove AllocationRegion unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasAllocationRegionUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasAllocationRegionUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasAllocationRegionUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode

--Step 5 :: Remove OriginatingRegion unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasOriginatingRegionUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasOriginatingRegionUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasOriginatingRegionUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode


--Step 6 :: Remove FunctionalDepartment unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasFunctionalDepartmentUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasFunctionalDepartmentUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasFunctionalDepartmentUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode


--Step 7 :: Remove PropertyFund unknowns from #ValidationSummary, that have been re-classed and now net out to 0
Update #ValidationSummary
Set	HasPropertyFundUnknown = 0
	From	
			#GeneralLedger gl 
			INNER JOIN 
						(
						Select  
								gl.GlAccountCode,
								gl.EntityID

						From #ValidationSummary vs
								INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
						Where vs.HasPropertyFundUnknown = 1
						Group By
								gl.GlAccountCode,
								gl.EntityID
						Having SUM(gl.Amount) = 0.00
						) UnknownAfterReclass
						ON UnknownAfterReclass.EntityID = gl.EntityID 
						AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
						
Where	#ValidationSummary.HasPropertyFundUnknown = 1
AND		#ValidationSummary.ReferenceCode = gl.SourcePrimaryKey
 AND	#ValidationSummary.SourceCode = gl.SourceCode


-----------------------------------------------------------------------------------------------------------------------------------------------
--Step 8 :: OriginatingRegion & FunctionalDepartment Combination
--Sheet 1 :: OriginatingSubRegion And FunctionalDepartment

IF OBJECT_ID('tempdb..#ValidRegionAndFunctionalDepartment') IS NOT NULL
	DROP TABLE #ValidRegionAndFunctionalDepartment

CREATE TABLE #ValidRegionAndFunctionalDepartment
(OriginatingSubRegionName Varchar(50) NOT NULL,
FunctionalDepartmentName Varchar(50) NOT NULL
)
Insert Into #ValidRegionAndFunctionalDepartment
(FunctionalDepartmentName,OriginatingSubRegionName)
EXEC [stp_S_ValidPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuater,
	@DataPriorToDate = @DataPriorToDate

Insert Into #ValidRegionAndFunctionalDepartment
(FunctionalDepartmentName,OriginatingSubRegionName)
EXEC [stp_S_ValidNonPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuater,
	@DataPriorToDate = @DataPriorToDate


--Add additional entries provided by Martin: IMS 56718
Insert Into #ValidRegionAndFunctionalDepartment
(OriginatingSubRegionName, FunctionalDepartmentName)
Select t1.OriginatingSubRegionName, t1.FunctionalDepartmentName 
From AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment t1
		LEFT OUTER JOIN #ValidRegionAndFunctionalDepartment t2
				ON t2.OriginatingSubRegionName = t1.OriginatingSubRegionName AND
				t2.FunctionalDepartmentName = t1.FunctionalDepartmentName
Where t2.FunctionalDepartmentName IS NULL

IF OBJECT_ID('tempdb..#InvalidRegionAndFunctDeptCombination') IS NOT NULL
	DROP TABLE #InvalidRegionAndFunctDeptCombination
	
Select  
		s.SourceCode,
		pa.ReferenceCode,
		fd.FunctionalDepartmentName,
		orr.SubRegionName
Into #InvalidRegionAndFunctDeptCombination
From ProfitabilityActual pa

		INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

		INNER JOIN [Source] s ON s.SourceKey = pa.SourceKey
		
		LEFT OUTER JOIN FunctionalDepartment fd ON 
					fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
				
		LEFT OUTER JOIN OriginatingRegion orr ON 
					orr.OriginatingRegionKey = pa.OriginatingRegionKey

		LEFT OUTER JOIN GlAccountCategory gac ON 
					gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

		LEFT OUTER JOIN #ValidRegionAndFunctionalDepartment vs 
			on vs.FunctionalDepartmentName = fd.FunctionalDepartmentName
			 AND vs.OriginatingSubRegionName = orr.SubRegionName

Where	s.SourceCode LIKE '%C'
AND		vs.FunctionalDepartmentName IS NULL
AND		pas.SourceTable IN ('GHIS','JOURNAL')
--IMS 56718 : Revenue should not be validated against a specific functional department/originating region
AND		gac.FeeOrExpense <> 'INCOME'



--Remove from this table the items, that the reclass logic already fixed the issue at hand
Delete t1 
From #InvalidRegionAndFunctDeptCombination t1
		INNER JOIN #GeneralLedger gl ON gl.SourcePrimaryKey = t1.ReferenceCode
							 AND gl.SourceCode = t1.SourceCode
		INNER JOIN 
					(
					Select  
							gl.GlAccountCode,
							gl.EntityID

					From #InvalidRegionAndFunctDeptCombination vs
							INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
					Group By
							gl.GlAccountCode,
							gl.EntityID
					Having SUM(gl.Amount) = 0.00
					) UnknownAfterReclass
				ON UnknownAfterReclass.EntityID = gl.EntityID 
					AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode
					
--Updated the existing rows in #ValidationSummary where FunctionalDepartment&OriginatingRegion combination is not valid
Update #ValidationSummary
Set	InValidOriginatingRegionAndFunctionalDepartment = 1
	From	
		#InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination
						
Where	#ValidationSummary.ReferenceCode = InvalidRegionAndFunctDeptCombination.ReferenceCode
 AND	#ValidationSummary.SourceCode = InvalidRegionAndFunctDeptCombination.SourceCode


--Insert only where FunctionalDepartment&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown,InValidOriginatingRegionAndFunctionalDepartment)
Select 
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

From	ProfitabilityActual pa

			INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey

			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey

			LEFT OUTER JOIN #ValidationSummary existing ON existing.SourceCode = ss.SourceCode AND existing.ReferenceCode = pa.ReferenceCode

			INNER JOIN #InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination ON
						InvalidRegionAndFunctDeptCombination.ReferenceCode = pa.ReferenceCode
					AND	InvalidRegionAndFunctDeptCombination.SourceCode = ss.SourceCode
 
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND		existing.ReferenceCode IS NULL --Not in table yet
AND		pas.SourceTable IN ('GHIS','JOURNAL')

---------------------------------------------------------------------------------------------------------------------------------------
--Sheet 2 :: Entity ActivityType Validation

IF OBJECT_ID('tempdb..#HolisticReviewExport') IS NOT NULL
	DROP TABLE #HolisticReviewExport
	
CREATE TABLE #HolisticReviewExport
(	ProjectCode varchar(20) NULL,
	ProjectName varchar(100) NULL,
	ProjectEndPeriod int NULL,
	ActivityType varchar(50) NULL,
	PropertyFund varchar(100) NULL,
	PropertyFundAllocationSubRegionName varchar(50) NULL,
	Source char(2) NULL,
	AllocationType varchar(100) NULL,
	CorporateDepartment char(8) NULL,
	CorporateDepartmentDescription varchar(50) NULL,
	ReportingEntity varchar(100) NULL,
	ReportingEntityAllocationSubRegionName varchar(50) NULL,
	EntityType varchar(50) NULL,
	BudgetOwner varchar(255) NULL,
	RegionalOwner varchar(255) NULL,
	BudgetCoordinatorDisplayNames nvarchar(max) NULL,
	IsTSCost Varchar(3) NULL,
	PropertyEntity char(6) NULL,
	PropertyEntityName nvarchar(264) NULL
)
SET XACT_ABORT ON

Insert Into #HolisticReviewExport
EXEC SERVER3.Gdm.dbo.HolisticReviewExport


IF OBJECT_ID('tempdb..#ValidActivityTypeEntity') IS NOT NULL
	DROP TABLE #ValidActivityTypeEntity
	
Select
		DISTINCT 
		list.ActivityType ActivityTypeName,
		list.AllocationType AllocationTypeName,
		list.ReportingEntity ReportingEntityName
Into #ValidActivityTypeEntity
From
		#HolisticReviewExport list

--Add additional entries provided by Martin: IMS 56718
Insert Into #ValidActivityTypeEntity
(ReportingEntityName, ActivityTypeName, AllocationTypeName)
Select t1.ReportingEntityName, t1.ActivityTypeName, t1.AllocationTypeName 
From AdditionalValidCombinationsForEntityActivity t1
		LEFT OUTER JOIN #ValidActivityTypeEntity t2
				ON t2.ReportingEntityName = t1.ReportingEntityName AND
				t2.ActivityTypeName = t1.ActivityTypeName AND
				t2.AllocationTypeName = t1.AllocationTypeName
Where t2.AllocationTypeName IS NULL


IF OBJECT_ID('tempdb..#InValidActivityTypeAndEntityCombination') IS NOT NULL
	DROP TABLE #InValidActivityTypeAndEntityCombination
	
Select  
		s.SourceCode,
		pa.ReferenceCode,

		vs.AllocationTypeName,
		REPLACE(gac.AccountSubTypeName,'-','') AccountSubTypeName,

		vs.ActivityTypeName LocalActivityTypeName,
		at.ActivityTypeName ValidationActivityTypeName,

		vs.ReportingEntityName,
		pf.PropertyFundName
		
Into #InValidActivityTypeAndEntityCombination
From ProfitabilityActual pa

		INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

		INNER JOIN [Source] s ON s.SourceKey = pa.SourceKey
		
		INNER JOIN PropertyFund pf ON 
					pf.PropertyFundKey = pa.PropertyFundKey
				
		INNER JOIN ActivityType at ON 
					at.ActivityTypeKey = pa.ActivityTypeKey

		INNER JOIN GlAccountCategory gac ON 
					gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

		INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey

		LEFT OUTER JOIN #ValidActivityTypeEntity vs 
			on 
				(	--GR
						gac.MajorCategoryName		<> 'Salaries/Taxes/Benefits'
				AND		oh.OverheadCode				= 'UNALLOC'
				AND		gac.AccountSubTypeName			= 'Overhead'
					--AM
				AND		vs.AllocationTypeName		= 'NonPayroll'
				AND		vs.ActivityTypeName			= 'Corporate Overhead'
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)
				OR
				(	--GR
						gac.MajorCategoryName		= 'Salaries/Taxes/Benefits'
				AND		oh.OverheadCode				= 'UNALLOC'
				AND		gac.AccountSubTypeName			= 'Overhead'
					--AM
				AND		vs.AllocationTypeName		= 'Payroll'
				AND		vs.ActivityTypeName			= 'Corporate Overhead'
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)
				OR
				(	--Default Match	
						vs.AllocationTypeName		= REPLACE(gac.AccountSubTypeName,'-','')
				AND		vs.ActivityTypeName			= at.ActivityTypeName
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)

Where	vs.ActivityTypeName		IS NULL
AND		pas.SourceTable			IN ('GHIS','JOURNAL')
AND		NOT(oh.OverheadCode		= 'ALLOC' AND gac.AccountSubTypeName = 'Overhead')


--Remove from this table the items, that the reclass logic already fixed the issue at hand
Delete t1 
From #InValidActivityTypeAndEntityCombination t1
		INNER JOIN #GeneralLedger gl ON gl.SourcePrimaryKey = t1.ReferenceCode
							 AND gl.SourceCode = t1.SourceCode
		INNER JOIN 
					(
					Select  
							gl.GlAccountCode,
							gl.EntityID

					From #InValidActivityTypeAndEntityCombination vs
							INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey AND vs.SourceCode = gl.SourceCode
					Group By
							gl.GlAccountCode,
							gl.EntityID
					Having SUM(gl.Amount) = 0.00
					) UnknownAfterReclass
				ON UnknownAfterReclass.EntityID = gl.EntityID 
					AND UnknownAfterReclass.GlAccountCode = gl.GlAccountCode

--Delete the old Reporting Entity Names
Delete From #InValidActivityTypeAndEntityCombination
Where LTRIM(RTRIM(PropertyFundName)) IN (
Select 'ECM Business Development' ReportingEntity UNION
Select 'Employee Reimbursables' ReportingEntity UNION
Select 'US CORP TBD' ReportingEntity

)



--Updated the existing rows in #ValidationSummary where FunctionalDepartment&OriginatingRegion combination is not valid
Update #ValidationSummary
Set	InValidActivityTypeAndEntity = 1
	From	
		#InValidActivityTypeAndEntityCombination InValidActivityTypeAndEntityCombination
						
Where	#ValidationSummary.ReferenceCode = InValidActivityTypeAndEntityCombination.ReferenceCode
 AND	#ValidationSummary.SourceCode = InValidActivityTypeAndEntityCombination.SourceCode


--Insert only where FunctionalDepartment&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown,InValidActivityTypeAndEntity)
Select 
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

From	ProfitabilityActual pa

			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey

			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey

			LEFT OUTER JOIN #ValidationSummary existing ON existing.SourceCode = ss.SourceCode AND existing.ReferenceCode = pa.ReferenceCode

			INNER JOIN #InValidActivityTypeAndEntityCombination InValidActivityTypeAndEntityCombination ON
						InValidActivityTypeAndEntityCombination.ReferenceCode = pa.ReferenceCode
					AND	InValidActivityTypeAndEntityCombination.SourceCode = ss.SourceCode
 
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND existing.ReferenceCode IS NULL --Not in table yet

------------------------------------------------------------------------------------------------------------------------------------------
--Now Remove the rows from #ValidationSummary, where the re-class of items cause the to be valid now
Delete From #ValidationSummary
Where	HasActivityTypeUnknown = 0
AND		HasAllocationRegionUnknown = 0
AND		HasFunctionalDepartmentUnknown = 0
AND		HasGlAccountUnknown = 0
AND		HasGlAccountCategoryUnknown = 0
AND		HasOriginatingRegionUnknown = 0
--AND		HasOverheadUnknown = 0
AND		HasPropertyFundUnknown = 0
AND		InValidOriginatingRegionAndFunctionalDepartment = 0
AND		InValidActivityTypeAndEntity = 0



Select 


		--Query
		vs.SourceCode,
		vs.ProfitabilityActualKey,
		vs.ReferenceCode,
		vs.HasActivityTypeUnknown,
		vs.HasAllocationRegionUnknown,
		vs.HasFunctionalDepartmentUnknown,
		vs.HasGlAccountUnknown,
		vs.HasGlAccountCategoryUnknown,
		vs.HasOriginatingRegionUnknown,
		vs.HasPropertyFundUnknown,
		vs.InValidOriginatingRegionAndFunctionalDepartment,
		vs.InValidActivityTypeAndEntity,
		--DW
		gac.MajorCategoryName [Gr MajorCategoryName],
		gac.MinorCategoryName [Gr MinorCategoryName],
		gac.AccountSubTypeName [Gr AccountSubTypeName],
		gac.FeeOrExpense [Gr FeeOrExpense],
		pf.PropertyFundName [Gr ReportingEntityName],
		at.ActivityTypeName [Gr ActivityTypeName],
		orr.RegionName [Gr OriginatingRegionName],
		orr.SubRegionName [Gr OriginatingSubRegionName],
		ar.RegionName [Gr AllocationRegionName],
		ar.SubRegionName [Gr AllocationSubRegionName],
		oh.OverheadName [Gr OverheadName],
		gla.Code [Gr GlAccountCode],
		gla.Name [Gr GlAccountName],
		fd.FunctionalDepartmentName [GR FunctionalDepartmentName],
		--MRI
		gl.Period,
		gl.Ref,
		gl.SiteID,
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
		gl.[Source]

From #ValidationSummary vs
	INNER JOIN ProfitabilityActual pa on pa.ProfitabilityActualKey = vs.ProfitabilityActualKey
	INNER JOIN GlAccountCategory gac on gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
	INNER JOIN PropertyFund pf on pf.PropertyFundKey = pa.PropertyFundKey
	INNER JOIN ActivityType at ON at.ActivityTypeKey = pa.ActivityTypeKey
	INNER JOIN OriginatingRegion orr ON orr.OriginatingRegionKey = pa.OriginatingRegionKey
	INNER JOIN AllocationRegion ar ON ar.AllocationRegionKey = pa.AllocationRegionKey
	INNER JOIN Overhead oh ON Oh.OverheadKey = pa.OverheadKey
	INNER JOIN GlAccount gla ON gla.GlAccountKey = pa.GlAccountKey
	INNER JOIN FunctionalDepartment fd ON fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
	
	INNER JOIN #GeneralLedger gl on vs.ReferenceCode = gl.SourcePrimaryKey and vs.SourceCode = gl.SourceCode
Order By vs.SourceCode, vs.ReferenceCode
GO

