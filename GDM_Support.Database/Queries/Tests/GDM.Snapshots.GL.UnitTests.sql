USE GDM_GR 


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccount_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccount_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccount_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccount_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccount_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccount_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMajorCategory_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMajorCategory_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMajorCategory_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMajorCategory_teardown
	
	
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMinorCategory_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMinorCategory_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMinorCategory_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_teardown


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMinorCategory_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMinorCategory_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncSnapshotGLMinorCategory_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncSnapshotGLMinorCategory_teardown
GO




IF 	OBJECT_ID('tempdb..#Globals') IS NOT NULL
	DROP TABLE #Globals

IF 	OBJECT_ID('tempdb..#Tests') IS NOT NULL
	DROP TABLE #Tests
	
IF 	OBJECT_ID('tempdb..#RunTests') IS NOT NULL
	DROP PROCEDURE #RunTests
IF 	OBJECT_ID('tempdb..#RunPhase') IS NOT NULL
	DROP PROCEDURE #RunPhase
	
IF 	OBJECT_ID('tempdb..#AssertBit') IS NOT NULL
	DROP PROCEDURE #AssertBit
IF 	OBJECT_ID('tempdb..#AssertInt') IS NOT NULL
	DROP PROCEDURE #AssertInt
IF 	OBJECT_ID('tempdb..#AssertVarchar') IS NOT NULL
	DROP PROCEDURE #AssertVarchar

IF 	OBJECT_ID('tempdb..#SetGlobalInt') IS NOT NULL
	DROP PROCEDURE #SetGlobalInt


GO
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






-- #region ut_stp_IU_SyncSnapshotGLGlobalAccount

GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccount_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccount_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(10) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 10)))
	DECLARE @Name VARCHAR(250) = 'Cash 123456'
	
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	
	INSERT INTO Gdm.dbo.GLGlobalAccount (ActivityTypeId,ParentGLGlobalAccountId,Code,Name,IsGbs,IsRegionalOverheadCost,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(NULL,NULL,@AccountCode,'Cash 456',0,0,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1)	

	DECLARE @GLGlobalAccountId INT 	
	SET @GLGlobalAccountId = (SELECT @@Identity)
	
	EXEC @return_value = GDM_Gr.[dbo].[stp_IU_SyncGLGlobalAccount]
	
		
		--ALTER TABLE  Gdm.dbo.SnapshotGLGlobalAccount DROP CONSTRAINT FK_SnapshotGLGlobalAccount_GLGlobalAccount
	DECLARE @SourceGlAccountId INT = (SELECT MAX(GlGlobalAccountId) FROM Gdm.dbo.GLGlobalAccount)
	EXEC @return_value = GDM_Gr.[dbo].[stp_IU_SyncGLGlobalAccount]
	
	INSERT INTO Gdm.dbo.SnapshotGLGlobalAccount (GLGlobalAccountId, 
		SnapshotId, 
		ActivityTypeId,
		ParentGLGlobalAccountId,
		Code,
		Name,IsGbs,IsRegionalOverheadCost,InsertedDate,UpdatedDate,UpdatedByStaffId, IsActive) 
	VALUES(@SourceGlAccountId, @SnapshotId, NULL,NULL,@AccountCode,@Name,0,0,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1, 1)	
	

	DECLARE @StringValue1 VARCHAR(250)

	EXEC @return_value = GDM_Gr.[dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
	
	--DECLARE @GLGlobalAccountId INT = @SourceGlGlobalAccountId
-- last 10 characters of hash
	--SELECT @AccountCode
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccount WHERE
			ActivityTypeId IS NULL AND
			--GLStatutoryTypeId = 0 AND
			ParentGLGlobalAccountId IS NULL AND
			--Code = '1001000001' AND
			Code = @AccountCode AND
			Name = @Name AND
			IsGbs = 0 AND
			IsRegionalOverheadCost = 0 AND
			IsActive = 1 AND
			--InsertedDate = '2010/02/14 08:05:24 AM' AND
			--UpdatedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedByStaffId = -1 AND
			ExpenseCzarStaffId = -1 AND
			GLGlobalAccountId = @GLGlobalAccountId)
		RAISERROR ('GLGlobalAccount Expected GR to sync from Insert', 16, 1)    	
		
		
		
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	
	
	UPDATE 	Gdm.dbo.SnapshotGLGlobalAccount SET
			ActivityTypeId = NULL,
			ParentGLGlobalAccountId = NULL,
			Code = @AccountCode,
			Name = 'Cash 4567',
			IsGbs = 0,
			IsRegionalOverheadCost = 0,
			IsActive = 0,
			InsertedDate = '2010/02/14 08:05:24 AM',
			UpdatedDate = '2010/02/14 08:05:24 AM',
			UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLGlobalAccountId = @GLGlobalAccountId
	

			
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
	
	---SELECT * FROM Gdm.dbo.SnapshotGLGlobalAccount WHERE GLGlobalAccountId = @GLGlobalAccountId
	---SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccount  WHERE GLGlobalAccountId = @GLGlobalAccountId
	
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccount WHERE
			GLGlobalAccountId = @GLGlobalAccountId AND
			ActivityTypeId IS NULL AND
			--GLStatutoryTypeId = 0 AND
			ParentGLGlobalAccountId IS NULL AND
			Code = @AccountCode AND
			Name = 'Cash 4567' AND
			Description = '' AND
			--IsGR = 0 AND
			IsGbs = 0 AND
			IsRegionalOverheadCost = 0 AND
			--IsActive = 0 AND
			InsertedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedByStaffId = -1 AND
			ExpenseCzarStaffId = -1 AND
			--ParentCode = '10010000'	AND
			GLGlobalAccountId = @GLGlobalAccountId)

		RAISERROR ('GLGlobalAccount Expected GR to Update', 16, 1)    	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotGLGlobalAccount SET
			ActivityTypeId = NULL,
			--GLStatutoryTypeId = 0,
			ParentGLGlobalAccountId = NULL,
			Code = @AccountCode,
			Name = 'Cash 4568',
			Description = '',
			IsGR = 0,
			IsGbs = 0,
			IsRegionalOverheadCost = 0,
			IsActive = 0,
			InsertedDate = '2010/02/14 08:05:24 AM',
			UpdatedDate = '2010/02/14 08:05:24 AM',
			UpdatedByStaffId = -1,
			ExpenseCzarStaffId = -1
		WHERE 
			GLGlobalAccountId = @GLGlobalAccountId
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccount Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
   IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccount WHERE
			ActivityTypeId IS NULL AND
			--GLStatutoryTypeId = 0 AND
			ParentGLGlobalAccountId IS NULL AND
			Code = @AccountCode AND
			Name = 'Cash 4567' AND
			Description = '' AND
			--IsGR = 0 AND
			IsGbs = 0 AND
			IsRegionalOverheadCost = 0 AND
			--IsActive = 0 AND
			InsertedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedByStaffId = -1 AND
			ExpenseCzarStaffId = -1 AND
			GLGlobalAccountId = @GLGlobalAccountId)

		RAISERROR ('GLGlobalAccount Expected GR to lose Changes', 16, 1)    	
		
		

	
	DELETE FROM Gdm.dbo.SnapshotGLGlobalAccount WHERE GLGlobalAccountId = @GLGlobalAccountId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGLGlobalAccount  WHERE GLGlobalAccountId = @GLGlobalAccountId)
	
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccount Expected DeActivated record'	
	
	DELETE FROM Gdm_GR.dbo.SnapshotGLGlobalAccount WHERE GLGlobalAccountId = @GLGlobalAccountId

END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccount_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncSnapshotGLGlobalAccount


