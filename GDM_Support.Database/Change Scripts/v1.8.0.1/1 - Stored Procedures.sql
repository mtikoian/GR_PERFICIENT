USE [GDM_GR]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncMaster]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncMaster]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncMaster]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLMinorCategory]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLMinorCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLMinorCategory]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccountTranslationType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLMinorCategory]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLMinorCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLMinorCategory]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLMajorCategory]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLMajorCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLMajorCategory]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotPropertyFund]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotPropertyFund]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncReportingEntityCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityPropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncReportingEntityPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGLobalAccountGLAccount]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLGLobalAccountGLAccount]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncPropertyFund]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncPropertyFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncPropertyFund]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManageCorporateEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManagePropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLAccountSubType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLAccountSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLAccountSubType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLAccountType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLAccountType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLAccountType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLTranslationSubType]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLTranslationSubType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationSubType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLMajorCategory]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLMajorCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLMajorCategory]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGlobalAccount]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccount]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncActivityTypeBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncActivityTypeBusinessLine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncActivityTypeBusinessLine]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLTranslationType]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLTranslationType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGlobalRegion]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGlobalRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGlobalRegion]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLStatutoryType]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLStatutoryType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotGLStatutoryType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManageType]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManageType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotManageType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotRelatedFund]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotRelatedFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotRelatedFund]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManageCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManageCorporateDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncManageCorporateDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManageCorporateEntity]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManageCorporateEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncManageCorporateEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManagePropertyDepartment]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManagePropertyDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncManagePropertyDepartment]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManagePropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManagePropertyEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncManagePropertyEntity]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotBusinessLine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotBusinessLine]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotActivityType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshot]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshot]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotEntityType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotEntityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotEntityType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManageType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManageType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncManageType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncRelatedFund]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncRelatedFund]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncRelatedFund]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]    Script Date: 08/24/2011 17:45:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncBusinessLine]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncBusinessLine]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncActivityType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncActivityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncActivityType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncEntityType]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncEntityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncEntityType]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGlobalRegion]    Script Date: 08/24/2011 17:45:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGlobalRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_SyncGlobalRegion]
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGlobalRegion]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGlobalRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GlobalRegion table in the GDM_GR database with the 
	dbo.GlobalRegion table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGlobalRegion]
AS

SET IDENTITY_INSERT GDM_GR.dbo.GlobalRegion ON

MERGE
	GDM_GR.dbo.GlobalRegion AS [Target]
USING
	GDM.dbo.GlobalRegion AS [Source]
ON
	[Source].GlobalRegionId = [Target].GlobalRegionId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
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

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.GlobalRegion OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncEntityType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncEntityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.EntityType table in the GDM_GR database with the 
	dbo.EntityType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncEntityType] AS

SET IDENTITY_INSERT GDM_GR.dbo.EntityType ON

MERGE
	GDM_GR.dbo.EntityType AS [Target]
USING
	GDM.dbo.EntityType AS [Source]
ON
	[Source].EntityTypeId = [Target].EntityTypeId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].ProjectCodePortion = [Source].ProjectCodePortion,
		[Target].[Description] = [Source].[Description],
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		EntityTypeId,
		Name,
		ProjectCodePortion,
		[Description],
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].EntityTypeId,
		[Source].Name,
		[Source].ProjectCodePortion,
		[Source].[Description],
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.EntityType OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncActivityType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncActivityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the ActivityType table in the GDM_GR database with the 
	ActivityType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncActivityType]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ActivityType ON

MERGE
	GDM_GR.dbo.ActivityType AS [Target]
USING
	GDM.dbo.ActivityType AS [Source]
ON
	[Source].ActivityTypeId = [Target].ActivityTypeId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].GLAccountSuffix = [Source].GLAccountSuffix,
		[Target].IsEscalatable = [Source].IsEscalatable,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
		-- [Target].ActivityTypeCode = [Source].ActivityTypeCode, -- can''t update these as they are computed fields
		-- [Target].GLSuffix = [Source].GLSuffix

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ActivityTypeId,
		Code,
		Name,
		GLAccountSuffix,
		IsEscalatable,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
		-- ActivityTypeCode, -- can''t update these as they are computed fields
		-- GLSuffix
	)
	VALUES (
		[Source].ActivityTypeId,
		[Source].Code,
		[Source].Name,
		[Source].GLAccountSuffix,
		[Source].IsEscalatable,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
		-- [Source].ActivityTypeCode, -- can''t update these as they are computed fields
		-- [Source].GLSuffix
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ActivityType OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncBusinessLine]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.BusinessLine table in the GDM_GR database with the 
	dbo.BusinessLine table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncBusinessLine]
AS

SET IDENTITY_INSERT GDM_GR.dbo.BusinessLine ON

MERGE
	GDM_GR.dbo.BusinessLine AS [Target]
USING
	GDM.dbo.BusinessLine AS [Source]
ON
	[Source].BusinessLineId = [Target].BusinessLineId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		BusinessLineId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].BusinessLineId,
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.BusinessLine OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotPropertyEntityGLAccountInclusion table in the GDM_GR database 
	with the dbo.SnapshotPropertyEntityGLAccountInclusion table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]
AS

MERGE
	GDM_GR.dbo.SnapshotPropertyEntityGLAccountInclusion AS [Target]
USING
	GDM.dbo.SnapshotPropertyEntityGLAccountInclusion AS [Source]
ON
	[Source].PropertyEntityGLAccountInclusionId = [Target].PropertyEntityGLAccountInclusionId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].GLAccountCode = [Source].GLAccountCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		PropertyEntityGLAccountInclusionId,
		PropertyEntityCode,
		GLAccountCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].PropertyEntityGLAccountInclusionId,
		[Source].PropertyEntityCode,
		[Source].GLAccountCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncRelatedFund]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncRelatedFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.RelatedFund table in the GDM_GR database with the dbo.RelatedFund table
	in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncRelatedFund]
AS

SET IDENTITY_INSERT GDM_GR.dbo.RelatedFund ON

MERGE
	GDM_GR.dbo.RelatedFund AS [Target]
USING
	GDM.dbo.RelatedFund AS [Source]
ON
	[Source].RelatedFundId = [Target].RelatedFundId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].AbbreviatedName = [Source].AbbreviatedName,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		RelatedFundId,
		Name,
		AbbreviatedName,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].RelatedFundId,
		[Source].Name,
		[Source].AbbreviatedName,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.RelatedFund OFF


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.PropertyEntityGLAccountInclusion table in the GDM_GR database with the 
	dbo.PropertyEntityGLAccountInclusion table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
AS

SET IDENTITY_INSERT GDM_GR.dbo.PropertyEntityGLAccountInclusion ON

MERGE
	GDM_GR.dbo.PropertyEntityGLAccountInclusion AS [Target]
USING
	GDM.dbo.PropertyEntityGLAccountInclusion AS [Source]
ON
	[Source].PropertyEntityGLAccountInclusionId = [Target].PropertyEntityGLAccountInclusionId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].GLAccountCode = [Source].GLAccountCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		PropertyEntityGLAccountInclusionId,
		PropertyEntityCode,
		GLAccountCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].PropertyEntityGLAccountInclusionId,
		[Source].PropertyEntityCode,
		[Source].GLAccountCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.PropertyEntityGLAccountInclusion OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManageType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManageType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ManageType table in the GDM_GR database with the 
	dbo.ManageType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncManageType]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ManageType ON

MERGE
	GDM_GR.dbo.ManageType AS [Target]
USING
	GDM.dbo.ManageType AS [Source]
