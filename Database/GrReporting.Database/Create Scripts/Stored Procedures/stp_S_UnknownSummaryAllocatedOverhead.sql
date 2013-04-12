USE GrReporting
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_S_UnknownSummaryAllocatedOverhead]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[stp_S_UnknownSummaryAllocatedOverhead]
GO

CREATE PROCEDURE [dbo].[stp_S_UnknownSummaryAllocatedOverhead]
@BudgetYear int,
@BudgetQuater	Varchar(2),
@DataPriorToDate DateTime,
@StartPeriod int,
@EndPeriod int
AS


--SET @StartPeriod = 201001
--SET @EndPeriod = 201008
--SET @BudgetYear = 2010
--SET @BudgetQuater = 'Q2'
--SET @DataPriorToDate = '2010-12-31'
--ActivityType
--GlAccount
--GlAccountCategory
--AllocationRegion
--OriginatingRegion
--FunctionalDepartment
--<<not included>>Overhead
--PropertyFund

--This is copied directly from stp_IU_LoadGrProfitabiltyOverhead
IF OBJECT_ID('tempdb..#ActivityTypeGLAccount') IS NOT NULL
	DROP TABLE #ActivityTypeGLAccount
	
CREATE TABLE #ActivityTypeGLAccount(
	ActivityTypeId INT,
	GLAccountCode VARCHAR(12)
)

INSERT INTO #ActivityTypeGLAccount (
	ActivityTypeId, 
	GLAccountCode
)
SELECT NULL AS ActivityTypeId, '5002950000' AS GLAccountCode UNION ALL --header (NULL in on hierarchy)
SELECT 1, '5002950001' UNION ALL --Leasing
SELECT 2, '5002950002' UNION ALL --Acquisitions
SELECT 3, '5002950003' UNION ALL --Asset Management
SELECT 4, '5002950004' UNION ALL --Development
SELECT 5, '5002950005' UNION ALL --Property Management Escalatable
SELECT 6, '5002950006' UNION ALL --Property Management Non-Escalatable
SELECT 7, '5002950007' UNION ALL --Syndication (Investment and Fund)
SELECT 8, '5002950008' UNION ALL --Fund Organization
SELECT 9, '5002950009' UNION ALL --Fund Operations
SELECT 10, '5002950010' UNION ALL --Property Management TI
SELECT 11, '5002950011' UNION ALL --Property Management CapEx
SELECT 12, '5002950012' UNION ALL --Corporate
SELECT 99, '5002950099' --Corporate Overhead (No corporate overhead (5002950099) account  use header instead)



IF OBJECT_ID('tempdb..#ValidationSummary') IS NOT NULL
	DROP TABLE #ValidationSummary
	
CREATE TABLE #ValidationSummary
(
SourceCode Char(2) NOT NULL,
ProfitabilityActualKey Int NOT NULL,
ReferenceCode varchar(100) NOT NULL,
HasActivityTypeUnknown TinyInt NULL,
HasAllocationRegionUnknown TinyInt NULL,
HasFunctionalDepartmentUnknown TinyInt NULL,
HasGlAccountUnknown TinyInt NULL,
HasGlAccountCategoryUnknown TinyInt NULL,
HasOriginatingRegionUnknown TinyInt NULL,
--HasOverheadUnknown TinyInt NULL,
HasPropertyFundUnknown TinyInt NULL,
InValidRegionAndFunctionalDepartment TinyInt NULL DEFAULT(0),
InValidActivityTypeEntity  TinyInt NULL DEFAULT(0)
)

--Step 1 :: Get all the unknowns
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown)

Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	CASE WHEN pa.ActivityTypeKey = -1 THEN 1 ELSE 0 END HasActivityTypeUnknown, 
	CASE WHEN pa.AllocationRegionKey = -1 THEN 1 ELSE 0 END HasAllocationRegionUnknown, 
	CASE WHEN pa.FunctionalDepartmentKey = -1 AND gac.FeeOrExpense <> 'INCOME' THEN 1 ELSE 0 END HasFunctionalDepartmentUnknown,
	CASE WHEN pa.GlAccountKey = -1 THEN 1 ELSE 0 END HasGlAccountUnknown, 
	CASE WHEN gac.MajorCategoryName like '%unknown%' THEN 1 ELSE 0 END HasGlAccountCategoryUnknown, 
	CASE WHEN pa.OriginatingRegionKey = -1 AND gac.FeeOrExpense <> 'INCOME' THEN 1 ELSE 0 END HasOriginatingRegionUnknown,
	--CASE WHEN pa.OverheadKey = -1 THEN 1 ELSE 0 END HasOverheadUnknown, 
	CASE WHEN pa.PropertyFundKey = -1 THEN 1 ELSE 0 END HasPropertyFundUnknown

