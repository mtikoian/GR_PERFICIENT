 USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]    Script Date: 08/10/2011 12:11:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncReportingEntityCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
GO

USE [GDM_GR]
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ReportingEntityCorporateDepartment table in the GDM_GR database with the 
	dbo.ReportingEntityCorporateDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityCorporateDepartment ON

MERGE
	GDM_GR.dbo.ReportingEntityCorporateDepartment AS [Target]
USING
	GDM.dbo.ReportingEntityCorporateDepartment AS [Source]
ON
	[Source].ReportingEntityCorporateDepartmentId = [Target].ReportingEntityCorporateDepartmentId -- match where primary keys are equal

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
		ReportingEntityCorporateDepartmentId,
		PropertyFundId,
		SourceCode,
		CorporateDepartmentCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ReportingEntityCorporateDepartmentId,
		[Source].PropertyFundId,
		[Source].SourceCode,
		[Source].CorporateDepartmentCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE;

SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityCorporateDepartment OFF


GO