ON
	[Source].ManageTypeId = [Target].ManageTypeId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].[Description] = [Source].[Description],
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ManageTypeId,
		Code,
		Name,
		[Description],
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ManageTypeId,
		[Source].Code,
		[Source].Name,
		[Source].[Description],
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ManageType OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotEntityType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotEntityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotEntityType table in the GDM_GR database with the 
	dbo.SnapshotEntityType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-08-08		: PKayongo	:	The stored procedure was created.
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotEntityType] AS


MERGE
	GDM_GR.dbo.SnapshotEntityType AS [Target]
USING
	GDM.dbo.SnapshotEntityType AS [Source]
ON
	[Source].EntityTypeId = [Target].EntityTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].ProjectCodePortion = [Source].ProjectCodePortion,
		[Target].[Description] = [Source].[Description],
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		EntityTypeId,
		Name,
		ProjectCodePortion,
		[Description],
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].EntityTypeId,
		[Source].Name,
		[Source].ProjectCodePortion,
		[Source].[Description],
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshot]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshot]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.Snapshot table in the GDM_GR database with the 
	dbo.Snapshot table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshot]
AS

SET IDENTITY_INSERT GDM_GR.dbo.Snapshot ON

MERGE
	GDM_GR.dbo.Snapshot AS [Target]
USING
	GDM.dbo.Snapshot AS [Source]
ON
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GroupName = [Source].GroupName,
		[Target].GroupKey = [Source].GroupKey,
		[Target].IsLocked = [Source].IsLocked,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].LastSyncDate = [Source].LastSyncDate,
		[Target].ManualUpdatedDate = [Source].ManualUpdatedDate

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		GroupName,
		GroupKey,
		IsLocked,
		InsertedDate,
		LastSyncDate,
		ManualUpdatedDate
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GroupName,
		[Source].GroupKey,
		[Source].IsLocked,
		[Source].InsertedDate,
		[Source].LastSyncDate,
		[Source].ManualUpdatedDate
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE; -- 

SET IDENTITY_INSERT GDM_GR.dbo.Snapshot OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotActivityType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotActivityType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotActivityType table in the GDM_GR database with the 
	dbo.SnapshotActivityType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityType]
AS



MERGE
	GDM_GR.dbo.SnapshotActivityType AS [Target]
USING
	GDM.dbo.SnapshotActivityType AS [Source]
ON
	[Source].ActivityTypeId = [Target].ActivityTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].GLAccountSuffix = [Source].GLAccountSuffix,
		[Target].IsEscalatable = [Source].IsEscalatable,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
		-- [Target].ActivityTypeCode = [Source].ActivityTypeCode, -- can''t update these as they are computed fields
		-- [Target].GLSuffix = [Source].GLSuffix

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ActivityTypeId,
		Code,
		Name,
		GLAccountSuffix,
		IsEscalatable,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
		-- ActivityTypeCode, -- can''t update these as they are computed fields
		-- GLSuffix
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ActivityTypeId,
		[Source].Code,
		[Source].Name,
		[Source].GLAccountSuffix,
		[Source].IsEscalatable,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
		-- [Source].ActivityTypeCode, -- can''t update these as they are computed fields
		-- [Source].GLSuffix
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotBusinessLine]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotBusinessLine table in the GDM_GR database with the 
	dbo.SnapshotBusinessLine table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotBusinessLine]
AS


MERGE
	GDM_GR.dbo.SnapshotBusinessLine AS [Target]
USING
	GDM.dbo.SnapshotBusinessLine AS [Source]
ON
	[Source].BusinessLineId = [Target].BusinessLineId AND-- match where primary keys are equal
	[Source].SnapshotId = [Target].SnapshotId
	
WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		BusinessLineId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].BusinessLineId,
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManagePropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManagePropertyEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ManagePropertyEntity table in the GDM_GR database with the 
	dbo.ManagePropertyEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncManagePropertyEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ManagePropertyEntity ON

MERGE
	GDM_GR.dbo.ManagePropertyEntity AS [Target]
USING
	GDM.dbo.ManagePropertyEntity AS [Source]
ON
	[Source].ManagePropertyEntityId = [Target].ManagePropertyEntityId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ManagePropertyEntityId,
		ManageTypeId,
		PropertyEntityCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ManagePropertyEntityId,
		[Source].ManageTypeId,
		[Source].PropertyEntityCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ManagePropertyEntity OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManagePropertyDepartment]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManagePropertyDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ManagePropertyDepartment table in the GDM_GR database with the 
	dbo.ManagePropertyDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncManagePropertyDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ManagePropertyDepartment ON

MERGE
	GDM_GR.dbo.ManagePropertyDepartment AS [Target]
USING
	GDM.dbo.ManagePropertyDepartment AS [Source]
ON
	[Source].ManagePropertyDepartmentId = [Target].ManagePropertyDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].PropertyDepartmentCode = [Source].PropertyDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ManagePropertyDepartmentId,
		ManageTypeId,
		PropertyDepartmentCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ManagePropertyDepartmentId,
		[Source].ManageTypeId,
		[Source].PropertyDepartmentCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ManagePropertyDepartment OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManageCorporateEntity]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManageCorporateEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ManageCorporateEntity table in the GDM_GR database with the 
	dbo.ManageCorporateEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncManageCorporateEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ManageCorporateEntity ON

MERGE
	GDM_GR.dbo.ManageCorporateEntity AS [Target]
USING
	GDM.dbo.ManageCorporateEntity AS [Source]
ON
	[Source].ManageCorporateEntityId = [Target].ManageCorporateEntityId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].CorporateEntityCode = [Source].CorporateEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ManageCorporateEntityId,
		ManageTypeId,
		CorporateEntityCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ManageCorporateEntityId,
		[Source].ManageTypeId,
		[Source].CorporateEntityCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ManageCorporateEntity OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncManageCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncManageCorporateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ManageCorporateDepartment table in the GDM_GR database with the 
	dbo.ManageCorporateDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncManageCorporateDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ManageCorporateDepartment ON

MERGE
	GDM_GR.dbo.ManageCorporateDepartment AS [Target]
USING
	GDM.dbo.ManageCorporateDepartment AS [Source]
ON
	[Source].ManageCorporateDepartmentId = [Target].ManageCorporateDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ManageCorporateDepartmentId,
		ManageTypeId,
		CorporateDepartmentCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].ManageCorporateDepartmentId,
		[Source].ManageTypeId,
		[Source].CorporateDepartmentCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ManageCorporateDepartment OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.OriginatingRegionPropertyDepartment table in the GDM_GR database with the 
	dbo.OriginatingRegionPropertyDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionPropertyDepartment ON

MERGE
	GDM_GR.dbo.OriginatingRegionPropertyDepartment AS [Target]
USING
	GDM.dbo.OriginatingRegionPropertyDepartment AS [Source]
ON
	[Source].OriginatingRegionPropertyDepartmentId = [Target].OriginatingRegionPropertyDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].PropertyDepartmentCode = [Source].PropertyDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		OriginatingRegionPropertyDepartmentId,
		GlobalRegionId,
		PropertyDepartmentCode,
		SourceCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].OriginatingRegionPropertyDepartmentId,
		[Source].GlobalRegionId,
		[Source].PropertyDepartmentCode,
		[Source].SourceCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	DELETE; -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionPropertyDepartment OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.OriginatingRegionCorporateEntity table in the GDM_GR database with the 
	dbo.OriginatingRegionCorporateEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionCorporateEntity ON

MERGE
	GDM_GR.dbo.OriginatingRegionCorporateEntity AS [Target]
USING
	GDM.dbo.OriginatingRegionCorporateEntity AS [Source]
