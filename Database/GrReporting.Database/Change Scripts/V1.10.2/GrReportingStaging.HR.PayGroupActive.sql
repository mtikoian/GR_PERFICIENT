USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [HR].[PayGroupActive]    Script Date: 07/16/2012 02:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[PayGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [HR].[PayGroupActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [HR].[PayGroupActive]    Script Date: 07/16/2012 02:36:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [HR].[PayGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[PayGroup] Gl1
		INNER JOIN (
			SELECT 
				PayGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[PayGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PayGroupId
		) t1 ON t1.PayGroupId = Gl1.PayGroupId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PayGroupId	
)


GO


