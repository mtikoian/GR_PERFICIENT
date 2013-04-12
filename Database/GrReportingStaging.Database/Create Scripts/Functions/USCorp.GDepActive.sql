
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USCorp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USCorp].[GDepActive]
GO
CREATE FUNCTION [USCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
					DEPARTMENT,
					MAX(LASTDATE) LASTDATE
			FROM 
					[USCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
		GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

GO


