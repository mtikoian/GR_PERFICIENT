USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDEmployee]    Script Date: 07/03/2012 23:21:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDEmployee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDEmployee]
GO


USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDEmployee]    Script Date: 06/18/2012 23:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_IU_SCDEmployee]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

Declare @StartTime datetime



--------------#SubDepartment----------------
SET @StartTime = GETDATE()
CREATE TABLE #SubDepartment
(
	[SubDepartmentId] [int] NOT NULL,
	SubDepartmentName varchar(50) NOT NULL,
	SubDepartmentCode varchar(50) NOT NULL
)	
INSERT INTO #SubDepartment
SELECT S.SubDepartmentId,S.Name,S.Code
FROM GrReportingStaging.HR.SubDepartment S
join GrReportingStaging.HR.SubDepartmentActive('2012-08-31') a on S.ImportKey=a.ImportKey

	PRINT 'Completed inserting records into #SubDepartment: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#SubDepartment_SubDepartmentId ON #SubDepartment ([SubDepartmentId]) 


PRINT 'Completed creating indexes on #SubDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



--------------#Location----------------
SET @StartTime = GETDATE()
CREATE TABLE #Location
(
	[LocationId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL
)	
INSERT INTO #Location
SELECT l.LocationId,l.ExternalSubRegionId
FROM GrReportingStaging.HR.Location l 
join GrReportingStaging.HR.LocationActive(@DataPriorToDate) a on l.ImportKey=a.ImportKey

	PRINT 'Completed inserting records into #Location: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#Location_LocationId ON #Location (LocationId) 


PRINT 'Completed creating indexes on #Location'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--------------#PayGroup----------------
SET @StartTime = GETDATE()
CREATE TABLE #PayGroup
(
	[PayGroupId] [int] NOT NULL,
	--[PayFrequencyId] [int] NOT NULL,
	PayGroupName varchar(50) NOT NULL,
	PayGroupCode varchar(50) NOT NULL,
	[RegionId] [int] NOT NULL
)
INSERT INTO #PayGroup
SELECT 	p.PayGroupId,p.Name,p.Code, p.RegionId
FROM GrReportingStaging.HR.PayGroup p 
join GrReportingStaging.HR.PayGroupActive(@DataPriorToDate) a on p.ImportKey=a.ImportKey
	
	

	PRINT 'Completed inserting records into #PayGroup: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
CREATE CLUSTERED INDEX IX_#PayGroup_PayGroupId ON #PayGroup (PayGroupId) 


PRINT 'Completed creating indexes on #PayGroup'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


--------------#PayrollRegion----------------
SET @StartTime = GETDATE()
CREATE TABLE #PayrollRegion
(
	[RegionId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL,
	[CorporateEntityRef] [varchar](6) NOT NULL,
	[CorporateSourceCode] [varchar](2) NOT NULL
)
INSERT INTO #PayrollRegion
SELECT PR.RegionId,
PR.ExternalSubRegionId,
PR.CorporateEntityRef,
PR.CorporateSourceCode
FROM GrReportingStaging.TapasGlobal.PayrollRegion PR 
join GrReportingStaging.TapasGlobal.PayrollRegionActive(@DataPriorToDate) A 
on A.ImportKey = PR.ImportKey



	PRINT 'Completed inserting records into #PayrollRegion: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
CREATE CLUSTERED INDEX IX_#PayrollRegion_RegionId ON #PayrollRegion (ExternalSubRegionId,RegionId) 



PRINT 'Completed creating indexes on #PayrollRegion'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-----------------TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment---------


CREATE TABLE #BudgetEmployeeFunctionalDepartment(

	[ImportBatchId] [int] NOT NULL,
	[BudgetEmployeeFunctionalDepartmentId] [int] NOT NULL,
	[BudgetEmployeeId] [int] NOT NULL,
	[SubDepartmentId] [int] NOT NULL,
	[EffectiveStartDate] datetime NOT NULL,
	[EffectiveEndDate] datetime NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL
)

INSERT #BudgetEmployeeFunctionalDepartment
SELECT S.ImportBatchId,
S.BudgetEmployeeFunctionalDepartmentId,
S.[BudgetEmployeeId],
S.[SubDepartmentId],
LEFT(S.[EffectivePeriod], 4) + '-' + RIGHT(S.[EffectivePeriod], 2) + '-01',
ISNULL(LEFT(O.EffectiveEndPeriod, 4) + '-' + RIGHT(O.EffectiveEndPeriod, 2) + '-01','9999-12-31'),
S.[FunctionalDepartmentId]
FROM GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment S JOIN
(

	Select
	A.ImportBatchId,A.BudgetEmployeeFunctionalDepartmentId,
	MIN(B.EffectivePeriod) AS EffectiveEndPeriod
	From GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment A
	LEFT JOIn GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment B
	ON A.ImportBatchId=B.ImportBatchId and A.BudgetEmployeeId=B.BudgetEmployeeId
	and A.EffectivePeriod<B.EffectivePeriod
	GROUP by A.ImportBatchId,A.BudgetEmployeeFunctionalDepartmentId

) O on S.ImportBatchId = O.ImportBatchId 
and S.BudgetEmployeeFunctionalDepartmentId = O.BudgetEmployeeFunctionalDepartmentId



	PRINT 'Completed inserting records into ##BudgetEmployeeFunctionalDepartment: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
CREATE CLUSTERED INDEX IX_#BudgetEmployeeFunctionalDepartment_BudgetEmployeeId ON 
	#BudgetEmployeeFunctionalDepartment (BudgetEmployeeId,ImportBatchId) 



PRINT 'Completed creating indexes on ##BudgetEmployeeFunctionalDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-------------------Main code-------------------


	MERGE INTO
		dbo.Employee DIM
	USING
	(
	
	--declare @DataPriorToDate datetime = '2012-07-31', @MaximumEndDate datetime ='9999-12-31'
		SELECT
			S.HrEmployeeId,
			-1 AS BudgetEmployeeId,
			S.DisplayName AS EmployeeName,
			ISNULL(S.StaffId,-1) as StaffId,
			EH.EmployeeHistoryId,
			-1 AS BudgetEmployeeFunctionalDepartmentId,
			PG.PayGroupCode,
			PG.PayGroupName,
			SD.SubDepartmentCode,
			SD.SubDepartmentName,
			PR.CorporateEntityRef,
			PR.CorporateSourceCode,
			EH.FirstName,
			EH.LastName,
			EH.Initials,
			EH.EffectiveDate as StartDate,
			EH.EffectiveEndDate as EndDate,
			-1 AS BudgetId,
			0 AS SnapShotId,
			'' AS ReasonForChange
		FROM
			GrReportingStaging.TapasGlobal.HrEmployee S
			INNER JOIN GrReportingStaging.TapasGlobal.EmployeeHistory EH ON S.HrEmployeeId=EH.HrEmployeeId
			INNER JOIN #PayGroup PG ON EH.PayGroupId = PG.PayGroupId
			INNER JOIN #SubDepartment SD ON EH.SubDepartmentId = SD.SubDepartmentId
			INNER JOIN #Location L ON EH.LocationId = L.LocationId
			INNER JOIN #PayrollRegion PR ON PR.RegionId=PG.RegionId and PR.ExternalSubRegionId=L.ExternalSubRegionId
			
		UNION

		SELECT
			isnull(S.HrEmployeeId,-1) as HrEmployeeId,
			S.BudgetEmployeeId,
			S.Name AS EmployeeName,
			-1 as StaffId,
			-1 AS EmployeeHistoryId,
			FD.BudgetEmployeeFunctionalDepartmentId,
			PG.PayGroupCode,
			PG.PayGroupName,
			SD.SubDepartmentCode,
			SD.SubDepartmentName,
			PR.CorporateEntityRef,
			PR.CorporateSourceCode,
			'' as FirstName,
			'' as LastName,
			'' as Initials,
			FD.[EffectiveStartDate] as StartDate,
			ISNULL(FD.[EffectiveEndDate], @MaximumEndDate) as EndDate,
			S.BudgetId,
			B.SnapShotId,
			'' AS ReasonForChange
		FROM
			GrReportingStaging.TapasGlobalBudgeting.BudgetEmployee S
			INNER JOIN GrReportingStaging.TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) SA ON
				S.ImportKey = SA.ImportKey
			JOIN GrReportingStaging.TapasGlobalBudgeting.Budget TB On S.BudgetId = TB.BudgetId
			JOIN GrReportingStaging.GBS.Budget B ON TB.BudgetAllocationSetId=B.BudgetAllocationSetId
			INNER JOIN #Location L ON S.LocationId = L.LocationId
			INNER JOIN #PayGroup PG ON S.PayGroupId = PG.PayGroupId
			INNER JOIN GrReportingStaging.Gdm.SnapshotPayrollRegion PR 
				ON PR.RegionId=TB.RegionId and PR.ExternalSubRegionId=L.ExternalSubRegionId 
					and PR.SnapshotId=B.SnapshotId
			INNER JOIN #BudgetEmployeeFunctionalDepartment FD 
				ON S.BudgetEmployeeId = FD.BudgetEmployeeId and 
					S.ImportBatchId=FD.ImportBatchId  
			INNER JOIN #SubDepartment SD ON FD.SubDepartmentId = SD.SubDepartmentId
					
		

	) AS SRC ON
		SRC.HrEmployeeId = DIM.HrEmployeeId AND
		SRC.BudgetEmployeeId = DIM.BudgetEmployeeId AND
		SRC.EmployeeHistoryId = DIM.EmployeeHistoryId AND
		SRC.BudgetEmployeeFunctionalDepartmentId = DIM.BudgetEmployeeFunctionalDepartmentId AND
		SRC.BudgetId = DIM.BudgetId AND 
		SRC.SnapshotId = DIM.SnapshotId
		
	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source		
			DIM.EmployeeName <> SRC.EmployeeName OR
			DIM.StaffId <> SRC.StaffId OR
			DIM.EmployeeHistoryId <> SRC.EmployeeHistoryId OR
			DIM.PayGroupCode <> SRC.PayGroupCode OR
			DIM.PayGroupName <> SRC.PayGroupName OR
			DIM.SubDepartmentCode <> SRC.SubDepartmentCode OR
			DIM.SubDepartmentName <> SRC.SubDepartmentName OR
			DIM.CorporateEntityRef <> SRC.CorporateEntityRef OR
			DIM.CorporateSourceCode <> SRC.CorporateSourceCode OR
			DIM.FirstName <> SRC.FirstName OR
			DIM.LastName <> SRC.LastName OR
			DIM.Initials <> SRC.Initials OR
			DIM.StartDate <> SRC.StartDate OR
			DIM.EndDate <> SRC.EndDate
		)
	THEN
		UPDATE
		SET
			DIM.EmployeeName = SRC.EmployeeName,
			DIM.StaffId = SRC.StaffId,
			DIM.EmployeeHistoryId = SRC.EmployeeHistoryId ,
			DIM.PayGroupCode = SRC.PayGroupCode ,
			DIM.PayGroupName = SRC.PayGroupName ,
			DIM.SubDepartmentCode = SRC.SubDepartmentCode ,
			DIM.SubDepartmentName = SRC.SubDepartmentName ,
			DIM.CorporateEntityRef = SRC.CorporateEntityRef ,
			DIM.CorporateSourceCode = SRC.CorporateSourceCode ,
			DIM.FirstName = SRC.FirstName ,
			DIM.LastName = SRC.LastName ,
			DIM.Initials = SRC.Initials ,
			DIM.StartDate = SRC.StartDate ,
			DIM.EndDate = SRC.EndDate,
			DIM.ReasonForChange =   'Record updated in source'
										

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn't exist in [Source], 'end' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.EmployeeKey<>-1
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
	HrEmployeeId,
	StaffId,
	BudgetEmployeeId,
	EmployeeHistoryId,
	BudgetEmployeeFunctionalDepartmentId,
	PayGroupCode,
	PayGroupName,
	SubDepartmentCode,
	SubDepartmentName,
	CorporateEntityRef,
	CorporateSourceCode ,
	EmployeeName,
	FirstName,
	LastName,
	Initials,
	StartDate,
	EndDate,
	BudgetId,
	SnapshotId,
	ReasonForChange
		)
		VALUES
		(
	SRC.HrEmployeeId,
	SRC.StaffId,
	SRC.BudgetEmployeeId,
	SRC.EmployeeHistoryId,
	SRC.BudgetEmployeeFunctionalDepartmentId,
	SRC.PayGroupCode,
	SRC.PayGroupName,
	SRC.SubDepartmentCode,
	SRC.SubDepartmentName,
	SRC.CorporateEntityRef,
	SRC.CorporateSourceCode ,
	SRC.EmployeeName,
	SRC.FirstName,
	SRC.LastName,
	SRC.Initials,
	SRC.StartDate,
	SRC.EndDate,
	SRC.BudgetId,
	SRC.SnapshotId,
	SRC.ReasonForChange

		);
  
  
  
  
/* ================================================================================================================================================
	12. Clean Up
   ============================================================================================================================================= */
BEGIN

	IF OBJECT_ID('tempdb..#PayGroup') IS NOT NULL
		DROP TABLE #PayGroup

	IF OBJECT_ID('tempdb..#SubDepartment') IS NOT NULL
		DROP TABLE #SubDepartment

	IF OBJECT_ID('tempdb..#Location') IS NOT NULL
			DROP TABLE #Location
			
	IF OBJECT_ID('tempdb..#PayrollRegion') IS NOT NULL
			DROP TABLE #PayrollRegion	

	IF OBJECT_ID('tempdb..#BudgetEmployeeFunctionalDepartment') IS NOT NULL
			DROP TABLE #BudgetEmployeeFunctionalDepartment			
	
 END

GO
