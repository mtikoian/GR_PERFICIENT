-- Disable referential integrity
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

-- Delete all the data in all tables
EXEC sp_MSForEachTable '
	IF OBJECTPROPERTY(object_id(''?''), ''TableHasForeignRef'') = 1
		DELETE FROM ?
	ELSE
		TRUNCATE TABLE ?
'
GO

-- This will reseed each table
EXEC sp_MSForEachTable '
	IF OBJECTPROPERTY(object_id(''?''), ''TableHasIdentity'') = 1
		DBCC CHECKIDENT (''?'', RESEED, 1)
'
GO

-- Enable referential integrity again
EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'