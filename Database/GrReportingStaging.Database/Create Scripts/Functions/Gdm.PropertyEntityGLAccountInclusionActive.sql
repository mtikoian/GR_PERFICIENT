IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyEntityGLAccountInclusionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[PropertyEntityGLAccountInclusionActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[PropertyEntityGLAccountInclusionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyEntityGLAccountInclusion] Gl1
		INNER JOIN (
			SELECT 
				PropertyEntityGLAccountInclusionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyEntityGLAccountInclusion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PropertyEntityGLAccountInclusionId
		) t1 ON t1.PropertyEntityGLAccountInclusionId = Gl1.PropertyEntityGLAccountInclusionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PropertyEntityGLAccountInclusionId	
)

GO 