 CREATE PROCEDURE #AssertInt
	@Value INT,
	@ExpectedValue INT,
	@Error VARCHAR(250)
AS
BEGIN
	IF @Value <> @ExpectedValue
	BEGIN
		PRINT 'ERROR: ' + STR(@Value)
		RAISERROR (@Error, 16, 1)
	END	
END
GO
CREATE PROCEDURE #AssertBit
	@Value BIT,
	@ExpectedValue BIT,
	@Error VARCHAR(250) = '#AssertBit'
AS
BEGIN
	IF @Value <> @ExpectedValue
	BEGIN
		PRINT 'ERROR: ' + STR(@Value)
		RAISERROR (@Error, 16, 1)
	END	
END
GO
CREATE PROCEDURE #AssertVarchar
	@Value VARCHAR(250),
	@ExpectedValue VARCHAR(250),
	@Error VARCHAR(250)
AS
BEGIN
	IF @Value <> @ExpectedValue
	BEGIN
		PRINT 'ERROR: ' + @Value
		RAISERROR (@Error, 16, 1)
	END	
END

GO
CREATE PROCEDURE #RunPhase 
	@Phase VARCHAR(250)
AS
BEGIN

	DECLARE @TestName VARCHAR(250) 
	DECLARE @QryCursor CURSOR
	SET @QryCursor = CURSOR FOR
	SELECT TestName FROM #Tests WHERE Active = 1
	OPEN @QryCursor
	FETCH NEXT
	FROM @QryCursor INTO @TestName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @Qry VARCHAR(250)
		SET @Qry = N'EXEC ' + @TestName + '_' + @Phase
		PRINT @Qry			
		EXEC (@qry)
		
			
		FETCH NEXT
		FROM @QryCursor INTO @TestName
	END
	CLOSE @QryCursor
	DEALLOCATE @QryCursor
END
GO
CREATE PROCEDURE #RunTests
AS
BEGIN	
--	BEGIN TRAN
	EXEC #RunPhase 'setup'	
	PRINT '>>>>>>>>>>> Setup Success'
	EXEC #RunPhase 'test'	
	PRINT '>>>>>>>>>>> Tests Success'
	EXEC #RunPhase 'teardown'	
	PRINT '>>>>>>>>>>> Teardown Success'
--	ROLLBACK
END
GO
CREATE TABLE #Globals
(
	KeyName VARCHAR(250),
	IntValue INT
)
GO
CREATE PROCEDURE #SetGlobalInt
	@KeyName VARCHAR(250),
	@IntValue INT
AS
BEGIN
	DELETE FROM #Globals where KeyName = @KeyName
	INSERT INTO #Globals (KeyName, IntValue) VALUES (@KeyName, @IntValue)
END
GO

-----------------------------------------------------------------------------------------------------------------------------------
-------   TESTS BEGIN GLCategorization
-----------------------------------------------------------------------------------------------------------------------------------

