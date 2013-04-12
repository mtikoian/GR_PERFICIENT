
/****** Object:  StoredProcedure [dbo].[stp_U_ImportBatch]    Script Date: 10/20/2009 12:06:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_U_ImportBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_U_ImportBatch]
GO

CREATE PROCEDURE [dbo].[stp_U_ImportBatch]
	@BatchId INT
AS
	UPDATE 
		Batch
	SET 
	    BatchEndDate = GETDATE()
	WHERE BatchId=@BatchId

GO
