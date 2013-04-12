



USE BC_TS_GRINDER_Q3
GO

IF NOT EXISTS(select * From GlobalAccountMappingLookupFee Where FeeTypeUId = 1 AND FeeCategoryUId = 10)
	BEGIN
	Insert Into GlobalAccountMappingLookupFee (FeeTypeUId,FeeCategoryUId,GlobalAccountMappingId) 
	VALUES(1,10,4714)
	END
GO
IF NOT EXISTS(select * From GlobalAccountMappingLookupFee Where FeeTypeUId = 1 AND FeeCategoryUId = 12)
	BEGIN
	Insert Into GlobalAccountMappingLookupFee (FeeTypeUId,FeeCategoryUId,GlobalAccountMappingId)
	VALUES(1,12,4712)
	END
GO
IF NOT EXISTS(select * From GlobalAccountMappingLookupFee Where FeeTypeUId = 2 AND FeeCategoryUId = 4)
	BEGIN
	Insert Into GlobalAccountMappingLookupFee (FeeTypeUId,FeeCategoryUId,GlobalAccountMappingId)
	VALUES(2,4,4700)
	END
GO
UPDATE dbo.EmployeeSubRegion
SET
	Code = 'UKD',
	UpdatedDate = getdate()
WHERE
	Name ='Italy' Or Name = 'United Kingdom'
	
	
UPDATE dbo.EmployeeSubRegion
SET
	Code = 'NCA',
	UpdatedDate = getdate()
WHERE
	Name ='Seattle' Or Name = 'North California'
	
	
UPDATE dbo.EmployeeSubRegion
SET
	Code = 'NYS',
	UpdatedDate = getdate()
WHERE
	Name ='Corporate'
	
UPDATE dbo.EmployeeSubRegion
SET
	Code = 'FRA',
	UpdatedDate = getdate()
WHERE
	Name ='France' OR Name = 'France-OPCI'
	
UPDATE dbo.EmployeeSubRegion
SET
	Code = 'SCA',
	UpdatedDate = getdate()
WHERE
	Name ='Southern California'

UPDATE dbo.PropFundMRIDeptCodeMapping
SET
	CorporateMRIDeptCode = '019014'
WHERE
	RTRIM(Name) = 'Jiang Wan New Town' AND
	CorporateMRIDeptCode = '001601'	
--------------------------------------------------------------------------------------------------------------
-- Polly's update

BEGIN TRAN
SELECT
	NPE.NonPayrollExpenseID AS NonPayrollExpenseId,
	FD.Name AS FunctionalDepartment,
	ISNULL(Emp.LastName, '') + ', ' + ISNULL(Emp.FirstName, '') AS CompletedByEmployeeName,
	EC.Name AS ExpenseCategory,
	GT.Name AS ExpenseType,
	ISNULL(JC.Code, '') AS JobCode,
	ISNULL(JC.Description, '') AS JobCodeDescription,
	ED.Name as ExpenseDirection, --IT EXPENSES ONLY 	
	ESR.Name AS OriginatingRegion,
	VendorName AS VendorName,
	ExpenseDescription AS ExpenseDescription,
	PeriodGroup AS PeriodGroup,
	C.Name AS Currency,	
	NPED.LocalAmount AS Amount,
	NPED.DollarAmount AS DollarAmount,
	NPED.ProjectGroupID AS ProjectGroupID,
	ISNULL(PG.Name, '') AS ProjectGroup,
	NPED.ProjectID as ProjectID,
	ISNULL(P.Name, '') AS ProjectName,
	ISNULL(AT.Name, '') AS ActivityType,
	ISNULL(P.BudgetOwner, '') AS BudgetOwner,
	SubmittedDate AS SubmittedDate,
	DataSource AS DataSource,
	ISNULL(NPE.Comments, '') AS Comments,
	ISNULL(MiscellaneousComments, '') AS MiscellaneousComments
	,NPE.Overhead as OverHead --Added 11/11/10
	,NPED.JanuaryLocal
	,NPED.FebruaryLocal
	,NPED.MarchLocal
	,NPED.AprilLocal
	,NPED.MayLocal
	,NPED.JuneLocal
	,NPED.JulyLocal
	,NPED.AugustLocal
	,NPED.SeptemberLocal
	,NPED.OctoberLocal
	,NPED.NovemberLocal
	,NPED.DecemberLocal
	,NPED.JanuaryDollar
	,NPED.FebruaryDollar
	,NPED.MarchDollar
	,NPED.AprilDollar
	,NPED.MayDollar
	,NPED.JuneDollar
	,NPED.JulyDollar
	,NPED.AugustDollar
	,NPED.SeptemberDollar
	,NPED.OctoberDollar
	,NPED.NovemberDollar
	,NPED.DecemberDollar
	,NPC.NonPayrollCycleUID
	,NPC.CycleName
