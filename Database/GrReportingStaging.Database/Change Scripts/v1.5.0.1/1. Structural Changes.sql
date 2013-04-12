 USE GrReportingStaging
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'Gdm' AND TABLE_NAME = 'GLGlobalAccountTranslationSubType' AND COLUMN_NAME = 'PostingPropertyGLAccountCode')
BEGIN

	ALTER TABLE
		Gdm.GLGlobalAccountTranslationSubType
	DROP COLUMN PostingPropertyGLAccountCode

END

GO
