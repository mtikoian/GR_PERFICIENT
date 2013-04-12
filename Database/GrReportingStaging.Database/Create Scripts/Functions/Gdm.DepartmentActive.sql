USE GrReportingStaging
GO 
 
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[DepartmentActive]
GO
CREATE   FUNCTION [Gdm].[DepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[Department] Gl1
		INNER JOIN (
			SELECT 
				DepartmentCode,
				[Source],
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[Department]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				DepartmentCode,
				[Source]
		) t1 ON 
			t1.DepartmentCode = Gl1.DepartmentCode AND
			t1.[Source] = Gl1.Source AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.DepartmentCode,
		Gl1.Source
)

GO


