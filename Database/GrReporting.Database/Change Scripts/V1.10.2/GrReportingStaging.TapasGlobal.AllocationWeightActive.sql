USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[AllocationWeightActive]    Script Date: 07/16/2012 03:17:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[AllocationWeightActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[AllocationWeightActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[AllocationWeightActive]    Script Date: 07/16/2012 03:17:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [TapasGlobal].[AllocationWeightActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Pg1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[AllocationWeight] Pg1
		INNER JOIN (
			SELECT 
				AllocationWeightId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[AllocationWeight]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY AllocationWeightId
		) t1 ON t1.AllocationWeightId = Pg1.AllocationWeightId AND
				t1.UpdatedDate = Pg1.UpdatedDate
	WHERE Pg1.UpdatedDate <= @DataPriorToDate
	GROUP BY Pg1.AllocationWeightId	
)



GO


