USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[SPLIT]    Script Date: 12/10/2009 09:58:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPLIT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SPLIT]
GO

/********************************************************************/
--Description:  Split comma seperated varchar
--History: 
--         [yyyy-mm-dd]	: [Person]	: [Details of changes made] 
/********************************************************************/

CREATE FUNCTION [dbo].[SPLIT]
(
@itemList TEXT
)
RETURNS @ReturnTable TABLE (item varchar(100) NOT NULL)

AS
BEGIN

	DECLARE	@CommaIndexLen int,
		@IdCounter int,
		@CurrentChar varchar(1),
		@Id varchar(100),
		@TerminateIn int

	DECLARE	@itemTable TABLE (item varchar(100) NOT NULL)

	SET @TerminateIn = 0
	SET @IdCounter = 1
	SET @Id = ''

	-- @TerminateIn var is for catching infinite loops. If this is not returning all data, then increase the number
	WHILE  @IdCounter <= DATALENGTH(@itemList) AND @TerminateIn <= 500000
	BEGIN
		SET @CurrentChar = SUBSTRING(@itemList,@IdCounter, 1)

		IF @CurrentChar = '|'
		BEGIN
			INSERT INTO @itemTable (item)
			SELECT LTRIM(RTRIM(@Id))
			-- Clear the Id variable
			SET @Id = ''
		END
		ELSE
		BEGIN
			SET @Id = @Id + @CurrentChar
		END

		--Move to next Char
		SET @IdCounter = @IdCounter + 1
		SET @TerminateIn = @TerminateIn + 1
	END

	INSERT INTO @itemTable (item)
	SELECT @Id

	INSERT INTO @ReturnTable (item)
	SELECT DISTINCT item FROM @itemTable

	RETURN
	
END 

 