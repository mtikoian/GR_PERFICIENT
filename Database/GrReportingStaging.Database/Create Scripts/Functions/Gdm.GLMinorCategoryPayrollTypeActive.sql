USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLMinorCategoryPayrollTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLMinorCategoryPayrollTypeActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active Gdm.GLMinorCategoryPayrollTypeActive records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/


CREATE FUNCTION [Gdm].[GLMinorCategoryPayrollTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLMinorCategoryPayrollType] Gl1
		INNER JOIN (
			SELECT 
				GLMinorCategoryPayrollTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLMinorCategoryPayrollType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLMinorCategoryPayrollTypeId
		) t1 ON t1.GLMinorCategoryPayrollTypeId = Gl1.GLMinorCategoryPayrollTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLMinorCategoryPayrollTypeId
)

GO