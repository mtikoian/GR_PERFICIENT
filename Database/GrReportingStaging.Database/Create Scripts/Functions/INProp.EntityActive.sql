
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[INProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [INProp].[EntityActive]
GO
CREATE FUNCTION [INProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

GO


