
USE [GrReportingStaging]
GO

/****** Object:  UserDefinedFunction [Gdm].[PropertyFundActive]    Script Date: 12/07/2009 13:52:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyFundActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[PropertyFundActive]
GO
CREATE   FUNCTION [Gdm].[PropertyFundActive]
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
	[Gdm].[PropertyFund] Gl1
		INNER JOIN (
		Select 
				PropertyFundId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[PropertyFund]
		Where	UpdatedDate <= @DataPriorToDate
		Group By PropertyFundId
		) t1 ON t1.PropertyFundId = Gl1.PropertyFundId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.PropertyFundId	

RETURN 
END

GO

