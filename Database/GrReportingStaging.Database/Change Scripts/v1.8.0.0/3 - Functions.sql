/* Functions to deploy:

[Gr].[GetActivityTypeBusinessLineExpanded]
[Gr].[GetGlobalGLAccountCategoryTranslation]
[Gr].[GetGlobalRegionExpanded]
[Gr].[GetFunctionalDepartmentExpanded]

*/ 

USE [GrReportingStaging]
GO
/****** Object:  UserDefinedFunction [Gr].[GetActivityTypeBusinessLineExpanded]    Script Date: 08/11/2011 14:00:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 08/11/2011 14:00:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 08/11/2011 14:00:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalRegionExpanded]    Script Date: 08/11/2011 14:00:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalRegionExpanded]
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalRegionExpanded]    Script Date: 08/11/2011 14:00:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalRegionExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gr].[GetGlobalRegionExpanded]
	(@DataPriorToDate DATETIME)
	
RETURNS @Result TABLE (
	GlobalRegionId INT NOT NULL,
	RegionCode VARCHAR(10) NOT NULL,
	RegionName VARCHAR(50) NOT NULL,
	RegionCountryId INT NULL,
	RegionDefaultCurrencyCode CHAR(3) NOT NULL,
	RegionDefaultCorporateSourceCode CHAR(2) NOT NULL,
	RegionProjectCodePortion CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsAllocationRegion BIT NOT NULL,
	IsOriginatingRegion BIT NOT NULL,
	SubRegionCode VARCHAR(10) NULL,
	SubRegionName VARCHAR(50) NULL,
	SubRegionDefaultCurrencyCode CHAR(3) NULL,
	SubRegionProjectCodePortion CHAR(2) NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result
SELECT
	GR.GlobalRegionId,
	GR.RegionCode,
	GR.RegionName,
	GR.RegionCountryId,
	GR.RegionDefaultCurrencyCode,
	GR.RegionDefaultCorporateSourceCode,
	GR.RegionProjectCodePortion,
	GR.InsertedDate,
	GR.UpdatedDate,
	GR.IsAllocationRegion,
	GR.IsOriginatingRegion,
	GR.SubRegionCode,
	GR.SubRegionName,
	GR.SubRegionDefaultCurrencyCode,
	GR.SubRegionProjectCodePortion,
	GR.IsActive
FROM
	Gdm.GlobalRegionActive(@DataPriorToDate) GRA

	INNER JOIN
	(
		SELECT
			SubReg.ImportKey,
			SubReg.GlobalRegionId,
			Reg.Code RegionCode,
			Reg.Name RegionName,
			Reg.CountryId RegionCountryId,
			Reg.DefaultCurrencyCode RegionDefaultCurrencyCode,
			Reg.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
			Reg.ProjectCodePortion RegionProjectCodePortion,	
			CONVERT(DATETIME, CONVERT(VARCHAR(23), Reg.InsertedDate, 120), 120) InsertedDate,
			CONVERT(DATETIME, CONVERT(VARCHAR(23), CASE WHEN MAX(SubReg.UpdatedDate) < MAX(Reg.UpdatedDate) THEN MAX(Reg.UpdatedDate) ELSE MAX(SubReg.UpdatedDate) END, 120), 120) UpdatedDate,
			SubReg.IsAllocationRegion,
			SubReg.IsOriginatingRegion,
			SubReg.Code SubRegionCode,
			SubReg.Name SubRegionName,
			SubReg.DefaultCurrencyCode SubRegionDefaultCurrencyCode,
			SubReg.ProjectCodePortion SubRegionProjectCodePortion,
			CASE WHEN Reg.IsActive = 0 THEN 0 ELSE SubReg.IsActive END AS IsActive -- If the Parent Region is not active, then its SubRegions should not be active either
		FROM
			Gdm.GlobalRegion Reg

			INNER JOIN Gdm.GlobalRegion SubReg ON
				SubReg.ParentGlobalRegionId = Reg.GlobalRegionId
		GROUP BY
			SubReg.ImportKey,
			SubReg.GlobalRegionId,
			Reg.Code,
			Reg.Name,
			Reg.CountryId,
			Reg.DefaultCurrencyCode,
			Reg.DefaultCorporateSourceCode,	
			Reg.ProjectCodePortion,
			Reg.InsertedDate,
			SubReg.IsAllocationRegion,
			SubReg.IsOriginatingRegion,
			SubReg.Code,
			SubReg.Name,
			SubReg.DefaultCurrencyCode,
			SubReg.ProjectCodePortion,
			CASE WHEN Reg.IsActive = 0 THEN 0 ELSE SubReg.IsActive END

		UNION

		-- SELECT the Parent Regions (Regions that have no Parent Region)

		SELECT
			Reg.ImportKey,
			Reg.GlobalRegionId,
			Reg.Code RegionCode,
			Reg.Name RegionName,
			Reg.CountryId RegionCountryId,
			Reg.DefaultCurrencyCode RegionDefaultCurrencyCode,
			Reg.DefaultCorporateSourceCode RegionDefaultCorporateSourceCode,
			Reg.ProjectCodePortion RegionProjectCodePortion,
			CONVERT(DATETIME, CONVERT(VARCHAR(23), Reg.InsertedDate, 120), 120),
			CONVERT(DATETIME, CONVERT(VARCHAR(23), Reg.UpdatedDate, 120), 120),
			Reg.IsAllocationRegion,
			Reg.IsOriginatingRegion,
			NULL SubRegionCode,
			NULL SubRegionName,
			NULL SubRegionDefaultCurrencyCode,
			NULL SubRegionProjectCodePortion,
			Reg.IsActive
		FROM
			Gdm.GlobalRegion Reg
		WHERE
			Reg.ParentGlobalRegionId IS NULL AND
			Reg.GlobalRegionId IN (
									SELECT
										ParentGlobalRegionId 
									FROM
										Gdm.GlobalRegion Reg 
									WHERE
										Reg.ParentGlobalRegionId IS NOT NULL )
	) GR ON
		GRA.ImportKey = GR.ImportKey

RETURN
END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 08/11/2011 14:00:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
	(@DataPriorToDate DATETIME)

RETURNS @GLAccountCategories TABLE (
		GlobalAccountCategoryCode VARCHAR(33) NULL,
		TranslationTypeName VARCHAR(50) NOT NULL,
		TranslationSubTypeName VARCHAR(50) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		FeeOrExpense VARCHAR(7) NOT NULL,
		GLAccountSubTypeName VARCHAR(50) NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
AS

BEGIN	

	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)

--------------------------------------------------------------------------------------------------------------------------------------------

	-- Get ''UNKNOWN'' GL Account Category records for each Translation SubType

	SELECT
		LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':-1:-1:-1:-1'',
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		-1,
		''UNKNOWN'',
		-1,
		''UNKNOWN'',
		''UNKNOWN'',
		''UNKNOWN'',
		1,
		''1900-01-01'',
		''1900-01-01''	
	FROM
	
		(
			SELECT
				TT.*
			FROM
				Gdm.GLTranslationType TT
				INNER JOIN
					Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA
					ON TTA.ImportKey = TT.ImportKey
		) TT
	
		INNER JOIN (
			SELECT
				TST.*
			FROM
				Gdm.GLTranslationSubType TST
				INNER JOIN
					Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA 
					ON TSTA.ImportKey = TST.ImportKey
		) TST ON TT.GLTranslationTypeId = TST.GLTranslationTypeId

	------------------

	UNION

	------------------

	/*  Sample output from the SELECT below:

		GlobalAccountCategoryCode	TranslationTypeName	TranslationSubTypeName	GLMajorCategoryId	GLMajorCategoryName			GLMinorCategoryId	GLMinorCategoryName				FeeOrExpense	GLAccountSubTypeName
		1:233:18:490:1:1			Global				Global					18					Legal & Professional Fees	490					Legal - HR Related - Non-Union	EXPENSE			Non-Payroll
	*/

	SELECT
		CONVERT(VARCHAR(32), LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + '':'' + 
			LTRIM(STR(AT.GLAccountTypeId, 10, 0)) + '':'' + 
			LTRIM(STR(AST.GLAccountSubTypeId, 10, 0))) GlobalAccountCategoryCode,
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		MajC.GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		CASE
			WHEN
				AT.Code LIKE ''%EXP%''
			THEN
				''EXPENSE'' 
			WHEN
				AT.Code LIKE ''%INC%''
			THEN
				''INCOME''
			ELSE ''UNKNOWN''
		END AS FeeOrExpense,						-- sourced from Gdm.GlobalGlAccountCategoryHierarchy.AccountType
		AST.Name GLAccountSubTypeName,				-- used to be ExpenseType, sourced from Gdm.GlobalGlAccountCategoryHierarchy.ExpenseType
		CASE
			WHEN									-- Every record that is used to construct the GL Account Category record needs to be active
				TST.IsActive = 1 AND				-- for the GL Account Category record to be active itself.
				GLATST.IsActive = 1 AND
				GLATT.IsActive = 1 AND
				TT.IsActive = 1 AND
				GLA.IsActive = 1 AND
				MajC.IsActive = 1 AND
				MinC.IsActive = 1 AND
				AST.IsActive = 1 AND
				AT.IsActive = 1
			THEN
				1
			ELSE
				0
		END AS IsActive, 
		MIN(GLATT.InsertedDate) InsertedDate,
		MAX(GLATT.UpdatedDate) UpdatedDate
	FROM
		Gdm.GLTranslationSubType TST
		
		INNER JOIN Gdm.GLGlobalAccountTranslationSubType GLATST ON
			TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId					
			
		INNER JOIN Gdm.GLGlobalAccountTranslationType GLATT ON
			GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
			TST.GLTranslationTypeId = GLATT.GLTranslationTypeId
					
		INNER JOIN Gdm.GLTranslationType TT ON
			GLATT.GLTranslationTypeId = TT.GLTranslationTypeId
	
		INNER JOIN Gdm.GLGlobalAccount GLA ON
			GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId	
		
		INNER JOIN Gdm.GLMinorCategory MinC ON
			GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId

		INNER JOIN Gdm.GLMajorCategory MajC ON
			MinC.GLMajorCategoryId = MajC.GLMajorCategoryId

		INNER JOIN Gdm.GLAccountSubType AST ON
			GLATT.GLAccountSubTypeId = AST.GLAccountSubTypeId
			
		INNER JOIN Gdm.GLAccountType AT ON
			GLATT.GLAccountTypeId = AT.GLAccountTypeId 
			
		INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON 
			TSTA.ImportKey = TST.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GLATSTA ON 
			GLATSTA.ImportKey = GLATST.ImportKey
			
		INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON 
			TTA.ImportKey = TT.ImportKey	
			
		INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GLATTA ON 
			GLATTA.ImportKey = GLATT.ImportKey	
			
		INNER JOIN 	Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
			GLAA.ImportKey = GLA.ImportKey	
			
		INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON 
			MinCA.ImportKey = MinC.ImportKey
			
		INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON 
			MajCA.ImportKey = MajC.ImportKey	
			
		INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON 
			ASTA.ImportKey = AST.ImportKey	
			
		INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
			ATA.ImportKey = AT.ImportKey 	
			
	GROUP BY
		TT.GLTranslationTypeId,
		TT.Name,		
		TST.GLTranslationSubTypeId,
		TST.Name,
		MajC.GLMajorCategoryId,
		MajC.Name,
		MinC.GLMinorCategoryId,
		MinC.Name,
		CASE
			WHEN
				AT.Code LIKE ''%EXP%''
			THEN
				''EXPENSE'' 
			WHEN
				AT.Code LIKE ''%INC%''
			THEN
				''INCOME''
			ELSE
				''UNKNOWN''
		END,
		AT.GLAccountTypeId,
		AST.Name,
		AST.GLAccountSubTypeId,
		CASE
			WHEN
				TST.IsActive = 1 AND
				GLATST.IsActive = 1 AND
				GLATT.IsActive = 1 AND
				TT.IsActive = 1 AND
				GLA.IsActive = 1 AND
				MajC.IsActive = 1 AND
				MinC.IsActive = 1 AND
				AST.IsActive = 1 AND
				AT.IsActive = 1
			THEN
				1
			ELSE
				0
		END