FROM NonPayrollExpense NPE
	INNER JOIN NonPayrollExpenseDetail NPED 
		ON NPE.NonPayrollExpenseID = NPED.NonPayrollExpenseID
		AND NPED.NonPayrollCycleUID = 4 -- NEED TO SPECIFIY THE CORRECT NON PAYROLL CYCLE

	LEFT OUTER JOIN NonPayrolLCycle NPC ON NPED.NonPayrollCycleUID = NPC.NonPayrollCycleUID 
	LEFT OUTER JOIN Project P ON NPE.ProjectId = P.ProjectId
	LEFT OUTER JOIN ActivityType AT ON AT.ActivityTypeId = P.ActivityTypeId
	LEFT OUTER JOIN ProjectGroup PG ON PG.ProjectGroupId = NPE.ProjectGroupId
	LEFT OUTER JOIN EmployeeSubRegion ESR ON ESR.EmployeeSubRegionId = NPE.OriginatingEmployeeSubRegionId
	LEFT OUTER JOIN FunctionalDepartment FD ON NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId
	LEFT OUTER JOIN ExpenseCategory EC ON NPE.ExpenseCategoryId = EC.ExpenseCategoryId
	LEFT OUTER JOIN GLType GT ON GT.GLTypeId = NPE.GLTypeId
	LEFT OUTER JOIN JobCode JC ON JC.JobCodeId = NPE.JobCodeId
	LEFT OUTER JOIN Currency C ON C.CurrencyId = NPE.CurrencyId
	LEFT OUTER JOIN Employee Emp ON NPE.CompletedByEmployeeID = Emp.EmployeeId
	LEFT OUTER JOIN ExpenseDirection ED ON ED.ID = NPE.ExpenseDirectionId
	
WHERE
	NPE.NonPayrollExpenseId IN (127256,
		127944,
		127945,
		127946,
		127947,
		127948,
		127949,
		127950,
		127951,
		127960,
		127961,
		127962,
		130241,
		130242,
		130485,
		130487,
		130488,
		130620,
		131328,
		131804,
		131805,
		131806,
		132127,
		132177)
ORDER BY
	NPE.NonPayrollExpenseID
	
	
	
UPDATE NonPayrollExpense SET Overhead = 0 WHERE NonPayrollExpenseId IN (127256,
127944,
127945,
127946,
127947,
127948,
127949,
127950,
127951,
127960,
127961,
127962,
130241,
130242,
130485,
130487,
130488,
130620,
131328,
131804,
131805,
131806,
132127,
132177)


