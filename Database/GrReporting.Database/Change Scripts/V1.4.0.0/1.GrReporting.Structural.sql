--===============================================================================================================================
----------------------------------------------- Update Tables in the Warehouse
--===============================================================================================================================

-----------------
-- dbo.GlAccount
-----------------

BEGIN TRAN

USE [GrReporting]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

PRINT ('----- dbo.GlAccount -----')

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlAccount]') AND type in (N'U'))
BEGIN

    IF NOT EXISTS (SELECT TOP 1 * FROM dbo.GlAccount) -- make sure the table is empty
    BEGIN

        -- rather alter and rename fields to preserve column order

        -- rename GlobalGlAccountId to GLGlobalAccountId
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccount' AND COLUMN_NAME = 'GlobalGlAccountId')
        BEGIN
            EXEC sp_rename 'dbo.GlAccount.[GlobalGlAccountId]', 'GLGlobalAccountId', 'COLUMN'
            PRINT ('dbo.GlAccount.[GlobalGlAccountId] renamed to [GLGlobalAccountId]')
        END
        
        -- rename GlAccountCode to Code
        IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccount' AND COLUMN_NAME = 'GlAccountCode')
        BEGIN
        
            -- first drop the index on GlAccountCode, else we won't be able to rename the column        
            IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GlAccount]') AND name = N'IX_GlAccountCode')
            BEGIN
                DROP INDEX [IX_GlAccountCode] ON [dbo].[GlAccount] WITH ( ONLINE = OFF )
            END
            
            -- change data type from CHAR(12) to VARCHAR(10)
            ALTER TABLE
                dbo.GlAccount
            ALTER COLUMN
                GlAccountCode VARCHAR(10)            

            -- rename the column        
            EXEC sp_rename 'dbo.GlAccount.[GlAccountCode]', 'Code', 'COLUMN'
            
            -- recreate the index using the renamed column
            CREATE NONCLUSTERED INDEX [IX_Code] ON [dbo].[GlAccount] 
            (
	            [Code] ASC
            ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
            
            PRINT ('dbo.GlAccount.[GlAccountCode] renamed to [Code]')
        END
        
        -- rename GlAccountName to Name
        IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccount' AND COLUMN_NAME = 'GlAccountName')
        BEGIN
            -- change data type from NVARCHAR(250) to VARCHAR(150)
            ALTER TABLE
                dbo.GlAccount
            ALTER COLUMN
                GlAccountName NVARCHAR(150)
        
            EXEC sp_rename 'dbo.GlAccount.[GlAccountName]', 'Name', 'COLUMN'
            PRINT ('dbo.GlAccount.[GlAccountName] renamed to [Name]')
        END

    END
    ELSE
    BEGIN
        PRINT ('Cannot proceed because dbo.GlAccount is not empty - the table needs to be empty before this script can be run.')
    END

END

GO

COMMIT TRAN

-------------------------
-- dbo.GlAccountCategory
-------------------------

BEGIN TRAN

USE [GrReporting]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

PRINT ('----- dbo.GlAccountCategory -----')

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND type in (N'U'))
BEGIN

    IF NOT EXISTS (SELECT TOP 1 * FROM dbo.GlAccountCategory) -- make sure the table is empty
    BEGIN

        -- add column TranslationTypeName
        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'TranslationTypeName')
        BEGIN
		    ALTER TABLE
			    dbo.GlAccountCategory
		    ADD
			    TranslationTypeName VARCHAR(50) NOT NULL DEFAULT ''
    		
		    PRINT ('dbo.GlAccountCategory.[TranslationTypeName] added')
	    END

        -- add column TranslationSubTypeName
        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'TranslationSubTypeName')
        BEGIN    
		    ALTER TABLE
			    dbo.GlAccountCategory
		    ADD
			    TranslationSubTypeName VARCHAR(50) NOT NULL DEFAULT ''
    		
		    PRINT ('dbo.GlAccountCategory.[TranslationSubTypeName] added')
	    END

        -- drop column HierarchyName
        IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'HierarchyName')
        BEGIN
            ALTER TABLE
                dbo.GlAccountCategory
            DROP COLUMN
                HierarchyName
            
            PRINT ('dbo.GlAccountCategory.[HierarchyName] dropped')
        END    

        -- drop column MajorName and add column MajorCategoryName
        IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'MajorName')
        BEGIN
		    ALTER TABLE
			    dbo.GlAccountCategory
		    DROP COLUMN
			    MajorName

            ALTER TABLE
                dbo.GlAccountCategory
            ADD
                MajorCategoryName VARCHAR(50) NOT NULL DEFAULT ''
                
            PRINT ('dbo.GlAccountCategory.[MajorName] dropped, dbo.GlAccountCategory.[MajorCategoryName] added')            
        END
        
        -- drop column MinorName and add column MinorCategoryName
        IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'MinorName')
        BEGIN
		    ALTER TABLE
			    dbo.GlAccountCategory
		    DROP COLUMN
			    MinorName

            ALTER TABLE
                dbo.GlAccountCategory
            ADD
                MinorCategoryName VARCHAR(100) NOT NULL DEFAULT ''
                
            PRINT ('dbo.GlAccountCategory.[MinorName] dropped, dbo.GlAccountCategory.[MinorCategoryName] added')
        END

    END
    ELSE
    BEGIN
        PRINT ('Cannot proceed because dbo.GlAccountCategory is not empty - the table needs to be empty before this script can be run.')
    END

