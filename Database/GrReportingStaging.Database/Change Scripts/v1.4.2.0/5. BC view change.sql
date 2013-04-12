USE [BC]
GO

/****** Object:  View [dbo].[GlobalReportingCorporateBudget]    Script Date: 09/30/2010 12:51:42 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[GlobalReportingCorporateBudget]'))
DROP VIEW [dbo].[GlobalReportingCorporateBudget]
GO

USE [BC]
GO

/****** Object:  View [dbo].[GlobalReportingCorporateBudget]    Script Date: 09/30/2010 12:51:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[GlobalReportingCorporateBudget]
AS

Select 
	SourceUniqueKey,
    BudgetId,
	IsExpense,
	CONVERT(Varchar(2), SourceCode) SourceCode,
    BudgetYear,
    BudgetPeriodCode,
    LockedDate,
	Period,
	InternationalCurrencyCode,
	LocalAmount,
	GlobalGlAccountCode,
    FunctionalDepartment,
    FunctionalDepartmentGlobalCode,
    OriginatingSubRegion,
    OriginatingSubRegionCode,
    OriginatingRegion,
    OriginatingRegionCode,
	CONVERT(Varchar(10), NonPayrollCorporateMRIDepartmentCode) NonPayrollCorporateMRIDepartmentCode,
    AllocationSubRegion,
    AllocationSubRegionProjectRegionId, 
    AllocationRegion, 
    AllocationRegionGlobalRegionId, 
    IsReimbursable,
    JobCode,
    IsUnallocatedOverhead
    
From	(

---
--- Q0 Original Budget
---

--Project Group Non Payroll Expense Allocations
SELECT
    'BudgetId=' + CONVERT(varchar, 1)
        + '&Period=' + CONVERT(varchar, PG.Period) 
		+ '&BudgetPeriodCode=Q0' + 
        + '&NonPayrollExpenseId=' + CONVERT(varchar,NPE.NonPayrollExpenseId) 
        + '&FeeIncomeId=0'
        + '&ProjectId=' + CONVERT(varchar, Proj.ProjectId)
        + '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
        + '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code,''))
        + '&FunctionalDepartmentGlobalCode=' + CONVERT(varchar, IsNull(FD.GlobalCode,'')) as SourceUniqueKey,
    1 as BudgetId,
	1 as IsExpense,
    --todo this should be update to determine the source correctly 
    --i.e. from the corporate source
    --CASE WHEN (R.Name = 'USA') THEN 'UC' ELSE 'EC' END as SourceCode,
    IsNull(Proj.CorporateMRISource,'') as SourceCode,
    
    B.BudgetYear as BudgetYear,
    'Q0' as BudgetPeriodCode,
    B.LockedDate as LockedDate,

    PG.Period as Period,

    C.InternationalCurrencyCode as InternationalCurrencyCode,

    NPE.Amount * PG.Multiplier * ISNULL(PGA.Percentage,1) as LocalAmount,

    IsNull(GAM.GlobalAccountKey,0) as GlobalGlAccountCode,

    IsNull(FD.Name,'') as FunctionalDepartment,
    IsNull(FD.GlobalCode,'') as FunctionalDepartmentGlobalCode,

    IsNull(ESR.Name,'') as OriginatingSubRegion,
    IsNull(ESR.Code,'') as OriginatingSubRegionCode,

    IsNull(ER.Name,'') as OriginatingRegion,
    IsNull(ER.Code,'') as OriginatingRegionCode,

    --AT.Code as ActivityTypeCode,

    --E.Name as EntityName,
    --E.PropertyFundId as EntityPropertyFundId, 
    --this should map back to TAPAS, I am concerned 
    --that this is incorrect and that we should really be using and Entity Ref or some other code
	IsNull(Proj.NonPayrollCorporateMRIDepartmentCode,'') as NonPayrollCorporateMRIDepartmentCode,
	
    --not positive about us giving this is this should be a lookup off of the Entity
    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 
    --this should map back to TAPAS, I am concerned about
    --this approach however and that we should have some form of coding for this.

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 
    --this should map back to TAPAS, I am concerned about this approach we should be
    --using some form of code here I would think

    Proj.NonPayrollReimbursable as IsReimbursable,

    IsNull(JC.Code,'') as JobCode,
    0 IsUnallocatedOverhead

FROM NonPayrollExpense NPE
      
    INNER JOIN Budget B ON  
        NPE.BudgetId = B.BudgetId

    INNER JOIN ProjectGroup ProjG ON
        NPE.ProjectGroupId = ProjG.ProjectGroupId
        
    INNER JOIN ProjectGroupAllocation PGA ON
        ProjG.ProjectGroupId = PGA.ProjectGroupId

    INNER JOIN Project Proj ON
        PGA.ProjectId = Proj.ProjectId
        
    INNER JOIN GLType GLT ON 
        NPE.GLTypeId = GLT.GLTypeId

    INNER JOIN PeriodGroup PG ON
        NPE.PeriodGroup = PG.PeriodGroup

    LEFT OUTER JOIN SubRegion SR ON
        Proj.SubRegionId = SR.SubRegionId

    LEFT OUTER JOIN Region R ON
        Proj.RegionId = R.RegionId

    LEFT OUTER JOIN GlobalAccountMappingLookup GLAC ON
        NPE.GLTypeId = GLAC.GLTypeId AND
        Proj.ActivityTypeId = GLAC.ActivityTypeId

    LEFT OUTER JOIN GlobalAccountMapping GAM ON
        GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    INNER JOIN ActivityType AT ON
        Proj.ActivityTypeId = AT.ActivityTypeId

    LEFT OUTER JOIN FunctionalDepartment FD ON
        NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId

    LEFT OUTER JOIN EmployeeSubRegion ESR ON
        NPE.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN EmployeeRegion ER ON
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN Currency C ON 
        NPE.CurrencyId = C.CurrencyId
        
    LEFT OUTER JOIN JobCode JC ON
        NPE.JobCodeId = JC.JobCodeId

WHERE B.IsLocked = 1 AND 
    --Need to exclude Overheads
    (
        --exclude 99 activity types
        AT.Code <> '99'
        
        --exclude specific 99 GL Account Codes where the expense is 
        --is not a 99 activity expense.
        AND RIGHT(GlobalAccountKey,2) <> '99'
        
        --exclude based on specific GL Codes for particular departments
        AND NOT
        (
            GAM.GlobalAccountKey IN
                (
                '5101000012',
                '5202000012',
                '5326000012',
                '5309100012',
                '5303100012',
                '5303000012',
                '5203000000',
                '5207000000',
                '5210000000',
                '5305000000',
                '5489000000',
                '6401000000',
                '6503000000',
                '5316100012',
                '5316000012',
                '5312100012',
                '5312000012',
                '5020100012',
                '5020600012'
                ) AND
            ISNULL(FD.GlobalCode,'') IN
                (
                'OFS',  --office services
                'REX'   --regional executive
                )
        )
        
        --exclude particular expense types (for IT costs & Other)
        AND NOT
        (
            GLT.Name IN
            (
            'Printers – 955020',
            'Other Leased Computer Equip – 955040',
            'Computer Supplies – 955300',
            'Video Conferencing Expenses – 956470',
            'Land Telephone Expenses – 956600',
            --new exclusions
            'Base Rent',
            'Operating Escalation',
            'Utilities',
            'Cleaning, Maintenance & Repairs',
            'Lease Storage Space',
            'Lease Office Space',
            'Commercial Rent & Occ Tax',
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '12'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '01'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '02'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '04'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '06'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Lease Storage Space'
            ) AND 
            AT.Code = '06'
        )
    )
        
UNION ALL

--Project Non Payroll Expense Allocations
SELECT
    'BudgetId=' + CONVERT(varchar, 1)
        + '&Period=' + CONVERT(varchar, PG.Period) 
		+ '&BudgetPeriodCode=Q0' + 
        + '&NonPayrollExpenseId=' + CONVERT(varchar,NPE.NonPayrollExpenseId) 
        + '&FeeIncomeId=0'
        + '&ProjectId=' + CONVERT(varchar, Proj.ProjectId)
        + '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
        + '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code,''))
        + '&FunctionalDepartmentGlobalCode=' + CONVERT(varchar, IsNull(FD.GlobalCode,'')) as SourceUniqueKey,

    1 as BudgetId,
	1 as IsExpense,
    --todo this should be update to determine the source correctly 
    --i.e. from the corporate source
    --CASE WHEN (R.Name = 'USA') THEN 'UC' ELSE 'EC' END as SourceCode,
	IsNull(Proj.CorporateMRISource,'') as SourceCode,
    
    B.BudgetYear as BudgetYear,
    'Q0' as BudgetPeriodCode,
    B.LockedDate as LockedDate,

    PG.Period as Period,

    C.InternationalCurrencyCode as InternationalCurrencyCode,

    NPE.Amount * PG.Multiplier as LocalAmount,

    IsNull(GAM.GlobalAccountKey,0) as GlobalGlAccountCode,

    IsNull(FD.Name,'') as FunctionalDepartment,
    IsNull(FD.GlobalCode,'') as FunctionalDepartmentGlobalCode,

    IsNull(ESR.Name,'') as OriginatingSubRegion,
    IsNull(ESR.Code,'') as OriginatingSubRegionCode,

    IsNull(ER.Name,'') as OriginatingRegion,
    IsNull(ER.Code,'') as OriginatingRegionCode,

    --AT.Code as ActivityTypeCode,

    --E.Name as EntityName,
    --E.PropertyFundId as EntityPropertyFundId, 
    --this should map back to TAPAS, I am concerned 
    --that this is incorrect and that we should really be using and Entity Ref or some other code

	IsNull(Proj.NonPayrollCorporateMRIDepartmentCode,'') as NonPayrollCorporateMRIDepartmentCode,

    --not positive about us giving this is this should be a lookup off of the Entity
    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 
    --this should map back to TAPAS, I am concerned about
    --this approach however and that we should have some form of coding for this.

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 
    --this should map back to TAPAS, I am concerned about this approach we should be
    --using some form of code here I would think

    Proj.NonPayrollReimbursable as IsReimbursable, 

    IsNull(JC.Code,'') as JobCode,
    0 IsUnallocatedOverhead

FROM NonPayrollExpense NPE
            
    INNER JOIN Budget B ON  
        NPE.BudgetId = B.BudgetId
      
    INNER JOIN Project Proj ON
        NPE.ProjectId = Proj.ProjectId

    INNER JOIN GLType GLT ON 
        NPE.GLTypeId = GLT.GLTypeId

    INNER JOIN PeriodGroup PG ON
        NPE.PeriodGroup = PG.PeriodGroup

    LEFT OUTER JOIN SubRegion SR ON
        Proj.SubRegionId = SR.SubRegionId

    LEFT OUTER JOIN Region R ON
        Proj.RegionId = R.RegionId

    LEFT OUTER JOIN GlobalAccountMappingLookup GLAC ON
        NPE.GLTypeId = GLAC.GLTypeId AND
        Proj.ActivityTypeId = GLAC.ActivityTypeId

    LEFT OUTER JOIN GlobalAccountMapping GAM ON
        GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    INNER JOIN ActivityType AT ON
        Proj.ActivityTypeId = AT.ActivityTypeId

    LEFT OUTER JOIN FunctionalDepartment FD ON
        NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId

    LEFT OUTER JOIN EmployeeSubRegion ESR ON
        NPE.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN EmployeeRegion ER ON
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN Currency C ON 
        NPE.CurrencyId = C.CurrencyId
      
    LEFT OUTER JOIN JobCode JC ON
        NPE.JobCodeId = JC.JobCodeId

WHERE B.IsLocked = 1 AND 
    --Need to exclude Overheads
    (
        --exclude 99 activity types
        AT.Code <> '99'
        
        AND RIGHT(GlobalAccountKey,2) <> '99'
        
        --exclude based on specific GL Codes for particular departments
        AND NOT
        (
            GAM.GlobalAccountKey IN
                (
                '5101000012',
                '5202000012',
                '5326000012',
                '5309100012',
                '5303100012',
                '5303000012',
                '5203000000',
                '5207000000',
                '5210000000',
                '5305000000',
                '5489000000',
                '6401000000',
                '6503000000',
                '5316100012',
                '5316000012',
                '5312100012',
                '5312000012',
                '5020100012',
                '5020600012'
                ) AND
            ISNULL(FD.GlobalCode,'') IN
                (
                'OFS',  --office services
                'REX'   --regional executive
                )
        )
        
        --exclude particular expense types (for IT costs)
        --exclude particular expense types (for IT costs & Other)
        AND NOT
        (
            GLT.Name IN
            (
            'Printers – 955020',
            'Other Leased Computer Equip – 955040',
            'Computer Supplies – 955300',
            'Video Conferencing Expenses – 956470',
            'Land Telephone Expenses – 956600',
            --new exclusions
            'Base Rent',
            'Operating Escalation',
            'Utilities',
            'Cleaning, Maintenance & Repairs',
            'Lease Storage Space',
            'Lease Office Space',
            'Commercial Rent & Occ Tax',
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '12'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '01'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '02'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '04'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Misc. Marketing & Leasing Expense'
            ) AND 
            AT.Code = '06'
        )
        AND NOT
        (
            GLT.Name IN
            (
            'Lease Storage Space'
            ) AND 
            AT.Code = '06'
        )
    )

UNION ALL

--Fee Income Data
SELECT
    'BudgetId=' + CONVERT(varchar, 1)
        + '&Period=' + CONVERT(varchar, PG.Period) 
		+ '&BudgetPeriodCode=Q0' + 
        + '&NonPayrollExpenseId=0'
        + '&FeeIncomeId=' + CONVERT(varchar,FI.FeeIncomeId) 
        + '&ProjectId=0'
        + '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
        + '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code,''))
        + '&FunctionalDepartmentGlobalCode=0' as SourceUniqueKey,

    1 as BudgetId,
	0 as IsExpense,
    --todo this should be update to determine the source correctly 
    --i.e. from the corporate source
    --CASE WHEN (R.Name = 'USA') THEN 'UC' ELSE 'EC' END as SourceCode,
    IsNull(FI.CorporateMRISource,'') as SourceCode, 
    
    B.BudgetYear as BudgetYear,
    'Q0' as BudgetPeriodCode,
    B.LockedDate as LockedDate,

    PG.Period as Period,

    C.InternationalCurrencyCode as InternationalCurrencyCode,

    FI.Amount * PG.Multiplier as LocalAmount,

    IsNull(GAM.GlobalAccountKey,0) as GlobalGlAccountCode,

	--fees do not have an origianting functional department
    '' as FunctionalDepartment,
    '' as FunctionalDepartmentGlobalCode,

    IsNull(ESR.Name,'') as OriginatingSubRegion,
    IsNull(ESR.Code,'') as OriginatingSubRegionCode,

    IsNull(ER.Name,'') as OriginatingRegion,
    IsNull(ER.Code,'') as OriginatingRegionCode,

    --AT.Code as ActivityTypeCode,

    --E.Name as EntityName,
    --E.PropertyFundId as EntityPropertyFundId, 
    --this should map back to TAPAS, I am concerned 
    --that this is incorrect and that we should really be using and Entity Ref or some other code

	IsNull(FI.CorporateMRIDepartmentCode,''),

    --not positive about us giving this is this should be a lookup off of the Entity
    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 
    --this should map back to TAPAS, I am concerned about
    --this approach however and that we should have some form of coding for this.

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 
    --this should map back to TAPAS, I am concerned about this approach we should be
    --using some form of code here I would think

    0 as IsReimbursable, 

    '' as JobCode,
    0 IsUnallocatedOverhead

FROM FeeIncome FI
            
    INNER JOIN Budget B ON  
        FI.BudgetId = B.BudgetId
    
    INNER JOIN PeriodGroup PG ON
        FI.PeriodGroup = PG.PeriodGroup

    LEFT OUTER JOIN SubRegion SR ON
        FI.SubRegionId = SR.SubRegionId

    LEFT OUTER JOIN Region R ON
        FI.RegionId = R.RegionId

    LEFT OUTER JOIN GlobalAccountMappingLookupFee GLAC ON
        FI.FeeTypeId = GLAC.FeeTypeId AND
        FI.FeeSubCategoryId = GLAC.FeeSubCategoryId

    LEFT OUTER JOIN GlobalAccountMapping GAM ON
        GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    LEFT OUTER JOIN EmployeeSubRegion ESR ON
        FI.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN EmployeeRegion ER ON
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN Currency C ON 
        FI.CurrencyId = C.CurrencyId

WHERE B.IsLocked = 1 --AND 
    --Need to exclude Overheads
--    (
--        --exclude 99 activity types
--        AT.Code <> '99'
--    )
        
--------------------------------------------------------------------------------------
--- Q1 Reforecast
--------------------------------------------------------------------------------------

UNION ALL

SELECT
	'BudgetId=' + CONVERT(varchar, NPC.NonPayrollCycleUID)
		+ '&Period=' +	CASE NPED.Period 
							WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
							WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
							WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
							WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
							WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
							WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
							WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
							WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
							WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
							WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
							WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
							WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12' END
		+ '&BudgetPeriodCode=Q1' + 
		+ '&NonPayrollExpenseId=' + CONVERT(varchar, NPE.NonPayrollExpenseId)
		+ '&FeeIncomeId=0'
		+ '&ProjectId=' + CONVERT(varchar, Proj.ProjectId)
		+ '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
		+ '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code, ''))
		+ '&FunctionalDepartmentGlobalCode=' + CONVERT(varchar, IsNull(FD.GlobalCode, '')) AS SourceUniqueKey,
    --Using the NonPayrollCycle here rather than the old budget
	NPC.NonPayrollCycleUID AS BudgetId,
	1 AS IsExpense,
	IsNull(Proj.CorporateMriSource,'') AS SourceCode, 
	NPC.BudgetYear AS BudgetYear,
	NPC.BudgetPeriodCode AS BudgetPeriodCode,
	NPC.AvailableDate AS LockedDate,
	CASE NPED.Period 
		WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
		WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
		WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
		WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
		WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
		WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
		WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
		WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
		WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
		WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
		WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
		WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12'
	END AS Period,

	C.InternationalCurrencyCode AS InternationalCurrencyCode,

	NPED.Amount * ISNULL(PGA.Percentage,1) AS LocalAmount,
	
	IsNull(GAM.GlobalAccountKey,0) AS GlobalGLAccountCode,
	IsNull(FD.Name,'') AS FunctionalDepartment,
	IsNull(FD.GlobalCode,'') AS FunctionalDepartmentGlobalCode,
	IsNull(ESR.Name,'') AS OriginatingSubRegion,
	IsNull(ESR.Code,'') AS OriginatingSubRegionCode,
	IsNull(ER.Name,'') AS OriginatingRegion,
	IsNull(ER.Code,'') AS OriginatingRegionCode,
	
	IsNull(Proj.NonPayrollCorporateMRIDepartmentCode,'') as NonPayrollCorporateMRIDepartmentCode,

    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 

    Proj.NonPayrollReimbursable as IsReimbursable,
    IsNull(JC.Code,'') as JobCode,
    CASE WHEN NPE.Overhead = 0 THEN 0 ELSE 1 END IsUnallocatedOverhead

FROM 
	BC_TS_GRINDER_Q1.dbo.NonPayrollExpenseDetail

    --We need to unpivot to turn the local amounts into rows rather than columns
	UNPIVOT (Amount FOR Period IN (JanuaryLocal, FebruaryLocal, MarchLocal, AprilLocal, MayLocal, JuneLocal, JulyLocal, AugustLocal, SeptemberLocal, OctoberLocal, NovemberLocal, DecemberLocal)) AS NPED

	INNER JOIN BC_TS_GRINDER_Q1.dbo.NonPayrollExpense NPE ON
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId	

	INNER JOIN BC_TS_GRINDER_Q1.dbo.NonPayrollCycle NPC ON
		NPED.NonPayrollCycleUID = NPC.NonPayrollCycleUID
/* -- Doesn't seem like they are using versioning for non-payroll, yet.
	INNER JOIN (
		SELECT NonPayrollCycleUID, max(Version) as Version
		FROM BC_TS_GRINDER_Q1.dbo.NonPayrollExpenseDetail
		GROUP BY NonPayrollCycleUID
	) NPEDV ON
		NPED.NonPayrollCycleUID = NPEDV.NonPayrollCycleUID AND
		NPED.Version = NPEDV.Version
*/
	INNER JOIN BC_TS_GRINDER_Q1.dbo.ProjectGroup PG ON
		NPE.ProjectGroupId = PG.ProjectGroupId

	INNER JOIN BC_TS_GRINDER_Q1.dbo.ProjectGroupAllocation PGA ON
		PG.ProjectGroupId = PGA.ProjectGroupId

	INNER JOIN BC_TS_GRINDER_Q1.dbo.Project Proj ON
		PGA.ProjectId = Proj.ProjectId

    INNER JOIN BC_TS_GRINDER_Q1.dbo.GLType GLT ON 
        NPE.GLTypeId = GLT.GLTypeId
	
    INNER JOIN BC_TS_GRINDER_Q1.dbo.ActivityType AT ON
        Proj.ActivityTypeId = AT.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.GlobalAccountMappingLookup GLAC ON
		NPE.GLTypeId = GLAC.GLTypeId AND
		Proj.ActivityTypeId = GLAC.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.GlobalAccountMapping GAM ON
		GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.FunctionalDepartment FD ON
        NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.EmployeeSubRegion ESR ON
        NPE.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.EmployeeRegion ER ON
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN BC_TS_GRINDER_Q1.dbo.Currency C ON 
        NPE.CurrencyId = C.CurrencyId
        
    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.JobCode JC ON
        NPE.JobCodeId = JC.JobCodeId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.SubRegion SR ON
        Proj.SubRegionId = SR.SubRegionId

	LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.Region R ON
		Proj.RegionId = R.RegionId		
