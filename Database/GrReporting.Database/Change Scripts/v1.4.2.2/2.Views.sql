USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRCorp].[GeneralLedger]'))
DROP VIEW [BRCorp].[GeneralLedger]
GO

/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BRProp].[GeneralLedger]'))
DROP VIEW [BRProp].[GeneralLedger]
GO

/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNCorp].[GeneralLedger]'))
DROP VIEW [CNCorp].[GeneralLedger]
GO

/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[CNProp].[GeneralLedger]'))
DROP VIEW [CNProp].[GeneralLedger]
GO

/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUCorp].[GeneralLedger]'))
DROP VIEW [EUCorp].[GeneralLedger]
GO

/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EUProp].[GeneralLedger]'))
DROP VIEW [EUProp].[GeneralLedger]
GO

/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INCorp].[GeneralLedger]'))
DROP VIEW [INCorp].[GeneralLedger]
GO

/****** Object:  View [INProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[INProp].[GeneralLedger]'))
DROP VIEW [INProp].[GeneralLedger]
GO

/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USCorp].[GeneralLedger]'))
DROP VIEW [USCorp].[GeneralLedger]
GO

/****** Object:  View [USProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[USProp].[GeneralLedger]'))
DROP VIEW [USProp].[GeneralLedger]
GO

USE [GrReportingStaging]
GO

/****** Object:  View [BRCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  View [BRProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [BRProp].[GeneralLedger]
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
From BRProp.GrGHis
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
From BRProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [CNCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNCorp].[GeneralLedger]
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
From CNCorp.GrGHis
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
	CONVERT(Char(6),NULL) CorporateDepartmentCode, --this allow the GeneralLedger for Prop & Corp to be union ed,,
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
From CNCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp


GO

/****** Object:  View [CNProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [CNProp].[GeneralLedger]
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
From CNProp.GrGHis
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
From CNProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [EUCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  View [EUProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  View [INCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [INCorp].[GeneralLedger]
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
	JobCode
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
From INCorp.GrGHis
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
From INCorp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [INProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [INProp].[GeneralLedger]
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
From INProp.GrGHis
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
From INProp.GrJournal 
--NO Where clauses allowed here, that should be in relevant stp

GO

/****** Object:  View [USCorp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

/****** Object:  View [USProp].[GeneralLedger]    Script Date: 10/26/2010 10:25:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

