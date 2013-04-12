USE [GrReportingStaging]
GO
/****** Object:  View [USProp].[GeneralLedger]    Script Date: 09/01/2009 12:34:09 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
DROP VIEW [USProp].[GeneralLedger]
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
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
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
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CorporateDepartmentCode,
	OcurrCode,
	Balfor,
	Source,
	Ref,
	SiteID,
	Item,
	EntityID,
	Reversal,
	Status,
	UserID
From USProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp
GO