WHERE
	NPC.IsAvailable = 1 AND NPC.AvailableDate IS NOT NULL AND NPC.BudgetPeriodCode = 'Q1' AND
	NPE.Overhead = 0

UNION ALL

SELECT
	'BudgetId=' + CONVERT(varchar, NPC.NonPayrollCycleUID)
		+ '&Period=' +	CASE NPED.Period 
							WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
							WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
							WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
							WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
							WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
							WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
							WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
							WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
							WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
							WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
							WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
							WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12' END
		+ '&BudgetPeriodCode=Q1' + 		
		+ '&NonPayrollExpenseId=' + CONVERT(varchar, NPE.NonPayrollExpenseId)
		+ '&FeeIncomeId=0'
		+ '&ProjectId=' + CONVERT(varchar, Proj.ProjectId)
		+ '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
		+ '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code, ''))
		+ '&FunctionalDepartmentGlobalCode=' + CONVERT(varchar, IsNull(FD.GlobalCode, '')) AS SourceUniqueKey,
    --Use the NonPayrollCycle here rather than the old budget
	NPC.NonPayrollCycleUID AS BudgetId,
	1 AS IsExpense,
	IsNull(Proj.CorporateMriSource,'') AS SourceCode, 
	NPC.BudgetYear AS BudgetYear,
	NPC.BudgetPeriodCode AS BudgetPeriodCode,
	NPC.AvailableDate AS LockedDate,
	
	CASE NPED.Period 
		WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
		WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
		WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
		WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
		WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
		WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
		WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
		WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
		WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
		WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
		WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
		WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12'
	END AS Period,

	C.InternationalCurrencyCode AS InternationalCurrencyCode,

	NPED.Amount as LocalAmount,
	
	IsNull(GAM.GlobalAccountKey,0) AS GlobalGLAccountCode,
	IsNull(FD.Name,'') AS FunctionalDepartment,
	IsNull(FD.GlobalCode,'') AS FunctionalDepartmentGlobalCode,
	IsNull(ESR.Name,'') AS OriginatingSubRegion,
	IsNull(ESR.Code,'') AS OriginatingSubRegionCode,
	IsNull(ER.Name,'') AS OriginatingRegion,
	IsNull(ER.Code,'') AS OriginatingRegionCode,
	
	IsNull(Proj.NonPayrollCorporateMRIDepartmentCode,'') as NonPayrollCorporateMRIDepartmentCode,

    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 

    Proj.NonPayrollReimbursable as IsReimbursable,
    IsNull(JC.Code,'') as JobCode,
    CASE WHEN NPE.Overhead = 0 THEN 0 ELSE 1 END IsUnallocatedOverhead

