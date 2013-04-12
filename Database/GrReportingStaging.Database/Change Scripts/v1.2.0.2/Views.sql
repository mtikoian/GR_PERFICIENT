USE [GrReportingStaging]
GO



USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [BRCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From BRCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp

UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From BRCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [BRCorp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [BRCorp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'BC' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	'BRL' OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From BRCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [BRProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From BRProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From BRProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [BRProp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [BRProp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'BR' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	ISNULL(JR.OCURRCODE,'BRL') OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From BRProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CNCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From CNCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp

UNION ALL
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From CNCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [CNCorp].[GrGHis]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CNCorp].[GrGHis]
AS
Select 
	'G-'+GHIS.PERIOD+'-'+GHIS.REF+'-'+GHIS.SOURCE+'-'+GHIS.SITEID+'-'+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	'CC' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID RegionCode,
	GHIS.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	GHIS.JOBCODE FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN Description,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	'CNY' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From CNCorp.GHIS
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [CNCorp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CNCorp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'CC' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	'CNY' OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From CNCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CNProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From CNProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From CNProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [CNProp].[GrGHis]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CNProp].[GrGHis]
AS
Select 
	'G-'+GHIS.PERIOD+'-'+GHIS.REF+'-'+GHIS.SOURCE+'-'+GHIS.SITEID+'-'+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	'CN' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN Description,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	'CNY' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From CNProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [CNProp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [CNProp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'CN' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	'CNY' OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From CNProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [EUCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From EUCorp.GrGHis
UNION ALL
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From EUCorp.GrJournal 

GO

/****** Object:  View [EUCorp].[GrGHis]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [EUCorp].[GrGHis]
AS
Select 
	'G-'+GHIS.PERIOD+'-'+GHIS.REF+'-'+GHIS.SOURCE+'-'+GHIS.SITEID+'-'+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	'EC' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID RegionCode,
	GHIS.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	GHIS.JOBCODE FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN Description,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From EUCorp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [EUCorp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [EUCorp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'EC' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From EUCorp.JOURNAL JR

--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [EUProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From EUProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From EUProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [EUProp].[GrGHis]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [EUProp].[GrGHis]
AS
Select 
	'G-'+GHIS.PERIOD+'-'+GHIS.REF+'-'+GHIS.SOURCE+'-'+GHIS.SITEID+'-'+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	'EU' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN Description,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	GHIS.OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From EUProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [EUProp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [EUProp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'EU' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	JR.OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From EUProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [Gdm].[GlobalRegionExpanded]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [Gdm].[GlobalRegionExpanded]
AS
SELECT SubReg.[ImportKey]
      ,SubReg.[GlobalRegionId]
      ,Reg.RegionCode
      ,Reg.[Name] Name
      ,CONVERT(DateTime,CONVERT(Varchar(23),Reg.[InsertedDate],120),120) InsertedDate
      ,CONVERT(DateTime,CONVERT(Varchar(23),CASE WHEN MAX(SubReg.[UpdatedDate]) < MAX(Reg.[UpdatedDate]) THEN MAX(Reg.[UpdatedDate]) ELSE MAX(SubReg.[UpdatedDate]) END,120),120)  UpdatedDate
      ,SubReg.[IsAllocationRegion]
      ,SubReg.[IsOriginatingRegion]
      ,SubReg.[RegionCode] SubRegionCode
      ,SubReg.[Name] SubRegionName
  FROM [Gdm].[GlobalRegion] Reg
		INNER JOIN [Gdm].[GlobalRegion] SubReg ON SubReg.ParentGlobalRegionId = Reg.GlobalRegionId
GRoup By SubReg.[ImportKey]
      ,SubReg.[GlobalRegionId]
      ,Reg.[RegionCode]
      ,Reg.[Name]
      ,Reg.[InsertedDate]
      ,SubReg.[IsAllocationRegion]
      ,SubReg.[IsOriginatingRegion]
      ,SubReg.[RegionCode]
      ,SubReg.[Name]
UNION
SELECT Reg.[ImportKey]
      ,Reg.[GlobalRegionId]
      ,Reg.[RegionCode] RegionCode
      ,Reg.[Name] RegionName
      ,CONVERT(DateTime,CONVERT(Varchar(23),Reg.[InsertedDate],120),120)
      ,CONVERT(DateTime,CONVERT(Varchar(23),Reg.[UpdatedDate],120),120)
      ,Reg.[IsAllocationRegion]
      ,Reg.[IsOriginatingRegion]
      ,NULL SubRegionCode
      ,NULL SubRegionName
  FROM [Gdm].[GlobalRegion] Reg
Where Reg.ParentGlobalRegionId IS NULL
AND Reg.GlobalRegionId NOT IN (
	Select ParentGlobalRegionId 
	From [Gdm].[GlobalRegion] Reg 
	Where Reg.ParentGlobalRegionId IS NOT NULL
)



GO

/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [INCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From INCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From INCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [INCorp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [INCorp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'IC' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	'INR' OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From INCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [INProp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [INProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From INProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
*/
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From INProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [INProp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [INProp].[GrJournal]
AS
Select 
	'J-'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'IN' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	ISNULL(JR.OCURRCODE,'INR') OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From INProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [USCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From USCorp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	OcurrCode,
	Balfor,
	Source
From USCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [USCorp].[GrGHis]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [USCorp].[GrGHis]
AS
Select 
	'G-'+GHIS.PERIOD+'-'+GHIS.REF+'-'+GHIS.SOURCE+'-'+GHIS.SITEID+'-'+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	'UC' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID RegionCode,
	GHIS.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	GHIS.JOBCODE FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN Description,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	'USD' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From USCorp.GHIS

--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [USCorp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [USCorp].[GrJournal]
AS
Select 
	'J'+JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'UC' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID RegionCode,
	JR.DEPARTMENT PropertyFundCode,
	--This looks strange, but its because in Corp: the jobcode is the same as the functionaldepartment
	JR.JOBCODE FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	'USD' OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From USCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [USProp].[GeneralLedger]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [USProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From USProp.GrGHis
--NO Where clauses allowed here, that should be in relevant stp
UNION ALL
Select
	SourcePrimaryKey,
	SourceCode,
	Period,
	RegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	Amount,
	EnterDate,
	Description,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source
From USProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [USProp].[GrGHis]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [USProp].[GrGHis]
AS
Select 
	'G-'+GHIS.PERIOD+'-'+GHIS.REF+'-'+GHIS.SOURCE+'-'+GHIS.SITEID+'-'+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	'US' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.DESCRPN Description,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	'USD' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From USProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [USProp].[GrJournal]    Script Date: 03/03/2010 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [USProp].[GrJournal]
AS
Select 
	'J-'+ JR.PERIOD+'-'+JR.REF+'-'+JR.SOURCE+'-'+JR.SITEID+'-'+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	'US' SourceCode,
	JR.PERIOD Period,
	JR.ENTITYID PropertyFundCode,
	LEFT(JR.DEPARTMENT,3) RegionCode,
	SUBSTRING(JR.DEPARTMENT,4,DATALENGTH (JR.DEPARTMENT)-3) FunctionalDepartmentCode,
	JR.JOBCODE JobCode,
	JR.ACCTNUM GlAccountCode,
	JR.AMT Amount,
	JR.ENTRDATE EnterDate,
	JR.DESCRPN Description,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	'USD' OcurrCode,
	'N' BALFOR,
	JR.SOURCE
From USProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

GO

