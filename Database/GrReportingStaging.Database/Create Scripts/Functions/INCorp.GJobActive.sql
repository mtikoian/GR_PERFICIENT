
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GJobActive]
GO
CREATE FUNCTION [INCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

GO


