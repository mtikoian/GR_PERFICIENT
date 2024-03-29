USE [GDM_GR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncMaster]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncMaster]
GO

USE [GDM_GR]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_IU_SyncMaster] AS

EXEC dbo.stp_IU_SyncActivityType
EXEC dbo.stp_IU_SyncBusinessLine
EXEC dbo.stp_IU_SyncActivityTypeBusinessLine
EXEC dbo.stp_IU_SyncEntityType
EXEC dbo.stp_IU_SyncGlobalRegion
EXEC dbo.stp_IU_SyncConsolidationRegionCorporateDepartment
EXEC dbo.stp_IU_SyncConsolidationRegionPropertyEntity
EXEC dbo.stp_IU_SyncManageType
EXEC dbo.stp_IU_SyncManageCorporateDepartment
EXEC dbo.stp_IU_SyncManageCorporateEntity
EXEC dbo.stp_IU_SyncManagePropertyDepartment
EXEC dbo.stp_IU_SyncManagePropertyEntity
EXEC dbo.stp_IU_SyncOriginatingRegionCorporateEntity
EXEC dbo.stp_IU_SyncOriginatingRegionPropertyDepartment
EXEC dbo.stp_IU_SyncPropertyEntityGLAccountInclusion

EXEC dbo.stp_IU_SyncGLGlobalAccount
EXEC dbo.stp_IU_SyncGLGLobalAccountGLAccount
EXEC dbo.stp_IU_SyncGLMajorCategory
EXEC dbo.stp_IU_SyncGLMinorCategory
EXEC dbo.stp_IU_SyncGLGlobalAccountTranslationSubType
EXEC dbo.stp_IU_SyncGLGlobalAccountTranslationType
EXEC dbo.stp_IU_SyncRelatedFund
EXEC dbo.stp_IU_SyncPropertyFund
EXEC dbo.stp_IU_SyncReportingEntityCorporateDepartment
EXEC dbo.stp_IU_SyncReportingEntityPropertyEntity

-- Synchronising the snapshot tables

/*

EXEC dbo.stp_IU_SyncSnapshot
EXEC dbo.stp_IU_SyncSnapshotActivityType
EXEC dbo.stp_IU_SyncSnapshotBusinessLine
EXEC dbo.stp_IU_SyncSnapshotActivityTypeBusinessLine

EXEC dbo.stp_IU_SyncSnapshotEntityType
EXEC dbo.stp_IU_SyncSnapshotGlobalRegion
EXEC dbo.stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment
EXEC dbo.stp_IU_SyncSnapshotConsolidationRegionPropertyEntity
EXEC dbo.stp_IU_SyncSnapshotManageType
EXEC dbo.stp_IU_SyncSnapshotManageCorporateDepartment
EXEC dbo.stp_IU_SyncSnapshotManageCorporateEntity
EXEC dbo.stp_IU_SyncSnapshotManagePropertyDepartment
EXEC dbo.stp_IU_SyncSnapshotManagePropertyEntity

EXEC dbo.stp_IU_SyncSnapshotOriginatingRegionCorporateEntity
EXEC dbo.stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment
EXEC dbo.stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion

EXEC dbo.stp_IU_SyncSnapshotGLTranslationType
EXEC dbo.stp_IU_SyncSnapshotGLTranslationSubType
EXEC dbo.stp_IU_SyncSnapshotGLAccountSubType
EXEC dbo.stp_IU_SyncSnapshotGLAccountType
EXEC dbo.stp_IU_SyncSnapshotGLStatutoryType

EXEC dbo.stp_IU_SyncSnapshotGLGlobalAccount
EXEC dbo.stp_IU_SyncSnapshotGLGLobalAccountGLAccount
EXEC dbo.stp_IU_SyncSnapshotGLMajorCategory
EXEC dbo.stp_IU_SyncSnapshotGLMinorCategory
EXEC dbo.stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType
EXEC dbo.stp_IU_SyncSnapshotGLGlobalAccountTranslationType
EXEC dbo.stp_IU_SyncSnapshotRelatedFund
EXEC dbo.stp_IU_SyncSnapshotPropertyFund
EXEC dbo.stp_IU_SyncSnapshotReportingEntityCorporateDepartment
EXEC dbo.stp_IU_SyncSnapshotReportingEntityPropertyEntity

*/

GO