From	ProfitabilityActual pa
			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey
			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey
			INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND		pas.SourceTable IN ('BillingUploadDetail')
AND		gac.MinorCategoryName <> 'Architects & Engineering'
--Only where one of the DimensionKey's are unknown
AND (
	CASE WHEN pa.ActivityTypeKey = -1 THEN 1 ELSE 0 END = 1 OR 
	CASE WHEN pa.AllocationRegionKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.FunctionalDepartmentKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.GlAccountKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN gac.MajorCategoryName like '%unknown%' THEN 1 ELSE 0 END = 1 OR 
	CASE WHEN pa.OriginatingRegionKey = -1 THEN 1 ELSE 0 END = 1 OR
	--CASE WHEN pa.OverheadKey = -1 THEN 1 ELSE 0 END = 1 OR
	CASE WHEN pa.PropertyFundKey = -1 THEN 1 ELSE 0 END = 1
	)

IF OBJECT_ID('tempdb..#GeneralLedger') IS NOT NULL
	DROP TABLE #GeneralLedger
	
--Step 1 :: Get all the TapasUS (Payroll) GeneralLedger Details, used to removed re-classed MRI items
		


-----------------------------------------------------------------------------------------------------------------------------------------------
--Step 8 :: OriginatingRegion & FunctionalDepartment Combination
--Sheet 1 :: OriginatingSubRegion And FunctionalDepartment

IF OBJECT_ID('tempdb..#ValidRegionAndFunctionalDepartment') IS NOT NULL
	DROP TABLE #ValidRegionAndFunctionalDepartment

CREATE TABLE #ValidRegionAndFunctionalDepartment
(OriginatingSubRegionName Varchar(50) NOT NULL,
FunctionalDepartmentName Varchar(50) NOT NULL
)
Insert Into #ValidRegionAndFunctionalDepartment
(FunctionalDepartmentName,OriginatingSubRegionName)
EXEC [stp_S_ValidPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuater,
	@DataPriorToDate = @DataPriorToDate

Insert Into #ValidRegionAndFunctionalDepartment
(FunctionalDepartmentName,OriginatingSubRegionName)
EXEC [stp_S_ValidNonPayrollRegionAndFunctionalDepartment] 
	@BudgetYear = @BudgetYear,
	@BudgetQuater = @BudgetQuater,
	@DataPriorToDate = @DataPriorToDate

--Select 
--		DISTINCT 
--		orr.Name GdmOriginatingRegionName,
--		orr.Code GdmOriginatingRegionCode,
--		fd.Code FunctionalDepartmentCode,
--		fd.Name FunctionalDepartmentName
--Into #ValidRegionAndFunctionalDepartment
--From	SERVER3.GACS.dbo.[Site] si
--			INNER JOIN SERVER3.GACS.dbo.Team te ON te.SiteID = si.SiteID
--			INNER JOIN SERVER3.GACS.dbo.StaffTeam st ON st.TeamID = te.TeamID
--			INNER JOIN SERVER3.GACS.dbo.Staff s ON s.StaffID = st.StaffID
--			INNER JOIN SERVER3.GACS.dbo.StaffFunctionalDepartment sf ON sf.StaffID = s.StaffID
--			INNER JOIN SERVER3.GACS.dbo.FunctionalDepartment fd ON fd.FunctionalDepartmentID = sf.FunctionalDepartmentID
--			INNER JOIN SERVER3.GACS.dbo.StaffEntity se ON se.StaffID = s.StaffID
--			INNER JOIN SERVER3.GACS.dbo.Entity e ON e.EntityRef = se.EntityRef
--			INNER JOIN SERVER3.Gdm.dbo.OriginatingRegionCorporateEntity orrce ON orrce.CorporateEntityCode = e.EntityRef AND orrce.SourceCode = e.[Source]
--			INNER JOIN SERVER3.Gdm.dbo.OriginatingSubRegion orr ON orr.OriginatingSubRegionGlobalRegionId = orrce.GlobalRegionId
--Where te.name like '%Budget Coordinator%'
--and e.IsHistoric = 0
--and e.[Source] like '%C'

------------------------------------------------------------------------------------------------------------------------------------------
--The view an interim solution, until the spreadhseet is finalyzed
------------------------------------------------------------------------------------------------------------------------------------------
--Select
--		DISTINCT 
--		list.OriginatingSubRegionName,
--		list.FunctionalDepartmentName
--Into #ValidRegionAndFunctionalDepartment
--From
--		GrReportingStaging.dbo.ValidOriginatingSubRegionAndFunctionalDepartment list

IF OBJECT_ID('tempdb..#InvalidRegionAndFunctDeptCombination') IS NOT NULL
	DROP TABLE #InvalidRegionAndFunctDeptCombination
	
Select  
		s.SourceCode,
		pa.ReferenceCode,
		fd.FunctionalDepartmentName,
		orr.SubRegionName
Into #InvalidRegionAndFunctDeptCombination
From ProfitabilityActual pa

		INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

		INNER JOIN [Source] s ON s.SourceKey = pa.SourceKey
		
		LEFT OUTER JOIN FunctionalDepartment fd ON 
					fd.FunctionalDepartmentKey = pa.FunctionalDepartmentKey
				
		LEFT OUTER JOIN OriginatingRegion orr ON 
					orr.OriginatingRegionKey = pa.OriginatingRegionKey

		LEFT OUTER JOIN GlAccountCategory gac ON 
					gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey
					
		LEFT OUTER JOIN #ValidRegionAndFunctionalDepartment vs 
			on vs.FunctionalDepartmentName = fd.FunctionalDepartmentName
			 AND vs.OriginatingSubRegionName = orr.SubRegionName

Where	vs.FunctionalDepartmentName IS NULL
--AND		s.SourceCode LIKE '%C' --GC 2010-11-25 removed this for in MRI actuals its not included
AND		pas.SourceTable IN ('BillingUploadDetail')
AND		gac.FeeOrExpense <> 'INCOME'
AND		gac.MinorCategoryName <> 'Architects & Engineering'



--Remove from this table the items, that the reclass logic already fixed the issue at hand
-->> No reclass removal required for the process do not exist in TAPAS


--Updated the existing rows in #ValidationSummary where FunctionalDepartment&OriginatingRegion combination is not valid
Update #ValidationSummary
Set	InValidRegionAndFunctionalDepartment = 1
	From	
		#InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination
						
Where	#ValidationSummary.ReferenceCode = InvalidRegionAndFunctDeptCombination.ReferenceCode
 AND	#ValidationSummary.SourceCode = InvalidRegionAndFunctDeptCombination.SourceCode


--Insert only where FunctionalDepartment&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown,InValidRegionAndFunctionalDepartment)
Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	0 HasActivityTypeUnknown, 
	0 HasAllocationRegionUnknown, 
	0 HasFunctionalDepartmentUnknown,
	0 HasGlAccountUnknown, 
	0 HasGlAccountCategoryUnknown, 
	0 HasOriginatingRegionUnknown,
	--1 HasOverheadUnknown, 
	0 HasPropertyFundUnknown,
	1 InValidRegionAndFunctionalDepartment

