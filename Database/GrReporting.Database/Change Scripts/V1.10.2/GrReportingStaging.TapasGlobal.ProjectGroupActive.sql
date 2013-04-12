USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectGroupActive]    Script Date: 08/07/2012 23:01:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[ProjectGroupActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectGroupActive]    Script Date: 08/07/2012 23:01:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [TapasGlobal].[ProjectGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Pg1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[ProjectGroup] Pg1
		INNER JOIN (
			SELECT 
				ProjectGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[ProjectGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ProjectGroupId
		) t1 ON t1.ProjectGroupId = Pg1.ProjectGroupId AND
				t1.UpdatedDate = Pg1.UpdatedDate
	WHERE Pg1.UpdatedDate <= @DataPriorToDate
	GROUP BY Pg1.ProjectGroupId	
)



GO


