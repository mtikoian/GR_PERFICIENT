/*
Select * From ActivityType
Where ActivityType NOT IN (Select ActivityTypeName From [REPORTING-DW].GrReporting.dbo.ActivityType)
AND ActivityType <> 'All'

Select * From AllocationRegion
Where AllocationRegion NOT IN (Select SubRegionName From [REPORTING-DW].GrReporting.dbo.AllocationRegion)
AND AllocationRegion <> 'All'

Select * From Entity 
Where Entity NOT IN (Select PropertyFundName From [REPORTING-DW].GrReporting.dbo.PropertyFund)
AND Entity <> 'All'

Select * From FunctionalDepartment
Where FunctionalDepartment NOT IN (Select FunctionalDepartmentName From [REPORTING-DW].GrReporting.dbo.FunctionalDepartment)
AND FunctionalDepartment <> 'All'

Select * From OriginatingRegion
Where RegionName NOT IN (Select SubRegionName From [REPORTING-DW].GrReporting.dbo.OriginatingRegion)
AND RegionName <> 'All'

Select * From [REPORTING-DW].GrReporting.dbo.OriginatingRegion
*/

BEGIN TRAN


Update OriginatingRegion 
Set RegionName = 'PCVST', RegionCode = 'PCV' 
Where RegionName = 'PCV/ST'

Update OriginatingRegion 
Set RegionName = 'BEIJING', RegionCode = 'CNB' 
Where RegionName = 'TS REC (Chengdu)'

Update OriginatingRegion 
Set RegionName = 'CHENGDU', RegionCode = 'CNC' 
Where RegionName = 'TS REC (Beijing)'

Update OriginatingRegion 
Set RegionName = 'SHANGHAI', RegionCode = 'CNS' 
Where RegionName = 'TS REC (Shanghai)'

Update OriginatingRegion 
Set RegionName = 'TIANJIN', RegionCode = 'CNT' 
Where RegionName = 'TS REC (Tianjin)'

UPDATE OriginatingRegion
SET [RegionName] = 'INDIA'
WHERE [RegionName] = 'TSP INDIA'

UPDATE OriginatingRegion
SET [RegionName] = 'VIRGINIA/DC'
WHERE [RegionName] = 'VA/DC'


Update SavedOriginatingRegionParameter 
Set OriginatingRegion = 'PCVST'
Where OriginatingRegion = 'PCV/ST'

Update SavedOriginatingRegionParameter 
Set OriginatingRegion = 'CHENGDU'
Where OriginatingRegion = 'TS REC (Chengdu)'

Update SavedOriginatingRegionParameter 
Set OriginatingRegion = 'BEIJING'
Where OriginatingRegion = 'TS REC (Beijing)'

Update SavedOriginatingRegionParameter 
Set OriginatingRegion = 'SHANGHAI'
Where OriginatingRegion = 'TS REC (Shanghai)'

Update SavedOriginatingRegionParameter 
Set OriginatingRegion = 'TIANJIN'
Where OriginatingRegion = 'TS REC (Tianjin)'

UPDATE SavedOriginatingRegionParameter
SET [OriginatingRegion] = 'INDIA'
WHERE [OriginatingRegion] = 'TSP INDIA'

UPDATE SavedOriginatingRegionParameter
SET [OriginatingRegion] = 'VIRGINIA/DC'
WHERE [OriginatingRegion] = 'VA/DC'

UPDATE SO1
SET [OriginatingRegion] = 'ATLANTA'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'ATLANTA'		
WHERE 
	SO1.[OriginatingRegion] = 'FLORIDA' AND
	SO2.ReportId IS NULL

UPDATE SO1
SET [OriginatingRegion] = 'NEW YORK'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'NEW YORK'		
WHERE 
	SO1.[OriginatingRegion] = 'MPACT STUDIO' AND
	SO2.ReportId IS NULL


UPDATE SO1
SET [OriginatingRegion] = 'NORTHERN CALIFORNIA'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'NORTHERN CALIFORNIA'		
WHERE 
	SO1.[OriginatingRegion] = 'SEATTLE' AND
	SO2.ReportId IS NULL
	

UPDATE SO1
SET [OriginatingRegion] = 'UNITED KINGDOM'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'UNITED KINGDOM'		
WHERE 
	SO1.[OriginatingRegion] = 'SPAIN' AND
	SO2.ReportId IS NULL


UPDATE SO1
SET [OriginatingRegion] = 'FRANCE'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'FRANCE'		
WHERE 
	SO1.[OriginatingRegion] = 'TS Mgmt (OPCI)' AND
	SO2.ReportId IS NULL

UPDATE SO1
SET [OriginatingRegion] = 'UNITED KINGDOM'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'UNITED KINGDOM'		
WHERE 
	SO1.[OriginatingRegion] = 'TSP ITALY' AND
	SO2.ReportId IS NULL

