USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
GO

CREATE PROCEDURE [dbo].[stp_S_ValidNonPayrollRegionAndFunctionalDepartment]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime
AS

DECLARE @BudgetQuarterNumber INT
SET @BudgetQuarterNumber = CAST(SUBSTRING(@BudgetQuater, 2, 1) AS INT) + 1

CREATE TABLE #FunctionalDepartment(
	ImportKey INT NOT NULL,
	ImportBatchId INT NOT NULL,
	ImportDate DATETIME NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Code VARCHAR(20) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	GlobalCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment(
	ImportKey,
	ImportBatchId,
	ImportDate,
	FunctionalDepartmentId,
	Name,
	Code,
	IsActive,
	InsertedDate,
	UpdatedDate,
	GlobalCode
)
SELECT 
	fd.* 
FROM 
	GrReportingStaging.HR.FunctionalDepartment fd
	INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) fdA ON
		fd.ImportKey = fdA.ImportKey

PRINT 'Completed inserting records into #FunctionalDepartment:'+CONVERT(char(10),@@rowcount)
PRINT CONVERT(Varchar(27), getdate(), 121)

CREATE CLUSTERED INDEX IX_FunctionalDepartmentId ON #FunctionalDepartment (FunctionalDepartmentId)
PRINT 'Completed creating indexes on #FunctionalDepartment'
PRINT CONVERT(Varchar(27), getdate(), 121)


Select 
		DISTINCT
		Fd.Name FunctionalDepartmentName,
		GrOr.Name OriginatingSubRegionName
From 
		Server3.GBS.dbo.NonPayrollExpenseBreakdown ExB
			INNER JOIN #FunctionalDepartment Fd ON Fd.FunctionalDepartmentId = ExB.FunctionalDepartmentId
			
			 INNER JOIN (
					SELECT 
						Gr.* 
					FROM 
						GrReportingStaging.Gdm.GlobalRegion Gr
						INNER JOIN GrReportingStaging.Gdm.GlobalRegionActive(@DataPriorToDate) GrA ON
							Gr.ImportKey = GrA.ImportKey
					) GrOr ON GrOr.GlobalRegionId = ExB.OriginatingSubRegionGlobalRegionId
					
Where BudgetID in (										
					Select BudgetId
					From 
							Server3.GBS.dbo.Budget 
					Where BudgetReportGroupPeriodID IN (
						Select 
								BudgetReportGroupPeriodID 
						From 
								Server3.GDM_GR.dbo.BudgetReportGroupPeriod 
						Where [YEAR] = @BudgetYear and Period = (Select 
																		MIN(t1.ReforecastEffectivePeriod)
																 From 
																		GrReporting.dbo.Reforecast t1
																Where ReforecastEffectiveYear = @BudgetYear
																And	ReforecastEffectiveQuarter = @BudgetQuarterNumber
																)
														)
				)
GO