From	ProfitabilityActual pa

			INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey

			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey

			LEFT OUTER JOIN #ValidationSummary existing ON existing.SourceCode = ss.SourceCode AND existing.ReferenceCode = pa.ReferenceCode

			INNER JOIN #InvalidRegionAndFunctDeptCombination InvalidRegionAndFunctDeptCombination ON
						InvalidRegionAndFunctDeptCombination.ReferenceCode = pa.ReferenceCode
					AND	InvalidRegionAndFunctDeptCombination.SourceCode = ss.SourceCode
 
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod		
AND		existing.ReferenceCode IS NULL --Not in table yet
AND		pas.SourceTable IN ('BillingUploadDetail')
AND		gac.MinorCategoryName <> 'Architects & Engineering'


------------------------------------------------------------
--Sheet 2 :: ActivityType And Entity

IF OBJECT_ID('tempdb..#HolisticReviewExport') IS NOT NULL
	DROP TABLE #HolisticReviewExport
	
CREATE TABLE #HolisticReviewExport
(	ProjectCode varchar(20) NULL,
	ProjectName varchar(100) NULL,
	ProjectEndPeriod int NULL,
	ActivityType varchar(50) NULL,
	PropertyFund varchar(100) NULL,
	PropertyFundAllocationSubRegionName varchar(50) NULL,
	Source char(2) NULL,
	AllocationType varchar(100) NULL,
	CorporateDepartment char(8) NULL,
	CorporateDepartmentDescription varchar(50) NULL,
	ReportingEntity varchar(100) NULL,
	ReportingEntityAllocationSubRegionName varchar(50) NULL,
	EntityType varchar(50) NULL,
	BudgetOwner varchar(255) NULL,
	RegionalOwner varchar(255) NULL,
	BudgetCoordinatorDisplayNames nvarchar(max) NULL,
	IsTSCost Varchar(3) NULL,
	PropertyEntity char(6) NULL,
	PropertyEntityName nvarchar(264) NULL
)
SET XACT_ABORT ON

