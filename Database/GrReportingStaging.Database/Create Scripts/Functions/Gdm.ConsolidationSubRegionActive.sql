 USE GrReportingStaging
 GO
 
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ConsolidationSubRegionActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ConsolidationSubRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ConsolidationSubRegion] Gl1
		INNER JOIN (
			SELECT 
				ConsolidationSubRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ConsolidationSubRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ConsolidationSubRegionGlobalRegionId
		) t1 ON t1.ConsolidationSubRegionGlobalRegionId = Gl1.ConsolidationSubRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ConsolidationSubRegionGlobalRegionId
)

GO