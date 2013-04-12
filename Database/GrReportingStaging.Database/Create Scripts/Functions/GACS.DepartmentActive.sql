
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[DepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[DepartmentActive]
GO
CREATE FUNCTION [GACS].[DepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[Department] Gl1
		INNER JOIN (
			SELECT 
				Department,
				Source,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[GACS].[Department]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY Department,
				Source
		) t1 ON t1.Department = Gl1.Department AND
				t1.Source = Gl1.Source AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.Department,
				Gl1.Source
)

GO

