IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[GLMinorCategoryActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[GLMinorCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLMinorCategory] Gl1
		INNER JOIN (
			SELECT 
				GLMinorCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLMinorCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLMinorCategoryId
		) t1 ON t1.GLMinorCategoryId = Gl1.GLMinorCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLMinorCategoryId	
)

GO