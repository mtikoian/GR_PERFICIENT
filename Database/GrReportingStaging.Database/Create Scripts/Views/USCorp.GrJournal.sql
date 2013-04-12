USE [GrReportingStaging]
GO
/****** Object:  View [USCorp].[GrJournal]    Script Date: 09/01/2009 12:34:09 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GrJournal]'))
DROP VIEW [USCorp].[GrJournal]
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
	JR.USERID [User],
	JR.DESCRPN [Description],
	JR.ADDLDESC AdditionalDescription,
	JR.BASIS Basis,
	JR.LASTDATE LastDate,
	RIGHT(RTRIM(JR.ACCTNUM),2) GlAccountSuffix,
	'USD' OcurrCode,
	'N' BALFOR,
	JR.SOURCE,
	JR.REF Ref,
	JR.SITEID SiteID,
	JR.ITEM Item,
	JR.ENTITYID EntityID,
	JR.REVERSAL Reversal,
	JR.STATUS Status,
	JR.USERID UserID
From USCorp.JOURNAL JR
--NO Where clauses allowed here, that should be in relevant stp
GO