Insert Into #HolisticReviewExport
EXEC SERVER3.Gdm.dbo.HolisticReviewExport


IF OBJECT_ID('tempdb..#ValidActivityTypeEntity') IS NOT NULL
	DROP TABLE #ValidActivityTypeEntity
	
Select
		DISTINCT 
		list.ActivityType ActivityTypeName,
		list.AllocationType AllocationTypeName,
		list.ReportingEntity ReportingEntityName
Into #ValidActivityTypeEntity
From
		#HolisticReviewExport list


--Add additional entries provided by Martin: IMS 56718
Insert Into #ValidActivityTypeEntity
(ReportingEntityName, ActivityTypeName, AllocationTypeName)
Select t1.ReportingEntityName, t1.ActivityTypeName, t1.AllocationTypeName 
From AdditionalValidCombinationsForEntityActivity t1
		LEFT OUTER JOIN #ValidActivityTypeEntity t2
				ON t2.ReportingEntityName = t1.ReportingEntityName AND
				t2.ActivityTypeName = t1.ActivityTypeName AND
				t2.AllocationTypeName = t1.AllocationTypeName
Where t2.AllocationTypeName IS NULL


IF OBJECT_ID('tempdb..#InvalidActivityTypeEntityCombination') IS NOT NULL
	DROP TABLE #InvalidActivityTypeEntityCombination
	
Select  
		s.SourceCode,
		pa.ReferenceCode,

		vs.AllocationTypeName,
		REPLACE(gac.AccountSubTypeName,'-','') AccountSubTypeName,

		vs.ActivityTypeName LocalActivityTypeName,
		at.ActivityTypeName ValidationActivityTypeName,

		vs.ReportingEntityName,
		pf.PropertyFundName
		
Into #InvalidActivityTypeEntityCombination
From ProfitabilityActual pa

		INNER JOIN ProfitabilityActualSourceTable pas ON pas.ProfitabilityActualSourceTableId = pa.ProfitabilityActualSourceTableId

		INNER JOIN [Source] s ON s.SourceKey = pa.SourceKey
		
		INNER JOIN PropertyFund pf ON 
					pf.PropertyFundKey = pa.PropertyFundKey
				
		INNER JOIN ActivityType at ON 
					at.ActivityTypeKey = pa.ActivityTypeKey

		INNER JOIN GlAccountCategory gac ON 
					gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

		INNER JOIN Overhead oh ON oh.OverheadKey = pa.OverheadKey

		INNER JOIN Calendar ca ON ca.CalendarKey = pa.CalendarKey

		LEFT OUTER JOIN #ValidActivityTypeEntity vs 
			on 
				(	--GR
						gac.MajorCategoryName		<> 'Salaries/Taxes/Benefits'
				AND		oh.OverheadCode				= 'UNALLOC'
				AND		gac.AccountSubTypeName			= 'Overhead'
					--AM
				AND		vs.AllocationTypeName		= 'NonPayroll'
				AND		vs.ActivityTypeName			= 'Corporate Overhead'
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)
				OR
				(	--GR
						gac.MajorCategoryName		= 'Salaries/Taxes/Benefits'
				AND		oh.OverheadCode				= 'UNALLOC'
				AND		gac.AccountSubTypeName			= 'Overhead'
					--AM
				AND		vs.AllocationTypeName		= 'Payroll'
				AND		vs.ActivityTypeName			= 'Corporate Overhead'
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)
				OR
				(	--Default Match	
						vs.AllocationTypeName		= REPLACE(gac.AccountSubTypeName,'-','')
				AND		vs.ActivityTypeName			= at.ActivityTypeName
				AND		vs.ReportingEntityName		= pf.PropertyFundName
				)

Where	vs.ActivityTypeName		IS NULL
AND		pas.SourceTable			IN ('BillingUploadDetail')
AND		NOT(oh.OverheadCode		= 'ALLOC' AND gac.AccountSubTypeName = 'Overhead')
AND		gac.MinorCategoryName	<> 'Architects & Engineering'
AND		ca.CalendarPeriod		>= 201007 

--Remove from this table the items, that the reclass logic already fixed the issue at hand
-->>> This is not required for reclass is a option from TAPAS

--Delete the old Reporting Entity Names
Delete From #InvalidActivityTypeEntityCombination
Where LTRIM(RTRIM(PropertyFundName)) IN (
		Select 'ECM Business Development' ReportingEntity UNION
		Select 'Employee Reimbursables' ReportingEntity UNION
		Select 'US CORP TBD' ReportingEntity
		)