ON
	[Source].OriginatingRegionCorporateEntityId = [Target].OriginatingRegionCorporateEntityId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].CorporateEntityCode = [Source].CorporateEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		-- [Target].IsDeleted = [Source].IsDeleted,  -- IsDeleted has been removed from this table: only hard deletes are possible
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		OriginatingRegionCorporateEntityId,
		GlobalRegionId,
		CorporateEntityCode,
		SourceCode,
		-- IsDeleted, -- IsDeleted has been removed from this table: only hard deletes are possible
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].OriginatingRegionCorporateEntityId,
		[Source].GlobalRegionId,
		[Source].CorporateEntityCode,
		[Source].SourceCode,
		-- [Source].IsDeleted, -- IsDeleted has been removed from this table: only hard deletes are possible
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	DELETE;

SET IDENTITY_INSERT GDM_GR.dbo.OriginatingRegionCorporateEntity OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotRelatedFund]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotRelatedFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotRelatedFund table in the GDM_GR database with the dbo.SnapshotRelatedFund 
	table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotRelatedFund]
AS


MERGE
	GDM_GR.dbo.SnapshotRelatedFund AS [Target]
USING
	GDM.dbo.SnapshotRelatedFund AS [Source]
ON
	[Source].RelatedFundId = [Target].RelatedFundId AND
	[Source].SnapshotId = [Target].SnapshotId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields
	UPDATE SET
		[Target].Name = [Source].Name,
		[Target].AbbreviatedName = [Source].AbbreviatedName,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		RelatedFundId,
		Name,
		AbbreviatedName,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].RelatedFundId,
		[Source].Name,
		[Source].AbbreviatedName,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManageType]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManageType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotManageType table in the GDM_GR database 
	with the dbo.SnapshotManageType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotManageType]
AS

MERGE
	GDM_GR.dbo.SnapshotManageType AS [Target]
USING
	GDM.dbo.SnapshotManageType AS [Source]
ON
	[Source].ManageTypeId = [Target].ManageTypeId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].[Description] = [Source].[Description],
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ManageTypeId,
		Code,
		Name,
		[Description],
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ManageTypeId,
		[Source].Code,
		[Source].Name,
		[Source].[Description],
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLStatutoryType]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLStatutoryType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLStatutoryType table in the GDM_GR database 
	with the dbo.SnapshotGLStatutoryType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLStatutoryType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLStatutoryType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLAST.[GLStatutoryTypeId],
			GLAST.[Code],
			GLAST.[Name],
			GLAST.[Description],
			GLAST.[IsActive],
			GLAST.[InsertedDate],
			GLAST.[UpdatedDate],
			GLAST.[UpdatedByStaffId]
		FROM
			GDM_GR.dbo.GLStatutoryType GLAST 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLStatutoryTypeId = [Target].GLStatutoryTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].[Description] = [Source].[Description],
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLStatutoryTypeId],
		[Code],
		[Name],
		[Description],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLStatutoryTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[Description],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGlobalRegion]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGlobalRegion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
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

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
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

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLTranslationType]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLTranslationType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLTranslationType table in the GDM_GR database 
	with the dbo.SnapshotGLTranslationType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLTranslationType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLTT.[GLTranslationTypeId],
			GLTT.[Code],
			GLTT.[Name],
			GLTT.[Description],
			GLTT.[IsActive],
			GLTT.[InsertedDate],
			GLTT.[UpdatedDate],
			GLTT.[UpdatedByStaffId]
		FROM
			GDM_GR.dbo.GLTranslationType GLTT 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLTranslationTypeId = [Target].GLTranslationTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].[Description] = [Source].[Description],
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLTranslationTypeId],
		[Code],
		[Name],
		[Description],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[Description],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncActivityTypeBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncActivityTypeBusinessLine]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the ActivityTypeBusinessLine table in the GDM_GR database with the 
	ActivityTypeBusinessLine table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncActivityTypeBusinessLine]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ActivityTypeBusinessLine ON

MERGE
	GDM_GR.dbo.ActivityTypeBusinessLine AS [Target]
USING
	GDM.dbo.ActivityTypeBusinessLine AS [Source]
ON
	[Source].ActivityTypeBusinessLineId = [Target].ActivityTypeBusinessLineId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ActivityTypeId = [Source].ActivityTypeId,
		[Target].BusinessLineId = [Source].BusinessLineId,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId,
		[Target].IsActive = [Source].IsActive

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		ActivityTypeBusinessLineId,
		ActivityTypeId,
		BusinessLineId,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsActive
	)
	VALUES (
		[Source].ActivityTypeBusinessLineId,
		[Source].ActivityTypeId,
		[Source].BusinessLineId,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		[Source].IsActive
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.ActivityTypeBusinessLine OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGlobalAccount]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLGlobalAccount table in the GDM_GR database with the 
	dbo.GLGlobalAccount table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccount]
AS

