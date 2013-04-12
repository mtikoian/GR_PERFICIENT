USE [GrReporting]
GO

/****** Object:  Table [dbo].[YearToDate]    Script Date: 03/16/2010 09:28:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[YearToDate]') AND type in (N'U'))
DROP TABLE [dbo].[YearToDate]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[YearToDate]    Script Date: 03/16/2010 09:28:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[YearToDate](
	[YearToDateKey] [int] NOT NULL,
	[YearToDateMonthName] [varchar](10) NOT NULL,
	[YearToDateQuarterName] [varchar](10) NOT NULL,
	[YearToDatePeriod] [int] NOT NULL,
	[YearToDateYear] [int] NULL,
 CONSTRAINT [PK_YearToDate] PRIMARY KEY CLUSTERED 
(
	[YearToDateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/*
Run this script on:

OBTSSQL10\dev.GrReporting    -  This database will be modified

to synchronize it with:

OBTSSQL10\dev.GrReportingVer2

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 8.0.2 from Red Gate Software Ltd at 3/16/2010 9:54:06 AM

*/
		
SET XACT_ABORT ON
GO
SET ARITHABORT ON
GO
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)
BEGIN TRANSACTION

-- Add rows to [dbo].[YearToDate]
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (-1, 'UNKNOWN', 'UNKNOWN', -1, -1)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40177, 'January', 'Q0', 201001, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40208, 'February', 'Q0', 201002, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40236, 'March', 'Q0', 201003, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40267, 'April', 'Q1', 201004, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40297, 'May', 'Q1', 201005, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40328, 'June', 'Q1', 201006, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40358, 'July', 'Q2', 201007, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40389, 'August', 'Q2', 201008, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40420, 'September', 'Q2', 201009, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40450, 'October', 'Q3', 201010, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40481, 'November', 'Q3', 201011, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40511, 'December', 'Q3', 201012, 2010)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40542, 'January', 'Q0', 201101, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40573, 'February', 'Q0', 201102, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40601, 'March', 'Q0', 201103, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40632, 'April', 'Q1', 201104, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40662, 'May', 'Q1', 201105, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40693, 'June', 'Q1', 201106, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40723, 'July', 'Q2', 201107, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40754, 'August', 'Q2', 201108, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40785, 'September', 'Q2', 201109, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40815, 'October', 'Q3', 201110, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40846, 'November', 'Q3', 201111, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40876, 'December', 'Q3', 201112, 2011)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40907, 'January', 'Q0', 201201, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40938, 'February', 'Q0', 201202, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40967, 'March', 'Q0', 201203, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (40998, 'April', 'Q1', 201204, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41028, 'May', 'Q1', 201205, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41059, 'June', 'Q1', 201206, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41089, 'July', 'Q2', 201207, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41120, 'August', 'Q2', 201208, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41151, 'September', 'Q2', 201209, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41181, 'October', 'Q3', 201210, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41212, 'November', 'Q3', 201211, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41242, 'December', 'Q3', 201212, 2012)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41273, 'January', 'Q0', 201301, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41304, 'February', 'Q0', 201302, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41332, 'March', 'Q0', 201303, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41363, 'April', 'Q1', 201304, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41393, 'May', 'Q1', 201305, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41424, 'June', 'Q1', 201306, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41454, 'July', 'Q2', 201307, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41485, 'August', 'Q2', 201308, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41516, 'September', 'Q2', 201309, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41546, 'October', 'Q3', 201310, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41577, 'November', 'Q3', 201311, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41607, 'December', 'Q3', 201312, 2013)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41638, 'January', 'Q0', 201401, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41669, 'February', 'Q0', 201402, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41697, 'March', 'Q0', 201403, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41728, 'April', 'Q1', 201404, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41758, 'May', 'Q1', 201405, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41789, 'June', 'Q1', 201406, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41819, 'July', 'Q2', 201407, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41850, 'August', 'Q2', 201408, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41881, 'September', 'Q2', 201409, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41911, 'October', 'Q3', 201410, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41942, 'November', 'Q3', 201411, 2014)
INSERT INTO [dbo].[YearToDate] ([YearToDateKey], [YearToDateMonthName], [YearToDateQuarterName], [YearToDatePeriod], [YearToDateYear]) VALUES (41972, 'December', 'Q3', 201412, 2014)
-- Operation applied to 61 rows out of 61
COMMIT TRANSACTION
GO
