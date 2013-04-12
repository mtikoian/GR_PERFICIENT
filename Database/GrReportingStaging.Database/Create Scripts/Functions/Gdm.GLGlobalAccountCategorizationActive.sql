USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLGlobalAccountCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLGlobalAccountCategorizationActive]
GO


/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active Gdm.GLGlobalAccountCategorization records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/


CREATE FUNCTION [Gdm].[GLGlobalAccountCategorizationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLGlobalAccountCategorization] Gl1
		INNER JOIN (
			SELECT 
				GLGlobalAccountId,
				GLCategorizationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLGlobalAccountCategorization]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				GLGlobalAccountId,
				GLCategorizationId
		) t1 ON 
			t1.GLGlobalAccountId = Gl1.GLGlobalAccountId AND
			t1.GLCategorizationId = Gl1.GLCategorizationId AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.GLGlobalAccountId,
		Gl1.GLCategorizationId
)

GO