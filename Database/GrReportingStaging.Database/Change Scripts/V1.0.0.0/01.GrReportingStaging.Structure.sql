
--TODO: Remember that SSISConfigurations and Batch tables aren't being created here 
--because we don't want to loose the information if we are smoking the DW for a re-load.
--Un comment all commented constraints for these tables if you want to do a fresh deployment!


USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- Create Schema

USE [GrReportingStaging]
GO
/****** Object:  Schema [BRCorp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [BRCorp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [BRProp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [BRProp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [BudgetingCorp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [BudgetingCorp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CNCorp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [CNCorp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [CNProp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [CNProp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [EUCorp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [EUCorp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [EUProp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [EUProp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [GACS]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [GACS] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [Gdm]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [Gdm] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [Gr]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [Gr] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [HR]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [HR] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [INCorp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [INCorp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [INProp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [INProp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [TapasGlobal]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [TapasGlobal] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [TapasGlobalBudgeting]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [TapasGlobalBudgeting] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [USCorp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [USCorp] AUTHORIZATION [dbo]
GO
/****** Object:  Schema [USProp]    Script Date: 12/28/2009 17:09:21 ******/
CREATE SCHEMA [USProp] AUTHORIZATION [dbo]
GO


-- Create Tables

/****** Object:  Table [dbo].[SSISConfigurations]    Script Date: 12/15/2009 13:18:17 ******/
/*
CREATE TABLE [dbo].[SSISConfigurations](
	[ConfigurationFilter] [nvarchar](255) NOT NULL,
	[ConfiguredValue] [nvarchar](255) NULL,
	[PackagePath] [nvarchar](255) NOT NULL,
	[ConfiguredValueType] [nvarchar](20) NOT NULL
) ON [PRIMARY]

GO
*/

/****** Object:  Table [dbo].[Batch]    Script Date: 12/18/2009 16:07:55 ******/
/*
CREATE TABLE [dbo].[Batch](
	[BatchId] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [varchar](100) NOT NULL,
	[BatchStartDate] [datetime] NOT NULL,
	[BatchEndDate] [datetime] NULL,
	[ImportStartDate] [datetime] NOT NULL,
	[ImportEndDate] [datetime] NOT NULL,
	[DataPriorToDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Batch] PRIMARY KEY CLUSTERED 
(
	[BatchId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
*/

/*
ALTER TABLE [dbo].[Batch] ADD  CONSTRAINT [DF_Batch_BatchDate]  DEFAULT (getdate()) FOR [BatchStartDate]
GO
*/

