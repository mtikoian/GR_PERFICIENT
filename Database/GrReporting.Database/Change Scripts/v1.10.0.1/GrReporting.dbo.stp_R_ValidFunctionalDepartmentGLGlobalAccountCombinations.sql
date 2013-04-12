USE [GrReporting]
GO

/****** Object:  StoredProcedure [debug].[stp_R_ValidGLGlobalAccountFunctionalDepartmentCombinations_jt]    Script Date: 04/01/2012 01:34:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
GO


USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]    Script Date: 03/26/2012 01:14:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
@DataPriorToDate DATETIME
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Originating Region - Functional Department Mappings
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-03-19		: JTrussler	:	 - Create script
			2012-03-26		: MChen		:	 - Replace hard-coded date to @DataPriorToDate, and source it from SSISConfigurations table
**********************************************************************************************************************/

/* ================================================================================================================
	STEP 0: CROSS JOIN TO GET ALL ORIGINATING REGION - FUNCTIONAL DEPARTMENT COMBINATIONS
=================================================================================================================*/
IF (@DataPriorToDate IS NULL)
	BEGIN
		SET @DataPriorToDate = 
			CONVERT
				(
					DATETIME,
					(
						SELECT 
							ConfiguredValue 
						FROM 
							GrReportingStaging.dbo.SSISConfigurations 
						WHERE 
							ConfigurationFilter = 'ActualDataPriorToDate'
					)
				)
	END

BEGIN
SELECT
	 DISTINCT GGA.Code, GGA.Name
INTO
	#GlobalGLAccounts
FROM GrReportingStaging.GDM.GLGlobalAccount GGA	
LEFT OUTER JOIN GrReportingStaging.Gdm.GLAccount GA
ON GGA.GLGlobalAccountId = GA.GLGlobalAccountId
WHERE GGA.IsActive = 1 AND GA.IsGlobalReporting = 1

	
SELECT
	FD.GlobalCode,
	FD.Name
INTO 
	#FunctionalDepartments
FROM	
	GrReportingStaging.HR.FunctionalDepartment FD
WHERE 
	FD.IsActive = 1 AND
    FD.GlobalCode IS NOT NULL AND
    FD.Code <> 'TESTING'

    
SELECT
	FD.GlobalCode AS 'FunctionalDepartmentCode',
	GA.Code AS 'GLGLobalAccountCode'
INTO 
	#GlobalGLAccountFunctionalDepartment
FROM 
	#FunctionalDepartments FD
	CROSS JOIN #GlobalGLAccounts GA
	
	
END 
    
/* ================================================================================================================
	STEP 1: REMOVE ALL INVALID COMBINATIONS
=================================================================================================================*/
BEGIN

DELETE GAFD
FROM #GlobalGLAccountFunctionalDepartment GAFD
	INNER JOIN (
			SELECT 
				GLGlobalAccount.Code AS 'GLGlobalAccountCode',
				FunctionalDepartment.GlobalCode AS 'FunctionalDepartmentGlobalCode'
			FROM GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccount
			INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive(@DataPriorToDate) ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FunctionalDepartmentActive ON
				FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive(@DataPriorToDate) GLGlobalAccountActive ON
				GLGlobalAccount.ImportKey = GLGlobalAccountActive.ImportKey
	) InvalidCombinations ON
		GAFD.FunctionalDepartmentCode = 
		CASE
			WHEN InvalidCombinations.FunctionalDepartmentGlobalCode IS NULL THEN GAFD.FunctionalDepartmentCode
			ELSE InvalidCombinations.FunctionalDepartmentGlobalCode
		END	AND
		GAFD.GLGLobalAccountCode = InvalidCombinations.GLGlobalAccountCode

END 
/* ================================================================================================================
	STEP 3: RETURN FINAL RESULTS
=================================================================================================================*/

BEGIN

SELECT 
	#GlobalGLAccounts.Code AS 'GLGLobalAccountCode',
	#GlobalGLAccounts.Name AS 'GLGLobalAccountName',
	#FunctionalDepartments.Name AS 'FunctionalDepartment',
	#FunctionalDepartments.GlobalCode
FROM
	#GlobalGLAccountFunctionalDepartment GAFD
	INNER JOIN #GlobalGLAccounts ON
		GAFD.GLGLobalAccountCode = #GlobalGLAccounts.Code
	INNER JOIN #FunctionalDepartments ON
		GAFD.FunctionalDepartmentCode = #FunctionalDepartments.GlobalCode
	
END

IF OBJECT_ID('tempdb..#GlobalGLAccounts') IS NOT NULL
	DROP TABLE #GlobalGLAccounts

IF OBJECT_ID('tempdb..#FunctionalDepartments') IS NOT NULL
	DROP TABLE #FunctionalDepartments

IF OBJECT_ID('tempdb..#GlobalGLAccountFunctionalDepartment') IS NOT NULL
	DROP TABLE #GlobalGLAccountFunctionalDepartment





GO


