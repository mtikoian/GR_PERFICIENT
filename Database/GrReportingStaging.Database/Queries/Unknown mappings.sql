 ------------------------------------------------------------------------------------
 -- Property Fund
 ------------------------------------------------------------------------------------
 
 -- Actuals
 
 /*
Select 
 missingdata.*
From (
*/

 Select 
gl.SOURCECODE,
gl.PropertyFundCode, COUNT(*) trncount
From 
      (
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From USCorp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From EUCorp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From INCorp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From BRCorp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From CNCorp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From USProp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From EUProp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From INProp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From BRProp.GeneralLedger UNION ALL
      Select SourceCode, PropertyFundCode, SourcePrimaryKey From CNProp.GeneralLedger
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityActual a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
                              Where a.PropertyFundKey = -1
                        ) a ON a.ReferenceCode = gl.SourcePrimaryKey AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.PropertyFundCode

order by gl.SOURCECODE,
gl.PropertyFundCode

/*
) missingdata 
    INNER JOIN GrReportingStaging.Gdm.PropertyFundMapping pfm on pfm.PropertyFundCode = missingdata.PropertyFundCode
    and pfm.SourceCode = missingdata.SOURCECODE
*/

 ------------------------------------------------------------------------------------
 -- GL Account
 ------------------------------------------------------------------------------------
 
 -- Actuals

/*
Select 
 missingdata.*
From (
*/

Select 
gl.SOURCECODE,
gl.GlAccountCode, COUNT(*) trncount
From 
      (
      Select SourceCode, GlAccountCode, SourcePrimaryKey From USCorp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From EUCorp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From INCorp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From BRCorp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From CNCorp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From USProp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From EUProp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From INProp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From BRProp.GeneralLedger UNION ALL
      Select SourceCode, GlAccountCode, SourcePrimaryKey From CNProp.GeneralLedger
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityActual a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
                              Where a.GlAccountKey = -1
                        ) a ON a.ReferenceCode = gl.SourcePrimaryKey AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.GlAccountCode

order by 
gl.SOURCECODE,
gl.GlAccountCode

/*
) missingdata 
    INNER JOIN GrReportingStaging.Gdm.GlAccountMapping glam on glam.GlAccountCode = missingdata.GlAccountCode
    and glam.SourceCode = missingdata.SOURCECODE


order by 
missingdata.SOURCECODE,
missingdata.GlAccountCode
*/

 
 
 
-- UNKNOWN STATISTICS

-- Actual

DECLARE @ActualTranCount int = 0,
		@ActualLocalAmount money = 0

SELECT 
	--'Actual Tran Count' as ActualTranCount,
	@ActualTranCount = COUNT(*),
	@ActualLocalAmount = SUM(LocalActual)
FROM ProfitabilityActual a

SELECT @ActualTranCount as ActualTranCount, @ActualLocalAmount as ActualLocalAmount

SELECT 
	'Unknown Actual Source' as Source,
	COUNT(*) as TranCount,
	SUM(LocalActual) as LocalActual
FROM ProfitabilityActual a
WHERE a.SourceKey = -1

SELECT 
	'Unknown Actual GL Account' as GlAccount,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount) * 100.00) as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.GlAccountKey = -1
GROUP BY s.SourceCode

SELECT 
	'Unknown Actual Functional Department' as FunctionalDepartment,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.FunctionalDepartmentKey = -1
GROUP BY s.SourceCode

SELECT 
	'Unknown Actual Reimbursable' as Reimbursable,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.ReimbursableKey = -1
GROUP BY s.SourceCode

SELECT 
	'Unknown Actual ActivityType' as ActivityType,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.ActivityTypeKey = -1
GROUP BY s.SourceCode

SELECT 
	'Unknown Actual Property Fund' as PropertyFund,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.PropertyFundKey = -1
GROUP BY s.SourceCode

SELECT 
	'Unknown Actual Originating Region' as OriginatingRegion,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.OriginatingRegionKey = -1
GROUP BY s.SourceCode

SELECT 
	'Unknown Actual Allocation Region' as AllocationRegion,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.AllocationRegionKey = -1
GROUP BY s.SourceCode