/****** Object:  Table [Gdm].[ActivityType]    Script Date: 12/18/2009 16:07:54 ******/
CREATE TABLE [Gdm].[ActivityType](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[ActivityTypeCode] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[GLSuffix] [char](2) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ActivityType] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[AllocationRegionMapping]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[AllocationRegionMapping](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[AllocationRegionMappingId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[RegionCode] [varchar](10) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_RegionMapping] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BenefitOption]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BenefitOption](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BenefitOptionId] [int] NOT NULL,
	[PlanTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BenefitOption] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[BillingUpload]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[BillingUpload](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BillingUploadId] [int] NOT NULL,
	[BillingUploadBatchId] [int] NULL,
	[BillingUploadTypeId] [int] NOT NULL,
	[TimeAllocationId] [int] NOT NULL,
	[CostTypeId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[ExternalRegionId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL,
	[PayrollId] [int] NULL,
	[OverheadId] [int] NULL,
	[PayGroupId] [int] NULL,
	[UnionCodeId] [int] NULL,
	[OverheadRegionId] [int] NULL,
	[HREmployeeId] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[SubDepartmentId] [int] NOT NULL,
	[ExpensePeriod] [int] NOT NULL,
	[PayrollDescription] [nvarchar](100) NULL,
	[OverheadDescription] [nvarchar](100) NULL,
	[ProjectName] [varchar](100) NOT NULL,
	[ProjectCode] [varchar](50) NOT NULL,
	[ReversalPeriod] [int] NULL,
	[BillingAdjustmentComment] [varchar](max) NULL,
	[AllocationPeriod] [int] NOT NULL,
	[AllocationValue] [decimal](18, 9) NOT NULL,
	[IsReversable] [bit] NOT NULL,
	[IsReversed] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[HasNoInactiveProjects] [bit] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ProjectGroupAllocationAdjustmentId] [int] NULL,
	[AdjustedTimeAllocationDetailId] [int] NULL,
	[PayrollPayDate] [datetime] NULL,
	[PayrollFromDate] [datetime] NULL,
	[PayrollToDate] [datetime] NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[OverheadFunctionalDepartmentId] [int] NULL,
 CONSTRAINT [PK_BillingUpload] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[BillingUploadDetail]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[BillingUploadDetail](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BillingUploadDetailId] [int] NOT NULL,
	[BillingUploadBatchId] [int] NOT NULL,
	[BillingUploadId] [int] NOT NULL,
	[BillingUploadDetailTypeId] [int] NOT NULL,
	[ExpenseTypeId] [int] NULL,
	[GLAccountCode] [varchar](15) NOT NULL,
	[CorporateEntityRef] [varchar](6) NULL,
	[CorporateDepartmentCode] [varchar](8) NOT NULL,
	[CorporateDepartmentIsRechargedToAr] [bit] NOT NULL,
	[CorporateSourceCode] [varchar](2) NOT NULL,
	[AllocationAmount] [decimal](18, 9) NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[IsUnion] [bit] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[CorporateDepartmentIsRechargedToAp] [bit] NOT NULL,
 CONSTRAINT [PK_BillingUploadDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[Budget]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[Budget](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[BudgetTypeId] [int] NOT NULL,
	[BudgetStatusId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[StartPeriod] [int] NOT NULL,
	[EndPeriod] [int] NOT NULL,
	[FirstProjectedPeriod] [int] NULL,
	[CurrencyCode] [varchar](3) NOT NULL,
	[CanEmployeesViewBudget] [bit] NOT NULL,
	[IsReforecast] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[LastLockedDate] [datetime] NULL,
 CONSTRAINT [PK_Budget] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployee]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetEmployee](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetEmployeeId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[HrEmployeeId] [int] NULL,
	[PayGroupId] [int] NOT NULL,
	[JobTitleId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[StateId] [int] NULL,
	[OverheadRegionId] [int] NOT NULL,
	[ApproverStaffId] [int] NULL,
	[Name] [varchar](255) NOT NULL,
	[IsUnion] [bit] NOT NULL,
	[RehirePeriod] [int] NOT NULL,
	[RehireDate] [datetime] NOT NULL,
	[TerminatePeriod] [int] NULL,
	[TerminateDate] [datetime] NULL,
	[EmployeeHistoryEffectivePeriod] [int] NOT NULL,
	[EmployeeHistoryEffectiveDate] [datetime] NOT NULL,
	[EmployeePayrollEffectiveDate] [datetime] NULL,
	[CurrentAnnualSalary] [decimal](18, 2) NULL,
	[PreviousYearSalary] [decimal](18, 2) NULL,
	[SalaryYear] [int] NOT NULL,
	[PreviousYearBonus] [decimal](18, 2) NULL,
	[BonusYear] [int] NULL,
	[IsActualEmployee] [bit] NOT NULL,
	[IsReviewed] [bit] NOT NULL,
	[IsPartTime] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[OriginalBudgetEmployeeId] [int] NULL,
 CONSTRAINT [PK_BudgetEmployee] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetEmployeeFunctionalDepartmentId] [int] NOT NULL,
	[BudgetEmployeeId] [int] NOT NULL,
	[SubDepartmentId] [int] NOT NULL,
	[EffectivePeriod] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetEmployeeFunctionalDepartment] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetEmployeePayrollAllocationId] [int] NOT NULL,
	[BudgetEmployeeId] [int] NOT NULL,
	[BudgetProjectId] [int] NOT NULL,
	[BudgetProjectGroupId] [int] NULL,
	[Period] [int] NOT NULL,
	[SalaryAllocationValue] [decimal](18, 9) NOT NULL,
	[BonusAllocationValue] [decimal](18, 9) NULL,
	[BonusCapAllocationValue] [decimal](18, 9) NULL,
	[ProfitShareAllocationValue] [decimal](18, 9) NULL,
	[PreTaxSalaryAmount] [decimal](18, 2) NOT NULL,
	[PreTaxBonusAmount] [decimal](18, 2) NULL,
	[PreTaxBonusCapExcessAmount] [decimal](18, 2) NULL,
	[PreTaxProfitShareAmount] [decimal](18, 2) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[OriginalBudgetEmployeePayrollAllocationId] [int] NULL,
 CONSTRAINT [PK_BudgetEmployeePayrollAllocation] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetEmployeePayrollAllocationDetailId] [int] NOT NULL,
	[BudgetEmployeePayrollAllocationId] [int] NOT NULL,
	[BenefitOptionId] [int] NULL,
	[BudgetTaxTypeId] [int] NULL,
	[SalaryAmount] [decimal](18, 2) NULL,
	[BonusAmount] [decimal](18, 2) NULL,
	[ProfitShareAmount] [decimal](18, 2) NULL,
	[BonusCapExcessAmount] [decimal](18, 2) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetEmployeePayrollAllocationDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetOverheadAllocation]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocation](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetOverheadAllocationId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[OverheadRegionId] [int] NOT NULL,
	[BudgetEmployeeId] [int] NOT NULL,
	[BudgetPeriod] [int] NOT NULL,
	[AllocationAmount] [decimal](18, 2) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[OriginalBudgetOverheadAllocationId] [int] NULL,
 CONSTRAINT [PK_BudgetOverheadAllocation] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetOverheadAllocationDetailId] [int] NOT NULL,
	[BudgetOverheadAllocationId] [int] NOT NULL,
	[BudgetProjectId] [int] NOT NULL,
	[AllocationValue] [decimal](18, 9) NOT NULL,
	[AllocationAmount] [decimal](18, 2) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetOverheadAllocationDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetProject]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetProject](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetProjectId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[ProjectId] [int] NULL,
	[RegionId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[Code] [varchar](50) NULL,
	[Name] [varchar](100) NULL,
	[CorporateDepartmentCode] [varchar](6) NULL,
	[CorporateSourceCode] [varchar](2) NULL,
	[StartPeriod] [int] NOT NULL,
	[EndPeriod] [int] NULL,
	[IsReimbursable] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[OriginalBudgetProjectId] [int] NULL,
	[IsTsCost] [bit] NOT NULL,
	[CanAllocateOverheads] [bit] NOT NULL,
	[AllocateOverheadsProjectId] [int] NULL,
	[MarkUpPercentage] [decimal](5, 4) NULL,
	[ProjectOwnerStaffId] [int] NULL,
 CONSTRAINT [PK_BudgetProject] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetReportGroup]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetReportGroup](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetReportGroupId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[ExchangeRateId] [int] NOT NULL,
	[IsReforecast] [bit] NOT NULL,
	[StartPeriod] [int] NOT NULL,
	[EndPeriod] [int] NOT NULL,
	[FirstProjectedPeriod] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[GRChangedDate] [datetime] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetReportGroup] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetReportGroupDetail]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetReportGroupDetail](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetReportGroupDetailId] [int] NOT NULL,
	[BudgetReportGroupId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetReportGroupDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetStatus]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetStatus](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetStatusId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetStatus] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[BudgetTaxType]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[BudgetTaxType](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[BudgetTaxTypeId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[TaxTypeId] [int] NOT NULL,
	[FixedTaxTypeId] [int] NOT NULL,
	[RateCalculationMethodId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[OriginalBudgetTaxTypeId] [int] NULL,
 CONSTRAINT [PK_BudgetTaxType] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [GACS].[Department]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [GACS].[Department](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[Department] [char](8) NOT NULL,
	[Description] [varchar](50) NULL,
	[LastDate] [datetime] NULL,
	[MRIUserID] [char](20) NULL,
	[Source] [char](2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FunctionalDepartmentId] [int] NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INProp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INProp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](55) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](14) NULL,
	[LASTDATE] [datetime] NULL,
	[PROJID] [char](6) NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[CURRCODE] [char](3) NULL,
 CONSTRAINT [UPKCL_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INCorp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INCorp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](30) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](15) NULL,
	[LASTDATE] [datetime] NULL,
	[PROJID] [char](6) NOT NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[CURRCODE] [char](3) NULL,
 CONSTRAINT [UPKCL_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUCorp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUCorp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](40) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](15) NULL,
	[FEET] [money] NULL,
	[UNITS] [int] NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[LEDGCODE] [char](2) NOT NULL,
	[CLOSEDAY] [char](3) NOT NULL,
	[YEAREND] [char](6) NULL,
	[CURPED] [char](6) NULL,
	[MAXOPEN] [smallint] NULL,
	[BASIS] [char](1) NOT NULL,
	[PROJID] [char](6) NOT NULL,
	[INTRACCT] [char](12) NULL,
	[GLPURGE] [char](6) NULL,
	[APACCTNO] [char](12) NULL,
	[OPENBAL] [money] NULL,
	[INVCSTAT] [char](1) NOT NULL,
	[SUMDET] [char](1) NOT NULL,
	[SUMCASH] [char](1) NOT NULL,
	[CASHTYPE] [char](2) NULL,
	[APPURGE] [char](6) NULL,
	[M_1099DATE] [datetime] NULL,
	[VATREG] [char](20) NULL,
	[ATAXACCT] [char](12) NULL,
	[ATAXCASH] [char](2) NULL,
	[VENDPPED] [char](6) NULL,
	[PAYENTRY] [char](1) NULL,
	[TAXEXEMP] [char](12) NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[ACCTNUM] [char](12) NULL,
	[APPLIMIT] [money] NULL,
	[STATEID] [char](2) NULL,
	[PROPTYPE] [char](3) NULL,
	[PROPSUBTYPE] [char](3) NULL,
	[ACQUIRED] [datetime] NULL,
	[DISPOSED] [datetime] NULL,
	[INVESTFLAG] [char](1) NULL,
	[CLASSID] [char](1) NULL,
	[INVTYPE] [char](6) NULL,
	[LIFECODE] [char](6) NULL,
	[LOCAID] [char](3) NULL,
	[GROSSVALUE] [money] NULL,
	[NETVALUE] [money] NULL,
	[INCRET] [money] NULL,
	[CAPRET] [money] NULL,
	[TOTRET] [money] NULL,
	[JEDESCID] [char](9) NULL,
	[OPTED] [char](1) NULL,
	[CURRCODE] [char](3) NULL,
	[APREALEXCHG] [char](12) NULL,
	[APUNREEXCHG] [char](12) NULL,
	[CROSSCURYN] [char](1) NULL,
	[CMREALACCT] [char](12) NULL,
	[CMUNREACCT] [char](12) NULL,
	[CMDEPGLACCT] [char](12) NULL,
	[RMTACCTNO] [char](12) NULL,
	[RMTCASHTYPE] [char](2) NULL,
	[RMTOTHRFEE] [money] NULL,
	[TOGFEES] [money] NULL,
	[MINBAL] [money] NULL,
	[HELDFUNDS] [money] NULL,
	[BADTAXACCT] [char](12) NULL,
	[BADTAXCSHTYPE] [char](2) NULL,
	[FIDTAXACCT] [char](12) NULL,
	[FIDTAXCSHTYPE] [char](2) NULL,
	[TOGACCTNUM] [char](12) NULL,
	[TOGCASHTYPE] [char](2) NULL,
	[TOGVENDID] [char](6) NULL,
	[OTRACCTNUM] [char](12) NULL,
	[OTRCASHTYPE] [char](2) NULL,
	[OTRVENDID] [char](6) NULL,
	[ENTTYPE] [char](3) NULL,
	[PERIODCNT] [smallint] NULL,
	[RECLAIMPCT] [float] NULL,
	[ALTTAXID] [char](15) NULL,
	[TAXSUSPENSE] [char](1) NULL,
	[CMNBANKING] [char](1) NULL,
	[ARREALACCT] [char](12) NULL,
	[ARUNREACCT] [char](12) NULL,
	[RETAINACCT] [char](12) NULL,
	[BILLFEES] [char](1) NULL,
	[FUNDBALACCT] [char](12) NULL,
	[TAXRPTFREQ] [char](1) NULL,
	[OWNERID] [char](6) NULL,
	[COUNTRY] [char](2) NULL,
	[APTAXSUSPENSEACCOUNTNUMBER] [char](12) NULL,
	[STLINEBASIS] [char](1) NULL,
	[MATRIXID] [float] NULL,
	[ENTMATRIXOPTION] [char](1) NULL,
	[NCREIFACQUIREDFIRSTDAYQTR] [char](1) NULL,
	[NCREIFDISPOSEDLASTDAYQTR] [char](1) NULL,
	[CHECKLOCATIONID] [char](6) NULL,
	[POSCSHTYP] [char](2) NULL,
	[MAXAPOPEN] [smallint] NULL,
	[APREALLOSS] [char](12) NULL,
	[APUNREALLOSS] [char](12) NULL,
	[ARREALLOSS] [char](12) NULL,
	[ARUNREALLOSS] [char](12) NULL,
	[CMREALLOSS] [char](12) NULL,
	[CMUNREALLOSS] [char](12) NULL,
	[CMDEPLOSS] [char](12) NULL,
	[VENDORWITHHOLDINGACCT] [char](12) NULL,
 CONSTRAINT [PK_ENTITY_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUProp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUProp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](80) NOT NULL,
	[ADDR1] [char](40) NULL,
	[ADDR2] [char](60) NULL,
	[ADDR3] [char](60) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](25) NULL,
	[FEET] [money] NULL,
	[UNITS] [int] NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[LEDGCODE] [char](2) NOT NULL,
	[CLOSEDAY] [char](3) NOT NULL,
	[YEAREND] [char](6) NULL,
	[CURPED] [char](6) NULL,
	[MAXOPEN] [smallint] NULL,
	[BASIS] [char](1) NOT NULL,
	[PROJID] [char](6) NOT NULL,
	[INTRACCT] [char](12) NULL,
	[GLPURGE] [char](6) NULL,
	[APACCTNO] [char](12) NULL,
	[OPENBAL] [money] NULL,
	[INVCSTAT] [char](1) NOT NULL,
	[SUMDET] [char](1) NOT NULL,
	[SUMCASH] [char](1) NOT NULL,
	[CASHTYPE] [char](2) NULL,
	[APPURGE] [char](6) NULL,
	[M_1099DATE] [datetime] NULL,
	[VATREG] [char](20) NULL,
	[ATAXACCT] [char](12) NULL,
	[ATAXCASH] [char](2) NULL,
	[VENDPPED] [char](6) NULL,
	[PAYENTRY] [char](1) NULL,
	[TAXEXEMP] [char](12) NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[ACCTNUM] [char](12) NULL,
	[APPLIMIT] [money] NULL,
	[STATEID] [char](2) NULL,
	[PROPTYPE] [char](3) NULL,
	[PROPSUBTYPE] [char](3) NULL,
	[ACQUIRED] [datetime] NULL,
	[DISPOSED] [datetime] NULL,
	[INVESTFLAG] [char](1) NULL,
	[CLASSID] [char](1) NULL,
	[INVTYPE] [char](6) NULL,
	[LIFECODE] [char](6) NULL,
	[LOCAID] [char](3) NULL,
	[GROSSVALUE] [money] NULL,
	[NETVALUE] [money] NULL,
	[INCRET] [money] NULL,
	[CAPRET] [money] NULL,
	[TOTRET] [money] NULL,
	[JEDESCID] [char](9) NULL,
	[OPTED] [char](1) NULL,
	[CURRCODE] [char](3) NULL,
	[APREALEXCHG] [char](12) NULL,
	[APUNREEXCHG] [char](12) NULL,
	[CROSSCURYN] [char](1) NULL,
	[CMREALACCT] [char](12) NULL,
	[CMUNREACCT] [char](12) NULL,
	[CMDEPGLACCT] [char](12) NULL,
	[RMTACCTNO] [char](12) NULL,
	[RMTCASHTYPE] [char](2) NULL,
	[RMTOTHRFEE] [money] NULL,
	[TOGFEES] [money] NULL,
	[MINBAL] [money] NULL,
	[HELDFUNDS] [money] NULL,
	[BADTAXACCT] [char](12) NULL,
	[BADTAXCSHTYPE] [char](2) NULL,
	[FIDTAXACCT] [char](12) NULL,
	[FIDTAXCSHTYPE] [char](2) NULL,
	[TOGACCTNUM] [char](12) NULL,
	[TOGCASHTYPE] [char](2) NULL,
	[TOGVENDID] [char](6) NULL,
	[OTRACCTNUM] [char](12) NULL,
	[OTRCASHTYPE] [char](2) NULL,
	[OTRVENDID] [char](6) NULL,
	[ENTTYPE] [char](3) NULL,
	[PERIODCNT] [smallint] NULL,
	[RECLAIMPCT] [float] NULL,
	[ALTTAXID] [char](15) NULL,
	[TAXSUSPENSE] [char](1) NULL,
	[CMNBANKING] [char](1) NULL,
	[ARREALACCT] [char](12) NULL,
	[ARUNREACCT] [char](12) NULL,
	[RETAINACCT] [char](12) NULL,
	[PHONENO] [char](14) NULL,
	[SERVCHRG] [char](1) NULL,
	[CMCOMPID] [char](2) NULL,
	[APCOMPID] [char](2) NULL,
	[ATAXCODE] [char](1) NULL,
	[APDEVID] [char](3) NULL,
	[BILLFEES] [char](1) NULL,
	[FUNDBALACCT] [char](12) NULL,
	[TAXRPTFREQ] [char](1) NULL,
	[OWNERID] [char](6) NULL,
	[COUNTRY] [char](2) NULL,
	[APTAXSUSPENSEACCOUNTNUMBER] [char](12) NULL,
	[STLINEBASIS] [char](1) NULL,
	[OUTSOURCED] [char](1) NULL,
	[MATRIXID] [float] NULL,
	[ENTMATRIXOPTION] [char](1) NULL,
	[NCREIFACQUIREDFIRSTDAYQTR] [char](1) NULL,
	[NCREIFDISPOSEDLASTDAYQTR] [char](1) NULL,
	[CHECKLOCATIONID] [char](6) NULL,
	[MAXAPOPEN] [smallint] NULL,
	[APREALLOSS] [char](12) NULL,
	[APUNREALLOSS] [char](12) NULL,
	[ARREALLOSS] [char](12) NULL,
	[ARUNREALLOSS] [char](12) NULL,
	[CMREALLOSS] [char](12) NULL,
	[CMUNREALLOSS] [char](12) NULL,
	[CMDEPLOSS] [char](12) NULL,
	[VENDORWITHHOLDINGACCT] [char](12) NULL,
	[TS_CRN] [char](15) NULL,
	[ADDR4] [char](60) NULL,
	[TS_FAXNO] [char](25) NULL,
 CONSTRAINT [PK_ENTITY_2] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [CNProp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNProp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [nchar](7) NOT NULL,
	[NAME] [nchar](30) NOT NULL,
	[ADDR1] [nchar](35) NULL,
	[ADDR2] [nchar](35) NULL,
	[ADDR3] [nchar](35) NULL,
	[STATE] [nchar](3) NULL,
	[CITY] [nchar](17) NULL,
	[ZIPCODE] [nchar](9) NULL,
	[PHONE] [nchar](15) NULL,
	[FEET] [money] NULL,
	[UNITS] [int] NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[LEDGCODE] [nchar](2) NOT NULL,
	[CLOSEDAY] [nchar](3) NOT NULL,
	[YEAREND] [nchar](6) NULL,
	[CURPED] [nchar](6) NULL,
	[MAXOPEN] [smallint] NULL,
	[BASIS] [nchar](1) NOT NULL,
	[PROJID] [nchar](6) NOT NULL,
	[INTRACCT] [nchar](12) NULL,
	[GLPURGE] [nchar](6) NULL,
	[APACCTNO] [nchar](12) NULL,
	[OPENBAL] [money] NULL,
	[INVCSTAT] [nchar](1) NOT NULL,
	[SUMDET] [nchar](1) NOT NULL,
	[SUMCASH] [nchar](1) NOT NULL,
	[CASHTYPE] [nchar](2) NULL,
	[APPURGE] [nchar](6) NULL,
	[M_1099DATE] [datetime] NULL,
	[VATREG] [nchar](9) NULL,
	[ATAXACCT] [nchar](12) NULL,
	[ATAXCASH] [nchar](2) NULL,
	[VENDPPED] [nchar](6) NULL,
	[PAYENTRY] [nchar](1) NULL,
	[TAXEXEMP] [nchar](12) NULL,
	[SHIPADR1] [nchar](35) NULL,
	[SHIPADR2] [nchar](35) NULL,
	[SHIPADR3] [nchar](35) NULL,
	[SHIPCITY] [nchar](17) NULL,
	[SHIPST] [nchar](3) NULL,
	[SHIPZIP] [nchar](9) NULL,
	[BILLADR1] [nchar](35) NULL,
	[BILLADR2] [nchar](35) NULL,
	[BILLADR3] [nchar](35) NULL,
	[BILLCITY] [nchar](17) NULL,
	[BILLST] [nchar](3) NULL,
	[BILLZIP] [nchar](9) NULL,
	[ACCTNUM] [nchar](12) NULL,
	[APPLIMIT] [money] NULL,
	[STATEID] [nchar](2) NULL,
	[PROPTYPE] [nchar](3) NULL,
	[PROPSUBTYPE] [nchar](3) NULL,
	[ACQUIRED] [datetime] NULL,
	[DISPOSED] [datetime] NULL,
	[INVESTFLAG] [nchar](1) NULL,
	[CLASSID] [nchar](1) NULL,
	[INVTYPE] [nchar](6) NULL,
	[LIFECODE] [nchar](6) NULL,
	[LOCAID] [nchar](3) NULL,
	[GROSSVALUE] [money] NULL,
	[NETVALUE] [money] NULL,
	[INCRET] [money] NULL,
	[CAPRET] [money] NULL,
	[TOTRET] [money] NULL,
	[JEDESCID] [nchar](9) NULL,
	[OPTED] [nchar](1) NULL,
	[CURRCODE] [nchar](3) NULL,
	[APREALEXCHG] [nchar](12) NULL,
	[APUNREEXCHG] [nchar](12) NULL,
	[CROSSCURYN] [nchar](1) NULL,
	[CMREALACCT] [nchar](12) NULL,
	[CMUNREACCT] [nchar](12) NULL,
	[CMDEPGLACCT] [nchar](12) NULL,
	[RMTACCTNO] [nchar](12) NULL,
	[RMTCASHTYPE] [nchar](2) NULL,
	[RMTOTHRFEE] [money] NULL,
	[TOGFEES] [money] NULL,
	[MINBAL] [money] NULL,
	[HELDFUNDS] [money] NULL,
	[BADTAXACCT] [nchar](12) NULL,
	[BADTAXCSHTYPE] [nchar](2) NULL,
	[FIDTAXACCT] [nchar](12) NULL,
	[FIDTAXCSHTYPE] [nchar](2) NULL,
	[TOGACCTNUM] [nchar](12) NULL,
	[TOGCASHTYPE] [nchar](2) NULL,
	[TOGVENDID] [nchar](6) NULL,
	[OTRACCTNUM] [nchar](12) NULL,
	[OTRCASHTYPE] [nchar](2) NULL,
	[OTRVENDID] [nchar](6) NULL,
	[ENTTYPE] [nchar](3) NULL,
	[PERIODCNT] [smallint] NULL,
	[RECLAIMPCT] [float] NULL,
	[ALTTAXID] [nchar](15) NULL,
	[TAXSUSPENSE] [nchar](1) NULL,
	[CMNBANKING] [nchar](1) NULL,
	[ARREALACCT] [nchar](12) NULL,
	[ARUNREACCT] [nchar](12) NULL,
	[RETAINACCT] [nchar](12) NULL,
	[BILLFEES] [nchar](1) NULL,
	[FUNDBALACCT] [nchar](12) NULL,
	[TAXRPTFREQ] [nchar](1) NULL,
	[OWNERID] [nchar](6) NULL,
	[COUNTRY] [nchar](2) NULL,
	[APTAXSUSPENSEACCOUNTNUMBER] [nchar](12) NULL,
	[STLINEBASIS] [nchar](1) NULL,
	[MATRIXID] [float] NULL,
	[ENTMATRIXOPTION] [nchar](1) NULL,
	[NCREIFACQUIREDFIRSTDAYQTR] [nchar](1) NULL,
	[NCREIFDISPOSEDLASTDAYQTR] [nchar](1) NULL,
	[CHECKLOCATIONID] [nchar](6) NULL,
	[POSCSHTYP] [nchar](2) NULL,
	[MAXAPOPEN] [smallint] NULL,
	[APREALLOSS] [nchar](12) NULL,
	[APUNREALLOSS] [nchar](12) NULL,
	[ARREALLOSS] [nchar](12) NULL,
	[ARUNREALLOSS] [nchar](12) NULL,
	[CMREALLOSS] [nchar](12) NULL,
	[CMUNREALLOSS] [nchar](12) NULL,
	[CMDEPLOSS] [nchar](12) NULL,
	[VENDORWITHHOLDINGACCT] [nchar](12) NULL,
 CONSTRAINT [UPKCL_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BRProp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRProp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](55) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](14) NULL,
	[LASTDATE] [datetime] NULL,
	[PROJID] [char](6) NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[CURRCODE] [char](3) NULL,
 CONSTRAINT [UPKCL_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USCorp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USCorp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](30) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](15) NULL,
	[FEET] [money] NULL,
	[UNITS] [int] NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[LEDGCODE] [char](2) NOT NULL,
	[CLOSEDAY] [char](3) NOT NULL,
	[YEAREND] [char](6) NULL,
	[CURPED] [char](6) NULL,
	[MAXOPEN] [smallint] NULL,
	[BASIS] [char](1) NOT NULL,
	[PROJID] [char](6) NOT NULL,
	[INTRACCT] [char](14) NULL,
	[GLPURGE] [char](6) NULL,
	[APACCTNO] [char](14) NULL,
	[OPENBAL] [money] NULL,
	[INVCSTAT] [char](1) NOT NULL,
	[SUMDET] [char](1) NOT NULL,
	[SUMCASH] [char](1) NOT NULL,
	[CASHTYPE] [char](2) NULL,
	[APPURGE] [char](6) NULL,
	[M_1099DATE] [datetime] NULL,
	[VATREG] [char](9) NULL,
	[ATAXACCT] [char](14) NULL,
	[ATAXCASH] [char](2) NULL,
	[VENDPPED] [char](6) NULL,
	[PAYENTRY] [char](1) NULL,
	[TAXEXEMP] [char](12) NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[ACCTNUM] [char](14) NULL,
	[APPLIMIT] [money] NULL,
	[STATEID] [char](2) NULL,
	[PROPTYPE] [char](3) NULL,
	[PROPSUBTYPE] [char](3) NULL,
	[ACQUIRED] [datetime] NULL,
	[DISPOSED] [datetime] NULL,
	[INVESTFLAG] [char](1) NULL,
	[CLASSID] [char](1) NULL,
	[INVTYPE] [char](6) NULL,
	[LIFECODE] [char](6) NULL,
	[LOCAID] [char](3) NULL,
	[GROSSVALUE] [money] NULL,
	[NETVALUE] [money] NULL,
	[INCRET] [money] NULL,
	[CAPRET] [money] NULL,
	[TOTRET] [money] NULL,
	[JEDESCID] [char](9) NULL,
	[OPTED] [char](1) NULL,
	[CURRCODE] [char](3) NULL,
	[APREALEXCHG] [char](14) NULL,
	[APUNREEXCHG] [char](14) NULL,
	[CROSSCURYN] [char](1) NULL,
	[CMREALACCT] [char](14) NULL,
	[CMUNREACCT] [char](14) NULL,
	[CMDEPGLACCT] [char](14) NULL,
	[RMTACCTNO] [char](14) NULL,
	[RMTCASHTYPE] [char](2) NULL,
	[RMTOTHRFEE] [money] NULL,
	[TOGFEES] [money] NULL,
	[MINBAL] [money] NULL,
	[HELDFUNDS] [money] NULL,
	[BADTAXACCT] [char](14) NULL,
	[BADTAXCSHTYPE] [char](2) NULL,
	[FIDTAXACCT] [char](14) NULL,
	[FIDTAXCSHTYPE] [char](2) NULL,
	[TOGACCTNUM] [char](14) NULL,
	[TOGCASHTYPE] [char](2) NULL,
	[TOGVENDID] [char](6) NULL,
	[OTRACCTNUM] [char](14) NULL,
	[OTRCASHTYPE] [char](2) NULL,
	[OTRVENDID] [char](6) NULL,
	[ENTTYPE] [char](3) NULL,
	[PERIODCNT] [smallint] NULL,
	[RECLAIMPCT] [float] NULL,
	[ALTTAXID] [char](15) NULL,
	[TAXSUSPENSE] [char](1) NULL,
	[CMNBANKING] [char](1) NULL,
	[ARREALACCT] [char](14) NULL,
	[ARUNREACCT] [char](14) NULL,
	[RETAINACCT] [char](14) NULL,
	[BILLFEES] [char](1) NULL,
	[FUNDBALACCT] [char](14) NULL,
	[TAXRPTFREQ] [char](1) NULL,
	[OWNERID] [char](6) NULL,
	[COUNTRY] [char](2) NULL,
	[APTAXSUSPENSEACCOUNTNUMBER] [char](14) NULL,
	[STLINEBASIS] [char](1) NULL,
	[MATRIXID] [float] NULL,
	[ENTMATRIXOPTION] [char](1) NULL,
	[NCREIFACQUIREDFIRSTDAYQTR] [char](1) NULL,
	[NCREIFDISPOSEDLASTDAYQTR] [char](1) NULL,
	[CHECKLOCATIONID] [char](6) NULL,
	[POSCSHTYP] [char](2) NULL,
 CONSTRAINT [PK_ENTITY_3] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BRCorp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRCorp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](30) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](15) NULL,
	[LASTDATE] [datetime] NULL,
	[PROJID] [char](6) NOT NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[CURRCODE] [char](3) NULL,
 CONSTRAINT [UPKCL_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [CNCorp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNCorp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [nchar](6) NOT NULL,
	[NAME] [nchar](40) NOT NULL,
	[ADDR1] [nchar](35) NULL,
	[ADDR2] [nchar](35) NULL,
	[ADDR3] [nchar](35) NULL,
	[STATE] [nchar](3) NULL,
	[CITY] [nchar](17) NULL,
	[ZIPCODE] [nchar](9) NULL,
	[PHONE] [nchar](15) NULL,
	[FEET] [money] NULL,
	[UNITS] [int] NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[LEDGCODE] [nchar](2) NOT NULL,
	[CLOSEDAY] [nchar](3) NOT NULL,
	[YEAREND] [nchar](6) NULL,
	[CURPED] [nchar](6) NULL,
	[MAXOPEN] [smallint] NULL,
	[BASIS] [nchar](1) NOT NULL,
	[PROJID] [nchar](6) NOT NULL,
	[INTRACCT] [nchar](12) NULL,
	[GLPURGE] [nchar](6) NULL,
	[APACCTNO] [nchar](12) NULL,
	[OPENBAL] [money] NULL,
	[INVCSTAT] [nchar](1) NOT NULL,
	[SUMDET] [nchar](1) NOT NULL,
	[SUMCASH] [nchar](1) NOT NULL,
	[CASHTYPE] [nchar](2) NULL,
	[APPURGE] [nchar](6) NULL,
	[M_1099DATE] [datetime] NULL,
	[VATREG] [nchar](9) NULL,
	[ATAXACCT] [nchar](12) NULL,
	[ATAXCASH] [nchar](2) NULL,
	[VENDPPED] [nchar](6) NULL,
	[PAYENTRY] [nchar](1) NULL,
	[TAXEXEMP] [nchar](12) NULL,
	[SHIPADR1] [nchar](35) NULL,
	[SHIPADR2] [nchar](35) NULL,
	[SHIPADR3] [nchar](35) NULL,
	[SHIPCITY] [nchar](17) NULL,
	[SHIPST] [nchar](3) NULL,
	[SHIPZIP] [nchar](9) NULL,
	[BILLADR1] [nchar](35) NULL,
	[BILLADR2] [nchar](35) NULL,
	[BILLADR3] [nchar](35) NULL,
	[BILLCITY] [nchar](17) NULL,
	[BILLST] [nchar](3) NULL,
	[BILLZIP] [nchar](9) NULL,
	[ACCTNUM] [nchar](12) NULL,
	[APPLIMIT] [money] NULL,
	[STATEID] [nchar](2) NULL,
	[PROPTYPE] [nchar](3) NULL,
	[PROPSUBTYPE] [nchar](3) NULL,
	[ACQUIRED] [datetime] NULL,
	[DISPOSED] [datetime] NULL,
	[INVESTFLAG] [nchar](1) NULL,
	[CLASSID] [nchar](1) NULL,
	[INVTYPE] [nchar](6) NULL,
	[LIFECODE] [nchar](6) NULL,
	[LOCAID] [nchar](3) NULL,
	[GROSSVALUE] [money] NULL,
	[NETVALUE] [money] NULL,
	[INCRET] [money] NULL,
	[CAPRET] [money] NULL,
	[TOTRET] [money] NULL,
	[JEDESCID] [nchar](9) NULL,
	[OPTED] [nchar](1) NULL,
	[CURRCODE] [nchar](3) NULL,
	[APREALEXCHG] [nchar](12) NULL,
	[APUNREEXCHG] [nchar](12) NULL,
	[CROSSCURYN] [nchar](1) NULL,
	[CMREALACCT] [nchar](12) NULL,
	[CMUNREACCT] [nchar](12) NULL,
	[CMDEPGLACCT] [nchar](12) NULL,
	[RMTACCTNO] [nchar](12) NULL,
	[RMTCASHTYPE] [nchar](2) NULL,
	[RMTOTHRFEE] [money] NULL,
	[TOGFEES] [money] NULL,
	[MINBAL] [money] NULL,
	[HELDFUNDS] [money] NULL,
	[BADTAXACCT] [nchar](12) NULL,
	[BADTAXCSHTYPE] [nchar](2) NULL,
	[FIDTAXACCT] [nchar](12) NULL,
	[FIDTAXCSHTYPE] [nchar](2) NULL,
	[TOGACCTNUM] [nchar](12) NULL,
	[TOGCASHTYPE] [nchar](2) NULL,
	[TOGVENDID] [nchar](6) NULL,
	[OTRACCTNUM] [nchar](12) NULL,
	[OTRCASHTYPE] [nchar](2) NULL,
	[OTRVENDID] [nchar](6) NULL,
	[ENTTYPE] [nchar](3) NULL,
	[PERIODCNT] [smallint] NULL,
	[RECLAIMPCT] [float] NULL,
	[ALTTAXID] [nchar](15) NULL,
	[TAXSUSPENSE] [nchar](1) NULL,
	[CMNBANKING] [nchar](1) NULL,
	[ARREALACCT] [nchar](12) NULL,
	[ARUNREACCT] [nchar](12) NULL,
	[RETAINACCT] [nchar](12) NULL,
	[BILLFEES] [nchar](1) NULL,
	[FUNDBALACCT] [nchar](12) NULL,
	[TAXRPTFREQ] [nchar](1) NULL,
	[OWNERID] [nchar](6) NULL,
	[COUNTRY] [nchar](2) NULL,
	[APTAXSUSPENSEACCOUNTNUMBER] [nchar](12) NULL,
	[STLINEBASIS] [nchar](1) NULL,
	[MATRIXID] [float] NULL,
	[ENTMATRIXOPTION] [nchar](1) NULL,
	[NCREIFACQUIREDFIRSTDAYQTR] [nchar](1) NULL,
	[NCREIFDISPOSEDLASTDAYQTR] [nchar](1) NULL,
	[CHECKLOCATIONID] [nchar](6) NULL,
	[POSCSHTYP] [nchar](2) NULL,
	[MAXAPOPEN] [smallint] NULL,
	[APREALLOSS] [nchar](12) NULL,
	[APUNREALLOSS] [nchar](12) NULL,
	[ARREALLOSS] [nchar](12) NULL,
	[ARUNREALLOSS] [nchar](12) NULL,
	[CMREALLOSS] [nchar](12) NULL,
	[CMUNREALLOSS] [nchar](12) NULL,
	[CMDEPLOSS] [nchar](12) NULL,
	[VENDORWITHHOLDINGACCT] [nchar](12) NULL,
 CONSTRAINT [UPKCL_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USProp].[ENTITY]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USProp].[ENTITY](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[NAME] [char](55) NOT NULL,
	[ADDR1] [char](35) NULL,
	[ADDR2] [char](35) NULL,
	[ADDR3] [char](35) NULL,
	[STATE] [char](3) NULL,
	[CITY] [char](17) NULL,
	[ZIPCODE] [char](9) NULL,
	[PHONE] [char](14) NULL,
	[FEET] [money] NULL,
	[UNITS] [int] NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[LEDGCODE] [char](2) NOT NULL,
	[CLOSEDAY] [char](3) NOT NULL,
	[YEAREND] [char](6) NULL,
	[CURPED] [char](6) NULL,
	[MAXOPEN] [smallint] NULL,
	[BASIS] [char](1) NOT NULL,
	[PROJID] [char](6) NOT NULL,
	[INTRACCT] [char](14) NULL,
	[GLPURGE] [char](6) NULL,
	[APACCTNO] [char](14) NULL,
	[OPENBAL] [money] NULL,
	[INVCSTAT] [char](1) NOT NULL,
	[SUMDET] [char](1) NOT NULL,
	[SUMCASH] [char](1) NOT NULL,
	[CASHTYPE] [char](2) NULL,
	[APPURGE] [char](6) NULL,
	[M_1099DATE] [datetime] NULL,
	[VATREG] [char](9) NULL,
	[ATAXACCT] [char](14) NULL,
	[ATAXCASH] [char](2) NULL,
	[VENDPPED] [char](6) NULL,
	[PAYENTRY] [char](1) NULL,
	[TAXEXEMP] [char](12) NULL,
	[SHIPADR1] [char](35) NULL,
	[SHIPADR2] [char](35) NULL,
	[SHIPADR3] [char](35) NULL,
	[SHIPCITY] [char](17) NULL,
	[SHIPST] [char](3) NULL,
	[SHIPZIP] [char](9) NULL,
	[BILLADR1] [char](35) NULL,
	[BILLADR2] [char](35) NULL,
	[BILLADR3] [char](35) NULL,
	[BILLCITY] [char](17) NULL,
	[BILLST] [char](3) NULL,
	[BILLZIP] [char](9) NULL,
	[ACCTNUM] [char](14) NULL,
	[APPLIMIT] [money] NULL,
	[STATEID] [char](2) NULL,
	[PROPTYPE] [char](3) NULL,
	[PROPSUBTYPE] [char](3) NULL,
	[ACQUIRED] [datetime] NULL,
	[DISPOSED] [datetime] NULL,
	[INVESTFLAG] [char](1) NULL,
	[CLASSID] [char](1) NULL,
	[INVTYPE] [char](6) NULL,
	[LIFECODE] [char](6) NULL,
	[LOCAID] [char](3) NULL,
	[GROSSVALUE] [money] NULL,
	[NETVALUE] [money] NULL,
	[INCRET] [money] NULL,
	[CAPRET] [money] NULL,
	[TOTRET] [money] NULL,
	[JEDESCID] [char](9) NULL,
	[OPTED] [char](1) NULL,
	[CURRCODE] [char](3) NULL,
	[APREALEXCHG] [char](14) NULL,
	[APUNREEXCHG] [char](14) NULL,
	[CROSSCURYN] [char](1) NULL,
	[CMREALACCT] [char](14) NULL,
	[CMUNREACCT] [char](14) NULL,
	[CMDEPGLACCT] [char](14) NULL,
	[RMTACCTNO] [char](14) NULL,
	[RMTCASHTYPE] [char](2) NULL,
	[RMTOTHRFEE] [money] NULL,
	[TOGFEES] [money] NULL,
	[MINBAL] [money] NULL,
	[HELDFUNDS] [money] NULL,
	[BADTAXACCT] [char](14) NULL,
	[BADTAXCSHTYPE] [char](2) NULL,
	[FIDTAXACCT] [char](14) NULL,
	[FIDTAXCSHTYPE] [char](2) NULL,
	[TOGACCTNUM] [char](14) NULL,
	[TOGCASHTYPE] [char](2) NULL,
	[TOGVENDID] [char](6) NULL,
	[OTRACCTNUM] [char](14) NULL,
	[OTRCASHTYPE] [char](2) NULL,
	[OTRVENDID] [char](6) NULL,
	[ENTTYPE] [char](3) NOT NULL,
	[PERIODCNT] [smallint] NULL,
	[RECLAIMPCT] [float] NULL,
	[ALTTAXID] [char](15) NULL,
	[TAXSUSPENSE] [char](1) NULL,
	[CMNBANKING] [char](1) NULL,
	[ARREALACCT] [char](14) NULL,
	[ARUNREACCT] [char](14) NULL,
	[RETAINACCT] [char](14) NULL,
	[BILLFEES] [char](1) NULL,
	[FUNDBALACCT] [char](14) NULL,
	[TAXRPTFREQ] [char](1) NULL,
	[OWNERID] [char](6) NULL,
	[COUNTRY] [char](2) NULL,
	[APTAXSUSPENSEACCOUNTNUMBER] [char](14) NULL,
	[STLINEBASIS] [char](1) NULL,
	[MATRIXID] [float] NULL,
	[ENTMATRIXOPTION] [char](1) NULL,
	[NCREIFACQUIREDFIRSTDAYQTR] [char](1) NULL,
	[NCREIFDISPOSEDLASTDAYQTR] [char](1) NULL,
	[CHECKLOCATIONID] [char](6) NULL,
	[PHONENO] [char](14) NULL,
	[TSPREGION] [char](15) NULL,
	[TOWNID] [char](9) NULL,
	[PROLOG] [char](1) NULL,
	[FASCOMPANYID] [smallint] NULL,
 CONSTRAINT [PK_ENTITY] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[ExchangeRate]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[ExchangeRate](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ExchangeRateId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[StartPeriod] [int] NULL,
	[EndPeriod] [int] NULL,
	[IsLocked] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ExchangeRate] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[ExchangeRateDetail]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[ExchangeRateDetail](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ExchangeRateDetailId] [int] NOT NULL,
	[ExchangeRateId] [int] NOT NULL,
	[CurrencyCode] [char](3) NOT NULL,
	[Period] [int] NULL,
	[Rate] [decimal](18, 4) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ExchangeRateDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [HR].[FunctionalDepartment]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [HR].[FunctionalDepartment](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[GlobalCode] [char](3) NULL,
 CONSTRAINT [PK_FunctionalDepartment] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USProp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USProp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[ACCTNAME] [char](40) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[M_1099ACCT] [char](1) NOT NULL,
	[DPRSTR] [char](1) NULL,
	[PEXCHTYPE] [char](1) NULL,
	[OWNERTAX] [char](1) NULL,
	[SUBWITH] [char](1) NULL,
	[ACCTBASIS] [char](1) NULL,
	[LEGALACCT] [char](1) NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BRCorp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRCorp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[ACCTNAME] [char](50) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [CNProp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNProp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [nchar](12) NOT NULL,
	[ACCTNAME] [nchar](60) NULL,
	[TYPE] [nchar](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[M_1099ACCT] [nchar](1) NOT NULL,
	[DPRSTR] [nchar](1) NULL,
	[PEXCHTYPE] [nchar](1) NULL,
	[OWNERTAX] [nchar](1) NULL,
	[SUBWITH] [nchar](1) NULL,
	[ACCTBASIS] [nchar](1) NULL,
	[LEGALACCT] [nchar](1) NULL,
	[TSPAGREEMENT] [nchar](1) NULL,
	[ACCTNAME_EN] [nchar](50) NULL,
	[ISGR] [nchar](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUCorp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUCorp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](12) NOT NULL,
	[ACCTNAME] [char](50) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[M_1099ACCT] [char](1) NOT NULL,
	[DPRSTR] [char](1) NULL,
	[PEXCHTYPE] [char](1) NULL,
	[OWNERTAX] [char](1) NULL,
	[SUBWITH] [char](1) NULL,
	[ACCTBASIS] [char](1) NULL,
	[LEGALACCT] [char](1) NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [PK_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INCorp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INCorp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[ACCTNAME] [char](50) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BRProp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRProp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[ACCTNAME] [char](50) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [CNCorp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNCorp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [nchar](12) NOT NULL,
	[ACCTNAME] [nchar](50) NULL,
	[TYPE] [nchar](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[M_1099ACCT] [nchar](1) NOT NULL,
	[DPRSTR] [nchar](1) NULL,
	[PEXCHTYPE] [nchar](1) NULL,
	[OWNERTAX] [nchar](1) NULL,
	[SUBWITH] [nchar](1) NULL,
	[ACCTBASIS] [nchar](1) NULL,
	[LEGALACCT] [nchar](1) NULL,
	[TSPAGREEMENT] [nchar](1) NULL,
	[ACCTNAME_EN] [nchar](50) NULL,
	[ISGR] [nchar](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUProp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUProp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](12) NOT NULL,
	[ACCTNAME] [char](60) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[M_1099ACCT] [char](1) NOT NULL,
	[DPRSTR] [char](1) NULL,
	[PEXCHTYPE] [char](1) NULL,
	[OWNERTAX] [char](1) NULL,
	[SUBWITH] [char](1) NULL,
	[ACCTBASIS] [char](1) NULL,
	[CONV] [char](1) NULL,
	[INACTIVE] [char](1) NULL,
	[LEGALACCT] [char](1) NULL,
	[SCHARGE] [char](1) NULL,
	[FACCTNAME] [char](65) NULL,
	[FACCT] [char](6) NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [PK_GACC_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INProp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INProp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[ACCTNAME] [char](50) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [UPKCL_GACC] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USCorp].[GACC]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USCorp].[GACC](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[ACCTNAME] [char](50) NULL,
	[TYPE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[M_1099ACCT] [char](1) NOT NULL,
	[DPRSTR] [char](1) NULL,
	[PEXCHTYPE] [char](1) NULL,
	[OWNERTAX] [char](1) NULL,
	[SUBWITH] [char](1) NULL,
	[ACCTBASIS] [char](1) NULL,
	[LEGALACCT] [char](1) NULL,
	[ACCOUNTCATEGORY] [char](8) NULL,
	[ISGR] [char](1) NULL,
 CONSTRAINT [PK_GACC_2] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USCorp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USCorp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[DTYPE] [char](1) NULL,
	[DREGION] [char](6) NULL,
	[TISHEXCLUDE] [char](1) NULL,
	[CONTNAME] [char](30) NULL,
	[INTERCOMPANY] [char](1) NULL,
	[DEPARTMENTTYPE] [char](10) NULL,
	[NETTSCOST] [char](1) NULL,
 CONSTRAINT [PK_GDEP_3] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INProp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INProp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
 CONSTRAINT [UPKCL_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BRProp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRProp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
 CONSTRAINT [UPKCL_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BRCorp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRCorp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[NETTSCOST] [char](1) NULL,
 CONSTRAINT [UPKCL_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INCorp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INCorp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[NETTSCOST] [char](1) NULL,
 CONSTRAINT [UPKCL_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [CNCorp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNCorp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [nchar](6) NOT NULL,
	[DESCRPN] [nchar](50) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[ACCOUNTID] [nchar](12) NULL,
	[NETTSCOST] [nchar](1) NULL,
 CONSTRAINT [UPKCL_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USProp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USProp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
 CONSTRAINT [PK_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUProp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUProp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](8) NOT NULL,
	[DESCRPN] [char](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
 CONSTRAINT [PK_GDEP_2] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUCorp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUCorp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[DESCRPN] [char](50) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[NETTSCOST] [char](1) NULL,
 CONSTRAINT [PK_GDEP_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [CNProp].[GDEP]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNProp].[GDEP](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[DEPARTMENT] [nchar](6) NOT NULL,
	[DESCRPN] [nchar](40) NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[ACCOUNTID] [nchar](12) NULL,
 CONSTRAINT [UPKCL_GDEP] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USCorp].[GHIS]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USCorp].[GHIS](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](6) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [int] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](13) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[PDENTRY] [char](6) NULL,
	[ENTRDATE] [datetime] NULL,
	[OWNERTAX] [char](1) NULL,
	[BASIS] [char](1) NOT NULL,
	[BALFOR] [char](1) NOT NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[OEXCHGREF] [char](8) NULL,
	[PPCJEFLAG] [char](1) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVREF] [char](6) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[REVITEM] [smallint] NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[CATEGORY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [float] NULL,
	[BRSTATUS] [char](1) NULL,
 CONSTRAINT [PK_GHIS_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [USProp].[GHIS]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USProp].[GHIS](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](8) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](15) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[PDENTRY] [char](6) NULL,
	[ENTRDATE] [datetime] NULL,
	[OWNERTAX] [char](1) NULL,
	[BASIS] [char](1) NOT NULL,
	[BALFOR] [char](1) NOT NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[OEXCHGREF] [char](8) NULL,
	[PPCJEFLAG] [char](1) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVREF] [char](8) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[REVITEM] [smallint] NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[CATEGORY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [float] NULL,
	[BRSTATUS] [char](1) NULL,
	[GDEP] [int] NULL,
	[DB] [char](2) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [PK_GHIS_2] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [EUProp].[GHIS]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUProp].[GHIS](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](8) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](12) NOT NULL,
	[DEPARTMENT] [char](8) NOT NULL,
	[JOBCODE] [char](15) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[PDENTRY] [char](6) NULL,
	[ENTRDATE] [datetime] NULL,
	[STATFLAG] [char](1) NULL,
	[BASIS] [char](1) NOT NULL,
	[BALFOR] [char](1) NOT NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[OEXCHGREF] [char](8) NULL,
	[PPCJEFLAG] [char](1) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVREF] [char](8) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[REVITEM] [smallint] NULL,
	[INVREF] [char](20) NULL,
	[CONV] [char](1) NULL,
	[ACCTDONE] [char](1) NULL,
	[OLDACCT] [char](12) NULL,
	[TSPREF] [char](8) NULL,
	[PAGINIER] [char](15) NULL,
	[ADDLDESC] [text] NULL,
	[VENDNAME] [char](35) NULL,
	[ALLOCODE] [char](3) NULL,
	[OWNERTAX] [char](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[FROMSCDT] [datetime] NULL,
	[TOSCDATE] [datetime] NULL,
	[CATEGORY] [char](1) NULL,
	[VATPED] [char](6) NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [char](1) NULL,
	[SCDATE] [datetime] NULL,
	[PARENTITEM] [float] NULL,
	[JRNLTYPE] [char](3) NULL,
	[APREF] [char](30) NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [char](20) NULL,
	[LOANSTAT] [char](1) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [PK_GHIS_3] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [CNProp].[GHIS]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNProp].[GHIS](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [nchar](6) NOT NULL,
	[REF] [nchar](6) NOT NULL,
	[SOURCE] [nchar](2) NOT NULL,
	[SITEID] [nchar](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [nchar](7) NOT NULL,
	[ACCTNUM] [nchar](12) NOT NULL,
	[DEPARTMENT] [nchar](6) NOT NULL,
	[JOBCODE] [nchar](7) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [nchar](60) NULL,
	[PDENTRY] [nchar](6) NULL,
	[ENTRDATE] [datetime] NULL,
	[OWNERTAX] [nchar](1) NULL,
	[BASIS] [nchar](1) NOT NULL,
	[BALFOR] [nchar](1) NOT NULL,
	[OCURRCODE] [nchar](3) NULL,
	[OAMT] [money] NULL,
	[OEXCHGREF] [nchar](8) NULL,
	[PPCJEFLAG] [nchar](1) NULL,
	[CJEGRPID] [nchar](5) NULL,
	[CJEID] [nchar](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [nchar](1) NULL,
	[REVREF] [nchar](6) NULL,
	[REVENTRY] [nchar](1) NULL,
	[REVPRD] [nchar](6) NULL,
	[INTENTENTRY] [nchar](1) NULL,
	[INTENTTYPE] [nchar](3) NULL,
	[REVITEM] [smallint] NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [nchar](5) NULL,
	[JC_COSTLIST] [nchar](3) NULL,
	[JC_COSTCODE] [nchar](6) NULL,
	[CATEGORY] [nchar](1) NULL,
	[VATPED] [nchar](6) NULL,
	[OWNTBL] [nchar](20) NULL,
	[OWNYEAR] [nchar](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [nchar](20) NULL,
	[CTRYYEAR] [nchar](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [nchar](1) NULL,
	[ADDLDESC] [ntext] NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [nchar](20) NULL,
	[LOANSTAT] [nchar](1) NULL,
	[CDEP] [nchar](6) NULL,
 CONSTRAINT [UPKCL_GHIS] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [EUCorp].[GHIS]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUCorp].[GHIS](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](6) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](12) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](7) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[PDENTRY] [char](6) NULL,
	[ENTRDATE] [datetime] NULL,
	[OWNERTAX] [char](1) NULL,
	[BASIS] [char](1) NOT NULL,
	[BALFOR] [char](1) NOT NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[OEXCHGREF] [char](8) NULL,
	[PPCJEFLAG] [char](1) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVREF] [char](6) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[REVITEM] [smallint] NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[CATEGORY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [char](1) NULL,
	[VATPED] [char](6) NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [char](20) NULL,
	[LOANSTAT] [char](1) NULL,
 CONSTRAINT [PK_GHIS] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [CNCorp].[GHIS]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNCorp].[GHIS](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [nchar](6) NOT NULL,
	[REF] [nchar](6) NOT NULL,
	[SOURCE] [nchar](2) NOT NULL,
	[SITEID] [nchar](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [nchar](6) NOT NULL,
	[ACCTNUM] [nchar](12) NOT NULL,
	[DEPARTMENT] [nchar](6) NOT NULL,
	[JOBCODE] [nchar](7) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [nchar](60) NULL,
	[PDENTRY] [nchar](6) NULL,
	[ENTRDATE] [datetime] NULL,
	[OWNERTAX] [nchar](1) NULL,
	[BASIS] [nchar](1) NOT NULL,
	[BALFOR] [nchar](1) NOT NULL,
	[OCURRCODE] [nchar](3) NULL,
	[OAMT] [money] NULL,
	[OEXCHGREF] [nchar](8) NULL,
	[PPCJEFLAG] [nchar](1) NULL,
	[CJEGRPID] [nchar](5) NULL,
	[CJEID] [nchar](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [nchar](1) NULL,
	[REVREF] [nchar](6) NULL,
	[REVENTRY] [nchar](1) NULL,
	[REVPRD] [nchar](6) NULL,
	[INTENTENTRY] [nchar](1) NULL,
	[INTENTTYPE] [nchar](3) NULL,
	[REVITEM] [smallint] NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [nchar](5) NULL,
	[JC_COSTLIST] [nchar](3) NULL,
	[JC_COSTCODE] [nchar](6) NULL,
	[CATEGORY] [nchar](1) NULL,
	[VATPED] [nchar](6) NULL,
	[OWNTBL] [nchar](20) NULL,
	[OWNYEAR] [nchar](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [nchar](20) NULL,
	[CTRYYEAR] [nchar](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [nchar](1) NULL,
	[ADDLDESC] [ntext] NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [nchar](20) NULL,
	[LOANSTAT] [nchar](1) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [UPKCL_GHIS] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [USCorp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USCorp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [char](13) NOT NULL,
	[DESCRPTN] [char](30) NULL,
	[JOBTYPE] [char](1) NOT NULL,
	[JOBBUDGT] [money] NULL,
	[JOBSRTDT] [datetime] NULL,
	[JIMPCDT] [datetime] NULL,
	[JINACTDT] [datetime] NULL,
	[JACTIVE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[SQFEET] [int] NULL,
	[BLDGID] [char](6) NULL,
	[LEASID] [char](6) NULL,
	[REVENH] [char](1) NOT NULL,
	[CAPRECUR] [char](1) NOT NULL,
	[PROJAMT] [money] NULL,
	[CHNGAMT] [money] NULL,
	[ESCYRS] [smallint] NULL,
	[ACCTNUM] [char](14) NULL,
	[INSVCDT] [datetime] NULL,
	[ASSETID] [char](8) NULL,
	[LIFE] [smallint] NULL,
	[MANAGER] [char](20) NULL,
	[JOBCOST] [char](1) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[PCTGCOMP] [smallint] NULL,
	[RMPROPID] [char](6) NULL,
	[RMBLDGID] [char](3) NULL,
	[RMUNIT] [char](6) NULL,
	[RMSQFEET] [int] NULL,
	[COMMENT] [text] NULL,
	[SUITID] [char](5) NULL,
 CONSTRAINT [PK_GJOB_2] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [CNProp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNProp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [nchar](7) NOT NULL,
	[DESCRPTN] [nchar](30) NULL,
	[JOBTYPE] [nchar](1) NOT NULL,
	[JOBBUDGT] [money] NULL,
	[JOBSRTDT] [datetime] NULL,
	[JIMPCDT] [datetime] NULL,
	[JINACTDT] [datetime] NULL,
	[JACTIVE] [nchar](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[SQFEET] [int] NULL,
	[BLDGID] [nchar](6) NULL,
	[LEASID] [nchar](6) NULL,
	[REVENH] [nchar](1) NOT NULL,
	[CAPRECUR] [nchar](1) NOT NULL,
	[PROJAMT] [money] NULL,
	[CHNGAMT] [money] NULL,
	[ESCYRS] [smallint] NULL,
	[ACCTNUM] [nchar](12) NULL,
	[INSVCDT] [datetime] NULL,
	[ASSETID] [nchar](8) NULL,
	[LIFE] [smallint] NULL,
	[MANAGER] [nchar](20) NULL,
	[JOBCOST] [nchar](1) NULL,
	[JC_COSTLIST] [nchar](3) NULL,
	[PCTGCOMP] [smallint] NULL,
	[RMPROPID] [nchar](6) NULL,
	[RMBLDGID] [nchar](3) NULL,
	[RMUNIT] [nchar](6) NULL,
	[RMSQFEET] [int] NULL,
	[COMMENT] [ntext] NULL,
	[SUITID] [nchar](5) NULL,
 CONSTRAINT [UPKCL_GJOB] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [EUCorp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUCorp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [char](7) NOT NULL,
	[DESCRPTN] [char](50) NULL,
	[JOBTYPE] [char](1) NOT NULL,
	[JOBBUDGT] [money] NULL,
	[JOBSRTDT] [datetime] NULL,
	[JIMPCDT] [datetime] NULL,
	[JINACTDT] [datetime] NULL,
	[JACTIVE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[SQFEET] [int] NULL,
	[BLDGID] [char](6) NULL,
	[LEASID] [char](6) NULL,
	[REVENH] [char](1) NOT NULL,
	[CAPRECUR] [char](1) NOT NULL,
	[PROJAMT] [money] NULL,
	[CHNGAMT] [money] NULL,
	[ESCYRS] [smallint] NULL,
	[ACCTNUM] [char](12) NULL,
	[INSVCDT] [datetime] NULL,
	[ASSETID] [char](8) NULL,
	[LIFE] [smallint] NULL,
	[MANAGER] [char](20) NULL,
	[JOBCOST] [char](1) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[PCTGCOMP] [smallint] NULL,
	[RMPROPID] [char](6) NULL,
	[RMBLDGID] [char](3) NULL,
	[RMUNIT] [char](6) NULL,
	[RMSQFEET] [int] NULL,
	[COMMENT] [text] NULL,
	[SUITID] [char](5) NULL,
 CONSTRAINT [PK_GJOB] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [BRCorp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRCorp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [char](13) NOT NULL,
	[DESCRPTN] [char](30) NULL,
	[JOBTYPE] [char](1) NOT NULL,
	[JACTIVE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
 CONSTRAINT [UPKCL_GJOB] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USProp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USProp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [char](15) NOT NULL,
	[DESCRPTN] [char](35) NULL,
	[JOBTYPE] [char](1) NOT NULL,
	[JOBBUDGT] [money] NULL,
	[JOBSRTDT] [datetime] NULL,
	[JIMPCDT] [datetime] NULL,
	[JINACTDT] [datetime] NULL,
	[JACTIVE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[SQFEET] [int] NULL,
	[BLDGID] [char](6) NULL,
	[LEASID] [char](6) NULL,
	[REVENH] [char](1) NOT NULL,
	[CAPRECUR] [char](1) NOT NULL,
	[PROJAMT] [money] NULL,
	[CHNGAMT] [money] NULL,
	[ESCYRS] [smallint] NULL,
	[ACCTNUM] [char](14) NULL,
	[INSVCDT] [datetime] NULL,
	[ASSETID] [char](8) NULL,
	[LIFE] [smallint] NULL,
	[MANAGER] [char](20) NULL,
	[JOBCOST] [char](1) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[PCTGCOMP] [smallint] NULL,
	[RMPROPID] [char](6) NULL,
	[RMBLDGID] [char](3) NULL,
	[RMUNIT] [char](6) NULL,
	[RMSQFEET] [int] NULL,
	[RPTDESCRIP] [char](35) NULL,
	[RPTCATEGORY] [char](35) NULL,
	[SQFTTYP] [char](3) NULL,
	[MOCCPID] [char](8) NULL,
	[DESCRPTN2] [char](15) NOT NULL,
	[ADDLFEE] [money] NULL,
	[CSTARTDATE] [datetime] NULL,
	[CENDDATE] [datetime] NULL,
	[LEASINSERVICE] [char](1) NOT NULL,
	[FFEINSERVICE] [char](1) NOT NULL,
	[SUPFEEELIG] [char](1) NULL,
	[TENANTCENDDATE] [datetime] NULL,
	[SUITID] [char](5) NULL,
	[TENANTCSTARTDATE] [datetime] NULL,
	[TS_ASSUMP] [char](1) NULL,
	[LEASEEXECDATE] [datetime] NULL,
	[TEMP] [char](1) NULL,
	[COMMENT] [text] NULL,
	[COMMENT2] [text] NULL,
	[EXCLAUTOAP] [char](1) NULL,
 CONSTRAINT [UPKCL_GJOB] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [CNCorp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNCorp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [nchar](7) NOT NULL,
	[DESCRPTN] [nchar](50) NULL,
	[JOBTYPE] [nchar](1) NOT NULL,
	[JOBBUDGT] [money] NULL,
	[JOBSRTDT] [datetime] NULL,
	[JIMPCDT] [datetime] NULL,
	[JINACTDT] [datetime] NULL,
	[JACTIVE] [nchar](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[SQFEET] [int] NULL,
	[BLDGID] [nchar](6) NULL,
	[LEASID] [nchar](6) NULL,
	[REVENH] [nchar](1) NOT NULL,
	[CAPRECUR] [nchar](1) NOT NULL,
	[PROJAMT] [money] NULL,
	[CHNGAMT] [money] NULL,
	[ESCYRS] [smallint] NULL,
	[ACCTNUM] [nchar](12) NULL,
	[INSVCDT] [datetime] NULL,
	[ASSETID] [nchar](8) NULL,
	[LIFE] [smallint] NULL,
	[MANAGER] [nchar](20) NULL,
	[JOBCOST] [nchar](1) NULL,
	[JC_COSTLIST] [nchar](3) NULL,
	[PCTGCOMP] [smallint] NULL,
	[RMPROPID] [nchar](6) NULL,
	[RMBLDGID] [nchar](3) NULL,
	[RMUNIT] [nchar](6) NULL,
	[RMSQFEET] [int] NULL,
	[COMMENT] [ntext] NULL,
	[SUITID] [nchar](5) NULL,
 CONSTRAINT [UPKCL_GJOB] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [INCorp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INCorp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [char](13) NOT NULL,
	[DESCRPTN] [char](30) NULL,
	[JOBTYPE] [char](1) NOT NULL,
	[JACTIVE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
 CONSTRAINT [UPKCL_GJOB] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [EUProp].[GJOB]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUProp].[GJOB](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JOBCODE] [char](15) NOT NULL,
	[DESCRPTN] [char](50) NULL,
	[JOBTYPE] [char](1) NOT NULL,
	[JOBBUDGT] [money] NULL,
	[JOBSRTDT] [datetime] NULL,
	[JIMPCDT] [datetime] NULL,
	[JINACTDT] [datetime] NULL,
	[JACTIVE] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[SQFEET] [int] NULL,
	[BLDGID] [char](6) NULL,
	[LEASID] [char](6) NULL,
	[REVENH] [char](1) NOT NULL,
	[CAPRECUR] [char](1) NOT NULL,
	[PROJAMT] [money] NULL,
	[CHNGAMT] [money] NULL,
	[ESCYRS] [smallint] NULL,
	[ACCTNUM] [char](12) NULL,
	[INSVCDT] [datetime] NULL,
	[ASSETID] [char](8) NULL,
	[LIFE] [smallint] NULL,
	[MANAGER] [char](20) NULL,
	[JOBCOST] [char](1) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[PCTGCOMP] [smallint] NULL,
	[RMPROPID] [char](6) NULL,
	[RMBLDGID] [char](3) NULL,
	[RMUNIT] [char](6) NULL,
	[RMSQFEET] [int] NULL,
	[COMMENT] [text] NULL,
	[DESCRPTN2] [char](50) NULL,
	[MOCCPID] [char](8) NULL,
	[SQFTTYP] [char](3) NULL,
	[COMMENT2] [text] NULL,
	[SUITID] [char](5) NULL,
 CONSTRAINT [PK_GJOB_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[GlAccountMapping]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[GlAccountMapping](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GlAccountMappingId] [int] NOT NULL,
	[GlobalGlAccountId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[GlAccountCode] [char](14) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_GlAccountMapping] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[GlobalAllocationRegionMapping]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[GlobalAllocationRegionMapping](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GlobalAllocationRegionMappingId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[GlobalProjectRegionId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_GlobalAllocationRegionMapping] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[GlobalGlAccount]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[GlobalGlAccount](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GlobalGlAccountId] [int] NOT NULL,
	[ActivityTypeId] [int] NULL,
	[GlAccountCode] [char](12) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[AccountType] [varchar](50) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_GlAccount] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[GlobalGlAccountCategoryHierarchy]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[GlobalGlAccountCategoryHierarchy](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GlobalGlAccountCategoryHierarchyId] [int] NOT NULL,
	[GlobalGlAccountCategoryHierarchyGroupId] [int] NOT NULL,
	[GlobalGlAccountId] [int] NOT NULL,
	[MajorGlAccountCategoryId] [int] NOT NULL,
	[MinorGlAccountCategoryId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[AccountType] [varchar](50) NOT NULL,
	[ExpenseType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GlobalGlAccountHieranchy] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[GlobalGlAccountCategoryHierarchyGroup]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[GlobalGlAccountCategoryHierarchyGroup](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GlobalGlAccountCategoryHierarchyGroupId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_GlobalGlAccountHieranchyGroup] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[GlobalRegion]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[GlobalRegion](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[RegionCode] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[ParentGlobalRegionId] [int] NULL,
	[IsAllocationRegion] [bit] NOT NULL,
	[IsOriginatingRegion] [bit] NOT NULL,
 CONSTRAINT [PK_GlobalRegion] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [BudgetingCorp].[GlobalReportingCorporateBudget]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BudgetingCorp].[GlobalReportingCorporateBudget](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[SourceUniqueKey] [varchar](280) NOT NULL,
	[BudgetId] [int] NOT NULL,
	[SourceCode] [varchar](2) NOT NULL,
	[BudgetYear] [varchar](6) NOT NULL,
	[BudgetPeriodCode] [varchar](2) NOT NULL,
	[LockedDate] [datetime] NULL,
	[Period] [int] NOT NULL,
	[InternationalCurrencyCode] [varchar](3) NOT NULL,
	[LocalAmount] [decimal](37, 14) NULL,
	[GlobalGlAccountCode] [bigint] NOT NULL,
	[FunctionalDepartment] [varchar](50) NOT NULL,
	[FunctionalDepartmentGlobalCode] [varchar](3) NULL,
	[OriginatingSubRegion] [varchar](50) NOT NULL,
	[OriginatingSubRegionCode] [varchar](10) NULL,
	[OriginatingRegion] [varchar](50) NOT NULL,
	[OriginatingRegionCode] [varchar](10) NOT NULL,
	[NonPayrollCorporateMRIDepartmentCode] varchar(10) NULL,
	[AllocationSubRegion] [varchar](50) NOT NULL,
	[AllocationSubRegionProjectRegionId] [varchar](50) NOT NULL,
	[AllocationRegion] [varchar](50) NOT NULL,
	[AllocationRegionGlobalRegionId] [varchar](50) NOT NULL,
	[IsReimbursable] [bit] NOT NULL,
	[JobCode] [varchar](20) NULL,
 CONSTRAINT [PK_GlobalReportingCorporateBudget] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[GRBudgetReportGroupPeriodId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Period] [int] NOT NULL,
	[BudgetReportGroupId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_GRBudgetReportGroupPeriod] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [GACS].[JobCode]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [GACS].[JobCode](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[JobCode] [varchar](15) NOT NULL,
	[Source] [char](2) NOT NULL,
	[JobType] [varchar](15) NOT NULL,
	[BuildingRef] [varchar](6) NULL,
	[LastDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Reference] [varchar](50) NOT NULL,
	[MRIUserID] [char](20) NOT NULL,
	[Description] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[AccountingComment] [varchar](5000) NULL,
	[PMComment] [varchar](5000) NULL,
	[LeaseRef] [varchar](20) NULL,
	[Area] [int] NULL,
	[AreaType] [varchar](20) NULL,
	[RMPropertyRef] [varchar](6) NULL,
	[IsAssumption] [bit] NOT NULL,
	[FunctionalDepartmentId] [int] NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_JobCode] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [USCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USCorp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](6) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](13) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[OEXCHGREF] [char](8) NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[REVREF] [char](6) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[REVITEM] [smallint] NULL,
	[OWNERTAX] [char](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[CATEGORY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [float] NULL,
	[BRSTATUS] [char](1) NULL,
	[IMPORT] [char](10) NULL,
 CONSTRAINT [PK_JOURNAL_2] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [USProp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [USProp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](8) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](15) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[OEXCHGREF] [char](8) NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[REVREF] [char](8) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[REVITEM] [smallint] NULL,
	[OWNERTAX] [char](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[CATEGORY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [float] NULL,
	[BRSTATUS] [char](1) NULL,
	[DB] [char](2) NULL,
	[GDEP] [int] NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [PK_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [BRProp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRProp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](8) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](15) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[INTENTENTRY] [char](1) NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[OCURRCODE] [char](3) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [UPKCL_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INProp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INProp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](8) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](15) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[INTENTENTRY] [char](1) NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[OCURRCODE] [char](3) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [UPKCL_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [INCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [INCorp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](6) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](13) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[INTENTENTRY] [char](1) NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
 CONSTRAINT [UPKCL_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [CNCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNCorp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [nchar](6) NOT NULL,
	[REF] [nchar](6) NOT NULL,
	[SOURCE] [nchar](2) NOT NULL,
	[SITEID] [nchar](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [nchar](6) NOT NULL,
	[ACCTNUM] [nchar](12) NOT NULL,
	[DEPARTMENT] [nchar](6) NOT NULL,
	[JOBCODE] [nchar](7) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [nchar](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [nchar](1) NOT NULL,
	[STATUS] [nchar](1) NOT NULL,
	[OEXCHGREF] [nchar](8) NULL,
	[BASIS] [nchar](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[OCURRCODE] [nchar](3) NULL,
	[OAMT] [money] NULL,
	[REVREF] [nchar](6) NULL,
	[INTENTENTRY] [nchar](1) NULL,
	[INTENTTYPE] [nchar](3) NULL,
	[CJEGRPID] [nchar](5) NULL,
	[CJEID] [nchar](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [nchar](1) NULL,
	[REVENTRY] [nchar](1) NULL,
	[REVPRD] [nchar](6) NULL,
	[REVITEM] [smallint] NULL,
	[OWNERTAX] [nchar](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [nchar](5) NULL,
	[JC_COSTLIST] [nchar](3) NULL,
	[JC_COSTCODE] [nchar](6) NULL,
	[CATEGORY] [nchar](1) NULL,
	[PROJID] [nchar](6) NULL,
	[OWNTBL] [nchar](20) NULL,
	[OWNYEAR] [nchar](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [nchar](20) NULL,
	[CTRYYEAR] [nchar](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [nchar](1) NULL,
	[ADDLDESC] [ntext] NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [nchar](20) NULL,
	[LOANSTAT] [nchar](1) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [UPKCL_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [CNProp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [CNProp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [nchar](6) NOT NULL,
	[REF] [nchar](6) NOT NULL,
	[SOURCE] [nchar](2) NOT NULL,
	[SITEID] [nchar](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [nchar](7) NOT NULL,
	[ACCTNUM] [nchar](12) NOT NULL,
	[DEPARTMENT] [nchar](6) NOT NULL,
	[JOBCODE] [nchar](7) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [nchar](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [nchar](1) NOT NULL,
	[STATUS] [nchar](1) NOT NULL,
	[OEXCHGREF] [nchar](8) NULL,
	[BASIS] [nchar](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [nchar](20) NULL,
	[OCURRCODE] [nchar](3) NULL,
	[OAMT] [money] NULL,
	[REVREF] [nchar](6) NULL,
	[INTENTENTRY] [nchar](1) NULL,
	[INTENTTYPE] [nchar](3) NULL,
	[CJEGRPID] [nchar](5) NULL,
	[CJEID] [nchar](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [nchar](1) NULL,
	[REVENTRY] [nchar](1) NULL,
	[REVPRD] [nchar](6) NULL,
	[REVITEM] [smallint] NULL,
	[OWNERTAX] [nchar](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [nchar](5) NULL,
	[JC_COSTLIST] [nchar](3) NULL,
	[JC_COSTCODE] [nchar](6) NULL,
	[CATEGORY] [nchar](1) NULL,
	[PROJID] [nchar](6) NULL,
	[OWNTBL] [nchar](20) NULL,
	[OWNYEAR] [nchar](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [nchar](20) NULL,
	[CTRYYEAR] [nchar](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [nchar](1) NULL,
	[ADDLDESC] [ntext] NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [nchar](20) NULL,
	[LOANSTAT] [nchar](1) NULL,
	[CDEP] [nchar](6) NULL,
 CONSTRAINT [UPKCL_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [BRCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [BRCorp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](6) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](14) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](13) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[INTENTENTRY] [char](1) NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
 CONSTRAINT [UPKCL_JOURNAL] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [EUProp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUProp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](8) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](12) NOT NULL,
	[DEPARTMENT] [char](12) NOT NULL,
	[JOBCODE] [char](15) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[OEXCHGREF] [char](8) NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[REVREF] [char](8) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[REVITEM] [smallint] NULL,
	[STATFLAG] [char](1) NULL,
	[INVREF] [char](20) NULL,
	[CONV] [char](1) NULL,
	[ACCTDONE] [char](1) NULL,
	[OLDACCT] [char](12) NULL,
	[TSPREF] [char](8) NULL,
	[PAGINIER] [char](15) NULL,
	[ALLOCODE] [char](3) NULL,
	[VENDNAME] [char](35) NULL,
	[ADDLDESC] [text] NULL,
	[OWNERTAX] [char](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[FROMSCDT] [datetime] NULL,
	[TOSCDATE] [datetime] NULL,
	[CATEGORY] [char](1) NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [char](1) NULL,
	[SCDATE] [datetime] NULL,
	[JRNLTYPE] [char](3) NULL,
	[PARENTITEM] [float] NULL,
	[APREF] [char](30) NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [char](20) NULL,
	[LOANSTAT] [char](1) NULL,
	[CDEP] [char](6) NULL,
 CONSTRAINT [PK_JOURNAL_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [EUCorp].[JOURNAL]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [EUCorp].[JOURNAL](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PERIOD] [char](6) NOT NULL,
	[REF] [char](6) NOT NULL,
	[SOURCE] [char](2) NOT NULL,
	[SITEID] [char](2) NOT NULL,
	[ITEM] [smallint] NOT NULL,
	[ENTITYID] [char](6) NOT NULL,
	[ACCTNUM] [char](12) NOT NULL,
	[DEPARTMENT] [char](6) NOT NULL,
	[JOBCODE] [char](7) NULL,
	[AMT] [money] NULL,
	[DESCRPN] [char](60) NULL,
	[ENTRDATE] [datetime] NULL,
	[REVERSAL] [char](1) NOT NULL,
	[STATUS] [char](1) NOT NULL,
	[OEXCHGREF] [char](8) NULL,
	[BASIS] [char](1) NOT NULL,
	[LASTDATE] [datetime] NULL,
	[USERID] [char](20) NULL,
	[OCURRCODE] [char](3) NULL,
	[OAMT] [money] NULL,
	[REVREF] [char](6) NULL,
	[INTENTENTRY] [char](1) NULL,
	[INTENTTYPE] [char](3) NULL,
	[CJEGRPID] [char](5) NULL,
	[CJEID] [char](8) NULL,
	[DESTITEM] [int] NULL,
	[AUDITFLAG] [char](1) NULL,
	[REVENTRY] [char](1) NULL,
	[REVPRD] [char](6) NULL,
	[REVITEM] [smallint] NULL,
	[OWNERTAX] [char](1) NULL,
	[OWNPCTCALC] [datetime] NULL,
	[JC_PHASECODE] [char](5) NULL,
	[JC_COSTLIST] [char](3) NULL,
	[JC_COSTCODE] [char](6) NULL,
	[CATEGORY] [char](1) NULL,
	[ADDLDESC] [text] NULL,
	[OWNTBL] [char](20) NULL,
	[OWNYEAR] [char](4) NULL,
	[OWNNUM] [float] NULL,
	[CTRYTBL] [char](20) NULL,
	[CTRYYEAR] [char](4) NULL,
	[CTRYNUM] [float] NULL,
	[BANKRECID] [int] NULL,
	[BRSTATUS] [char](1) NULL,
	[PROJID] [char](6) NULL,
	[INTERFACEID] [float] NULL,
	[INTFMARKER] [char](20) NULL,
	[LOANSTAT] [char](1) NULL,
 CONSTRAINT [PK_JOURNAL_3] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [HR].[Location]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [HR].[Location](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL,
	[StateId] [int] NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[MajorGlAccountCategory]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[MajorGlAccountCategory](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[MajorGlAccountCategoryId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_MajorAccountCategory] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[MinorGlAccountCategory]    Script Date: 12/18/2009 16:07:55 ******/

CREATE TABLE [Gdm].[MinorGlAccountCategory](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[MinorGlAccountCategoryId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_MinorAccountCategory] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[OriginatingRegionMapping]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[OriginatingRegionMapping](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[OriginatingRegionMappingId] [int] NOT NULL,
	[GlobalRegionId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[RegionCode] [varchar](10) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_OriginatingRegionMapping] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[Overhead]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[Overhead](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[OverheadId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[ExpensePeriod] [int] NOT NULL,
	[AllocationStartPeriod] [int] NOT NULL,
	[AllocationEndPeriod] [int] NULL,
	[Description] [nvarchar](60) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[InsertedByStaffId] [int] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[InvoiceNumber] [varchar](13) NULL,
 CONSTRAINT [PK_Overhead] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[OverheadRegion]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[OverheadRegion](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[OverheadRegionId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[CorporateEntityRef] [varchar](6) NULL,
	[CorporateSourceCode] [varchar](2) NULL,
	[Name] [varchar](50) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_OverheadRegion] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[PayrollRegion]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[PayrollRegion](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[PayrollRegionId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL,
	[CorporateEntityRef] [varchar](6) NOT NULL,
	[CorporateSourceCode] [varchar](2) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_PayrollRegion] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[Project]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[Project](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[ActivityTypeId] [int] NOT NULL,
	[ProjectOwnerId] [int] NULL,
	[CorporateDepartmentCode] [varchar](8) NOT NULL,
	[CorporateSourceCode] [char](2) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[StartPeriod] [int] NOT NULL,
	[EndPeriod] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[PropertyOverheadGLAccountCode] [varchar](15) NULL,
	[PropertyOverheadDepartmentCode] [varchar](6) NULL,
	[PropertyOverheadJobCode] [varchar](15) NULL,
	[PropertyOverheadSourceCode] [char](2) NULL,
	[CorporateUnionPayrollIncomeCategoryCode] [varchar](6) NULL,
	[CorporateNonUnionPayrollIncomeCategoryCode] [varchar](6) NULL,
	[CorporateOverheadIncomeCategoryCode] [varchar](6) NULL,
	[PropertyFundId] [int] NOT NULL,
	[MarkUpPercentage] [decimal](5, 4) NULL,
	[HistoricalProjectCode] [varchar](50) NULL,
	[IsTSCost] [bit] NOT NULL,
	[CanAllocateOverheads] [bit] NOT NULL,
	[AllocateOverheadsProjectId] [int] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[ProjectRegion]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[ProjectRegion](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ProjectRegionId] [int] NOT NULL,
	[GlobalProjectRegionId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Code] [varchar](6) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ProjectRegion] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[ProjectType]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[ProjectType](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ProjectTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ProjectType] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[PropertyFund]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[PropertyFund](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[RelatedFundId] [int] NOT NULL,
	[ProjectRegionId] [int] NOT NULL,
	[ProjectTypeId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_GlobalProperty] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [Gdm].[PropertyFundMapping]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [Gdm].[PropertyFundMapping](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PropertyFundMappingId] [int] NOT NULL,
	[PropertyFundId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[PropertyFundCode] [varchar](8) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_PropertyFundMapping_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[ReforecastActualBilledPayroll]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[ReforecastActualBilledPayroll](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[ReforecastActualBilledPayrollId] [int] NOT NULL,
	[BudgetId] [int] NOT NULL,
	[HrEmployeeId] [int] NOT NULL,
	[CostTypeId] [int] NOT NULL,
	[ExpenseTypeId] [int] NULL,
	[BudgetTaxTypeId] [int] NULL,
	[ProjectId] [int] NOT NULL,
	[PayGroupId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ExternalRegionId] [int] NOT NULL,
	[ExternalSubRegionId] [int] NOT NULL,
	[SubDepartmentId] [int] NOT NULL,
	[ExpensePeriod] [int] NOT NULL,
	[AllocationAmount] [decimal](18, 9) NOT NULL,
	[AllocationPercentage] [decimal](18, 9) NOT NULL,
	[IsUnion] [bit] NOT NULL,
	[IsReimbursable] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[BenefitOptionId] [int] NULL,
	[IsAdjustment] [bit] NOT NULL,
	[FunctionalDepartmentId] [int] NOT NULL,
	[ActivityTypeId] [int] NULL,
	[OverheadRegionId] [int] NULL,
 CONSTRAINT [PK_ReforecastActualBilledPayroll] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [HR].[Region]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [HR].[Region](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[RegionId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[PayCode] [varchar](5) NULL,
	[EnrollmentTypeId] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[RegionExtended]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[RegionExtended](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[RegionId] [int] NOT NULL,
	[RegionalAdministratorId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[HasEmployees] [bit] NOT NULL,
	[CanChargeMarkupOnProject] [bit] NOT NULL,
	[CanChargeMarkupOnPayrollOverhead] [bit] NOT NULL,
	[CanUploadOverheadJournal] [bit] NOT NULL,
	[ProjectRef] [varchar](8) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[OverheadFunctionalDepartmentId] [int] NOT NULL,
	[CanRegionBillInArrears] [bit] NOT NULL,
 CONSTRAINT [PK_RegionExtended] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[SystemSetting]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[SystemSetting](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[SystemSettingId] [int] NULL,
	[SystemSettingTypeId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Value] [varchar](50) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SystemSetting] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobal].[SystemSettingRegion]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobal].[SystemSettingRegion](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[SystemSettingRegionId] [int] NOT NULL,
	[SystemSettingId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[BankLetterAddress] [text] NULL,
	[CorporatePayrollCreditDepartmentCode] [varchar](8) NULL,
	[CorporatePayrollCreditEntityRef] [varchar](6) NULL,
	[CorporateOverheadCreditGLAccountCode] [varchar](15) NULL,
	[CorporateOverheadDebitGLAccountCode] [varchar](15) NULL,
	[CorporateOverheadCreditDepartmentCode] [varchar](8) NULL,
	[CorporateOverheadCreditEntityRef] [varchar](6) NULL,
	[CorporateMarkUpCreditGLAccountCode] [varchar](15) NULL,
	[CorporateMarkUpDebitGLAccountCode] [varchar](15) NULL,
	[CorporateMarkUpCreditDepartmentCode] [varchar](8) NULL,
	[CorporateMarkUpCreditEntityRef] [varchar](6) NULL,
	[CorporateMarkUpDebitEntityRef] [varchar](6) NULL,
	[CorporateOverheadClearingEntityRef] [varchar](6) NULL,
	[CorporatePayrollClearingEntityRef] [varchar](6) NULL,
	[PropertyMarkUpGLaccountCode] [varchar](15) NULL,
	[PropertyVendorCode] [varchar](15) NULL,
	[BudgetAllocationBudgetId] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[BonusCapExcessProjectId] [int] NULL,
 CONSTRAINT [PK_SystemSettingRegion] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Table [TapasGlobalBudgeting].[TaxType]    Script Date: 12/18/2009 16:07:55 ******/
CREATE TABLE [TapasGlobalBudgeting].[TaxType](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[TaxTypeId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
	[FixedTaxTypeId] [int] NOT NULL,
	[RateCalculationMethodId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	[MinorGlAccountCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_TaxType] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- Add constraints

ALTER TABLE [Gdm].[ActivityType] ADD  CONSTRAINT [DF_ActivityType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[AllocationRegionMapping] ADD  CONSTRAINT [DF_AllocationRegionMapping_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BenefitOption] ADD  CONSTRAINT [DF_BenefitOption_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[BillingUpload] ADD  CONSTRAINT [DF_BillingUpload_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[BillingUploadDetail] ADD  CONSTRAINT [DF_BillingUploadDetail_ImpoertDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[Budget] ADD  CONSTRAINT [DF_Budget_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployee] ADD  CONSTRAINT [DF_BudgetEmployee_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] ADD  CONSTRAINT [DF_BudgetEmployeeFunctionalDepartment_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] ADD  CONSTRAINT [DF_BudgetEmployeePayrollAllocation_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] ADD  CONSTRAINT [DF_BudgetEmployeePayrollAllocationDetail_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocation] ADD  CONSTRAINT [DF_BudgetOverheadAllocation_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] ADD  CONSTRAINT [DF_BudgetOverheadAllocationDetail_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetProject] ADD  CONSTRAINT [DF_BudgetProject_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetReportGroup] ADD  CONSTRAINT [DF_BudgetReportGroup_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetReportGroupDetail] ADD  CONSTRAINT [DF_BudgetReportGroupDetail_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetStatus] ADD  CONSTRAINT [DF_BudgetStatus_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[BudgetTaxType] ADD  CONSTRAINT [DF_BudgetTaxType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [GACS].[Department] ADD  CONSTRAINT [DF_Department_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INProp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INCorp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUCorp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUProp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNProp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRProp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USCorp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRCorp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNCorp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USProp].[ENTITY] ADD  CONSTRAINT [DF_ENTITY_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[ExchangeRate] ADD  CONSTRAINT [DF_ExchangeRate_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[ExchangeRate] ADD  CONSTRAINT [DF_ExchangeRate_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[ExchangeRate] ADD  CONSTRAINT [DF_ExchangeRate_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[ExchangeRateDetail] ADD  CONSTRAINT [DF_ExchangeRateDetail_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[ExchangeRateDetail] ADD  CONSTRAINT [DF_ExchangeRateDetail_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[ExchangeRateDetail] ADD  CONSTRAINT [DF_ExchangeRateDetail_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

ALTER TABLE [HR].[FunctionalDepartment] ADD  CONSTRAINT [DF_FunctionalDepartment_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USProp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRCorp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNProp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUCorp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INCorp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRProp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNCorp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUProp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INProp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USCorp].[GACC] ADD  CONSTRAINT [DF_GACC_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USCorp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INProp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRProp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRCorp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INCorp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNCorp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USProp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUProp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUCorp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNProp].[GDEP] ADD  CONSTRAINT [DF_GDEP_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USCorp].[GHIS] ADD  CONSTRAINT [DF_GHIS_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USProp].[GHIS] ADD  CONSTRAINT [DF_GHIS_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUProp].[GHIS] ADD  CONSTRAINT [DF_GHIS_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNProp].[GHIS] ADD  CONSTRAINT [DF_GHIS_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUCorp].[GHIS] ADD  CONSTRAINT [DF_GHIS_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNCorp].[GHIS] ADD  CONSTRAINT [DF_GHIS_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USCorp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNProp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUCorp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRCorp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USProp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNCorp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INCorp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUProp].[GJOB] ADD  CONSTRAINT [DF_GJOB_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlAccountMapping] ADD  CONSTRAINT [DF_GlAccountMapping_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlAccountMapping] ADD  CONSTRAINT [DF_GlAccountMapping_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

ALTER TABLE [Gdm].[GlAccountMapping] ADD  CONSTRAINT [DF_GlAccountMapping_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [Gdm].[GlobalAllocationRegionMapping] ADD  CONSTRAINT [DF_GlobalAllocationRegionMapping_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlobalGlAccount] ADD  CONSTRAINT [DF_GlobalGlAccount_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlobalGlAccount] ADD  CONSTRAINT [DF_GlobalGlAccount_AccountType]  DEFAULT ('UNKNOWN') FOR [AccountType]
GO

ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchy] ADD  CONSTRAINT [DF_GlobalGlAccountCategoryHieranchy_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchy] ADD  CONSTRAINT [DF_GlobalGlAccountCategoryHieranchy_AccountType]  DEFAULT ('') FOR [AccountType]
GO

ALTER TABLE [Gdm].[GlobalGlAccountCategoryHierarchyGroup] ADD  CONSTRAINT [DF_GlobalGlAccountCategoryHieranchyGroup_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlobalRegion] ADD  CONSTRAINT [DF_GlobalRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[GlobalRegion] ADD  CONSTRAINT [DF_GlobalRegion_IsAllocationRegion]  DEFAULT ((0)) FOR [IsAllocationRegion]
GO

ALTER TABLE [Gdm].[GlobalRegion] ADD  CONSTRAINT [DF_GlobalRegion_IsOriginatingRegion]  DEFAULT ((0)) FOR [IsOriginatingRegion]
GO

ALTER TABLE [BudgetingCorp].[GlobalReportingCorporateBudget] ADD  CONSTRAINT [DF_GlobalReportingCorporateBudget_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] ADD  CONSTRAINT [DF_GRBudgetReportGroupPeriod_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] ADD  CONSTRAINT [DF_GRBudgetReportGroupPeriod_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] ADD  CONSTRAINT [DF_GRBudgetReportGroupPeriod_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

ALTER TABLE [GACS].[JobCode] ADD  CONSTRAINT [DF_JobCode_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USCorp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [USProp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRProp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INProp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [INCorp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNCorp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [CNProp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [BRCorp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUProp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [EUCorp].[JOURNAL] ADD  CONSTRAINT [DF_JOURNAL_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [HR].[Location] ADD  CONSTRAINT [DF_Location_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[MajorGlAccountCategory] ADD  CONSTRAINT [DF_MajorGlAccountCategory_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[MinorGlAccountCategory] ADD  CONSTRAINT [DF_MinorGlAccountCategory_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[OriginatingRegionMapping] ADD  CONSTRAINT [DF_OriginatingRegionMapping_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[Overhead] ADD  CONSTRAINT [DF_Overhead_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[OverheadRegion] ADD  CONSTRAINT [DF_OverheadRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[Project] ADD  CONSTRAINT [DF_Project_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[ProjectRegion] ADD  CONSTRAINT [DF_ProjectRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[ProjectType] ADD  CONSTRAINT [DF_ProjectType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[PropertyFund] ADD  CONSTRAINT [DF_PropertyFund_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[PropertyFund] ADD  CONSTRAINT [DF_PropertyFund_ProjectTypeId]  DEFAULT ((1)) FOR [ProjectTypeId]
GO

ALTER TABLE [Gdm].[PropertyFundMapping] ADD  CONSTRAINT [DF_PropertyFundMapping_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[PropertyFundMapping] ADD  CONSTRAINT [DF_PropertyFundMapping_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

ALTER TABLE [Gdm].[PropertyFundMapping] ADD  CONSTRAINT [DF_PropertyFundMapping_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [TapasGlobalBudgeting].[ReforecastActualBilledPayroll] ADD  CONSTRAINT [DF_ReforecastActualBilledPayroll_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [HR].[Region] ADD  CONSTRAINT [DF_Region_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[RegionExtended] ADD  CONSTRAINT [DF_RegionExtended_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[SystemSetting] ADD  CONSTRAINT [DF_SystemSetting_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobal].[SystemSettingRegion] ADD  CONSTRAINT [DF_SystemSettingRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [TapasGlobalBudgeting].[TaxType] ADD  CONSTRAINT [DF_TaxType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO


SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_PADDING OFF
GO