
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[SystemSettingRegionActive]
GO
CREATE FUNCTION [TapasGlobal].[SystemSettingRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[SystemSettingRegion] Gl1
		INNER JOIN (
			SELECT 
				SystemSettingRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[SystemSettingRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SystemSettingRegionId
		) t1 ON t1.SystemSettingRegionId = Gl1.SystemSettingRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SystemSettingRegionId	
)

GO


