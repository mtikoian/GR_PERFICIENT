USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrTimeAllocationActual]    Script Date: 07/12/2012 01:48:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_LoadGrTimeAllocationActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_LoadGrTimeAllocationActual]
GO

USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[stp_IU_LoadGrTimeAllocationActual]    Script Date: 07/12/2012 01:48:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************************************************************
Description
	This stored procedure processes actual transaction data and uploads it to the
	ProfitabilityActual table in the data warehouse (GrReporting.dbo.ProfitabilityActual)
	
	1. Set the default unknown values to be used in the fact tables
	2. Get data exclusion lists (Manage Type tables) from GDM
	3. Source MRI data from USCORP, USPROP, EUCORP, EUPROP, INCORP, INPROP, BRCORP, BRPROP
	4. Obtain mapping data from GDM (Excluding GL Categorization Hierarchy), GACS and HR
	5. Map GDM GL Account Categorization Data
	6. Map General Ledger to GDM, HR and GACS mapping data
	7. Insert data into table representing schema of ProfitabilityActual
	8. Transfer the data to the GrReporting.dbo.ProfitabilityActual fact table
	9. Clean up

***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[stp_IU_LoadGrTimeAllocationActual]
	@ImportStartDate	DateTime=NULL,
	@ImportEndDate		DateTime=NULL,
	@DataPriorToDate	DateTime=NULL
AS

SET NOCOUNT ON
--declare	@ImportStartDate	DateTime=NULL,	@ImportEndDate		DateTime=NULL,	@DataPriorToDate	DateTime=NULL


IF ((SELECT TOP 1 CONVERT(INT, ConfiguredValue) FROM GrReportingStaging.dbo.SSISConfigurations WHERE ConfigurationFilter = 'CanImportTimeAllocationActuals') <> 1)
BEGIN
	PRINT ('Import of Tapas Time Allocation Actuals is not scheduled in GrReportingStaging.dbo.SSISConfigurations. Aborting ...')
	RETURN
END

PRINT '####'
PRINT 'stp_IU_LoadGrTimeAllocationActual'
PRINT CONVERT(VARCHAR(27), GETDATE(), 121)
PRINT '####'

DECLARE @StartTime DATETIME
DECLARE @StartTime2 DATETIME
DECLARE @RowCount INT

IF (@ImportStartDate IS NULL)
	BEGIN
	SET @ImportStartDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportStartDate'))
	END

IF (@ImportEndDate IS NULL)
	BEGIN
	SET @ImportEndDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualImportEndDate'))
	END

IF (@DataPriorToDate IS NULL)
	BEGIN
	SET @DataPriorToDate = CONVERT(DateTime,(SELECT ConfiguredValue FROM SSISConfigurations WHERE ConfigurationFilter = 'ActualDataPriorToDate'))
	END
	
	
Declare @ImportStartPeriod int = year(@ImportStartDate)*100+month(@ImportStartDate)
Declare @ImportEndPeriod int = year(@ImportEndDate)*100+month(@ImportEndDate)
/* ===========================================================================================================================================
	1. Set the default unknown values to be used in the fact tables - these are used when a join can't be made to a dimension
   =========================================================================================================================================== */
   
DECLARE 
	@FunctionalDepartmentKeyUnknown INT,
	@ReimbursableKeyUnknown INT,
	@ActivityTypeKeyUnknown INT,
	@SourceKeyUnknown INT,
	@OriginatingRegionKeyUnknown INT,
	@AllocationRegionKeyUnknown INT,
	@PropertyFundKeyUnknown INT,
	@ReportingEntityKeyUnknown INT,
	
		@LocalCurrencyKeyUnknown		 INT = (SELECT CurrencyKey FROM GrReporting.dbo.Currency WHERE CurrencyCode = 'USD'),
		@ProjectKeyUnknown				INT = -1,
		@ProjectGroupKeyUnknown		INT = -1,
		@EmployeeKeyUnknown			INT = -1

   
SET @FunctionalDepartmentKeyUnknown = (SELECT FunctionalDepartmentKey FROM GrReporting.dbo.FunctionalDepartment WHERE FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKeyUnknown		    = (SELECT ReimbursableKey FROM GrReporting.dbo.Reimbursable WHERE ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKeyUnknown		    = (SELECT ActivityTypeKey FROM GrReporting.dbo.ActivityType WHERE ActivityTypeCode = 'UNKNOWN')
SET @SourceKeyUnknown				= (SELECT SourceKey FROM GrReporting.dbo.Source WHERE SourceName = 'UNKNOWN')
SET @OriginatingRegionKeyUnknown	= (SELECT OriginatingRegionKey FROM GrReporting.dbo.OriginatingRegion WHERE RegionCode = 'UNKNOWN' AND SnapshotId = 0)
SET @AllocationRegionKeyUnknown	    = (SELECT AllocationRegionKey FROM GrReporting.dbo.AllocationRegion WHERE RegionCode = 'UNKNOWN' AND SnapshotId = 0)
SET @PropertyFundKeyUnknown		    = (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFundFTE WHERE PropertyFundName = 'UNKNOWN' AND SnapshotId = 0)
SET @ReportingEntityKeyUnknown		= (SELECT PropertyFundKey FROM GrReporting.dbo.PropertyFund WHERE PropertyFundName = 'UNKNOWN' AND SnapshotId = 0)

/* ===========================================================================================================================================
	2. Create temp tables
   =========================================================================================================================================== */
/*
-------------#Employee----------------

SET @StartTime = GETDATE()


CREATE TABLE #Employee 
(
	EmployeeKey INT NOT NULL,
	HREmployeeId INT NOT NULL,
	StaffId INT NULL
)

INSERT INTO #Employee
(
	EmployeeKey,
	HREmployeeId,
	StaffId
)
SELECT
	GREM.EmployeeKey,
	GREM.HREmployeeId,
	GREM.StaffId
FROM
	TapasGlobal.HREmployee TGEM
	INNER JOIN TapasGlobal.HREmployeeActive(@DataPriorToDate) A ON TGEM.ImportKey=A.ImportKey
	INNER JOIN GrReporting.dbo.Employee GREM ON
		TGEM.HREmployeeId = GREM.HREmployeeId
		
	PRINT 'Completed inserting records into #Employee: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
CREATE CLUSTERED INDEX IX_#Employee_HREmployeeId ON #Employee (HREmployeeId) 
CREATE NONCLUSTERED INDEX IX_#Employee_StaffId ON #Employee (StaffId) INCLUDE(EmployeeKey)
	
	
	PRINT 'Completed creating indexes on #Employee'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	*/
	
	-------------#Project----------------
	SET @StartTime = GETDATE()
CREATE TABLE #Project
(
	ProjectKey INT NOT NULL,
	ProjectId INT NOT NULL,
	CorporateSourceCode VARCHAR(10) NOT NULL,
	CorporateDepartmentCode VARCHAR(8) NOT NULL,
	IsTsCost BIT NOT NULL,
	ActivityTypeId INT NOT NULL,
	PropertyFundId INT NOT NULL,
	StartDate datetime NOT NULL,
	EndDate datetime NOT NULL
)

INSERT INTO #Project
(
	ProjectKey,
	ProjectId,
	CorporateSourceCode,
	CorporateDepartmentCode,
	IsTsCost,
	ActivityTypeId,
	PropertyFundId,
	StartDate,
	EndDate
)
SELECT 
	GRP.ProjectKey,
	GRP.ProjectId,
	TGP.CorporateSourceCode,
	TGP.CorporateDepartmentCode,
	TGP.IsTSCost,
	TGP.ActivityTypeId,
	TGP.PropertyFundId,
	GRP.StartDate,
	GRP.EndDate
FROM
	TapasGlobal.Project TGP
	INNER JOIN GrReportingStaging.TapasGlobal.ProjectActive(@DataPriorToDate) PA ON TGP.ImportKey = PA.ImportKey
	INNER JOIN GrReporting.dbo.Project GRP ON TGP.ProjectId = GRP.ProjectId AND GRP.BudgetProjectId = -1
	
	PRINT 'Completed inserting records into #Project: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))	
	
CREATE CLUSTERED INDEX IX_#Project_ProjectId ON #Project (ProjectId) 

		PRINT 'Completed creating indexes on ##Project'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
-------------#ProjectGroup----------------	
	SET @StartTime = GETDATE()
CREATE TABLE #ProjectGroup
(
	ProjectGroupKey INT NOT NULL,
	ProjectGroupId INT NOT NULL,
	StartDate datetime NOT NULL,
	EndDate datetime NOT NULL	
)

INSERT INTO #ProjectGroup
(
	ProjectGroupKey,
	ProjectGroupId,
	StartDate,
	EndDate	
)
SELECT 
	GRPG.ProjectGroupKey,
	GRPG.ProjectGroupId,
	GRPG.StartDate,
	GRPG.EndDate
FROM
	TapasGlobal.ProjectGroup TGPG
	INNER JOIN GrReportingStaging.TapasGlobal.ProjectGroupActive(@DataPriorToDate) PGA ON TGPG.ImportKey = PGA.ImportKey
	INNER JOIN GrReporting.dbo.ProjectGroup GRPG ON TGPG.ProjectGroupId = GRPG.ProjectGroupId 
		AND GRPG.BudgetProjectGroupId = -1
		
	
		PRINT 'Completed inserting records into #ProjectGroup: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
CREATE CLUSTERED INDEX IX_#ProjectGroup_ProjectGroupId ON #ProjectGroup (ProjectGroupId) 

PRINT 'Completed creating indexes on #ProjectGroup'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------#ProjectGroupAllocation----------------	
SET @StartTime = GETDATE()
CREATE TABLE #ProjectGroupAllocation
(
	[ProjectGroupAllocationId] [int] NOT NULL,
	[ProjectGroupId] [int] NOT NULL,
	[EffectivePeriod] [int] NOT NULL,
	[EffectiveEndPeriod] [int] NOT NULL
)
INSERT #ProjectGroupAllocation
SELECT P.ProjectGroupAllocationId,P.ProjectGroupId,P.EffectivePeriod,P.EffectiveEndPeriod
FROM TapasGlobal.ProjectGroupAllocation P 

	PRINT 'Completed inserting records into #ProjectGroupAllocation: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



CREATE CLUSTERED INDEX IX_#ProjectGroupAllocation_ProjectGroupId ON #ProjectGroupAllocation (ProjectGroupId,EffectivePeriod,EffectiveEndPeriod)

PRINT 'Completed creating indexes on #ProjectGroupAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------#AllocationWeight----------------	
SET @StartTime = GETDATE()
CREATE TABLE #AllocationWeight
(
	[AllocationWeightId] [int] NOT NULL,
	[ProjectGroupAllocationId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Weight] [numeric](18, 9) NOT NULL
)

INSERT #AllocationWeight
SELECT O.AllocationWeightId,O.ProjectGroupAllocationId,O.ProjectId,O.Weight
FROM TapasGlobal.AllocationWeight O join TapasGlobal.AllocationWeightActive(@DataPriorToDate) A
ON O.ImportKey = A.ImportKey

	PRINT 'Completed inserting records into #AllocationWeight: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


CREATE CLUSTERED INDEX IX_#AllocationWeight_ProjectGroupAllocationId 
   ON #AllocationWeight (ProjectGroupAllocationId)


PRINT 'Completed creating indexes on #AllocationWeight'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))	


