 USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManagePropertyDepartmentActive]
GO


CREATE FUNCTION [Gdm].[ManagePropertyDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManagePropertyDepartment] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				PropertyDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManagePropertyDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				PropertyDepartmentCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.PropertyDepartmentCode = Gl1.PropertyDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.PropertyDepartmentCode,
		Gl1.SourceCode
)


GO