END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND type in (N'U'))
BEGIN 

    IF NOT EXISTS (SELECT TOP 1 * FROM dbo.GlAccountCategory) -- make sure the table is empty
    BEGIN
       
        -- drop column ExpenseType and add column AccountSubTypeName
        IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'ExpenseType')
        BEGIN
            ALTER TABLE
                dbo.GlAccountCategory
            DROP COLUMN
			    ExpenseType

            ALTER TABLE
                dbo.GlAccountCategory
            ADD
                AccountSubTypeName VARCHAR(50) NOT NULL DEFAULT ''

            PRINT ('dbo.GlAccountCategory.[ExpenseType] dropped, dbo.GlAccountCategory.[AccountSubTypeName] added')
        END

    END

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GlAccountCategory]') AND type in (N'U'))
BEGIN

    IF NOT EXISTS (SELECT TOP 1 * FROM dbo.GlAccountCategory) -- make sure the table is empty
    BEGIN

	    -- drop and recreate the date columns so that they are the last two columns in the table
	    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'StartDate')
	    BEGIN
	    	
	    	-- first drop the constraint, else the column can't be dropped
	        IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GlAccount__Start__438D9122]') AND type = 'D')
	        BEGIN
	            ALTER TABLE [dbo].[GlAccountCategory] DROP CONSTRAINT [DF__GlAccount__Start__438D9122]
	        END
	        
		    ALTER TABLE
			    dbo.GlAccountCategory
		    DROP COLUMN
			    StartDate
    			
		    ALTER TABLE
			    dbo.GlAccountCategory
		    ADD
			    StartDate DATETIME NOT NULL --DEFAULT '1753-01-01'
    		
    		-- don't recreate the constraint for the moment - might need to change this still
    		
		    PRINT ('dbo.GlAccountCategory.[StartDate] dropped, dbo.GlAccountCategory.[StartDate] added')
	    END

	    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GlAccountCategory' AND COLUMN_NAME = 'EndDate')
	    BEGIN

	    	-- first drop the constraint, else the column can't be dropped
	        IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__GlAccount__EndDa__41A548B0]') AND type = 'D')
	        BEGIN
	            ALTER TABLE [dbo].[GlAccountCategory] DROP CONSTRAINT [DF__GlAccount__EndDa__41A548B0]
	        END

		    ALTER TABLE
			    dbo.GlAccountCategory
		    DROP COLUMN
			    EndDate
    			
		    ALTER TABLE
			    dbo.GlAccountCategory
		    ADD
			    EndDate DATETIME NOT NULL --DEFAULT GETDATE()

            -- don't recreate the constraint for the moment - might need to change this still

            PRINT ('dbo.GlAccountCategory.[EndDate] dropped, dbo.GlAccountCategory.[EndDate] added')
	    END

    END

END

GO

COMMIT TRAN

------------------------------------------------------------------------------------------------------------------------

