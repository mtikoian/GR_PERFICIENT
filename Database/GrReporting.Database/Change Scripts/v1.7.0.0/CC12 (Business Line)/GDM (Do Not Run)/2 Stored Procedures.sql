/*
1. SyncSnapshot
2. CopySnapshot
*/

---------------------------------------------------------------------
				/*	Beginning of SyncSnapshot	*/
---------------------------------------------------------------------


USE [GDM]
GO
/****** Object:  StoredProcedure [dbo].[SyncSnapshot]    Script Date: 03/18/2011 16:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SyncSnapshot]
	@SnapshotId int = NULL
AS
BEGIN	
	SET NOCOUNT ON					
	SET XACT_ABORT ON
		
	IF EXISTS (SELECT * FROM [dbo].[Snapshot] WHERE [SnapshotId] = @SnapshotId AND [IsLocked] = 1)
	RETURN;	

	BEGIN TRAN

	INSERT INTO [dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount]
		([SnapshotId]
		,[FeePropertyGLAccountGLGlobalAccountId]
		,[PropertyGLAccountCode]
		,[GLGlobalAccountId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[SourceCode])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[FeePropertyGLAccountGLGlobalAccountId]
		,[Source].[PropertyGLAccountCode]
		,[Source].[GLGlobalAccountId]		
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[SourceCode]
	FROM 
		[GBS].[FeePropertyGLAccountGLGlobalAccount] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount] [Existing] ON
			[Existing].[FeePropertyGLAccountGLGlobalAccountId] = [Source].[FeePropertyGLAccountGLGlobalAccountId] AND			
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLMinorCategoryPayrollType]
		([SnapshotId]
		,[GLMinorCategoryPayrollTypeId]
		,[GLMinorCategoryId]
		,[PayrollTypeId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])    
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLMinorCategoryPayrollTypeId]
		,[Source].[GLMinorCategoryId]
		,[Source].[PayrollTypeId]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[GBS].[GLMinorCategoryPayrollType] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotGLMinorCategoryPayrollType] [Existing] ON
			[Existing].[GLMinorCategoryPayrollTypeId] = [Source].[GLMinorCategoryPayrollTypeId] AND			
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyEntityException]
		([SnapshotId]
		,[PropertyEntityExceptionId]
		,[SourceCode]
		,[PropertyEntityCode]
		,[GLGlobalAccountId]
		,[PropertyBudgetTypeId]
		,[PropertyGLAccountCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDirectCost])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyEntityExceptionId]
		,[Source].[SourceCode]
		,[Source].[PropertyEntityCode]
		,[Source].[GLGlobalAccountId]
		,[Source].[PropertyBudgetTypeId]
		,[Source].[PropertyGLAccountCode]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[IsDirectCost]
	FROM 
		[GBS].[PropertyEntityException] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotPropertyEntityException] [Existing] ON
			[Existing].[PropertyEntityExceptionId] = [Source].[PropertyEntityExceptionId] AND			
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyGLAccountGLGlobalAccount]
		([SnapshotId]
		,[PropertyGLAccountGLGlobalAccountId]
		,[PropertyGLAccountCode]
		,[GLGlobalAccountId]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDirectCost])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyGLAccountGLGlobalAccountId]
		,[Source].[PropertyGLAccountCode]
		,[Source].[GLGlobalAccountId]
		,[Source].[PropertyBudgetTypeId]
		,[Source].[SourceCode]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[IsDirectCost]
	FROM
		[GBS].[PropertyGLAccountGLGlobalAccount] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotPropertyGLAccountGLGlobalAccount] [Existing] ON
			[Existing].[PropertyGLAccountGLGlobalAccountId] = [Source].[PropertyGLAccountGLGlobalAccountId] AND			
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyOverheadPropertyGLAccount]
		([SnapshotId]
		,[PropertyOverheadPropertyGLAccountId]
		,[PropertyGLAccountCode]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[ActivityTypeId]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyOverheadPropertyGLAccountId]
		,[Source].[PropertyGLAccountCode]
		,[Source].[PropertyBudgetTypeId]
		,[Source].[SourceCode]
		,[Source].[ActivityTypeId]
		,[Source].[FunctionalDepartmentId]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[GBS].[PropertyOverheadPropertyGLAccount] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotPropertyOverheadPropertyGLAccount] [Existing] ON
			[Existing].[PropertyOverheadPropertyGLAccountId] = [Source].[PropertyOverheadPropertyGLAccountId] AND			
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyPayrollPropertyGLAccount]
		([SnapshotId]
		,[PropertyPayrollPropertyGLAccountId]
		,[PropertyGLAccountCode]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[ActivityTypeId]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[PayrollTypeId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyPayrollPropertyGLAccountId]
		,[Source].[PropertyGLAccountCode]
		,[Source].[PropertyBudgetTypeId]
		,[Source].[SourceCode]
		,[Source].[ActivityTypeId]
		,[Source].[FunctionalDepartmentId]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[PayrollTypeId]
	FROM
		[GBS].[PropertyPayrollPropertyGLAccount] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotPropertyPayrollPropertyGLAccount] [Existing] ON
			[Existing].[PropertyPayrollPropertyGLAccountId] = [Source].[PropertyPayrollPropertyGLAccountId] AND			
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotCorporateDepartment]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[Description]
		,[LastDate]
		,[MriUserID]
		,[IsActive]
		,[FunctionalDepartmentId]
		,[IsTsCost])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[Code]
		,[Source].[SourceCode]
		,[Source].[Description]
		,[Source].[LastDate]
		,[Source].[MriUserID]
		,[Source].[IsActive]
		,[Source].[FunctionalDepartmentId]
		,[Source].[IsTsCost]
	FROM 
		[dbo].[CorporateDepartment] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotCorporateDepartment] [Existing] ON
			[Existing].[Code] = [Source].[Code] AND
			[Existing].[SourceCode] = [Source].[SourceCode] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotCorporateEntity]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[CityID]
		,[Name]
		,[DisplayName]
		,[CurrencyCode]
		,[IsActive]
		,[IsCustom]
		,[Address]
		,[IsFund]
		,[ShippingAddress]
		,[BillingAddress]
		,[ProjectRef]
		,[IsOutsourced]
		,[IsRMProperty]
		,[IsHistoric])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[Code]
		,[Source].[SourceCode]
		,[Source].[CityID]
		,[Source].[Name]
		,[Source].[DisplayName]
		,[Source].[CurrencyCode]
		,[Source].[IsActive]
		,[Source].[IsCustom]
		,[Source].[Address]
		,[Source].[IsFund]
		,[Source].[ShippingAddress]
		,[Source].[BillingAddress]
		,[Source].[ProjectRef]
		,[Source].[IsOutsourced]
		,[Source].[IsRMProperty]
		,[Source].[IsHistoric]	
	FROM 
		[dbo].[CorporateEntity] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotCorporateEntity] [Existing] ON
			[Existing].[Code] = [Source].[Code] AND
			[Existing].[SourceCode] = [Source].[SourceCode] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotCorporateJobCode]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[JobType]
		,[Description]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[StartDate]
		,[EndDate])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[Code]
		,[Source].[SourceCode]
		,[Source].[JobType]
		,[Source].[Description]
		,[Source].[FunctionalDepartmentId]
		,[Source].[IsActive]
		,[Source].[StartDate]
		,[Source].[EndDate]
	FROM 
		[dbo].[CorporateJobCode] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotCorporateJobCode] [Existing] ON
			[Existing].[Code] = [Source].[Code] AND
			[Existing].[SourceCode] = [Source].[SourceCode] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotCurrency]
		([SnapshotId]
		,[Code]
		,[Symbol])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[Code]
		,[Source].[Symbol]
	FROM 
		[dbo].[Currency] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotCurrency] [Existing] ON
			[Existing].[Code] = [Source].[Code] AND
			[Existing].[Symbol] = [Source].[Symbol] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL		
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotFunctionalDepartment]
		([SnapshotId]
		,[FunctionalDepartmentId]
		,[Name]
		,[Code]
		,[GlobalCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[NuViewId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[FunctionalDepartmentId]
		,[Source].[Name]
		,[Source].[Code]
		,[Source].[GlobalCode]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[NuViewId]
	FROM 
		[dbo].[FunctionalDepartment] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotFunctionalDepartment] [Existing] ON
			[Existing].[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL				
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLAccount]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[Name]
		,[Type]
		,[IsHistoric]
		,[IsGR]
		,[IsActive]
		,[UpdatedDate])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[Code]
		,[Source].[SourceCode]
		,[Source].[Name]
		,[Source].[Type]
		,[Source].[IsHistoric]
		,[Source].[IsGR]
		,[Source].[IsActive]
		,[Source].[UpdatedDate]
	FROM 
		[dbo].[GLAccount] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotGLAccount] [Existing] ON
			[Existing].[Code] = [Source].[Code] AND
			[Existing].[SourceCode] = [Source].[SourceCode] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL		
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPayrollRegion]
		([SnapshotId]
		,[PayrollRegionId]
		,[RegionId]
		,[ExternalSubRegionId]
		,[CorporateEntityRef]
		,[CorporateSourceCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PayrollRegionId]
		,[Source].[RegionId]
		,[Source].[ExternalSubRegionId]
		,[Source].[CorporateEntityRef]
		,[Source].[CorporateSourceCode]		
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[TAPASB].[PayrollRegion] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotPayrollRegion] [Existing] ON
			[Existing].[PayrollRegionId] = [Source].[PayrollRegionId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL				
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotOverheadRegion]
           ([SnapshotId]
           ,[OverheadRegionId]
           ,[RegionId]
           ,[CorporateEntityRef]
           ,[CorporateSourceCode]
           ,[Name]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[OverheadRegionId]
		,[Source].[RegionId]
		,[Source].[CorporateEntityRef]
		,[Source].[CorporateSourceCode]
		,[Source].[Name]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[TAPASB].[OverheadRegion] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotOverheadRegion] [Existing] ON
			[Existing].[OverheadRegionId] = [Source].[OverheadRegionId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL			
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyEntityGLAccountInclusion]
		([SnapshotId]
		,[PropertyEntityGLAccountInclusionId]
		,[PropertyEntityCode]
		,[GLAccountCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyEntityGLAccountInclusionId]
		,[Source].[PropertyEntityCode]
		,[Source].[GLAccountCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[PropertyEntityGLAccountInclusion] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotPropertyEntityGLAccountInclusion] [Existing] ON
			[Existing].[PropertyEntityGLAccountInclusionId] = [Source].[PropertyEntityGLAccountInclusionId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity]
		([SnapshotId]
		,[RechargeCorporateDepartmentPropertyEntityId]
		,[CorporateDepartmentCode]
		,[CorporateDepartmentSourceCode]
		,[PropertyEntityCode]
		,[PropertyEntitySourceCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[RechargeCorporateDepartmentPropertyEntityId]
		,[Source].[CorporateDepartmentCode]
		,[Source].[CorporateDepartmentSourceCode]
		,[Source].[PropertyEntityCode]
		,[Source].[PropertyEntitySourceCode]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[RechargeCorporateDepartmentPropertyEntity] [Source]
		CROSS JOIN [dbo].[Snapshot] 
		LEFT OUTER JOIN [dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity] [Existing] ON
			[Existing].[RechargeCorporateDepartmentPropertyEntityId] = [Source].[RechargeCorporateDepartmentPropertyEntityId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL		
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLTranslationType]
		([SnapshotId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLTranslationTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[Description]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLTranslationType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLTranslationType] [Existing] ON
			[Existing].[GLTranslationTypeId] = [Source].[GLTranslationTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLTranslationSubType]
		([SnapshotId]
		,[GLTranslationSubTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsGRDefault])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLTranslationSubTypeId]
		,[Source].[GLTranslationTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[IsGRDefault]
	FROM 
		[dbo].[GLTranslationSubType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLTranslationSubType] [Existing] ON
			[Existing].[GLTranslationSubTypeId] = [Source].[GLTranslationSubTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLAccountType]
		([SnapshotId]
		,[GLAccountTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLAccountTypeId]
		,[Source].[GLTranslationTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLAccountType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLAccountType] [Existing] ON
			[Existing].[GLAccountTypeId] = [Source].[GLAccountTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLAccountSubType]
		([SnapshotId]
		,[GLAccountSubTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLAccountSubTypeId]
		,[Source].[GLTranslationTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLAccountSubType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLAccountSubType] [Existing] ON
			[Existing].[GLAccountSubTypeId] = [Source].[GLAccountSubTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLMajorCategory]
		([SnapshotId]
		,[GLMajorCategoryId]
		,[GLTranslationSubTypeId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLMajorCategoryId]
		,[Source].[GLTranslationSubTypeId]
		,[Source].[Name]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLMajorCategory] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLMajorCategory] [Existing] ON
			[Existing].[GLMajorCategoryId] = [Source].[GLMajorCategoryId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLMinorCategory]
		([SnapshotId]
		,[GLMinorCategoryId]
		,[GLMajorCategoryId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLMinorCategoryId]
		,[Source].[GLMajorCategoryId]
		,[Source].[Name]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLMinorCategory] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLMinorCategory] [Existing] ON
			[Existing].[GLMinorCategoryId] = [Source].[GLMinorCategoryId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLStatutoryType]
		([SnapshotId]
		,[GLStatutoryTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLStatutoryTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[Description]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLStatutoryType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLStatutoryType] [Existing] ON
			[Existing].[GLStatutoryTypeId] = [Source].[GLStatutoryTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotActivityType]
		([SnapshotId]
		,[ActivityTypeId]
		,[Code]
		,[Name]
		,[GLAccountSuffix]
		,[IsEscalatable]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ActivityTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[GLAccountSuffix]
		,[Source].[IsEscalatable]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[ActivityType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotActivityType] [Existing] ON
			[Existing].[ActivityTypeId] = [Source].[ActivityTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLGlobalAccount]
		([SnapshotId]
		,[GLGlobalAccountId]
		,[ActivityTypeId]
		,[GLStatutoryTypeId]
		,[ParentGLGlobalAccountId]
		,[Code]
		,[Name]
		,[Description]
		,[IsGR]
		,[IsGbs]
		,[IsRegionalOverheadCost]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[ExpenseCzarStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLGlobalAccountId]
		,[Source].[ActivityTypeId]
		,[Source].[GLStatutoryTypeId]
		,[Source].[ParentGLGlobalAccountId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[Description]
		,[Source].[IsGR]
		,[Source].[IsGbs]
		,[Source].[IsRegionalOverheadCost]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[ExpenseCzarStaffId]
	FROM 
		[dbo].[GLGlobalAccount] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLGlobalAccount] [Existing] ON
			[Existing].[GLGlobalAccountId] = [Source].[GLGlobalAccountId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLGlobalAccountGLAccount]
		([SnapshotId]
		,[GLGlobalAccountGLAccountId]
		,[GLGlobalAccountId]
		,[SourceCode]
		,[Code]
		,[Name]
		,[Description]
		,[PreGlobalAccountCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLGlobalAccountGLAccountId]
		,[Source].[GLGlobalAccountId]
		,[Source].[SourceCode]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[Description]
		,[Source].[PreGlobalAccountCode]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLGlobalAccountGLAccount] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLGlobalAccountGLAccount] [Existing] ON
			[Existing].[GLGlobalAccountGLAccountId] = [Source].[GLGlobalAccountGLAccountId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLGlobalAccountTranslationType]
		([SnapshotId]
		,[GLGlobalAccountTranslationTypeId]
		,[GLGlobalAccountId]
		,[GLTranslationTypeId]
		,[GLAccountTypeId]
		,[GLAccountSubTypeId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLGlobalAccountTranslationTypeId]
		,[Source].[GLGlobalAccountId]
		,[Source].[GLTranslationTypeId]
		,[Source].[GLAccountTypeId]
		,[Source].[GLAccountSubTypeId]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLGlobalAccountTranslationType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLGlobalAccountTranslationType] [Existing] ON
			[Existing].[GLGlobalAccountTranslationTypeId] = [Source].[GLGlobalAccountTranslationTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGLGlobalAccountTranslationSubType]
		([SnapshotId]
		,[GLGlobalAccountTranslationSubTypeId]
		,[GLGlobalAccountId]
		,[GLTranslationSubTypeId]
		,[GLMinorCategoryId]
		,[PostingPropertyGLAccountCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GLGlobalAccountTranslationSubTypeId]
		,[Source].[GLGlobalAccountId]
		,[Source].[GLTranslationSubTypeId]
		,[Source].[GLMinorCategoryId]
		,[Source].[PostingPropertyGLAccountCode]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GLGlobalAccountTranslationSubType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGLGlobalAccountTranslationSubType] [Existing] ON
			[Existing].[GLGlobalAccountTranslationSubTypeId] = [Source].[GLGlobalAccountTranslationSubTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL  	  	
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotGlobalRegion]
		([SnapshotId]
		,[GlobalRegionId]
		,[ParentGlobalRegionId]
		,[CountryId]
		,[Code]
		,[Name]
		,[IsAllocationRegion]
		,[IsOriginatingRegion]
		,[DefaultCurrencyCode]
		,[DefaultCorporateSourceCode]
		,[ProjectCodePortion]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[GlobalRegionId]
		,[Source].[ParentGlobalRegionId]
		,[Source].[CountryId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[IsAllocationRegion]
		,[Source].[IsOriginatingRegion]
		,[Source].[DefaultCurrencyCode]
		,[Source].[DefaultCorporateSourceCode]
		,[Source].[ProjectCodePortion]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[GlobalRegion] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotGlobalRegion] [Existing] ON
			[Existing].[GlobalRegionId] = [Source].[GlobalRegionId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotOriginatingRegionCorporateEntity]
		([SnapshotId]
		,[OriginatingRegionCorporateEntityId]
		,[GlobalRegionId]
		,[CorporateEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[OriginatingRegionCorporateEntityId]
		,[Source].[GlobalRegionId]
		,[Source].[CorporateEntityCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[OriginatingRegionCorporateEntity] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotOriginatingRegionCorporateEntity] [Existing] ON
			[Existing].[OriginatingRegionCorporateEntityId] = [Source].[OriginatingRegionCorporateEntityId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotOriginatingRegionPropertyDepartment]
		([SnapshotId]
		,[OriginatingRegionPropertyDepartmentId]
		,[GlobalRegionId]
		,[PropertyDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[OriginatingRegionPropertyDepartmentId]
		,[Source].[GlobalRegionId]
		,[Source].[PropertyDepartmentCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[OriginatingRegionPropertyDepartment] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotOriginatingRegionPropertyDepartment] [Existing] ON
			[Existing].[OriginatingRegionPropertyDepartmentId] = [Source].[OriginatingRegionPropertyDepartmentId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotRegionalAdministratorGlobalSubRegion]
		([SnapshotId]
		,[StaffId]
		,[GlobalRegionId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[StaffId]
		,[Source].[GlobalRegionId]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[RegionalAdministratorGlobalSubRegion] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotRegionalAdministratorGlobalSubRegion] [Existing] ON
			[Existing].[StaffId] = [Source].[StaffId] AND
			[Existing].[GlobalRegionId] = [Source].[GlobalRegionId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotRelatedFund]
		([SnapshotId]
		,[RelatedFundId]
		,[Name]
		,[AbbreviatedName]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[RelatedFundId]
		,[Source].[Name]
		,[Source].[AbbreviatedName]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[RelatedFund] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotRelatedFund] [Existing] ON
			[Existing].[RelatedFundId] = [Source].[RelatedFundId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotEntityType]
		([SnapshotId]
		,[EntityTypeId]
		,[Name]
		,[ProjectCodePortion]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[EntityTypeId]
		,[Source].[Name]
		,[Source].[ProjectCodePortion]
		,[Source].[Description]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[EntityType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotEntityType] [Existing] ON
			[Existing].[EntityTypeId] = [Source].[EntityTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyFund]
		([SnapshotId]
		,[PropertyFundId]
		,[RelatedFundId]
		,[EntityTypeId]
		,[AllocationSubRegionGlobalRegionId]
		,[BudgetOwnerStaffId]
		,[RegionalOwnerStaffId]
		,[DefaultGLTranslationSubTypeId]
		,[Name]
		,[IsReportingEntity]
		,[IsPropertyFund]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyFundId]
		,[Source].[RelatedFundId]
		,[Source].[EntityTypeId]
		,[Source].[AllocationSubRegionGlobalRegionId]
		,[Source].[BudgetOwnerStaffId]
		,[Source].[RegionalOwnerStaffId]
		,[Source].[DefaultGLTranslationSubTypeId]
		,[Source].[Name]
		,[Source].[IsReportingEntity]
		,[Source].[IsPropertyFund]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[PropertyFund] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotPropertyFund] [Existing] ON
			[Existing].[PropertyFundId] = [Source].[PropertyFundId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotReportingEntityCorporateDepartment]
		([SnapshotId]
		,[ReportingEntityCorporateDepartmentId]
		,[PropertyFundId]
		,[SourceCode]
		,[CorporateDepartmentCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDeleted])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ReportingEntityCorporateDepartmentId]
		,[Source].[PropertyFundId]
		,[Source].[SourceCode]
		,[Source].[CorporateDepartmentCode]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[IsDeleted]
	FROM 
		[dbo].[ReportingEntityCorporateDepartment] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotReportingEntityCorporateDepartment] [Existing] ON
			[Existing].[ReportingEntityCorporateDepartmentId] = [Source].[ReportingEntityCorporateDepartmentId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotReportingEntityPropertyEntity]
		([SnapshotId]
		,[ReportingEntityPropertyEntityId]
		,[PropertyFundId]
		,[SourceCode]
		,[PropertyEntityCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDeleted])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ReportingEntityPropertyEntityId]
		,[Source].[PropertyFundId]
		,[Source].[SourceCode]
		,[Source].[PropertyEntityCode]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[IsDeleted]
	FROM 
		[dbo].[ReportingEntityPropertyEntity] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotReportingEntityPropertyEntity] [Existing] ON
			[Existing].[ReportingEntityPropertyEntityId] = [Source].[ReportingEntityPropertyEntityId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyFundDisplayName]
		([SnapshotId]
		,[PropertyFundDisplayNameId]
		,[PropertyFundId]
		,[DisplayName]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyFundDisplayNameId]
		,[Source].[PropertyFundId]
		,[Source].[DisplayName]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[PropertyFundDisplayName] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotPropertyFundDisplayName] [Existing] ON
			[Existing].[PropertyFundDisplayNameId] = [Source].[PropertyFundDisplayNameId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyFundBudgetCoordinator]
		([SnapshotId]
		,[PropertyFundBudgetCoordinatorId]
		,[PropertyFundId]
		,[BudgetCoordinatorStaffId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyFundBudgetCoordinatorId]
		,[Source].[PropertyFundId]
		,[Source].[BudgetCoordinatorStaffId]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[PropertyFundBudgetCoordinator] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotPropertyFundBudgetCoordinator] [Existing] ON
			[Existing].[PropertyFundBudgetCoordinatorId] = [Source].[PropertyFundBudgetCoordinatorId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotManageType]
		([SnapshotId]
		,[ManageTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ManageTypeId]
		,[Source].[Code]
		,[Source].[Name]
		,[Source].[Description]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[ManageType] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotManageType] [Existing] ON
			[Existing].[ManageTypeId] = [Source].[ManageTypeId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotManageCorporateDepartment]
		([SnapshotId]
		,[ManageCorporateDepartmentId]
		,[ManageTypeId]
		,[CorporateDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ManageCorporateDepartmentId]
		,[Source].[ManageTypeId]
		,[Source].[CorporateDepartmentCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[ManageCorporateDepartment] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotManageCorporateDepartment] [Existing] ON
			[Existing].[ManageCorporateDepartmentId] = [Source].[ManageCorporateDepartmentId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotManageCorporateEntity]
		([SnapshotId]
		,[ManageCorporateEntityId]
		,[ManageTypeId]
		,[CorporateEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ManageCorporateEntityId]
		,[Source].[ManageTypeId]
		,[Source].[CorporateEntityCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[ManageCorporateEntity] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotManageCorporateEntity] [Existing] ON
			[Existing].[ManageCorporateEntityId] = [Source].[ManageCorporateEntityId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotManagePropertyDepartment]
		([SnapshotId]
		,[ManagePropertyDepartmentId]
		,[ManageTypeId]
		,[PropertyDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ManagePropertyDepartmentId]
		,[Source].[ManageTypeId]
		,[Source].[PropertyDepartmentCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[ManagePropertyDepartment] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotManagePropertyDepartment] [Existing] ON
			[Existing].[ManagePropertyDepartmentId] = [Source].[ManagePropertyDepartmentId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotManagePropertyEntity]
		([SnapshotId]
		,[ManagePropertyEntityId]
		,[ManageTypeId]
		,[PropertyEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ManagePropertyEntityId]
		,[Source].[ManageTypeId]
		,[Source].[PropertyEntityCode]
		,[Source].[SourceCode]
		,[Source].[IsDeleted]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[ManagePropertyEntity] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotManagePropertyEntity] [Existing] ON
			[Existing].[ManagePropertyEntityId] = [Source].[ManagePropertyEntityId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

	INSERT INTO [dbo].[SnapshotPropertyFundMapping]
		([SnapshotId]
		,[PropertyFundMappingId]
		,[PropertyFundId]
		,[SourceCode]
		,[PropertyFundCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[IsDeleted]
		,[ActivityTypeId])    
	SELECT 
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[PropertyFundMappingId]
		,[Source].[PropertyFundId]
		,[Source].[SourceCode]
		,[Source].[PropertyFundCode]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[IsDeleted]
		,[Source].[ActivityTypeId]
	FROM 
		[GR].[PRopertyFundMapping] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotPropertyFundMapping] [Existing] ON
			[Existing].[PropertyFundMappingId] = [Source].[PropertyFundMappingId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

-- Insert BusinessLine and ActivityTypeBusinessLine snapshot data (GRP CC10)

	INSERT INTO [dbo].[SnapshotBusinessLine]
		([SnapshotId]
		,[BusinessLineId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[BusinessLineId]
		,[Source].[Name]
		,[Source].[IsActive]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
	FROM 
		[dbo].[BusinessLine] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotBusinessLine] [Existing] ON
			[Existing].[BusinessLineId] = [Source].[BusinessLineId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)

INSERT INTO [dbo].[SnapshotActivityTypeBusinessLine]
		([SnapshotId]
		,[ActivityTypeBusinessLineId]
		,[ActivityTypeId]
		,[BusinessLineId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsActive])
	SELECT
		[dbo].[Snapshot].[SnapshotId]
		,[Source].[ActivityTypeBusinessLineId]
		,[Source].[ActivityTypeId]
		,[Source].[BusinessLineId]
		,[Source].[InsertedDate]
		,[Source].[UpdatedDate]
		,[Source].[UpdatedByStaffId]
		,[Source].[IsActive]
	FROM 
		[dbo].[ActivityTypeBusinessLine] [Source]
		CROSS JOIN [dbo].[Snapshot]
		LEFT OUTER JOIN [dbo].[SnapshotActivityTypeBusinessLine] [Existing] ON
			[Existing].[ActivityTypeBusinessLineId] = [Source].[ActivityTypeBusinessLineId] AND
			[Existing].[SnapshotId] = [dbo].[Snapshot].[SnapshotId]
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
		[Existing].[SnapshotId] IS NULL
	OPTION (MAXDOP 1)


	IF EXISTS(SELECT * FROM dbo.[Snapshot] WHERE (@SnapshotId IS NULL OR [SnapshotId] = @SnapshotId) AND LastSyncDate IS NOT NULL)
	BEGIN

		UPDATE [Existing] SET
			[PropertyGLAccountCode] = [Source].[PropertyGLAccountCode]
			,[GLGlobalAccountId] = [Source].[GLGlobalAccountId]		
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[SourceCode] = [Source].[SourceCode]
		FROM 
			[dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[FeePropertyGLAccountGLGlobalAccountId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[FeePropertyGLAccountGLGlobalAccountId]
						,[Existing].[PropertyGLAccountCode]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[SourceCode]
					FROM 
						[dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON 
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION 
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[FeePropertyGLAccountGLGlobalAccountId]
						,[Source].[PropertyGLAccountCode]
						,[Source].[GLGlobalAccountId]		
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[SourceCode]
					FROM
						[GBS].[FeePropertyGLAccountGLGlobalAccount] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[FeePropertyGLAccountGLGlobalAccountId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[FeePropertyGLAccountGLGlobalAccountId] = [Existing].[FeePropertyGLAccountGLGlobalAccountId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GBS].[FeePropertyGLAccountGLGlobalAccount] [Source] ON
				[Source].[FeePropertyGLAccountGLGlobalAccountId] = [Existing].[FeePropertyGLAccountGLGlobalAccountId]			
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLMinorCategoryId] = [Source].[GLMinorCategoryId]
			,[PayrollTypeId] = [Source].[PayrollTypeId]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM   
			[dbo].[SnapshotGLMinorCategoryPayrollType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLMinorCategoryPayrollTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLMinorCategoryPayrollTypeId]
						,[Existing].[GLMinorCategoryId]
						,[Existing].[PayrollTypeId]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM
						[dbo].[SnapshotGLMinorCategoryPayrollType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLMinorCategoryPayrollTypeId]
						,[Source].[GLMinorCategoryId]
						,[Source].[PayrollTypeId]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[GBS].[GLMinorCategoryPayrollType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLMinorCategoryPayrollTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLMinorCategoryPayrollTypeId] = [Existing].[GLMinorCategoryPayrollTypeId] AND			
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GBS].[GLMinorCategoryPayrollType] [Source] ON
				[Source].[GLMinorCategoryPayrollTypeId] = [Existing].[GLMinorCategoryPayrollTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[SourceCode] = [Source].[SourceCode]
			,[PropertyEntityCode] = [Source].[PropertyEntityCode]
			,[GLGlobalAccountId] = [Source].[GLGlobalAccountId]
			,[PropertyBudgetTypeId] = [Source].[PropertyBudgetTypeId]
			,[PropertyGLAccountCode] = [Source].[PropertyGLAccountCode]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[IsDirectCost] = [Source].[IsDirectCost]
		FROM 
			[dbo].[SnapshotPropertyEntityException] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyEntityExceptionId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyEntityExceptionId]
						,[Existing].[SourceCode]
						,[Existing].[PropertyEntityCode]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[PropertyBudgetTypeId]
						,[Existing].[PropertyGLAccountCode]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[IsDirectCost]
					FROM 
						[dbo].[SnapshotPropertyEntityException] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyEntityExceptionId]
						,[Source].[SourceCode]
						,[Source].[PropertyEntityCode]
						,[Source].[GLGlobalAccountId]
						,[Source].[PropertyBudgetTypeId]
						,[Source].[PropertyGLAccountCode]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[IsDirectCost]
					FROM 
						[GBS].[PropertyEntityException] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyEntityExceptionId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyEntityExceptionId] = [Existing].[PropertyEntityExceptionId] AND			
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GBS].[PropertyEntityException] [Source] ON
				[Source].[PropertyEntityExceptionId] = [Existing].[PropertyEntityExceptionId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyGLAccountCode] = [Source].[PropertyGLAccountCode]
			,[GLGlobalAccountId] = [Source].[GLGlobalAccountId]
			,[PropertyBudgetTypeId] = [Source].[PropertyBudgetTypeId]
			,[SourceCode] = [Source].[SourceCode]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[IsDirectCost] = [Source].[IsDirectCost]
		FROM
			[dbo].[SnapshotPropertyGLAccountGLGlobalAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyGLAccountGLGlobalAccountId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyGLAccountGLGlobalAccountId]
						,[Existing].[PropertyGLAccountCode]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[PropertyBudgetTypeId]
						,[Existing].[SourceCode]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[IsDirectCost]
					FROM
						[dbo].[SnapshotPropertyGLAccountGLGlobalAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyGLAccountGLGlobalAccountId]
						,[Source].[PropertyGLAccountCode]
						,[Source].[GLGlobalAccountId]
						,[Source].[PropertyBudgetTypeId]
						,[Source].[SourceCode]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[IsDirectCost]
					FROM
						[GBS].[PropertyGLAccountGLGlobalAccount] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyGLAccountGLGlobalAccountId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyGLAccountGLGlobalAccountId] = [Existing].[PropertyGLAccountGLGlobalAccountId] AND			
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GBS].[PropertyGLAccountGLGlobalAccount]  [Source] ON
				[Source].[PropertyGLAccountGLGlobalAccountId] = [Existing].[PropertyGLAccountGLGlobalAccountId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyGLAccountCode] = [Source].[PropertyGLAccountCode]
			,[PropertyBudgetTypeId] = [Source].[PropertyBudgetTypeId]
			,[SourceCode] = [Source].[SourceCode]
			,[ActivityTypeId] = [Source].[ActivityTypeId]
			,[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM
			[dbo].[SnapshotPropertyOverheadPropertyGLAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyOverheadPropertyGLAccountId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyOverheadPropertyGLAccountId]
						,[Existing].[PropertyGLAccountCode]
						,[Existing].[PropertyBudgetTypeId]
						,[Existing].[SourceCode]
						,[Existing].[ActivityTypeId]
						,[Existing].[FunctionalDepartmentId]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM
						[dbo].[SnapshotPropertyOverheadPropertyGLAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyOverheadPropertyGLAccountId]
						,[Source].[PropertyGLAccountCode]
						,[Source].[PropertyBudgetTypeId]
						,[Source].[SourceCode]
						,[Source].[ActivityTypeId]
						,[Source].[FunctionalDepartmentId]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[GBS].[PropertyOverheadPropertyGLAccount] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyOverheadPropertyGLAccountId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyOverheadPropertyGLAccountId] = [Existing].[PropertyOverheadPropertyGLAccountId] AND			
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GBS].[PropertyOverheadPropertyGLAccount] [Source] ON
				[Source].[PropertyOverheadPropertyGLAccountId] = [Existing].[PropertyOverheadPropertyGLAccountId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyGLAccountCode] = [Source].[PropertyGLAccountCode]
			,[PropertyBudgetTypeId] = [Source].[PropertyBudgetTypeId]
			,[SourceCode] = [Source].[SourceCode]
			,[ActivityTypeId] = [Source].[ActivityTypeId]
			,[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[PayrollTypeId] = [Source].[PayrollTypeId]
		FROM
			[dbo].[SnapshotPropertyPayrollPropertyGLAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyPayrollPropertyGLAccountId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyPayrollPropertyGLAccountId]
						,[Existing].[PropertyGLAccountCode]
						,[Existing].[PropertyBudgetTypeId]
						,[Existing].[SourceCode]
						,[Existing].[ActivityTypeId]
						,[Existing].[FunctionalDepartmentId]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[PayrollTypeId]
					FROM
						[dbo].[SnapshotPropertyPayrollPropertyGLAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyPayrollPropertyGLAccountId]
						,[Source].[PropertyGLAccountCode]
						,[Source].[PropertyBudgetTypeId]
						,[Source].[SourceCode]
						,[Source].[ActivityTypeId]
						,[Source].[FunctionalDepartmentId]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[PayrollTypeId]
					FROM
						[GBS].[PropertyPayrollPropertyGLAccount] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyPayrollPropertyGLAccountId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyPayrollPropertyGLAccountId] = [Existing].[PropertyPayrollPropertyGLAccountId] AND			
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GBS].[PropertyPayrollPropertyGLAccount] [Source] ON
				[Source].[PropertyPayrollPropertyGLAccountId] = [Existing].[PropertyPayrollPropertyGLAccountId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Description] = [Source].[Description]
			,[LastDate] = [Source].[LastDate]
			,[MriUserID] = [Source].[MriUserID]
			,[IsActive] = [Source].[IsActive]
			,[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId]
			,[IsTsCost] = [Source].[IsTsCost]
		FROM
			[dbo].[SnapshotCorporateDepartment] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[Code]
					,[SourceCode]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[Code]
						,[Existing].[SourceCode]
						,[Existing].[Description]
						,[Existing].[LastDate]
						,[Existing].[MriUserID]
						,[Existing].[IsActive]
						,[Existing].[FunctionalDepartmentId]
						,[Existing].[IsTsCost]
					FROM
						[dbo].[SnapshotCorporateDepartment] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[Code]
						,[Source].[SourceCode]
						,[Source].[Description]
						,[Source].[LastDate]
						,[Source].[MriUserID]
						,[Source].[IsActive]
						,[Source].[FunctionalDepartmentId]
						,[Source].[IsTsCost]
					FROM 
						[dbo].[CorporateDepartment] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[Code]
					,[SourceCode]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[Code] = [Existing].[Code] AND
					[Changed].[SourceCode] = [Existing].[SourceCode] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[CorporateDepartment] [Source] ON
				[Source].[Code] = [Existing].[Code] AND
				[Source].[SourceCode] = [Existing].[SourceCode]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[CityID] = [Source].[CityID]
			,[Name] = [Source].[Name]
			,[DisplayName] = [Source].[DisplayName]
			,[CurrencyCode] = [Source].[CurrencyCode]
			,[IsActive] = [Source].[IsActive]
			,[IsCustom] = [Source].[IsCustom]
			,[Address] = [Source].[Address]
			,[IsFund] = [Source].[IsFund]
			,[ShippingAddress] = [Source].[ShippingAddress]
			,[BillingAddress] = [Source].[BillingAddress]
			,[ProjectRef] = [Source].[ProjectRef]
			,[IsOutsourced] = [Source].[IsOutsourced]
			,[IsRMProperty] = [Source].[IsRMProperty]
			,[IsHistoric] = [Source].[IsHistoric]
		FROM
			[dbo].[SnapshotCorporateEntity] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[Code]
					,[SourceCode]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[Code]
						,[Existing].[SourceCode]
						,[Existing].[CityID]
						,[Existing].[Name]
						,[Existing].[DisplayName]
						,[Existing].[CurrencyCode]
						,[Existing].[IsActive]
						,[Existing].[IsCustom]
						,[Existing].[Address]
						,[Existing].[IsFund]
						,[Existing].[ShippingAddress]
						,[Existing].[BillingAddress]
						,[Existing].[ProjectRef]
						,[Existing].[IsOutsourced]
						,[Existing].[IsRMProperty]
						,[Existing].[IsHistoric]	
					FROM
						[dbo].[SnapshotCorporateEntity] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[Code]
						,[Source].[SourceCode]
						,[Source].[CityID]
						,[Source].[Name]
						,[Source].[DisplayName]
						,[Source].[CurrencyCode]
						,[Source].[IsActive]
						,[Source].[IsCustom]
						,[Source].[Address]
						,[Source].[IsFund]
						,[Source].[ShippingAddress]
						,[Source].[BillingAddress]
						,[Source].[ProjectRef]
						,[Source].[IsOutsourced]
						,[Source].[IsRMProperty]
						,[Source].[IsHistoric]	
					FROM 
						[dbo].[CorporateEntity] [Source]
						CROSS JOIN [dbo].[Snapshot] 
						) [Compare]
					WHERE
						((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
					GROUP BY
						[SnapshotId]
						,[Code]
						,[SourceCode]
					HAVING
						COUNT(*) > 1
				) [Changed] ON
					[Changed].[Code] = [Existing].[Code] AND
					[Changed].[SourceCode] = [Existing].[SourceCode] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[CorporateEntity] [Source] ON
				[Source].[Code] = [Existing].[Code] AND
				[Source].[SourceCode] = [Existing].[SourceCode]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[JobType] = [Source].[JobType]
			,[Description] = [Source].[Description]
			,[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId]
			,[IsActive] = [Source].[IsActive]
			,[StartDate] = [Source].[StartDate]
			,[EndDate] = [Source].[EndDate]
		FROM
			[dbo].[SnapshotCorporateJobCode] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[Code]
					,[SourceCode]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[Code]
						,[Existing].[SourceCode]
						,[Existing].[JobType]
						,[Existing].[Description]
						,[Existing].[FunctionalDepartmentId]
						,[Existing].[IsActive]
						,[Existing].[StartDate]
						,[Existing].[EndDate]
					FROM
						[dbo].[SnapshotCorporateJobCode] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[Code]
						,[Source].[SourceCode]
						,[Source].[JobType]
						,[Source].[Description]
						,[Source].[FunctionalDepartmentId]
						,[Source].[IsActive]
						,[Source].[StartDate]
						,[Source].[EndDate]
					FROM 
						[dbo].[CorporateJobCode] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[Code]
					,[SourceCode]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[Code] = [Existing].[Code] AND
					[Changed].[SourceCode] = [Existing].[SourceCode] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[CorporateJobCode] [Source] ON
				[Source].[Code] = [Existing].[Code] AND
				[Source].[SourceCode] = [Existing].[SourceCode]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId]
			,[Name] = [Source].[Name]
			,[Code] = [Source].[Code]
			,[GlobalCode] = [Source].[GlobalCode]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[NuViewId] = [Source].[NuViewId]
		FROM 
			[dbo].[SnapshotFunctionalDepartment] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[FunctionalDepartmentId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[FunctionalDepartmentId]
						,[Existing].[Name]
						,[Existing].[Code]
						,[Existing].[GlobalCode]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[NuViewId]
					FROM 
						[dbo].[SnapshotFunctionalDepartment] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[FunctionalDepartmentId]
						,[Source].[Name]
						,[Source].[Code]
						,[Source].[GlobalCode]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[NuViewId]
					FROM 
						[dbo].[FunctionalDepartment] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[FunctionalDepartmentId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[FunctionalDepartmentId] = [Existing].[FunctionalDepartmentId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[FunctionalDepartment] [Source] ON
				[Source].[FunctionalDepartmentId] = [Existing].[FunctionalDepartmentId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Name] = [Source].[Name]
			,[Type] = [Source].[Type]
			,[IsHistoric] = [Source].[IsHistoric]
			,[IsGR] = [Source].[IsGR]
			,[IsActive] = [Source].[IsActive]
			,[UpdatedDate] = [Source].[UpdatedDate]
		FROM 
			[dbo].[SnapshotGLAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[Code]
					,[SourceCode]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[Code]
						,[Existing].[SourceCode]
						,[Existing].[Name]
						,[Existing].[Type]
						,[Existing].[IsHistoric]
						,[Existing].[IsGR]
						,[Existing].[IsActive]
						,[Existing].[UpdatedDate]
					FROM 
						[dbo].[SnapshotGLAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[Code]
						,[Source].[SourceCode]
						,[Source].[Name]
						,[Source].[Type]
						,[Source].[IsHistoric]
						,[Source].[IsGR]
						,[Source].[IsActive]
						,[Source].[UpdatedDate]
					FROM 
						[dbo].[GLAccount] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[Code]
					,[SourceCode]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[Code] = [Existing].[Code] AND
					[Changed].[SourceCode] = [Existing].[SourceCode] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLAccount] [Source] ON
				[Source].[Code] = [Existing].[Code] AND
				[Source].[SourceCode] = [Existing].[SourceCode]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[RegionId] = [Source].[RegionId]
			,[ExternalSubRegionId] = [Source].[ExternalSubRegionId]
			,[CorporateEntityRef] = [Source].[CorporateEntityRef]
			,[CorporateSourceCode] = [Source].[CorporateSourceCode]	
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotPayrollRegion] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PayrollRegionId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PayrollRegionId]
						,[Existing].[RegionId]
						,[Existing].[ExternalSubRegionId]
						,[Existing].[CorporateEntityRef]
						,[Existing].[CorporateSourceCode]		
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotPayrollRegion] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PayrollRegionId]
						,[Source].[RegionId]
						,[Source].[ExternalSubRegionId]
						,[Source].[CorporateEntityRef]
						,[Source].[CorporateSourceCode]		
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[TAPASB].[PayrollRegion] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PayrollRegionId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PayrollRegionId] = [Existing].[PayrollRegionId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [TAPASB].[PayrollRegion] [Source] ON
				[Source].[PayrollRegionId] = [Existing].[PayrollRegionId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[RegionId] = [Source].[RegionId]
			,[CorporateEntityRef] = [Source].[CorporateEntityRef]
			,[CorporateSourceCode] = [Source].[CorporateSourceCode]
			,[Name] = [Source].[Name]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotOverheadRegion] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[OverheadRegionId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[OverheadRegionId]
						,[Existing].[RegionId]
						,[Existing].[CorporateEntityRef]
						,[Existing].[CorporateSourceCode]
						,[Existing].[Name]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotOverheadRegion] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[OverheadRegionId]
						,[Source].[RegionId]
						,[Source].[CorporateEntityRef]
						,[Source].[CorporateSourceCode]
						,[Source].[Name]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[SnapshotOverheadRegion] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[OverheadRegionId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[OverheadRegionId] = [Existing].[OverheadRegionId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [TAPASB].[OverheadRegion] [Source] ON
				[Source].[OverheadRegionId] = [Existing].[OverheadRegionId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyEntityCode] = [Source].[PropertyEntityCode]
			,[GLAccountCode] = [Source].[GLAccountCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotPropertyEntityGLAccountInclusion] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyEntityGLAccountInclusionId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyEntityGLAccountInclusionId]
						,[Existing].[PropertyEntityCode]
						,[Existing].[GLAccountCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotPropertyEntityGLAccountInclusion] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyEntityGLAccountInclusionId]
						,[Source].[PropertyEntityCode]
						,[Source].[GLAccountCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[PropertyEntityGLAccountInclusion] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyEntityGLAccountInclusionId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyEntityGLAccountInclusionId] = [Existing].[PropertyEntityGLAccountInclusionId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[PropertyEntityGLAccountInclusion] [Source] ON
				[Source].[PropertyEntityGLAccountInclusionId] = [Existing].[PropertyEntityGLAccountInclusionId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[CorporateDepartmentCode] = [Source].[CorporateDepartmentCode]
			,[CorporateDepartmentSourceCode] = [Source].[CorporateDepartmentSourceCode]
			,[PropertyEntityCode] = [Source].[PropertyEntityCode]
			,[PropertyEntitySourceCode] = [Source].[PropertyEntitySourceCode]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[RechargeCorporateDepartmentPropertyEntityId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[RechargeCorporateDepartmentPropertyEntityId]
						,[Existing].[CorporateDepartmentCode]
						,[Existing].[CorporateDepartmentSourceCode]
						,[Existing].[PropertyEntityCode]
						,[Existing].[PropertyEntitySourceCode]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[RechargeCorporateDepartmentPropertyEntityId]
						,[Source].[CorporateDepartmentCode]
						,[Source].[CorporateDepartmentSourceCode]
						,[Source].[PropertyEntityCode]
						,[Source].[PropertyEntitySourceCode]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[RechargeCorporateDepartmentPropertyEntity] [Source]
						CROSS JOIN [dbo].[Snapshot] 
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[RechargeCorporateDepartmentPropertyEntityId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[RechargeCorporateDepartmentPropertyEntityId] = [Existing].[RechargeCorporateDepartmentPropertyEntityId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[RechargeCorporateDepartmentPropertyEntity] [Source] ON
				[Source].[RechargeCorporateDepartmentPropertyEntityId] = [Existing].[RechargeCorporateDepartmentPropertyEntityId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[Description] = [Source].[Description]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLTranslationType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLTranslationTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLTranslationTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[Description]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLTranslationType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLTranslationTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[Description]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLTranslationType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLTranslationTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLTranslationTypeId] = [Existing].[GLTranslationTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLTranslationType] [Source] ON
				[Source].[GLTranslationTypeId] = [Existing].[GLTranslationTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLTranslationTypeId] = [Source].[GLTranslationTypeId]
			,[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[IsGRDefault] = [Source].[IsGRDefault]
		FROM 
			[dbo].[SnapshotGLTranslationSubType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLTranslationSubTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLTranslationSubTypeId]
						,[Existing].[GLTranslationTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[IsGRDefault]
					FROM 
						[dbo].[SnapshotGLTranslationSubType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLTranslationSubTypeId]
						,[Source].[GLTranslationTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[IsGRDefault]
					FROM 
						[dbo].[GLTranslationSubType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLTranslationSubTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLTranslationSubTypeId] = [Existing].[GLTranslationSubTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLTranslationSubType] [Source] ON
				[Source].[GLTranslationSubTypeId] = [Existing].[GLTranslationSubTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLTranslationTypeId] = [Source].[GLTranslationTypeId]
			,[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLAccountType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLAccountTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLAccountTypeId]
						,[Existing].[GLTranslationTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLAccountType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLAccountTypeId]
						,[Source].[GLTranslationTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLAccountType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLAccountTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLAccountTypeId] = [Existing].[GLAccountTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLAccountType] [Source] ON
				[Source].[GLAccountTypeId] = [Existing].[GLAccountTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLTranslationTypeId] = [Source].[GLTranslationTypeId]
			,[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLAccountSubType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLAccountSubTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLAccountSubTypeId]
						,[Existing].[GLTranslationTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLAccountSubType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLAccountSubTypeId]
						,[Source].[GLTranslationTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLAccountSubType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLAccountSubTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLAccountSubTypeId] = [Existing].[GLAccountSubTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLAccountSubType] [Source] ON
				[Source].[GLAccountSubTypeId] = [Existing].[GLAccountSubTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLTranslationSubTypeId] = [Source].[GLTranslationSubTypeId]
			,[Name] = [Source].[Name]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLMajorCategory] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLMajorCategoryId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLMajorCategoryId]
						,[Existing].[GLTranslationSubTypeId]
						,[Existing].[Name]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLMajorCategory] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLMajorCategoryId]
						,[Source].[GLTranslationSubTypeId]
						,[Source].[Name]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLMajorCategory] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLMajorCategoryId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLMajorCategoryId] = [Existing].[GLMajorCategoryId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLMajorCategory] [Source] ON
				[Source].[GLMajorCategoryId] = [Existing].[GLMajorCategoryId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLMajorCategoryId] = [Source].[GLMajorCategoryId]
			,[Name] = [Source].[Name]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId] 
		FROM 
			[dbo].[SnapshotGLMinorCategory] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLMinorCategoryId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLMinorCategoryId]
						,[Existing].[GLMajorCategoryId]
						,[Existing].[Name]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLMinorCategory] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLMinorCategoryId]
						,[Source].[GLMajorCategoryId]
						,[Source].[Name]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLMinorCategory] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLMinorCategoryId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLMinorCategoryId] = [Existing].[GLMinorCategoryId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLMinorCategory] [Source] ON
				[Source].[GLMinorCategoryId] = [Existing].[GLMinorCategoryId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[Description] = [Source].[Description]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLStatutoryType] [Existing]
			INNER JOIN (
					SELECT
						[SnapshotId]
						,[GLStatutoryTypeId]
					FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLStatutoryTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[Description]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLStatutoryType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLStatutoryTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[Description]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLStatutoryType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLStatutoryTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLStatutoryTypeId] = [Existing].[GLStatutoryTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLStatutoryType] [Source] ON
				[Source].[GLStatutoryTypeId] = [Existing].[GLStatutoryTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[GLAccountSuffix] = [Source].[GLAccountSuffix]
			,[IsEscalatable] = [Source].[IsEscalatable]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotActivityType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ActivityTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ActivityTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[GLAccountSuffix]
						,[Existing].[IsEscalatable]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotActivityType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ActivityTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[GLAccountSuffix]
						,[Source].[IsEscalatable]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[ActivityType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ActivityTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ActivityTypeId] = [Existing].[ActivityTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ActivityType] [Source] ON
				[Source].[ActivityTypeId] = [Existing].[ActivityTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[ActivityTypeId] = [Source].[ActivityTypeId]
			,[GLStatutoryTypeId] = [Source].[GLStatutoryTypeId]
			,[ParentGLGlobalAccountId] = [Source].[ParentGLGlobalAccountId]
			,[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[Description] = [Source].[Description]
			,[IsGR] = [Source].[IsGR]
			,[IsGbs] = [Source].[IsGbs]
			,[IsRegionalOverheadCost] = [Source].[IsRegionalOverheadCost]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[ExpenseCzarStaffId] = [Source].[ExpenseCzarStaffId]
		FROM 
			[dbo].[SnapshotGLGlobalAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLGlobalAccountId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[ActivityTypeId]
						,[Existing].[GLStatutoryTypeId]
						,[Existing].[ParentGLGlobalAccountId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[Description]
						,[Existing].[IsGR]
						,[Existing].[IsGbs]
						,[Existing].[IsRegionalOverheadCost]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[ExpenseCzarStaffId]
					FROM 
						[dbo].[SnapshotGLGlobalAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLGlobalAccountId]
						,[Source].[ActivityTypeId]
						,[Source].[GLStatutoryTypeId]
						,[Source].[ParentGLGlobalAccountId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[Description]
						,[Source].[IsGR]
						,[Source].[IsGbs]
						,[Source].[IsRegionalOverheadCost]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[ExpenseCzarStaffId]
					FROM 
						[dbo].[GLGlobalAccount] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLGlobalAccountId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLGlobalAccountId] = [Existing].[GLGlobalAccountId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLGlobalAccount] [Source] ON
				[Source].[GLGlobalAccountId] = [Existing].[GLGlobalAccountId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLGlobalAccountId] = [Source].[GLGlobalAccountId]
			,[SourceCode] = [Source].[SourceCode]
			,[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[Description] = [Source].[Description]
			,[PreGlobalAccountCode] = [Source].[PreGlobalAccountCode]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLGlobalAccountGLAccount] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLGlobalAccountGLAccountId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLGlobalAccountGLAccountId]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[SourceCode]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[Description]
						,[Existing].[PreGlobalAccountCode]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLGlobalAccountGLAccount] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLGlobalAccountGLAccountId]
						,[Source].[GLGlobalAccountId]
						,[Source].[SourceCode]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[Description]
						,[Source].[PreGlobalAccountCode]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLGlobalAccountGLAccount] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLGlobalAccountGLAccountId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLGlobalAccountGLAccountId] = [Existing].[GLGlobalAccountGLAccountId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLGlobalAccountGLAccount] [Source] ON
				[Source].[GLGlobalAccountGLAccountId] = [Existing].[GLGlobalAccountGLAccountId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLGlobalAccountId] = [Source].[GLGlobalAccountId]
			,[GLTranslationTypeId] = [Source].[GLTranslationTypeId]
			,[GLAccountTypeId] = [Source].[GLAccountTypeId]
			,[GLAccountSubTypeId] = [Source].[GLAccountSubTypeId]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLGlobalAccountTranslationType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLGlobalAccountTranslationTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLGlobalAccountTranslationTypeId]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[GLTranslationTypeId]
						,[Existing].[GLAccountTypeId]
						,[Existing].[GLAccountSubTypeId]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLGlobalAccountTranslationType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLGlobalAccountTranslationTypeId]
						,[Source].[GLGlobalAccountId]
						,[Source].[GLTranslationTypeId]
						,[Source].[GLAccountTypeId]
						,[Source].[GLAccountSubTypeId]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLGlobalAccountTranslationType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLGlobalAccountTranslationTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLGlobalAccountTranslationTypeId] = [Existing].[GLGlobalAccountTranslationTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GLGlobalAccountTranslationType] [Source] ON
				[Source].[GLGlobalAccountTranslationTypeId] = [Existing].[GLGlobalAccountTranslationTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GLGlobalAccountId] = [Source].[GLGlobalAccountId]
			,[GLTranslationSubTypeId] = [Source].[GLTranslationSubTypeId]
			,[GLMinorCategoryId] = [Source].[GLMinorCategoryId]
			,[PostingPropertyGLAccountCode] = [Source].[PostingPropertyGLAccountCode]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGLGlobalAccountTranslationSubType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GLGlobalAccountTranslationSubTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GLGlobalAccountTranslationSubTypeId]
						,[Existing].[GLGlobalAccountId]
						,[Existing].[GLTranslationSubTypeId]
						,[Existing].[GLMinorCategoryId]
						,[Existing].[PostingPropertyGLAccountCode]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGLGlobalAccountTranslationSubType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GLGlobalAccountTranslationSubTypeId]
						,[Source].[GLGlobalAccountId]
						,[Source].[GLTranslationSubTypeId]
						,[Source].[GLMinorCategoryId]
						,[Source].[PostingPropertyGLAccountCode]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GLGlobalAccountTranslationSubType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GLGlobalAccountTranslationSubTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GLGlobalAccountTranslationSubTypeId] = [Existing].[GLGlobalAccountTranslationSubTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
  			INNER JOIN [dbo].[GLGlobalAccountTranslationSubType] [Source] ON
				[Source].[GLGlobalAccountTranslationSubTypeId] = [Existing].[GLGlobalAccountTranslationSubTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[ParentGlobalRegionId] = [Source].[ParentGlobalRegionId]
			,[CountryId] = [Source].[CountryId]
			,[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[IsAllocationRegion] = [Source].[IsAllocationRegion]
			,[IsOriginatingRegion] = [Source].[IsOriginatingRegion]
			,[DefaultCurrencyCode] = [Source].[DefaultCurrencyCode]
			,[DefaultCorporateSourceCode] = [Source].[DefaultCorporateSourceCode]
			,[ProjectCodePortion] = [Source].[ProjectCodePortion]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotGlobalRegion] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[GlobalRegionId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[GlobalRegionId]
						,[Existing].[ParentGlobalRegionId]
						,[Existing].[CountryId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[IsAllocationRegion]
						,[Existing].[IsOriginatingRegion]
						,[Existing].[DefaultCurrencyCode]
						,[Existing].[DefaultCorporateSourceCode]
						,[Existing].[ProjectCodePortion]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotGlobalRegion] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[GlobalRegionId]
						,[Source].[ParentGlobalRegionId]
						,[Source].[CountryId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[IsAllocationRegion]
						,[Source].[IsOriginatingRegion]
						,[Source].[DefaultCurrencyCode]
						,[Source].[DefaultCorporateSourceCode]
						,[Source].[ProjectCodePortion]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[GlobalRegion] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[GlobalRegionId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[GlobalRegionId] = [Existing].[GlobalRegionId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[GlobalRegion] [Source] ON
				[Source].[GlobalRegionId] = [Existing].[GlobalRegionId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GlobalRegionId] = [Source].[GlobalRegionId]
			,[CorporateEntityCode] = [Source].[CorporateEntityCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotOriginatingRegionCorporateEntity] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[OriginatingRegionCorporateEntityId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[OriginatingRegionCorporateEntityId]
						,[Existing].[GlobalRegionId]
						,[Existing].[CorporateEntityCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotOriginatingRegionCorporateEntity] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[OriginatingRegionCorporateEntityId]
						,[Source].[GlobalRegionId]
						,[Source].[CorporateEntityCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[OriginatingRegionCorporateEntity] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[OriginatingRegionCorporateEntityId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[OriginatingRegionCorporateEntityId] = [Existing].[OriginatingRegionCorporateEntityId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[OriginatingRegionCorporateEntity] [Source] ON
				[Source].[OriginatingRegionCorporateEntityId] = [Existing].[OriginatingRegionCorporateEntityId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[GlobalRegionId] = [Source].[GlobalRegionId]
			,[PropertyDepartmentCode] = [Source].[PropertyDepartmentCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotOriginatingRegionPropertyDepartment] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[OriginatingRegionPropertyDepartmentId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[OriginatingRegionPropertyDepartmentId]
						,[Existing].[GlobalRegionId]
						,[Existing].[PropertyDepartmentCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotOriginatingRegionPropertyDepartment] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[OriginatingRegionPropertyDepartmentId]
						,[Source].[GlobalRegionId]
						,[Source].[PropertyDepartmentCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[OriginatingRegionPropertyDepartment] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[OriginatingRegionPropertyDepartmentId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[OriginatingRegionPropertyDepartmentId] = [Existing].[OriginatingRegionPropertyDepartmentId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[OriginatingRegionPropertyDepartment] [Source] ON
				[Source].[OriginatingRegionPropertyDepartmentId] = [Existing].[OriginatingRegionPropertyDepartmentId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotRegionalAdministratorGlobalSubRegion] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[StaffId]
					,[GlobalRegionId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[StaffId]
						,[Existing].[GlobalRegionId]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotRegionalAdministratorGlobalSubRegion] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[StaffId]
						,[Source].[GlobalRegionId]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[RegionalAdministratorGlobalSubRegion] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[StaffId]
					,[GlobalRegionId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[StaffId] = [Existing].[StaffId] AND
					[Changed].[GlobalRegionId] = [Existing].[GlobalRegionId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[RegionalAdministratorGlobalSubRegion] [Source] ON
				[Source].[StaffId] = [Existing].[StaffId] AND
				[Source].[GlobalRegionId] = [Existing].[GlobalRegionId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Name] = [Source].[Name]
			,[AbbreviatedName] = [Source].[AbbreviatedName]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotRelatedFund] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[RelatedFundId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[RelatedFundId]
						,[Existing].[Name]
						,[Existing].[AbbreviatedName]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotRelatedFund] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[RelatedFundId]
						,[Source].[Name]
						,[Source].[AbbreviatedName]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[RelatedFund] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[RelatedFundId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[RelatedFundId] = [Existing].[RelatedFundId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[RelatedFund] [Source] ON
				[Source].[RelatedFundId] = [Existing].[RelatedFundId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Name] = [Source].[Name]
			,[ProjectCodePortion] = [Source].[ProjectCodePortion]
			,[Description] = [Source].[Description]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotEntityType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[EntityTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[EntityTypeId]
						,[Existing].[Name]
						,[Existing].[ProjectCodePortion]
						,[Existing].[Description]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotEntityType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[EntityTypeId]
						,[Source].[Name]
						,[Source].[ProjectCodePortion]
						,[Source].[Description]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[EntityType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[EntityTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[EntityTypeId] = [Existing].[EntityTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[EntityType] [Source] ON
				[Source].[EntityTypeId] = [Existing].[EntityTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[RelatedFundId] = [Source].[RelatedFundId]
			,[EntityTypeId] = [Source].[EntityTypeId]
			,[AllocationSubRegionGlobalRegionId] = [Source].[AllocationSubRegionGlobalRegionId]
			,[BudgetOwnerStaffId] = [Source].[BudgetOwnerStaffId]
			,[RegionalOwnerStaffId] = [Source].[RegionalOwnerStaffId]
			,[DefaultGLTranslationSubTypeId] = [Source].[DefaultGLTranslationSubTypeId]
			,[Name] = [Source].[Name]
			,[IsReportingEntity] = [Source].[IsReportingEntity]
			,[IsPropertyFund] = [Source].[IsPropertyFund]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotPropertyFund] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyFundId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyFundId]
						,[Existing].[RelatedFundId]
						,[Existing].[EntityTypeId]
						,[Existing].[AllocationSubRegionGlobalRegionId]
						,[Existing].[BudgetOwnerStaffId]
						,[Existing].[RegionalOwnerStaffId]
						,[Existing].[DefaultGLTranslationSubTypeId]
						,[Existing].[Name]
						,[Existing].[IsReportingEntity]
						,[Existing].[IsPropertyFund]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotPropertyFund] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyFundId]
						,[Source].[RelatedFundId]
						,[Source].[EntityTypeId]
						,[Source].[AllocationSubRegionGlobalRegionId]
						,[Source].[BudgetOwnerStaffId]
						,[Source].[RegionalOwnerStaffId]
						,[Source].[DefaultGLTranslationSubTypeId]
						,[Source].[Name]
						,[Source].[IsReportingEntity]
						,[Source].[IsPropertyFund]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[PropertyFund] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyFundId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyFundId] = [Existing].[PropertyFundId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[PropertyFund] [Source] ON
				[Source].[PropertyFundId] = [Existing].[PropertyFundId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyFundId] = [Source].[PropertyFundId]
			,[SourceCode] = [Source].[SourceCode]
			,[CorporateDepartmentCode] = [Source].[CorporateDepartmentCode]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[IsDeleted] = [Source].[IsDeleted]
		FROM 
			[dbo].[SnapshotReportingEntityCorporateDepartment] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ReportingEntityCorporateDepartmentId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ReportingEntityCorporateDepartmentId]
						,[Existing].[PropertyFundId]
						,[Existing].[SourceCode]
						,[Existing].[CorporateDepartmentCode]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[IsDeleted]
					FROM 
						[dbo].[SnapshotReportingEntityCorporateDepartment] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ReportingEntityCorporateDepartmentId]
						,[Source].[PropertyFundId]
						,[Source].[SourceCode]
						,[Source].[CorporateDepartmentCode]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[IsDeleted]
					FROM 
						[dbo].[ReportingEntityCorporateDepartment] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ReportingEntityCorporateDepartmentId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ReportingEntityCorporateDepartmentId] = [Existing].[ReportingEntityCorporateDepartmentId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ReportingEntityCorporateDepartment] [Source] ON
				[Source].[ReportingEntityCorporateDepartmentId] = [Existing].[ReportingEntityCorporateDepartmentId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyFundId] = [Source].[PropertyFundId]
			,[SourceCode] = [Source].[SourceCode]
			,[PropertyEntityCode] = [Source].[PropertyEntityCode]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[IsDeleted] = [Source].[IsDeleted]
		FROM 
			[dbo].[SnapshotReportingEntityPropertyEntity] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ReportingEntityPropertyEntityId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ReportingEntityPropertyEntityId]
						,[Existing].[PropertyFundId]
						,[Existing].[SourceCode]
						,[Existing].[PropertyEntityCode]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[IsDeleted]
					FROM 
						[dbo].[SnapshotReportingEntityPropertyEntity] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ReportingEntityPropertyEntityId]
						,[Source].[PropertyFundId]
						,[Source].[SourceCode]
						,[Source].[PropertyEntityCode]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[IsDeleted]
					FROM 
						[dbo].[ReportingEntityPropertyEntity] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ReportingEntityPropertyEntityId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ReportingEntityPropertyEntityId] = [Existing].[ReportingEntityPropertyEntityId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ReportingEntityPropertyEntity] [Source] ON
				[Source].[ReportingEntityPropertyEntityId] = [Existing].[ReportingEntityPropertyEntityId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyFundId] = [Source].[PropertyFundId]
			,[DisplayName] = [Source].[DisplayName]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotPropertyFundDisplayName] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyFundDisplayNameId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyFundDisplayNameId]
						,[Existing].[PropertyFundId]
						,[Existing].[DisplayName]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotPropertyFundDisplayName] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyFundDisplayNameId]
						,[Source].[PropertyFundId]
						,[Source].[DisplayName]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[PropertyFundDisplayName] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyFundDisplayNameId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyFundDisplayNameId] = [Existing].[PropertyFundDisplayNameId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[PropertyFundDisplayName] [Source] ON
				[Source].[PropertyFundDisplayNameId] = [Existing].[PropertyFundDisplayNameId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyFundId] = [Source].[PropertyFundId]
			,[BudgetCoordinatorStaffId] = [Source].[BudgetCoordinatorStaffId]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotPropertyFundBudgetCoordinator] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyFundBudgetCoordinatorId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyFundBudgetCoordinatorId]
						,[Existing].[PropertyFundId]
						,[Existing].[BudgetCoordinatorStaffId]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotPropertyFundBudgetCoordinator] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyFundBudgetCoordinatorId]
						,[Source].[PropertyFundId]
						,[Source].[BudgetCoordinatorStaffId]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[PropertyFundBudgetCoordinator] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyFundBudgetCoordinatorId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyFundBudgetCoordinatorId] = [Existing].[PropertyFundBudgetCoordinatorId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[PropertyFundBudgetCoordinator] [Source] ON
				[Source].[PropertyFundBudgetCoordinatorId] = [Existing].[PropertyFundBudgetCoordinatorId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[Code] = [Source].[Code]
			,[Name] = [Source].[Name]
			,[Description] = [Source].[Description]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotManageType] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ManageTypeId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ManageTypeId]
						,[Existing].[Code]
						,[Existing].[Name]
						,[Existing].[Description]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotManageType] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ManageTypeId]
						,[Source].[Code]
						,[Source].[Name]
						,[Source].[Description]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[ManageType] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ManageTypeId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ManageTypeId] = [Existing].[ManageTypeId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ManageType] [Source] ON
				[Source].[ManageTypeId] = [Existing].[ManageTypeId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[ManageTypeId] = [Source].[ManageTypeId]
			,[CorporateDepartmentCode] = [Source].[CorporateDepartmentCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotManageCorporateDepartment] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ManageCorporateDepartmentId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ManageCorporateDepartmentId]
						,[Existing].[ManageTypeId]
						,[Existing].[CorporateDepartmentCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotManageCorporateDepartment] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ManageCorporateDepartmentId]
						,[Source].[ManageTypeId]
						,[Source].[CorporateDepartmentCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[ManageCorporateDepartment] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ManageCorporateDepartmentId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ManageCorporateDepartmentId] = [Existing].[ManageCorporateDepartmentId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ManageCorporateDepartment] [Source] ON
				[Source].[ManageCorporateDepartmentId] = [Existing].[ManageCorporateDepartmentId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[ManageTypeId] = [Source].[ManageTypeId]
			,[CorporateEntityCode] = [Source].[CorporateEntityCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotManageCorporateEntity] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ManageCorporateEntityId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ManageCorporateEntityId]
						,[Existing].[ManageTypeId]
						,[Existing].[CorporateEntityCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotManageCorporateEntity] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ManageCorporateEntityId]
						,[Source].[ManageTypeId]
						,[Source].[CorporateEntityCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[ManageCorporateEntity] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ManageCorporateEntityId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ManageCorporateEntityId] = [Existing].[ManageCorporateEntityId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ManageCorporateEntity] [Source] ON
				[Source].[ManageCorporateEntityId] = [Existing].[ManageCorporateEntityId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[ManageTypeId] = [Source].[ManageTypeId]
			,[PropertyDepartmentCode] = [Source].[PropertyDepartmentCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotManagePropertyDepartment] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ManagePropertyDepartmentId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ManagePropertyDepartmentId]
						,[Existing].[ManageTypeId]
						,[Existing].[PropertyDepartmentCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotManagePropertyDepartment] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ManagePropertyDepartmentId]
						,[Source].[ManageTypeId]
						,[Source].[PropertyDepartmentCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[ManagePropertyDepartment] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ManagePropertyDepartmentId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ManagePropertyDepartmentId] = [Existing].[ManagePropertyDepartmentId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ManagePropertyDepartment] [Source] ON
				[Source].[ManagePropertyDepartmentId] = [Existing].[ManagePropertyDepartmentId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[ManageTypeId] = [Source].[ManageTypeId]
			,[PropertyEntityCode] = [Source].[PropertyEntityCode]
			,[SourceCode] = [Source].[SourceCode]
			,[IsDeleted] = [Source].[IsDeleted]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotManagePropertyEntity] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ManagePropertyEntityId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ManagePropertyEntityId]
						,[Existing].[ManageTypeId]
						,[Existing].[PropertyEntityCode]
						,[Existing].[SourceCode]
						,[Existing].[IsDeleted]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotManagePropertyEntity] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ManagePropertyEntityId]
						,[Source].[ManageTypeId]
						,[Source].[PropertyEntityCode]
						,[Source].[SourceCode]
						,[Source].[IsDeleted]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[ManagePropertyEntity] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ManagePropertyEntityId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ManagePropertyEntityId] = [Existing].[ManagePropertyEntityId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ManagePropertyEntity] [Source] ON
				[Source].[ManagePropertyEntityId] = [Existing].[ManagePropertyEntityId]
		OPTION (MAXDOP 1)

		UPDATE [Existing] SET
			[PropertyFundId] = [Source].[PropertyFundId]
			,[SourceCode] = [Source].[SourceCode]
			,[PropertyFundCode] = [Source].[PropertyFundCode]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[IsDeleted] = [Source].[IsDeleted]
			,[ActivityTypeId] = [Source].[ActivityTypeId]    
		FROM
			[dbo].[SnapshotPropertyFundMapping] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[PropertyFundMappingId]
				FROM (
					SELECT 
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[PropertyFundMappingId]
						,[Existing].[PropertyFundId]
						,[Existing].[SourceCode]
						,[Existing].[PropertyFundCode]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[IsDeleted]
						,[Existing].[ActivityTypeId]
					FROM
						[dbo].[SnapshotPropertyFundMapping] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT 
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[PropertyFundMappingId]
						,[Source].[PropertyFundId]
						,[Source].[SourceCode]
						,[Source].[PropertyFundCode]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[IsDeleted]
						,[Source].[ActivityTypeId]
					FROM 
						[GR].[PRopertyFundMapping] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[PropertyFundMappingId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[PropertyFundMappingId] = [Existing].[PropertyFundMappingId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [GR].[PRopertyFundMapping] [Source] ON
				[Source].[PropertyFundMappingId] = [Existing].[PropertyFundMappingId]
		OPTION (MAXDOP 1)

-- Update BusinessLine and ActivityTypeBusinessLine snapshot data (GRP CC10)

	UPDATE [Existing] SET
			,[Name] = [Source].[Name]
			,[IsActive] = [Source].[IsActive]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
		FROM 
			[dbo].[SnapshotBusinessLine] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[BusinessLineId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[BusinessLineId]
						,[Existing].[Name]
						,[Existing].[IsActive]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
					FROM 
						[dbo].[SnapshotBusinessLine] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[BusinessLineId]
						,[Source].[Name]
						,[Source].[IsActive]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
					FROM 
						[dbo].[BusinessLine] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[BusinessLineId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[BusinessLineId] = [Existing].[BusinessLineId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[BusinessLine] [Source] ON
				[Source].[BusinessLineId] = [Existing].[BusinessLineId]
		OPTION (MAXDOP 1)

UPDATE [Existing] SET
			[ActivityTypeId] = [Source].[ActivityTypeId]
			,[BusinessLineId] = [Source].[BusinessLineId]
			,[InsertedDate] = [Source].[InsertedDate]
			,[UpdatedDate] = [Source].[UpdatedDate]
			,[UpdatedByStaffId] = [Source].[UpdatedByStaffId]
			,[IsActive] = [Source].[IsActive]
		FROM 
			[dbo].[SnapshotActivityTypeBusinessLine] [Existing]
			INNER JOIN (
				SELECT
					[SnapshotId]
					,[ActivityTypeBusinessLineId]
				FROM (
					SELECT
						[Existing].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Existing].[ActivityTypeBusinessLineId]
						,[Existing].[ActivityTypeId]
						,[Existing].[BusinessLineId]
						,[Existing].[InsertedDate]
						,[Existing].[UpdatedDate]
						,[Existing].[UpdatedByStaffId]
						,[Existing].[IsActive]
					FROM 
						[dbo].[SnapshotActivityTypeBusinessLine] [Existing]
						INNER JOIN [dbo].[Snapshot] ON
							[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
					UNION
					SELECT
						[Snapshot].[SnapshotId]
						,[Snapshot].[IsLocked]
						,[Source].[ActivityTypeBusinessLineId]
						,[Source].[ActivityTypeId]
						,[Source].[BusinessLineId]
						,[Source].[InsertedDate]
						,[Source].[UpdatedDate]
						,[Source].[UpdatedByStaffId]
						,[Source].[IsActive]
						
					FROM 
						[dbo].[ActivityTypeBusinessLine] [Source]
						CROSS JOIN [dbo].[Snapshot]
					) [Compare]
				WHERE
					((@SnapshotId IS NULL AND [IsLocked] = 0) OR [SnapshotId] = @SnapshotId)
				GROUP BY
					[SnapshotId]
					,[ActivityTypeBusinessLineId]
				HAVING
					COUNT(*) > 1
				) [Changed] ON
					[Changed].[ActivityTypeBusinessLineId] = [Existing].[ActivityTypeBusinessLineId] AND
					[Changed].[SnapshotId] = [Existing].[SnapshotId]
			INNER JOIN [dbo].[ActivityTypeBusinessLine] [Source] ON
				[Source].[ActivityTypeBusinessLineId] = [Existing].[ActivityTypeBusinessLineId]
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount] [Existing]
			LEFT OUTER JOIN [GBS].[FeePropertyGLAccountGLGlobalAccount] [Source] ON
				[Existing].[FeePropertyGLAccountGLGlobalAccountId] = [Source].[FeePropertyGLAccountGLGlobalAccountId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[FeePropertyGLAccountGLGlobalAccountId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLMinorCategoryPayrollType] [Existing]
			LEFT OUTER JOIN [GBS].[GLMinorCategoryPayrollType] [Source] ON
				[Existing].[GLMinorCategoryPayrollTypeId] = [Source].[GLMinorCategoryPayrollTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLMinorCategoryPayrollTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyEntityException] [Existing]
			LEFT OUTER JOIN [GBS].[PropertyEntityException] [Source] ON
				[Existing].[PropertyEntityExceptionId] = [Source].[PropertyEntityExceptionId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyEntityExceptionId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyGLAccountGLGlobalAccount] [Existing]
			LEFT OUTER JOIN [GBS].[PropertyGLAccountGLGlobalAccount] [Source] ON
				[Existing].[PropertyGLAccountGLGlobalAccountId] = [Source].[PropertyGLAccountGLGlobalAccountId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyGLAccountGLGlobalAccountId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyOverheadPropertyGLAccount] [Existing]
			LEFT OUTER JOIN [GBS].[PropertyOverheadPropertyGLAccount] [Source] ON
				[Existing].[PropertyOverheadPropertyGLAccountId] = [Source].[PropertyOverheadPropertyGLAccountId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyOverheadPropertyGLAccountId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyPayrollPropertyGLAccount] [Existing]
			LEFT OUTER JOIN [GBS].[PropertyPayrollPropertyGLAccount] [Source] ON
				[Existing].[PropertyPayrollPropertyGLAccountId] = [Source].[PropertyPayrollPropertyGLAccountId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyPayrollPropertyGLAccountId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotManagePropertyEntity] [Existing]
			LEFT OUTER JOIN [dbo].[ManagePropertyEntity] [Source] ON
				[Existing].[ManagePropertyEntityId] = [Source].[ManagePropertyEntityId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ManagePropertyEntityId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotManagePropertyDepartment] [Existing]
			LEFT OUTER JOIN [dbo].[ManagePropertyDepartment] [Source] ON
				[Existing].[ManagePropertyDepartmentId] = [Source].[ManagePropertyDepartmentId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ManagePropertyDepartmentId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotManageCorporateEntity] [Existing]
			LEFT OUTER JOIN [dbo].[ManageCorporateEntity] [Source] ON
				[Existing].[ManageCorporateEntityId] = [Source].[ManageCorporateEntityId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ManageCorporateEntityId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotManageCorporateDepartment] [Existing]
			LEFT OUTER JOIN [dbo].[ManageCorporateDepartment] [Source] ON
				[Existing].[ManageCorporateDepartmentId] = [Source].[ManageCorporateDepartmentId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ManageCorporateDepartmentId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotManageType] [Existing]
			LEFT OUTER JOIN [dbo].[ManageType] [Source] ON
				[Existing].[ManageTypeId] = [Source].[ManageTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ManageTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyFundBudgetCoordinator] [Existing]
			LEFT OUTER JOIN [dbo].[PropertyFundBudgetCoordinator] [Source] ON
				[Existing].[PropertyFundBudgetCoordinatorId] = [Source].[PropertyFundBudgetCoordinatorId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyFundBudgetCoordinatorId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyFundDisplayName] [Existing]
			LEFT OUTER JOIN [dbo].[PropertyFundDisplayName] [Source] ON
				[Existing].[PropertyFundDisplayNameId] = [Source].[PropertyFundDisplayNameId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyFundDisplayNameId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotReportingEntityPropertyEntity] [Existing]
			LEFT OUTER JOIN [dbo].[ReportingEntityPropertyEntity] [Source] ON
				[Existing].[ReportingEntityPropertyEntityId] = [Source].[ReportingEntityPropertyEntityId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ReportingEntityPropertyEntityId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotReportingEntityCorporateDepartment] [Existing]
			LEFT OUTER JOIN [dbo].[ReportingEntityCorporateDepartment] [Source] ON
				[Existing].[ReportingEntityCorporateDepartmentId] = [Source].[ReportingEntityCorporateDepartmentId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ReportingEntityCorporateDepartmentId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyFund] [Existing]
			LEFT OUTER JOIN [dbo].[PropertyFund] [Source] ON
				[Existing].[PropertyFundId] = [Source].[PropertyFundId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyFundId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotEntityType] [Existing]
			LEFT OUTER JOIN [dbo].[EntityType] [Source] ON
				[Existing].[EntityTypeId] = [Source].[EntityTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[EntityTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotRelatedFund] [Existing]
			LEFT OUTER JOIN [dbo].[RelatedFund] [Source] ON
				[Existing].[RelatedFundId] = [Source].[RelatedFundId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[RelatedFundId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotRegionalAdministratorGlobalSubRegion] [Existing]
			LEFT OUTER JOIN [dbo].[RegionalAdministratorGlobalSubRegion] [Source] ON
				[Existing].[StaffId] = [Source].[StaffId] AND
				[Existing].[GlobalRegionId] = [Source].[GlobalRegionId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[StaffId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotOriginatingRegionPropertyDepartment] [Existing]
			LEFT OUTER JOIN [dbo].[OriginatingRegionPropertyDepartment] [Source] ON
				[Existing].[OriginatingRegionPropertyDepartmentId] = [Source].[OriginatingRegionPropertyDepartmentId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[OriginatingRegionPropertyDepartmentId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotOriginatingRegionCorporateEntity] [Existing]
			LEFT OUTER JOIN [dbo].[OriginatingRegionCorporateEntity] [Source] ON
				[Existing].[OriginatingRegionCorporateEntityId] = [Source].[OriginatingRegionCorporateEntityId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[OriginatingRegionCorporateEntityId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGlobalRegion] [Existing]
			LEFT OUTER JOIN [dbo].[GlobalRegion] [Source] ON
				[Existing].[GlobalRegionId] = [Source].[GlobalRegionId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GlobalRegionId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLGlobalAccountTranslationSubType] [Existing]
			LEFT OUTER JOIN [dbo].[GLGlobalAccountTranslationSubType] [Source] ON
				[Existing].[GLGlobalAccountTranslationSubTypeId] = [Source].[GLGlobalAccountTranslationSubTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLGlobalAccountTranslationSubTypeId] IS NULL  	
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLGlobalAccountTranslationType] [Existing]
			LEFT OUTER JOIN [dbo].[GLGlobalAccountTranslationType] [Source] ON
				[Existing].[GLGlobalAccountTranslationTypeId] = [Source].[GLGlobalAccountTranslationTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLGlobalAccountTranslationTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLGlobalAccountGLAccount] [Existing]
			LEFT OUTER JOIN [dbo].[GLGlobalAccountGLAccount] [Source] ON
				[Existing].[GLGlobalAccountGLAccountId] = [Source].[GLGlobalAccountGLAccountId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLGlobalAccountGLAccountId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLGlobalAccount] [Existing]
			LEFT OUTER JOIN [dbo].[GLGlobalAccount] [Source] ON
				[Existing].[GLGlobalAccountId] = [Source].[GLGlobalAccountId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLGlobalAccountId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotActivityType] [Existing]
			LEFT OUTER JOIN [dbo].[ActivityType] [Source] ON
				[Existing].[ActivityTypeId] = [Source].[ActivityTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ActivityTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLStatutoryType] [Existing]
			LEFT OUTER JOIN [dbo].[GLStatutoryType] [Source] ON
				[Existing].[GLStatutoryTypeId] = [Source].[GLStatutoryTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLStatutoryTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLMinorCategory] [Existing]
			LEFT OUTER JOIN [dbo].[GLMinorCategory] [Source] ON
				[Existing].[GLMinorCategoryId] = [Source].[GLMinorCategoryId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLMinorCategoryId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLMajorCategory] [Existing]
			LEFT OUTER JOIN [dbo].[GLMajorCategory] [Source] ON
				[Existing].[GLMajorCategoryId] = [Source].[GLMajorCategoryId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLMajorCategoryId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLAccountSubType] [Existing]
			LEFT OUTER JOIN [dbo].[GLAccountSubType] [Source] ON
				[Existing].[GLAccountSubTypeId] = [Source].[GLAccountSubTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLAccountSubTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLAccountType] [Existing]
			LEFT OUTER JOIN [dbo].[GLAccountType] [Source] ON
				[Existing].[GLAccountTypeId] = [Source].[GLAccountTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLAccountTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLTranslationSubType] [Existing]
			LEFT OUTER JOIN [dbo].[GLTranslationSubType] [Source] ON
				[Existing].[GLTranslationSubTypeId] = [Source].[GLTranslationSubTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLTranslationSubTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLTranslationType] [Existing]
			LEFT OUTER JOIN [dbo].[GLTranslationType] [Source] ON
				[Existing].[GLTranslationTypeId] = [Source].[GLTranslationTypeId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[GLTranslationTypeId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity] [Existing]
			LEFT OUTER JOIN [dbo].[RechargeCorporateDepartmentPropertyEntity] [Source] ON
				[Existing].[RechargeCorporateDepartmentPropertyEntityId] = [Source].[RechargeCorporateDepartmentPropertyEntityId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[RechargeCorporateDepartmentPropertyEntityId] IS NULL 
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyEntityGLAccountInclusion] [Existing]
			LEFT OUTER JOIN [dbo].[PropertyEntityGLAccountInclusion] [Source] ON
				[Existing].[PropertyEntityGLAccountInclusionId] = [Source].[PropertyEntityGLAccountInclusionId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyEntityGLAccountInclusionId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotOverheadRegion] [Existing]
			LEFT OUTER JOIN [TAPASB].[OverheadRegion] [Source] ON
				[Existing].[OverheadRegionId] = [Source].[OverheadRegionId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[OverheadRegionId] IS NULL	
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPayrollRegion] [Existing]
			LEFT OUTER JOIN [TAPASB].[PayrollRegion] [Source] ON
				[Existing].[PayrollRegionId] = [Source].[PayrollRegionId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PayrollRegionId] IS NULL	
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotGLAccount] [Existing]
			LEFT OUTER JOIN [dbo].[GLAccount] [Source] ON
				[Existing].[Code] = [Source].[Code] AND
				[Existing].[SourceCode] = [Source].[SourceCode]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[Code] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotFunctionalDepartment] [Existing]
			LEFT OUTER JOIN [dbo].[FunctionalDepartment] [Source] ON
				[Existing].[FunctionalDepartmentId] = [Source].[FunctionalDepartmentId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[FunctionalDepartmentId] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]	
		FROM 
			[dbo].[SnapshotCurrency] [Existing]		
			LEFT OUTER JOIN [dbo].[Currency] [Source] ON
				[Existing].[Code] = [Source].[Code] AND
				[Existing].[Symbol] = [Source].[Symbol]	
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[Code] IS NULL	
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotCorporateJobCode] [Existing]
			LEFT OUTER JOIN [dbo].[CorporateJobCode] [Source] ON
				[Existing].[Code] = [Source].[Code] AND
				[Existing].[SourceCode] = [Source].[SourceCode]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[Code] IS NULL	
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotCorporateEntity] [Existing]
			LEFT OUTER JOIN [dbo].[CorporateEntity] [Source] ON
				[Existing].[Code] = [Source].[Code] AND
				[Existing].[SourceCode] = [Source].[SourceCode]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[Code] IS NULL
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotCorporateDepartment] [Existing]
			LEFT OUTER JOIN [dbo].[CorporateDepartment] [Source] ON
				[Existing].[Code] = [Source].[Code] AND
				[Existing].[SourceCode] = [Source].[SourceCode]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[Code] IS NULL	
		OPTION (MAXDOP 1)

		DELETE [Existing]
		FROM 
			[dbo].[SnapshotPropertyFundMapping] [Existing]
			LEFT OUTER JOIN [GR].[PropertyFundMapping] [Source] ON
				[Existing].[PropertyFundMappingId] = [Source].[PropertyFundMappingId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[PropertyFundMappingId] IS NULL	
		OPTION (MAXDOP 1)
		
		-- Insert BusinessLine and ActivityTypeBusinessLine snapshot data (GRP CC10)
		
		DELETE [Existing]
		FROM 
			[dbo].[SnapshotBusinessLine] [Existing]
			LEFT OUTER JOIN [dbo].[BusinessLine] [Source] ON
				[Existing].[BusinessLineId] = [Source].[BusinessLineId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[BusinessLineId] IS NULL
		OPTION (MAXDOP 1)
		
		DELETE [Existing]
		FROM 
			[dbo].[SnapshotActivityTypeBusinessLine] [Existing]
			LEFT OUTER JOIN [dbo].[ActivityTypeBusinessLine] [Source] ON
				[Existing].[ActivityTypeBusinessLineId] = [Source].[ActivityTypeBusinessLineId]
			INNER JOIN [dbo].[Snapshot] ON
				[dbo].[Snapshot].[SnapshotId] = [Existing].[SnapshotId]
		WHERE
			((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
			[dbo].[Snapshot].[SnapshotId] = @SnapshotId) AND
			[Source].[ActivityTypeBusinessLineId] IS NULL
		OPTION (MAXDOP 1)
	END
	
	UPDATE [dbo].[Snapshot] SET
		[LastSyncDate] = GETDATE()
	WHERE
		((@SnapshotId IS NULL AND [dbo].[Snapshot].[IsLocked] = 0) OR 
		[dbo].[Snapshot].[SnapshotId] = @SnapshotId)
				
	
	
	COMMIT	
END 

---------------------------------------------------------------------
				/*	End of SyncSnapshot	*/
