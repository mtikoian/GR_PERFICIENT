 USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGLCategorizationHierarchy]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDGLCategorizationHierarchy]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDGLCategorizationHierarchy]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #GLCategorizationHierarchy
(
	GLCategorizationHierarchyCode VARCHAR(50) NOT NULL,
	GLCategorizationTypeName VARCHAR(50) NOT NULL,
	GLCategorizationName VARCHAR(50) NOT NULL,
	GLFinancialCategoryName VARCHAR(50) NOT NULL,
	GLMajorCategoryName VARCHAR(400) NOT NULL,
	GLMinorCategoryName VARCHAR(400) NOT NULL,
	GLAccountName VARCHAR(150) NOT NULL,
	GLAccountCode VARCHAR(10) NOT NULL,
	InflowOutflow VARCHAR(7) NOT NULL,
	SnapshotId INT NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #GLCategorizationHierarchy
(
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLGlobalAccountName,
	GLGlobalAccountCode,
	InflowOutflow,
	0 AS SnapshotId,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.GLCategorizationHierarchy DIM
	USING
	(
		SELECT
			GLCategorizationHierarchyCode,
			GLCategorizationTypeName,
			GLCategorizationName,
			GLFinancialCategoryName,
			GLMajorCategoryName,
			GLMinorCategoryName,
			GLGlobalAccountName,
			GLGlobalAccountCode,
			InflowOutflow,
			0 AS SnapshotId,
			IsActive,
			InsertedDate,
			UpdatedDate
		FROM
			GrReportingStaging.Gr.GetGLCategorizationHierarchyExpanded(@DataPriorToDate)

	) AS SRC ON
		SRC.GLCategorizationHierarchyCode = DIM.GLCategorizationHierarchyCode AND
		DIM.EndDate = @MaximumEndDate AND -- Only consider active dimension records (those records that have not been 'ended')
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source
			DIM.GLCategorizationTypeName <> SRC.GLCategorizationTypeName OR
			DIM.GLCategorizationName <> SRC.GLCategorizationName OR
			DIM.GLFinancialCategoryName <> SRC.GLFinancialCategoryName OR
			DIM.GLMajorCategoryName <> SRC.GLMajorCategoryName OR
			DIM.GLMinorCategoryName <> SRC.GLMinorCategoryName OR
			DIM.GLAccountName <> SRC.GLGlobalAccountName OR
			DIM.GLAccountCode <> SRC.GLGlobalAccountCode OR
			DIM.InflowOutflow <> SRC.InflowOutflow OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,
			DIM.ReasonForChange =   CASE
										WHEN
											SRC.IsActive = 0
										THEN
											'Record deactivated in source'
										ELSE
											'Record updated in source'
									END

	/* ===========================================================================================================================================
		When a record exists in [Target] that doesn't exist in [Source], 'end' it by updating its EndDate
	   ======================================================================================================================================== */

	WHEN
		NOT MATCHED BY SOURCE AND
		DIM.SnapshotId = 0 AND
		DIM.GLCategorizationHierarchyKey > 0 AND  -- Do not update the 'UNKNOWN' record; this will not be matched in SOURCE
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
		NOT MATCHED BY TARGET AND
		SRC.IsActive = 1
	THEN
		INSERT
		(
			GLCategorizationHierarchyCode,
			GLCategorizationTypeName,
			GLCategorizationName,
			GLFinancialCategoryName,
			GLMajorCategoryName,
			GLMinorCategoryName,
			GLAccountName,
			GLAccountCode,
			InflowOutflow,
			SnapshotId,
			EndDate,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.GLCategorizationHierarchyCode,
			SRC.GLCategorizationTypeName,
			SRC.GLCategorizationName,
			SRC.GLFinancialCategoryName,
			SRC.GLMajorCategoryName,
			SRC.GLMinorCategoryName,
			SRC.GLGlobalAccountName,
			SRC.GLGlobalAccountCode,
			SRC.InflowOutflow,
			0,
			@MaximumEndDate,
			CASE
				WHEN -- If this record (identified by its primary key) doesn't exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.GLCategorizationHierarchy
							WHERE
								SnapshotId = 0 AND
								GLCategorizationHierarchyCode = SRC.GLCategorizationHierarchyCode
						)
				THEN -- Then it must be a new record
					'New record in source'
				ELSE -- Else the source record must have been reactivated and/or updated
					'Record reactivated in source'
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.GLCategorizationHierarchy
									WHERE
										SnapshotId = 0 AND
										GLCategorizationHierarchyCode = SRC.GLCategorizationHierarchyCode)), @MinimumStartDate)
		)

	----------

	OUTPUT
		SRC.GLCategorizationHierarchyCode,
		SRC.GLCategorizationTypeName,
		SRC.GLCategorizationName,
		SRC.GLFinancialCategoryName,
		SRC.GLMajorCategoryName,
		SRC.GLMinorCategoryName,
		SRC.GLGlobalAccountName,
		SRC.GLGlobalAccountCode,
		SRC.InflowOutflow,
		SRC.SnapshotId,
		SRC.IsActive,
		@NewEndDate AS UpdatedDate,
		'Record updated in source' AS ReasonForChange,
		$Action AS MergeAction
) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND  -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1				   /* An update can either be triggered by the field of a source record being updated, or a source record
													being deactivated. Make sure that we only insert records associated with updates caused by the
													former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */
	
INSERT INTO dbo.GLCategorizationHierarchy
(
	GLCategorizationHierarchyCode,
	GLCategorizationTypeName,
	GLCategorizationName,
	GLFinancialCategoryName,
	GLMajorCategoryName,
	GLMinorCategoryName,
	GLAccountName,
	GLAccountCode,
	InflowOutflow,
	SnapshotId,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	GLCategorizationHierarchy.GLCategorizationHierarchyCode,
	GLCategorizationHierarchy.GLCategorizationTypeName,
	GLCategorizationHierarchy.GLCategorizationName,
	GLCategorizationHierarchy.GLFinancialCategoryName,
	GLCategorizationHierarchy.GLMajorCategoryName,
	GLCategorizationHierarchy.GLMinorCategoryName,
	GLCategorizationHierarchy.GLAccountName,
	GLCategorizationHierarchy.GLAccountCode,
	GLCategorizationHierarchy.InflowOutflow,
	GLCategorizationHierarchy.SnapshotId,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GRReporting.dbo.GLCategorizationHierarchy DIM WHERE DIM.GLCategorizationHierarchyCode = GLCategorizationHierarchy.GLCategorizationHierarchyCode AND DIM.SnapshotId = GLCategorizationHierarchy.SnapshotId)),
	GLCategorizationHierarchy.EndDate,
	GLCategorizationHierarchy.ReasonForChange
FROM
	#GLCategorizationHierarchy GLCategorizationHierarchy
	
GO