-- #region ut_stp_IU_SyncSnapshotGLMinorCategory
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT GLMinorCategoryId FROM GDM.dbo.GLMinorCategory WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLMinorCategory Test data already exists', 16, 1)
	
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)	
	DECLARE @GLMajorCategoryId INT = (SELECT TOP 1 GLMajorCategoryId from GDM.dbo.GLMajorCategory WHERE Name = 'Legal & Professional Fees')
	IF @GLMajorCategoryId IS NULL
		RAISERROR ('Expect a valid MajorCategoryId', 16, 1)
		
	INSERT INTO Gdm.dbo.GLMinorCategory (GLMajorCategoryId,Name,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@GLMajorCategoryId,'Accounting & Tax99',0,'2010/07/24 04:42:12 AM','2010/07/24 04:42:12 AM',-1)
	
	DECLARE @GLMinorCategoryId INT = (SELECT @@Identity)
	IF @GLMinorCategoryId IS NULL
		RAISERROR ('GLMinorCategory could not initialise GLMinorCategoryId', 16, 1)
	
	EXEC [dbo].[stp_IU_SyncGLMinorCategory]
	
	INSERT INTO Gdm.dbo.SnapshotGLMinorCategory (SnapshotId, GLMinorCategoryId, GLMajorCategoryId,Name,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@SnapshotId, @GLMinorCategoryId, @GLMajorCategoryId,'Accounting & Tax99',0,'2010/07/24 04:42:12 AM','2010/07/24 04:42:12 AM',-1)	

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMinorCategory]
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLMinorCategory WHERE
			SnapshotId = @SnapshotId AND
			GLMajorCategoryId = @GLMajorCategoryId AND
			Name = 'Accounting & Tax99' AND
			IsActive = 0 AND
			InsertedDate = CONVERT(DATETIME, '2010/07/24 04:42:12 AM') AND
			UpdatedDate = CONVERT(DATETIME, '2010/07/24 04:42:12 AM') AND
			UpdatedByStaffId = -1 AND
			GLMinorCategoryId = @GLMinorCategoryId)
		RAISERROR ('GLMinorCategory Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotGLMinorCategory SET
			GLMajorCategoryId = @GLMajorCategoryId,
			Name = 'Accounting & Tax77',
			IsActive = 0,
			InsertedDate = '2010/07/24 04:42:12 AM',
			UpdatedDate = '2010/07/24 04:42:12 AM',
			UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLMinorCategoryId = @GLMinorCategoryId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMinorCategory]
	
   IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLMinorCategory WHERE
			SnapshotId = @SnapshotId AND
			GLMajorCategoryId = @GLMajorCategoryId AND
			Name = 'Accounting & Tax77' AND
			IsActive = 0 AND
			InsertedDate = CONVERT(DATETIME, '2010/07/24 04:42:12 AM') AND
			UpdatedDate = CONVERT(DATETIME, '2010/07/24 04:42:12 AM') AND
			UpdatedByStaffId = -1 AND

			GLMinorCategoryId = @GLMinorCategoryId)

		RAISERROR ('GLMinorCategory Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
		UPDATE 	Gdm_GR.dbo.SnapshotGLMinorCategory SET
			GLMajorCategoryId = @GLMajorCategoryId,
			Name = 'Accounting & Tax55',
			IsActive = 0,
			InsertedDate = '2010/07/24 04:42:12 AM',
			UpdatedDate = '2010/07/24 04:42:12 AM',
			UpdatedByStaffId = -1
		WHERE 
			GLMinorCategoryId = @GLMinorCategoryId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'GLMinorCategory Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMinorCategory]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
	 IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLMinorCategory WHERE
			SnapshotId = @SnapshotId AND
			GLMajorCategoryId = @GLMajorCategoryId AND
			Name = 'Accounting & Tax77' AND
			IsActive = 0 AND
			InsertedDate = CONVERT(DATETIME, '2010/07/24 04:42:12 AM') AND
			UpdatedDate = CONVERT(DATETIME, '2010/07/24 04:42:12 AM') AND
			UpdatedByStaffId = -1 AND
			GLMinorCategoryId = @GLMinorCategoryId)
		RAISERROR ('GLMinorCategory Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotGLMinorCategory WHERE GLMinorCategoryId = @GLMinorCategoryId AND SnapshotId = @SnapshotId
	
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMinorCategory]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGLMinorCategory  WHERE GLMinorCategoryId = @GLMinorCategoryId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'GLMinorCategory Expected DeActivated record'
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion ut_stp_IU_SyncSnapshotGLMinorCategory

