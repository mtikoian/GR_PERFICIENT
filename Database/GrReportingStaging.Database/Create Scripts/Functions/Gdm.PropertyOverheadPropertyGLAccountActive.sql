USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyOverheadPropertyGLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyOverheadPropertyGLAccountActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[PropertyOverheadPropertyGLAccountActive] records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[PropertyOverheadPropertyGLAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyOverheadPropertyGLAccount] Gl1
		INNER JOIN (
			SELECT 
				ISNULL(GLCategorizationId, '') AS GLCategorizationId,
				ISNULL(ActivityTypeId, '') AS ActivityTypeId,
				ISNULL(FunctionalDepartmentId, '') AS FunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyOverheadPropertyGLAccount]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				ISNULL(GLCategorizationId, ''),
				ISNULL(ActivityTypeId, ''),
				ISNULL(FunctionalDepartmentId, '')
		) t1 ON 
			t1.GLCategorizationId = ISNULL(Gl1.GLCategorizationId, '') AND
			t1.ActivityTypeId = ISNULL(Gl1.ActivityTypeId, '') AND
			t1.FunctionalDepartmentId = ISNULL(Gl1.FunctionalDepartmentId, '') AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLCategorizationId,
		Gl1.ActivityTypeId,
		Gl1.FunctionalDepartmentId
)

GO