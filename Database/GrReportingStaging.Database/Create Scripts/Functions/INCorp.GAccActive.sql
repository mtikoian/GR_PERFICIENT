
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INCorp].[GAccActive]
GO
CREATE FUNCTION [INCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)

GO


