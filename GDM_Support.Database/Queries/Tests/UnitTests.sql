USE [GDM_GR]

SET NOCOUNT ON

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncActivityType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncActivityType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncActivityType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncActivityType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncActivityType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncActivityType_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncPropertyFund_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncPropertyFund_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncPropertyFund_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncPropertyFund_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncPropertyFund_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncPropertyFund_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncActivityTypeBusinessLine_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncActivityTypeBusinessLine_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncActivityTypeBusinessLine_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncActivityTypeBusinessLine_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncActivityTypeBusinessLine_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncActivityTypeBusinessLine_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncBusinessLine_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncBusinessLine_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncBusinessLine_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncBusinessLine_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncBusinessLine_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncBusinessLine_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncEntityType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncEntityType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncEntityType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncEntityType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncEntityType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncEntityType_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGlobalRegion_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGlobalRegion_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGlobalRegion_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGlobalRegion_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncGlobalRegion_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncGlobalRegion_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageType_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageType_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageType_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageType_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageType_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageType_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageCorporateDepartment_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageCorporateDepartment_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageCorporateDepartment_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageCorporateDepartment_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageCorporateDepartment_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageCorporateDepartment_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageCorporateEntity_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageCorporateEntity_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageCorporateEntity_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageCorporateEntity_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManageCorporateEntity_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManageCorporateEntity_teardown


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManagePropertyDepartment_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManagePropertyDepartment_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManagePropertyDepartment_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManagePropertyDepartment_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManagePropertyDepartment_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManagePropertyDepartment_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManagePropertyEntity_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManagePropertyEntity_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManagePropertyEntity_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManagePropertyEntity_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncManagePropertyEntity_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncManagePropertyEntity_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncOriginatingRegionCorporateEntity_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncOriginatingRegionCorporateEntity_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncOriginatingRegionCorporateEntity_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncOriginatingRegionCorporateEntity_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncOriginatingRegionCorporateEntity_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncOriginatingRegionCorporateEntity_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncOriginatingRegionPropertyDepartment_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncOriginatingRegionPropertyDepartment_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncOriginatingRegionPropertyDepartment_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncOriginatingRegionPropertyDepartment_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncOriginatingRegionPropertyDepartment_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncOriginatingRegionPropertyDepartment_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncPropertyEntityGLAccountInclusion_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncPropertyEntityGLAccountInclusion_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncPropertyEntityGLAccountInclusion_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncPropertyEntityGLAccountInclusion_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncPropertyEntityGLAccountInclusion_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncPropertyEntityGLAccountInclusion_teardown


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncReportingEntityCorporateDepartment_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncReportingEntityCorporateDepartment_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncReportingEntityCorporateDepartment_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncReportingEntityCorporateDepartment_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncReportingEntityCorporateDepartment_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncReportingEntityCorporateDepartment_teardown


IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncReportingEntityPropertyEntity_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncReportingEntityPropertyEntity_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncReportingEntityPropertyEntity_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncReportingEntityPropertyEntity_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncReportingEntityPropertyEntity_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncReportingEntityPropertyEntity_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncConsolidationRegionPropertyEntity_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncConsolidationRegionPropertyEntity_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncConsolidationRegionPropertyEntity_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncConsolidationRegionPropertyEntity_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncConsolidationRegionPropertyEntity_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncConsolidationRegionPropertyEntity_teardown

IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncConsolidationRegionCorporateDepartment_setup') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncConsolidationRegionCorporateDepartment_setup
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncConsolidationRegionCorporateDepartment_test') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncConsolidationRegionCorporateDepartment_test
IF 	OBJECT_ID('tempdb..#ut_stp_IU_SyncConsolidationRegionCorporateDepartment_teardown') IS NOT NULL
	DROP PROCEDURE #ut_stp_IU_SyncConsolidationRegionCorporateDepartment_teardown

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
	EXEC #RunPhase 'teardown'	
	PRINT '>>>>>>>>>>> Teardown Success'
END
GO
----------------------------------------------------------------------------------------
--- TESTS
----------------------------------------------------------------------------------------

-- #region ut_stp_IU_SyncActivityType
-- Setup
GO
CREATE PROCEDURE #ut_stp_IU_SyncActivityType_setup AS 
BEGIN 
  --EXEC #AssertInt 1, 0, 'Error in value'
  
  IF EXISTS(SELECT ActivityTypeId FROM  GDM.dbo.ActivityType WHERE Code = 'LEASEABC' AND Name = 'LeasingABC')
		RAISERROR ('Test data already exists', 16, 1)
  IF EXISTS(SELECT ActivityTypeId FROM  GDM_GR.dbo.ActivityType WHERE Code = 'LEASEABC' AND Name = 'LeasingABC')
		RAISERROR ('Test data already exists', 16, 1)
  INSERT Gdm.dbo.ActivityType(Code,Name,GLAccountSuffix,IsEscalatable,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
  VALUES('LEASEABC','LeasingABC','31','0','1',convert(datetime,'Jul 24 2010  4:30AM'),convert(datetime,'Jul 24 2010  4:30AM'),'-1') 
  
END 
-- Test
GO
CREATE PROCEDURE #ut_stp_IU_SyncActivityType_test AS 
BEGIN 
	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityType]
	
    IF NOT EXISTS(SELECT ActivityTypeId FROM  GDM_GR.dbo.ActivityType 
		WHERE Code = 'LEASEABC' AND Name = 'LeasingABC')
		RAISERROR ('Record not synched', 16, 1)    	
	
	DECLARE @ActivityTypeId INT 
	SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')
	
	DECLARE @NewDate DATETIME = GETDATE()
	DECLARE @FutureDate DATETIME = @NewDate + 1
	
	UPDATE 	Gdm.dbo.ActivityType SET 
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
		ActivityTypeId = @ActivityTypeId
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityType]
	
	IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.ActivityType WHERE
		Code = 'LEASEABC2' AND
		Name = 'LeasingABC2' AND
		GLAccountSuffix = '31' AND
		IsEscalatable = 0 AND
		InsertedDate = @FutureDate AND
		UpdatedDate = @NewDate AND
		UpdatedByStaffId = 1)
		RAISERROR ('Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ActivityType SET 
		Name = 'LeasingABC3',
		Code = 'LEASEABC3',
		GLAccountSuffix = '32',
		IsEscalatable = 0,
		UpdatedDate = @NewDate,
		UpdatedByStaffId = 1
	--WHERE Code = 'LEASEABC'
	WHERE ActivityTypeId = @ActivityTypeId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityType]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
	IF NOT EXISTS(SELECT * FROM Gdm_GR.dbo.ActivityType WHERE
		Code = 'LEASEABC2' AND
		Name = 'LeasingABC2' AND
		GLAccountSuffix = '31' AND
		IsEscalatable = 0 AND
		InsertedDate = @FutureDate AND
		UpdatedDate = @NewDate AND
		UpdatedByStaffId = 1)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	UPDATE 	Gdm_GR.dbo.ActivityType SET Name = 'LeasingABC3' WHERE 
		--Code = 'LEASEABC'
		ActivityTypeId = @ActivityTypeId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityType]

	DELETE FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC2'
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be inserted'
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityType]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
	
    IF EXISTS(SELECT ActivityTypeId FROM  GDM_GR.dbo.ActivityType WHERE Code = 'LEASEABC' AND IsActive = 1)
		RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	EXEC #AssertInt 1, 1, 'Error in value'
END
-- Teardown
GO
CREATE PROCEDURE #ut_stp_IU_SyncActivityType_tearDown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END
GO
-- #endregion ut_stp_IU_SyncActivityType


