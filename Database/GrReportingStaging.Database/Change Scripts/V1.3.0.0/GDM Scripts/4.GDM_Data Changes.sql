IF NOT EXISTS(Select * From Gr.GlobalRegion Where Name = 'EU FUNDS')
	BEGIN
	INSERT INTO [GDM].[Gr].[GlobalRegion]
			   ([RegionCode]
			   ,[Name]
			   ,[ParentGlobalRegionId]
			   ,[IsAllocationRegion]
			   ,[IsOriginatingRegion]
			   ,[InsertedDate]
			   ,[UpdatedDate])
		 Select
			   'EUF'
			   ,'EU FUNDS'
			   ,(Select GlobalRegionId From Gr.GlobalRegion Where Name = 'EUROPE')
			   ,1
			   ,0
			   ,getdate()
			   ,Getdate()
	END

GO


--select * From PropertyFund Where Name like '%1099 NY Avenue (CSREFI)%'
BEGIN  TRAN

Update PropertyFund Set Name ='1 N. Franklin', UpdatedDate = getdate() Where Name = '1 N. Franklin (EOP)'
Update PropertyFund Set Name ='10/30 S. Wacker', UpdatedDate = getdate() Where Name = '10/30 S. Wacker (EOP)'
Update PropertyFund Set Name ='1099 NY Avenue', UpdatedDate = getdate() Where Name = '1099 NY Avenue (Hertz Site)'
Update PropertyFund Set Name ='1099 NY Avenue (CSREFI)', UpdatedDate = getdate() Where Name = '1099 NY Avenue (CSREFI) '
Update PropertyFund Set Name ='1201 F Street', UpdatedDate = getdate() Where Name = '1201 F Street (Carr Portfolio)'
Update PropertyFund Set Name ='1455 Penn Ave', UpdatedDate = getdate() Where Name = '1455 Penn Ave (Willard Hotel)'
Update PropertyFund Set Name ='161 N. Clark', UpdatedDate = getdate() Where Name = '161 N. Clark (EOP)'
Update PropertyFund Set Name ='1717 Penn Ave', UpdatedDate = getdate() Where Name = '1717 Penn Ave (Carr Portfolio)'
Update PropertyFund Set Name ='1730 Penn Ave', UpdatedDate = getdate() Where Name = '1730 Penn Ave (Carr Portfolio)'
Update PropertyFund Set Name ='1747 Penn Ave', UpdatedDate = getdate() Where Name = '1747 Penn Ave (Carr Portfolio)'
Update PropertyFund Set Name ='1750 H Street', UpdatedDate = getdate() Where Name = '1750 H Street (Carr Portfolio)'
Update PropertyFund Set Name ='1775 Penn Ave', UpdatedDate = getdate() Where Name = '1775 Penn Ave (Carr Portfolio)'
Update PropertyFund Set Name ='1919 Penn Ave', UpdatedDate = getdate() Where Name = '1919 Penn Ave (Carr Portfolio)'
Update PropertyFund Set Name ='200 Park', UpdatedDate = getdate() Where Name = '200 Park (Metlife)'
Update PropertyFund Set Name ='200 Park Corporate Entity', UpdatedDate = getdate() Where Name = '200 Park-Corp Entity'
Update PropertyFund Set Name ='2025 M Street', UpdatedDate = getdate() Where Name = '2025 M Street (Carr Portfolio)'
Update PropertyFund Set Name ='2100 Penn Ave', UpdatedDate = getdate() Where Name = '2100 Penn Ave (Carr Porfolio)'
Update PropertyFund Set Name ='30 N. LaSalle', UpdatedDate = getdate() Where Name = '30 N. LaSalle (EOP)'
Update PropertyFund Set Name ='300 Spear', UpdatedDate = getdate() Where Name = '300 Spear (Infinity)'
Update PropertyFund Set Name ='520 Pike', UpdatedDate = getdate() Where Name = '520 Pike Tower'
Update PropertyFund Set Name ='740 15th Street', UpdatedDate = getdate() Where Name = '740 15th Street (Carr Portfolio)'
Update PropertyFund Set Name ='Assoc of Otolaryngology', UpdatedDate = getdate() Where Name = 'American Assoc of Otolaryngology (Carr Portfolio)'
Update PropertyFund Set Name ='AT&T-Corporate Entity', UpdatedDate = getdate() Where Name = 'AT&T-Corp Entity'
Update PropertyFund Set Name ='Bala Complex', UpdatedDate = getdate() Where Name = 'Bala Plaza Complex'
Update PropertyFund Set Name ='BEA Site', UpdatedDate = getdate() Where Name = 'Campus at North First Street (BEA)'
Update PropertyFund Set Name ='Brazil Fund I_Fund GP', UpdatedDate = getdate() Where Name = 'Brazil Fund I GP'
Update PropertyFund Set Name ='Brazil Fund II_Fund GP', UpdatedDate = getdate() Where Name = 'Brazil Fund II GP'
Update PropertyFund Set Name ='Brazil Fund III_Fund GP', UpdatedDate = getdate() Where Name = 'Brazil Fund III GP'
Update PropertyFund Set Name ='Canal Center', UpdatedDate = getdate() Where Name = 'Canal Center (Carr Portfolio)'
Update PropertyFund Set Name ='Central Park of Lisle', UpdatedDate = getdate() Where Name = 'Central Park of Lisle complex'
Update PropertyFund Set Name ='Centrium', UpdatedDate = getdate() Where Name = 'Centrium (St Cathrine House/Pegasus)'
Update PropertyFund Set Name ='China Fund I_Fund GP', UpdatedDate = getdate() Where Name = 'China Fund I GP'
Update PropertyFund Set Name ='Civic Opera House', UpdatedDate = getdate() Where Name = 'Civic Opera House (20 N. Wacker) (EOP)'
Update PropertyFund Set Name ='Commercial Bank', UpdatedDate = getdate() Where Name = 'Commercial Bank (Carr Portfolio)'
Update PropertyFund Set Name ='Commonwealth Tower', UpdatedDate = getdate() Where Name = 'Commonwealth Tower (Carr Portfolio)'
Update PropertyFund Set Name ='Dublin Corp Center', UpdatedDate = getdate() Where Name = 'Dublin Corporate Center complex'
Update PropertyFund Set Name ='ESOF_Fund GP', UpdatedDate = getdate() Where Name = 'ESOF GP'
Update PropertyFund Set Name ='Floyd D Akers', UpdatedDate = getdate() Where Name = 'Floyd D Akers (Carr Portfolio)'
Update PropertyFund Set Name ='Friedrichstrasse 191', UpdatedDate = getdate() Where Name = 'Friedrichstrasse 191 (Q108)'
Update PropertyFund Set Name ='Friedrichstrasse 205', UpdatedDate = getdate() Where Name = 'Friedrichstrasse 205 (Q205)'
Update PropertyFund Set Name ='Fund I_Fund GP', UpdatedDate = getdate() Where Name = 'Fund I GP'
Update PropertyFund Set Name ='Fund III_Fund GP', UpdatedDate = getdate() Where Name = 'Fund III GP'
Update PropertyFund Set Name ='Fund IV_Fund GP', UpdatedDate = getdate() Where Name = 'Fund IV GP'
Update PropertyFund Set Name ='Fund V Int''l_Fund GP', UpdatedDate = getdate() Where Name = 'Fund V Int''l GP'
Update PropertyFund Set Name ='Fund V US_Fund GP', UpdatedDate = getdate() Where Name = 'Fund V US GP'
Update PropertyFund Set Name ='Fund VI_Fund GP', UpdatedDate = getdate() Where Name = 'Fund VI GP'
Update PropertyFund Set Name ='Fund VII_Fund GP', UpdatedDate = getdate() Where Name = 'Fund VII GP'
Update PropertyFund Set Name ='Fund VIII_Fund GP', UpdatedDate = getdate() Where Name = 'Fund VIII GP'
Update PropertyFund Set Name ='GAC', UpdatedDate = getdate() Where Name = 'Greenwich America Center'
Update PropertyFund Set Name ='GAP Building', UpdatedDate = getdate() Where Name = 'GAP Building (550 Terry Francois)'
Update PropertyFund Set Name ='Gruneburgweg (WC)', UpdatedDate = getdate() Where Name = 'Gruneburgweg (Westend Carree)'
Update PropertyFund Set Name ='Hamburg HTC', UpdatedDate = getdate() Where Name = 'Hamburg HTC (Harbour Holdings)'
Update PropertyFund Set Name ='Im Trutz 55 (WC)', UpdatedDate = getdate() Where Name = 'Im Trutz 55 (Westend Carree)'
Update PropertyFund Set Name ='India Fund I_Fund GP', UpdatedDate = getdate() Where Name = 'India Fund I GP'
Update PropertyFund Set Name ='India Fund II_Fund GP', UpdatedDate = getdate() Where Name = 'India Fund II GP'
Update PropertyFund Set Name ='Lumiere', UpdatedDate = getdate() Where Name = 'Lumiere '
Update PropertyFund Set Name ='Maple Plaza', UpdatedDate = getdate() Where Name = 'Maple Plaza '
Update PropertyFund Set Name ='NCUA Building', UpdatedDate = getdate() Where Name = 'NCUA Building (Carr Portfolio)'
Update PropertyFund Set Name ='Newseum Development', UpdatedDate = getdate() Where Name = 'Newseum Development (Carr Portfolio)'
Update PropertyFund Set Name ='Olympic Tower', UpdatedDate = getdate() Where Name = 'Olympic Tower (645 Fifth Ave)'
Update PropertyFund Set Name ='Park Place', UpdatedDate = getdate() Where Name = 'Park Place - Corp Entity'
Update PropertyFund Set Name ='PCVST', UpdatedDate = getdate() Where Name = 'Peter Cooper Village/Stuy Town'
Update PropertyFund Set Name ='Presidential Plaza', UpdatedDate = getdate() Where Name = 'Presidente Vargas'
Update PropertyFund Set Name ='Regents University', UpdatedDate = getdate() Where Name = 'Regents University (Carr Portfolio)'
Update PropertyFund Set Name ='Rio', UpdatedDate = getdate() Where Name = 'Rio (Ventura Towers)'
Update PropertyFund Set Name ='Rio_Phase II', UpdatedDate = getdate() Where Name = 'Rio (Ventura Towers)_Phase II'
Update PropertyFund Set Name ='Rock Spring I', UpdatedDate = getdate() Where Name = 'Rock Spring I (Carr Portfolio)'
Update PropertyFund Set Name ='Rotebuhlplatz', UpdatedDate = getdate() Where Name = 'Rotebuhlplatz 23/25'
Update PropertyFund Set Name ='Second & Seneca', UpdatedDate = getdate() Where Name = 'Second & Seneca (Seattle)'
Update PropertyFund Set Name ='Stafford Place II', UpdatedDate = getdate() Where Name = 'Stafford Place I (Carr Portfolio)'
Update PropertyFund Set Name ='Summit I', UpdatedDate = getdate() Where Name = 'Summit I (Carr Portfolio)'
Update PropertyFund Set Name ='Tellapur (H400)', UpdatedDate = getdate() Where Name = 'Tellapur (Hyderabad 400 acres)'
Update PropertyFund Set Name ='Terrell Place', UpdatedDate = getdate() Where Name = 'Terrell Place (Carr Portfolio)'
Update PropertyFund Set Name ='Transpotomac Plaza', UpdatedDate = getdate() Where Name = 'Transpotomac Plaza (Carr Portfolio)'
Update PropertyFund Set Name ='TSCE', UpdatedDate = getdate() Where Name = 'TS Crown Entities'
Update PropertyFund Set Name ='TSCE - China RMB Fund', UpdatedDate = getdate() Where Name = 'China RMB Fund'
Update PropertyFund Set Name ='TSEC_Fund GP', UpdatedDate = getdate() Where Name = 'TSEC GP'
Update PropertyFund Set Name ='TSEV Fund II_Fund GP', UpdatedDate = getdate() Where Name = 'TSEV Fund II GP'
Update PropertyFund Set Name ='TSEV_Fund GP', UpdatedDate = getdate() Where Name = 'TSEV GP'
Update PropertyFund Set Name ='TSP Corp', UpdatedDate = getdate() Where Name = 'TSP Corporate'
Update PropertyFund Set Name ='TSRES', UpdatedDate = getdate() Where Name = 'TS Real Estate Services LLC'
Update PropertyFund Set Name ='Waverock (H12)', UpdatedDate = getdate() Where Name = 'Waverock (Hyderabad 12 acres)'
Update PropertyFund Set Name ='Westbridge', UpdatedDate = getdate() Where Name = 'Westbridge (2550 M St) (Carr Portfolio)'
Update PropertyFund Set Name ='Woodland Park Property', UpdatedDate = getdate() Where Name = 'Woodland Park'
Update PropertyFund Set Name ='World Bank', UpdatedDate = getdate() Where Name = 'World Bank (Carr Portfolio)'
Update PropertyFund Set Name ='WPPOA', UpdatedDate = getdate() Where Name = 'Woodland Park Property Owners Association'


