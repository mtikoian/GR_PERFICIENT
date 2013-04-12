
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[OverheadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[OverheadActive]
GO
CREATE FUNCTION [TapasGlobal].[OverheadActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[Overhead] Gl1
		INNER JOIN (
			SELECT 
				OverheadId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[Overhead]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OverheadId
		) t1 ON t1.OverheadId = Gl1.OverheadId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OverheadId	
)

GO
