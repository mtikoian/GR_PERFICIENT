 /*
 Requirement for Deployment:
 
 [Gr].[GetFunctionalDepartmentExpanded]
 [GetGlobalGlAccountCategoryTranslation]
 [stp_I_ImportBatch]
 
 stp_IU_LoadGrProfitabiltyCorporateOriginalBudget.sql
 stp_IU_LoadGrProfitabiltyCorporateReforecast.sql
 stp_IU_LoadGrProfitabiltyGeneralLedger.sql
 stp_IU_LoadGrProfitabiltyOverhead.sql
 stp_IU_LoadGrProfitabiltyPayrollOriginalBudget.sql
 stp_IU_LoadGrProfitabiltyPayrollReforecast.sql
 
 */ 
 
 
USE [GrReportingStaging]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
GO
CREATE   FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(
	FunctionalDepartmentId Int NOT NULL,
	ReferenceCode varchar(20) NULL,
	FunctionalDepartmentCode varchar(20) NOT NULL,
	FunctionalDepartmentName Varchar(50) NOT NULL,
	SubFunctionalDepartmentCode varchar(20) NOT NULL,
	SubFunctionalDepartmentName Varchar(100) NOT NULL,
	UpdatedDate DateTime NOT NULL
	)
AS
BEGIN 

Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+':',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		Fd.GlobalCode SubFunctionalDepartmentCode,
		RTRIM(Fd.GlobalCode) + ' - ' + Fd.Name SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
Where Fd.GlobalCode IS NOT NULL

Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		T2.FunctionalDepartmentId,
		T1.FunctionalDepartmentCode+':'+T2.Code,
		T1.FunctionalDepartmentCode,
		T1.FunctionalDepartmentName,
		T2.Code,
		RTRIM(T2.Code) + ' - ' + T2.Description,
		T2.UpdatedDate
From	
		@Result T1
			INNER JOIN 
						(
							Select 
									--Jc.Source,
									Jc.JobCode Code,
									Max(Jc.Description) as Description,
									Max(Jc.FunctionalDepartmentId) as FunctionalDepartmentId,
									Max(Jc.UpdatedDate) as UpdatedDate
							From GACS.JobCode Jc
								INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON JcA.ImportKey = Jc.ImportKey
							Where Jc.FunctionalDepartmentId IS NOT NULL
							Group By --TODO. As per AW advice job code will never be map to functional departments for day 1, we will address a change in this when the time comes.
									Jc.JobCode
							
						) T2 ON T2.FunctionalDepartmentId = T1.FunctionalDepartmentId
						AND T2.Code <> T1.FunctionalDepartmentCode

Order By T1.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+':UNKNOWN',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		'UNKNOWN' SubFunctionalDepartmentCode,
		'UNKNOWN' SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
Where Fd.GlobalCode IS NOT NULL

RETURN
END

GO

/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 10/20/2009 12:06:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ImportBatch]
GO

CREATE PROCEDURE [dbo].[stp_I_ImportBatch]
	@PackageName		VARCHAR(100),
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime

AS

	
	INSERT INTO Batch
	(
		PackageName,
		BatchStartDate,
		ImportStartDate,
		ImportEndDate,
		DataPriorToDate
	)
	VALUES
	(
		@PackageName,	/* PackageName	*/
		GetDate(),
		@ImportStartDate,
		@ImportEndDate,
		@DataPriorToDate
	)
	
	SELECT SCOPE_IDENTITY() AS BatchId

GO

--- [Gdm].[PropertyEntityGLAccountInclusionActive]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyEntityGLAccountInclusionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[PropertyEntityGLAccountInclusionActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[PropertyEntityGLAccountInclusionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyEntityGLAccountInclusion] Gl1
		INNER JOIN (
			SELECT 
				PropertyEntityGLAccountInclusionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyEntityGLAccountInclusion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PropertyEntityGLAccountInclusionId
		) t1 ON t1.PropertyEntityGLAccountInclusionId = Gl1.PropertyEntityGLAccountInclusionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PropertyEntityGLAccountInclusionId	
)

GO

--------
USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 09/23/2010 13:24:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryTranslation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryTranslation]    Script Date: 09/23/2010 13:24:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryTranslation]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE (
	GlobalAccountCategoryCode varchar(33) NULL,
	TranslationTypeName varchar(50) NOT NULL,
	TranslationSubTypeName varchar(50) NOT NULL,
	GLMajorCategoryId int NOT NULL,
	GLMajorCategoryName varchar(50) NOT NULL,
	GLMinorCategoryId int NOT NULL,
	GLMinorCategoryName varchar(100) NOT NULL,
	FeeOrExpense varchar(7) NOT NULL,
	GLAccountSubTypeName varchar(50) NULL,
	InsertedDate DateTime NOT NULL,
	UpdatedDate DateTime NOT NULL
)
AS

BEGIN
	
	
	Insert Into @Result
	(GlobalAccountCategoryCode,TranslationTypeName,TranslationSubTypeName,GLMajorCategoryId,
	GLMajorCategoryName,GLMinorCategoryId,GLMinorCategoryName,FeeOrExpense,GLAccountSubTypeName,InsertedDate,UpdatedDate)
	SELECT	
		CONVERT(VARCHAR(32), LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + ':' + 
			LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + ':' + 
			LTRIM(STR(MajC.GLMajorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(MinC.GLMinorCategoryId, 10, 0)) + ':' + 
			LTRIM(STR(AT.GLAccountTypeId, 10, 0)) + ':' + 
			LTRIM(STR(AST.GLAccountSubTypeId, 10, 0))) GlobalAccountCategoryCode,
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		MajC.GLMajorCategoryId,
		MajC.Name GLMajorCategoryName,
		MinC.GLMinorCategoryId,
		MinC.Name GLMinorCategoryName,
		CASE WHEN AT.Code LIKE '%EXP%' THEN 'EXPENSE' 
			WHEN AT.Code LIKE '%INC%' THEN 'INCOME'
			ELSE 'UNKNOWN' END as FeeOrExpense,		-- sourced from Gdm.GlobalGlAccountCategoryHierarchy.AccountType
		AST.Name GLAccountSubTypeName,				-- used to be ExpenseType, sourced from Gdm.GlobalGlAccountCategoryHierarchy.ExpenseType
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
		CASE WHEN AT.Code LIKE '%EXP%' THEN 'EXPENSE' 
			WHEN AT.Code LIKE '%INC%' THEN 'INCOME'
			ELSE 'UNKNOWN' END,
		AT.GLAccountTypeId,
		AST.Name,
		AST.GLAccountSubTypeId
		
	UNION
	
	SELECT
		LTRIM(STR(TT.GLTranslationTypeId, 10, 0)) + ':' + LTRIM(STR(TST.GLTranslationSubTypeId, 10, 0)) + ':-1:-1:-1:-1',
		TT.Name TranslationTypeName,
		TST.Name TranslationSubTypeName,
		-1,
		'UNKNOWN',
		-1,
		'UNKNOWN',
		'UNKNOWN',
		'UNKNOWN',
		'1900-01-01',
		'1900-01-01'	
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
	
	DECLARE @Temp TABLE (
	GlobalAccountCategoryCode varchar(33) NULL,
	TranslationTypeName varchar(50) NOT NULL,
	TranslationSubTypeName varchar(50) NOT NULL,
	GLMajorCategoryId int NOT NULL,
	GLMajorCategoryName varchar(50) NOT NULL,
	GLMinorCategoryId int NOT NULL,
	GLMinorCategoryName varchar(100) NOT NULL,
	FeeOrExpense varchar(7) NOT NULL,
	GLAccountSubTypeName varchar(50) NULL,
	InsertedDate DateTime NOT NULL,
	UpdatedDate DateTime NOT NULL)
	
		
	--Now add the virtual rows, for each Major&Minor combination, we need to have a copy combination, but the
	--GLAccountSubType must be Overhead instead of the original GLAccountSubType
	Insert Into @Temp
	(GlobalAccountCategoryCode, TranslationTypeName,TranslationSubTypeName,GLMajorCategoryId,
	GLMajorCategoryName,GLMinorCategoryId,GLMinorCategoryName,FeeOrExpense,GLAccountSubTypeName,InsertedDate,UpdatedDate)
	SELECT	
		DISTINCT
		REVERSE(SUBSTRING(REVERSE(GlobalAccountCategoryCode), patindex('%:%',REVERSE(GlobalAccountCategoryCode)), LEN(GlobalAccountCategoryCode)))+
			(Select LTRIM(STR(GLAccountSubTypeId,10,0)) From Gdm.GLAccountSubType Where Code = 'GRPOHD') as GlobalAccountCategoryCode,
		TranslationTypeName,
		TranslationSubTypeName,
		GLMajorCategoryId,
		GLMajorCategoryName,
		GLMinorCategoryId,
		GLMinorCategoryName,
		FeeOrExpense,
		(Select Name From Gdm.GLAccountSubType Where Code = 'GRPOHD'),
		InsertedDate,
		UpdatedDate
	From @Result
		
	
	Insert Into @Result
	(GlobalAccountCategoryCode, TranslationTypeName,TranslationSubTypeName,GLMajorCategoryId,
	GLMajorCategoryName,GLMinorCategoryId,GLMinorCategoryName,FeeOrExpense,GLAccountSubTypeName,InsertedDate,UpdatedDate)
	Select  
			t1.GlobalAccountCategoryCode, t1.TranslationTypeName,t1.TranslationSubTypeName,t1.GLMajorCategoryId,
			t1.GLMajorCategoryName,t1.GLMinorCategoryId,t1.GLMinorCategoryName,t1.FeeOrExpense,t1.GLAccountSubTypeName,
			t1.InsertedDate,t1.UpdatedDate
	From @Temp t1
		LEFT OUTER JOIN @Result t2 ON t1.GlobalAccountCategoryCode = t2.GlobalAccountCategoryCode
	Where 	t2.GlobalAccountCategoryCode IS NULL
		
	RETURN 
END
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadExchangeRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyOverhead]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 10/01/2010 06:43:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadExchangeRates]    Script Date: 10/01/2010 06:43:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadExchangeRates]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()
	
SET NOCOUNT OFF
PRINT '####'
PRINT 'stp_IU_LoadExchangeRates'
PRINT '####'

--Generate temp table to prevent repeated function calls

CREATE TABLE #BudgetReportGroupActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupActive
SELECT * FROM TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate)
 
CREATE TABLE #BudgetReportGroupDetailActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupDetailActive
SELECT * FROM TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate)
 
CREATE TABLE #BudgetActive
(
	ImportKey INT
)
INSERT INTO #BudgetActive
SELECT * FROM TapasGlobalBudgeting.BudgetActive(@DataPriorToDate)

CREATE TABLE #ExchangeRateActive
(
	ImportKey INT
)
INSERT INTO #ExchangeRateActive
SELECT * FROM Gdm.BudgetExchangeRateActive(@DataPriorToDate)

CREATE TABLE #ExchangeRateDetailActive
(
	ImportKey INT
)
INSERT INTO #ExchangeRateDetailActive
SELECT * FROM Gdm.BudgetExchangeRateDetailActive(@DataPriorToDate)

CREATE TABLE #BudgetStatusActive
(
	ImportKey INT
)
INSERT INTO #BudgetStatusActive
SELECT * FROM TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate)

CREATE TABLE #BudgetReportGroupPeriodActive
(
	ImportKey INT
)
INSERT INTO #BudgetReportGroupPeriodActive
SELECT * FROM Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate)

--Get all budget report groups which have been modified
DECLARE @UpdatedBudgetReportGroupIds  TABLE 
        (BudgetReportGroupId INT)

INSERT INTO @UpdatedBudgetReportGroupIds
SELECT 
	DISTINCT brg.BudgetReportGroupId
FROM
	Gdm.BudgetExchangeRateDetail erd
    INNER JOIN Gdm.BudgetExchangeRate er ON  
		er.BudgetExchangeRateId= erd.BudgetExchangeRateId
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetExchangeRateId = er.BudgetExchangeRateId
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON  
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    INNER JOIN TapasGlobalBudgeting.Budget b ON  
		b.BudgetId = brgd.BudgetId
    INNER JOIN TapasGlobalBudgeting.BudgetStatus bs ON  
		bs.BudgetStatusId = b.BudgetStatusId
WHERE  
	(
		(erd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(er.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brg.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
		(b.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate)
	) AND
	er.IsDeleted = 0
	  

--Filter items that are deleted or not global
DECLARE @FirstFilterBudgetReportGroupIds TABLE 
        (BudgetReportGroupId INT)

INSERT INTO @FirstFilterBudgetReportGroupIds
SELECT 
	brg.BudgetReportGroupId
FROM
	@UpdatedBudgetReportGroupIds ubrgi
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetReportGroupId = ubrgi.BudgetReportGroupId
    INNER JOIN #BudgetReportGroupActive bprga ON  
		bprga.ImportKey = brg.ImportKey
	INNER JOIN Gdm.BudgetReportGroupPeriod grgp ON 
		grgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId
	INNER JOIN #BudgetReportGroupPeriodActive grbrgpa ON 
		grbrgpa.ImportKey = grgp.ImportKey
WHERE  
	brg.IsDeleted = 0 AND
	grgp.IsDeleted = 0

--Get the budgets that are locked

CREATE TABLE #FilteredBudgetGroups 
(
    BudgetReportGroupId INT,
    StartPeriod INT,
    EndPeriod INT,
    FirstProjectedPeriod INT,
	ExchangeRateId INT
)

INSERT INTO #FilteredBudgetGroups
SELECT 
	brg.BudgetReportGroupId,
    MAX(brg.StartPeriod),
    MAX(brg.EndPeriod),
    MAX(brg.FirstProjectedPeriod),
    MAX(brg.BudgetExchangeRateId)
FROM
	@FirstFilterBudgetReportGroupIds ffbrgi
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroup brg ON  
		brg.BudgetReportGroupId = ffbrgi.BudgetReportGroupId
    INNER JOIN #BudgetReportGroupActive brga ON  
		brga.ImportKey = brg.ImportKey
    INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetail brgd ON  
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId AND 
		brgd.IsDeleted = 0
    INNER JOIN #BudgetReportGroupDetailActive brgda ON  
		brgda.ImportKey = brgd.ImportKey
    INNER JOIN TapasGlobalBudgeting.Budget b ON  
		b.BudgetId = brgd.BudgetId AND 
		b.IsDeleted = 0
	INNER JOIN #BudgetActive ba ON  
		ba.ImportKey = b.ImportKey
    INNER JOIN TapasGlobalBudgeting.BudgetStatus bs ON  
		b.BudgetStatusId = bs.BudgetStatusId
	INNER JOIN #BudgetStatusActive bsa ON 
		bsa.ImportKey = bs.ImportKey
GROUP BY
    brg.BudgetReportGroupId
HAVING  COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) 

--Get only the latest budgets
CREATE TABLE #LatestBudgetGroups 
(
	BudgetReportGroupId INT,
    StartPeriod INT,
    EndPeriod INT,
    ExchangeRateId INT
)
        
--Number the budgetgroups with no first projected date
UPDATE #FilteredBudgetGroups
SET FirstProjectedPeriod = NumberedRows.RowNumber
FROM
(
	SELECT BudgetReportGroupId, StartPeriod, EndPeriod, ExchangeRateId, ROW_NUMBER() OVER (ORDER BY ExchangeRateId) AS RowNumber
	FROM #FilteredBudgetGroups
) NumberedRows
INNER JOIN #FilteredBudgetGroups lbg ON
	NumberedRows.BudgetReportGroupId = lbg.BudgetReportGroupId AND
	NumberedRows.StartPeriod = lbg.StartPeriod AND
	NumberedRows.EndPeriod = lbg.EndPeriod AND
	NumberedRows.ExchangeRateId = lbg.ExchangeRateId
WHERE FirstProjectedPeriod IS NULL

;with FilteredBudgetGroupsRank as
(
    SELECT  
		fbg.BudgetReportGroupId,
		fbg.StartPeriod,
		fbg.EndPeriod,
		fbg.FirstProjectedPeriod,
		fbg.ExchangeRateId,
        RANK() OVER (PARTITION BY fbg.StartPeriod, fbg.EndPeriod ORDER BY fbg.FirstProjectedPeriod DESC) AS GroupRank
    FROM #FilteredBudgetGroups fbg
)
INSERT INTO #LatestBudgetGroups
SELECT DISTINCT
	fbgr.BudgetReportGroupId,
	fbgr.StartPeriod,
	fbgr.EndPeriod,
	fbgr.ExchangeRateId
FROM
	FilteredBudgetGroupsRank fbgr
WHERE 
	fbgr.GroupRank <= 1
	
--Get the exchange rate for the given groups
CREATE TABLE #ExchangeRates 
(
	CurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    BudgetReportGroupId INT,
    BudgetExchangeRateId INT,
    BudgetExchangeRateDetailId INT
)

INSERT INTO #ExchangeRates
SELECT 
	erd.CurrencyCode,
    erd.Period,
    erd.Rate,
    lbg.BudgetReportGroupId,
    lbg.ExchangeRateId,
    erd.BudgetExchangeRateDetailId
FROM
	#LatestBudgetGroups lbg
    INNER JOIN Gdm.BudgetExchangeRate er ON  
		er.BudgetExchangeRateId = lbg.ExchangeRateId
    INNER JOIN #ExchangeRateActive era ON  
		era.ImportKey = er.ImportKey
    INNER JOIN Gdm.BudgetExchangeRateDetail erd ON  
		er.BudgetExchangeRateId = erd.BudgetExchangeRateId
    INNER JOIN #ExchangeRateDetailActive erda ON  
		erda.ImportKey = erd.ImportKey
WHERE  
	erd.Period BETWEEN lbg.StartPeriod AND lbg.EndPeriod
	
--Calculate the cross rates
DECLARE @CrossCurrency TABLE 
(
	SourceCurrencyCode CHAR(3),
    DestinationCurrencyCode CHAR(3),
    Period INT,
    Rate DECIMAL(18, 12),
    SourceReferenceCode VARCHAR(127),
    DestinationReferenceCode VARCHAR(127)
)
        
INSERT INTO @CrossCurrency
SELECT 
	s.CurrencyCode AS SourceCurrencyCode, 
	d.CurrencyCode AS DestinationCurrencyCode,
	es.Period, 
	(ed.Rate / es.Rate) AS Rate,
	'BudgetReportGroupId=' + CAST(es.BudgetReportGroupId AS VARCHAR(50)) +
    '&BudgetExchangeRateId=' + CAST(es.BudgetExchangeRateId AS VARCHAR(50)) +
    '&BudgetExchangeRateDetailId=' + CAST(es.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    SourceReferenceCode,
    'BudgetReportGroupId=' + CAST(ed.BudgetReportGroupId AS VARCHAR(50)) +
    '&BudgetExchangeRateId=' + CAST(ed.BudgetExchangeRateId AS VARCHAR(50)) +
    '&BudgetExchangeRateDetailId=' + CAST(ed.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    DestinationReferenceCode
FROM
	GrReporting.dbo.Currency s
    CROSS JOIN GrReporting.dbo.Currency d
    INNER JOIN #ExchangeRates es ON es.CurrencyCode = s.CurrencyCode
    INNER JOIN #ExchangeRates ed ON ed.CurrencyCode = d.CurrencyCode
WHERE  
	s.CurrencyCode <> 'UNK' AND 
	d.CurrencyCode <> 'UNK' AND
	es.Period = ed.Period
	
--Build the fact
DECLARE @USDCurrencyKey INT
SELECT 
	@USDCurrencyKey = CurrencyKey
FROM
	GrReporting.dbo.Currency cur
WHERE  
	cur.CurrencyCode = 'USD'
	
IF (@USDCurrencyKey IS NULL)
BEGIN
	SET @USDCurrencyKey = -1
END

CREATE TABLE #FactData 
(
	SourceCurrencyKey INT,
    DestinationCurrencyKey INT,
    CalendarKey INT,
    Rate DECIMAL(18, 12),
    ReferenceCode VARCHAR(255)
)

INSERT INTO #FactData
SELECT 
	 ISNULL(curs.CurrencyKey, -1) AS SourceCurrencyKey,
	 ISNULL(curd.CurrencyKey, -1) AS DestinationCurrencyKey,
	 c.CalendarKey,
	 CASE 
         WHEN cc.Rate IS NULL THEN 0
         ELSE cc.Rate
    END AS Rate,
    ('SRC:' + cc.SourceReferenceCode + ' DST:' + cc.DestinationReferenceCode) AS ReferenceCode
FROM 
	@CrossCurrency cc 
	INNER JOIN GrReporting.dbo.Calendar c ON  
		cc.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency curs ON  
		curs.CurrencyCode = cc.SourceCurrencyCode
	LEFT JOIN GrReporting.dbo.Currency curd ON
		curd.CurrencyCode = cc.DestinationCurrencyCode
		
INSERT INTO #FactData		
SELECT 
	@USDCurrencyKey AS SourceCurrencyKey,
    ISNULL(cur.CurrencyKey, -1) AS DestinationCurrencyKey,
    c.CalendarKey,
    er.Rate,
    'BudgetReportGroupId=' + CAST(er.BudgetReportGroupId AS VARCHAR(50)) +
    '&BudgetExchangeRateId=' + CAST(er.BudgetExchangeRateId AS VARCHAR(50)) +
    '&BudgetExchangeRateDetailId=' + CAST(er.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    ReferenceCode
FROM
	#ExchangeRates er
    INNER JOIN GrReporting.dbo.Calendar c ON  
		er.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency cur ON  
		cur.CurrencyCode = er.CurrencyCode
	LEFT JOIN #FactData fd ON 
		fd.SourceCurrencyKey=@USDCurrencyKey AND
		fd.DestinationCurrencyKey=ISNULL(cur.CurrencyKey, -1) AND
		fd.CalendarKey = c.CalendarKey
WHERE fd.Rate IS NULL

INSERT INTO #FactData
SELECT 
	ISNULL(cur.CurrencyKey, -1) AS SourceCurrencyKey,
    @USDCurrencyKey AS DestinationCurrencyKey,
    c.CalendarKey,
    CASE 
         WHEN er.Rate IS NULL THEN 0
         ELSE (1 / er.Rate)
    END AS Rate,
    'BudgetReportGroupId=' + CAST(er.BudgetReportGroupId AS VARCHAR(50)) +
    '&BudgetExchangeRateId=' + CAST(er.BudgetExchangeRateId AS VARCHAR(50)) +
    '&BudgetExchangeRateDetailId=' + CAST(er.BudgetExchangeRateDetailId AS VARCHAR(50)) AS 
    ReferenceCode
FROM
	#ExchangeRates er
    INNER JOIN GrReporting.dbo.Calendar c ON  
		er.Period = c.CalendarPeriod
    LEFT JOIN GrReporting.dbo.Currency cur ON  
		cur.CurrencyCode = er.CurrencyCode
	LEFT JOIN #FactData fd ON 
		fd.SourceCurrencyKey=ISNULL(cur.CurrencyKey, -1) AND
		fd.DestinationCurrencyKey=@USDCurrencyKey AND
		fd.CalendarKey = c.CalendarKey
WHERE fd.Rate IS NULL

IF ((SELECT COUNT(*) FROM #FactData WHERE SourceCurrencyKey = @USDCurrencyKey AND DestinationCurrencyKey = @USDCurrencyKey)<=0)
BEGIN
	INSERT INTO #FactData
	SELECT DISTINCT
		@USDCurrencyKey AS SourceCurrencyKey,
		@USDCurrencyKey AS DestinationCurrencyKey,
		c.CalendarKey,
		1 AS Rate,
		'Default' AS ReferenceCode
	FROM
		#ExchangeRates er
		INNER JOIN GrReporting.dbo.Calendar c ON  
			er.Period = c.CalendarPeriod
		LEFT JOIN #FactData fd ON 
			fd.SourceCurrencyKey=@USDCurrencyKey AND
			fd.DestinationCurrencyKey=@USDCurrencyKey AND
			fd.CalendarKey = c.CalendarKey
	WHERE fd.Rate IS NULL
END

--Update the star schema
MERGE GrReporting.dbo.ExchangeRate AS d
USING #FactData AS s ON  
	d.SourceCurrencyKey = s.SourceCurrencyKey AND 
	d.DestinationCurrencyKey = s.DestinationCurrencyKey AND 
	d.CalendarKey = s.CalendarKey
WHEN MATCHED
THEN
	UPDATE
	SET 
		d.Rate = s.Rate,
		d.ReferenceCode = s.ReferenceCode
WHEN NOT MATCHED
THEN
	INSERT 
	VALUES
	  (
		s.SourceCurrencyKey,
		s.DestinationCurrencyKey,
		s.CalendarKey,
		s.Rate,
		s.ReferenceCode
	  );

DROP TABLE #FilteredBudgetGroups
DROP TABLE #LatestBudgetGroups
DROP TABLE #ExchangeRates
DROP TABLE #FactData

DROP TABLE #BudgetReportGroupActive 
DROP TABLE #BudgetReportGroupDetailActive 
DROP TABLE #BudgetReportGroupPeriodActive
DROP TABLE #BudgetActive
DROP TABLE #ExchangeRateActive
DROP TABLE #ExchangeRateDetailActive
DROP TABLE #BudgetStatusActive
  
print 'Rows inserted/updated: '+CONVERT(char(10),@@rowcount)

GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]    Script Date: 10/01/2010 06:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyCorporateOriginalBudget'
PRINT '####'
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateOriginalBudget]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

DECLARE 
      @GlAccountKey				Int = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @OverheadKey				Int = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN'),
	  @CanImportCorporateBudget	Int = (Select ConfiguredValue From [GrReportingStaging].[dbo].[SSISConfigurations] Where ConfigurationFilter = 'CanImportCorporateBudget')


IF (@CanImportCorporateBudget = 0)
	BEGIN
	print 'Import CorporateBudget not scheduled in SSISConfigurations'
	RETURN
	END


DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
	
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT 'Start'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT	
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode = 'Q0' -- Original budget values only

PRINT 'Rows Inserted into #Budget::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GLGlobalAccount gla
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT 'Rows Inserted into #GlAccount::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Rows Inserted into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*, Code as ActivityTypeCode
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT 'Rows Inserted into #ActvityType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT 'Rows Inserted into #GlobalRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mappings (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT
	pfm.*
INTO
	#PropertyFundMapping
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey
		
PRINT 'Rows Inserted into #PropertyFundMapping'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType 
(ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATT.ImportKey, 
	GATT.GLGlobalAccountTranslationTypeId, 
	GATT.GLGlobalAccountId, 
	GATT.GLTranslationTypeId, 
	GATT.GLAccountTypeId,
	
	CASE WHEN GA.ACtivityTypeId = 99 THEN 
											--GC :: CC1 >>
											--Unallocated overhead expenses will be grouped under the “Overhead” expense 
											--type and not “Non-Payroll”. This will be based on the activity of the 
											--transaction; all transactions that have a corporate overhead activity 
											--will have an expense type of “Overhead”.
											
											(
											Select GST.GLAccountSubTypeId 
											From Gdm.GLAccountSubType GST 
												INNER JOIN Gdm.GLTranslationType GTT ON GTT.GLTranslationTypeId = GST.GLTranslationTypeId
											Where GTT.Code = 'GL'
											AND GST.Code = 'GRPOHD'	
											) 
										ELSE GATT.GLAccountSubTypeId END,
										
	GATT.IsActive, 
	GATT.InsertedDate, 
	GATT.UpdatedDate, 
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

	LEFT OUTER JOIN 
					(Select GA.*
					From	Gdm.GLGlobalAccount GA
							INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GAA ON
								GAA.ImportKey = GA.ImportKey
					) GA ON GA.GLGlobalAccountId = GATT.GLGlobalAccountId
					
-- #GLGlobalAccountTranslationSubType

INSERT INTO
	#GLGlobalAccountTranslationSubType (ImportKey, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId,
	PostingPropertyGLAccountCode, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATST.ImportKey, GATST.GLGlobalAccountTranslationSubTypeId, GATST.GLGlobalAccountId, GATST.GLTranslationSubTypeId, GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode, GATST.IsActive, GATST.InsertedDate, GATST.UpdatedDate, GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO
	#GLTranslationType (ImportKey, GLTranslationTypeId, Code, [Name], [Description], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	TT.ImportKey, TT.GLTranslationTypeId, TT.Code, TT.[Name], TT.[Description], TT.IsActive, TT.InsertedDate, TT.UpdatedDate, TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO
	#GLTranslationSubType (ImportKey, GLTranslationSubTypeId, GLTranslationTypeId, Code, [Name], IsActive, InsertedDate, UpdatedDate,
	UpdatedByStaffId, IsGRDefault)
SELECT
	TST.ImportKey, TST.GLTranslationSubTypeId, TST.GLTranslationTypeId, TST.Code, TST.[Name], TST.IsActive, TST.InsertedDate, TST.UpdatedDate,
	TST.UpdatedByStaffId, TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO
	#GLMajorCategory (ImportKey, GLMajorCategoryId, GLTranslationSubTypeId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	MajC.ImportKey, MajC.GLMajorCategoryId, MajC.GLTranslationSubTypeId, MajC.[Name], MajC.IsActive, MajC.InsertedDate, MajC.UpdatedDate, MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO
	#GLMinorCategory (ImportKey, GLMinorCategoryId, GLMajorCategoryId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	Minc.ImportKey, Minc.GLMinorCategoryId, Minc.GLMajorCategoryId, Minc.[Name], Minc.IsActive, Minc.InsertedDate, Minc.UpdatedDate, Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GLGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL,
	IsUnallocatedOverhead bit NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	GlGlobalAccountCode,
	GLGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	IsUnallocatedOverhead
)

SELECT 
	b.BudgetId,
	'BC:' + b.SourceUniqueKey + '&ImportKey=' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as BudgetAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.Code,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as AllocationSubRegionGlobalRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense,
	b.IsUnallocatedOverhead
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		--GC Change Control 1
		gla.Code = CASE WHEN b.IsUnallocatedOverhead = 1 AND LEN(b.GlobalGlAccountCode) >= 10 THEN LEFT(b.GlobalGlAccountCode,10)+'99' ELSE b.GlobalGlAccountCode END
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		fd.GlobalCode = b.FunctionalDepartmentGlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		at.ActivityTypeId = gla.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		pfm.PropertyFundCode = b.NonPayrollCorporateMRIDepartmentCode AND -- Combination of entity and corporate department
		pfm.SourceCode = b.SourceCode AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) OR
			(
			 (GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
			 (GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId = pfm.PropertyFundId

	LEFT OUTER JOIN #GlobalRegion gr ON
		gr.Code = b.OriginatingSubRegionCode

WHERE
	b.LocalAmount <> 0

PRINT 'Rows Inserted into #ProfitabilitySource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE NONCLUSTERED INDEX IX_LocalAmount ON [#Budget] ([LocalAmount])
INCLUDE ([ImportKey],[SourceUniqueKey],[BudgetId],[SourceCode],[LockedDate],[Period],[InternationalCurrencyCode],[GlobalGlAccountCode],[FunctionalDepartmentGlobalCode],[OriginatingSubRegionCode],[NonPayrollCorporateMRIDepartmentCode],[AllocationSubRegionProjectRegionId],[IsReimbursable],[JobCode])

PRINT 'Created Index on GlAccountKey #ProfitabilitySource'
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT 'Rows Inserted into #AllocationSubRegion'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(ps.ExpensePeriod,4)+'-'+RIGHT(ps.ExpensePeriod,2)+'-01') as CalendarKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKey ELSE GrOh.OverheadKey END OverheadKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.BudgetAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId 
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN (
				Select 
					*
				From GrReporting.dbo.FunctionalDepartment
				Where SubFunctionalDepartmentCode <> FunctionalDepartmentCode
				) GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		--GrFdmD.ReferenceCode LIKE '%:'+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN (
			Select 
				* 
			From 
			GrReporting.dbo.FunctionalDepartment
			Where SubFunctionalDepartmentCode = FunctionalDepartmentCode
			) GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +':%' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = ps.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = ps.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		Asr.AllocationSubRegionGlobalRegionId = ps.AllocationSubRegionGlobalRegionId --AND 
		--Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = Asr.AllocationSubRegionGlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		GrOrFee.GlobalRegionId = Asr.AllocationSubRegionGlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ps.OriginatingGlobalRegionId AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		GrCu.CurrencyCode  = ps.LocalCurrencyCode

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN ps.IsUnallocatedOverhead = 1 THEN 'UNALLOC' ELSE 'UNKNOWN' END

PRINT 'Rows Inserted into #ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityBudget (GlAccountKey)
PRINT 'Created Index on GlAccountKey #ProfitabilityBudget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'GL' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

/* This is not used by the business yet: Gcloete
-------------------------------------------------------------------------------------------------------------------
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU CORP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU PROP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU FUND' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US PROP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US CORP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US FUND' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		

--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityBudget
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityBudget Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'DEV' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityBudget

PRINT 'Rows Inserted into #DeletingBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)

	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM GrReporting.dbo.ProfitabilityBudget 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT 'Rows Deleted from #DeletingBudget:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print 'Cleaned up rows in ProfitabilityBudget'


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityBudget


PRINT 'Rows Inserted into ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityBudget
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory



GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]    Script Date: 10/01/2010 06:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyCorporateReforecast'
PRINT '####'
--*/

/*
[stp_IU_LoadGrProfitabiltyCorporateReforecast]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

DECLARE 
      @GlAccountKey				Int = (Select GlAccountKey From GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
      @SourceKey				Int = (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN'),
      @FunctionalDepartmentKey	Int = (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN'),
      @ReimbursableKey			Int = (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN'),
      @ActivityTypeKey			Int = (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN'),
      @PropertyFundKey			Int = (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundName = 'UNKNOWN'),
      @AllocationRegionKey		Int = (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN'),
      @OriginatingRegionKey		Int = (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN'),
      @OverheadKey				Int = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
      @LocalCurrencyKey			Int = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNKNOWN'),
	  @CanImportCorporateBudget	Int = (Select ConfiguredValue From [GrReportingStaging].[dbo].[SSISConfigurations] Where ConfigurationFilter = 'CanImportCorporateBudget')


IF (@CanImportCorporateBudget = 0)
	BEGIN
	print 'Import CorporateBudget not scheduled in SSISConfigurations'
	RETURN
	END

DECLARE
		@EUFundGlAccountCategoryKeyUnknown				Int,
		@EUCorporateGlAccountCategoryKeyUnknown			Int,
		@EUPropertyGlAccountCategoryKeyUnknown			Int,
		@USFundGlAccountCategoryKeyUnknown				Int,
		@USPropertyGlAccountCategoryKeyUnknown			Int,
		@USCorporateGlAccountCategoryKeyUnknown			Int,
		@DevelopmentGlAccountCategoryKeyUnknown			Int,
		@GlobalGlAccountCategoryKeyUnknown				Int
		
SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

DECLARE @SourceSystemId int
SET @SourceSystemId = 1 -- Corporate budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

PRINT 'Start'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget line item.
SELECT
	CAST(Budget.BudgetYear AS VARCHAR(4)) + CASE Budget.BudgetPeriodCode 
												WHEN 'Q1' THEN CASE WHEN Budget.BudgetYear = 2010 THEN '03' /*March isn Q1 start in 2010 - Ask Mike Caracciolo why*/ ELSE '04' END --Q1 - April (04)
												WHEN 'Q2' THEN '06' --Q2 - June (06)
												WHEN 'Q3' THEN '10' --Q3 - Oct (10)
												ELSE '01' -- Default to Q0 Jan (01)
											END as FirstProjectedPeriod,
	Budget.*
INTO
	#Budget
FROM
	BudgetingCorp.GlobalReportingCorporateBudget Budget
	INNER JOIN BudgetingCorp.GlobalReportingCorporateBudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
WHERE
	Budget.LockedDate IS NOT NULL AND
	Budget.LockedDate BETWEEN @ImportStartDate AND @ImportEndDate AND
	Budget.BudgetPeriodCode <> 'Q0' -- Reforecast budget values only

PRINT 'Rows Inserted into #Budget::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

-- Source Gl Account
SELECT
	gla.*
INTO
	#GlAccount
FROM
	Gdm.GlGlobalAccount gla
	INNER JOIN Gdm.GlGlobalAccountActive(@DataPriorToDate) glaA ON
		gla.ImportKey = glaA.ImportKey 

PRINT 'Rows Inserted into #GlAccount::'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department
SELECT 
	fd.* 
INTO
	#FunctionalDepartment
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Rows Inserted into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Activity Type
SELECT
	at.*, Code as ActivityTypeCode
INTO
	#ActivityType
FROM
	Gdm.ActivityType at
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) atA ON
		at.ImportKey = atA.ImportKey

PRINT 'Rows Inserted into #ActvityType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source originating region
SELECT
	gr.*
INTO
	#GlobalRegion
FROM
	Gdm.GlobalRegion gr
	INNER JOIN Gdm.GlobalRegionActive(@DataPriorToDate) grA ON
		gr.ImportKey = grA.ImportKey 

PRINT 'Rows Inserted into #GlobalRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping (untill the switch over to GBS all budgets sourced from the grinder will use old mappings)
SELECT 
	PropertyFundMapping.* 
INTO
	#PropertyFundMapping
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Rows Inserted into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)

-- Source Property Fund
SELECT 
	PropertyFund.* 
INTO
	#PropertyFund
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO
	#GLGlobalAccountTranslationType (ImportKey, GLGlobalAccountTranslationTypeId, GLGlobalAccountId, GLTranslationTypeId, GLAccountTypeId,
	GLAccountSubTypeId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATT.ImportKey, 
	GATT.GLGlobalAccountTranslationTypeId, 
	GATT.GLGlobalAccountId, 
	GATT.GLTranslationTypeId, 
	GATT.GLAccountTypeId,
	
	CASE WHEN GA.ACtivityTypeId = 99 THEN 
											--GC :: CC1 >>
											--Unallocated overhead expenses will be grouped under the “Overhead” expense 
											--type and not “Non-Payroll”. This will be based on the activity of the 
											--transaction; all transactions that have a corporate overhead activity 
											--will have an expense type of “Overhead”.
											
											(
											Select GST.GLAccountSubTypeId 
											From Gdm.GLAccountSubType GST 
												INNER JOIN Gdm.GLTranslationType GTT ON GTT.GLTranslationTypeId = GST.GLTranslationTypeId
											Where GTT.Code = 'GL'
											AND GST.Code = 'GRPOHD'	
											) 
										ELSE GATT.GLAccountSubTypeId END,
										
	GATT.IsActive, 
	GATT.InsertedDate, 
	GATT.UpdatedDate, 
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

	LEFT OUTER JOIN 
					(Select GA.*
					From	Gdm.GLGlobalAccount GA
							INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GAA ON
								GAA.ImportKey = GA.ImportKey
					) GA ON GA.GLGlobalAccountId = GATT.GLGlobalAccountId

-- #GLGlobalAccountTranslationSubType

INSERT INTO
	#GLGlobalAccountTranslationSubType (ImportKey, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId,
	PostingPropertyGLAccountCode, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	GATST.ImportKey, GATST.GLGlobalAccountTranslationSubTypeId, GATST.GLGlobalAccountId, GATST.GLTranslationSubTypeId, GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode, GATST.IsActive, GATST.InsertedDate, GATST.UpdatedDate, GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO
	#GLTranslationType (ImportKey, GLTranslationTypeId, Code, [Name], [Description], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	TT.ImportKey, TT.GLTranslationTypeId, TT.Code, TT.[Name], TT.[Description], TT.IsActive, TT.InsertedDate, TT.UpdatedDate, TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO
	#GLTranslationSubType (ImportKey, GLTranslationSubTypeId, GLTranslationTypeId, Code, [Name], IsActive, InsertedDate, UpdatedDate,
	UpdatedByStaffId, IsGRDefault)
SELECT
	TST.ImportKey, TST.GLTranslationSubTypeId, TST.GLTranslationTypeId, TST.Code, TST.[Name], TST.IsActive, TST.InsertedDate, TST.UpdatedDate,
	TST.UpdatedByStaffId, TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO
	#GLMajorCategory (ImportKey, GLMajorCategoryId, GLTranslationSubTypeId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	MajC.ImportKey, MajC.GLMajorCategoryId, MajC.GLTranslationSubTypeId, MajC.[Name], MajC.IsActive, MajC.InsertedDate, MajC.UpdatedDate, MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO
	#GLMinorCategory (ImportKey, GLMinorCategoryId, GLMajorCategoryId, [Name], IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
SELECT
	Minc.ImportKey, Minc.GLMinorCategoryId, Minc.GLMajorCategoryId, Minc.[Name], Minc.IsActive, Minc.InsertedDate, Minc.UpdatedDate, Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Map reforecast budget Amounts
CREATE TABLE #ProfitabilitySource
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	ReforecastAmount money NOT NULL,
	GlGlobalAccountCode varchar(21) NOT NULL,
	GlGlobalAccountId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	FunctionalDepartmentId int NULL,
	JobCode varchar(20) NULL,
	Reimbursable bit NULL,
	ActivityTypeCode varchar(10) NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NULL,
	AllocationSubRegionGlobalRegionId int NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingGlobalRegionId int NULL,
	LocalCurrencyCode char(3) NOT NULL,
	LockedDate datetime NOT NULL,
	IsExpense bit NOT NULL,
	IsUnallocatedOverhead bit NOT NULL
)
-- Insert reforecast budget amounts
INSERT INTO #ProfitabilitySource
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	ReforecastAmount,
	GlGlobalAccountCode,
	GlGlobalAccountId,
	FunctionalDepartmentCode,
	FunctionalDepartmentId,
	JobCode,
	Reimbursable,
	ActivityTypeCode,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingGlobalRegionId,
	LocalCurrencyCode,
	LockedDate,
	IsExpense,
	IsUnallocatedOverhead
)

