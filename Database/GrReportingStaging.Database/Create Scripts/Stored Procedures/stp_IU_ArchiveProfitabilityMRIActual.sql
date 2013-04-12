USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityMRIActual]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    Description
	This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive 
	table. These rows no longer exist in the source data systems.

	This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, 
	given that access to its #ProfitabilityActual temporary table is required.

	┌─────────────────┬─────────────────┬──────────────────────────────────────────────────────────────────────────────────┐
	│   YYYY-MM-DD    │      PERSON     │                          DETAILS OF CHANGES MADE                                 │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-06-07    │    P Kayongo    │ Added ConsolidationRegionKey mapping from the ProfitabilityActual table to the   │
	│                 │                 │ ProfitabilityActualArchive table.                                                │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-06-30    │    I Saunder    │ Updated logic used to determine which fact records are no longer valid.          │
	├─────────────────┼─────────────────┼──────────────────────────────────────────────────────────────────────────────────┤
	│   2011-09-27    │    P Kayongo    │ Updated GLAccount mapping to new Categorizations (CC21).			               │
	└─────────────────┴─────────────────┴──────────────────────────────────────────────────────────────────────────────────┘


──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityMRIActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

-- Get all records from all MRIs

SELECT
	*
INTO
	#AllGeneralLedgers
