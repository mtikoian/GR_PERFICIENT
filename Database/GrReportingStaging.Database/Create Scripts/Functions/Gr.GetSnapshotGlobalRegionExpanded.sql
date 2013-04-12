USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetSnapshotGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gr].[GetSnapshotGlobalRegionExpanded]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gr].[GetSnapshotGlobalRegionExpanded]()

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
	IsActive BIT NOT NULL,
	SnapshotId INT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	SubRegion.GlobalRegionId,
	ParentRegion.Code AS RegionCode,
	ParentRegion.Name AS RegionName,
	ParentRegion.CountryId AS RegionCountryId,
	ParentRegion.DefaultCurrencyCode AS RegionDefaultCurrencyCode,
	ParentRegion.DefaultCorporateSourceCode AS RegionDefaultCorporateSourceCode,
	ParentRegion.ProjectCodePortion AS RegionProjectCodePortion,
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
	ParentRegion.IsActive & SubRegion.IsActive AS IsActive, -- If the Parent Region is not active, then its SubRegions should not be active either
	ParentRegion.SnapshotId
FROM
	Gdm.SnapshotGlobalRegion ParentRegion

	INNER JOIN Gdm.SnapshotGlobalRegion SubRegion ON
		SubRegion.ParentGlobalRegionId = ParentRegion.GlobalRegionId AND
		SubRegion.SnapshotId = ParentRegion.SnapshotId

UNION

SELECT
	ParentRegion.GlobalRegionId,
	ParentRegion.Code AS RegionCode,
	ParentRegion.[Name] AS RegionName,
	ParentRegion.CountryId AS RegionCountryId,
	ParentRegion.DefaultCurrencyCode AS RegionDefaultCurrencyCode,
	ParentRegion.DefaultCorporateSourceCode AS RegionDefaultCorporateSourceCode,
	ParentRegion.ProjectCodePortion AS RegionProjectCodePortion,
	ParentRegion.InsertedDate,
	ParentRegion.UpdatedDate,
	ParentRegion.IsAllocationRegion,
	ParentRegion.IsOriginatingRegion,
	NULL AS SubRegionCode,
	NULL AS SubRegionName,
	NULL AS SubRegionDefaultCurrencyCode,
	NULL AS SubRegionProjectCodePortion,
	ParentRegion.IsActive,
	ParentRegion.SnapshotId
FROM
	Gdm.SnapshotGlobalRegion ParentRegion
WHERE
	ParentRegion.ParentGlobalRegionId IS NULL AND -- Regions that do not have a parent region (i.e.: are parent regions themselves)
	ParentRegion.GlobalRegionId IN (SELECT -- Find all global regions that have a parent region (to make sure we don't include parent regions that aren't
										   --		references by sub regions)
										ParentGlobalRegionId
									FROM
										Gdm.SnapshotGlobalRegion
									WHERE
										ParentGlobalRegionId IS NOT NULL AND
										SnapshotId = ParentRegion.SnapshotId )

RETURN

END

GO

