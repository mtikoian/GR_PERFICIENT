

/****** Object:  UserDefinedFunction [Gr].[GlobalGlAccountHieranchy]    Script Date: 10/01/2009 14:46:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetGlobalGlAccountCategoryHierarchy]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetGlobalGlAccountCategoryHierarchy]
GO

/****** Object:  UserDefinedFunction [Gr].[GlobalGlAccountHieranchy]    Script Date: 10/01/2009 14:46:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryHierarchy]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		DISTINCT 
		GlHg.Name HierarchyName,
		LTRIM(STR(GlH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+LTRIM(STR(GlH.MajorGlAccountCategoryId,10,0))+':'+LTRIM(STR(GlH.MinorGlAccountCategoryId,10,0)) as GlobalAccountCategoryCode,
		GlH.MajorGlAccountCategoryId,
		GlMa.Name MajorGlAccountCategoryName,
		GlH.MinorGlAccountCategoryId,
		GlMi.Name MinorGlAccountCategoryName,
		CASE WHEN GlH.AccountType LIKE '%EXP%' THEN 'EXPENSE' 
			WHEN GlH.AccountType LIKE '%INC%' THEN 'INCOME'
			ELSE 'UNKNOWN' END as FeeOrExpense,
		GlH.ExpenseType,
		MIN(GlH.InsertedDate) InsertedDate,
		MAX(GlH.UpdatedDate) UpdatedDate
			
	FROM	
			(
				SELECT GlH.*
				FROM
					Gdm.GlobalGlAccountCategoryHierarchy GlH
					INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHA ON GlHA.ImportKey = GlH.ImportKey
			) GlH
			
			INNER JOIN (
				SELECT GlHg.*
				FROM
					Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
					INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHgA ON GlHgA.ImportKey = GlHg.ImportKey
			) GlHg ON GlHg.GlobalGlAccountCategoryHierarchyGroupId = GlH.GlobalGlAccountCategoryHierarchyGroupId
			
			INNER JOIN (
				SELECT GlMa.*
				FROM
					Gdm.MajorGlAccountCategory GlMa
					INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) GlMaA ON GlMaA.ImportKey = GlMa.ImportKey
			) GlMa ON GlMa.MajorGlAccountCategoryId = GlH.MajorGlAccountCategoryId
			
			INNER JOIN (
				SELECT GlMi.*
				FROM
					Gdm.MinorGlAccountCategory GlMi
					INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) GlMiA ON GlMiA.ImportKey = GlMi.ImportKey
			) GlMi ON GlMi.MinorGlAccountCategoryId = GlH.MinorGlAccountCategoryId		
	GROUP BY 
		GlH.GlobalGlAccountCategoryHierarchyGroupId,
		GlHg.Name,
		GlH.MajorGlAccountCategoryId,
		GlMa.Name,
		GlH.MinorGlAccountCategoryId,
		GlMi.Name,
		GlH.AccountType,
		GlH.ExpenseType
		
	UNION ALL

	SELECT 
		GlHg.Name HierarchyName,
		LTRIM(STR(GlHg.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':-1:-1',
		-1,
		'UNKNOWN',
		-1,
		'UNKNOWN',
		'UNKNOWN',
		'UNKNOWN',
		'1900-01-01',
		'1900-01-01'
		
		FROM
			Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHgA ON GlHgA.ImportKey = GlHg.ImportKey
)

