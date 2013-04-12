USE GrReporting
GO

-- csp_IU_SCD

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo. WHERE SnapshotId = 0
		
			-- TODO: Insert new record into SOURCE
			EXEC csp_IU_SCD  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo. WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 2.1: Record updated in SOURCE - field updated not used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo. WHERE SnapshotId = 0
		
			-- TODO: Update field of existing record in SOURCE that is not a field in the DIMENSION
			EXEC csp_IU_SCD  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo. WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 2.2: Record updated in SOURCE - field updates used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo. WHERE SnapshotId = 0
		
			-- TODO: Update field of existing record in SOURCE that is also a field in the DIMENSION
			EXEC csp_IU_SCD  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo. WHERE SnapshotId = 0
	
	ROLLBACK TRAN

---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo. WHERE SnapshotId = 0
		
			-- TODO: If applicable, deactivate a record in SOURCE that also exists in the DIMENSION
			EXEC csp_IU_SCD  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo. WHERE SnapshotId = 0
	
	ROLLBACK TRAN


---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo. WHERE SnapshotId = 0
		
			-- TODO: Hard-delete a record in SOURCE that also exists in the DIMENSION
			EXEC csp_IU_SCD  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo. WHERE SnapshotId = 0
	
	ROLLBACK TRAN


