  USE [GDM_GR]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncRelatedFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncRelatedFund]
GO

USE [GDM_GR]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.RelatedFund table in the GDM_GR database with the dbo.RelatedFund table
	in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncRelatedFund]
AS

SET IDENTITY_INSERT GDM_GR.dbo.RelatedFund ON

MERGE
	GDM_GR.dbo.RelatedFund AS [Target]
USING
	GDM.dbo.RelatedFund AS [Source]
ON
	[Source].RelatedFundId = [Target].RelatedFundId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].AbbreviatedName = [Source].AbbreviatedName,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		RelatedFundId,
		Name,
		AbbreviatedName,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].RelatedFundId,
		[Source].Name,
		[Source].AbbreviatedName,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.RelatedFund OFF


GO


