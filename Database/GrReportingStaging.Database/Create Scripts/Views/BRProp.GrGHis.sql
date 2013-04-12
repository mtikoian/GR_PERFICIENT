USE [GrReportingStaging]
GO
/****** Object:  View [BRProp].[GrGHis]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GrGHis]'))
DROP VIEW [BRProp].[GrGHis]
GO
/*
CREATE VIEW [BRProp].[GrGHis]
AS
Select 
	'PERIOD='+GHIS.PERIOD+'&REF='+GHIS.REF+'&SOURCE='+GHIS.SOURCE+'&SITEID='+GHIS.SITEID+'&ITEM='+LTRIM(STR(GHIS.ITEM,10,0)) SourcePrimaryKey,
	2 SourceTableId, --The Id field is purely to optimize the join in Loader stp
	'GHIS' SourceTable,
	'BR' SourceCode,
	GHIS.PERIOD Period,
	GHIS.ENTITYID PropertyFundCode,
	LEFT(GHIS.DEPARTMENT,3) RegionCode,
	SUBSTRING(GHIS.DEPARTMENT,4,DATALENGTH (GHIS.DEPARTMENT)-3) FunctionalDepartmentCode,
	GHIS.JOBCODE JobCode,
	GHIS.ACCTNUM GlAccountCode,
	GHIS.AMT Amount,
	GHIS.ENTRDATE EnterDate,
	GHIS.USERID [User],
	GHIS.DESCRPN [Description],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	GHIS.CDEP CorporateDepartmentCode,
	GHIS.OcurrCode,
	'N' BALFOR,
	GHIS.SOURCE,
	GHIS.REF Ref,
	GHIS.SITEID SiteID,
	GHIS.ITEM Item,
	GHIS.ENTITYID EntityID,
	'' Reversal,
	'' Status,
	'' UserID
From BRProp.GHIS
Where GHIS.ENTRDATE >= CONVERT(DateTime, '2010-01-01 00:00:00', 120)
--NO Where clauses allowed here, that should be in relevant stp
*/
GO
