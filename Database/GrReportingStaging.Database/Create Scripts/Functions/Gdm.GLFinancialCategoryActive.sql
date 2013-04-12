
USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLFinancialCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLFinancialCategoryActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GL Financial Categories
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLFinancialCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLFinancialCategory] Gl1
		INNER JOIN (
			SELECT 
				GLFinancialCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLFinancialCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLFinancialCategoryId
		) t1 ON t1.GLFinancialCategoryId = Gl1.GLFinancialCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLFinancialCategoryId
)

GO