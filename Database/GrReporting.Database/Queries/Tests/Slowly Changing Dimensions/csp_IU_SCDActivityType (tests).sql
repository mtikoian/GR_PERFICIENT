USE GrReporting
GO

-- csp_IU_SCDActivityType

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

			-- need to deactivate this record as an activity type can only be associated with one business line, and we will be updated 99's
			UPDATE GrReportingStaging.Gdm.ActivityTypeBusinessLine SET IsActive = 0 WHERE ActivityTypeBusinessLineId = 4

			INSERT INTO GrReportingStaging.Gdm.ActivityTypeBusinessLine (ImportBatchId, ImportDate, ActivityTypeBusinessLineId, ActivityTypeId, BusinessLineId, InsertedDate, UpdatedDate, UpdatedByStaffId, IsActive)
			VALUES (2613, '2011-08-02 15:14:28.753', 14, 99, 2, GETDATE(), GETDATE(), -1, 1)
			EXEC csp_IU_SCDActivityType @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

	ROLLBACK TRAN


---- Scenario 2.1: Record updated in SOURCE - field updated not used by dimension

	BEGIN TRAN

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

			UPDATE GrReportingStaging.Gdm.ActivityType SET IsEscalatable = 1, UpdatedDate = GETDATE() WHERE ActivityTypeId = 1 -- Leasing
			EXEC csp_IU_SCDActivityType @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

	ROLLBACK TRAN


---- Scenario 2.2: Record updated in SOURCE

	BEGIN TRAN

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

			UPDATE GrReportingStaging.Gdm.ActivityType SET Name = Name + '(U)', UpdatedDate = GETDATE() WHERE ActivityTypeId = 1 -- Leasing
			EXEC csp_IU_SCDActivityType @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

	ROLLBACK TRAN


---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0
		
			UPDATE GrReportingStaging.Gdm.ActivityTypeBusinessLine SET IsActive = 0, UpdatedDate = GETDATE() WHERE ActivityTypeBusinessLineId = 1 -- Acquisitions; Fund Management
			EXEC csp_IU_SCDActivityType @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

	ROLLBACK TRAN


---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0
		
			DELETE FROM GrReportingStaging.Gdm.ActivityTypeBusinessLine WHERE ActivityTypeBusinessLineId = 1 -- Acquisitions; Fund Management
			EXEC csp_IU_SCDActivityType @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.ActivityType WHERE SnapshotId = 0

	ROLLBACK TRAN
