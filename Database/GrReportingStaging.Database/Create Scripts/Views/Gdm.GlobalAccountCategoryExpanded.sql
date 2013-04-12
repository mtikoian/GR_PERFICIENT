USE [GrReportingStaging]
GO
/****** Object:  View [Gdm].[GlobalAccountCategoryExpanded]    Script Date: 09/01/2009 12:34:08 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAccountCategoryExpanded]'))
DROP VIEW [Gdm].[GlobalAccountCategoryExpanded]
GO
/*
CREATE VIEW [Gdm].[GlobalAccountCategoryExpanded]
AS
SELECT SubCat.[ImportKey]
      ,SubCat.[GlobalAccountCategoryId]
      ,Cat.[Name] AccountCategoryName
      ,CONVERT(DateTime,CONVERT(Varchar(23),Cat.[InsertedDate],120),120) InsertedDate
      ,CONVERT(DateTime,CONVERT(Varchar(23),CASE WHEN MAX(SubCat.[UpdatedDate]) < MAX(Cat.[UpdatedDate]) THEN MAX(Cat.[UpdatedDate]) ELSE MAX(SubCat.[UpdatedDate]) END,120),120)  UpdatedDate
      ,Cat.[IsGlobalSubAccountCategory]
      ,SubCat.[Name] SubCategoryName
      ,CASE WHEN SubCat.IsFee = 1 THEN 'Fee' WHEN SubCat.IsExpense = 1 THEN 'Expense' ELSE 'Other' END FeeOrExpense
  FROM [Gdm].[GlobalAccountCategory] Cat
		INNER JOIN [Gdm].[GlobalAccountCategory] SubCat ON SubCat.ParentGlobalAccountCategoryId = Cat.GlobalAccountCategoryId
GRoup By SubCat.[ImportKey]
      ,SubCat.[GlobalAccountCategoryId]
      ,Cat.[Name]
      ,Cat.[InsertedDate]
      ,Cat.[IsGlobalSubAccountCategory]
      ,SubCat.[Name]
      ,CASE WHEN SubCat.IsFee = 1 THEN 'Fee' WHEN SubCat.IsExpense = 1 THEN 'Expense' ELSE 'Other' END
UNION
SELECT Cat.[ImportKey]
      ,Cat.[GlobalAccountCategoryId]
      ,Cat.[Name] [AccountCategoryName]
      ,CONVERT(DateTime,CONVERT(Varchar(23),Cat.[InsertedDate],120),120)
      ,CONVERT(DateTime,CONVERT(Varchar(23),Cat.[UpdatedDate],120),120)
      ,Cat.[IsGlobalSubAccountCategory]
      ,NULL SubCategoryName
      ,CASE WHEN Cat.IsFee = 1 THEN 'Fee' WHEN Cat.IsExpense = 1 THEN 'Expense' ELSE 'Other' END FeeOrExpense
  FROM [Gdm].[GlobalAccountCategory] Cat
Where Cat.IsGlobalSubAccountCategory = 0
AND Cat.GlobalAccountCategoryId NOT IN (
	Select ParentGlobalAccountCategoryId 
	From [Gdm].[GlobalAccountCategory] Reg 
	Where Cat.IsGlobalSubAccountCategory = 1
)
*/
GO
