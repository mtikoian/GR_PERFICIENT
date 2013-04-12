 USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]    Script Date: 08/10/2011 12:13:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
GO

USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]    Script Date: 08/10/2011 12:13:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionPropertyEntity ON

MERGE
	GDM_GR.dbo.ConsolidationRegionPropertyEntity AS [Target]
USING
	GDM.dbo.ConsolidationRegionPropertyEntity AS [Source]
ON
	[Source].ConsolidationRegionPropertyEntityId = [Target].ConsolidationRegionPropertyEntityId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId --,
		-- [Target].IsPrimary = [Source].IsPrimary

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		ConsolidationRegionPropertyEntityId,
		GlobalRegionId,
		SourceCode,
		PropertyEntityCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId--,
		--IsPrimary
	)
	VALUES (
		[Source].ConsolidationRegionPropertyEntityId,
		[Source].GlobalRegionId,
		[Source].SourceCode,
		[Source].PropertyEntityCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId--,
		--[Source].IsPrimary
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE;
	
SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionPropertyEntity OFF


GO