-------------#PropertyFund----------------			
		SET @StartTime = GETDATE()
CREATE TABLE #PropertyFund
(
	PropertyFundKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NULL,
	StartDate DateTime NULL,
	EndDate DateTime NULL
)

INSERT INTO #PropertyFund
(
	PropertyFundKey,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	StartDate,
	EndDate
)
SELECT
	GRPF.PropertyFundKey,
	GRPF.PropertyFundId,
	GMPF.AllocationSubRegionGlobalRegionId,
	GMPF.BudgetOwnerStaffId,
	GRPF.StartDate,
	GRPF.EndDate
FROM GDM.PropertyFund GMPF
	INNER JOIn GDM.PropertyFundActive(@DataPriorToDate) PA on PA.ImportKey = GMPF.ImportKey
	INNER JOIN GrReporting.dbo.PropertyFundFTE GRPF on GMPF.PropertyFundId = GRPF.PropertyFundId 
		and GRPF.SnapshotId = 0
	
		
				
	PRINT 'Completed inserting records into #PropertyFund: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
CREATE CLUSTERED INDEX IX_#PropertyFund_PropertyFundId ON #PropertyFund (PropertyFundId) 
		


PRINT 'Completed creating indexes on #PropertyFund'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


-------------#ReportingEntity----------------			
		SET @StartTime = GETDATE()
CREATE TABLE #ReportingEntity
(
	PropertyFundKey INT NOT NULL,
	PropertyFundId INT NOT NULL,
	AllocationSubRegionGlobalRegionId INT NOT NULL,
	BudgetOwnerStaffId INT NULL,
	BudgetOwnerStaff varchar(255) NULL,
	StartDate DateTime NULL,
	EndDate DateTime NULL
)

INSERT INTO #ReportingEntity
(
	PropertyFundKey,
	PropertyFundId,
	AllocationSubRegionGlobalRegionId,
	BudgetOwnerStaffId,
	BudgetOwnerStaff,
	StartDate,
	EndDate
)
SELECT
	GRPF.PropertyFundKey,
	GRPF.PropertyFundId,
	GMPF.AllocationSubRegionGlobalRegionId,
	GMPF.BudgetOwnerStaffId,
	Staff.DisplayName,
	GRPF.StartDate,
	GRPF.EndDate
FROM GDM.PropertyFund GMPF
	INNER JOIn GDM.PropertyFundActive(@DataPriorToDate) PA on PA.ImportKey = GMPF.ImportKey
	INNER JOIN GrReporting.dbo.PropertyFund GRPF on GMPF.PropertyFundId = GRPF.PropertyFundId 
		and GRPF.SnapshotId = 0
	left JOIN GACS.Staff on GMPF.BudgetOwnerStaffId=Staff.StaffID
				
	PRINT 'Completed inserting records into #ReportingEntity: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
CREATE CLUSTERED INDEX IX_#ReportingEntity_PropertyFundId ON #ReportingEntity (PropertyFundId) 
		


PRINT 'Completed creating indexes on #ReportingEntity'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
		
-------------#EmployeeHistory----------------	
SET @StartTime = GETDATE()
CREATE TABLE #EmployeeHistory
(
	EmployeeKey INT NOT NULL,
	StartDate DateTime NULL,
	EndDate DateTime NULL,
	HREmployeeId INT NOT NULL,
	--PayGroupId INT NOT NULL,
	--LocationId INT NOT NULL,
	FunctionalDepartmentId INT NOT NULL,
	--SubDepartmentId INT NOT NULL,
	CorporateEntityRef [varchar](6) NOT NULL, 
	CorporateSourceCode [varchar](2) NOT NULL
)

INSERT INTO #EmployeeHistory
(
	EmployeeKey,
	StartDate ,
	EndDate,
	HREmployeeId ,
	--PayGroupId,
	--LocationId ,
	FunctionalDepartmentId,
	--SubDepartmentId,
	CorporateEntityRef, 
	CorporateSourceCode
)
SELECT 
    hh1.EmployeeKey,
	hh1.StartDate,
	hh1.EndDate,
	hh1.HREmployeeId,
	--hh1.PayGroupId,
	--hh1.LocationId,
	hh2.FunctionalDepartmentId,
	--hh1.SubDepartmentId,
	hh1.CorporateEntityRef,
	hh1.CorporateSourceCode
FROM GrReporting.dbo.Employee hh1 
join GrReportingStaging.TapasGlobal.EmployeeHistory hh2 on hh2.EmployeeHistoryId=hh1.EmployeeHistoryId


	PRINT 'Completed inserting records into ##EmployeeHistory: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#EmployeeHistory_HREmployeeId ON #EmployeeHistory (HREmployeeId,StartDate,EndDate) 


PRINT 'Completed creating indexes on ##EmployeeHistory'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------#FunctionalDepartment----------------	
SET @StartTime = GETDATE()
CREATE TABLE #FunctionalDepartment
(
	--FunctionalDepartmentKey INT NOT NULL,
	FunctionalDepartmentId Int NOT NULL,
	FunctionalDepartmentCode CHAR(3) NULL
)

INSERT INTO #FunctionalDepartment
(
	--FunctionalDepartmentKey,
	FunctionalDepartmentId,
	FunctionalDepartmentCode
)
SELECT 
	--GRFD.FunctionalDepartmentKey,
	HRFD.FunctionalDepartmentId,
	HRFD.GlobalCode

FROM HR.FunctionalDepartment HRFD
	INNER JOIN GrReportingStaging.HR.FunctionalDepartmentActive(@DataPriorToDate) FDA ON HRFD.ImportKey = FDA.ImportKey
	--INNER JOIN HR.SubDepartment HRSD ON HRFD.FunctionalDepartmentId = HRSD.FunctionalDepartmentId
	--	AND HRSD.IsActive = 1 AND HRFD.IsActive = 1
	--INNER JOIN GrReporting.dbo.FunctionalDepartment GRFD ON HRFD.GlobalCode = GRFD.FunctionalDepartmentCode
	--	AND GRFD.SubFunctionalDepartmentCode = HRFD.GlobalCode 
	
	PRINT 'Completed inserting records into ##FunctionalDepartment: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

PRINT 'Completed creating indexes on ##FunctionalDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------#ConsolidationRegionCorporateDepartment----------------
SET @StartTime = GETDATE()	
CREATE TABLE #ConsolidationRegionCorporateDepartment
(
	[ConsolidationRegionCorporateDepartmentId] [int] NOT NULL,
	[CorporateDepartmentCode] [varchar](10) NOT NULL,
	[SourceCode] [varchar](2) NOT NULL,
	[GlobalRegionId] [int] NOT NULL
)

INSERT INTO #ConsolidationRegionCorporateDepartment
(
	[ConsolidationRegionCorporateDepartmentId],
	[CorporateDepartmentCode],
	[SourceCode],
	[GlobalRegionId]
)
SELECT 
	GMCRCD.ConsolidationRegionCorporateDepartmentId,
	GMCRCD.CorporateDepartmentCode,
	GMCRCD.SourceCode,
	GMCRCD.GlobalRegionId
FROM GDM.ConsolidationRegionCorporateDepartment GMCRCD
	INNER JOIN GDM.ConsolidationRegionCorporateDepartmentActive(@DataPriorToDate) CRCDA ON GMCRCD.ImportKey = CRCDA.ImportKey


	PRINT 'Completed inserting records into #ConsolidationRegionCorporateDepartment: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))



CREATE CLUSTERED INDEX IX_#ConsolidationRegionCorporateDepartment 
   ON #ConsolidationRegionCorporateDepartment (CorporateDepartmentCode,SourceCode) 

PRINT 'Completed creating indexes on #ConsolidationRegionCorporateDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

