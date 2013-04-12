
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[ProjectTypeActive]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[EntityTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[EntityTypeActive]
GO
CREATE FUNCTION [Gdm].[EntityTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[EntityType] Gl1
		INNER JOIN (
			SELECT 
				EntityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[EntityType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY EntityTypeId
		) t1 ON t1.EntityTypeId = Gl1.EntityTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.EntityTypeId	
)

GO