-- #region ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_setup AS 
BEGIN 

	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(10) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 10)))
	
	INSERT INTO Gdm.dbo.GLGlobalAccount (ActivityTypeId,ParentGLGlobalAccountId,Code,Name,IsGbs,IsRegionalOverheadCost,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(NULL,NULL,@AccountCode,@AccountCode,0,0,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1)	
	DECLARE @GLGlobalAccountId INT = (SELECT @@Identity)	

	INSERT INTO Gdm.dbo.GLAccount (GLGlobalAccountId,SourceCode,Code,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@GLGlobalAccountId,'BC',@AccountCode,'??',0,NULL,'2010/07/24 04:44:55 AM','2010/07/24 04:44:55 AM',-1)		
	DECLARE @GLAccountId INT = (SELECT @@Identity)
	
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) from GDM.dbo.Snapshot )
	
	
	INSERT INTO Gdm.dbo.SnapshotGLGlobalAccount (
		SnapshotId, 
		GlGlobalAccountId, 
		ActivityTypeId,
		ParentGLGlobalAccountId,
		Code,Name,IsGbs,IsRegionalOverheadCost,InsertedDate,UpdatedDate,UpdatedByStaffId, IsActive) 
	VALUES(@SnapshotId, 
			@GLGlobalAccountId, 
			NULL,
			NULL,
			@AccountCode,@AccountCode,0,0,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1, 1)	

	
	INSERT INTO GDM.dbo.SnapshotGLAccount
		(SnapshotId,Code,SourceCode,Name,Type,IsHistoric,IsGlobalReporting,IsActive,LastDate,
			GLAccountId,
			GLGlobalAccountId,
			EnglishName,IsServiceCharge,IsDirectRecharge,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@SnapshotId,@AccountCode,'BC','Valores a Depositar','I',0,0,0,'2009/11/13 02:49:01 PM',
		@GLAccountId,@GLGlobalAccountId,'',0,0,'2011/07/06 03:04:23 PM','2011/07/06 03:04:29 PM',-1)



	EXEC @return_value = GDM_GR.[dbo].[stp_IU_SyncGLGlobalAccount]	
	EXEC @return_value = GDM_GR.[dbo].[stp_IU_SyncGLGlobalAccountGLAccount]

	EXEC	@return_value = GDM_GR.[dbo].[stp_IU_SyncSnapshotGLGlobalAccount]
	EXEC	@return_value = GDM_GR.[dbo].[stp_IU_SyncSnapshotGLGlobalAccountGLAccount]
	
	--SELECT @GLGlobalAccountId
	--SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountGLAccount where SourceCode = 'BC' AND Code = @AccountCode 
	
    IF NOT EXISTS(
		SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountGLAccount WHERE
					--GLGlobalAccountGLAccountId = 1 AND
					GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode AND
					--Code = 'CP1001000000' AND
					--Name = '?? (Header)' AND
					--Description = '' AND
					--PreGlobalAccountCode = '' AND
					--IsActive = 0 AND
					--InsertedDate = '2010/07/24 04:44:55 AM' AND
					--UpdatedDate = '2010/07/24 04:44:55 AM' AND
					UpdatedByStaffId = -1)
		RAISERROR ('GLGlobalAccountGLAccount Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
		UPDATE 	 Gdm.dbo.SnapshotGLAccount SET
				SourceCode = 'BC',
				Code = @AccountCode,
				Name = '?? (Header)',
				--InsertedDate = '2010/07/24 04:44:55 AM',
				--UpdatedDate = '2010/07/24 04:44:55 AM',
				UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode 
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountGLAccount]
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountGLAccount WHERE
					--GLGlobalAccountGLAccountId = 1 AND
					GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode AND
					--Name = '?? (Header)' AND
					--Description = '' AND
					--PreGlobalAccountCode = '' AND
					--IsActive = 0 AND
					--InsertedDate = '2010/07/24 04:44:55 AM' AND
					--UpdatedDate = '2010/07/24 04:44:55 AM' AND
					UpdatedByStaffId = -1 
					)

		RAISERROR ('GLGlobalAccountGLAccount Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	
	UPDATE 	 Gdm_GR.dbo.SnapshotGLGlobalAccountGLAccount SET
				GLGlobalAccountId = @GLGlobalAccountId,
				SourceCode = 'BC',
				Code = @AccountCode,
				--Name = '?? (Header)',
				--Description = '',
				--PreGlobalAccountCode = '',
				--IsActive = 0,
				--InsertedDate = '2010/07/24 04:44:55 AM',
				--UpdatedDate = '2010/07/24 04:44:55 AM',
				UpdatedByStaffId = -1
		WHERE 
			GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode 
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccountGLAccount Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountGLAccount]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountGLAccount WHERE
					--GLGlobalAccountGLAccountId = 1 AND
					GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode AND
					--Name = '?? (Header)' AND
					--Description = '' AND
					--PreGlobalAccountCode = '' AND
					--IsActive = 0 AND
					--Version = NULL AND
					--InsertedDate = '2010/07/24 04:44:55 AM' AND
					--UpdatedDate = '2010/07/24 04:44:55 AM' AND
					UpdatedByStaffId = -1)
		RAISERROR ('GLGlobalAccountGLAccount Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotGLAccount WHERE GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountGLAccount]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGLGlobalAccountGLAccount  WHERE GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'BC' AND
					Code = @AccountCode)
	
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccountGLAccount Expected DeActivated record'
	
	
	
	
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount


