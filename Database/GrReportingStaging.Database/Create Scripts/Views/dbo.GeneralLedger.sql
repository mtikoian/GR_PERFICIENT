USE [GrReportingStaging]
GO

/****** Object:  View [dbo].[ProfitabilityFact]    Script Date: 11/19/2010 09:49:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select COUNT(*) From GeneralLedger

CREATE VIEW [dbo].GeneralLedger
AS
Select 'BRCorp' SourceSystem, * From BRCorp.GeneralLedger
UNION ALL
Select 'BRProp' SourceSystem, * From BRProp.GeneralLedger

UNION ALL
Select 'CNCorp' SourceSystem, * From CNCorp.GeneralLedger
UNION ALL
Select 'CNProp' SourceSystem, * From CNProp.GeneralLedger

UNION ALL
Select 'INCorp' SourceSystem, * From INCorp.GeneralLedger
UNION ALL
Select 'INProp' SourceSystem, * From INProp.GeneralLedger

UNION ALL
Select 'EUCorp' SourceSystem, * From EUCorp.GeneralLedger
UNION ALL
Select 'EUProp' SourceSystem, * From EUProp.GeneralLedger


UNION ALL
Select 'USCorp' SourceSystem, * From USCorp.GeneralLedger
UNION ALL
Select 'USProp' SourceSystem, * From USProp.GeneralLedger


 