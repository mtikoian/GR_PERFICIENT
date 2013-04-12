USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ReportingEntityCorporateDepartmentActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ReportingEntityCorporateDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ReportingEntityCorporateDepartment] Gl1
		INNER JOIN (
			SELECT 
				CorporateDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingEntityCorporateDepartment]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				CorporateDepartmentCode,
				SourceCode
		) t1 ON 
			t1.CorporateDepartmentCode = Gl1.CorporateDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.CorporateDepartmentCode,
		Gl1.SourceCode
)

GO