 USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityPropertyEntity]    Script Date: 08/10/2011 12:13:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncReportingEntityPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
GO

USE [GDM_GR]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityPropertyEntity]    Script Date: 08/10/2011 12:13:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ReportingEntityPropertyEntity table in the GDM_GR database with the 
	dbo.ReportingEntityPropertyEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityPropertyEntity ON

MERGE
	GDM_GR.dbo.ReportingEntityPropertyEntity AS [Target]
USING
	GDM.dbo.ReportingEntityPropertyEntity AS [Source]
ON
	[Source].ReportingEntityPropertyEntityId = [Target].ReportingEntityPropertyEntityId -- match where primary keys are equal

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
		ReportingEntityPropertyEntityId,
		PropertyFundId,
		SourceCode,
		PropertyEntityCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId--,
		--IsPrimary
	)
	VALUES (
		[Source].ReportingEntityPropertyEntityId,
		[Source].PropertyFundId,
		[Source].SourceCode,
		[Source].PropertyEntityCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId--,
		--[Source].IsPrimary
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	DELETE;
	
SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityPropertyEntity OFF


GO