--Updated the existing rows in #ValidationSummary where FunctionalDepartment&OriginatingRegion combination is not valid
Update #ValidationSummary
Set	InvalidActivityTypeEntity = 1
	From	
		#InvalidActivityTypeEntityCombination InvalidActivityTypeEntityCombination
						
Where	#ValidationSummary.ReferenceCode = InvalidActivityTypeEntityCombination.ReferenceCode
 AND	#ValidationSummary.SourceCode = InvalidActivityTypeEntityCombination.SourceCode


--Insert only where ActivityTypeEntity&OriginatingRegion combination is not valid and the item is not in #ValidationSummary yet
Insert Into #ValidationSummary
(SourceCode,ProfitabilityActualKey, ReferenceCode, HasActivityTypeUnknown, HasAllocationRegionUnknown, 
HasFunctionalDepartmentUnknown,HasGlAccountUnknown, HasGlAccountCategoryUnknown, 
HasOriginatingRegionUnknown,--HasOverheadUnknown, 
HasPropertyFundUnknown,InvalidActivityTypeEntity)
Select 
	ss.SourceCode,
	pa.ProfitabilityActualKey, 
	pa.ReferenceCode, 
	0 HasActivityTypeUnknown, 
	0 HasAllocationRegionUnknown, 
	0 HasFunctionalDepartmentUnknown,
	0 HasGlAccountUnknown, 
	0 HasGlAccountCategoryUnknown, 
	0 HasOriginatingRegionUnknown,
	--1 HasOverheadUnknown, 
	0 HasPropertyFundUnknown,
	1 InValidRegionAndFunctionalDepartment

From	ProfitabilityActual pa

			INNER JOIN Calendar ca on ca.CalendarKey = pa.CalendarKey

			INNER JOIN GlAccountCategory gac ON gac.GlAccountCategoryKey = pa.GlobalGlAccountCategoryKey

			INNER JOIN [Source] ss ON ss.SourceKey = pa.SourceKey

			LEFT OUTER JOIN #ValidationSummary existing ON existing.SourceCode = ss.SourceCode AND existing.ReferenceCode = pa.ReferenceCode

			INNER JOIN #InvalidActivityTypeEntityCombination InvalidActivityTypeEntityCombination ON
						InvalidActivityTypeEntityCombination.ReferenceCode = pa.ReferenceCode
					AND	InvalidActivityTypeEntityCombination.SourceCode = ss.SourceCode
 
Where	ca.CalendarPeriod BETWEEN @StartPeriod AND @EndPeriod	
AND		ca.CalendarPeriod		>= 201007 	
AND		existing.ReferenceCode IS NULL --Not in table yet
AND		gac.MinorCategoryName <> 'Architects & Engineering'


------------------------------------------------------------------------------------------------------------------------------------------
--Now Remove the rows from #ValidationSummary, where the re-class of items cause the to be valid now
Delete From #ValidationSummary
Where	HasActivityTypeUnknown = 0
AND		HasAllocationRegionUnknown = 0
AND		HasFunctionalDepartmentUnknown = 0
AND		HasGlAccountUnknown = 0
AND		HasGlAccountCategoryUnknown = 0
AND		HasOriginatingRegionUnknown = 0
--AND		HasOverheadUnknown = 0
AND		HasPropertyFundUnknown = 0
AND		InValidRegionAndFunctionalDepartment = 0
AND		InValidActivityTypeEntity = 0


