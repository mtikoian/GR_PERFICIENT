USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionExpanded]'))
	DROP VIEW [Gdm].[GlobalRegionExpanded]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Gdm].[GlobalRegionExpanded]
AS
SELECT
	SubReg.[ImportKey],
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
	SubReg.ProjectCodePortion SubRegionProjectCodePortion
	
FROM
	[Gdm].[GlobalRegion] Reg
	INNER JOIN
		[Gdm].[GlobalRegion] SubReg ON SubReg.ParentGlobalRegionId = Reg.GlobalRegionId

GROUP BY
	SubReg.[ImportKey],
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
	SubReg.ProjectCodePortion

UNION

SELECT
	Reg.[ImportKey],
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
	NULL SubRegionProjectCodePortion
	
FROM
	[Gdm].[GlobalRegion] Reg
WHERE
	Reg.ParentGlobalRegionId IS NULL AND
	Reg.GlobalRegionId NOT IN (
								SELECT ParentGlobalRegionId 
								FROM [Gdm].[GlobalRegion] Reg 
								WHERE Reg.ParentGlobalRegionId IS NOT NULL
							   )


GO


