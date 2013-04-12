USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[HrEmployeeActive]    Script Date: 07/09/2012 22:15:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[HrEmployeeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[HrEmployeeActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [TapasGlobal].[HrEmployeeActive]    Script Date: 07/09/2012 22:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [TapasGlobal].[HrEmployeeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[HrEmployee] Gl1
		INNER JOIN (
			SELECT 
				HrEmployeeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
					[TapasGlobal].[HrEmployee]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY HrEmployeeId
		) t1 ON t1.HrEmployeeId = Gl1.HrEmployeeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.HrEmployeeId	
)


GO


