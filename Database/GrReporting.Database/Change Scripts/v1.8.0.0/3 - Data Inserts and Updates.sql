USE GrReporting
GO

UPDATE dbo.Reforecast
SET 
	ReforecastQuarterName = 'Q2'
WHERE
	ReforecastEffectivePeriod IN (201108, 201109)

















-- START StartDate and EndDate UPDATE ------------------------------------------------------------------------------------------------------------

-- The UNKNOWN records for the slowly changing dimensions have had their EndDate's changed from '9999-12-31 00:00:00.000'.
-- Make sure that all UNKNOWN records in the dimensions have an EndDate of '9999-12-31 00:00:00.000', and a StartDate of '1753-01-01 00:00:00.000'

USE GrReporting
GO

UPDATE
	dbo.ActivityType
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	ActivityTypeKey = -1 AND
	ActivityTypeId = -1 AND
	ActivityTypeCode = 'UNKNOWN' AND
	ActivityTypeName = 'UNKNOWN' AND
	SnapshotId = 0 AND
	BusinessLineId = -1 AND
	BusinessLineName = 'UNKNOWN'

GO

USE GrReporting
GO

UPDATE
	dbo.AllocationRegion
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	AllocationRegionKey = -1 AND
	GlobalRegionId = -1 AND
	RegionCode = 'UNKNOWN' AND
	RegionName = 'UNKNOWN' AND
	SubRegionCode = 'UNKNOWN' AND
	SubRegionName= 'UNKNOWN'

GO

USE GrReporting
GO

UPDATE
	dbo.FunctionalDepartment
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	FunctionalDepartmentKey = -1 AND
	ReferenceCode = -1 AND
	FunctionalDepartmentCode = 'UNKNOWN' AND
	FunctionalDepartmentName = 'UNKNOWN' AND
	SubFunctionalDepartmentCode = 'UNKNOWN' AND
	SubFunctionalDepartmentName = 'UNKNOWN'

GO

USE GrReporting
GO

UPDATE
	dbo.GLAccount
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	GlAccountKey = -1 AND
	GLGlobalAccountId = -1 AND
	Code = 'UNKNOWN' AND
	[Name] = 'UNKNOWN' AND
	AccountType = 'UNKNOWN' AND
	SnapshotId = 0

GO
USE GrReporting
GO

UPDATE
	dbo.GlAccountCategory
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	MajorCategoryName = 'UNKNOWN' AND
	MinorCategoryName = 'UNKNOWN' AND
	FeeOrExpense = 'UNKNOWN' AND
	SnapshotId = 0

GO
USE GrReporting
GO

UPDATE
	dbo.OriginatingRegion
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	OriginatingRegionKey = -1 AND
	GlobalRegionId = -1 AND
	RegionName = 'UNKNOWN' AND
	RegionCode = 'UNKNOWN' AND
	SubRegionCode = 'UNKNOWN' AND
	SubRegionName = 'UNKNOWN' AND
	SnapshotId = 0

GO
USE GrReporting
GO

UPDATE
	dbo.PropertyFund
SET
	StartDate = '1753-01-01 00:00:00.000',
	EndDate = '9999-12-31 00:00:00.000'
WHERE
	PropertyFundKey = -1 AND
	PropertyFundId = -1 AND
	PropertyFundName = 'UNKNOWN' AND
	PropertyFundType = 'UNKNOWN' AND
	SnapshotId = 0

GO

-- END StartDate and EndDate UPDATE --------------------------------------------------------------------------------------------------------------


