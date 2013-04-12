USE GrReporting
GO

-- csp_IU_SCDOriginatingRegion

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0

			-- SubRegion: i.e.: A region with a Parent Region		
			INSERT INTO GrReportingStaging.Gdm.GlobalRegion (ImportBatchId, ImportDate, GlobalRegionId, ParentGlobalRegionId, CountryId, Code, Name, IsAllocationRegion, IsOriginatingRegion, DefaultCurrencyCode, DefaultCorporateSourceCode, ProjectCodePortion, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId, IsConsolidationRegion)
			VALUES (2613, '2011-08-02 15:14:26.320', 90, 34, 1, 'TST1', 'TEST1', 1, 1, 'USD', 'US', 46, 1, '2009-08-06 09:28:55.477', '2010-07-24 05:27:34.847', -1, 1)
	
			EXEC csp_IU_SCDOriginatingRegion @DataPriorToDate = '2011-12-31'
		
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 2.1: Record updated in SOURCE - field updated not used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
		
			UPDATE GrReportingStaging.Gdm.GlobalRegion SET DefaultCorporateSourceCode = 'US', UpdatedDate = GETDATE() WHERE Code = 'SCA'
			EXEC csp_IU_SCDOriginatingRegion  @DataPriorToDate = '2011-12-31'
		
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 2.2: Record updated in SOURCE - field updates used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
		
			UPDATE GrReportingStaging.Gdm.GlobalRegion SET Name = Name + '(U)', UpdatedDate = GETDATE() WHERE Code = 'CNB'
			EXEC csp_IU_SCDOriginatingRegion  @DataPriorToDate = '2011-12-31'
		
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
		
			UPDATE GrReportingStaging.Gdm.GlobalRegion SET IsActive = 0, UpdatedDate = GETDATE() WHERE Code = 'UKD'
			EXEC csp_IU_SCDOriginatingRegion  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
		
			DELETE FROM GrReportingStaging.Gdm.GlobalRegion WHERE Code = 'BOS'
			EXEC csp_IU_SCDOriginatingRegion  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.OriginatingRegion WHERE SnapshotId = 0
	
	ROLLBACK TRAN


 