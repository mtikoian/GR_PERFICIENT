
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[LocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[LocationActive]
GO
CREATE FUNCTION [HR].[LocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[Location] Gl1
		INNER JOIN (
			SELECT 
				LocationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[Location]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY LocationId
		) t1 ON t1.LocationId = Gl1.LocationId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.LocationId	
)

GO

