USE GrReporting
GO


CREATE UNIQUE NONCLUSTERED INDEX [IX_Unique] ON [dbo].[ActivityType] ([ActivityTypeCode]) INCLUDE ([ActivityTypeKey], [ActivityTypeName])
GO 
CREATE UNIQUE NONCLUSTERED INDEX [IX_Name_SubName] ON [dbo].[AllocationRegion] ([RegionName], [SubRegionName]) INCLUDE ([AllocationRegionKey], [RegionCode], [SubRegionCode])
GO
CREATE NONCLUSTERED INDEX [IX_CalendarPeriod] ON [dbo].[Calendar] ([CalendarPeriod]) INCLUDE ([CalendarKey])
GO
CREATE NONCLUSTERED INDEX [IX_Year] ON [dbo].[Calendar] ([CalendarYear]) INCLUDE ([CalendarKey])
GO
CREATE NONCLUSTERED INDEX [IX_CalendarYear_CalendarKey] ON [dbo].[Calendar] ([CalendarYear], [CalendarKey]) INCLUDE ([CalendarPeriod])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Uniqueue] ON [dbo].[Currency] ([CurrencyCode]) INCLUDE ([CurrencyKey], [Name])
GO
CREATE NONCLUSTERED INDEX [IX_DestinationCurrencyKey] ON [dbo].[ExchangeRate] ([DestinationCurrencyKey], [CalendarKey], [SourceCurrencyKey]) INCLUDE ([Rate])
GO

CREATE NONCLUSTERED INDEX [IX_SourceCurrencyKey_CalendarKey_DestinationCurrencyKey] ON [dbo].[ExchangeRate] ([SourceCurrencyKey], [CalendarKey], [DestinationCurrencyKey]) INCLUDE ([Rate])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Uniqueue] ON [dbo].[FeeAdjustment] ([FeeAdjustmentCode]) INCLUDE ([FeeAdjustmentKey], [FeeAdjustmentName])
GO
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[FunctionalDepartment] ([FunctionalDepartmentKey])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Name_SubName] ON [dbo].[FunctionalDepartment] ([FunctionalDepartmentName], [SubFunctionalDepartmentName]) INCLUDE ([FunctionalDepartmentCode], [FunctionalDepartmentKey], [SubFunctionalDepartmentCode])
GO
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[GlAccount] ([GlAccountKey]) INCLUDE ([Code], [Name])
GO
CREATE STATISTICS [st_Code_Name] ON [dbo].[GlAccount] ([Code], [Name], [GlAccountKey])
GO
CREATE STATISTICS [st_GlAccountKey_Code] ON [dbo].[GlAccount] ([GlAccountKey], [Code])
GO
CREATE NONCLUSTERED INDEX [IX_GlAccountCategoryKey_MinorCategoryName] ON [dbo].[GlAccountCategory] ([GlAccountCategoryKey], [MinorCategoryName]) INCLUDE ([AccountSubTypeName], [FeeOrExpense], [MajorCategoryName])
GO
CREATE NONCLUSTERED INDEX [IX_Major_Minor_FeeOrExpense_AccountSubTypeName] ON [dbo].[GlAccountCategory] ([MajorCategoryName], [MinorCategoryName], [FeeOrExpense], [AccountSubTypeName]) INCLUDE ([FeeOrExpenseMultiplicationFactor])
GO
CREATE NONCLUSTERED INDEX [IX_MinorName] ON [dbo].[GlAccountCategory] ([MinorCategoryName]) INCLUDE ([GlAccountCategoryKey])
GO
CREATE NONCLUSTERED INDEX [IX_Composite] ON [dbo].[GlAccountCategory] ([MinorCategoryName], [GlAccountCategoryKey], [AccountSubTypeName], [FeeOrExpense], [MajorCategoryName])
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Name_SubName] ON [dbo].[OriginatingRegion] ([RegionName], [SubRegionName]) INCLUDE ([OriginatingRegionKey], [RegionCode], [SubRegionCode])
GO
CREATE NONCLUSTERED INDEX [IX_SubName] ON [dbo].[OriginatingRegion] ([SubRegionName]) INCLUDE ([OriginatingRegionKey])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Uniqueue] ON [dbo].[Overhead] ([OverheadCode]) INCLUDE ([OverheadKey], [OverheadName])
GO
------
DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] 
GO
DROP INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual]
GO
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] 
GO
DROP INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual]
GO
DROP INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual]
GO
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual]
GO
GO
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 
GO
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityActual]
GO
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] 

