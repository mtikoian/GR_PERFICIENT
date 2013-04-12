USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GetProjectGroupExpanded]    Script Date: 07/31/2012 02:25:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetProjectGroupExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetProjectGroupExpanded]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GetProjectGroupExpanded]    Script Date: 07/31/2012 02:25:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************************************************************
Description
	The function is used for as source data for populating the ProjectGroup slowly changing	dimension in 
	the data warehouse (GrReporting).
**********************************************************************************************************************/

CREATE FUNCTION [Gr].[GetProjectGroupExpanded]
	(@DataPriorToDate DateTime)

RETURNS @Result TABLE
(
	[ProjectGroupId] [int] NULL,
	[BudgetProjectGroupId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[EndPeriod] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[AMProjectGroupId] [int] NULL,
	[BudgetId] [int]
)

AS

BEGIN 

INSERT INTO @Result
(
	[ProjectGroupId],
	[BudgetProjectGroupId],
	[SourceCode],
	[Name],
	[EndPeriod],
	[InsertedDate],
	[UpdatedDate],
	[UpdatedByStaffId],
	[AMProjectGroupId],
	[BudgetId]
)
SELECT 
	pg.ProjectGroupId,
	-1,
	pg.Sourcecode,
	pg.Name,
	pg.EndPeriod,
	pg.InsertedDate,
	pg.UpdatedDate,
	pg.UpdatedByStaffId,
	pg.AMProjectGroupId,
	-1
FROM 
	TapasGlobal.ProjectGroup pg
	INNER JOIN TapasGlobal.ProjectGroupActive(@DataPriorToDate) pga ON 
		pg.ImportKey = pga.ImportKey

INSERT INTO @Result
(
	[ProjectGroupId],
	[BudgetProjectGroupId],
	[SourceCode],
	[Name],
	[EndPeriod],
	[InsertedDate],
	[UpdatedDate],
	[UpdatedByStaffId],
	[AMProjectGroupId],
	[BudgetId]
)
SELECT 
	ISNULL(bpg.ProjectGroupId, -1),
	bpg.BudgetProjectGroupId,
	'',
	bpg.Name,
	bpg.EndPeriod,
	bpg.InsertedDate,
	bpg.UpdatedDate,
	bpg.UpdatedByStaffId,
	bpg.AMBudgetProjectGroupId,
	bpg.BudgetId
FROM 
	TapasGlobalBudgeting.BudgetProjectGroup bpg
	INNER JOIN TapasGlobalBudgeting.BudgetProjectGroupActive(@DataPriorToDate) bpga ON 
		bpg.ImportKey = bpga.ImportKey

RETURN

END



GO


