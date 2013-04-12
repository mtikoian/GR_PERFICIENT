USE [GrReporting]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDActivityType]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDActivityType]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDAllocationRegion]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDFunctionalDepartment]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccount]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDGlAccount]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccountCategory]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccountCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDOriginatingRegion]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDOriginatingRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDOriginatingRegion]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 09/21/2011 12:23:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDPropertyFund]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDPropertyFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDPropertyFund]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE()
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

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

			INNER JOIN GrReportingStaging.GDM.PropertyFundActive(''2011-12-31'') SA ON
				S.ImportKey = SA.ImportKey

			INNER JOIN GrReportingStaging.GDM.EntityType ET ON
				S.EntityTypeId = ET.EntityTypeId
		WHERE
			S.IsPropertyFund = 1

	) AS SRC ON
		SRC.PropertyFundId = DIM.PropertyFundId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0  -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data
		
	---------
	
	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		  -- IF the record in the Dimension is currently active AND ...
		((	DIM.EndDate = @MaximumEndDate AND
			(										   -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
				DIM.PropertyFundName <> SRC.PropertyFundName OR
				DIM.PropertyFundType <> SRC.PropertyFundType OR
				SRC.IsActive = 0
			)
		) OR
		(
			SRC.IsActive = 1 AND
			DIM.EndDate <> @MaximumEndDate AND
			DIM.ReasonForChange NOT IN (
				''Record deactivated in source. New reactivated record has been created'',
				''Record updated in source'')			
		))
	THEN
		UPDATE
		SET
			DIM.EndDate = (
				CASE 
					WHEN (DIM.EndDate = @MaximumEndDate AND (DIM.PropertyFundName <> SRC.PropertyFundName OR DIM.PropertyFundType <> SRC.PropertyFundType OR SRC.IsActive = 0))
				THEN	
					SRC.UpdatedDate  -- ... THEN deactivate the dimension record by updating its EndDate
											-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation
											-- will not be reflected here.
				ELSE
					Dim.EndDate
				END
			),
			
			DIM.ReasonForChange = (
				CASE 
					WHEN (DIM.EndDate = @MaximumEndDate AND (DIM.PropertyFundName <> SRC.PropertyFundName OR DIM.PropertyFundType <> SRC.PropertyFundType OR SRC.IsActive = 0))
				THEN
					(CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)
				ELSE
					''Record deactivated in source. New reactivated record has been created''
				END
			)
											

	----------
	
	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.PropertyFundKey <> -1 AND
		 Dim.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	-----------
	
	WHEN NOT MATCHED BY TARGET AND SRC.IsActive = 1 THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
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
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''	
		)

	-----------

	OUTPUT
		SRC.PropertyFundId,
		SRC.PropertyFundName,
		SRC.PropertyFundType,
		SRC.SnapshotId,
		SRC.IsActive,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND  -- This bit is important: Only insert a new record into the dimension if the merge triggered an update 
	IsActive = 1                           -- AND the dimension record that was updated is still active. If the record was deactivated in [SOURCE]
										   -- we don''t want to create a new record for it - we only need to ''end'' its existing record in [TARGET]

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
	PropertyFundId,
	PropertyFundName,
	PropertyFundType,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#PropertyFund


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDOriginatingRegion]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDOriginatingRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDOriginatingRegion]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #OriginatingRegion (
	GlobalRegionId INT NOT NULL,
	RegionCode NVARCHAR(10) NOT NULL,
	RegionName NVARCHAR(50) NOT NULL,
	SubRegionCode NVARCHAR(10) NOT NULL,
	SubRegionName NVARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)
INSERT INTO #OriginatingRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.OriginatingRegion DIM
	USING
	(
		SELECT
			GlobalRegionId,
			RegionCode,
			RegionName,
			ISNULL(SubRegionCode, ''UNKNOWN'') AS SubRegionCode,
			ISNULL(SubRegionName, ''UNKNOWN'') AS SubRegionName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gr.GetGlobalRegionExpanded(@DataPriorToDate)
		WHERE
			IsOriginatingRegion = 1

	) AS SRC ON
		SRC.GlobalRegionId = DIM.GlobalRegionId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.RegionCode <> SRC.RegionCode OR
			DIM.RegionName <> SRC.RegionName OR
			DIM.SubRegionCode <> SRC.SubRegionCode OR
			DIM.SubRegionName <> SRC.SubRegionName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                  -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			GlobalRegionId,
			RegionCode,
			RegionName,
			SubRegionCode,
			SubRegionName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GlobalRegionId,
			SRC.RegionCode,
			SRC.RegionName,
			SRC.SubRegionCode,
			SRC.SubRegionName,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.OriginatingRegionKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''			

	--------

	OUTPUT -- Dimension
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.