/*
	OLD							NEW
	--------------------------------------------------------
	GLGlobalAccountId			GLGlobalAccountId
	ActivityTypeId				ActivityTypeId
	GLStatutoryTypeId								[no idea - NEW has no concept of a statutory type - but, we don''t use it directly, so UNK]
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

DECLARE @UNKGLStatutoryTypeId INT = (SELECT TOP 1 GLStatutoryTypeId FROM GDM_GR.dbo.GLStatutoryType WHERE Code = ''UNK'')

SET IDENTITY_INSERT GDM_GR.dbo.GLGlobalAccount ON

MERGE
	GDM_GR.dbo.GLGlobalAccount AS [Target]
USING
	GDM.dbo.GLGlobalAccount AS [Source]
ON
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ActivityTypeId = [Source].ActivityTypeId,
		[Target].ParentGLGlobalAccountId = [Source].ParentGLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsRegionalOverheadCost = [Source].IsRegionalOverheadCost,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
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
		[Source].GLGlobalAccountId,
		[Source].ActivityTypeId,
		@UNKGLStatutoryTypeId,				-- GLStatutoryTypeId
		[Source].ParentGLGlobalAccountId,
		[Source].Code,
		[Source].Name,
		'''',									-- Description
		0,									-- IsGR: set to 0 [we don''t actually use this field, we look at the ISGR flag in MRI GACC]
		[Source].IsGBS,
		[Source].IsRegionalOverheadCost,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		-1									-- ExpenseCzarStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.GLGlobalAccount OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionPropertyEntity ON

MERGE
	GDM_GR.dbo.ConsolidationRegionPropertyEntity AS [Target]
USING
	GDM.dbo.ConsolidationRegionPropertyEntity AS [Source]
ON
	[Source].ConsolidationRegionPropertyEntityId = [Target].ConsolidationRegionPropertyEntityId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId --,
		-- [Target].IsPrimary = [Source].IsPrimary

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;
	
SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionPropertyEntity OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
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

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;

SET IDENTITY_INSERT GDM_GR.dbo.ConsolidationRegionCorporateDepartment OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLMajorCategory]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLMajorCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLMajorCategory table in the GDM_GR database with the 
	dbo.GLMajorCategory table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLMajorCategory] AS

SET IDENTITY_INSERT GDM_GR.dbo.GLMajorCategory ON

MERGE
	GDM_GR.dbo.GLMajorCategory AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.GLMajorCategory
		WHERE
			GLCategorizationId = 233 -- we''re only syncing GLOBAL
	) AS [Source]
ON
	[Source].GLMajorCategoryId = [Target].GLMajorCategoryId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		GLMajorCategoryId,
		GLTranslationSubTypeId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLMajorCategoryId,
		[Source].GLCategorizationId, -- should always be 233 because of the (WHERE GLCategorizationId = 233) filter above
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.GLMajorCategory OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLTranslationSubType]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLTranslationSubType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLTranslationSubType table in the GDM_GR database 
	with the dbo.SnapshotGLTranslationSubType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLTranslationSubType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLTranslationSubType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLTST.[GLTranslationSubTypeId],
			GLTST.[GLTranslationTypeId],
			GLTST.[Code],
			GLTST.[Name],
			GLTST.[IsActive],
			GLTST.[Version],
			GLTST.[InsertedDate],
			GLTST.[UpdatedDate],
			GLTST.[UpdatedByStaffId],
			GLTST.[IsGRDefault]
		FROM
			GDM_GR.dbo.GLTranslationSubType GLTST 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLTranslationSubTypeId = [Target].GLTranslationSubTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId,
		[Target].IsGRDefault = [Source].IsGRDefault
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLTranslationSubTypeId],
		[GLTranslationTypeId],
		[Code],
		[Name],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId],
		[IsGRDefault]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLTranslationSubTypeId],
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId],
			[Source].[IsGRDefault]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
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
	GLStatutoryTypeId								[no idea - NEW has no concept of a statutory type - but, we don''t use it directly, so UNK]
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

DECLARE @UNKGLStatutoryTypeId INT = (SELECT TOP 1 GLStatutoryTypeId FROM GDM_GR.dbo.GLStatutoryType WHERE Code = ''UNK'')


MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccount AS [Target]
USING
	GDM.dbo.SnapshotGLGlobalAccount AS [Source]
ON
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ActivityTypeId = [Source].ActivityTypeId,
		[Target].ParentGLGlobalAccountId = [Source].ParentGLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsRegionalOverheadCost = [Source].IsRegionalOverheadCost,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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
		'''',									-- Description
		0,									-- IsGR: set to 0 [we don''t actually use this field, we look at the ISGR flag in MRI GACC]
		[Source].IsGBS,
		[Source].IsRegionalOverheadCost,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		-1									-- ExpenseCzarStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLAccountType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLAccountType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLAccountSubType table in the GDM_GR database 
	with the dbo.SnapshotGLAccountSubType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLAccountType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLAccountType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLAST.[GLAccountTypeId],
			GLAST.[GLTranslationTypeId],
			GLAST.[Code],
			GLAST.[Name],
			GLAST.[IsActive],
			GLAST.[InsertedDate],
			GLAST.[UpdatedDate],
			GLAST.[UpdatedByStaffId]
		FROM
			GDM_GR.dbo.GLAccountType GLAST 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLAccountTypeId = [Target].GLAccountTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLAccountTypeId],
		[GLTranslationTypeId],
		[Code],
		[Name],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLAccountTypeId],
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLAccountSubType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLAccountSubType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLAccountSubType table in the GDM_GR database 
	with the dbo.SnapshotGLAccountSubType table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLAccountSubType]
AS


MERGE
	GDM_GR.dbo.SnapshotGLAccountSubType AS [Target]
USING
	(
		SELECT
			S.SnapshotId,
			GLAST.[GLAccountSubTypeId],
			GLAST.[GLTranslationTypeId],
			GLAST.[Code],
			GLAST.[Name],
			GLAST.[IsActive],
			GLAST.[InsertedDate],
			GLAST.[UpdatedDate],
			GLAST.[UpdatedByStaffId]
		FROM
			GDM_GR.dbo.GLAccountSubType GLAST 
			
			CROSS JOIN GDM_GR.dbo.[Snapshot] S
	)
	AS [Source]
ON
	[Source].GLAccountSubTypeId = [Target].GLAccountSubTypeId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].Code = [Source].Code,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,  
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId
WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		[GLAccountSubTypeId],
		[GLTranslationTypeId],
		[Code],
		[Name],
		[IsActive],
		[InsertedDate],
		[UpdatedDate],
		[UpdatedByStaffId]
	)
	VALUES (
			[Source].SnapshotId,
			[Source].[GLAccountSubTypeId],
			[Source].[GLTranslationTypeId],
			[Source].[Code],
			[Source].[Name],
			[Source].[IsActive],
			[Source].[InsertedDate],
			[Source].[UpdatedDate],
			[Source].[UpdatedByStaffId]
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	UPDATE SET
		[Target].IsActive = 0;


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManagePropertyEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotManagePropertyEntity table in the GDM_GR database 
	with the dbo.SnapshotManagePropertyEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]
AS



MERGE
	GDM_GR.dbo.SnapshotManagePropertyEntity AS [Target]
USING
	GDM.dbo.SnapshotManagePropertyEntity AS [Source]
ON
	[Source].ManagePropertyEntityId = [Target].ManagePropertyEntityId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ManagePropertyEntityId,
		ManageTypeId,
		PropertyEntityCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ManagePropertyEntityId,
		[Source].ManageTypeId,
		[Source].PropertyEntityCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotManagePropertyDepartment table in the GDM_GR database 
	with the dbo.SnapshotManagePropertyDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]
AS


MERGE
	GDM_GR.dbo.SnapshotManagePropertyDepartment AS [Target]
USING
	GDM.dbo.SnapshotManagePropertyDepartment AS [Source]
ON
	[Source].ManagePropertyDepartmentId = [Target].ManagePropertyDepartmentId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].PropertyDepartmentCode = [Source].PropertyDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ManagePropertyDepartmentId,
		ManageTypeId,
		PropertyDepartmentCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ManagePropertyDepartmentId,
		[Source].ManageTypeId,
		[Source].PropertyDepartmentCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManageCorporateEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotManageCorporateEntity table in the GDM_GR database 
	with the dbo.SnapshotManageCorporateEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]
AS


MERGE
	GDM_GR.dbo.SnapshotManageCorporateEntity AS [Target]
USING
	GDM.dbo.SnapshotManageCorporateEntity AS [Source]
ON
	[Source].ManageCorporateEntityId = [Target].ManageCorporateEntityId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].CorporateEntityCode = [Source].CorporateEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ManageCorporateEntityId,
		ManageTypeId,
		CorporateEntityCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ManageCorporateEntityId,
		[Source].ManageTypeId,
		[Source].CorporateEntityCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotManageCorporateDepartment table in the GDM_GR database 
	with the dbo.SnapshotManageCorporateDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]
AS

MERGE
	GDM_GR.dbo.SnapshotManageCorporateDepartment AS [Target]
USING
	GDM.dbo.SnapshotManageCorporateDepartment AS [Source]
ON
	[Source].ManageCorporateDepartmentId = [Target].ManageCorporateDepartmentId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ManageTypeId = [Source].ManageTypeId,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].IsDeleted = [Source].IsDeleted,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ManageCorporateDepartmentId,
		ManageTypeId,
		CorporateDepartmentCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ManageCorporateDepartmentId,
		[Source].ManageTypeId,
		[Source].CorporateDepartmentCode,
		[Source].SourceCode,
		[Source].IsDeleted,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsDeleted = 1; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotOriginatingRegionPropertyDepartment table in the GDM_GR database 
	with the dbo.SnapshotOriginatingRegionPropertyDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]
AS

MERGE
	GDM_GR.dbo.SnapshotOriginatingRegionPropertyDepartment AS [Target]
USING
	GDM.dbo.SnapshotOriginatingRegionPropertyDepartment AS [Source]
ON
	[Source].OriginatingRegionPropertyDepartmentId = [Target].OriginatingRegionPropertyDepartmentId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].PropertyDepartmentCode = [Source].PropertyDepartmentCode,
		[Target].SourceCode = [Source].SourceCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		OriginatingRegionPropertyDepartmentId,
		GlobalRegionId,
		PropertyDepartmentCode,
		SourceCode,
		IsDeleted,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].OriginatingRegionPropertyDepartmentId,
		[Source].GlobalRegionId,
		[Source].PropertyDepartmentCode,
		[Source].SourceCode,
		0,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	DELETE; -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotOriginatingRegionCorporateEntity table in the GDM_GR database 
	with the dbo.SnapshotOriginatingRegionCorporateEntity table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]
AS


MERGE
	GDM_GR.dbo.SnapshotOriginatingRegionCorporateEntity AS [Target]
USING
	GDM.dbo.SnapshotOriginatingRegionCorporateEntity AS [Source]
ON
	[Source].OriginatingRegionCorporateEntityId = [Target].OriginatingRegionCorporateEntityId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].CorporateEntityCode = [Source].CorporateEntityCode,
		[Target].SourceCode = [Source].SourceCode,
		-- [Target].IsDeleted = [Source].IsDeleted,  -- IsDeleted has been removed from this table: only hard deletes are possible
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		OriginatingRegionCorporateEntityId,
		GlobalRegionId,
		CorporateEntityCode,
		SourceCode,
		IsDeleted, -- IsDeleted has been removed from this table: only hard deletes are possible
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].OriginatingRegionCorporateEntityId,
		[Source].GlobalRegionId,
		[Source].CorporateEntityCode,
		[Source].SourceCode,
		0,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target]
	DELETE;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncPropertyFund]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncPropertyFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.PropertyFund table in the GDM_GR database with the dbo.PropertyFund table
	in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncPropertyFund]
AS

SET IDENTITY_INSERT GDM_GR.dbo.PropertyFund ON

MERGE
	GDM_GR.dbo.PropertyFund AS [Target]
USING
	GDM.dbo.PropertyFund AS [Source]
ON
	[Source].PropertyFundId = [Target].PropertyFundId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields
	UPDATE SET
		[Target].RelatedFundId = [Source].RelatedFundId,
		[Target].EntityTypeId = [Source].EntityTypeId,
		[Target].AllocationSubRegionGlobalRegionId = [Source].AllocationSubRegionGlobalRegionId,
		[Target].BudgetOwnerStaffId = ISNULL([Source].BudgetOwnerStaffId, -1),
		[Target].RegionalOwnerStaffId = ISNULL([Source].RegionalOwnerStaffId, -1),
		--[Target].DefaultGLTranslationSubTypeId = [Source].DefaultGLTranslationSubTypeId,
		[Target].Name = [Source].Name,
		[Target].IsReportingEntity = [Source].IsReportingEntity,
		[Target].IsPropertyFund = [Source].IsPropertyFund,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		PropertyFundId,
		RelatedFundId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId,
		BudgetOwnerStaffId,
		RegionalOwnerStaffId,
		DefaultGLTranslationSubTypeId,
		Name,
		IsReportingEntity,
		IsPropertyFund,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].PropertyFundId,
		[Source].RelatedFundId,
		[Source].EntityTypeId,
		[Source].AllocationSubRegionGlobalRegionId,
		ISNULL([Source].BudgetOwnerStaffId, -1),
		ISNULL([Source].RegionalOwnerStaffId, -1),
		233, --  we can''t update this: just default to GLOBAL (233) in the mean time
		[Source].Name,
		[Source].IsPropertyFund,
		[Source].IsPropertyFund,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.PropertyFund OFF


' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]
AS



MERGE
	GDM_GR.dbo.SnapshotConsolidationRegionPropertyEntity AS [Target]
USING
	GDM.dbo.SnapshotConsolidationRegionPropertyEntity AS [Source]
ON
	[Source].ConsolidationRegionPropertyEntityId = [Target].ConsolidationRegionPropertyEntityId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId --,
		-- [Target].IsPrimary = [Source].IsPrimary

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
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
		[Source].SnapshotId,
		[Source].ConsolidationRegionPropertyEntityId,
		[Source].GlobalRegionId,
		[Source].SourceCode,
		[Source].PropertyEntityCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId--,
		--[Source].IsPrimary
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.ConsolidationRegionCorporateDepartment table in the GDM_GR database with the 
	dbo.ConsolidationRegionCorporateDepartment table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]
AS

MERGE
	GDM_GR.dbo.SnapshotConsolidationRegionCorporateDepartment AS [Target]
USING
	GDM.dbo.SnapshotConsolidationRegionCorporateDepartment AS [Source]
ON
	[Source].ConsolidationRegionCorporateDepartmentId = [Target].ConsolidationRegionCorporateDepartmentId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GlobalRegionId = [Source].GlobalRegionId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ConsolidationRegionCorporateDepartmentId,
		GlobalRegionId,
		SourceCode,
		CorporateDepartmentCode,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ConsolidationRegionCorporateDepartmentId,
		[Source].GlobalRegionId,
		[Source].SourceCode,
		[Source].CorporateDepartmentCode,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotActivityTypeBusinessLine table in the GDM_GR database with the 
	dbo.SnapshotActivityTypeBusinessLine table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
AS



MERGE
	GDM_GR.dbo.SnapshotActivityTypeBusinessLine AS [Target]
USING
	GDM.dbo.SnapshotActivityTypeBusinessLine AS [Source]
ON
	[Source].ActivityTypeBusinessLineId = [Target].ActivityTypeBusinessLineId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].ActivityTypeId = [Source].ActivityTypeId,
		[Target].BusinessLineId = [Source].BusinessLineId,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId,
		[Target].IsActive = [Source].IsActive

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		ActivityTypeBusinessLineId,
		ActivityTypeId,
		BusinessLineId,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsActive
	)
	VALUES (
		[Source].SnapshotId,
		[Source].ActivityTypeBusinessLineId,
		[Source].ActivityTypeId,
		[Source].BusinessLineId,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId,
		[Source].IsActive
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGLobalAccountGLAccount]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLGlobalAccountGLAccount table in the GDM_GR database with the 
	GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLGLobalAccountGLAccount] AS

/*
	OLD							NEW
	--------------------------------------------------------
	GLGlobalAccountGLAccountId	GLAccountId
	GLGlobalAccount				GLGlobalAccount
	Code						Code
	SourceCode					SourceCode
	Name						Name
	Description										[Default to '''']
	PreGlobalAccountCode
								EnglishName
								Type
								LastDate
	IsActive					IsActive
								IsHistoric
								IsGlobalReporting
								IsServiceCharge
								IsDirectRecharge
	InsertedDate				InsertedDate
	UpdatedDate					UpdatedDate
	UpdatedByStaffId			UpdatedByStaffId																									 */


