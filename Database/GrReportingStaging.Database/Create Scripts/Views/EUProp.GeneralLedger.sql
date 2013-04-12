USE [GrReportingStaging]
GO
/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
DROP VIEW [EUProp].[GeneralLedger]
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
From EUProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp
GO
