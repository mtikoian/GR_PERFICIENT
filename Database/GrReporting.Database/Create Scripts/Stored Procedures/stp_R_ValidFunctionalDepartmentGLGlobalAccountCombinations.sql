USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]    Script Date: 02/15/2012 18:28:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
GO

USE [GrReporting]
GO

/****** Object:  StoredProcedure [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]    Script Date: 02/15/2012 18:28:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--exec stp_S_UnknownSummaryMRIActuals @BudgetYear=2010, @BudgetQuarter='Q2', @DataPriorToDate='2010-12-31', @StartPeriod=201001, @EndPeriod=201002

CREATE PROCEDURE [dbo].[stp_R_ValidFunctionalDepartmentGLGlobalAccountCombinations]
@DataPriorToDate DATETIME
AS

/*********************************************************************************************************************
Description
	This report generates a list of all valid Originating Region - Functional Department Mappings
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]
			2012-01-27		: SNothling	:	CC21 - Create script
**********************************************************************************************************************/

/* ================================================================================================================
	STEP 0: CROSS JOIN TO GET ALL ORIGINATING REGION - FUNCTIONAL DEPARTMENT COMBINATIONS
=================================================================================================================*/
BEGIN
SELECT
	GA.Code,
	GA.Name
INTO
	#GlobalGLAccounts	
FROM 
	GrReportingStaging.GDM.GLGlobalAccount GA
WHERE GA.IsActive = 1
			
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
			INNER JOIN GrReportingStaging.GDM.RestrictedFunctionalDepartmentGLGlobalAccountActive('2012-01-31') ActiveRestrictedFunctionalDepartmentGlGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.ImportKey = ActiveRestrictedFunctionalDepartmentGlGlobalAccount.ImportKey
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartment FunctionalDepartment ON
				RestrictedFunctionalDepartmentGLGlobalAccount.FunctionalDepartmentId = FunctionalDepartment.FunctionalDepartmentId
			LEFT OUTER JOIN GrReportingStaging.HR.FunctionalDepartmentActive('2012-01-31') FunctionalDepartmentActive ON
				FunctionalDepartment.ImportKey = FunctionalDepartmentActive.ImportKey
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccount ON
				RestrictedFunctionalDepartmentGLGlobalAccount.GLGlobalAccountId = GLGlobalAccount.GLGlobalAccountId
			INNER JOIN GrReportingStaging.GDM.GLGlobalAccountActive('2012-01-31') GLGlobalAccountActive ON
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


