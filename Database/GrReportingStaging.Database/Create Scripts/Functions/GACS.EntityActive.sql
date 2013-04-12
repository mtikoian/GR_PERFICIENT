 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[EntityActive]
GO
CREATE FUNCTION [GACS].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[Entity] Gl1
		INNER JOIN (
		
			SELECT 
				EntityRef,
				Source,
				MAX(LastDate) AS LastDate
			FROM 
				[GACS].[Entity]
			WHERE	
				LastDate <= @DataPriorToDate
			GROUP BY 
				EntityRef,
				Source
			
		) t1 ON 
			t1.EntityRef = Gl1.EntityRef AND
			t1.Source = Gl1.Source AND
			t1.LastDate = Gl1.LastDate
	WHERE 
		Gl1.LastDate <= @DataPriorToDate
	GROUP BY 
		Gl1.EntityRef,
		Gl1.Source
)

GO 