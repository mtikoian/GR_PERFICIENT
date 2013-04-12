USE GrReporting
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_R_UnknownActivityType') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_R_UnknownActivityType
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.stp_R_UnknownActivityType
@StartPeriod Varchar(6),
@StopPeriod  Varchar(6)
AS

DECLARE @DataPriorToDate DateTime

SET @DataPriorToDate = GETDATE()

CREATE TABLE #Result(
	SourceSystem Varchar(50) NOT NULL,
	SourceTable varchar(50) NOT NULL,
	ActivityTypeName varchar(50) NOT NULL,
	FunctionalDepartmentUnknown varchar(3) NOT NULL,
	OriginatingRegionUnknown varchar(3) NOT NULL,
	GLAccountUnknown varchar(3) NOT NULL,
	GlPeriod char(6) NOT NULL,
	GlRef char(8) NOT NULL,
	GlSource char(2) NOT NULL,
	GlSiteID char(2) NOT NULL,
	GlItem smallint NOT NULL,
	GlEntityID char(7) NOT NULL,
	EntityName varchar(80) NULL,
	GlAccountNumber char(14) NOT NULL,
	GlAccountName varchar(60) NULL,
	PropertyFundCode char(7) NOT NULL,
	DepartmentDescription varchar(50) NULL,
	Jobcode char(15) NULL,
	JobCodeDescription varchar(50) NULL,
	GlAmount money NULL,
	GlDescription char(60) NULL,
	GlEntrDate datetime NULL,
	GlReversal varchar(1) NOT NULL,
	GlStatus varchar(1) NOT NULL,
	GlBasis char(1) NOT NULL,
	GlLastDate datetime NULL,
	GlUser varchar(20) NULL
)

--USProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--USCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.USCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.USCorp.ENTITY En
					INNER JOIN GrReportingStaging.USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--EUCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.EUCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.EUCorp.ENTITY En
					INNER JOIN GrReportingStaging.EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--INProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.Ref GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--INCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.INCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.INCorp.ENTITY En
					INNER JOIN GrReportingStaging.INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--BRProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--BRCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.BRCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.BRCorp.ENTITY En
					INNER JOIN GrReportingStaging.BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod


--CNProp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNProp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

--CNCorp
Insert Into #Result
(SourceSystem,SourceTable,ActivityTypeName,FunctionalDepartmentUnknown,OriginatingRegionUnknown,GLAccountUnknown,GlPeriod,
GlRef,GlSource,GlSiteID,GlItem,GlEntityID,EntityName,GlAccountNumber,GlAccountName,PropertyFundCode,DepartmentDescription,
Jobcode,JobCodeDescription,GlAmount,GlDescription,GlEntrDate,GlReversal,GlStatus,GlBasis,GlLastDate,GlUser)
Select
		s.SourceSystem
		,pst.SourceTable
		,at.ActivityTypeName
		
		,CASE
			WHEN pa.FunctionalDepartmentKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS FunctionalDepartmentUnknown
		
		,CASE					/* DISPLAY FOR ACTIVITY TYPE UNKNOWNS */
			WHEN pa.OriginatingRegionKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS OriginatingRegionUnknown
		
		,CASE					/* DISPLAY FOR GL ACCOUNT UNKNOWNS */
			WHEN pa.GlAccountKey = -1 THEN ('Yes')
			ELSE ('No')
			END AS GLAccountUnknown
		,Gl.Period GlPeriod
		,Gl.REF GlRef
		,Gl.Source GlSource
		,Gl.SiteID GlSiteID
		,Gl.Item GlItem
		,Gl.EntityID GlEntityID
		,RTRIM(En.NAME) EntityName   
		,Gl.GlAccountCode GlAccountNumber
		,RTRIM(Ga.ACCTNAME) GlAccountName
		,Gl.PropertyFundCode
		,De.Description DepartmentDescription
		,Gl.JobCode Jobcode
		,Jb.Description JobCodeDescription
		,Gl.Amount GlAmount
		,Gl.Description GlDescription
		,Gl.EnterDate GlEntrDate
		,Gl.Reversal GlReversal
		,Gl.Status GlStatus
		,Gl.Basis GlBasis
		,Gl.LastDate GlLastDate
		,Gl.UserID GlUser
	
FROM 

	GrReporting.dbo.ProfitabilityActual pa	
	
	INNER JOIN GrReporting.dbo.Source s ON 
		pa.SourceKey = s.SourceKey
		
	INNER JOIN GrReporting.dbo.Calendar c On
		pa.CalendarKey = c.CalendarKey	
		
	INNER JOIN dbo.ActivityType at ON
		pa.ActivityTypeKey = at.ActivityTypeKey
		
	INNER JOIN dbo.GlAccountCategory Category ON
		pa.GlobalGlAccountCategoryKey = Category.GlAccountCategoryKey	
		
	INNER JOIN GrReportingStaging.CNCorp.GeneralLedger Gl ON
	Gl.SourcePrimaryKey = pa.ReferenceCode
	
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
		
	INNER JOIN GrReporting.dbo.ProfitabilityActualSourceTable pst ON 
			pst.ProfitabilityActualSourceTableId = gl.SourceTableId

	LEFT OUTER JOIN (
				SELECT
					En.*
				FROM
					GrReportingStaging.CNCorp.ENTITY En
					INNER JOIN GrReportingStaging.CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
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
					De.*
				FROM
					GrReportingStaging.GACS.Department De
					INNER JOIN GrReportingStaging.GACS.DepartmentActive(@DataPriorToDate) DeA ON
						DeA.ImportKey = De.ImportKey
				) De ON
		De.DEPARTMENT = Gl.PropertyFundCode AND De.Source = s.SourceCode

	LEFT OUTER JOIN (
				SELECT
					Jb.*
				FROM
					GrReportingStaging.GACS.JobCode Jb
					INNER JOIN GrReportingStaging.GACS.JobCodeActive(@DataPriorToDate) JbA ON
						JbA.ImportKey = Jb.ImportKey
				) Jb ON
		Jb.JobCode = Gl.JobCode AND Jb.Source = s.SourceCode

Where	pa.ActivityTypeKey = -1
AND		Gl.Period >= @StartPeriod
AND		Gl.Period <= @StopPeriod

CREATE CLUSTERED INDEX IX_Clustered ON #Result (SourceSystem, GlPeriod, GlEntrDate)

Select * From #Result ORder By SourceSystem, GlPeriod, GlEntrDate