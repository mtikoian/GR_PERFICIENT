 USE [GrReportingStaging]
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
DROP VIEW [BRCorp].[GeneralLedger]
GO
/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
DROP VIEW [BRProp].[GeneralLedger]
GO
/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
DROP VIEW [CNCorp].[GeneralLedger]
GO
/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
DROP VIEW [CNProp].[GeneralLedger]
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
DROP VIEW [EUCorp].[GeneralLedger]
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
DROP VIEW [EUProp].[GeneralLedger]
GO
/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
DROP VIEW [INCorp].[GeneralLedger]
GO
/****** Object:  View [INProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
DROP VIEW [INProp].[GeneralLedger]
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
DROP VIEW [USCorp].[GeneralLedger]
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
DROP VIEW [USProp].[GeneralLedger]
GO
/****** Object:  View [CNCorp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrGHis]'))
DROP VIEW [CNCorp].[GrGHis]
GO
/****** Object:  View [CNProp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrGHis]'))
DROP VIEW [CNProp].[GrGHis]
GO
/****** Object:  View [EUCorp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrGHis]'))
DROP VIEW [EUCorp].[GrGHis]
GO
/****** Object:  View [EUProp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrGHis]'))
DROP VIEW [EUProp].[GrGHis]
GO
/****** Object:  View [USCorp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrGHis]'))
DROP VIEW [USCorp].[GrGHis]
GO
/****** Object:  View [USProp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrGHis]'))
DROP VIEW [USProp].[GrGHis]
GO
/****** Object:  View [BRCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GrJournal]'))
DROP VIEW [BRCorp].[GrJournal]
GO
/****** Object:  View [BRProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GrJournal]'))
DROP VIEW [BRProp].[GrJournal]
GO
/****** Object:  View [CNCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrJournal]'))
DROP VIEW [CNCorp].[GrJournal]
GO
/****** Object:  View [CNProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrJournal]'))
DROP VIEW [CNProp].[GrJournal]
GO
/****** Object:  View [EUCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrJournal]'))
DROP VIEW [EUCorp].[GrJournal]
GO
/****** Object:  View [EUProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrJournal]'))
DROP VIEW [EUProp].[GrJournal]
GO
/****** Object:  View [INCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GrJournal]'))
DROP VIEW [INCorp].[GrJournal]
GO
/****** Object:  View [INProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GrJournal]'))
DROP VIEW [INProp].[GrJournal]
GO
/****** Object:  View [USCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrJournal]'))
DROP VIEW [USCorp].[GrJournal]
GO
/****** Object:  View [USProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrJournal]'))
DROP VIEW [USProp].[GrJournal]
GO
/****** Object:  View [USProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [USProp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''US'' SourceCode,
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
	''USD'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From USProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [USCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [USCorp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''UC'' SourceCode,
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
	''USD'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From USCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [INProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [INProp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''IN'' SourceCode,
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
	ISNULL(JR.OCURRCODE,''INR'') OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From INProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [INCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [INCorp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''IC'' SourceCode,
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
	''INR'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From INCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [EUProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [EUProp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''EU'' SourceCode,
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
	''N'' BALFOR,
	JR.SOURCE
From EUProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [EUCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [EUCorp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''EC'' SourceCode,
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
	''N'' BALFOR,
	JR.SOURCE
From EUCorp.JOURNAL JR

--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [CNProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CNProp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''CN'' SourceCode,
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
	''CNY'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From CNProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [CNCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CNCorp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''CC'' SourceCode,
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
	''CNY'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From CNCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [BRProp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [BRProp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''BR'' SourceCode,
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
	ISNULL(JR.OCURRCODE,''BRL'') OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From BRProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [BRCorp].[GrJournal]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GrJournal]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [BRCorp].[GrJournal]
AS
Select 
	JR.PERIOD+''-''+JR.REF+''-''+JR.SOURCE+''-''+JR.SITEID+''-''+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	''BC'' SourceCode,
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
	''BRL'' OcurrCode,
	''N'' BALFOR,
	JR.SOURCE
From BRCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USProp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [USProp].[GrGHis]
AS
Select 
	GHIS.PERIOD+''-''+GHIS.REF+''-''+GHIS.SOURCE+''-''+GHIS.SITEID+''-''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	''US'' SourceCode,
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
	''USD'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From USProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [USCorp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [USCorp].[GrGHis]
AS
Select 
	GHIS.PERIOD+''-''+GHIS.REF+''-''+GHIS.SOURCE+''-''+GHIS.SITEID+''-''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	''UC'' SourceCode,
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
	''USD'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From USCorp.GHIS

--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [EUProp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'create VIEW [EUProp].[GrGHis]
AS
Select 
	GHIS.PERIOD+''-''+GHIS.REF+''-''+GHIS.SOURCE+''-''+GHIS.SITEID+''-''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	''EU'' SourceCode,
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
'
GO
/****** Object:  View [EUCorp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [EUCorp].[GrGHis]
AS
Select 
	GHIS.PERIOD+''-''+GHIS.REF+''-''+GHIS.SOURCE+''-''+GHIS.SITEID+''-''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	''EC'' SourceCode,
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
'
GO
/****** Object:  View [CNProp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CNProp].[GrGHis]
AS
Select 
	GHIS.PERIOD+''-''+GHIS.REF+''-''+GHIS.SOURCE+''-''+GHIS.SITEID+''-''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	''CN'' SourceCode,
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
	''CNY'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From CNProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp
'
GO
/****** Object:  View [CNCorp].[GrGHis]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrGHis]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CNCorp].[GrGHis]
AS
Select 
	GHIS.PERIOD+''-''+GHIS.REF+''-''+GHIS.SOURCE+''-''+GHIS.SITEID+''-''+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	''CC'' SourceCode,
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
	''CNY'' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE
From CNCorp.GHIS
--NO Where clauses allowed here, that should be in relevant stp

'
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [USProp].[GeneralLedger]
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
'
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [USCorp].[GeneralLedger]
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

'
GO
/****** Object:  View [INProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [INProp].[GeneralLedger]
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
'
GO
/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [INCorp].[GeneralLedger]
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
'
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'create VIEW [EUProp].[GeneralLedger]
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
'
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [EUCorp].[GeneralLedger]
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
'
GO
/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CNProp].[GeneralLedger]
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
'
GO
/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [CNCorp].[GeneralLedger]
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

'
GO
/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [BRProp].[GeneralLedger]
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
'
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 01/27/2010 14:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [BRCorp].[GeneralLedger]
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

'
GO
