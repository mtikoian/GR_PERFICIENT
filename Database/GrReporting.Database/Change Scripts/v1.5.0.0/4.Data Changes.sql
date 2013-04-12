 /*
 
 IMS 57301 - Update GR Original Budget for Fees, and the Grinder (BC)
 
 */
 
 USE GrReporting
 
 GO
 Update ProfitabilityBudget
 Set	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4107000003'),
		ActivityTypeKey = (Select ActivityTypeKey From ActivityType Where ActivityTypeName = 'Asset Management')
Where	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4107000000') AND
		ActivityTypeKey = -1
GO
 Update ProfitabilityBudget
 Set	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602000004'),
		ActivityTypeKey = (Select ActivityTypeKey From ActivityType Where ActivityTypeName = 'Development')
Where	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602000000') AND
		ActivityTypeKey = -1
GO
 Update ProfitabilityBudget
 Set	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602500001'),
		ActivityTypeKey = (Select ActivityTypeKey From ActivityType Where ActivityTypeName = 'Leasing')
Where	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602500000') AND
		ActivityTypeKey = -1
GO
 Update ProfitabilityBudget
 Set	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602150004'),
		ActivityTypeKey = (Select ActivityTypeKey From ActivityType Where ActivityTypeName = 'Development')
Where	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602150000') AND
		ActivityTypeKey = -1

GO
 Update ProfitabilityBudget
 Set	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602550005'),
		ActivityTypeKey = (Select ActivityTypeKey From ActivityType Where ActivityTypeName = 'Property Management Escalatable')
Where	GlAccountKey = (Select GlAccountKey From GlAccount Where Code = '4602550000') AND
		ActivityTypeKey = -1
GO




USE BC
GO

IF NOT EXISTS(Select * From GlobalAccountMapping Where GlobalAccountMappingId = 4825)
	BEGIN
	SET IDENTITY_INSERT GlobalAccountMapping ON
	Insert Into GlobalAccountMapping
	(GlobalAccountMappingId,GlobalAccountKey,	EUCorpMajorExpenseCategory,	EUCorpAccountNumber,	EUCorpAccountName,
	USCorpMajorExpenseCategory,	USCorpAccountNumber,	USCorpAccountName,	USPropMajorExpenseCategory,	USPropAccountNumber,	USPropAccountName,
	EUPropMajorExpenseCategory,	EUPropAccountNumber,	EUPropAccountName,	EUFundMajorExpenseCategory,	EUFundAccountNumber,	EUFundAccountName,
	USFundMajorExpenseCategory,	USFundAccountNumber,	USFundAccountName,	IsActive,	InsertedDate,	UpdatedDate,	UpdatedByStaffId)

	VALUES(4825,4602550005,'Fee Income','460255-0005','PROPERTY MANAGEMENT FEE','Fee Income','460255-0005','PROPERTY MANAGEMENT FEE',
	'NO MAPPING NEEDED','NO MAPPING NEEDED','NO MAPPING NEEDED','NO MAPPING NEEDED','NO MAPPING NEEDED','NO MAPPING NEEDED',
	'NO MAPPING NEEDED','NO MAPPING NEEDED','NO MAPPING NEEDED','No Mapping Needed','No Mapping Needed','No Mapping Needed',
	1,'2009/09/02','2009/09/02',NULL)
	SET IDENTITY_INSERT GlobalAccountMapping OFF
	END
GO

Update GlobalAccountMappingLookupFee 
Set GlobalAccountMappingId = 4695
Where FeeTypeId = 6 AND
FeeSubCategoryId = 8 AND	
GlobalAccountMappingId = 4694


Update GlobalAccountMappingLookupFee 
Set GlobalAccountMappingId = 4700
Where FeeTypeId = 8 AND
FeeSubCategoryId = 10 AND	
GlobalAccountMappingId = 4699

Update GlobalAccountMappingLookupFee 
Set GlobalAccountMappingId = 4702
Where FeeTypeId = 8 AND
FeeSubCategoryId = 12 AND	
GlobalAccountMappingId = 4701

Update GlobalAccountMappingLookupFee 
Set GlobalAccountMappingId = 4709
Where FeeTypeId = 9 AND
FeeSubCategoryId = 11 AND	
GlobalAccountMappingId = 4708

Update GlobalAccountMappingLookupFee 
Set GlobalAccountMappingId = 4825
Where FeeTypeId = 10 AND
FeeSubCategoryId = 13 AND	
GlobalAccountMappingId = 4710

GO

Update BC.dbo.Budget Set LockedDate = '2010-03-01 00:00:00.000' Where BudgetId = 1


update GrReportingStaging.BudgetingCorp.GlobalReportingCorporateBudget
Set LockedDate = '2010-03-01 00:00:00.000' 
Where BudgetId = 1

