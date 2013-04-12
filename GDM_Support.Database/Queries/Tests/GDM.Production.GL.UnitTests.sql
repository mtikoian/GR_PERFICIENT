


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccount_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccount_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccount_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccount_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccount_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccount_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGLobalAccountGLAccount_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGLobalAccountGLAccount_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGLobalAccountGLAccount_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGLobalAccountGLAccount_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGLobalAccountGLAccount_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGLobalAccountGLAccount_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccountTranslationSubType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationSubType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccountTranslationSubType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationSubType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccountTranslationSubType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationSubType_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccountTranslationType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccountTranslationType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLGlobalAccountTranslationType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationType_teardown
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMajorCategory_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMajorCategory_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMajorCategory_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMajorCategory_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMajorCategory_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMajorCategory_teardown
	
	
	
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMinorCategory_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMinorCategory_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMinorCategory_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMinorCategory_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMinorCategory_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMinorCategory_teardown


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMinorCategory_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMinorCategory_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMinorCategory_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMinorCategory_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGLMinorCategory_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGLMinorCategory_teardown
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






-- #region ut_stp_IU_SyncGLGlobalAccount

GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccount_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccount_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(10) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 10)))
	--DECLARE @AccountCode VARCHAR(10) = '1001000001'
	
	IF EXISTS(SELECT GLGlobalAccountId FROM GDM.dbo.GLGlobalAccount WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLGlobalAccount Test data already exists', 16, 1)
		
	INSERT INTO Gdm.dbo.GLGlobalAccount (ActivityTypeId,ParentGLGlobalAccountId,Code,Name,IsGbs,IsRegionalOverheadCost,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(NULL,NULL,@AccountCode,'Cash 456',0,0,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1)	

	DECLARE @GLGlobalAccountId INT 	
	SET @GLGlobalAccountId = (SELECT @@Identity)
	
	IF @GLGlobalAccountId IS NULL
		RAISERROR ('GLGlobalAccount could not initialise GLGlobalAccountId', 16, 1)

	DECLARE @StringValue1 VARCHAR(250)
	EXEC @return_value = [dbo].[stp_IU_SyncGLGlobalAccount]
	
	
	
-- last 10 characters of hash
	--SELECT @AccountCode
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccount WHERE
			ActivityTypeId IS NULL AND
			--GLStatutoryTypeId = 0 AND
			ParentGLGlobalAccountId IS NULL AND
			--Code = '1001000001' AND
			Code = @AccountCode AND
			Name = 'Cash 456' AND
			IsGbs = 0 AND
			IsRegionalOverheadCost = 0 AND
			IsActive = 1 AND
			InsertedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedDate = '2010/02/14 08:05:24 AM' AND
			UpdatedByStaffId = -1 AND
			ExpenseCzarStaffId = -1 AND
			GLGlobalAccountId = @GLGlobalAccountId)
		RAISERROR ('GLGlobalAccount Expected GR to sync from Insert', 16, 1)    	
		
		
		
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	
	
	UPDATE 	Gdm.dbo.GLGlobalAccount SET
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
	

			
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccount]
	
	---SELECT * FROM Gdm.dbo.GLGlobalAccount WHERE GLGlobalAccountId = @GLGlobalAccountId
	---SELECT * FROM Gdm_GR.dbo.GLGlobalAccount  WHERE GLGlobalAccountId = @GLGlobalAccountId
	
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccount WHERE
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
	UPDATE 	Gdm_GR.dbo.GLGlobalAccount SET
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
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccount]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
   IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccount WHERE
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
		
		

	
	DELETE FROM Gdm.dbo.GLGlobalAccount WHERE GLGlobalAccountId = @GLGlobalAccountId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccount]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GLGlobalAccount  WHERE GLGlobalAccountId = @GLGlobalAccountId)
	
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccount Expected DeActivated record'	
	
	DELETE FROM Gdm_GR.dbo.GLGlobalAccount WHERE GLGlobalAccountId = @GLGlobalAccountId

END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccount_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncGLGlobalAccount


-- #region ut_stp_IU_SyncGLGLobalAccountGLAccount
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGLobalAccountGLAccount_setup AS 
BEGIN 

	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGLobalAccountGLAccount_test AS 