--------------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @GLAccountCategories_GLAccountSubTypeAsOverhead TABLE(
		GlobalAccountCategoryCode VARCHAR(33) NULL,
		TranslationTypeName VARCHAR(50) NOT NULL,
		TranslationSubTypeName VARCHAR(50) NOT NULL,
		GLMajorCategoryId INT NOT NULL,
		GLMajorCategoryName VARCHAR(50) NOT NULL,
		GLMinorCategoryId INT NOT NULL,
		GLMinorCategoryName VARCHAR(100) NOT NULL,
		FeeOrExpense VARCHAR(7) NOT NULL,
		GLAccountSubTypeName VARCHAR(50) NULL,
		IsActive BIT NOT NULL,
		InsertedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
	)
	
	DECLARE @GRPOHD_Name VARCHAR(50) = (SELECT TOP 1 Name FROM Gdm.GLAccountSubType WHERE Code = ''GRPOHD'')
	DECLARE @GRPOHD_ID VARCHAR(10) = (SELECT LTRIM(STR(GLAccountSubTypeId, 10, 0)) FROM Gdm.GLAccountSubType WHERE Code = ''GRPOHD'')
	
	/*
		For each GL Account Category record that has been inserted into @GLAccountCategories, a new record needs to be inserted that is identical to this
		record in every respect apart from its GLAccountSubType - this will be hardcoded from the original GLAccountSubType to ''Overhead''
		Note that in thet record below, all field values should be identical to the sample record above (around line 100) besides the
		GLAccountSubType field: this has been updated from ''Non-Payroll'' to ''Overhead''.

		GlobalAccountCategoryCode	TranslationTypeName		TranslationSubTypeName	GLMajorCategoryId	GLMajorCategoryName			GLMinorCategoryId	GLMinorCategoryName					FeeOrExpense	GLAccountSubTypeName
		1:233:18:490:1:3			Global					Global					18					Legal & Professional Fees	490					Legal - HR Related - Non-Union		EXPENSE			Overhead
	*/

	INSERT INTO @GLAccountCategories_GLAccountSubTypeAsOverhead (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT	
		DISTINCT
		REVERSE(SUBSTRING(REVERSE(GlobalAccountCategoryCode),
						  PATINDEX(''%:%'', REVERSE(GlobalAccountCategoryCode)),
						  LEN(GlobalAccountCategoryCode))
						  ) + @GRPOHD_ID -- we can hardcode the ID of the ''Overhead'' GLAccountSubType record
		AS GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		@GRPOHD_Name AS GLAccountSubTypeName, -- Instead of selecting the original GLAccountSubType, hardcode ''Overhead''
		IsActive,
		InsertedDate,
		UpdatedDate
	FROM
		@GLAccountCategories
		
	-- Insert the new ''Overhead'' GL Account Category records into @GLAccountCategories that do not already exist in @GLAccountCategories.
	
	INSERT INTO @GLAccountCategories (
		GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		GLAccountSubTypeName,
		IsActive,
		InsertedDate,
		UpdatedDate
	)
	SELECT  
		t1.GlobalAccountCategoryCode,
		t1.TranslationTypeName,
		t1.TranslationSubTypeName,
		t1.GLMajorCategoryId,
		t1.GLMajorCategoryName,
		t1.GLMinorCategoryId,
		t1.GLMinorCategoryName,
		t1.FeeOrExpense,
		t1.GLAccountSubTypeName,
		t1.IsActive,
		t1.InsertedDate,
		t1.UpdatedDate
	FROM
		@GLAccountCategories_GLAccountSubTypeAsOverhead t1

		LEFT OUTER JOIN @GLAccountCategories t2 ON
			t1.GlobalAccountCategoryCode = t2.GlobalAccountCategoryCode
	WHERE
		t2.GlobalAccountCategoryCode IS NULL
		
	RETURN

END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 08/11/2011 14:00:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
/*********************************************************************************************************************
Description
	The function is used for as source data for populating the FunctionalDepartment slowly changing	dimension in 
	the data warehouse (GrReporting).
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-20		: PKayongo	:	Add the IsActive = 1 condition to Functional Departments to make sure
											inactive functional departments are not included.
											
			2011-08-09		: ISaunder	: Removed the IsActive filter and added it to the SELECTs instead. The SCD stored procedures will determine
											how inactive functional departments should ne handled.
**********************************************************************************************************************/

CREATE FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE (
	FunctionalDepartmentId INT NOT NULL,
	ReferenceCode VARCHAR(20) NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN 

INSERT INTO @Result (
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	FD.FunctionalDepartmentId,
	FD.GlobalCode+'':'',
	FD.GlobalCode FunctionalDepartmentCode,
	FD.Name FunctionalDepartmentName,
	FD.GlobalCode SubFunctionalDepartmentCode,
	RTRIM(Fd.GlobalCode) + '' - '' + Fd.Name SubFunctionalDepartmentName,
	FD.UpdatedDate,
	FD.IsActive	
FROM 
	HR.FunctionalDepartment FD
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON 
		FDA.ImportKey = FD.ImportKey
WHERE 
	FD.GlobalCode IS NOT NULL

INSERT INTO @Result
(
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	T2.FunctionalDepartmentId,
	T1.FunctionalDepartmentCode+'':''+T2.Code,
	T1.FunctionalDepartmentCode,
	T1.FunctionalDepartmentName,
	T2.Code,
	RTRIM(T2.Code) + '' - '' + T2.Description,
	T2.UpdatedDate,
	CASE WHEN T1.IsActive = 0 THEN 0 ELSE T2.IsActive END AS IsActive -- If the Parent FD is inactive, the child FDs should be inactive as well
FROM	
	@Result T1
	INNER JOIN 
	(
		SELECT 
			JC.JobCode Code,
			MAX(JC.Description) AS Description,
			MAX(JC.FunctionalDepartmentId) AS FunctionalDepartmentId,
			MAX(JC.UpdatedDate) AS UpdatedDate,
			IsActive
		FROM 
			GACS.JobCode JC
			INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JCA ON
				JCA.ImportKey = JC.ImportKey
		WHERE 
			JC.FunctionalDepartmentId IS NOT NULL
		GROUP BY --TODO. As per AW advice job code will never be map to functional departments for day 1, we will address a change in this when the time comes.
			JC.JobCode,
			JC.IsActive
	) T2 ON 
		T2.FunctionalDepartmentId = T1.FunctionalDepartmentId AND
		T2.Code <> T1.FunctionalDepartmentCode
ORDER BY 
	T1.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
INSERT INTO @Result (
	FunctionalDepartmentId,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	FD.FunctionalDepartmentId,
	FD.GlobalCode+'':UNKNOWN'',
	FD.GlobalCode FunctionalDepartmentCode,
	FD.Name FunctionalDepartmentName,
	''UNKNOWN'' SubFunctionalDepartmentCode,
	''UNKNOWN'' SubFunctionalDepartmentName,
	FD.UpdatedDate,
	FD.IsActive
FROM 
	HR.FunctionalDepartment FD
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON
		FDA.ImportKey = FD.ImportKey
WHERE 
	FD.GlobalCode IS NOT NULL

RETURN
END

' 
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetActivityTypeBusinessLineExpanded]    Script Date: 08/11/2011 14:00:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetActivityTypeBusinessLineExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'

CREATE FUNCTION [Gr].[GetActivityTypeBusinessLineExpanded] 
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE (
	ActivityTypeId INT NOT NULL,
	ActivityTypeName VARCHAR(50) NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	BusinessLineId INT NOT NULL,
	BusinessLineName VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)
AS
BEGIN

INSERT INTO @Result
SELECT
	ActivityType.ActivityTypeId,
	ActivityType.ActivityTypeName,
	ActivityType.ActivityTypeCode,
	BusinessLine.BusinessLineId,
	BusinessLine.BusinessLineName,
	MIN(ActivityTypeBusinessLine.InsertedDate) AS InsertedDate,
	MAX(ActivityTypeBusinessLine.UpdatedDate) AS UpdatedDate,
	CASE WHEN ActivityTypeBusinessLine.IsActive = 1 AND ActivityType.IsActive = 1 AND BusinessLine.IsActive = 1 THEN 1 ELSE 0 END AS IsActive
	-- All records (ActivityType, BusinessLine, and ActivityTypeBusinessLine) need to be active for the ''final'' record to be active
FROM
	(
		SELECT
			ATBL.ActivityTypeId,
			ATBL.BusinessLineId,
			ATBL.InsertedDate,
			ATBL.UpdatedDate,
			ATBL.IsActive
		FROM
			Gdm.ActivityTypeBusinessLine ATBL
			INNER JOIN Gdm.ActivityTypeBusinessLineActive(@DataPriorToDate) ATBLA ON
				ATBL.ImportKey = ATBLA.ImportKey
	
	) ActivityTypeBusinessLine
		
	INNER JOIN (
	
		SELECT
			AT.ActivityTypeId,
			AT.Name AS ActivityTypeName,
			AT.Code AS ActivityTypeCode,
			AT.InsertedDate,
			AT.UpdatedDate,
			AT.IsActive
		FROM
			Gdm.ActivityType AT
			INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) ATA ON
				AT.ImportKey = ATA.ImportKey
	
	) ActivityType ON
		ActivityTypeBusinessLine.ActivityTypeId = ActivityType.ActivityTypeId

	INNER JOIN (
	
		SELECT
			BL.BusinessLineId,
			BL.Name AS BusinessLineName,
			BL.InsertedDate,
			BL.UpdatedDate,
			BL.IsActive
		FROM
			Gdm.BusinessLine BL
			INNER JOIN Gdm.BusinessLineActive(@DataPriorToDate) BLA ON
				BL.ImportKey = BLA.ImportKey
	
	) BusinessLine ON
		ActivityTypeBusinessLine.BusinessLineId = BusinessLine.BusinessLineId

GROUP BY
	ActivityType.ActivityTypeId,
	ActivityType.ActivityTypeName,
	ActivityType.ActivityTypeCode,
	BusinessLine.BusinessLineId,
	BusinessLine.BusinessLineName,
	CASE WHEN ActivityTypeBusinessLine.IsActive = 1 AND ActivityType.IsActive = 1 AND BusinessLine.IsActive = 1 THEN 1 ELSE 0 END

RETURN
END

' 
END
GO
