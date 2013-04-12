IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMajorCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[GLMajorCategoryActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[GLMajorCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLMajorCategory] Gl1
		INNER JOIN (
			SELECT 
				GLMajorCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLMajorCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLMajorCategoryId
		) t1 ON t1.GLMajorCategoryId = Gl1.GLMajorCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLMajorCategoryId	
)

GO