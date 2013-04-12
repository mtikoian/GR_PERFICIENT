﻿IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[AllocationSubRegionActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[AllocationSubRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[AllocationSubRegion] Gl1
		INNER JOIN (
			SELECT 
				Code,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AllocationSubRegion]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				Code
		) t1 ON 
			t1.Code = Gl1.Code AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.Code
)

GO