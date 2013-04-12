USE GrReporting
GO


UPDATE PA
SET
	PropertyFundKey = ToKeep.PropertyFundKey
FROM
	dbo.ProfitabilityActual PA
	
	INNER JOIN
	(
		SELECT 
			MAX(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToDelete ON
		PA.PropertyFundKey = ToDelete.PropertyFundKey
	
	INNER JOIN
	(
		SELECT 
			MIN(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToKeep ON
		ToDelete.PropertyFundId = ToKeep.PropertyFundId AND
		ToDelete.PropertyFundName = ToKeep.PropertyFundName AND
		ToDelete.PropertyFundType = ToKeep.PropertyFundType

PRINT 'Profitability Actual Updated'

UPDATE PB
SET
	PropertyFundKey = ToKeep.PropertyFundKey
FROM
	dbo.ProfitabilityBudget PB
	
	INNER JOIN
	(
		SELECT 
			MAX(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToDelete ON
		PB.PropertyFundKey = ToDelete.PropertyFundKey
	
	INNER JOIN
	(
		SELECT 
			MIN(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToKeep ON
		ToDelete.PropertyFundId = ToKeep.PropertyFundId AND
		ToDelete.PropertyFundName = ToKeep.PropertyFundName AND
		ToDelete.PropertyFundType = ToKeep.PropertyFundType	

PRINT 'Profitability Budget Updated'
		
UPDATE PR
SET
	PropertyFundKey = ToKeep.PropertyFundKey
FROM
	dbo.ProfitabilityReforecast PR
	
	INNER JOIN
	(
		SELECT 
			MAX(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToDelete ON
		PR.PropertyFundKey = ToDelete.PropertyFundKey
	
	INNER JOIN
	(
		SELECT 
			MIN(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToKeep ON
		ToDelete.PropertyFundId = ToKeep.PropertyFundId AND
		ToDelete.PropertyFundName = ToKeep.PropertyFundName AND
		ToDelete.PropertyFundType = ToKeep.PropertyFundType	

PRINT 'Profitability Reforecast Updated'

UPDATE PAA
SET
	PropertyFundKey = ToKeep.PropertyFundKey
FROM
	dbo.ProfitabilityActualArchive PAA
	
	INNER JOIN
	(
		SELECT 
			MAX(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToDelete ON
		PAA.PropertyFundKey = ToDelete.PropertyFundKey
	
	INNER JOIN
	(
		SELECT 
			MIN(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToKeep ON
		ToDelete.PropertyFundId = ToKeep.PropertyFundId AND
		ToDelete.PropertyFundName = ToKeep.PropertyFundName AND
		ToDelete.PropertyFundType = ToKeep.PropertyFundType	
		
UPDATE PF
SET
	EndDate = '9999-12-31 00:00:00.000'
FROM
	dbo.PropertyFund PF
	
	INNER JOIN
	(
		SELECT 
			MIN(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToKeep ON
		PF.PropertyFundKey = ToKeep.PropertyFundKey
		
PRINT 'Property Fund Updated'		

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActual_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]'))
ALTER TABLE [dbo].[ProfitabilityActual] DROP CONSTRAINT [FK_ProfitabilityActual_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityBudget_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]'))
ALTER TABLE [dbo].[ProfitabilityBudget] DROP CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityReforecast_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]'))
ALTER TABLE [dbo].[ProfitabilityReforecast] DROP CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActual]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityBudget]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityReforecast]') AND name = N'IX_PropertyFundKey')
DROP INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] WITH ( ONLINE = OFF )
GO


DELETE PF
FROM
	dbo.PropertyFund PF 
	
	INNER JOIN
	(
		SELECT 
			MAX(PF.PropertyFundKey) AS PropertyFundKey,
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		FROM 
			[GrReporting].[dbo].[PropertyFund] PF
		WHERE
			SnapshotId = 0
		GROUP BY
			PF.PropertyFundId,
			PF.PropertyFundName,
			PF.PropertyFundType
		HAVING
			COUNT(PropertyFundKey) > 1
	) ToDelete ON
		PF.PropertyFundKey = ToDelete.PropertyFundKey
		
ALTER TABLE [dbo].[ProfitabilityActual]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActual_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityActual] CHECK CONSTRAINT [FK_ProfitabilityActual_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityBudget]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityBudget_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityBudget] CHECK CONSTRAINT [FK_ProfitabilityBudget_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityReforecast]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityReforecast] CHECK CONSTRAINT [FK_ProfitabilityReforecast_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]
GO

CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityActual] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalActual],
[ProfitabilityActualKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlAccountCategoryKey],
[OverheadKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityBudget] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalBudget],
[ProfitabilityBudgetKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlAccountCategoryKey],
[BudgetReforecastTypeKey],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [IX_PropertyFundKey] ON [dbo].[ProfitabilityReforecast] 
(
	[PropertyFundKey] ASC
)
INCLUDE ( [LocalReforecast],
[ProfitabilityReforecastKey],
[CalendarKey],
[GlAccountKey],
[SourceKey],
[FunctionalDepartmentKey],
[ReimbursableKey],
[ActivityTypeKey],
[AllocationRegionKey],
[OriginatingRegionKey],
[LocalCurrencyKey],
[GlobalGlAccountCategoryKey],
[BudgetReforecastTypeKey],
[OverheadKey],
[FeeAdjustmentKey]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


