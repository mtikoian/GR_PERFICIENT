DELETE FROM dbo.ProfitabilityActual
DELETE FROM dbo.ProfitabilityBudget
DELETE FROM dbo.ExchangeRate

--DELETE FROM dbo.Reforecast Where ReforecastKey > 0
DELETE FROM dbo.GlAccountCategory Where GlAccountCategoryKey > 0
DELETE FROM dbo.ActivityType Where ActivityTypeKey > 0
DELETE FROM dbo.AllocationRegion Where AllocationRegionKey > 0
--DELETE FROM dbo.Calendar Where CalendarKey > 0
DELETE FROM dbo.FunctionalDepartment Where FunctionalDepartmentKey > 0
DELETE FROM dbo.GlAccount Where GlAccountKey > 0
DELETE FROM dbo.OriginatingRegion Where OriginatingRegionKey > 0
DELETE FROM dbo.PropertyFund Where PropertyFundKey > 0
DELETE FROM dbo.Currency Where CurrencyKey > 0
--DELETE FROM dbo.Reimbursable Where ReimbursableKey > 0
--DELETE FROM dbo.Source Where SourceKey > 0


 