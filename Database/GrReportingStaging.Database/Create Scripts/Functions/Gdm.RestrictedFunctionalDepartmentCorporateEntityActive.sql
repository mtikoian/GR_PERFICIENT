USE GrReportingStaging
GO

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]
	records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/


CREATE FUNCTION [Gdm].[RestrictedFunctionalDepartmentCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[RestrictedFunctionalDepartmentCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				CorporateEntityCode,
				FunctionalDepartmentId,
				CorporateEntitySourceCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[RestrictedFunctionalDepartmentCorporateEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY 
				CorporateEntityCode,
				FunctionalDepartmentId,
				CorporateEntitySourceCode
		) t1 ON 
			t1.CorporateEntityCode = Gl1.CorporateEntityCode AND
			t1.FunctionalDepartmentId = Gl1.FunctionalDepartmentId AND
			t1.CorporateEntitySourceCode = Gl1.CorporateEntitySourceCode AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.CorporateEntityCode,
		Gl1.FunctionalDepartmentId,
		Gl1.CorporateEntitySourceCode
)