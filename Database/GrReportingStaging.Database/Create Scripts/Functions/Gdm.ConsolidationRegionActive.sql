IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ConsolidationRegionActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ConsolidationRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ConsolidationRegion] Gl1
		INNER JOIN (
			SELECT 
				ConsolidationRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ConsolidationRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ConsolidationRegionGlobalRegionId
		) t1 ON t1.ConsolidationRegionGlobalRegionId = Gl1.ConsolidationRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ConsolidationRegionGlobalRegionId
)

GO