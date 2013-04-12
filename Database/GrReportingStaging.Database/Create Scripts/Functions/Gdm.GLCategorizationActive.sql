USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLCategorizationActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GLCategorizations
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLCategorizationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLCategorization] Gl1
		INNER JOIN (
			SELECT 
				GLCategorizationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLCategorization]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLCategorizationId
		) t1 ON t1.GLCategorizationId = Gl1.GLCategorizationId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLCategorizationId
)

GO
PRINT '[Gdm].[GLGLCategorizationActive] function has been created'