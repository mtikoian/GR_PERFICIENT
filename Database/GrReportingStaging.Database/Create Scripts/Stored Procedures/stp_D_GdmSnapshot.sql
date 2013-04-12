USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_D_GdmSnapshot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_D_GdmSnapshot]
GO

USE [GrReportingStaging]
GO

/*********************************************************************************************************************
Description
	Deletes snapshot data from the GrReportingStaging database.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]


**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_D_GdmSnapshot]
	@SnapshotId INT
AS

BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------

-- Find all of the snapshot table names in GrReportingStaging

IF (@SnapshotId IS NULL)
BEGIN
	PRINT 'There is no snapshot to delete'
	RETURN
END

CREATE TABLE #AllSnapshotTables (
	TableName VARCHAR(128) NOT NULL
)

INSERT INTO #AllSnapshotTables (
	TableName
)
SELECT
	LTRIM(RTRIM(TABLE_NAME))
FROM
	INFORMATION_SCHEMA.TABLES
WHERE
	TABLE_TYPE = 'BASE TABLE' AND
	TABLE_SCHEMA = 'Gdm' AND
	LEFT(TABLE_NAME, 8) = 'Snapshot'

------------------------------------------------------------

DECLARE tableCursor CURSOR FOR SELECT TableName FROM #AllSnapshotTables
DECLARE @CurrentTableName VARCHAR(128)

OPEN tableCursor

FETCH NEXT FROM tableCursor
INTO @CurrentTableName

WHILE @@FETCH_STATUS = 0 -- Loop through all snapshot table names, and execute the delete statement on each of them
BEGIN

	DECLARE @Query VARCHAR(MAX) = '
	DELETE
		S
	FROM
		Gdm.[' + @CurrentTableName + '] S
	WHERE
		S.SnapshotId = ' + CONVERT(VARCHAR(3), @SnapshotId)

	EXEC(@Query)
	--PRINT(@Query)
	
	FETCH NEXT FROM tableCursor
	INTO @CurrentTableName

END

CLOSE tableCursor
DEALLOCATE tableCursor

END

GO
