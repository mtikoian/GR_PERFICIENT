
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AccountCategoryMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[AccountCategoryMappingActive]
GO
/*
CREATE   FUNCTION [Gdm].[AccountCategoryMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[Gdm].[AccountCategoryMapping] Gl1
		INNER JOIN (
			SELECT 
				AccountCategoryMappingId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AccountCategoryMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY AccountCategoryMappingId
		) t1 ON t1.AccountCategoryMappingId = Gl1.AccountCategoryMappingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.AccountCategoryMappingId	
)

*/