MERGE
	GDM_GR.dbo.GLGlobalAccountGLAccount AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.GLAccount
		WHERE
			GLGlobalAccountId IS NOT NULL
	)  AS [Source]
ON
	[Source].SourceCode = [Target].SourceCode AND -- can''t match primary keys as GLGlobalAccountGLAccountId and GLAccountId are different fields
	[Source].Code = [Target].Code AND
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].SourceCode = [Source].SourceCode,
		[Target].Name = [Source].Name,
		[Target].[Description] = '''',							-- Description: doesn''t exist in dbo.GLAccount, so default to ''''
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		GLGlobalAccountId,
		SourceCode,
		Code,
		Name,
		[Description],
		PreGlobalAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLGlobalAccountId,
		[Source].SourceCode,
		[Source].Code,
		[Source].Name,
		'''',							-- Description: doesn''t exist in dbo.GLAccount, so default to ''''
		NULL,						-- PreGlobalAccountCode: doesn''t exist in dbo.GLAccount, so default to NULL
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target].
	DELETE;						-- can''t deactivate as there is a good chance that dbo.GLGlobalAccountGLAccount_SourceCode_Code_IsActive_UniqueIndex
								-- will be triggered, causing the statement to fail.
								-- Deleting should be fine as there are no foreign key constraints onto dbo.GLGlobalAccountGLAccount
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityPropertyEntity]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncReportingEntityPropertyEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
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

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyFundId = [Source].PropertyFundId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId --,
		-- [Target].IsPrimary = [Source].IsPrimary

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;
	
SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityPropertyEntity OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncReportingEntityCorporateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
AS

SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityCorporateDepartment ON

MERGE
	GDM_GR.dbo.ReportingEntityCorporateDepartment AS [Target]
USING
	GDM.dbo.ReportingEntityCorporateDepartment AS [Source]
ON
	[Source].ReportingEntityCorporateDepartmentId = [Target].ReportingEntityCorporateDepartmentId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyFundId = [Source].PropertyFundId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;

SET IDENTITY_INSERT GDM_GR.dbo.ReportingEntityCorporateDepartment OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotPropertyFund]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotPropertyFund]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotPropertyFund table in the GDM_GR database with the 
	dbo.SnapshotPropertyFund table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotPropertyFund]
AS


MERGE
	GDM_GR.dbo.SnapshotPropertyFund AS [Target]
USING
	GDM.dbo.SnapshotPropertyFund AS [Source]
ON
	[Source].PropertyFundId = [Target].PropertyFundId AND
	[Source].SnapshotId = [Target].SnapshotId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields
	UPDATE SET
		[Target].RelatedFundId = [Source].RelatedFundId,
		[Target].EntityTypeId = [Source].EntityTypeId,
		[Target].AllocationSubRegionGlobalRegionId = [Source].AllocationSubRegionGlobalRegionId,
		[Target].BudgetOwnerStaffId = ISNULL([Source].BudgetOwnerStaffId, -1),
		[Target].RegionalOwnerStaffId = ISNULL([Source].RegionalOwnerStaffId, -1),
		--[Target].DefaultGLTranslationSubTypeId = [Source].DefaultGLTranslationSubTypeId,
		[Target].Name = [Source].Name,
		[Target].IsReportingEntity = [Source].IsReportingEntity,
		[Target].IsPropertyFund = [Source].IsPropertyFund,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		PropertyFundId,
		RelatedFundId,
		EntityTypeId,
		AllocationSubRegionGlobalRegionId,
		BudgetOwnerStaffId,
		RegionalOwnerStaffId,
		DefaultGLTranslationSubTypeId,
		Name,
		IsReportingEntity,
		IsPropertyFund,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].PropertyFundId,
		[Source].RelatedFundId,
		[Source].EntityTypeId,
		[Source].AllocationSubRegionGlobalRegionId,
		ISNULL([Source].BudgetOwnerStaffId, -1),
		ISNULL([Source].RegionalOwnerStaffId, -1),
		233, --  we can''t update this: just default to GLOBAL (233) in the mean time
		[Source].Name,
		[Source].IsPropertyFund,
		[Source].IsPropertyFund,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table



' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLMajorCategory]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLMajorCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLMajorCategory table in the GDM_GR database 
	with the dbo.SnapshotGLMajorCategory table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLMajorCategory] AS



MERGE
	GDM_GR.dbo.SnapshotGLMajorCategory AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.SnapshotGLMajorCategory
		WHERE
			GLCategorizationId = 233 -- we''re only syncing GLOBAL
	) AS [Source]
ON
	[Source].GLMajorCategoryId = [Target].GLMajorCategoryId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLMajorCategoryId,
		GLTranslationSubTypeId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLMajorCategoryId,
		[Source].GLCategorizationId, -- should always be 233 because of the (WHERE GLCategorizationId = 233) filter above
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLMinorCategory]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLMinorCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLMinorCategory table in the GDM_GR database with the 
	dbo.GLMinorCategory table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLMinorCategory]
AS

SET IDENTITY_INSERT GDM_GR.dbo.GLMinorCategory ON

MERGE
	GDM_GR.dbo.GLMinorCategory AS [Target]
USING
	(
		SELECT
			MinC.*,
			MajC.GLCategorizationId
		FROM
			GDM.dbo.GLMinorCategory MinC
			INNER JOIN GDM.dbo.GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId
		WHERE
			MajC.GLCategorizationId = 233
	) AS [Source]
ON
	[Source].GLMinorCategoryId = [Target].GLMinorCategoryId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLMajorCategoryId = [Source].GLMajorCategoryId,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET AND [Source].GLCategorizationId = 233 THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		GLMinorCategoryId,
		GLMajorCategoryId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLMinorCategoryId,
		[Source].GLMajorCategoryId,
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.GLMinorCategory OFF
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccountTranslationType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLGlobalAccountTranslationType table in the GDM_GR database with the 
	GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccountTranslationType] AS

DECLARE @GRIncome_GLAccountTypeId INT = (SELECT TOP 1 GLAccountTypeId FROM GDM_GR.dbo.GLAccountType WHERE Code = ''GRPINC'')
DECLARE @GRExpense_GLAccountTypeId INT = (SELECT TOP 1 GLAccountTypeId FROM GDM_GR.dbo.GLAccountType WHERE Code = ''GRPEXP'')

DECLARE @GRPayroll_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = ''GRPPYR'')
DECLARE @GROverhead_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = ''GRPOHD'')
DECLARE @GRNonPayroll_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = ''GRPNPR'')

MERGE
	GDM_GR.dbo.GLGlobalAccountTranslationType AS [Target]
USING
	(
		SELECT
			GAC.GLGlobalAccountId,
			1 AS GLTranslationTypeId,
			CASE
				WHEN
					FinC.InflowOutflow = ''Inflow''
				THEN
					@GRIncome_GLAccountTypeId
				ELSE
					@GRExpense_GLAccountTypeId
			END AS GLAccountTypeId, -- Inflow = GR Income = 3; Outflow = GR Expense = 4
			CASE
				WHEN
					FinC.Name = ''Payroll''
				THEN
					@GRPayroll_GLAccountSubTypeId
				WHEN
					FinC.Name = ''Overhead''
				THEN
					@GROverhead_GLAccountSubTypeId
				ELSE
					@GRNonPayroll_GLAccountSubTypeId -- FinC.Name IN (''Non-Payroll'', ''Other Revenue'', ''Fee Income'', ''Other Expenses'')					
			END AS GLAccountSubTypeId
		FROM
			GDM.dbo.GLGlobalAccountCategorization GAC

			INNER JOIN GDM.dbo.GLMinorCategory MinC ON
				GAC.DirectGLMinorCategoryId = MinC.GLMinorCategoryId
			
			INNER JOIN GDM.dbo.GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId
				
			INNER JOIN GDM.dbo.GLFinancialCategory FinC ON
				MajC.GLFinancialCategoryId = FinC.GLFinancialCategoryId
		WHERE
			GAC.GLCategorizationId = 233 AND
			FinC.GLCategorizationId = 233
		
	) AS [Source]
ON
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND -- match where primary keys are equal
	[Source].GLTranslationTypeId = [Target].GLTranslationTypeId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].GLAccountTypeId = [Source].GLAccountTypeId,
		[Target].GLAccountSubTypeId = [Source].GLAccountSubTypeId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		GLGlobalAccountId,
		GLTranslationTypeId,
		GLAccountTypeId,
		GLAccountSubTypeId,
		IsActive,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLGlobalAccountId,
		[Source].GLTranslationTypeId,
		[Source].GLAccountTypeId,
		[Source].GLAccountSubTypeId,
		1,
		-1
	)

WHEN NOT MATCHED BY SOURCE AND [Target].GLTranslationTypeId = 1 THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccountGLAccount table in the GDM_GR database with the 
	dbo.SnapshotGLAccount table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGLobalAccountGLAccount] AS

/*
	OLD							NEW
	--------------------------------------------------------
	GLGlobalAccountGLAccountId	GLAccountId
	GLGlobalAccount				GLGlobalAccount
	Code						Code
	SourceCode					SourceCode
	Name						Name
	Description										[Default to '''']
	PreGlobalAccountCode
								EnglishName
								Type
								LastDate
	IsActive					IsActive
								IsHistoric
								IsGlobalReporting
								IsServiceCharge
								IsDirectRecharge
	InsertedDate				InsertedDate
	UpdatedDate					UpdatedDate
	UpdatedByStaffId			UpdatedByStaffId																									 */


MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccountGLAccount AS [Target]
USING
	(
		SELECT
			GLA.*,
			GGAGA.GLGlobalAccountGLAccountId
		FROM
			GDM.dbo.SnapshotGLAccount GLA 
			INNER JOIN GDM_GR.dbo.GLGlobalAccountGLAccount GGAGA ON
				GLA.SourceCode = GGAGA.SourceCode AND 
				GLA.Code = GGAGA.Code AND
				GLA.GLGlobalAccountId = GGAGA.GLGlobalAccountId
		WHERE
			GLA.GLGlobalAccountId IS NOT NULL
	)  AS [Source]
ON
	[Source].SourceCode = [Target].SourceCode AND -- can''t match primary keys as GLGlobalAccountGLAccountId and GLAccountId are different fields
	[Source].Code = [Target].Code AND
	[Source].GLGlobalAccountId = [Target].GLGlobalAccountId AND
	[Source].SnapshotId = [Target].SnapshotId

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].Code = [Source].Code,
		[Target].SourceCode = [Source].SourceCode,
		[Target].Name = [Source].Name,
		[Target].[Description] = '''',							-- Description: doesn''t exist in dbo.GLAccount, so default to ''''
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLGlobalAccountGLAccountId,
		GLGlobalAccountId,
		SourceCode,
		Code,
		Name,
		[Description],
		PreGlobalAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
		VALUES (
		[Source].SnapshotId,
		[Source].GLGlobalAccountGLAccountId,
		[Source].GLGlobalAccountId,
		[Source].SourceCode,
		[Source].Code,
		[Source].Name,
		'''',							-- Description: doesn''t exist in dbo.GLAccount, so default to ''''
		NULL,						-- PreGlobalAccountCode: doesn''t exist in dbo.GLAccount, so default to NULL
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], delete it in [Target].
	DELETE;						-- can''t deactivate as there is a good chance that dbo.GLGlobalAccountGLAccount_SourceCode_Code_IsActive_UniqueIndex
								-- will be triggered, causing the statement to fail.
								-- Deleting should be fine as there are no foreign key constraints onto dbo.GLGlobalAccountGLAccount
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
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

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyFundId = [Source].PropertyFundId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].PropertyEntityCode = [Source].PropertyEntityCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId --,
		-- [Target].IsPrimary = [Source].IsPrimary

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
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

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].PropertyFundId = [Source].PropertyFundId,
		[Target].SourceCode = [Source].SourceCode,
		[Target].CorporateDepartmentCode = [Source].CorporateDepartmentCode,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	DELETE;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.GLGlobalAccountTranslationSubType table in the GDM_GR database with the 
	GDM.dbo.GLGlobalAccountCategorization table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
AS

SET IDENTITY_INSERT GDM_GR.dbo.GLGlobalAccountTranslationSubType ON

MERGE
	GDM_GR.dbo.GLGlobalAccountTranslationSubType AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.GLGlobalAccountCategorization
		WHERE
			GLCategorizationId = 233 AND
			DirectGLMinorCategoryId IS NOT NULL
	) AS [Source]
ON
	[Source].GLGlobalAccountCategorizationId = [Target].GLGlobalAccountTranslationSubTypeId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].GLMinorCategoryId = [Source].DirectGLMinorCategoryId, -- DirectGLMinorCategoryId should equal DirectGLMinorCategoryId for 233
		[Target].IsActive = 1, -- IsActive field has been removed from GLGlobalAccountCategorization
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		GLGlobalAccountTranslationSubTypeId,
		GLGlobalAccountId,
		GLTranslationSubTypeId,
		GLMinorCategoryId,
		PostingPropertyGLAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].GLGlobalAccountCategorizationId,
		[Source].GLGlobalAccountId,
		[Source].GLCategorizationId,
		[Source].DirectGLMinorCategoryId,
		NULL,
		1,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE AND [Target].GLTranslationSubTypeId = 233 THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

SET IDENTITY_INSERT GDM_GR.dbo.GLGlobalAccountTranslationSubType OFF

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLMinorCategory]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLMinorCategory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLMinorCategory table in the GDM_GR database 
	with the dbo.SnapshotGLMinorCategory table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-08		: PKayongo	: Stored procedure created
			2011-08-15		: ISaunder	: Added the drop to the view [dbo].[SnapshotGLGlobalAccountDetail].

**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLMinorCategory]
AS

--------------------------------------------------------------------------------------------------------------------------------------------------
-- The indexes on the view below are updated when this sync script is executed. Unfortunately, this causes the sync script to execute indefinitely.
-- To prevent this from happening, the view (and its indexes) are dropped before the sync script is executed, and then recreated afterwards.

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]''))
	DROP VIEW [dbo].[SnapshotGLGlobalAccountDetail]

--------------------------------------------------------------------------------------------------------------------------------------------------

MERGE
	GDM_GR.dbo.SnapshotGLMinorCategory AS [Target]
USING
	(
		SELECT
			MinC.*,
			MajC.GLCategorizationId
		FROM
			GDM.dbo.SnapshotGLMinorCategory MinC
			INNER JOIN GDM.dbo.SnapshotGLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MinC.SnapshotId = MajC.SnapshotId
		WHERE
			MajC.GLCategorizationId = 233
	) AS [Source]
ON
	[Source].GLMinorCategoryId = [Target].GLMinorCategoryId AND
	[Source].SnapshotId = [Target].SnapshotId -- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLMajorCategoryId = [Source].GLMajorCategoryId,
		[Target].Name = [Source].Name,
		[Target].IsActive = [Source].IsActive,
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET AND [Source].GLCategorizationId = 233 THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLMinorCategoryId,
		GLMajorCategoryId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLMinorCategoryId,
		[Source].GLMajorCategoryId,
		[Source].Name,
		[Source].IsActive,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Recreate the view (and its indexes) that was dropped at the beginning of this stored procedure

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]''))
EXEC dbo.sp_executesql @statement = N''CREATE VIEW [dbo].[SnapshotGLGlobalAccountDetail] WITH SCHEMABINDING AS
SELECT 
	S.GroupKey as BudgetAllocationSetId,
	GLA.SnapshotId,
	GLA.GLGlobalAccountId,
    GLA.Code AS GLGlobalAccountCode,
    GLA.Name AS GLGlobalAccountName,
	MajC.GLMajorCategoryId,
    MajC.Name AS GLMajorCategoryName,
	MC.GLMinorCategoryId,
    MC.Name AS GLMinorCategoryName,
	GLATT.GLAccountTypeId,
	GLATT.GLAccountSubTypeId,
	TT.GLTranslationTypeId,
	TST.GLTranslationSubTypeId, 
	TT.Code AS TranslationTypeCode,
	TST.Code AS TranslationSubTypeCode,
	GLATST.PostingPropertyGLAccountCode,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.ActivityTypeId,
	AST.Name AS GLAccountSubTypeName
