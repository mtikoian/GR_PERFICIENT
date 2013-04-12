 USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLCategorizationTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLCategorizationTypeActive]
GO


/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GLCategorizationTypes
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLCategorizationTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLCategorizationType] Gl1
		INNER JOIN (
			SELECT 
				GLCategorizationTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLCategorizationType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLCategorizationTypeId
		) t1 ON t1.GLCategorizationTypeId = Gl1.GLCategorizationTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLCategorizationTypeId
)

GO