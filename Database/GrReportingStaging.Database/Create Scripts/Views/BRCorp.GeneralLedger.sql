USE [GrReportingStaging]
GO
/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
DROP VIEW [BRCorp].[GeneralLedger]
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
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
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
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,
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
From BRCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO
