
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadDetailActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[BillingUploadDetailActive]
GO
CREATE FUNCTION [TapasGlobal].[BillingUploadDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[BillingUploadDetail] Gl1
		INNER JOIN (
			SELECT 
				BillingUploadDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[BillingUploadDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BillingUploadDetailId
		) t1 ON t1.BillingUploadDetailId = Gl1.BillingUploadDetailId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BillingUploadDetailId	
)

GO


