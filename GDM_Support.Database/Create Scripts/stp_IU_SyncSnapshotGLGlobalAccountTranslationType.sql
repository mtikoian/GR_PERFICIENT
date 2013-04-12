﻿ USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccountTranslationType table in the GDM_GR database 
	with the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType] AS

DECLARE @GRIncome_GLAccountTypeId INT = (SELECT TOP 1 GLAccountTypeId FROM GDM_GR.dbo.GLAccountType WHERE Code = 'GRPINC')
DECLARE @GRExpense_GLAccountTypeId INT = (SELECT TOP 1 GLAccountTypeId FROM GDM_GR.dbo.GLAccountType WHERE Code = 'GRPEXP')

DECLARE @GRPayroll_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = 'GRPPYR')
DECLARE @GROverhead_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = 'GRPOHD')
DECLARE @GRNonPayroll_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = 'GRPNPR')

MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccountTranslationType AS [Target]
USING
	(
		SELECT
			GAC.GLGlobalAccountId,
			1 AS GLTranslationTypeId,
			CASE
				WHEN
					FinC.InflowOutflow = 'Inflow'
				THEN
					@GRIncome_GLAccountTypeId
				ELSE
					@GRExpense_GLAccountTypeId
			END AS GLAccountTypeId, -- Inflow = GR Income = 3; Outflow = GR Expense = 4
			CASE
				WHEN
					FinC.Name = 'Payroll'
				THEN
					@GRPayroll_GLAccountSubTypeId
				WHEN
					FinC.Name = 'Overhead'
				THEN
					@GROverhead_GLAccountSubTypeId
				ELSE
					@GRNonPayroll_GLAccountSubTypeId -- FinC.Name IN ('Non-Payroll', 'Other Revenue', 'Fee Income', 'Other Expenses')					
			END AS GLAccountSubTypeId,
			GAC.SnapshotId,
			GLGATT.GLGlobalAccountTranslationTypeId,
			GLGATT.InsertedDate,
			GLGATT.UpdatedDate,
			GLGATT.UpdatedByStaffId
		FROM
			GDM.dbo.SnapshotGLGlobalAccountCategorization GAC

			INNER JOIN GDM.dbo.SnapshotGLMinorCategory MinC ON
				GAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId AND
				GAC.SnapshotId = MinC.SnapshotId
			
			INNER JOIN GDM.dbo.SnapshotGLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MinC.SnapshotId = MajC.SnapshotId
				
			INNER JOIN GDM.dbo.SnapshotGLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId AND
				MajC.SnapshotId = FinC.SnapshotId
				
			LEFT OUTER JOIN GDM_GR.dbo.GLGlobalAccountTranslationType GLGATT ON
				GLGATT.GlGlobalAccountId = GAC.GlGlobalAccountId AND
				GLGATT.GlTranslationTypeId = 1 AND
				GLGATT.GLAccountTypeId = 
					(
						CASE
							WHEN
								FinC.InflowOutflow = 'Inflow'
							THEN
								@GRIncome_GLAccountTypeId
							ELSE
								@GRExpense_GLAccountTypeId
						END
					) AND
				GLGATT.GLAccountSubTypeId = 
				(
					CASE
						WHEN
							FinC.Name = 'Payroll'
						THEN
							@GRPayroll_GLAccountSubTypeId
						WHEN
							FinC.Name = 'Overhead'
						THEN
							@GROverhead_GLAccountSubTypeId
						ELSE
							@GRNonPayroll_GLAccountSubTypeId -- FinC.Name IN ('Non-Payroll', 'Other Revenue', 'Fee Income', 'Other Expenses')					
					END
				)
		WHERE
			GAC.GLCategorizationId = 233 AND
			FinC.GLCategorizationId = 233
		
	) AS [Source]
ON
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND -- match where primary keys are equal
	[Source].GLTranslationTypeId = [Target].GLTranslationTypeId AND
	[Source].SnapshotId = [Target].SnapshotId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]'s fields to be equal to [Source]'s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].GLAccountTypeId = [Source].GLAccountTypeId,
		[Target].GLAccountSubTypeId = [Source].GLAccountSubTypeId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn't exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLGlobalAccountTranslationTypeId,
		GLGlobalAccountId,
		GLTranslationTypeId,
		GLAccountTypeId,
		GLAccountSubTypeId,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLGlobalAccountTranslationTypeId,
		[Source].GLGlobalAccountId,
		[Source].GLTranslationTypeId,
		[Source].GLAccountTypeId,
		[Source].GLAccountSubTypeId,
		1,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE AND [Target].GLTranslationTypeId = 1 THEN -- when a record exists in [Target] that doesn't exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don't hard delete the target record as this will probably break FK constraints on this table

GO
