USE [GrReportingStaging]
GO
/****** Object:  View [BRProp].[GrGHis]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GrGHis]'))
DROP VIEW [CNProp].[GrGHis]
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
	'' [User],
	GHIS.DESCRPN [Description],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	'CNY' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE,
	GHIS.REF Ref,
	GHIS.SITEID SiteID,
	GHIS.ITEM Item,
	GHIS.ENTITYID EntityID,
	'' Reversal,
	'' Status,
	'' UserID
From CNProp.GHIS
--NO Where clauses allowed here, that should be in relevant stp
GO
