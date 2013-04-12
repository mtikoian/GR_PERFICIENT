
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[SystemSettingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[SystemSettingActive]
GO
CREATE FUNCTION [TapasGlobal].[SystemSettingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[SystemSetting] Gl1
		INNER JOIN (
		SELECT 
			SystemSettingId,
			MAX(UpdatedDate) UpdatedDate
		FROM 
			[TapasGlobal].[SystemSetting]
		WHERE	UpdatedDate <= @DataPriorToDate
		GROUP BY SystemSettingId
		) t1 ON t1.SystemSettingId = Gl1.SystemSettingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SystemSettingId
)

GO
