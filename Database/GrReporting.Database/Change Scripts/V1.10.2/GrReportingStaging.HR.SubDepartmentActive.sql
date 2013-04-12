USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [HR].[SubDepartmentActive]    Script Date: 08/17/2012 03:25:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[SubDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[SubDepartmentActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [HR].[SubDepartmentActive]    Script Date: 08/17/2012 03:25:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [HR].[SubDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[SubDepartment] Gl1
		INNER JOIN (
			SELECT 
				SubDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[SubDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SubDepartmentId
		) t1 ON t1.SubDepartmentId = Gl1.SubDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SubDepartmentId	
)


GO


