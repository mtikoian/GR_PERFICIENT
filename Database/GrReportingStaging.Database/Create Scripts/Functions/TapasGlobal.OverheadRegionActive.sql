
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[OverheadRegionActive]
GO
CREATE FUNCTION [TapasGlobal].[OverheadRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[OverheadRegion] Gl1
		INNER JOIN (
			SELECT 
				OverheadRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[OverheadRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OverheadRegionId
		) t1 ON t1.OverheadRegionId = Gl1.OverheadRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OverheadRegionId	
)

GO