--Return the UNKNOWN's
Select 
	vs.SourceCode,
	CASE WHEN vs.HasActivityTypeUnknown = 1 THEN 'YES' ELSE 'NO' END HasActivityTypeUnknown,
	CASE WHEN vs.HasFunctionalDepartmentUnknown = 1 THEN 'YES' ELSE 'NO' END HasFunctionalDepartmentUnknown,
	CASE WHEN vs.HasOriginatingRegionUnknown = 1 THEN 'YES' ELSE 'NO' END HasOriginatingRegionUnknown,
	CASE WHEN vs.HasPropertyFundUnknown = 1 THEN 'YES' ELSE 'NO' END HasPropertyFundUnknown,
	CASE WHEN vs.HasAllocationRegionUnknown = 1 THEN 'YES' ELSE 'NO' END HasAllocationRegionUnknown,
	CASE WHEN vs.HasGlAccountUnknown = 1 THEN 'YES' ELSE 'NO' END HasGlAccountUnknown,
	CASE WHEN vs.HasGlAccountCategoryUnknown = 1 THEN 'YES' ELSE 'NO' END HasGlAccountCategoryUnknown,
	CASE WHEN vs.InValidRegionAndFunctionalDepartment = 1 THEN 'YES' ELSE 'NO' END InValidRegionAndFunctionalDepartment,
	CASE WHEN vs.InValidActivityTypeEntity = 1 THEN 'YES' ELSE 'NO' END InValidActivityTypeEntity,
	CASE WHEN 
		vs.HasActivityTypeUnknown = 1 OR 
		vs.HasFunctionalDepartmentUnknown = 1 OR
		vs.HasOriginatingRegionUnknown = 1 OR
		vs.InValidRegionAndFunctionalDepartment = 1 OR
		vs.InValidActivityTypeEntity = 1
	THEN CASE WHEN
			vs.HasPropertyFundUnknown = 1 OR
			vs.HasAllocationRegionUnknown = 1 OR
			vs.HasGlAccountUnknown = 1 OR
			vs.HasGlAccountCategoryUnknown = 1
		THEN 
			'Both Corporate Finance and Accounting'
		ELSE
			'Accounting - Re-class'
		END
	ELSE 
		'Corporate Finance - Mapping'
	END AS ResolvedBy,
	--DW
	gl.ExpensePeriod,
	gl.AllocationRegionCode,
	gl.AllocationRegionName,
	gl.OriginatingRegionCode,
	gl.OriginatingRegionSourceCode,
	gl.PropertyFundName,
	gl.FunctionalDepartmentCode,
	gl.ActivityTypeCode,
	gl.ForeignCurrency,
	gl.ForeignActual,
	gl.GlAccountCode,
	gl.EmployeeDisplayName
	
