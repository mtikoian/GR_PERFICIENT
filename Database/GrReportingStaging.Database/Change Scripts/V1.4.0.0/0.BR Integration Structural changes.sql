﻿ USE GrReportingStaging
GO
ALTER TABLE BRCORP.JOURNAL ALTER COLUMN DESCRPN NCHAR(60) NULL
ALTER TABLE BRPROP.JOURNAL ALTER COLUMN DESCRPN NCHAR(60) NULL
GO