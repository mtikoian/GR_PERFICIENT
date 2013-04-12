USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GlobalGlAccountHieranchy]    Script Date: 10/01/2009 14:46:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GlobalGlAccountHieranchy]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GlobalGlAccountHieranchy]
GO

USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gr].[GlobalGlAccountHieranchy]    Script Date: 10/01/2009 14:46:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [Gr].[GlobalGlAccountHieranchy]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(GlobalGlAccountId Int NOT NULL,
	GlAccountCode char(12) NOT NULL,
	Name nvarchar(50) NOT NULL,
	MajorGlAccountCategoryId Int NOT NULL,
	MajorGlAccountCategoryName Varchar(100) NOT NULL,
	MinorGlAccountCategoryId Int NOT NULL,
	MinorGlAccountCategoryName Varchar(100) NOT NULL,
	InsertedDate DateTime NOT NULL,
	UpdatedDate DateTime NOT NULL
	)
AS

BEGIN


INSERT Into @Result
(	GlobalGlAccountId,
	GlAccountCode,
	Name,
	MajorGlAccountCategoryId,
	MajorGlAccountCategoryName,
	MinorGlAccountCategoryId,
	MinorGlAccountCategoryName,
	InsertedDate,
	UpdatedDate
)
Select 
	Gl.GlobalGlAccountId,
	Gl.GlAccountCode,
	Gl.Name,
	Gl.MajorGlAccountCategoryId,
	GlMa.Name MajorGlAccountCategoryName,
	Gl.MinorGlAccountCategoryId,
	GlMi.Name MinorGlAccountCategoryName,
	Gl.InsertedDate,
	Gl.UpdatedDate
		
From	(
			Select Gla.*
			From	Gdm.GlobalGlAccount Gla
				INNER JOIN Gdm.GlobalAccountCategoryActive(@DataPriorToDate) GlaA ON GlaA.ImportKey = Gla.ImportKey
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
		
RETURN 
END


GO

 