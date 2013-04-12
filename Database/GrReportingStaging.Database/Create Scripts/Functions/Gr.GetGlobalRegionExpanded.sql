USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gr].[GetGlobalRegionExpanded]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gr].[GetGlobalRegionExpanded]
	(@DataPriorToDate DATETIME)
	
RETURNS @Result TABLE
(
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(10) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	RegionCountryId INT NULL,
	RegionDefaultCurrencyCode CHAR(3) NOT NULL,
	RegionDefaultCorporateSourceCode CHAR(2) NOT NULL,
	RegionProjectCodePortion CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsAllocationRegion BIT NOT NULL,
	IsOriginatingRegion BIT NOT NULL,
	SubRegionCode VARCHAR(10) NULL,
	SubRegionName VARCHAR(50) NULL,
	SubRegionDefaultCurrencyCode CHAR(3) NULL,
	SubRegionProjectCodePortion CHAR(2) NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	GR.GlobalRegionId,
	GR.RegionCode,
	GR.RegionName,
	GR.RegionCountryId,
	GR.RegionDefaultCurrencyCode,
	GR.RegionDefaultCorporateSourceCode,
	GR.RegionProjectCodePortion,
	GR.InsertedDate,
	GR.UpdatedDate,
	GR.IsAllocationRegion,
	GR.IsOriginatingRegion,
	GR.SubRegionCode,
	GR.SubRegionName,
	GR.SubRegionDefaultCurrencyCode,
	GR.SubRegionProjectCodePortion,
	GR.IsActive
FROM
	Gdm.GlobalRegionActive(@DataPriorToDate) GRA

	INNER JOIN
	(
		SELECT
			SubRegion.ImportKey,
			SubRegion.GlobalRegionId,
			ParentRegion.Code RegionCode,
			ParentRegion.Name RegionName,
			ParentRegion.CountryId RegionCountryId,
			ParentRegion.DefaultCurrencyCode RegionDefaultCurrencyCode,
			ParentRegion.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
			ParentRegion.ProjectCodePortion RegionProjectCodePortion,
			(	-- We will choose the InsertedDate of the record (ParentRegion or SubRegion) that was last inserted
				SELECT
					MAX(InsertedDate) AS InsertedDate
				FROM
					(
						SELECT ParentRegion.InsertedDate UNION
						SELECT SubRegion.InsertedDate
					) InsertedDates
			) AS InsertedDate,
			(	-- Again, we will choose the InsertedDate of the record (ParentRegion or SubRegion) that was last inserted
				SELECT
					MAX(UpdatedDate) AS UpdatedDate
				FROM
					(
						SELECT ParentRegion.UpdatedDate UNION
						SELECT SubRegion.UpdatedDate
					) UpdatedDates
			) AS UpdatedDate,
			SubRegion.IsAllocationRegion,
			SubRegion.IsOriginatingRegion,
			SubRegion.Code SubRegionCode,
			SubRegion.Name SubRegionName,
			SubRegion.DefaultCurrencyCode SubRegionDefaultCurrencyCode,
			SubRegion.ProjectCodePortion SubRegionProjectCodePortion,
			(ParentRegion.IsActive & SubRegion.IsActive) AS IsActive -- If the Parent Region is not active, then its SubRegions should not be active either
		FROM
			Gdm.GlobalRegion ParentRegion

			INNER JOIN Gdm.GlobalRegion SubRegion ON
				SubRegion.ParentGlobalRegionId = ParentRegion.GlobalRegionId

		UNION

		-- SELECT the Parent Regions (Regions that have no Parent Region)

		SELECT
			ImportKey,
			GlobalRegionId,
			Code RegionCode,
			[Name] RegionName,
			CountryId RegionCountryId,
			DefaultCurrencyCode RegionDefaultCurrencyCode,
			DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
			ProjectCodePortion RegionProjectCodePortion,
			InsertedDate,
			UpdatedDate,
			IsAllocationRegion,
			IsOriginatingRegion,
			NULL SubRegionCode,
			NULL SubRegionName,
			NULL SubRegionDefaultCurrencyCode,
			NULL SubRegionProjectCodePortion,
			IsActive
		FROM
			Gdm.GlobalRegion
		WHERE
			ParentGlobalRegionId IS NULL AND -- Regions that do not have a parent region (i.e.: are parent regions themselves)
			GlobalRegionId IN ( SELECT -- Find all global regions that have a parent region (to make sure we don't include parent regions that aren't
									   --		references by sub regions)
									ParentGlobalRegionId 
								FROM
									Gdm.GlobalRegion
								WHERE
									ParentGlobalRegionId IS NOT NULL )
	) GR ON
		GRA.ImportKey = GR.ImportKey

RETURN
END

GO

