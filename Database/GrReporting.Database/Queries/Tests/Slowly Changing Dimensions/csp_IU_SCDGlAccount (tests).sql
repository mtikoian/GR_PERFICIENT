USE GrReporting
GO

-- csp_IU_SCDGlAccount

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
		
			INSERT INTO GrReportingStaging.Gdm.GLGlobalAccount (ImportBatchId, ImportDate, GLGlobalAccountId, ActivityTypeId, GLStatutoryTypeId, Code, Name, [Description], IsGR, IsGbs, IsRegionalOverheadCost, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
			VALUES (2613, '2011-08-02 15:14:29.097', 139999, NULL, 0, '1234567890', 'Test GL Account', 'Test account for GR SCD', 1, 0, 0, 1, GETDATE(), GETDATE(), -1)
			
			EXEC csp_IU_SCDGlAccount  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
	
	ROLLBACK TRAN

---- Scenario 2.1: Record updated in SOURCE - field updated not used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
		
			UPDATE GrReportingStaging.Gdm.GLGlobalAccount SET IsGbs = 1, UpdatedDate = GETDATE() WHERE GLGlobalAccountId = 132554
			EXEC csp_IU_SCDGlAccount  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
	
	ROLLBACK TRAN

---- Scenario 2.2: Record updated in SOURCE - field updates used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
		
			UPDATE GrReportingStaging.Gdm.GLGlobalAccount SET Name = Name + '(U)', UpdatedDate = GETDATE() WHERE GLGlobalAccountId = 132554
			EXEC csp_IU_SCDGlAccount  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
	
	ROLLBACK TRAN

---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
		
			UPDATE GrReportingStaging.Gdm.GLGlobalAccount SET IsActive = 0, UpdatedDate = GETDATE() WHERE GLGlobalAccountId = 132554
			EXEC csp_IU_SCDGlAccount  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
	
	ROLLBACK TRAN


---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
		
			DELETE FROM GrReportingStaging.Gdm.GLGlobalAccount WHERE GLGlobalAccountId = 132554
			EXEC csp_IU_SCDGlAccount  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccount WHERE SnapshotId = 0 ORDER BY GLGlobalAccountId
	
	ROLLBACK TRAN


