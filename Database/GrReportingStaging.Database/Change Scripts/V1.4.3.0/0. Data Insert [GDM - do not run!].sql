USE GDM
GO

IF NOT EXISTS (SELECT * FROM dbo.ManageType WHERE Code = 'GMREXCL')
BEGIN

	INSERT INTO dbo.ManageType (
		Code,
		Name,
		[Description],
		UpdatedByStaffId
	)
	VALUES (
		'GMREXCL',
		'Global Management Report Exclusion',
		'Items that are excluded by the Global Management Reports',
		-1
	)

END
ELSE
BEGIN
	PRINT ('Cannot insert ManageType with code ''GMREXCL'' because it already exists in dbo.ManageType')
END