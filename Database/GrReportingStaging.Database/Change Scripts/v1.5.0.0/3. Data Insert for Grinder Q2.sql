USE BC_TS_GRINDER_Q2
GO

update BC_TS_GRINDER_Q2.dbo.FeeBudgetCycle set AvailableDate = '2010-08-13 11:06:44.440' Where BudgetPeriodCode = 'Q2'


/*
EXCEL Formula:

="Insert Into FeeDetail (FeeDetailUID,"&C$1&","&D$1&","&E$1&","&F$1&","&G$1&","&H$1&","&I$1&","&J$1&","&K$1&","&M$1&","&N$1&",
"&O$1&","&P$1&","&Q$1&","&R$1&","&T$1&","&U$1&","&V$1&","&W$1&","&X$1&",CREATED,LastUpdated,
LastUpdatedBy,"&AB$1&","&AC$1&","&AD$1&","&AE$1&","&AF$1&",FeeCategoryId,"&AH$1&",EntityId,"&AJ$1&","&AK$1&","&AL$1&",PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
"&B2&",
CASE WHEN '"&C2&"' = 'NULL' THEN NULL ELSE '"&C2&"' END,
"&D2&",
"&E2&",
"&F2&",
"&G2&",
"&H2&",
"&I2&",
"&J2&",
"&K2&",
"&M2&",
"&N2&",
"&O2&",
"&P2&",
"&Q2&",
"&R2&",
"&T2&",
"&U2&",
"&V2&",
"&W2&",
"&X2&",
"&Y2&",
"&Z2&",
"&AA2&",
"&AB2&",
"&AC2&",
"&AD2&",
"&AE2&",
"&AF2&",
"&AG2&",
"&AH2&",
"&AI2&",
"&AJ2&",
"&AK2&",
'"&AL2&"',
"&AM2&",
CASE WHEN '"&AN2&"' = 'Yes' THEN 1 ELSE 0 END"



="Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,"&D$1&","&E$1&","&F$1&","&G$1&","&H$1&","&I$1&","&J$1&","&K$1&","&L$1&","&M$1&","&N$1&",
"&O$1&","&P$1&","&Q$1&","&R$1&","&S$1&","&T$1&","&U$1&","&V$1&","&W$1&","&X$1&")

Select 
"&B2&",
CASE WHEN '"&C2&"' = 'NULL' THEN NULL ELSE '"&C2&"' END,
"&D2&",
"&E2&",
'"&F2&"',
"&G2&",
"&H2&",
"&I2&",
"&J2&",
"&K2&",
"&L2&",
"&M2&",
"&N2&",
"&O2&",
"&P2&",
"&Q2&",
"&R2&",
"&S2&",
"&T2&",
getdate(),
getdate(),
"&W2&",
"&X2&""


="IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = "&B2&")
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('"&A2&"'
           ,"&B2&"
           ,'"&C2&"'
           ,'"&D2&"'
           ,'"&E2&"')
GO
"


*/
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME = 'FeeDetail' AND COLUMN_NAME = 'IsAdjustment')
	BEGIN
	ALTER TABLE dbo.FeeDetail ADD IsAdjustment Bit NOT NULL CONSTRAINT DF_FeeDetail_IsAdjustment DEFAULT '0'
	END
GO


Delete From FeeBudgetDetail Where FeeBudgetDetailUID >= 1695 AND FeeBudgetDetailUID < = 1716
Delete from FeeDetail Where FeeDetailUID >= 591 AND FeeDetailUID <= 612
GO
SET IDENTITY_INSERT FeeDetail ON 

Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
591,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
158,
2169,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
194,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
592,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
159,
2170,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
195,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
593,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
160,
2171,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
196,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
594,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
161,
2172,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
197,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
595,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
163,
2175,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
200,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
596,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
165,
2177,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
201,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
597,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
175,
2178,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
204,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
598,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
167,
2179,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
202,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
599,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
168,
2180,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
203,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
600,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
176,
2182,
NULL,
4,
'Eliminates 4Q Leasing Commissions',
163,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
601,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
167,
2179,
NULL,
4,
'Eliminates ALL Leasing Commissions for PCVST',
202,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
602,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
5,
1,
167,
2179,
NULL,
4,
'Eliminates Property Mgmt for PCVST after July',
202,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
603,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
5,
1,
165,
2177,
NULL,
4,
'Reduced assumption in Waverock',
201,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
604,
CASE WHEN '2010 budget reflects $9,416 in fees.  ' = 'NULL' THEN NULL ELSE '2010 budget reflects $9,416 in fees.  ' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
3,
7,
167,
2351,
NULL,
4,
'General Corporate Adjustment',
199,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
605,
CASE WHEN '2010 budget reflects $9,416 in fees.  ' = 'NULL' THEN NULL ELSE '2010 budget reflects $9,416 in fees.  ' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
3,
7,
167,
2179,
NULL,
4,
'Eliminates PCVST Construction Fees',
202,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
606,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
3,
7,
165,
2177,
NULL,
4,
'Carrryover from budget.  Reduced due Wavelock leasing adj',
201,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
607,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
4,
5,
165,
2177,
NULL,
4,
'Additional cut of leasing assumptions by half from 2010 Budget',
201,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
608,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
2,
2,
162,
2173,
NULL,
4,
'Keep Jiang Wan in Predev for slow predev start (Amount in local currency)',
198,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
609,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
2,
2,
160,
2171,
NULL,
4,
'Keep Tower 4 in Predev for slow predev start (Amount in local currency)',
196,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
610,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
2,
2,
160,
2171,
NULL,
4,
'Adjustment for Brasilia: assumes 200K REI based on 3rd party.  Leftover from budget',
196,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
611,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
2,
2,
167,
2179,
NULL,
4,
'Reduc LIC Medmac fee to show that TSP will receive $2M in cost back only.',
202,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
612,
CASE WHEN 'NULL' = 'NULL' THEN NULL ELSE 'NULL' END,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
40391,
NULL,
NULL,
NULL,
NULL,
NULL,
2,
2,
165,
2177,
NULL,
4,
'Reduced per MR',
201,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END



