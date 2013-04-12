IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingEntityPropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ReportingEntityPropertyEntityActive]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ReportingEntityPropertyEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ReportingEntityPropertyEntity] Gl1
		INNER JOIN (
			SELECT 
				PropertyEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingEntityPropertyEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY 
				PropertyEntityCode,
				SourceCode
		) t1 ON 
			t1.PropertyEntityCode = Gl1.PropertyEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.PropertyEntityCode,
		Gl1.SourceCode
)

GO