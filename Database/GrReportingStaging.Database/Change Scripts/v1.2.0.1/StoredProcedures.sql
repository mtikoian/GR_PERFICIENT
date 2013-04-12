USE GrReportingStaging
GO

/****** Object:  StoredProcedure dbo.ClearSessionSnapshot    Script Date: 08/21/2009 10:24:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.stp_IU_LoadGrProfitabiltyGeneralLedger') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.stp_IU_LoadGrProfitabiltyGeneralLedger
GO

CREATE PROCEDURE dbo.stp_IU_LoadGrProfitabiltyGeneralLedger
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS


DECLARE 
      @GlAccountKey				Int,
      @FunctionalDepartmentKey	Int,
      @ReimbursableKey			Int,
      @ActivityTypeKey			Int,
      @SourceKey				Int,
      @OriginatingRegionKey		Int,
      @AllocationRegionKey		Int,
      @PropertyFundKey			Int
     -- @CurrencyKey				Int
      
--Default FK for the Fact table      
SET @GlAccountKey				= (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountCode = 'UNKNOWN')
SET @FunctionalDepartmentKey	= (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKey			= (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKey			= (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN')
SET @SourceKey					= (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN')
SET @OriginatingRegionKey		= (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN')
SET @AllocationRegionKey		= (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN')
SET @PropertyFundKey			= (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey				= (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNK')



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
	SourcePrimaryKey varchar(32) NULL,
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
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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
		
From USProp.GeneralLedger Gl

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
AND		Gl.CorporateDepartmentCode IS NULL
AND		Gl.BALFOR			<> 'B'

PRINT 'US PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
	

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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

PRINT 'US CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	ISNULL(Gl.OcurrCode, En.CurrCode) ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
From EUProp.GeneralLedger Gl

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
AND		Gl.CorporateDepartmentCode IS NULL
AND		Gl.BALFOR			<> 'B'

PRINT 'EU PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	ISNULL(Gl.OcurrCode, En.CurrCode) ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	Gl.Description,
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
	
From EUCorp.GeneralLedger Gl
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

PRINT 'EU CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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
AND		Gl.CorporateDepartmentCode IS NULL
AND		Gl.BALFOR			<> 'B'
AND		Gl.Source			= 'GR'

PRINT 'BR PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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


PRINT 'BR CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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
		
From CNProp.GeneralLedger Gl

		INNER JOIN 
				(Select En.*
				From CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON EnA.ImportKey = En.ImportKey
				) En ON En.EntityId = Gl.PropertyFundCode
				
		INNER JOIN (
					Select Ga.*
					From CNProp.GACC Ga
							INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON 
								GaA.ImportKey = Ga.ImportKey
					) Ga  ON Ga.ACCTNUM = Gl.GlAccountCode
					
Where	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate
AND		Gl.Basis			IN ('A','B')
AND		En.Name				NOT LIKE '%intercompany%'
AND		ISNULL(Ga.IsGR,0)	= 'Y'
AND		Gl.CorporateDepartmentCode IS NULL
AND		Gl.BALFOR			<> 'B'

PRINT 'CH PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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

PRINT 'CH CORP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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
AND		Gl.CorporateDepartmentCode IS NULL
AND		Gl.BALFOR			<> 'B'
AND		Gl.Source			= 'GR'

PRINT 'IN PROP:Rows Inserted into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Insert Into #ProfitabilityGeneralLedger
(	SourcePrimaryKey,SourceCode,Period,OriginatingRegionCode,PropertyFundCode,FunctionalDepartmentCode,JobCode,GlAccountCode,
	LocalCurrency,LocalActual,EnterDate,Description,Basis,LastDate,GlAccountSuffix,NetTSCost, UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
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
	IsDeleted bit NOT NULL
)
CREATE TABLE #PropertyFund(
	ImportKey int NOT NULL,
	PropertyFundId int NOT NULL,
	Name varchar(100) NOT NULL,
	RelatedFundId int NOT NULL,
	ProjectRegionId int NOT NULL,
	ProjectTypeId int NOT NULL,
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
(ImportKey, PropertyFundMappingId,PropertyFundId,SourceCode,PropertyFundCode,InsertedDate,UpdatedDate,IsDeleted)
Select Pfm.ImportKey, Pfm.PropertyFundMappingId,Pfm.PropertyFundId,Pfm.SourceCode,Pfm.PropertyFundCode,Pfm.InsertedDate,Pfm.UpdatedDate,Pfm.IsDeleted
From Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,PropertyFundMappingId)

Insert Into #OriginatingRegionMapping
(ImportKey,OriginatingRegionMappingId,GlobalRegionId,SourceCode,RegionCode,InsertedDate,UpdatedDate,IsDeleted)
Select Orm.ImportKey,Orm.OriginatingRegionMappingId,Orm.GlobalRegionId,Orm.SourceCode,Orm.RegionCode,Orm.InsertedDate,Orm.UpdatedDate,Orm.IsDeleted
From Gdm.OriginatingRegionMapping Orm 
		INNER JOIN Gdm.OriginatingRegionMappingActive(@DataPriorToDate) OrmA ON OrmA.ImportKey = Orm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionMapping (RegionCode,SourceCode,IsDeleted,GlobalRegionId, OriginatingRegionMappingId)

Insert Into #PropertyFund
(ImportKey,PropertyFundId,Name,RelatedFundId,ProjectRegionId,ProjectTypeId,InsertedDate,UpdatedDate)
Select Pf.ImportKey,Pf.PropertyFundId,Pf.Name,Pf.RelatedFundId,Pf.ProjectRegionId,Pf.ProjectTypeId,Pf.InsertedDate,Pf.UpdatedDate
From Gdm.PropertyFund Pf 
		INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PfA ON PfA.ImportKey = Pf.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (ProjectRegionId,PropertyFundId)

Insert Into #ProjectRegion
(ImportKey,ProjectRegionId,GlobalProjectRegionId,Name,Code,InsertedDate,UpdatedDate,UpdatedByStaffId)
Select Pr.ImportKey,Pr.ProjectRegionId,Pr.GlobalProjectRegionId,Pr.Name,Pr.Code,Pr.InsertedDate,Pr.UpdatedDate,Pr.UpdatedByStaffId
From TapasGlobal.ProjectRegion Pr 
	INNER JOIN TapasGlobal.ProjectRegionActive(@DataPriorToDate) PrA ON PrA.ImportKey = Pr.ImportKey

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

PRINT 'Completed inserting Active records into temp table'
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #ProfitabilityActual(
	CalendarKey int NOT NULL,GlAccountKey int NOT NULL,SourceKey int NOT NULL,FunctionalDepartmentKey int NOT NULL,ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,OriginatingRegionKey int NOT NULL,AllocationRegionKey int NOT NULL,PropertyFundKey int NOT NULL,
	ReferenceCode Varchar(50) NOT NULL,LocalCurrencyKey Int NOT NULL,LocalActual money NOT NULL) 

Insert Into #ProfitabilityActual
           (CalendarKey,GlAccountKey,SourceKey,FunctionalDepartmentKey,ReimbursableKey,ActivityTypeKey,OriginatingRegionKey,AllocationRegionKey
           ,PropertyFundKey,ReferenceCode,LocalCurrencyKey,LocalActual)

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
			AND GrFdm1.ReferenceCode LIKE CASE WHEN Gl.JobCode IS NOT NULL THEN Fd.GlobalCode + ':'+ LTRIM(RTRIM(Gl.JobCode))
												ELSE Fd.GlobalCode + ':UNKNOWN' END

		--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
		--that will be used, should the JobCode not match, but the FunctionalDepartment does match
		LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2
			ON ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate
			AND GrFdm2.ReferenceCode LIKE Fd.GlobalCode +':' 

			
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

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Transfer the updated rows
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
	LocalActual					= Pro.LocalActual
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
ReferenceCode, LocalCurrencyKey, LocalActual)

Select
		Pro.CalendarKey,Pro.GlAccountKey,Pro.FunctionalDepartmentKey,Pro.ReimbursableKey,
		Pro.ActivityTypeKey,Pro.SourceKey,Pro.OriginatingRegionKey,Pro.AllocationRegionKey,Pro.PropertyFundKey,
		Pro.ReferenceCode, Pro.LocalCurrencyKey, Pro.LocalActual
									
From	#ProfitabilityActual Pro
			LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON 
										ProExists.SourceKey						= Pro.SourceKey
									AND	ProExists.ReferenceCode					= Pro.ReferenceCode
Where ProExists.SourceKey IS NULL
PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


--MRI should never delete rows from the GeneralLedger....
--hence we should never have to delete records
PRINT 'Orphan Rows Delete in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



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

INSERT INTO #GlobalGlAccountCategoryHierarchy
(GlobalGlAccountCategoryHierarchyId,GlobalGlAccountCategoryHierarchyGroupId,GlobalGlAccountId,
MajorGlAccountCategoryId,MinorGlAccountCategoryId,InsertedDate,UpdatedDate,IsDeleted,AccountType)
Select GlH.GlobalGlAccountCategoryHierarchyId,GlH.GlobalGlAccountCategoryHierarchyGroupId,GlH.GlobalGlAccountId,
		GlH.MajorGlAccountCategoryId,GlH.MinorGlAccountCategoryId,GlH.InsertedDate,GlH.UpdatedDate,GlH.IsDeleted,GlH.AccountType
From Gdm.GlobalGlAccountCategoryHierarchy GlH
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHa ON GlHa.ImportKey = GlH.ImportKey


/* Add virtual Mappings for all the GlAccounts that is not part of ANY Hierarchy*/
/*
INSERT INTO #GlobalGlAccountCategoryHierarchy
(GlobalGlAccountCategoryHierarchyId,GlobalGlAccountCategoryHierarchyGroupId,GlobalGlAccountId,
MajorGlAccountCategoryId,MinorGlAccountCategoryId,InsertedDate,UpdatedDate,IsDeleted,AccountType)
Select GlH.GlobalGlAccountCategoryHierarchyId,GlH.GlobalGlAccountCategoryHierarchyGroupId,GlH.GlobalGlAccountId,
		GlH.MajorGlAccountCategoryId,GlH.MinorGlAccountCategoryId,GlH.InsertedDate,GlH.UpdatedDate,GlH.IsDeleted,GlH.AccountType
From Gr.GlobalGlAccountCategoryHierarchyVirtual(@DataPriorToDate) GlH
*/

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