-- #region stp_IU_SyncActivityTypeBusinessLine
GO
CREATE PROCEDURE #ut_stp_IU_SyncActivityTypeBusinessLine_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncActivityTypeBusinessLine_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() -- will be used as the lookup
	IF EXISTS(SELECT ActivityTypeBusinessLineId FROM GDM.dbo.ActivityTypeBusinessLine WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ActivityTypeBusinessLine Test data already exists', 16, 1)

	DECLARE @ActivityTypeId1 INT = (SELECT ActivityTypeId from Gdm.dbo.ActivityType WHERE Code = 'SYN')
	DECLARE @ActivityTypeId2 INT = (SELECT ActivityTypeId from Gdm.dbo.ActivityType WHERE Code = 'ORG')

	DECLARE @BusinessLineTypeId1 INT = (SELECT BusinessLineId from Gdm.dbo.BusinessLine WHERE Name = 'Leasing')
	DECLARE @BusinessLineTypeId2 INT = (SELECT BusinessLineId from Gdm.dbo.BusinessLine WHERE Name = 'Development')


	INSERT GDM.dbo.ActivityTypeBusinessLine(ActivityTypeId,BusinessLineId,InsertedDate,UpdatedDate,UpdatedByStaffId,IsActive)       
	VALUES(@ActivityTypeId1,@BusinessLineTypeId1,@InsertedDate,convert(datetime,'May  7 2011  3:24AM'),'-1','1')		
	
	--IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM GDM.dbo.ActivityTypeBusinessLine WHERE InsertedDate = @InsertedDate)
	--	RAISERROR ('ActivityTypeBusinessLine Testdata expected to exist', 16, 1)

	DECLARE @ActivityTypeBusinessLineId INT = (SELECT @@IDENTITY) --(SELECT ActivityTypeBusinessLineId FROM GDM.dbo.ActivityTypeBusinessLine WHERE  InsertedDate = @InsertedDate)
	--PRINT @ActivityTypeBusinessLineId
	--SELECT * FROM  GDM.dbo.ActivityTypeBusinessLine
	IF @ActivityTypeBusinessLineId IS NULL
		RAISERROR ('ActivityTypeBusinessLine could not initialise ActivityTypeBusinessLineId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityTypeBusinessLine]
	
    IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.ActivityTypeBusinessLine
		WHERE 
			ActivityTypeId = @ActivityTypeId1 AND
			BusinessLineId = @BusinessLineTypeId1 AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId = -1 AND
			IsActive = 1 AND		
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		RAISERROR ('ActivityTypeBusinessLine Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ActivityTypeBusinessLine SET 
		ActivityTypeId = @ActivityTypeId2,
		BusinessLineId = @BusinessLineTypeId2,
		InsertedDate = @InsertedDate,
		UpdatedDate = convert(datetime,'May  7 2011  3:24AM'),
		UpdatedByStaffId = 1,
		IsActive = 1
	WHERE 
		--Code = 'LEASEABC'
		ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityTypeBusinessLine]
	
    IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.ActivityTypeBusinessLine
		WHERE 
		    ActivityTypeId = @ActivityTypeId2 AND
			BusinessLineId = @BusinessLineTypeId2 AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId = 1 AND
			IsActive = 1 AND		
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		RAISERROR ('Property Fund Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ActivityTypeBusinessLine SET 
				ActivityTypeId = @ActivityTypeId1,
				BusinessLineId = @BusinessLineTypeId1,
				InsertedDate = @InsertedDate,
				UpdatedDate = convert(datetime,'May  7 2011  3:22AM'),
				UpdatedByStaffId = -1,
				IsActive = 0
		WHERE 
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC @return_value = [dbo].[stp_IU_SyncActivityTypeBusinessLine]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.ActivityTypeBusinessLine
		WHERE 
		  ActivityTypeId = @ActivityTypeId2 AND
			BusinessLineId = @BusinessLineTypeId2 AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId = 1 AND
			IsActive = 1 AND		
			ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ActivityTypeBusinessLine WHERE ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncActivityTypeBusinessLine]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.ActivityTypeBusinessLine  WHERE ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
	
	EXEC #AssertBit @IsActive, 0, 'Property Expected DeActivated record'
    --IF EXISTS(SELECT ActivityTypeBusinessLineId FROM  GDM_GR.dbo.ActivityTypeBusinessLine  WHERE ActivityTypeBusinessLineId = @ActivityTypeBusinessLineId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncActivityTypeBusinessLine_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncActivityTypeBusinessLine


-- #region stp_IU_SyncBusinessLine
GO
CREATE PROCEDURE #ut_stp_IU_SyncBusinessLine_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncBusinessLine_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT BusinessLineId FROM GDM.dbo.BusinessLine WHERE InsertedDate = @InsertedDate)
		RAISERROR ('BusinessLine Test data already exists', 16, 1)
		
	INSERT GDM.dbo.BusinessLine(Name,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('Unknown2','1',@InsertedDate,convert(datetime,'May  7 2011  3:24AM'),'-1')
	
	DECLARE @BusinessLineId INT = (SELECT @@IDENTITY) --(SELECT BusinessLineId FROM GDM.dbo.BusinessLine WHERE  InsertedDate = @InsertedDate)
	--PRINT @BusinessLineId
	--SELECT * FROM  GDM.dbo.BusinessLine
	IF @BusinessLineId IS NULL
		RAISERROR ('BusinessLine could not initialise BusinessLineId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncBusinessLine]
	
    IF NOT EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.BusinessLine
		WHERE 		
			Name = 'Unknown2' AND
			IsActive = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:24AM') AND
			UpdatedByStaffId	= '-1' AND
			BusinessLineId = @BusinessLineId)
		RAISERROR ('BusinessLine Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.BusinessLine SET 
			Name = 'Unknown3',
			IsActive = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  7 2011  3:22AM'),
			UpdatedByStaffId	= '1' 
		WHERE 
			--Code = 'LEASEABC'
			BusinessLineId = @BusinessLineId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncBusinessLine]
	
    IF NOT EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.BusinessLine
		WHERE 
		  	Name = 'Unknown3' AND
			IsActive = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:22AM') AND
			UpdatedByStaffId	= '1' AND
			BusinessLineId = @BusinessLineId)

		RAISERROR ('BusinessLine Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.BusinessLine SET 
			Name = 'Unknown4',
			IsActive = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  7 2011  3:21AM'),
			UpdatedByStaffId	= '-1' 
		WHERE 
			BusinessLineId = @BusinessLineId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncBusinessLine]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.BusinessLine
		WHERE 
		 	Name = 'Unknown3' AND
			IsActive = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  7 2011  3:22AM') AND
			UpdatedByStaffId	= '1' AND
			BusinessLineId = @BusinessLineId)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.BusinessLine WHERE BusinessLineId = @BusinessLineId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncBusinessLine]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.BusinessLine  WHERE BusinessLineId = @BusinessLineId)
	
	EXEC #AssertBit @IsActive, 0, 'Property Expected DeActivated record'
    --IF EXISTS(SELECT BusinessLineId FROM  GDM_GR.dbo.BusinessLine  WHERE BusinessLineId = @BusinessLineId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncBusinessLine_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncBusinessLine


-- #region stp_IU_SyncEntityType
GO
CREATE PROCEDURE #ut_stp_IU_SyncEntityType_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncEntityType_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT EntityTypeId FROM GDM.dbo.EntityType WHERE InsertedDate = @InsertedDate)
		RAISERROR ('EntityType Test data already exists', 16, 1)
		
	INSERT GDM.dbo.EntityType(Name,ProjectCodePortion,Description,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('To Be Confirmed2','9','To Be Confirmed2','1',@InsertedDate,convert(datetime,'Jul 24 2010  5:34AM'),'-1')				
	DECLARE @EntityTypeId INT = (SELECT @@Identity)
	IF @EntityTypeId IS NULL
		RAISERROR ('EntityType could not initialise EntityTypeId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncEntityType]
	
    IF NOT EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.EntityType
		WHERE 		
			Name = 'To Be Confirmed2' AND
			ProjectCodePortion = '9' AND
			Description = 'To Be Confirmed2' AND
			IsActive = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:34AM') AND
			UpdatedByStaffId = '-1'	AND
			EntityTypeId = @EntityTypeId)
		RAISERROR ('EntityType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.EntityType SET 
			Name = 'To Be Confirmed3',
			ProjectCodePortion = '9',
			Description = 'To Be Confirmed3',
			IsActive = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM'),
			UpdatedByStaffId = '-1'	
		WHERE 
			--Code = 'LEASEABC'
			EntityTypeId = @EntityTypeId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncEntityType]
	
    IF NOT EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.EntityType
		WHERE 
		  	Name = 'To Be Confirmed3' AND
			ProjectCodePortion = '9' AND
			Description = 'To Be Confirmed3' AND
			IsActive = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM') AND
			UpdatedByStaffId = '-1'	AND
			EntityTypeId = @EntityTypeId)

		RAISERROR ('EntityType Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.EntityType SET 
			Name = 'To Be Confirmed4',
			ProjectCodePortion = '9',
			Description = 'To Be Confirmed4',
			IsActive = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM'),
			UpdatedByStaffId = '-1'	
		WHERE 
			EntityTypeId = @EntityTypeId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncEntityType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.EntityType
		WHERE 
		 	Name = 'To Be Confirmed3' AND
			ProjectCodePortion = '9' AND
			Description = 'To Be Confirmed3' AND
			IsActive = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:33AM') AND
			UpdatedByStaffId = '-1'	AND
			EntityTypeId = @EntityTypeId)
		RAISERROR ('Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.EntityType WHERE EntityTypeId = @EntityTypeId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncEntityType]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.EntityType  WHERE EntityTypeId = @EntityTypeId)
	
	EXEC #AssertBit @IsActive, 0, 'Property Expected DeActivated record'
    --IF EXISTS(SELECT EntityTypeId FROM  GDM_GR.dbo.EntityType  WHERE EntityTypeId = @EntityTypeId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncEntityType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncEntityType


-- #region stp_IU_SyncGlobalRegion
GO
CREATE PROCEDURE #ut_stp_IU_SyncGlobalRegion_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGlobalRegion_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT GlobalRegionId FROM GDM.dbo.GlobalRegion WHERE InsertedDate = @InsertedDate)
		RAISERROR ('GlobalRegion Test data already exists', 16, 1)
		
	INSERT GDM.dbo.GlobalRegion(ParentGlobalRegionId,CountryId,Code,Name,IsAllocationRegion,IsOriginatingRegion,DefaultCurrencyCode,DefaultCorporateSourceCode,ProjectCodePortion,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId,IsConsolidationRegion)       
	VALUES('32','2','EUF2','EU Funds2','1','0','EU2','EC','11','1',@InsertedDate,convert(datetime,'Jul 24 2010  5:27AM'),'-1','0')		
	DECLARE @GlobalRegionId INT = (SELECT @@Identity)
	IF @GlobalRegionId IS NULL
		RAISERROR ('GlobalRegion could not initialise GlobalRegionId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncGlobalRegion]
	
    IF NOT EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.GlobalRegion
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
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM') AND
			UpdatedByStaffId = '-1' AND
			IsConsolidationRegion = '0' AND
			GlobalRegionId = @GlobalRegionId)
		RAISERROR ('GlobalRegion Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.GlobalRegion SET 
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
			GlobalRegionId = @GlobalRegionId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncGlobalRegion]
	
    IF NOT EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.GlobalRegion
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
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM') AND
			UpdatedByStaffId = '-1' AND
			IsConsolidationRegion = '0' AND
			GlobalRegionId = @GlobalRegionId)

		RAISERROR ('GlobalRegion Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.GlobalRegion SET 
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
			GlobalRegionId = @GlobalRegionId
	EXEC #AssertInt @@RowCount, 1, 'GlobalRegion Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncGlobalRegion]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.GlobalRegion
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
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul 24 2010  5:27AM') AND
			UpdatedByStaffId = '-1' AND
			IsConsolidationRegion = '0' AND
			GlobalRegionId = @GlobalRegionId)
		RAISERROR ('GlobalRegion Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.GlobalRegion WHERE GlobalRegionId = @GlobalRegionId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncGlobalRegion]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.GlobalRegion  WHERE GlobalRegionId = @GlobalRegionId)
	
	EXEC #AssertBit @IsActive, 0, 'GlobalRegion Expected DeActivated record'
    --IF EXISTS(SELECT GlobalRegionId FROM  GDM_GR.dbo.GlobalRegion  WHERE GlobalRegionId = @GlobalRegionId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncGlobalRegion_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncGlobalRegion


-- #region stp_IU_SyncManageType
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageType_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageType_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManageTypeId FROM GDM.dbo.ManageType WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ManageType Test data already exists', 16, 1)
		
	INSERT GDM.dbo.ManageType(Code,Name,Description,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('GMREXCL2','Global Management Report Exclusion2','Items that are excluded by the Global Management Reports2','0',@InsertedDate,convert(datetime,'Nov  8 2010  3:16AM'),'-1')
	DECLARE @ManageTypeId INT = (SELECT @@Identity)
	IF @ManageTypeId IS NULL
		RAISERROR ('ManageType could not initialise ManageTypeId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncManageType]
	
    IF NOT EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.ManageType
		WHERE 		
			Code = 'GMREXCL2' AND
			Name = 'Global Management Report Exclusion2' AND
			Description = 'Items that are excluded by the Global Management Reports2' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM') AND
			UpdatedByStaffId = '-1' AND
			ManageTypeId = @ManageTypeId)
		RAISERROR ('ManageType Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ManageType SET 
			Code = 'GMREXCL3',		
			Name = 'Global Management Report Exclusion3',
			Description = 'Items that are excluded by the Global Management Reports3',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			ManageTypeId = @ManageTypeId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncManageType]
	
    IF NOT EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.ManageType
		WHERE 
			Code = 'GMREXCL3' AND
			Name = 'Global Management Report Exclusion3' AND
			Description = 'Items that are excluded by the Global Management Reports3' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM') AND
			UpdatedByStaffId = '-1' AND
			ManageTypeId = @ManageTypeId)

		RAISERROR ('ManageType Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ManageType SET 
			Code = 'GMREXCL4',		
			Name = 'Global Management Report Exclusion4',
			Description = 'Items that are excluded by the Global Management Reports4',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			ManageTypeId = @ManageTypeId
	EXEC #AssertInt @@RowCount, 1, 'ManageType Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncManageType]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.ManageType
		WHERE 
			Code = 'GMREXCL3' AND
			Name = 'Global Management Report Exclusion3' AND
			Description = 'Items that are excluded by the Global Management Reports3' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Nov  8 2010  3:16AM') AND
			UpdatedByStaffId = '-1' AND
			ManageTypeId = @ManageTypeId)
		RAISERROR ('ManageType Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ManageType WHERE ManageTypeId = @ManageTypeId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncManageType]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ManageType  WHERE ManageTypeId = @ManageTypeId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManageType Expected DeActivated record'
    --IF EXISTS(SELECT ManageTypeId FROM  GDM_GR.dbo.ManageType  WHERE ManageTypeId = @ManageTypeId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageType_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncManageType

-- #region stp_IU_SyncManageCorporateDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageCorporateDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageCorporateDepartment_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManageCorporateDepartmentId FROM GDM.dbo.ManageCorporateDepartment WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ManageCorporateDepartment Test data already exists', 16, 1)
		
	INSERT GDM.dbo.ManageCorporateDepartment(ManageTypeId,CorporateDepartmentCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('1','017181  ','EC','0',@InsertedDate,convert(datetime,'Jun  9 2011 10:59AM'),'255')
	DECLARE @ManageCorporateDepartmentId INT = (SELECT @@Identity)
	IF @ManageCorporateDepartmentId IS NULL
		RAISERROR ('ManageCorporateDepartment could not initialise ManageCorporateDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateDepartment]
	
    IF NOT EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.ManageCorporateDepartment
		WHERE 		
			ManageTypeId = '1' AND
			CorporateDepartmentCode = '017181  ' AND
			SourceCode= 'EC' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  9 2011 10:59AM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
		RAISERROR ('ManageCorporateDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ManageCorporateDepartment SET 
			ManageTypeId = '1',
			CorporateDepartmentCode = '017182  ',
			SourceCode= 'BC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  9 2011 10:58AM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateDepartment]
	
    IF NOT EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.ManageCorporateDepartment
		WHERE 
			ManageTypeId = '1' AND
			CorporateDepartmentCode = '017182  ' AND
			SourceCode= 'BC' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  9 2011 10:58AM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId)

		RAISERROR ('ManageCorporateDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ManageCorporateDepartment SET 
			ManageTypeId = '1',
			CorporateDepartmentCode = '017183  ',
			SourceCode= 'CC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  9 2011 10:57AM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId
	EXEC #AssertInt @@RowCount, 1, 'ManageCorporateDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.ManageCorporateDepartment
		WHERE 
			ManageTypeId = '1' AND
			CorporateDepartmentCode = '017182  ' AND
			SourceCode= 'BC' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  9 2011 10:58AM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
		RAISERROR ('ManageCorporateDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ManageCorporateDepartment WHERE ManageCorporateDepartmentId = @ManageCorporateDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ManageCorporateDepartment  WHERE ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManageCorporateDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ManageCorporateDepartmentId FROM  GDM_GR.dbo.ManageCorporateDepartment  WHERE ManageCorporateDepartmentId = @ManageCorporateDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageCorporateDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncManageCorporateDepartment



-- #region stp_IU_SyncManageCorporateEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageCorporateEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageCorporateEntity_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManageCorporateEntityId FROM GDM.dbo.ManageCorporateEntity WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ManageCorporateEntity Test data already exists', 16, 1)
		

	INSERT GDM.dbo.ManageCorporateEntity(ManageTypeId,CorporateEntityCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('1','11006 ','EC','0',@InsertedDate,convert(datetime,'May  5 2011  8:11PM'),'255')
	
	DECLARE @ManageCorporateEntityId INT = (SELECT @@Identity)
	IF @ManageCorporateEntityId IS NULL
		RAISERROR ('ManageCorporateEntity could not initialise ManageCorporateEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateEntity]
	
    IF NOT EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.ManageCorporateEntity
		WHERE 		
			ManageTypeId = '1' AND
			CorporateEntityCode = '11006 ' AND
			SourceCode = 'EC' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  5 2011  8:11PM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateEntityId = @ManageCorporateEntityId)
		RAISERROR ('ManageCorporateEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ManageCorporateEntity SET 
			ManageTypeId = '1',
			CorporateEntityCode = '11007 ',
			SourceCode = 'EC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  5 2011  8:10PM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManageCorporateEntityId = @ManageCorporateEntityId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateEntity]
	
    IF NOT EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.ManageCorporateEntity
		WHERE 
			ManageTypeId = '1' AND
			CorporateEntityCode = '11007 ' AND
			SourceCode = 'EC' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  5 2011  8:10PM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateEntityId = @ManageCorporateEntityId)

		RAISERROR ('ManageCorporateEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ManageCorporateEntity SET 
			ManageTypeId = '1',
			CorporateEntityCode = '11008 ',
			SourceCode = 'EC',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  5 2011  8:09PM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManageCorporateEntityId = @ManageCorporateEntityId
	EXEC #AssertInt @@RowCount, 1, 'ManageCorporateEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateEntity]
		
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.ManageCorporateEntity
		WHERE 
			ManageTypeId = '1' AND
			CorporateEntityCode = '11007 ' AND
			SourceCode = 'EC' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  5 2011  8:10PM') AND
			UpdatedByStaffId = '255' AND
			ManageCorporateEntityId = @ManageCorporateEntityId)
		RAISERROR ('ManageCorporateEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ManageCorporateEntity WHERE ManageCorporateEntityId = @ManageCorporateEntityId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncManageCorporateEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ManageCorporateEntity  WHERE ManageCorporateEntityId = @ManageCorporateEntityId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManageCorporateEntity Expected DeActivated record'
    --IF EXISTS(SELECT ManageCorporateEntityId FROM  GDM_GR.dbo.ManageCorporateEntity  WHERE ManageCorporateEntityId = @ManageCorporateEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManageCorporateEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncManageCorporateEntity


-- #region stp_IU_SyncManagePropertyDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncManagePropertyDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManagePropertyDepartment_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManagePropertyDepartmentId FROM GDM.dbo.ManagePropertyDepartment WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ManagePropertyDepartment Test data already exists', 16, 1)
		
	
	INSERT GDM.dbo.ManagePropertyDepartment(ManageTypeId,PropertyDepartmentCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('1','TSP2    ','US','0',@InsertedDate,convert(datetime,'Jun  7 2011 10:05PM'),'255')
	
	DECLARE @ManagePropertyDepartmentId INT = (SELECT @@Identity)
	IF @ManagePropertyDepartmentId IS NULL
		RAISERROR ('ManagePropertyDepartment could not initialise ManagePropertyDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyDepartment]
	
    IF NOT EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.ManagePropertyDepartment
		WHERE 		
			ManageTypeId = '1' AND
			PropertyDepartmentCode = 'TSP2    ' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  7 2011 10:05PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		RAISERROR ('ManagePropertyDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ManagePropertyDepartment SET 
			ManageTypeId = '1',
			PropertyDepartmentCode = 'TSP3    ',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  7 2011 10:04PM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyDepartment]
	
    IF NOT EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.ManagePropertyDepartment
		WHERE 
			ManageTypeId = '1' AND
			PropertyDepartmentCode = 'TSP3    ' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  7 2011 10:04PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		RAISERROR ('ManagePropertyDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ManagePropertyDepartment SET 
			ManageTypeId = '1',
			PropertyDepartmentCode = 'TSP4    ',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun  7 2011 10:03PM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId
	EXEC #AssertInt @@RowCount, 1, 'ManagePropertyDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.ManagePropertyDepartment
		WHERE 
			ManageTypeId = '1' AND
			PropertyDepartmentCode = 'TSP3    ' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun  7 2011 10:04PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		RAISERROR ('ManagePropertyDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ManagePropertyDepartment WHERE ManagePropertyDepartmentId = @ManagePropertyDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ManagePropertyDepartment  WHERE ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManagePropertyDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ManagePropertyDepartmentId FROM  GDM_GR.dbo.ManagePropertyDepartment  WHERE ManagePropertyDepartmentId = @ManagePropertyDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManagePropertyDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncManagePropertyDepartment

-- #region stp_IU_SyncManagePropertyEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncManagePropertyEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManagePropertyEntity_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ManagePropertyEntityId FROM GDM.dbo.ManagePropertyEntity WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ManagePropertyEntity Test data already exists', 16, 1)
	
	INSERT GDM.dbo.ManagePropertyEntity(ManageTypeId,PropertyEntityCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('1','RCLAN2','EU','1',@InsertedDate,convert(datetime,'Jun 13 2011  6:08PM'),'255')	
	
	
	DECLARE @ManagePropertyEntityId INT = (SELECT @@Identity)
	IF @ManagePropertyEntityId IS NULL
		RAISERROR ('ManagePropertyEntity could not initialise ManagePropertyEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyEntity]
	
    IF NOT EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.ManagePropertyEntity
		WHERE 		
			ManageTypeId = '1' AND
			PropertyEntityCode = 'RCLAN2' AND
			SourceCode = 'EU' AND
			IsDeleted = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun 13 2011  6:08PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyEntityId = @ManagePropertyEntityId)
		RAISERROR ('ManagePropertyEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ManagePropertyEntity SET 
			ManageTypeId = '1',
			PropertyEntityCode = 'RCLAN3',
			SourceCode = 'US',
			IsDeleted = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ManagePropertyEntityId = @ManagePropertyEntityId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyEntity]
	
    IF NOT EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.ManagePropertyEntity
		WHERE 
			ManageTypeId = '1' AND
			PropertyEntityCode = 'RCLAN3' AND
			SourceCode = 'US' AND
			IsDeleted = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyEntityId = @ManagePropertyEntityId)

		RAISERROR ('ManagePropertyEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ManagePropertyEntity SET 
			ManageTypeId = '1',
			PropertyEntityCode = 'RCLAN4',
			SourceCode = 'EU',
			IsDeleted = '1',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM'),
			UpdatedByStaffId = '255'
		WHERE 
			ManagePropertyEntityId = @ManagePropertyEntityId
	EXEC #AssertInt @@RowCount, 1, 'ManagePropertyEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyEntity]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.ManagePropertyEntity
		WHERE 
			ManageTypeId = '1' AND
			PropertyEntityCode = 'RCLAN3' AND
			SourceCode = 'US' AND
			IsDeleted = '1' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jun 13 2011  6:07PM') AND
			UpdatedByStaffId = '255' AND
			ManagePropertyEntityId = @ManagePropertyEntityId)
		RAISERROR ('ManagePropertyEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ManagePropertyEntity WHERE ManagePropertyEntityId = @ManagePropertyEntityId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncManagePropertyEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ManagePropertyEntity  WHERE ManagePropertyEntityId = @ManagePropertyEntityId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ManagePropertyEntity Expected DeActivated record'
    --IF EXISTS(SELECT ManagePropertyEntityId FROM  GDM_GR.dbo.ManagePropertyEntity  WHERE ManagePropertyEntityId = @ManagePropertyEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncManagePropertyEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncManagePropertyEntity



-- #region stp_IU_SyncOriginatingRegionCorporateEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncOriginatingRegionCorporateEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncOriginatingRegionCorporateEntity_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT OriginatingRegionCorporateEntityId FROM GDM.dbo.OriginatingRegionCorporateEntity WHERE InsertedDate = @InsertedDate)
		RAISERROR ('OriginatingRegionCorporateEntity Test data already exists', 16, 1)
		
	
	INSERT GDM.dbo.OriginatingRegionCorporateEntity(GlobalRegionId,CorporateEntityCode,SourceCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('41','HKCON2 ','UC',@InsertedDate,convert(datetime,'May  6 2011  6:44AM'),'-1')
	
	DECLARE @OriginatingRegionCorporateEntityId INT = (SELECT @@Identity)
	IF @OriginatingRegionCorporateEntityId IS NULL
		RAISERROR ('OriginatingRegionCorporateEntity could not initialise OriginatingRegionCorporateEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
	
    IF NOT EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.OriginatingRegionCorporateEntity
		WHERE 		
			GlobalRegionId = '41' AND
			CorporateEntityCode = 'HKCON2 ' AND
			SourceCode = 'UC' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  6 2011  6:44AM') AND
			UpdatedByStaffId = '-1'	 AND
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
		RAISERROR ('OriginatingRegionCorporateEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.OriginatingRegionCorporateEntity SET 
			GlobalRegionId = '41',
			CorporateEntityCode = 'HKCON3 ',
			SourceCode = 'UC',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  6 2011  6:43AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
	
    IF NOT EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.OriginatingRegionCorporateEntity
		WHERE 
			GlobalRegionId = '41' AND
			CorporateEntityCode = 'HKCON3 ' AND
			SourceCode = 'UC' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  6 2011  6:43AM') AND
			UpdatedByStaffId = '-1'	 AND
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)

		RAISERROR ('OriginatingRegionCorporateEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.OriginatingRegionCorporateEntity SET 
			GlobalRegionId = '41',
			CorporateEntityCode = 'HKCON4 ',
			SourceCode = 'UC',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May  6 2011  6:42AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId
	EXEC #AssertInt @@RowCount, 1, 'OriginatingRegionCorporateEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.OriginatingRegionCorporateEntity
		WHERE 
			GlobalRegionId = '41' AND
			CorporateEntityCode = 'HKCON3 ' AND
			SourceCode = 'UC' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May  6 2011  6:43AM') AND
			UpdatedByStaffId = '-1'	 AND
			OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
		RAISERROR ('OriginatingRegionCorporateEntity Expected GR to lose Changes', 16, 1)    		
	
	DELETE FROM Gdm.dbo.OriginatingRegionCorporateEntity WHERE OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionCorporateEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.OriginatingRegionCorporateEntity  WHERE OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
	
	EXEC #AssertBit @IsDeleted, 1, 'OriginatingRegionCorporateEntity Expected DeActivated record'
    --IF EXISTS(SELECT OriginatingRegionCorporateEntityId FROM  GDM_GR.dbo.OriginatingRegionCorporateEntity  WHERE OriginatingRegionCorporateEntityId = @OriginatingRegionCorporateEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncOriginatingRegionCorporateEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncOriginatingRegionCorporateEntity


-- #region stp_IU_SyncOriginatingRegionPropertyDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncOriginatingRegionPropertyDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncOriginatingRegionPropertyDepartment_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM GDM.dbo.OriginatingRegionPropertyDepartment WHERE InsertedDate = @InsertedDate)
		RAISERROR ('OriginatingRegionPropertyDepartment Test data already exists', 16, 1)
		

	INSERT GDM.dbo.OriginatingRegionPropertyDepartment(GlobalRegionId,PropertyDepartmentCode,SourceCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('12','GRWOF2','US',@InsertedDate,convert(datetime,'May 23 2011  7:07AM'),'-1')
	DECLARE @OriginatingRegionPropertyDepartmentId INT = (SELECT @@Identity)
	IF @OriginatingRegionPropertyDepartmentId IS NULL
		RAISERROR ('OriginatingRegionPropertyDepartment could not initialise OriginatingRegionPropertyDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
	
    IF NOT EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.OriginatingRegionPropertyDepartment
		WHERE 		
			GlobalRegionId = '12' AND
			PropertyDepartmentCode = 'GRWOF2' AND
			SourceCode = 'US' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May 23 2011  7:07AM') AND
			UpdatedByStaffId = '-1' AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
		RAISERROR ('OriginatingRegionPropertyDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.OriginatingRegionPropertyDepartment SET 
			GlobalRegionId = '12',
			PropertyDepartmentCode = 'GRWOF3',
			SourceCode = 'EU',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May 23 2011  7:06AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
	
    IF NOT EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.OriginatingRegionPropertyDepartment
		WHERE 
			GlobalRegionId = '12' AND
			PropertyDepartmentCode = 'GRWOF3' AND
			SourceCode = 'EU' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May 23 2011  7:06AM') AND
			UpdatedByStaffId = '-1' AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)

		RAISERROR ('OriginatingRegionPropertyDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.OriginatingRegionPropertyDepartment SET 
			GlobalRegionId = '12',
			PropertyDepartmentCode = 'GRWOF4',
			SourceCode = 'US',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'May 23 2011  7:05AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId
	EXEC #AssertInt @@RowCount, 1, 'OriginatingRegionPropertyDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.OriginatingRegionPropertyDepartment
		WHERE 
			GlobalRegionId = '12' AND
			PropertyDepartmentCode = 'GRWOF3' AND
			SourceCode = 'EU' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'May 23 2011  7:06AM') AND
			UpdatedByStaffId = '-1' AND
			OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
		RAISERROR ('OriginatingRegionPropertyDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.OriginatingRegionPropertyDepartment WHERE OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncOriginatingRegionPropertyDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.OriginatingRegionPropertyDepartment  WHERE OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
	
	EXEC #AssertBit @IsDeleted, 1, 'OriginatingRegionPropertyDepartment Expected DeActivated record'
    --IF EXISTS(SELECT OriginatingRegionPropertyDepartmentId FROM  GDM_GR.dbo.OriginatingRegionPropertyDepartment  WHERE OriginatingRegionPropertyDepartmentId = @OriginatingRegionPropertyDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncOriginatingRegionPropertyDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncOriginatingRegionPropertyDepartment


-- #region stp_IU_SyncPropertyEntityGLAccountInclusion
GO
CREATE PROCEDURE #ut_stp_IU_SyncPropertyEntityGLAccountInclusion_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncPropertyEntityGLAccountInclusion_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM GDM.dbo.PropertyEntityGLAccountInclusion WHERE InsertedDate = @InsertedDate)
		RAISERROR ('PropertyEntityGLAccountInclusion Test data already exists', 16, 1)
		
	INSERT GDM.dbo.PropertyEntityGLAccountInclusion(PropertyEntityCode,GLAccountCode,SourceCode,IsDeleted,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('VALKH2','TE5014000008','EU','0',@InsertedDate,convert(datetime,'Oct 12 2010  1:51AM'),'-1')
	
	DECLARE @PropertyEntityGLAccountInclusionId INT = (SELECT @@Identity)
	IF @PropertyEntityGLAccountInclusionId IS NULL
		RAISERROR ('PropertyEntityGLAccountInclusion could not initialise PropertyEntityGLAccountInclusionId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
	
    IF NOT EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.PropertyEntityGLAccountInclusion
		WHERE 		
			PropertyEntityCode = 'VALKH2' AND
			GLAccountCode = 'TE5014000008' AND
			SourceCode = 'EU' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Oct 12 2010  1:51AM') AND
			UpdatedByStaffId = '-1' AND
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
		RAISERROR ('PropertyEntityGLAccountInclusion Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.PropertyEntityGLAccountInclusion SET 
			PropertyEntityCode = 'VALKH3',
			GLAccountCode = 'TE5014000007',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			--Code = 'LEASEABC'
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
	
    IF NOT EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.PropertyEntityGLAccountInclusion
		WHERE 
			PropertyEntityCode = 'VALKH3' AND
			GLAccountCode = 'TE5014000007' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM') AND
			UpdatedByStaffId = '-1' AND
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)

		RAISERROR ('PropertyEntityGLAccountInclusion Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.PropertyEntityGLAccountInclusion SET 
			PropertyEntityCode = 'VALKH4',
			GLAccountCode = 'TE5014000007',
			SourceCode = 'US',
			IsDeleted = '0',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM'),
			UpdatedByStaffId = '-1'
		WHERE 
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId
	EXEC #AssertInt @@RowCount, 1, 'PropertyEntityGLAccountInclusion Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.PropertyEntityGLAccountInclusion
		WHERE 
			PropertyEntityCode = 'VALKH3' AND
			GLAccountCode = 'TE5014000007' AND
			SourceCode = 'US' AND
			IsDeleted = '0' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Oct 12 2010  1:50AM') AND
			UpdatedByStaffId = '-1' AND
			PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
		RAISERROR ('PropertyEntityGLAccountInclusion Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.PropertyEntityGLAccountInclusion WHERE PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyEntityGLAccountInclusion]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.PropertyEntityGLAccountInclusion  WHERE PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
	
	EXEC #AssertBit @IsDeleted, 1, 'PropertyEntityGLAccountInclusion Expected DeActivated record'
    --IF EXISTS(SELECT PropertyEntityGLAccountInclusionId FROM  GDM_GR.dbo.PropertyEntityGLAccountInclusion  WHERE PropertyEntityGLAccountInclusionId = @PropertyEntityGLAccountInclusionId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncPropertyEntityGLAccountInclusion_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncPropertyEntityGLAccountInclusion


-- #region stp_IU_SyncReportingEntityCorporateDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncReportingEntityCorporateDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncReportingEntityCorporateDepartment_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM GDM.dbo.ReportingEntityCorporateDepartment WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ReportingEntityCorporateDepartment Test data already exists', 16, 1)

	INSERT GDM.dbo.ReportingEntityCorporateDepartment(PropertyFundId,SourceCode,CorporateDepartmentCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('2715','EC','108723',@InsertedDate,convert(datetime,'Jul  1 2011  9:52AM'),'255')
	DECLARE @ReportingEntityCorporateDepartmentId INT = (SELECT @@Identity)
	IF @ReportingEntityCorporateDepartmentId IS NULL
		RAISERROR ('ReportingEntityCorporateDepartment could not initialise ReportingEntityCorporateDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
	
    IF NOT EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.ReportingEntityCorporateDepartment
		WHERE 		
			PropertyFundId = '2715' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108723' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:52AM') AND
			UpdatedByStaffId = '255' AND
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
		RAISERROR ('ReportingEntityCorporateDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ReportingEntityCorporateDepartment SET 
			PropertyFundId = '2715',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108721',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
	
    IF NOT EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.ReportingEntityCorporateDepartment
		WHERE 
			PropertyFundId = '2715' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)

		RAISERROR ('ReportingEntityCorporateDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ReportingEntityCorporateDepartment SET 
			PropertyFundId = '2715',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108720',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:50AM'),
			UpdatedByStaffId = '255'
		WHERE 
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId
	EXEC #AssertInt @@RowCount, 1, 'ReportingEntityCorporateDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.ReportingEntityCorporateDepartment
		WHERE 
			PropertyFundId = '2715' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
		RAISERROR ('ReportingEntityCorporateDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ReportingEntityCorporateDepartment WHERE ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityCorporateDepartment]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ReportingEntityCorporateDepartment  WHERE ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ReportingEntityCorporateDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ReportingEntityCorporateDepartmentId FROM  GDM_GR.dbo.ReportingEntityCorporateDepartment  WHERE ReportingEntityCorporateDepartmentId = @ReportingEntityCorporateDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncReportingEntityCorporateDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncReportingEntityCorporateDepartment

-- #region stp_IU_SyncReportingEntityPropertyEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncReportingEntityPropertyEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncReportingEntityPropertyEntity_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ReportingEntityPropertyEntityId FROM GDM.dbo.ReportingEntityPropertyEntity WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ReportingEntityPropertyEntity Test data already exists', 16, 1)
		
	INSERT GDM.dbo.ReportingEntityPropertyEntity(PropertyFundId,SourceCode,PropertyEntityCode,InsertedDate,UpdatedDate,UpdatedByStaffId,IsPrimary)       
	VALUES('2508','US','RCPAY2',@InsertedDate,convert(datetime,'Jul  5 2011  8:25AM'),'7740','0')
	
	DECLARE @ReportingEntityPropertyEntityId INT = (SELECT @@Identity)
	IF @ReportingEntityPropertyEntityId IS NULL
		RAISERROR ('ReportingEntityPropertyEntity could not initialise ReportingEntityPropertyEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
	
    IF NOT EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.ReportingEntityPropertyEntity
		WHERE 		
			PropertyFundId = '2508' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY2' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:25AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
		RAISERROR ('ReportingEntityPropertyEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ReportingEntityPropertyEntity SET 
			PropertyFundId = '2508',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY3',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM'),
			UpdatedByStaffId = '7740',
			IsPrimary = '0'
		WHERE 
			--Code = 'LEASEABC'
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
	
    IF NOT EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.ReportingEntityPropertyEntity
		WHERE 
			PropertyFundId = '2508' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			--IsPrimary = '0' AND
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)

		RAISERROR ('ReportingEntityPropertyEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ReportingEntityPropertyEntity SET 
			PropertyFundId = '2508',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY4',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:23AM'),
			UpdatedByStaffId = '7740',
			IsPrimary = '0'
		WHERE 
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId
	EXEC #AssertInt @@RowCount, 1, 'ReportingEntityPropertyEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.ReportingEntityPropertyEntity
		WHERE 
			PropertyFundId = '2508' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			IsPrimary = '0' AND
			ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
		RAISERROR ('ReportingEntityPropertyEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ReportingEntityPropertyEntity WHERE ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncReportingEntityPropertyEntity]
	
	DECLARE @IsDeleted BIT = (SELECT IsDeleted FROM  GDM_GR.dbo.ReportingEntityPropertyEntity  WHERE ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
	
	EXEC #AssertBit @IsDeleted, 1, 'ReportingEntityPropertyEntity Expected DeActivated record'
    --IF EXISTS(SELECT ReportingEntityPropertyEntityId FROM  GDM_GR.dbo.ReportingEntityPropertyEntity  WHERE ReportingEntityPropertyEntityId = @ReportingEntityPropertyEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncReportingEntityPropertyEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncReportingEntityPropertyEntity


-- #region stp_IU_SyncPropertyFund
GO
CREATE PROCEDURE #ut_stp_IU_SyncPropertyFund_setup AS 
BEGIN 
	IF EXISTS(SELECT PropertyFundId FROM GDM.dbo.PropertyFund WHERE Name = 'German ClubABC')
		RAISERROR ('PropertyFund Test data already exists', 16, 1)
	INSERT GDM.dbo.PropertyFund(RelatedFundId,EntityTypeId,AllocationSubRegionGlobalRegionId,BudgetOwnerStaffId,RegionalOwnerStaffId,Name,IsReportingEntity,IsPropertyFund,IsActive,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('26','1','42','494','-1','German ClubABC','1','1','1',convert(datetime,'Jun 30 2011  5:14PM'),convert(datetime,'Jun 30 2011  5:14PM'),'255')
	IF NOT EXISTS(SELECT PropertyFundId FROM GDM.dbo.PropertyFund WHERE Name = 'German ClubABC')
		RAISERROR ('PropertyFund Test data could not be inserted', 16, 1)
	--EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncPropertyFund_test AS 
BEGIN 
	DECLARE @PropertyFundId INT = (SELECT PropertyFundId FROM GDM.dbo.PropertyFund WHERE  Name = 'German ClubABC')
	IF @PropertyFundId IS NULL
		RAISERROR ('PropertyFund could not initialise PropertyFundId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyFund]
	
    IF NOT EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.PropertyFund
		WHERE 
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
	UPDATE 	Gdm.dbo.PropertyFund SET 
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
		PropertyFundId = @PropertyFundId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyFund]
	
    IF NOT EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.PropertyFund
		WHERE 
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
	UPDATE 	Gdm_GR.dbo.PropertyFund SET 
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
			PropertyFundId = @PropertyFundId
	EXEC #AssertInt @@RowCount, 1, 'Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyFund]
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.PropertyFund
		WHERE 
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
	
	
	DELETE FROM Gdm.dbo.PropertyFund WHERE PropertyFundId = @PropertyFundId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncPropertyFund]
	
	DECLARE @IsActive BIT = (SELECT IsActive FROM  GDM_GR.dbo.PropertyFund  WHERE PropertyFundId = @PropertyFundId)
	
	EXEC #AssertBit @IsActive, 0, 'Property Expected DeActivated record'
    --IF EXISTS(SELECT PropertyFundId FROM  GDM_GR.dbo.PropertyFund  WHERE PropertyFundId = @PropertyFundId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncPropertyFund_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncPropertyFund

-- #region stp_IU_SyncConsolidationRegionCorporateDepartment
GO
CREATE PROCEDURE #ut_stp_IU_SyncConsolidationRegionCorporateDepartment_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncConsolidationRegionCorporateDepartment_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM GDM.dbo.ConsolidationRegionCorporateDepartment WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ConsolidationRegionCorporateDepartment Test data already exists', 16, 1)

	INSERT GDM.dbo.ConsolidationRegionCorporateDepartment(GlobalRegionId,SourceCode,CorporateDepartmentCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('40','EC','108723',@InsertedDate,convert(datetime,'Jul  1 2011  9:52AM'),'255')
	DECLARE @ConsolidationRegionCorporateDepartmentId INT = (SELECT @@Identity)
	IF @ConsolidationRegionCorporateDepartmentId IS NULL
		RAISERROR ('ConsolidationRegionCorporateDepartment could not initialise ConsolidationRegionCorporateDepartmentId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
	
    IF NOT EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.ConsolidationRegionCorporateDepartment
		WHERE 		
			GlobalRegionId = '40' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108723' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:52AM') AND
			UpdatedByStaffId = '255' AND
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
		RAISERROR ('ConsolidationRegionCorporateDepartment Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ConsolidationRegionCorporateDepartment SET 
			GlobalRegionId = '39',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108721',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM'),
			UpdatedByStaffId = '255'
		WHERE 
			--Code = 'LEASEABC'
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
	
    IF NOT EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.ConsolidationRegionCorporateDepartment
		WHERE 
			GlobalRegionId = '39' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)

		RAISERROR ('ConsolidationRegionCorporateDepartment Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ConsolidationRegionCorporateDepartment SET 
			GlobalRegionId = '37',
			SourceCode = 'EC',
			CorporateDepartmentCode = '108720',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  1 2011  9:50AM'),
			UpdatedByStaffId = '255'
		WHERE 
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId
	EXEC #AssertInt @@RowCount, 1, 'ConsolidationRegionCorporateDepartment Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.ConsolidationRegionCorporateDepartment
		WHERE 
			GlobalRegionId = '39' AND
			SourceCode = 'EC' AND
			CorporateDepartmentCode = '108721' AND
			InsertedDate = @InsertedDate AND
			UpdatedDate = convert(datetime,'Jul  1 2011  9:51AM') AND
			UpdatedByStaffId = '255' AND
			ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
		RAISERROR ('ConsolidationRegionCorporateDepartment Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ConsolidationRegionCorporateDepartment WHERE ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionCorporateDepartment]
	
	DECLARE @IsDeleted BIT 
	IF EXISTS (SELECT * FROM Gdm_GR.dbo.ConsolidationRegionCorporateDepartment WHERE ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
	BEGIN
		SET @IsDeleted = 0
	END
	ELSE
	BEGIN
		SET @IsDeleted = 1
	END
	EXEC #AssertBit @IsDeleted, 1, 'ConsolidationRegionCorporateDepartment Expected DeActivated record'
    --IF EXISTS(SELECT ConsolidationRegionCorporateDepartmentId FROM  GDM_GR.dbo.ConsolidationRegionCorporateDepartment  WHERE ConsolidationRegionCorporateDepartmentId = @ConsolidationRegionCorporateDepartmentId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncConsolidationRegionCorporateDepartment_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncConsolidationRegionCorporateDepartment

-- #region stp_IU_SyncConsolidationRegionPropertyEntity
GO
CREATE PROCEDURE #ut_stp_IU_SyncConsolidationRegionPropertyEntity_setup AS 
BEGIN 
	EXEC #AssertBit 1,  1
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncConsolidationRegionPropertyEntity_test AS 
BEGIN 
	DECLARE @InsertedDate DATETIME = GETDATE() 
	IF EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM GDM.dbo.ConsolidationRegionPropertyEntity WHERE InsertedDate = @InsertedDate)
		RAISERROR ('ConsolidationRegionPropertyEntity Test data already exists', 16, 1)
		
	INSERT GDM.dbo.ConsolidationRegionPropertyEntity(GlobalRegionId,SourceCode,PropertyEntityCode,InsertedDate,UpdatedDate,UpdatedByStaffId)       
	VALUES('40','US','RCPAY2',@InsertedDate,convert(datetime,'Jul  5 2011  8:25AM'),'7740')
	
	DECLARE @ConsolidationRegionPropertyEntityId INT = (SELECT @@Identity)
	IF @ConsolidationRegionPropertyEntityId IS NULL
		RAISERROR ('ConsolidationRegionPropertyEntity could not initialise ConsolidationRegionPropertyEntityId', 16, 1)

	DECLARE	@return_value int
	DECLARE @StringValue1 VARCHAR(250)
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
	
    IF NOT EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.ConsolidationRegionPropertyEntity
		WHERE 		
			GlobalRegionId = '40' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY2' AND
			InsertedDate = CONVERT(DATETIME, @InsertedDate) AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:25AM') AND
			UpdatedByStaffId = '7740' AND
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
		RAISERROR ('ConsolidationRegionPropertyEntity Expected GR to sync from Insert', 16, 1)    	
	
	DECLARE @NewDate DATETIME = GETDATE()
	
	UPDATE 	Gdm.dbo.ConsolidationRegionPropertyEntity SET 
			GlobalRegionId = '39',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY3',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM'),
			UpdatedByStaffId = '7740'
		WHERE 
			--Code = 'LEASEABC'
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId
		
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
	
    IF NOT EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.ConsolidationRegionPropertyEntity
		WHERE 
			GlobalRegionId = '39' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			InsertedDate = CONVERT(DATETIME, @InsertedDate) AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)

		RAISERROR ('ConsolidationRegionPropertyEntity Expected GR to Update', 16, 1)    	
	
	
	--SET @ActivityTypeId = (SELECT ActivityTypeId FROM Gdm.dbo.ActivityType WHERE Code = 'LEASEABC')	
	UPDATE 	Gdm_GR.dbo.ConsolidationRegionPropertyEntity SET 
			GlobalRegionId = '37',
			SourceCode = 'US',
			PropertyEntityCode = 'RCPAY4',
			InsertedDate = @InsertedDate,
			UpdatedDate = convert(datetime,'Jul  5 2011  8:23AM'),
			UpdatedByStaffId = '7740'
		WHERE 
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId
	EXEC #AssertInt @@RowCount, 1, 'ConsolidationRegionPropertyEntity Expected 1 record update'
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
	
	
	
	--SELECT * FROM GDM.dbo.ActivityType
	--SELECT * FROM GDM_GR.dbo.ActivityType
    IF NOT EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.ConsolidationRegionPropertyEntity
		WHERE 
			GlobalRegionId = '39' AND
			SourceCode = 'US' AND
			PropertyEntityCode = 'RCPAY3' AND
			InsertedDate = CONVERT(DATETIME, @InsertedDate) AND
			UpdatedDate = convert(datetime,'Jul  5 2011  8:24AM') AND
			UpdatedByStaffId = '7740' AND
			ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
		RAISERROR ('ConsolidationRegionPropertyEntity Expected GR to lose Changes', 16, 1)    	
	
	
	DELETE FROM Gdm.dbo.ConsolidationRegionPropertyEntity WHERE ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId
	EXEC #AssertInt 1, @@RowCount, 'Expected record to be deleted'
	EXEC	@return_value = [dbo].[stp_IU_SyncConsolidationRegionPropertyEntity]
	
	DECLARE @IsDeleted BIT 
	IF EXISTS (SELECT * FROM Gdm_GR.dbo.ConsolidationRegionPropertyEntity WHERE ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
	BEGIN
		SET @IsDeleted = 0
	END
	ELSE
	BEGIN
		SET @IsDeleted = 1
	END
	EXEC #AssertBit @IsDeleted, 1, 'ConsolidationRegionPropertyEntity Expected DeActivated record'
    --IF EXISTS(SELECT ConsolidationRegionPropertyEntityId FROM  GDM_GR.dbo.ConsolidationRegionPropertyEntity  WHERE ConsolidationRegionPropertyEntityId = @ConsolidationRegionPropertyEntityId)
		--RAISERROR ('Expected record to be deleted from Gdm_GR.dbo.ActivityType', 16, 1)    	
	
	--EXEC #AssertInt 1, 1, 'Error in value'
		
END 
GO
CREATE PROCEDURE #ut_stp_IU_SyncConsolidationRegionPropertyEntity_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
-- #endregion stp_IU_SyncConsolidationRegionPropertyEntity
----------------------------------------------------------------------------------------
--- MAIN
----------------------------------------------------------------------------------------


BEGIN TRAN


CREATE TABLE #Tests
(
	TestName VARCHAR(250)
)
INSERT #Tests (TestName)
SELECT '#ut_stp_IU_SyncActivityType' UNION ALL
SELECT '#ut_stp_IU_SyncPropertyFund' UNION ALL
SELECT '#ut_stp_IU_SyncActivityTypeBusinessLine' UNION ALL
SELECT '#ut_stp_IU_SyncBusinessLine' UNION ALL
SELECT '#ut_stp_IU_SyncEntityType'  UNION ALL
SELECT '#ut_stp_IU_SyncGlobalRegion'  UNION ALL
SELECT '#ut_stp_IU_SyncManageType'  UNION ALL
SELECT '#ut_stp_IU_SyncManageCorporateDepartment'  UNION ALL
SELECT '#ut_stp_IU_SyncManageCorporateEntity'  UNION ALL
SELECT '#ut_stp_IU_SyncManagePropertyDepartment'  UNION ALL
SELECT '#ut_stp_IU_SyncManagePropertyEntity'  UNION ALL
SELECT '#ut_stp_IU_SyncOriginatingRegionCorporateEntity'  UNION ALL
SELECT '#ut_stp_IU_SyncOriginatingRegionPropertyDepartment'  UNION ALL
--SELECT '#ut_stp_IU_SyncPropertyEntityCorporateDepartment'  UNION ALL
SELECT '#ut_stp_IU_SyncReportingEntityCorporateDepartment'  UNION ALL
SELECT '#ut_stp_IU_SyncReportingEntityPropertyEntity' UNION ALL
SELECT '#ut_stp_IU_SyncConsolidationRegionCorporateDepartment' UNION ALL
SELECT '#ut_stp_IU_SyncConsolidationRegionPropertyEntity' 

EXEC #RunTests
   
  
--SELECT * FROM GDM.dbo.ActivityType

ROLLBACK




RETURN
/* --- TEMPLATE  ------ COPY HERE ------- 

-- #region ut_PROCNAME
GO
CREATE PROCEDURE #ut_PROCNAME_setup AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 
GO
CREATE PROCEDURE #ut_PROCNAME_test AS 
BEGIN 
	EXEC #AssertBit 0, 1, 'NOT IMPLEMENTED'
END 
GO
CREATE PROCEDURE #ut_PROCNAME_teardown AS 
BEGIN 
	EXEC #AssertBit 1, 1
END 

-- #endregion ut_PROCNAME

 --- END TEMPLATE  ------ COPY HERE -------*/





/* GDM 

GDM Snapshot
dbo.stp_IU_SyncSnapshotActivityType
dbo.stp_IU_SyncSnapshotActivityTypeBusinessLine
dbo.stp_IU_SyncSnapshotBusinessLine
dbo.stp_IU_SyncSnapshotEntity
dbo.stp_IU_SyncSnapshotGlobalRegion
dbo.stp_IU_SyncSnapshotManageType
dbo.stp_IU_SyncSnapshotManageCorporateDepartment
dbo.stp_IU_SyncSnapshotManageCorporateEntity
dbo.stp_IU_SyncSnapshotManagePropertyDepartment
dbo.stp_IU_SyncSnapshotManagePropertyEntity
dbo.stp_IU_SyncSnapshotOriginatingRegionCorporateEntity
dbo.stp_IU_SyncSnapshotOriginatingRegionPropertyDepartment
dbo.stp_IU_SyncSnapshotPropertyEntityGLAccountInclusion
dbo.stp_IU_SyncSnapshotPropertyFund
dbo.stp_IU_SyncSnapshotReportingEntityCorporateDepartment
dbo.stp_IU_SyncSnapshotReportingEntityPropertyEntity



GDM Production
dbo.GLCategorization
dbo.GLCategorizationType
dbo.GLFinancialCategory
removed
{'inflow', 'outflow'}
dbo.GLMajorCategory
dbo.GLMinorCategory
dbo.GLGlobalAccountCategorization
dbo.GLGLobalAccount
dbo.GLAccount
removed



GDM Snapshot
dbo.SnapshotGLCategorization
dbo.SnapshotGLCategorizationType
dbo.SnapshotGLFinancialCategory
removed
{'inflow', 'outflow'}
dbo.SnapshotGLMajorCategory
dbo.SnapshotGLMinorCategory
dbo.SnapshotGLGlobalAccountCategorization
dbo.SnapshotGLGLobalAccount
dbo.SnapshotGLAccount
removed



*/