FROM
	(
		SELECT SourcePrimaryKey, 'US' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[USProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'UC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[USCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'EU' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[EUProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'EC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[EUCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'BR' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[BRProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'BC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[BRCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'IN' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[INProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'IC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[INCorp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'CN' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[CNProp].[GeneralLedger]
		UNION ALL
		SELECT SourcePrimaryKey, 'CC' AS SourceCode, ISNULL(LastDate, EnterDate) AS LastDate FROM [GrReportingStaging].[CNCorp].[GeneralLedger]		
	)
	AS AllGeneralLedgers
WHERE
	LastDate BETWEEN @ImportStartDate AND @ImportEndDate

CREATE UNIQUE CLUSTERED INDEX IX_AllGeneralLedgers_Clustered ON #AllGeneralLedgers(SourcePrimaryKey, SourceCode)

-- Find orphan rows using #ProfitabilityActual, which exists in the scope of the stored proc that executed this stored proc

SELECT
	GRPA.*
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA
	
	-- Need to join on Source because reference code is not source specific (we could have identical reference codes for different sources)
	INNER JOIN GrReporting.dbo.[Source] S ON
		GRPA.SourceKey = S.SourceKey
	
	-- Need to join here because we only consider JOURNAL and GHIS sources (not BillingUploadDetail from TAPAS)
	INNER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
		GRPA.SourceSystemKey = SourceSystem.SourceSystemKey
	
	-- This join will determine all transactions in GrReporting.dbo.ProfitabilityActual that have been deleted in MRI	
	LEFT OUTER JOIN #AllGeneralLedgers AGL ON
		GRPA.ReferenceCode = AGL.SourcePrimaryKey AND
		S.SourceCode = AGL.SourceCode
	
	-- This join will determine all transactions in GrReporting.dbo.ProfitabilityActual that should no longer be there because of changes in
	-- business rules (i.e.: a new record in a ManageType table)
	LEFT OUTER JOIN #ProfitabilityActual PA ON
		GRPA.ReferenceCode = PA.ReferenceCode AND
		GRPA.SourceKey = PA.SourceKey
	
WHERE
	GRPA.LastDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	SourceSystem.SourceTableName IN ('JOURNAL', 'GHIS') AND
	(AGL.SourcePrimaryKey IS NULL OR PA.ReferenceCode IS NULL) -- If either a transaction as been deleted in MRI or a transaction in
															   -- dbo.ProfitabilityActual needs to be smoked because business rules have changed.

-- Update dbo.ProfitabilityActualArchive - it could be possible that we are archiving a record for the second time (although this is unlikely -
-- more to protect against duplicate inserts while running on DEV/TEST). If this is the case, update the record.

UPDATE
	PAA
SET
	PAA.CalendarKey = NPAAR.CalendarKey,
	PAA.SourceKey = NPAAR.SourceKey,
	PAA.FunctionalDepartmentKey = NPAAR.FunctionalDepartmentKey,
	PAA.ReimbursableKey = NPAAR.ReimbursableKey,
	PAA.ActivityTypeKey = NPAAR.ActivityTypeKey,
	PAA.PropertyFundKey = NPAAR.PropertyFundKey,
	PAA.OriginatingRegionKey = NPAAR.OriginatingRegionKey,
	PAA.AllocationRegionKey = NPAAR.AllocationRegionKey,
	PAA.LocalCurrencyKey = NPAAR.LocalCurrencyKey,
	PAA.LocalActual = NPAAR.LocalActual,
	PAA.ReferenceCode = NPAAR.ReferenceCode,
	PAA.SourceSystemKey = NPAAR.SourceSystemKey,
	
	PAA.GlobalGLCategorizationHierarchyKey = NPAAR.GlobalGLCategorizationHierarchyKey,
	PAA.USPropertyGLCategorizationHierarchyKey = NPAAR.USPropertyGLCategorizationHierarchyKey,
	PAA.USFundGLCategorizationHierarchyKey = NPAAR.USFundGLCategorizationHierarchyKey,
	PAA.EUPropertyGLCategorizationHierarchyKey = NPAAR.EUPropertyGLCategorizationHierarchyKey,
	PAA.EUFundGLCategorizationHierarchyKey = NPAAR.EUFundGLCategorizationHierarchyKey,
	PAA.USDevelopmentGLCategorizationHierarchyKey = NPAAR.USDevelopmentGLCategorizationHierarchyKey,
	PAA.EUDevelopmentGLCategorizationHierarchyKey = NPAAR.EUDevelopmentGLCategorizationHierarchyKey,
	PAA.ReportingGLCategorizationHierarchyKey = NPAAR.ReportingGLCategorizationHierarchyKey,
	
	PAA.LastDate = NPAAR.LastDate,
	PAA.[User] = NPAAR.[User],
	PAA.[Description] = NPAAR.[Description],
	PAA.AdditionalDescription = NPAAR.AdditionalDescription,
	PAA.OriginatingRegionCode = NPAAR.OriginatingRegionCode,
	PAA.PropertyFundCode = NPAAR.PropertyFundCode,
	PAA.FunctionalDepartmentCode = NPAAR.FunctionalDepartmentCode,
	PAA.OverheadKey = NPAAR.OverheadKey,
	PAA.InsertedDate = GETDATE(),
	PAA.ConsolidationRegionKey = NPAAR.ConsolidationRegionKey
FROM
	GrReporting.dbo.ProfitabilityActualArchive PAA
	
	INNER JOIN #NewProfitabilityActualArchiveRecords NPAAR ON
		PAA.ReferenceCode = NPAAR.ReferenceCode AND
		PAA.SourceKey = NPAAR.SourceKey

-- Insert new orphan rows into dbo.ProfitabilityActualArchive table. We do not want to insert duplicate records; hence the LEFT OUTER JOIN and NULL

INSERT INTO GrReporting.dbo.ProfitabilityActualArchive
(
	ProfitabilityActualArchiveKey,
    CalendarKey,
    SourceKey,
    FunctionalDepartmentKey,
    ReimbursableKey,
    ActivityTypeKey,
    PropertyFundKey,
    OriginatingRegionKey,
    AllocationRegionKey,
    LocalCurrencyKey,
    LocalActual,
    ReferenceCode,
    SourceSystemKey,
    
	GlobalGLCategorizationHierarchyKey,
	USPropertyGLCategorizationHierarchyKey,
	USFundGLCategorizationHierarchyKey,
	EUPropertyGLCategorizationHierarchyKey,
	EUFundGLCategorizationHierarchyKey,
	USDevelopmentGLCategorizationHierarchyKey,
	EUDevelopmentGLCategorizationHierarchyKey,
    ReportingGLCategorizationHierarchyKey,
    LastDate,
    [User],
    [Description],
    AdditionalDescription,
    OriginatingRegionCode,
    PropertyFundCode,
    FunctionalDepartmentCode,
    OverheadKey,
    InsertedDate,
    ConsolidationRegionKey
)
SELECT
	NPAAR.ProfitabilityActualKey,
    NPAAR.CalendarKey,
    NPAAR.SourceKey,
    NPAAR.FunctionalDepartmentKey,
    NPAAR.ReimbursableKey,
    NPAAR.ActivityTypeKey,
    NPAAR.PropertyFundKey,
    NPAAR.OriginatingRegionKey,
    NPAAR.AllocationRegionKey,
    NPAAR.LocalCurrencyKey,
    NPAAR.LocalActual,
    NPAAR.ReferenceCode,
    NPAAR.SourceSystemKey,
    
	NPAAR.GlobalGLCategorizationHierarchyKey,
	NPAAR.USPropertyGLCategorizationHierarchyKey,
	NPAAR.USFundGLCategorizationHierarchyKey,
	NPAAR.EUPropertyGLCategorizationHierarchyKey,
	NPAAR.EUFundGLCategorizationHierarchyKey,
	NPAAR.USDevelopmentGLCategorizationHierarchyKey,
	NPAAR.EUDevelopmentGLCategorizationHierarchyKey,
    NPAAR.ReportingGLCategorizationHierarchyKey,
    NPAAR.LastDate,
    NPAAR.[User],
    NPAAR.[Description],
    NPAAR.AdditionalDescription,
    NPAAR.OriginatingRegionCode,
    NPAAR.PropertyFundCode,
    NPAAR.FunctionalDepartmentCode,
    NPAAR.OverheadKey,
    GETDATE(),
    NPAAR.ConsolidationRegionKey
FROM
	#NewProfitabilityActualArchiveRecords NPAAR
 
	LEFT JOIN GrReporting.dbo.ProfitabilityActualArchive PAA ON
		NPAAR.ReferenceCode = PAA.ReferenceCode AND
		NPAAR.SourceKey = PAA.SourceKey
WHERE
	PAA.ReferenceCode IS NULL

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE
FROM
	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

--

PRINT 'Completed removing all orphan records from GrReporting.dbo.ProfitabilityActual: '+ LTRIM(RTRIM(CONVERT(char(20),@@rowcount)))
PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #AllGeneralLedgers
DROP TABLE #NewProfitabilityActualArchiveRecords

GO


