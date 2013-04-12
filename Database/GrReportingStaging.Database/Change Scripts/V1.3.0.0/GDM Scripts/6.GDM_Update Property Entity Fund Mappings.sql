BEGIN TRANSACTION

INSERT INTO [GDM].[Gr].[PropertyFundMapping]
           ([PropertyFundId]
           ,[SourceCode]
           ,[PropertyFundCode]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[IsDeleted]
           ,[ActivityTypeId])
SELECT
	PF.PropertyFundId,
	RTRIM(PFM1.[Corp MRI Source]),
	RTRIM(PFM1.[MRI Dept Code]),
	getdate(),
	getdate(),
	0,
	NULL
FROM
	GDM.dbo.ImportPropertyEntityMapping PFM1
	
	LEFT OUTER JOIN GDM.Gr.PropertyFundMapping PFM2 ON
		PFM2.SourceCode = RTRIM(PFM1.[Corp MRI Source]) AND
		PFM2.PropertyFundCode = RTRIM(PFM1.[MRI Dept Code])
		
	INNER JOIN GDM.dbo.PropertyFund PF ON
		RTRIM(PFM1.[Reporting Entity]) = PF.Name
	
	INNER JOIN GACS.dbo.Entity E ON
		E.EntityRef = RTRIM(PFM1.[MRI Dept Code]) AND
		E.Source = RTRIM(PFM1.[Corp MRI Source])
WHERE
	PFM2.PropertyFundMappingId IS NULL AND
	RTRIM(PFM1.[Corp MRI Source]) <> 'CN'
	
INSERT INTO [GDM].[Gr].[PropertyFundMapping]
           ([PropertyFundId]
           ,[SourceCode]
           ,[PropertyFundCode]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[IsDeleted]
           ,[ActivityTypeId])
SELECT
	PF.PropertyFundId,
	RTRIM(PFM1.[Corp MRI Source]),
	EM.LocalEntityRef,
	getdate(),
	getdate(),
	0,
	NULL
FROM
	GDM.dbo.ImportPropertyEntityMapping PFM1
			
	INNER JOIN GDM.dbo.PropertyFund PF ON
		RTRIM(PFM1.[Reporting Entity]) = PF.Name
		
	INNER JOIN 	GACS.dbo.EntityMapping EM ON
		EM.Source = RTRIM(PFM1.[Corp MRI Source]) AND
		EM.OriginalEntityRef = RTRIM(PFM1.[MRI Dept Code])
	
	INNER JOIN GACS.dbo.Entity E ON
		E.EntityRef = EM.LocalEntityRef AND
		E.Source =  EM.Source
	
	LEFT OUTER JOIN GDM.Gr.PropertyFundMapping PFM2 ON
		PFM2.SourceCode = RTRIM(PFM1.[Corp MRI Source]) AND
		PFM2.PropertyFundCode = EM.LocalEntityRef
	
WHERE
	PFM2.PropertyFundMappingId IS NULL AND
	RTRIM(PFM1.[Corp MRI Source]) = 'CN'	



-- Updates existing mappings to match what is in the spreadsheet
CREATE TABLE #UpdateMappings
(
	PropertyFundMappingId int,
	SpreadsheetReportingEntity nvarchar(255),
	GDMPropertyFundName varchar(100) NULL

)

INSERT INTO #UpdateMappings
SELECT 
	PFM2.PropertyFundMappingId,
	RTRIM(PFM1.[Reporting Entity]) SpreadsheetReportingEntity,
	PF.Name GDMPropertyFundName
FROM 
	GDM.dbo.ImportPropertyEntityMapping PFM1
	
	LEFT OUTER JOIN GACS.dbo.EntityMapping EM ON
		EM.Source = RTRIM(PFM1.[Corp MRI Source]) AND
		EM.OriginalEntityRef = RTRIM(PFM1.[MRI Dept Code])
	
	LEFT OUTER JOIN GDM.Gr.PropertyFundMapping PFM2 ON
		PFM2.SourceCode = RTRIM(PFM1.[Corp MRI Source]) AND
		PFM2.PropertyFundCode = EM.LocalEntityRef
		
	LEFT OUTER JOIN GDM.dbo.PropertyFund PF ON
		PFM2.PropertyFundId = PF.PropertyFundId
		
	LEFT OUTER JOIN GDM.dbo.ProjectRegion PR ON
		PR.ProjectRegionID = PF.ProjectRegionId
		
WHERE
	PFM1.[Corp MRI Source] = 'CN' AND
	(PF.Name <> RTRIM(PFM1.[Reporting Entity])) AND
	RTRIM(PFM1.[Reporting Entity]) <> ''
	


INSERT INTO #UpdateMappings
SELECT 
	PFM2.PropertyFundMappingId,
	RTRIM(PFM1.[Reporting Entity]) SpreadsheetReportingEntity,
	PF.Name GDMPropertyFundName
FROM 
	GDM.dbo.ImportPropertyEntityMapping PFM1
	
	LEFT OUTER JOIN GDM.Gr.PropertyFundMapping PFM2 ON
		PFM2.SourceCode = RTRIM(PFM1.[Corp MRI Source]) AND
		PFM2.PropertyFundCode = RTRIM(PFM1.[MRI Dept Code])
		
	LEFT OUTER JOIN GDM.dbo.PropertyFund PF ON
		PFM2.PropertyFundId = PF.PropertyFundId
		
	LEFT OUTER JOIN GDM.dbo.ProjectRegion PR ON
		PR.ProjectRegionID = PF.ProjectRegionId
WHERE
	PFM1.[Corp MRI Source] <> 'CN' AND
	(PF.Name <> RTRIM(PFM1.[Reporting Entity])) AND
	RTRIM(PFM1.[Reporting Entity]) <> ''
	
UPDATE PFM
SET
	PropertyFundId = PF.PropertyFundId
FROM
	GDM.GR.PropertyFundMapping PFM
	
	INNER JOIN #UpdateMappings M ON
		M.PropertyFundMappingId = PFM.PropertyFundMappingId
	
	LEFT OUTER JOIN GDM.dbo.PropertyFund PF ON
		PF.Name = SpreadsheetReportingEntity

DROP TABLE #UpdateMappings

COMMIT TRANSACTION