SELECT 
	b.BudgetId,
	'BC:' + b.SourceUniqueKey + '&ImportKey=' + CONVERT(varchar, b.ImportKey) as ReferenceCode,
	b.FirstProjectedPeriod,
	b.Period as ExpensePeriod,
	b.SourceCode,
	b.LocalAmount as ReforecastAmount,
	CONVERT(varchar,b.GlobalGlAccountCode) as GlGlobalAccountCode,
	IsNull(gla.GLGlobalAccountId,-1) as GlGlobalAccountId,
	b.FunctionalDepartmentGlobalCode as FunctionalDepartmentCode,
	IsNull(fd.FunctionalDepartmentId,-1),
	b.JobCode,
	b.IsReimbursable as Reimbursable,
	at.ActivityTypeCode,
	IsNull(at.ActivityTypeId,-1),
	pfm.PropertyFundId,
	IsNull(DepartmentPropertyFund.AllocationSubRegionGlobalRegionId,-1) as ProjectRegionId,
	b.OriginatingSubRegionCode as OriginatingRegionCode,
	IsNull(gr.GlobalRegionId,-1) as OriginatingGlobalRegionId,
	b.InternationalCurrencyCode as LocalCurrencyCode,
	b.LockedDate,
	b.IsExpense,
	b.IsUnallocatedOverhead
FROM
	#Budget b 
	
	LEFT OUTER JOIN #GlAccount gla ON
		--GC Change Control 1
		gla.Code = CASE WHEN b.IsUnallocatedOverhead = 1 AND LEN(b.GlobalGlAccountCode) >= 8 THEN LEFT(b.GlobalGlAccountCode,8)+'99' ELSE b.GlobalGlAccountCode END
		
	LEFT OUTER JOIN #FunctionalDepartment fd ON
		fd.GlobalCode = b.FunctionalDepartmentGlobalCode
		
	LEFT OUTER JOIN #ActivityType at ON
		at.ActivityTypeId = gla.ActivityTypeId
		
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON 
		GrSc.SourceCode = b.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		pfm.PropertyFundCode = b.NonPayrollCorporateMRIDepartmentCode AND -- Combination of entity and corporate department
		pfm.SourceCode = b.SourceCode AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = at.ActivityTypeId) OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND at.ActivityTypeId IS NULL)
			)
		) AND
		pfm.IsDeleted = 0
		
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		pfm.PropertyFundId = DepartmentPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN #GlobalRegion gr ON
		gr.Code = b.OriginatingSubRegionCode

WHERE
	b.LocalAmount <> 0 --AND
	--(b.Period >= b.FirstProjectedPeriod OR b.FirstProjectedPeriod = '201003') -- Get only reforecasted budgeted amounts 
	--(UPDATED: Hack the planet: Now also source actuals for non payroll (including fees) for reforecast Q1, 201003 from the grinder (Yes Q1 201003 - Ask MikeC))


PRINT 'Rows Inserted into #ProfitabilitySource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- See hack below. 
SELECT
	asr.*
INTO
	#AllocationSubRegion
FROM
	Gdm.AllocationSubRegion asr
	INNER JOIN Gdm.AllocationSubRegionActive(@DataPriorToDate) asrA ON
		asr.ImportKey = asrA.ImportKey
		
PRINT 'Rows Inserted into #AllocationSubRegion'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey int NOT NULL,
	ReforecastKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalReforecast money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,

	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
		DATEDIFF(dd, '1900-01-01', LEFT(ps.ExpensePeriod,4)+'-'+RIGHT(ps.ExpensePeriod,2)+'-01') as CalendarKey
		,DATEDIFF(dd, '1900-01-01', LEFT(ps.FirstProjectedPeriod,4)+'-'+RIGHT(ps.FirstProjectedPeriod,2)+'-01') as ReforecastKey
		,CASE WHEN GrGl.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGl.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) IS NULL THEN @FunctionalDepartmentKey ELSE ISNULL(GrFdmD.[FunctionalDepartmentKey], GrFdmP.[FunctionalDepartmentKey]) END FunctionalDepartmentKey
		,CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN IsNull(ps.IsExpense,-1) = 0 THEN 
			CASE WHEN GrOrFee.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOrFee.[OriginatingRegionKey] END 
		 ELSE 
			CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END 
		 END OriginatingRegionKey
		,CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKey ELSE GrOh.OverheadKey END OverheadKey
		,CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey
		,ps.ReforecastAmount
		,ps.ReferenceCode
		,ps.BudgetId
		,@SourceSystemId
FROM
	#ProfitabilitySource ps
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGl ON
		ps.GlGlobalAccountId = GrGl.GlGlobalAccountId AND
		ps.LockedDate BETWEEN GrGl.StartDate AND GrGl.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		ps.SourceCode = GrSc.SourceCode

	--Detail/Sub Level (job level)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmD ON
		ps.LockedDate  BETWEEN GrFdmD.StartDate AND GrFdmD.EndDate AND
		GrFdmD.SubFunctionalDepartmentCode <> GrFdmD.FunctionalDepartmentCode AND
		--GrFdmD.ReferenceCode LIKE '%:'+ ps.JobCode --new substitude below
		GrFdmD.SubFunctionalDepartmentCode = ps.JobCode
			
	--Parent Level
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdmP ON
		ps.LockedDate  BETWEEN GrFdmP.StartDate AND GrFdmP.EndDate AND
		GrFdmP.SubFunctionalDepartmentCode = GrFdmP.FunctionalDepartmentCode AND
		--GrFdmP.ReferenceCode LIKE ps.FunctionalDepartmentCode +':%' --new substitude below
		GrFdmP.FunctionalDepartmentCode = ps.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN ps.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		ps.ActivityTypeId = GrAt.ActivityTypeId AND
		ps.LockedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		ps.PropertyFundId = GrPf.PropertyFundId AND
		ps.LockedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion Asr ON
		ps.AllocationSubRegionGlobalRegionId = Asr.AllocationSubRegionGlobalRegionId --AND
		--Asr.IsActive = 1

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		Asr.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		ps.LockedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

	-- This is only used for fees. It sets the originating region to the allocation region
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOrFee ON
		Asr.AllocationSubRegionGlobalRegionId = GrOrFee.GlobalRegionId AND
		ps.LockedDate BETWEEN GrOrFee.StartDate AND GrOrFee.EndDate


	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ps.OriginatingRegionCode = GrOr.SubRegionCode AND
		ps.LockedDate BETWEEN GrOr.StartDate AND GrOr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		ps.LocalCurrencyCode = GrCu.CurrencyCode 

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN ps.IsUnallocatedOverhead = 1 THEN 'UNALLOC' ELSE 'UNKNOWN' END
		

PRINT 'Rows Inserted into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_GlAcocuntKey ON #ProfitabilityReforecast (GlAccountKey)
PRINT 'Created Index on GlAccountKey #ProfitabilityReforecast'
PRINT CONVERT(Varchar(27), getdate(), 121)

-------------------------------------------------------------------------------------------------------------------
		
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'GL' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU CORP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU PROP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU FUND' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US PROP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US CORP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US FUND' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityReforecast
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityReforecast Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'DEV' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified reforecast budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId int NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#ProfitabilityReforecast

PRINT 'Rows Inserted into #DeletingReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Remove 
DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard
WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)


	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM GrReporting.dbo.ProfitabilityReforecast 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
	
	PRINT 'Rows Deleted from #DeletingBudget:'+CONVERT(char(10),@@rowcount)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
END

print 'Cleaned up rows in ProfitabilityReforecast'


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new fact data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey

FROM 
	#ProfitabilityReforecast


PRINT 'Rows Inserted into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Source data
DROP TABLE #Budget
DROP TABLE #GlAccount
DROP TABLE #FunctionalDepartment
DROP TABLE #ActivityType
DROP TABLE #GlobalRegion
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #AllocationSubRegion
-- Mapping mapping
DROP TABLE #ProfitabilitySource
DROP TABLE #DeletingBudget
DROP TABLE #ProfitabilityReforecast
-- Account Category Mapping
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory



GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]    Script Date: 10/01/2010 06:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyGeneralLedger]
	@ImportStartDate DATETIME,
	@ImportEndDate	 DATETIME,
	@DataPriorToDate DATETIME
AS

DECLARE 
		@GlAccountKeyUnknown INT,
		@GlAccountCategoryKey INT,
		@FunctionalDepartmentKeyUnknown INT,
		@ReimbursableKeyUnknown INT,
		@ActivityTypeKeyUnknown INT,
		@SourceKeyUnknown INT,
		@OriginatingRegionKeyUnknown INT,
		@AllocationRegionKeyUnknown INT,
		@PropertyFundKeyUnknown INT,
		@OverheadKeyUnknown INT,
		-- @CurrencyKey	INT,
		@EUFundGlAccountCategoryKeyUnknown	INT,
		@EUCorporateGlAccountCategoryKeyUnknown INT,
		@EUPropertyGlAccountCategoryKeyUnknown	INT,
		@USFundGlAccountCategoryKeyUnknown INT,
		@USPropertyGlAccountCategoryKeyUnknown	INT,
		@USCorporateGlAccountCategoryKeyUnknown INT,
		@DevelopmentGlAccountCategoryKeyUnknown INT,
		@GlobalGlAccountCategoryKeyUnknown INT
      