------
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityActual] ([ActivityTypeKey]) INCLUDE ([AllocationRegionKey], [CalendarKey], [FunctionalDepartmentKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey], [ProfitabilityActualKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE NONCLUSTERED INDEX [IX_AllocationRegionKey] ON [dbo].[ProfitabilityActual] ([AllocationRegionKey]) INCLUDE ([ActivityTypeKey], [CalendarKey], [FunctionalDepartmentKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey], [ProfitabilityActualKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityActual] ([CalendarKey]) INCLUDE ([ActivityTypeKey], [AllocationRegionKey], [FunctionalDepartmentKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey], [ProfitabilityActualKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE NONCLUSTERED INDEX [IX_FunctionalDepartmentKey] ON [dbo].[ProfitabilityActual] ([FunctionalDepartmentKey]) INCLUDE ([ActivityTypeKey], [AllocationRegionKey], [CalendarKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey], [ProfitabilityActualKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE NONCLUSTERED INDEX [IX_GlAccountKey] ON [dbo].[ProfitabilityActual] ([GlAccountKey]) INCLUDE ([ActivityTypeKey], [AllocationRegionKey], [CalendarKey], [FunctionalDepartmentKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey], [ProfitabilityActualKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityActual] ([OriginatingRegionKey]) INCLUDE ([ActivityTypeKey], [AllocationRegionKey], [CalendarKey], [FunctionalDepartmentKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OverheadKey], [ProfitabilityActualKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityActual] ([OriginatingRegionKey], [LocalCurrencyKey], [CalendarKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [PropertyFundKey], [AllocationRegionKey], [SourceKey], [ReimbursableKey], [OverheadKey], [ActivityTypeKey])
GO
CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] ([PropertyFundKey]) INCLUDE ([ActivityTypeKey], [AllocationRegionKey], [CalendarKey], [FunctionalDepartmentKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [LocalActual], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey], [ProfitabilityActualKey], [ReimbursableKey], [SourceKey])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityActual] ([ReferenceCode], [SourceKey]) INCLUDE ([ProfitabilityActualKey])
GO
------

DROP INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget]
GO
DROP INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] 
GO
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] 
GO
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] 



----
CREATE NONCLUSTERED INDEX [IX_ActivityTypeKey] ON [dbo].[ProfitabilityBudget] ([ActivityTypeKey])
GO
CREATE NONCLUSTERED INDEX [IX_CalendarKey] ON [dbo].[ProfitabilityBudget] ([CalendarKey]) INCLUDE ([GlobalGlAccountCategoryKey], [LocalCurrencyKey], [OriginatingRegionKey], [OverheadKey])
GO
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityBudget] ([OriginatingRegionKey])
GO
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityBudget] ([OriginatingRegionKey], [LocalCurrencyKey], [CalendarKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [PropertyFundKey], [AllocationRegionKey], [SourceKey], [ReimbursableKey], [OverheadKey], [ActivityTypeKey])


--------------------------

DROP INDEX [ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] 
GO
DROP INDEX [IX_ProfitabilityReforecast_SourceSystemBudget] ON [dbo].[ProfitabilityReforecast] 
GO
DROP INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] 
GO
DROP INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityReforecast] 
GO
DROP INDEX [IX_ReforecatKey] ON [dbo].[ProfitabilityReforecast] 
GO
DROP INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] 
GO


--------------------------
CREATE NONCLUSTERED INDEX [ActivityTypeKey] ON [dbo].[ProfitabilityReforecast] ([ActivityTypeKey])
GO
CREATE NONCLUSTERED INDEX [IX_ProfitabilityReforecast_SourceSystemBudget] ON [dbo].[ProfitabilityReforecast] ([BudgetId], [SourceSystemId])
GO
CREATE NONCLUSTERED INDEX [IX_OriginatingRegionKey] ON [dbo].[ProfitabilityReforecast] ([OriginatingRegionKey])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ReferenceCode] ON [dbo].[ProfitabilityReforecast] ([ReferenceCode]) INCLUDE ([ProfitabilityReforecastKey])
GO
CREATE NONCLUSTERED INDEX [IX_ReforecatKey] ON [dbo].[ProfitabilityReforecast] ([ReforecastKey]) INCLUDE ([ActivityTypeKey], [AllocationRegionKey], [CalendarKey], [FunctionalDepartmentKey], [GlAccountKey], [LocalCurrencyKey], [LocalReforecast], [OriginatingRegionKey], [ProfitabilityReforecastKey], [PropertyFundKey], [ReimbursableKey], [SourceKey])
GO
CREATE CLUSTERED INDEX [IX_Clustered] ON [dbo].[ProfitabilityReforecast] ([ReforecastKey], [OriginatingRegionKey], [LocalCurrencyKey], [CalendarKey], [GlAccountKey], [GlobalGlAccountCategoryKey], [PropertyFundKey], [AllocationRegionKey], [SourceKey], [ReimbursableKey], [OverheadKey], [ActivityTypeKey])
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ReforecastEffectivePeriod] ON [dbo].[Reforecast] ([ReforecastEffectivePeriod]) INCLUDE ([ReforecastKey])
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Uniqueue] ON [dbo].[Reimbursable] ([ReimbursableCode]) INCLUDE ([MultiplicationFactor], [ReimbursableKey], [ReimbursableName])
GO