-- #region ut_stp_IU_SyncSnapshotGLMajorCategory
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_test AS 
BEGIN 
	
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT GLMajorCategoryId FROM GDM.dbo.GLMajorCategory WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLMajorCategory Test data already exists', 16, 1)
		
	INSERT INTO Gdm.dbo.GLMajorCategory (GLCategorizationId,Name,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId, AllowCorporateDepartmentExceptions) 
	VALUES(233,'Interest Income2',0,'2010/07/24 04:41:19 AM','2010/07/24 04:41:19 AM',-1, 0)	
	DECLARE @GLMajorCategoryId INT = (SELECT @@Identity)
	IF @GLMajorCategoryId IS NULL
		RAISERROR ('GLMajorCategory could not initialise GLMajorCategoryId', 16, 1)
	
	EXEC	[dbo].[stp_IU_SyncGLMajorCategory]
	
	INSERT INTO Gdm.dbo.SnapshotGLMajorCategory (SnapshotId, GLMajorCategoryId, GLCategorizationId,Name,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId, AllowCorporateDepartmentExceptions) 
	VALUES(@SnapshotId, @GLMajorCategoryId, 233,'Interest Income2',0,'2010/07/24 04:41:19 AM','2010/07/24 04:41:19 AM',-1, 0)	

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMajorCategory]
	
	--SELECT * FROM Gdm_GR.dbo.GLMajorCategorY WHERE GLMajorCategoryId = @GLMajorCategoryId
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLMajorCategory WHERE
			SnapshotId = @SnapshotId AND
			GLMajorCategoryId = @GLMajorCategoryId AND
			GLTranslationSubTypeId = 233 AND
			Name = 'Interest Income2' AND
			IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:41:19 AM' AND
			--UpdatedDate = '2010/07/24 04:41:19 AM' AND
			UpdatedByStaffId = -1 AND
			GLMajorCategoryId = @GLMajorCategoryId)
		RAISERROR ('GLMajorCategory Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
			UPDATE Gdm.dbo.SnapshotGLMajorCategory SET
				GLCategorizationId = 233,
				Name = 'Interest Income3',
				IsActive = 0,
				InsertedDate = '2010/07/24 04:41:19 AM',
				UpdatedDate = '2010/07/24 04:41:19 AM',
				UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLMajorCategoryId = @GLMajorCategoryId AND
			SnapshotId = @SnapshotId
		 
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMajorCategory]
	
     IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLMajorCategory WHERE
			SnapshotId = @SnapshotId AND
			--GLMajorCategoryId = 1 AND
			GLTranslationSubTypeId = 233 AND
			Name = 'Interest Income3' AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:41:19 AM' AND
			--UpdatedDate = '2010/07/24 04:41:19 AM' AND
			UpdatedByStaffId = -1 AND
			GLMajorCategoryId = @GLMajorCategoryId)
		RAISERROR ('GLMajorCategory Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
		UPDATE Gdm_GR.dbo.SnapshotGLMajorCategory SET
				GLTranslationSubTypeId = 233,
				Name = 'Interest Income4',
				IsActive = 0,
				InsertedDate = '2010/07/24 04:41:19 AM',
				UpdatedDate = '2010/07/24 04:41:19 AM',
				UpdatedByStaffId = -1
		WHERE 
			GLMajorCategoryId = @GLMajorCategoryId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'GLMajorCategory Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMajorCategory]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
  IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLMajorCategory WHERE
			SnapshotId = @SnapshotId AND
			GLTranslationSubTypeId = 233 AND
			Name = 'Interest Income3' AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:41:19 AM' AND
			--UpdatedDate = '2010/07/24 04:41:19 AM' AND
			UpdatedByStaffId = -1 AND
			GLMajorCategoryId = @GLMajorCategoryId)
		RAISERROR ('GLMajorCategory Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotGLMajorCategory WHERE GLMajorCategoryId = @GLMajorCategoryId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLMajorCategory]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGLMajorCategory  WHERE GLMajorCategoryId = @GLMajorCategoryId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'GLMajorCategory Expected DeActivated record'
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncSnapshotGLMajorCategoryslationType

BEGIN TRAN


CREATE TABLE #Tests
(
	TestName VARCHAR(250)
)
INSERT #Tests (TestName)
SELECT '#ut_stp_IU_SyncSnapshotGLMajorCategory' 
EXEC #RunTests
   
  
--SELECT * FROM GDM.dbo.ActivityType

ROLLBACK

DROP PROCEDURE #AssertInt
DROP PROCEDURE #AssertBit
DROP PROCEDURE #AssertVarchar
DROP PROCEDURE #RunPhase 
DROP PROCEDURE #RunTests
DROP TABLE #Globals
DROP PROCEDURE #SetGlobalInt

DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_test
DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_teardown