--Default FK for the Fact table
/*
[stp_IU_LoadGrProfitabiltyGeneralLedgerVer2]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/       
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN') -- GDM: changed GlAccountCode to Code
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey			 = (Select CurrencyKey From GrReporting.dbo.Currency Where CurrencyCode = 'UNK')
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

IF (@DataPriorToDate IS NULL)
	SET @DataPriorToDate = GETDATE()

IF 	(@DataPriorToDate < '2010-01-01')
	SET @DataPriorToDate = '2010-01-01'
	
SET NOCOUNT ON
PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyGeneralLedger'
PRINT CONVERT(VARCHAR(27), getdate(), 121)
PRINT '####'

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Master Temp table for the combined ledger results from MRI Sources
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityGeneralLedger(
	SourcePrimaryKey VARCHAR(100) NULL,
	SourceTableId INT NOT NULL,
	SourceCode VARCHAR(2) NOT NULL,
	Period CHAR(6) NOT NULL,
	OriginatingRegionCode CHAR(6) NOT NULL,
	PropertyFundCode CHAR(12) NOT NULL,
	FunctionalDepartmentCode CHAR(15) NULL,
	JobCode CHAR(15) NULL,
	GlAccountCode CHAR(12) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual MONEY NOT NULL,
	EnterDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	Basis CHAR(1) NOT NULL,
	LastDate DATETIME NULL,
	GlAccountSuffix VARCHAR(2) NULL,
	NetTSCost CHAR(1) NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger (
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	'USD' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM 
	USProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					USProp.ENTITY En
					INNER JOIN USProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					USProp.GACC Ga
					INNER JOIN USProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'US')
	)	
	

PRINT 'US PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--US CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,

	'USD' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM USCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					USCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					USCorp.ENTITY En
					INNER JOIN USCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					USCorp.GACC Ga
					INNER JOIN USCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
				
	INNER JOIN (
				SELECT
					Gd.*
				FROM
					USCorp.GDEP Gd
					INNER JOIN USCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B'--AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'


PRINT 'US CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = 'PLZ' THEN 'PLN' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount,0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.Description, '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM EUProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					EUProp.ENTITY En
					INNER JOIN EUProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode

	INNER JOIN (
				SELECT
					Ga.*
				FROM
					EUProp.GACC Ga
					INNER JOIN EUProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'EU')
	)	

PRINT 'EU PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EU CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode, 
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription, 
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	CASE WHEN ISNULL(Gl.OcurrCode, En.CurrCode) = 'PLZ' THEN 'PLN' ELSE ISNULL(Gl.OcurrCode, En.CurrCode) END ForeignCurrency,
	ISNULL(Gl.Amount, 0) ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
	
FROM EUCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					EUCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					EUCorp.ENTITY En
					INNER JOIN EUCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
				
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					EUCorp.GACC Ga
					INNER JOIN EUCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					EUCorp.GDEP Gd
					INNER JOIN EUCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode

WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Ga.IsGR, 0) = 'Y' AND
	Gl.BALFOR <> 'B' --AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'

PRINT 'EU CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.Description, '')),
	RTRIM(CONVERT(NVARCHAR(4000), ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	BRProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					BRProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					BRProp.ENTITY En
					INNER JOIN BRProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					BRProp.GACC Ga
					INNER JOIN BRProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source]	= 'GR' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'BR')
	)		

PRINT 'BR PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--BR CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	'BRL' ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '')),
	RTRIM(IsNull(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM BRCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
						SourcePrimaryKey,
						MAX(SourceTableId) SourceTableId
				FROM
						BRCorp.GeneralLedger Gl
				GROUP BY
						SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					BRCorp.ENTITY En
					INNER JOIN BRCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					BRCorp.GACC Ga
					INNER JOIN BRCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					BRCorp.GDEP Gd
					INNER JOIN BRCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source] = 'GR' --AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'


PRINT 'BR CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	ISNULL(Em.LocalEntityRef, Gl.PropertyFundCode) PropertyFundCode, --Generic convert 7char to 6char EntityID
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(IsNull(Gl.[User], '')),
	RTRIM(IsNull(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),IsNull(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNProp.GeneralLedger Gl
				GROUP BY 
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND
		t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					CNProp.ENTITY En
					INNER JOIN CNProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Em.*
				FROM
					GACS.EntityMapping Em
					INNER JOIN GACS.EntityMappingActive(@DataPriorToDate) EmA ON
						EmA.ImportKey = Em.ImportKey
				) Em ON
		Em.OriginalEntityRef = Gl.PropertyFundCode AND
		Em.[Source] = Gl.SourceCode
			
	LEFT OUTER JOIN (
				SELECT
					Ga.*
				FROM
					CNProp.GACC Ga
					INNER JOIN CNProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'CN')
	)	
PRINT 'CH PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CH CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST, 'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	CNCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					CNCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					CNCorp.ENTITY En
					INNER JOIN CNCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					CNCorp.GACC Ga
					INNER JOIN CNCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode

	INNER JOIN (
				SELECT
					Gd.*
				FROM
					CNCorp.GDEP Gd
					INNER JOIN CNCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
															
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Ga.IsGR,0) = 'Y' AND
	Gl.BALFOR <> 'B' --AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'

PRINT 'CH CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN PROP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	'N',
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INProp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					INProp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					INProp.ENTITY En
					INNER JOIN INProp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.PropertyFundCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					INProp.GACC Ga
					INNER JOIN INProp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
					
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Gl.CorporateDepartmentCode, 'N') = 'N' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source] = 'GR' AND
	RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99' AND
	( -- Change Control 6
		ISNULL(Ga.IsGR, 'N') = 'Y'
			OR
		Ga.ACCTNUM IN ( SELECT
							PEAI.GLAccountCode
						FROM
							(
								SELECT
									PEAI.*
								FROM							
									Gdm.PropertyEntityGLAccountInclusion PEAI
									INNER JOIN Gdm.PropertyEntityGLAccountInclusionActive(@DataPriorToDate) PEAIA ON
										PEAIA.ImportKey = PEAI.ImportKey
							) PEAI
						WHERE
							PEAI.PropertyEntityCode = Gl.PropertyFundCode AND
							PEAI.IsDeleted = 0 AND
							PEAI.SourceCode = 'IN')
	)	
PRINT 'IN PROP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--IN CORP
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
INSERT INTO #ProfitabilityGeneralLedger(
	SourcePrimaryKey,
	SourceTableId,
	SourceCode,
	Period,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode,
	JobCode,
	GlAccountCode,
	LocalCurrency,
	LocalActual,
	EnterDate,
	[User],
	[Description],
	AdditionalDescription,
	Basis,
	LastDate,
	GlAccountSuffix,
	NetTSCost,
	UpdatedDate
)
SELECT 
	Gl.SourcePrimaryKey,
	Gl.SourceTableId,
	Gl.SourceCode,
	Gl.Period,
	Gl.RegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode,
	Gl.JobCode,
	Gl.GlAccountCode,
	
	Gl.OcurrCode ForeignCurrency,
	Gl.Amount ForeignActual,

	Gl.EnterDate,
	RTRIM(ISNULL(Gl.[User], '')),
	RTRIM(ISNULL(Gl.[Description], '')),
	RTRIM(CONVERT(NVARCHAR(4000),ISNULL(Gl.AdditionalDescription, ''))),
	Gl.Basis,
	Gl.LastDate,
	Gl.GlAccountSuffix,
	ISNULL(Gd.NETTSCOST,'N') NetTSCost,
	ISNULL(Gl.LastDate, Gl.EnterDate)
		
FROM
	INCorp.GeneralLedger Gl
	INNER JOIN (
				--This allows JOURNAL&GHIS to each have a record with the same PK,
				--but that is incorrect data and as such GR will pick GHIS as the 
				--more accurate data, for it is posted data, where journal data is still open data
				SELECT 
					SourcePrimaryKey,
					MAX(SourceTableId) SourceTableId
				FROM
					INCorp.GeneralLedger Gl
				GROUP BY
					SourcePrimaryKey
				) t1 ON
		t1.SourcePrimaryKey = Gl.SourcePrimaryKey AND t1.SourceTableId = Gl.SourceTableId

	INNER JOIN (
				SELECT
					En.*
				FROM
					INCorp.ENTITY En
					INNER JOIN INCorp.EntityActive(@DataPriorToDate) EnA ON
						EnA.ImportKey = En.ImportKey
				) En ON
		En.EntityId = Gl.RegionCode
			
	INNER JOIN (
				SELECT
					Ga.*
				FROM
					INCorp.GACC Ga
					INNER JOIN INCorp.GAccActive(@DataPriorToDate) GaA ON
						GaA.ImportKey = Ga.ImportKey
				) Ga ON
		Ga.ACCTNUM = Gl.GlAccountCode
				
	INNER JOIN (
				SELECT
					Gd.*
				FROM
					INCorp.GDEP Gd
					INNER JOIN INCorp.GDepActive(@DataPriorToDate) GdA ON
						GdA.ImportKey = Gd.ImportKey
				) Gd ON
		Gd.DEPARTMENT = Gl.PropertyFundCode
										
WHERE
	ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate AND
	Gl.Basis IN ('A','B') AND
	En.Name	NOT LIKE '%Intercompany%' AND
	ISNULL(Ga.IsGR, 0) = 'Y' AND
	Gl.BALFOR <> 'B' AND
	Gl.[Source] = 'GR' --AND
	--Change Control 1 : GC 2010-09-01
	--RIGHT(LTRIM(RTRIM(Gl.GlAccountCode)), 2) <> '99'

PRINT 'IN CORP:Rows Inserted Into #ProfitabilityGeneralLedger:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityGeneralLedger (UpdatedDate, FunctionalDepartmentCode, JobCode, GlAccountCode, SourceCode, Period, OriginatingRegionCode, PropertyFundCode, SourcePrimaryKey)

PRINT 'Completed building clustered index on #ProfitabilityGeneralLedger'
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them INTo the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Prepare the # tables used for performance optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	Code VARCHAR(31) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

CREATE TABLE #Department(
	ImportKey INT NOT NULL,
	Department CHAR(8) NOT NULL,
	[Description] VARCHAR(50) NULL,
	LastDate DATETIME NULL,
	MRIUserID CHAR(20) NULL,
	[Source] CHAR(2) NOT NULL,
	IsActive BIT NOT NULL,
	FunctionalDepartmentId INT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #JobCode(
	ImportKey INT NOT NULL,
	JobCode VARCHAR(15) NOT NULL,
	[Source] CHAR(2) NOT NULL,
	JobType VARCHAR(15) NOT NULL,
	BuildingRef VARCHAR(6) NULL,
	LastDate DATETIME NOT NULL,
	IsActive BIT NOT NULL,
	Reference VARCHAR(50) NOT NULL,
	MRIUserID CHAR(20) NOT NULL,
	[Description] VARCHAR(50) NULL,
	StartDate DATETIME NULL,
	EndDate DATETIME NULL,
	AccountingComment VARCHAR(5000) NULL,
	PMComment VARCHAR(5000) NULL,
	LeaseRef VARCHAR(20) NULL,
	Area INT NULL,
	AreaType VARCHAR(20) NULL,
	RMPropertyRef VARCHAR(6) NULL,
	IsAssumption BIT NOT NULL,
	FunctionalDepartmentId INT NULL
) 

CREATE TABLE #ActivityType(
	ImportKey INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	GLAccountSuffix char(2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #GLGlobalAccount(
	ImportKey INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountGLAccount( -- used to be #GlAccountMapping in GDM 1.2
	ImportKey INT NOT NULL,
	GLGlobalAccountGLAccountId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(12) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[Description] NVARCHAR(255) NOT NULL,
	PreGlobalAccountCode VARCHAR(50) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

CREATE TABLE #PropertyFund( -- GDM 2.0 change
	ImportKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)


CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #JobCodeFunctionalDepartment(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

CREATE TABLE #ParentFunctionalDepartment(
	FunctionalDepartmentKey INT NOT NULL,
	ReferenceCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME NOT NULL
)

-- #FunctionalDepartment

INSERT INTO #FunctionalDepartment(
	ImportKey,
	FunctionalDepartmentId,
	[Name],
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT
	Fd.ImportKey,
	Fd.FunctionalDepartmentId,
	Fd.Name,
	Fd.Code,
	Fd.IsActive,
	Fd.InsertedDate,
	Fd.UpdatedDate,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		FdA.ImportKey = Fd.ImportKey

-- #Department

INSERT INTO #Department(
	ImportKey,
	Department,
	[Description],
	LastDate,
	MRIUserID,
	[Source],
	IsActive,
	FunctionalDepartmentId,
	UpdatedDate
)
SELECT
	Dpt.ImportKey,
	Dpt.Department,
	Dpt.[Description],
	Dpt.LastDate,
	Dpt.MRIUserID,
	Dpt.[Source],
	Dpt.IsActive,
	Dpt.FunctionalDepartmentId,
	Dpt.UpdatedDate
FROM GACS.Department Dpt
	INNER JOIN GACS.DepartmentActive(@DataPriorToDate) DptA ON
		DptA.ImportKey = Dpt.ImportKey
WHERE
	Dpt.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #Department (Department, [Source])

-- #JobCode

INSERT INTO #JobCode(
	ImportKey,
	JobCode,
	[Source],
	JobType,
	BuildingRef,
	LastDate,
	IsActive,
	Reference,
	MRIUserID,
	[Description],
	StartDate,
	EndDate,
	AccountingComment,
	PMComment,
	LeaseRef,
	Area,
	AreaType,
	RMPropertyRef,
	IsAssumption,
	FunctionalDepartmentId
)
SELECT
	Jc.ImportKey,
	Jc.JobCode,
	Jc.[Source],
	Jc.JobType,
	Jc.BuildingRef,
	Jc.LastDate,
	Jc.IsActive,
	Jc.Reference,
	Jc.MRIUserID,
	Jc.[Description],
	Jc.StartDate,
	Jc.EndDate,
	Jc.AccountingComment,
	Jc.PMComment,
	Jc.LeaseRef,
	Jc.Area,
	Jc.AreaType,
	Jc.RMPropertyRef,
	Jc.IsAssumption,
	Jc.FunctionalDepartmentId
FROM
	GACS.JobCode Jc
	INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON
		JcA.ImportKey = Jc.ImportKey
WHERE
	Jc.FunctionalDepartmentId IS NOT NULL

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #JobCode (JobCode, [Source])

-- #ActivityType

INSERT INTO #ActivityType(
	ImportKey,
	ActivityTypeId,
	ActivityTypeCode,
	[Name],
	GLAccountSuffix,
	InsertedDate,
	UpdatedDate
)
SELECT
	At.ImportKey,
	At.ActivityTypeId,
	At.Code,
	At.Name,
	At.GLAccountSuffix,
	At.InsertedDate,
	At.UpdatedDate
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

-- #GLGlobalAccount

INSERT INTO #GLGlobalAccount(
	ImportKey,
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GLA.ImportKey,
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.GLStatutoryTypeId,
	GLA.Code,
	GLA.[Name], 
	GLA.[Description],
	GLA.IsGR,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.IsActive,
	GLA.InsertedDate,
	GLA.UpdatedDate,
	GLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLAA.ImportKey = GLA.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

-- #GLGlobalAccountGLAccount

INSERT INTO #GLGlobalAccountGLAccount(
	ImportKey,
	GLGlobalAccountGLAccountId,
	GLGlobalAccountId,
	SourceCode,
	Code,
	[Name],
	[Description],
	PreGlobalAccountCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GAGLA.ImportKey,
	GAGLA.GLGlobalAccountGLAccountId,
	GAGLA.GLGlobalAccountId,
	GAGLA.SourceCode,
	GAGLA.Code,
	GAGLA.[Name],
	GAGLA.[Description],
	GAGLA.PreGlobalAccountCode,
	GAGLA.IsActive,
	GAGLA.InsertedDate,
	GAGLA.UpdatedDate,
	GAGLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountGLAccount GAGLA
	INNER JOIN Gdm.GLGlobalAccountGLAccountActive(@DataPriorToDate) GlA ON
		GlA.ImportKey = GAGLA.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccountGLAccount (Code, SourceCode, GLGlobalAccountGLAccountId)

-- #PropertyFundMapping

INSERT INTO #PropertyFundMapping(
	ImportKey,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId)
SELECT
	Pfm.ImportKey,
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

-- #PropertyFund

INSERT INTO #PropertyFund(
	ImportKey,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	[Name],
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	PF.ImportKey,
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.[Name],
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.IsActive,
	PF.InsertedDate,
	PF.UpdatedDate,
	PF.UpdatedByStaffId
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PFA.ImportKey = PF.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (PropertyFundId)

-- #ReportingEntityCorporateDepartment

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

-- #ReportingEntityPropertyEntity

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

-- #JobCodeFunctionalDepartment
INSERT INTO #JobCodeFunctionalDepartment(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE
	FunctionalDepartmentCode <> SubFunctionalDepartmentCode

-- Parent Level
INSERT INTO #ParentFunctionalDepartment(
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
)
SELECT
	FunctionalDepartmentKey,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	StartDate,
	EndDate
FROM
	GrReporting.dbo.FunctionalDepartment
WHERE (
		FunctionalDepartmentCode = SubFunctionalDepartmentCode
		OR 
		ReferenceCode = FunctionalDepartmentCode+':UNKNOWN'
	  )

-----------------------------------------------------------------------------------------------------------

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType(
	ImportKey,
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
SELECT
	GATT.ImportKey,
	GATT.GLGlobalAccountTranslationTypeId,
	GATT.GLGlobalAccountId,
	GATT.GLTranslationTypeId,
	GATT.GLAccountTypeId,
	CASE WHEN GA.ACtivityTypeId = 99 THEN 
											--GC :: CC1 >>
											--Unallocated overhead expenses will be grouped under the “Overhead” expense 
											--type and not “Non-Payroll”. This will be based on the activity of the 
											--transaction; all transactions that have a corporate overhead activity 
											--will have an expense type of “Overhead”.
											
											(
											Select GST.GLAccountSubTypeId 
											From Gdm.GLAccountSubType GST 
												INNER JOIN Gdm.GLTranslationType GTT ON GTT.GLTranslationTypeId = GST.GLTranslationTypeId
											Where GTT.Code = 'GL'
											AND GST.Code = 'GRPOHD'	
											) 
										ELSE GATT.GLAccountSubTypeId END,
	GATT.IsActive,
	GATT.InsertedDate,
	GATT.UpdatedDate,
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey
		
	LEFT OUTER JOIN 
					(Select GA.*
					From	Gdm.GLGlobalAccount GA
							INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GAA ON
								GAA.ImportKey = GA.ImportKey
					) GA ON GA.GLGlobalAccountId = GATT.GLGlobalAccountId

-- #GLGlobalAccountTranslationSubType

INSERT INTO #GLGlobalAccountTranslationSubType(
	ImportKey,
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
SELECT
	GATST.ImportKey,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode,
	GATST.IsActive,
	GATST.InsertedDate,
	GATST.UpdatedDate,
	GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.[Name],
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- drop table #ProfitabilityActual

PRINT 'Completed inserting Active records INTo temp table'
PRINT CONVERT(VARCHAR(27), getdate(), 121)
-- drop table #ProfitabilityActual

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	ProfitabilityActualSourceTableId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL,
	
	EntryDate DATETIME NULL,
	[User] NVARCHAR(20) NULL,
	[Description] NCHAR(60) NULL,
	AdditionalDescription NVARCHAR(4000) NULL,
	OriginatingRegionCode char(6) NULL,
	PropertyFundCode char(12) NULL,
	FunctionalDepartmentCode char(15) NULL 
) 



INSERT INTO #ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	EntryDate,
	[User],
	[Description],
	AdditionalDescription,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode 
)

SELECT 

	DATEDIFF(dd, '1900-01-01', LEFT(Gl.PERIOD, 4)+'-'+RIGHT(Gl.PERIOD, 2)+'-01') CalendarKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKeyUnknown ELSE GrSc.SourceKey END SourceKey,
	CASE WHEN ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE ISNULL(GrFdm1.FunctionalDepartmentKey, GrFdm2.FunctionalDepartmentKey) END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.ActivityTypeKey END ActivityTypeKey,
	CASE WHEN OrR.OriginatingRegionKey IS NULL THEN @OriginatingRegionKeyUnknown ELSE OrR.OriginatingRegionKey END OriginatingRegionKey,
	CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END AllocationRegionKey,
	CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.PropertyFundKey END PropertyFundKey,
	CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE GrOh.OverheadKey END OverheadKey,
	Gl.SourcePrimaryKey,
	Cu.CurrencyKey,
	Gl.LocalActual,
	Gl.SourceTableId,
	Gl.EnterDate,
	Gl.[User],
	Gl.[Description],
	Gl.AdditionalDescription,
	
	Gl.OriginatingRegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode

FROM
	#ProfitabilityGeneralLedger Gl
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Cu.CurrencyCode = Gl.LocalCurrency

	LEFT OUTER JOIN #JobCode Jc ON --The JobCodes is FunctionalDepartment in Corp
		Jc.JobCode = Gl.JobCode AND
		Jc.Source = Gl.SourceCode AND
		GrSc.IsCorporate = 'YES'
	
	LEFT OUTER JOIN #Department Dp ON --The Department (Region+FunctionalDept) is FunctionalDepartment in Prop
		Dp.Department = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		Dp.Source = Gl.SourceCode AND
		GrSc.IsProperty = 'YES'

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Fd.FunctionalDepartmentId = ISNULL(Jc.FunctionalDepartmentId, Dp.FunctionalDepartmentId)

	LEFT OUTER JOIN #JobCodeFunctionalDepartment GrFdm1 ON --Detail/Sub Level : JobCode
		ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm1.StartDate AND GrFdm1.EndDate AND
		GrFdm1.ReferenceCode = CASE WHEN Gl.JobCode IS NOT NULL THEN Fd.GlobalCode + ':'+ LTRIM(RTRIM(Gl.JobCode))
									ELSE Fd.GlobalCode + ':UNKNOWN' END

	--Parent Level: Determine the default FunctionalDepartment (FunctionalDepartment:XX, JobCode:UNKNOWN)
	--that will be used, should the JobCode not match, but the FunctionalDepartment does match
	LEFT OUTER JOIN #ParentFunctionalDepartment GrFdm2 ON
		ISNULL(Gl.LastDate, EnterDate)  BETWEEN GrFdm2.StartDate AND GrFdm2.EndDate AND
		GrFdm2.ReferenceCode = Fd.GlobalCode +':' 
		
	LEFT OUTER JOIN #GLGlobalAccountGLAccount GAGLA ON --#GlAccountMapping Gam
		GAGLA.Code = Gl.GlAccountCode AND
		GAGLA.SourceCode = Gl.SourceCode AND
		GAGLA.IsActive = 1
		
	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.GLGlobalAccountId = GAGLA.GLGlobalAccountId AND --Gam.GlobalGlAccountId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrGa.StartDate AND GrGa.EndDate

	LEFT OUTER JOIN #GLGlobalAccount GA ON --#GlobalGlAccount Glo
		GA.GLGlobalAccountId = GAGLA.GLGlobalAccountId
		--ON Glo.GlobalGlAccountId = Gam.GlobalGlAccountId

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = GA.ActivityTypeId

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAt.StartDate AND GrAt.EndDate

	--GC Change Control 1
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = CASE WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' ELSE 'UNKNOWN' END
		
	LEFT OUTER JOIN #PropertyFundMapping Pfm ON
		Pfm.PropertyFundCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		Pfm.SourceCode = Gl.SourceCode AND
		Pfm.IsDeleted = 0 AND
		(
			(GrSc.IsProperty = 'YES' AND Pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND Pfm.ActivityTypeId = GA.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND Pfm.ActivityTypeId IS NULL AND GA.ActivityTypeId IS NULL)
			)
		) AND
		(Gl.Period < '201007')

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		RECD.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201007' AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(Gl.PropertyFundCode)) AND
		REPE.SourceCode = Gl.SourceCode AND
		Gl.Period >= '201007' AND
		REPE.IsDeleted = 0			   
	
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.SourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(Gl.OriginatingRegionCode)) + LTRIM(RTRIM(Gl.FunctionalDepartmentCode)) AND
		ORPD.SourceCode = Gl.SourceCode AND
		ORPD.IsDeleted = 0

	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion OrR ON
		OrR.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		--OrR.GlobalRegionId = ORPD.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN OrR.StartDate AND OrR.EndDate
	
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId =
			CASE
				WHEN Gl.Period < '201007' THEN Pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
			
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = PF.PropertyFundId AND 
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrPf.StartDate AND GrPf.EndDate

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId
		
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		--ON GrAr.GlobalRegionId = Arm.GlobalRegionId AND
		ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE WHEN Gl.NetTSCost = 'Y' THEN 'NO' ELSE 'YES' END

			
--This is NOT needed for the temp table selects at the top already filter the inserts!
--/*Where ISNULL(Gl.LastDate, GL.EnterDate) BETWEEN @ImportStartDate AND @ImportEndDate*/

PRINT 'Completed converting all transactional data to star schema keys'
PRINT CONVERT(VARCHAR(27), getdate(), 121)

-----------------------------------------------------------------------------------------------------------
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		GATT.GLGlobalAccountId = Gla.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		GATST.GLGlobalAccountId = Gla.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		TST.GLTranslationTypeId = GATT.GLTranslationTypeId AND
		TST.GLTranslationSubTypeId = GATST.GLTranslationSubTypeId AND
		TST.Code = 'GL' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		MinC.GLMinorCategoryId = GATST.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'EU CORP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
		
			
PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'EU PROP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'EU FUND' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))
	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'US PROP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'US CORP' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'US FUND' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		


--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	INNER JOIN GrReporting.dbo.GlAccount Gla ON
		Gla.GlAccountKey = Gl.GlAccountKey

	LEFT OUTER JOIN #GLGlobalAccountTranslationType GATT ON
		Gla.GLGlobalAccountId = GATT.GLGlobalAccountId AND
		GATT.IsActive = 1
	
	LEFT OUTER JOIN #GLGlobalAccountTranslationSubType GATST ON
		Gla.GLGlobalAccountId = GATST.GLGlobalAccountId AND
		GATST.IsActive = 1
		
	LEFT OUTER JOIN #GLTranslationSubType TST ON
		GATT.GLTranslationTypeId = TST.GLTranslationTypeId AND
		GATST.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND
		TST.Code = 'DEV' AND -- filter on Code because it is indexed and guaranteed to be unique
		TST.IsActive = 1

	LEFT OUTER JOIN #GLMinorCategory MinC ON
		GATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
		MinC.IsActive = 1
		
	LEFT OUTER JOIN #GLMajorCategory MajC ON
		MajC.GLMajorCategoryId = MinC.GLMajorCategoryId AND
		MajC.GLTranslationSubTypeId = TST.GLTranslationSubTypeId AND -- this join isn't necessary but including it for completeness
		MajC.IsActive = 1
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), TST.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), TST.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), MinC.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATST.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GATT.GLAccountSubTypeId))

PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--Transfer the updated rows
UPDATE
	GrReporting.dbo.ProfitabilityActual
SET	
	CalendarKey						 = Pro.CalendarKey,
	GlAccountKey					 = Pro.GlAccountKey,
	FunctionalDepartmentKey			 = Pro.FunctionalDepartmentKey,
	ReimbursableKey					 = Pro.ReimbursableKey,
	ActivityTypeKey					 = Pro.ActivityTypeKey,
	OriginatingRegionKey			 = Pro.OriginatingRegionKey,
	AllocationRegionKey				 = Pro.AllocationRegionKey,
	PropertyFundKey					 = Pro.PropertyFundKey,
	OverheadKey						 = Pro.OverheadKey,
	LocalCurrencyKey				 = Pro.LocalCurrencyKey,
	LocalActual						 = Pro.LocalActual,
	ProfitabilityActualSourceTableId = Pro.ProfitabilityActualSourceTableId,
	
	EUCorporateGlAccountCategoryKey	 = @EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey	 = @EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey		 = @EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey	 = @USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey	 = @USCorporateGlAccountCategoryKeyUnknown, --Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey		 = @USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey		 = Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey	 = @DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey

	
	EntryDate						 = Pro.EntryDate,
	[User]							 = Pro.[User],
	[Description]					 = Pro.[Description],
	AdditionalDescription			 = Pro.AdditionalDescription,
	
	OriginatingRegionCode			 = Pro.OriginatingRegionCode,
	PropertyFundCode				 = Pro.PropertyFundCode,
	FunctionalDepartmentCode		 = Pro.FunctionalDepartmentCode
	
FROM
	#ProfitabilityActual Pro
WHERE
	ProfitabilityActual.SourceKey = Pro.SourceKey AND
	ProfitabilityActual.ReferenceCode = Pro.ReferenceCode

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
	
--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual (
	CalendarKey,
	GlAccountKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	EntryDate,
	[User],
	[Description],
	AdditionalDescription,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode
)
	
SELECT
	Pro.CalendarKey,
	Pro.GlAccountKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.PropertyFundKey,
	Pro.ReferenceCode,
	Pro.LocalCurrencyKey,
	Pro.LocalActual,
	Pro.ProfitabilityActualSourceTableId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----Pro.USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	Pro.GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	Pro.EntryDate,
	Pro.[User],
	Pro.[Description],
	Pro.AdditionalDescription,
	Pro.OriginatingRegionCode, 
	Pro.PropertyFundCode, 
	Pro.FunctionalDepartmentCode
											
FROM
	#ProfitabilityActual Pro
	
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists
		ON ProExists.SourceKey = Pro.SourceKey AND
		   ProExists.ReferenceCode = Pro.ReferenceCode
		   
WHERE
	ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--MRI should never delete rows from the GeneralLedger....
--hence we should never have to delete records
--PRINT 'Orphan Rows Delete in Profitability:'+CONVERT(char(10),@@rowcount)
--PRINT CONVERT(VARCHAR(27), getdate(), 121)

DROP TABLE #ProfitabilityGeneralLedger
DROP TABLE #FunctionalDepartment
DROP TABLE #Department
DROP TABLE #JobCode
DROP TABLE #ActivityType
DROP TABLE #GLGlobalAccount
DROP TABLE #GLGlobalAccountGLAccount
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #PropertyFundMapping
DROP TABLE #PropertyFund
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #AllocationSubRegion
DROP TABLE #JobCodeFunctionalDepartment
DROP TABLE #ParentFunctionalDepartment
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #ProfitabilityActual



GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyOverhead]    Script Date: 10/01/2010 06:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyOverhead]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()


DECLARE 
	@GlAccountKeyUnknown INT,
	--@OverheadGlAccountKeyUnknown INT,
	@FunctionalDepartmentKeyUnknown INT,
	@ReimbursableKeyUnknown INT,
	@ActivityTypeKeyUnknown INT,
	@SourceKeyUnknown INT,
	@OriginatingRegionKeyUnknown INT,
	@AllocationRegionKeyUnknown INT,
	@PropertyFundKeyUnknown INT,
	@OverheadKeyUnknown INT,
		--@CurrencyKey INT,
	@EUFundGlAccountCategoryKeyUnknown INT,
	@EUCorporateGlAccountCategoryKeyUnknown INT,
	@EUPropertyGlAccountCategoryKeyUnknown	INT,
	@USFundGlAccountCategoryKeyUnknown	INT,
	@USPropertyGlAccountCategoryKeyUnknown	INT,
	@USCorporateGlAccountCategoryKeyUnknown INT,
	@DevelopmentGlAccountCategoryKeyUnknown INT,
	@GlobalGlAccountCategoryKeyUnknown INT

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyOverhead'
PRINT '####'
SET NOCOUNT ON
  