SELECT
	NPE.NonPayrollExpenseID AS NonPayrollExpenseId,
	FD.Name AS FunctionalDepartment,
	ISNULL(Emp.LastName, '') + ', ' + ISNULL(Emp.FirstName, '') AS CompletedByEmployeeName,
	EC.Name AS ExpenseCategory,
	GT.Name AS ExpenseType,
	ISNULL(JC.Code, '') AS JobCode,
	ISNULL(JC.Description, '') AS JobCodeDescription,
	ED.Name as ExpenseDirection, --IT EXPENSES ONLY 	
	ESR.Name AS OriginatingRegion,
	VendorName AS VendorName,
	ExpenseDescription AS ExpenseDescription,
	PeriodGroup AS PeriodGroup,
	C.Name AS Currency,	
	NPED.LocalAmount AS Amount,
	NPED.DollarAmount AS DollarAmount,
	NPED.ProjectGroupID AS ProjectGroupID,
	ISNULL(PG.Name, '') AS ProjectGroup,
	NPED.ProjectID as ProjectID,
	ISNULL(P.Name, '') AS ProjectName,
	ISNULL(AT.Name, '') AS ActivityType,
	ISNULL(P.BudgetOwner, '') AS BudgetOwner,
	SubmittedDate AS SubmittedDate,
	DataSource AS DataSource,
	ISNULL(NPE.Comments, '') AS Comments,
	ISNULL(MiscellaneousComments, '') AS MiscellaneousComments
	,NPE.Overhead as OverHead --Added 11/11/10
	,NPED.JanuaryLocal
	,NPED.FebruaryLocal
	,NPED.MarchLocal
	,NPED.AprilLocal
	,NPED.MayLocal
	,NPED.JuneLocal
	,NPED.JulyLocal
	,NPED.AugustLocal
	,NPED.SeptemberLocal
	,NPED.OctoberLocal
	,NPED.NovemberLocal
	,NPED.DecemberLocal
	,NPED.JanuaryDollar
	,NPED.FebruaryDollar
	,NPED.MarchDollar
	,NPED.AprilDollar
	,NPED.MayDollar
	,NPED.JuneDollar
	,NPED.JulyDollar
	,NPED.AugustDollar
	,NPED.SeptemberDollar
	,NPED.OctoberDollar
	,NPED.NovemberDollar
	,NPED.DecemberDollar
	,NPC.NonPayrollCycleUID
	,NPC.CycleName
FROM NonPayrollExpense NPE
	INNER JOIN NonPayrollExpenseDetail NPED 
		ON NPE.NonPayrollExpenseID = NPED.NonPayrollExpenseID
		AND NPED.NonPayrollCycleUID = 4 -- NEED TO SPECIFIY THE CORRECT NON PAYROLL CYCLE

	LEFT OUTER JOIN NonPayrolLCycle NPC ON NPED.NonPayrollCycleUID = NPC.NonPayrollCycleUID 
	LEFT OUTER JOIN Project P ON NPE.ProjectId = P.ProjectId
	LEFT OUTER JOIN ActivityType AT ON AT.ActivityTypeId = P.ActivityTypeId
	LEFT OUTER JOIN ProjectGroup PG ON PG.ProjectGroupId = NPE.ProjectGroupId
	LEFT OUTER JOIN EmployeeSubRegion ESR ON ESR.EmployeeSubRegionId = NPE.OriginatingEmployeeSubRegionId
	LEFT OUTER JOIN FunctionalDepartment FD ON NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId
	LEFT OUTER JOIN ExpenseCategory EC ON NPE.ExpenseCategoryId = EC.ExpenseCategoryId
	LEFT OUTER JOIN GLType GT ON GT.GLTypeId = NPE.GLTypeId
	LEFT OUTER JOIN JobCode JC ON JC.JobCodeId = NPE.JobCodeId
	LEFT OUTER JOIN Currency C ON C.CurrencyId = NPE.CurrencyId
	LEFT OUTER JOIN Employee Emp ON NPE.CompletedByEmployeeID = Emp.EmployeeId
	LEFT OUTER JOIN ExpenseDirection ED ON ED.ID = NPE.ExpenseDirectionId
	
WHERE
	NPE.NonPayrollExpenseId IN (127256,
		127944,
		127945,
		127946,
		127947,
		127948,
		127949,
		127950,
		127951,
		127960,
		127961,
		127962,
		130241,
		130242,
		130485,
		130487,
		130488,
		130620,
		131328,
		131804,
		131805,
		131806,
		132127,
		132177)
ORDER BY
	NPE.NonPayrollExpenseID
	
	
--ROLLBACK TRAN
COMMIT TRAN