FROM 
	BC_TS_GRINDER_Q1.dbo.NonPayrollExpenseDetail

    --We need to unpivot to turn the local amounts into rows rather than columns
	UNPIVOT (Amount FOR Period IN (JanuaryLocal, FebruaryLocal, MarchLocal, AprilLocal, MayLocal, JuneLocal, JulyLocal, AugustLocal, SeptemberLocal, OctoberLocal, NovemberLocal, DecemberLocal)) AS NPED

	INNER JOIN BC_TS_GRINDER_Q1.dbo.NonPayrollExpense NPE ON
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId	

	INNER JOIN BC_TS_GRINDER_Q1.dbo.NonPayrollCycle NPC ON
		NPED.NonPayrollCycleUID = NPC.NonPayrollCycleUID
/* -- Doesn't seem like they are using versioning for non-payroll, yet.
	INNER JOIN (
		SELECT NonPayrollCycleUID, max(Version) as Version
		FROM BC_TS_GRINDER_Q1.dbo.NonPayrollExpenseDetail
		GROUP BY NonPayrollCycleUID
	) NPEDV ON
		NPED.NonPayrollCycleUID = NPEDV.NonPayrollCycleUID AND
		NPED.Version = NPEDV.Version
*/
	INNER JOIN BC_TS_GRINDER_Q1.dbo.Project Proj ON
		NPE.ProjectId = Proj.ProjectId

    INNER JOIN BC_TS_GRINDER_Q1.dbo.GLType GLT ON 
        NPE.GLTypeId = GLT.GLTypeId
	
    INNER JOIN BC_TS_GRINDER_Q1.dbo.ActivityType AT ON
        Proj.ActivityTypeId = AT.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.GlobalAccountMappingLookup GLAC ON
		NPE.GLTypeId = GLAC.GLTypeId AND
		Proj.ActivityTypeId = GLAC.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.GlobalAccountMapping GAM ON
		GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.FunctionalDepartment FD ON
        NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.EmployeeSubRegion ESR ON
        NPE.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.EmployeeRegion ER ON
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN BC_TS_GRINDER_Q1.dbo.Currency C ON 
        NPE.CurrencyId = C.CurrencyId
        
    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.JobCode JC ON
        NPE.JobCodeId = JC.JobCodeId

    LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.SubRegion SR ON
        Proj.SubRegionId = SR.SubRegionId

	LEFT OUTER JOIN BC_TS_GRINDER_Q1.dbo.Region R ON
		Proj.RegionId = R.RegionId		
