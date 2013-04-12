 USE [GDM_GR]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
GO

USE [GDM_GR]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ConsolidationRegionCorporateDepartment table in the GDM_GR database with the 
	dbo.ConsolidationRegionCorporateDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionCorporateDepartment ON

MERGE
	GDM_GR.dbo.ConsolidationRegionCorporateDepartment AS [Target]
USING
	GDM.dbo.ConsolidationRegionCorporateDepartment AS [Source]
ON
	[Source].ConsolidationRegionCorporateDepartmentId = [Target].ConsolidationRegionCorporateDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		ConsolidationRegionCorporateDepartmentId,
		GlobalRegionId,
		SourceCode,
		CorporateDepartmentCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ConsolidationRegionCorporateDepartmentId,
		[Source].GlobalRegionId,
		[Source].SourceCode,
		[Source].CorporateDepartmentCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE;

SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionCorporateDepartment OFF


GO


