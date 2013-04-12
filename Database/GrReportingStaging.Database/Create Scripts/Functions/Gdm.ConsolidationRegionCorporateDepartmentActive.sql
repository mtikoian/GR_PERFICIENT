 USE GrReportingStaging
 GO
 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].ConsolidationRegionCorporateDepartmentActive') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ConsolidationRegionCorporateDepartmentActive]
 GO
 
 CREATE FUNCTION [Gdm].ConsolidationRegionCorporateDepartmentActive
	(@DatePriorToDate DATETIME)
	
RETURNS TABLE as RETURN
(
	SELECT
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].ConsolidationRegionCorporateDepartment Gl1
		INNER JOIN (
			SELECT
				CorporateDepartmentCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM
				[Gdm].ConsolidationRegionCorporateDepartment
			WHERE
				UpdatedDate <= @DatePriorToDate
			GROUP BY
				CorporateDepartmentCode,
				SourceCode
		) t1 ON 
			t1.CorporateDepartmentCode = Gl1.CorporateDepartmentCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DatePriorToDate
	GROUP BY
		Gl1.CorporateDepartmentCode,
		Gl1.SourceCode
)

GO