--Change Request 1

Update PropertyFund Set Name = 'Presidente Vargas', UpdatedDate = getdate() Where Name = 'Presidential Plaza'
Update PropertyFund Set Name = 'Presidential Plaza' , UpdatedDate = getdate() Where Name =  'Presidential Plaza (Carr Portfolio)'

--Change Request 2

Update PropertyFund Set Name = 'Park Place - Corp Entity', UpdatedDate = getdate() Where Name = 'Park Place'
Update PropertyFund Set Name = 'Park Place', UpdatedDate = getdate() Where Name = 'Park Place (Carr Portfolio)'

--COMMIT TRAN
--ROLLBACK TRAN

--Up to here on TEST&DEV 2010-04-27

--ProjectRegion Name changes

Update ProjectRegion Set Name = 'EU Funds' Where Name = 'EU Funds (US Cost)'
Update ProjectRegion Set Name = 'Virginia/DC' Where Name = 'Virginia-DC'
Update ProjectRegion Set Name = 'Southern California' Where Name = 'Los Angeles'

--BEGIN TRAN
INSERT INTO [GDM].[Gr].[AllocationRegionMapping]
           ([GlobalRegionId]
           ,[SourceCode]
           ,[RegionCode]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[IsDeleted])
     SELECT
           (SELECT GlobalRegionId FROM GR.GlobalRegion WHERE RegionCode = 'EUF')
           ,'UC'
           ,13
           ,getdate()
           ,getdate()
           ,0

