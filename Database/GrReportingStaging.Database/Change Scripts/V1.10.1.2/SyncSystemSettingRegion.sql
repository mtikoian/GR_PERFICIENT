USE [TAPASUS]
GO
/****** Object:  StoredProcedure [dbo].[SyncSystemSettingRegion]    Script Date: 07/18/2012 21:53:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SyncSystemSettingRegion]
AS

MERGE 
	TAPASUS.Admin.SystemSettingRegion AS DST 
USING 
	SERVER3.TAPASUS.GMR.SystemSettingRegionReplication AS SRC ON
		DST.SystemSettingRegionId = SRC.SystemSettingRegionId
WHEN
	MATCHED AND
	/*
		DST.BankLetterAddress NOT LIKE SRC.BankLetterAddress OR 
		(DST.BankLetterAddress IS NULL AND SRC.BankLetterAddress IS NOT NULL) OR
		(DST.BankLetterAddress IS NOT NULL AND SRC.BankLetterAddress IS NULL) OR
	*/
		
		DST.BonusCapExcessProjectId <> SRC.BonusCapExcessProjectId OR 
		(DST.BonusCapExcessProjectId IS NULL AND SRC.BonusCapExcessProjectId IS NOT NULL) OR
		(DST.BonusCapExcessProjectId IS NOT NULL AND SRC.BonusCapExcessProjectId IS NULL) OR
		
		DST.BudgetAllocationBudgetId <> SRC.BudgetAllocationBudgetId OR 
		(DST.BudgetAllocationBudgetId IS NULL AND SRC.BudgetAllocationBudgetId IS NOT NULL) OR
		(DST.BudgetAllocationBudgetId IS NOT NULL AND SRC.BudgetAllocationBudgetId IS NULL) OR
		
		DST.CorporateMarkUpCreditDepartmentCode <> SRC.CorporateMarkUpCreditDepartmentCode OR 
		(DST.CorporateMarkUpCreditDepartmentCode IS NULL AND SRC.CorporateMarkUpCreditDepartmentCode IS NOT NULL) OR
		(DST.CorporateMarkUpCreditDepartmentCode IS NOT NULL AND SRC.CorporateMarkUpCreditDepartmentCode IS NULL) OR
		
		DST.CorporateMarkUpCreditEntityRef <> SRC.CorporateMarkUpCreditEntityRef OR 
		(DST.CorporateMarkUpCreditEntityRef IS NULL AND SRC.CorporateMarkUpCreditEntityRef IS NOT NULL) OR
		(DST.CorporateMarkUpCreditEntityRef IS NOT NULL AND SRC.CorporateMarkUpCreditEntityRef IS NULL) OR
		
		DST.CorporateMarkUpCreditGLAccountCode <> SRC.CorporateMarkUpCreditGLAccountCode OR 
		(DST.CorporateMarkUpCreditGLAccountCode IS NULL AND SRC.CorporateMarkUpCreditGLAccountCode IS NOT NULL) OR
		(DST.CorporateMarkUpCreditGLAccountCode IS NOT NULL AND SRC.CorporateMarkUpCreditGLAccountCode IS NULL) OR
		
		DST.CorporateMarkUpDebitEntityRef <> SRC.CorporateMarkUpDebitEntityRef OR 
		(DST.CorporateMarkUpDebitEntityRef IS NULL AND SRC.CorporateMarkUpDebitEntityRef IS NOT NULL) OR
		(DST.CorporateMarkUpDebitEntityRef IS NOT NULL AND SRC.CorporateMarkUpDebitEntityRef IS NULL) OR
		
		DST.CorporateMarkUpDebitGLAccountCode <> SRC.CorporateMarkUpDebitGLAccountCode OR 
		(DST.CorporateMarkUpDebitGLAccountCode IS NULL AND SRC.CorporateMarkUpDebitGLAccountCode IS NOT NULL) OR
		(DST.CorporateMarkUpDebitGLAccountCode IS NOT NULL AND SRC.CorporateMarkUpDebitGLAccountCode IS NULL) OR
		
		DST.CorporateOverheadClearingEntityRef <> SRC.CorporateOverheadClearingEntityRef OR 
		(DST.CorporateOverheadClearingEntityRef IS NULL AND SRC.CorporateOverheadClearingEntityRef IS NOT NULL) OR
		(DST.CorporateOverheadClearingEntityRef IS NOT NULL AND SRC.CorporateOverheadClearingEntityRef IS NULL) OR
		
		DST.CorporateOverheadCreditDepartmentCode <> SRC.CorporateOverheadCreditDepartmentCode OR 
		(DST.CorporateOverheadCreditDepartmentCode IS NULL AND SRC.CorporateOverheadCreditDepartmentCode IS NOT NULL) OR
		(DST.CorporateOverheadCreditDepartmentCode IS NOT NULL AND SRC.CorporateOverheadCreditDepartmentCode IS NULL) OR
		
		DST.CorporateOverheadCreditEntityRef <> SRC.CorporateOverheadCreditEntityRef OR 
		(DST.CorporateOverheadCreditEntityRef IS NULL AND SRC.CorporateOverheadCreditEntityRef IS NOT NULL) OR
		(DST.CorporateOverheadCreditEntityRef IS NOT NULL AND SRC.CorporateOverheadCreditEntityRef IS NULL) OR
		
		DST.CorporateOverheadCreditGLAccountCode <> SRC.CorporateOverheadCreditGLAccountCode OR 
		(DST.CorporateOverheadCreditGLAccountCode IS NULL AND SRC.CorporateOverheadCreditGLAccountCode IS NOT NULL) OR
		(DST.CorporateOverheadCreditGLAccountCode IS NOT NULL AND SRC.CorporateOverheadCreditGLAccountCode IS NULL) OR
		
		DST.CorporateOverheadDebitGLAccountCode <> SRC.CorporateOverheadDebitGLAccountCode OR 
		(DST.CorporateOverheadDebitGLAccountCode IS NULL AND SRC.CorporateOverheadDebitGLAccountCode IS NOT NULL) OR
		(DST.CorporateOverheadDebitGLAccountCode IS NOT NULL AND SRC.CorporateOverheadDebitGLAccountCode IS NULL) OR
		
		DST.CorporatePayrollClearingEntityRef <> SRC.CorporatePayrollClearingEntityRef OR
		(DST.CorporatePayrollClearingEntityRef IS NULL AND SRC.CorporatePayrollClearingEntityRef IS NOT NULL) OR
		(DST.CorporatePayrollClearingEntityRef IS NOT NULL AND SRC.CorporatePayrollClearingEntityRef IS NULL) OR
		 
		DST.CorporatePayrollCreditDepartmentCode <> SRC.CorporatePayrollCreditDepartmentCode OR 
		(DST.CorporatePayrollCreditDepartmentCode IS NULL AND SRC.CorporatePayrollCreditDepartmentCode IS NOT NULL) OR
		(DST.CorporatePayrollCreditDepartmentCode IS NOT NULL AND SRC.CorporatePayrollCreditDepartmentCode IS NULL) OR
		
		DST.CorporatePayrollCreditEntityRef <> SRC.CorporatePayrollCreditEntityRef OR 
		(DST.CorporatePayrollCreditEntityRef IS NULL AND SRC.CorporatePayrollCreditEntityRef IS NOT NULL) OR
		(DST.CorporatePayrollCreditEntityRef IS NOT NULL AND SRC.CorporatePayrollCreditEntityRef IS NULL) OR
		
		DST.InsertedDate <> SRC.InsertedDate OR 
		(DST.InsertedDate IS NULL AND SRC.InsertedDate IS NOT NULL) OR
		(DST.InsertedDate IS NOT NULL AND SRC.InsertedDate IS NULL) OR
		
		DST.PropertyMarkUpGLaccountCode <> SRC.PropertyMarkUpGLaccountCode OR 
		(DST.PropertyMarkUpGLaccountCode IS NULL AND SRC.PropertyMarkUpGLaccountCode IS NOT NULL) OR
		(DST.PropertyMarkUpGLaccountCode IS NOT NULL AND SRC.PropertyMarkUpGLaccountCode IS NULL) OR
		
		DST.PropertyVendorCode <> SRC.PropertyVendorCode OR 
		(DST.PropertyVendorCode IS NULL AND SRC.PropertyVendorCode IS NOT NULL) OR
		(DST.PropertyVendorCode IS NOT NULL AND SRC.PropertyVendorCode IS NULL) OR
		
		DST.RegionId <> SRC.RegionId OR
		(DST.RegionId IS NULL AND SRC.RegionId IS NOT NULL) OR
		(DST.RegionId IS NOT NULL AND SRC.RegionId IS NULL) OR
		 
		DST.SourceCode <> SRC.SourceCode OR 
		(DST.SourceCode IS NULL AND SRC.SourceCode IS NOT NULL) OR
		(DST.SourceCode IS NOT NULL AND SRC.SourceCode IS NULL) OR
		
		DST.SystemSettingId <> SRC.SystemSettingId OR 
		(DST.SystemSettingId IS NULL AND SRC.SystemSettingId IS NOT NULL) OR
		(DST.SystemSettingId IS NOT NULL AND SRC.SystemSettingId IS NULL) OR
		
		DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR 
		(DST.UpdatedByStaffId IS NULL AND SRC.UpdatedByStaffId IS NOT NULL) OR
		(DST.UpdatedByStaffId IS NOT NULL AND SRC.UpdatedByStaffId IS NULL) OR
		
		DST.UpdatedDate <> SRC.UpdatedDate OR
		(DST.UpdatedDate IS NULL AND SRC.UpdatedDate IS NOT NULL) OR
		(DST.UpdatedDate IS NOT NULL AND SRC.UpdatedDate IS NULL)