--Default FK for the Fact table
/*
exec [stp_IU_LoadGrProfitabiltyOverhead]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/  
     
SET @GlAccountKeyUnknown			= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN')
--SET @OverheadGlAccountKeyUnknown	= (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = '5002950000  ') -- Only log against header account (This might be changed back so only commented out)
SET @FunctionalDepartmentKeyUnknown	= (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown			= (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown			= (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN')
SET @AllocationRegionKeyUnknown		= (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN')
SET @PropertyFundKeyUnknown			= (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN')
--SET @CurrencyKey					= (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNK')
SET @OverheadKeyUnknown				= (SELECT OverheadKey FROM GrReporting.dbo.Overhead WHERE OverheadName = 'UNKNOWN')

SET @EUFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @EUPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USFundGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USPropertyGlAccountCategoryKeyUnknown  = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @USCorporateGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @DevelopmentGlAccountCategoryKeyUnknown = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')
SET @GlobalGlAccountCategoryKeyUnknown      = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

CREATE TABLE #ActivityTypeGLAccount(
	ActivityTypeId INT,
	GLAccountCode VARCHAR(12)
)

INSERT INTO #ActivityTypeGLAccount (
	ActivityTypeId, 
	GLAccountCode
)
SELECT NULL AS ActivityTypeId, '5002950000' AS GLAccountCode UNION ALL --header (NULL in on hierarchy)
SELECT 1, '5002950001' UNION ALL --Leasing
SELECT 2, '5002950002' UNION ALL --Acquisitions
SELECT 3, '5002950003' UNION ALL --Asset Management
SELECT 4, '5002950004' UNION ALL --Development
SELECT 5, '5002950005' UNION ALL --Property Management Escalatable
SELECT 6, '5002950006' UNION ALL --Property Management Non-Escalatable
SELECT 7, '5002950007' UNION ALL --Syndication (Investment and Fund)
SELECT 8, '5002950008' UNION ALL --Fund Organization
SELECT 9, '5002950009' UNION ALL --Fund Operations
SELECT 10, '5002950010' UNION ALL --Property Management TI
SELECT 11, '5002950011' UNION ALL --Property Management CapEx
SELECT 12, '5002950012' UNION ALL --Corporate
SELECT 99, '5002950099' --Corporate Overhead (No corporate overhead (5002950099) account  use header instead)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Create the temp tables used on the "active" records for optimization
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #AllocationRegion(
	ImportKey INT NOT NULL,
	AllocationRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	DefaultCurrencyCode CHAR(3) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)
CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #BillingUpload(
	ImportKey INT  NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadBatchId INT NULL,
	BillingUploadTypeId INT NOT NULL,
	TimeAllocationId INT NOT NULL,
	CostTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalRegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	PayrollId INT NULL,
	OverheadId INT NULL,
	PayGroupId INT NULL,
	UnionCodeId INT NULL,
	OverheadRegionId INT NULL,
	HREmployeeId INT NOT NULL,
	ProjectId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	PayrollDescription NVARCHAR(100) NULL,
	OverheadDescription NVARCHAR(100) NULL,
	ProjectCode VARCHAR(50) NOT NULL,
	ReversalPeriod INT NULL,
	AllocationPeriod INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	IsReversable BIT NOT NULL,
	IsReversed BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	HasNoInactiveProjects BIT NOT NULL,
	LocationId INT NOT NULL,
	ProjectGroupAllocationAdjustmentId INT NULL,
	AdjustedTimeAllocationDetailId INT NULL,
	PayrollPayDate DATETIME NULL,
	PayrollFromDate DATETIME NULL,
	PayrollToDate DATETIME NULL,
	FunctionalDepartmentId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NULL,
)

CREATE TABLE #BillingUploadDetail(
	ImportKey INT NOT NULL,
	BillingUploadDetailId INT NOT NULL,
	BillingUploadBatchId INT NOT NULL,
	BillingUploadId INT NOT NULL,
	BillingUploadDetailTypeId INT NOT NULL,
	ExpenseTypeId INT NULL,
	GLAccountCode VARCHAR(15) NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateDepartmentIsRechargedToAr BIT NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	AllocationAmount DECIMAL(18, 9) NOT NULL,
	CurrencyCode CHAR(3) NOT NULL,
	IsUnion BIT NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	CorporateDepartmentIsRechargedToAp BIT NOT NULL
)

CREATE TABLE #Overhead(
	ImportKey INT NOT NULL,
	OverheadId INT NOT NULL,
	RegionId INT NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationStartPeriod INT NOT NULL,
	AllocationEndPeriod INT NULL,
	[Description] NVARCHAR(60) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	InsertedByStaffId INT NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	InvoiceNumber VARCHAR(13) NULL
)

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

CREATE TABLE #PropertyFund( -- GDM 2.0 change
	ImportKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	[Name] VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode char(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition - used to be AllocationRegionMapping
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition - used to be OriginatingRegionMapping
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #GLGlobalAccount(
	ImportKey INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	ActivityTypeId INT NULL,
	GLStatutoryTypeId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsGR BIT NOT NULL,
	IsGbs BIT NOT NULL,
	IsRegionalOverheadCost BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #ActivityType(
	ImportKey INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	GLSuffix CHAR(2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLGlobalAccountTranslationSubType(
	ImportKey INT NOT NULL,
	GLGlobalAccountTranslationSubTypeId INT NOT NULL,
	GLGlobalAccountId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	PostingPropertyGLAccountCode VARCHAR(14) NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

--======================================================================================================================================

INSERT INTO #BillingUpload (
	ImportKey,
	BillingUploadId,
	BillingUploadBatchId,
	BillingUploadTypeId,
	TimeAllocationId,
	CostTypeId,
	RegionId,
	ExternalRegionId,
	ExternalSubRegionId,
	PayrollId,
	OverheadId,
	PayGroupId,
	UnionCodeId,
	OverheadRegionId,
	HREmployeeId,
	ProjectId,
	SubDepartmentId,
	ExpensePeriod,
	PayrollDescription,
	OverheadDescription,
	ProjectCode,
	ReversalPeriod,
	AllocationPeriod,
	AllocationValue,
	IsReversable,
	IsReversed,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	HasNoInactiveProjects,
	LocationId,
	ProjectGroupAllocationAdjustmentId,
	AdjustedTimeAllocationDetailId,
	PayrollPayDate,
	PayrollFromDate,
	PayrollToDate,
	FunctionalDepartmentId,
	ActivityTypeId,
	OverheadFunctionalDepartmentId
)
SELECT 
	Bu.ImportKey,
	Bu.BillingUploadId,
	Bu.BillingUploadBatchId,
	Bu.BillingUploadTypeId,
	Bu.TimeAllocationId,
	Bu.CostTypeId,
	Bu.RegionId,
	Bu.ExternalRegionId,
	Bu.ExternalSubRegionId,
	Bu.PayrollId,
	Bu.OverheadId,
	Bu.PayGroupId,
	Bu.UnionCodeId,
	Bu.OverheadRegionId,
	Bu.HREmployeeId,
	Bu.ProjectId,
	Bu.SubDepartmentId,
	Bu.ExpensePeriod,
	Bu.PayrollDescription,
	Bu.OverheadDescription,
	Bu.ProjectCode,
	Bu.ReversalPeriod,
	Bu.AllocationPeriod,
	Bu.AllocationValue,
	Bu.IsReversable,
	Bu.IsReversed,
	Bu.InsertedDate,
	Bu.UpdatedDate,
	Bu.UpdatedByStaffId,
	Bu.HasNoInactiveProjects,
	Bu.LocationId,
	Bu.ProjectGroupAllocationAdjustmentId,
	Bu.AdjustedTimeAllocationDetailId,
	Bu.PayrollPayDate,
	Bu.PayrollFromDate,
	Bu.PayrollToDate,
	Bu.FunctionalDepartmentId,
	Bu.ActivityTypeId,
	Bu.OverheadFunctionalDepartmentId
FROM
	TapasGlobal.BillingUpload	Bu
	INNER JOIN TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA ON
		BuA.ImportKey = Bu.ImportKey

------------

INSERT INTO #BillingUploadDetail (
	ImportKey,
	BillingUploadDetailId,
	BillingUploadBatchId,
	BillingUploadId,
	BillingUploadDetailTypeId,
	ExpenseTypeId,
	GLAccountCode,
	CorporateEntityRef,
	CorporateDepartmentCode,
	CorporateDepartmentIsRechargedToAr,
	CorporateSourceCode,
	AllocationAmount,
	CurrencyCode,
	IsUnion,
	UpdatedByStaffId,
	InsertedDate,
	UpdatedDate,
	CorporateDepartmentIsRechargedToAp
)
SELECT 
	Bud.ImportKey,
	Bud.BillingUploadDetailId,
	Bud.BillingUploadBatchId,
	Bud.BillingUploadId,
	Bud.BillingUploadDetailTypeId,
	Bud.ExpenseTypeId,
	Bud.GLAccountCode,
	Bud.CorporateEntityRef,
	Bud.CorporateDepartmentCode,
	Bud.CorporateDepartmentIsRechargedToAr,
	Bud.CorporateSourceCode,
	Bud.AllocationAmount,
	Bud.CurrencyCode,
	Bud.IsUnion,
	Bud.UpdatedByStaffId,
	Bud.InsertedDate,
	Bud.UpdatedDate,
	Bud.CorporateDepartmentIsRechargedToAp
FROM
	TapasGlobal.BillingUploadDetail Bud
	INNER JOIN TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA ON
		BudA.ImportKey = Bud.ImportKey

----------

INSERT INTO #Overhead (
	ImportKey,
	OverheadId,
	RegionId,
	ExpensePeriod,
	AllocationStartPeriod,
	AllocationEndPeriod,
	[Description],
	InsertedDate,
	InsertedByStaffId,
	UpdatedDate,
	UpdatedByStaffId,
	InvoiceNumber
)
SELECT 
	 Oh.ImportKey,
	 Oh.OverheadId,
	 Oh.RegionId,
	 Oh.ExpensePeriod,
	 Oh.AllocationStartPeriod,
	 Oh.AllocationEndPeriod,
	 Oh.[Description],
	 Oh.InsertedDate,
	 Oh.InsertedByStaffId,
	 Oh.UpdatedDate,
	 Oh.UpdatedByStaffId,
	 Oh.InvoiceNumber
FROM
	TapasGlobal.Overhead Oh 
	INNER JOIN TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
		OhA.ImportKey = Oh.ImportKey

----------

INSERT INTO #FunctionalDepartment (
	ImportKey,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT
	Fd.ImportKey,
	Fd.FunctionalDepartmentId,
	Fd.Name,
	Fd.Code,
	Fd.IsActive,
	Fd.InsertedDate,
	Fd.UpdatedDate,
	Fd.GlobalCode
FROM
	HR.FunctionalDepartment Fd 
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
		FdA.ImportKey = Fd.ImportKey

----------

INSERT INTO #Project (
	ImportKey,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	P2.ImportKey,
	P2.ProjectId,
	P2.RegionId,
	P2.ActivityTypeId,
	P2.ProjectOwnerId,
	P2.CorporateDepartmentCode,
	P2.CorporateSourceCode,
	P2.Code,
	P2.Name,
	P2.StartPeriod,
	P2.EndPeriod,
	P2.InsertedDate,
	P2.UpdatedDate,
	P2.UpdatedByStaffId,
	P2.PropertyOverheadGLAccountCode,
	P2.PropertyOverheadDepartmentCode,
	P2.PropertyOverheadJobCode,
	P2.PropertyOverheadSourceCode,
	P2.CorporateUnionPayrollIncomeCategoryCode,
	P2.CorporateNonUnionPayrollIncomeCategoryCode,
	P2.CorporateOverheadIncomeCategoryCode,
	P2.PropertyFundId,
	P2.MarkUpPercentage,
	P2.HistoricalProjectCode,
	P2.IsTSCost,
	P2.CanAllocateOverheads,
	P2.AllocateOverheadsProjectId
FROM
	TapasGlobal.Project P2
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) P2A ON
		P2A.ImportKey = P2.ImportKey

----------------------------------------------------------------------------------------------

-- #AllocationRegion

INSERT INTO #AllocationRegion(
	ImportKey,
	AllocationRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	DefaultCurrencyCode,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AR.ImportKey,
	AR.AllocationRegionGlobalRegionId,
	AR.Code,
	AR.[Name],
	AR.ProjectCodePortion,
	AR.DefaultCurrencyCode,
	AR.IsActive,
	AR.InsertedDate,
	AR.UpdatedDate,
	AR.UpdatedByStaffId
FROM
	Gdm.AllocationRegion AR
	INNER JOIN Gdm.AllocationRegionActive(@DataPriorToDate) ARA ON
		ARA.ImportKey = AR.ImportKey

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

-- #PropertyFund
	
INSERT INTO #PropertyFund(
	ImportKey,
	PropertyFundId,
	RelatedFundId,
	EntityTypeId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	RegionalOwnerStaffId,
	DefaultGLTranslationSubTypeId,
	[Name],
	IsReportingEntity,
	IsPropertyFund,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	PF.ImportKey,
	PF.PropertyFundId,
	PF.RelatedFundId,
	PF.EntityTypeId,
	PF.AllocationSubRegionGlobalRegionId,
	PF.BudgetOwnerStaffId,
	PF.RegionalOwnerStaffId,
	PF.DefaultGLTranslationSubTypeId,
	PF.[Name],
	PF.IsReportingEntity,
	PF.IsPropertyFund,
	PF.IsActive,
	PF.InsertedDate,
	PF.UpdatedDate,
	PF.UpdatedByStaffId
FROM
	Gdm.PropertyFund PF 
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
		PFA.ImportKey = PF.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFund (PropertyFundId)

-- #PropertyFundMapping

INSERT INTO #PropertyFundMapping(
	ImportKey,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT
	Pfm.ImportKey,
	Pfm.PropertyFundMappingId,
	Pfm.PropertyFundId,
	Pfm.SourceCode,
	Pfm.PropertyFundCode,
	Pfm.InsertedDate,
	Pfm.UpdatedDate,
	Pfm.IsDeleted,
	Pfm.ActivityTypeId
FROM
	Gdm.PropertyFundMapping Pfm 
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
		PfmA.ImportKey = Pfm.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #PropertyFundMapping (PropertyFundCode, SourceCode, IsDeleted, PropertyFundId, PropertyFundMappingId, ActivityTypeId)

-- #ReportingEntityCorporateDepartment

INSERT INTO #ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

-- #ReportingEntityPropertyEntity

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

-- #ActivityType

INSERT INTO #ActivityType(
	ImportKey,
	ActivityTypeId,
	ActivityTypeCode,
	[Name],
	GLSuffix,
	InsertedDate,
	UpdatedDate
)
SELECT
	At.ImportKey,
	At.ActivityTypeId,
	At.Code,
	At.Name,
	At.GLAccountSuffix,
	At.InsertedDate,
	At.UpdatedDate
FROM
	Gdm.ActivityType At
	INNER JOIN Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
		Ata.ImportKey = At.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ActivityType (ActivityTypeId)

-- #GLGlobalAccount

INSERT INTO #GLGlobalAccount(
	ImportKey,
	GLGlobalAccountId,
	ActivityTypeId,
	GLStatutoryTypeId,
	Code,
	[Name],
	[Description],
	IsGR,
	IsGbs,
	IsRegionalOverheadCost,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	GLA.ImportKey,
	GLA.GLGlobalAccountId,
	GLA.ActivityTypeId,
	GLA.GLStatutoryTypeId,
	GLA.Code,
	GLA.[Name], 
	GLA.[Description],
	GLA.IsGR,
	GLA.IsGbs,
	GLA.IsRegionalOverheadCost,
	GLA.IsActive,
	GLA.InsertedDate,
	GLA.UpdatedDate,
	GLA.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccount GLA
	INNER JOIN Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
		GLAA.ImportKey = GLA.ImportKey
	
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #GLGlobalAccount (GLGlobalAccountId, ActivityTypeId)

INSERT INTO #OverheadRegion(
	ImportKey,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Ovr.ImportKey,
	Ovr.OverheadRegionId,
	Ovr.RegionId,
	Ovr.CorporateEntityRef,
	Ovr.CorporateSourceCode,
	Ovr.Name,
	Ovr.InsertedDate,
	Ovr.UpdatedDate,
	Ovr.UpdatedByStaffId
FROM	TapasGlobal.OverheadRegion Ovr 
		INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
			OvrA.ImportKey = Ovr.ImportKey

-- #GLGlobalAccountTranslationType

INSERT INTO #GLGlobalAccountTranslationType(
	ImportKey,
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
SELECT
	GATT.ImportKey,
	GATT.GLGlobalAccountTranslationTypeId,
	GATT.GLGlobalAccountId,
	GATT.GLTranslationTypeId,
	GATT.GLAccountTypeId,
	GATT.GLAccountSubTypeId,
	GATT.IsActive,
	GATT.InsertedDate,
	GATT.UpdatedDate,
	GATT.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationType GATT
	INNER JOIN Gdm.GLGlobalAccountTranslationTypeActive(@DataPriorToDate) GATTA ON
		GATTA.ImportKey = GATT.ImportKey

-- #GLGlobalAccountTranslationSubType

INSERT INTO #GLGlobalAccountTranslationSubType(
	ImportKey,
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
SELECT
	GATST.ImportKey,
	GATST.GLGlobalAccountTranslationSubTypeId,
	GATST.GLGlobalAccountId,
	GATST.GLTranslationSubTypeId,
	GATST.GLMinorCategoryId,
	GATST.PostingPropertyGLAccountCode,
	GATST.IsActive,
	GATST.InsertedDate,
	GATST.UpdatedDate,
	GATST.UpdatedByStaffId
FROM
	Gdm.GLGlobalAccountTranslationSubType GATST
	INNER JOIN Gdm.GLGlobalAccountTranslationSubTypeActive(@DataPriorToDate) GATSTA ON
		GATSTA.ImportKey = GATST.ImportKey

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	GLTranslationTypeId,
	Code,
	[Name],
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.[Name],
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

PRINT 'Completed inserting Active records into temp table'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Now use the temp tables and load the #ProfitabilityOverhead
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityOverhead(
	BillingUploadDetailId INT NOT NULL,
	CorporateDepartmentCode VARCHAR(8)  NULL,
	CorporateSourceCode VARCHAR(2)  NULL,
	CanAllocateOverheads Bit NOT NULL,
	ExpensePeriod INT NOT NULL,
	AllocationRegionCode VARCHAR(6) NULL,
	OriginatingRegionCode VARCHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	PropertyFundCode char(12) NULL,
	PropertyFundId INT NOT NULL,
	FunctionalDepartmentCode CHAR(3) NULL,
	ActivityTypeCode VARCHAR(10) NULL,
	ExpenseType VARCHAR(8) NOT NULL,
	LocalCurrency CHAR(3) NOT NULL,
	LocalActual DECIMAL(18,12) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL
)

INSERT INTO #ProfitabilityOverhead(
	BillingUploadDetailId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	CanAllocateOverheads,
	ExpensePeriod,
	AllocationRegionCode,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	PropertyFundId,
	FunctionalDepartmentCode,
	ActivityTypeCode,
	ExpenseType,
	LocalCurrency,
	LocalActual,
	UpdatedDate,
	InsertedDate,
	PropertyFundCode
)
SELECT 
	Bud.BillingUploadDetailId,
	
	CASE
		WHEN P1.AllocateOverheadsProjectId IS NULL THEN Bud.CorporateDepartmentCode
		ELSE P2.CorporateDepartmentCode
	END AS CorporateDepartmentCode,
	
	Bud.CorporateSourceCode,
	
	CASE
		WHEN P1.AllocateOverheadsProjectId IS NULL THEN P1.CanAllocateOverheads
		ELSE P2.CanAllocateOverheads
	END AS CanAllocateOverheads,
	
	Bu.ExpensePeriod,
	GrAr.RegionCode AllocationRegionCode, --Pr.Code AllocationRegionCode,
	Ovr.CorporateEntityRef OriginatingRegionCode,
	Ovr.CorporateSourceCode OriginatingRegionSourceCode,
	
	CASE
		WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId, --This is seen as the Gdm.Gr.GlobalPropertyFundId
	
	Fd.GlobalCode FunctionalDepartmentCode,
	At.ActivityTypeCode,
	'Overhead' ExpenseType,
	Bud.CurrencyCode ForeignCurrency,
	Bud.AllocationAmount ForeignActual,
	Bud.UpdatedDate,
	Bud.InsertedDate,
	P1.CorporateDepartmentCode as PropertyFundCode
FROM
	#BillingUpload Bu
		
	INNER JOIN #BillingUploadDetail Bud ON
		Bud.BillingUploadId = Bu.BillingUploadId

	INNER JOIN #Overhead Oh ON
		Oh.OverheadId = Bu.OverheadId

	LEFT OUTER JOIN #FunctionalDepartment Fd ON
		Fd.FunctionalDepartmentId = Bu.OverheadFunctionalDepartmentId

	LEFT OUTER JOIN #Project P1 ON
		P1.ProjectId = Bu.ProjectId

	LEFT OUTER JOIN #Project P2 ON
		P2.ProjectId = P1.AllocateOverheadsProjectId

	-- P1 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = P1.CorporateSourceCode

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON -- added
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
		RECDC.SourceCode = P1.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007' AND		   
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON -- added
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
		REPEC.SourceCode = P1.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007' AND
		REPEC.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		pfm.PropertyFundCode = P1.CorporateDepartmentCode AND -- Combination of entity and corporate department
		pfm.SourceCode = P1.CorporateSourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
			)
		) AND Bu.ExpensePeriod < '201007' 
		
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN Bu.ExpensePeriod < '201007' THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = 'YES' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END -- extra condition? re: date

	-- P1 end -----------------------
	-- P2 ---------------------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO
		ON GrScO.SourceCode = P2.CorporateSourceCode

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDO ON -- added
		GrScO.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
		RECDO.SourceCode = P2.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007'  AND			   
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON -- added
		GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
		REPEO.SourceCode = P2.CorporateSourceCode AND
		Bu.ExpensePeriod >= '201007'  AND
		REPEO.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		P2.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		P2.CorporateSourceCode = opfm.SourceCode AND
		opfm.IsDeleted = 0  AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = Bu.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL) 
			)	
		) AND Bu.ExpensePeriod < '201007' 

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN Bu.ExpensePeriod < '201007' THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END	

	-- P2 end -----------------------

	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = (
								CASE
									WHEN (P1.PropertyFundId IS NULL OR P1.PropertyFundId = 0) THEN
										ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
									ELSE
										ISNULL(OverheadPropertyFund.PropertyFundId, -1)
								END
							) --AND
		--PF.IsActive = 1
		
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		-- ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate ???????

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeId = Bu.ActivityTypeId

	LEFT OUTER JOIN #OverheadRegion Ovr ON
		Ovr.OverheadRegionId = Bu.OverheadRegionId

WHERE
	Bu.BillingUploadBatchId IS NOT NULL AND
	Bud.BillingUploadDetailTypeId <> 2 
	--AND ISNULL(Bu.UpdatedDate, Bu.UpdatedDate) BETWEEN @ImportStartDate AND @ImportEndDate --NOTE:: GC I am note sure it can work with the date filter

--IMS 48953 - Exclude overhead mark up from the import

PRINT 'Rows Inserted into #ProfitabilityOverhead:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--------------------------------------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Take the different sources and combine them into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityActual(
	CalendarKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	AllocationRegionKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	ReferenceCode VARCHAR(100) NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalActual MONEY NOT NULL,
	ProfitabilityActualSourceTableId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL,
	
	OriginatingRegionCode char(6) NULL,
	PropertyFundCode char(12) NULL,
	FunctionalDepartmentCode char(15) NULL 
) 

INSERT INTO #ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode
)
SELECT 
	DATEDIFF(dd, '1900-01-01', LEFT(Gl.ExpensePeriod, 4) + '-' + RIGHT(Gl.ExpensePeriod, 2) + '-01') CalendarKey,
	--,ISNULL(@OverheadGlAccountKeyUnknown, @GlAccountKeyUnknown) GlAccountKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.SourceKey IS NULL THEN @SourceKeyUnknown ELSE GrSc.SourceKey END SourceKey,
	CASE WHEN GrFdm.FunctionalDepartmentKey IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.FunctionalDepartmentKey END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.ActivityTypeKey IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.ActivityTypeKey END ActivityTypeKey,
	CASE WHEN GrOr.OriginatingRegionKey IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.OriginatingRegionKey END OriginatingRegionKey,
	CASE WHEN GrAr.AllocationRegionKey IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.AllocationRegionKey END AllocationRegionKey,
	CASE WHEN GrPf.PropertyFundKey IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.PropertyFundKey END PropertyFundKey,
	CASE WHEN GrOh.OverheadKey IS NULL THEN @OverheadKeyUnknown ELSE GrOh.OverheadKey END OverheadKey,
		'BillingUploadDetailId=' + LTRIM(STR(Gl.BillingUploadDetailId, 10, 0)),
	Cu.CurrencyKey,
	Gl.LocalActual,
	3 ProfitabilityActualSourceTableId, --BillingUploadDetail
	Gl.OriginatingRegionCode,
	Gl.PropertyFundCode,
	Gl.FunctionalDepartmentCode
	

FROM
	#ProfitabilityOverhead Gl

	LEFT OUTER JOIN GrReporting.dbo.Currency Cu ON
		Cu.CurrencyCode = Gl.LocalCurrency

	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.FunctionalDepartmentCode = Gl.FunctionalDepartmentCode AND
		GrFdm.SubFunctionalDepartmentCode = Gl.FunctionalDepartmentCode AND
		Gl.UpdatedDate BETWEEN GrFdm.StartDate AND ISNULL(GrFdm.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #ActivityType At ON
		At.ActivityTypeCode = Gl.ActivityTypeCode 
		
	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		GrAt.ActivityTypeId = At.ActivityTypeId AND
		Gl.UpdatedDate BETWEEN GrAt.StartDate AND ISNULL(GrAt.EndDate, Gl.UpdatedDate)
	
	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		GrOh.OverheadCode = 'ALLOC'
		
	LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
		AtGla.ActivityTypeId = At.ActivityTypeId

	LEFT OUTER JOIN #GLGlobalAccount GA ON
		GA.Code = AtGla.GLAccountCode AND
		ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGA ON
		GrGA.GLGlobalAccountId = GA.GLGlobalAccountId AND
		Gl.UpdatedDate BETWEEN GrGA.StartDate AND GrGA.EndDate
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = Gl.CorporateSourceCode
	
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		GrPf.PropertyFundId = Gl.PropertyFundId AND
		Gl.UpdatedDate BETWEEN GrPf.StartDate AND ISNULL(GrPf.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = Gl.OriginatingRegionCode AND
		ORCE.SourceCode = Gl.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
	
	-- Overheads should only be sourced from Corporate, but the mapping for property below has been included	
	--LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
	--	ORPD.PropertyDepartmentCode = Gl.OriginatingRegionCode AND
	--	ORPD.SourceCode = Gl.OriginatingRegionSourceCode AND
	--	ORPD.IsDeleted = 0		  
		   
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ORCE.GlobalRegionId AND
		--GrOr.GlobalRegionId = ORPD.GlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, Gl.UpdatedDate)
	
	LEFT OUTER JOIN #PropertyFund PF ON
		PF.PropertyFundId = Gl.PropertyFundId --AND
		--PF.IsActive = 1

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
		--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId AND
		Gl.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, Gl.UpdatedDate)

	LEFT OUTER JOIN (
						SELECT 'UC' SOURCECODE, DEPARTMENT, NETTSCOST FROM USCorp.GDEP UNION ALL
						SELECT 'EC' SOURCECODE, DEPARTMENT, NETTSCOST FROM EUCorp.GDEP UNION ALL
						SELECT 'IC' SOURCECODE, DEPARTMENT, NETTSCOST FROM INCorp.GDEP UNION ALL
						SELECT 'BC' SOURCECODE, DEPARTMENT, NETTSCOST FROM BRCorp.GDEP UNION ALL
						SELECT 'CC' SOURCECODE, DEPARTMENT, NETTSCOST FROM CNCorp.GDEP
					) RiCo ON
		RiCo.DEPARTMENT = Gl.CorporateDepartmentCode AND
		RiCo.SOURCECODE = Gl.CorporateSourceCode	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		GrRi.ReimbursableCode = CASE
									WHEN Gl.CanAllocateOverheads = 1 THEN 
										CASE
											WHEN ISNULL(RiCo.NETTSCOST, 'N') = 'Y' THEN 'NO' ELSE 'YES'
										END
									ELSE 'NO'
								END

WHERE
	Gl.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate

----Prepare data for later Clean-up of Key's that have changed and 
----as such left the current record to be not required anymore	
--Update GrReporting.dbo.ProfitabilityActual
--SET 	
--Actual						= 0
--Where	SourceKey	IN (Select DISTINCT SourceKey From #ProfitabilityActual)
--AND		CalendarKey	BETWEEN DATEDIFF(dd,'1900-01-01', @ImportStartDate) AND 
--							 DATEDIFF(dd,'1900-01-01', @ImportEndDate)
--Transfer the updated rows
	
-------------------------------------------------------------------------------------------------------------------
--GlobalGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	GlobalGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'GL' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


/*
-- EUCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END 
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU CORP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

		
			
PRINT 'Completed converting all EUCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--EUPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU PROP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all EUPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)


--EUFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	EUFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @EUFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'EU FUND' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all EUFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USPropertyGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USPropertyGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USPropertyGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US PROP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USPropertyGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USCorporateGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USCorporateGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USCorporateGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
From #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US CORP' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all USCorporateGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

--USFundGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	USFundGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @USFundGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM
	#ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'US FUND' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))


PRINT 'Completed converting all USFundGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)

		
--DevelopmentGlAccountCategoryKey
UPDATE
	#ProfitabilityActual
SET
	DevelopmentGlAccountCategoryKey = CASE WHEN GLAC.GlAccountCategoryKey IS NULL THEN @DevelopmentGlAccountCategoryKeyUnknown ELSE GLAC.GlAccountCategoryKey END
FROM #ProfitabilityActual Gl

	LEFT OUTER JOIN 
	(
		SELECT	
			Gla.GlAccountKey,
			TST.GLTranslationTypeId,
			TST.GLTranslationSubTypeId,
			MinC.GLMajorCategoryId,
			GLATST.GLMinorCategoryId,
			GLATT.GLAccountTypeId,
			GLATT.GLAccountSubTypeId
		FROM	
			#GLTranslationSubType TST 

			INNER JOIN #GLGlobalAccountTranslationSubType GLATST ON
				TST.GLTranslationSubTypeId = GLATST.GLTranslationSubTypeId AND
				GLATST.IsActive = 1
			
			INNER JOIN #GLGlobalAccountTranslationType GLATT ON
				GLATST.GLGlobalAccountId = GLATT.GLGlobalAccountId AND
				TST.GLTranslationTypeId = GLATT.GLTranslationTypeId AND
				GLATT.IsActive = 1

			INNER JOIN GrReporting.dbo.GlAccount Gla ON
				GLATT.GLGlobalAccountId = GLA.GLGlobalAccountId

			INNER JOIN #GLMinorCategory MinC ON
				GLATST.GLMinorCategoryId = MinC.GLMinorCategoryId AND
				MinC.IsActive = 1

			INNER JOIN #GLMajorCategory MajC ON
				MinC.GLMajorCategoryId = MajC.GLMajorCategoryId AND
				MajC.IsActive = 1

		WHERE 
				TST.Code = 'DEV' AND 
				TST.IsActive = 1
	) as GLAD ON
		GLAD.GlAccountKey = Gl.GlAccountKey
	
	LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GLAC ON
		Gl.CalendarKey BETWEEN GLAC.StartDate AND GLAC.EndDate AND
		GLAC.GlobalGlAccountCategoryCode = CONVERT(VARCHAR(32),
											CONVERT(VARCHAR(8), GLAD.GLTranslationTypeId) + ':' + 
											CONVERT(VARCHAR(8), GLAD.GLTranslationSubTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMajorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLMinorCategoryId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountTypeId) + ':' +
											CONVERT(VARCHAR(8), GLAD.GLAccountSubTypeId))

	
PRINT 'Completed converting all DevelopmentGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(VARCHAR(27), getdate(), 121)
*/
CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityActual (SourceKey, ReferenceCode)
PRINT 'Completed building clustered index on #ProfitabilityActual'
PRINT CONVERT(Varchar(27), getdate(), 121)