-- #region ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(12) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 12)))
	
	DECLARE @GLGlobalAccountId INT = (SELECT MAX(GLGlobalAccountId) FROM GDM.dbo.GLGlobalAccount)
	INSERT INTO GDM.dbo.GLGlobalAccountCategorization
		(GLGlobalAccountId,GLCategorizationId,CoAGLMinorCategoryId,DirectGLMinorCategoryId,DirectPostingGLAccountId,IsDirectApplicable,IndirectGLMinorCategoryId,IndirectPostingGLAccountId,IsIndirectApplicable,Version,InsertedDate,UpdatedDate,UpdatedByStaffId,IsCoAApplicable) 
		VALUES(@GLGlobalAccountId,233,NULL,772,NULL,0,772,NULL,0,NULL,'2011/07/06 03:05:42 PM','2011/07/06 03:05:42 PM',-1,0)
	DECLARE @GLGlobalAccountCategorizationId INT = @@Identity
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM.dbo.Snapshot)
	
			
	DELETE FROM GDM.dbo.SnapshotGLGlobalAccountCategorization WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId
	INSERT INTO GDM.dbo.SnapshotGLGlobalAccountCategorization
		(SnapshotId,GLGlobalAccountCategorizationId,GLGlobalAccountId,GLCategorizationId,CoAGLMinorCategoryId,DirectGLMinorCategoryId,DirectPostingGLAccountId,IsDirectApplicable,IndirectGLMinorCategoryId,IndirectPostingGLAccountId,IsIndirectApplicable,Version,InsertedDate,UpdatedDate,UpdatedByStaffId,IsCoAApplicable) 
		VALUES(@SnapshotId,@GLGlobalAccountCategorizationId, 132583,233,NULL,31,NULL,0,31,NULL,0,NULL,'2010/07/24 04:46:59 AM','2010/07/24 04:46:59 AM',-1,0)

	EXEC	@return_value = GDM_GR.[dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
	
	--SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationSubType where GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId
	
	IF NOT EXISTS(
		SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationSubType WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountCategorizationId AND
			GLGlobalAccountId = 132583 AND
			GLTranslationSubTypeId = 233 AND
			--GLMinorCategoryId = 31 AND
			--PostingPropertyGLAccountCode = '' AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:46:58 AM' AND
			--UpdatedDate = '2010/07/24 04:46:58 AM' AND
			UpdatedByStaffId = -1
	)
		RAISERROR ('GLGlobalAccountTranslationSubType Expected GR to sync from Insert', 16, 1)  
	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	
		UPDATE Gdm.dbo.SnapshotGLGlobalAccountCategorization SET
				SnapshotId = @SnapshotId,
				GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId,
				GLGlobalAccountId = 132583,
				GLCategorizationId = 233,
				DirectGLMinorCategoryId = 31,
				DirectPostingGLAccountId = NULL,
				IsDirectApplicable = 0,
				IndirectGLMinorCategoryId = 31,
				IndirectPostingGLAccountId = NULL,
				IsIndirectApplicable = 0,
				InsertedDate = '2010/07/24 04:46:59 AM',
				UpdatedDate = '2010/07/24 04:46:59 AM',
				UpdatedByStaffId = -1
		WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId

		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
	
  
	IF NOT EXISTS(
		SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationSubType WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountCategorizationId AND
			GLGlobalAccountId = 132583 AND
			GLTranslationSubTypeId = 233 AND
			--GLMinorCategoryId = 31 AND
			--PostingPropertyGLAccountCode = '' AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:46:58 AM' AND
			--UpdatedDate = '2010/07/24 04:46:58 AM' AND
			UpdatedByStaffId = -1
	)

		RAISERROR ('GLGlobalAccountTranslationSubType Expected GR to Update', 16, 1)    	
	
	
			
		UPDATE Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationSubType SET
			SnapshotId = @SnapshotId,
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountCategorizationId,
			GLGlobalAccountId = 132582,
			GLTranslationSubTypeId = 233,
			GLMinorCategoryId = 31,
			PostingPropertyGLAccountCode = '',
			IsActive = 0,
			InsertedDate = '2010/07/24 04:46:58 AM',
			UpdatedDate = '2010/07/24 04:46:58 AM',
			UpdatedByStaffId = -1			
		WHERE
				SnapshotId = @SnapshotId AND
				GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountCategorizationId
	
			
			
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccountTranslationSubType Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
	
	
	
	IF NOT EXISTS(
		SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationSubType WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountCategorizationId AND
			GLGlobalAccountId = 132583 AND
			GLTranslationSubTypeId = 233 AND
			--GLMinorCategoryId = 31 AND
			--PostingPropertyGLAccountCode = '' AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:46:58 AM' AND
			--UpdatedDate = '2010/07/24 04:46:58 AM' AND
			UpdatedByStaffId = -1
	)
		RAISERROR ('GLGlobalAccountTranslationSubType Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotGLGlobalAccountCategorization WHERE SnapshotId = @SnapshotId AND
			GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId

	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGLGlobalAccountTranslationSubType  WHERE SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountCategorizationId )
	
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccountTranslationSubType Expected DeActivated record'
	
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType


-- #region ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_test AS 
BEGIN 
DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(12) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 12)))
	
	DECLARE @GLGlobalAccountId INT = (SELECT MAX(GLGlobalAccountId) FROM GDM.dbo.GLGlobalAccount)
	DELETE FROM GDM.dbo.GLGlobalAccountCategorization WHERE
		GLGlobalAccountId = @GLGlobalAccountId AND
		GLCategorizationId = 233

	INSERT INTO GDM.dbo.GLGlobalAccountCategorization
		(GLGlobalAccountId,GLCategorizationId,CoAGLMinorCategoryId,DirectGLMinorCategoryId,DirectPostingGLAccountId,IsDirectApplicable,IndirectGLMinorCategoryId,IndirectPostingGLAccountId,IsIndirectApplicable,Version,InsertedDate,UpdatedDate,UpdatedByStaffId,IsCoAApplicable) 
		VALUES(@GLGlobalAccountId,233,NULL,772,NULL,0,772,NULL,0,NULL,'2011/07/06 03:05:42 PM','2011/07/06 03:05:42 PM',-1,0)
		
	DECLARE @GLGlobalAccountCategorizationId INT = @@Identity
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM.dbo.Snapshot)

	DELETE FROM GDM.dbo.SnapshotGLGlobalAccountCategorization WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId
	
	INSERT INTO GDM.dbo.SnapshotGLGlobalAccountCategorization
		(SnapshotId,GLGlobalAccountCategorizationId,GLGlobalAccountId,GLCategorizationId,CoAGLMinorCategoryId,DirectGLMinorCategoryId,DirectPostingGLAccountId,IsDirectApplicable,IndirectGLMinorCategoryId,IndirectPostingGLAccountId,IsIndirectApplicable,Version,InsertedDate,UpdatedDate,UpdatedByStaffId,IsCoAApplicable) 
		VALUES(@SnapshotId,@GLGlobalAccountCategorizationId, 132583,233,NULL,31,NULL,0,31,NULL,0,NULL,'2010/07/24 04:46:59 AM','2010/07/24 04:46:59 AM',-1,0)



	
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]
	--SELECT @GLGlobalAccountId
	--SELECT * FROM  Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationType WHERE 			GLGlobalAccountId = @GLGlobalAccountId 
	
    IF NOT EXISTS(				
		SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationType WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationTypeId = 1 AND
			GLGlobalAccountId = 132583 AND
			GLTranslationTypeId = 1 AND
			GLAccountTypeId = 1 AND
			GLAccountSubTypeId = 1 AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:46:37 AM' AND
			--UpdatedDate = '2010/07/24 04:46:37 AM' AND
			UpdatedByStaffId = -1)	
				
		RAISERROR ('GLGlobalAccountTranslationType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
			
		

		UPDATE Gdm.dbo.SnapshotGLGlobalAccountCategorization SET
				SnapshotId = @SnapshotId,
				GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId,
				GLGlobalAccountId = 132583,
				GLCategorizationId = 233,
				DirectGLMinorCategoryId = 31,
				DirectPostingGLAccountId = NULL,
				IsDirectApplicable = 0,
				IndirectGLMinorCategoryId = 31,
				IndirectPostingGLAccountId = NULL,
				IsIndirectApplicable = 0,
				InsertedDate = '2010/07/24 04:46:59 AM',
				UpdatedDate = '2010/07/24 04:46:59 AM',
				UpdatedByStaffId = -1
		WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId
		
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]
	
	   IF NOT EXISTS(				
			SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationType WHERE
				SnapshotId = @SnapshotId AND
				GLGlobalAccountTranslationTypeId = 1 AND
				GLGlobalAccountId = 132583 AND
				GLTranslationTypeId = 1 AND
				GLAccountTypeId = 1 AND
				GLAccountSubTypeId = 1 AND
				--IsActive = 0 AND
				--InsertedDate = '2010/07/24 04:46:37 AM' AND
				--UpdatedDate = '2010/07/24 04:46:37 AM' AND
				UpdatedByStaffId = -1)	
		RAISERROR ('GLGlobalAccountTranslationType Expected GR to Update', 16, 1)    	
	
	
	
	UPDATE Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationType SET
		SnapshotId = @SnapshotId,
		GLGlobalAccountTranslationTypeId = 1,
		GLGlobalAccountId = 132583,
		GLTranslationTypeId = 1,
		GLAccountTypeId = 1,
		GLAccountSubTypeId = 1,
		IsActive = 0,
		InsertedDate = '2010/07/24 04:46:37 AM',
		UpdatedDate = '2010/07/24 04:46:37 AM',
		UpdatedByStaffId = -1				
	WHERE 
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationTypeId = 1 AND
			GLGlobalAccountId = 132583

				
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccountTranslationType Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
     IF NOT EXISTS(				
		SELECT * FROM Gdm_GR.dbo.SnapshotGLGlobalAccountTranslationType WHERE
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationTypeId = 1 AND
			GLGlobalAccountId = 132583 AND
			GLTranslationTypeId = 1 AND
			GLAccountTypeId = 1 AND
			GLAccountSubTypeId = 1 AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:46:37 AM' AND
			--UpdatedDate = '2010/07/24 04:46:37 AM' AND
			UpdatedByStaffId = -1)	
		RAISERROR ('GLGlobalAccountTranslationType Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotGLGlobalAccountCategorization WHERE 
				
				SnapshotId = @SnapshotId AND
			    GLGlobalAccountCategorizationId = @GLGlobalAccountCategorizationId
				
				
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGLGlobalAccountTranslationType]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGLGlobalAccountTranslationType  WHERE 
			SnapshotId = @SnapshotId AND
			GLGlobalAccountTranslationTypeId = 1 AND
			GLGlobalAccountId = 132583)
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccountTranslationType Expected DeActivated record'
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType


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



