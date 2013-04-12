
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReimbursableCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReimbursableCorporateDepartmentActive]
GO
/*
CREATE   FUNCTION [Gdm].[ReimbursableCorporateDepartmentActive]
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
	[Gdm].[ReimbursableCorporateDepartment] Gl1
		INNER JOIN (
		Select 
				ReimbursableCorporateDepartmentId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[ReimbursableCorporateDepartment]
		Where	UpdatedDate <= @DataPriorToDate
		Group By ReimbursableCorporateDepartmentId
		) t1 ON t1.ReimbursableCorporateDepartmentId = Gl1.ReimbursableCorporateDepartmentId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.ReimbursableCorporateDepartmentId	

RETURN 
END
*/
GO