--------------------------------------------------------------------------------------------------------------
GO

BEGIN TRAN

UPDATE
	[BC_TS_GRINDER_Q3].[dbo].[NonPayrollExpenseDetail]
SET
	NonPayrollCycleUID = 1
WHERE
	NonPayrollExpenseID IN (132618, 132617) AND
	NonPayrollCycleUID = 4

COMMIT TRAN



SELECT * FROM [BC_TS_GRINDER_Q3].[dbo].[NonPayrollExpenseDetail] WHERE NonPayrollExpenseID IN (132618, 132617)
GO
--Update the Projects
BEGIN TRAN

UPDATE BC_TS_Grinder_Q3.dbo.Project
SET NonPayrollCorporateMRIDepartmentCode = '019014'
WHERE ProjectId IN (13214, 13215, 13003, 13113, 13115)

COMMIT TRAN

--Update the mapping table
BEGIN TRAN

UPDATE  BC_TS_Grinder_Q3.dbo.BudgetOwnerReportMapping
SET MRIDeptCode = '019014'
WHERE MRIDeptCode = '001601'

COMMIT TRAN
GO



USE BC_TS_GRINDER_Q3
GO

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


="IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = "&B2&")
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
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


delete from FeeBudgetDetail Where FeeBudgetDetailUID in (2211,2212,2213,2214,2215,2216,2217,2218,2219,2220,2221,2222,2223,2224,2225,2226,2227,2228,2229,2230,2231,2232)

Delete from FeeDetail Where FeeDetailUID in (597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618)


GO
SET IDENTITY_INSERT FeeDetail ON 

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
40452,
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
196,
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
40452,
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
197,
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
40452,
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
198,
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
40452,
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
199,
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
40452,
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
40452,
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
203,
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
40452,
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
206,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
604,
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
40452,
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
204,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
605,
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
40452,
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
205,
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
40452,
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
40452,
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
204,
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
40452,
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
204,
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
40452,
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
203,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
610,
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
40452,
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
201,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
611,
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
40452,
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
204,
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
40452,
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
203,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
613,
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
40452,
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
203,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
614,
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
40452,
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
200,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
615,
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
40452,
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
198,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
616,
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
40452,
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
198,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
617,
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
40452,
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
204,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END
Insert Into FeeDetail (FeeDetailUID,Additional_Remarks,PreDevelopment_Start,PreDevelopment_End,Development_StartDate,Expected_Completion,Total_Anticipated_Cost,PreDevelopment_Fee,Development_Fee,Total_TI_Area_RSF,Spec_Dollar_TI,Spec_Percent,
Signed_Dollar_TI,Signed_Percent,Building_Description_Capex,Total_Leasing_Area,Spec_Leasing_Dollar,Signed_Dollar,Property_Revenue,Implied_Mgmt_Fee,RecordType,CREATED,LastUpdated,
LastUpdatedBy,Leasing_Spec_Percent,Leasing_Signed_Percent,Asset_GAVBasis,Asset_FeePercentage,FeeTypeId,FeeCategoryId,SubRegionId,EntityId,RelatedFundId,CurrencyID,ReclassificationDesc,PropFundMRIDeptCodeMappingId,IsAdjustment)

Select 
618,
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
40452,
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
203,
CASE WHEN 'Yes' = 'Yes' THEN 1 ELSE 0 END




SET IDENTITY_INSERT FeeDetail OFF


