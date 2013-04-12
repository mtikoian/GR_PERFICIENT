-- Add SourceSystem entry for GBS

USE GrReporting
GO
 
IF NOT EXISTS (SELECT * FROM dbo.SourceSystem WHERE Name = 'Global Budgeting System')
BEGIN
	INSERT INTO dbo.SourceSystem (
		SourceSystemId,
		Name	
	)
	SELECT
		(SELECT MAX(SourceSystemId) FROM dbo.SourceSystem) + 1,
		'Global Budgeting System'
END
ELSE
BEGIN
	PRINT ('Cannot insert ''Global Budgeting System'' into GrReporting.dbo.SourceSystem because it already exists.')
END

----------------------------------