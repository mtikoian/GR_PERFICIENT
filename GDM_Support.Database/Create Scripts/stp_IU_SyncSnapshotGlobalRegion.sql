 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGlobalRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGlobalRegion]
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGlobalRegion table in the GDM_GR database 
	with the dbo.SnapshotGlobalRegion table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGlobalRegion]
AS


MERGE
	GDM_GR.dbo.SnapshotGlobalRegion AS [Target]
USING
	GDM.dbo.SnapshotGlobalRegion AS [Source]
ON
	[Source].GlobalRegionId = [Target].GlobalRegionId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].ParentGlobalRegionId = [Source].ParentGlobalRegionId,
		[Target].CountryId = [Source].CountryId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsAllocationRegion = [Source].IsAllocationRegion,
		[Target].IsOriginatingRegion = [Source].IsOriginatingRegion,
		[Target].DefaultCurrencyCode = [Source].DefaultCurrencyCode,
		[Target].DefaultCorporateSourceCode = [Source].DefaultCorporateSourceCode,
		[Target].ProjectCodePortion = [Source].ProjectCodePortion,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId,
		[Target].IsConsolidationRegion = [Source].IsConsolidationRegion		

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		GlobalRegionId,
		ParentGlobalRegionId,
		CountryId,
		Code,
		Name,
		IsAllocationRegion,
		IsOriginatingRegion,
		DefaultCurrencyCode,
		DefaultCorporateSourceCode,
		ProjectCodePortion,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsConsolidationRegion
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GlobalRegionId,
		[Source].ParentGlobalRegionId,
		[Source].CountryId,
		[Source].Code,
		[Source].Name,
		[Source].IsAllocationRegion,
		[Source].IsOriginatingRegion,
		[Source].DefaultCurrencyCode,
		[Source].DefaultCorporateSourceCode,
		[Source].ProjectCodePortion,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		[Source].IsConsolidationRegion		
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table



GO
