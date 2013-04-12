USE GDM
GO
/*
EntityType: populate with correct data 
RelatedFund: rename to RelatedFund and populate
GlobalProjectRegion			
ProjectRegion
PropertyFund: populate with correct data 
PropertyFundMapping: add foreign key reference to PropertyFund
					 Add column & foregnkey reference to ActivityType (allow null)
					 
*/


IF NOT EXISTS(Select * From EntityType)
	BEGIN
	SET IDENTITY_INSERT [EntityType] ON
	
	INSERT INTO [dbo].[EntityType]
           (EntityTypeId,
			[Name]
           ,[Description]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[UpdatedByStaffId])
	Select 
			ProjectTypeId,
			[Name]
           ,[Description]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[UpdatedByStaffId]
	From [TAPASUS].[Project].[ProjectType]

	SET IDENTITY_INSERT [EntityType] OFF
	
	END

IF NOT EXISTS(Select * From RelatedFund)
	BEGIN
	SET IDENTITY_INSERT [RelatedFund] ON
	INSERT INTO [dbo].[RelatedFund]
           (RelatedFundId
           ,[Name]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[UpdatedByStaffId])
     
	Select RelatedFundId
           ,[Name]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[UpdatedByStaffId]
     From [TAPASUS].[Admin].RelatedFund
	
	SET IDENTITY_INSERT [RelatedFund] OFF
	END


IF NOT EXISTS(Select * From GlobalProjectRegion)
	BEGIN
	SET IDENTITY_INSERT [GlobalProjectRegion] ON
	INSERT INTO [dbo].[GlobalProjectRegion]
           (GlobalProjectRegionId,
			Name,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId)
     
	Select 
			GlobalProjectRegionId,
			Name,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId
     From [TAPASUS].[Project].GlobalProjectRegion
	
	SET IDENTITY_INSERT [GlobalProjectRegion] OFF
	END


IF NOT EXISTS(Select * From ProjectRegion)
	BEGIN
	SET IDENTITY_INSERT [ProjectRegion] ON
	INSERT INTO [dbo].[ProjectRegion]
           (ProjectRegionId,
			GlobalProjectRegionId,
			Name,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId)
     
	Select 
			ProjectRegionId,
			GlobalProjectRegionId,
			Name,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId
			
     From [TAPASUS].[Project].ProjectRegion
	
	SET IDENTITY_INSERT [ProjectRegion] OFF
	END



IF NOT EXISTS(Select * From PropertyFund)
	BEGIN
	SET IDENTITY_INSERT [PropertyFund] ON
	INSERT INTO [dbo].[PropertyFund]
           (PropertyFundId,
			RelatedFundId,
			EntityTypeId,
			ProjectRegionId,
			Name,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId)
     
	Select 
			PropertyFundId,
			RelatedFundId,
			ProjectTypeId,
			ProjectRegionId,
			Name,
			InsertedDate,
			UpdatedDate,
			UpdatedByStaffId

     From [TAPASUS].[Admin].[PropertyFund]
	
	SET IDENTITY_INSERT [PropertyFund] OFF
	END

--Add the FK Reference Back, now that the data is laoded

IF NOT EXISTS(Select * From sysobjects Where Name = 'FK_PropertyFundMapping_PropertyFund')
	BEGIN
	ALTER TABLE Gr.PropertyFundMapping ADD CONSTRAINT
		FK_PropertyFundMapping_PropertyFund FOREIGN KEY
		(
		PropertyFundId
		) REFERENCES dbo.PropertyFund
		(
		PropertyFundId
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 
	END	
GO