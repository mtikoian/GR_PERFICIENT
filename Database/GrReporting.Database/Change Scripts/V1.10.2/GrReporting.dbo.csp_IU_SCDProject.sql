USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 07/03/2012 23:21:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDProject]
GO


USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDProject]    Script Date: 06/18/2012 23:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_IU_SCDProject]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #Project
(
	ProjectId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	ProjectName VARCHAR(100) NOT NULL,
	ProjectCode VARCHAR(50) NOT NULL,
	RegionName varchar(50) NOT NULL,
	RegionId int NOT NULL,
	CorporateDepartmentCode VARCHAR(10) NOT NULL,
	CorporateDepartmentName VARCHAR(50) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #Project
(
	ProjectId,
	BudgetProjectId,
	ProjectName,
	ProjectCode,
	RegionName,
	RegionId,
	CorporateDepartmentCode,
	CorporateDepartmentName,
	CorporateSourceCode,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange
)
SELECT
	ProjectId,
	BudgetProjectId,
	ProjectName,
	ProjectCode,
	RegionName,
	RegionId,
	CorporateDepartmentCode,
	CorporateDepartmentName,
	CorporateSourceCode,
	UpdatedDate,
	@MaximumEndDate,
	BudgetId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.Project DIM
	USING
	(
	---- actual project
		SELECT
			S.ProjectId,
			-1 AS BudgetProjectId,
			S.Name AS ProjectName,
			S.Code AS ProjectCode,
			R.Name AS RegionName,
			R.RegionId,
			S.CorporateDepartmentCode,
			D.Description AS CorporateDepartmentName,
			S.CorporateSourceCode,
			LEFT(S.StartPeriod, 4) + '-' + RIGHT(S.StartPeriod, 2) + '-01' AS StartDate,
			S.UpdatedDate,
			-1 AS BudgetId,
			'' AS ReasonForChange
		FROM
			GrReportingStaging.TapasGlobal.Project S
			INNER JOIN GrReportingStaging.TapasGlobal.ProjectActive(@DataPriorToDate) SA ON
				S.ImportKey = SA.ImportKey

			INNER JOIN GrReportingStaging.GDM.Department D ON 
				(D.DepartmentCode=S.CorporateDepartmentCode and D.Source=S.CorporateSourceCode)
			INNER JOIN GrReportingStaging.GDM.DepartmentActive(@DataPriorToDate) DA ON
				D.ImportKey = DA.ImportKey
			INNER JOIN GrReportingStaging.HR.Region R ON S.RegionId = R.RegionId
			INNER JOIN GrReportingStaging.Hr.RegionActive(@DataPriorToDate) RA ON
				RA.ImportKey = R.ImportKey
			
		UNION
		
		----budget Project
		SELECT
			IsNull(S.ProjectId,-1) AS ProjectId,
			S.BudgetProjectId,
			IsNull(S.Name,'') AS ProjectName,
			IsNull(S.Code,'') AS ProjectCode,
			R.Name AS RegionName,
			R.RegionId,
			IsNull(S.CorporateDepartmentCode,'') AS CorporateDepartmentCode,
			IsNull(D.Description,'') AS CorporateDepartmentName,
			IsNull(S.CorporateSourceCode,'') AS CorporateSourceCode,
			LEFT(S.StartPeriod, 4) + '-' + RIGHT(S.StartPeriod, 2) + '-01' StartDate,
			S.UpdatedDate,
			S.BudgetId,
			'' AS ReasonForChange
		FROM
			GrReportingStaging.TapasGlobalBudgeting.BudgetProject S
			INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) SA ON
				S.ImportKey = SA.ImportKey

			LEFT JOIN GrReportingStaging.GDM.Department D ON 
				(D.DepartmentCode=S.CorporateDepartmentCode and D.Source=S.CorporateSourceCode)
			LEFT JOIN GrReportingStaging.GDM.DepartmentActive(@DataPriorToDate) DA ON
				D.ImportKey = DA.ImportKey
			INNER JOIN GrReportingStaging.HR.Region R ON S.RegionId = R.RegionId
			INNER JOIN GrReportingStaging.Hr.RegionActive(@DataPriorToDate) RA ON
				RA.ImportKey = R.ImportKey

		

	) AS SRC ON
		SRC.ProjectId = DIM.ProjectId AND
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been 'ended')
		SRC.BudgetProjectId = DIM.BudgetProjectId
		
	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source		
			DIM.ProjectName <> SRC.ProjectName OR
			DIM.ProjectCode <> SRC.ProjectCode OR
			DIM.CorporateDepartmentCode <> SRC.CorporateDepartmentCode OR
			DIM.CorporateDepartmentName <> SRC.CorporateDepartmentName OR
			DIM.CorporateSourceCode <> SRC.CorporateSourceCode OR
			DIM.RegionName <> SRC.RegionName OR
			DIM.RegionId <> SRC.RegionId
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,
			DIM.ReasonForChange =   'Record updated in source'
										

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn't exist in [Source], 'end' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		--DIM.BudgetProjectId = -1 AND  -- Deal with actual project only
		DIM.ProjectKey <> -1 AND -- Do not update the 'UNKNOWN' record; this will not be matched in SOURCE
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
			ProjectId,
			BudgetProjectId,
			ProjectName,
			ProjectCode,
			RegionName,
			RegionId,
			CorporateDepartmentCode,
			CorporateDepartmentName,
			CorporateSourceCode,
			StartDate,
			EndDate,
			BudgetId,
			ReasonForChange
		)
		VALUES
		(
			SRC.ProjectId,
			SRC.BudgetProjectId,
			SRC.ProjectName,
			SRC.ProjectCode,
			SRC.RegionName,
			SRC.RegionId,
			SRC.CorporateDepartmentCode,
			SRC.CorporateDepartmentName,
			SRC.CorporateSourceCode,
			@MinimumStartDate,
			@MaximumEndDate,
			SRC.BudgetId,
			SRC.ReasonForChange
		)
	-----------

	OUTPUT
		SRC.ProjectId,
		SRC.BudgetProjectId,
		SRC.ProjectName,
		SRC.ProjectCode,
		SRC.RegionName,
		SRC.RegionId,
		SRC.CorporateDepartmentCode,
		SRC.CorporateDepartmentName,
		SRC.CorporateSourceCode,
		SRC.BudgetId,
		'Record updated in source' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE'

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.Project
(
	ProjectId,
	BudgetProjectId,
	ProjectName,
	ProjectCode,
	RegionName,
	RegionId,
	CorporateDepartmentCode,
	CorporateDepartmentName,
	CorporateSourceCode,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange
)
SELECT
	ProjectId,
	BudgetProjectId,
	ProjectName,
	ProjectCode,
	RegionName,
	RegionId,
	CorporateDepartmentCode,
	CorporateDepartmentName,
	CorporateSourceCode,
	StartDate,
	EndDate,
	BudgetId,
	ReasonForChange

FROM
	#Project
GO