UPDATE
	GrReporting.dbo.ProfitabilityActual
SET 	
	CalendarKey						 = Pro.CalendarKey,
	GlAccountKey					 = Pro.GlAccountKey,
	FunctionalDepartmentKey			 = Pro.FunctionalDepartmentKey,
	ReimbursableKey					 = Pro.ReimbursableKey,
	ActivityTypeKey					 = Pro.ActivityTypeKey,
	OriginatingRegionKey			 = Pro.OriginatingRegionKey,
	AllocationRegionKey				 = Pro.AllocationRegionKey,
	PropertyFundKey					 = Pro.PropertyFundKey,
	OverheadKey						 = Pro.OverheadKey,
	LocalCurrencyKey				 = Pro.LocalCurrencyKey,
	LocalActual						 = Pro.LocalActual,
	ProfitabilityActualSourceTableId = Pro.ProfitabilityActualSourceTableId,
		
	EUCorporateGlAccountCategoryKey	 = @EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey	 = @EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey		 = @EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey	 = @USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey	 = @USCorporateGlAccountCategoryKeyUnknown, --Pro.USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey		 = @USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey		 = Pro.GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey	 = @DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	OriginatingRegionCode			 = Pro.OriginatingRegionCode,
	PropertyFundCode				 = Pro.PropertyFundCode,
	FunctionalDepartmentCode		 = Pro.FunctionalDepartmentCode
	
FROM
	#ProfitabilityActual Pro
WHERE
	ProfitabilityActual.SourceKey = Pro.SourceKey AND
	ProfitabilityActual.ReferenceCode = Pro.ReferenceCode

PRINT 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Transfer the new rows
INSERT INTO GrReporting.dbo.ProfitabilityActual(
	CalendarKey,
	GlAccountKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	SourceKey,
	OriginatingRegionKey,
	AllocationRegionKey,
	PropertyFundKey,
	OverheadKey,
	ReferenceCode,
	LocalCurrencyKey,
	LocalActual,
	ProfitabilityActualSourceTableId,
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,
	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,
	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey,
	
	OriginatingRegionCode,
	PropertyFundCode,
	FunctionalDepartmentCode
)
SELECT
	Pro.CalendarKey,
	Pro.GlAccountKey,
	Pro.FunctionalDepartmentKey,
	Pro.ReimbursableKey,
	Pro.ActivityTypeKey,
	Pro.SourceKey,
	Pro.OriginatingRegionKey,
	Pro.AllocationRegionKey,
	Pro.PropertyFundKey,
	Pro.OverheadKey,
	Pro.ReferenceCode, 
	Pro.LocalCurrencyKey, 
	Pro.LocalActual,
	Pro.ProfitabilityActualSourceTableId, --BillingUploadDetail

	@EUCorporateGlAccountCategoryKeyUnknown, --Pro.EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --Pro.EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --Pro.EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --Pro.USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----Pro.USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --Pro.USFundGlAccountCategoryKey,

	Pro.GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown, --Pro.DevelopmentGlAccountCategoryKey
	
	Pro.OriginatingRegionCode,
	Pro.PropertyFundCode,
	Pro.FunctionalDepartmentCode				
FROM
	#ProfitabilityActual Pro
	LEFT OUTER JOIN GrReporting.dbo.ProfitabilityActual ProExists ON
		ProExists.SourceKey	= Pro.SourceKey AND
		ProExists.ReferenceCode	= Pro.ReferenceCode

WHERE
	ProExists.SourceKey IS NULL

PRINT 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)
--Uploaded BillingUploads should never be deleted ....
--hence we should never have to delete records

DROP TABLE #ActivityTypeGLAccount
DROP TABLE #AllocationRegion
DROP TABLE #AllocationSubRegion
DROP TABLE #BillingUpload
DROP TABLE #BillingUploadDetail
DROP TABLE #Overhead
DROP TABLE #FunctionalDepartment
DROP TABLE #Project
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #GLGlobalAccount
DROP TABLE #ActivityType
DROP TABLE #OverheadRegion
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLGlobalAccountTranslationType
DROP TABLE #GLGlobalAccountTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #ProfitabilityOverhead
DROP TABLE #ProfitabilityActual


GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]    Script Date: 10/01/2010 06:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()


PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollOriginalBudget'
PRINT '####'

DECLARE	 @CanImportTapasBudget		Int = (Select ConfiguredValue From [GrReportingStaging].[dbo].[SSISConfigurations] Where ConfigurationFilter = 'CanImportTapasBudget')


IF (@CanImportTapasBudget = 0)
	BEGIN
	print 'Import TapasBudget not scheduled in SSISConfigurations'
	RETURN
	END



	
/*
[stp_IU_LoadGrProfitabiltyPayrollOriginalBudget]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*
-- Setup Bonus Cap Excess Project Setting

CREATE TABLE #SystemSettingRegion(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)
INSERT INTO #SystemSettingRegion(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM
		TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA ON
			ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM
				TapasGlobal.SystemSetting ss
				INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA ON
					ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON
		ssr.SystemSettingId = ss.SystemSettingId
		
PRINT 'Completed getting system settings'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsGLMajorCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1
	
DECLARE 
	@GlAccountKey			 INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
	@SourceKey				 INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@FunctionalDepartmentKey INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@ReimbursableKey		 INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
	@ActivityTypeKey		 INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@PropertyFundKey		 INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@AllocationRegionKey	 INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@OriginatingRegionKey	 INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@OverheadKey			 INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
    @LocalCurrencyKey		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNKNOWN')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')



-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsGLMajorCategoryId = GLMajorCategoryId
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = 'Salaries/Taxes/Benefits'

print (@SalariesTaxesBenefitsGLMajorCategoryId)

--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Base Salary'

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Benefits'

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Bonus'

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsGLMajorCategoryId AND
	GLMinorCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = 'General Overhead'

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'External General Overhead'

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountSubType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)


-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLTranslationTypeId,
	Code,
	Name,
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.ImportBatchId,
	TT.ImportDate,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey


-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLAccountType

INSERT INTO #GLAccountType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AT.ImportKey,
	AT.ImportBatchId,
	AT.ImportDate,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.GLAccountType AT
	INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
		AT.ImportKey = ATA.ImportKey
	
-- #GLAccountSubType

INSERT INTO #GLAccountSubType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AST.ImportKey,
	AST.ImportBatchId,
	AST.ImportDate,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.GLAccountSubType AST
	INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON
		AST.ImportKey = ASTA.ImportKey


-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MinC.ImportKey,
	MinC.GLMinorCategoryId,
	MinC.GLMajorCategoryId,
	MinC.[Name],
	MinC.IsActive,
	MinC.InsertedDate,
	MinC.UpdatedDate,
	MinC.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for 'Map account categories' section
CREATE TABLE #GLAccountCategoryTranslationsPayroll(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslationsPayroll(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE '%PYR' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed getting GlAccountCategory payroll records'
PRINT CONVERT(Varchar(27), getdate(), 121)



CREATE TABLE #GLAccountCategoryTranslationsOverhead(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslationsOverhead(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE '%OHD' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed getting GlAccountCategory overhead records'
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 

CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey
		
PRINT 'Completed inserting records from BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group. 

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	Name,
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey
		
PRINT 'Completed inserting records from BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM
	Gdm.BudgetReportGroupPeriod brgp
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey
		
PRINT 'Completed inserting records from GRBudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	[Name],
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
		
PRINT 'Completed inserting records from BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget

CREATE TABLE #AllActiveBudget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #AllActiveBudget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
		
PRINT 'Completed inserting records from Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.

CREATE TABLE #AllModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL
)

INSERT INTO #AllModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted
)

SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.BudgetReportGroupPeriodId,
	Budget.IsDeleted AS IsBudgetDeleted,
	Budget.IsReforecast AS IsBugetReforecast,
	Budget.BudgetStatusId, 
	brgd.IsDeleted AS IsDetailDeleted, 
	brg.IsReforecast AS IsGroupReforecast, 
	brg.StartPeriod AS GroupStartPeriod, 
	brg.EndPeriod AS GroupEndPeriod, 
	brg.IsDeleted AS IsGroupDeleted,
	brgp.IsDeleted AS IsPeriodDeleted
FROM
	#AllActiveBudget Budget -- Active TapasGlobalBudgeting.Budget 's

	INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId

	INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = brg.BudgetReportGroupPeriodId

WHERE -- Only pull budgets that were modified
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

PRINT 'Completed inserting records into #AllModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

CREATE TABLE #LockedModifiedReportGroup( -- All budgets in a particular group need to be locked before the group can be pulled
	BudgetReportGroupId INT NOT NULL
)

INSERT INTO #LockedModifiedReportGroup(
	BudgetReportGroupId
)

SELECT
	amrb.BudgetReportGroupId
FROM
	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING
	COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) -- Are all budgets locked within this group? If not, no budgets get imported 

PRINT 'Completed inserting records into #LockedModifiedReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information

CREATE TABLE #FilteredModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)

INSERT INTO #FilteredModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted,
	BudgetReportGroupPeriod 
)
SELECT
	amrb.*,
	brgp.Period BudgetReportGroupPeriod
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = amrb.BudgetReportGroupPeriodId
		
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 0 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 0 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0 AND
	brgp.IsDeleted = 0

PRINT 'Completed inserting records into #FilteredModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget information that meet criteria

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #Budget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	[Name],
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.* 
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId

PRINT 'Completed inserting records into #Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project
-- Get all the budget projects that are associated with the budgets that will be pulled, as per code above
CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	[Name] VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL, --“NonPayrollReimbursable” 
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)

INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	[Name],
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.* 
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	[Name],
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.* 
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	[Name] VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)

INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	[Name],
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)
PRINT 'Completed creating indexes on ##BudgetEmployee'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee Functional Department

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)

SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Functional Department

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT 
	fd.* 
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund

CREATE TABLE #PropertyFund(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PropertyFund(
	ImportKey,
	ImportBatchId,
	ImportDate,
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
SELECT 
	PropertyFund.* 
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Property Fund Mapping

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #PropertyFundMapping(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	PropertyFundMapping.* 
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityCorporateDepartment

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

PRINT 'Completed creating indexes on #ReportingEntityCorporateDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityPropertyEntity

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

PRINT 'Completed creating indexes on #ReportingEntityPropertyEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT 'Completed creating indexes on #Location'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.* 
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT 'Completed creating indexes on #RegionExtended'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.* 
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT 'Completed creating indexes on #PayrollRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	[Name] VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	[Name],
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadRegion.* 
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT 'Completed creating indexes on #OverheadRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	[Name],
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT 'Completed creating indexes on #Project'
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId
		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate
		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetailBatches (BudgetEmployeePayrollAllocationDetailId, ImportBatchId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

----------

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON -- Only get tax details for the pre-tax amounts we are looking at
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type

CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.* 
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- Classifies tax types into minor categories, see CASE statement; gets set here because it can be overwritten later in the stored procedure

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON -- rather pull through as unknown than exclude, therefore LEFT JOIN
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail
CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId, -- Hardcode to a specific minor category, could be changed later in the stored proc
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON -- Only pull allocationDetails for the allocations we are pulling
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 
			
PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- Originating region mapping

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

-- #OriginatingRegionCorporateEntity

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

PRINT 'Completed inserting records into #OriginatingRegionCorporateEntity:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionCorporateEntity (CorporateEntityCode, SourceCode, IsDeleted, GlobalRegionId)
PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- #OriginatingRegionPropertyDepartment

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

PRINT 'Completed inserting records into #OriginatingRegionPropertyDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionPropertyDepartment (PropertyDepartmentCode, SourceCode, IsDeleted, GlobalRegionId)
PRINT 'Completed creating indexes on #OriginatingRegionPropertyDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey

PRINT 'Completed inserting records into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department
-- What was the last period before an employee changed her functional department, finds all functional departments that an employee is associated with
CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
		
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					EFD.EffectivePeriod <= Allocation.Period
			  
				GROUP BY
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
	 ) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode Varchar(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
-- links everything that we have pulled above (applying linking logic to tax, pre-tax and overhead data)
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable,
	BudgetProject.ActivityTypeId,
	Att.ActivityTypeCode,
	
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN -- which property fund are we looking at 
					ProjectPropertyFund.PropertyFundId -- fall back
				ELSE -- else it is not @ or null, so use the mapping below (joining property fund from department to source)
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId, -- else use -1, which is UNKNOWN
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
		
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	fmrb.BudgetReportGroupPeriod
	
FROM
	#BudgetEmployeePayrollAllocation Allocation -- tax amount

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = SourceRegion.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
						
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007	
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON -- property fund could be coming from multiple sources
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

	INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = BudgetProject.ActivityTypeId

WHERE
	Allocation.Period BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod --AND
	--Change Control 1 : GC 2010-09-01
	--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)

CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)
PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode Varchar(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT
	pts.BudgetId,
	pts.BudgetRegionId,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.ActivityTypeCode,
	pts.PropertyFundId,
	pts.AllocationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail 

	INNER JOIN #ProfitabilityPreTaxSource pts ON -- pre tax has already been resolved, above, so join to limit taxdetail
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId


PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId INT NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId AS BudgetId,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode,
	 
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE -- allocation region gets sourced from property fund, project region = allocation region
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			ISNULL(CASE
						WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
							ProjectPropertyFund.PropertyFundId
						ELSE
							DepartmentPropertyFund.PropertyFundId 
				   END, -1) 
		ELSE
			ISNULL(OverheadPropertyFund.PropertyFundId, -1)
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,	
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON -- where overhead amount sits
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	---------------
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
		GrScC.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDC ON
		GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDC.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDC.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECDC.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEC ON
		GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEC.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEC.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPEC.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScC.IsCorporate = 'YES' THEN RECDC.PropertyFundId
						ELSE REPEC.PropertyFundId
					END
			END

	---------------

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON
		GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECDO ON
		GrScO.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECDO.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECDO.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECDO.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPEO ON
		GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPEO.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPEO.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPEO.IsDeleted = 0	

	LEFT OUTER JOIN #PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
						ELSE REPEO.PropertyFundId
					END
			END

	---------------

	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.GroupStartPeriod AND fmrb.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId int NOT NULL,
	ReferenceCode varchar(300) NOT NULL,
	ExpensePeriod char(6) NOT NULL,	
	SourceCode varchar(2) NULL,
	BudgetAmount money NOT NULL,
	MajorGlAccountCategoryId int NOT NULL,
	MinorGlAccountCategoryId int NOT NULL,
	FunctionalDepartmentId int NOT NULL,
	FunctionalDepartmentCode varchar(31) NULL,
	Reimbursable bit NOT NULL,
	FeeOrExpense  Varchar(20) NOT NULL,
	ActivityTypeId int NOT NULL,
	PropertyFundId int NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode char(6) NULL,
	OriginatingRegionSourceCode varchar(2) NULL,
	LocalCurrencyCode char(3) NOT NULL,
	AllocationUpdatedDate datetime NOT NULL,
	GLAccountSubTypeIdGlobal INT NOT NULL,
	GlobalGlAccountCode Varchar(10) NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	FeeOrExpense,
	ActivityTypeId,
	PropertyFundId,
	
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	GLAccountSubTypeIdGlobal,
	GlobalGlAccountCode
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps -- pull all pre-tax amounts that are not zero
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitSharePreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessPreTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN -- settings logic for bonus cap, override property fund
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps

	INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = pps.SourceCode
		
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		--This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
		ISNULL(p.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND --This is a bypass for the 'NULL' scenario, for only CORP have ActivityTypeId's set
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryTaxTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitShareTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
		INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = pps.ActivityTypeId
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsGLMajorCategoryId AS MinorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
		   END, -1) AS PropertyFundId,
		   
	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		   

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON GrSc.SourceCode = pps.SourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0		
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MinorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	'Overhead' FeeOrExpense,
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate,
	(Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL'),
	--General Allocated Overhead Account :: CC8
	'50029500'+RIGHT('0'+LTRIM(STR(pos.ActivityTypeId,3,0)),2)
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0


PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityBudget(
	CalendarKey int NOT NULL,
	GlAccountKey int NOT NULL,
	SourceKey int NOT NULL,
	FunctionalDepartmentKey int NOT NULL,
	ReimbursableKey int NOT NULL,
	ActivityTypeKey int NOT NULL,
	PropertyFundKey int NOT NULL,	
	AllocationRegionKey int NOT NULL,
	OriginatingRegionKey int NOT NULL,
	OverheadKey int NOT NULL,
	LocalCurrencyKey int NOT NULL,
	LocalBudget money NOT NULL,
	ReferenceCode Varchar(300) NOT NULL,
	BudgetId int NOT NULL,
	SourceSystemId int NOT NULL,
	
	EUCorporateGlAccountCategoryKey int NULL,
	EUPropertyGlAccountCategoryKey int NULL,
	EUFundGlAccountCategoryKey int NULL,

	USPropertyGlAccountCategoryKey int NULL,
	USCorporateGlAccountCategoryKey int NULL,
	USFundGlAccountCategoryKey int NULL,

	GlobalGlAccountCategoryKey int NULL,
	DevelopmentGlAccountCategoryKey int NULL
) 

INSERT INTO #ProfitabilityBudget 
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') AS CalendarKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKey ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKey ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKey ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKey ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.Source GrSc ON
		GrSc.SourceCode = pbm.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.Code = pbm.GlobalGlAccountCode AND --Gam.GlobalGlAccountId AND
		pbm.AllocationUpdatedDate BETWEEN GrGa.StartDate AND GrGa.EndDate
		
	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode AND
		--GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND --replaced by new logic below
		GrFdm.FunctionalDepartmentCode = pbm.FunctionalDepartmentCode
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		--GC :: Change Control 1
		GrOh.OverheadCode = CASE WHEN pbm.FeeOrExpense = 'Overhead' THEN 'ALLOC' 
									WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' 
									ELSE 'UNKNOWN' END

	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0

	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
	--ASR.IsActive = 1		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0

	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = pbm.OriginatingRegionCode AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = pbm.OriginatingRegionCode AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0		
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT 'Completed inserting records into #ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityBudget (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityBudget (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId int = -1
DECLARE @LoopCount int = 0 -- Infinite loop safe guard

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)
	
	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM GrReporting.dbo.ProfitabilityBudget 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityBudget'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	PRINT 'Completed deleting records from ProfitabilityBudget:BudgetId='+CONVERT(varchar,@BudgetId)
	PRINT CONVERT(Varchar(27), getdate(), 121)

	DELETE
	FROM
		#DeletingBudget
	WHERE
		BudgetId = @BudgetId
END

print 'Cleaned up rows in ProfitabilityBudget'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)

SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			LEFT OUTER JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslationsPayroll ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL'
							UNION ALL
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslationsOverhead ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL'

						) GlAcHg ON GlAcHg.GLAccountSubTypeId = Gl.GLAccountSubTypeIdGlobal
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate  BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityBudget
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityBudget.ReferenceCode



PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


/*

This is where other Translation used to be and should be :: Gcloete

--EUCorporateGlAccountCategoryKey
--EUPropertyGlAccountCategoryKey
--EUFundGlAccountCategoryKey
--USPropertyGlAccountCategoryKey
--USCorporateGlAccountCategoryKey
--USFundGlAccountCategoryKey
--DevelopmentGlAccountCategoryKey
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityBudget
(
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT 
	CalendarKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalBudget,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey

FROM 
	#ProfitabilityBudget

print 'Rows Inserted in ProfitabilityBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP TABLE #SystemSettingRegion
DROP TABLE #GLAccountType
DROP TABLE #GLAccountSubType
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #GLAccountCategoryTranslationsPayroll
DROP TABLE #GLAccountCategoryTranslationsOverhead
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #AllocationSubRegion
DROP TABLE #ProfitabilityBudget
DROP TABLE #DeletingBudget
--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup


GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]    Script Date: 10/01/2010 06:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[stp_IU_LoadGrProfitabiltyPayrollReforecast]

	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
IF @DataPriorToDate IS NULL 
	SET @DataPriorToDate = GETDATE()

PRINT '####'
PRINT 'stp_IU_LoadGrProfitabiltyPayrollReforecast'
PRINT '####'

DECLARE	 @CanImportTapasBudget		Int = (Select ConfiguredValue From [GrReportingStaging].[dbo].[SSISConfigurations] Where ConfigurationFilter = 'CanImportTapasBudget')


IF (@CanImportTapasBudget = 0)
	BEGIN
	print 'Import TapasBudget not scheduled in SSISConfigurations'
	RETURN
	END
	
/*
[stp_IU_LoadGrProfitabiltyPayrollReforecast]
	@ImportStartDate	= '1900-01-01',
	@ImportEndDate		= '2010-12-31',
	@DataPriorToDate	= '2010-12-31'
*/ 

-- Setup account categories and default to UNKNOWN.
DECLARE 
	@SalariesTaxesBenefitsMajorGlAccountCategoryId INT = -1,
	@BaseSalaryMinorGlAccountCategoryId INT = -1,
	@BenefitsMinorGlAccountCategoryId INT = -1,
	@BonusMinorGlAccountCategoryId INT = -1,
	@ProfitShareMinorGlAccountCategoryId INT = -1,
	@OccupancyCostsMajorGlAccountCategoryId INT = -1,
	@OverheadMinorGlAccountCategoryId INT = -1

DECLARE 
	@GlAccountKeyUnknown			INT = (SELECT GlAccountKey FROM GrReporting.dbo.GlAccount WHERE Code = 'UNKNOWN'),
	@SourceKeyUnknown				INT = (SELECT SourceKey FROM GrReporting.dbo.[Source] WHERE SourceName = 'UNKNOWN'),
	@FunctionalDepartmentKeyUnknown INT = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN'),
	@ReimbursableKeyUnknown			INT = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN'),
	@ActivityTypeKeyUnknown			INT = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN'),
	@PropertyFundKeyUnknown			INT = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN'),
	@AllocationRegionKeyUnknown		INT = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN'),
	@OriginatingRegionKeyUnknown	INT = (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN'),
	@OverheadKeyUnknown				INT = (Select OverheadKey From GrReporting.dbo.Overhead Where OverheadCode = 'UNKNOWN'),
    @LocalCurrencyKeyUnknown		INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'UNKNOWN')

DECLARE
	@EUFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUCorporateGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@EUPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'EU Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USFundGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Fund Profit & Loss'      AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USPropertyGlAccountCategoryKeyUnknown	INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Property Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@USCorporateGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'US Corporate Profit & Loss' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@DevelopmentGlAccountCategoryKeyUnknown INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global Profit & Loss' AND TranslationSubTypeName = 'Development Profit & Loss'  AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN'),
	@GlobalGlAccountCategoryKeyUnknown		INT = (SELECT GlAccountCategoryKey FROM GrReporting.dbo.GlAccountCategory WHERE TranslationTypeName = 'Global' AND TranslationSubTypeName = 'Global' AND MajorCategoryName = 'UNKNOWN' AND MinorCategoryName = 'UNKNOWN' AND FeeOrExpense = 'UNKNOWN' AND AccountSubTypeName = 'UNKNOWN')

	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Setup mapping variables
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


-- Set gl account categories
SELECT TOP 1
	@SalariesTaxesBenefitsMajorGlAccountCategoryId = GLMajorCategoryId
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = 'Salaries/Taxes/Benefits'

print (@SalariesTaxesBenefitsMajorGlAccountCategoryId)
--NB!!!!!!!
--The roll up to payroll is very sensitive information. It is crutial that information regarding payroll not get 
--communicated to TS employees on certain reports. Changing the category name here will have ramifications because 
--some reports check for this name.
--NB!!!!!!!

SELECT
	@BaseSalaryMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Base Salary'

SELECT
	@BenefitsMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits'

SELECT
	@BonusMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Bonus'

SELECT
	@ProfitShareMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @SalariesTaxesBenefitsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'Benefits' -- Yes benefit is correct (Just incase they want to split profit share out again)

SELECT TOP 1
	@OccupancyCostsMajorGlAccountCategoryId = GLMajorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryName = 'General Overhead'

SELECT
	@OverheadMinorGlAccountCategoryId = GLMinorCategoryId 
FROM
	Gr.GetGlobalGlAccountCategoryTranslation(@DataPriorToDate)
WHERE
	GLMajorCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
	GLMinorCategoryName = 'External General Overhead'