FROM
	dbo.SnapshotGLGlobalAccount GLA
	
	INNER JOIN dbo.SnapshotGLGlobalAccountTranslationSubType GLATST ON
		GLA.GLGlobalAccountId = GLATST.GLGlobalAccountId AND
		GLA.SnapshotId = GLATST.SnapshotId 		
		
	INNER JOIN dbo.SnapshotGLTranslationSubType TST ON
		GLATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		GLATST.SnapShotId = TST.SnapshotId
	
	INNER JOIN dbo.SnapshotGLTranslationType TT ON
		TST.GLTranslationTypeId = TT.GLTranslationTypeId AND
		TST.SnapshotId = TT.SnapshotId
		
	INNER JOIN dbo.SnapshotGLGlobalAccountTranslationType GLATT ON
		GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId AND
		GLATT.SnapshotId = GLA.SnapshotId AND
		GLATT.GLTranslationTypeId = TT.GLTranslationTypeId 
				
	INNER JOIN dbo.SnapshotGLMinorCategory MC ON
		MC.GLMinorCategoryId = GLATST.GLMinorCategoryId AND
		MC.SnapshotId = GLATST.SnapshotId

    INNER JOIN dbo.SnapshotGLMajorCategory MajC ON
        MC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
		MC.SnapshotId = MajC.SnapshotId

	INNER JOIN dbo.SnapshotGLAccountSubType AST ON
		GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId AND
		GLA.SnapshotId = AST.SnapshotId
		
	INNER JOIN dbo.[Snapshot] S ON
		GLA.SnapshotId = S.SnapshotId
WHERE
	GLA.IsActive = 1 AND
	GLATST.IsActive = 1 AND 
	GLATT.IsActive = 1 AND
	S.GroupName = ''''BudgetAllocationSet''''
''
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]'') AND name = N''UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeCodeTranslationTypeCode'')
	CREATE UNIQUE CLUSTERED INDEX [UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeCodeTranslationTypeCode] ON [dbo].[SnapshotGLGlobalAccountDetail] 
	(
		[GLGlobalAccountId] ASC,
		[BudgetAllocationSetId] ASC,
		[TranslationSubTypeCode] ASC,
		[TranslationTypeCode] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N''[dbo].[SnapshotGLGlobalAccountDetail]'') AND name = N''UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeIdTranslationTypeId'')
	CREATE UNIQUE NONCLUSTERED INDEX [UX_GLGlobalAccountIdSnapshotIdTranslationSubTypeIdTranslationTypeId] ON [dbo].[SnapshotGLGlobalAccountDetail] 
	(
		[GLGlobalAccountId] ASC,
		[BudgetAllocationSetId] ASC,
		[GLTranslationSubTypeId] ASC,
		[GLTranslationTypeId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--------------------------------------------------------------------------------------------------------------------------------------------------
' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccountTranslationType table in the GDM_GR database 
	with the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType] AS

DECLARE @GRIncome_GLAccountTypeId INT = (SELECT TOP 1 GLAccountTypeId FROM GDM_GR.dbo.GLAccountType WHERE Code = ''GRPINC'')
DECLARE @GRExpense_GLAccountTypeId INT = (SELECT TOP 1 GLAccountTypeId FROM GDM_GR.dbo.GLAccountType WHERE Code = ''GRPEXP'')

DECLARE @GRPayroll_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = ''GRPPYR'')
DECLARE @GROverhead_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = ''GRPOHD'')
DECLARE @GRNonPayroll_GLAccountSubTypeId INT = (SELECT TOP 1 GLAccountSubTypeId FROM GDM_GR.dbo.GLAccountSubType WHERE Code = ''GRPNPR'')

MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccountTranslationType AS [Target]
USING
	(
		SELECT
			GAC.GLGlobalAccountId,
			1 AS GLTranslationTypeId,
			CASE
				WHEN
					FinC.InflowOutflow = ''Inflow''
				THEN
					@GRIncome_GLAccountTypeId
				ELSE
					@GRExpense_GLAccountTypeId
			END AS GLAccountTypeId, -- Inflow = GR Income = 3; Outflow = GR Expense = 4
			CASE
				WHEN
					FinC.Name = ''Payroll''
				THEN
					@GRPayroll_GLAccountSubTypeId
				WHEN
					FinC.Name = ''Overhead''
				THEN
					@GROverhead_GLAccountSubTypeId
				ELSE
					@GRNonPayroll_GLAccountSubTypeId -- FinC.Name IN (''Non-Payroll'', ''Other Revenue'', ''Fee Income'', ''Other Expenses'')					
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
								FinC.InflowOutflow = ''Inflow''
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
							FinC.Name = ''Payroll''
						THEN
							@GRPayroll_GLAccountSubTypeId
						WHEN
							FinC.Name = ''Overhead''
						THEN
							@GROverhead_GLAccountSubTypeId
						ELSE
							@GRNonPayroll_GLAccountSubTypeId -- FinC.Name IN (''Non-Payroll'', ''Other Revenue'', ''Fee Income'', ''Other Expenses'')					
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

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLTranslationTypeId = [Source].GLTranslationTypeId,
		[Target].GLAccountTypeId = [Source].GLAccountTypeId,
		[Target].GLAccountSubTypeId = [Source].GLAccountSubTypeId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
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

WHEN NOT MATCHED BY SOURCE AND [Target].GLTranslationTypeId = 1 THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table

' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]    Script Date: 08/24/2011 17:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The stored procedure synchronises the dbo.SnapshotGLGlobalAccountTranslationSubType table in the GDM_GR database 
	with the dbo.SnapshotGLGlobalAccountCategorization table in the GDM database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
	
			2011-08-04		: PKayongo	: Stored procedure created

**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
AS



MERGE
	GDM_GR.dbo.SnapshotGLGlobalAccountTranslationSubType AS [Target]
USING
	(
		SELECT
			*
		FROM
			GDM.dbo.SnapshotGLGlobalAccountCategorization
		WHERE
			GLCategorizationId = 233 AND
			DirectGLMinorCategoryId IS NOT NULL
	) AS [Source]
ON
	[Source].GLGlobalAccountCategorizationId = [Target].GLGlobalAccountTranslationSubTypeId AND
	[Source].SnapshotId = [Target].SnapshotId-- match where primary keys are equal

WHEN MATCHED THEN -- when [Target] matches [Source], updated [Target]''s fields to be equal to [Source]''s fields (besides the PK field)
	UPDATE SET
		[Target].GLGlobalAccountId = [Source].GLGlobalAccountId,
		[Target].GLTranslationSubTypeId = [Source].GLCategorizationId,
		[Target].GLMinorCategoryId = [Source].DirectGLMinorCategoryId, -- DirectGLMinorCategoryId should equal DirectGLMinorCategoryId for 233
		[Target].IsActive = 1, -- IsActive field has been removed from GLGlobalAccountCategorization
		[Target].InsertedDate = [Source].InsertedDate,
		[Target].UpdatedDate = [Source].UpdatedDate,
		[Target].UpdatedByStaffId = [Source].UpdatedByStaffId

WHEN NOT MATCHED BY TARGET THEN -- when a record exists in [Source] that doesn''t exist in [Target], insert it
	INSERT (
		SnapshotId,
		GLGlobalAccountTranslationSubTypeId,
		GLGlobalAccountId,
		GLTranslationSubTypeId,
		GLMinorCategoryId,
		PostingPropertyGLAccountCode,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)
	VALUES (
		[Source].SnapshotId,
		[Source].GLGlobalAccountCategorizationId,
		[Source].GLGlobalAccountId,
		[Source].GLCategorizationId,
		[Source].DirectGLMinorCategoryId,
		NULL,
		1,
		[Source].InsertedDate,
		[Source].UpdatedDate,
		[Source].UpdatedByStaffId
	)

WHEN NOT MATCHED BY SOURCE AND [Target].GLTranslationSubTypeId = 233 THEN -- when a record exists in [Target] that doesn''t exist in [Source], deactivate it in [Target]
	UPDATE SET
		[Target].IsActive = 0; -- Don''t hard delete the target record as this will probably break FK constraints on this table



' 
END
GO
/****** Object:  StoredProcedure [dbo].[stp_IU_SyncMaster]    Script Date: 08/24/2011 17:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_SyncMaster]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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





' 
END
GO
