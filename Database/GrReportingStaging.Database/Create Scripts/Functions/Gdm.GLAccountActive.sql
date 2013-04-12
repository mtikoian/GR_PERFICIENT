﻿USE GrReportingStaging
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GLAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GLAccountActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active GLAccount records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[GLAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GLAccount] Gl1
		INNER JOIN (
			SELECT 
				GLAccountId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GLAccount]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GLAccountId
		) t1 ON t1.GLAccountId = Gl1.GLAccountId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GLAccountId
)

GO