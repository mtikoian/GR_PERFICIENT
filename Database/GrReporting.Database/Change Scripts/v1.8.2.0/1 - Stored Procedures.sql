USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 10/17/2011 18:36:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 10/17/2011 18:36:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE()
DECLARE @MinimumStartDate DATETIME = '1753-01-01 00:00:00.000'
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'
	
CREATE TABLE #PropertyFund (
	PropertyFundId INT NOT NULL,
	PropertyFundName NVARCHAR(100) NOT NULL,
	PropertyFundType VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #PropertyFund (
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	UpdatedDate,
	@MaximumEndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.PropertyFund DIM
	USING
	(
		SELECT
			S.PropertyFundId,
			S.Name AS PropertyFundName,
			ET.Name AS PropertyFundType,
			S.IsActive,
			S.InsertedDate,
			S.UpdatedDate,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GDM.PropertyFund S

			INNER JOIN GrReportingStaging.GDM.PropertyFundActive(@DataPriorToDate) SA ON
				S.ImportKey = SA.ImportKey

			INNER JOIN GrReportingStaging.GDM.EntityType ET ON
				S.EntityTypeId = ET.EntityTypeId
		WHERE
			S.IsReportingEntity = 1

	) AS SRC ON
		SRC.PropertyFundId = DIM.PropertyFundId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0  -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data
	---------
	
	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
			(
				DIM.EndDate = @MaximumEndDate AND -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
				(										   
					DIM.PropertyFundName <> SRC.PropertyFundName OR
					DIM.PropertyFundType <> SRC.PropertyFundType OR
					SRC.IsActive = 0
				)
			) OR
			(
				DIM.EndDate <> @MaximumEndDate AND
				DIM.PropertyFundName = SRC.PropertyFundName AND
				DIM.PropertyFundType = SRC.PropertyFundType AND
				SRC.IsActive = 1
			)
	THEN
		UPDATE
		SET
		 -- ... THEN deactivate the dimension record by updating its EndDate
		 -- Note that other changes that might have been made to the record in [SOURCE] during its deactivation
		 -- will not be reflected here.
		 
			
			DIM.ReasonForChange = 
				CASE 
					WHEN DIM.EndDate = @MaximumEndDate THEN
						(CASE WHEN SRC.IsActive = 0 THEN 'Record deactivated in source' ELSE 'Record updated in source' END)
					ELSE
						'Record has been reactivated'
				END,
			DIM.EndDate = CASE WHEN DIM.EndDate = @MaximumEndDate THEN SRC.UpdatedDate ELSE @MaximumEndDate END
	----------
	
	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn't exist in [Source], 'end' it
		 DIM.SnapshotId = 0 AND
		 DIM.PropertyFundKey <> -1 AND
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = 'Record no longer exists in source'

	-----------
	
	WHEN NOT MATCHED BY TARGET AND SRC.IsActive = 1 THEN -- When a record exists in [Source] that doesn't exist in [Target], insert it
		INSERT (
			PropertyFundId,
			PropertyFundName,
			PropertyFundType,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.PropertyFundId,
			SRC.PropertyFundName,
			SRC.PropertyFundType,
			@MinimumStartDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			'New record or reactivated record in source'
		)

	-----------

	OUTPUT
		SRC.PropertyFundId,
		SRC.PropertyFundName,
		SRC.PropertyFundType,
		SRC.SnapshotId,
		SRC.IsActive,
		--CASE WHEN DIM.EndDate = @MaximumEndDate THEN'Record updated in source' 	ELSE 'Record has been reactivated' END  AS ReasonForChange,
		'Record updated in source' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND  -- This bit is important: Only insert a new record into the dimension if the merge triggered an update 
	IsActive = 1  AND                          -- AND the dimension record that was updated is still active. If the record was deactivated in [SOURCE]
	ReasonForChange <> 'Record has been reactivated'					   -- we don't want to create a new record for it - we only need to 'end' its existing record in [TARGET]

---------------------------------

INSERT INTO dbo.PropertyFund (
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	PF.PropertyFundId,
	PF.PropertyFundName,
	PF.PropertyFundType,
	PF.StartDate,
	PF.EndDate,
	PF.SnapshotId,
	PF.ReasonForChange
FROM
	#PropertyFund PF
	
	LEFT OUTER JOIN dbo.PropertyFund DIM ON
		DIM.PropertyFundId = PF.PropertyFundId AND
		DIM.PropertyFundName = PF.PropertyFundName AND
		DIM.PropertyFundType = PF.PropertyFundType
WHERE
	DIM.PropertyFundId IS NULL







GO


