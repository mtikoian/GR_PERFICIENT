USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[TimeAllocationActive]    Script Date: 07/16/2012 01:51:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[TimeAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[TimeAllocationActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[TimeAllocationActive]    Script Date: 07/16/2012 01:51:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [TapasGlobal].[TimeAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[TimeAllocation] Gl1
		INNER JOIN (
			SELECT 
				TimeAllocationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[TimeAllocation]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY TimeAllocationId
		) t1 ON t1.TimeAllocationId = Gl1.TimeAllocationId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.TimeAllocationId	
)


GO


