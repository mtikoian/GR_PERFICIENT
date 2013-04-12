USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccountCategory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
GO

CREATE PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = '9999-12-31 00:00:00.000'

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

CREATE TABLE #GLAccountCategory (
	GlobalGlAccountCategoryCode NVARCHAR(32) NOT NULL,
	TranslationTypeName NVARCHAR(50) NOT NULL,
	TranslationSubTypeName NVARCHAR(50) NOT NULL,
	MajorCategoryName NVARCHAR(50) NOT NULL,
	MinorCategoryName NVARCHAR(100) NOT NULL,
	FeeOrExpense NVARCHAR(50) NOT NULL,
	AccountSubTypeName NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #GlAccountCategory( -- Dimension
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.GlAccountCategory DIM
	USING
	(
		SELECT
			GlobalAccountCategoryCode AS GlobalGlAccountCategoryCode,
			TranslationTypeName,
			TranslationSubTypeName,
			GLMajorCategoryName AS MajorCategoryName,
			GLMinorCategoryName AS MinorCategoryName,
			FeeOrExpense,
			GLAccountSubTypeName AS AccountSubTypeName,
			IsActive,
			InsertedDate,
			UpdatedDate,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GR.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate) S -- S stands for SOURCE

	) AS SRC ON
		SRC.GlobalGlAccountCategoryCode = DIM.GlobalGlAccountCategoryCode AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR !the record has been deactivated in [SOURCE]! ...
			DIM.TranslationTypeName <> SRC.TranslationTypeName OR
			DIM.TranslationSubTypeName <> SRC.TranslationSubTypeName OR
			DIM.MajorCategoryName <> SRC.MajorCategoryName OR
			DIM.MinorCategoryName <> SRC.MinorCategoryName OR
			DIM.FeeOrExpense <> SRC.FeeOrExpense OR
			DIM.AccountSubTypeName <> SRC.AccountSubTypeName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                   -- ... THEN deactivate the dimension record by updating its EndDate
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN 'Record deactivated in source' ELSE 'Record updated in source' END)

				-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation will not be reflected here.	

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn't exist in [Target], insert it
		INSERT (
			GlobalGlAccountCategoryCode,
			TranslationTypeName,
			TranslationSubTypeName,
			MajorCategoryName,
			MinorCategoryName,
			FeeOrExpense,
			AccountSubTypeName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GlobalGlAccountCategoryCode,
			SRC.TranslationTypeName,
			SRC.TranslationSubTypeName,
			SRC.MajorCategoryName,
			SRC.MinorCategoryName,
			SRC.FeeOrExpense,
			SRC.AccountSubTypeName,
			@NewEndDate,--SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			'New record in source'
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn't exist in [Source], 'end' it
		 DIM.SnapshotId = 0 AND
		 DIM.GlAccountCategoryKey <> -1 AND -- do not update the 'UNKNOWN' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = 'Record no longer exists in source'

	--------

	OUTPUT -- Dimension
		SRC.GlobalGlAccountCategoryCode,
		SRC.TranslationTypeName,
		SRC.TranslationSubTypeName,
		SRC.MajorCategoryName,
		SRC.MinorCategoryName,
		SRC.FeeOrExpense,
		SRC.AccountSubTypeName,
		SRC.SnapshotId,
		SRC.IsActive,
		@NewEndDate AS UpdatedDate, --DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		'Record updated in source' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = 'UPDATE' AND
	MergedData.IsActive = 1 AND						   -- Only insert records into the dimension that are active.
	MergedData.GlobalGlAccountCategoryCode IS NOT NULL -- This NOT NULL check is needed to prevent an empty record being inserted into the
													   -- dimension. It seems that hardcoding the EndDate to '9999-12-31 00:00:00.000' in the
													   -- outer INSERT statement triggers an INSERT that failes because every field besides the
													   -- hardcoded EndDate is NULL.

-----------------------------------------------

INSERT INTO dbo.GlAccountCategory( -- Dimension
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalGlAccountCategoryCode,
	TranslationTypeName,
	TranslationSubTypeName,
	MajorCategoryName,
	MinorCategoryName,
	FeeOrExpense,
	AccountSubTypeName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#GLAccountCategory



GO
