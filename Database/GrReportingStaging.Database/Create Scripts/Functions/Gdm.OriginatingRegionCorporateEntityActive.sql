IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[OriginatingRegionCorporateEntityActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[OriginatingRegionCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[OriginatingRegionCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				CorporateEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionCorporateEntity]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				CorporateEntityCode,
				SourceCode
		) t1 ON 
			t1.CorporateEntityCode = Gl1.CorporateEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.CorporateEntityCode,
		Gl1.SourceCode	
)

GO