SELECT
	'Unknown Actual GlAccount Category Global Hierarchy' as GlAccountCategory,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@ActualTranCount)) * 100.00 as ActualTranCountPercentage,
	SUM(LocalActual) as LocalActual,
	(SUM(LocalActual) / @ActualLocalAmount) * 100.00 as ActualLocalAmountPercentage
FROM
	ProfitabilityActual a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
    INNER JOIN dbo.ProfitabilityActualGlAccountCategoryBridgeVirtual('2010','201012','Global') b ON  
		a.ProfitabilityActualKey = b.ProfitabilityActualKey
GROUP BY s.SourceCode

-- Corporate Budget

DECLARE @BudgetTranCount int = 0,
		@BudgetLocalAmount money = 0

SELECT 
	--'Budget Tran Count' as BudgetTranCount,
	@BudgetTranCount = COUNT(*),
	@BudgetLocalAmount = SUM(LocalBudget)
FROM ProfitabilityBudget a
WHERE a.ReferenceCode like 'BC:%'

SELECT @BudgetTranCount as BudgetTranCount, @BudgetLocalAmount as BudgetLocalAmount

SELECT 
	'Unknown Budget Source' as Source,
	COUNT(*) as TranCount,
	SUM(LocalBudget) as LocalBudget
FROM ProfitabilityBudget a
WHERE a.SourceKey = -1 and a.ReferenceCode like 'BC:%'

SELECT 
	'Unknown Budget GL Account' as GlAccount,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.GlAccountKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode 

/* --GL accounts that are unknown
Select 
gl.SOURCECODE,
gl.GlobalGlAccountCode, COUNT(*) trncount
From 
      (
      Select ImportKey, SourceCode, GlobalGlAccountCode, SourceUniqueKey From GrReportingStaging.BudgetingCorp.GlobalReportingCorporateBudget
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityBudget a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
                              Where a.GlAccountKey = -1 and a.ReferenceCode like 'BC:%'
                        ) a ON a.ReferenceCode = 'BC:' + gl.SourceUniqueKey + '&ImportKey=' + ltrim(str(gl.ImportKey,10,0))  AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.GlobalGlAccountCode
*/

SELECT 
	'Unknown Budget Functional Department' as FunctionalDepartment,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.FunctionalDepartmentKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode

/* --Functional department codes that are unknown
Select 
gl.SOURCECODE,
gl.FunctionalDepartmentGlobalCode, COUNT(*) trncount
From 
      (
      Select ImportKey, SourceCode, FunctionalDepartmentGlobalCode, SourceUniqueKey From GrReportingStaging.BudgetingCorp.GlobalReportingCorporateBudget
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityBudget a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
                              Where a.FunctionalDepartmentKey = -1 and a.ReferenceCode like 'BC:%'
                        ) a ON a.ReferenceCode = 'BC:' + gl.SourceUniqueKey + '&ImportKey=' + ltrim(str(gl.ImportKey,10,0))  AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.FunctionalDepartmentGlobalCode
*/

SELECT 
	'Unknown Budget Reimbursable' as Reimbursable,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.ReimbursableKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget ActivityType' as ActivityType,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.ActivityTypeKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode

/* -- Get gl accounts with unknown activity
Select 
gl.SOURCECODE,
gl.GlobalGlAccountCode, COUNT(*) trncount
From 
      (
      Select ImportKey, SourceCode, GlobalGlAccountCode, SourceUniqueKey From GrReportingStaging.BudgetingCorp.GlobalReportingCorporateBudget
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityBudget a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
                              Where a.ActivityTypeKey = -1 and a.ReferenceCode like 'BC:%'
                        ) a ON a.ReferenceCode = 'BC:' + gl.SourceUniqueKey + '&ImportKey=' + ltrim(str(gl.ImportKey,10,0))  AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.GlobalGlAccountCode
*/

SELECT 
	'Unknown Budget Property Fund' as PropertyFund,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.PropertyFundKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode

/* -- Get corporate department with no property fund
Select 
gl.SOURCECODE,
gl.NonPayrollCorporateMRIDepartmentCode, COUNT(*) trncount
From 
      (
      Select ImportKey, SourceCode, NonPayrollCorporateMRIDepartmentCode, SourceUniqueKey From GrReportingStaging.BudgetingCorp.GlobalReportingCorporateBudget
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityBudget a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
                              Where a.PropertyFundKey = -1 and a.ReferenceCode like 'BC:%'
                        ) a ON a.ReferenceCode = 'BC:' + gl.SourceUniqueKey + '&ImportKey=' + ltrim(str(gl.ImportKey,10,0))  AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.NonPayrollCorporateMRIDepartmentCode
*/

