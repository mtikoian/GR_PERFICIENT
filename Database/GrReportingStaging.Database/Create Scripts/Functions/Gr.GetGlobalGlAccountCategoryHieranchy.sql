USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GlobalGlAccountHieranchy]    Script Date: 10/01/2009 14:46:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GlobalGlAccountCategoryHieranchyActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GlobalGlAccountCategoryHieranchyActive]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GlobalGlAccountHieranchy]    Script Date: 10/01/2009 14:46:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [Gr].[GlobalGlAccountCategoryHieranchyActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(
	GlobalAccountCategoryCode Varchar(21) NOT NULL,
	MajorGlAccountCategoryId Int NOT NULL,
	MajorGlAccountCategoryName Varchar(100) NOT NULL,
	MinorGlAccountCategoryId Int NOT NULL,
	MinorGlAccountCategoryName Varchar(100) NOT NULL,
	FeeOrExpense Varchar(10) NOT NULL,
	InsertedDate DateTime NOT NULL,
	UpdatedDate DateTime NOT NULL
	)
AS

BEGIN


INSERT Into @Result
(	GlobalAccountCategoryCode,
	MajorGlAccountCategoryId,
	MajorGlAccountCategoryName,
	MinorGlAccountCategoryId,
	MinorGlAccountCategoryName,
	FeeOrExpense,
	InsertedDate,
	UpdatedDate
)
Select 
	DISTINCT 
	LTRIM(STR(Gl.MajorGlAccountCategoryId,10,0))+':'+LTRIM(STR(Gl.MinorGlAccountCategoryId,10,0)),
	Gl.MajorGlAccountCategoryId,
	GlMa.Name MajorGlAccountCategoryName,
	Gl.MinorGlAccountCategoryId,
	GlMi.Name MinorGlAccountCategoryName,
	CASE WHEN Gl.AccountType LIKE '%EXP%' THEN 'EXPENSE' 
		WHEN Gl.AccountType LIKE '%INC%' THEN 'INCOME'
		ELSE 'UNKNOWN' END,
	MIN(Gl.InsertedDate) InsertedDate,
	MAX(Gl.UpdatedDate) UpdatedDate
		
From	(
			Select Gl.*
			From	Gdm.GlobalGlAccount Gl
				INNER JOIN Gdm.GlobalGlAccountActive(@DataPriorToDate) GlA ON GlA.ImportKey = Gl.ImportKey
		) Gl
		
		INNER JOIN (
			Select GlMa.*
			From	Gdm.MajorGlAccountCategory GlMa
				INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) GlMaA ON GlMaA.ImportKey = GlMa.ImportKey
		) GlMa ON GlMa.MajorGlAccountCategoryId = Gl.MajorGlAccountCategoryId
		
		INNER JOIN (
			Select GlMi.*
			From	Gdm.MinorGlAccountCategory GlMi
				INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) GlMiA ON GlMiA.ImportKey = GlMi.ImportKey
		) GlMi ON GlMi.MinorGlAccountCategoryId = Gl.MinorGlAccountCategoryId		
Group By 
	Gl.MajorGlAccountCategoryId,
	GlMa.Name,
	Gl.MinorGlAccountCategoryId,
	GlMi.Name,
	Gl.AccountType
			
RETURN 
END


GO

 