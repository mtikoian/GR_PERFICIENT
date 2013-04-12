--Select * From dbo.ImportCorporateDepartmentMapping Where MRIDeptCode = '009320'

USE GDM_Import
GO
SET NOCOUNT ON
SET QUOTED_IDENTIFIER OFF
DECLARE @ImportVersion		Int
DECLARE	@CorpMRISource		NVarchar(50)
DECLARE	@MRIDeptCode		NVarchar(50)
DECLARE	@ActvityList		NVarchar(500)
DECLARE	@ActvityTypeCode	NVarchar(255)
DECLARE	@PropertyFundId		Int
DECLARE	@ActivityTypeId		Int
DECLARE @ReportingEntity	NVarchar(255)
DECLARE @BillingEntityType	NVarchar(255)
DECLARE @ReportingRegion	NVarchar(255)
DECLARE @ReportingRegionId	Int
DECLARE @EntityTypeId		Int

BEGIN TRAN


--DROP TABLE #Changes
CREATE TABLE #Changes
(PropertyFundId Int NOT NULL, 
ReportingRegionName Varchar(100) NOT NULL, 
ProjectRegionName Varchar(100) NOT NULL,
ReportingEntityRegionName Varchar(100) NOT NULL,
ProjectTypeName Varchar(100) NOT NULL, 
EntityTypeName Varchar(100) NOT NULL)
						
						
print 'Confirm you use the correct version in : GDM_Import.dbo.ImportCorporateDepartmentMapping '
			
--Select max(ImportVersion) From GDM_Import.dbo.ImportCorporateDepartmentMapping 
SET @ImportVersion = 17


DECLARE CC0 SCROLL Cursor FOR

Select 
		DISTINCT
		LTRIM(RTRIM(CorpMRISource)), 
		LTRIM(RTRIM(MRIDeptCode))
From GDM_Import.dbo.ImportCorporateDepartmentMapping 
Where ImportVersion = @ImportVersion