SELECT 
	'Unknown Budget Originating Region' as OriginatingRegion,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.OriginatingRegionKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget Allocation Region' as AllocationRegion,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.AllocationRegionKey = -1 and a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode


SELECT
	'Unknown Budget GlAccount Category Global Hierarchy' as GlAccountCategory,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM
	ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
    INNER JOIN dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('2010','201012','Global') b ON  
		a.ProfitabilityBudgetKey = b.ProfitabilityBudgetKey
WHERE a.ReferenceCode like 'BC:%'
GROUP BY s.SourceCode

/* -- Get hierarchy unknowns (for all hierarchies)
Select 
gl.SOURCECODE,
gl.GlobalGlAccountCode, COUNT(*) trncount
From 
      (
      Select ImportKey, SourceCode, GlobalGlAccountCode, SourceUniqueKey From GrReportingStaging.BudgetingCorp.GlobalReportingCorporateBudget
      ) gl
            INNER JOIN (
                              Select a.ReferenceCode,
                                          s.SourceCode
                              From GrReporting.dbo.ProfitabilityBudget a
                                          INNER JOIN GrReporting.dbo.Source s ON s.SourceKey = a.SourceKey
											INNER JOIN dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('2010','201012','Fund') b ON  
													a.ProfitabilityBudgetKey = b.ProfitabilityBudgetKey
                              Where a.ReferenceCode like 'BC:%'
                        ) a ON a.ReferenceCode = 'BC:' + gl.SourceUniqueKey + '&ImportKey=' + ltrim(str(gl.ImportKey,10,0))  AND a.SourceCode = gl.SOURCECODE
Group by gl.SOURCECODE,
gl.GlobalGlAccountCode
*/

-- Payroll Budget
/*
DECLARE @BudgetTranCount int = 0,
		@BudgetLocalAmount money = 0
*/
SELECT 
	--'Budget Tran Count' as BudgetTranCount,
	@BudgetTranCount = COUNT(*),
	@BudgetLocalAmount = SUM(LocalBudget)
FROM ProfitabilityBudget a
WHERE a.ReferenceCode like 'TGB:%'

SELECT @BudgetTranCount as BudgetTranCount, @BudgetLocalAmount as BudgetLocalAmount

SELECT 
	'Unknown Budget Source' as Source,
	COUNT(*) as TranCount,
	SUM(LocalBudget) as LocalBudget
FROM ProfitabilityBudget a
WHERE a.SourceKey = -1 and a.ReferenceCode like 'TGB:%'

SELECT 
	'Unknown Budget GL Account' as GlAccount,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.GlAccountKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode 

SELECT 
	'Unknown Budget Functional Department' as FunctionalDepartment,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.FunctionalDepartmentKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget Reimbursable' as Reimbursable,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.ReimbursableKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget ActivityType' as ActivityType,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.ActivityTypeKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget Property Fund' as PropertyFund,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.PropertyFundKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget Originating Region' as OriginatingRegion,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.OriginatingRegionKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode

SELECT 
	'Unknown Budget Allocation Region' as AllocationRegion,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
WHERE a.AllocationRegionKey = -1 and a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode


SELECT
	'Unknown Budget GlAccount Category Global Hierarchy' as GlAccountCategory,
	s.SourceCode,
	COUNT(*) as TranCount,
	(COUNT(*) / CONVERT(DECIMAL(12,4),@BudgetTranCount)) * 100.00 as BudgetTranCountPercentage,
	SUM(LocalBudget) as LocalBudget,
	(SUM(LocalBudget) / @BudgetLocalAmount) * 100.00 as BudgetLocalAmountPercentage
FROM
	ProfitabilityBudget a
	INNER JOIN Source s ON s.SourceKey = a.SourceKey
    INNER JOIN dbo.ProfitabilityBudgetGlAccountCategoryBridgeVirtual('2010','201012','Global') b ON  
		a.ProfitabilityBudgetKey = b.ProfitabilityBudgetKey
WHERE a.ReferenceCode like 'TGB:%'
GROUP BY s.SourceCode
