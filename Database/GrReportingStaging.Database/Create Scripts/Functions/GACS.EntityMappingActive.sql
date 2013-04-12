
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[EntityMappingActive]
GO
CREATE FUNCTION [GACS].[EntityMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[EntityMapping] Gl1
		INNER JOIN (
		
			SELECT 
				EntityMappingId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[GACS].[EntityMapping]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY EntityMappingId
			
		) t1 ON t1.EntityMappingId = Gl1.EntityMappingId AND
				t1.InsertedDate = Gl1.InsertedDate
	WHERE Gl1.InsertedDate <= @DataPriorToDate
	GROUP BY Gl1.EntityMappingId
)

GO 