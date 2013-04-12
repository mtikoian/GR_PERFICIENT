USE [GrReportingStaging]
GO
/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 09/01/2009 12:34:09 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
DROP VIEW [USCorp].[GeneralLedger]
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
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed
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
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed
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
From USCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO
