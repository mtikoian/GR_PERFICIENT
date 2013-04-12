USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncPropertyFund]    Script Date: 11/01/2011 05:09:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncPropertyFund]
GO

USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncPropertyFund]    Script Date: 11/01/2011 05:09:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.PropertyFund table in the GDM_GR database with the dbo.PropertyFund table
	in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncPropertyFund]
AS

SET IDENTITY_INSERT GDM_GR.dbo.PropertyFund ON

MERGE
	GDM_GR.dbo.PropertyFund AS [Target]
USING
	GDM.dbo.PropertyFund AS [Source]
ON
	[Source].PropertyFundId = [Target].PropertyFundId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields
	UPDATE SET
		[Target].RelatedFundId = [Source].RelatedFundId,
		[Target].EntityTypeId = [Source].EntityTypeId,
		[Target].AllocationSubRegionGlobalRegionId = [Source].AllocationSubRegionGlobalRegionId,
		[Target].BudgetOwnerStaffId = ISNULL([Source].BudgetOwnerStaffId, -1),
		[Target].RegionalOwnerStaffId = ISNULL([Source].RegionalOwnerStaffId, -1),
		--[Target].DefaultGLTranslationSubTypeId = [Source].DefaultGLTranslationSubTypeId,
		[Target].Name = [Source].Name,
		[Target].IsReportingEntity = [Source].IsReportingEntity,
		[Target].IsPropertyFund = [Source].IsPropertyFund,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		PropertyFundId,
		RelatedFundId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId,
		BudgetOwnerStaffId,
		RegionalOwnerStaffId,
		DefaultGLTranslationSubTypeId,
		Name,
		IsReportingEntity,
		IsPropertyFund,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].PropertyFundId,
		[Source].RelatedFundId,
		[Source].EntityTypeId,
		[Source].AllocationSubRegionGlobalRegionId,
		ISNULL([Source].BudgetOwnerStaffId, -1),
		ISNULL([Source].RegionalOwnerStaffId, -1),
		233, --  we can't update this: just default to GLOBAL (233) in the mean time
		[Source].Name,
		[Source].IsReportingEntity,
		[Source].IsPropertyFund,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.PropertyFund OFF




GO