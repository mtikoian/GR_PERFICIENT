USE GrReporting
GO

-- csp_IU_SCDPropertyFund

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
		
			INSERT INTO GrReportingStaging.Gdm.PropertyFund (ImportBatchId, ImportDate, PropertyFundId, RelatedFundId, EntityTypeId, AllocationSubRegionGlobalRegionId, BudgetOwnerStaffId, RegionalOwnerStaffId, DefaultGLTranslationSubTypeId, Name, IsReportingEntity, IsPropertyFund, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
			VALUES (2613, '2011-08-02 15:14:25.800', 9191, 43, 3, 12, -1, -1, 233, 'TEST_PF', 0, 1, 1, '2010-07-24 04:51:32.847', '2010-07-24 04:51:32.847', -1)
			
			EXEC csp_IU_SCDPropertyFund  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
	
	ROLLBACK TRAN

---- Scenario 2.1: Record updated in SOURCE - field updated not used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
		
			UPDATE GrReportingStaging.Gdm.PropertyFund SET RegionalOwnerStaffId = -1, UpdatedDate = GETDATE() WHERE PropertyFundId = 1612
			
			EXEC csp_IU_SCDPropertyFund  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
	
	ROLLBACK TRAN

---- Scenario 2.2: Record updated in SOURCE - field updates used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
		
			UPDATE GrReportingStaging.Gdm.PropertyFund SET Name = Name + '(U)', UpdatedDate = GETDATE() WHERE PropertyFundId = 1610
			EXEC csp_IU_SCDPropertyFund  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
	
	ROLLBACK TRAN

---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
		
			UPDATE GrReportingStaging.Gdm.PropertyFund SET IsActive = 0, UpdatedDate = GETDATE() WHERE PropertyFundId = 1613
			EXEC csp_IU_SCDPropertyFund  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
	
	ROLLBACK TRAN


---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
		
			DELETE FROM GrReportingStaging.Gdm.PropertyFund WHERE PropertyFundId = 1613
			EXEC csp_IU_SCDPropertyFund  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.PropertyFund WHERE SnapshotId = 0 ORDER BY PropertyFundId
	
	ROLLBACK TRAN


