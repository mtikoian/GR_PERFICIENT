
--Add additional information to actual table.

ALTER TABLE dbo.ProfitabilityActual ADD
	EntryDate datetime NULL,
	[User] nvarchar(20) NULL,
	[Description] nvarchar(60) NULL,
	AdditionalDescription nvarchar(4000) NULL
 
 GO
