
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [TapasGlobal].[BillingUploadActive]
GO
CREATE FUNCTION [TapasGlobal].[BillingUploadActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[BillingUpload] Gl1
		INNER JOIN (
			SELECT 
				BillingUploadId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[BillingUpload]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BillingUploadId
		) t1 ON t1.BillingUploadId = Gl1.BillingUploadId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BillingUploadId	
)

GO
