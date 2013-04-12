USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GrJournal]'))
DROP VIEW [BRCorp].[GrJournal]
GO

/****** Object:  View [BRProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GrJournal]'))
DROP VIEW [BRProp].[GrJournal]
GO

/****** Object:  View [CNCorp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrGHis]'))
DROP VIEW [CNCorp].[GrGHis]
GO

/****** Object:  View [CNCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GrJournal]'))
DROP VIEW [CNCorp].[GrJournal]
GO

/****** Object:  View [CNProp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrGHis]'))
DROP VIEW [CNProp].[GrGHis]
GO

/****** Object:  View [CNProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrJournal]'))
DROP VIEW [CNProp].[GrJournal]
GO

/****** Object:  View [EUCorp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrGHis]'))
DROP VIEW [EUCorp].[GrGHis]
GO

/****** Object:  View [EUCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GrJournal]'))
DROP VIEW [EUCorp].[GrJournal]
GO

/****** Object:  View [EUProp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrGHis]'))
DROP VIEW [EUProp].[GrGHis]
GO

/****** Object:  View [EUProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GrJournal]'))
DROP VIEW [EUProp].[GrJournal]
GO

/****** Object:  View [INCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GrJournal]'))
DROP VIEW [INCorp].[GrJournal]
GO

/****** Object:  View [INProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GrJournal]'))
DROP VIEW [INProp].[GrJournal]
GO

/****** Object:  View [USCorp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrGHis]'))
DROP VIEW [USCorp].[GrGHis]
GO

/****** Object:  View [USCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrJournal]'))
DROP VIEW [USCorp].[GrJournal]
GO

/****** Object:  View [USProp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrGHis]'))
DROP VIEW [USProp].[GrGHis]
GO

/****** Object:  View [USProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GrJournal]'))
DROP VIEW [USProp].[GrJournal]
GO

USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [BRCorp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [BRProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [BRProp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [CNCorp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNCorp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
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

/****** Object:  View [CNCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNCorp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [CNProp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNProp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
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

/****** Object:  View [CNProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNProp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [EUCorp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EUCorp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
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

/****** Object:  View [EUCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EUCorp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [EUProp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create VIEW [EUProp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
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

/****** Object:  View [EUProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EUProp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [INCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [INCorp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [INProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [INProp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [USCorp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [USCorp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
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

/****** Object:  View [USCorp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [USCorp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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

/****** Object:  View [USProp].[GrGHis]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [USProp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
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

/****** Object:  View [USProp].[GrJournal]    Script Date: 03/10/2010 09:17:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [USProp].[GrJournal]
AS
Select 
	'PERIOD='+JR.PERIOD+'&REF='+JR.REF+'&SOURCE='+JR.SOURCE+'&SITEID='+JR.SITEID+'&ITEM='+LTRIM(STR(JR.ITEM,10,0)) SourcePrimaryKey,
	1 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'JOURNAL' SourceTable,
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
USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
DROP VIEW [BRCorp].[GeneralLedger]
GO

/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
DROP VIEW [BRProp].[GeneralLedger]
GO

/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
DROP VIEW [CNCorp].[GeneralLedger]
GO

/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
DROP VIEW [CNProp].[GeneralLedger]
GO

/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
DROP VIEW [EUCorp].[GeneralLedger]
GO

/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
DROP VIEW [EUProp].[GeneralLedger]
GO

/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
DROP VIEW [INCorp].[GeneralLedger]
GO

/****** Object:  View [INProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
DROP VIEW [INProp].[GeneralLedger]
GO

/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
DROP VIEW [USCorp].[GeneralLedger]
GO

/****** Object:  View [USProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
DROP VIEW [USProp].[GeneralLedger]
GO

USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [BRCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [BRProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EUCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create VIEW [EUProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [INCorp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [INProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [INProp].[GeneralLedger]
AS
-- Integration Databases will not have a GHIS table, for no closing process will run that move
-- the journal entries to GHIS
/*
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [USCorp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableID,
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

/****** Object:  View [USProp].[GeneralLedger]    Script Date: 03/10/2010 09:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [USProp].[GeneralLedger]
AS
Select
	SourcePrimaryKey,
	SourceTable,
	SourceTableID,
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
	SourceTable,
	SourceTableId,
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


 