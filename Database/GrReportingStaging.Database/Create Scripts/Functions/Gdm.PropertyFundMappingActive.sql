
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyFundMappingActive]
GO
CREATE FUNCTION [Gdm].[PropertyFundMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyFundMapping] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				PropertyFundCode,
				ActivityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyFundMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SourceCode,
				PropertyFundCode,
				ActivityTypeId
		) t1 ON t1.SourceCode = Gl1.SourceCode AND
				t1.PropertyFundCode = Gl1.PropertyFundCode AND
				(
				(t1.ActivityTypeId IS NOT NULL AND t1.ActivityTypeId = Gl1.ActivityTypeId)
				OR
				(t1.ActivityTypeId IS NULL AND Gl1.ActivityTypeId IS NULL)
				) AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PropertyFundMappingId	
)

GO