DECLARE @SourceSystemId int
SET @SourceSystemId = 2 -- Tapas budgeting source system

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Source Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--/*

--
-- Setup Bonus Cap Excess Project Setting
--

CREATE TABLE #SystemSettingRegion
(
	SystemSettingId INT NOT NULL,
	SystemSettingName VARCHAR(50) NOT NULL,
	SystemSettingRegionId INT NOT NULL,
	RegionId INT,
	SourceCode VARCHAR(2),
	BonusCapExcessProjectId INT
)

CREATE TABLE #GLTranslationType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLTranslationSubType(
	ImportKey INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsGRDefault BIT NOT NULL
)

CREATE TABLE #GLMajorCategory(
	ImportKey INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLMinorCategory(
	ImportKey INT NOT NULL,
	GLMinorCategoryId INT NOT NULL,
	GLMajorCategoryId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

CREATE TABLE #GLAccountSubType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	GLAccountSubTypeId INT NOT NULL,
	GLTranslationTypeId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)


-- #SystemSettingRegion

INSERT INTO #SystemSettingRegion
(
	SystemSettingId,
	SystemSettingName,
	SystemSettingRegionId,
	RegionId,
	SourceCode,
	BonusCapExcessProjectId
)

SELECT 
	ss.SystemSettingId,
	ss.Name,
	ssr.SystemSettingRegionId,
	ssr.RegionId,
	ssr.SourceCode,
	ssr.BonusCapExcessProjectId
FROM
	(SELECT 
		ssr.* 
	 FROM TapasGlobal.SystemSettingRegion ssr
		INNER JOIN TapasGlobal.SystemSettingRegionActive(@DataPriorToDate) ssrA
			ON ssr.ImportKey = ssrA.ImportKey
	 ) ssr
	INNER JOIN
		(SELECT
			ss.SystemSettingId,
			ss.Name
		 FROM
			(SELECT	
				ss.*
			 FROM TapasGlobal.SystemSetting ss
					INNER JOIN TapasGlobal.SystemSettingActive(@DataPriorToDate) ssA 
						ON ss.ImportKey = ssA.ImportKey
			 ) ss

		  ) ss ON ssr.SystemSettingId = ss.SystemSettingId
PRINT 'Completed getting system settings'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- #GLTranslationType

INSERT INTO #GLTranslationType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLTranslationTypeId,
	Code,
	Name,
	[Description],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TT.ImportKey,
	TT.ImportBatchId,
	TT.ImportDate,
	TT.GLTranslationTypeId,
	TT.Code,
	TT.Name,
	TT.[Description],
	TT.IsActive,
	TT.InsertedDate,
	TT.UpdatedDate,
	TT.UpdatedByStaffId
FROM
	Gdm.GLTranslationType TT
	INNER JOIN Gdm.GLTranslationTypeActive(@DataPriorToDate) TTA ON
		TTA.ImportKey = TT.ImportKey

-- #GLTranslationSubType

INSERT INTO #GLTranslationSubType(
	ImportKey,
	GLTranslationSubTypeId,
	GLTranslationTypeId,
	Code,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsGRDefault
)
SELECT
	TST.ImportKey,
	TST.GLTranslationSubTypeId,
	TST.GLTranslationTypeId,
	TST.Code,
	TST.[Name],
	TST.IsActive,
	TST.InsertedDate,
	TST.UpdatedDate,
	TST.UpdatedByStaffId,
	TST.IsGRDefault
FROM
	Gdm.GLTranslationSubType TST
	INNER JOIN Gdm.GLTranslationSubTypeActive(@DataPriorToDate) TSTA ON
		TSTA.ImportKey = TST.ImportKey

-- #GLMajorCategory

INSERT INTO #GLMajorCategory(
	ImportKey,
	GLMajorCategoryId,
	GLTranslationSubTypeId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	MajC.ImportKey,
	MajC.GLMajorCategoryId,
	MajC.GLTranslationSubTypeId,
	MajC.[Name],
	MajC.IsActive,
	MajC.InsertedDate,
	MajC.UpdatedDate,
	MajC.UpdatedByStaffId
FROM
	Gdm.GLMajorCategory MajC
	INNER JOIN Gdm.GLMajorCategoryActive(@DataPriorToDate) MajCA ON
		MajC.ImportKey = MajCA.ImportKey

-- #GLMinorCategory

INSERT INTO #GLMinorCategory(
	ImportKey,
	GLMinorCategoryId,
	GLMajorCategoryId,
	[Name],
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	Minc.ImportKey,
	Minc.GLMinorCategoryId,
	Minc.GLMajorCategoryId,
	Minc.[Name],
	Minc.IsActive,
	Minc.InsertedDate,
	Minc.UpdatedDate,
	Minc.UpdatedByStaffId
FROM
	Gdm.GLMinorCategory MinC
	INNER JOIN Gdm.GLMinorCategoryActive(@DataPriorToDate) MinCA ON
		MinCA.ImportKey = MinC.ImportKey

-- #GLAccountType

INSERT INTO #GLAccountType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AT.ImportKey,
	AT.ImportBatchId,
	AT.ImportDate,
	AT.GLAccountTypeId,
	AT.GLTranslationTypeId,
	AT.Code,
	AT.Name,
	AT.IsActive,
	AT.InsertedDate,
	AT.UpdatedDate,
	AT.UpdatedByStaffId	
FROM
	Gdm.GLAccountType AT
	INNER JOIN Gdm.GLAccountTypeActive(@DataPriorToDate) ATA ON
		AT.ImportKey = ATA.ImportKey
	
-- #GLAccountSubType

INSERT INTO #GLAccountSubType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	GLAccountSubTypeId,
	GLTranslationTypeId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	AST.ImportKey,
	AST.ImportBatchId,
	AST.ImportDate,
	AST.GLAccountSubTypeId,
	AST.GLTranslationTypeId,
	AST.Code,
	AST.Name,
	AST.IsActive,
	AST.InsertedDate,
	AST.UpdatedDate,
	AST.UpdatedByStaffId
FROM
	Gdm.GLAccountSubType AST
	INNER JOIN Gdm.GLAccountSubTypeActive(@DataPriorToDate) ASTA ON
		AST.ImportKey = ASTA.ImportKey



-- Get GLTranslationType, GLTranslationSubType, GLAccountType(either expense type), and GLAccountSubType(either payroll type) data
-- This table is used when inserts are made to the TranslationSubType CategoryLookup tables: search for 'Map account categories' section
CREATE TABLE #GLAccountCategoryTranslationsPayroll(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslationsPayroll(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE '%PYR' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed getting GlAccountCategory payroll records'
PRINT CONVERT(Varchar(27), getdate(), 121)


CREATE TABLE #GLAccountCategoryTranslationsOverhead(
	GLTranslationTypeId INT NOT NULL,
	GLTranslationSubTypeId INT NOT NULL,
	GLTranslationSubTypeCode VARCHAR(10) NOT NULL,
	GLAccountTypeId INT NOT NULL,
	GLAccountSubTypeId INT NOT NULL
)

INSERT INTO #GLAccountCategoryTranslationsOverhead(
	GLTranslationTypeId,
	GLTranslationSubTypeId,
	GLTranslationSubTypeCode,
	GLAccountTypeId,
	GLAccountSubTypeId
)
SELECT
	TST.GLTranslationTypeId,
	TST.GLTranslationSubTypeId,
	TST.Code,
	AT.GLAccountTypeId,
	AST.GLAccountSubTypeId
FROM
	#GLTranslationSubType TST

	INNER JOIN #GLTranslationType TT ON
		TT.GLTranslationTypeId = TST.GLTranslationTypeId

	INNER JOIN #GLAccountType AT ON
		TST.GLTranslationTypeId = AT.GLTranslationTypeId AND
		AT.IsActive = 1

	INNER JOIN #GLAccountSubType AST ON
		TST.GLTranslationTypeId = AST.GLTranslationTypeId AND
		AST.IsActive = 1
	
WHERE
	AST.Code LIKE '%OHD' AND -- This stored procedure exclusively looks at payroll. Only consider Account SubTypes related to payroll.
	AT.Code LIKE '%EXP' AND -- Only consider expense-related account types: Payroll is always considered as an expense.
	TT.IsActive = 1 AND
	TST.IsActive = 1 AND
	AT.IsActive = 1 AND
	AST.IsActive = 1

PRINT 'Completed getting GlAccountCategory overhead records'
PRINT CONVERT(Varchar(27), getdate(), 121)

------------------------------------------------------------------------------------------------------
--Source and identify report grouping records
------------------------------------------------------------------------------------------------------

-- Source budget report group detail. 



CREATE TABLE #BudgetReportGroupDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupDetailId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetId INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)


INSERT INTO #BudgetReportGroupDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupDetailId,
	BudgetReportGroupId,
	RegionId,
	BudgetId,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgd.*
FROM 
	TapasGlobalBudgeting.BudgetReportGroupDetail brgd
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupDetailActive(@DataPriorToDate) brgdA ON
		brgd.ImportKey = brgdA.ImportKey

--select * from #BudgetReportGroupDetail
		
PRINT 'Completed inserting records from BudgetReportGroupDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget report group.

CREATE TABLE #BudgetReportGroup(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	IsReforecast BIT NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	IsDeleted BIT NOT NULL,
	GRChangedDate DATETIME NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	BudgetReportGroupPeriodId INT NULL
)

INSERT INTO #BudgetReportGroup(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupId,
	Name,
	BudgetExchangeRateId,
	IsReforecast,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	IsDeleted,
	GRChangedDate,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	BudgetReportGroupPeriodId
)
SELECT 
	brg.* 
FROM 
	TapasGlobalBudgeting.BudgetReportGroup brg
	INNER JOIN TapasGlobalBudgeting.BudgetReportGroupActive(@DataPriorToDate) brgA ON
		brg.ImportKey = brgA.ImportKey

--select * from #BudgetReportGroup
	
PRINT 'Completed inserting records from BudgetReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source report group period mapping.

CREATE TABLE #BudgetReportGroupPeriod(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	BudgetExchangeRateId INT NOT NULL,
	[Year] INT NOT NULL,
	Period INT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetReportGroupPeriod(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetReportGroupPeriodId,
	BudgetExchangeRateId,
	[Year],
	Period,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	brgp.*
FROM
	Gdm.BudgetReportGroupPeriod brgp
	INNER JOIN Gdm.BudgetReportGroupPeriodActive(@DataPriorToDate) brgpA ON
		brgp.ImportKey = brgpA.ImportKey

--select * from #BudgetReportGroupPeriod

PRINT 'Completed inserting records from GRBudgetReportGroupPeriod:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget status

CREATE TABLE #BudgetStatus(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetStatus(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetStatusId,
	Name,
	[Description],
	InsertedDate,
	UpdatedByStaffId
)
SELECT 
	BudgetStatus.* 
FROM
	TapasGlobalBudgeting.BudgetStatus BudgetStatus
	INNER JOIN TapasGlobalBudgeting.BudgetStatusActive(@DataPriorToDate) BudgetStatusA ON
		BudgetStatus.ImportKey = BudgetStatusA.ImportKey
		
PRINT 'Completed inserting records from BudgetStatus:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source all active budget

CREATE TABLE #AllActiveBudget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #AllActiveBudget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	TapasGlobalBudgeting.Budget Budget
	INNER JOIN TapasGlobalBudgeting.BudgetActive(@DataPriorToDate) BudgetA ON
		Budget.ImportKey = BudgetA.ImportKey
		
PRINT 'Completed inserting records from Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Modified new or modified budget or report group setup.

CREATE TABLE #AllModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	BudgetFirstProjectedPeriod INT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL
)

INSERT INTO #AllModifiedReportBudget(
	BudgetId, 
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId, 
	BudgetFirstProjectedPeriod,
	IsDetailDeleted, 
	IsGroupReforecast, 
	GroupStartPeriod, 
	GroupEndPeriod, 
	IsGroupDeleted,
	IsPeriodDeleted
)
SELECT 
	brgd.BudgetId, 
	brgd.BudgetReportGroupId,
	brgp.BudgetReportGroupPeriodId,
	Budget.IsDeleted AS IsBudgetDeleted,
	Budget.IsReforecast AS IsBugetReforecast,
	Budget.BudgetStatusId, 
	Budget.FirstProjectedPeriod AS BudgetFirstProjectedPeriod,
	brgd.IsDeleted AS IsDetailDeleted, 
	brg.IsReforecast AS IsGroupReforecast, 
	brg.StartPeriod AS GroupStartPeriod, 
	brg.EndPeriod AS GroupEndPeriod, 
	brg.IsDeleted AS IsGroupDeleted,
	brgp.IsDeleted AS IsPeriodDeleted
FROM
	#AllActiveBudget Budget

    INNER JOIN #BudgetReportGroupDetail brgd ON
		Budget.BudgetId = brgd.BudgetId
    
    INNER JOIN #BudgetReportGroup brg ON
		brgd.BudgetReportGroupId = brg.BudgetReportGroupId
    
    INNER JOIN #BudgetReportGroupPeriod brgp ON
		brg.BudgetReportGroupPeriodId = brgp.BudgetReportGroupPeriodId 
		
WHERE
	(brgd.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brg.GRChangedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(brgp.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate) OR
	(Budget.LastLockedDate IS NOT NULL AND Budget.LastLockedDate BETWEEN @ImportStartDate AND @ImportEndDate)

--select * from #AllModifiedReportBudget

PRINT 'Completed inserting records into #AllModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Filtered budget and setup report group setup

CREATE TABLE #LockedModifiedReportGroup(
	BudgetReportGroupId INT NOT NULL
)

INSERT INTO #LockedModifiedReportGroup(
	BudgetReportGroupId
)
SELECT
	amrb.BudgetReportGroupId
FROM
	#AllModifiedReportBudget amrb
	
	INNER JOIN #BudgetStatus bs ON
		amrb.BudgetStatusId = bs.BudgetStatusId
GROUP BY
	amrb.BudgetReportGroupId
HAVING
	COUNT(*) = SUM(CASE WHEN bs.[Name] = 'Locked' THEN 1 ELSE 0 END) 

PRINT 'Completed inserting records into #LockedModifiedReportGroup:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source filtered budget information

CREATE TABLE #FilteredModifiedReportBudget(
	BudgetId INT NOT NULL,
	BudgetReportGroupId INT NOT NULL,
	BudgetReportGroupPeriodId INT NOT NULL,
	IsBudgetDeleted BIT NOT NULL,
	IsBugetReforecast BIT NOT NULL,
	BudgetStatusId INT NOT NULL,
	BudgetFirstProjectedPeriod INT NULL,
	IsDetailDeleted BIT NOT NULL,
	IsGroupReforecast BIT NOT NULL,
	GroupStartPeriod INT NOT NULL,
	GroupEndPeriod INT NOT NULL,
	IsGroupDeleted BIT NOT NULL,
	IsPeriodDeleted BIT NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)

INSERT INTO #FilteredModifiedReportBudget(
	BudgetId,
	BudgetReportGroupId,
	BudgetReportGroupPeriodId,
	IsBudgetDeleted,
	IsBugetReforecast,
	BudgetStatusId,
	BudgetFirstProjectedPeriod,
	IsDetailDeleted,
	IsGroupReforecast,
	GroupStartPeriod,
	GroupEndPeriod,
	IsGroupDeleted,
	IsPeriodDeleted,
	BudgetReportGroupPeriod 
)
SELECT
	amrb.*,
	brgp.Period BudgetReportGroupPeriod
FROM
	#LockedModifiedReportGroup lmrg
	
	INNER JOIN #AllModifiedReportBudget amrb ON
		lmrg.BudgetReportGroupId = amrb.BudgetReportGroupId

	INNER JOIN #BudgetReportGroupPeriod brgp ON
		brgp.BudgetReportGroupPeriodId = amrb.BudgetReportGroupPeriodId
		
WHERE
	amrb.IsBudgetDeleted = 0 AND
	amrb.IsBugetReforecast = 1 AND
	amrb.IsDetailDeleted = 0 AND
	amrb.IsGroupReforecast = 1 AND
	amrb.IsGroupDeleted = 0 AND
	amrb.IsPeriodDeleted = 0 AND
	brgp.IsDeleted = 0

PRINT 'Completed inserting records into #FilteredModifiedReportBudget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--select * from #FilteredModifiedReportBudget

-- Source budget information that meet criteria

CREATE TABLE #Budget(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetId INT NOT NULL,
	RegionId INT NOT NULL,
	BudgetTypeId INT NOT NULL,
	BudgetStatusId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NOT NULL,
	FirstProjectedPeriod INT NULL,
	CurrencyCode VARCHAR(3) NOT NULL,
	CanEmployeesViewBudget BIT NOT NULL,
	IsReforecast BIT NOT NULL,
	IsDeleted BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	LastLockedDate DATETIME NULL,
	BudgetAllocationSetId INT NULL,
	LastAMUpdateDate DATETIME NULL
)

INSERT INTO #Budget(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetId,
	RegionId,
	BudgetTypeId,
	BudgetStatusId,
	Name,
	StartPeriod,
	EndPeriod,
	FirstProjectedPeriod,
	CurrencyCode,
	CanEmployeesViewBudget,
	IsReforecast,
	IsDeleted,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	LastLockedDate,
	BudgetAllocationSetId,
	LastAMUpdateDate
)
SELECT 
	Budget.*
FROM
	#AllActiveBudget Budget
	
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		Budget.BudgetId = fmrb.BudgetId
PRINT 'Completed inserting records into #Budget:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #Budget (BudgetId)
PRINT 'Completed creating indexes on #Budget'
PRINT CONVERT(Varchar(27), getdate(), 121)

--select * from #Budget

--*/
------------------------------------------------------------------------------------------------------
--Source associated records
------------------------------------------------------------------------------------------------------

--/*
-- Source budget project

CREATE TABLE #BudgetProject(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetId INT NOT NULL,
	ProjectId INT NULL,
	RegionId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	Code VARCHAR(50) NULL,
	Name VARCHAR(100) NULL,
	CorporateDepartmentCode VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	IsReimbursable BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetProjectId INT NULL,
	IsTsCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	ProjectOwnerStaffId INT NULL,
	AMBudgetProjectId INT NULL
)

INSERT INTO #BudgetProject(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetProjectId,
	BudgetId,
	ProjectId,
	RegionId,
	PropertyFundId,
	ActivityTypeId,
	Code,
	Name,
	CorporateDepartmentCode,
	CorporateSourceCode,
	StartPeriod,
	EndPeriod,
	IsReimbursable,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetProjectId,
	IsTsCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId,
	MarkUpPercentage,
	ProjectOwnerStaffId,
	AMBudgetProjectId
)
SELECT 
	BudgetProject.*
FROM 
	TapasGlobalBudgeting.BudgetProject BudgetProject
	INNER JOIN TapasGlobalBudgeting.BudgetProjectActive(@DataPriorToDate) BudgetProjectA ON
		BudgetProject.ImportKey = BudgetProjectA.ImportKey
		
	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetProject.BudgetId = b.BudgetId

--select * from #BudgetProject

PRINT 'Completed inserting records into #BudgetProject:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetID ON #BudgetProject (BudgetId)
PRINT 'Completed creating indexes on #BudgetProject'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region

CREATE TABLE #Region(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	PayCode VARCHAR(5) NULL,
	EnrollmentTypeId INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Region(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	SourceCode,
	Code,
	Name,
	PayCode,
	EnrollmentTypeId,
	InsertedDate,
	UpdatedDate
)
SELECT 
	SourceRegion.*
FROM 
	HR.Region SourceRegion
	INNER JOIN HR.RegionActive(@DataPriorToDate) SourceRegionA ON
		SourceRegion.ImportKey = SourceRegionA.ImportKey
PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee

CREATE TABLE #BudgetEmployee(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetId INT NOT NULL,
	HrEmployeeId INT NULL,
	PayGroupId INT NOT NULL,
	JobTitleId INT NOT NULL,
	LocationId INT NOT NULL,
	StateId INT NULL,
	OverheadRegionId INT NOT NULL,
	ApproverStaffId INT NULL,
	Name VARCHAR(255) NOT NULL,
	IsUnion BIT NOT NULL,
	RehirePeriod INT NOT NULL,
	RehireDate DATETIME NOT NULL,
	TerminatePeriod INT NULL,
	TerminateDate DATETIME NULL,
	EmployeeHistoryEffectivePeriod INT NOT NULL,
	EmployeeHistoryEffectiveDate DATETIME NOT NULL,
	EmployeePayrollEffectiveDate DATETIME NULL,
	CurrentAnnualSalary DECIMAL(18, 2) NULL,
	PreviousYearSalary DECIMAL(18, 2) NULL,
	SalaryYear INT NOT NULL,
	PreviousYearBonus DECIMAL(18, 2) NULL,
	BonusYear INT NULL,
	IsActualEmployee BIT NOT NULL,
	IsReviewed BIT NOT NULL,
	IsPartTime BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeeId INT NULL
)

INSERT INTO #BudgetEmployee(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeId,
	BudgetId,
	HrEmployeeId,
	PayGroupId,
	JobTitleId,
	LocationId,
	StateId,
	OverheadRegionId ,
	ApproverStaffId,
	Name,
	IsUnion,
	RehirePeriod,
	RehireDate,
	TerminatePeriod,
	TerminateDate,
	EmployeeHistoryEffectivePeriod,
	EmployeeHistoryEffectiveDate,
	EmployeePayrollEffectiveDate,
	CurrentAnnualSalary,
	PreviousYearSalary,
	SalaryYear,
	PreviousYearBonus,
	BonusYear,
	IsActualEmployee,
	IsReviewed,
	IsPartTime,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeeId
)
SELECT 
	BudgetEmployee.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployee BudgetEmployee
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeActive(@DataPriorToDate) BudgetEmployeeA ON
		BudgetEmployee.ImportKey = BudgetEmployeeA.ImportKey

	--data limiting join
	INNER JOIN #Budget b ON
		BudgetEmployee.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #Region:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeID ON #BudgetEmployee (BudgetEmployeeId)
CREATE INDEX IX_BudgetId ON #BudgetEmployee (BudgetId)

PRINT 'Completed creating indexes on ##BudgetEmployee'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Budget Employee Functional Department

CREATE TABLE #BudgetEmployeeFunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeeFunctionalDepartmentId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	SubDepartmentId INT NOT NULL,
	EffectivePeriod INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #BudgetEmployeeFunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeeFunctionalDepartmentId,
	BudgetEmployeeId,
	SubDepartmentId,
	EffectivePeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	FunctionalDepartmentId
)
SELECT 
	efd.* 
FROM 
	TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartment efd
	INNER JOIN TapasGlobalBudgeting.BudgetEmployeeFunctionalDepartmentActive(@DataPriorToDate) efdA ON
		efd.ImportKey = efdA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetEmployee be ON
		efd.BudgetEmployeeId = be.BudgetEmployeeId

PRINT 'Completed inserting records into #BudgetEmployeeFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeeId ON #BudgetEmployeeFunctionalDepartment (BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetEmployeeFunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)



-- Source Functional Department

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT 
	fd.*
FROM 
	HR.FunctionalDepartment fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund

CREATE TABLE #PropertyFund(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundId INT NOT NULL,
	RelatedFundId INT NULL,
	EntityTypeId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NOT NULL,
	RegionalOwnerStaffId INT NOT NULL,
	DefaultGLTranslationSubTypeId INT NULL,
	Name VARCHAR(100) NOT NULL,
	IsReportingEntity BIT NOT NULL,
	IsPropertyFund BIT NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PropertyFund(
	ImportKey,
	ImportBatchId,
	ImportDate,
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
SELECT 
	PropertyFund.*
FROM 
	Gdm.PropertyFund PropertyFund
	INNER JOIN Gdm.PropertyFundActive(@DataPriorToDate) PropertyFundA ON
		PropertyFund.ImportKey = PropertyFundA.ImportKey 

PRINT 'Completed inserting records into #PropertyFund:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFund (PropertyFundId)
PRINT 'Completed creating indexes on #PropertyFund'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Property Fund Mapping

CREATE TABLE #PropertyFundMapping(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	PropertyFundMappingId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyFundCode VARCHAR(8) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL,
	ActivityTypeId INT NULL
)

INSERT INTO #PropertyFundMapping(
	ImportKey,
	ImportBatchId,
	ImportDate,
	PropertyFundMappingId,
	PropertyFundId,
	SourceCode,
	PropertyFundCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted,
	ActivityTypeId
)
SELECT 
	PropertyFundMapping.* 
FROM 
	Gdm.PropertyFundMapping PropertyFundMapping
	INNER JOIN Gdm.PropertyFundMappingActive(@DataPriorToDate) PropertyFundMappingA ON
		PropertyFundMapping.ImportKey = PropertyFundMappingA.ImportKey 

PRINT 'Completed inserting records into #PropertyFundMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PropertyFundId ON #PropertyFundMapping (PropertyFundCode,SourceCode,IsDeleted,PropertyFundId,ActivityTypeId)
PRINT 'Completed creating indexes on #PropertyFundMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityCorporateDepartment

CREATE TABLE #ReportingEntityCorporateDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityCorporateDepartmentId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	CorporateDepartmentCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL,
)

INSERT INTO	#ReportingEntityCorporateDepartment(
	ImportKey,
	ReportingEntityCorporateDepartmentId,
	PropertyFundId,
	SourceCode,
	CorporateDepartmentCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	RECD.ImportKey,
	RECD.ReportingEntityCorporateDepartmentId,
	RECD.PropertyFundId,
	RECD.SourceCode,
	RECD.CorporateDepartmentCode,
	RECD.InsertedDate,
	RECD.UpdatedDate,
	RECD.UpdatedByStaffId,
	RECD.IsDeleted
FROM
	Gdm.ReportingEntityCorporateDepartment RECD
	INNER JOIN Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
		RECDA.ImportKey = RECD.ImportKey

PRINT 'Completed creating indexes on #ReportingEntityCorporateDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source ReportingEntityPropertyEntity

CREATE TABLE #ReportingEntityPropertyEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	ReportingEntityPropertyEntityId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	PropertyEntityCode CHAR(6) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsDeleted BIT NOT NULL
)

INSERT INTO #ReportingEntityPropertyEntity(
	ImportKey,
	ReportingEntityPropertyEntityId,
	PropertyFundId,
	SourceCode,
	PropertyEntityCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	IsDeleted
)
SELECT
	REPE.ImportKey,
	REPE.ReportingEntityPropertyEntityId,
	REPE.PropertyFundId,
	REPE.SourceCode,
	REPE.PropertyEntityCode,
	REPE.InsertedDate,
	REPE.UpdatedDate,
	REPE.UpdatedByStaffId,
	REPE.IsDeleted
FROM
	Gdm.ReportingEntityPropertyEntity REPE
	INNER JOIN Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
		REPEA.ImportKey = REPE.ImportKey

PRINT 'Completed creating indexes on #ReportingEntityPropertyEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Location

CREATE TABLE #Location(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	LocationId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	StateId INT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL
)

INSERT INTO #Location(
	ImportKey,
	ImportBatchId,
	ImportDate,
	LocationId,
	ExternalSubRegionId,
	StateId,
	Code,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate
)
SELECT 
	Location.* 
FROM 
	HR.Location Location
	INNER JOIN HR.LocationActive(@DataPriorToDate) LocationA ON
		Location.ImportKey = LocationA.ImportKey
	
PRINT 'Completed inserting records into #Location:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_LocationId ON #Location (LocationId)
PRINT 'Completed creating indexes on #Location'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source region extended

CREATE TABLE #RegionExtended(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	RegionId INT NOT NULL,
	RegionalAdministratorId INT NOT NULL,
	CountryId INT NOT NULL,
	HasEmployees BIT NOT NULL,
	CanChargeMarkupOnProject BIT NOT NULL,
	CanChargeMarkupOnPayrollOverhead BIT NOT NULL,
	CanUploadOverheadJournal BIT NOT NULL,
	ProjectRef VARCHAR(8) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OverheadFunctionalDepartmentId INT NOT NULL,
	CanRegionBillInArrears BIT NOT NULL
)

INSERT INTO #RegionExtended(
	ImportKey,
	ImportBatchId,
	ImportDate,
	RegionId,
	RegionalAdministratorId,
	CountryId,
	HasEmployees,
	CanChargeMarkupOnProject,
	CanChargeMarkupOnPayrollOverhead,
	CanUploadOverheadJournal,
	ProjectRef,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OverheadFunctionalDepartmentId,
	CanRegionBillInArrears
)
SELECT 
	RegionExtended.*
FROM 
	TapasGlobal.RegionExtended RegionExtended
	INNER JOIN TapasGlobal.RegionExtendedActive(@DataPriorToDate) RegionExtendedA ON
		RegionExtended.ImportKey = RegionExtendedA.ImportKey

PRINT 'Completed inserting records into #RegionExtended:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_RegionId ON #RegionExtended (RegionId)
PRINT 'Completed creating indexes on #RegionExtended'
PRINT CONVERT(Varchar(27), getdate(), 121)


-- Source Payroll Originating Region

CREATE TABLE #PayrollRegion(
	ImportKey INT NOT NULL,
	PayrollRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	ExternalSubRegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NOT NULL,
	CorporateSourceCode VARCHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #PayrollRegion(
	ImportKey,
	PayrollRegionId,
	RegionId,
	ExternalSubRegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	PayrollRegion.*
FROM 
	TapasGlobal.PayrollRegion PayrollRegion
	INNER JOIN TapasGlobal.PayrollRegionActive(@DataPriorToDate) PayrollRegionA ON
		PayrollRegion.ImportKey = PayrollRegionA.ImportKey
	
PRINT 'Completed inserting records into #PayrollRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_PayrollRegionId ON #PayrollRegion (PayrollRegionId)
PRINT 'Completed creating indexes on #PayrollRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source Overhead Originating Region

CREATE TABLE #OverheadRegion(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	OverheadRegionId INT NOT NULL,
	RegionId INT NOT NULL,
	CorporateEntityRef VARCHAR(6) NULL,
	CorporateSourceCode VARCHAR(2) NULL,
	Name VARCHAR(50) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadRegion(
	ImportKey,
	ImportBatchId,
	ImportDate,
	OverheadRegionId,
	RegionId,
	CorporateEntityRef,
	CorporateSourceCode,
	Name,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)

SELECT 
	OverheadRegion.*
FROM 
	TapasGlobal.OverheadRegion OverheadRegion
	INNER JOIN TapasGlobal.OverheadRegionActive(@DataPriorToDate) OverheadRegionA ON
		OverheadRegion.ImportKey = OverheadRegionA.ImportKey
	
PRINT 'Completed inserting records into #OverheadRegion:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_OverheadRegionId ON #OverheadRegion (OverheadRegionId)
PRINT 'Completed creating indexes on #OverheadRegion'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source project

CREATE TABLE #Project(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	ProjectId INT NOT NULL,
	RegionId INT NOT NULL,
	ActivityTypeId INT NOT NULL,
	ProjectOwnerId INT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	CorporateSourceCode CHAR(2) NOT NULL,
	Code VARCHAR(50) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	StartPeriod INT NOT NULL,
	EndPeriod INT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	PropertyOverheadGLAccountCode VARCHAR(15) NULL,
	PropertyOverheadDepartmentCode VARCHAR(6) NULL,
	PropertyOverheadJobCode VARCHAR(15) NULL,
	PropertyOverheadSourceCode CHAR(2) NULL,
	CorporateUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateNonUnionPayrollIncomeCategoryCode VARCHAR(6) NULL,
	CorporateOverheadIncomeCategoryCode VARCHAR(6) NULL,
	PropertyFundId INT NOT NULL,
	MarkUpPercentage DECIMAL(5, 4) NULL,
	HistoricalProjectCode VARCHAR(50) NULL,
	IsTSCost BIT NOT NULL,
	CanAllocateOverheads BIT NOT NULL,
	AllocateOverheadsProjectId INT NULL
)

INSERT INTO #Project(
	ImportKey,
	ImportBatchId,
	ImportDate,
	ProjectId,
	RegionId,
	ActivityTypeId,
	ProjectOwnerId,
	CorporateDepartmentCode,
	CorporateSourceCode,
	Code,
	Name,
	StartPeriod,
	EndPeriod,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	PropertyOverheadGLAccountCode,
	PropertyOverheadDepartmentCode,
	PropertyOverheadJobCode,
	PropertyOverheadSourceCode,
	CorporateUnionPayrollIncomeCategoryCode,
	CorporateNonUnionPayrollIncomeCategoryCode,
	CorporateOverheadIncomeCategoryCode,
	PropertyFundId,
	MarkUpPercentage,
	HistoricalProjectCode,
	IsTSCost,
	CanAllocateOverheads,
	AllocateOverheadsProjectId
)
SELECT 
	Project.*
FROM 
	TapasGlobal.Project Project
	INNER JOIN TapasGlobal.ProjectActive(@DataPriorToDate) ProjectA ON
		Project.ImportKey = ProjectA.ImportKey 

PRINT 'Completed inserting records into #Project:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_ProjectId ON #Project (ProjectId)
PRINT 'Completed creating indexes on #Project'
PRINT CONVERT(Varchar(27), getdate(), 121)



------------------------------------------------------------------------------------------------------
-- Additional required mappings
------------------------------------------------------------------------------------------------------

-- #OriginatingRegionCorporateEntity

CREATE TABLE #OriginatingRegionCorporateEntity( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionCorporateEntityId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	CorporateEntityCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #OriginatingRegionCorporateEntity(
	ImportKey,
	OriginatingRegionCorporateEntityId,
	GlobalRegionId,
	CorporateEntityCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORCE.ImportKey,
	ORCE.OriginatingRegionCorporateEntityId,
	ORCE.GlobalRegionId,
	ORCE.CorporateEntityCode,
	ORCE.SourceCode,
	ORCE.InsertedDate,
	ORCE.UpdatedDate,
	ORCE.IsDeleted	
FROM
	Gdm.OriginatingRegionCorporateEntity ORCE
	INNER JOIN Gdm.OriginatingRegionCorporateEntityActive (@DataPriorToDate) ORCEA ON
		ORCEA.ImportKey = ORCE.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionCorporateEntity (CorporateEntityCode, SourceCode, IsDeleted, GlobalRegionId)

PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- #OriginatingRegionPropertyDepartment

CREATE TABLE #OriginatingRegionPropertyDepartment( -- GDM 2.0 addition
	ImportKey INT NOT NULL,
	OriginatingRegionPropertyDepartmentId INT NOT NULL,
	GlobalRegionId INT NOT NULL,
	PropertyDepartmentCode VARCHAR(10) NOT NULL,
	SourceCode CHAR(2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL	
)

INSERT INTO #OriginatingRegionPropertyDepartment(
	ImportKey,
	OriginatingRegionPropertyDepartmentId,
	GlobalRegionId,
	PropertyDepartmentCode,
	SourceCode,
	InsertedDate,
	UpdatedDate,
	IsDeleted
)
SELECT
	ORPD.ImportKey,
	ORPD.OriginatingRegionPropertyDepartmentId,
	ORPD.GlobalRegionId,
	ORPD.PropertyDepartmentCode,
	ORPD.SourceCode,
	ORPD.InsertedDate,
	ORPD.UpdatedDate,
	ORPD.IsDeleted
FROM
	Gdm.OriginatingRegionPropertyDepartment ORPD
	INNER JOIN Gdm.OriginatingRegionPropertyDepartmentActive(@DataPriorToDate) ORPDA ON
		ORPDA.ImportKey = ORPD.ImportKey

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #OriginatingRegionPropertyDepartment (PropertyDepartmentCode, SourceCode, IsDeleted, GlobalRegionId)

PRINT 'Completed inserting records into #OriginatingRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Allocation Region Mappings

CREATE TABLE #AllocationSubRegion(
	ImportKey INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	Code VARCHAR(10) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	ProjectCodePortion VARCHAR(2) NOT NULL,
	AllocationRegionGlobalRegionId INT NULL,
	DefaultCurrencyCode CHAR(3) NOT NULL,
	CountryId INT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

-- #AllocationSubRegion

INSERT INTO #AllocationSubRegion(
	ImportKey,
	AllocationSubRegionGlobalRegionId,
	Code,
	[Name],
	ProjectCodePortion,
	AllocationRegionGlobalRegionId,
	DefaultCurrencyCode,
	CountryId,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	ASR.ImportKey,
	ASR.AllocationSubRegionGlobalRegionId,
	ASR.Code,
	ASR.[Name],
	ASR.ProjectCodePortion,
	ASR.AllocationRegionGlobalRegionId,
	ASR.DefaultCurrencyCode,
	ASR.CountryId,
	ASR.IsActive,
	ASR.InsertedDate,
	ASR.UpdatedDate,
	ASR.UpdatedByStaffId
FROM
	Gdm.AllocationSubRegion ASR
	INNER JOIN	Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON
		ASRA.ImportKey = ASR.ImportKey

PRINT 'Completed inserting records into #AllocationRegionMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


------------------------------------------------------------------------------------------------------
--Source allocation records
------------------------------------------------------------------------------------------------------

-- Source payroll allocation

CREATE TABLE #BudgetEmployeePayrollAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	BudgetProjectGroupId INT NULL,
	Period INT NOT NULL,
	SalaryAllocationValue DECIMAL(18, 9) NOT NULL,
	BonusAllocationValue DECIMAL(18, 9) NULL,
	BonusCapAllocationValue DECIMAL(18, 9) NULL,
	ProfitShareAllocationValue DECIMAL(18, 9) NULL,
	PreTaxSalaryAmount DECIMAL(18, 2) NOT NULL,
	PreTaxBonusAmount DECIMAL(18, 2) NULL,
	PreTaxBonusCapExcessAmount DECIMAL(18, 2) NULL,
	PreTaxProfitShareAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetEmployeePayrollAllocationId INT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	BudgetProjectId,
	BudgetProjectGroupId,
	Period,
	SalaryAllocationValue,
	BonusAllocationValue,
	BonusCapAllocationValue,
	ProfitShareAllocationValue,
	PreTaxSalaryAmount,
	PreTaxBonusAmount,
	PreTaxBonusCapExcessAmount,
	PreTaxProfitShareAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetEmployeePayrollAllocationId
)
SELECT
	Allocation.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocation Allocation

	INNER JOIN TapasGlobalBudgeting.BudgetEmployeePayrollAllocationActive(@DataPriorToDate) AllocationA ON
		Allocation.ImportKey = AllocationA.ImportKey

	--data limiting join
	INNER JOIN #BudgetProject bp ON
		Allocation.BudgetProjectId = bp.BudgetProjectId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationId ON #BudgetEmployeePayrollAllocation (BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll tax detail
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Using the 'active' function here cause serious performance issues and the only way around it, was to extract the logic from the is active function 
--to seperate peaces of code.
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId int NOT NULL,
	ImportBatchId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetailBatches(
	BudgetEmployeePayrollAllocationDetailId,
	ImportBatchId
)
SELECT 
	B2.BudgetEmployeePayrollAllocationDetailId,
	MAX(B2.ImportBatchId) AS ImportBatchId
FROM 
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
		
	INNER JOIN Batch ON
		B2.ImportBatchId = batch.BatchId		
WHERE	
	batch.BatchEndDate IS NOT NULL AND
	batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
	batch.ImportEndDate <= @DataPriorToDate		
GROUP BY
	B2.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetailBatches:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE TABLE #BEPADa(
	ImportKey INT NOT NULL
)

INSERT INTO #BEPADa(
	ImportKey
)
SELECT
	MAX(B1.ImportKey) ImportKey
FROM
	[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

	INNER JOIN #BudgetEmployeePayrollAllocationDetailBatches t1 ON 
		t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
		t1.ImportBatchId = B1.ImportBatchId

GROUP BY
	B1.BudgetEmployeePayrollAllocationDetailId

PRINT 'Completed inserting records into #BEPADa:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #BudgetEmployeePayrollAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BenefitOptionId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetEmployeePayrollAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	BenefitOptionId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.*
FROM
	TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetail TaxDetail
	
	INNER JOIN #BEPADa TaxDetailA ON
		TaxDetail.ImportKey = TaxDetailA.ImportKey

	--data limiting join
	INNER JOIN #BudgetEmployeePayrollAllocation Allocation ON
		TaxDetail.BudgetEmployeePayrollAllocationId = Allocation.BudgetEmployeePayrollAllocationId

PRINT 'Completed inserting records into #BudgetEmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetEmployeePayrollAllocationDetailId ON #BudgetEmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetEmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source budget tax type

CREATE TABLE #BudgetTaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetTaxTypeId INT NOT NULL,
	BudgetId INT NOT NULL,
	TaxTypeId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetTaxTypeId INT NULL
)

INSERT INTO #BudgetTaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetTaxTypeId,
	BudgetId,
	TaxTypeId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	InsertedDate,
	UpdatedByStaffId,
	OriginalBudgetTaxTypeId
)
SELECT 
	BudgetTaxType.* 
FROM 
	TapasGlobalBudgeting.BudgetTaxType BudgetTaxType
	INNER JOIN TapasGlobalBudgeting.BudgetTaxTypeActive(@DataPriorToDate) BudgetTaxTypeA ON
		BudgetTaxType.ImportKey = BudgetTaxTypeA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		BudgetTaxType.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetTaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_BudgetTaxTypeId ON #BudgetTaxType (BudgetTaxTypeId)
PRINT 'Completed creating indexes on #BudgetTaxType'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source tax type

CREATE TABLE #TaxType(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	TaxTypeId INT NOT NULL,
	RegionId INT NOT NULL,
	FixedTaxTypeId INT NOT NULL,
	RateCalculationMethodId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL
)

INSERT INTO #TaxType(
	ImportKey,
	ImportBatchId,
	ImportDate,
	TaxTypeId,
	RegionId,
	FixedTaxTypeId,
	RateCalculationMethodId,
	Name,
	IsActive,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	MinorGlAccountCategoryId
)
SELECT 
	TaxType.*
FROM 
	TapasGlobalBudgeting.TaxType TaxType
	INNER JOIN TapasGlobalBudgeting.TaxTypeActive(@DataPriorToDate) TaxTypeA ON
		TaxType.ImportKey = TaxTypeA.ImportKey

PRINT 'Completed inserting records into #TaxType:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll allocation Tax detail
CREATE TABLE #EmployeePayrollAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	MinorGlAccountCategoryId INT NULL,
	BudgetTaxTypeId INT NULL,
	SalaryAmount DECIMAL(18, 2) NULL,
	BonusAmount DECIMAL(18, 2) NULL,
	ProfitShareAmount DECIMAL(18, 2) NULL,
	BonusCapExcessAmount DECIMAL(18, 2) NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #EmployeePayrollAllocationDetail
(
	ImportKey,
	BudgetEmployeePayrollAllocationDetailId,
	BudgetEmployeePayrollAllocationId,
	MinorGlAccountCategoryId,
	BudgetTaxTypeId,
	SalaryAmount,
	BonusAmount,
	ProfitShareAmount,
	BonusCapExcessAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	TaxDetail.ImportKey,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	TaxDetail.BudgetEmployeePayrollAllocationId,
	CASE WHEN (TaxDetail.BenefitOptionId IS NOT NULL) THEN @BenefitsMinorGlAccountCategoryId ELSE TaxType.MinorGlAccountCategoryId END AS MinorGlAccountCategoryId,
	TaxDetail.BudgetTaxTypeId,
	TaxDetail.SalaryAmount,
	TaxDetail.BonusAmount,
	TaxDetail.ProfitShareAmount,
	TaxDetail.BonusCapExcessAmount,
	TaxDetail.InsertedDate,
	TaxDetail.UpdatedDate,
	TaxDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetEmployeePayrollAllocation Allocation
	
	INNER JOIN #BudgetEmployeePayrollAllocationDetail TaxDetail ON
		Allocation.BudgetEmployeePayrollAllocationId = TaxDetail.BudgetEmployeePayrollAllocationId 
			
	LEFT OUTER JOIN #BudgetTaxType BudgetTaxType ON
		TaxDetail.BudgetTaxTypeId = BudgetTaxType.BudgetTaxTypeId
				
	LEFT OUTER JOIN #TaxType TaxType ON
		BudgetTaxType.TaxTypeId = TaxType.TaxTypeId	
			
PRINT 'Completed inserting records into #EmployeePayrollAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #EmployeePayrollAllocationDetail (BudgetEmployeePayrollAllocationDetailId,BudgetEmployeePayrollAllocationId)
PRINT 'Completed creating indexes on #EmployeePayrollAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

--*/
-- Source payroll overhead allocation