BEGIN 
	
	
	/*DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(12) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 12)))
	--DECLARE @AccountCode VARCHAR(10) = 'CP1001000000'
	IF EXISTS(SELECT * FROM GDM.dbo.GLAccount WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLGlobalAccountGLAccount Test data already exists', 16, 1)
		
	INSERT INTO Gdm.dbo.GLAccount (GLGlobalAccountId,SourceCode,Code,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(132554,'CC',@AccountCode,'?? (Header)',0,NULL,'2010/07/24 04:44:55 AM','2010/07/24 04:44:55 AM',-1)	
	EXEC #AssertInt 1, @@RowCount, 'Expected 1 Insert'
	
	DECLARE @GLGlobalAccountGLAccountId INT = (SELECT @@Identity)*/
	
	-- INSERT GL ACCOUNT
	DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(10) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 10)))
	--DECLARE @AccountCode VARCHAR(10) = 'CP1001000000'
	IF EXISTS(SELECT * FROM GDM.dbo.GLAccount WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLGlobalAccountGLAccount Test data already exists', 16, 1)
	
		
	INSERT INTO Gdm.dbo.GLGlobalAccount (ActivityTypeId,ParentGLGlobalAccountId,Code,Name,IsGbs,IsRegionalOverheadCost,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(NULL,NULL,@AccountCode,@AccountCode,0,0,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1)	
	DECLARE @GLGlobalAccountId INT = (SELECT @@Identity)	
	EXEC @return_value = GDM_GR.[dbo].[stp_IU_SyncGLGlobalAccount]	
		
	INSERT INTO Gdm.dbo.GLAccount (GLGlobalAccountId,SourceCode,Code,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@GLGlobalAccountId,'CC',@AccountCode,'??',0,NULL,'2010/07/24 04:44:55 AM','2010/07/24 04:44:55 AM',-1)		
	
	DECLARE @GLAccountId INT = (SELECT @@Identity)
	
	IF @GLGlobalAccountId IS NULL
		RAISERROR ('GLGlobalAccountGLAccount could not initialise GLGlobalAccountGLAccountId', 16, 1)

	
	--DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = GDM_GR.[dbo].[stp_IU_SyncGLGlobalAccountGLAccount]
	-- END INSERT GL ACCOUNT
	
	
	IF @GLGlobalAccountId IS NULL
		RAISERROR ('GLGlobalAccountGLAccount could not initialise GLGlobalAccountGLAccountId', 16, 1)

	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountGLAccount]
	
	/*SELECT * FROM Gdm.dbo.GLAccount WHERE GLGlobalAccountId = 132554 AND
					SourceCode = 'CC' AND
					Code = @AccountCode
	SELECT * FROM Gdm_GR.dbo.GLGlobalAccountGLAccount WHERE GLGlobalAccountId = 132554 AND
					SourceCode = 'CC' AND
					Code = @AccountCode*/
    IF NOT EXISTS(
		SELECT * FROM Gdm_GR.dbo.GLGlobalAccountGLAccount WHERE
					--GLGlobalAccountGLAccountId = 1 AND
					GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'CC' AND
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
	
		UPDATE 	 Gdm.dbo.GLAccount SET
				SourceCode = 'CC',
				Code = @AccountCode,
				Name = '?? (Header)',
				InsertedDate = '2010/07/24 04:44:55 AM',
				UpdatedDate = '2010/07/24 04:44:55 AM',
				UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'CC' AND
					Code = @AccountCode 
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountGLAccount]
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccountGLAccount WHERE
					--GLGlobalAccountGLAccountId = 1 AND
					GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'CC' AND
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
	
	UPDATE 	 Gdm_GR.dbo.GLGlobalAccountGLAccount SET
				GLGlobalAccountId = @GLGlobalAccountId,
				SourceCode = 'CC',
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
					SourceCode = 'CC' AND
					Code = @AccountCode 
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccountGLAccount Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountGLAccount]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccountGLAccount WHERE
					--GLGlobalAccountGLAccountId = 1 AND
					GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'CC' AND
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
	
	
	DELETE FROM Gdm.dbo.GLAccount WHERE GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'CC' AND
					Code = @AccountCode
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountGLAccount]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GLGlobalAccountGLAccount  WHERE GLGlobalAccountId = @GLGlobalAccountId AND
					SourceCode = 'CC' AND
					Code = @AccountCode)
	
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccountGLAccount Expected DeActivated record'
	
	
	
	
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGLobalAccountGLAccount_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncGLGLobalAccountGLAccount


-- #region ut_stp_IU_SyncGLGlobalAccountTranslationSubType
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationSubType_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationSubType_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE @AccountCode VARCHAR(12) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 12)))

	INSERT INTO GDM.dbo.GLAccount
		(Code,SourceCode,Name,EnglishName,Type,LastDate,IsActive,IsHistoric,IsGlobalReporting,IsServiceCharge,IsDirectRecharge,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@AccountCode,'BC','Valores a Depositar2','','I','2009/11/13 02:49:01 PM',0,0,0,0,0,NULL,'2011/07/06 03:05:28 PM','2011/07/06 03:05:28 PM',-1)
	DECLARE @GlAccountId INT = (SELECT @@Identity)
	
	INSERT INTO GDM.dbo.GLGlobalAccount
			(ActivityTypeId,ParentGLGlobalAccountId,Code,Name,IsGbs,IsRegionalOverheadCost,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
			VALUES(NULL,NULL,@GlAccountId,'Cash (Header)',0,0,0,NULL,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1)
	DECLARE @GLGlobalAccountId INT = (SELECT @@Identity)		
	
		EXEC @return_value = [dbo].[stp_IU_SyncGLGlobalAccount]

	IF EXISTS(SELECT * FROM GDM.dbo.GLGlobalAccountCategorization WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLGlobalAccountTranslationSubType Test data already exists', 16, 1)
		
	DECLARE @GLCategorizationId INT = (SELECT GLCategorizationId from GDM.dbo.GLCategorization where name = 'Global')
	DECLARE @GLMinorCategory INT = (SELECT GLMinorCategoryId from GDM.dbo.GLMinorCategory where name = 'Acquisition Fees')
		
	INSERT INTO Gdm.dbo.GLGlobalAccountCategorization (GLGlobalAccountId,GLCategorizationId,DirectGLMinorCategoryId,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@GLGlobalAccountId,@GLCategorizationId,@GLMinorCategory,NULL,'2010/07/24 04:46:58 AM','2010/07/24 04:46:58 AM',-1)	
	DECLARE @GLGlobalAccountTranslationSubTypeId INT = (SELECT @@Identity)
	IF @GLGlobalAccountTranslationSubTypeId IS NULL
		RAISERROR ('GLGlobalAccountTranslationSubType could not initialise GLGlobalAccountTranslationSubTypeId', 16, 1)
	--PRINT 'GLGlobalAccountTranslationSubType INSERTED'
	
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
	
	--SELECT * FROM Gdm_GR.dbo.GLGlobalAccountTranslationSubType where GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId
	
    IF NOT EXISTS(SELECT * FROM  Gdm_GR.dbo.GLGlobalAccountTranslationSubType WHERE
				GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId AND
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationSubTypeId = @GLCategorizationId AND
				GLMinorCategoryId = @GLMinorCategory AND
				--PostingPropertyGLAccountCode = '' AND
				--IsActive = 0 AND
				InsertedDate = '2010/07/24 04:46:58 AM' AND
				UpdatedDate = '2010/07/24 04:46:58 AM' AND
				UpdatedByStaffId = -1)
		RAISERROR ('GLGlobalAccountTranslationSubType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
			UPDATE Gdm.dbo.GLGlobalAccountCategorization  SET
				--GLGlobalAccountTranslationSubTypeId = 2,
				GLGlobalAccountId = @GLGlobalAccountId,
				GLCategorizationId = @GLCategorizationId,
				DirectGLMinorCategoryId = @GLMinorCategory,
				--PostingPropertyGLAccountCode = '',
				--IsActive = 0,
				InsertedDate = '2010/07/24 04:46:58 AM',
				UpdatedDate = '2010/07/24 04:46:58 AM',
				UpdatedByStaffId = -1
		WHERE 
			GLGlobalAccountCategorizationId = @GLGlobalAccountTranslationSubTypeId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
	
    IF NOT EXISTS(SELECT * FROM  Gdm_GR.dbo.GLGlobalAccountTranslationSubType WHERE
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationSubTypeId = @GLCategorizationId AND
				GLMinorCategoryId = @GLMinorCategory AND
				--PostingPropertyGLAccountCode = '' AND
				--IsActive = 0 AND
				InsertedDate = '2010/07/24 04:46:58 AM' AND
				UpdatedDate = '2010/07/24 04:46:58 AM' AND
				UpdatedByStaffId = -1 AND
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId)

		RAISERROR ('GLGlobalAccountTranslationSubType Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE Gdm_GR.dbo.GLGlobalAccountTranslationSubType SET
				GLGlobalAccountId = @GLGlobalAccountId,
				GLTranslationSubTypeId = @GLCategorizationId,
				GLMinorCategoryId = @GLMinorCategory,
				--PostingPropertyGLAccountCode = '',
				IsActive = 0,
				InsertedDate = '2010/07/24 04:46:58 AM',
				UpdatedDate = '2010/07/24 04:46:58 AM',
				UpdatedByStaffId = -1
		WHERE 
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccountTranslationSubType Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT * FROM  Gdm_GR.dbo.GLGlobalAccountTranslationSubType WHERE
				--GLGlobalAccountTranslationSubTypeId = 2 AND
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationSubTypeId = @GLCategorizationId AND
				GLMinorCategoryId = @GLMinorCategory AND
				--PostingPropertyGLAccountCode = '' AND
				--IsActive = 0 AND
				InsertedDate = '2010/07/24 04:46:58 AM' AND
				UpdatedDate = '2010/07/24 04:46:58 AM' AND
				UpdatedByStaffId = -1 AND
			GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId)
		RAISERROR ('GLGlobalAccountTranslationSubType Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.GLGlobalAccountCategorization WHERE GLGlobalAccountCategorizationId = @GLGlobalAccountTranslationSubTypeId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationSubType]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GLGlobalAccountTranslationSubType  WHERE GLGlobalAccountTranslationSubTypeId = @GLGlobalAccountTranslationSubTypeId)
	
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccountTranslationSubType Expected DeActivated record'
	
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationSubType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncGLGlobalAccountTranslationSubType


-- #region ut_stp_IU_SyncGLGlobalAccountTranslationType
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationType_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationType_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	DECLARE	@return_value int
	IF EXISTS(SELECT * FROM GDM.dbo.GLGlobalAccountCategorization WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLGlobalAccountTranslationType Test data already exists', 16, 1)

	-- GLOBAL ACCOUNT
	DECLARE @AccountCode VARCHAR(12) = (SELECT(RIGHT(SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', CAST(@InsertedDate AS VARCHAR(MAX)))), 3, 32), 12)))

	DELETE FROM GDM.dbo.GLAccount WHERE Code = @AccountCode AND SourceCode = 'BC'
	
	INSERT INTO GDM.dbo.GLAccount
		(Code,SourceCode,Name,EnglishName,Type,LastDate,IsActive,IsHistoric,IsGlobalReporting,IsServiceCharge,IsDirectRecharge,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
		
	VALUES(@AccountCode,'BC','Valores a Depositar2','','I','2009/11/13 02:49:01 PM',0,0,0,0,0,NULL,'2011/07/06 03:05:28 PM','2011/07/06 03:05:28 PM',-1)
	DECLARE @GlAccountId INT = (SELECT @@Identity)
	
	INSERT INTO GDM.dbo.GLGlobalAccount
			(ActivityTypeId,ParentGLGlobalAccountId,Code,Name,IsGbs,IsRegionalOverheadCost,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
			VALUES(NULL,NULL,@GlAccountId,'Cash (Header)2',0,0,0,NULL,'2010/02/14 08:05:24 AM','2010/02/14 08:05:24 AM',-1)
	DECLARE @GLGlobalAccountId INT = (SELECT @@Identity)		
	
	EXEC @return_value = [dbo].[stp_IU_SyncGLGlobalAccount]


			
	--INSERT INTO Gdm.dbo.GLGlobalAccountTranslationType (GLGlobalAccountTranslationTypeId,GLGlobalAccountId,GLTranslationTypeId,GLAccountTypeId,GLAccountSubTypeId,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) VALUES(1,132583,1,1,1,0,NULL,'2010/07/24 04:46:37 AM','2010/07/24 04:46:37 AM',-1)	
	INSERT INTO Gdm.dbo.GLGlobalAccountCategorization
			(GLGlobalAccountId,GLCategorizationId,CoAGLMinorCategoryId,DirectGLMinorCategoryId,DirectPostingGLAccountId,IsDirectApplicable,IndirectGLMinorCategoryId,IndirectPostingGLAccountId,IsIndirectApplicable,Version,InsertedDate,UpdatedDate,UpdatedByStaffId,IsCoAApplicable) 
			VALUES(@GLGlobalAccountId,233,NULL,772,NULL,0,772,NULL,0,NULL,'2011/07/06 03:05:42 PM','2011/07/06 03:05:42 PM',-1,0)
	
	
	DECLARE @GLGlobalAccountTranslationTypeId INT = (SELECT @@Identity)
	IF @GLGlobalAccountTranslationTypeId IS NULL
		RAISERROR ('GLGlobalAccountTranslationType could not initialise GLGlobalAccountTranslationTypeId', 16, 1)

	
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]
	--SELECT @GLGlobalAccountId
	--SELECT * FROM  Gdm_GR.dbo.GLGlobalAccountTranslationType WHERE 			GLGlobalAccountId = @GLGlobalAccountId 
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccountTranslationType WHERE
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationTypeId = 1 AND
				GLAccountTypeId = 1 AND
				GLAccountSubTypeId = 1  AND
				--IsActive = 0 AND
				--InsertedDate = '2010/07/24 04:46:37 AM' AND
				--UpdatedDate = '2010/07/24 04:46:37 AM' AND
				UpdatedByStaffId = -1)
		RAISERROR ('GLGlobalAccountTranslationType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	
	UPDATE GDM.dbo.GLGlobalAccountCategorization SET
			GLGlobalAccountId = @GLGlobalAccountId,
			GLCategorizationId = 233,
			CoAGLMinorCategoryId = NULL,
			DirectGLMinorCategoryId = 772,
			DirectPostingGLAccountId = NULL,
			IsDirectApplicable = 0,
			IndirectGLMinorCategoryId = 772,
			IndirectPostingGLAccountId = NULL,
			IsIndirectApplicable = 0,
			InsertedDate = '2011/07/06 03:05:42 PM',
			UpdatedDate = '2011/07/06 03:05:42 PM',
			UpdatedByStaffId = 1,
			IsCoAApplicable = 0
		WHERE 
			GLGlobalAccountCategorizationId = @GLGlobalAccountTranslationTypeId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]
	
	 IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccountTranslationType WHERE
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationTypeId = 1 AND
				GLAccountTypeId = 1 AND
				GLAccountSubTypeId = 1  AND
				--IsActive = 0 AND
				--InsertedDate = '2010/07/24 04:46:37 AM' AND
				--UpdatedDate = '2010/07/24 04:46:37 AM' AND
				UpdatedByStaffId = -1) -- GR Is ignoring this
		RAISERROR ('GLGlobalAccountTranslationType Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE Gdm_GR.dbo.GLGlobalAccountTranslationType SET
			GLGlobalAccountId = @GLGlobalAccountId,
			GLTranslationTypeId = 1,
			GLAccountTypeId = 1,
			GLAccountSubTypeId = 1,
			IsActive = 0,
			InsertedDate = '2010/07/24 04:46:37 AM',
			UpdatedDate = '2010/07/24 04:46:37 AM',
			UpdatedByStaffId = -1
		WHERE 
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationTypeId = 1 
	EXEC #AssertInt @@RowCount, 1, 'GLGlobalAccountTranslationType Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLGlobalAccountTranslationType WHERE
				--GLGlobalAccountTranslationTypeId = 1 AND
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationTypeId = 1 AND
				GLAccountTypeId = 1 AND
				GLAccountSubTypeId = 1 AND
				--IsActive = 0 AND
				--InsertedDate = '2010/07/24 04:46:37 AM' AND
				--UpdatedDate = '2010/07/24 04:46:37 AM' AND
				UpdatedByStaffId = -1)
		RAISERROR ('GLGlobalAccountTranslationType Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.GLGlobalAccountCategorization WHERE 
				GLGlobalAccountId = @GLGlobalAccountId  AND GLCategorizationId = 233
				
				
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLGlobalAccountTranslationType]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GLGlobalAccountTranslationType  WHERE 
				GLGlobalAccountId = @GLGlobalAccountId AND
				GLTranslationTypeId = 1)
	EXEC #AssertBit @IsActive, 0, 'GLGlobalAccountTranslationType Expected DeActivated record'
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLGlobalAccountTranslationType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncGLGlobalAccountTranslationType


-- #region ut_stp_IU_SyncGLMajorCategory
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLMajorCategory_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLMajorCategory_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT GLMajorCategoryId FROM GDM.dbo.GLMajorCategory WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLMajorCategory Test data already exists', 16, 1)
		
	INSERT INTO Gdm.dbo.GLMajorCategory (GLCategorizationId,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(233,'Interest Income2',0,NULL,'2010/07/24 04:41:19 AM','2010/07/24 04:41:19 AM',-1)	
	DECLARE @GLMajorCategoryId INT = (SELECT @@Identity)
	IF @GLMajorCategoryId IS NULL
		RAISERROR ('GLMajorCategory could not initialise GLMajorCategoryId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMajorCategory]
	--SELECT * FROM Gdm_GR.dbo.GLMajorCategorY WHERE GLMajorCategoryId = @GLMajorCategoryId
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLMajorCategory WHERE
			--GLMajorCategoryId = 1 AND
			GLTranslationSubTypeId = 233 AND
			Name = 'Interest Income2' AND
			IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:41:19 AM' AND
			--UpdatedDate = '2010/07/24 04:41:19 AM' AND
			UpdatedByStaffId = -1 AND
			GLMajorCategoryId = @GLMajorCategoryId)
		RAISERROR ('GLMajorCategory Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
			UPDATE Gdm.dbo.GLMajorCategory SET
				GLCategorizationId = 233,
				Name = 'Interest Income3',
				IsActive = 0,
				InsertedDate = '2010/07/24 04:41:19 AM',
				UpdatedDate = '2010/07/24 04:41:19 AM',
				UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLMajorCategoryId = @GLMajorCategoryId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMajorCategory]
	
     IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLMajorCategory WHERE
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
		UPDATE Gdm_GR.dbo.GLMajorCategory SET
				GLTranslationSubTypeId = 233,
				Name = 'Interest Income4',
				IsActive = 0,
				InsertedDate = '2010/07/24 04:41:19 AM',
				UpdatedDate = '2010/07/24 04:41:19 AM',
				UpdatedByStaffId = -1
		WHERE 
			GLMajorCategoryId = @GLMajorCategoryId
	EXEC #AssertInt @@RowCount, 1, 'GLMajorCategory Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMajorCategory]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
  IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLMajorCategory WHERE
			GLTranslationSubTypeId = 233 AND
			Name = 'Interest Income3' AND
			--IsActive = 0 AND
			--InsertedDate = '2010/07/24 04:41:19 AM' AND
			--UpdatedDate = '2010/07/24 04:41:19 AM' AND
			UpdatedByStaffId = -1 AND
			GLMajorCategoryId = @GLMajorCategoryId)
		RAISERROR ('GLMajorCategory Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.GLMajorCategory WHERE GLMajorCategoryId = @GLMajorCategoryId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMajorCategory]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GLMajorCategory  WHERE GLMajorCategoryId = @GLMajorCategoryId)
	
	EXEC #AssertBit @IsActive, 0, 'GLMajorCategory Expected DeActivated record'
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLMajorCategory_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_stp_IU_SyncGLMajorCategoryslationType

-- #region ut_stp_IU_SyncGLMinorCategory
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLMinorCategory_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLMinorCategory_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT GLMinorCategoryId FROM GDM.dbo.GLMinorCategory WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GLMinorCategory Test data already exists', 16, 1)
		
	DECLARE @GLMajorCategoryId INT = (SELECT TOP 1 GLMajorCategoryId from GDM.dbo.GLMajorCategory WHERE Name = 'Legal & Professional Fees')
	IF @GLMajorCategoryId IS NULL
		RAISERROR ('Expect a valid MajorCategoryId', 16, 1)
		
	INSERT INTO Gdm.dbo.GLMinorCategory (GLMajorCategoryId,Name,IsActive,Version,InsertedDate,UpdatedDate,UpdatedByStaffId) 
	VALUES(@GLMajorCategoryId,'Accounting & Tax2',0,NULL,'2010/07/24 04:42:12 AM','2010/07/24 04:42:12 AM',-1)
	
	DECLARE @GLMinorCategoryId INT = (SELECT @@Identity)
	
	
	
	IF @GLMinorCategoryId IS NULL
		RAISERROR ('GLMinorCategory could not initialise GLMinorCategoryId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMinorCategory]
	
    IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLMinorCategory WHERE
			GLMajorCategoryId = @GLMajorCategoryId AND
			Name = 'Accounting & Tax2' AND
			IsActive = 0 AND
			InsertedDate = '2010/07/24 04:42:12 AM' AND
			UpdatedDate = '2010/07/24 04:42:12 AM' AND
			UpdatedByStaffId = -1 AND
			GLMinorCategoryId = @GLMinorCategoryId)
		RAISERROR ('GLMinorCategory Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.GLMinorCategory SET
			GLMajorCategoryId = @GLMajorCategoryId,
			Name = 'Accounting & Tax3',
			IsActive = 0,
			InsertedDate = '2010/07/24 04:42:12 AM',
			UpdatedDate = '2010/07/24 04:42:12 AM',
			UpdatedByStaffId = -1
		WHERE 
			--Code = 'LEASEABC'
			GLMinorCategoryId = @GLMinorCategoryId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMinorCategory]
	
   IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLMinorCategory WHERE
			GLMajorCategoryId = @GLMajorCategoryId AND
			Name = 'Accounting & Tax3' AND
			IsActive = 0 AND
			InsertedDate = '2010/07/24 04:42:12 AM' AND
			UpdatedDate = '2010/07/24 04:42:12 AM' AND
			UpdatedByStaffId = -1 AND

			GLMinorCategoryId = @GLMinorCategoryId)

		RAISERROR ('GLMinorCategory Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
		UPDATE 	Gdm_GR.dbo.GLMinorCategory SET
			GLMajorCategoryId = @GLMajorCategoryId,
			Name = 'Accounting & Tax4',
			IsActive = 0,
			InsertedDate = '2010/07/24 04:42:12 AM',
			UpdatedDate = '2010/07/24 04:42:12 AM',
			UpdatedByStaffId = -1
		WHERE 
			GLMinorCategoryId = @GLMinorCategoryId
	EXEC #AssertInt @@RowCount, 1, 'GLMinorCategory Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMinorCategory]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
	 IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.GLMinorCategory WHERE
			GLMajorCategoryId = @GLMajorCategoryId AND
			Name = 'Accounting & Tax3' AND
			IsActive = 0 AND
			InsertedDate = '2010/07/24 04:42:12 AM' AND
			UpdatedDate = '2010/07/24 04:42:12 AM' AND
			UpdatedByStaffId = -1 AND
			GLMinorCategoryId = @GLMinorCategoryId)
		RAISERROR ('GLMinorCategory Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.GLMinorCategory WHERE GLMinorCategoryId = @GLMinorCategoryId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGLMinorCategory]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GLMinorCategory  WHERE GLMinorCategoryId = @GLMinorCategoryId)
	
	EXEC #AssertBit @IsActive, 0, 'GLMinorCategory Expected DeActivated record'
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGLMinorCategory_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion ut_stp_IU_SyncGLMinorCategoryionType



-----------------------------------------------------------------------------------------------------------------------------------
-------   TESTS END GLCategorization
-----------------------------------------------------------------------------------------------------------------------------------

BEGIN TRAN
SET NOCOUNT ON

CREATE TABLE #Tests
(
	TestName VARCHAR(250),
	Active BIT
)
INSERT #Tests (Active, TestName)
SELECT 1, '#ut_stp_IU_SyncGLGlobalAccount' UNION ALL
SELECT 1, '#ut_stp_IU_SyncGLGLobalAccountGLAccount' UNION ALL
SELECT 1, '#ut_stp_IU_SyncGLGlobalAccountTranslationSubType' UNION ALL
SELECT 1, '#ut_stp_IU_SyncGLGlobalAccountTranslationType' UNION ALL
SELECT 1, '#ut_stp_IU_SyncGLMajorCategory' UNION ALL
SELECT 1, '#ut_stp_IU_SyncGLMinorCategory'


--#ut_stp_IU_SyncGLGlobalAccountTranslationType

EXEC #RunTests
   
  
--SELECT * FROM GDM.dbo.ActivityType

ROLLBACK

/*
-- TESTS
#ut_stp_IU_SyncGLGlobalAccount
#ut_stp_IU_SyncGLGLobalAccountGLAccount
#ut_stp_IU_SyncGLGlobalAccountTranslationSubType
#ut_stp_IU_SyncGLGlobalAccountTranslationType
#ut_stp_IU_SyncGLMajorCategory
#ut_stp_IU_SyncGLMinorCategory




-- Stored procs
stp_IU_SyncGLGlobalAccount
stp_IU_SyncGLGLobalAccountGLAccount
stp_IU_SyncGLGlobalAccountTranslationSubType
stp_IU_SyncGLGlobalAccountTranslationType
stp_IU_SyncGLMajorCategory
stp_IU_SyncGLMinorCategory

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