WHERE
	NPC.IsAvailable = 1 AND NPC.AvailableDate IS NOT NULL AND NPC.BudgetPeriodCode = 'Q1' AND
	NPE.Overhead = 0

UNION ALL

-- Fees
SELECT
	'BudgetId=' + CONVERT(varchar, FBC.NonPayrollCycleUID)
		+ '&Period=' +	CASE FBD.Period 
							WHEN 'January' THEN CAST(FBC.BudgetYear AS char(4)) + '01'
							WHEN 'February' THEN CAST(FBC.BudgetYear AS char(4)) + '02'
							WHEN 'March' THEN CAST(FBC.BudgetYear AS char(4)) + '03'
							WHEN 'April' THEN CAST(FBC.BudgetYear AS char(4)) + '04'
							WHEN 'May' THEN CAST(FBC.BudgetYear AS char(4)) + '05'
							WHEN 'June' THEN CAST(FBC.BudgetYear AS char(4)) + '06'
							WHEN 'July' THEN CAST(FBC.BudgetYear AS char(4)) + '07'
							WHEN 'August' THEN CAST(FBC.BudgetYear AS char(4)) + '08'
							WHEN 'September' THEN CAST(FBC.BudgetYear AS char(4)) + '09'
							WHEN 'October' THEN CAST(FBC.BudgetYear AS char(4)) + '10'
							WHEN 'November' THEN CAST(FBC.BudgetYear AS char(4)) + '11'
							WHEN 'December' THEN CAST(FBC.BudgetYear AS char(4)) + '12' END
		+ '&BudgetPeriodCode=Q1' + 		
		+ '&NonPayrollExpenseId=0'  
		+ '&FeeIncomeId=' + CONVERT(varchar, FBD.FeeBudgetDetailUID)
		+ '&ProjectId=0' 
		+ '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
		+ '&OriginatingSubRegionCode=0'
		+ '&FunctionalDepartmentGlobalCode=0' AS SourceUniqueKey,
    --Needs to link to the NonPayrollCycle here because it needs to be from the same grouping.
	FBC.NonPayrollCycleUID AS BudgetId,
	0 AS IsExpense,
	IsNull(PFDCM.CorporateMRISource,'') as SourceCode,
	FBC.BudgetYear AS BudgetYear,
	FBC.BudgetPeriodCode AS BudgetPeriodCode,
	FBC.AvailableDate AS LockedDate, 
	--I know this is messy but we need the 6 digit period value for this
	CASE FBD.Period 
		WHEN 'January' THEN CAST(FBC.BudgetYear AS char(4)) + '01'
		WHEN 'February' THEN CAST(FBC.BudgetYear AS char(4)) + '02'
		WHEN 'March' THEN CAST(FBC.BudgetYear AS char(4)) + '03'
		WHEN 'April' THEN CAST(FBC.BudgetYear AS char(4)) + '04'
		WHEN 'May' THEN CAST(FBC.BudgetYear AS char(4)) + '05'
		WHEN 'June' THEN CAST(FBC.BudgetYear AS char(4)) + '06'
		WHEN 'July' THEN CAST(FBC.BudgetYear AS char(4)) + '07'
		WHEN 'August' THEN CAST(FBC.BudgetYear AS char(4)) + '08'
		WHEN 'September' THEN CAST(FBC.BudgetYear AS char(4)) + '09'
		WHEN 'October' THEN CAST(FBC.BudgetYear AS char(4)) + '10'
		WHEN 'November' THEN CAST(FBC.BudgetYear AS char(4)) + '11'
		WHEN 'December' THEN CAST(FBC.BudgetYear AS char(4)) + '12'
	END AS Period,

	C.InternationalCurrencyCode AS InternationalCurrencyCode,

	FBD.Amount AS LocalAmount,
	
	IsNull(GAM.GlobalAccountKey,0) AS GlobalGLAccountCode,
	-- Fees do not have functional departments
	'' AS FunctionalDepartment,
	'' AS FunctionalDepartmentGlobalCode,
	-- Don't have originating region for fees
	'' AS OriginatingSubRegion,
	'' AS OriginatingSubRegionCode,
	'' AS OriginatingRegion,
	'' AS OriginatingRegionCode,
	IsNull(PFDCM.CorporateMRIDeptCode,'') as NonPayrollCorporateMRIDepartmentCode,

    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 

	-- Don't have for fees (debug information only get off sub region)
    '' as AllocationRegion, 
    '' as AllocationRegionGlobalRegionId, 

    0 as IsReimbursable,
    '' as JobCode,
    0 IsUnallocatedOverhead

