 USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gdm].[ManagePropertyEntityActive]    Script Date: 01/05/2012 08:18:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManagePropertyEntityActive]
GO

CREATE FUNCTION [Gdm].[ManagePropertyEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManagePropertyEntity] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				PropertyEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManagePropertyEntity]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				PropertyEntityCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.PropertyEntityCode = Gl1.PropertyEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.PropertyEntityCode,
		Gl1.SourceCode
)


GO


