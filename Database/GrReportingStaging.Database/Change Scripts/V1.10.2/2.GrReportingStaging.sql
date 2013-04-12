

USE [GrReportingStaging]



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[TimeAllocation]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[TimeAllocation]


CREATE TABLE [TapasGlobal].[TimeAllocation](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL, 
[TimeAllocationId] [int] NOT NULL,
[Period] [int] NOT NULL,
[HREmployeeId] [int] NOT NULL,
[ApprovalStatusId] [int] NOT NULL,
[LockStatusId] [int] NOT NULL,
[ApprovedByStaffId] [int] NULL,
[ApprovedByStaffName] [varchar] (50) NULL,
[ApprovedDate] [datetime] NULL,
[SubmittedDate] [datetime] NULL,
[PreLockedDate] [datetime] NULL,
[LockedDate] [datetime] NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[IsUserModified] [bit] NOT NULL,
[SubmittedByStaffId] [int] NULL,
[SubmittedByStaffName] [varchar] (50) NULL,
[AllocationTypeId] [int] NOT NULL,
[IsTemporary] [bit] NOT NULL,
[UpdatedByStaffName] [varchar] (50) NOT NULL,
CONSTRAINT [PK_TimeAllocation] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[TimeAllocation] ADD  CONSTRAINT [DF_TimeAllocation_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO


USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[TimeAllocationDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[TimeAllocationDetail]


CREATE TABLE [TapasGlobal].[TimeAllocationDetail](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[TimeAllocationDetailId] [int] NOT NULL,
[TimeAllocationId] [int] NOT NULL,
[AllocationValueTypeId] [int] NOT NULL,
[ProjectId] [int] NULL,
[ProjectGroupId] [int] NULL,
[AllocationValue] [numeric] (18,9) NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_TimeAllocationDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[TimeAllocationDetail] ADD  CONSTRAINT [DF_TimeAllocationDetail_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO

USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[BillingUploadType]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[BillingUploadType]


CREATE TABLE [TapasGlobal].[BillingUploadType](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[BillingUploadTypeId] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL,
[Description] [varchar] (100) NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BillingUploadType] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[BillingUploadType] ADD  CONSTRAINT [DF_BillingUploadType_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO

USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[AllocationWeight]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[AllocationWeight]


CREATE TABLE [TapasGlobal].[AllocationWeight](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[AllocationWeightId] [int] NOT NULL,
[ProjectGroupAllocationId] [int] NOT NULL,
[ProjectId] [int] NOT NULL,
[Weight] [numeric] (18,9) NOT NULL,
[IsPropertyWeightAllocation] [bit] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_AllocationWeight] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[AllocationWeight] ADD  CONSTRAINT [DF_AllocationWeight_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO



USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectGroup]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[ProjectGroup]


CREATE TABLE [TapasGlobal].[ProjectGroup](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[ProjectGroupId] [int] NOT NULL,
[SourceCode] [char] (2) NOT NULL,
[Name] [varchar] (100) NOT NULL,
[EndPeriod] [int] NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[AMProjectGroupId] [int] NULL,
[IsFunctionalDepartmentIncluded] [bit] NULL,
 CONSTRAINT [PK_ProjectGroup] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[ProjectGroup] ADD  CONSTRAINT [DF_ProjectGroup_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO



USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[ProjectGroupAllocation]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[ProjectGroupAllocation]


CREATE TABLE [TapasGlobal].[ProjectGroupAllocation](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[ProjectGroupAllocationId] [int] NOT NULL,
[ProjectGroupId] [int] NOT NULL,
[EffectivePeriod] [int] NOT NULL,
[TotalPropertyWeight] [numeric] (18,9) NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[SnapshotNumber] [int] NULL,
 CONSTRAINT [PK_ProjectGroupAllocation] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[ProjectGroupAllocation] ADD  CONSTRAINT [DF_ProjectGroupAllocation_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO



USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[HREmployee]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[HREmployee]


CREATE TABLE [TapasGlobal].[HREmployee](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[HREmployeeId] [int] NOT NULL,
[HREmployeeNumber] [int] NOT NULL,
[EncryptedSSN] [varbinary] (32) NULL,
[StaffId] [int] NULL,
[EDEmployeeId] [int] NULL,
[IsTerminated] [bit] NOT NULL,
[IsEmployeeMappedToGacs] [bit] NOT NULL,
[IsEmployeeMappedToED] [bit] NOT NULL,
[DisplayName] [varchar] (255) NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[MappedByStaffId] [int] NOT NULL,
[NTLogin] [varchar] (255) NULL,
[Email] [varchar] (255) NULL,
[IsActive] [bit] NULL,
[IsTapasEmployee] [bit] NULL,
[EmployeeHistoryId] [int] NOT NULL,
[FileNumber] [int] NULL,
[PayGroupId] [int] NULL,
[LocationId] [int] NULL,
[SubDepartmentId] [int] NULL,
[ImportSubDepartmentId] [int] NULL,
[FunctionalDepartmentId] [int] NULL,
[UnionCodeId] [int] NULL,
[JobTitleId] [int] NULL,
[OverheadRegionId] [int] NULL,
[ImportOverHeadRegionId] [int] NULL,
[IsLatestInformation] [bit] NULL,
[EffectivePeriod] [int] NULL,
[EffectiveDate] [datetime] NULL,
[FirstName] [varchar] (100) NULL,
[LastName] [varchar] (100) NULL,
[Initials] [varchar] (50) NULL,
[BirthDate] [datetime] NULL,
[HirePeriod] [int] NULL,
[HireDate] [datetime] NULL,
[RehirePeriod] [int] NULL,
[RehireDate] [datetime] NULL,
[TerminatePeriod] [int] NULL,
[TerminateDate] [datetime] NULL,
[IsEmployed] [bit] NULL,
[ERSApproverStaffId] [int] NULL,
[ApproverStaffId] [int] NULL,
 CONSTRAINT [PK_HREmployee] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[HREmployee] ADD  CONSTRAINT [DF_HREmployee_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]



GO


USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobal].[EmployeeHistory]') AND type in (N'U'))
DROP TABLE [TapasGlobal].[EmployeeHistory]


CREATE TABLE [TapasGlobal].[EmployeeHistory](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[EmployeeHistoryId] [int] NOT NULL,
[HREmployeeId] [int] NOT NULL,
[FileNumber] [int] NOT NULL,
[PayGroupId] [int] NOT NULL,
[LocationId] [int] NOT NULL,
[SubDepartmentId] [int] NOT NULL,
[ImportSubDepartmentId] [int] NOT NULL,
[FunctionalDepartmentId] [int] NOT NULL,
[UnionCodeId] [int] NULL,
[JobTitleId] [int] NOT NULL,
[EncryptedSSN] [varbinary] (32) NOT NULL,
[OverheadRegionId] [int] NULL,
[ImportOverheadRegionId] [int] NULL,
[IsLatestInformation] [bit] NULL,
[EffectivePeriod] [int] NULL,
[EffectiveDate] [datetime] NOT NULL,
[EffectiveEndDate] [datetime] NOT NULL,
[FirstName] [varchar] (100) NOT NULL,
[LastName] [varchar] (100) NOT NULL,
[Initials] [varchar] (50) NULL,
[BirthDate] [datetime] NOT NULL,
[HirePeriod] [int] NULL,
[HireDate] [datetime] NOT NULL,
[RehirePeriod] [int] NULL,
[RehireDate] [datetime] NULL,
[TerminatePeriod] [int] NULL,
[TerminateDate] [datetime] NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[ERSApproverStaffId] [int] NULL,
[ApproverStaffId] [int] NULL,
[NTLogin] [varchar] (255) NULL,
[Email] [varchar] (255) NULL,
[IsActive] [bit] NULL,
 CONSTRAINT [PK_EmployeeHistory] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobal].[EmployeeHistory] ADD  CONSTRAINT [DF_EmployeeHistory_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

GO



USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetAllocation]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetAllocation]


CREATE TABLE [TapasGlobalBudgeting].[BudgetAllocation](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[BudgetAllocationId] [int] NOT NULL,
[BudgetEmployeeId] [int] NOT NULL,
[BudgetAllocationSetupId] [int] NULL,
[BudgetPeriod] [int] NOT NULL,
[IsEditable] [bit] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[OriginalBudgetAllocationId] [int] NULL,
 CONSTRAINT [PK_BudgetAllocation] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobalBudgeting].[BudgetAllocation] ADD  CONSTRAINT [DF_BudgetAllocation_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO





USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetAllocationDetail]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetAllocationDetail]


CREATE TABLE [TapasGlobalBudgeting].[BudgetAllocationDetail](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[BudgetAllocationDetailId] [int] NOT NULL,
[BudgetAllocationId] [int] NOT NULL,
[BudgetProjectId] [int] NULL,
[BudgetProjectGroupId] [int] NULL,
[AllocationValue] [numeric] (10,9) NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetAllocationDetail] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobalBudgeting].[BudgetAllocationDetail] ADD  CONSTRAINT [DF_BudgetAllocationDetail_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

GO





USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectGroup]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetProjectGroup]


CREATE TABLE [TapasGlobalBudgeting].[BudgetProjectGroup](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[BudgetProjectGroupId] [int] NOT NULL,
[ProjectGroupId] [int] NULL,
[BudgetId] [int] NOT NULL,
[Name] [varchar] (100) NULL,
[EndPeriod] [int] NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[OriginalBudgetProjectGroupId] [int] NULL,
[AMBudgetProjectGroupId] [int] NULL,
 CONSTRAINT [PK_BudgetProjectGroup] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobalBudgeting].[BudgetProjectGroup] ADD  CONSTRAINT [DF_BudgetProjectGroup_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

GO



USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetProjectGroupAllocation]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetProjectGroupAllocation]


CREATE TABLE [TapasGlobalBudgeting].[BudgetProjectGroupAllocation](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[BudgetProjectGroupAllocationId] [int] NOT NULL,
[BudgetProjectGroupId] [int] NOT NULL,
[EffectivePeriod] [int] NOT NULL,
[TotalPropertyWeight] [numeric] (18,9) NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
[OriginalBudgetProjectGroupAllocationId] [int] NULL,
 CONSTRAINT [PK_BudgetProjectGroupAllocation] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobalBudgeting].[BudgetProjectGroupAllocation] ADD  CONSTRAINT [DF_BudgetProjectGroupAllocation_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

GO



USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TapasGlobalBudgeting].[BudgetAllocationWeight]') AND type in (N'U'))
DROP TABLE [TapasGlobalBudgeting].[BudgetAllocationWeight]


CREATE TABLE [TapasGlobalBudgeting].[BudgetAllocationWeight](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[BudgetAllocationWeightId] [int] NOT NULL,
[BudgetProjectGroupAllocationId] [int] NOT NULL,
[BudgetProjectId] [int] NOT NULL,
[Weight] [numeric] (18,9) NOT NULL,
[IsPropertyWeightAllocation] [bit] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_BudgetAllocationWeight] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [TapasGlobalBudgeting].[BudgetAllocationWeight] ADD  CONSTRAINT [DF_BudgetAllocationWeight_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

GO



----delete the 3 tables in ErpHR if they exists
use [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ErpHR.ExternalSubRegion') AND type in (N'U'))
drop table ErpHR.ExternalSubRegion


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ErpHR.PayGroup') AND type in (N'U'))
drop table ErpHR.PayGroup

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ErpHR.SubDepartment') AND type in (N'U'))
drop table ErpHR.SubDepartment


----create tables
USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[PayGroup]') AND type in (N'U'))
DROP TABLE [HR].[PayGroup]


CREATE TABLE [HR].[PayGroup](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[PayGroupId] [int] NOT NULL,
[PayFrequencyId] [int] NOT NULL,
[RegionId] [int] NOT NULL,
[Code] [varchar] (50) NOT NULL,
[Name] [varchar] (50) NOT NULL,
[IsUnion] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[IsPartTime] [bit] NOT NULL,
[IsPayroll] [bit] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_PayGroup] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [HR].[PayGroup] ADD  CONSTRAINT [DF_PayGroup_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO


USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[ExternalSubRegion]') AND type in (N'U'))
DROP TABLE [HR].[ExternalSubRegion]


CREATE TABLE [HR].[ExternalSubRegion](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[ExternalSubRegionId] [int] NOT NULL,
[ExternalRegionId] [int] NOT NULL,
[Code] [varchar] (50) NOT NULL,
[Name] [varchar] (50) NOT NULL,
[IsActive] [bit] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_ExternalSubRegion] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [HR].[ExternalSubRegion] ADD  CONSTRAINT [DF_ExternalSubRegion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]



GO


USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[SubDepartment]') AND type in (N'U'))
DROP TABLE [HR].[SubDepartment]


CREATE TABLE [HR].[SubDepartment](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[SubDepartmentId] [int] NOT NULL,
[FunctionalDepartmentId] [int] NULL,
[Name] [varchar] (50) NOT NULL,
[Code] [varchar] (50) NOT NULL,
[IsActive] [bit] NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
 CONSTRAINT [PK_SubDepartment] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [HR].[SubDepartment] ADD  CONSTRAINT [DF_SubDepartment_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]


GO









USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[Staff]') AND type in (N'U'))
DROP TABLE [GACS].[Staff]


CREATE TABLE [GACS].[Staff](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[StaffID] [int] NOT NULL,
[NTLogin] [varchar] (255) NOT NULL,
[FirstName] [varchar] (255) NOT NULL,
[LastName] [varchar] (255) NOT NULL,
[DisplayName] [varchar] (255) NOT NULL,
[IsActive] [bit] NOT NULL,
[SDate] [datetime] NOT NULL,
[UDate] [datetime] NOT NULL,
[email] [varchar] (255) NULL,
[CountryID] [int] NULL,
[CityID] [int] NULL,
[IsDeveloper] [bit] NOT NULL,
[AllUSBuildingAccess] [bit] NOT NULL,
[AllEUBuildingAccess] [bit] NOT NULL,
[AllUSEntityAccess] [bit] NULL,
[AllEUEntityAccess] [bit] NULL,
[ProjectAccessList] [varchar] (1000) NULL,
[IsEmployee] [bit] NOT NULL,
[ADObjectGUID] [uniqueidentifier] NULL,
[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [GACS].[Staff] ADD  CONSTRAINT [DF_Staff_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]



GO



USE [GrReportingStaging]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[Team]') AND type in (N'U'))
DROP TABLE [GACS].[Team]


CREATE TABLE [GACS].[Team](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL, 
[TeamID] [int] NOT NULL,
[SiteID] [int] NOT NULL,
[Name] [varchar] (255) NOT NULL,
[Description] [varchar] (500) NOT NULL,
[IsActive] [bit] NOT NULL,
[SDate] [datetime] NOT NULL,
[UDate] [datetime] NOT NULL,
CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [GACS].[Team] ADD  CONSTRAINT [DF_Team_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]



GO




USE [GrReportingStaging]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GACS].[Site]') AND type in (N'U'))
DROP TABLE [GACS].[Site]


CREATE TABLE [GACS].[Site](
[ImportKey] [int] IDENTITY(1,1) NOT NULL,
[ImportBatchId] [int] NOT NULL,
[ImportDate] [datetime] NOT NULL,
[SiteID] [int] NOT NULL,
[Name] [varchar] (255) NOT NULL,
[Description] [varchar] (500) NOT NULL,
[AppPrefix] [varchar] (50) NOT NULL,
[IsActive] [bit] NOT NULL,
[SDate] [datetime] NOT NULL,
[UDate] [datetime] NOT NULL,
[StaffDetailURL] [varchar] (250) NOT NULL,
[FilterName] [varchar] (255) NULL,
[FilterPath] [varchar] (500) NULL,
[DatabaseName] [varchar] (100) NOT NULL,
[SiteStatusId] [int] NOT NULL,
 CONSTRAINT [PK_Site] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [GACS].[Site] ADD  CONSTRAINT [DF_Site_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]

