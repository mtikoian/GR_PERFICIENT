USE [GrReportingStaging]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHieranchyActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalGlAccountCategoryHieranchyActive]
GO
CREATE   FUNCTION [Gdm].[GlobalGlAccountCategoryHieranchyActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[GlobalGlAccountCategoryHieranchy] Gl1
		INNER JOIN (
		Select 
				GlobalGlAccountCategoryHieranchyId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[GlobalGlAccountCategoryHieranchy]
		Where	UpdatedDate <= @DataPriorToDate
		Group By GlobalGlAccountCategoryHieranchyId
		) t1 ON t1.GlobalGlAccountCategoryHieranchyId = Gl1.GlobalGlAccountCategoryHieranchyId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.GlobalGlAccountCategoryHieranchyId	

RETURN 
END

GO


