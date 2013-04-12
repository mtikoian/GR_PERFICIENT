
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[JobCodeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [GACS].[JobCodeActive]
GO
CREATE FUNCTION [GACS].[JobCodeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[JobCode] Gl1
		INNER JOIN (
			SELECT 
				JobCode,
				Source,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[GACS].[JobCode]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY JobCode,
				Source
		) t1 ON t1.JobCode = Gl1.JobCode AND
				t1.Source = Gl1.Source AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.JobCode,
				Gl1.Source
)

GO