SET IDENTITY_INSERT FeeDetail OFF



GO


SET IDENTITY_INSERT FeeBudgetDetail ON

Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1695,
CASE WHEN '591' = 'NULL' THEN NULL ELSE '591' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-61493,
-59239,
-217699,
-338431,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1696,
CASE WHEN '592' = 'NULL' THEN NULL ELSE '592' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
-376901,
-376901,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1697,
CASE WHEN '593' = 'NULL' THEN NULL ELSE '593' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-45000,
-45000,
-45000,
-135000,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1698,
CASE WHEN '594' = 'NULL' THEN NULL ELSE '594' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-268082,
-188122,
-384168,
-840372,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1699,
CASE WHEN '595' = 'NULL' THEN NULL ELSE '595' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-52417,
-255000,
0,
-307417,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1700,
CASE WHEN '596' = 'NULL' THEN NULL ELSE '596' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1701,
CASE WHEN '597' = 'NULL' THEN NULL ELSE '597' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-139600,
0,
-89100,
-228700,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1702,
CASE WHEN '598' = 'NULL' THEN NULL ELSE '598' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-740384,
-1037290,
-4701326,
-6479000,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1703,
CASE WHEN '599' = 'NULL' THEN NULL ELSE '599' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-50848,
-57267,
-190158,
-298273,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1704,
CASE WHEN '600' = 'NULL' THEN NULL ELSE '600' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-223582,
-87739,
-242197,
-553518,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1705,
CASE WHEN '601' = 'NULL' THEN NULL ELSE '601' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
-2220,
-38550,
-5995,
-7394,
-22286,
-76445,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1706,
CASE WHEN '602' = 'NULL' THEN NULL ELSE '602' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
-232527,
-240359,
-266965,
-739851,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1707,
CASE WHEN '603' = 'NULL' THEN NULL ELSE '603' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1708,
CASE WHEN '604' = 'NULL' THEN NULL ELSE '604' END,
2010,
4,
'Y',
-166666,
-166666,
-166666,
-166666,
-166666,
-166666,
-166666,
-166666,
-166666,
-166666,
-166666,
-166674,
-2000000,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1709,
CASE WHEN '605' = 'NULL' THEN NULL ELSE '605' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
-16411,
-9380,
-25089,
-27956,
-8847,
0,
-2800,
-90483,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1710,
CASE WHEN '606' = 'NULL' THEN NULL ELSE '606' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1711,
CASE WHEN '607' = 'NULL' THEN NULL ELSE '607' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1712,
CASE WHEN '608' = 'NULL' THEN NULL ELSE '608' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
-586318,
-586318,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1713,
CASE WHEN '609' = 'NULL' THEN NULL ELSE '609' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
-166037,
-166037,
-166037,
-166037,
-664148,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1714,
CASE WHEN '610' = 'NULL' THEN NULL ELSE '610' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1715,
CASE WHEN '611' = 'NULL' THEN NULL ELSE '611' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
0,
0,
0,
-282265,
-282265,
-282265,
-282265,
-1129060,
NULL,
getdate(),
getdate(),
4,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
1716,
CASE WHEN '612' = 'NULL' THEN NULL ELSE '612' END,
2010,
4,
'Y',
0,
0,
0,
0,
0,
-45291,
-45291,
-45292,
0,
0,
0,
0,
-135874,
NULL,
getdate(),
getdate(),
4,
1



SET IDENTITY_INSERT FeeBudgetDetail OFF

GO
SET IDENTITY_INSERT PropFundMRIDeptCodeMapping ON


IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 194)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Atlanta'
           ,194
           ,'014000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 195)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Boston'
           ,195
           ,'003001'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 196)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Brazil'
           ,196
           ,'012007'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 197)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Chicago'
           ,197
           ,'007000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 198)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP China'
           ,198
           ,'016000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 199)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Corporate'
           ,199
           ,'001000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 200)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP France'
           ,200
           ,'011000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 201)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP India'
           ,201
           ,'013000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 202)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP New York'
           ,202
           ,'002000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 203)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Northern California'
           ,203
           ,'006000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 204)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Southern California'
           ,204
           ,'005000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 163)
 INSERT INTO [BC_TS_GRINDER_Q2].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Virginia/DC'
           ,163
           ,'004000'
           ,'PROPERTY'
           ,'UC')
GO

SET IDENTITY_INSERT PropFundMRIDeptCodeMapping OFF

GO
--IMS 57317 - Update SubRegionId on one of the FeeDetails table.

BEGIN TRAN
Update BC_TS_GRINDER_Q2.dbo.FeeDetail 
Set SubRegionId = 170 
From
		BC_TS_GRINDER_Q2.dbo.FeeBudgetDetail 
WHERE  FeeBudgetDetail.FeeDetailUID = FeeDetail.FeeDetailUID
AND FeeBudgetCycleUId = 4 and FeeDetail.FeeDetailUID = 604
COMMIT TRAN
