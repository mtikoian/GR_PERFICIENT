USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectGroupAllocationActive]    Script Date: 07/16/2012 03:17:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectGroupAllocationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[ProjectGroupAllocationActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectGroupAllocationActive]    Script Date: 07/16/2012 03:17:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [TapasGlobal].[ProjectGroupAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Pg1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[ProjectGroupAllocation] Pg1
		INNER JOIN (
			SELECT 
				ProjectGroupAllocationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[ProjectGroupAllocation]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ProjectGroupAllocationId
		) t1 ON t1.ProjectGroupAllocationId = Pg1.ProjectGroupAllocationId AND
				t1.UpdatedDate = Pg1.UpdatedDate
	WHERE Pg1.UpdatedDate <= @DataPriorToDate
	GROUP BY Pg1.ProjectGroupAllocationId	
)



GO


