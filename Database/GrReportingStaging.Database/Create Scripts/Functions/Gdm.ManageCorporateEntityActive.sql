 USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageCorporateEntityActive]
GO

CREATE FUNCTION [Gdm].[ManageCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				CorporateEntityCode,
				SourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageCorporateEntity]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ManageTypeId,
				CorporateEntityCode,
				SourceCode
		) t1 ON 
			t1.ManageTypeId = Gl1.ManageTypeId AND
			t1.CorporateEntityCode = Gl1.CorporateEntityCode AND
			t1.SourceCode = Gl1.SourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.ManageTypeId,
		Gl1.CorporateEntityCode,
		Gl1.SourceCode
)


GO


