USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.OriginatingRegionCorporateEntity table in the GDM_GR database with the 
	dbo.OriginatingRegionCorporateEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionCorporateEntity ON

MERGE
	GDM_GR.dbo.OriginatingRegionCorporateEntity AS [Target]
USING
	GDM.dbo.OriginatingRegionCorporateEntity AS [Source]
ON
	[Source].OriginatingRegionCorporateEntityId = [Target].OriginatingRegionCorporateEntityId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].CorporateEntityCode = [Source].CorporateEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		-- [Target].IsDeleted = [Source].IsDeleted,  -- IsDeleted has been removed from this table: only hard deletes are possible
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		OriginatingRegionCorporateEntityId,
		GlobalRegionId,
		CorporateEntityCode,
		SourceCode,
		-- IsDeleted, -- IsDeleted has been removed from this table: only hard deletes are possible
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].OriginatingRegionCorporateEntityId,
		[Source].GlobalRegionId,
		[Source].CorporateEntityCode,
		[Source].SourceCode,
		-- [Source].IsDeleted, -- IsDeleted has been removed from this table: only hard deletes are possible
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], delete it in [Target]
	DELETE;

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionCorporateEntity OFF

GO