---------------------------------------------------------------------


---------------------------------------------------------------------
				/*	Beginning of CopySnapshot	*/
---------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[CopySnapshot]    Script Date: 03/18/2011 17:09:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CopySnapshot]
	@FromSnapshotId int,
	@ToSnapshotId int
AS
BEGIN	
	SET NOCOUNT ON;
	
	--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
	SET XACT_ABORT ON;

	BEGIN TRANSACTION		

	IF NOT EXISTS(SELECT * FROM [dbo].[Snapshot] WHERE [SnapshotId] = @FromSnapshotId) OR NOT EXISTS(SELECT * FROM [dbo].[Snapshot] WHERE [SnapshotId] = @ToSnapshotId)
	RETURN

	DELETE [dbo].[SnapshotPropertyFundMapping]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotManagePropertyEntity]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotManagePropertyDepartment]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotManageCorporateEntity]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotManageCorporateDepartment]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotManageType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyFundBudgetCoordinator]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyFundDisplayName]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotReportingEntityPropertyEntity]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotReportingEntityCorporateDepartment]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyFund]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotEntityType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotRelatedFund]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotRegionalAdministratorGlobalSubRegion]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotOriginatingRegionPropertyDepartment]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotOriginatingRegionCorporateEntity]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGlobalRegion]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLGlobalAccountTranslationSubType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLGlobalAccountTranslationType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLGlobalAccountGLAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLGlobalAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotActivityType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLStatutoryType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLMinorCategory]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLMajorCategory]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLAccountSubType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLAccountType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLTranslationSubType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLTranslationType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyEntityGLAccountInclusion]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotOverheadRegion]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPayrollRegion]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotFunctionalDepartment]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotCurrency]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotCorporateJobCode]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotCorporateEntity]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotCorporateDepartment]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyPayrollPropertyGLAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyOverheadPropertyGLAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyGLAccountGLGlobalAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotPropertyEntityException]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotGLMinorCategoryPayrollType]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount]
	WHERE 
		[SnapshotId] = @ToSnapshotId
		
