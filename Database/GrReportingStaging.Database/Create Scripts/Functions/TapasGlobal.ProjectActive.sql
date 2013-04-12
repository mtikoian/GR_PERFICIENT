
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[ProjectActive]
GO
CREATE FUNCTION [TapasGlobal].[ProjectActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[Project] Gl1
		INNER JOIN (
			SELECT 
				ProjectId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
					[TapasGlobal].[Project]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ProjectId
		) t1 ON t1.ProjectId = Gl1.ProjectId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ProjectId	
)

GO