---------------------------------

INSERT INTO dbo.OriginatingRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#OriginatingRegion

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccountCategory]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccountCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDGlAccountCategory]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

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
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

				-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation will not be reflected here.	

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
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
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.GlAccountCategoryKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

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
		''Record updated in source'' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1 AND						   -- Only insert records into the dimension that are active.
	MergedData.GlobalGlAccountCategoryCode IS NOT NULL -- This NOT NULL check is needed to prevent an empty record being inserted into the
													   -- dimension. It seems that hardcoding the EndDate to ''9999-12-31 00:00:00.000'' in the
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



' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDGlAccount]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDGlAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDGlAccount]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

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
			'''' AS AccountType,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gdm.GLGLobalAccount S -- S stands for SOURCE
			
			INNER JOIN GrReportingStaging.Gdm.GLGlobalAccountActive(''2011-12-31'') SA ON
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
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

	--------

	WHEN NOT MATCHED BY TARGET -- When a record exists in [Source] that doesn''t exist in [Target], insert it
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
			''New record in source''	
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.GlAccountKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''			

	--------

	OUTPUT -- Dimension
		SRC.GLGlobalAccountId,
		SRC.Code,
		SRC.Name,
		SRC.AccountType,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
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

' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDFunctionalDepartment]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDFunctionalDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDFunctionalDepartment]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #FunctionalDepartment ( -- Dimension
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(100) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #FunctionalDepartment ( -- Dimension
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
			GrReportingStaging.Gr.GetFunctionalDepartmentExpanded(''2011-12-31'')	

	) AS SRC ON
		SRC.ReferenceCode = DIM.ReferenceCode

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.FunctionalDepartmentCode <> SRC.FunctionalDepartmentCode OR
			DIM.FunctionalDepartmentName <> SRC.FunctionalDepartmentName OR
			DIM.SubFunctionalDepartmentCode <> SRC.SubFunctionalDepartmentCode OR
			DIM.SubFunctionalDepartmentName <> SRC.SubFunctionalDepartmentName OR
			SRC.IsActive = 0
		) AND
		DIM.ReferenceCode NOT IN (''LGL:'', ''LGL:UNKNOWN'', ''LGL:RSK'', ''LGL:RIM'')
	THEN
		UPDATE
		SET
			DIM.EndDate = (CASE WHEN SRC.UpdatedDate < DIM.StartDate THEN @NewEndDate ELSE SRC.UpdatedDate END),
										                    -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)
															
	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			ReferenceCode,
			FunctionalDepartmentCode,
			FunctionalDepartmentName,
			SubFunctionalDepartmentCode,
			SubFunctionalDepartmentName,
			StartDate,
			EndDate,
			ReasonForChange
		)
		VALUES (
			SRC.ReferenceCode,
			SRC.FunctionalDepartmentCode,
			SRC.FunctionalDepartmentName,
			SRC.SubFunctionalDepartmentCode,
			SRC.SubFunctionalDepartmentName,
			SRC.UpdatedDate, -- InsertedDate is not available: use UpdatedDate instead.
			@MaximumEndDate,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.FunctionalDepartmentKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.ReferenceCode NOT IN (''LGL:'', ''LGL:UNKNOWN'', ''LGL:RSK'', ''LGL:RIM'') AND
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''


	--------

	OUTPUT -- Dimension
		SRC.ReferenceCode,
		SRC.FunctionalDepartmentCode,
		SRC.FunctionalDepartmentName,
		SRC.SubFunctionalDepartmentCode,
		SRC.SubFunctionalDepartmentName,
		SRC.IsActive,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.


------------------------------

INSERT INTO dbo.FunctionalDepartment( -- Dimension
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
	StartDate,
	EndDate,
	ReasonForChange
FROM
	#FunctionalDepartment

-----------

UPDATE
	dbo.FunctionalDepartment
SET
	EndDate = ''2010-12-31 23:59:59.000''
WHERE
	FunctionalDepartmentName = ''Legal, Risk & Records''


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDAllocationRegion]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDAllocationRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDAllocationRegion]
	@DataPriorToDate DATETIME

AS

/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''

CREATE TABLE #AllocationRegion (
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(50) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	SubRegionCode VARCHAR(10) NOT NULL,
	SubRegionName VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange NVARCHAR(1024) NULL
)

INSERT INTO #AllocationRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.AllocationRegion DIM
	USING
	(
		SELECT
			GlobalRegionId,
			RegionCode,
			RegionName,
			ISNULL(SubRegionCode, ''UNKNOWN'') AS SubRegionCode,
			ISNULL(SubRegionName, ''UNKNOWN'') AS SubRegionName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.Gr.GetGlobalRegionExpanded(@DataPriorToDate) -- [VIEW] S stands for SOURCE
		WHERE
			IsAllocationRegion = 1

	) AS SRC ON
		SRC.GlobalRegionId = DIM.GlobalRegionId AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR the record has been deactivated in [SOURCE] ...
			DIM.RegionCode <> SRC.RegionCode OR
			DIM.RegionName <> SRC.RegionName OR
			DIM.SubRegionCode <> SRC.SubRegionCode OR
			DIM.SubRegionName <> SRC.SubRegionName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                  -- ... THEN deactivate the dimension record by updating its EndDate
															-- Note that other changes that might have been made to the record in [SOURCE] during
															-- its deactivation will not be reflected here.
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			GlobalRegionId,
			RegionCode,
			RegionName,
			SubRegionCode,
			SubRegionName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.GlobalRegionId,
			SRC.RegionCode,
			SRC.RegionName,
			SRC.SubRegionCode,
			SRC.SubRegionName,
			SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''	
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.AllocationRegionKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	--------

	OUTPUT -- Dimension
		SRC.GlobalRegionId,
		SRC.RegionCode,
		SRC.RegionName,
		SRC.SubRegionCode,
		SRC.SubRegionName,
		SRC.IsActive,
		SRC.SnapshotId,
		''Record updated in source'' AS ReasonForChange,
		DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1					-- Only insert records that are still active into the dimension. Without this check, deactivated
											-- records will be reinserted into the dimension after having been deactivated.

---------------------------------------

INSERT INTO dbo.AllocationRegion( -- Dimension
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	GlobalRegionId,
	RegionCode,
	RegionName,
	SubRegionCode,
	SubRegionName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#AllocationRegion


' 
END
GO
/****** Object:  StoredProcedure [dbo].[csp_IU_SCDActivityType]    Script Date: 09/21/2011 12:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_IU_SCDActivityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_IU_SCDActivityType]
	@DataPriorToDate DATETIME

AS

DECLARE @NewEndDate DATETIME = GETDATE() -- If a TARGET/Dimension record needs to be ended, use this date
DECLARE @MaximumEndDate DATETIME = ''9999-12-31 00:00:00.000''


/* IMPORTANT: There is no single business key that we can use to match dimension records with source records: we match using ActivityTypeId and
			  BusinessLineId. For this reason it''s difficult to distinguish between new dimension records and dimension records that have been
			  updated. As such, the UpdatedDate of a record can''t be used as the dimension record''s StartDate or EndDate with any certainty.
			  For this reason, @NewEndDate is used to set a record''s EndDate for a deactivation, as well as to set the StartDate of a new
			  dimension record. */


/*	There is a bug in SQL Server 2008 that prevents the use of the MERGE statement when the table that is being merged to is referenced by
	other tables using FKs. [http://connect.microsoft.com/SQLServer/feedback/details/435031/]
	A work-around is to insert the result of the merge into a temp table, and to then insert data from this temp table into the dimension.
*/

CREATE TABLE #ActivityType (
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL,
	SnapshotId INT NOT NULL,
	ReasonForChange  VARCHAR(1024) NOT NULL
)
INSERT INTO #ActivityType (
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	UpdatedDate AS StartDate,
	@MaximumEndDate AS EndDate,
	0 AS SnapshotId,
	ReasonForChange
FROM
(
	MERGE INTO
		dbo.ActivityType DIM
	USING
	(
		SELECT
			ActivityTypeId,
			ActivityTypeName,
			ActivityTypeCode,
			BusinessLineId,
			BusinessLineName,
			InsertedDate,
			UpdatedDate,
			IsActive,
			0 AS SnapshotId
		FROM
			GrReportingStaging.GR.GetActivityTypeBusinessLineExpanded(@DataPriorToDate)

	) AS SRC ON
		SRC.ActivityTypeId = DIM.ActivityTypeId AND
		SRC.BusinessLineId = DIM.BusinessLineID AND
		SRC.SnapshotId = DIM.SnapshotId AND
		DIM.SnapshotId = 0 -- hardcode 0 as this stored procedure handles only LIVE GDM data, not snapshotted data

	--------

	WHEN MATCHED AND -- When a record exists in [Target] and [Source] and is active in [TARGET] but has been updated/deactivated in [SOURCE], end the record in the dimension.
		 DIM.EndDate = @MaximumEndDate AND					-- IF the record in the Dimension is currently active AND ...
		(										            -- ... a field has changed OR !the record has been deactivated in [SOURCE]! ...
			DIM.ActivityTypeId <> SRC.ActivityTypeId OR
			DIM.BusinessLineId <> SRC.BusinessLineId OR
			DIM.ActivityTypeName <> SRC.ActivityTypeName OR
			DIM.ActivityTypeCode <> SRC.ActivityTypeCode OR
			DIM.BusinessLineName <> SRC.BusinessLineName OR
			SRC.IsActive = 0
		)
	THEN
		UPDATE
		SET
			DIM.EndDate = SRC.UpdatedDate,                   -- ... THEN deactivate the dimension record by updating its EndDate
			DIM.ReasonForChange = (CASE WHEN SRC.IsActive = 0 THEN ''Record deactivated in source'' ELSE ''Record updated in source'' END)


				-- Note that other changes that might have been made to the record in [SOURCE] during its deactivation will not be reflected here.	

	--------

	WHEN NOT MATCHED BY TARGET THEN -- When a record exists in [Source] that doesn''t exist in [Target], insert it
		INSERT (
			ActivityTypeId,
			ActivityTypeName,
			ActivityTypeCode,
			BusinessLineId,
			BusinessLineName,
			StartDate,
			EndDate,
			SnapshotId,
			ReasonForChange
		)
		VALUES (
			SRC.ActivityTypeId,
			SRC.ActivityTypeName,
			SRC.ActivityTypeCode,
			SRC.BusinessLineId,
			SRC.BusinessLineName,
			@NewEndDate,--SRC.InsertedDate,
			@MaximumEndDate,
			SRC.SnapshotId,
			''New record in source''
		)

	--------

	WHEN NOT MATCHED BY SOURCE AND -- When a record exists in [Target] that doesn''t exist in [Source], ''end'' it
		 DIM.SnapshotId = 0 AND
		 DIM.ActivityTypeKey <> -1 AND -- do not update the ''UNKNOWN'' record; this will not be matched in SOURCE
		 DIM.EndDate = @MaximumEndDate
	THEN
		UPDATE
		SET
			DIM.EndDate = @NewEndDate,
			ReasonForChange = ''Record no longer exists in source''

	--------

	OUTPUT -- Dimension
		SRC.ActivityTypeId,
		SRC.ActivityTypeName,
		SRC.ActivityTypeCode,
		SRC.BusinessLineId,
		SRC.BusinessLineName,
		SRC.SnapshotId,
		SRC.IsActive,
		@NewEndDate AS UpdatedDate, --DATEADD(ms, 10, SRC.UpdatedDate) AS UpdatedDate,
		''Record updated in source'' AS ReasonForChange,
		$Action AS MergeAction

) AS MergedData
WHERE
	MergedData.MergeAction = ''UPDATE'' AND
	MergedData.IsActive = 1				  -- Only active records should be inserted into the dimension - the insert would be initiated because
										  -- the field(s) of an active record have been updated in SOURCE.


-----------------------------------

INSERT INTO dbo.ActivityType( -- Dimension
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
)
SELECT
	ActivityTypeId,
	ActivityTypeName,
	ActivityTypeCode,
	BusinessLineId,
	BusinessLineName,
	StartDate,
	EndDate,
	SnapshotId,
	ReasonForChange
FROM
	#ActivityType

' 
END
GO