GO
SET IDENTITY_INSERT FeeBudgetDetail ON


Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2211,
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
0,
0,
-239098,
-239098,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2212,
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
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2213,
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
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2214,
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
0,
-192261,
-229940,
-422201,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2215,
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
0,
0,
0,
-359627,
0,
-359627,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2216,
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
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2217,
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
-786196,
-786196,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2218,
CASE WHEN '604' = 'NULL' THEN NULL ELSE '604' END,
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
-4518910,
-4518910,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2219,
CASE WHEN '605' = 'NULL' THEN NULL ELSE '605' END,
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
-311315,
-311315,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2220,
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
-1482242,
-1482242,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2221,
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
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2222,
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
-240359,
-266965,
-507324,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2223,
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
0,
0,
0,
0,
0,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2224,
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
-1000000,
-1000000,
-1000000,
-3000000,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2225,
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
0,
-8847,
0,
-2800,
-11647,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2226,
CASE WHEN '612' = 'NULL' THEN NULL ELSE '612' END,
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
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2227,
CASE WHEN '613' = 'NULL' THEN NULL ELSE '613' END,
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
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2228,
CASE WHEN '614' = 'NULL' THEN NULL ELSE '614' END,
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
-469098,
-469098,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2229,
CASE WHEN '615' = 'NULL' THEN NULL ELSE '615' END,
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
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2230,
CASE WHEN '616' = 'NULL' THEN NULL ELSE '616' END,
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
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2231,
CASE WHEN '617' = 'NULL' THEN NULL ELSE '617' END,
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
-632264,
-248398,
-248398,
-1129060,
NULL,
getdate(),
getdate(),
5,
1
Insert Into FeeBudgetDetail (FeeBudgetDetailUID,FeeDetailUID,FeeYear,Version,isLocked,January,February,March,April,May,June,July,August,
September,October,November,December,YearlyTotal,Comments,Created,LastUpdated,FeeBudgetCycleUID,isActive)

Select 
2232,
CASE WHEN '618' = 'NULL' THEN NULL ELSE '618' END,
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
5,
1



SET IDENTITY_INSERT FeeBudgetDetail OFF
GO

SET IDENTITY_INSERT PropFundMRIDeptCodeMapping ON


IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 196)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Atlanta'
           ,196
           ,'014000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 197)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Boston'
           ,197
           ,'003001'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 198)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Brazil'
           ,198
           ,'012007'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 199)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Chicago'
           ,199
           ,'007000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 200)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP China'
           ,200
           ,'016000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 201)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Corporate'
           ,201
           ,'001000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 202)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP France'
           ,202
           ,'011000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 203)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP India'
           ,203
           ,'013000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 204)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP New York'
           ,204
           ,'002000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 205)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Northern California'
           ,205
           ,'006000'
           ,'PROPERTY'
           ,'UC')
GO

IF NOT EXISTS(Select * From [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping] Where PropFundMRIDeptCodeMappingId = 206)
 INSERT INTO [BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
           ([Name]
           ,PropFundMRIDeptCodeMappingId
           ,[CorporateMRIDeptCode]
           ,[Type]
           ,[CorporateMRISource])
     VALUES
           ('TSP Southern California'
           ,206
           ,'005000'
           ,'PROPERTY'
           ,'UC')
GO




SET IDENTITY_INSERT PropFundMRIDeptCodeMapping OFF

-- IMS 57410 ----------------------------------

UPDATE
	[BC_TS_GRINDER_Q3].[dbo].[Project]
SET
	NonPayrollCorporateMRIDepartmentCode = '012026',
	UpdatedDate = GETDATE(),
	UpdatedByStaffId = -1
WHERE
	ProjectId = 13751 AND
	Name = 'CN_BRAZIL FUND I (PORTFOLIO MGMT ALLOC)_Asset Mgmt' AND -- have name as condition to make sure that Id is correct
	NonPayrollCorporateMRIDepartmentCode = '021026'

GO
--------------

UPDATE
	[BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
SET
	CorporateMRIDeptCode = '011289',
	Name = 'Le Galilee (Suresnes)'
WHERE
	PropFundMRIDeptCodeMappingId = 104

GO
--------------

UPDATE
	[BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
SET
	CorporateMRIDeptCode = '011292'
WHERE
	PropFundMRIDeptCodeMappingId = 191

GO
--------------

UPDATE
	[BC_TS_GRINDER_Q3].[dbo].[PropFundMRIDeptCodeMapping]
SET
	CorporateMRIDeptCode = '016007'
WHERE
	PropFundMRIDeptCodeMappingId = 98

GO
-------------------------------------