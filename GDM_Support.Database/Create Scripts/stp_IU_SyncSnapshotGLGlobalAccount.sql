 USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccount table in the GDM_GR database with the 
	dbo.SnapshotGLGlobalAccount table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
AS

/*
	OLD							NEW
	--------------------------------------------------------
	GLGlobalAccountId			GLGlobalAccountId
	ActivityTypeId				ActivityTypeId
	GLStatutoryTypeId								[no idea - NEW has no concept of a statutory type - but, we don't use it directly, so UNK]
	ParentGLGlobalAccountId		ParentGLGlobalAccountId
	Code						Code
	Name						Name
	Description
	IsGR
	IsGBS						IsGBS
	IsRegionalOverheadCost		IsRegionalOverheadCost
	IsActive					IsActive
	InsertedDate				InsertedDate
	UpdatedDate					UpdatedDate
	UpdatedByStaffId			UpdatedByStaffId
	ExpenseCzarStaffId								[default to -1]
	ParentCode										[computed field]																			 */

DECLARE @UNKGLStatutoryTypeId INT = (SELECT TOP 1 GLStatutoryTypeId FROM GDM_GR.dbo.GLStatutoryType WHERE Code = 'UNK')


MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccount AS [Target]
USING
	GDM.dbo.SnapshotGLGlobalAccount AS [Source]
ON
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].ActivityTypeId = [Source].ActivityTypeId,
		[Target].ParentGLGlobalAccountId = [Source].ParentGLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsRegionalOverheadCost = [Source].IsRegionalOverheadCost,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLGlobalAccountId,
		ActivityTypeId,
		GLStatutoryTypeId,
		ParentGLGlobalAccountId,
		Code,
		Name,
		[Description],
		IsGR,
		IsGbs,
		IsRegionalOverheadCost,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		ExpenseCzarStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLGlobalAccountId,
		[Source].ActivityTypeId,
		@UNKGLStatutoryTypeId,				-- GLStatutoryTypeId
		[Source].ParentGLGlobalAccountId,
		[Source].Code,
		[Source].Name,
		'',									-- Description
		0,									-- IsGR: set to 0 [we don't actually use this field, we look at the ISGR flag in MRI GACC]
		[Source].IsGBS,
		[Source].IsRegionalOverheadCost,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		-1									-- ExpenseCzarStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table



GO