FROM 
	BC_TS_GRINDER_Q1_1.dbo.FeeBudgetDetail 

    --We need to unpivot to turn the local amounts into rows rather than columns
	UNPIVOT (Amount FOR Period IN (January, February, March, April, May, June, July, August, September, October, November, December)) AS FBD

	INNER JOIN BC_TS_GRINDER_Q1_1.dbo.FeeDetail FeeD ON
		FBD.FeeDetailUID = FeeD.FeeDetailUID
		
	LEFT OUTER JOIN BC_TS_GRINDER_Q1_1.dbo.PropFundMRIDeptCodeMapping PFDCM ON
		FeeD.PropFundMRIDeptCodeMappingId = PFDCM.PropFundMRIDeptCodeMappingId

	INNER JOIN BC_TS_GRINDER_Q1_1.dbo.FeeBudgetCycle FBC ON
		FBD.FeeBudgetCycleUID = FBC.FeeBudgetCycleUID
/* -- Doesn't seem like they are using versioning for fees, yet. 
	INNER JOIN (
		SELECT FeeBudgetCycleUID, max(Version) as Version
		FROM BC_TS_GRINDER_Q1.dbo.FeeBudgetDetail
		WHERE IsActive = 1
		GROUP BY FeeBudgetCycleUID
	) FBDV ON
		FBD.FeeBudgetCycleUID = FBDV.FeeBudgetCycleUID AND
		FBD.Version = FBDV.Version
*/
    LEFT OUTER JOIN BC_TS_GRINDER_Q1_1.dbo.GlobalAccountMappingLookupFee GLAC ON
        IsNull(FeeD.FeeTypeId,0) = GLAC.FeeTypeUID AND
        IsNull(FeeD.FeeCategoryId,0) = GLAC.FeeCategoryUID

	LEFT OUTER JOIN BC_TS_GRINDER_Q1_1.dbo.GlobalAccountMapping GAM ON
		GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    INNER JOIN BC_TS_GRINDER_Q1_1.dbo.Currency C ON 
        FeeD.CurrencyId = C.CurrencyId
    
    LEFT OUTER JOIN BC_TS_GRINDER_Q1_1.dbo.SubRegion SR ON
        FeeD.SubRegionId = SR.SubRegionId

