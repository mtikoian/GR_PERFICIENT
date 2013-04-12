/*
1. Create the following Major and Minor Categories of the same name
	- Corporate Tax
	- Depreciation Expense
	- Guaranteed Payment
	- Interest and Penalties
	- Realized (Gain)/Loss Major Category
	- Unrealized (Gain)/Loss
2. Insert Business Lines into Business Line table
3. Map Business Lines to ActivityTypes in ActivityTypeBusinessLine table
*/

USE GDM
GO

 -----------------------------------------------------
 /*		Create new Major and Minor Categories		*/
 -----------------------------------------------------
 
 -- Creates the Corporate Tax Major Category
DECLARE @GLTranslationSubTypeId INT = (SELECT TOP 1 GLTranslationSubTypeId FROM GLTranslationSubType WHERE Code = 'GL')
IF NOT EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Corporate Tax')
	
	BEGIN
	
	INSERT INTO GlMajorCategory 
	(
		GLTranslationSubTypeId, 
		[Name], 
		UpdatedByStaffId
	)
	VALUES
	(
		@GLTranslationSubTypeId, 
		'Corporate Tax', 
		-1
	)
	
	END
GO

-- Creates the Corporate Tax Minor Category
IF NOT EXISTS (SELECT * FROM GlMinorCategory WHERE [Name] = 'Corporate Tax')
	
	BEGIN
	
	IF EXISTS (	SELECT * 
				FROM GlMajorCategory 
				WHERE [Name] = 'Corporate Tax')
		BEGIN
		DECLARE @GlMajorCategoryId INT = (SELECT TOP 1 GlMajorCategoryId from GlMajorCategory WHERE [Name] = 'Corporate Tax')
		
		INSERT INTO GlMinorCategory 
		(
			GlMajorCategoryId, 
			[Name], 
			UpdatedByStaffId
		)
		VALUES
		(
			@GlMajorCategoryId, 
			'Corporate Tax', 
			-1
		)
	END
	ELSE
		PRINT ('Corporate Tax Major Category does not exist')
	END
GO


-- Creates the Depreciation Major Category

DECLARE @GLTranslationSubTypeId INT = (SELECT TOP 1 GLTranslationSubTypeId FROM GLTranslationSubType WHERE Code = 'GL')
IF NOT EXISTS (	SELECT * 
				FROM 
					GlMajorCategory 
				WHERE [Name] = 'Depreciation Expense')
	BEGIN
		INSERT INTO GlMajorCategory 
		(
			GLTranslationSubTypeId, 
			[Name], 
			UpdatedByStaffId
		)
		VALUES
		(
			@GLTranslationSubTypeId,
			'Depreciation Expense', 
			-1
		)
	END
GO

-- Creates the Depreciation Minor Category
IF NOT EXISTS (SELECT * FROM GlMinorCategory WHERE [Name] = 'Depreciation Expense')
	
	BEGIN
	
	IF EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Depreciation Expense')
		BEGIN
			DECLARE @GlMajorCategoryId INT = (SELECT TOP 1 GlMajorCategoryId from GlMajorCategory WHERE [Name] = 'Depreciation Expense')
			INSERT INTO GlMinorCategory 
			(
				GlMajorCategoryId, 
				[Name], 
				UpdatedByStaffId
			)
			VALUES 
			(
				@GlMajorCategoryId, 
				'Depreciation Expense', 
				-1
			)
		END
	ELSE
		PRINT ('Depreciation Expense Major Category does not exist')
	END
	
	GO



-- Creates the Guaranteed Payment Major Category

DECLARE @GLTranslationSubTypeId INT = (SELECT TOP 1 GLTranslationSubTypeId FROM GLTranslationSubType WHERE Code = 'GL')

IF NOT EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Guaranteed Payment')

BEGIN

INSERT INTO GlMajorCategory 
(
	GLTranslationSubTypeId, 
	[Name], 
	UpdatedByStaffId
)
VALUES
(
	@GLTranslationSubTypeId, 
	'Guaranteed Payment', 
	-1
)
END
GO

-- Creates the Guaranteed Payment Minor Category

IF NOT EXISTS (SELECT * FROM GlMinorCategory WHERE [Name] = 'Guaranteed Payment')
BEGIN
IF EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Guaranteed Payment')
	BEGIN
	
	DECLARE @GlMajorCategoryId INT = (SELECT TOP 1 GlMajorCategoryId from GlMajorCategory WHERE [Name] = 'Guaranteed Payment')
	
	INSERT INTO GlMinorCategory 
	(
		GlMajorCategoryId, 
		[Name], 
		UpdatedByStaffId
	)
	VALUES 
	(
		@GlMajorCategoryId, 
		'Guaranteed Payment', 
		-1
	)
	END
ELSE
	PRINT ('Guaranteed Payment Major Category does not exist')
END
GO


-- Creates the Interest and Penalties Major Category
DECLARE @GLTranslationSubTypeId INT = (SELECT TOP 1 GLTranslationSubTypeId FROM GLTranslationSubType WHERE Code = 'GL')
IF NOT EXISTS (	SELECT * 
				FROM GlMajorCategory 
				WHERE [Name] = 'Interest and Penalties')
BEGIN
INSERT INTO GlMajorCategory 
(
	GLTranslationSubTypeId, 
	[Name], 
	UpdatedByStaffId
)
VALUES
(
	@GLTranslationSubTypeId, 
	'Interest and Penalties', 
	-1
)
END
GO

-- Creates the Interest and Penalties Minor Category
IF NOT EXISTS (SELECT * FROM GlMinorCategory WHERE [Name] = 'Interest and Penalties')