UPDATE SO1
SET [OriginatingRegion] = 'NEW YORK'
FROM
	SavedOriginatingRegionParameter SO1 	
	LEFT OUTER JOIN SavedOriginatingRegionParameter SO2 ON
		SO1.ReportId = SO2.ReportId AND
		SO2.OriginatingRegion = 'NEW YORK'		
WHERE 
	SO1.[OriginatingRegion] = 'US CORPORATE' AND
	SO2.ReportId IS NULL

DELETE FROM SavedOriginatingRegionParameter
  WHERE OriginatingRegion IN ('FLORIDA', 'US CORPORATE', 'TSP ITALY', 'TS Mgmt (OPCI)','SPAIN',
  'SEATTLE', 'MPACT STUDIO')

Update Entity Set Entity ='1 N. Franklin' Where Entity = '1 N. Franklin (EOP)'
Update Entity Set Entity ='10/30 S. Wacker' Where Entity = '10/30 S. Wacker (EOP)'
Update Entity Set Entity ='1099 NY Avenue' Where Entity = '1099 NY Avenue (Hertz Site)'
Update Entity Set Entity ='1099 NY Avenue (CSREFI)' Where Entity = '1099 NY Avenue (CSREFI) '
Update Entity Set Entity ='1201 F Street' Where Entity = '1201 F Street (Carr Portfolio)'
Update Entity Set Entity ='1455 Penn Ave' Where Entity = '1455 Penn Ave (Willard Hotel)'
Update Entity Set Entity ='161 N. Clark' Where Entity = '161 N. Clark (EOP)'
Update Entity Set Entity ='1717 Penn Ave' Where Entity = '1717 Penn Ave (Carr Portfolio)'
Update Entity Set Entity ='1730 Penn Ave' Where Entity = '1730 Penn Ave (Carr Portfolio)'
Update Entity Set Entity ='1747 Penn Ave' Where Entity = '1747 Penn Ave (Carr Portfolio)'
Update Entity Set Entity ='1750 H Street' Where Entity = '1750 H Street (Carr Portfolio)'
Update Entity Set Entity ='1775 Penn Ave' Where Entity = '1775 Penn Ave (Carr Portfolio)'
Update Entity Set Entity ='1919 Penn Ave' Where Entity = '1919 Penn Ave (Carr Portfolio)'
Update Entity Set Entity ='200 Park' Where Entity = '200 Park (Metlife)'
Update Entity Set Entity ='200 Park Corporate Entity' Where Entity = '200 Park-Corp Entity'
Update Entity Set Entity ='2025 M Street' Where Entity = '2025 M Street (Carr Portfolio)'
Update Entity Set Entity ='2100 Penn Ave' Where Entity = '2100 Penn Ave (Carr Porfolio)'
Update Entity Set Entity ='30 N. LaSalle' Where Entity = '30 N. LaSalle (EOP)'
Update Entity Set Entity ='300 Spear' Where Entity = '300 Spear (Infinity)'
Update Entity Set Entity ='520 Pike' Where Entity = '520 Pike Tower'
Update Entity Set Entity ='740 15th Street' Where Entity = '740 15th Street (Carr Portfolio)'
Update Entity Set Entity ='Assoc of Otolaryngology' Where Entity = 'American Assoc of Otolaryngology (Carr Portfolio)'
Update Entity Set Entity ='AT&T-Corporate Entity' Where Entity = 'AT&T-Corp Entity'
Update Entity Set Entity ='Bala Complex' Where Entity = 'Bala Plaza Complex'
Update Entity Set Entity ='BEA Site' Where Entity = 'Campus at North First Street (BEA)'
Update Entity Set Entity ='Brazil Fund I_Fund GP' Where Entity = 'Brazil Fund I GP'
Update Entity Set Entity ='Brazil Fund II_Fund GP' Where Entity = 'Brazil Fund II GP'
Update Entity Set Entity ='Brazil Fund III_Fund GP' Where Entity = 'Brazil Fund III GP'
Update Entity Set Entity ='Canal Center' Where Entity = 'Canal Center (Carr Portfolio)'
Update Entity Set Entity ='Central Park of Lisle' Where Entity = 'Central Park of Lisle complex'
Update Entity Set Entity ='Centrium' Where Entity = 'Centrium (St Cathrine House/Pegasus)'
Update Entity Set Entity ='China Fund I_Fund GP' Where Entity = 'China Fund I GP'
Update Entity Set Entity ='Civic Opera House' Where Entity = 'Civic Opera House (20 N. Wacker) (EOP)'
Update Entity Set Entity ='Commercial Bank' Where Entity = 'Commercial Bank (Carr Portfolio)'
Update Entity Set Entity ='Commonwealth Tower' Where Entity = 'Commonwealth Tower (Carr Portfolio)'
Update Entity Set Entity ='Dublin Corp Center' Where Entity = 'Dublin Corporate Center complex'
Update Entity Set Entity ='ESOF_Fund GP' Where Entity = 'ESOF GP'
Update Entity Set Entity ='Floyd D Akers' Where Entity = 'Floyd D Akers (Carr Portfolio)'
Update Entity Set Entity ='Friedrichstrasse 191' Where Entity = 'Friedrichstrasse 191 (Q108)'
Update Entity Set Entity ='Friedrichstrasse 205' Where Entity = 'Friedrichstrasse 205 (Q205)'
Update Entity Set Entity ='Fund I_Fund GP' Where Entity = 'Fund I GP'
Update Entity Set Entity ='Fund III_Fund GP' Where Entity = 'Fund III GP'
Update Entity Set Entity ='Fund IV_Fund GP' Where Entity = 'Fund IV GP'
Update Entity Set Entity ='Fund V Int''l_Fund GP' Where Entity = 'Fund V Int''l GP'
Update Entity Set Entity ='Fund V US_Fund GP' Where Entity = 'Fund V US GP'
Update Entity Set Entity ='Fund VI_Fund GP' Where Entity = 'Fund VI GP'
Update Entity Set Entity ='Fund VII_Fund GP' Where Entity = 'Fund VII GP'
Update Entity Set Entity ='Fund VIII_Fund GP' Where Entity = 'Fund VIII GP'
Update Entity Set Entity ='GAC' Where Entity = 'Greenwich America Center'
Update Entity Set Entity ='GAP Building' Where Entity = 'GAP Building (550 Terry Francois)'
Update Entity Set Entity ='Gruneburgweg (WC)' Where Entity = 'Gruneburgweg (Westend Carree)'
Update Entity Set Entity ='Hamburg HTC' Where Entity = 'Hamburg HTC (Harbour Holdings)'
Update Entity Set Entity ='Im Trutz 55 (WC)' Where Entity = 'Im Trutz 55 (Westend Carree)'
Update Entity Set Entity ='India Fund I_Fund GP' Where Entity = 'India Fund I GP'
Update Entity Set Entity ='India Fund II_Fund GP' Where Entity = 'India Fund II GP'
Update Entity Set Entity ='LB Immo Investments' Where Entity = 'LB Immo Investment'
Update Entity Set Entity ='Lumiere' Where Entity = 'Lumiere '
Update Entity Set Entity ='Maple Plaza' Where Entity = 'Maple Plaza '
Update Entity Set Entity ='NCUA Building' Where Entity = 'NCUA Building (Carr Portfolio)'
Update Entity Set Entity ='Newseum Development' Where Entity = 'Newseum Development (Carr Portfolio)'
Update Entity Set Entity ='Olympic Tower' Where Entity = 'Olympic Tower (645 Fifth Ave)'
Update Entity Set Entity ='Park Place' Where Entity = 'Park Place - Corp Entity'
Update Entity Set Entity ='PCVST' Where Entity = 'Peter Cooper Village/Stuy Town'
Update Entity Set Entity ='Presidential Plaza' Where Entity = 'Presidente Vargas'
Update Entity Set Entity ='Regents University' Where Entity = 'Regents University (Carr Portfolio)'
Update Entity Set Entity ='Rio' Where Entity = 'Rio (Ventura Towers)'
Update Entity Set Entity ='Rio_Phase II' Where Entity = 'Rio (Ventura Towers)_Phase II'
Update Entity Set Entity ='Rock Spring I' Where Entity = 'Rock Spring I (Carr Portfolio)'
Update Entity Set Entity ='Rotebuhlplatz' Where Entity = 'Rotebuhlplatz 23/25'
Update Entity Set Entity ='Second & Seneca' Where Entity = 'Second & Seneca (Seattle)'
Update Entity Set Entity ='Stafford Place II' Where Entity = 'Stafford Place I (Carr Portfolio)'
Update Entity Set Entity ='Summit I' Where Entity = 'Summit I (Carr Portfolio)'
Update Entity Set Entity ='Terrell Place' Where Entity = 'Terrell Place (Carr Portfolio)'
Update Entity Set Entity ='Transpotomac Plaza' Where Entity = 'Transpotomac Plaza (Carr Portfolio)'
Update Entity Set Entity ='TSCE' Where Entity = 'TS Crown Entities'
Update Entity Set Entity ='TSCE - China RMB Fund' Where Entity = 'China RMB Fund'
Update Entity Set Entity ='TSEC_Fund GP' Where Entity = 'TSEC GP'
Update Entity Set Entity ='TSEV Fund II_Fund GP' Where Entity = 'TSEV Fund II GP'
Update Entity Set Entity ='TSEV_Fund GP' Where Entity = 'TSEV GP'
Update Entity Set Entity ='TSP Boston JV' Where Entity = 'TSP Boston'
Update Entity Set Entity ='TSP Corp' Where Entity = 'TSP Corporate'
Update Entity Set Entity ='TSRES' Where Entity = 'TS Real Estate Services LLC'
Update Entity Set Entity ='Waverock (H12)' Where Entity = 'Waverock (Hyderabad 12 acres)'
Update Entity Set Entity ='Westbridge' Where Entity = 'Westbridge (2550 M St) (Carr Portfolio)'
Update Entity Set Entity ='Woodland Park Property' Where Entity = 'Woodland Park'
Update Entity Set Entity ='World Bank' Where Entity = 'World Bank (Carr Portfolio)'
Update Entity Set Entity ='WPPOA' Where Entity = 'Woodland Park Property Owners Association'