WHERE
	FBC.IsAvailable = 1 AND 
	FBC.AvailableDate IS NOT NULL AND FBC.BudgetPeriodCode = 'Q1' AND
	FBC.NonPayrollCycleUID IS NOT NULL
	
	
UNION ALL
--------------------------------------------------------------------------------------
--- Q2 Reforecast
--------------------------------------------------------------------------------------

SELECT
	'BudgetId=' + CONVERT(varchar, NPC.NonPayrollCycleUID)
		+ '&Period=' +	CASE NPED.Period 
							WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
							WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
							WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
							WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
							WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
							WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
							WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
							WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
							WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
							WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
							WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
							WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12' END
		+ '&BudgetPeriodCode=Q2' + 
		+ '&NonPayrollExpenseId=' + CONVERT(varchar, NPE.NonPayrollExpenseId)
		+ '&FeeIncomeId=0'
		+ '&ProjectId=' + CONVERT(varchar, Proj.ProjectId)
		+ '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
		+ '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code, ''))
		+ '&FunctionalDepartmentGlobalCode=' + CONVERT(varchar, IsNull(FD.GlobalCode, '')) AS SourceUniqueKey,
    --Using the NonPayrollCycle here rather than the old budget
	NPC.NonPayrollCycleUID AS BudgetId,
	1 AS IsExpense,
	IsNull(Proj.CorporateMriSource,'') AS SourceCode, 
	NPC.BudgetYear AS BudgetYear,
	NPC.BudgetPeriodCode AS BudgetPeriodCode,
	NPC.AvailableDate AS LockedDate,
	CASE NPED.Period 
		WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
		WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
		WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
		WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
		WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
		WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
		WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
		WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
		WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
		WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
		WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
		WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12'
	END AS Period,

	C.InternationalCurrencyCode AS InternationalCurrencyCode,

	NPED.Amount * ISNULL(PGA.Percentage,1) AS LocalAmount,
	
	IsNull(GAM.GlobalAccountKey,0) AS GlobalGLAccountCode,
	IsNull(FD.Name,'') AS FunctionalDepartment,
	IsNull(FD.GlobalCode,'') AS FunctionalDepartmentGlobalCode,
	IsNull(ESR.Name,'') AS OriginatingSubRegion,
	IsNull(ESR.Code,'') AS OriginatingSubRegionCode,
	IsNull(ER.Name,'') AS OriginatingRegion,
	IsNull(ER.Code,'') AS OriginatingRegionCode,
	
	IsNull(Proj.NonPayrollCorporateMRIDepartmentCode,'') as NonPayrollCorporateMRIDepartmentCode,

    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 

    Proj.NonPayrollReimbursable as IsReimbursable,
    IsNull(JC.Code,'') as JobCode,
    CASE WHEN NPE.Overhead = 0 THEN 0 ELSE 1 END IsUnallocatedOverhead

FROM 
	BC_TS_GRINDER_Q2.dbo.NonPayrollExpenseDetail --

    --We need to unpivot to turn the local amounts into rows rather than columns
	UNPIVOT (Amount FOR Period IN (JanuaryLocal, FebruaryLocal, MarchLocal, AprilLocal, MayLocal, JuneLocal, JulyLocal, AugustLocal, SeptemberLocal, OctoberLocal, NovemberLocal, DecemberLocal)) AS NPED

	INNER JOIN BC_TS_GRINDER_Q2.dbo.NonPayrollExpense NPE ON  
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId	

	INNER JOIN BC_TS_GRINDER_Q2.dbo.NonPayrollCycle NPC ON  
		NPED.NonPayrollCycleUID = NPC.NonPayrollCycleUID
/* -- Doesn't seem like they are using versioning for non-payroll, yet.
	INNER JOIN (
		SELECT NonPayrollCycleUID, max(Version) as Version
		FROM BC_TS_GRINDER_Q1.dbo.NonPayrollExpenseDetail
		GROUP BY NonPayrollCycleUID
	) NPEDV ON
		NPED.NonPayrollCycleUID = NPEDV.NonPayrollCycleUID AND
		NPED.Version = NPEDV.Version
*/
	INNER JOIN BC_TS_GRINDER_Q2.dbo.ProjectGroup PG ON  
		NPE.ProjectGroupId = PG.ProjectGroupId

	INNER JOIN BC_TS_GRINDER_Q2.dbo.ProjectGroupAllocation PGA ON  
		PG.ProjectGroupId = PGA.ProjectGroupId

	INNER JOIN BC_TS_GRINDER_Q2.dbo.Project Proj ON  
		PGA.ProjectId = Proj.ProjectId

    INNER JOIN BC_TS_GRINDER_Q2.dbo.GLType GLT ON 
        NPE.GLTypeId = GLT.GLTypeId
	
    INNER JOIN BC_TS_GRINDER_Q2.dbo.ActivityType AT ON  
        Proj.ActivityTypeId = AT.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.GlobalAccountMappingLookup GLAC ON  
		NPE.GLTypeId = GLAC.GLTypeId AND
		Proj.ActivityTypeId = GLAC.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.GlobalAccountMapping GAM ON  
		GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.FunctionalDepartment FD ON  
        NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.EmployeeSubRegion ESR ON  
        NPE.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.EmployeeRegion ER ON  
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN BC_TS_GRINDER_Q2.dbo.Currency C ON   
        NPE.CurrencyId = C.CurrencyId
        
    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.JobCode JC ON  
        NPE.JobCodeId = JC.JobCodeId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.SubRegion SR ON  
        Proj.SubRegionId = SR.SubRegionId

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.Region R ON  
		Proj.RegionId = R.RegionId		