OPEN CC0
FETCH NEXT From CC0 INTO @CorpMRISource, @MRIDeptCode
WHILE (@@fetch_status <> -1)
	BEGIN
	IF (@@fetch_status <> -2)
		BEGIN


		--ProcessFlow	
		--Mark All mappings for deletion
		--Update & Insert new mappings&activity, with rmeoving the IsDeleted tag on them
		Update GDM.Gr.PropertyFundMapping 
		SET IsDeleted = 1,
			UpdatedDate = getdate()
		Where SourceCode = @CorpMRISource
		AND PropertyFundCode = @MRIDeptCode
		--AND PropertyFundId = @PropertyFundId
		
		DECLARE CC SCROLL Cursor FOR

		Select 
				Activity, 
				LTRIM(RTRIM(ReportingEntity)), 
				LTRIM(RTRIM(BillingEntityType)), 
				LTRIM(RTRIM(ReportingRegion)) 
		From GDM_Import.dbo.ImportCorporateDepartmentMapping 
		Where ImportVersion = @ImportVersion
		AND LTRIM(RTRIM(CorpMRISource)) = @CorpMRISource
		AND LTRIM(RTRIM(MRIDeptCode)) = @MRIDeptCode

		OPEN CC
		FETCH NEXT From CC INTO @ActvityList,@ReportingEntity, @BillingEntityType, @ReportingRegion
		WHILE (@@fetch_status <> -1)
			BEGIN
			IF (@@fetch_status <> -2)
				BEGIN

				SET @EntityTypeId = (Select EntityTypeId From GDM.dbo.EntityType Where Name = @BillingEntityType)

				--Get the ProjectRegion, should it not exists, insert it
				SET @ReportingRegionId = (Select ProjectRegionId From GDM.dbo.ProjectRegion Where Name = @ReportingRegion)
				
				IF @ReportingRegionId IS NULL
					BEGIN
					INSERT INTO [GDM].[dbo].[ProjectRegion]
					   ([GlobalProjectRegionId]
					   ,[Name]
					   ,[InsertedDate]
					   ,[UpdatedDate]
					   ,[UpdatedByStaffId])
					Select
					   (Select GlobalProjectRegionId From Gdm.dbo.GlobalProjectRegion Where NAme = 'To Be Confirmed')
					   ,@ReportingRegion
					   ,getdate()
					   ,getdate()
					   ,-1
					SET @ReportingRegionId = SCOPE_IDENTITY()
					END

				--Get the PropertyFund, should it not exists, insert it
				SET @PropertyFundId = (Select PropertyFundId From GDM.dbo.PropertyFund Where Name = @ReportingEntity)

				IF @PropertyFundId IS NULL
					BEGIN
						
					INSERT INTO [GDM].[dbo].[PropertyFund]
							   ([RelatedFundId]
							   ,[EntityTypeId]
							   ,[ProjectRegionId]
							   ,[Name]
							   ,[IsReportingEntity]
							   ,[IsPropertyFund]
							   ,[InsertedDate]
							   ,[UpdatedDate]
							   ,[UpdatedByStaffId])
						 Select
							   NULL
							   ,@EntityTypeId
							   ,@ReportingRegionId
							   ,@ReportingEntity
							   ,1
							   ,0
							   ,getdate()
							   ,getdate()
							   ,-1

						SET @PropertyFundId = SCOPE_IDENTITY()
					END

				ELSE
					BEGIN

					IF EXISTS(Select * 
						From [GDM].[dbo].[PropertyFund]
						Where PropertyFundId = @PropertyFundId
						AND (EntityTypeId <> @EntityTypeId OR ProjectRegionId <> @ReportingRegionId))
						BEGIN
						Insert Into #Changes
						(PropertyFundId, ReportingRegionName, ProjectRegionName, ReportingEntityRegionName,ProjectTypeName,EntityTypeName)
						Select  @PropertyFundId PropertyFundId, 
								@ReportingEntity ReportingEntityName, 
								(Select Name From [GDM].[dbo].[ProjectRegion] Where [ProjectRegionId] = pf.[ProjectRegionId]),
								(Select Name From [GDM].[dbo].[ProjectRegion] Where [ProjectRegionId] = @ReportingRegionId),
								(Select Name From [GDM].[dbo].[EntityType] Where [EntityTypeId] = @EntityTypeId),
								(Select Name From [GDM].[dbo].[EntityType] Where [EntityTypeId] = pf.EntityTypeId)
						From [GDM].[dbo].[PropertyFund] pf
						Where PropertyFundId = @PropertyFundId
						END
					
					
					Update [GDM].[dbo].[PropertyFund]
					SET	[EntityTypeId]			= @EntityTypeId
						,[ProjectRegionId]		= @ReportingRegionId
						,[UpdatedDate]			= getdate()
						,[UpdatedByStaffId]	= -1
					Where PropertyFundId = @PropertyFundId
					
					END

				DECLARE CC1 SCROLL Cursor FOR
				--LEASE is error in spreadsheet
				Select CASE WHEN LTRIM(RTRIM(Field1)) = 'LEAS' THEN 'LEASE' ELSE LTRIM(RTRIM(Field1)) END From GDM_Import.dbo.ConvertCsvToTable(@ActvityList)

				OPEN CC1
				FETCH NEXT From CC1 INTO @ActvityTypeCode
				WHILE (@@fetch_status <> -1)
					BEGIN
					IF (@@fetch_status <> -2)
						BEGIN
						--select @ActvityTypeCode
						IF @ActvityTypeCode = 'NOACT'
							BEGIN
							SET @ActivityTypeId = NULL
							END
						ELSE
							BEGIN
							SET @ActivityTypeId = (Select ActivityTypeId From Gdm.dbo.ActivityType Where ActivityTypeCode = @ActvityTypeCode)
							END
							
						IF EXISTS(Select * 
										From GDM.Gr.PropertyFundMapping 
										Where SourceCode = @CorpMRISource
										AND PropertyFundCode = @MRIDeptCode
										AND (ActivityTypeId = @ActivityTypeId OR (ActivityTypeId IS NULL AND @ActivityTypeId IS NULL))
										)
							BEGIN
							Update GDM.Gr.PropertyFundMapping 
							SET IsDeleted = 0,
								UpdatedDate = getdate(),
								PropertyFundId = @PropertyFundId
							Where SourceCode = @CorpMRISource
							AND PropertyFundCode = @MRIDeptCode
							AND (ActivityTypeId = @ActivityTypeId OR (ActivityTypeId IS NULL AND @ActivityTypeId IS NULL))
						
							END
						ELSE
							BEGIN
							Insert Into GDM.Gr.PropertyFundMapping 
							(PropertyFundId,SourceCode,PropertyFundCode,InsertedDate,UpdatedDate,IsDeleted,ActivityTypeId)
							Select @PropertyFundId,@CorpMRISource,@MRIDeptCode,getdate(),getdate(),0,@ActivityTypeId

							IF @@error <> 0
								BEGIN
								Select @PropertyFundId,@CorpMRISource,@MRIDeptCode,getdate(),getdate(),0,@ActivityTypeId						
								END
							END
						END
					FETCH NEXT From CC1 INTO @ActvityTypeCode
					END
				CLOSE CC1
				DEALLOCATE CC1
				
				END
			FETCH NEXT From CC INTO @ActvityList, @ReportingEntity, @BillingEntityType, @ReportingRegion
			END
		CLOSE CC
		DEALLOCATE CC


		END
	FETCH NEXT From CC0 INTO @CorpMRISource, @MRIDeptCode
	END
CLOSE CC0
DEALLOCATE CC0

Select DISTINCT * From #Changes


COMMIT TRAN
--rollback tran
