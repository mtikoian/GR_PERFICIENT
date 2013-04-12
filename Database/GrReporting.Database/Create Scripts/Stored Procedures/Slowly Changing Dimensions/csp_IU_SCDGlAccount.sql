 USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDGlAccount]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDGlAccount]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

CREATE TABLE #GlAccount (
	GLGlobalAccountId INT NOT NULL,
	Code NVARCHAR(10) NULL,
	Name NVARCHAR(150) NULL,
	AccountType NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #GlAccount( -- Dimension
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.GlAccount DIM
	USING
	(
		SELECT
			GLGLobalAccountId,
			Code,
			Name,
			'' AS AccountType,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gdm.GLGLobalAccount S -- S stands for SOURCE
			
			INNER JOIN GrReportingStaging.Gdm.GLGlobalAccountActive('2011-12-31') SA ON
				S.ImportKey = SA.ImportKey

	) AS SRC ON
		SRC.GLGlobalAccountId = DIM.GLGlobalAccountId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.Code <> SRC.Code OR
			DIM.Name <> SRC.Name OR
			DIM.AccountType <> SRC.AccountType OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                  -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN 'Record deactivated in source' ELSE 'Record updated in source' END)

	--------

	WHEN NOT MATCHED BY TARGET -- When a record exists in [Source] that doesn't exist in [Target], insert it
	THEN 
		INSERT (
			GLGlobalAccountId,
			Code,
			Name,
			AccountType,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GLGlobalAccountId,
			SRC.Code,
			SRC.Name,
			SRC.AccountType,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			'New record in source'	
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn't exist in [Source], 'end' it
		 DIM.SnapshotId = 0 AND
		 DIM.GlAccountKey <> -1 AND -- do not update the 'UNKNOWN' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = 'Record no longer exists in source'			

	--------

	OUTPUT -- Dimension
		SRC.GLGlobalAccountId,
		SRC.Code,
		SRC.Name,
		SRC.AccountType,
		SRC.IsActive,
		SRC.SnapshotId,
		'Record updated in source' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.

----------------------------------

INSERT INTO dbo.GlAccount( -- Dimension
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GLGlobalAccountId,
	Code,
	Name,
	AccountType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange

FROM
	#GlAccount

GO
 