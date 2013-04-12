
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[RegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[RegionActive]
GO
CREATE FUNCTION [HR].[RegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[Region] Gl1
		INNER JOIN (
			SELECT 
				RegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[Region]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY RegionId
		) t1 ON t1.RegionId = Gl1.RegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.RegionId	
)

GO

