
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[FunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[FunctionalDepartmentActive]
GO
CREATE   FUNCTION [HR].[FunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[HR].[FunctionalDepartment] Gl1
		INNER JOIN (
			SELECT 
				FunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[FunctionalDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY FunctionalDepartmentId
		) t1 ON t1.FunctionalDepartmentId = Gl1.FunctionalDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.FunctionalDepartmentId	
)

GO

