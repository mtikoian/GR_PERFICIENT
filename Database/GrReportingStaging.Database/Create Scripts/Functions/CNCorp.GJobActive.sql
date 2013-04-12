
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CNCorp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CNCorp].[GJobActive]
GO
CREATE FUNCTION [CNCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GJob] Gl1
		INNER JOIN (
			Select 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			From 
				[CNCorp].[GJob]
			Where	LASTDATE <= @DataPriorToDate
			Group By JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)

GO