-----------------------------------------------------------------------------------------------------------------------------------
-------   TESTS END GLCategorization
-----------------------------------------------------------------------------------------------------------------------------------
GO
BEGIN TRAN
SET NOCOUNT ON

CREATE TABLE #Tests
(
	TestName VARCHAR(250),
	Active BIT
)
INSERT #Tests (Active, TestName)
SELECT 0, '#ut_stp_IU_SyncSnapshotGLGlobalAccount' UNION ALL
SELECT 0, '#ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount' UNION ALL
SELECT 0, '#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType' UNION ALL
SELECT 0, '#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType' UNION ALL
SELECT 1, '#ut_stp_IU_SyncSnapshotGLMajorCategory' UNION ALL
SELECT 0, '#ut_stp_IU_SyncSnapshotGLMinorCategory'

EXEC #RunTests
   

ROLLBACK

/*
-- TESTS
#ut_stp_IU_SyncSnapshotGLGlobalAccount
#ut_stp_IU_SyncSnapshotGLGLobalAccountGLAccount
#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType
#ut_stp_IU_SyncSnapshotGLGlobalAccountTranslationType
#ut_stp_IU_SyncSnapshotGLMajorCategory
#ut_stp_IU_SyncSnapshotGLMinorCategory




-- Stored procs
stp_IU_SyncSnapshotGLGlobalAccount
stp_IU_SyncSnapshotGLGLobalAccountGLAccount
stp_IU_SyncSnapshotGLGlobalAccountTranslationSubType
stp_IU_SyncSnapshotGLGlobalAccountTranslationType
stp_IU_SyncSnapshotGLMajorCategory
stp_IU_SyncSnapshotGLMinorCategory

-- Tables
GLGlobalAccount
GLGLobalAccountGLAccount
GLGlobalAccountTranslationSubType
GLGlobalAccountTranslationType
GLMajorCategory
GLMinorCategory




INSERT INTO GLGlobalAccount (GLGlobalAccountId,ActivityTypeId,GLStatutoryTypeId,ParentGLGlobalAccountId,Code,Name,Description,IsGR,IsGbs,IsRegionalOverheadCost,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId,ExpenseCzarStaffId,ParentCode) VALUES(132554,NULL,0,NULL,'1001000000','Cash (Header)','',0,0,0,0,NULL,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1,-1,'10010000')
INSERT INTO GLGlobalAccountGLAccount (GLGlobalAccountGLAccountId,GLGlobalAccountId,SourceCode,Code,Name,Description,PreGlobalAccountCode,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) VALUES(1,132554,'CC','CP1001000000','?? (Header)','','',0,NULL,'2010/07/24 04:44:55 AM','2010/07/24 04:44:55 AM',-1)
INSERT INTO GLGlobalAccountTranslationSubType (GLGlobalAccountTranslationSubTypeId,GLGlobalAccountId,GLTranslationSubTypeId,GLMinorCategoryId,PostingPropertyGLAccountCode,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) VALUES(2,132583,240,237,'',0,NULL,'2010/07/24 04:46:58 AM','2010/07/24 04:46:58 AM',-1)
INSERT INTO GLGlobalAccountTranslationType (GLGlobalAccountTranslationTypeId,GLGlobalAccountId,GLTranslationTypeId,GLAccountTypeId,GLAccountSubTypeId,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) VALUES(1,132583,1,1,1,0,NULL,'2010/07/24 04:46:37 AM','2010/07/24 04:46:37 AM',-1)
INSERT INTO GLMajorCategory (GLMajorCategoryId,GLTranslationSubTypeId,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) VALUES(1,233,'Interest Income',0,NULL,'2010/07/24 04:41:19 AM','2010/07/24 04:41:19 AM',-1)
INSERT INTO GLMinorCategory (GLMinorCategoryId,GLMajorCategoryId,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) VALUES(1,142,'Accounting & Tax',0,NULL,'2010/07/24 04:42:12 AM','2010/07/24 04:42:12 AM',-1)'complete'



*/