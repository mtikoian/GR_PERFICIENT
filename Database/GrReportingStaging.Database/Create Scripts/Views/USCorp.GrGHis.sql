USE [GrReportingStaging]
GO
/****** Object:  View [USCorp].[GrGHis]    Script Date: 09/01/2009 12:34:09 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrGHis]'))
DROP VIEW [USCorp].[GrGHis]
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
	'' [User],
	GHIS.DESCRPN [Description],
	GHIS.ADDLDESC AdditionalDescription,
	GHIS.BASIS Basis,
	CONVERT(DateTime,NULL,120) LastDate,
	RIGHT(RTRIM(GHIS.ACCTNUM),2) GlAccountSuffix,
	'USD' OcurrCode,
	GHIS.BALFOR,
	GHIS.SOURCE,
	GHIS.REF Ref,
	GHIS.SITEID SiteID,
	GHIS.ITEM Item,
	GHIS.ENTITYID EntityID,
	'' Reversal,
	'' Status,
	'' UserID
From USCorp.GHIS

--NO Where clauses allowed here, that should be in relevant stp
GO
