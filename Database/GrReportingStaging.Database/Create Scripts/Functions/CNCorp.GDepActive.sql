
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GDepActive]
GO
CREATE FUNCTION [CNCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

GO