/*
--------------#Location----------------
SET @StartTime = GETDATE()
CREATE TABLE #Location
(
	[LocationId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL
)	
INSERT INTO #Location
SELECT l.LocationId,l.ExternalSubRegionId
FROM HR.Location l join HR.LocationActive(@DataPriorToDate) a on l.ImportKey=a.ImportKey

	PRINT 'Completed inserting records into #Location: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#Location_LocationId ON #Location (LocationId) 


PRINT 'Completed creating indexes on #Location'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

--------------#PayGroup----------------
SET @StartTime = GETDATE()
CREATE TABLE #PayGroup
(
	[PayGroupId] [int] NOT NULL,
	--[PayFrequencyId] [int] NOT NULL,
	[RegionId] [int] NOT NULL
)
INSERT INTO #PayGroup
SELECT 	p.PayGroupId,p.RegionId
FROM HR.PayGroup p join HR.PayGroupActive(@DataPriorToDate) a on p.ImportKey=a.ImportKey
	
	

	PRINT 'Completed inserting records into #PayGroup: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
CREATE CLUSTERED INDEX IX_#PayGroup_PayGroupId ON #PayGroup (PayGroupId) 


PRINT 'Completed creating indexes on #PayGroup'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


--------------#PayrollRegion----------------
SET @StartTime = GETDATE()
CREATE TABLE #PayrollRegion
(
	[RegionId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL,
	[CorporateEntityRef] [varchar](6) NOT NULL,
	[CorporateSourceCode] [varchar](2) NOT NULL
)
INSERT INTO #PayrollRegion
SELECT PR.RegionId,
PR.ExternalSubRegionId,
PR.CorporateEntityRef,
PR.CorporateSourceCode
FROM TapasGlobal.PayrollRegion PR join TapasGlobal.PayrollRegionActive(@DataPriorToDate) A 
on A.ImportKey = PR.ImportKey



	PRINT 'Completed inserting records into #PayrollRegion: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
CREATE CLUSTERED INDEX IX_#PayrollRegion_RegionId ON #PayrollRegion (ExternalSubRegionId,RegionId) 



PRINT 'Completed creating indexes on #PayrollRegion'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
*/
--------------#OriginatingRegionCorporateEntity----------------
SET @StartTime = GETDATE()
CREATE TABLE #OriginatingRegionCorporateEntity
(

	[OriginatingRegionCorporateEntityId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[CorporateEntityCode] [varchar](10) NOT NULL,
	[SourceCode] [char](2) NOT NULL
)

INSERT #OriginatingRegionCorporateEntity
SeLECT O.OriginatingRegionCorporateEntityId,
O.GlobalRegionId,
O.CorporateEntityCode,
O.SourceCode
FROM GDM.OriginatingRegionCorporateEntity O join GDM.OriginatingRegionCorporateEntityActive(@DataPriorToDate) A
ON O.ImportKey=A.ImportKey

	PRINT 'Completed inserting records into #OriginatingRegionCorporateEntity: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
CREATE CLUSTERED INDEX IX_#OriginatingRegionCorporateEntity_CorporateEntityCode 
	ON #OriginatingRegionCorporateEntity (CorporateEntityCode,SourceCode) 



PRINT 'Completed creating indexes on #OriginatingRegionCorporateEntity'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
-------------#ReportingEntityCorporateDepartment-------------	
SET @StartTime = GETDATE()
CREATE TABLE #ReportingEntityCorporateDepartment(
	
	[PropertyFundId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[CorporateDepartmentCode] [char](6) NOT NULL
	
)	
INSERT #ReportingEntityCorporateDepartment
SELECT O.PropertyFundId,
O.SourceCode,
O.CorporateDepartmentCode
FROM GDM.ReportingEntityCorporateDepartment O JOIN GDM.ReportingEntityCorporateDepartmentActive(@DataPriorToDate) A
ON O.ImportKey=A.ImportKey


	PRINT 'Completed inserting records into #ReportingEntityCorporateDepartment: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
CREATE CLUSTERED INDEX IX_#ReportingEntityCorporateDepartment_CorporateDepartmentCode
	ON #ReportingEntityCorporateDepartment (CorporateDepartmentCode,SourceCode) 



PRINT 'Completed creating indexes on #ReportingEntityCorporateDepartment'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

-------------#TimeAllocation-------------
SET @StartTime = GETDATE()
CREATE TABLE #TimeAllocation
(
	[TimeAllocationId] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[HREmployeeId] [int] NOT NULL,
	[ApprovedByStaffId] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[ApprovedDate] [datetime] NOT NULL,
	[ApprovedByStaff] varchar(255) NULL,
	AllocationDate datetime NOT NULL
	
)
INSERT INTO #TimeAllocation
SELECT T.TimeAllocationId,
T.Period,
T.HREmployeeId,
T.ApprovedByStaffId,
T.InsertedDate,
T.UpdatedDate,
T.ApprovedDate,
T.ApprovedByStaffName,
dateadd(dd,-1,dateadd(mm,1,LEFT(T.Period,4)+'-'+RIGHT(T.Period,2)+'-01')) -- the last day of this Period
FROM GrReportingStaging.TapasGlobal.TimeAllocation T
INNER JOIN TapasGlobal.TimeAllocationActive(@DataPriorToDate) A on T.ImportKey=A.ImportKey
where T.ApprovalStatusId in (3,4) and T.LockStatusId=3 
and T.Period between @ImportStartPeriod and @ImportEndPeriod
 --and  T.HREmployeeId=1307 and T.Period=201204  

/*
1.	Import all actual time allocations that have been entered in Tapas Global that have been ‘User Approved’ or ‘Auto Approved’.
a.	Project Groups will be broken down into individual projects.
2.	Import all actual time allocations that have been locked (Normal allocations).



ApprovalStatusId does relate to the approval above, the values are as follows:
•         1 - InProgress
•         2 - PendingApproval
•         3 - AutoApproved
•         4 - UserApproved

The list of locked statuses are:
•         1 – Open
•         2 – PreLocked
•         3 – Locked


*/


	PRINT 'Completed inserting records into #TimeAllocation: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#TimeAllocation_TimeAllocationId 
    ON #TimeAllocation (TimeAllocationId) 



PRINT 'Completed creating indexes on #TimeAllocation'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
    
    
    SET @StartTime = GETDATE()
    
CREATE TABLE #TimeAllocationDetail
(
	[TimeAllocationDetailId] [int] NOT NULL,
	[TimeAllocationId] [int] NOT NULL,
	[AllocationValueTypeId] [int] NOT NULL,
	[ProjectId] [int] NULL,
	[ProjectGroupId] [int] NULL,
	[AllocationValue] [numeric](18, 9) NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
)

INSERT INTO #TimeAllocationDetail
SELECT T.TimeAllocationDetailId,
T.TimeAllocationId,
T.AllocationValueTypeId,
T.ProjectId,
T.ProjectGroupId,
T.AllocationValue,
T.UpdatedDate
FROM GrReportingStaging.TapasGlobal.TimeAllocationDetail T
INNER JOIN TapasGlobal.TimeAllocationDetailActive(@DataPriorToDate) A on T.ImportKey=A.ImportKey
INNER JOIN #TimeAllocation TA ON T.TimeAllocationId = TA.TimeAllocationId

	PRINT 'Completed inserting records into #TimeAllocationDetail: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#TimeAllocationDetail_TimeAllocationId 
    ON #TimeAllocationDetail (TimeAllocationId) 

PRINT 'Completed creating indexes on #TimeAllocationDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
	
	
	SET @StartTime = GETDATE()
	
CREATE TABLE #TimeAllocationDetailBillingUpload
(
	[TimeAllocationId] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[ApprovedByStaff] varchar(255) NULL
	
)
INSERT INTO #TimeAllocationDetailBillingUpload
SELECT T.TimeAllocationId,
T.Period,
T.ApprovedByStaffName
FROM GrReportingStaging.TapasGlobal.TimeAllocation T
INNER JOIN TapasGlobal.TimeAllocationActive(@DataPriorToDate) A on T.ImportKey=A.ImportKey
where T.ApprovalStatusId in (3,4) and T.LockStatusId=3 

	PRINT 'Completed inserting records into #TimeAllocationDetailBillingUpload: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#TimeAllocationDetailBillingUpload_TimeAllocationId 
    ON #TimeAllocationDetailBillingUpload (TimeAllocationId) 

PRINT 'Completed creating indexes on #TimeAllocationDetailBillingUpload'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


	
-------------#BillingUpload----------------
SET @StartTime = GETDATE()
CREATE TABLE #BillingUpload
(
	[BillingUploadId] [int] NOT NULL,
	[BillingUploadBatchId] [int] NULL,
	[BillingUploadTypeId] [int] NOT NULL,
	[TimeAllocationId] [int] NOT NULL,
	[HREmployeeId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[AllocationValue] [decimal](18, 9) NOT NULL,
	[PayrollPayDate] [datetime] NULL,
	[PayrollDescription] [nvarchar](100) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[AllocationPeriod] [int] NOT NULL,
	[ExpensePeriod] [int] NOT NULL,
	[PayrollId] [int] NULL,
	LocationId [int]  NULL,
	PayGroupId [int]  NULL,
	FunctionalDepartmentId	 [int]  NULL,
	[ApprovedByStaff] varchar(255) NULL,
	AllocationDate datetime NOT NULL,
	ExpenseDate datetime NOT NULL
)

INSERT INTO #BillingUpload
(
	[BillingUploadId],
	[BillingUploadBatchId],
	[BillingUploadTypeId],
	[TimeAllocationId],
	[HREmployeeId],
	[ProjectId],
	[AllocationValue],
	[PayrollPayDate],
	[PayrollDescription],
	[InsertedDate],
	[UpdatedDate],
	[AllocationPeriod],
	[ExpensePeriod],
	[PayrollId],
	LocationId,
	PayGroupId,
	FunctionalDepartmentId,
	[ApprovedByStaff],
	AllocationDate,
	ExpenseDate
)
SELECT 
	TGBU.[BillingUploadId],
	TGBU.[BillingUploadBatchId],
	TGBU.[BillingUploadTypeId],
	TGBU.[TimeAllocationId],
	TGBU.[HREmployeeId],
	TGBU.[ProjectId],
	TGBU.[AllocationValue],
	TGBU.[PayrollPayDate],
	TGBU.[PayrollDescription],
	TGBU.InsertedDate,
	TGBU.[UpdatedDate],
	TGBU.[AllocationPeriod],
	TGBU.[ExpensePeriod],
	TGBU.[PayrollId],
	TGBU.LocationId,
	TGBU.PayGroupId,
	TGBU.FunctionalDepartmentId,
	TA.ApprovedByStaff,
	dateadd(dd,-1,dateadd(mm,1,LEFT(TGBU.AllocationPeriod,4)+'-'+RIGHT(TGBU.AllocationPeriod,2)+'-01')), -- the last day of this Period
	dateadd(dd,-1,dateadd(mm,1,LEFT(TGBU.ExpensePeriod,4)+'-'+RIGHT(TGBU.ExpensePeriod,2)+'-01')) -- the last day of this Period
FROM TapasGlobal.BillingUpload TGBU
	--INNER JOIN GrReportingStaging.TapasGlobal.BillingUpload GRBU ON TGBU.BillingUploadId = GRBU.BillingUploadId
	INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadActive(@DataPriorToDate) BUA ON TGBU.ImportKey = BUA.ImportKey
	INNER JOIN #TimeAllocationDetailBillingUpload TA on TGBU.TimeAllocationId = TA.TimeAllocationId
Where TGBU.ExpensePeriod between @ImportStartPeriod and @ImportEndPeriod and  TGBU.PayrollId is not null 
	--and   TGBU.HREmployeeId=1307 and TGBU.ExpensePeriod=201205  
	
	
	PRINT 'Completed inserting records into #BillingUpload: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

	
CREATE CLUSTERED INDEX IX_#BillingUpload_BillingUploadId ON #BillingUpload (BillingUploadId)

PRINT 'Completed creating indexes on #BillingUpload'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
SET @StartTime = GETDATE()	
CREATE TABLE #BillingUploadDetail
(
	--[BillingUploadDetailId] [int] NOT NULL,
	[BillingUploadId] [int] NOT NULL,
	[AllocationAmount] [decimal](18, 9) NOT NULL,
	[CorporateSourceCode] [varchar](2) NOT NULL,
	[CurrencyCode] [char](3) NOT NULL
)

INSERT INTO #BillingUploadDetail
(
	--[BillingUploadDetailId],
	[BillingUploadId],
	[AllocationAmount],
	[CorporateSourceCode],
	[CurrencyCode]
)
SELECT 
	--TGBUD.[BillingUploadDetailId],
	TGBUD.[BillingUploadId],
	sum(TGBUD.[AllocationAmount]) as AllocationAmount,
	TGBUD.[CorporateSourceCode],
	TGBUD.[CurrencyCode]
FROM TapasGlobal.BillingUploadDetail TGBUD
	--INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetail GRBUD ON TGBUD.BillingUploadDetailId = GRBUD.BillingUploadDetailId
	INNER JOIN GrReportingStaging.TapasGlobal.BillingUploadDetailActive(@DataPriorToDate) BUDA ON TGBUD.ImportKey = BUDA.ImportKey
	INNER JOIN #BillingUpload BU ON BU.BillingUploadId=TGBUD.BillingUploadId
Group by 	
	TGBUD.[BillingUploadId],
	TGBUD.[CorporateSourceCode],
	TGBUD.[CurrencyCode]
	PRINT 'Completed inserting records into #BillingUploadDetail: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

CREATE CLUSTERED INDEX IX_#BillingUploadDetail_BillingUploadId ON #BillingUploadDetail (BillingUploadId)


PRINT 'Completed creating indexes on #BillingUploadDetail'
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

/*
select * from #BillingUpload
select * from #BillingUploadDetail


*/

/*
Create temp table for final result
*/

-------------#TimeAllocationActual----------------
	SET @StartTime = GETDATE() 
CREATE TABLE #TimeAllocationActual
(
	[ReferenceCode] [varchar](500) NOT NULL,
	[ProjectKey] [int] NULL,
	[BudgetOwnerStaff] varchar(255) NULL,
	[PropertyFundKey] [int] NULL,
	[AllocationRegionKey] [int] NULL,
	[Local_NonLocal] [varchar](20) NOT NULL,
	[OriginatingRegionKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[CalendarKey] [int] NOT NULL,
	[ActualAllocatedFTE] [numeric](18, 12) NULL,
	[ReportingEntityKey] [int] NULL,
	[CorporateDepartmentCode] [varchar](8) NULL,
	[FunctionalDepartmentKey] [int] NULL,
	[SourceSystemId] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[ReimbursableKey] [int] NULL,
	[ActivityTypeKey] [int] NULL,
	[ProjectGroupKey] [int] NULL,
	[UserId] [int] NULL,
	[TapasUploadDate] [datetime] NULL,
	[BilledAmount] [money] NOT NULL,
	[BilledFTE] [numeric](18, 12) NOT NULL,
	[AdjustmentsAmount] [money] NOT NULL,
	[AdjustmentsFTE] [numeric](18, 12) NOT NULL,
	[LocalCurrencyKey] [int] NULL,
	[ConsolidationRegionKey] [int] NULL,
	[ApprovedByStaff] varchar(255) NULL
)

--TimeAllocation-Project
INSERT INTO #TimeAllocationActual
(
	[ReferenceCode],
	[ProjectKey],
	[BudgetOwnerStaff],
	[PropertyFundKey],
	[AllocationRegionKey],
	[Local_NonLocal],
	[OriginatingRegionKey],
	[EmployeeKey],
	[CalendarKey],
	[ActualAllocatedFTE],
	[ReportingEntityKey],
	[CorporateDepartmentCode],
	[FunctionalDepartmentKey],
	[SourceSystemId],
	[SourceKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[ProjectGroupKey],
	[UserId],
	[BilledAmount],
	[BilledFTE],
	[AdjustmentsAmount],
	[AdjustmentsFTE],
	[LocalCurrencyKey],
	[ConsolidationRegionKey],
	[ApprovedByStaff]
)
SELECT 
	'TimeAllocationDetailId=' + STR(TAD.TimeAllocationDetailId) + 
	 '&ProjectId=' + STR(ISNULL(P.ProjectId, -1))+
	 '&HREmployeeId='+STR(EH.HREmployeeId)+
	 '&Period='+STR(TA.Period),
	P.ProjectKey,
	--ISNULL(BudgetOwner.EmployeeKey,@EmployeeKeyUnknown),
	ISNULL(RE.BudgetOwnerStaff,''),
	ISNULL(PF.PropertyFundKey,@PropertyFundKeyUnknown),
	ISNULL(GrAr.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),''),
	ISNULL(GrOr.OriginatingRegionKey,@OriginatingRegionKeyUnknown),
	EH.EmployeeKey,
	DATEDIFF(dd, '1900-01-01', LEFT(TA.Period, 4) + '-' + RIGHT(TA.Period, 2) + '-01') CalendarKey,
	TAD.AllocationValue,
	ISNULL(RE.PropertyFundKey,@ReportingEntityKeyUnknown),
	P.CorporateDepartmentCode,
	ISNULL(GrFd.FunctionalDepartmentKey,@FunctionalDepartmentKeyUnknown),
	3,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown),
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
	ISNULL(AT.ActivityTypeKey,@ActivityTypeKeyUnknown),
	@ProjectGroupKeyUnknown,
	TA.HREmployeeId,
	0,
	0,
	0,
	0,
	@LocalCurrencyKeyUnknown,  --no currency key needed for this source, set USD as default
	
	ISNULL(AR.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(TA.ApprovedByStaff,'')

	
	--select *
FROM #TimeAllocation TA

	INNER JOIN #TimeAllocationDetail TAD on TA.TimeAllocationId = TAD.TimeAllocationId
	
	--INNER JOIN #Employee EM ON TA.HREmployeeId = EM.HREmployeeId
	
	INNER JOIN #Project P ON TAD.ProjectId = P.ProjectId
		AND TA.AllocationDate>=P.StartDate and TA.AllocationDate<P.EndDate
	
	--LEFT JOIN #Employee Approver ON (TA.ApprovedByStaffId = Approver.StaffId and Approver.StaffId<>-1)
	
	LEFT JOIN GrReporting.dbo.[Source] GrSc ON P.CorporateSourceCode = GrSc.SourceCode
	
	LEFT JOIN GrReporting.dbo.ActivityType AT ON P.ActivityTypeId = AT.ActivityTypeId AND AT.SnapshotId = 0
		AND TA.AllocationDate>=AT.StartDate and TA.AllocationDate<AT.EndDate
	
	LEFT JOIN #PropertyFund PF ON P.PropertyFundId = PF.PropertyFundId
		AND TA.AllocationDate between PF.StartDate AND PF.EndDate
		
	LEFT JOIn #ReportingEntityCorporateDepartment RECD ON (P.CorporateDepartmentCode=RECD.CorporateDepartmentCode 
		and P.CorporateSourceCode=RECD.SourceCode)
	LEFT JOIN #ReportingEntity RE ON RE.PropertyFundId=RECD.PropertyFundId
		AND TA.AllocationDate between RE.StartDate AND RE.EndDate
		
	--BudgetOwner is a property of ReportingEntity
	--LEFT JOIN #Employee BudgetOwner ON RE.BudgetOwnerStaffId = BudgetOwner.StaffId and  BudgetOwner.Staffid<>-1
		
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN P.IsTsCost = 0 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode
		
	LEFT JOIN #ConsolidationRegionCorporateDepartment CRCD on 
		(CRCD.CorporateDepartmentCode=P.CorporateDepartmentCode and CRCD.SourceCode=P.CorporateSourceCode)
		
	LEFT JOIN GrReporting.dbo.AllocationRegion AR ON CRCD.GlobalRegionId = AR.GlobalRegionId
		AND AR.SnapshotId = 0 AND
		TA.AllocationDate BETWEEN AR.StartDate AND ISNULL(AR.EndDate, TA.AllocationDate) 
	
	INNER JOIN #EmployeeHistory EH ON TA.HREmployeeId = EH.HREmployeeId
		AND TA.AllocationDate>=EH.StartDate AND TA.UpdatedDate<EH.EndDate	
	
	--LEFT JOIN #Location l ON l.LocationId=EH.LocationId
	
	--LEFT JOIN #PayGroup PG ON PG.PayGroupId = EH.PayGroupId
	
	--LEFT JOIN #PayrollRegion PR ON l.ExternalSubRegionId = PR.ExternalSubRegionId 
	--	and PG.RegionId=PR.RegionId
		
    LEFT JOIN #OriginatingRegionCorporateEntity ORCE ON
		EH.CorporateEntityRef = ORCE.CorporateEntityCode AND
		EH.CorporateSourceCode = ORCE.SourceCode  
		
	LEFT JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ORCE.GlobalRegionId  = GrOr.GlobalRegionId AND
		TA.AllocationDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, ta.AllocationDate) AND
		GrOr.SnapshotId = 0
		
	LEFT JOIN #FunctionalDepartment FD on EH.FunctionalDepartmentId = FD.FunctionalDepartmentId
	LEFT JOIN GrReporting.dbo.FunctionalDepartment GrFd on FD.FunctionalDepartmentCode=GrFd.FunctionalDepartmentCode
		and FD.FunctionalDepartmentCode = GrFd.SubFunctionalDepartmentCode
		and TA.AllocationDate BETWEEN GrFd.StartDate AND ISNULL(GrFd.EndDate, TA.AllocationDate)
	
	--allocation region is related to reporting entity
	LEFT JOIN GrReporting.dbo.AllocationRegion GrAr on 
		(GrAr.GlobalRegionId= RE.AllocationSubRegionGlobalRegionId and GrAr.SnapshotId=0) 
		AND TA.AllocationDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, ta.AllocationDate) 
		
		--where TA.Period=201201 and EM.EmployeeKey=14904
	--WHERE TAD.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate
		

	PRINT 'Completed inserting records into TimeAllocation Project: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


		
		--TimeAllocation ProjectGroup
	SET @StartTime = GETDATE() 
