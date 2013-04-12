 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotReportingEntityPropertyEntity table in the GDM_GR database with the 
	dbo.SnapshotReportingEntityPropertyEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
AS


MERGE
	GDM_GR.dbo.SnapshotReportingEntityPropertyEntity AS [Target]
USING
	GDM.dbo.SnapshotReportingEntityPropertyEntity AS [Source]
ON
	[Source].ReportingEntityPropertyEntityId = [Target].ReportingEntityPropertyEntityId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyFundId = [Source].PropertyFundId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId --,
		-- [Target].IsPrimary = [Source].IsPrimary

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		ReportingEntityPropertyEntityId,
		PropertyFundId,
		SourceCode,
		PropertyEntityCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsDeleted
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ReportingEntityPropertyEntityId,
		[Source].PropertyFundId,
		[Source].SourceCode,
		[Source].PropertyEntityCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		0
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE;
	

GO


