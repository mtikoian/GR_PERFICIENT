USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive] 
	records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[RestrictedFunctionalDepartmentGLGlobalAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountId,
				ISNULL(FunctionalDepartmentId, 0) AS FunctionalDepartmentId, -- Functional Department can have a null value.
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[RestrictedFunctionalDepartmentGLGlobalAccount]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				GLGlobalAccountId,
				FunctionalDepartmentId
		) t1 ON 
			t1.GLGlobalAccountId = Gl1.GLGlobalAccountId AND
			t1.FunctionalDepartmentId = ISNULL(Gl1.FunctionalDepartmentId, 0) AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLGlobalAccountId,
		Gl1.FunctionalDepartmentId
)


GO