-- BusinessLine and ActivityTypeBusinessLine snapshot data (GRP CC10)

	DELETE [dbo].[SnapshotBusinessLine]
	WHERE 
		[SnapshotId] = @ToSnapshotId

	DELETE [dbo].[SnapshotActivityTypeBusinessLine]
	WHERE 
		[SnapshotId] = @ToSnapshotId
		

	INSERT INTO [dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount]
		([SnapshotId]
		,[FeePropertyGLAccountGLGlobalAccountId]
		,[PropertyGLAccountCode]
		,[GLGlobalAccountId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[SourceCode])
	SELECT
		@ToSnapshotId
		,[FeePropertyGLAccountGLGlobalAccountId]
		,[PropertyGLAccountCode]
		,[GLGlobalAccountId]		
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[SourceCode]
	FROM 
		[dbo].[SnapshotFeePropertyGLAccountGLGlobalAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLMinorCategoryPayrollType]
		([SnapshotId]
		,[GLMinorCategoryPayrollTypeId]
		,[GLMinorCategoryId]
		,[PayrollTypeId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])    
	SELECT
		@ToSnapshotId
		,[GLMinorCategoryPayrollTypeId]
		,[GLMinorCategoryId]
		,[PayrollTypeId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLMinorCategoryPayrollType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyEntityException]
		([SnapshotId]
		,[PropertyEntityExceptionId]
		,[SourceCode]
		,[PropertyEntityCode]
		,[GLGlobalAccountId]
		,[PropertyBudgetTypeId]
		,[PropertyGLAccountCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDirectCost])
	SELECT
		@ToSnapshotId
		,[PropertyEntityExceptionId]
		,[SourceCode]
		,[PropertyEntityCode]
		,[GLGlobalAccountId]
		,[PropertyBudgetTypeId]
		,[PropertyGLAccountCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDirectCost]
	FROM 
		[dbo].[SnapshotPropertyEntityException]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyGLAccountGLGlobalAccount]
		([SnapshotId]
		,[PropertyGLAccountGLGlobalAccountId]
		,[PropertyGLAccountCode]
		,[GLGlobalAccountId]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDirectCost])
	SELECT
		@ToSnapshotId
		,[PropertyGLAccountGLGlobalAccountId]
		,[PropertyGLAccountCode]
		,[GLGlobalAccountId]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDirectCost]
	FROM 
		[dbo].[SnapshotPropertyGLAccountGLGlobalAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyOverheadPropertyGLAccount]
		([SnapshotId]
		,[PropertyOverheadPropertyGLAccountId]
		,[PropertyGLAccountCode]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[ActivityTypeId]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[PropertyOverheadPropertyGLAccountId]
		,[PropertyGLAccountCode]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[ActivityTypeId]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotPropertyOverheadPropertyGLAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyPayrollPropertyGLAccount]
		([SnapshotId]
		,[PropertyPayrollPropertyGLAccountId]
		,[PropertyGLAccountCode]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[ActivityTypeId]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[PayrollTypeId])
	SELECT
		@ToSnapshotId
		,[PropertyPayrollPropertyGLAccountId]
		,[PropertyGLAccountCode]
		,[PropertyBudgetTypeId]
		,[SourceCode]
		,[ActivityTypeId]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[PayrollTypeId]
	FROM 
		[dbo].[SnapshotPropertyPayrollPropertyGLAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotCorporateDepartment]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[Description]
		,[LastDate]
		,[MriUserID]
		,[IsActive]
		,[FunctionalDepartmentId]
		,[IsTsCost])
	SELECT
		@ToSnapshotId
		,[Code]
		,[SourceCode]
		,[Description]
		,[LastDate]
		,[MriUserID]
		,[IsActive]
		,[FunctionalDepartmentId]
		,[IsTsCost]
	FROM 
		[dbo].[SnapshotCorporateDepartment]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotCorporateEntity]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[CityID]
		,[Name]
		,[DisplayName]
		,[CurrencyCode]
		,[IsActive]
		,[IsCustom]
		,[Address]
		,[IsFund]
		,[ShippingAddress]
		,[BillingAddress]
		,[ProjectRef]
		,[IsOutsourced]
		,[IsRMProperty]
		,[IsHistoric])
	SELECT
		@ToSnapshotId
		,[Code]
		,[SourceCode]
		,[CityID]
		,[Name]
		,[DisplayName]
		,[CurrencyCode]
		,[IsActive]
		,[IsCustom]
		,[Address]
		,[IsFund]
		,[ShippingAddress]
		,[BillingAddress]
		,[ProjectRef]
		,[IsOutsourced]
		,[IsRMProperty]
		,[IsHistoric]	
	FROM 
		[dbo].[SnapshotCorporateEntity]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotCorporateJobCode]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[JobType]
		,[Description]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[StartDate]
		,[EndDate])
	SELECT
		@ToSnapshotId
		,[Code]
		,[SourceCode]
		,[JobType]
		,[Description]
		,[FunctionalDepartmentId]
		,[IsActive]
		,[StartDate]
		,[EndDate]
	FROM 
		[dbo].[SnapshotCorporateJobCode]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotCurrency]
		([SnapshotId]
		,[Code]
		,[Symbol])
	SELECT
		@ToSnapshotId
		,[Code]
		,[Symbol]
	FROM 
		[dbo].[SnapshotCurrency]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotFunctionalDepartment]
		([SnapshotId]
		,[FunctionalDepartmentId]
		,[Name]
		,[Code]
		,[GlobalCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[NuViewId])
	SELECT
		@ToSnapshotId
		,[FunctionalDepartmentId]
		,[Name]
		,[Code]
		,[GlobalCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[NuViewId]
	FROM 
		[dbo].[SnapshotFunctionalDepartment]
	WHERE
		[SnapshotId] = @FromSnapshotId		

	INSERT INTO [dbo].[SnapshotGLAccount]
		([SnapshotId]
		,[Code]
		,[SourceCode]
		,[Name]
		,[Type]
		,[IsHistoric]
		,[IsGR]
		,[IsActive]
		,[UpdatedDate])
	SELECT
		@ToSnapshotId
		,[Code]
		,[SourceCode]
		,[Name]
		,[Type]
		,[IsHistoric]
		,[IsGR]
		,[IsActive]
		,[UpdatedDate]
	FROM 
		[dbo].[SnapshotGLAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPayrollRegion]
		([SnapshotId]
		,[PayrollRegionId]
		,[RegionId]
		,[ExternalSubRegionId]
		,[CorporateEntityRef]
		,[CorporateSourceCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[PayrollRegionId]
		,[RegionId]
		,[ExternalSubRegionId]
		,[CorporateEntityRef]
		,[CorporateSourceCode]		
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotPayrollRegion]
	WHERE
		[SnapshotId] = @FromSnapshotId	

	INSERT INTO [dbo].[SnapshotOverheadRegion]
           ([SnapshotId]
           ,[OverheadRegionId]
           ,[RegionId]
           ,[CorporateEntityRef]
           ,[CorporateSourceCode]
           ,[Name]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[OverheadRegionId]
		,[RegionId]
		,[CorporateEntityRef]
		,[CorporateSourceCode]
		,[Name]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotOverheadRegion]
	WHERE
		[SnapshotId] = @FromSnapshotId		

	INSERT INTO [dbo].[SnapshotPropertyEntityGLAccountInclusion]
		([SnapshotId]
		,[PropertyEntityGLAccountInclusionId]
		,[PropertyEntityCode]
		,[GLAccountCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[PropertyEntityGLAccountInclusionId]
		,[PropertyEntityCode]
		,[GLAccountCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotPropertyEntityGLAccountInclusion]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity]
		([SnapshotId]
		,[RechargeCorporateDepartmentPropertyEntityId]
		,[CorporateDepartmentCode]
		,[CorporateDepartmentSourceCode]
		,[PropertyEntityCode]
		,[PropertyEntitySourceCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[RechargeCorporateDepartmentPropertyEntityId]
		,[CorporateDepartmentCode]
		,[CorporateDepartmentSourceCode]
		,[PropertyEntityCode]
		,[PropertyEntitySourceCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotRechargeCorporateDepartmentPropertyEntity]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLTranslationType]
		([SnapshotId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLTranslationType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLTranslationSubType]
		([SnapshotId]
		,[GLTranslationSubTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsGRDefault])
	SELECT
		@ToSnapshotId
		,[GLTranslationSubTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsGRDefault]
	FROM 
		[dbo].[SnapshotGLTranslationSubType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLAccountType]
		([SnapshotId]
		,[GLAccountTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLAccountTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLAccountType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLAccountSubType]
		([SnapshotId]
		,[GLAccountSubTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLAccountSubTypeId]
		,[GLTranslationTypeId]
		,[Code]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLAccountSubType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLMajorCategory]
		([SnapshotId]
		,[GLMajorCategoryId]
		,[GLTranslationSubTypeId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLMajorCategoryId]
		,[GLTranslationSubTypeId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLMajorCategory]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLMinorCategory]
		([SnapshotId]
		,[GLMinorCategoryId]
		,[GLMajorCategoryId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLMinorCategoryId]
		,[GLMajorCategoryId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLMinorCategory]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLStatutoryType]
		([SnapshotId]
		,[GLStatutoryTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLStatutoryTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLStatutoryType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotActivityType]
		([SnapshotId]
		,[ActivityTypeId]
		,[Code]
		,[Name]
		,[GLAccountSuffix]
		,[IsEscalatable]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[ActivityTypeId]
		,[Code]
		,[Name]
		,[GLAccountSuffix]
		,[IsEscalatable]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotActivityType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLGlobalAccount]
		([SnapshotId]
		,[GLGlobalAccountId]
		,[ActivityTypeId]
		,[GLStatutoryTypeId]
		,[ParentGLGlobalAccountId]
		,[Code]
		,[Name]
		,[Description]
		,[IsGR]
		,[IsGbs]
		,[IsRegionalOverheadCost]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[ExpenseCzarStaffId])
	SELECT
		@ToSnapshotId
		,[GLGlobalAccountId]
		,[ActivityTypeId]
		,[GLStatutoryTypeId]
		,[ParentGLGlobalAccountId]
		,[Code]
		,[Name]
		,[Description]
		,[IsGR]
		,[IsGbs]
		,[IsRegionalOverheadCost]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[ExpenseCzarStaffId]
	FROM 
		[dbo].[SnapshotGLGlobalAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLGlobalAccountGLAccount]
		([SnapshotId]
		,[GLGlobalAccountGLAccountId]
		,[GLGlobalAccountId]
		,[SourceCode]
		,[Code]
		,[Name]
		,[Description]
		,[PreGlobalAccountCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLGlobalAccountGLAccountId]
		,[GLGlobalAccountId]
		,[SourceCode]
		,[Code]
		,[Name]
		,[Description]
		,[PreGlobalAccountCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLGlobalAccountGLAccount]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLGlobalAccountTranslationType]
		([SnapshotId]
		,[GLGlobalAccountTranslationTypeId]
		,[GLGlobalAccountId]
		,[GLTranslationTypeId]
		,[GLAccountTypeId]
		,[GLAccountSubTypeId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLGlobalAccountTranslationTypeId]
		,[GLGlobalAccountId]
		,[GLTranslationTypeId]
		,[GLAccountTypeId]
		,[GLAccountSubTypeId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLGlobalAccountTranslationType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGLGlobalAccountTranslationSubType]
		([SnapshotId]
		,[GLGlobalAccountTranslationSubTypeId]
		,[GLGlobalAccountId]
		,[GLTranslationSubTypeId]
		,[GLMinorCategoryId]
		,[PostingPropertyGLAccountCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GLGlobalAccountTranslationSubTypeId]
		,[GLGlobalAccountId]
		,[GLTranslationSubTypeId]
		,[GLMinorCategoryId]
		,[PostingPropertyGLAccountCode]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGLGlobalAccountTranslationSubType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotGlobalRegion]
		([SnapshotId]
		,[GlobalRegionId]
		,[ParentGlobalRegionId]
		,[CountryId]
		,[Code]
		,[Name]
		,[IsAllocationRegion]
		,[IsOriginatingRegion]
		,[DefaultCurrencyCode]
		,[DefaultCorporateSourceCode]
		,[ProjectCodePortion]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[GlobalRegionId]
		,[ParentGlobalRegionId]
		,[CountryId]
		,[Code]
		,[Name]
		,[IsAllocationRegion]
		,[IsOriginatingRegion]
		,[DefaultCurrencyCode]
		,[DefaultCorporateSourceCode]
		,[ProjectCodePortion]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotGlobalRegion]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotOriginatingRegionCorporateEntity]
		([SnapshotId]
		,[OriginatingRegionCorporateEntityId]
		,[GlobalRegionId]
		,[CorporateEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[OriginatingRegionCorporateEntityId]
		,[GlobalRegionId]
		,[CorporateEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotOriginatingRegionCorporateEntity]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotOriginatingRegionPropertyDepartment]
		([SnapshotId]
		,[OriginatingRegionPropertyDepartmentId]
		,[GlobalRegionId]
		,[PropertyDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[OriginatingRegionPropertyDepartmentId]
		,[GlobalRegionId]
		,[PropertyDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotOriginatingRegionPropertyDepartment]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotRegionalAdministratorGlobalSubRegion]
		([SnapshotId]
		,[StaffId]
		,[GlobalRegionId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[StaffId]
		,[GlobalRegionId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotRegionalAdministratorGlobalSubRegion]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotRelatedFund]
		([SnapshotId]
		,[RelatedFundId]
		,[Name]
		,[AbbreviatedName]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[RelatedFundId]
		,[Name]
		,[AbbreviatedName]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotRelatedFund]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotEntityType]
		([SnapshotId]
		,[EntityTypeId]
		,[Name]
		,[ProjectCodePortion]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[EntityTypeId]
		,[Name]
		,[ProjectCodePortion]
		,[Description]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotEntityType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyFund]
		([SnapshotId]
		,[PropertyFundId]
		,[RelatedFundId]
		,[EntityTypeId]
		,[AllocationSubRegionGlobalRegionId]
		,[BudgetOwnerStaffId]
		,[RegionalOwnerStaffId]
		,[DefaultGLTranslationSubTypeId]
		,[Name]
		,[IsReportingEntity]
		,[IsPropertyFund]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[PropertyFundId]
		,[RelatedFundId]
		,[EntityTypeId]
		,[AllocationSubRegionGlobalRegionId]
		,[BudgetOwnerStaffId]
		,[RegionalOwnerStaffId]
		,[DefaultGLTranslationSubTypeId]
		,[Name]
		,[IsReportingEntity]
		,[IsPropertyFund]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotPropertyFund]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotReportingEntityCorporateDepartment]
		([SnapshotId]
		,[ReportingEntityCorporateDepartmentId]
		,[PropertyFundId]
		,[SourceCode]
		,[CorporateDepartmentCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDeleted])
	SELECT
		@ToSnapshotId
		,[ReportingEntityCorporateDepartmentId]
		,[PropertyFundId]
		,[SourceCode]
		,[CorporateDepartmentCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDeleted]
	FROM 
		[dbo].[SnapshotReportingEntityCorporateDepartment]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotReportingEntityPropertyEntity]
		([SnapshotId]
		,[ReportingEntityPropertyEntityId]
		,[PropertyFundId]
		,[SourceCode]
		,[PropertyEntityCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDeleted])
	SELECT
		@ToSnapshotId
		,[ReportingEntityPropertyEntityId]
		,[PropertyFundId]
		,[SourceCode]
		,[PropertyEntityCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsDeleted]
	FROM 
		[dbo].[SnapshotReportingEntityPropertyEntity]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyFundDisplayName]
		([SnapshotId]
		,[PropertyFundDisplayNameId]
		,[PropertyFundId]
		,[DisplayName]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[PropertyFundDisplayNameId]
		,[PropertyFundId]
		,[DisplayName]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotPropertyFundDisplayName]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyFundBudgetCoordinator]
		([SnapshotId]
		,[PropertyFundBudgetCoordinatorId]
		,[PropertyFundId]
		,[BudgetCoordinatorStaffId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[PropertyFundBudgetCoordinatorId]
		,[PropertyFundId]
		,[BudgetCoordinatorStaffId]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotPropertyFundBudgetCoordinator]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotManageType]
		([SnapshotId]
		,[ManageTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[ManageTypeId]
		,[Code]
		,[Name]
		,[Description]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotManageType]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotManageCorporateDepartment]
		([SnapshotId]
		,[ManageCorporateDepartmentId]
		,[ManageTypeId]
		,[CorporateDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[ManageCorporateDepartmentId]
		,[ManageTypeId]
		,[CorporateDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotManageCorporateDepartment]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotManageCorporateEntity]
		([SnapshotId]
		,[ManageCorporateEntityId]
		,[ManageTypeId]
		,[CorporateEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[ManageCorporateEntityId]
		,[ManageTypeId]
		,[CorporateEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotManageCorporateEntity]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotManagePropertyDepartment]
		([SnapshotId]
		,[ManagePropertyDepartmentId]
		,[ManageTypeId]
		,[PropertyDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[ManagePropertyDepartmentId]
		,[ManageTypeId]
		,[PropertyDepartmentCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotManagePropertyDepartment]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotManagePropertyEntity]
		([SnapshotId]
		,[ManagePropertyEntityId]
		,[ManageTypeId]
		,[PropertyEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])
	SELECT
		@ToSnapshotId
		,[ManagePropertyEntityId]
		,[ManageTypeId]
		,[PropertyEntityCode]
		,[SourceCode]
		,[IsDeleted]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotManagePropertyEntity]
	WHERE
		[SnapshotId] = @FromSnapshotId

	INSERT INTO [dbo].[SnapshotPropertyFundMapping]
		([SnapshotId]
		,[PropertyFundMappingId]
		,[PropertyFundId]
		,[SourceCode]
		,[PropertyFundCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[IsDeleted]
		,[ActivityTypeId])    
	SELECT 
		@ToSnapshotId
		,[PropertyFundMappingId]
		,[PropertyFundId]
		,[SourceCode]
		,[PropertyFundCode]
		,[InsertedDate]
		,[UpdatedDate]
		,[IsDeleted]
		,[ActivityTypeId]
	FROM 
		[dbo].[SnapshotPropertyFundMapping]
	WHERE
		[SnapshotId] = @FromSnapshotId
		
-- BusinessLine and ActivityTypeBusinessLine snapshot data (GRP CC10)

	INSERT INTO [dbo].[SnapshotBusinessLine]
		([BusinessLineId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId])    
	SELECT 
		@ToSnapshotId
		,[BusinessLineId]
		,[Name]
		,[IsActive]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
	FROM 
		[dbo].[SnapshotBusinessLine]
	WHERE
		[SnapshotId] = @FromSnapshotId

INSERT INTO [dbo].[SnapshotActivityTypeBusinessLine]
		([ActivityTypeId]
		,[BusinessLineId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsActive])    
	SELECT 
		@ToSnapshotId
		,[ActivityTypeId]
		,[BusinessLineId]
		,[InsertedDate]
		,[UpdatedDate]
		,[UpdatedByStaffId]
		,[IsActive]
	FROM 
		[dbo].[SnapshotActivityTypeBusinessLine]
	WHERE
		[SnapshotId] = @FromSnapshotId


	UPDATE [dbo].[Snapshot] SET
		[LastSyncDate] = (SELECT TOP 1 [LastSyncDate] FROM [dbo].[Snapshot] WHERE [SnapshotId] = @FromSnapshotId)
	WHERE
		[SnapshotId] = @ToSnapshotId 

	COMMIT TRANSACTION
END 
---------------------------------------------------------------------
				/*	End of CopySnapshot	*/
---------------------------------------------------------------------