INSERT INTO #TimeAllocationActual
(
	[ReferenceCode],
	[ProjectKey],
	[BudgetOwnerStaff],
	[PropertyFundKey],
	[AllocationRegionKey],
	[Local_NonLocal],
	[OriginatingRegionKey],
	[EmployeeKey],
	[CalendarKey],
	[ActualAllocatedFTE],
	[ReportingEntityKey],
	[CorporateDepartmentCode],
	[FunctionalDepartmentKey],
	[SourceSystemId],
	[SourceKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[ProjectGroupKey],
	[UserId],
	[BilledAmount],
	[BilledFTE],
	[AdjustmentsAmount],
	[AdjustmentsFTE],
	[LocalCurrencyKey],
	[ConsolidationRegionKey],
	ApprovedByStaff
)
SELECT 
	'TimeAllocationDetailId=' + STR(TAD.TimeAllocationDetailId) + 
	 '&ProjectId=' + STR(ISNULL(P.ProjectId, -1))+
	 '&HREmployeeId='+STR(EH.HREmployeeId)+
	 '&Period='+STR(TA.Period)+
	 '&ProjectGroupId=' + STR(PG.ProjectGroupId) ,
	P.ProjectKey,
	ISNULL(RE.BudgetOwnerStaff,''),
	ISNULL(PF.PropertyFundKey,@PropertyFundKeyUnknown),
	ISNULL(GrAr.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),''),
	ISNULL(GrOr.OriginatingRegionKey,@OriginatingRegionKeyUnknown),
	EH.EmployeeKey,
	DATEDIFF(dd, '1900-01-01', LEFT(TA.Period, 4) + '-' + RIGHT(TA.Period, 2) + '-01') CalendarKey,
	TAD.AllocationValue * TGAW.Weight,
	ISNULL(RE.PropertyFundKey,@ReportingEntityKeyUnknown),
	P.CorporateDepartmentCode,
	ISNULL(GrFd.FunctionalDepartmentKey,@FunctionalDepartmentKeyUnknown),
	3,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown),
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
	ISNULL(AT.ActivityTypeKey,@ActivityTypeKeyUnknown),
	ISNULL(PG.ProjectGroupKey,@ProjectGroupKeyUnknown),
	TA.HREmployeeId,
	0,
	0,
	0,
	0,
	@LocalCurrencyKeyUnknown,  --no currency for this source, set as USD
	ISNULL(AR.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(TA.ApprovedByStaff,'')
	--select P.ProjectId,PP.ProjectName,P.ProjectKey,*
FROM #TimeAllocation TA

	INNER JOIN #TimeAllocationDetail TAD on TA.TimeAllocationId = TAD.TimeAllocationId
	
	--INNER JOIN #Employee EM ON TA.HREmployeeId = EM.HREmployeeId
	
	--LEFT JOIN #Employee Approver ON TA.ApprovedByStaffId = Approver.StaffId and  Approver.StaffId<>-1
	
	INNER JOIN #ProjectGroup PG ON TAD.ProjectGroupId = PG.ProjectGroupId
		AND TA.AllocationDate>=PG.StartDate and TA.AllocationDate<PG.EndDate
	
	INNER JOIN #ProjectGroupAllocation TGPGA on 
		(TGPGA.ProjectGroupId=PG.ProjectGroupId and TGPGA.EffectivePeriod<=TA.Period and TA.Period<TGPGA.EffectiveEndPeriod)

	INNER JOIN #AllocationWeight TGAW on TGPGA.ProjectGroupAllocationId=TGAW.ProjectGroupAllocationId
	
	INNER JOIN #Project P on P.ProjectId = TGAW.ProjectId
		AND TA.AllocationDate>=P.StartDate and TA.AllocationDate<P.EndDate
		
	--JOIN GrReporting.dbo.Project PP ON PP.ProjectKey = P.ProjectKey
	
	LEFT JOIN GrReporting.dbo.[Source] GrSc ON P.CorporateSourceCode = GrSc.SourceCode
	
	LEFT JOIN GrReporting.dbo.ActivityType AT ON P.ActivityTypeId = AT.ActivityTypeId
		AND AT.SnapshotId = 0 AND
		TA.AllocationDate BETWEEN AT.StartDate AND ISNULL(AT.EndDate, TA.AllocationDate) 
	
	LEFT JOIN #PropertyFund PF ON P.PropertyFundId = PF.PropertyFundId
		AND TA.AllocationDate between PF.StartDate AND PF.EndDate
		
	LEFT JOIn #ReportingEntityCorporateDepartment RECD ON (P.CorporateDepartmentCode=RECD.CorporateDepartmentCode 
		and P.CorporateSourceCode=RECD.SourceCode)
	LEFT JOIN #ReportingEntity RE ON RE.PropertyFundId=RECD.PropertyFundId
		AND TA.AllocationDate between RE.StartDate AND RE.EndDate

	--BudgetOwner is a property of ReportingEntity
	--LEFT JOIN #Employee BudgetOwner ON RE.BudgetOwnerStaffId = BudgetOwner.StaffId and  BudgetOwner.Staffid<>-1
	
	LEFT JOIN #ConsolidationRegionCorporateDepartment CRCD on 
		(CRCD.CorporateDepartmentCode=P.CorporateDepartmentCode and CRCD.SourceCode=P.CorporateSourceCode)
		
	LEFT JOIN GrReporting.dbo.AllocationRegion AR ON CRCD.GlobalRegionId = AR.GlobalRegionId
		AND AR.SnapshotId = 0 
		AND TA.AllocationDate BETWEEN AR.StartDate AND ISNULL(AR.EndDate, TA.AllocationDate) 
	
	INNER JOIN #EmployeeHistory EH ON TA.HREmployeeId = EH.HREmployeeId
		AND TA.AllocationDate>=EH.StartDate AND TA.AllocationDate<EH.EndDate	
	
	--LEFT JOIN #Location l ON l.LocationId=EH.LocationId
	
	--LEFT JOIN #PayGroup EHPG ON EHPG.PayGroupId = EH.PayGroupId
	
	--LEFT JOIN #PayrollRegion PR ON l.ExternalSubRegionId = PR.ExternalSubRegionId 
	--	and EHPG.RegionId=PR.RegionId
		
    LEFT JOIN #OriginatingRegionCorporateEntity ORCE ON
		EH.CorporateEntityRef = ORCE.CorporateEntityCode AND
		EH.CorporateSourceCode = ORCE.SourceCode  
		
	LEFT JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ORCE.GlobalRegionId  = GrOr.GlobalRegionId AND
		TA.AllocationDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, ta.AllocationDate) AND
		GrOr.SnapshotId = 0
		
	LEFT JOIN #FunctionalDepartment FD on EH.FunctionalDepartmentId = FD.FunctionalDepartmentId
	LEFT JOIN GrReporting.dbo.FunctionalDepartment GrFd on FD.FunctionalDepartmentCode=GrFd.FunctionalDepartmentCode
		and FD.FunctionalDepartmentCode = GrFd.SubFunctionalDepartmentCode
		and TA.AllocationDate BETWEEN GrFd.StartDate AND ISNULL(GrFd.EndDate, TA.AllocationDate)
	

	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN P.IsTsCost = 0 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode
			
	--allocation region is related to reporting entity
	LEFT JOIN GrReporting.dbo.AllocationRegion GrAr on 
		(GrAr.GlobalRegionId= RE.AllocationSubRegionGlobalRegionId and GrAr.SnapshotId=0) AND
		TA.AllocationDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, TA.AllocationDate) 
		
	--WHERE TAD.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate
--where TA.Period=201201 and EM.EmployeeKey=14904 --and P.ProjectKey=110144
--order by 2

	PRINT 'Completed inserting records into TimeAllocation ProjectGroup: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


	SET @StartTime = GETDATE() 
--BillingUpload-Project
INSERT INTO #TimeAllocationActual
(
	[ReferenceCode],
	[ProjectKey],
	[BudgetOwnerStaff],
	[PropertyFundKey],
	[AllocationRegionKey],
	[Local_NonLocal],
	[OriginatingRegionKey],
	[EmployeeKey],
	[CalendarKey],
	[ActualAllocatedFTE],
	[ReportingEntityKey],
	[CorporateDepartmentCode],
	[FunctionalDepartmentKey],
	[SourceSystemId],
	[SourceKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[ProjectGroupKey],
	[UserId],
	[BilledAmount],
	[BilledFTE],
	[AdjustmentsAmount],
	[AdjustmentsFTE],
	[LocalCurrencyKey],
	[ConsolidationRegionKey] ,
	ApprovedByStaff
)
SELECT 
	'TimeAllocationId=' + STR(BU.TimeAllocationId) + 
	 '&ProjectId=' + STR(ISNULL(P.ProjectId, -1))+
	 '&HREmployeeId='+STR(EH.HREmployeeId)+
	 '&Period='+STR(BU.ExpensePeriod)+
	'&BillingUploadId='+LTRIM(STR(min(BU.BillingUploadId))),

	P.ProjectKey,
	ISNULL(RE.BudgetOwnerStaff,''),
	ISNULL(PF.PropertyFundKey,@PropertyFundKeyUnknown),
	ISNULL(GrAr.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),''),
	ISNULL(GrOr.OriginatingRegionKey,@OriginatingRegionKeyUnknown),
	EH.EmployeeKey,
	--ISNULL(Approver.EmployeeKey, @EmployeeKeyUnknown),
	DATEDIFF(dd, '1900-01-01', LEFT(BU.ExpensePeriod, 4) + '-' + RIGHT(BU.ExpensePeriod, 2) + '-01') CalendarKey,
	NULL,
	ISNULL(RE.PropertyFundKey,@ReportingEntityKeyUnknown),
	P.CorporateDepartmentCode,
	ISNULL(GrFd.FunctionalDepartmentKey,@FunctionalDepartmentKeyUnknown),
	3,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown),
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
	ISNULL(AT.ActivityTypeKey,@ActivityTypeKeyUnknown),
	@ProjectGroupKeyUnknown,
	BU.HREmployeeId,
	ISNULL(sum(case when bu.BillingUploadTypeId=1 then bud.AllocationAmount else 0 end),0)
		as 'Billed Amount',
		/*
		we do avg here because there are cases that in one period, there are several batches that 
		have different AllocationValue, so they cannot be used in group by;
		AVG is not working great when there is Adjustment, 
		and some times, there is no billed FTE, just adjustment:
		ProjectId	HREmployeeId	AllocationPeriod
		1493		438				201202
		1312		3543			201201		
		4593		1747			201203
		5080		3408			201202
		*/
	ISNULL(sum(case when bu.BillingUploadTypeId=1 then bu.AllocationValue	else 0 end)
		/case when COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end)>0
			then COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId	else null end) 
			else 1 end
	,0)
		 as 'Billed FTE',
	ISNULL(sum(case when bu.BillingUploadTypeId<>1 then bud.AllocationAmount else 0 end),0)
		as 'Adjustments Amount',
	ISNULL(sum(case when bu.BillingUploadTypeId<>1 then bu.AllocationValue	else 0 end)
		/case when COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end)>0
			then COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId	else null end) 
			else COUNT(distinct case when bu.BillingUploadTypeId<>1 then bu.BillingUploadBatchId	else null end) end
		,0)
		 as 'Adjustments FTE',
	ISNULL(C.CurrencyKey,@LocalCurrencyKeyUnknown),
	ISNULL(AR.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(TA.ApprovedByStaff,'')
	/*
	select * from Tapasus.Allocation.TimeAllocation ta join tapasus.allocation.timeAllocationdetail tad
	on ta.TimeAllocationID=tad.TimeAllocationId
	where ta.TimeAllocationId in (94535,96358)
	
	select * from #TimeAllocationDetail
	select * from #TimeAllocationDetailBillingUpload
	*/
	
	--select   --P.ProjectId,EH.HREmployeeId,bu.ExpensePeriod  

FROM #BillingUpload BU

	INNER JOIN #BillingUploadDetail BUD ON BU.BillingUploadId = BUD.BillingUploadId  --1851210
	
	INNER JOIN #Project P ON BU.ProjectId = P.ProjectId
		AND BU.ExpenseDate >= P.StartDate AND BU.ExpenseDate < P.EndDate
	
	-- we no longer try to find project group for billingupload
	--INNER JOIN #TimeAllocationDetailBillingUpload TAD ON 
	--	(TAD.TimeAllocationId=BU.TimeAllocationId and TAD.ProjectId=BU.ProjectId)
		
		--we use time allocation's approver for billingupload
	LEFT JOIN #TimeAllocationDetailBillingUpload TA ON  (TA.TimeAllocationId=BU.TimeAllocationId)

	INNER JOIN #EmployeeHistory EH ON BU.HREmployeeId = EH.HREmployeeId
		AND BU.ExpenseDate>=EH.StartDate AND BU.ExpenseDate<EH.EndDate	
	
	LEFT JOIN GrReporting.dbo.[Source] GrSc ON P.CorporateSourceCode = GrSc.SourceCode
	
	LEFT JOIN GrReporting.dbo.ActivityType AT ON P.ActivityTypeId = AT.ActivityTypeId
		AND AT.SnapshotId = 0 AND 
		BU.ExpenseDate BETWEEN AT.StartDate AND ISNULL(AT.EndDate, BU.ExpenseDate) 
	
	LEFT JOIN #PropertyFund PF ON P.PropertyFundId = PF.PropertyFundId
		AND BU.ExpenseDate between PF.StartDate AND PF.EndDate
		
	LEFT JOIn #ReportingEntityCorporateDepartment RECD ON (P.CorporateDepartmentCode=RECD.CorporateDepartmentCode 
		and P.CorporateSourceCode=RECD.SourceCode)
	LEFT JOIN #ReportingEntity RE ON RE.PropertyFundId=RECD.PropertyFundId
		AND BU.ExpenseDate between RE.StartDate AND RE.EndDate

	--BudgetOwner is a property of ReportingEntity
	--LEFT JOIN #Employee BudgetOwner ON RE.BudgetOwnerStaffId = BudgetOwner.StaffId and  BudgetOwner.Staffid<>-1
	LEFT JOIN #ConsolidationRegionCorporateDepartment CRCD on 
		(CRCD.CorporateDepartmentCode=P.CorporateDepartmentCode and CRCD.SourceCode=P.CorporateSourceCode)
		
	LEFT JOIN GrReporting.dbo.AllocationRegion AR ON CRCD.GlobalRegionId = AR.GlobalRegionId
		AND AR.SnapshotId = 0 AND
		BU.ExpenseDate BETWEEN AT.StartDate AND ISNULL(AT.EndDate, BU.ExpenseDate) 

	
	--LEFT JOIN #Location l ON l.LocationId=BU.LocationId
	
	--LEFT JOIN #PayGroup PG ON PG.PayGroupId = BU.PayGroupId
	
	--LEFT JOIN #PayrollRegion PR ON l.ExternalSubRegionId = PR.ExternalSubRegionId 
	--	and PG.RegionId=PR.RegionId
		
    LEFT JOIN #OriginatingRegionCorporateEntity ORCE ON
		EH.CorporateEntityRef = ORCE.CorporateEntityCode AND
		EH.CorporateSourceCode = ORCE.SourceCode  
		
	LEFT JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ORCE.GlobalRegionId  = GrOr.GlobalRegionId AND
		bu.ExpenseDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, bu.ExpenseDate) AND
		GrOr.SnapshotId = 0
		
		--get last month's functional department
	LEFT JOIN #FunctionalDepartment FD on BU.FunctionalDepartmentId = FD.FunctionalDepartmentId
	LEFT JOIN GrReporting.dbo.FunctionalDepartment GrFd on FD.FunctionalDepartmentCode=GrFd.FunctionalDepartmentCode
		and FD.FunctionalDepartmentCode = GrFd.SubFunctionalDepartmentCode
		and BU.AllocationDate BETWEEN GrFd.StartDate AND ISNULL(GrFd.EndDate, BU.AllocationDate)
	
	--allocation region is related to reporting entity
	LEFT JOIN GrReporting.dbo.AllocationRegion GrAr on 
		(GrAr.GlobalRegionId= RE.AllocationSubRegionGlobalRegionId and GrAr.SnapshotId=0) 
		AND BU.ExpenseDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, BU.ExpenseDate) 
		
	LEFT JOIN GrReporting.dbo.Currency C ON C.CurrencyCode = BUD.CurrencyCode
	
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN P.IsTsCost = 0 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode
		
