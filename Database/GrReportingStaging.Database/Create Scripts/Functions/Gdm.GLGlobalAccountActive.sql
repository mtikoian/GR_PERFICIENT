IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[GLGlobalAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccount] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccount]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLGlobalAccountId
		) t1 ON t1.GLGlobalAccountId = Gl1.GLGlobalAccountId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLGlobalAccountId
)

GO