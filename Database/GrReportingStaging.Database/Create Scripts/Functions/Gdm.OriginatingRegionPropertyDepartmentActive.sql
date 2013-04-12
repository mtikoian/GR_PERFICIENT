IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionPropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[OriginatingRegionPropertyDepartmentActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[OriginatingRegionPropertyDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[OriginatingRegionPropertyDepartment] Gl1
		INNER JOIN (
			SELECT 
				PropertyDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionPropertyDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				PropertyDepartmentCode,
				SourceCode
		) t1 ON 
			t1.PropertyDepartmentCode = Gl1.PropertyDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.PropertyDepartmentCode,
		Gl1.SourceCode	
)

GO