--WHERE BU.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate AND BU.PayrollId is not null 
--group by P.ProjectId,EM.HREmployeeId,bu.ExpensePeriod
--		having ISNULL(COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end),0)=0
--and ISNULL(COUNT(distinct case when bu.BillingUploadTypeId<>1 then bu.BillingUploadBatchId else null end),0)=0
group by 
	
	'TimeAllocationId=' + STR(BU.TimeAllocationId) + 
	 '&ProjectId=' + STR(ISNULL(P.ProjectId, -1))+
	 '&HREmployeeId='+STR(EH.HREmployeeId)+
	 '&Period='+STR(BU.ExpensePeriod)+
	'&BillingUploadId=',--+LTRIM(STR(min(BU.BillingUploadId))),

	P.ProjectKey,
	ISNULL(RE.BudgetOwnerStaff,''),
	ISNULL(PF.PropertyFundKey,@PropertyFundKeyUnknown),
	ISNULL(GrAr.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),''),
	ISNULL(GrOr.OriginatingRegionKey,@OriginatingRegionKeyUnknown),
	EH.EmployeeKey,
	--ISNULL(Approver.EmployeeKey, @EmployeeKeyUnknown),
	DATEDIFF(dd, '1900-01-01', LEFT(BU.ExpensePeriod, 4) + '-' + RIGHT(BU.ExpensePeriod, 2) + '-01') ,

	ISNULL(RE.PropertyFundKey,@ReportingEntityKeyUnknown),
	P.CorporateDepartmentCode,
	ISNULL(GrFd.FunctionalDepartmentKey,@FunctionalDepartmentKeyUnknown),

	ISNULL(GrSc.SourceKey, @SourceKeyUnknown),
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ,
	ISNULL(AT.ActivityTypeKey,@ActivityTypeKeyUnknown),

	BU.HREmployeeId,
	ISNULL(C.CurrencyKey,@LocalCurrencyKeyUnknown),
	ISNULL(AR.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(TA.ApprovedByStaff,'')
	
	PRINT 'Completed inserting records into BillingUpload Project: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
	
	/*
SET @StartTime = GETDATE() 	
--BillingUpload- ProjectGroup
INSERT INTO #TimeAllocationActual
(
	[ReferenceCode],
	[ProjectKey],
	[BudgetOwnerStaff],
	[PropertyFundKey],
	[AllocationRegionKey],
	[Local_NonLocal],
	[OriginatingRegionKey],
	[EmployeeKey],
	--[ApprovedByStaffKey],
	[CalendarKey],
	[ActualAllocatedFTE],
	[ReportingEntityKey],
	[CorporateDepartmentCode],
	[FunctionalDepartmentKey],
	[SourceSystemId],
	[SourceKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[ProjectGroupKey],
	[UserId],
	[BilledAmount],
	[BilledFTE],
	[AdjustmentsAmount],
	[AdjustmentsFTE],
	[LocalCurrencyKey],
	[ConsolidationRegionKey] ,
	ApprovedByStaff
)
SELECT 
	'TimeAllocationDetailId=' + STR(TAD.TimeAllocationDetailId) + 
	 '&ProjectId=' + STR(ISNULL(P.ProjectId, -1))+
	 '&ProjectGroupId=' + LTRIM(STR(TGPG.ProjectGroupId))+
	 '&HREmployeeId='+STR(EH.HREmployeeId)+
	 '&Period='+STR(BU.ExpensePeriod)+
	'&BillingUploadId='+LTRIM(STR(min(BU.BillingUploadId))),
	
	P.ProjectKey,
	--ISNULL(BudgetOwner.EmployeeKey,@EmployeeKeyUnknown),
	ISNULL(RE.BudgetOwnerStaff,''),
	ISNULL(PF.PropertyFundKey,@PropertyFundKeyUnknown),
	ISNULL(GrAr.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),''),
	ISNULL(GrOr.OriginatingRegionKey,@OriginatingRegionKeyUnknown),
	EH.EmployeeKey,
	--ISNULL(Approver.EmployeeKey, @EmployeeKeyUnknown),
	DATEDIFF(dd, '1900-01-01', LEFT(BU.ExpensePeriod, 4) + '-' + RIGHT(BU.ExpensePeriod, 2) + '-01') CalendarKey,
	NULL,
	ISNULL(RE.PropertyFundKey,@ReportingEntityKeyUnknown),
	P.CorporateDepartmentCode,
	ISNULL(GrFd.FunctionalDepartmentKey,@FunctionalDepartmentKeyUnknown),
	3,
	ISNULL(GrSc.SourceKey, @SourceKeyUnknown),
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ReimbursableKey,
	ISNULL(AT.ActivityTypeKey,@ActivityTypeKeyUnknown),
	ISNULL(TGPG.ProjectGroupKey,@ProjectGroupKeyUnknown),
	BU.HREmployeeId,
	ISNULL(sum(case when bu.BillingUploadTypeId=1 then bud.AllocationAmount else 0 end),0)
		as 'Billed Amount',
	ISNULL(sum(case when bu.BillingUploadTypeId=1 then bu.AllocationValue	else 0 end)
		/case when COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end)>0 
			then COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId	else null end)
			else 1 end
	,0)
		  as 'Billed FTE',
	ISNULL(sum(case when bu.BillingUploadTypeId<>1 then bud.AllocationAmount else 0 end),0)
		as 'Adjustments Amount',
	ISNULL(sum(case when bu.BillingUploadTypeId<>1 then bu.AllocationValue	else 0 end)
		/case when COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end)>0 
			then COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId	else null end)
			else COUNT(distinct case when bu.BillingUploadTypeId<>1 then bu.BillingUploadBatchId else null end) end
		,0)
		 as 'Adjustments FTE',
	ISNULL(C.CurrencyKey,@LocalCurrencyKeyUnknown),  
	ISNULL(AR.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(TA.ApprovedByStaff,'')
	--select bu.ProjectId,bu.HREmployeeId,bu.ExpensePeriod
	/*,min(case when bu.BillingUploadTypeId=1 then bu.AllocationValue	else null end)
	,sum(case when bu.BillingUploadTypeId=1 then bu.AllocationValue	else 0 end)
		/case when COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end)>0 
			then COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId	else null end)
			else 1 end
	,max(case when bu.BillingUploadTypeId=1 then bu.AllocationValue	else 0 end)
	,min(case when bu.BillingUploadTypeId<>1 then bu.AllocationValue	else null end)
		,sum(case when bu.BillingUploadTypeId<>1 then bu.AllocationValue	else 0 end)
		/case when COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end)>0 
			then COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId	else null end)
			else COUNT(distinct case when bu.BillingUploadTypeId<>1 then bu.BillingUploadBatchId else null end) end
	,max(case when bu.BillingUploadTypeId<>1 then bu.AllocationValue	else 0 end)*/
	--select *
FROM #BillingUpload BU

	INNER JOIN #BillingUploadDetail BUD ON BU.BillingUploadId = BUD.BillingUploadId
	
	INNER JOIN #TimeAllocationDetailBillingUpload TAD ON TAD.TimeAllocationId = BU.TimeAllocationId and TAD.ProjectGroupId is not null
	
	--select * from #TimeAllocationDetailBillingUpload
			--we use time allocation's approver for billingupload
	LEFT JOIN #TimeAllocation TA ON  (TA.TimeAllocationId=BU.TimeAllocationId)
	--LEFT JOIN #Employee Approver ON TA.ApprovedByStaffId = Approver.StaffId and  Approver.StaffId<>-1
	
	INNER JOIN #Project P ON BU.ProjectId = P.ProjectId
		AND BU.UpdatedDate >= P.StartDate AND BU.UpdatedDate<P.EndDate
	
	INNER JOIN #ProjectGroup TGPG ON TAD.ProjectGroupId = TGPG.ProjectGroupId
		AND BU.UpdatedDate >= TGPG.StartDate AND BU.UpdatedDate<TGPG.EndDate
	
	INNER JOIN #ProjectGroupAllocation TGPGA ON 
		(TGPG.ProjectGroupId=TGPGA.ProjectGroupId AND 
			TGPGA.EffectivePeriod<=BU.[AllocationPeriod] and BU.[AllocationPeriod]<TGPGA.EffectiveEndPeriod)
		
	LEFT  JOIN #AllocationWeight TGAW ON TGPGA.ProjectGroupAllocationId = TGAW.ProjectGroupAllocationId
		AND TGAW.ProjectId = P.ProjectId
		--where bu.BillingUploadId=10771624
	order by 1
	
	select * from #TimeAllocationDetail where TimeAllocationId=94409
	--INNER JOIN #Employee EM ON BU.HREmployeeId = EM.HREmployeeId
	INNER JOIN #EmployeeHistory EH ON BU.HREmployeeId = EH.HREmployeeId
		AND BU.UpdatedDate>=EH.StartDate AND BU.UpdatedDate<EH.EndDate	
	
	LEFT JOIN GrReporting.dbo.[Source] GrSc ON P.CorporateSourceCode = GrSc.SourceCode
	
	LEFT JOIN GrReporting.dbo.ActivityType AT ON P.ActivityTypeId = AT.ActivityTypeId
		AND AT.SnapshotId = 0 AND
		BU.UpdatedDate BETWEEN AT.StartDate AND ISNULL(AT.EndDate, BU.UpdatedDate) 
	
	LEFT JOIN #PropertyFund PF ON P.PropertyFundId = PF.PropertyFundId
		AND BU.PayrollPayDate between PF.StartDate AND PF.EndDate
	
	LEFT JOIn #ReportingEntityCorporateDepartment RECD ON (P.CorporateDepartmentCode=RECD.CorporateDepartmentCode 
		and P.CorporateSourceCode=RECD.SourceCode)
	LEFT JOIN #ReportingEntity RE ON RE.PropertyFundId=RECD.PropertyFundId
		AND BU.PayrollPayDate between RE.StartDate AND RE.EndDate
	
	LEFT JOIN #ConsolidationRegionCorporateDepartment CRCD on 
		(CRCD.CorporateDepartmentCode=P.CorporateDepartmentCode and CRCD.SourceCode=P.CorporateSourceCode)
		
	LEFT JOIN GrReporting.dbo.AllocationRegion AR ON CRCD.GlobalRegionId = AR.GlobalRegionId
		AND AR.SnapshotId = 0 AND
		BU.UpdatedDate BETWEEN AR.StartDate AND ISNULL(AR.EndDate, BU.UpdatedDate) 

	
	--LEFT JOIN #Location l ON l.LocationId=BU.LocationId
	
	--LEFT JOIN #PayGroup PG ON PG.PayGroupId = BU.PayGroupId
	
	--LEFT JOIN #PayrollRegion PR ON l.ExternalSubRegionId = PR.ExternalSubRegionId 
	--	and PG.RegionId=PR.RegionId
		
    LEFT JOIN #OriginatingRegionCorporateEntity ORCE ON
		EH.CorporateEntityRef = ORCE.CorporateEntityCode AND
		EH.CorporateSourceCode = ORCE.SourceCode  
		
	LEFT JOIN GrReporting.dbo.OriginatingRegion GrOr ON
		ORCE.GlobalRegionId  = GrOr.GlobalRegionId AND
		bu.UpdatedDate BETWEEN GrOr.StartDate AND ISNULL(GrOr.EndDate, bu.UpdatedDate) AND
		GrOr.SnapshotId = 0
		
	LEFT JOIN #FunctionalDepartment FD on BU.FunctionalDepartmentId = FD.FunctionalDepartmentId
	LEFT JOIN GrReporting.dbo.FunctionalDepartment GrFd on FD.FunctionalDepartmentCode=GrFd.FunctionalDepartmentCode
		and FD.FunctionalDepartmentCode = GrFd.SubFunctionalDepartmentCode
		and BU.UpdatedDate BETWEEN GrFd.StartDate AND ISNULL(GrFd.EndDate, BU.UpdatedDate)
	
	
	LEFT JOIN GrReporting.dbo.AllocationRegion GrAr on 
		(GrAr.GlobalRegionId= PF.AllocationSubRegionGlobalRegionId and GrAr.SnapshotId=0)
		AND BU.UpdatedDate BETWEEN GrAr.StartDate AND ISNULL(GrAr.EndDate, BU.UpdatedDate) 
		
	LEFT JOIN GrReporting.dbo.Currency C ON C.CurrencyCode = BUD.CurrencyCode
	
	--BudgetOwner is a property of ReportingEntity
	--LEFT JOIN #Employee BudgetOwner ON RE.BudgetOwnerStaffId = BudgetOwner.StaffId and  BudgetOwner.Staffid<>-1
	
	LEFT OUTER JOIN GrReporting.dbo.Reimbursable GrRi ON
			CASE WHEN P.IsTsCost = 0 THEN 'YES' ELSE 'NO' END = GrRi.ReimbursableCode
		
	--WHERE BU.UpdatedDate BETWEEN @ImportStartDate AND @ImportEndDate AND BU.PayrollId is not null 
		--where BU.ExpensePeriod=201202 and BU.HREmployeeId=2228 --and P.ProjectKey=110144
		--order by 1
	--group by bu.ProjectId,bu.HREmployeeId,bu.ExpensePeriod
