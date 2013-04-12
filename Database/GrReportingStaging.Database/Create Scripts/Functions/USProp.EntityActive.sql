
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[USProp].[EntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [USProp].[EntityActive]
GO
CREATE FUNCTION [USProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
					ENTITYID,
					MAX(LASTDATE) LASTDATE
			FROM 
					[USProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)

GO


