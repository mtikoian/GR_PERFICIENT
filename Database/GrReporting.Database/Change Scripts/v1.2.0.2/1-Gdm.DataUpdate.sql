--For the lack of having a place to put this I have added GDM update here. When we have a process this should be moved to correct location.
--NB: TODO: Read comments below BEFORE running script
USE GDM

BEGIN TRAN

INSERT INTO dbo.MajorGlAccountCategory ([Name], InsertedDate, UpdatedDate)
VALUES ('General Overhead', GetDate(), GetDate())

DECLARE @GeneralOverheadMajorGlAccountCategoryId Int
SET @GeneralOverheadMajorGlAccountCategoryId = (SELECT MajorGlAccountCategoryId FROM dbo.MajorGlAccountCategory WHERE [Name] = 'General Overhead')
SELECT @GeneralOverheadMajorGlAccountCategoryId

DECLARE @OccupancyCostsMajorGlAccountCategoryId Int
SET @OccupancyCostsMajorGlAccountCategoryId = (SELECT MajorGlAccountCategoryId FROM dbo.MajorGlAccountCategory WHERE [Name] = 'Occupancy Costs')
SELECT @OccupancyCostsMajorGlAccountCategoryId

DECLARE @ExternalGeneralOverheadMinorGlAccountCategoryId Int
SET @ExternalGeneralOverheadMinorGlAccountCategoryId = (SELECT MinorGlAccountCategoryId FROM dbo.MinorGlAccountCategory WHERE [Name] = 'External General Overhead')
SELECT @ExternalGeneralOverheadMinorGlAccountCategoryId

UPDATE Gr.GlobalGlAccountCategoryHierarchy
SET MajorGlAccountCategoryId = @GeneralOverheadMajorGlAccountCategoryId
WHERE MajorGlAccountCategoryId = @OccupancyCostsMajorGlAccountCategoryId AND
MinorGlAccountCategoryId = @ExternalGeneralOverheadMinorGlAccountCategoryId

ROLLBACK TRAN
 