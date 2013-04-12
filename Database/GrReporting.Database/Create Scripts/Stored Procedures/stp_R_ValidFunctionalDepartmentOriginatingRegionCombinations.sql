USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]    Script Date: 02/21/2012 17:32:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]    Script Date: 02/21/2012 17:32:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentOriginatingRegionCombinations]
@SnapshotId INT
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Originating Region - Functional Department Mappings
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-01-27		: SNothling	:	CC21 - Create script
**********************************************************************************************************************/

/* ================================================================================================================
	STEP 0: CROSS JOIN TO GET ALL ORIGINATING REGION - FUNCTIONAL DEPARTMENT COMBINATIONS
=================================================================================================================*/

BEGIN
SELECT DISTINCT
	GR.Code,
	GR.Name
INTO
	#OriginatingRegions	
FROM 
	GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity ORCE
	INNER JOIN GrReportingStaging.GDM.GlobalRegion GR ON
		ORCE.GlobalRegionId = GR.GlobalRegionId
WHERE 
	SnapshotId = @SnapshotId

				
SELECT
	FD.GlobalCode,
	FD.Name
INTO 
	#FunctionalDepartments
FROM	
	GrReportingStaging.HR.FunctionalDepartment FD
WHERE 
	FD.IsActive = 1 AND
    FD.GlobalCode IS NOT NULL AND
    FD.Code <> 'TESTING'
    
SELECT
	FD.GlobalCode AS 'FunctionalDepartmentCode',
	ORS.Code AS 'OriginatingRegionCode'
INTO 
	#OriginatingRegionFunctionalDepartments
FROM 
	#OriginatingRegions ORS
	CROSS JOIN #FunctionalDepartments FD
	
END 
    
/* ================================================================================================================
	STEP 1: REMOVE ALL INVALID COMBINATIONS
=================================================================================================================*/
BEGIN

DELETE ORFD
FROM #OriginatingRegionFunctionalDepartments ORFD
	INNER JOIN #OriginatingRegions ON
		ORFD.OriginatingRegionCode = #OriginatingRegions.Code
	INNER JOIN #FunctionalDepartments ON
		ORFD.FunctionalDepartmentCode = #FunctionalDepartments.GlobalCode
	LEFT OUTER JOIN (
		-- get a list of functional for which all the corporate entities is restricted in a global region
		-- the global region - functional department combination is then restricted
		SELECT
			FunctionalDepartmentGlobalRegionCount.FunctionalDepartmentCode AS 'FunctionalDepartmentCode',
			GlobalRegion.Code AS 'GlobalRegionCode'
		FROM (
			-- Get a count of corporate entities restricted for each functional department per originating region
			SELECT
				FunctionalDepartment.GlobalCode AS 'FunctionalDepartmentCode',
				OriginatingRegionCorporateEntity.GlobalRegionId,
				COUNT(
					RestrictedCombinations.CorporateEntitySourceCode + 
					RestrictedCombinations.CorporateEntityCode
				) AS 'CorporateEntityRestrictionsCount'
			FROM 
				GrReportingStaging.Gdm.SnapshotRestrictedFunctionalDepartmentCorporateEntity RestrictedCombinations
			INNER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedCombinations.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			INNER JOIN GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity ON
				RestrictedCombinations.CorporateEntityCode = OriginatingRegionCorporateEntity.CorporateEntityCode AND
				RestrictedCombinations.CorporateEntitySourceCode = OriginatingRegionCorporateEntity.SourceCode
			WHERE 
				FunctionalDepartment.IsActive = 1 AND
				RestrictedCombinations.SnapshotId = @SnapshotId AND
				OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
			GROUP BY 
				FunctionalDepartment.GlobalCode,
				GlobalRegionId
		) FunctionalDepartmentGlobalRegionCount
		INNER JOIN (
			-- Get a count of corporate entities per originating region
			SELECT
				GlobalRegionId,
				COUNT(OriginatingRegionCorporateEntity.SourceCode + CorporateEntityCode) AS CorporateEntitiesPerRegion
			FROM 
				GrReportingStaging.GDM.SnapshotOriginatingRegionCorporateEntity OriginatingRegionCorporateEntity
			WHERE
				OriginatingRegionCorporateEntity.SnapshotId = @SnapshotId
			GROUP BY
				GlobalRegionId
		) GlobalRegionCorporateEntityCount ON
			FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegionCorporateEntityCount.GlobalRegionId
		INNER JOIN GrReportingStaging.Gdm.GlobalRegion GlobalRegion ON
			FunctionalDepartmentGlobalRegionCount.GlobalRegionId = GlobalRegion.GlobalRegionId
		WHERE
			FunctionalDepartmentGlobalRegionCount.CorporateEntityRestrictionsCount = GlobalRegionCorporateEntityCount.CorporateEntitiesPerRegion
	) InvalidCombinations ON
		ORFD.FunctionalDepartmentCode = InvalidCombinations.FunctionalDepartmentCode AND
		ORFD.OriginatingRegionCode = InvalidCombinations.GlobalRegionCode
	LEFT OUTER JOIN dbo.AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment ON
		#OriginatingRegions.Name = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName AND
		#FunctionalDepartments.Name = AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName
	WHERE
		InvalidCombinations.FunctionalDepartmentCode IS NOT NULL AND
		InvalidCombinations.GlobalRegionCode IS NOT NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.FunctionalDepartmentName IS NULL AND
		AdditionalValidCombinationsForOriginatingSubRegionFunctionalDepartment.OriginatingSubRegionName IS NULL

END 
/* ================================================================================================================
	STEP 3: RETURN FINAL RESULTS
=================================================================================================================*/

BEGIN

SELECT
	#OriginatingRegions.Name AS 'OriginatingRegion',
	#FunctionalDepartments.Name AS 'FunctionalDepartment'
FROM
	#OriginatingRegionFunctionalDepartments
INNER JOIN #OriginatingRegions ON
	#OriginatingRegionFunctionalDepartments.OriginatingRegionCode = #OriginatingRegions.Code
INNER JOIN #FunctionalDepartments ON
	#OriginatingRegionFunctionalDepartments.FunctionalDepartmentCode = #FunctionalDepartments.GlobalCode
	
END

IF OBJECT_ID('tempdb..#OriginatingRegions') IS NOT NULL
	DROP TABLE #OriginatingRegions

IF OBJECT_ID('tempdb..#FunctionalDepartments') IS NOT NULL
	DROP TABLE #FunctionalDepartments

IF OBJECT_ID('tempdb..#OriginatingRegionFunctionalDepartments') IS NOT NULL
	DROP TABLE #OriginatingRegionFunctionalDepartments





GO
