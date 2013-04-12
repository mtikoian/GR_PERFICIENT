USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDProjectGroup]    Script Date: 07/17/2012 21:38:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDProjectGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDProjectGroup]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDProjectGroup]    Script Date: 07/17/2012 21:38:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_IU_SCDProjectGroup]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #ProjectGroup
(
	[ProjectGroupId] [int] NOT NULL,
	[BudgetProjectGroupId] [int] NOT NULL,
	[ProjectGroupName] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[BudgetId] [int] NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #ProjectGroup
(
	ProjectGroupId,
	BudgetProjectGroupId,
	ProjectGroupName,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange
)
SELECT
	ProjectGroupId,
	BudgetProjectGroupId,
	Name,
	UpdatedDate,
	@MaximumEndDate AS EndDate,
	BudgetId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.ProjectGroup DIM
	USING
	(
		SELECT
			ProjectGroupId,
			BudgetProjectGroupId,
			Name,
			UpdatedDate,
			BudgetId
		FROM
			GrReportingStaging.Gr.GetProjectGroupExpanded(@DataPriorToDate)	

	) AS SRC ON
		ISNULL(DIM.ProjectGroupId, -1) = ISNULL(SRC.ProjectGroupId, -1) AND
		DIM.BudgetProjectGroupId = SRC.BudgetProjectGroupId AND
		DIM.BudgetId = SRC.BudgetId AND
		DIM.EndDate = @MaximumEndDate -- Only consider active dimension records (those records that have not been 'ended')

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source
			DIM.ProjectGroupName <> SRC.Name
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,
			DIM.ReasonForChange = 'Record updated in source'

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn't exist in [Source], 'end' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.ProjectGroupKey <> -1 AND 
		DIM.EndDate = @MaximumEndDate -- Make sure that the dimension record is active, else we might continuously update the same inactive record
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = 'Record deleted in source'

	/* ===========================================================================================================================================
		When a record exists in [Source] that doesn't exist in [Target], insert it
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY TARGET
	THEN
		INSERT
		(
			ProjectGroupId,
			BudgetProjectGroupId,
			ProjectGroupName,
			EndDate,
			BudgetId,
			StartDate,
			ReasonForChange
		)
		VALUES
		(
			SRC.ProjectGroupId,
			SRC.BudgetProjectGroupId,
			SRC.Name,
			@MaximumEndDate,
			SRC.BudgetId,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.ProjectGroup
									WHERE
										ISNULL(ProjectGroupId, -1) = ISNULL(SRC.ProjectGroupId, -1) AND
										BudgetProjectGroupId = SRC.BudgetProjectGroupId AND 
										BudgetId = SRC.BudgetId)), @MinimumStartDate),
			'New record in source'
		)

	--------

	OUTPUT -- Dimension
		SRC.ProjectGroupId,
		SRC.BudgetProjectGroupId,
		SRC.Name,
		SRC.UpdatedDate,
		SRC.BudgetId,
		'Record updated in source' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' -- Important: Only insert a new record into the dimension if the merge triggered an update.

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.ProjectGroup
(
	ProjectGroupId,
	BudgetProjectGroupId,
	ProjectGroupName,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange
)
SELECT
	Updated.ProjectGroupId,
	Updated.BudgetProjectGroupId,
	Updated.ProjectGroupName,
	Updated.StartDate,
	Updated.EndDate,
	Updated.BudgetId,
	Updated.ReasonForChange
FROM
	#ProjectGroup Updated



GO


