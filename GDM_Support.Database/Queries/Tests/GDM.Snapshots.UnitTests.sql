
---------------------------------------
--- Utility functions
---------------------------------------
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
	SELECT TestName FROM #Tests
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
	EXEC #RunPhase 'setup'	
	PRINT '>>>>>>>>>>> Setup Success'
	EXEC #RunPhase 'test'	
	PRINT '>>>>>>>>>>> Tests Success'
	--EXEC #RunPhase 'teardown'	
	--PRINT '>>>>>>>>>>> Teardown Success'
END
GO

-- SnapshotInsert
CREATE  PROCEDURE #SnapshotSetup 
AS
BEGIN
INSERT INTO GDM.dbo.Snapshot
(
	GroupName,
	GroupKey,
	IsLocked
)
VALUES
(
	'Snapshot Sync Test',
	99,
	1
)

EXEC stp_IU_SyncSnapshot

END
GO

/*---------------------------------------------
	Tests
---------------------------------------------*/
-- #region stp_IU_SyncSnapshotActivityType

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityType_setup AS 
BEGIN 
  --EXEC #AssertInt 1, 0, 'Error in value'
  
  DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
  
  IF EXISTS(SELECT ActivityTypeId FROM  GDM.dbo.SnapshotActivityType WHERE Code = 'LEASEABC' AND Name = 'LeasingABC' AND SnapshotId = @SnapshotId)
		RAISERROR ('Test data already exists', 16, 1)
  IF EXISTS(SELECT ActivityTypeId FROM  GDM_GR.dbo.SnapshotActivityType WHERE Code = 'LEASEABC' AND Name = 'LeasingABC' AND SnapshotId = @SnapshotId)
		RAISERROR ('Test data already exists', 16, 1)
  
  INSERT INTO Gdm.dbo.ActivityType
  (
	Code,Name,GLAccountSuffix,IsEscalatable,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId
  )
  VALUES('LEASEABC','LeasingABC','31','0','1',convert(datetime,'Jul 24 2010  4:30AM'),convert(datetime,'Jul 24 2010  4:30AM'),'-1') 
  
  DECLARE @ActivityTypeId INT = (SELECT @@Identity)
  
  EXEC stp_IU_SyncActivityType
  
  
  INSERT Gdm.dbo.SnapshotActivityType(SnapshotId, ActivityTypeId, Code,Name,GLAccountSuffix,IsEscalatable,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
  VALUES(@SnapshotId, @ActivityTypeId, 'LEASEABC','LeasingABC','31','0','1',convert(datetime,'Jul 24 2010  4:30AM'),convert(datetime,'Jul 24 2010  4:30AM'),'-1') 
  
END 
-- Test
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityType_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityType]
	
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	
		
    IF NOT EXISTS(SELECT ActivityTypeId FROM  GDM_GR.dbo.SnapshotActivityType 
		WHERE Code = 'LEASEABC' AND Name = 'LeasingABC' AND SnapshotId =  @SnapshotId)
		RAISERROR ('Record not synched', 16, 1)    	
	
	DECLARE @ActivityTypeId INT 
	SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.SnapshotActivityType WHERE Code = 'LEASEABC' AND SnapshotId = @SnapshotId)
	PRINT 'Activity Type for update: ' + str(@ActivityTypeId)
	
	DECLARE @NewDate DATETIME = GETDATE()
	DECLARE @FutureDate DATETIME = @NewDate + 1
	
	UPDATE 	Gdm.dbo.SnapshotActivityType SET 
		Name = 'LeasingABC2',
		Code = 'LEASEABC2',
		GLAccountSuffix = '31',
		IsActive = 0,
		IsEscalatable = 0,
		InsertedDate = @FutureDate,
		UpdatedDate = @NewDate,
		UpdatedByStaffId = 1
	WHERE 
		--Code = 'LEASEABC'
		ActivityTypeId = @ActivityTypeId AND
		SnapshotId =  @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityType]
	
	IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotActivityType WHERE
		SnapshotId =  @SnapshotId AND
		Code = 'LEASEABC2' AND
		Name = 'LeasingABC2' AND
		GLAccountSuffix = '31' AND
		IsEscalatable = 0 AND
		--InsertedDate = @FutureDate AND
		--UpdatedDate = @NewDate AND
		UpdatedByStaffId = 1)
		RAISERROR ('Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotActivityType SET 
		Name = 'LeasingABC3',
		Code = 'LEASEABC3',
		GLAccountSuffix = '32',
		IsEscalatable = 0,
		UpdatedDate = @NewDate,
		UpdatedByStaffId = 1
	--WHERE Code = 'LEASEABC'
	WHERE ActivityTypeId = @ActivityTypeId AND SnapshotId =  @SnapshotId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityType]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
	IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotActivityType WHERE
		SnapshotId =  @SnapshotId AND
		Code = 'LEASEABC2' AND
		Name = 'LeasingABC2' AND
		GLAccountSuffix = '31' AND
		IsEscalatable = 0 AND
		--InsertedDate = @FutureDate AND
		--UpdatedDate = @NewDate AND
		UpdatedByStaffId = 1)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	UPDATE 	Gdm_GR.dbo.SnapshotActivityType SET Name = 'LeasingABC3' WHERE 
		--Code = 'LEASEABC'
		ActivityTypeId = @ActivityTypeId AND
		SnapshotId =  @SnapshotId
		
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityType]

	DELETE FROM Gdm.dbo.SnapshotActivityType WHERE Code = 'LEASEABC2' AND SnapshotId =  @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be inserted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityType]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
	
    IF EXISTS(SELECT ActivityTypeId FROM  GDM_GR.dbo.SnapshotActivityType WHERE Code = 'LEASEABC' AND IsActive = 1 AND SnapshotId =  @SnapshotId)
		RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.SnapshotActivityType', 16, 1)    	
	
	EXEC #AssertInt 1, 1, 'Error in value'
END
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityType_tearDown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityType AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotActivityType_setup
	EXEC #ut_stp_IU_SyncSnapshotActivityType_test
	EXEC #ut_stp_IU_SyncSnapshotActivityType_teardown
END
GO
-- #endregion stp_IU_SyncSnapshotActivityType

-- #region stp_IU_SyncSnapshotActivityTypeBusinessLine

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_test AS 
BEGIN 

	DECLARE @InsertedDate DATETIME = GETDATE() -- will be used as the lookup
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	
	DECLARE @ActivityTypeBusinessLineId INT = (SELECT MAX(ActivityTypeBusinessLineId) FROM GDM.dbo.ActivityTypeBusinessLine) + 1
	
	IF EXISTS(SELECT ActivityTypeBusinessLineId FROM GDM.dbo.SnapshotActivityTypeBusinessLine WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ActivityTypeBusinessLine Test data already exists', 16, 1)

	DECLARE @ActivityTypeId1 INT = (SELECT ActivityTypeId from Gdm.dbo.ActivityType WHERE Code = 'SYN')
	DECLARE @ActivityTypeId2 INT = (SELECT ActivityTypeId from Gdm.dbo.ActivityType WHERE Code = 'ORG')

	DECLARE @BusinessLineTypeId1 INT = (SELECT BusinessLineId from Gdm.dbo.BusinessLine WHERE Name = 'Leasing')
	DECLARE @BusinessLineTypeId2 INT = (SELECT BusinessLineId from Gdm.dbo.BusinessLine WHERE Name = 'Development')


	INSERT GDM.dbo.SnapshotActivityTypeBusinessLine
	(
		SnapshotId,
		ActivityTypeBusinessLineId,
		ActivityTypeId,
		BusinessLineId,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsActive
	)       
	VALUES
	(
		@SnapshotId,
		@ActivityTypeBusinessLineId,
		@ActivityTypeId1,
		@BusinessLineTypeId1,
		@InsertedDate,
		convert(datetime,'May  7 2011  3:24AM'),
		'-1',
		'1'
	)		
	
	--IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM GDM.dbo.ActivityTypeBusinessLine WHERE InsertedDate = @InsertedDate)
	--	RAISERROR ('ActivityTypeBusinessLine Testdata expected to exist', 16, 1)

		--PRINT @ActivityTypeBusinessLineId
	--SELECT * FROM  GDM.dbo.ActivityTypeBusinessLine
	IF @ActivityTypeBusinessLineId IS NULL
		RAISERROR ('ActivityTypeBusinessLine could not initialise ActivityTypeBusinessLineId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
	
    IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.SnapshotActivityTypeBusinessLine
		WHERE 
			SnapshotId = @SnapshotId AND
			ActivityTypeId = @ActivityTypeId1 AND
			BusinessLineId = @BusinessLineTypeId1 AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId = -1 AND
			IsActive = 1 AND		
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		RAISERROR ('ActivityTypeBusinessLine Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotActivityTypeBusinessLine SET 
		ActivityTypeId = @ActivityTypeId2,
		BusinessLineId = @BusinessLineTypeId2,
		InsertedDate = @InsertedDate,
		UpdatedDate = convert(datetime,'May  7 2011  3:24AM'),
		UpdatedByStaffId = 1,
		IsActive = 1
	WHERE 
		--Code = 'LEASEABC'
		ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId AND
		SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
	
    IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.SnapshotActivityTypeBusinessLine
		WHERE 
			SnapshotId = @SnapshotId AND
		    ActivityTypeId = @ActivityTypeId2 AND
			BusinessLineId = @BusinessLineTypeId2 AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId = 1 AND
			IsActive = 1 AND		
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		RAISERROR ('Property Fund Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotActivityTypeBusinessLine SET 
				ActivityTypeId = @ActivityTypeId1,
				BusinessLineId = @BusinessLineTypeId1,
				InsertedDate = @InsertedDate,
				UpdatedDate = convert(datetime,'May  7 2011  3:22AM'),
				UpdatedByStaffId = -1,
				IsActive = 0
		WHERE 
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId AND
			SnapshotId = @SnapshotId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC @return_value = [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.SnapshotActivityTypeBusinessLine
		WHERE 
			SnapshotId = @SnapshotId AND
			ActivityTypeId = @ActivityTypeId2 AND
			BusinessLineId = @BusinessLineTypeId2 AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId = 1 AND
			IsActive = 1 AND		
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotActivityTypeBusinessLine WHERE ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotActivityTypeBusinessLine]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotActivityTypeBusinessLine  WHERE ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'ActivityTypeBusinessLine Expected DeActivated record'
    --IF EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.ActivityTypeBusinessLine  WHERE ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_setup
	EXEC #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_test 
	EXEC #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_teardown 
END
GO

-- #endregion stp_IU_SyncSnapshotActivityTypeBusinessLine

-- #region stp_IU_SyncSnapshotBusinessLine
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT BusinessLineId FROM GDM.dbo.SnapshotBusinessLine WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('BusinessLine Test data already exists', 16, 1)
		
	INSERT INTO GDM.dbo.BusinessLine
	(
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)       
	VALUES(
		'Unknown2',
		'1',
		@InsertedDate,
		convert(datetime,'May  7 2011  3:24AM'),
		'-1'
	)
	DECLARE @BusinessLineId INT = (SELECT @@IDENTITY)
	EXEC stp_IU_SyncBusinessLine
	
	
	
	INSERT GDM.dbo.SnapshotBusinessLine
	(
		SnapshotId,
		BusinessLineId,
		Name,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)       
	VALUES(
		@SnapshotId,
		@BusinessLineId,
		'Unknown2',
		'1',
		@InsertedDate,
		convert(datetime,'May  7 2011  3:24AM'),
		'-1'
	)
	
	
	
	--(SELECT BusinessLineId FROM GDM.dbo.BusinessLine WHERE  InsertedDate = @InsertedDate)
	--PRINT @BusinessLineId
	--SELECT * FROM  GDM.dbo.BusinessLine
	IF @BusinessLineId IS NULL
		RAISERROR ('BusinessLine could not initialise BusinessLineId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotBusinessLine]
	
    IF NOT EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.SnapshotBusinessLine
		WHERE 		
			Name = 'Unknown2' AND
			IsActive = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId	= '-1' AND
			BusinessLineId = @BusinessLineId AND 
			SnapshotId = @SnapshotId)
		RAISERROR ('BusinessLine Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotBusinessLine SET 
			Name = 'Unknown3',
			IsActive = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  7 2011  3:22AM'),
			UpdatedByStaffId	= '1' 
		WHERE 
			--Code = 'LEASEABC'
			BusinessLineId = @BusinessLineId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotBusinessLine]
	
    IF NOT EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.SnapshotBusinessLine
		WHERE 
		  	Name = 'Unknown3' AND
			IsActive = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:22AM') AND
			UpdatedByStaffId	= '1' AND
			BusinessLineId = @BusinessLineId AND
			SnapshotId = @SnapshotId)

		RAISERROR ('BusinessLine Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotBusinessLine SET 
			Name = 'Unknown4',
			IsActive = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  7 2011  3:21AM'),
			UpdatedByStaffId	= '-1' 
		WHERE 
			BusinessLineId = @BusinessLineId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotBusinessLine]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.SnapshotBusinessLine
		WHERE 
		 	Name = 'Unknown3' AND
			IsActive = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:22AM') AND
			UpdatedByStaffId	= '1' AND
			BusinessLineId = @BusinessLineId AND
			SnapshotId = @SnapshotId)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotBusinessLine WHERE BusinessLineId = @BusinessLineId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotBusinessLine]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotBusinessLine  WHERE BusinessLineId = @BusinessLineId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'BusinessLine Expected DeActivated record'
    --IF EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.BusinessLine  WHERE BusinessLineId = @BusinessLineId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotBusinessLine_setup
	EXEC #ut_stp_IU_SyncSnapshotBusinessLine_test 
	EXEC #ut_stp_IU_SyncSnapshotBusinessLine_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotBusinessLine

-- #region stp_IU_SyncSnapshotEntityType
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotEntityType_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotEntityType_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	
	DECLARE @EntityTypeId INT = (SELECT MAX(EntityTypeId) FROM GDM.dbo.EntityType) + 1
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT EntityTypeId FROM GDM.dbo.EntityType WHERE InsertedDate = @InsertedDate)
		RAISERROR ('EntityType Test data already exists', 16, 1)
		
	INSERT GDM.dbo.SnapshotEntityType
	(
		SnapshotId,
		EntityTypeId,
		Name,
		ProjectCodePortion,
		Description,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId
	)       
	VALUES(
		@SnapshotId,
		@EntityTypeId,
		'To Be Confirmed2',
		'9',
		'To Be Confirmed2',
		'1',
		@InsertedDate,
		convert(datetime,'Jul 24 2010  5:34AM'),
		'-1')				
	
	IF @EntityTypeId IS NULL
		RAISERROR ('EntityType could not initialise EntityTypeId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotEntityType]
	
    IF NOT EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.SnapshotEntityType
		WHERE 		
			Name = 'To Be Confirmed2' AND
			ProjectCodePortion = '9' AND
			Description = 'To Be Confirmed2' AND
			IsActive = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:34AM') AND
			UpdatedByStaffId = '-1'	AND
			EntityTypeId = @EntityTypeId AND
			SnapshotId = @SnapshotId)
		RAISERROR ('EntityType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotEntityType SET 
			Name = 'To Be Confirmed3',
			ProjectCodePortion = '9',
			Description = 'To Be Confirmed3',
			IsActive = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM'),
			UpdatedByStaffId = '-1'	
		WHERE 
			--Code = 'LEASEABC'
			EntityTypeId = @EntityTypeId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotEntityType]
	
    IF NOT EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.SnapshotEntityType
		WHERE 
		  	Name = 'To Be Confirmed3' AND
			ProjectCodePortion = '9' AND
			Description = 'To Be Confirmed3' AND
			IsActive = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM') AND
			UpdatedByStaffId = '-1'	AND
			EntityTypeId = @EntityTypeId AND
			SnapshotId = @SnapshotId
			)

		RAISERROR ('EntityType Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotEntityType SET 
			Name = 'To Be Confirmed4',
			ProjectCodePortion = '9',
			Description = 'To Be Confirmed4',
			IsActive = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM'),
			UpdatedByStaffId = '-1'	
		WHERE 
			EntityTypeId = @EntityTypeId AND
			SnapshotId = @SnapshotId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotEntityType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.SnapshotEntityType
		WHERE 
		 	Name = 'To Be Confirmed3' AND
			ProjectCodePortion = '9' AND
			Description = 'To Be Confirmed3' AND
			IsActive = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM') AND
			UpdatedByStaffId = '-1'	AND
			EntityTypeId = @EntityTypeId AND
			SnapshotId = @SnapshotId)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotEntityType WHERE EntityTypeId = @EntityTypeId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotEntityType]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotEntityType  WHERE EntityTypeId = @EntityTypeId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'Property Expected DeActivated record'
    --IF EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.EntityType  WHERE EntityTypeId = @EntityTypeId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotEntityType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotEntityType AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotEntityType_setup
	EXEC #ut_stp_IU_SyncSnapshotEntityType_test 
	EXEC #ut_stp_IU_SyncSnapshotEntityType_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotEntityType

-- #region stp_IU_SyncSnapshotGlobalRegion
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion_test AS 
BEGIN 
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT GlobalRegionId FROM GDM.dbo.SnapshotGlobalRegion WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GlobalRegion Test data already exists', 16, 1)
	
	INSERT GDM.dbo.GlobalRegion(
		ParentGlobalRegionId,
		CountryId,
		Code,
		Name,
		IsAllocationRegion,
		IsOriginatingRegion,
		DefaultCurrencyCode,
		DefaultCorporateSourceCode,
		ProjectCodePortion,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsConsolidationRegion)       
	VALUES('32','2','EUF2','EU Funds2','1','0','EU2','EC','11','1',@InsertedDate,convert(datetime,'Jul 24 2010  5:27AM'),'-1','0')		

	DECLARE @GlobalRegionId INT = (SELECT @@IDENTITY)
	EXEC stp_IU_SyncGlobalRegion
	
	
		
	INSERT GDM.dbo.SnapshotGlobalRegion(
		SnapshotId,
		GlobalRegionId,
		ParentGlobalRegionId,
		CountryId,
		Code,
		Name,
		IsAllocationRegion,
		IsOriginatingRegion,
		DefaultCurrencyCode,
		DefaultCorporateSourceCode,
		ProjectCodePortion,
		IsActive,
		InsertedDate,
		UpdatedDate,
		UpdatedByStaffId,
		IsConsolidationRegion)       
	VALUES(@SnapshotId, @GlobalRegionId, '32','2','EUF2','EU Funds2','1','0','EU2','EC','11','1',@InsertedDate,convert(datetime,'Jul 24 2010  5:27AM'),'-1','0')		
	
	IF @GlobalRegionId IS NULL
		RAISERROR ('GlobalRegion could not initialise GlobalRegionId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGlobalRegion]
	
    IF NOT EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.SnapshotGlobalRegion
		WHERE 		
			ParentGlobalRegionId = '32' AND
			CountryId = '2' AND
			Code = 'EUF2' AND
			Name = 'EU Funds2' AND
			IsAllocationRegion = '1' AND
			IsOriginatingRegion = '0' AND
			DefaultCurrencyCode = 'EU2' AND
			DefaultCorporateSourceCode = 'EC' AND
			ProjectCodePortion = '11' AND
			IsActive = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM') AND
			UpdatedByStaffId = '-1' AND
			IsConsolidationRegion = '0' AND
			GlobalRegionId = @GlobalRegionId AND
			SnapshotId = @SnapshotId)
		RAISERROR ('GlobalRegion Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotGlobalRegion SET 
			ParentGlobalRegionId = '32',
			CountryId = '1',
			Code = 'EUF3',
			Name = 'EU Funds3',
			IsAllocationRegion = '0',
			IsOriginatingRegion = '1',
			DefaultCurrencyCode = 'EU3',
			DefaultCorporateSourceCode = 'EC',
			ProjectCodePortion = '11',
			IsActive = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM'),
			UpdatedByStaffId = '-1',
			IsConsolidationRegion = '0'
		WHERE 
			--Code = 'LEASEABC'
			GlobalRegionId = @GlobalRegionId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGlobalRegion]
	
    IF NOT EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.SnapshotGlobalRegion
		WHERE 
		  	ParentGlobalRegionId = '32' AND
			CountryId = '1' AND
			Code = 'EUF3' AND
			Name = 'EU Funds3' AND
			IsAllocationRegion = '0' AND
			IsOriginatingRegion = '1' AND
			DefaultCurrencyCode = 'EU3' AND
			DefaultCorporateSourceCode = 'EC' AND
			ProjectCodePortion = '11' AND
			IsActive = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM') AND
			UpdatedByStaffId = '-1' AND
			IsConsolidationRegion = '0' AND
			GlobalRegionId = @GlobalRegionId AND
			SnapshotId = @SnapshotId)

		RAISERROR ('GlobalRegion Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotGlobalRegion SET 
			ParentGlobalRegionId = '32',
			CountryId = '1',
			Code = 'EUF4',
			Name = 'EU Funds4',
			IsAllocationRegion = '0',
			IsOriginatingRegion = '1',
			DefaultCurrencyCode = 'EU4',
			DefaultCorporateSourceCode = 'EC',
			ProjectCodePortion = '11',
			IsActive = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM'),
			UpdatedByStaffId = '-1',
			IsConsolidationRegion = '0'
		WHERE 
			GlobalRegionId = @GlobalRegionId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'GlobalRegion Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGlobalRegion]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.SnapshotGlobalRegion
		WHERE 
			SnapshotId = @SnapshotId AND
		 	ParentGlobalRegionId = '32' AND
			CountryId = '1' AND
			Code = 'EUF3' AND
			Name = 'EU Funds3' AND
			IsAllocationRegion = '0' AND
			IsOriginatingRegion = '1' AND
			DefaultCurrencyCode = 'EU3' AND
			DefaultCorporateSourceCode = 'EC' AND
			ProjectCodePortion = '11' AND
			IsActive = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM') AND
			UpdatedByStaffId = '-1' AND
			IsConsolidationRegion = '0' AND
			GlobalRegionId = @GlobalRegionId)
		RAISERROR ('GlobalRegion Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotGlobalRegion WHERE GlobalRegionId = @GlobalRegionId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotGlobalRegion]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotGlobalRegion  WHERE GlobalRegionId = @GlobalRegionId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'GlobalRegion Expected DeActivated record'
    --IF EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.GlobalRegion  WHERE GlobalRegionId = @GlobalRegionId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotGlobalRegion_setup
	EXEC #ut_stp_IU_SyncSnapshotGlobalRegion_test 
	EXEC #ut_stp_IU_SyncSnapshotGlobalRegion_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotGlobalRegion

-- #region stp_IU_SyncSnapshotManageType
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageType_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageType_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)	
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManageTypeId FROM GDM.dbo.SnapshotManageType WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ManageType Test data already exists', 16, 1)
		
	INSERT GDM.dbo.ManageType(Code,Name,Description,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('GMREXCL2','Global Management Report Exclusion2','Items that are excluded by the Global Management Reports2','0',@InsertedDate,convert(datetime,'Nov  8 2010  3:16AM'),'-1')
		
	DECLARE @ManageTypeId INT = (SELECT @@IDENTITY)
	EXEC stp_IU_SyncManageType
	
	INSERT GDM.dbo.SnapshotManageType(SnapshotId, ManageTypeId, Code,Name,Description,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ManageTypeId, 'GMREXCL2','Global Management Report Exclusion2','Items that are excluded by the Global Management Reports2','0',@InsertedDate,convert(datetime,'Nov  8 2010  3:16AM'),'-1')
	
	IF @ManageTypeId IS NULL
		RAISERROR ('ManageType could not initialise ManageTypeId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageType]
	
    IF NOT EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.SnapshotManageType
		WHERE 		
			SnapshotId = @SnapshotId AND
			Code = 'GMREXCL2' AND
			Name = 'Global Management Report Exclusion2' AND
			Description = 'Items that are excluded by the Global Management Reports2' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM') AND
			UpdatedByStaffId = '-1' AND
			ManageTypeId = @ManageTypeId)
		RAISERROR ('ManageType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotManageType SET 
			Code = 'GMREXCL3',		
			Name = 'Global Management Report Exclusion3',
			Description = 'Items that are excluded by the Global Management Reports3',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			ManageTypeId = @ManageTypeId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageType]
	
    IF NOT EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.SnapshotManageType
		WHERE 
			SnapshotId = @SnapshotId AND
			Code = 'GMREXCL3' AND
			Name = 'Global Management Report Exclusion3' AND
			Description = 'Items that are excluded by the Global Management Reports3' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM') AND
			UpdatedByStaffId = '-1' AND
			ManageTypeId = @ManageTypeId)

		RAISERROR ('ManageType Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotManageType SET 
			Code = 'GMREXCL4',		
			Name = 'Global Management Report Exclusion4',
			Description = 'Items that are excluded by the Global Management Reports4',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			ManageTypeId = @ManageTypeId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ManageType Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.SnapshotManageType
		WHERE 
			SnapshotId = @SnapshotId AND
			Code = 'GMREXCL3' AND
			Name = 'Global Management Report Exclusion3' AND
			Description = 'Items that are excluded by the Global Management Reports3' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM') AND
			UpdatedByStaffId = '-1' AND
			ManageTypeId = @ManageTypeId)
		RAISERROR ('ManageType Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotManageType WHERE ManageTypeId = @ManageTypeId AND SnapshotId = @SnapshotId
	
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageType]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotManageType  WHERE ManageTypeId = @ManageTypeId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManageType Expected DeActivated record'
    --IF EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.ManageType  WHERE ManageTypeId = @ManageTypeId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageType AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotManageType_setup
	EXEC #ut_stp_IU_SyncSnapshotManageType_test 
	EXEC #ut_stp_IU_SyncSnapshotManageType_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotManageType

-- #region stp_IU_SyncSnapshotManageCorporateDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ManageCorporateDepartmentId INT = (SELECT MAX(ManageCorporateDepartmentId) FROM GDM.dbo.ManageCorporateDepartment) + 1

	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManageCorporateDepartmentId FROM GDM.dbo.SnapshotManageCorporateDepartment WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ManageCorporateDepartment Test data already exists', 16, 1)
		
	
	INSERT GDM.dbo.SnapshotManageCorporateDepartment(SnapshotId, ManageCorporateDepartmentId, ManageTypeId,CorporateDepartmentCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ManageCorporateDepartmentId, '1','017181  ','EC','0',@InsertedDate,convert(datetime,'Jun  9 2011 10:59AM'),'255')

	IF @ManageCorporateDepartmentId IS NULL
		RAISERROR ('ManageCorporateDepartment could not initialise ManageCorporateDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]
	
    IF NOT EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotManageCorporateDepartment
		WHERE 	
			SnapshotId = @SnapshotId AND	
			ManageTypeId = '1' AND
			CorporateDepartmentCode = '017181  ' AND
			SourceCode= 'EC' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  9 2011 10:59AM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
		RAISERROR ('ManageCorporateDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotManageCorporateDepartment SET 
			ManageTypeId = '1',
			CorporateDepartmentCode = '017182  ',
			SourceCode= 'BC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  9 2011 10:58AM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]
	
    IF NOT EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotManageCorporateDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			CorporateDepartmentCode = '017182  ' AND
			SourceCode= 'BC' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  9 2011 10:58AM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId)

		RAISERROR ('ManageCorporateDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotManageCorporateDepartment SET 
			ManageTypeId = '1',
			CorporateDepartmentCode = '017183  ',
			SourceCode= 'CC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  9 2011 10:57AM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ManageCorporateDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotManageCorporateDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			CorporateDepartmentCode = '017182  ' AND
			SourceCode= 'BC' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  9 2011 10:58AM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
		RAISERROR ('ManageCorporateDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotManageCorporateDepartment WHERE ManageCorporateDepartmentId = @ManageCorporateDepartmentId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotManageCorporateDepartment  WHERE ManageCorporateDepartmentId = @ManageCorporateDepartmentId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManageCorporateDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.ManageCorporateDepartment  WHERE ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotManageCorporateDepartment_setup
	EXEC #ut_stp_IU_SyncSnapshotManageCorporateDepartment_test 
	EXEC #ut_stp_IU_SyncSnapshotManageCorporateDepartment_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotManageCorporateDepartment

-- #region stp_IU_SyncSnapshotManageCorporateEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ManageCorporateEntityId INT = (SELECT MAX(ManageCorporateEntityId) FROM GDM.dbo.ManageCorporateEntity) + 1
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManageCorporateEntityId FROM GDM.dbo.SnapshotManageCorporateEntity WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ManageCorporateEntity Test data already exists', 16, 1)

	
	INSERT GDM.dbo.SnapshotManageCorporateEntity(SnapshotId, ManageCorporateEntityId, ManageTypeId,CorporateEntityCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ManageCorporateEntityId, '1','11006 ','EC','0',@InsertedDate,convert(datetime,'May  5 2011  8:11PM'),'255')
	
	IF @ManageCorporateEntityId IS NULL
		RAISERROR ('ManageCorporateEntity could not initialise ManageCorporateEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]
	
    IF NOT EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.SnapshotManageCorporateEntity
		WHERE
			SnapshotId = @SnapshotId AND 		
			ManageTypeId = '1' AND
			CorporateEntityCode = '11006 ' AND
			SourceCode = 'EC' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  5 2011  8:11PM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateEntityId = @ManageCorporateEntityId)
		RAISERROR ('ManageCorporateEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotManageCorporateEntity SET 
			ManageTypeId = '1',
			CorporateEntityCode = '11007 ',
			SourceCode = 'EC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  5 2011  8:10PM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManageCorporateEntityId = @ManageCorporateEntityId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]
	
    IF NOT EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.SnapshotManageCorporateEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			CorporateEntityCode = '11007 ' AND
			SourceCode = 'EC' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  5 2011  8:10PM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateEntityId = @ManageCorporateEntityId)

		RAISERROR ('ManageCorporateEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotManageCorporateEntity SET 
			ManageTypeId = '1',
			CorporateEntityCode = '11008 ',
			SourceCode = 'EC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  5 2011  8:09PM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManageCorporateEntityId = @ManageCorporateEntityId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ManageCorporateEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]
		
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.SnapshotManageCorporateEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			CorporateEntityCode = '11007 ' AND
			SourceCode = 'EC' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  5 2011  8:10PM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateEntityId = @ManageCorporateEntityId)
		RAISERROR ('ManageCorporateEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotManageCorporateEntity WHERE ManageCorporateEntityId = @ManageCorporateEntityId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManageCorporateEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotManageCorporateEntity  WHERE ManageCorporateEntityId = @ManageCorporateEntityId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManageCorporateEntity Expected DeActivated record'
    --IF EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.ManageCorporateEntity  WHERE ManageCorporateEntityId = @ManageCorporateEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotManageCorporateEntity_setup
	EXEC #ut_stp_IU_SyncSnapshotManageCorporateEntity_test 
	EXEC #ut_stp_IU_SyncSnapshotManageCorporateEntity_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotManageCorporateEntity

-- #region stp_IU_SyncSnapshotManagePropertyDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ManagePropertyDepartmentId INT = (SELECT MAX(ManagePropertyDepartmentId) FROM GDM.dbo.ManagePropertyDepartment) + 1
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManagePropertyDepartmentId FROM GDM.dbo.SnapshotManagePropertyDepartment WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ManagePropertyDepartment Test data already exists', 16, 1)
		
	INSERT GDM.dbo.SnapshotManagePropertyDepartment(SnapshotId, ManagePropertyDepartmentId, ManageTypeId,PropertyDepartmentCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ManagePropertyDepartmentId,'1','TSP2    ','US','0',@InsertedDate,convert(datetime,'Jun  7 2011 10:05PM'),'255')
	
	IF @ManagePropertyDepartmentId IS NULL
		RAISERROR ('ManagePropertyDepartment could not initialise ManagePropertyDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]
	
    IF NOT EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.SnapshotManagePropertyDepartment
		WHERE 		
			SnapshotId = @SnapshotId AND 
			ManageTypeId = '1' AND
			PropertyDepartmentCode = 'TSP2    ' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  7 2011 10:05PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		RAISERROR ('ManagePropertyDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotManagePropertyDepartment SET 
			ManageTypeId = '1',
			PropertyDepartmentCode = 'TSP3    ',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  7 2011 10:04PM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]
	
    IF NOT EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.SnapshotManagePropertyDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			PropertyDepartmentCode = 'TSP3    ' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  7 2011 10:04PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		RAISERROR ('ManagePropertyDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotManagePropertyDepartment SET 
			ManageTypeId = '1',
			PropertyDepartmentCode = 'TSP4    ',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  7 2011 10:03PM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ManagePropertyDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.SnapshotManagePropertyDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			PropertyDepartmentCode = 'TSP3    ' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  7 2011 10:04PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		RAISERROR ('ManagePropertyDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotManagePropertyDepartment WHERE ManagePropertyDepartmentId = @ManagePropertyDepartmentId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotManagePropertyDepartment  WHERE ManagePropertyDepartmentId = @ManagePropertyDepartmentId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManagePropertyDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.ManagePropertyDepartment  WHERE ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotManagePropertyDepartment_setup
	EXEC #ut_stp_IU_SyncSnapshotManagePropertyDepartment_test 
	EXEC #ut_stp_IU_SyncSnapshotManagePropertyDepartment_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotManagePropertyDepartment

-- #region stp_IU_SyncSnapshotManagePropertyEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity_test AS 
BEGIN 
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ManagePropertyEntityId INT = (SELECT MAX(ManagePropertyEntityId) FROM GDM.dbo.ManagePropertyEntity) + 1
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManagePropertyEntityId FROM GDM.dbo.SnapshotManagePropertyEntity WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ManagePropertyEntity Test data already exists', 16, 1)
	
	INSERT GDM.dbo.SnapshotManagePropertyEntity(SnapshotId, ManagePropertyEntityId, ManageTypeId,PropertyEntityCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ManagePropertyEntityId,'1','RCLAN2','EU','1',@InsertedDate,convert(datetime,'Jun 13 2011  6:08PM'),'255')	
	
	
	
	IF @ManagePropertyEntityId IS NULL
		RAISERROR ('ManagePropertyEntity could not initialise ManagePropertyEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]
	
    IF NOT EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.SnapshotManagePropertyEntity
		WHERE
			SnapshotId = @SnapshotId AND 		
			ManageTypeId = '1' AND
			PropertyEntityCode = 'RCLAN2' AND
			SourceCode = 'EU' AND
			IsDeleted = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun 13 2011  6:08PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyEntityId = @ManagePropertyEntityId)
		RAISERROR ('ManagePropertyEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotManagePropertyEntity SET 
			ManageTypeId = '1',
			PropertyEntityCode = 'RCLAN3',
			SourceCode = 'US',
			IsDeleted = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManagePropertyEntityId = @ManagePropertyEntityId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]
	
    IF NOT EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.SnapshotManagePropertyEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			ManageTypeId = '1' AND
			PropertyEntityCode = 'RCLAN3' AND
			SourceCode = 'US' AND
			IsDeleted = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyEntityId = @ManagePropertyEntityId)

		RAISERROR ('ManagePropertyEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotManagePropertyEntity SET 
			ManageTypeId = '1',
			PropertyEntityCode = 'RCLAN4',
			SourceCode = 'EU',
			IsDeleted = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManagePropertyEntityId = @ManagePropertyEntityId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ManagePropertyEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.SnapshotManagePropertyEntity
		WHERE 
			ManageTypeId = '1' AND
			PropertyEntityCode = 'RCLAN3' AND
			SourceCode = 'US' AND
			IsDeleted = '1' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyEntityId = @ManagePropertyEntityId AND
			SnapshotId = @SnapshotId)
		RAISERROR ('ManagePropertyEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotManagePropertyEntity WHERE ManagePropertyEntityId = @ManagePropertyEntityId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotManagePropertyEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotManagePropertyEntity  WHERE ManagePropertyEntityId = @ManagePropertyEntityId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManagePropertyEntity Expected DeActivated record'
    --IF EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.ManagePropertyEntity  WHERE ManagePropertyEntityId = @ManagePropertyEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotManagePropertyEntity_setup
	EXEC #ut_stp_IU_SyncSnapshotManagePropertyEntity_test 
	EXEC #ut_stp_IU_SyncSnapshotManagePropertyEntity_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotManagePropertyEntity

-- #region stp_IU_SyncSnapshotOriginatingRegionCorporateEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @OriginatingRegionCorporateEntityId INT = (SELECT MAX(OriginatingRegionCorporateEntityId) FROM GDM.dbo.OriginatingRegionCorporateEntity) + 1
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT OriginatingRegionCorporateEntityId FROM GDM.dbo.SnapshotOriginatingRegionCorporateEntity WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('OriginatingRegionCorporateEntity Test data already exists', 16, 1)
		
	INSERT GDM.dbo.SnapshotOriginatingRegionCorporateEntity(SnapshotId, OriginatingRegionCorporateEntityId, GlobalRegionId,CorporateEntityCode,SourceCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @OriginatingRegionCorporateEntityId, '41','HKCON2 ','UC',@InsertedDate,convert(datetime,'May  6 2011  6:44AM'),'-1')
	
	IF @OriginatingRegionCorporateEntityId IS NULL
		RAISERROR ('OriginatingRegionCorporateEntity could not initialise OriginatingRegionCorporateEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]
	
    IF NOT EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.SnapshotOriginatingRegionCorporateEntity
		WHERE 		
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '41' AND
			CorporateEntityCode = 'HKCON2 ' AND
			SourceCode = 'UC' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  6 2011  6:44AM') AND
			UpdatedByStaffId = '-1'	 AND
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
		RAISERROR ('OriginatingRegionCorporateEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotOriginatingRegionCorporateEntity SET 
			GlobalRegionId = '41',
			CorporateEntityCode = 'HKCON3 ',
			SourceCode = 'UC',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  6 2011  6:43AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]
	
    IF NOT EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.SnapshotOriginatingRegionCorporateEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '41' AND
			CorporateEntityCode = 'HKCON3 ' AND
			SourceCode = 'UC' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  6 2011  6:43AM') AND
			UpdatedByStaffId = '-1'	 AND
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)

		RAISERROR ('OriginatingRegionCorporateEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotOriginatingRegionCorporateEntity SET 
			GlobalRegionId = '41',
			CorporateEntityCode = 'HKCON4 ',
			SourceCode = 'UC',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  6 2011  6:42AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'OriginatingRegionCorporateEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.SnapshotOriginatingRegionCorporateEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '41' AND
			CorporateEntityCode = 'HKCON3 ' AND
			SourceCode = 'UC' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  6 2011  6:43AM') AND
			UpdatedByStaffId = '-1'	 AND
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
		RAISERROR ('OriginatingRegionCorporateEntity Expected GR to lose Changes', 16, 1)    		
	
	DELETE FROM Gdm.dbo.SnapshotOriginatingRegionCorporateEntity WHERE OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionCorporateEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotOriginatingRegionCorporateEntity  WHERE OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'OriginatingRegionCorporateEntity Expected DeActivated record'
    --IF EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.OriginatingRegionCorporateEntity  WHERE OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_setup
	EXEC #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_test 
	EXEC #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotOriginatingRegionCorporateEntity

-- #region stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @OriginatingRegionPropertyDepartmentId INT = (SELECT MAX(OriginatingRegionPropertyDepartmentId) FROM GDM.dbo.OriginatingRegionPropertyDepartment) + 1
	
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM GDM.dbo.SnapshotOriginatingRegionPropertyDepartment WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('OriginatingRegionPropertyDepartment Test data already exists', 16, 1)

	INSERT GDM.dbo.SnapshotOriginatingRegionPropertyDepartment(SnapshotId, OriginatingRegionPropertyDepartmentId,GlobalRegionId,PropertyDepartmentCode,SourceCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @OriginatingRegionPropertyDepartmentId, '12','GRWOF2','US',@InsertedDate,convert(datetime,'May 23 2011  7:07AM'),'-1')
	
	
	IF @OriginatingRegionPropertyDepartmentId IS NULL
		RAISERROR ('OriginatingRegionPropertyDepartment could not initialise OriginatingRegionPropertyDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]
	
    IF NOT EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.SnapshotOriginatingRegionPropertyDepartment
		WHERE 		
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '12' AND
			PropertyDepartmentCode = 'GRWOF2' AND
			SourceCode = 'US' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May 23 2011  7:07AM') AND
			UpdatedByStaffId = '-1' AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
		RAISERROR ('OriginatingRegionPropertyDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotOriginatingRegionPropertyDepartment SET 
			GlobalRegionId = '12',
			PropertyDepartmentCode = 'GRWOF3',
			SourceCode = 'EU',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May 23 2011  7:06AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			SnapshotId = @SnapshotId AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]
	
    IF NOT EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.SnapshotOriginatingRegionPropertyDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '12' AND
			PropertyDepartmentCode = 'GRWOF3' AND
			SourceCode = 'EU' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May 23 2011  7:06AM') AND
			UpdatedByStaffId = '-1' AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)

		RAISERROR ('OriginatingRegionPropertyDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotOriginatingRegionPropertyDepartment SET 
			GlobalRegionId = '12',
			PropertyDepartmentCode = 'GRWOF4',
			SourceCode = 'US',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May 23 2011  7:05AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			SnapshotId = @SnapshotId AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId
	EXEC #AssertInt @@RowCount, 1, 'OriginatingRegionPropertyDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.SnapshotOriginatingRegionPropertyDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '12' AND
			PropertyDepartmentCode = 'GRWOF3' AND
			SourceCode = 'EU' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May 23 2011  7:06AM') AND
			UpdatedByStaffId = '-1' AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
		RAISERROR ('OriginatingRegionPropertyDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotOriginatingRegionPropertyDepartment WHERE OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotOriginatingRegionPropertyDepartment  WHERE OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'OriginatingRegionPropertyDepartment Expected DeActivated record'
    --IF EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.OriginatingRegionPropertyDepartment  WHERE OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_setup
	EXEC #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_test 
	EXEC #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_teardown 
END
GO

-- #endregion stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment

-- #region stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @PropertyEntityGLAccountInclusionId INT = (SELECT MAX(PropertyEntityGLAccountInclusionId) FROM GDM.dbo.PropertyEntityGLAccountInclusion) + 1

	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM GDM.dbo.SnapshotPropertyEntityGLAccountInclusion WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('PropertyEntityGLAccountInclusion Test data already exists', 16, 1)
		
	INSERT GDM.dbo.SnapshotPropertyEntityGLAccountInclusion(SnapshotId, PropertyEntityGLAccountInclusionId, PropertyEntityCode,GLAccountCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @PropertyEntityGLAccountInclusionId,'VALKH2','TE5014000008','EU','0',@InsertedDate,convert(datetime,'Oct 12 2010  1:51AM'),'-1')
	

	IF @PropertyEntityGLAccountInclusionId IS NULL
		RAISERROR ('PropertyEntityGLAccountInclusion could not initialise PropertyEntityGLAccountInclusionId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]
	
    IF NOT EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.SnapshotPropertyEntityGLAccountInclusion
		WHERE 		
			SnapshotId = @SnapshotId AND
			PropertyEntityCode = 'VALKH2' AND
			GLAccountCode = 'TE5014000008' AND
			SourceCode = 'EU' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Oct 12 2010  1:51AM') AND
			UpdatedByStaffId = '-1' AND
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
		RAISERROR ('PropertyEntityGLAccountInclusion Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotPropertyEntityGLAccountInclusion SET 
			PropertyEntityCode = 'VALKH3',
			GLAccountCode = 'TE5014000007',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]
	
    IF NOT EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.SnapshotPropertyEntityGLAccountInclusion
		WHERE 
			SnapshotId = @SnapshotId AND
			PropertyEntityCode = 'VALKH3' AND
			GLAccountCode = 'TE5014000007' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM') AND
			UpdatedByStaffId = '-1' AND
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)

		RAISERROR ('PropertyEntityGLAccountInclusion Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotPropertyEntityGLAccountInclusion SET 
			PropertyEntityCode = 'VALKH4',
			GLAccountCode = 'TE5014000007',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'PropertyEntityGLAccountInclusion Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.SnapshotPropertyEntityGLAccountInclusion
		WHERE 
			SnapshotId = @SnapshotId AND
			PropertyEntityCode = 'VALKH3' AND
			GLAccountCode = 'TE5014000007' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM') AND
			UpdatedByStaffId = '-1' AND
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
		RAISERROR ('PropertyEntityGLAccountInclusion Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotPropertyEntityGLAccountInclusion WHERE PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotPropertyEntityGLAccountInclusion  WHERE PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'PropertyEntityGLAccountInclusion Expected DeActivated record'
    --IF EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.PropertyEntityGLAccountInclusion  WHERE PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_setup
	EXEC #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_test 
	EXEC #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion

-- #region stp_IU_SyncSnapshotReportingEntityCorporateDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ReportingEntityCorporateDepartmentId INT = (SELECT MAX(ReportingEntityCorporateDepartmentId) FROM GDM.dbo.SnapshotReportingEntityCorporateDepartment) + 1


	DECLARE @InsertedDate DATETIME = GETDATE() 
	
	IF EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM GDM.dbo.SnapshotReportingEntityCorporateDepartment WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ReportingEntityCorporateDepartment Test data already exists', 16, 1)

	INSERT GDM.dbo.SnapshotReportingEntityCorporateDepartment(SnapshotId, ReportingEntityCorporateDepartmentId, PropertyFundId,SourceCode,CorporateDepartmentCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ReportingEntityCorporateDepartmentId, '2715','EC','108723',@InsertedDate,convert(datetime,'Jul  1 2011  9:52AM'),'255')
	
	IF @ReportingEntityCorporateDepartmentId IS NULL
		RAISERROR ('ReportingEntityCorporateDepartment could not initialise ReportingEntityCorporateDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
	
    IF NOT EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotReportingEntityCorporateDepartment
		WHERE
			SnapshotId = @SnapshotId AND 		
			PropertyFundId = '2715' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108723' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:52AM') AND
			UpdatedByStaffId = '255' AND
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
		RAISERROR ('ReportingEntityCorporateDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotReportingEntityCorporateDepartment SET 
			PropertyFundId = '2715',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108721',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
	
    IF NOT EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotReportingEntityCorporateDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			PropertyFundId = '2715' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)

		RAISERROR ('ReportingEntityCorporateDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotReportingEntityCorporateDepartment SET 
			PropertyFundId = '2715',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108720',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:50AM'),
			UpdatedByStaffId = '255'
		WHERE 
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ReportingEntityCorporateDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotReportingEntityCorporateDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			PropertyFundId = '2715' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
		RAISERROR ('ReportingEntityCorporateDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotReportingEntityCorporateDepartment WHERE SnapshotId = @SnapshotId AND ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityCorporateDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotReportingEntityCorporateDepartment  WHERE SnapshotId = @SnapshotId AND ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ReportingEntityCorporateDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.ReportingEntityCorporateDepartment  WHERE ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_setup
	EXEC #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_test 
	EXEC #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotReportingEntityCorporateDepartment

-- #region stp_IU_SyncSnapshotReportingEntityPropertyEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ReportingEntityPropertyEntityId INT = (SELECT MAX(ReportingEntityPropertyEntityId) FROM GDM.dbo.SnapshotReportingEntityPropertyEntity) + 1

	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ReportingEntityPropertyEntityId FROM GDM.dbo.SnapshotReportingEntityPropertyEntity WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ReportingEntityPropertyEntity Test data already exists', 16, 1)
	

	INSERT GDM.dbo.SnapshotReportingEntityPropertyEntity(SnapshotId, ReportingEntityPropertyEntityId, PropertyFundId,SourceCode,PropertyEntityCode,InsertedDate,UpdatedDate,UpdatedByStaffId,IsPrimary)       
	VALUES(@SnapshotId, @ReportingEntityPropertyEntityId, '2508','US','RCPAY2',@InsertedDate,convert(datetime,'Jul  5 2011  8:25AM'),'7740','0')
	
	IF @ReportingEntityPropertyEntityId IS NULL
		RAISERROR ('ReportingEntityPropertyEntity could not initialise ReportingEntityPropertyEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
	
    IF NOT EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.SnapshotReportingEntityPropertyEntity
		WHERE 		
			SnapshotId = @SnapshotId AND
			PropertyFundId = '2508' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY2' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:25AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
		RAISERROR ('ReportingEntityPropertyEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotReportingEntityPropertyEntity SET 
			PropertyFundId = '2508',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY3',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM'),
			UpdatedByStaffId = '7740',
			IsPrimary = '0'
		WHERE 
			--Code = 'LEASEABC'
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
	
    IF NOT EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.SnapshotReportingEntityPropertyEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			PropertyFundId = '2508' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)

		RAISERROR ('ReportingEntityPropertyEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotReportingEntityPropertyEntity SET 
			PropertyFundId = '2508',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY4',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:23AM'),
			UpdatedByStaffId = '7740'--,
			--IsPrimary = '0'
		WHERE 
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ReportingEntityPropertyEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
		
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.SnapshotReportingEntityPropertyEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			PropertyFundId = '2508' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
		RAISERROR ('ReportingEntityPropertyEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotReportingEntityPropertyEntity WHERE ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotReportingEntityPropertyEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.SnapshotReportingEntityPropertyEntity  WHERE ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ReportingEntityPropertyEntity Expected DeActivated record'
    --IF EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.ReportingEntityPropertyEntity  WHERE ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_setup
	EXEC #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_test 
	EXEC #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotReportingEntityPropertyEntity

-- #region stp_IU_SyncSnapshotPropertyFund
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund_setup AS 
BEGIN 

	EXEC #AssertBit 1,  1


	--EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund_test AS 
BEGIN 
	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	

	IF EXISTS(SELECT PropertyFundId FROM GDM.dbo.SnapshotPropertyFund WHERE Name = 'German ClubABC')
		RAISERROR ('PropertyFund Test data already exists', 16, 1)
		
		
	INSERT GDM.dbo.PropertyFund(RelatedFundId,EntityTypeId,AllocationSubRegionGlobalRegionId,BudgetOwnerStaffId,RegionalOwnerStaffId,Name,IsReportingEntity,IsPropertyFund,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('26','1','42','494','-1', 'German ClubABC','1','1','1',convert(datetime,'Jun 30 2011  5:14PM'),convert(datetime,'Jun 30 2011  5:14PM'),'255')

	DECLARE @PropertyFundId INT = (SELECT @@IDENTITY)

	IF @PropertyFundId IS NULL
		RAISERROR ('PropertyFund could not initialise PropertyFundId', 16, 1)
	EXEC stp_IU_SyncPropertyFund
	
	INSERT GDM.dbo.SnapshotPropertyFund(SnapshotId, PropertyFundId, RelatedFundId,EntityTypeId,AllocationSubRegionGlobalRegionId,BudgetOwnerStaffId,RegionalOwnerStaffId,Name,IsReportingEntity,IsPropertyFund,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @PropertyFundId, '26','1','42','494','-1', 'German ClubABC','1','1','1',convert(datetime,'Jun 30 2011  5:14PM'),convert(datetime,'Jun 30 2011  5:14PM'),'255')
	
	IF NOT EXISTS(SELECT PropertyFundId FROM GDM.dbo.SnapshotPropertyFund WHERE Name = 'German ClubABC')
		RAISERROR ('PropertyFund Test data could not be inserted', 16, 1)
	
	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyFund]
	
    IF NOT EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.SnapshotPropertyFund
		WHERE 
			SnapshotId = @SnapshotId AND
		    RelatedFundId = '26' AND
		    EntityTypeId = '1' AND
		    AllocationSubRegionGlobalRegionId =  '42' AND
		    BudgetOwnerStaffId = '494' AND
		    RegionalOwnerStaffId = '-1' AND
		    Name = 'German ClubABC' AND
		    IsReportingEntity = '1' AND
		    IsPropertyFund = '1' AND
		    IsActive = '1' AND
		    InsertedDate = convert(datetime,'Jun 30 2011  5:14PM') AND
		    UpdatedDate = convert(datetime,'Jun 30 2011  5:14PM') AND
		PropertyFundId = @PropertyFundId)
		RAISERROR ('PropertyFund Record not synched', 16, 1)    	
	
	
	DECLARE @NewDate DATETIME = GETDATE()
	UPDATE 	Gdm.dbo.SnapshotPropertyFund SET 
		    RelatedFundId = '27',
		    EntityTypeId = '2',
		    AllocationSubRegionGlobalRegionId =  '1',
		    BudgetOwnerStaffId = '495',
		    RegionalOwnerStaffId = '1',
		    Name = 'German ClubABC2',
		    IsReportingEntity = '0',
		    IsPropertyFund = '0',
		    IsActive = '0',
		    InsertedDate = convert(datetime,'Jun 30 2011  5:15PM'),
		    UpdatedDate = convert(datetime,'Jun 30 2011  5:15PM')
	WHERE 
		--Code = 'LEASEABC'
		PropertyFundId = @PropertyFundId AND
		SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyFund]
	
    IF NOT EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.SnapshotPropertyFund
		WHERE 
			SnapshotId = @SnapshotId AND
			RelatedFundId = '27' AND
		    EntityTypeId = '2' AND
		    AllocationSubRegionGlobalRegionId =  '1' AND
		    BudgetOwnerStaffId = '495' AND
		    RegionalOwnerStaffId = '1' AND
		    Name = 'German ClubABC2' AND
		    IsReportingEntity = '0' AND
		    IsPropertyFund = '0' AND
		    IsActive = '0' AND
		    InsertedDate = convert(datetime,'Jun 30 2011  5:15PM') AND
		    UpdatedDate = convert(datetime,'Jun 30 2011  5:15PM') AND
		PropertyFundId = @PropertyFundId)
		RAISERROR ('Property Fund Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotPropertyFund SET 
				RelatedFundId = '28',
				EntityTypeId = '1',
				AllocationSubRegionGlobalRegionId =  '2',
				BudgetOwnerStaffId = '494',
				RegionalOwnerStaffId = '1',
				Name = 'German ClubABC3',
				IsReportingEntity = '1',
				IsPropertyFund = '1',
				IsActive = '1',
				InsertedDate = convert(datetime,'Jun 30 2011  5:13PM'),
				UpdatedDate = convert(datetime,'Jun 30 2011  5:13PM')
		WHERE 
			PropertyFundId = @PropertyFundId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyFund]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.SnapshotPropertyFund
		WHERE 
			SnapshotId = @SnapshotId AND
			RelatedFundId = '27' AND
		    EntityTypeId = '2' AND
		    AllocationSubRegionGlobalRegionId =  '1' AND
		    BudgetOwnerStaffId = '495' AND
		    RegionalOwnerStaffId = '1' AND
		    Name = 'German ClubABC2' AND
		    IsReportingEntity = '0' AND
		    IsPropertyFund = '0' AND
		    IsActive = '0' AND
		    InsertedDate = convert(datetime,'Jun 30 2011  5:15PM') AND
		    UpdatedDate = convert(datetime,'Jun 30 2011  5:15PM') AND
		PropertyFundId = @PropertyFundId)	
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotPropertyFund WHERE PropertyFundId = @PropertyFundId AND SnapshotId = @SnapshotId
	
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotPropertyFund]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.SnapshotPropertyFund  WHERE PropertyFundId = @PropertyFundId AND SnapshotId = @SnapshotId)
	
	EXEC #AssertBit @IsActive, 0, 'Property Expected DeActivated record'
    --IF EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.PropertyFund  WHERE PropertyFundId = @PropertyFundId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotPropertyFund_setup
	EXEC #ut_stp_IU_SyncSnapshotPropertyFund_test 
	EXEC #ut_stp_IU_SyncSnapshotPropertyFund_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotPropertyFund

-- #region stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ConsolidationRegionCorporateDepartmentId INT = (SELECT MAX(ConsolidationRegionCorporateDepartmentId) FROM GDM.dbo.SnapshotConsolidationRegionCorporateDepartment) + 1


	DECLARE @InsertedDate DATETIME = GETDATE() 
	
	IF EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM GDM.dbo.SnapshotConsolidationRegionCorporateDepartment WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ConsolidationRegionCorporateDepartment Test data already exists', 16, 1)

	INSERT GDM.dbo.SnapshotConsolidationRegionCorporateDepartment(SnapshotId, ConsolidationRegionCorporateDepartmentId, GlobalRegionId,SourceCode,CorporateDepartmentCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ConsolidationRegionCorporateDepartmentId, '40','EC','108723',@InsertedDate,convert(datetime,'Jul  1 2011  9:52AM'),'255')
	
	IF @ConsolidationRegionCorporateDepartmentId IS NULL
		RAISERROR ('ConsolidationRegionCorporateDepartment could not initialise ConsolidationRegionCorporateDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]
	
    IF NOT EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotConsolidationRegionCorporateDepartment
		WHERE
			SnapshotId = @SnapshotId AND 		
			GlobalRegionId = '40' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108723' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:52AM') AND
			UpdatedByStaffId = '255' AND
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
		RAISERROR ('ConsolidationRegionCorporateDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotConsolidationRegionCorporateDepartment SET 
			GlobalRegionId = '39',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108721',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]
	
    IF NOT EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotConsolidationRegionCorporateDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '39' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)

		RAISERROR ('ConsolidationRegionCorporateDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotConsolidationRegionCorporateDepartment SET 
			GlobalRegionId = '27',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108720',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:50AM'),
			UpdatedByStaffId = '255'
		WHERE 
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ConsolidationRegionCorporateDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.SnapshotConsolidationRegionCorporateDepartment
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '39' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
		RAISERROR ('ConsolidationRegionCorporateDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotConsolidationRegionCorporateDepartment WHERE SnapshotId = @SnapshotId AND ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment]
	
	IF EXISTS (SELECT * FROM Gdm_GR.dbo.SnapshotConsolidationRegionCorporateDepartment WHERE SnapshotId = @SnapshotId AND ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId) 
	RAISERROR ('ConsolidationRegionCorporateDepartment Expected DeActivated record', 16, 1)  
    --IF EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.ConsolidationRegionCorporateDepartment  WHERE ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_setup
	EXEC #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_test 
	EXEC #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment

-- #region stp_IU_SyncSnapshotConsolidationRegionPropertyEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_test AS 
BEGIN 

	DECLARE @SnapshotId INT = (SELECT MAX(SnapshotId) FROM GDM_GR.dbo.Snapshot)
	DECLARE @ConsolidationRegionPropertyEntityId INT = (SELECT MAX(ConsolidationRegionPropertyEntityId) FROM GDM.dbo.SnapshotConsolidationRegionPropertyEntity) + 1

	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM GDM.dbo.SnapshotConsolidationRegionPropertyEntity WHERE InsertedDate = @InsertedDate AND SnapshotId = @SnapshotId)
		RAISERROR ('ConsolidationRegionPropertyEntity Test data already exists', 16, 1)
	

		
	INSERT GDM.dbo.SnapshotConsolidationRegionPropertyEntity(SnapshotId, ConsolidationRegionPropertyEntityId, GlobalRegionId,SourceCode,PropertyEntityCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES(@SnapshotId, @ConsolidationRegionPropertyEntityId, '40','US','RCPAY2',@InsertedDate,convert(datetime,'Jul  5 2011  8:25AM'),'7740')
	
	IF @ConsolidationRegionPropertyEntityId IS NULL
		RAISERROR ('ConsolidationRegionPropertyEntity could not initialise ConsolidationRegionPropertyEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]
	
    IF NOT EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.SnapshotConsolidationRegionPropertyEntity
		WHERE 		
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '40' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY2' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:25AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
		RAISERROR ('ConsolidationRegionPropertyEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.SnapshotConsolidationRegionPropertyEntity SET 
			GlobalRegionId = '39',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY3',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM'),
			UpdatedByStaffId = '7740'
		WHERE 
			--Code = 'LEASEABC'
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId AND
			SnapshotId = @SnapshotId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]
	
    IF NOT EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.SnapshotConsolidationRegionPropertyEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '39' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)

		RAISERROR ('ConsolidationRegionPropertyEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.SnapshotConsolidationRegionPropertyEntity SET 
			GlobalRegionId = '27',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY4',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:23AM'),
			UpdatedByStaffId = '7740'--,
			
		WHERE 
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId AND
			SnapshotId = @SnapshotId
			
	EXEC #AssertInt @@RowCount, 1, 'ConsolidationRegionPropertyEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]
		
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.SnapshotConsolidationRegionPropertyEntity
		WHERE 
			SnapshotId = @SnapshotId AND
			GlobalRegionId = '39' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			--InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
		RAISERROR ('ConsolidationRegionPropertyEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.SnapshotConsolidationRegionPropertyEntity WHERE ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId AND SnapshotId = @SnapshotId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncSnapshotConsolidationRegionPropertyEntity]
	
	IF EXISTS(SELECT * FROM Gdm_GR.dbo.SnapshotConsolidationRegionPropertyEntity WHERE ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId AND SnapshotId = @SnapshotId)
	RAISERROR ('ConsolidationRegionPropertyEntity Expected Deleted record', 16, 1)  

    --IF EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.ConsolidationRegionPropertyEntity  WHERE ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO

CREATE PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity AS
BEGIN
	EXEC #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_setup
	EXEC #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_test 
	EXEC #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_teardown 
END
GO
-- #endregion stp_IU_SyncSnapshotConsolidationRegionPropertyEntity

----------------------------------------------
---- Run tests
-----------------------------------------------


BEGIN TRAN


CREATE TABLE #Tests
(
	TestName VARCHAR(250)
)
INSERT #Tests (TestName)
SELECT '#ut_stp_IU_SyncSnapshotActivityType' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotActivityTypeBusinessLine' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotBusinessLine' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotEntityType' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotGlobalRegion' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotManageType' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotManageCorporateDepartment' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotManageCorporateEntity' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotManagePropertyDepartment' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotManagePropertyEntity' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity' UNION ALL
SELECT '#ut_stp_IU_SyncSnapshotPropertyFund'

EXEC #RunTests
   
  
--SELECT * FROM GDM.dbo.ActivityType

ROLLBACK


/* --- TEMPLATE  ------ COPY HERE ------- 

-- #region ut_PROCNAME
GO
CREATE PROCEDURE #ut_PROCNAME_test AS 
BEGIN 
	EXEC #AssertBit 0, 1, 'NOT IMPLEMENTED'
END 

-- #endregion ut_PROCNAME

 --- END TEMPLATE  ------ COPY HERE -------*/
 
 DROP PROCEDURE #AssertInt
DROP PROCEDURE #AssertBit
DROP PROCEDURE #AssertVarchar
DROP PROCEDURE #RunPhase 
DROP PROCEDURE #RunTests
 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityType
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityType_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityType_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityType_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotActivityTypeBusinessLine_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine
DROP PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotBusinessLine_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotEntityType
DROP PROCEDURE #ut_stp_IU_SyncSnapshotEntityType_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotEntityType_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotEntityType_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotGlobalRegion_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageType
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageType_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageType_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageType_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateDepartment_teardown 


DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManageCorporateEntity_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyDepartment_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotManagePropertyEntity_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity
DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionCorporateEntity_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment
DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion
DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment
DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityCorporateDepartment_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity
DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotReportingEntityPropertyEntity_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment
DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionCorporateDepartment_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity
DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotConsolidationRegionPropertyEntity_teardown 

DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund
DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund_setup
DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund_test 
DROP PROCEDURE #ut_stp_IU_SyncSnapshotPropertyFund_teardown 