 USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]    Script Date: 03/05/2012 16:26:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]    Script Date: 03/05/2012 16:26:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_R_ValidReportingEntityActivityTypeCombinations]
@BudgetAllocationSetId INT
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Reporting Entity - Activity Type Combinations
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-03-05		: SNothling	:	CC21 - Create script
**********************************************************************************************************************/

BEGIN

	CREATE TABLE #HolisticReviewExportTemp
	(	
		ProjectCode VARCHAR(20) NULL,
		ProjectName VARCHAR(100) NULL,
		ProjectEndPeriod INT NULL,
		ActivityType VARCHAR(50) NULL,
		PropertyFund VARCHAR(100) NULL,
		RelatedFund VARCHAR(100) NULL,
		PropertyFundAllocationSubRegionName VARCHAR(50) NULL,
		Source CHAR(2) NULL,
		AllocationType VARCHAR(100) NULL,
		CorporateDepartment CHAR(8) NULL,
		CorporateDepartmentDescription VARCHAR(50) NULL,
		ReportingEntity VARCHAR(100) NULL,
		ReportingEntityAllocationSubRegionName varchar(50) NULL,
		EntityType VARCHAR(50) NULL,
		BudgetOwner VARCHAR(255) NULL,
		RegionalOwner VARCHAR(255) NULL,
		BudgetCoordinatorDisplayNames nvarchar(MAX) NULL,
		IsTSCost VARCHAR(3) NULL,
		PropertyEntity CHAR(6) NULL,
		PropertyEntityName NVARCHAR(264) NULL
	)

	SET XACT_ABORT ON

	-- Get actuals
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport

	-- Get budget
	INSERT INTO #HolisticReviewExportTemp
	EXEC SERVER3.GDM.dbo.HolisticReviewExport @BudgetAllocationSetId=@BudgetAllocationSetId

	-- Get a distinct list of valid combinations of
	--	activity type
	--	allocation type
	--	reporting entity
	-- as projects have been set up in AM
	SELECT DISTINCT 
		ValidEntityActivityTypeCombinations.ActivityType ActivityTypeName,
		ValidEntityActivityTypeCombinations.AllocationType AllocationTypeName,
		ValidEntityActivityTypeCombinations.ReportingEntity ReportingEntityName
	INTO #ValidActivityTypeEntity
	FROM 
		#HolisticReviewExportTemp ValidEntityActivityTypeCombinations
		
	-- IMS 56718: Martin has specified additional entries that are also
	-- valid, even though they have no projects in AM
	INSERT INTO #ValidActivityTypeEntity
	SELECT 
		AdditionalMappings.ActivityTypeName, 
		AdditionalMappings.AllocationTypeName,
		AdditionalMappings.ReportingEntityName
	FROM 
		dbo.AdditionalValidCombinationsForEntityActivity AdditionalMappings
		LEFT OUTER JOIN #ValidActivityTypeEntity AMMappings ON 
			 AdditionalMappings.ReportingEntityName = AMMappings.ReportingEntityName AND
			 AdditionalMappings.ActivityTypeName = AMMappings.ActivityTypeName AND
			 AdditionalMappings.AllocationTypeName = AMMappings.AllocationTypeName
	WHERE 
		AMMappings.AllocationTypeName IS NULL
		
	SELECT * FROM #ValidActivityTypeEntity



END