--		having ISNULL(COUNT(distinct case when bu.BillingUploadTypeId=1 then bu.BillingUploadBatchId else null end),0)=0
--and ISNULL(COUNT(distinct case when bu.BillingUploadTypeId<>1 then bu.BillingUploadBatchId else null end),0)=0
	group by 
	'TimeAllocationDetailId=' + STR(TAD.TimeAllocationDetailId) + 
	 '&ProjectId=' + STR(ISNULL(P.ProjectId, -1))+
	 '&ProjectGroupId=' + LTRIM(STR(TGPG.ProjectGroupId))+
	 '&HREmployeeId='+STR(EH.HREmployeeId)+
	 '&Period='+STR(BU.ExpensePeriod)+
	'&BillingUploadId=',--+LTRIM(STR(BU.BillingUploadId)), 
	
	P.ProjectKey,
	ISNULL(RE.BudgetOwnerStaff,''),
	ISNULL(PF.PropertyFundKey,@PropertyFundKeyUnknown),
	ISNULL(GrAr.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(GrReporting.dbo.GetLocalNonLocalStr(GrOr.RegionName,GrOr.SubRegionName,GrAr.RegionName,GrAr.SubRegionName),''),
	ISNULL(GrOr.OriginatingRegionKey,@OriginatingRegionKeyUnknown),
	EH.EmployeeKey,
	--ISNULL(Approver.EmployeeKey, @EmployeeKeyUnknown),
	DATEDIFF(dd, '1900-01-01', LEFT(BU.ExpensePeriod, 4) + '-' + RIGHT(BU.ExpensePeriod, 2) + '-01') ,

	ISNULL(RE.PropertyFundKey,@ReportingEntityKeyUnknown),
	P.CorporateDepartmentCode,
	ISNULL(GrFd.FunctionalDepartmentKey,@FunctionalDepartmentKeyUnknown),

	ISNULL(GrSc.SourceKey, @SourceKeyUnknown),
	ISNULL(GrRi.ReimbursableKey, @ReimbursableKeyUnknown) ,
	ISNULL(AT.ActivityTypeKey,@ActivityTypeKeyUnknown),
	ISNULL(TGPG.ProjectGroupKey,@ProjectGroupKeyUnknown),
	BU.HREmployeeId,

	ISNULL(C.CurrencyKey,@LocalCurrencyKeyUnknown),  
	ISNULL(AR.AllocationRegionKey,@AllocationRegionKeyUnknown),
	ISNULL(TA.ApprovedByStaff,'')


	PRINT 'Completed inserting records into BillingUpload ProjectGroup: '+ CONVERT(CHAR(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))


*/


/* ==============================================================================================================================================
	Transfer the data to the GrReporting.dbo.TimeAllocationActual fact table
   =========================================================================================================================================== */
BEGIN

SET @StartTime = GETDATE() 

DECLARE @UpdatedDate DATETIME = GETDATE()

--Transfer the updated rows
UPDATE DIM
SET	
	DIM.[ProjectKey] = TAA.[ProjectKey],
	DIM.[BudgetOwnerStaff] = TAA.[BudgetOwnerStaff],
	DIM.[PropertyFundKey] = TAA.[PropertyFundKey],
	DIM.[AllocationRegionKey] = TAA.[AllocationRegionKey],
	DIM.[Local_NonLocal] = TAA.[Local_NonLocal],
	DIM.[OriginatingRegionKey] = TAA.[OriginatingRegionKey],
	DIM.[EmployeeKey] = TAA.[EmployeeKey],
	DIM.[CalendarKey] = TAA.[CalendarKey],
	DIM.[ActualAllocatedFTE] = TAA.ActualAllocatedFTE,
	DIM.[ReportingEntityKey] = TAA.[ReportingEntityKey],
	DIM.[CorporateDepartmentCode] = TAA.[CorporateDepartmentCode],
	DIM.[FunctionalDepartmentKey] = TAA.[FunctionalDepartmentKey],
	DIM.[SourceSystemId] = TAA.[SourceSystemId],
	DIM.[ReimbursableKey] = TAA.[ReimbursableKey],
	DIM.[ActivityTypeKey] = TAA.[ActivityTypeKey],
	DIM.[ProjectGroupKey] = TAA.[ProjectGroupKey],
	DIM.[UserId] = TAA.[UserId],
	DIM.[BilledAmount] = TAA.[BilledAmount],
	DIM.[BilledFTE] = TAA.[BilledFTE],
	DIM.[AdjustmentsAmount] = TAA.[AdjustmentsAmount],
	DIM.[AdjustmentsFTE] = TAA.[AdjustmentsFTE],
	DIM.[LocalCurrencyKey] = TAA.[LocalCurrencyKey],
	DIM.[ConsolidationRegionKey] = TAA.[ConsolidationRegionKey],
	DIM.[ApprovedByStaff] = TAA.[ApprovedByStaff],
	DIM.[UpdatedDate] = @StartTime
FROM
	GrReporting.dbo.TimeAllocationActual DIM
	
	INNER JOIN #TimeAllocationActual TAA ON
		DIM.SourceKey = TAA.SourceKey AND
		DIM.ReferenceCode = TAA.ReferenceCode
WHERE
	ISNULL(DIM.[ProjectKey], -1) <> ISNULL(TAA.[ProjectKey], -1) OR
	ISNULL(DIM.[BudgetOwnerStaff], '') <> ISNULL(TAA.[BudgetOwnerStaff], '') OR
	ISNULL(DIM.[PropertyFundKey], -1) <> ISNULL(TAA.[PropertyFundKey], -1) OR
	ISNULL(DIM.[AllocationRegionKey], -1) <> ISNULL(TAA.[AllocationRegionKey], -1) OR
	ISNULL(DIM.[Local_NonLocal], 'LOCAL') <> ISNULL(TAA.[Local_NonLocal], 'LOCAL') OR
	ISNULL(DIM.[OriginatingRegionKey], -1) <> ISNULL(TAA.[OriginatingRegionKey], -1) OR
	ISNULL(DIM.[EmployeeKey], -1) <> ISNULL(TAA.[EmployeeKey], -1) OR
	ISNULL(DIM.[ApprovedByStaff], '') <> ISNULL(TAA.[ApprovedByStaff], '') OR
	ISNULL(DIM.[CalendarKey], -1) <> ISNULL(TAA.[CalendarKey], -1) OR
	ISNULL(DIM.[ActualAllocatedFTE], -1) <> ISNULL(TAA.ActualAllocatedFTE, -1) OR
	ISNULL(DIM.[ReportingEntityKey], -1) <> ISNULL(TAA.[ReportingEntityKey], -1) OR
	ISNULL(DIM.[CorporateDepartmentCode], -1) <> ISNULL(TAA.[CorporateDepartmentCode], -1) OR
	ISNULL(DIM.[FunctionalDepartmentKey], -1) <> ISNULL(TAA.[FunctionalDepartmentKey], -1) OR
	ISNULL(DIM.[SourceSystemId], -1) <> ISNULL(TAA.[SourceSystemId], -1) OR
	ISNULL(DIM.[ReimbursableKey], -1) <> ISNULL(TAA.[ReimbursableKey], -1) OR
	ISNULL(DIM.[ActivityTypeKey], -1) <> ISNULL(TAA.[ActivityTypeKey], -1) OR
	ISNULL(DIM.[ProjectGroupKey], -1) <> ISNULL(TAA.[ProjectGroupKey], -1) OR
	ISNULL(DIM.[UserId], -1) <> ISNULL(TAA.[UserId], -1) OR
	DIM.[BilledAmount] <> TAA.[BilledAmount] OR
	DIM.[BilledFTE] <>TAA.[BilledFTE] OR
	DIM.[AdjustmentsAmount] <> TAA.[AdjustmentsAmount] OR
	DIM.[AdjustmentsFTE] <> TAA.[AdjustmentsFTE] OR
	DIM.[LocalCurrencyKey] <> TAA.[LocalCurrencyKey] OR
	ISNULL(DIM.[ConsolidationRegionKey], -1) <> ISNULL(TAA.[ConsolidationRegionKey], -1)
	
PRINT 'Rows Updated in TimeAllocationActual:'+CONVERT(char(10),@@rowcount)
	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))
	
	
	SET @StartTime = GETDATE() 
