USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.OriginatingRegionPropertyDepartment table in the GDM_GR database with the 
	dbo.OriginatingRegionPropertyDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionPropertyDepartment ON

MERGE
	GDM_GR.dbo.OriginatingRegionPropertyDepartment AS [Target]
USING
	GDM.dbo.OriginatingRegionPropertyDepartment AS [Source]
ON
	[Source].OriginatingRegionPropertyDepartmentId = [Target].OriginatingRegionPropertyDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].PropertyDepartmentCode = [Source].PropertyDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		OriginatingRegionPropertyDepartmentId,
		GlobalRegionId,
		PropertyDepartmentCode,
		SourceCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].OriginatingRegionPropertyDepartmentId,
		[Source].GlobalRegionId,
		[Source].PropertyDepartmentCode,
		[Source].SourceCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], delete it in [Target]
	DELETE; -- when a record exists in [Target] that doesn't exist in [Source], delete it in [Target]

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionPropertyDepartment OFF

GO
