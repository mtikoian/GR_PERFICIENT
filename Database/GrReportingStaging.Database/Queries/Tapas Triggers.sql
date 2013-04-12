 CREATE TABLE #ColumnCount
(
	TABLE_SCHEMA VARCHAR(255),
	TABLE_NAME VARCHAR(255),
	ColumnCount INT
)

exec sp_MSForEachTable 
'
	INSERT INTO #ColumnCount 
	SELECT 
		c.TABLE_SCHEMA, c.TABLE_NAME, count(*)
	FROM 
		INFORMATION_SCHEMA.[COLUMNS] c
	WHERE
		''[''+c.TABLE_SCHEMA+''].[''+c.TABLE_NAME+'']'' = ''?'' AND 
		(
			c.COLUMN_NAME = ''UpdatedDate'' OR
			c.COLUMN_NAME = ''InsertedDate''
		)
	GROUP BY c.TABLE_SCHEMA, c.TABLE_NAME
'

DECLARE @TableSchema VARCHAR(255),
		@TableName VARCHAR(255),
		@ColumnCount INT

DECLARE 
	TriggerCursor 
CURSOR FOR 
	SELECT 
		TABLE_SCHEMA,
		TABLE_NAME,
		ColumnCount
	FROM 
		#ColumnCount

OPEN TriggerCursor

FETCH NEXT FROM 
	TriggerCursor 
INTO 
	@TableSchema,
	@TableName,
	@ColumnCount

WHILE @@FETCH_STATUS = 0
BEGIN
    
    DECLARE @PrimaryKeys TABLE (ColumnName VARCHAR(255))
	DELETE FROM @PrimaryKeys
    
    INSERT INTO @PrimaryKeys
    SELECT COLUMN_NAME
	FROM 
		INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu ON
			tc.CONSTRAINT_NAME=kcu.CONSTRAINT_NAME
	WHERE 
		CONSTRAINT_TYPE = 'PRIMARY KEY' AND
		tc.TABLE_NAME=@TableName AND
		tc.TABLE_SCHEMA=@TableSchema
    
    DECLARE @ColumnName VARCHAR(255),
			@WhereClause VARCHAR(5000)
	
	SET @WhereClause = ''

	DECLARE 
		KeyCursor 
	CURSOR FOR 
		SELECT 
			ColumnName
		FROM 
			@PrimaryKeys

	OPEN KeyCursor

	FETCH NEXT FROM 
		KeyCursor 
	INTO 
		@ColumnName

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    
	    IF @WhereClause <> ''
	    BEGIN
	    	SET @WhereClause = @WhereClause + ' AND ' 	    	
	    END
	    
		SET @WhereClause = @WhereClause + '[' + @TableSchema + '].[' + @TableName + '].[' + @ColumnName + '] IN (SELECT INSERTED.[' + @ColumnName + '] FROM INSERTED)' 
	
		 -- Get the next key.
		FETCH NEXT FROM 
			KeyCursor 
		INTO 
			@ColumnName
	END 

	CLOSE KeyCursor
	DEALLOCATE KeyCursor
    
    DECLARE @TriggerSQL VARCHAR(8000)
    SET @TriggerSQL = ''
    
    IF @ColumnCount = 1
    BEGIN
    
        	SET @TriggerSQL = '
CREATE TRIGGER GRDateFix' + @TableSchema + @TableName + '
ON  [' + @TableSchema + '].[' + @TableName + '] 
AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	IF ((SELECT InsertedDate 
         FROM 
         INSERTED)<''2010-01-01'')
	BEGIN
		UPDATE [' + @TableSchema + '].[' + @TableName + ']
		SET 
			InsertedDate = DATEADD(m,1, InsertedDate)
		WHERE ' + @WhereClause + '
	END
END'
    
    END
    
    IF @ColumnCount > 1
    BEGIN
    	
	SET @TriggerSQL = '
CREATE TRIGGER GRDateFix' + @TableSchema + @TableName + '
ON  [' + @TableSchema + '].[' + @TableName + '] 
AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @InsertedDate DATETIME
	DECLARE @UpdatedDate DATETIME
	
	SELECT
		@InsertedDate = ISNULL(InsertedDate , CAST(''1800-01-01'' AS DATETIME)),
		@UpdatedDate = ISNULL(UpdatedDate, CAST(''1800-01-01'' AS DATETIME)) 
	FROM
		INSERTED
	

	IF (@InsertedDate < ''2010-01-01'' AND @UpdatedDate < ''2010-01-01'')
	BEGIN
		UPDATE [' + @TableSchema + '].[' + @TableName + ']
		SET 
			InsertedDate = DATEADD(m,1, InsertedDate),
			UpdatedDate = DATEADD(m,1, UpdatedDate)
		WHERE ' + @WhereClause + '
	END
	 ELSE
	BEGIN
		IF (@InsertedDate > ''2010-01-01'' AND @UpdatedDate < ''2010-01-01'')
		BEGIN
			UPDATE [' + @TableSchema + '].[' + @TableName + ']
			SET 
				UpdatedDate = DATEADD(m,1, UpdatedDate)
			WHERE ' + @WhereClause + '
		END
	END
END'
    	
    END
    
    EXEC(@TriggerSQL)

     -- Get the next table.
    FETCH NEXT FROM 
		TriggerCursor 
	INTO 
		@TableSchema,
		@TableName,
		@ColumnCount
END 

CLOSE TriggerCursor
DEALLOCATE TriggerCursor
	
DROP TABLE #ColumnCount
GO

CREATE TRIGGER GRDateFixBudgetBudget
ON  [Budget].[Budget] 
AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @InsertedDate DATETIME
	DECLARE @UpdatedDate DATETIME
	DECLARE @LastLockedDate DATETIME
	
	SELECT
		@InsertedDate = ISNULL(InsertedDate , CAST('1800-01-01' AS DATETIME)),
		@UpdatedDate = ISNULL(UpdatedDate, CAST('1800-01-01' AS DATETIME)),
		@LastLockedDate = ISNULL(LastLockedDate, CAST('1800-01-01' AS DATETIME))
	FROM
		INSERTED
	

	IF (@InsertedDate < '2010-01-01' AND @UpdatedDate < '2010-01-01' AND @LastLockedDate < '2010-01-01')
	BEGIN
		UPDATE [Budget].[Budget] 
		SET 
			InsertedDate = DATEADD(m,1, InsertedDate),
			UpdatedDate = DATEADD(m,1, UpdatedDate),
			LastLockedDate = DATEADD(m,1, LastLockedDate)
		WHERE Budget.Budget.BudgetId IN (SELECT INSERTED.[BudgetId] FROM INSERTED)
	END
	 ELSE
	BEGIN
		IF (@InsertedDate > '2010-01-01' AND @UpdatedDate < '2010-01-01' AND @LastLockedDate < '2010-01-01')
		BEGIN
			UPDATE [Budget].[Budget] 
			SET 
				UpdatedDate = DATEADD(m,1, UpdatedDate),
				LastLockedDate = DATEADD(m,1, LastLockedDate)
			WHERE Budget.Budget.BudgetId IN (SELECT INSERTED.[BudgetId] FROM INSERTED)
		END
		 ELSE
		BEGIN
			IF (@InsertedDate > '2010-01-01' AND @UpdatedDate < '2010-01-01' AND @LastLockedDate > '2010-01-01')
			BEGIN
				UPDATE [Budget].[Budget] 
				SET 
					UpdatedDate = DATEADD(m,1, UpdatedDate)
				WHERE Budget.Budget.BudgetId IN (SELECT INSERTED.[BudgetId] FROM INSERTED)
			END
		END
	END
END

GO