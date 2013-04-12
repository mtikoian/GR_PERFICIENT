/*

Views that need to be created:

GrReportingStaging.Gdm.SnapshotGlobalRegionExpanded

*/

USE [GrReportingStaging]
GO

/****** Object:  View [Gdm].[SnapshotGlobalRegionExpanded]    Script Date: 04/04/2011 18:53:17 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Gdm].[SnapshotGlobalRegionExpanded]'))
DROP VIEW [Gdm].[SnapshotGlobalRegionExpanded]
GO

USE [GrReportingStaging]
GO

/****** Object:  View [Gdm].[SnapshotGlobalRegionExpanded]    Script Date: 04/04/2011 18:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Gdm].[SnapshotGlobalRegionExpanded]
AS
SELECT
	SubReg.[GlobalRegionId],
	Reg.Code RegionCode,
	Reg.[Name] RegionName,
	Reg.CountryId RegionCountryId,
	Reg.DefaultCurrencyCode RegionDefaultCurrencyCode,
	Reg.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
	Reg.ProjectCodePortion RegionProjectCodePortion,
	
	CONVERT(DATETIME,CONVERT(VARCHAR(23),Reg.[InsertedDate],120),120) InsertedDate,
	CONVERT(DATETIME,CONVERT(VARCHAR(23),CASE WHEN MAX(SubReg.[UpdatedDate]) < MAX(Reg.[UpdatedDate]) THEN MAX(Reg.[UpdatedDate]) ELSE MAX(SubReg.[UpdatedDate]) END,120),120)  UpdatedDate,
	
	SubReg.[IsAllocationRegion],
	SubReg.[IsOriginatingRegion],
	SubReg.[Code] SubRegionCode,
	SubReg.[Name] SubRegionName,
	SubReg.DefaultCurrencyCode SubRegionDefaultCurrencyCode,
	--SubReg.DefaultCorporateSourceCode SubRegionDefaultCorporateSourceCode,
	SubReg.ProjectCodePortion SubRegionProjectCodePortion,
	Reg.SnapshotId
FROM
	[Gdm].[SnapshotGlobalRegion] Reg
	INNER JOIN
		[Gdm].[SnapshotGlobalRegion] SubReg ON
			SubReg.ParentGlobalRegionId = Reg.GlobalRegionId AND
			SubReg.SnapshotId = Reg.SnapshotId

GROUP BY
	SubReg.[GlobalRegionId],
	Reg.[Code],
	Reg.[Name],
	Reg.CountryId,
	Reg.DefaultCurrencyCode,
	Reg.DefaultCorporateSourceCode,	
	Reg.ProjectCodePortion,
	Reg.[InsertedDate],
	SubReg.[IsAllocationRegion],
	SubReg.[IsOriginatingRegion],
	SubReg.[Code],
	SubReg.[Name],
	SubReg.DefaultCurrencyCode,
	--SubReg.DefaultCorporateSourceCode,
	SubReg.ProjectCodePortion,
	Reg.SnapshotId

UNION

SELECT
	Reg.[GlobalRegionId],
	Reg.[Code] RegionCode,
	Reg.[Name] RegionName,
	Reg.CountryId RegionCountryId,
	Reg.DefaultCurrencyCode RegionDefaultCurrencyCode,
	Reg.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
	Reg.ProjectCodePortion RegionProjectCodePortion,
		
	CONVERT(DATETIME,CONVERT(VARCHAR(23),Reg.[InsertedDate],120),120),
	CONVERT(DATETIME,CONVERT(VARCHAR(23),Reg.[UpdatedDate],120),120),
	
	Reg.[IsAllocationRegion],
	Reg.[IsOriginatingRegion],
	NULL SubRegionCode,
	NULL SubRegionName,
	NULL SubRegionDefaultCurrencyCode,
	--NULL SubRegionDefaultCorporateSourceCode,
	NULL SubRegionProjectCodePortion,
	Reg.SnapshotId
	
FROM
	[Gdm].[SnapshotGlobalRegion] Reg
WHERE
	Reg.ParentGlobalRegionId IS NULL AND
	Reg.GlobalRegionId IN (
								SELECT
									ParentGlobalRegionId 
								FROM
									[Gdm].[SnapshotGlobalRegion] Reg2 
								WHERE
									Reg2.ParentGlobalRegionId IS NOT NULL AND
									Reg2.SnapshotId = Reg.SnapshotId
							   )

GO
