DECLARE	@GlobalAccountCode char(10),
	@GlobalAccountViewTypeCode char(3),
	@MajorGlAccountCategoryName varchar(100),
	@MinorGlAccountCategoryName varchar(100),
	@GlobalAccountViewAccountTypeCode char(6),
	@InsertedDate datetime,
	@GlobalGlAccountId Int,
	@GlobalAccountName nvarchar(200),
	@GlobalGlAccountCategoryId Int,
	@MajorGlAccountCategoryId Int,
	@MinorGlAccountCategoryId Int
	
SET NOCOUNT ON

DECLARE CC1 SCROLL Cursor FOR

SELECT GrGl.GlobalAccountCode
      ,GrGl.GlobalAccountViewTypeCode
      ,GrGl.MajorAccountCategoryName
      ,GrGl.MinorAccountCategoryName
      ,GrGl.GlobalAccountViewAccountTypeCode
      ,GrGl.InsertedDate
      ,Gl.GlobalAccountName
  FROM GL.dbo.GlobalAccountView GrGl
			INNER JOIN GL.dbo.GlobalAccount Gl ON Gl.GlobalAccountCode = GrGl.GlobalAccountCode
	
OPEN CC1
FETCH NEXT From CC1 INTO @GlobalAccountCode,@GlobalAccountViewTypeCode,
						@MajorGlAccountCategoryName,@MinorGlAccountCategoryName,
						@GlobalAccountViewAccountTypeCode,@InsertedDate, 
						@GlobalAccountName
WHILE (@@fetch_status <> -1)
	BEGIN
	IF (@@fetch_status <> -2)
		BEGIN
		--MajorAccountCategory
		SET @MajorGlAccountCategoryId = (Select MajorGlAccountCategoryId From dbo.MajorGlAccountCategory Where Name = @MajorGlAccountCategoryName)
		
		IF @MajorGlAccountCategoryId IS NULL
			BEGIN
			INSERT INTO [GDM].[dbo].[MajorGlAccountCategory]
			([Name])
			VALUES
			(@MajorGlAccountCategoryName)
			
			SET @MajorGlAccountCategoryId = SCOPE_IDENTITY()
			END
		
		--MinorAccountCategory	
		SET @MinorGlAccountCategoryId = (Select MinorGlAccountCategoryId From dbo.MinorGlAccountCategory Where Name = @MinorGlAccountCategoryName)
		
		IF @MinorGlAccountCategoryId IS NULL
			BEGIN
			INSERT INTO [GDM].[dbo].[MinorGlAccountCategory]
			([Name])
			VALUES
			(@MinorGlAccountCategoryName)
			
			SET @MinorGlAccountCategoryId = SCOPE_IDENTITY()
			END
			

		SET @GlobalGlAccountId = (Select GlobalGlAccountId 
									From Gr.GlobalGlAccount
									Where GlAccountCode = @GlobalAccountCode)

		--SETUP GlobalGlAccount
		IF @GlobalGlAccountId IS NULL
			BEGIN
			INSERT INTO [GDM].[Gr].[GlobalGlAccount]
           ([GlAccountCode]
           ,[Name]
           ,[AccountType]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,MajorGlAccountCategoryId
           ,MinorGlAccountCategoryId)
			 VALUES
			(@GlobalAccountCode
			,@GlobalAccountName
			,@GlobalAccountViewAccountTypeCode
			,getdate()
			,getdate()
			,@MajorGlAccountCategoryId
			,@MinorGlAccountCategoryId
			)	   
			END
		ELSE
			BEGIN
			UPDATE [GDM].[Gr].[GlobalGlAccount]
			   SET	[Name]						= @GlobalAccountName
					,[AccountType]				= @GlobalAccountViewAccountTypeCode
					,[UpdatedDate]				= getdate()
					,MajorGlAccountCategoryId	= @MajorGlAccountCategoryId
					,MinorGlAccountCategoryId	= @MinorGlAccountCategoryId

			 WHERE GlAccountCode = @GlobalAccountCode
			END
			
		SET @GlobalGlAccountId = null
		END
	FETCH NEXT From CC1 INTO @GlobalAccountCode,@GlobalAccountViewTypeCode,@MajorGlAccountCategoryName,@MinorGlAccountCategoryName,
							@GlobalAccountViewAccountTypeCode,@InsertedDate, @GlobalAccountName
	END
CLOSE CC1
DEALLOCATE CC1

GO