THEN
UPDATE
	SET
		--DST.BankLetterAddress = SRC.BankLetterAddress,
		DST.BonusCapExcessProjectId = SRC.BonusCapExcessProjectId,
		DST.BudgetAllocationBudgetId = SRC.BudgetAllocationBudgetId,
		DST.CorporateMarkUpCreditDepartmentCode = SRC.CorporateMarkUpCreditDepartmentCode,
		DST.CorporateMarkUpCreditEntityRef = SRC.CorporateMarkUpCreditEntityRef,
		DST.CorporateMarkUpCreditGLAccountCode = SRC.CorporateMarkUpCreditGLAccountCode,
		DST.CorporateMarkUpDebitEntityRef = SRC.CorporateMarkUpDebitEntityRef,
		DST.CorporateMarkUpDebitGLAccountCode = SRC.CorporateMarkUpDebitGLAccountCode,
		DST.CorporateOverheadClearingEntityRef = SRC.CorporateOverheadClearingEntityRef,
		DST.CorporateOverheadCreditDepartmentCode = SRC.CorporateOverheadCreditDepartmentCode,
		DST.CorporateOverheadCreditEntityRef = SRC.CorporateOverheadCreditEntityRef,
		DST.CorporateOverheadCreditGLAccountCode = SRC.CorporateOverheadCreditGLAccountCode,
		DST.CorporateOverheadDebitGLAccountCode = SRC.CorporateOverheadDebitGLAccountCode,
		DST.CorporatePayrollClearingEntityRef = SRC.CorporatePayrollClearingEntityRef,
		DST.CorporatePayrollCreditDepartmentCode = SRC.CorporatePayrollCreditDepartmentCode,
		DST.CorporatePayrollCreditEntityRef = SRC.CorporatePayrollCreditEntityRef,
		DST.InsertedDate = SRC.InsertedDate,
		DST.PropertyMarkUpGLaccountCode = SRC.PropertyMarkUpGLaccountCode,
		DST.PropertyVendorCode = SRC.PropertyVendorCode,
		DST.RegionId = SRC.RegionId,
		DST.SourceCode = SRC.SourceCode,
		DST.SystemSettingId = SRC.SystemSettingId,
		DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
		DST.UpdatedDate = SRC.UpdatedDate
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT
	(
		--BankLetterAddress,
		BonusCapExcessProjectId,
		BudgetAllocationBudgetId,
		CorporateMarkUpCreditDepartmentCode,
		CorporateMarkUpCreditEntityRef,
		CorporateMarkUpCreditGLAccountCode,
		CorporateMarkUpDebitEntityRef,
		CorporateMarkUpDebitGLAccountCode,
		CorporateOverheadClearingEntityRef,
		CorporateOverheadCreditDepartmentCode,
		CorporateOverheadCreditEntityRef,
		CorporateOverheadCreditGLAccountCode,
		CorporateOverheadDebitGLAccountCode,
		CorporatePayrollClearingEntityRef,
		CorporatePayrollCreditDepartmentCode,
		CorporatePayrollCreditEntityRef,
		InsertedDate,
		PropertyMarkUpGLaccountCode,
		PropertyVendorCode,
		RegionId,
		SourceCode,
		SystemSettingId,
		SystemSettingRegionId,
		UpdatedByStaffId,
		UpdatedDate
	)
	VALUES
	(
		--SRC.BankLetterAddress,
		SRC.BonusCapExcessProjectId,
		SRC.BudgetAllocationBudgetId,
		SRC.CorporateMarkUpCreditDepartmentCode,
		SRC.CorporateMarkUpCreditEntityRef,
		SRC.CorporateMarkUpCreditGLAccountCode,
		SRC.CorporateMarkUpDebitEntityRef,
		SRC.CorporateMarkUpDebitGLAccountCode,
		SRC.CorporateOverheadClearingEntityRef,
		SRC.CorporateOverheadCreditDepartmentCode,
		SRC.CorporateOverheadCreditEntityRef,
		SRC.CorporateOverheadCreditGLAccountCode,
		SRC.CorporateOverheadDebitGLAccountCode,
		SRC.CorporatePayrollClearingEntityRef,
		SRC.CorporatePayrollCreditDepartmentCode,
		SRC.CorporatePayrollCreditEntityRef,
		SRC.InsertedDate,
		SRC.PropertyMarkUpGLaccountCode,
		SRC.PropertyVendorCode,
		SRC.RegionId,
		SRC.SourceCode,
		SRC.SystemSettingId,
		SRC.SystemSettingRegionId,
		SRC.UpdatedByStaffId,
		SRC.UpdatedDate
	)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;


