 USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageCorporateDepartmentActive]
GO

CREATE FUNCTION [Gdm].[ManageCorporateDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageCorporateDepartment] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				CorporateDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageCorporateDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				CorporateDepartmentCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.CorporateDepartmentCode = Gl1.CorporateDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.CorporateDepartmentCode,
		Gl1.SourceCode
)


GO


