/*

Functions that need to be created:

GrReportingStaging.Gdm.BusinessLineActive()
GrReportingStaging.Gdm.ActivityTypeBusinessLineActive()
GrReportingStaging.Gr.GetActivityTypeBusinessLineExpanded() -- must be created after the above two functions as it makes use of them

*/

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gdm].[BusinessLineActive]    Script Date: 04/04/2011 16:45:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[BusinessLineActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[BusinessLineActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gdm].[BusinessLineActive]    Script Date: 04/04/2011 16:45:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [Gdm].[BusinessLineActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[BusinessLine] Gl1
		INNER JOIN (
			SELECT 
				BusinessLineId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[BusinessLine]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BusinessLineId
		) t1 ON t1.BusinessLineId = Gl1.BusinessLineId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BusinessLineId	
)

GO

---------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeBusinessLineActive]    Script Date: 04/04/2011 16:46:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ActivityTypeBusinessLineActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ActivityTypeBusinessLineActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeBusinessLineActive]    Script Date: 04/04/2011 16:46:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [Gdm].[ActivityTypeBusinessLineActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ActivityTypeBusinessLine] Gl1
		INNER JOIN (
			SELECT 
				ActivityTypeBusinessLineId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ActivityTypeBusinessLine]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ActivityTypeBusinessLineId
		) t1 ON t1.ActivityTypeBusinessLineId = Gl1.ActivityTypeBusinessLineId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ActivityTypeBusinessLineId	
)

GO

---------------------------------------------------------------------------------------------------------------

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GetActivityTypeBusinessLineExpanded]    Script Date: 04/04/2011 16:46:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GetActivityTypeBusinessLineExpanded]    Script Date: 04/04/2011 16:46:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded] 
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE (
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	ActivityType.ActivityTypeId,
	ActivityType.ActivityTypeName,
	ActivityType.ActivityTypeCode,
	BusinessLine.BusinessLineId,
	BusinessLine.BusinessLineName,
	MIN(ActivityTypeBusinessLine.InsertedDate),
	MAX(ActivityTypeBusinessLine.UpdatedDate)
FROM
	(
		SELECT
			ATBL.ActivityTypeId,
			ATBL.BusinessLineId,
			ATBL.InsertedDate,
			ATBL.UpdatedDate
		FROM
			Gdm.ActivityTypeBusinessLine ATBL
			INNER JOIN Gdm.ActivityTypeBusinessLineActive(@DataPriorToDate) ATBLA ON
				ATBL.ImportKey = ATBLA.ImportKey
	
	) ActivityTypeBusinessLine
		
	INNER JOIN (
	
		SELECT
			AT.ActivityTypeId,
			AT.Name AS ActivityTypeName,
			AT.Code AS ActivityTypeCode
		FROM
			Gdm.ActivityType AT
			INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) ATA ON
				AT.ImportKey = ATA.ImportKey
	
	) ActivityType ON
		ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId

	INNER JOIN (
	
		SELECT
			BL.BusinessLineId,
			BL.Name AS BusinessLineName
		FROM
			Gdm.BusinessLine BL
			INNER JOIN Gdm.BusinessLineActive(@DataPriorToDate) BLA ON
				BL.ImportKey = BLA.ImportKey
	
	) BusinessLine ON
		ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId

GROUP BY
	ActivityType.ActivityTypeId,
	ActivityType.ActivityTypeName,
	ActivityType.ActivityTypeCode,
	BusinessLine.BusinessLineId,
	BusinessLine.BusinessLineName

RETURN
END

GO