IF NOT EXISTS (SELECT * FROM [GDM].[dbo].[PropertyFund] WHERE Name = 'Project Motorcycle_Fund GP')
BEGIN

	INSERT INTO [GDM].[dbo].[PropertyFund]
			   ([RelatedFundId]
			   ,[EntityTypeId]
			   ,[ProjectRegionId]
			   ,[Name]
			   ,[InsertedDate]
			   ,[UpdatedDate]
			   ,[UpdatedByStaffId]
			   ,[IsReportingEntity]
			   ,[IsPropertyFund])
	SELECT
		NULL,
		ET.EntityTypeId,
		PR.ProjectRegionID,
		'Project Motorcycle_Fund GP',
		getdate(),
		getdate(),
		-1,
		1,
		0
	FROM
		GDM.dbo.EntityType ET
		
		INNER JOIN GDM.dbo.ProjectRegion PR ON
			PR.Name = 'US Funds'
			
	WHERE
		ET.Name = 'Fund'

END


IF (SELECT PR.Name FROM dbo.PropertyFund PF INNER JOIN dbo.ProjectRegion PR ON PR.ProjectRegionId = PF.ProjectRegionId WHERE PF.Name = 'Fund I Extension') <> 'US Funds'
BEGIN	

	UPDATE  GDM.dbo.PropertyFund
	SET
		ProjectRegionId = PR.ProjectRegionId
	FROM
		GDM.dbo.ProjectRegion PR
	WHERE
		PropertyFund.Name = 'Fund I Extension' AND
		PR.Name = 'US Funds'

END

--ROLLBACK TRAN
COMMIT TRAN
