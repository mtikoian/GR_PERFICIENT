 USE [GrReporting]
GO

/****** Object:  View [dbo].[FunctionalDepartmentLatestState]    Script Date: 01/23/2012 17:00:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[FunctionalDepartmentLatestState]'))
DROP VIEW [dbo].[FunctionalDepartmentLatestState]
GO

USE [GrReporting]
GO

/****** Object:  View [dbo].[FunctionalDepartmentLatestState]    Script Date: 01/23/2012 17:00:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE VIEW [dbo].[FunctionalDepartmentLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the FunctionalDepartment dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	FunctionalDepartment.FunctionalDepartmentKey AS 'FunctionalDepartmentKey',
	FunctionalDepartment.ReferenceCode AS 'FunctionalDepartmentReferenceCode',
	MaxFunctionalDepartmentRecord.FunctionalDepartmentName AS 'LatestFunctionalDepartmentName',
	MaxFunctionalDepartmentRecord.ReferenceCode AS 'LatestFunctionalDepartmentReferenceCode',
	MaxFunctionalDepartmentRecord.FunctionalDepartmentCode AS 'LatestFunctionalDepartmentCode',
	MaxFunctionalDepartmentRecord.SubFunctionalDepartmentCode AS 'LatestSubFunctionalDepartmentCode',
	MaxFunctionalDepartmentRecord.SubFunctionalDepartmentName AS 'LatestSubFunctionalDepartmentName'
FROM
	dbo.FunctionalDepartment
	INNER JOIN (
		SELECT
			ReferenceCode,
			MAX(EndDate) AS 'MaxFunctionalDepartmentEndDate'
		FROM 
			dbo.FunctionalDepartment
		GROUP BY 
			ReferenceCode
		) MaxFunctionalDepartment ON
		FunctionalDepartment.ReferenceCode = MaxFunctionalDepartment.ReferenceCode
	INNER JOIN dbo.FunctionalDepartment MaxFunctionalDepartmentRecord ON
		MaxFunctionalDepartment.ReferenceCode = MaxFunctionalDepartmentRecord.ReferenceCode AND
		MaxFunctionalDepartment.MaxFunctionalDepartmentEndDate = MaxFunctionalDepartmentRecord.EndDate







GO


