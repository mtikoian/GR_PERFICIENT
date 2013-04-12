USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MRIServerSourceActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[MRIServerSourceActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[MRIServerSourceActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[MRIServerSource] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[MRIServerSource]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				SourceCode
		) t1 ON 
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	Where 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.SourceCode	
)

GO