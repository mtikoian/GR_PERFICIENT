USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManagePropertyDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncManagePropertyDepartment]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ManagePropertyDepartment table in the GDM_GR database with the 
	dbo.ManagePropertyDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncManagePropertyDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ManagePropertyDepartment ON

MERGE
	GDM_GR.dbo.ManagePropertyDepartment AS [Target]
USING
	GDM.dbo.ManagePropertyDepartment AS [Source]
ON
	[Source].ManagePropertyDepartmentId = [Target].ManagePropertyDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].PropertyDepartmentCode = [Source].PropertyDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		ManagePropertyDepartmentId,
		ManageTypeId,
		PropertyDepartmentCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ManagePropertyDepartmentId,
		[Source].ManageTypeId,
		[Source].PropertyDepartmentCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don't hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ManagePropertyDepartment OFF

GO