CREATE TABLE #BudgetOverheadAllocation(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetId INT NOT NULL,
	OverheadRegionId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	BudgetPeriod INT NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	OriginalBudgetOverheadAllocationId INT NULL
)

INSERT INTO #BudgetOverheadAllocation(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationId,
	BudgetId,
	OverheadRegionId,
	BudgetEmployeeId,
	BudgetPeriod,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId,
	OriginalBudgetOverheadAllocationId
)
SELECT
	OverheadAllocation.*
FROM
	TapasGlobalBudgeting.BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationActive(@DataPriorToDate) OverheadAllocationA ON
		OverheadAllocation.ImportKey = OverheadAllocationA.ImportKey

	-- data limiting join
	INNER JOIN #Budget b ON
		OverheadAllocation.BudgetId = b.BudgetId

PRINT 'Completed inserting records into #BudgetOverheadAllocation:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocation (BudgetOverheadAllocationId,BudgetId,OverheadRegionId,BudgetEmployeeId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocation'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source overhead allocation detail

CREATE TABLE #BudgetOverheadAllocationDetail(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #BudgetOverheadAllocationDetail(
	ImportKey,
	ImportBatchId,
	ImportDate,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT 
	OverheadDetail.*
FROM			
	TapasGlobalBudgeting.BudgetOverheadAllocationDetail OverheadDetail
	
	INNER JOIN TapasGlobalBudgeting.BudgetOverheadAllocationDetailActive(@DataPriorToDate) OverheadDetailA ON
		OverheadDetail.ImportKey = OverheadDetailA.ImportKey

	-- data limiting join
	INNER JOIN #BudgetProject b ON
		OverheadDetail.BudgetProjectId = b.BudgetProjectId

PRINT 'Completed inserting records into #BudgetOverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #BudgetOverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #BudgetOverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-- Source payroll overhead allocation detail

CREATE TABLE #OverheadAllocationDetail
(
	ImportKey INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	BudgetOverheadAllocationId INT NOT NULL,
	BudgetProjectId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	AllocationValue DECIMAL(18, 9) NOT NULL,
	AllocationAmount DECIMAL(18, 2) NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
)

INSERT INTO #OverheadAllocationDetail
(
	ImportKey,
	BudgetOverheadAllocationDetailId,
	BudgetOverheadAllocationId,
	BudgetProjectId,
	MinorGlAccountCategoryId,
	AllocationValue,
	AllocationAmount,
	InsertedDate,
	UpdatedDate,
	UpdatedByStaffId
)
SELECT
	OverheadDetail.ImportKey,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	OverheadDetail.BudgetOverheadAllocationId,
	OverheadDetail.BudgetProjectId,
	@OverheadMinorGlAccountCategoryId AS MinorGlAccountCategoryId,
	OverheadDetail.AllocationValue,
	OverheadDetail.AllocationAmount,
	OverheadDetail.InsertedDate,
	OverheadDetail.UpdatedDate,
	OverheadDetail.UpdatedByStaffId
FROM

	-- Joining on allocation to limit amount of data
	#BudgetOverheadAllocation OverheadAllocation
	
	INNER JOIN #BudgetOverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId 

PRINT 'Completed inserting records into #OverheadAllocationDetail:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_Clustered ON #OverheadAllocationDetail (BudgetOverheadAllocationId,BudgetOverheadAllocationDetailId)
PRINT 'Completed creating indexes on #OverheadAllocationDetail'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Map Data
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Calculate effective functional department

CREATE TABLE #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeeId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL
)

INSERT INTO #EffectiveFunctionalDepartment(
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeeId,
	FunctionalDepartmentId
)
SELECT 
	Allocation.BudgetEmployeePayrollAllocationId,
	Allocation.BudgetEmployeeId,
	(
		SELECT 
			EFD.FunctionalDepartmentId
		FROM 
			(
				SELECT 
					Allocation2.BudgetEmployeeId,
					MAX(EFD.EffectivePeriod) AS EffectivePeriod
				FROM
					#BudgetEmployeePayrollAllocation Allocation2

					INNER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
						Allocation2.BudgetEmployeeId = EFD.BudgetEmployeeId
				
				WHERE
					Allocation.BudgetEmployeePayrollAllocationId = Allocation2.BudgetEmployeePayrollAllocationId AND
					EFD.EffectivePeriod <= Allocation.Period
					  
				GROUP BY
					Allocation2.BudgetEmployeeId
			) EFDo
		
			LEFT OUTER JOIN #BudgetEmployeeFunctionalDepartment EFD ON
				EFD.BudgetEmployeeId = EFDo.BudgetEmployeeId AND
				EFD.EffectivePeriod = EFDo.EffectivePeriod
				
	 ) AS FunctionalDepartmentId
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId

PRINT 'Completed inserting records into #EffectiveFunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Pre Tax Amounts
CREATE TABLE #ProfitabilityPreTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod char(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryPreTaxAmount MONEY NOT NULL,
	ProfitSharePreTaxAmount MONEY NOT NULL,
	BonusPreTaxAmount MONEY NOT NULL,
	BonusCapExcessPreTaxAmount MONEY NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL
)
-- Insert original budget amounts
INSERT INTO #ProfitabilityPreTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryPreTaxAmount,
	ProfitSharePreTaxAmount,
	BonusPreTaxAmount,
	BonusCapExcessPreTaxAmount,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	Budget.BudgetId AS BudgetId,
	Budget.RegionId AS BudgetRegionId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	Allocation.BudgetEmployeePayrollAllocationId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,Allocation.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=0&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, Allocation.ImportKey) AS ReferenceCode,
	Allocation.Period AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(Allocation.PreTaxSalaryAmount,0) AS SalaryPreTaxAmount,
	ISNULL(Allocation.PreTaxProfitShareAmount, 0) AS ProfitSharePreTaxAmount,
	ISNULL(Allocation.PreTaxBonusAmount,0) AS BonusPreTaxAmount, 
	ISNULL(Allocation.PreTaxBonusCapExcessAmount,0) AS BonusCapExcessPreTaxAmount,
	ISNULL(EFD.FunctionalDepartmentId, -1),
	fd.GlobalCode AS FunctionalDepartmentCode, 
	CASE WHEN BudgetProject.IsTsCost = 0 THEN 1 ELSE 0 END AS Reimbursable,
	BudgetProject.ActivityTypeId,
	Att.ActivityTypeCode,
	ISNULL(CASE
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,
			
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	Allocation.UpdatedDate,
	fmrb.BudgetReportGroupPeriod
FROM
	#BudgetEmployeePayrollAllocation Allocation

	INNER JOIN #BudgetProject BudgetProject ON 
		Allocation.BudgetProjectId = BudgetProject.BudgetProjectId
			
	INNER JOIN  #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
			
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId 
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId

	LEFT OUTER JOIN #EffectiveFunctionalDepartment efd ON
		Allocation.BudgetEmployeePayrollAllocationId = efd.BudgetEmployeePayrollAllocationId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		efd.FunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN #BudgetEmployee BudgetEmployee ON
		Allocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId
		
	LEFT OUTER JOIN #Location Location ON 
		Location.LocationId = BudgetEmployee.LocationId
		
	LEFT OUTER JOIN #PayrollRegion OriginatingRegion ON 
		Location.ExternalSubRegionId = OriginatingRegion.ExternalSubRegionId AND
		Budget.RegionId = OriginatingRegion.RegionId

	INNER JOIN GrReporting.dbo.ActivityType Att ON Att.ActivityTypeId = BudgetProject.ActivityTypeId
	
WHERE
	Allocation.Period BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod
	--Change Control 1 : GC 2010-09-01
	--BudgetProject.ActivityTypeId <> 99 -- exclude Corporate Overhead

PRINT 'Completed inserting records into #ProfitabilityPreTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE INDEX IX_SalaryPreTaxAmount ON #ProfitabilityPreTaxSource (SalaryPreTaxAmount)
CREATE INDEX IX_ProfitSharePreTaxAmount ON #ProfitabilityPreTaxSource (ProfitSharePreTaxAmount)
CREATE INDEX IX_BonusPreTaxAmount ON #ProfitabilityPreTaxSource (BonusPreTaxAmount)
CREATE INDEX IX_BonusCapExcessPreTaxAmount ON #ProfitabilityPreTaxSource (BonusCapExcessPreTaxAmount)

PRINT 'Completed creating indexes on #ProfitabilityPreTaxSource'
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Tax Amounts

CREATE TABLE #ProfitabilityTaxSource
(
	BudgetId INT NOT NULL,
	BudgetRegionId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetEmployeePayrollAllocationId INT NOT NULL,
	BudgetEmployeePayrollAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	SalaryTaxAmount MONEY NOT NULL,
	ProfitShareTaxAmount MONEY NOT NULL,
	BonusTaxAmount MONEY NOT NULL,
	BonusCapExcessTaxAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	ActivityTypeCode VARCHAR(50) NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	BudgetReportGroupPeriod INT NOT NULL,
)
--/*
-- Insert original budget amounts
INSERT INTO #ProfitabilityTaxSource
(
	BudgetId,
	BudgetRegionId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetEmployeePayrollAllocationId,
	BudgetEmployeePayrollAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	SalaryTaxAmount,
	ProfitShareTaxAmount,
	BonusTaxAmount,
	BonusCapExcessTaxAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	ActivityTypeCode,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	BudgetReportGroupPeriod
)
SELECT 
	pts.BudgetId,
	pts.BudgetRegionId,
	pts.FirstProjectedPeriod,
	ISNULL(pts.ProjectId,0) AS ProjectId,
	ISNULL(pts.HrEmployeeId,0) AS HrEmployeeId,
	pts.BudgetEmployeePayrollAllocationId,
	TaxDetail.BudgetEmployeePayrollAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,pts.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(pts.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(pts.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=' + CONVERT(varchar,pts.BudgetEmployeePayrollAllocationId) + '&BudgetEmployeePayrollAllocationDetailId=' + CONVERT(varchar,TaxDetail.BudgetEmployeePayrollAllocationDetailId) + '&BudgetOverheadAllocationDetailId=0' + '&ImportKey=' + CONVERT(varchar, TaxDetail.ImportKey) AS ReferenceCode,
	pts.ExpensePeriod,
	pts.SourceCode,
	ISNULL(TaxDetail.SalaryAmount, 0) AS SalaryTaxAmount,
	ISNULL(TaxDetail.ProfitShareAmount, 0) AS ProfitShareTaxAmount,
	ISNULL(TaxDetail.BonusAmount, 0) AS BonusTaxAmount,
	ISNULL(TaxDetail.BonusCapExcessAmount, 0) AS BonusCapExcessTaxAmount,
	TaxDetail.MinorGlAccountCategoryId,
	ISNULL(pts.FunctionalDepartmentId, -1),
	pts.FunctionalDepartmentCode, 
	pts.Reimbursable,
	pts.ActivityTypeId,
	pts.ActivityTypeCode,
	pts.PropertyFundId,
	ISNULL(PF.AllocationSubRegionGlobalRegionId, -1) AS AllocationSubRegionGlobalRegionId,
	pts.OriginatingRegionCode,
	pts.OriginatingRegionSourceCode,
	pts.LocalCurrencyCode,
	pts.AllocationUpdatedDate,
	pts.BudgetReportGroupPeriod
FROM
	#EmployeePayrollAllocationDetail TaxDetail

	INNER JOIN #ProfitabilityPreTaxSource pts ON
		TaxDetail.BudgetEmployeePayrollAllocationId = pts.BudgetEmployeePayrollAllocationId
		
	LEFT OUTER JOIN #PropertyFund PF ON
		pts.PropertyFundId = PF.PropertyFundId

PRINT 'Completed inserting records into #ProfitabilityTaxSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

--Map Overhead Amounts

CREATE TABLE #ProfitabilityOverheadSource
(
	BudgetId INT NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ProjectId INT NOT NULL,
	HrEmployeeId INT NOT NULL,
	BudgetOverheadAllocationDetailId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	OverheadAllocationAmount MONEY NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	OverheadUpdatedDate DATETIME NOT NULL
)
-- Insert original overhead amounts
INSERT INTO #ProfitabilityOverheadSource
(
	BudgetId,
	FirstProjectedPeriod,
	ProjectId,
	HrEmployeeId,
	BudgetOverheadAllocationDetailId,
	ReferenceCode,
	ExpensePeriod,
	SourceCode,
	OverheadAllocationAmount,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,	
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	OverheadUpdatedDate
)
SELECT
	Budget.BudgetId AS BudgetId,
	Budget.FirstProjectedPeriod,
	ISNULL(BudgetProject.ProjectId,0) AS ProjectId,
	ISNULL(BudgetEmployee.HrEmployeeId,0) AS HrEmployeeId,
	OverheadDetail.BudgetOverheadAllocationDetailId,
	'TGB:BudgetId=' + CONVERT(varchar,Budget.BudgetId) + '&ProjectId=' + CONVERT(varchar,ISNULL(BudgetProject.ProjectId,0)) + '&HrEmployeeId=' + CONVERT(varchar,ISNULL(BudgetEmployee.HrEmployeeId,0)) + '&BudgetEmployeePayrollAllocationId=0&BudgetEmployeePayrollAllocationDetailId=0' + '&BudgetOverheadAllocationDetailId=' + CONVERT(varchar,OverheadDetail.BudgetOverheadAllocationDetailId) + '&ImportKey=' + CONVERT(varchar, OverheadDetail.ImportKey) AS ReferenceCode,
	OverheadAllocation.BudgetPeriod AS ExpensePeriod,
	SourceRegion.SourceCode,
	ISNULL(OverheadDetail.AllocationAmount,0) AS OverheadAllocationAmount,
	OverheadDetail.MinorGlAccountCategoryId,
	ISNULL(RegionExtended.OverheadFunctionalDepartmentId, -1) AS FunctionalDepartmentId,
	fd.GlobalCode AS FunctionalDepartmentCode, 
	
	CASE
		WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
			CASE
				WHEN (BudgetProject.IsTsCost = 0) THEN -- Where ISTSCost is False the cost will be reimbursable
					1 
				ELSE
					0
			END
		ELSE
			0  --Where the BudgetProject.OverheadAllocationProjectID is populated: non-reimbursable
	END AS Reimbursable,
	
	BudgetProject.ActivityTypeId,
	
	CASE WHEN (BudgetProject.AllocateOverheadsProjectId IS NULL OR BudgetProject.AllocateOverheadsProjectId = 0) THEN 
		ISNULL(CASE WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE 
					DepartmentPropertyFund.PropertyFundId 
				END, -1) 
	ELSE 
		ISNULL(OverheadPropertyFund.PropertyFundId, -1) 
	END AS PropertyFundId,
	
	ISNULL(CASE -- Same case logic as above
				WHEN (BudgetProject.CorporateDepartmentCode = '@' OR BudgetProject.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,		
	
	OriginatingRegion.CorporateEntityRef,
	OriginatingRegion.CorporateSourceCode,
	Budget.CurrencyCode AS LocalCurrencyCode,
	OverheadDetail.UpdatedDate

FROM
	#BudgetOverheadAllocation OverheadAllocation 

	INNER JOIN #BudgetEmployee BudgetEmployee ON
		OverheadAllocation.BudgetEmployeeId = BudgetEmployee.BudgetEmployeeId

	INNER JOIN #OverheadAllocationDetail OverheadDetail ON
		OverheadAllocation.BudgetOverheadAllocationId = OverheadDetail.BudgetOverheadAllocationId
			
	INNER JOIN #BudgetProject BudgetProject ON 
		OverheadDetail.BudgetProjectId = BudgetProject.BudgetProjectId
		
	INNER JOIN #FilteredModifiedReportBudget fmrb ON
		BudgetProject.BudgetId = fmrb.BudgetId
		
	INNER JOIN #Budget Budget ON 
		fmrb.BudgetId = Budget.BudgetId
		
	LEFT OUTER JOIN #Region SourceRegion ON 
		Budget.RegionId = SourceRegion.RegionId
		
	LEFT OUTER JOIN #RegionExtended RegionExtended ON 
		SourceRegion.RegionId = RegionExtended.RegionId

	LEFT OUTER JOIN #FunctionalDepartment fd ON 
		RegionExtended.OverheadFunctionalDepartmentId = fd.FunctionalDepartmentId

	LEFT OUTER JOIN	#Project OverheadProject ON
		BudgetProject.AllocateOverheadsProjectId = OverheadProject.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		BudgetProject.PropertyFundId = ProjectPropertyFund.PropertyFundId
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON GrSc.SourceCode = BudgetProject.CorporateSourceCode
	
	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		BudgetProject.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		BudgetProject.CorporateSourceCode = pfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(pfm.ActivityTypeId, -1) AND 
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		RECD.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(BudgetProject.CorporateDepartmentCode)) AND
		REPE.SourceCode = BudgetProject.CorporateSourceCode AND
		fmrb.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	
	
	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO ON GrScO.SourceCode = OverheadProject.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping opfm ON
		OverheadProject.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
		OverheadProject.CorporateSourceCode = opfm.SourceCode AND
		--ISNULL(BudgetProject.ActivityTypeId, -1) = ISNULL(opfm.ActivityTypeId, -1) AND 
		opfm.IsDeleted = 0 AND 
		(
			(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = BudgetProject.ActivityTypeId)
				OR
				(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND BudgetProject.ActivityTypeId IS NULL)
			)
		) AND
		fmrb.BudgetReportGroupPeriod < 201007
	
	LEFT OUTER JOIN #PropertyFund OverheadPropertyFund ON
		OverheadPropertyFund.PropertyFundId =	
			CASE
				WHEN fmrb.BudgetReportGroupPeriod < 201007 THEN opfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
	
	LEFT OUTER JOIN #OverheadRegion OriginatingRegion ON 
		OverheadAllocation.OverheadRegionId = OriginatingRegion.OverheadRegionId
		
WHERE
	OverheadAllocation.BudgetPeriod BETWEEN fmrb.BudgetFirstProjectedPeriod AND fmrb.GroupEndPeriod
		
PRINT 'Completed inserting records into #ProfitabilityOverheadSource:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Generate mapping records
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


CREATE TABLE #ProfitabilityPayrollMapping
(
	BudgetId INT NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	FirstProjectedPeriod CHAR(6) NOT NULL,
	ExpensePeriod CHAR(6) NOT NULL,	
	SourceCode VARCHAR(2) NULL,
	BudgetAmount MONEY NOT NULL,
	MajorGlAccountCategoryId INT NOT NULL,
	MinorGlAccountCategoryId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	FunctionalDepartmentCode VARCHAR(31) NULL,
	Reimbursable BIT NOT NULL,
	FeeOrExpense  Varchar(20) NOT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	OriginatingRegionCode CHAR(6) NULL,
	OriginatingRegionSourceCode VARCHAR(2) NULL,
	LocalCurrencyCode CHAR(3) NOT NULL,
	AllocationUpdatedDate DATETIME NOT NULL,
	GLAccountSubTypeIdGlobal INT NOT NULL,
	GlobalGlAccountCode Varchar(10) NULL
)

INSERT INTO #ProfitabilityPayrollMapping
(
	BudgetId,
	ReferenceCode,
	FirstProjectedPeriod,
	ExpensePeriod,
	SourceCode,
	BudgetAmount,
	MajorGlAccountCategoryId,
	MinorGlAccountCategoryId,
	FunctionalDepartmentId,
	FunctionalDepartmentCode,
	Reimbursable,
	FeeOrExpense,
	ActivityTypeId,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	OriginatingRegionCode,
	OriginatingRegionSourceCode,
	LocalCurrencyCode,
	AllocationUpdatedDate,
	GLAccountSubTypeIdGlobal,
	GlobalGlAccountCode
)
-- Get Base Salary Payroll pre tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryPreTax' AS ReferenceCode,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BaseSalaryMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.SalaryPreTaxAmount <> 0

-- Get Profit Share Benefit pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitSharePreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitSharePreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@ProfitShareMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitSharePreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.ProfitSharePreTaxAmount <> 0

-- Get Bonus pre tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusPreTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
WHERE
	pps.BonusPreTaxAmount <> 0

--Get bonus cap pre tax mappings
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessPreTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessPreTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	@BonusMinorGlAccountCategoryId AS MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessPreTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,

	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityPreTaxSource pps
	
	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'
		
	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId
			
	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId
		
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0

	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0	

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END
		
WHERE
	pps.BonusCapExcessPreTaxAmount <> 0

UNION ALL

-- Get Base Salary Payroll Tax mappings and budget
SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=SalaryTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.SalaryTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'SalaryTaxTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.SalaryTaxAmount <> 0

-- Get Profit Share Benefit Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=ProfitShareTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.ProfitShareTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'ProfitShareTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.ProfitShareTaxAmount <> 0

-- Get Bonus Tax mappings and budget
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	pps.Reimbursable,  
	'BonusTax' FeeOrExpense,
	pps.ActivityTypeId,
	pps.PropertyFundId,
	pps.AllocationSubRegionGlobalRegionId,
	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps
WHERE
	pps.BonusTaxAmount <> 0

-- Get Bonus cap Tax mappings 
UNION ALL

SELECT
	pps.BudgetId,
	pps.ReferenceCode + '&Type=BonusCapExcessTax' AS ReferenceCod,
	pps.FirstProjectedPeriod,
	pps.ExpensePeriod,
	pps.SourceCode,
	pps.BonusCapExcessTaxAmount AS BudgetAmount,
	@SalariesTaxesBenefitsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pps.MinorGlAccountCategoryId, 
	pps.FunctionalDepartmentId,
	pps.FunctionalDepartmentCode,
	0 AS Reimbursable, -- Always Non-reimbursable for bunus cap amounts 
	'BonusCapExcessTax' FeeOrExpense,
	ISNULL(p.ActivityTypeId, -1) AS ActivityTypeId,
	
	ISNULL(CASE
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.PropertyFundId
				ELSE
					DepartmentPropertyFund.PropertyFundId 
			END, -1) AS PropertyFundId,
	-- Same case logic AS above

	ISNULL(CASE -- Same case logic as above
				WHEN (p.CorporateDepartmentCode = '@' OR p.CorporateDepartmentCode IS NULL) THEN 
					ProjectPropertyFund.AllocationSubRegionGlobalRegionId
				ELSE 
					DepartmentPropertyFund.AllocationSubRegionGlobalRegionId
			END, -1) AS AllocationSubRegionGlobalRegionId,

	pps.OriginatingRegionCode,
	pps.OriginatingRegionSourceCode,
	pps.LocalCurrencyCode,
	pps.AllocationUpdatedDate,
	--GC :: Change Control 1
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' 
		THEN  (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL')
		ELSE (Select GLAccountSubTypeId From #GLAccountCategoryTranslationsPayroll Where GLTranslationSubTypeCode = 'GL')
		END GLAccountSubTypeId,
	--General Allocated Overhead Account :: CC8
	CASE WHEN pps.ActivityTypeCode = 'CORPOH' THEN
		'50029500'+RIGHT('0'+LTRIM(STR(pps.ActivityTypeId,3,0)),2)
	ELSE
		NULL
	END as GlobalGlAccountCode
FROM
	#ProfitabilityTaxSource pps

	LEFT OUTER JOIN #SystemSettingRegion ssr ON
		pps.SourceCode = ssr.SourceCode AND
		pps.BudgetRegionId = ssr.RegionId AND
		ssr.SystemSettingName = 'BonusCapExcess'

	LEFT OUTER JOIN #Project p ON
		ssr.BonusCapExcessProjectId = p.ProjectId

	LEFT OUTER JOIN #PropertyFund ProjectPropertyFund ON
		p.PropertyFundId = ProjectPropertyFund.PropertyFundId

	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		GrSc.SourceCode = p.CorporateSourceCode

	LEFT OUTER JOIN #PropertyFundMapping pfm ON
		p.CorporateDepartmentCode = pfm.PropertyFundCode AND -- Combination of entity and corporate department
		p.CorporateSourceCode = pfm.SourceCode AND
		pfm.IsDeleted = 0 AND 
		(
			(GrSc.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
			OR
			(
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId = p.ActivityTypeId)
				OR
				(GrSc.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND p.ActivityTypeId IS NULL)
			)
		) AND
		pps.BudgetReportGroupPeriod < 201007

	LEFT OUTER JOIN	#ReportingEntityCorporateDepartment RECD ON
		GrSc.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
		RECD.CorporateDepartmentCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		RECD.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND			   
		RECD.IsDeleted = 0
		   
	LEFT OUTER JOIN #ReportingEntityPropertyEntity REPE ON
		GrSc.IsProperty = 'YES' AND -- only property MRIs resolved through this
		REPE.PropertyEntityCode = LTRIM(RTRIM(p.CorporateDepartmentCode)) AND
		REPE.SourceCode = p.CorporateSourceCode AND
		pps.BudgetReportGroupPeriod >= 201007 AND
		REPE.IsDeleted = 0

	LEFT OUTER JOIN #PropertyFund DepartmentPropertyFund ON
		DepartmentPropertyFund.PropertyFundId =
			CASE
				WHEN pps.BudgetReportGroupPeriod < 201007 THEN pfm.PropertyFundId
				ELSE
					CASE
						WHEN GrSc.IsCorporate = 'YES' THEN RECD.PropertyFundId
						ELSE REPE.PropertyFundId
					END
			END

WHERE
	pps.BonusCapExcessTaxAmount <> 0
	
-- Get Overhead mappings	
UNION ALL

SELECT
	pos.BudgetId,
	pos.ReferenceCode + '&Type=OverheadAllocation' AS ReferenceCod,
	pos.FirstProjectedPeriod,
	pos.ExpensePeriod,
	pos.SourceCode,
	pos.OverheadAllocationAmount AS BudgetAmount,
	@OccupancyCostsMajorGlAccountCategoryId AS MajorGlAccountCategoryId,
	pos.MinorGlAccountCategoryId, 
	pos.FunctionalDepartmentId,
	pos.FunctionalDepartmentCode,
	pos.Reimbursable,  
	'Overhead' FeeOrExpense,
	pos.ActivityTypeId,
	pos.PropertyFundId,
	pos.AllocationSubRegionGlobalRegionId,
	pos.OriginatingRegionCode,
	pos.OriginatingRegionSourceCode,
	pos.LocalCurrencyCode,
	pos.OverheadUpdatedDate,
	(Select GLAccountSubTypeId From #GLAccountCategoryTranslationsOverhead Where GLTranslationSubTypeCode = 'GL'),
	--General Allocated Overhead Account :: CC8
	'50029500'+RIGHT('0'+LTRIM(STR(pos.ActivityTypeId,3,0)),2) as GlobalGlAccountCode
FROM
	#ProfitabilityOverheadSource pos
WHERE
	pos.OverheadAllocationAmount <> 0

PRINT 'Completed inserting records into #ProfitabilityPayrollMapping:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_AllocationUpdatedDate ON #ProfitabilityPayrollMapping(ReferenceCode,AllocationUpdatedDate)
PRINT 'Completed creating indexes on #ProfitabilityPayrollMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Map mapped source data into the "REAL" fact table
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------------------------------------------------------------------------------------------------
-- Map to the fact
------------------------------------------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #ProfitabilityReforecast(
	CalendarKey INT NOT NULL,
	ReforecastKey INT NOT NULL,
	GlAccountKey INT NOT NULL,
	SourceKey INT NOT NULL,
	FunctionalDepartmentKey INT NOT NULL,
	ReimbursableKey INT NOT NULL,
	ActivityTypeKey INT NOT NULL,
	PropertyFundKey INT NOT NULL,	
	AllocationRegionKey INT NOT NULL,
	OriginatingRegionKey INT NOT NULL,
	OverheadKey INT NOT NULL,
	LocalCurrencyKey INT NOT NULL,
	LocalReforecast MONEY NOT NULL,
	ReferenceCode VARCHAR(300) NOT NULL,
	BudgetId INT NOT NULL,
	SourceSystemId INT NOT NULL,
	
	EUCorporateGlAccountCategoryKey INT NULL,
	EUPropertyGlAccountCategoryKey INT NULL,
	EUFundGlAccountCategoryKey INT NULL,

	USPropertyGlAccountCategoryKey INT NULL,
	USCorporateGlAccountCategoryKey INT NULL,
	USFundGlAccountCategoryKey INT NULL,

	GlobalGlAccountCategoryKey INT NULL,
	DevelopmentGlAccountCategoryKey INT NULL
) 

INSERT INTO #ProfitabilityReforecast 
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId
)
SELECT
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.ExpensePeriod,4)+'-'+RIGHT(pbm.ExpensePeriod,2)+'-01') AS CalendarKey,
	DATEDIFF(dd, '1900-01-01', LEFT(pbm.FirstProjectedPeriod,4)+'-'+RIGHT(pbm.FirstProjectedPeriod,2)+'-01') AS ReforecastKey,
	CASE WHEN GrGa.GlAccountKey IS NULL THEN @GlAccountKeyUnknown ELSE GrGa.GlAccountKey END GlAccountKey,
	CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKeyUnknown ELSE GrSc.[SourceKey] END SourceKey,
	CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKeyUnknown ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey,
	CASE WHEN GrRi.ReimbursableCode IS NULL THEN @ReimbursableKeyUnknown ELSE GrRi.ReimbursableKey END ReimbursableKey,
	CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKeyUnknown ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey,
	CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKeyUnknown ELSE GrPf.[PropertyFundKey] END PropertyFundKey,
	CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKeyUnknown ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey,
	CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKeyUnknown ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey,
	CASE WHEN GrOh.[OverheadKey] IS NULL THEN @OverheadKeyUnknown ELSE GrOh.[OverheadKey] END OverheadKey,
	CASE WHEN GrCu.[CurrencyKey] IS NULL THEN @LocalCurrencyKeyUnknown ELSE GrCu.[CurrencyKey] END LocalCurrencyKey,
	pbm.BudgetAmount,
	pbm.ReferenceCode,
	pbm.BudgetId,
	@SourceSystemId
FROM
	#ProfitabilityPayrollMapping pbm
	
	LEFT OUTER JOIN GrReporting.dbo.[Source] GrSc ON
		pbm.SourceCode = GrSc.SourceCode

	LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa ON
		GrGa.Code = pbm.GlobalGlAccountCode AND
		pbm.AllocationUpdatedDate BETWEEN GrGa.StartDate AND GrGa.EndDate
		
	--Parent Level (No job code for payroll)
	LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm ON
		GrFdm.ReferenceCode LIKE pbm.FunctionalDepartmentCode +':%' AND
		pbm.AllocationUpdatedDate BETWEEN GrFdm.StartDate AND GrFdm.EndDate AND
		GrFdm.SubFunctionalDepartmentCode = GrFdm.FunctionalDepartmentCode

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
		CASE WHEN pbm.Reimbursable = 1 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode

	LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt ON
		pbm.ActivityTypeId = GrAt.ActivityTypeId AND
		pbm.AllocationUpdatedDate BETWEEN GrAt.StartDate AND GrAt.EndDate

	LEFT OUTER JOIN GrReporting.dbo.Overhead GrOh ON
		--GC :: Change Control 1
		GrOh.OverheadCode = CASE WHEN pbm.FeeOrExpense = 'Overhead' THEN 'ALLOC' 
									WHEN GrAt.ActivityTypeCode = 'CORPOH' THEN 'UNALLOC' 
									ELSE 'UNKNOWN' END
									
	LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf ON
		pbm.PropertyFundId = GrPf.PropertyFundId AND
		pbm.AllocationUpdatedDate BETWEEN GrPf.StartDate AND GrPf.EndDate

	-- HACK: At some point tapas was supposed to pull project region out of GDM. 
	-- Now allocation regions are source based??? So I use the code because it is built up from the ProjectRegionId since there is only data for one source anyway.
	-- I don't check source because actuals also don't check source. 
	--LEFT OUTER JOIN #AllocationRegionMapping Arm ON
	--	Arm.RegionCode = pbm.ProjectRegionId AND -- TODO: Pull the RegionCode through from the top.
	--	Arm.IsDeleted = 0
	
	LEFT OUTER JOIN #AllocationSubRegion ASR ON
		pbm.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId		

	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		ASR.AllocationSubRegionGlobalRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate

/* -- At some point Allocation region in GDM was going to become the master list
	LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
		pbm.ProjectRegionId = GrAr.GlobalRegionId AND
		pbm.AllocationUpdatedDate BETWEEN GrAr.StartDate AND GrAr.EndDate
*/

	--LEFT OUTER JOIN #OriginatingRegionMapping Orm ON
	--	Orm.RegionCode = CASE WHEN RIGHT(pbm.OriginatingRegionSourceCode,1) = 'C' THEN LTRIM(RTRIM(pbm.OriginatingRegionCode))
	--							ELSE LTRIM(RTRIM(pbm.OriginatingRegionCode)) + LTRIM(RTRIM(pbm.FunctionalDepartmentCode)) END AND
	--	Orm.SourceCode = pbm.OriginatingRegionSourceCode AND
	--	Orm.IsDeleted = 0
		
	LEFT OUTER JOIN #OriginatingRegionCorporateEntity ORCE ON
		ORCE.CorporateEntityCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORCE.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORCE.IsDeleted = 0
		   
	LEFT OUTER JOIN #OriginatingRegionPropertyDepartment ORPD ON
		ORPD.PropertyDepartmentCode = LTRIM(RTRIM(pbm.OriginatingRegionCode)) AND
		ORPD.SourceCode = pbm.OriginatingRegionSourceCode AND
		ORPD.IsDeleted = 0			
		
	LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		GrOr.GlobalRegionId = ISNULL(ORCE.GlobalRegionId, ORPD.GlobalRegionId) AND
		pbm.AllocationUpdatedDate BETWEEN GrOr.StartDate AND GrOr.EndDate
	
	LEFT OUTER JOIN GrReporting.dbo.Currency GrCu ON
		pbm.LocalCurrencyCode = GrCu.CurrencyCode 

PRINT 'Completed inserting records into #ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE UNIQUE CLUSTERED INDEX IX_Clustered ON #ProfitabilityReforecast (ReferenceCode)
CREATE INDEX IX_CalendarKey ON #ProfitabilityReforecast (CalendarKey)

PRINT 'Completed creating indexes on #OriginatingRegionMapping'
PRINT CONVERT(Varchar(27), getdate(), 121)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Remove existing data for modified budget projects
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #DeletingBudget
(
	BudgetId INT NOT NULL
)

INSERT INTO #DeletingBudget
(
	BudgetId
)
SELECT DISTINCT 
	BudgetId
FROM
	#Budget

DECLARE @BudgetId INT = -1
DECLARE @LoopCount INT = 0 -- Infinite loop safe guard

WHILE (EXISTS (SELECT TOP 1 BudgetId FROM #DeletingBudget) AND @LoopCount < 100000)
BEGIN
	
	SET @LoopCount = @LoopCount + 1
	SET @BudgetId = (SELECT TOP 1 BudgetId FROM #DeletingBudget)


	DECLARE @row Int = 1
	DECLARE @deleteCnt Int = 0
	WHILE (@row > 0)
		BEGIN
		-- Remove old facts
		DELETE TOP (100000)
		FROM GrReporting.dbo.ProfitabilityReforecast 
		Where BudgetId = @BudgetId and SourceSystemId = @SourceSystemId
		
		SET @row = @@rowcount
		SET @deleteCnt = @deleteCnt + @row
		
		PRINT '>>>:'+CONVERT(char(10),@row)
		PRINT CONVERT(Varchar(27), getdate(), 121)
		
		END
		
	PRINT 'Rows Deleted from ProfitabilityReforecast:'+CONVERT(char(10),@deleteCnt)
	PRINT CONVERT(Varchar(27), getdate(), 121)
	
	

	DELETE FROM #DeletingBudget WHERE BudgetId = @BudgetId
END

print 'Cleaned up rows in ProfitabilityReforecast'

------------------------------------------------------------------------------------------------------
-- Map account categories
------------------------------------------------------------------------------------------------------

--GlobalGlAccountCategoryKey

CREATE TABLE #GlobalCategoryLookup(
	GlAccountCategoryKey INT NULL,
	ReferenceCode VARCHAR(300) NOT NULL
)

INSERT INTO #GlobalCategoryLookup(
	GlAccountCategoryKey,
	ReferenceCode
)
SELECT 
	GlAcGlobal.GlAccountCategoryKey,
	Gl.ReferenceCode
FROM
	(
		SELECT 
			GlAcHg.GLTranslationTypeId,
			GlAcHg.GLTranslationSubTypeId,
			Gl.MajorGlAccountCategoryId GLMajorCategoryId,
			Gl.MinorGlAccountCategoryId GLMinorCategoryId,
			GlAcHg.GLAccountTypeId,
			GlAcHg.GLAccountSubTypeId,
			Gl.AllocationUpdatedDate,
			Gl.ReferenceCode
		 FROM	
			#ProfitabilityPayrollMapping Gl				
			LEFT OUTER JOIN (
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslationsPayroll ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL'
							UNION ALL
							SELECT
								ACT.GLTranslationTypeId,
								ACT.GLTranslationSubTypeId,
								ACT.GLAccountTypeId,
								ACT.GLAccountSubTypeId
							FROM
								#GLAccountCategoryTranslationsOverhead ACT
							WHERE
								ACT.GLTranslationSubTypeCode = 'GL'

						) GlAcHg ON GlAcHg.GLAccountSubTypeId = Gl.GLAccountSubTypeIdGlobal
		 
		) Gl
															
		LEFT OUTER JOIN GrReporting.dbo.GlAccountCategory GlAcGlobal ON GlAcGlobal.GlobalGlAccountCategoryCode = 
			CONVERT(VARCHAR(32), LTRIM(STR(Gl.GLTranslationTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLTranslationSubTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMajorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLMinorCategoryId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountTypeId, 10, 0)) + ':' + 
								 LTRIM(STR(Gl.GLAccountSubTypeId, 10, 0)))

			AND Gl.AllocationUpdatedDate BETWEEN GlAcGlobal.StartDate AND GlAcGlobal.EndDate

CREATE UNIQUE CLUSTERED INDEX IX ON #GlobalCategoryLookup (ReferenceCode)

UPDATE
	#ProfitabilityReforecast
SET
	GlobalGlAccountCategoryKey = CASE WHEN t1.GlAccountCategoryKey IS NULL THEN @GlobalGlAccountCategoryKeyUnknown ELSE t1.GlAccountCategoryKey END
FROM
	#GlobalCategoryLookup t1
WHERE
	t1.ReferenceCode = #ProfitabilityReforecast.ReferenceCode

PRINT 'Completed converting all GlobalGlAccountCategoryKey keys:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


/*

This is where other Translation used to be and should be :: Gcloete

--EUCorporateGlAccountCategoryKey
--EUPropertyGlAccountCategoryKey
--EUFundGlAccountCategoryKey
--USPropertyGlAccountCategoryKey
--USCorporateGlAccountCategoryKey
--USFundGlAccountCategoryKey
--DevelopmentGlAccountCategoryKey
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Insert modified and new data 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

INSERT INTO GrReporting.dbo.ProfitabilityReforecast
(
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	EUCorporateGlAccountCategoryKey,
	EUPropertyGlAccountCategoryKey,
	EUFundGlAccountCategoryKey,

	USPropertyGlAccountCategoryKey,
	USCorporateGlAccountCategoryKey,
	USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	DevelopmentGlAccountCategoryKey
)
SELECT
	CalendarKey,
	ReforecastKey,
	GlAccountKey,
	SourceKey,
	FunctionalDepartmentKey,
	ReimbursableKey,
	ActivityTypeKey,
	PropertyFundKey,
	AllocationRegionKey,
	OriginatingRegionKey,
	OverheadKey,
	LocalCurrencyKey,
	LocalReforecast,
	ReferenceCode,
	BudgetId,
	SourceSystemId,
	
	@EUCorporateGlAccountCategoryKeyUnknown, --EUCorporateGlAccountCategoryKey,
	@EUPropertyGlAccountCategoryKeyUnknown, --EUPropertyGlAccountCategoryKey,
	@EUFundGlAccountCategoryKeyUnknown, --EUFundGlAccountCategoryKey,

	@USPropertyGlAccountCategoryKeyUnknown, --USPropertyGlAccountCategoryKey,
	@USCorporateGlAccountCategoryKeyUnknown, ----USCorporateGlAccountCategoryKey,
	@USFundGlAccountCategoryKeyUnknown, --USFundGlAccountCategoryKey,

	GlobalGlAccountCategoryKey,
	@DevelopmentGlAccountCategoryKeyUnknown --DevelopmentGlAccountCategoryKey
FROM 
	#ProfitabilityReforecast

print 'Rows Inserted in ProfitabilityReforecast:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Clean up
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP TABLE #SystemSettingRegion
DROP TABLE #GLTranslationType
DROP TABLE #GLTranslationSubType
DROP TABLE #GLMajorCategory
DROP TABLE #GLMinorCategory
DROP TABLE #GLAccountType
DROP TABLE #GLAccountSubType
DROP TABLE #GLAccountCategoryTranslationsPayroll
DROP TABLE #BudgetReportGroupDetail
DROP TABLE #BudgetReportGroup
DROP TABLE #BudgetReportGroupPeriod
DROP TABLE #BudgetStatus
DROP TABLE #AllActiveBudget
DROP TABLE #AllModifiedReportBudget
DROP TABLE #LockedModifiedReportGroup
DROP TABLE #FilteredModifiedReportBudget
DROP TABLE #Budget
DROP TABLE #BudgetProject
DROP TABLE #Region
DROP TABLE #BudgetEmployee
DROP TABLE #BudgetEmployeeFunctionalDepartment
DROP TABLE #FunctionalDepartment
DROP TABLE #PropertyFund
DROP TABLE #PropertyFundMapping
DROP TABLE #ReportingEntityCorporateDepartment
DROP TABLE #ReportingEntityPropertyEntity
DROP TABLE #Location
DROP TABLE #RegionExtended
DROP TABLE #PayrollRegion
DROP TABLE #OverheadRegion
DROP TABLE #Project
DROP TABLE #BudgetEmployeePayrollAllocation
DROP TABLE #BudgetEmployeePayrollAllocationDetailBatches
DROP TABLE #BEPADa
DROP TABLE #BudgetEmployeePayrollAllocationDetail
DROP TABLE #BudgetTaxType
DROP TABLE #TaxType
DROP TABLE #EmployeePayrollAllocationDetail
DROP TABLE #BudgetOverheadAllocation
DROP TABLE #BudgetOverheadAllocationDetail
DROP TABLE #OverheadAllocationDetail
DROP TABLE #EffectiveFunctionalDepartment
DROP TABLE #ProfitabilityPreTaxSource
DROP TABLE #ProfitabilityTaxSource
DROP TABLE #ProfitabilityOverheadSource
DROP TABLE #ProfitabilityPayrollMapping
DROP TABLE #OriginatingRegionCorporateEntity
DROP TABLE #OriginatingRegionPropertyDepartment
DROP TABLE #AllocationSubRegion
DROP TABLE #ProfitabilityReforecast
DROP TABLE #DeletingBudget
--DROP TABLE #EUCorpCategoryLookup
--DROP TABLE #EUPropCategoryLookup
--DROP TABLE #EUFundCategoryLookup
--DROP TABLE #USPropCategoryLookup
--DROP TABLE #USCorpCategoryLookup
--DROP TABLE #USFundCategoryLookup
DROP TABLE #GlobalCategoryLookup
--DROP TABLE #DevelCategoryLookup


GO




/****** Object:  StoredProcedure [dbo].[stp_I_ImportBatch]    Script Date: 10/20/2009 12:06:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_I_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_I_ImportBatch]
GO

CREATE PROCEDURE [dbo].[stp_I_ImportBatch]
	@PackageName		VARCHAR(100)
AS
	DECLARE @ImportStartDate DateTime
	DECLARE @ImportEndDate DateTime
	DECLARE @DataPriorToDate DateTime
	
	
IF 	@PackageName = 'ETL.Staging.TapasGlobalBudgeting'
	BEGIN
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'PayrollBudgetImportStartDate')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'PayrollBudgetImportEndDate')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'PayrollBudgetDataPriorToDate')
	
	
	END
ELSE IF @PackageName = 'ETL.Staging.BudgetingCorp'
	BEGIN
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'NonPayrollBudgetImportStartDate')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'NonPayrollBudgetImportEndDate')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'NonPayrollBudgetDataPriorToDate')
	
	END
ELSE
	BEGIN
	
	SET @ImportStartDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualImportStartDate')
	
	SET @ImportEndDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualImportEndDate')
							
	SET @DataPriorToDate = (SELECT Convert(DateTime,ConfiguredValue) 
							FROM dbo.SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate')
	END
	
	
	INSERT INTO Batch
	(
		PackageName,
		BatchStartDate,
		ImportStartDate,
		ImportEndDate,
		DataPriorToDate
	)
	VALUES
	(
		@PackageName,	/* PackageName	*/
		GetDate(),
		@ImportStartDate,
		@ImportEndDate,
		@DataPriorToDate
	)
	
	SELECT SCOPE_IDENTITY() AS BatchId

GO