--Change Request 1
Update Entity Set Entity = 'Presidente Vargas' Where Entity = 'Presidential Plaza'
Update Entity Set Entity = 'Presidential Plaza'  Where Entity =  'Presidential Plaza (Carr Portfolio)'

--Change Request 2
Update Entity Set Entity = 'Park Place - Corp Entity' Where Entity = 'Park Place'
Update Entity Set Entity = 'Park Place' Where Entity = 'Park Place (Carr Portfolio)'


--ProjectRegion Name changes

Update AllocationRegion Set AllocationRegion = 'EU Funds' Where AllocationRegion = 'EU Funds (US Cost)'
Update AllocationRegion Set AllocationRegion = 'Virginia/DC' Where AllocationRegion = 'Virginia-DC'
Update AllocationRegion Set AllocationRegion = 'Southern California' Where AllocationRegion = 'Los Angeles'
Update AllocationRegion Set AllocationRegion = 'INDIA' Where AllocationRegion = 'TSP India'
Update AllocationRegion Set AllocationRegion = 'VIRGINIA/DC' Where AllocationRegion = 'VA/DC'


Update SavedEntityParameter Set EntityParameter ='1 N. Franklin' Where EntityParameter = '1 N. Franklin (EOP)'
Update SavedEntityParameter Set EntityParameter ='10/30 S. Wacker' Where EntityParameter = '10/30 S. Wacker (EOP)'
Update SavedEntityParameter Set EntityParameter ='1099 NY Avenue' Where EntityParameter = '1099 NY Avenue (Hertz Site)'
Update SavedEntityParameter Set EntityParameter ='1099 NY Avenue (CSREFI)' Where EntityParameter = '1099 NY Avenue (CSREFI) '
Update SavedEntityParameter Set EntityParameter ='1201 F Street' Where EntityParameter = '1201 F Street (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='1455 Penn Ave' Where EntityParameter = '1455 Penn Ave (Willard Hotel)'
Update SavedEntityParameter Set EntityParameter ='161 N. Clark' Where EntityParameter = '161 N. Clark (EOP)'
Update SavedEntityParameter Set EntityParameter ='1717 Penn Ave' Where EntityParameter = '1717 Penn Ave (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='1730 Penn Ave' Where EntityParameter = '1730 Penn Ave (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='1747 Penn Ave' Where EntityParameter = '1747 Penn Ave (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='1750 H Street' Where EntityParameter = '1750 H Street (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='1775 Penn Ave' Where EntityParameter = '1775 Penn Ave (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='1919 Penn Ave' Where EntityParameter = '1919 Penn Ave (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='200 Park' Where EntityParameter = '200 Park (Metlife)'
Update SavedEntityParameter Set EntityParameter ='200 Park Corporate Entity' Where EntityParameter = '200 Park-Corp Entity'
Update SavedEntityParameter Set EntityParameter ='2025 M Street' Where EntityParameter = '2025 M Street (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='2100 Penn Ave' Where EntityParameter = '2100 Penn Ave (Carr Porfolio)'
Update SavedEntityParameter Set EntityParameter ='30 N. LaSalle' Where EntityParameter = '30 N. LaSalle (EOP)'
Update SavedEntityParameter Set EntityParameter ='300 Spear' Where EntityParameter = '300 Spear (Infinity)'
Update SavedEntityParameter Set EntityParameter ='520 Pike' Where EntityParameter = '520 Pike Tower'
Update SavedEntityParameter Set EntityParameter ='740 15th Street' Where EntityParameter = '740 15th Street (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Assoc of Otolaryngology' Where EntityParameter = 'American Assoc of Otolaryngology (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='AT&T-Corporate Entity' Where EntityParameter = 'AT&T-Corp Entity'
Update SavedEntityParameter Set EntityParameter ='Bala Complex' Where EntityParameter = 'Bala Plaza Complex'
Update SavedEntityParameter Set EntityParameter ='BEA Site' Where EntityParameter = 'Campus at North First Street (BEA)'
Update SavedEntityParameter Set EntityParameter ='Brazil Fund I_Fund GP' Where EntityParameter = 'Brazil Fund I GP'
Update SavedEntityParameter Set EntityParameter ='Brazil Fund II_Fund GP' Where EntityParameter = 'Brazil Fund II GP'
Update SavedEntityParameter Set EntityParameter ='Brazil Fund III_Fund GP' Where EntityParameter = 'Brazil Fund III GP'
Update SavedEntityParameter Set EntityParameter ='Canal Center' Where EntityParameter = 'Canal Center (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Central Park of Lisle' Where EntityParameter = 'Central Park of Lisle complex'
Update SavedEntityParameter Set EntityParameter ='Centrium' Where EntityParameter = 'Centrium (St Cathrine House/Pegasus)'
Update SavedEntityParameter Set EntityParameter ='China Fund I_Fund GP' Where EntityParameter = 'China Fund I GP'
Update SavedEntityParameter Set EntityParameter ='Civic Opera House' Where EntityParameter = 'Civic Opera House (20 N. Wacker) (EOP)'
Update SavedEntityParameter Set EntityParameter ='Commercial Bank' Where EntityParameter = 'Commercial Bank (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Commonwealth Tower' Where EntityParameter = 'Commonwealth Tower (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Dublin Corp Center' Where EntityParameter = 'Dublin Corporate Center complex'
Update SavedEntityParameter Set EntityParameter ='ESOF_Fund GP' Where EntityParameter = 'ESOF GP'
Update SavedEntityParameter Set EntityParameter ='Floyd D Akers' Where EntityParameter = 'Floyd D Akers (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Friedrichstrasse 191' Where EntityParameter = 'Friedrichstrasse 191 (Q108)'
Update SavedEntityParameter Set EntityParameter ='Friedrichstrasse 205' Where EntityParameter = 'Friedrichstrasse 205 (Q205)'
Update SavedEntityParameter Set EntityParameter ='Fund I_Fund GP' Where EntityParameter = 'Fund I GP'
Update SavedEntityParameter Set EntityParameter ='Fund III_Fund GP' Where EntityParameter = 'Fund III GP'
Update SavedEntityParameter Set EntityParameter ='Fund IV_Fund GP' Where EntityParameter = 'Fund IV GP'
Update SavedEntityParameter Set EntityParameter ='Fund V Int''l_Fund GP' Where EntityParameter = 'Fund V Int''l GP'
Update SavedEntityParameter Set EntityParameter ='Fund V US_Fund GP' Where EntityParameter = 'Fund V US GP'
Update SavedEntityParameter Set EntityParameter ='Fund VI_Fund GP' Where EntityParameter = 'Fund VI GP'
Update SavedEntityParameter Set EntityParameter ='Fund VII_Fund GP' Where EntityParameter = 'Fund VII GP'
Update SavedEntityParameter Set EntityParameter ='Fund VIII_Fund GP' Where EntityParameter = 'Fund VIII GP'
Update SavedEntityParameter Set EntityParameter ='GAC' Where EntityParameter = 'Greenwich America Center'
Update SavedEntityParameter Set EntityParameter ='GAP Building' Where EntityParameter = 'GAP Building (550 Terry Francois)'
Update SavedEntityParameter Set EntityParameter ='Gruneburgweg (WC)' Where EntityParameter = 'Gruneburgweg (Westend Carree)'
Update SavedEntityParameter Set EntityParameter ='Hamburg HTC' Where EntityParameter = 'Hamburg HTC (Harbour Holdings)'
Update SavedEntityParameter Set EntityParameter ='Im Trutz 55 (WC)' Where EntityParameter = 'Im Trutz 55 (Westend Carree)'
Update SavedEntityParameter Set EntityParameter ='India Fund I_Fund GP' Where EntityParameter = 'India Fund I GP'
Update SavedEntityParameter Set EntityParameter ='India Fund II_Fund GP' Where EntityParameter = 'India Fund II GP'
Update SavedEntityParameter Set EntityParameter ='LB Immo Investments' Where EntityParameter = 'LB Immo Investment'
Update SavedEntityParameter Set EntityParameter ='Lumiere' Where EntityParameter = 'Lumiere '
Update SavedEntityParameter Set EntityParameter ='Maple Plaza' Where EntityParameter = 'Maple Plaza '
Update SavedEntityParameter Set EntityParameter ='NCUA Building' Where EntityParameter = 'NCUA Building (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Newseum Development' Where EntityParameter = 'Newseum Development (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Olympic Tower' Where EntityParameter = 'Olympic Tower (645 Fifth Ave)'
Update SavedEntityParameter Set EntityParameter ='Park Place' Where EntityParameter = 'Park Place - Corp Entity'
Update SavedEntityParameter Set EntityParameter ='PCVST' Where EntityParameter = 'Peter Cooper Village/Stuy Town'
Update SavedEntityParameter Set EntityParameter ='Presidential Plaza' Where EntityParameter = 'Presidente Vargas'
Update SavedEntityParameter Set EntityParameter ='Regents University' Where EntityParameter = 'Regents University (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Rio' Where EntityParameter = 'Rio (Ventura Towers)'
Update SavedEntityParameter Set EntityParameter ='Rio_Phase II' Where EntityParameter = 'Rio (Ventura Towers)_Phase II'
Update SavedEntityParameter Set EntityParameter ='Rock Spring I' Where EntityParameter = 'Rock Spring I (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Rotebuhlplatz' Where EntityParameter = 'Rotebuhlplatz 23/25'
Update SavedEntityParameter Set EntityParameter ='Second & Seneca' Where EntityParameter = 'Second & Seneca (Seattle)'
Update SavedEntityParameter Set EntityParameter ='Stafford Place II' Where EntityParameter = 'Stafford Place I (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Summit I' Where EntityParameter = 'Summit I (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Terrell Place' Where EntityParameter = 'Terrell Place (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Transpotomac Plaza' Where EntityParameter = 'Transpotomac Plaza (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='TSCE' Where EntityParameter = 'TS Crown Entities'
Update SavedEntityParameter Set EntityParameter ='TSCE - China RMB Fund' Where EntityParameter = 'China RMB Fund'
Update SavedEntityParameter Set EntityParameter ='TSEC_Fund GP' Where EntityParameter = 'TSEC GP'
Update SavedEntityParameter Set EntityParameter ='TSEV Fund II_Fund GP' Where EntityParameter = 'TSEV Fund II GP'
Update SavedEntityParameter Set EntityParameter ='TSEV_Fund GP' Where EntityParameter = 'TSEV GP'
Update SavedEntityParameter Set EntityParameter ='TSP Boston JV' Where EntityParameter = 'TSP Boston'
Update SavedEntityParameter Set EntityParameter ='TSP Corp' Where EntityParameter = 'TSP Corporate'
Update SavedEntityParameter Set EntityParameter ='TSRES' Where EntityParameter = 'TS Real Estate Services LLC'
Update SavedEntityParameter Set EntityParameter ='Waverock (H12)' Where EntityParameter = 'Waverock (Hyderabad 12 acres)'
Update SavedEntityParameter Set EntityParameter ='Westbridge' Where EntityParameter = 'Westbridge (2550 M St) (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='Woodland Park Property' Where EntityParameter = 'Woodland Park'
Update SavedEntityParameter Set EntityParameter ='World Bank' Where EntityParameter = 'World Bank (Carr Portfolio)'
Update SavedEntityParameter Set EntityParameter ='WPPOA' Where EntityParameter = 'Woodland Park Property Owners Association'


--Change Request 1
Update SavedEntityParameter Set EntityParameter = 'Presidente Vargas' Where EntityParameter = 'Presidential Plaza'
Update SavedEntityParameter Set EntityParameter = 'Presidential Plaza'  Where EntityParameter =  'Presidential Plaza (Carr Portfolio)'

--Change Request 2
Update SavedEntityParameter Set EntityParameter = 'Park Place - Corp Entity' Where EntityParameter = 'Park Place'
Update SavedEntityParameter Set EntityParameter = 'Park Place' Where EntityParameter = 'Park Place (Carr Portfolio)'



Update SavedRegionParameter Set AllocationRegion = 'EU Funds' Where AllocationRegion = 'EU Funds (US Cost)'
Update SavedRegionParameter Set AllocationRegion = 'Virginia/DC' Where AllocationRegion = 'Virginia-DC'
Update SavedRegionParameter Set AllocationRegion = 'Southern California' Where AllocationRegion = 'Los Angeles'
Update SavedRegionParameter Set AllocationRegion = 'INDIA' Where AllocationRegion = 'TSP India'
Update SavedRegionParameter Set AllocationRegion = 'VIRGINIA/DC' Where AllocationRegion = 'VA/DC'



DELETE FROM [DBO].[SAVEDSTAFFPARAMETER]
   WHERE STAFF IN (
	'Clark, Bill','Clark, William','Clayborne, Sharon','Clift, Lauren','Cohen, Lance','Cortes, Joao','D''Alessio, Joel','D''Andrea, Gabriela',
	'de Sousa, Rackel','Deletion, Account','Desportes, Louis','Devaveth, Devender','Dickinson, Nadia','Doets, Tamara','Duong, Phong','Erakat, Tina',
	'Fernandez, Jesus','Ferriera, Russell','Feuerhak, Eiko','Figueroa-Bonilla, Ricardo','Fitzpatrick, Berne','FoxUser, Dave','Fraulo, Tony',
	'Gail, Michael','Gallo, Daniel','Galvin, Laura','Gasilo, Alex','George, William','Gerhardt, Stephen','Gilmer, Wesley','Greiwe, Brad',
	'Grishman, Kathleen','Grover, Doug','Guzman, Oscar','H„usler, Christiane','Halajian, Christopher','Harris, Calvin','Hatting, Susan',
	'Hayes, Margaret','Heaverlo, Kendra','Hemrick, Ryan','Henderson, Heather','Hinter, Ralf','Hirsch, Amanda','Hudson, Heather','Hylton, Julie',
	'Iannotta, Cathryn','Jennings, Kevin','Jesus, Daniele','Jimenez, Samuel','Johnson, Dennis','Johnson, Marie','Kahn, Jared','Kamys, Walter',
	'Karlovich, Dennis','Kaule, Anja','Keil, Carl','Ketchpaw, Mike','Kirschner, Roberto','Koch, Peter','Kogut, Steve','Kos, Anna','Krassner, Amanda',
	'Krausman, Jayme','Krzyzanowski, Danny','Kubiszyn, John','Abdalla, Beatriz','Alvarez, Ervin','Amantine, Camille','Applestein, Ben',
	'Asimyadis, Gabriele','Assef, Alice','Babinowich, Jeff','Baer, Claudia','Baker, Charles','Baxter, Mark','Berlin, Grant','Berrios, Norberto',
	'Bonvouloir, Caroline','Boyan, Ed','Bradley, James','Brock, Josiah','Broderick, Michael','Bromberg, Lauren','Brown, Dana','Brown, Laura',
	'Browne, Kenneth','Buechler, Guenther','Caimi, Jeffrey','Carey, Victoria','Cartwright, Douglass','Cavender, Scott','Chen, Jim',
	'Cherukuri, Srilatha','Chevere, Lithia','Chibatar, Elena','Chivers, Michael','Chorman, Peter','Chromcak, Kathleen','Lima, Valeria',
	'Linard, Tanguy','Lu, Cynthia','Mahaney, Bevan','Maldonado, Louis','Manaigo, Federico','Mannarino, Tony','Mansfield, Shalina',
	'Manyemwe, Daniel','Mariano, Rita','Marks, Laura','Mata, Fernando Pincelli','McCullough, Devin','Mehrotra, Aseem','Mendez, Jamie',
	'Mercado, Jaime','Mezheritsky, Dina','Mller, Christian','Morgan, Alexandra','Morgan, Eric','Mullen, Cassidy','Mungali, Praneet','Murciani, Christophe',
	'Mutha, Sripal Raj','Nanjappa, Jayamadappa','Naughton, Thomas','Nayak, Ameet','Neely, Katrina','NG, Lily','Nichols, Ebonie','Nson, Steve',
	'Nunez, Mariela','Odubayo, Idowu','Olsen, Harry','O''Neil, Janice','Park, Sophia','Patterson, Bob','Patterson, Darryn','Patterson, Michael',
	'Paull, Geraldine','Pereira, Sonia Maria M','Raju, Deborah','Reis, Stephane','Riccobono, Christina','Richino, Angela','Robinson, Damian',
	'Romanelli, Joseph','Ronnberg, Charlotte','Roth, Alexandra','Salam, Annie','Salem, Kimberley','Schmitz, Steve','Sct, Security','Sealy, Joe',
	'Seward, Elizabeth','Shaul, Caroline','Sousa, Joana','Sperber, Sebastian','Statuto, Damien','Stephens, Laura','Suryawanshi, Krishna',
	'Sweeney, Keri','Tan, Jacqueline','Tansil, Felix','Taylor, Patrick','Tencer, Daniel','Tinkham, Delphine','Tsao, ChihKung','Tucker, Tim',
	'Turner, Seth','Ullman, Katie','Urganciyan, Arthur','Vellore, Gerda','Ventura, Rodolfo','Walsh, Katie','Walter, Wibke','Webb, Bill',
	'Williams, Krystal','Wypski, Gene','Yang, Dong','Zabrosky, John','Zeltser, Irina','Zimbardo, Kristina','Phillips, Walter','Popova, Irina',
	'Preis, Mike','Citron, Daniel','Phelps, Toby','Shuler, Lucas','Prezioso, Antonio','Kumar, Sudhin' 
)

/*
  SELECT * FROM DBO.SAVEDSTAFFPARAMETER
  WHERE STAFF IN (  'Citron, Daniel','Phelps, Toby','Shuler, Lucas','Prezioso, Antonio','Kumar, Sudhin')
*/

DELETE FROM [DBO].[STAFF]
  WHERE STAFFNAME IN (
	'Clark, Bill', 'Clark, William', 'Clayborne, Sharon', 'Clift, Lauren', 'Cohen, Lance', 'Cortes, Joao','D''Alessio, Joel',
	'D''Andrea, Gabriela','de Sousa, Rackel','Deletion, Account','Desportes, Louis','Devaveth, Devender','Dickinson, Nadia',
	'Doets, Tamara','Duong, Phong','Erakat, Tina','Fernandez, Jesus','Ferriera, Russell','Feuerhak, Eiko','Figueroa-Bonilla, Ricardo',
	'Fitzpatrick, Berne','FoxUser, Dave','Fraulo, Tony','Gail, Michael','Gallo, Daniel','Galvin, Laura','Gasilo, Alex',
	'George, William','Gerhardt, Stephen','Gilmer, Wesley','Greiwe, Brad','Grishman, Kathleen','Grover, Doug','Guzman, Oscar',
	'H„usler, Christiane','Halajian, Christopher','Harris, Calvin','Hatting, Susan','Hayes, Margaret','Heaverlo, Kendra',
	'Hemrick, Ryan','Henderson, Heather','Hinter, Ralf','Hirsch, Amanda','Hudson, Heather','Hylton, Julie','Iannotta, Cathryn',
	'Jennings, Kevin','Jesus, Daniele','Jimenez, Samuel','Johnson, Dennis','Johnson, Marie','Kahn, Jared','Kamys, Walter',
	'Karlovich, Dennis','Kaule, Anja','Keil, Carl','Ketchpaw, Mike','Kirschner, Roberto','Koch, Peter','Kogut, Steve',
	'Kos, Anna','Krassner, Amanda','Krausman, Jayme','Krzyzanowski, Danny','Kubiszyn, John','Abdalla, Beatriz','Alvarez, Ervin',
	'Amantine, Camille','Applestein, Ben','Asimyadis, Gabriele','Assef, Alice','Babinowich, Jeff','Baer, Claudia',
	'Baker, Charles','Baxter, Mark','Berlin, Grant','Berrios, Norberto','Bonvouloir, Caroline','Boyan, Ed','Bradley, James',
	'Brock, Josiah','Broderick, Michael','Bromberg, Lauren','Brown, Dana','Brown, Laura','Browne, Kenneth','Buechler, Guenther',
	'Caimi, Jeffrey','Carey, Victoria','Cartwright, Douglass','Cavender, Scott','Chen, Jim','Cherukuri, Srilatha','Chevere, Lithia',
	'Chibatar, Elena','Chivers, Michael','Chorman, Peter','Chromcak, Kathleen','Lima, Valeria','Linard, Tanguy','Lu, Cynthia',
	'Mahaney, Bevan','Maldonado, Louis','Manaigo, Federico','Mannarino, Tony','Mansfield, Shalina','Manyemwe, Daniel',
	'Mariano, Rita','Marks, Laura','Mata, Fernando Pincelli','McCullough, Devin','Mehrotra, Aseem','Mendez, Jamie','Mercado, Jaime',
	'Mezheritsky, Dina','Mller, Christian','Morgan, Alexandra','Morgan, Eric','Mullen, Cassidy','Mungali, Praneet','Murciani, Christophe',
	'Mutha, Sripal Raj','Nanjappa, Jayamadappa','Naughton, Thomas','Nayak, Ameet','Neely, Katrina','NG, Lily','Nichols, Ebonie','Nson, Steve',
	'Nunez, Mariela','Odubayo, Idowu','Olsen, Harry','O''Neil, Janice','Park, Sophia','Patterson, Bob','Patterson, Darryn','Patterson, Michael',
	'Paull, Geraldine','Pereira, Sonia Maria M','Raju, Deborah','Reis, Stephane','Riccobono, Christina','Richino, Angela','Robinson, Damian',
	'Romanelli, Joseph','Ronnberg, Charlotte','Roth, Alexandra','Salam, Annie','Salem, Kimberley','Schmitz, Steve','Sct, Security',
	'Sealy, Joe','Seward, Elizabeth','Shaul, Caroline','Sousa, Joana','Sperber, Sebastian','Statuto, Damien','Stephens, Laura',
	'Suryawanshi, Krishna','Sweeney, Keri','Tan, Jacqueline','Tansil, Felix','Taylor, Patrick','Tencer, Daniel','Tinkham, Delphine',
	'Tsao, ChihKung','Tucker, Tim','Turner, Seth','Ullman, Katie','Urganciyan, Arthur','Vellore, Gerda','Ventura, Rodolfo','Walsh, Katie',
	'Walter, Wibke','Webb, Bill','Williams, Krystal','Wypski, Gene','Yang, Dong','Zabrosky, John','Zeltser, Irina','Zimbardo, Kristina',
	'Phillips, Walter','Popova, Irina','Preis, Mike','Citron, Daniel','Phelps, Toby','Shuler, Lucas','Prezioso, Antonio','Kumar, Sudhin'  
  )
  
/*  
SELECT  COUNT(STAFFNAME) FROM DBO.STAFF 
*/

COMMIT TRAN
--ROLLBACK TRAN