WHERE
	NPC.IsAvailable = 1 AND NPC.AvailableDate IS NOT NULL AND NPC.BudgetPeriodCode = 'Q2'-- AND
	--Change Control 1 :: GC 
	--NPE.Overhead = 0

UNION ALL

SELECT
	'BudgetId=' + CONVERT(varchar, NPC.NonPayrollCycleUID)
		+ '&Period=' +	CASE NPED.Period 
							WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
							WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
							WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
							WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
							WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
							WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
							WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
							WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
							WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
							WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
							WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
							WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12' END
		+ '&BudgetPeriodCode=Q2' + 		
		+ '&NonPayrollExpenseId=' + CONVERT(varchar, NPE.NonPayrollExpenseId)
		+ '&FeeIncomeId=0'
		+ '&ProjectId=' + CONVERT(varchar, Proj.ProjectId)
		+ '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
		+ '&OriginatingSubRegionCode=' + CONVERT(varchar, IsNull(ESR.Code, ''))
		+ '&FunctionalDepartmentGlobalCode=' + CONVERT(varchar, IsNull(FD.GlobalCode, '')) AS SourceUniqueKey,
    --Use the NonPayrollCycle here rather than the old budget
	NPC.NonPayrollCycleUID AS BudgetId,
	1 AS IsExpense,
	IsNull(Proj.CorporateMriSource,'') AS SourceCode, 
	NPC.BudgetYear AS BudgetYear,
	NPC.BudgetPeriodCode AS BudgetPeriodCode,
	NPC.AvailableDate AS LockedDate,
	
	CASE NPED.Period 
		WHEN 'JanuaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '01'
		WHEN 'FebruaryLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '02'
		WHEN 'MarchLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '03'
		WHEN 'AprilLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '04'
		WHEN 'MayLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '05'
		WHEN 'JuneLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '06'
		WHEN 'JulyLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '07'
		WHEN 'AugustLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '08'
		WHEN 'SeptemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '09'
		WHEN 'OctoberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '10'
		WHEN 'NovemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '11'
		WHEN 'DecemberLocal' THEN CAST(NPC.BudgetYear AS char(4)) + '12'
	END AS Period,

	C.InternationalCurrencyCode AS InternationalCurrencyCode,

	NPED.Amount as LocalAmount,
	
	IsNull(GAM.GlobalAccountKey,0) AS GlobalGLAccountCode,
	IsNull(FD.Name,'') AS FunctionalDepartment,
	IsNull(FD.GlobalCode,'') AS FunctionalDepartmentGlobalCode,
	IsNull(ESR.Name,'') AS OriginatingSubRegion,
	IsNull(ESR.Code,'') AS OriginatingSubRegionCode,
	IsNull(ER.Name,'') AS OriginatingRegion,
	IsNull(ER.Code,'') AS OriginatingRegionCode,
	
	IsNull(Proj.NonPayrollCorporateMRIDepartmentCode,'') as NonPayrollCorporateMRIDepartmentCode,

    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 

    IsNull(R.Name,'') as AllocationRegion, 
    IsNull(R.GlobalRegionId,0) as AllocationRegionGlobalRegionId, 

    Proj.NonPayrollReimbursable as IsReimbursable,
    IsNull(JC.Code,'') as JobCode,
    CASE WHEN NPE.Overhead = 0 THEN 0 ELSE 1 END IsUnallocatedOverhead

FROM 
	BC_TS_GRINDER_Q2.dbo.NonPayrollExpenseDetail  --

    --We need to unpivot to turn the local amounts into rows rather than columns
	UNPIVOT (Amount FOR Period IN (JanuaryLocal, FebruaryLocal, MarchLocal, AprilLocal, MayLocal, JuneLocal, JulyLocal, AugustLocal, SeptemberLocal, OctoberLocal, NovemberLocal, DecemberLocal)) AS NPED

	INNER JOIN BC_TS_GRINDER_Q2.dbo.NonPayrollExpense NPE ON  --
		NPED.NonPayrollExpenseId = NPE.NonPayrollExpenseId	

	INNER JOIN BC_TS_GRINDER_Q2.dbo.NonPayrollCycle NPC ON  --
		NPED.NonPayrollCycleUID = NPC.NonPayrollCycleUID
/* -- Doesn't seem like they are using versioning for non-payroll, yet.
	INNER JOIN (
		SELECT NonPayrollCycleUID, max(Version) as Version
		FROM BC_TS_GRINDER_Q1.dbo.NonPayrollExpenseDetail
		GROUP BY NonPayrollCycleUID
	) NPEDV ON
		NPED.NonPayrollCycleUID = NPEDV.NonPayrollCycleUID AND
		NPED.Version = NPEDV.Version
*/
	INNER JOIN BC_TS_GRINDER_Q2.dbo.Project Proj ON  
		NPE.ProjectId = Proj.ProjectId

    INNER JOIN BC_TS_GRINDER_Q2.dbo.GLType GLT ON  
        NPE.GLTypeId = GLT.GLTypeId
	
    INNER JOIN BC_TS_GRINDER_Q2.dbo.ActivityType AT ON  
        Proj.ActivityTypeId = AT.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.GlobalAccountMappingLookup GLAC ON    
		NPE.GLTypeId = GLAC.GLTypeId AND
		Proj.ActivityTypeId = GLAC.ActivityTypeId

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.GlobalAccountMapping GAM ON    
		GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.FunctionalDepartment FD ON    
        NPE.OriginatingFunctionalDepartmentId = FD.FunctionalDepartmentId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.EmployeeSubRegion ESR ON  
        NPE.OriginatingEmployeeSubRegionId = ESR.EmployeeSubRegionId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.EmployeeRegion ER ON  
        ESR.EmployeeRegionId = ER.EmployeeRegionId

    INNER JOIN BC_TS_GRINDER_Q2.dbo.Currency C ON   
        NPE.CurrencyId = C.CurrencyId
        
    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.JobCode JC ON  
        NPE.JobCodeId = JC.JobCodeId

    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.SubRegion SR ON  
        Proj.SubRegionId = SR.SubRegionId

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.Region R ON  
		Proj.RegionId = R.RegionId		
WHERE
	NPC.IsAvailable = 1 AND NPC.AvailableDate IS NOT NULL AND NPC.BudgetPeriodCode = 'Q2'-- AND
	--Change Control 1 :: GC
	--NPE.Overhead = 0

UNION ALL

