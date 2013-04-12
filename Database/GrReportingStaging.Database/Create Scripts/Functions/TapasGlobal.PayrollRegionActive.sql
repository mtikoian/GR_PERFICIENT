 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[PayrollRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[PayrollRegionActive]
GO
CREATE FUNCTION [TapasGlobal].[PayrollRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[PayrollRegion] Gl1
		INNER JOIN (
			SELECT 
				PayrollRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[PayrollRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PayrollRegionId
		) t1 ON t1.PayrollRegionId = Gl1.PayrollRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PayrollRegionId	
)

GO

