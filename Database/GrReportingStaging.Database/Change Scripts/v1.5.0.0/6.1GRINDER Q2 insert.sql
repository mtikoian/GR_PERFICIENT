USE BC_TS_GRINDER_Q2
GO

INSERT INTO dbo.FeeDetail (
	Additional_Remarks,
	PreDevelopment_Start,
	PreDevelopment_End,
	Development_StartDate,
	Expected_Completion,
	Total_Anticipated_Cost,
	PreDevelopment_Fee,
	Development_Fee,
	Total_TI_Area_RSF,
	Spec_TI_Area_RSF,
	Spec_Dollar_TI,
	Spec_Percent,
	Signed_Dollar_TI,
	Signed_Percent,
	Building_Description_Capex,
	Total_Leasing_Area,
	Spec_Area,
	Spec_Leasing_Dollar,
	Signed_Dollar,
	Property_Revenue,
	Implied_Mgmt_Fee,
	RecordType,
	Created,
	LastUpdated,
	LastUpdatedBy,
	Leasing_Spec_Percent,
	Leasing_Signed_Percent,
	Asset_GAVBasis,
	Asset_FeePercentage,
	FeeTypeId,
	FeeCategoryId,
	SubRegionId,
	EntityId,
	RelatedFundId,
	CurrencyId,
	ReclassificationDesc,
	PropFundMRIDeptCodeMappingId,
	IsAdjustment
)
VALUEs (
	'Part of the original budget numbers has been moved to CGII since they are now forecast separately.', -- Additional_Remarks
	NULL, -- PreDevelopment_Start
	NULL, -- PreDevelopment_End
	NULL, -- Development_StartDate
	NULL, -- Expected_Completion
	NULL, -- Total_Anticipated_Cost
	NULL, -- PreDevelopment_Fee
	NULL, -- Development_Fee
	22784, -- Total_TI_Area_RSF
	22784, -- Spec_TI_Area_RSF
	19168, -- Spec_Dollar_TI
	100, -- Spec_Percent
	0, -- Signed_Dollar_TI
	0, -- Signed_Percent
	NULL, -- Building_Description_Capex
	NULL, -- Total_Leasing_Area
	NULL, -- Spec_Area
	NULL, -- Spec_Leasing_Dollar
	NULL, -- Signed_Dollar
	NULL, -- Property_Revenue
	NULL, -- Implied_Mgmt_Fee
	'NEW', -- RecordType
	'2009/11/06  07:09:00 PM', -- Created
	'2010/07/15  07:23:00 PM', -- LastUpdated
	'cal178', -- LastUpdatedBy
	NULL, -- Leasing_Spec_Percent
	NULL, -- Leasing_Signed_Percent
	NULL, -- Asset_GAVBasis
	NULL, -- Asset_FeePercentage
	3, -- FeeTypeId
	7, -- FeeCategoryId
	175, -- SubRegionId
	2030, -- EntityId
	NULL, -- RelatedFundId
	4, -- CurrencyId
	'We have been doing more as-is deals this year than originally planned.', -- ReclassificationDesc
	76, -- PropFundMRIDeptCodeMappingId
	0 -- IsAdjustment
)

---------------------

DECLARE @Inserted_FeeDetailUID INT = SCOPE_IDENTITY()

INSERT INTO dbo.FeeBudgetDetail(
	FeeDetailUID,
	FeeYear,
	[Version],
	isLocked,
	January,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	October,
	November,
	December,
	YearlyTotal,
	Comments,
	Created,
	LastUpdated,
	FeeBudgetCycleUID,
	isActive
)
VALUES (
	@Inserted_FeeDetailUID, -- FeeDetailUID
	2010, -- FeeYear
	4, -- Version
	'Y', -- isLocked
	0, -- January
	0, -- February
	0, -- March
	0, -- April
	0, -- May
	13288, -- June
	0, -- July
	0, -- August
	0, -- September
	0, -- October
	0, -- November
	0, -- December
	13288, -- YearlyTotal
	NULL, -- Comments
	'2010/06/30  10:04:00 PM', -- Created
	'2010/06/30  10:05:00 PM', -- LastUpdated
	4, -- FeeBudgetCycleUID
	1 -- isActive
)
