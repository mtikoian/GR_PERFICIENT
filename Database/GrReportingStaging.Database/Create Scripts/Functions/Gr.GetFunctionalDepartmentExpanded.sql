USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************************
Description
	The function is used for as source data for populating the FunctionalDepartment slowly changing	dimension in 
	the data warehouse (GrReporting).
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-20		: PKayongo	:	Add the IsActive = 1 condition to Functional Departments to make sure inactive functional departments
												are not included.
											
			2011-08-09		: ISaunder	:	Removed the IsActive filter and added it to the SELECTs instead. The SCD stored procedures will
												determine how inactive functional departments should ne handled.

			2011-12-28		: ISaunder	:	Updated logic used to determine the UpdatedDate field - the UpdatedDate of the record that was last
												updated (either FunctionalDepartment or JobCode) is chosen as the UpdatedDate that is returned.
**********************************************************************************************************************/

CREATE FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	(@DataPriorToDate DateTime)

RETURNS @Result TABLE
(
	FunctionalDepartmentId INT NOT NULL,
	ReferenceCode VARCHAR(20) NULL,
	FunctionalDepartmentCode VARCHAR(20) NOT NULL,
	FunctionalDepartmentName VARCHAR(50) NOT NULL,
	SubFunctionalDepartmentCode VARCHAR(20) NOT NULL,
	SubFunctionalDepartmentName VARCHAR(100) NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	IsActive BIT NOT NULL
)

AS

BEGIN 

INSERT INTO @Result
(
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	FD.FunctionalDepartmentId,
	FD.GlobalCode+':',
	FD.GlobalCode FunctionalDepartmentCode,
	FD.Name FunctionalDepartmentName,
	FD.GlobalCode SubFunctionalDepartmentCode,
	RTRIM(Fd.GlobalCode) + ' - ' + Fd.Name SubFunctionalDepartmentName,
	FD.UpdatedDate,
	FD.IsActive	
FROM 
	HR.FunctionalDepartment FD
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON 
		FDA.ImportKey = FD.ImportKey
WHERE 
	FD.GlobalCode IS NOT NULL

INSERT INTO @Result
(
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	JobCodes.FunctionalDepartmentId,
	FunctionalDepartments.FunctionalDepartmentCode + ':' + JobCodes.Code,
	FunctionalDepartments.FunctionalDepartmentCode,
	FunctionalDepartments.FunctionalDepartmentName,
	JobCodes.Code,
	RTRIM(JobCodes.Code) + ' - ' + JobCodes.Description,
	CASE -- We will choose the InsertedDate of the record (FunctionalDepartment or JobCde) that was last inserted
		WHEN
			FunctionalDepartments.UpdatedDate > JobCodes.UpdatedDate
		THEN
			FunctionalDepartments.UpdatedDate
		ELSE
			JobCodes.UpdatedDate
	END AS UpdatedDate,
	FunctionalDepartments.IsActive & JobCodes.IsActive AS IsActive
FROM	
	@Result FunctionalDepartments
	INNER JOIN 
	(
		SELECT 
			JC.JobCode Code,
			MAX(JC.Description) AS Description,
			MAX(JC.FunctionalDepartmentId) AS FunctionalDepartmentId,
			MAX(JC.UpdatedDate) AS UpdatedDate,
			IsActive
		FROM 
			GACS.JobCode JC
			INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JCA ON
				JCA.ImportKey = JC.ImportKey
		WHERE 
			JC.FunctionalDepartmentId IS NOT NULL
		GROUP BY
			JC.JobCode,
			JC.IsActive
	) JobCodes ON 
		JobCodes.FunctionalDepartmentId = FunctionalDepartments.FunctionalDepartmentId AND
		JobCodes.Code <> FunctionalDepartments.FunctionalDepartmentCode
ORDER BY 
	FunctionalDepartments.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
INSERT INTO @Result
(
	FunctionalDepartmentId,
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate,
	IsActive
)
SELECT 
	FD.FunctionalDepartmentId,
	FD.GlobalCode+':UNKNOWN',
	FD.GlobalCode FunctionalDepartmentCode,
	FD.Name FunctionalDepartmentName,
	'UNKNOWN' SubFunctionalDepartmentCode,
	'UNKNOWN' SubFunctionalDepartmentName,
	FD.UpdatedDate,
	FD.IsActive
FROM 
	HR.FunctionalDepartment FD
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON
		FDA.ImportKey = FD.ImportKey
WHERE 
	FD.GlobalCode IS NOT NULL

RETURN

END

GO



