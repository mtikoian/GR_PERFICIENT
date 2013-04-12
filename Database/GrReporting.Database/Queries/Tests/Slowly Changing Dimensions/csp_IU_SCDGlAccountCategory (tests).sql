USE GrReporting
GO

-- csp_IU_SCDGlAccountCategory

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0 ORDER BY GlobalGlAccountCategoryCode
		
			--INSERT INTO GrReportingStaging.Gdm.GLGlobalAccountTranslationSubType (ImportBatchId, ImportDate, GLGlobalAccountTranslationSubTypeId, GLGlobalAccountId, GLTranslationSubTypeId, GLMinorCategoryId, IsActive, InsertedDate, UpdatedDate, UpdatedByStaffId)
			--VALUES (2613, '2011-08-02 15:14:31.560', 9999, 132590, 233, 1, 1, GETDATE(), GETDATE(), -1)
			
			EXEC csp_IU_SCDGlAccountCategory  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0 ORDER BY GlobalGlAccountCategoryCode
	
	ROLLBACK TRAN

---- Scenario 2.1: Record updated in SOURCE - field updated not used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0
		
			-- TODO: Update field of existing record in SOURCE that is not a field in the DIMENSION
			EXEC csp_IU_SCDGlAccountCategory  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 2.2: Record updated in SOURCE - field updates used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0 ORDER BY MinorCategoryName
		
			UPDATE GrReportingStaging.Gdm.GLMinorCategory SET Name = Name + '(U)', UpdatedDate = GETDATE() WHERE GLMinorCategoryId = 91
			EXEC csp_IU_SCDGlAccountCategory  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0 ORDER BY MinorCategoryName
	
	ROLLBACK TRAN

---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0
		
			-- TODO: If applicable, deactivate a record in SOURCE that also exists in the DIMENSION
			EXEC csp_IU_SCDGlAccountCategory  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0
	
	ROLLBACK TRAN


---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0
		
			-- TODO: Hard-delete a record in SOURCE that also exists in the DIMENSION
			EXEC csp_IU_SCDGlAccountCategory  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.GlAccountCategory WHERE SnapshotId = 0
	
	ROLLBACK TRAN


