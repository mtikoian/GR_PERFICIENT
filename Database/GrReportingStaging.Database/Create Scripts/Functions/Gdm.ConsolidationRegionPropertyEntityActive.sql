USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].ConsolidationRegionPropertyEntityActive') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ConsolidationRegionPropertyEntityActive]
GO
 
CREATE FUNCTION [Gdm].ConsolidationRegionPropertyEntityActive
	(@DatePriorToDate DATETIME)
	
RETURNS TABLE as RETURN
(
	SELECT
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].ConsolidationRegionPropertyEntity Gl1
		INNER JOIN (
			SELECT
				PropertyEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM
				[Gdm].ConsolidationRegionPropertyEntity
			WHERE
				UpdatedDate <= @DatePriorToDate
			GROUP BY
				PropertyEntityCode,
				SourceCode
		) t1 ON 
			t1.PropertyEntityCode = Gl1.PropertyEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DatePriorToDate
	GROUP BY
		Gl1.PropertyEntityCode,
		Gl1.SourceCode
)

GO