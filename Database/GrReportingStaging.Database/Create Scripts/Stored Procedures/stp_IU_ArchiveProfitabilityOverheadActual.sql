USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_ArchiveProfitabilityOverheadActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]
GO

USE [GrReportingStaging]
GO


/*********************************************************************************************************************
Description
	This stored procedure moves orphaned rows in the ProfitabilityActual table of the Data Warehouse to an archive 
	table. These rows no longer exist in the source data systems.

	This stored procedure is designed to only function in the scope of stp_IU_LoadGrProfitabiltyGeneralLedger, 
	given that access to its #ProfitabilityActual temporary table is required.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-06-23		: PKayongo	:	Added ConsolidationRegionKey mapping from the ProfitabilityActual table to
											the ProfitabilityActualArchive table			
			2011-10-04		: PKayongo	:	Updated to include the GLCategorizationHierarchy fields (CC21)
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_ArchiveProfitabilityOverheadActual]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

SELECT
	BUD.UpdatedDate,
	('BillingUploadDetailId=' + CONVERT(VARCHAR(20), BUD.BillingUploadDetailId)) AS ReferenceCode
INTO
	#ActiveBillingUploadDetail
FROM
	GrReportingStaging.TapasGlobal.BillingUploadDetail BUD
	INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BUDA ON
		BUDA.ImportKey = BUD.ImportKey


SELECT
	GRPA.ProfitabilityActualKey,
    GRPA.CalendarKey,
    GRPA.SourceKey,
    GRPA.FunctionalDepartmentKey,
    GRPA.ReimbursableKey,
    GRPA.ActivityTypeKey,
    GRPA.PropertyFundKey,
    GRPA.OriginatingRegionKey,
    GRPA.AllocationRegionKey,
    GRPA.LocalCurrencyKey,
    GRPA.LocalActual,
    GRPA.ReferenceCode,
    GRPA.SourceSystemKey,
    
	GRPA.GlobalGLCategorizationHierarchyKey,
	GRPA.USPropertyGLCategorizationHierarchyKey,
	GRPA.USFundGLCategorizationHierarchyKey,
	GRPA.EUPropertyGLCategorizationHierarchyKey,
	GRPA.EUFundGLCategorizationHierarchyKey,
	GRPA.USDevelopmentGLCategorizationHierarchyKey,
	GRPA.EUDevelopmentGLCategorizationHierarchyKey,
    
    GRPA.LastDate,
    GRPA.[User],
    GRPA.Description,
    GRPA.AdditionalDescription,
    GRPA.OriginatingRegionCode,
    GRPA.PropertyFundCode,
    GRPA.FunctionalDepartmentCode,
    GRPA.OverheadKey,
    GRPA.ConsolidationRegionKey
INTO
	#NewProfitabilityActualArchiveRecords
FROM
	GrReporting.dbo.ProfitabilityActual GRPA

	INNER JOIN GrReporting.dbo.Source S ON
		S.SourceKey = GRPA.SourceKey
	
	INNER JOIN GrReporting.dbo.SourceSystem SourceSystem ON
		GRPA.SourceSystemKey = SourceSystem.SourceSystemKey	
	
	LEFT OUTER JOIN #ActiveBillingUploadDetail ABUD ON
		GRPA.ReferenceCode = ABUD.ReferenceCode
			
	LEFT OUTER JOIN #ProfitabilityActual GRSPA ON
		GRPA.ReferenceCode = GRSPA.ReferenceCode AND
		GRPA.SourceKey = GRSPA.SourceKey

WHERE
	GRSPA.ReferenceCode IS NULL AND
	GRPA.LastDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	SourceSystem.SourceTableName = 'BillingUploadDetail' AND
	(
		ABUD.ReferenceCode IS NULL OR
		(ABUD.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate)		
	)

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
    
    LastDate,
    [User],
    Description,
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
	
    NPAAR.LastDate,
    NPAAR.[User],
    NPAAR.Description,
    NPAAR.AdditionalDescription,
    NPAAR.OriginatingRegionCode,
    NPAAR.PropertyFundCode,
    NPAAR.FunctionalDepartmentCode,
    NPAAR.OverheadKey,
    GETDATE() AS InsertedDate,
    NPAAR.ConsolidationRegionKey
FROM
	#NewProfitabilityActualArchiveRecords NPAAR

-- Delete orphan rows from dbo.ProfitabilityActual

DELETE FROM	GrReporting.dbo.ProfitabilityActual
WHERE
	ProfitabilityActualKey IN (SELECT ProfitabilityActualKey FROM #NewProfitabilityActualArchiveRecords)

DROP TABLE #ActiveBillingUploadDetail
DROP TABLE #NewProfitabilityActualArchiveRecords


GO


