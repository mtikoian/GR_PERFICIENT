ALTER TABLE BRProp.JOURNAL ALTER COLUMN REF char(6) NOT NULL
GO

ALTER TABLE INProp.JOURNAL ALTER COLUMN REF char(6) NOT NULL
GO
PRINT 'GrReporting & GrReportingStaging must be reloaded completely' 