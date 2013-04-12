USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record that has been deleted in the source needs to be ended, use this date
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #FunctionalDepartment
(
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(100) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #FunctionalDepartment
(
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.FunctionalDepartment DIM
	USING
	(
		SELECT
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			UpdatedDate,
			IsActive
		FROM
			GrReportingStaging.Gr.GetFunctionalDepartmentExpanded(@DataPriorToDate)	
		WHERE
			IsActive = 1
			/*
				It is necessary to filter on the IsActive flag. If the source data has 2 records, 1 inactivated record, and one
				changed active record, it will join 2 source records with one destination record. This will break the MERGE 
				statement and cause an error.
			*/
	) AS SRC ON
		DIM.ReferenceCode = SRC.ReferenceCode AND -- ReferenceCodef is treated as the Functional Department PK
		DIM.EndDate = @MaximumEndDate -- Only consider active dimension records (those records that have not been 'ended')

	/* ===========================================================================================================================================
		When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in
			the dimension.	
	   ======================================================================================================================================== */

	WHEN
		MATCHED AND
		(	-- If a field has been updated or the record has been deactivated in the source
			DIM.FunctionalDepartmentCode <> SRC.FunctionalDepartmentCode OR
			DIM.FunctionalDepartmentName <> SRC.FunctionalDepartmentName OR
			DIM.SubFunctionalDepartmentCode <> SRC.SubFunctionalDepartmentCode OR
			DIM.SubFunctionalDepartmentName <> SRC.SubFunctionalDepartmentName OR
			SRC.IsActive = 0
		)  AND
		DIM.ReferenceCode NOT IN ('LGL:', 'LGL:UNKNOWN', 'LGL:RSK', 'LGL:RIM') -- Ignore these
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
		DIM.FunctionalDepartmentKey <> -1 AND -- Do not update the 'UNKNOWN' record; this will not be matched in SOURCE
		DIM.ReferenceCode NOT IN ('LGL:', 'LGL:UNKNOWN', 'LGL:RSK', 'LGL:RIM') AND
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
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			EndDate,
			ReasonForChange,
			StartDate
		)
		VALUES
		(
			SRC.ReferenceCode,
			SRC.FunctionalDepartmentCode,
			SRC.FunctionalDepartmentName,
			SRC.SubFunctionalDepartmentCode,
			SRC.SubFunctionalDepartmentName,
			@MaximumEndDate,
			CASE
				WHEN -- If this record (identified by its primary key) doesn't exist in the dimension (regardless of its StartDate and EndDate)
					0 = (	SELECT
								COUNT(*)
							FROM
								GrReporting.dbo.FunctionalDepartment
							WHERE
								ReferenceCode = SRC.ReferenceCode
						)
				THEN -- Then it must be a new record
					'New record in source'
				ELSE -- Else the source record must have been reactivated and/or updated
					'Record reactivated in source'
			END,
			ISNULL(DATEADD(ms, 10, (SELECT
										MAX(EndDate)
									FROM
										GrReporting.dbo.FunctionalDepartment
									WHERE
										ReferenceCode = SRC.ReferenceCode)), @MinimumStartDate)
		)

	--------

	OUTPUT -- Dimension
		SRC.ReferenceCode,
		SRC.FunctionalDepartmentCode,
		SRC.FunctionalDepartmentName,
		SRC.SubFunctionalDepartmentCode,
		SRC.SubFunctionalDepartmentName,
		SRC.IsActive,
		'Record updated in source' AS ReasonForChange,
		@NewEndDate AS UpdatedDate, -- DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND -- Important: Only insert a new record into the dimension if the merge triggered an update.
	MergedData.IsActive = 1				  /* An update can either be triggered by the field of a source record being updated, or a source record
												being deactivated. Make sure that we only insert records associated with updates caused by the
												former, where a new dimension record to reflect these changes is required. */

/* ===============================================================================================================================================
	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
		other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension/[TARGET].
   ============================================================================================================================================ */

INSERT INTO dbo.FunctionalDepartment
(
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate,
	ReasonForChange
)
SELECT
	Updated.ReferenceCode,
	Updated.FunctionalDepartmentCode,
	Updated.FunctionalDepartmentName,
	Updated.SubFunctionalDepartmentCode,
	Updated.SubFunctionalDepartmentName,
	DATEADD(MS, 10, (SELECT MAX(EndDate) FROM GrReporting.dbo.FunctionalDepartment DIM WHERE DIM.ReferenceCode = Updated.ReferenceCode)) AS StartDate,
	Updated.EndDate,
	Updated.ReasonForChange
FROM
	#FunctionalDepartment Updated

-- Make sure that 'Legal, Risk & Records' is shown as having been deactivated at the end of 2010

UPDATE
	dbo.FunctionalDepartment
SET
	EndDate = '2010-12-31 23:59:59.000'
WHERE
	FunctionalDepartmentName = 'Legal, Risk & Records'

GO

 
 