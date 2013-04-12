
-- Iam purposefully not updateing GrReportingStaging because it should reflect what was imported and not updates.
USE GrReporting


BEGIN TRAN

--Get ID from GDM in query above
DECLARE @GeneralOverheadMajorGlAccountCategoryId Int = 'XXXX'
SELECT @GeneralOverheadMajorGlAccountCategoryId

--Check ID below from GDM
DECLARE @OccupancyCostsMajorGlAccountCategoryId Int = 2285
SELECT @OccupancyCostsMajorGlAccountCategoryId

--Check ID below from GDM
DECLARE @ExternalGeneralOverheadMinorGlAccountCategoryId Int = 22030
SELECT @ExternalGeneralOverheadMinorGlAccountCategoryId

UPDATE dbo.GlAccountCategory
SET GlobalGlAccountCategoryCode = REPLACE(GlobalGlAccountCategoryCode, ':' + 
								ltrim(rtrim(Convert(varchar,@OccupancyCostsMajorGlAccountCategoryId))) + ':' + 
								ltrim(rtrim(Convert(varchar,@ExternalGeneralOverheadMinorGlAccountCategoryId))),
								':' +
								ltrim(rtrim(Convert(varchar,@GeneralOverheadMajorGlAccountCategoryId))) + ':' + 
								ltrim(rtrim(Convert(varchar,@ExternalGeneralOverheadMinorGlAccountCategoryId)))
								),
MajorName = 'General Overhead'
WHERE MajorName = 'Occupancy Costs' AND MinorName = 'External General Overhead'

SELECT * FROM dbo.GlAccountCategory
WHERE MajorName = 'General Overhead' AND MinorName = 'External General Overhead'

ROLLBACK TRAN

