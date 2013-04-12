USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[TimeAllocationDetailActive]    Script Date: 07/16/2012 01:51:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[TimeAllocationDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[TimeAllocationDetailActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[TimeAllocationDetailActive]    Script Date: 07/16/2012 01:51:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [TapasGlobal].[TimeAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[TimeAllocationDetail] Gl1
		INNER JOIN (
			SELECT 
				TimeAllocationDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[TimeAllocationDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY TimeAllocationDetailId
		) t1 ON t1.TimeAllocationDetailId = Gl1.TimeAllocationDetailId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.TimeAllocationDetailId	
)


GO