BEGIN
IF EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Interest and Penalties')
	BEGIN
	DECLARE @GlMajorCategoryId INT = (SELECT TOP 1 GlMajorCategoryId from GlMajorCategory WHERE [Name] = 'Interest and Penalties')
	
	INSERT INTO GlMinorCategory 
	(
		GlMajorCategoryId, 
		[Name], 
		UpdatedByStaffId
	)
	VALUES 
	(
		@GlMajorCategoryId, 
		'Interest and Penalties', 
		-1
	)
	END
ELSE
	PRINT ('Interest and Penalties Major Category does not exist')

END
GO


-- Creates the Realized (Gain)/Loss Major Category
DECLARE @GLTranslationSubTypeId INT = (	SELECT TOP 1 GLTranslationSubTypeId FROM GLTranslationSubType WHERE Code = 'GL')

IF NOT EXISTS (	SELECT * 
				FROM GlMajorCategory 
				WHERE [Name] = 'Realized (Gain)/Loss')
BEGIN
INSERT INTO GlMajorCategory 
(
	GLTranslationSubTypeId, 
	[Name], 
	UpdatedByStaffId
)
VALUES
(
	@GLTranslationSubTypeId, 
	'Realized (Gain)/Loss', 
	-1
)
END
GO

-- Creates the Realized (Gain)/Loss Minor Category
IF NOT EXISTS (SELECT * FROM GlMinorCategory WHERE [Name] = 'Realized (Gain)/Loss')
BEGIN
IF EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Realized (Gain)/Loss')
	
	BEGIN
	DECLARE @GlMajorCategoryId INT = (SELECT TOP 1 GlMajorCategoryId from GlMajorCategory WHERE [Name] = 'Realized (Gain)/Loss')
	
	INSERT INTO GlMinorCategory 
	(
		GlMajorCategoryId, 
		[Name], 
		UpdatedByStaffId
	)
	VALUES 
	(
		@GlMajorCategoryId, 
		'Realized (Gain)/Loss', 
		-1
	)
	END
ELSE
	PRINT ('Realized (Gain)/Loss Major Category does not exist')
END
GO

END


-- Creates the Unrealized (Gain)/Loss Major Category
DECLARE @GLTranslationSubTypeId INT = (SELECT TOP 1 GLTranslationSubTypeId FROM GLTranslationSubType WHERE Code = 'GL')
IF NOT EXISTS (	SELECT * 
				FROM 
					GlMajorCategory 
				WHERE 
					[Name] = 'Unrealized (Gain)/Loss')
BEGIN

INSERT INTO GlMajorCategory 
(
	GLTranslationSubTypeId, 
	[Name], 
	UpdatedByStaffId
)
VALUES
(
	@GLTranslationSubTypeId, 
	'Unrealized (Gain)/Loss', 
	-1
)
END
GO

-- Creates the Unrealized (Gain)/Loss Minor Category
IF NOT EXISTS (	SELECT * 
				FROM 
					GlMinorCategory 
				WHERE 
					[Name] = 'Unrealized (Gain)/Loss')
BEGIN
IF EXISTS (SELECT * FROM GlMajorCategory WHERE [Name] = 'Unrealized (Gain)/Loss')
	BEGIN
	
	DECLARE @GlMajorCategoryId INT = (SELECT TOP 1 GlMajorCategoryId from GlMajorCategory WHERE [Name] = 'Unrealized (Gain)/Loss')
	
	INSERT INTO GlMinorCategory 
	(
		GlMajorCategoryId, 
		[Name], 
		UpdatedByStaffId
	)
	VALUES 
	(
		@GlMajorCategoryId, 
		'Unrealized (Gain)/Loss', 
		-1
	)
	END
ELSE
	PRINT ('Unrealized (Gain)/Loss Expense Major Category does not exist')
END
GO


 ------------------------------------------------------------
 /*		End of Create new Major and Minor Categories		*/
 -------------------------------------------------------------
 
 -------------------------------------------------------------
 /*		Insert Business Lines and Map to Activity Types		*/
 -------------------------------------------------------------
 
 INSERT INTO BusinessLine
 (
	[Name],
	UpdatedByStaffId
 )
 VALUES
	('Property Management', -1),
	('Fund Management', -1),
	('Leasing', -1),
	('Development', -1),
	('Corporate', -1),
	('Overhead', -1),
	('Unknown', -1)
	
 INSERT INTO ActivityTypeBusinessLine
 ( 
	ActivityTypeId,
	BusinessLineId,
	UpdatedByStaffId
 )
 SELECT DISTINCT
		[AT].ActivityTypeId,
		BusinessLineId = 
			CASE [AT].[Name] 
				WHEN	'Property Management Escalatable'		THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Property Management')
				WHEN	'Property Management Non-Escalatable'	THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Property Management')
				WHEN	'Property Management CapEx'				THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Property Management') 
				WHEN	'Property Management TI'				THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Property Management')
				
				WHEN	'Acquisitions'							THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Fund Management')
				WHEN	'Asset Management'						THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Fund Management')
				WHEN	'Fund Operations'						THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Fund Management')
				WHEN	'Fund Organization'						THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Fund Management')
				WHEN	'Syndication (Investment and Fund)'		THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Fund Management')
				
				WHEN	'Leasing'								THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Leasing')
				WHEN	'Development'							THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Development')
				WHEN	'Corporate'								THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Corporate')
				WHEN	'Corporate Overhead'					THEN (SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Overhead')
				ELSE	(SELECT TOP 1 BusinessLineId FROM BusinessLine WHERE [Name] = 'Unknown')
			END,
		-1
		FROM ActivityType [AT]
		
-------------------------------------------------------------
 /* End of Insert Business Lines and Map to Activity Types	*/
 -------------------------------------------------------------
 