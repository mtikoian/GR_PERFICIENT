USE GrReporting
GO

-- csp_IU_SCDFunctionalDepartment

---- Scenario 1: New Record in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.FunctionalDepartment
		
			INSERT INTO GrReportingStaging.HR.FunctionalDepartment (ImportBatchId, ImportDate, FunctionalDepartmentId, Name, Code, IsActive, InsertedDate, UpdatedDate, GlobalCode)
			VALUES (0, '2011-07-20 12:14:08.607', 911, 'Test Functional Department', 'TEST_FD', 1, GETDATE(), GETDATE(), 'TST')

			EXEC csp_IU_SCDFunctionalDepartment  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.FunctionalDepartment

	ROLLBACK TRAN

---- Scenario 2.1: Record updated in SOURCE - field updated not used by DIMENSION

	BEGIN TRAN

		SELECT * FROM dbo.FunctionalDepartment

			-- TODO: Update field of existing record in SOURCE that is not a field in the DIMENSION
			EXEC csp_IU_SCDFunctionalDepartment  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.FunctionalDepartment

	ROLLBACK TRAN

---- Scenario 2.2: Record updated in SOURCE - field updates used by DIMENSION

	BEGIN TRAN
	
		SELECT * FROM dbo.FunctionalDepartment
		
			-- TODO: Update field of existing record in SOURCE that is also a field in the DIMENSION
			EXEC csp_IU_SCDFunctionalDepartment  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.FunctionalDepartment
	
	ROLLBACK TRAN

---- Scenario 3.1: Record deactivated in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.FunctionalDepartment ORDER BY FunctionalDepartmentName
		
			UPDATE GrReportingStaging.HR.FunctionalDepartment SET IsActive = 0, UpdatedDate = GETDATE() WHERE FunctionalDepartmentId = 5
			EXEC csp_IU_SCDFunctionalDepartment  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.FunctionalDepartment ORDER BY FunctionalDepartmentName
	
	ROLLBACK TRAN


---- Scenario 3.2: Record hard deleted in SOURCE

	BEGIN TRAN
	
		SELECT * FROM dbo.FunctionalDepartment
		
			-- TODO: Hard-delete a record in SOURCE that also exists in the DIMENSION
			EXEC csp_IU_SCDFunctionalDepartment  @DataPriorToDate = '2011-12-31'

		SELECT * FROM dbo.FunctionalDepartment
	
	ROLLBACK TRAN


