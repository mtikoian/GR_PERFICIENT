
--- UPDATE GLOBAL REGION ----
BEGIN TRANSACTION

UPDATE Gr.GlobalRegion
SET NAME = 'INDIA'
WHERE NAME = 'TSP INDIA'

UPDATE Gr.GlobalRegion
SET NAME = 'PCVST'
WHERE NAME = 'PCV/ST'

UPDATE Gr.GlobalRegion
SET NAME = 'BEIJING'
WHERE NAME = 'TS REC (Beijing)'

UPDATE Gr.GlobalRegion
SET NAME = 'CHENGDU'
WHERE NAME = 'TS REC (Chengdu)'

UPDATE Gr.GlobalRegion
SET NAME = 'SHANGHAI'
WHERE NAME = 'TS REC (Shanghai)'

UPDATE Gr.GlobalRegion
SET NAME = 'TIANJIN'
WHERE NAME = 'TS REC (Tianjin)'

UPDATE Gr.GlobalRegion
SET NAME = 'VIRGINIA/DC'
WHERE NAME = 'VA/DC'

COMMIT TRANSACTION

/* CHECK
SELECT * FROM GR.GLOBALREGION
*/


---Originating Region Changes---
BEGIN TRANSACTION
Declare @GlobalRegionId INT

--florida--
SET @GlobalRegionId = 
(SELECT GlobalRegionId FROM Gr.GlobalRegion
WHERE REGIONCODE = 'ATL')


UPDATE Gr.OriginatingRegionMapping
SET GLOBALREGIONID = @GlobalRegionId
WHERE REGIONCODE in (
					'FL1700',
					'FLRAND',
					'FLRACC',
					'FLRASM',
					'FLRBOP',
					'FLRCEX',
					'FLRCFI',
					'FLRDNC',
					'FLRDCM',
					'FLRECM',
					'FLREXS',
					'FLRHCM',
					'FLRITS',
					'FLRLNS',
					'FLRLDP',
					'FLRLGL',
					'FLRMKT',
					'FLROFS',
					'FLRPMA',
					'FLRPMO',
					'FLRREX',
					'FLRTAX'
					)
					

--MPACT STUDIO, US CORPORATE--
SET @GlobalRegionId = 
(SELECT GlobalRegionId FROM Gr.GlobalRegion
WHERE REGIONCODE = 'NYS')

UPDATE Gr.OriginatingRegionMapping
SET GLOBALREGIONID = @GlobalRegionId
WHERE REGIONCODE in (
					'MPSACC',
					'MPSAND',
					'MPSASM',
					'MPSBOP',
					'MPSCEX',
					'MPSCFI',
					'MPSDCM',
					'MPSDNC',
					'MPSECM',
					'MPSEXS',
					'MPSHCM',
					'MPSITS',
					'MPSLDP',
					'MPSLGL',
					'MPSLNS',
					'MPSMKT',
					'MPSOFS',
					'MPSPMA',
					'MPSPMO',
					'MPSREX',
					'MPSTAX',
					'USFN21',
					'USFN01'
					)



--SEATTLE--
SET @GlobalRegionId = 
(SELECT GlobalRegionId FROM Gr.GlobalRegion
WHERE REGIONCODE = 'NCA')

UPDATE Gr.OriginatingRegionMapping
SET GLOBALREGIONID = @GlobalRegionId
WHERE REGIONCODE in (
					'SEAACC',
					'SEAAND',
					'SEAASM',
					'SEABOP',
					'SEACEX',
					'SEACFI',
					'SEADCM',
					'SEADNC',
					'SEAECM',
					'SEAEXS',
					'SEAHCM',
					'SEAITS',
					'SEALDP',
					'SEALGL',
					'SEALNS',
					'SEAMKT',
					'SEAOFS',
					'SEAPMA',
					'SEAPMO',
					'SEAREX',
					'SEATAX',
					'WA1800'
					)

--SPAIN--
SET @GlobalRegionId = 
(SELECT GlobalRegionId FROM Gr.GlobalRegion
WHERE REGIONCODE = 'UKD')

UPDATE Gr.OriginatingRegionMapping
SET GLOBALREGIONID = @GlobalRegionId
WHERE REGIONCODE in (
					'10000',
					'SPNACC',
					'SPNAND',
					'SPNASM',
					'SPNBOP',
					'SPNCEX',
					'SPNCFI',
					'SPNDCM',
					'SPNDNC',
					'SPNECM',
					'SPNEXS',
					'SPNHCM',
					'SPNITS',
					'SPNLDP',
					'SPNLGL',
					'SPNLNS',
					'SPNMKT',
					'SPNOFS',
					'SPNPMA',
					'SPNPMO',
					'SPNREX',
					'SPNTAX'
					)
					
--TS Mgmt (OPCI)--
SET @GlobalRegionId = 
(SELECT GlobalRegionId FROM Gr.GlobalRegion
WHERE REGIONCODE = 'FRA')

UPDATE Gr.OriginatingRegionMapping
SET GLOBALREGIONID = @GlobalRegionId
WHERE REGIONCODE in (
					'19000',
					'TSMACC',
					'TSMAND',
					'TSMASM',
					'TSMBOP',
					'TSMCEX',
					'TSMCFI',
					'TSMDCM',
					'TSMDNC',
					'TSMECM',
					'TSMEXS',
					'TSMHCM',
					'TSMITS',
					'TSMLDP',
					'TSMLGL',
					'TSMLNS',
					'TSMMKT',
					'TSMOFS',
					'TSMPMA',
					'TSMPMO',
					'TSMREX',
					'TSMTAX'

)

--TSP ITALY--
SET @GlobalRegionId = 
(SELECT GlobalRegionId FROM Gr.GlobalRegion
WHERE REGIONCODE = 'UKD')

UPDATE Gr.OriginatingRegionMapping
SET GLOBALREGIONID = @GlobalRegionId
WHERE REGIONCODE in (
					'15000',
					'18000',
					'ITAACC',
					'ITAAND',
					'ITAASM',
					'ITABOP',
					'ITACEX',
					'ITACFI',
					'ITADCM',
					'ITADNC',
					'ITAECM',
					'ITAEXS',
					'ITAHCM',
					'ITAITS',
					'ITALDP',
					'ITALGL',
					'ITALNS',
					'ITAMKT',
					'ITAOFS',
					'ITAPMA',
					'ITAPMO',
					'ITAREX',
					'ITATAX'
)

COMMIT TRANSACTION

/* CHECK ORIGINATING REGION MAPPINGS
SELECT mapping.OriginatingRegionMappingId, mapping.GlobalRegionId, mapping.regionCode,
region.name, region.ParentGlobalRegionId, sourcecode
FROM Gr.OriginatingRegionMapping mapping
INNER JOIN Gr.GlobalRegion region ON region.globalregionid = mapping.globalregionid
WHERE REGION.REGIONCODE in ('FLR', 'ITA', 'TSM', 'SPN', 'SEA','MPS','USC')

SELECT mapping.OriginatingRegionMappingId, mapping.GlobalRegionId, mapping.regionCode,
region.name, region.ParentGlobalRegionId, sourcecode
FROM Gr.OriginatingRegionMapping mapping
INNER JOIN Gr.GlobalRegion region ON region.globalregionid = mapping.globalregionid
WHERE REGION.REGIONCODE in ('ATL', 'UKD', 'FRA', 'NCA','NYS')
*/
