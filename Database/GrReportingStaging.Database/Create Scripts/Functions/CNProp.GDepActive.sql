
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNProp].[GDepActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNProp].[GDepActive]
GO
CREATE FUNCTION [CNProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT ANd
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)

GO


