
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalRegionActive]
GO
CREATE FUNCTION [Gdm].[GlobalRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalRegion] Gl1
		INNER JOIN (
			SELECT 
				GlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalRegionId
		) t1 ON t1.GlobalRegionId = Gl1.GlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalRegionId	
)

GO


