USE [GrReportingStaging]
GO

/****** Object:  StoredProcedure [dbo].[ClearSessionSnapshot]    Script Date: 08/21/2009 10:24:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_IU_USCorp_LoadProfitabiltyWithGeneralLedger]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_IU_USCorp_LoadProfitabiltyWithGeneralLedger]
GO

CREATE PROCEDURE [dbo].[stp_IU_USCorp_LoadProfitabiltyWithGeneralLedger]
	@ImportStartDate	DateTime,
	@ImportEndDate		DateTime
AS
SET NOCOUNT ON
DECLARE 
	  @TypeHierarchyKey			Int,
      @GlAccountKey				Int,
      @FunctionalDepartmentKey	Int,
      @ReimbursableKey			Int,
      @ActivityTypeKey			Int,
      @SourceKey				Int,
      @OriginatingRegionKey		Int,
      @AllocationRegionKey		Int,
      @PropertyFundKey			Int
      
      
SET @TypeHierarchyKey			= (Select TypeHierarchyKey From GrReporting.dbo.TypeHierarchy Where AccountCategory = 'UNKNOWN')
SET @GlAccountKey				= (Select GlAccountKey From GrReporting.dbo.GlAccount Where GlAccountNumber = 'UNKNOWN')
SET @FunctionalDepartmentKey	= (Select FunctionalDepartmentKey From GrReporting.dbo.FunctionalDepartment Where FunctionalDepartmentCode = 'UNKNOWN')
SET @ReimbursableKey			= (Select ReimbursableKey From GrReporting.dbo.Reimbursable Where ReimbursableCode = 'UNKNOWN')
SET @ActivityTypeKey			= (Select ActivityTypeKey From GrReporting.dbo.ActivityType Where ActivityTypeCode = 'UNKNOWN')
SET @SourceKey					= (Select SourceKey From GrReporting.dbo.Source Where SourceName = 'UNKNOWN')
SET @OriginatingRegionKey		= (Select OriginatingRegionKey From GrReporting.dbo.OriginatingRegion Where RegionCode = 'UNKNOWN')
SET @AllocationRegionKey		= (Select AllocationRegionKey From GrReporting.dbo.AllocationRegion Where RegionCode = 'UNKNOWN')
SET @PropertyFundKey			= (Select PropertyFundKey From GrReporting.dbo.PropertyFund Where PropertyFundCode = 'UNKNOWN')

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--If the join is not possible, default the link to the 'UNKNOWN' link
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE TABLE #Profitability(
	[CalendarKey] [int] NOT NULL,
	[GlAccountKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[TypeHierarchyKey] [int] NOT NULL,
	[FunctionalDepartmentKey] [int] NOT NULL,
	[ReimbursableKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[OriginatingRegionKey] [int] NOT NULL,
	[AllocationRegionKey] [int] NOT NULL,
	[PropertyFundKey] [int] NOT NULL,
	[SourceReferenceKey] [varchar](50) NOT NULL,
	[Actual] [money] NOT NULL,
	[Budget] [money] NOT NULL,
	[Variance] [money] NOT NULL
) 

Insert Into #Profitability
           ([CalendarKey]
           ,[GlAccountKey]
           ,[SourceKey]
           ,[TypeHierarchyKey]
           ,[FunctionalDepartmentKey]
           ,[ReimbursableKey]
           ,[ActivityTypeKey]
           ,[OriginatingRegionKey]
           ,[AllocationRegionKey]
           ,[PropertyFundKey]
           ,[SourceReferenceKey]
           ,[Actual]
           ,[Budget]
           ,[Variance])

SELECT 
		DATEDIFF(dd, '1900-01-01', Gl.EnterDate) [CalendarKey]
		,CASE WHEN GrGa.[GlAccountKey] IS NULL THEN @GlAccountKey ELSE GrGa.[GlAccountKey] END GlAccountKey
		,CASE WHEN GrSc.[SourceKey] IS NULL THEN @SourceKey ELSE GrSc.[SourceKey] END SourceKey
		,CASE WHEN GrTh.[TypeHierarchyKey] IS NULL THEN @TypeHierarchyKey ELSE GrTh.[TypeHierarchyKey] END TypeHierarchyKey
		,CASE WHEN GrFdm.[FunctionalDepartmentKey] IS NULL THEN @FunctionalDepartmentKey ELSE GrFdm.[FunctionalDepartmentKey] END FunctionalDepartmentKey
		,@ReimbursableKey
		,CASE WHEN GrAt.[ActivityTypeKey] IS NULL THEN @ActivityTypeKey ELSE GrAt.[ActivityTypeKey] END ActivityTypeKey
		,CASE WHEN GrOr.[OriginatingRegionKey] IS NULL THEN @OriginatingRegionKey ELSE GrOr.[OriginatingRegionKey] END OriginatingRegionKey
		,CASE WHEN GrAr.[AllocationRegionKey] IS NULL THEN @AllocationRegionKey ELSE GrAr.[AllocationRegionKey] END AllocationRegionKey
		,CASE WHEN GrPf.[PropertyFundKey] IS NULL THEN @PropertyFundKey ELSE GrPf.[PropertyFundKey] END PropertyFundKey
		,Gl.SourceReferenceKey
		,ISNULL(Gl.Amount,0) Actual
		,0 Budget
		,0 Variance	
From USCorp.GeneralLedger Gl

		LEFT OUTER JOIN Gdm.FunctionalDepartmentMapping Fdm 
			ON Fdm.FunctionalDepartmentCode = Gl.FunctionalDepartmentCode 
			AND Fdm.SourceCode = Gl.SourceCode
			
		LEFT OUTER JOIN GrReporting.dbo.FunctionalDepartment GrFdm 
			ON GrFdm.GlobalFunctionalDepartmentId = Fdm.GlobalFunctionalDepartmentId 
			AND Fdm.SourceCode = Gl.SourceCode
		
		LEFT OUTER JOIN Gdm.ActivityType At 
			ON At.GlSuffix = Gl.GlAccountSuffix 
			
		LEFT OUTER JOIN GrReporting.dbo.ActivityType GrAt 
			ON GrAt.ActivityTypeId = At.ActivityTypeId
		
		LEFT OUTER JOIN Gdm.GlAccountMapping Gam 
			ON Gam.GlAccountCode = Gl.GlAccountCode 
			AND Gam.SourceCode = Gl.SourceCode 
			
		LEFT OUTER JOIN GrReporting.dbo.GlAccount GrGa 
			ON GrGa.GlobalGlAccountId = Gam.GlobalGlAccountId

		LEFT OUTER JOIN Gdm.AccountCategoryMapping Acm 
			ON Acm.GlAccountCode = Gl.GlAccountCode 
			AND Acm.SourceCode = Gl.SourceCode 
			
		LEFT OUTER JOIN GrReporting.dbo.TypeHierarchy GrTh 
			ON GrTh.GlobalAccountCategoryId = Acm.GlobalAccountCategoryId
		
		LEFT OUTER JOIN GrReporting.dbo.Source GrSc 
			ON GrSc.SourceCode = Gl.SourceCode
		
		LEFT OUTER JOIN Gdm.PropertyFundMapping Pfm 
			ON Pfm.PropertyFundCode = LTRIM(RTRIM(Gl.PropertyFundCode)) 
			AND Pfm.SourceCode = Gl.SourceCode 
			
		LEFT OUTER JOIN GrReporting.dbo.PropertyFund GrPf 
			ON GrPf.PropertyFundId = Pfm.PropertyFundId

		LEFT OUTER JOIN Gdm.OriginatingRegionMapping Orm 
			ON Orm.RegionCode = Gl.RegionCode 
			AND Orm.SourceCode = Gl.SourceCode 
			
		LEFT OUTER JOIN GrReporting.dbo.OriginatingRegion GrOr 
			ON GrOr.GlobalRegionId = Orm.GlobalRegionId
		
		LEFT OUTER JOIN Gdm.PropertyFund Pf 
			ON Pf.PropertyFundId = Pfm.PropertyFundId
			
		LEFT OUTER JOIN TapasGlobal.ProjectRegion Pr 
			ON Pr.ProjectRegionId = Pf.ProjectRegionId	
				
		LEFT OUTER JOIN Gdm.AllocationRegionMapping Arm 
			ON Arm.RegionCode = Pr.Code
			
		LEFT OUTER JOIN GrReporting.dbo.AllocationRegion GrAr 
			ON GrAr.GlobalRegionId = Arm.GlobalRegionId

Where	Gl.LastDate BETWEEN @ImportStartDate AND @ImportEndDate

print 'Rows Inserted into #Profitability:'+CONVERT(char(10),@@rowcount)
	
--Transfer these new consolidated values into the "Real" Profitabilty fat table
	
Update GrReporting.dbo.Profitability
SET 	
CalendarKey					= Pro.CalendarKey,
TypeHierarchyKey			= Pro.TypeHierarchyKey,
GlAccountKey				= Pro.GlAccountKey,
FunctionalDepartmentKey		= Pro.FunctionalDepartmentKey,
ReimbursableKey				= Pro.ReimbursableKey,
ActivityTypeKey				= Pro.ActivityTypeKey,
SourceKey					= Pro.SourceKey,
OriginatingRegionKey		= Pro.OriginatingRegionKey,
AllocationRegionKey			= Pro.AllocationRegionKey,
PropertyFundKey				= Pro.PropertyFundKey,
Actual						= Pro.Actual,
Budget						= Pro.Budget,
Variance					= Pro.Variance
	
From
	#Profitability Pro
Where Pro.SourceReferenceKey = Profitability.SourceReferenceKey

print 'Rows Updated in Profitability:'+CONVERT(char(10),@@rowcount)
		
Insert Into GrReporting.dbo.Profitability
(CalendarKey,TypeHierarchyKey,GlAccountKey,FunctionalDepartmentKey,ReimbursableKey,
ActivityTypeKey,SourceKey,OriginatingRegionKey,AllocationRegionKey,PropertyFundKey,
SourceReferenceKey,Actual,Budget,Variance)

Select
		Pro.CalendarKey,Pro.TypeHierarchyKey,Pro.GlAccountKey,Pro.FunctionalDepartmentKey,Pro.ReimbursableKey,
		Pro.ActivityTypeKey,Pro.SourceKey,Pro.OriginatingRegionKey,Pro.AllocationRegionKey,Pro.PropertyFundKey,
		Pro.SourceReferenceKey,Pro.Actual,Pro.Budget,Pro.Variance

From	#Profitability Pro
			LEFT OUTER JOIN GrReporting.dbo.Profitability ProExists ON Pro.SourceReferenceKey = ProExists.SourceReferenceKey
Where ProExists.SourceReferenceKey IS NULL

print 'Rows Inserted in Profitability:'+CONVERT(char(10),@@rowcount)
	
GO