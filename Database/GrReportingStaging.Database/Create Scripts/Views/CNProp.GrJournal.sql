USE [GrReportingStaging]
GO
/****** Object:  View [BRProp].[GrJournal]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrJournal]'))
DROP VIEW [CNProp].[GrJournal]
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
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	JR.CDEP CorporateDepartmentCode,
	'CNY' OcurrCode,
	'N' BALFOR,
	JR.SOURCE,
	JR.REF Ref,
	JR.SITEID SiteID,
	JR.ITEM Item,
	JR.ENTITYID EntityID,
	JR.REVERSAL Reversal,
	JR.STATUS Status,
	JR.USERID UserID
From CNProp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
GO
