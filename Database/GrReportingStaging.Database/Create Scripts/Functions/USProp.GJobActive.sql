
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[GJobActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[GJobActive]
GO
CREATE FUNCTION [USProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
			    t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	

)

GO