PRINT 'Prepare temp table(s) for optimization'
PRINT CONVERT(Varchar(27), getdate(), 121)
		
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--ProfitabilityActualGlAccountCategoryBridge
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Remove all old Bridges and rebuild them:)
DELETE From [GrReporting].[dbo].[ProfitabilityActualGlAccountCategoryBridge] 
Where ProfitabilityActualKey IN 
	(Select ProExists.ProfitabilityActualKey 
	From	#ProfitabilityActual Pro
			INNER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON 
										ProExists.SourceKey	= Pro.SourceKey
									AND	ProExists.ReferenceCode	= Pro.ReferenceCode
	)

PRINT 'Delete rows from [ProfitabilityActualGlAccountCategoryBridge] table:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
	


INSERT INTO [GrReporting].[dbo].[ProfitabilityActualGlAccountCategoryBridge]
           ([ProfitabilityActualKey]
           ,[GlAccountCategoryKey])
Select 
		ProExists.ProfitabilityActualKey,
		GlAc.GlAccountCategoryKey GlAccountCategoryKey
From 

		#ProfitabilityActual Gl
			
		LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON 
										ProExists.SourceKey	= Gl.SourceKey
									AND	ProExists.ReferenceCode	= Gl.ReferenceCode

		LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON GrGa.GlAccountKey = Gl.GlAccountKey
					AND DATEADD(dd,Gl.CalendarKey,'1900-01-01')  BETWEEN GrGa.StartDate AND GrGa.EndDate

		INNER JOIN #GlobalGlAccountCategoryHierarchy GlAcH ON GlAcH.GlobalGlAccountId = GrGa.GlobalGlAccountId 
															
		LEFT OUTER JOIN #MajorGlAccountCategory MaGlAc ON MaGlAc.MajorGlAccountCategoryId = GlAcH.MajorGlAccountCategoryId

		LEFT OUTER JOIN #MinorGlAccountCategory MiGlAc ON MiGlAc.MinorGlAccountCategoryId = GlAcH.MinorGlAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAc ON GlAc.GlobalGlAccountCategoryCode = 
																	LTRIM(STR(GlAcH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+
																		LTRIM(STR(MaGlAc.MajorGlAccountCategoryId,10,0))+':'+
																		LTRIM(STR(MiGlAc.MinorGlAccountCategoryId,10,0))
																	AND DATEADD(dd,Gl.CalendarKey,'1900-01-01')  BETWEEN GlAc.StartDate AND GlAc.EndDate
--UNKNOWN GlAccounts are not allowed to have bridge table entries																	
Where GrGa.GlobalGlAccountId <> -1
PRINT 'Insert Data into [ProfitabilityActualGlAccountCategoryBridge] table:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Year to Date Bridge Table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


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