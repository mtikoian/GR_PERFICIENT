 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
GO

USE [GDM_GR]
GO


/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotReportingEntityCorporateDepartment table in the GDM_GR database with the 
	dbo.SnapshotReportingEntityCorporateDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/



CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
AS


MERGE
	GDM_GR.dbo.SnapshotReportingEntityCorporateDepartment AS [Target]
USING
	GDM.dbo.SnapshotReportingEntityCorporateDepartment AS [Source]
ON
	[Source].ReportingEntityCorporateDepartmentId = [Target].ReportingEntityCorporateDepartmentId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyFundId = [Source].PropertyFundId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		ReportingEntityCorporateDepartmentId,
		PropertyFundId,
		SourceCode,
		CorporateDepartmentCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsDeleted
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ReportingEntityCorporateDepartmentId,
		[Source].PropertyFundId,
		[Source].SourceCode,
		[Source].CorporateDepartmentCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		0
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE;




GO