--Transfer the new rows
INSERT INTO GrReporting.dbo.TimeAllocationActual 
(
	[ReferenceCode],
	[ProjectKey],
	[BudgetOwnerStaff],
	[PropertyFundKey],
	[AllocationRegionKey],
	[Local_NonLocal],
	[OriginatingRegionKey],
	[EmployeeKey],
	[ApprovedByStaff],
	[CalendarKey],
	[ActualAllocatedFTE],
	[ReportingEntityKey],
	[CorporateDepartmentCode],
	[FunctionalDepartmentKey],
	[SourceSystemId],
	[SourceKey],
	[ReimbursableKey],
	[ActivityTypeKey],
	[ProjectGroupKey],
	[UserId],
	[BilledAmount],
	[BilledFTE],
	[AdjustmentsAmount],
	[AdjustmentsFTE],
	[LocalCurrencyKey],
	[ConsolidationRegionKey],
	[InsertedDate],
	[UpdatedDate]
)
	
SELECT
	TAA.[ReferenceCode],
	TAA.[ProjectKey],
	TAA.[BudgetOwnerStaff],
	TAA.[PropertyFundKey],
	TAA.[AllocationRegionKey],
	TAA.[Local_NonLocal],
	TAA.[OriginatingRegionKey],
	TAA.[EmployeeKey],
	TAA.[ApprovedByStaff],
	TAA.[CalendarKey],
	TAA.ActualAllocatedFTE,
	TAA.[ReportingEntityKey],
	TAA.[CorporateDepartmentCode],
	TAA.[FunctionalDepartmentKey],
	TAA.[SourceSystemId],
	TAA.[SourceKey],
	TAA.[ReimbursableKey],
	TAA.[ActivityTypeKey],
	TAA.[ProjectGroupKey],
	TAA.[UserId],
	TAA.[BilledAmount],
	TAA.[BilledFTE],
	TAA.[AdjustmentsAmount],
	TAA.[AdjustmentsFTE],
	TAA.[LocalCurrencyKey],
	TAA.[ConsolidationRegionKey],
	@StartTime,
	@StartTime
FROM
	#TimeAllocationActual TAA
	
	LEFT OUTER JOIN GrReporting.dbo.TimeAllocationActual TAAExists ON
		TAA.SourceKey  = TAAExists.SourceKey AND
		TAA.ReferenceCode = TAAExists.ReferenceCode  
WHERE
	TAAExists.SourceKey IS NULL

PRINT 'Rows Inserted in TimeAllocationActual:'+CONVERT(char(10),@@rowcount)

	PRINT (CONVERT(VARCHAR(27), DATEDIFF(MILLISECOND, @StartTime, GETDATE()), 121) + ' ms' + CHAR(13))

END
/* ==============================================================================================================================================
	Clean up
   =========================================================================================================================================== */
 
BEGIN

IF OBJECT_ID('tempdb..#Employee') IS NOT NULL
	DROP TABLE #Employee

IF OBJECT_ID('tempdb..#Project') IS NOT NULL
	DROP TABLE #Project
	
IF OBJECT_ID('tempdb..#ProjectGroup') IS NOT NULL
	DROP TABLE #ProjectGroup
	
IF OBJECT_ID('tempdb..#ProjectGroupAllocation') IS NOT NULL
	DROP TABLE #ProjectGroupAllocation
	
IF OBJECT_ID('tempdb..#PropertyFund') IS NOT NULL	
	DROP TABLE #PropertyFund
IF OBJECT_ID('tempdb..#ReportingEntity') IS NOT NULL	
	DROP TABLE #ReportingEntity	
IF OBJECT_ID('tempdb..#FunctionalDepartment') IS NOT NULL
	DROP TABLE #FunctionalDepartment

IF OBJECT_ID('tempdb..#EmployeeHistory') IS NOT NULL
	DROP TABLE #EmployeeHistory
	
IF OBJECT_ID('tempdb..#ConsolidationRegionCorporateDepartment') IS NOT NULL	
	DROP TABLE #ConsolidationRegionCorporateDepartment
	
IF OBJECT_ID('tempdb..#TimeAllocationActual') IS NOT NULL	
	DROP TABLE #TimeAllocationActual
	
IF OBJECT_ID('tempdb..#BillingUpload') IS NOT NULL	
	DROP TABLE #BillingUpload
	
IF OBJECT_ID('tempdb..#BillingUploadDetail') IS NOT NULL	
	DROP TABLE #BillingUploadDetail
	
IF OBJECT_ID('tempdb..#TimeAllocation') IS NOT NULL	
	DROP TABLE #TimeAllocation
	
IF OBJECT_ID('tempdb..#TimeAllocationDetail') IS NOT NULL	
	DROP TABLE #TimeAllocationDetail	
	
		
IF OBJECT_ID('tempdb..#TimeAllocationDetailBillingUpload') IS NOT NULL	
	DROP TABLE #TimeAllocationDetailBillingUpload

IF OBJECT_ID('tempdb..#Location') IS NOT NULL
	DROP TABLE #Location 
	
IF OBJECT_ID('tempdb..#PayGroup') IS NOT NULL
	DROP TABLE #PayGroup

IF OBJECT_ID('tempdb..#PayrollRegion') IS NOT NULL
	DROP TABLE #PayrollRegion
IF OBJECT_ID('tempdb..#OriginatingRegionCorporateEntity') IS NOT NULL
	DROP TABLE #OriginatingRegionCorporateEntity 
IF OBJECT_ID('tempdb..#AllocationWeight') IS NOT NULL
	DROP TABLE #AllocationWeight 
IF OBJECT_ID('tempdb..#ReportingEntityCorporateDepartment') IS NOT NULL
	DROP TABLE #ReportingEntityCorporateDepartment 
	
	
	
END





GO