From #ValidationSummary vs

	INNER JOIN 
	(
		Select 
				Bud.BillingUploadDetailId,
				Bu.ExpensePeriod,
				GrAr.RegionCode AllocationRegionCode,
				GrAr.RegionName AllocationRegionName,
				Ovr.CorporateEntityRef OriginatingRegionCode,
				Ovr.CorporateSourceCode OriginatingRegionSourceCode,
				PF.Name PropertyFundName,
				Fd.GlobalCode FunctionalDepartmentCode,
				At.Code ActivityTypeCode,
				Bud.CurrencyCode ForeignCurrency,
				Bud.AllocationAmount ForeignActual,
				
				CASE
					WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
						ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
					ELSE
						ISNULL(OverheadPropertyFund.PropertyFundId, -1)
				END PFID,
				
				P1.PropertyFundId P1,
				P1.PropertyFundId P2,
				ISNULL(DepartmentPropertyFund.PropertyFundId, -1)  DepartmentPropertyFundId,
				ISNULL(OverheadPropertyFund.PropertyFundId, -1) OverheadPropertyFundId,
				GA.Code GlAccountCode,
				Emp.DisplayName EmployeeDisplayName
		From	
				(Select		
						Bu.*
					From	GrReportingStaging.TapasGlobal.BillingUpload Bu
								INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadActive(@DataPriorToDate) BuA 
							ON buA.ImportKey = bu.ImportKey
				) Bu
				
				LEFT OUTER JOIN SERVER3.ERPHR.dbo.HREmployee emp ON Emp.HREmployeeId = Bu.HREmployeeId
					
				INNER JOIN (Select 
								Bud.*
							From	GrReportingStaging.TapasGlobal.BillingUploadDetail Bud
										INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BudA 
											ON BudA.ImportKey = Bud.ImportKey
							) Bud ON Bud.BillingUploadId = Bu.BillingUploadId
						
				
				INNER JOIN (
							Select Oh.*
							From	GrReportingStaging.TapasGlobal.Overhead oh 
								INNER JOIN GrReportingStaging.TapasGlobal.OverheadActive(@DataPriorToDate) OhA ON
									OhA.ImportKey = Oh.ImportKey
							) Oh ON Oh.OverheadId = Bu.OverheadId

					LEFT OUTER JOIN (
									Select 
											Fd.*
									From GrReportingStaging.HR.FunctionalDepartment Fd 
										INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON
											FdA.ImportKey = Fd.ImportKey
									) Fd ON Fd.FunctionalDepartmentId = Bu.OverheadFunctionalDepartmentId

					LEFT OUTER JOIN (
									Select 
										P.*
									From GrReportingStaging.TapasGlobal.Project P
											INNER JOIN GrReportingStaging.TapasGlobal.ProjectActive(@DataPriorToDate) PA ON
												PA.ImportKey = P.ImportKey
									) P1 ON P1.ProjectId = Bu.ProjectId

					LEFT OUTER JOIN (
									Select 
										P.*
									From GrReportingStaging.TapasGlobal.Project P
											INNER JOIN GrReportingStaging.TapasGlobal.ProjectActive(@DataPriorToDate) PA ON
												PA.ImportKey = P.ImportKey
									) P2 ON
						P2.ProjectId = P1.AllocateOverheadsProjectId

					-- P1 ---------------------------

					LEFT OUTER JOIN GrReporting.dbo.[Source] GrScC ON
						GrScC.SourceCode = P1.CorporateSourceCode

					LEFT OUTER JOIN	(
									Select 
										RECD.*
									From GrReportingStaging.Gdm.ReportingEntityCorporateDepartment RECD
											INNER JOIN GrReportingStaging.Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
												RECDA.ImportKey = RECD.ImportKey
									)  RECDC ON GrScC.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
						RECDC.CorporateDepartmentCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
						RECDC.SourceCode = P1.CorporateSourceCode AND
						Bu.ExpensePeriod >= '201007' AND		   
						RECDC.IsDeleted = 0
						   
					LEFT OUTER JOIN (
									Select 
										REPE.*
									From GrReportingStaging.Gdm.ReportingEntityPropertyEntity REPE
												INNER JOIN GrReportingStaging.Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
													REPEA.ImportKey = REPE.ImportKey
									) REPEC ON -- added
						GrScC.IsProperty = 'YES' AND -- only property MRIs resolved through this
						REPEC.PropertyEntityCode = LTRIM(RTRIM(P1.CorporateDepartmentCode)) AND
						REPEC.SourceCode = P1.CorporateSourceCode AND
						Bu.ExpensePeriod >= '201007' AND
						REPEC.IsDeleted = 0

					LEFT OUTER JOIN (
									Select pfm.*
									From	GrReportingStaging.Gdm.PropertyFundMapping Pfm 
												INNER JOIN GrReportingStaging.Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
													PfmA.ImportKey = Pfm.ImportKey
									) pfm ON pfm.PropertyFundCode = P1.CorporateDepartmentCode AND -- Combination of entity and corporate department
						pfm.SourceCode = P1.CorporateSourceCode AND
						pfm.IsDeleted = 0 AND 
						(
							(GrScC.IsProperty = 'YES' AND pfm.ActivityTypeId IS NULL) 
							OR
							(
								(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId = Bu.ActivityTypeId)
								OR
								(GrScC.IsCorporate = 'YES' AND pfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL)
							)
						) AND Bu.ExpensePeriod < '201007' 
						
					LEFT OUTER JOIN GrReporting.dbo.PropertyFund DepartmentPropertyFund ON
						DepartmentPropertyFund.PropertyFundId =
							CASE
								WHEN Bu.ExpensePeriod < '201007' THEN pfm.PropertyFundId
								ELSE
									CASE
										WHEN GrScC.IsCorporate = 'YES' THEN RECDC.PropertyFundId
										ELSE REPEC.PropertyFundId
									END
							END -- extra condition? re: date

					-- P1 end -----------------------
					-- P2 ---------------------------

					LEFT OUTER JOIN GrReporting.dbo.[Source] GrScO
						ON GrScO.SourceCode = P2.CorporateSourceCode

					LEFT OUTER JOIN	(
									Select 
											RECD.*
									From	GrReportingStaging.Gdm.ReportingEntityCorporateDepartment RECD
												INNER JOIN GrReportingStaging.Gdm.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) RECDA ON
													RECDA.ImportKey = RECD.ImportKey
									) RECDO ON -- added
						GrScO.IsCorporate = 'YES' AND -- only corporate MRIs resolved through this
						RECDO.CorporateDepartmentCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
						RECDO.SourceCode = P2.CorporateSourceCode AND
						Bu.ExpensePeriod >= '201007'  AND 
						RECDO.IsDeleted = 0
						   
					LEFT OUTER JOIN (
									Select 
										REPE.*
									From GrReportingStaging.Gdm.ReportingEntityPropertyEntity REPE
												INNER JOIN GrReportingStaging.Gdm.ReportingEntityPropertyEntityActive(@DataPriorToDate) REPEA ON
													REPEA.ImportKey = REPE.ImportKey
									)  REPEO ON -- added
						GrScO.IsProperty = 'YES' AND -- only property MRIs resolved through this
						REPEO.PropertyEntityCode = LTRIM(RTRIM(P2.CorporateDepartmentCode)) AND
						REPEO.SourceCode = P2.CorporateSourceCode AND
						Bu.ExpensePeriod >= '201007'  AND
						REPEO.IsDeleted = 0

					LEFT OUTER JOIN (
									Select pfm.*
									From	GrReportingStaging.Gdm.PropertyFundMapping Pfm 
												INNER JOIN GrReportingStaging.Gdm.PropertyFundMappingActive(@DataPriorToDate) PfmA ON
													PfmA.ImportKey = Pfm.ImportKey
									) opfm ON
						P2.CorporateDepartmentCode = opfm.PropertyFundCode AND -- Combination of entity and corporate department
						P2.CorporateSourceCode = opfm.SourceCode AND
						opfm.IsDeleted = 0  AND 
						(
							(GrScO.IsProperty = 'YES' AND opfm.ActivityTypeId IS NULL) 
							OR
							(
								(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId = Bu.ActivityTypeId)
								OR
								(GrScO.IsCorporate = 'YES' AND opfm.ActivityTypeId IS NULL AND Bu.ActivityTypeId IS NULL) 
							)	
						) AND Bu.ExpensePeriod < '201007' 

					LEFT OUTER JOIN GrReporting.dbo.PropertyFund OverheadPropertyFund ON
						OverheadPropertyFund.PropertyFundId =
							CASE
								WHEN Bu.ExpensePeriod < '201007' THEN opfm.PropertyFundId
								ELSE
									CASE
										WHEN GrScO.IsCorporate = 'YES' THEN RECDO.PropertyFundId
										ELSE REPEO.PropertyFundId
									END
							END	

					-- P2 end -----------------------

					LEFT OUTER JOIN (
									Select 
										PF.*
										From	GrReportingStaging.Gdm.PropertyFund PF 
													INNER JOIN GrReportingStaging.Gdm.PropertyFundActive(@DataPriorToDate) PFA ON
														PFA.ImportKey = PF.ImportKey
									) PF ON PF.PropertyFundId = (
												CASE
												WHEN (P1.AllocateOverheadsProjectId IS NULL OR P1.AllocateOverheadsProjectId = 0) THEN 
													ISNULL(DepartmentPropertyFund.PropertyFundId, -1)
												ELSE
													ISNULL(OverheadPropertyFund.PropertyFundId, -1)
											END
											)
						
					LEFT OUTER JOIN (Select	
										ASR.*
									From	GrReportingStaging.Gdm.AllocationSubRegion ASR
											INNER JOIN	GrReportingStaging.Gdm.AllocationSubRegionActive(@DataPriorToDate) ASRA ON ASRA.ImportKey = ASR.ImportKey
									) ASR ON PF.AllocationSubRegionGlobalRegionId = ASR.AllocationSubRegionGlobalRegionId


					LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr ON
						GrAr.GlobalRegionId = ASR.AllocationSubRegionGlobalRegionId --AND
						-- ISNULL(Gl.LastDate, EnterDate) BETWEEN GrAr.StartDate AND GrAr.EndDate ???????

					LEFT OUTER JOIN (Select 
										At.*
									From 	GrReportingStaging.Gdm.ActivityType At
												INNER JOIN GrReportingStaging.Gdm.ActivityTypeActive(@DataPriorToDate) Ata ON
														Ata.ImportKey = At.ImportKey
									) At ON
						At.ActivityTypeId = Bu.ActivityTypeId

					LEFT OUTER JOIN (Select		
										Ovr.*
									From	GrReportingStaging.TapasGlobal.OverheadRegion Ovr 
												INNER JOIN GrReportingStaging.TapasGlobal.OverheadRegionActive(@DataPriorToDate) OvrA ON
													OvrA.ImportKey = Ovr.ImportKey
									) Ovr ON
						Ovr.OverheadRegionId = Bu.OverheadRegionId	
						
					
						LEFT OUTER JOIN #ActivityTypeGLAccount AtGla ON
							AtGla.ActivityTypeId = At.ActivityTypeId

						LEFT OUTER JOIN (
										Select	
												GLA.*
										FROM
												GrReportingStaging.Gdm.GLGlobalAccount GLA
												INNER JOIN GrReportingStaging.Gdm.GLGlobalAccountActive(@DataPriorToDate) GLAA ON
													GLAA.ImportKey = GLA.ImportKey
										) GA ON
							GA.Code = AtGla.GLAccountCode AND
							ISNULL(AtGla.ActivityTypeId, 0) = ISNULL(GA.ActivityTypeId, 0) -- Nulls for header (00) accounts. (Should really have an activity for this)
	
					
						
	) gl on vs.ReferenceCode = 'BillingUploadDetailId=' + LTRIM(STR(gl.BillingUploadDetailId, 10, 0))
Order By vs.SourceCode, vs.ReferenceCode
