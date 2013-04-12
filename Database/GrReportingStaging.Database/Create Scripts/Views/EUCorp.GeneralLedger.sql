USE [GrReportingStaging]
GO
/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
DROP VIEW [EUCorp].[GeneralLedger]
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
From EUCorp.GrJournal 
GO
