 USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gr].[GetFunctionalDepartmentExpanded]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
GO

/*********************************************************************************************************************
Description
	The function is used for as source data for populating the FunctionalDepartment slowly changing	dimension in 
	the data warehouse (GrReporting).
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-07-20		: PKayongo	:	Add the IsActive = 1 condition to Functional Departments to make sure
											inactive functional departments are not included.
**********************************************************************************************************************/

CREATE   FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(
	FunctionalDepartmentId Int NOT NULL,
	ReferenceCode varchar(20) NULL,
	FunctionalDepartmentCode varchar(20) NOT NULL,
	FunctionalDepartmentName Varchar(50) NOT NULL,
	SubFunctionalDepartmentCode varchar(20) NOT NULL,
	SubFunctionalDepartmentName Varchar(100) NOT NULL,
	UpdatedDate DateTime NOT NULL
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
	UpdatedDate
)
SELECT 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+':',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		Fd.GlobalCode SubFunctionalDepartmentCode,
		RTRIM(Fd.GlobalCode) + ' - ' + Fd.Name SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM 
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON 
		FdA.ImportKey = Fd.ImportKey
WHERE 
	Fd.GlobalCode IS NOT NULL AND
	Fd.IsActive = 1

Insert Into @Result
(
	FunctionalDepartmentId, 
	ReferenceCode,
	FunctionalDepartmentCode,
	FunctionalDepartmentName,
	SubFunctionalDepartmentCode,
	SubFunctionalDepartmentName,
	UpdatedDate
)
SELECT 
		T2.FunctionalDepartmentId,
		T1.FunctionalDepartmentCode+':'+T2.Code,
		T1.FunctionalDepartmentCode,
		T1.FunctionalDepartmentName,
		T2.Code,
		RTRIM(T2.Code) + ' - ' + T2.Description,
		T2.UpdatedDate
FROM	
		@Result T1
			INNER JOIN 
						(
							SELECT 
									--Jc.Source,
									Jc.JobCode Code,
									Max(Jc.Description) as Description,
									Max(Jc.FunctionalDepartmentId) as FunctionalDepartmentId,
									Max(Jc.UpdatedDate) as UpdatedDate
							FROM 
								GACS.JobCode Jc
								INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON 
									JcA.ImportKey = Jc.ImportKey
							WHERE 
								Jc.FunctionalDepartmentId IS NOT NULL
							GROUP BY --TODO. As per AW advice job code will never be map to functional departments for day 1, we will address a change in this when the time comes.
									Jc.JobCode
							
						) T2 ON 
							T2.FunctionalDepartmentId = T1.FunctionalDepartmentId
							AND T2.Code <> T1.FunctionalDepartmentCode

ORDER BY 
	T1.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
INSERT INTO @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
SELECT 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+':UNKNOWN',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		'UNKNOWN' SubFunctionalDepartmentCode,
		'UNKNOWN' SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM 
	HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
WHERE 
	Fd.GlobalCode IS NOT NULL AND
	Fd.IsActive = 1

RETURN
END


GO