-- Fees
SELECT
	'BudgetId=' + CONVERT(varchar, FBC.NonPayrollCycleUID)
		+ '&Period=' +	CASE FBD.Period 
							WHEN 'January' THEN CAST(FBC.BudgetYear AS char(4)) + '01'
							WHEN 'February' THEN CAST(FBC.BudgetYear AS char(4)) + '02'
							WHEN 'March' THEN CAST(FBC.BudgetYear AS char(4)) + '03'
							WHEN 'April' THEN CAST(FBC.BudgetYear AS char(4)) + '04'
							WHEN 'May' THEN CAST(FBC.BudgetYear AS char(4)) + '05'
							WHEN 'June' THEN CAST(FBC.BudgetYear AS char(4)) + '06'
							WHEN 'July' THEN CAST(FBC.BudgetYear AS char(4)) + '07'
							WHEN 'August' THEN CAST(FBC.BudgetYear AS char(4)) + '08'
							WHEN 'September' THEN CAST(FBC.BudgetYear AS char(4)) + '09'
							WHEN 'October' THEN CAST(FBC.BudgetYear AS char(4)) + '10'
							WHEN 'November' THEN CAST(FBC.BudgetYear AS char(4)) + '11'
							WHEN 'December' THEN CAST(FBC.BudgetYear AS char(4)) + '12' END
		+ '&BudgetPeriodCode=Q2' + 		
		+ '&NonPayrollExpenseId=0'  
		+ '&FeeIncomeId=' + CONVERT(varchar, FBD.FeeBudgetDetailUID)
		+ '&ProjectId=0' 
		+ '&GlobalAccountCode=' + CONVERT(varchar, IsNull(GAM.GlobalAccountKey,0))
		+ '&OriginatingSubRegionCode=0'
		+ '&FunctionalDepartmentGlobalCode=0' AS SourceUniqueKey,
    --Needs to link to the NonPayrollCycle here because it needs to be from the same grouping.
	FBC.NonPayrollCycleUID AS BudgetId,
	0 AS IsExpense,
	IsNull(PFDCM.CorporateMRISource,'') as SourceCode,
	FBC.BudgetYear AS BudgetYear,
	FBC.BudgetPeriodCode AS BudgetPeriodCode,
	FBC.AvailableDate AS LockedDate, 
	--I know this is messy but we need the 6 digit period value for this
	CASE FBD.Period 
		WHEN 'January' THEN CAST(FBC.BudgetYear AS char(4)) + '01'
		WHEN 'February' THEN CAST(FBC.BudgetYear AS char(4)) + '02'
		WHEN 'March' THEN CAST(FBC.BudgetYear AS char(4)) + '03'
		WHEN 'April' THEN CAST(FBC.BudgetYear AS char(4)) + '04'
		WHEN 'May' THEN CAST(FBC.BudgetYear AS char(4)) + '05'
		WHEN 'June' THEN CAST(FBC.BudgetYear AS char(4)) + '06'
		WHEN 'July' THEN CAST(FBC.BudgetYear AS char(4)) + '07'
		WHEN 'August' THEN CAST(FBC.BudgetYear AS char(4)) + '08'
		WHEN 'September' THEN CAST(FBC.BudgetYear AS char(4)) + '09'
		WHEN 'October' THEN CAST(FBC.BudgetYear AS char(4)) + '10'
		WHEN 'November' THEN CAST(FBC.BudgetYear AS char(4)) + '11'
		WHEN 'December' THEN CAST(FBC.BudgetYear AS char(4)) + '12'
	END AS Period,

	C.InternationalCurrencyCode AS InternationalCurrencyCode,

	FBD.Amount AS LocalAmount,
	
	IsNull(GAM.GlobalAccountKey,0) AS GlobalGLAccountCode,
	-- Fees do not have functional departments
	'' AS FunctionalDepartment,
	'' AS FunctionalDepartmentGlobalCode,
	-- Don't have originating region for fees
	'' AS OriginatingSubRegion,
	'' AS OriginatingSubRegionCode,
	'' AS OriginatingRegion,
	'' AS OriginatingRegionCode,
	IsNull(PFDCM.CorporateMRIDeptCode,'') as NonPayrollCorporateMRIDepartmentCode,

    IsNull(SR.Name,'') as AllocationSubRegion,
    IsNull(SR.ProjectRegionId,0) as AllocationSubRegionProjectRegionId, 

	-- Don't have for fees (debug information only get off sub region)
    '' as AllocationRegion, 
    '' as AllocationRegionGlobalRegionId, 

    0 as IsReimbursable,
    '' as JobCode,
    0 IsUnallocatedOverhead

FROM 
	BC_TS_GRINDER_Q2.dbo.FeeBudgetDetail   --

    --We need to unpivot to turn the local amounts into rows rather than columns
	UNPIVOT (Amount FOR Period IN (January, February, March, April, May, June, July, August, September, October, November, December)) AS FBD

	INNER JOIN BC_TS_GRINDER_Q2.dbo.FeeDetail FeeD ON  --
		FBD.FeeDetailUID = FeeD.FeeDetailUID	
		
	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.PropFundMRIDeptCodeMapping PFDCM ON
		FeeD.PropFundMRIDeptCodeMappingId = PFDCM.PropFundMRIDeptCodeMappingId

	INNER JOIN BC_TS_GRINDER_Q2.dbo.FeeBudgetCycle FBC ON  --BC_TS_GRINDER_Q2
		FBD.FeeBudgetCycleUID = FBC.FeeBudgetCycleUID
/* -- Doesn't seem like they are using versioning for fees, yet. 
	INNER JOIN (
		SELECT FeeBudgetCycleUID, max(Version) as Version
		FROM BC_TS_GRINDER_Q1.dbo.FeeBudgetDetail
		WHERE IsActive = 1
		GROUP BY FeeBudgetCycleUID
	) FBDV ON
		FBD.FeeBudgetCycleUID = FBDV.FeeBudgetCycleUID AND
		FBD.Version = FBDV.Version
*/
    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.GlobalAccountMappingLookupFee GLAC ON  --
        IsNull(FeeD.FeeTypeId,0) = GLAC.FeeTypeUID AND
        IsNull(FeeD.FeeCategoryId,0) = GLAC.FeeCategoryUID

	LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.GlobalAccountMapping GAM ON  --
		GLAC.GlobalAccountMappingId = GAM.GlobalAccountMappingId

    INNER JOIN BC_TS_GRINDER_Q2.dbo.Currency C ON   --
        FeeD.CurrencyId = C.CurrencyId
    
    LEFT OUTER JOIN BC_TS_GRINDER_Q2.dbo.SubRegion SR ON  --
        FeeD.SubRegionId = SR.SubRegionId

WHERE
	FBC.IsAvailable = 1 AND 
	FBC.AvailableDate IS NOT NULL AND FBC.BudgetPeriodCode = 'Q2' AND
	FBC.NonPayrollCycleUID IS NOT NULL
	) t1
GO


