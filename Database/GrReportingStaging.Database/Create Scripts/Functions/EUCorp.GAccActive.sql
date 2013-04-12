
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EUCorp].[GAccActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [EUCorp].[GAccActive]
GO
CREATE FUNCTION [EUCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	

)

GO


