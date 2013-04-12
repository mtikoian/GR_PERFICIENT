
USE [TAPASUS]
GO


-- create schema
--Allocation
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Allocation')
DROP SCHEMA [Allocation]
GO

USE [TAPASUS]

GO
CREATE SCHEMA [Allocation]
GO

--HR
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'HR')
DROP SCHEMA [HR]
GO

USE [TAPASUS]

GO
CREATE SCHEMA [HR]

GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Allocation].[TimeAllocation]') AND type in (N'U'))
DROP TABLE [Allocation].[TimeAllocation]

GO
CREATE TABLE [Allocation].[TimeAllocation](
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
	[TimeAllocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncTimeAllocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncTimeAllocation]
GO
	
CREATE PROCEDURE [dbo].[SyncTimeAllocation]
AS

MERGE 	
	 [TAPASUS].[Allocation].[TimeAllocation] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[TimeAllocationReplication] AS SRC ON
	DST.TimeAllocationId = SRC.TimeAllocationId
WHEN MATCHED AND	
	
DST.Period <> SRC.Period OR

DST.HREmployeeId <> SRC.HREmployeeId OR

DST.ApprovalStatusId <> SRC.ApprovalStatusId OR

DST.LockStatusId <> SRC.LockStatusId OR

DST.ApprovedByStaffId <> SRC.ApprovedByStaffId OR
						(DST.ApprovedByStaffId is not null and SRC.ApprovedByStaffId is null) OR 
						(DST.ApprovedByStaffId is null and SRC.ApprovedByStaffId is not null) OR

DST.ApprovedByStaffName <> SRC.ApprovedByStaffName OR
						(DST.ApprovedByStaffName is not null and SRC.ApprovedByStaffName is null) OR 
						(DST.ApprovedByStaffName is null and SRC.ApprovedByStaffName is not null) OR

DST.ApprovedDate <> SRC.ApprovedDate OR
						(DST.ApprovedDate is not null and SRC.ApprovedDate is null) OR 
						(DST.ApprovedDate is null and SRC.ApprovedDate is not null) OR

DST.SubmittedDate <> SRC.SubmittedDate OR
						(DST.SubmittedDate is not null and SRC.SubmittedDate is null) OR 
						(DST.SubmittedDate is null and SRC.SubmittedDate is not null) OR

DST.PreLockedDate <> SRC.PreLockedDate OR
						(DST.PreLockedDate is not null and SRC.PreLockedDate is null) OR 
						(DST.PreLockedDate is null and SRC.PreLockedDate is not null) OR

DST.LockedDate <> SRC.LockedDate OR
						(DST.LockedDate is not null and SRC.LockedDate is null) OR 
						(DST.LockedDate is null and SRC.LockedDate is not null) OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.IsUserModified <> SRC.IsUserModified OR

DST.SubmittedByStaffId <> SRC.SubmittedByStaffId OR
						(DST.SubmittedByStaffId is not null and SRC.SubmittedByStaffId is null) OR 
						(DST.SubmittedByStaffId is null and SRC.SubmittedByStaffId is not null) OR

DST.SubmittedByStaffName <> SRC.SubmittedByStaffName OR
						(DST.SubmittedByStaffName is not null and SRC.SubmittedByStaffName is null) OR 
						(DST.SubmittedByStaffName is null and SRC.SubmittedByStaffName is not null) OR

DST.AllocationTypeId <> SRC.AllocationTypeId OR

DST.IsTemporary <> SRC.IsTemporary OR

DST.UpdatedByStaffName <> SRC.UpdatedByStaffName 
THEN
	UPDATE
	SET
DST.Period = SRC.Period,
DST.HREmployeeId = SRC.HREmployeeId,
DST.ApprovalStatusId = SRC.ApprovalStatusId,
DST.LockStatusId = SRC.LockStatusId,
DST.ApprovedByStaffId = SRC.ApprovedByStaffId,
DST.ApprovedByStaffName = SRC.ApprovedByStaffName,
DST.ApprovedDate = SRC.ApprovedDate,
DST.SubmittedDate = SRC.SubmittedDate,
DST.PreLockedDate = SRC.PreLockedDate,
DST.LockedDate = SRC.LockedDate,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.IsUserModified = SRC.IsUserModified,
DST.SubmittedByStaffId = SRC.SubmittedByStaffId,
DST.SubmittedByStaffName = SRC.SubmittedByStaffName,
DST.AllocationTypeId = SRC.AllocationTypeId,
DST.IsTemporary = SRC.IsTemporary,
DST.UpdatedByStaffName = SRC.UpdatedByStaffName
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
TimeAllocationId,
Period,
HREmployeeId,
ApprovalStatusId,
LockStatusId,
ApprovedByStaffId,
ApprovedByStaffName,
ApprovedDate,
SubmittedDate,
PreLockedDate,
LockedDate,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
IsUserModified,
SubmittedByStaffId,
SubmittedByStaffName,
AllocationTypeId,
IsTemporary,
UpdatedByStaffName
)
VALUES
(
SRC.TimeAllocationId,
SRC.Period,
SRC.HREmployeeId,
SRC.ApprovalStatusId,
SRC.LockStatusId,
SRC.ApprovedByStaffId,
SRC.ApprovedByStaffName,
SRC.ApprovedDate,
SRC.SubmittedDate,
SRC.PreLockedDate,
SRC.LockedDate,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.IsUserModified,
SRC.SubmittedByStaffId,
SRC.SubmittedByStaffName,
SRC.AllocationTypeId,
SRC.IsTemporary,
SRC.UpdatedByStaffName
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Allocation].[TimeAllocationDetail]') AND type in (N'U'))
DROP TABLE [Allocation].[TimeAllocationDetail]

GO
CREATE TABLE [Allocation].[TimeAllocationDetail](
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
	[TimeAllocationDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncTimeAllocationDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncTimeAllocationDetail]
GO
	
CREATE PROCEDURE [dbo].[SyncTimeAllocationDetail]
AS

MERGE 	
	 [TAPASUS].[Allocation].[TimeAllocationDetail] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[TimeAllocationDetailReplication] AS SRC ON
	DST.TimeAllocationDetailId = SRC.TimeAllocationDetailId
WHEN MATCHED AND	
	
DST.TimeAllocationId <> SRC.TimeAllocationId OR

DST.AllocationValueTypeId <> SRC.AllocationValueTypeId OR

DST.ProjectId <> SRC.ProjectId OR
						(DST.ProjectId is not null and SRC.ProjectId is null) OR 
						(DST.ProjectId is null and SRC.ProjectId is not null) OR

DST.ProjectGroupId <> SRC.ProjectGroupId OR
						(DST.ProjectGroupId is not null and SRC.ProjectGroupId is null) OR 
						(DST.ProjectGroupId is null and SRC.ProjectGroupId is not null) OR

DST.AllocationValue <> SRC.AllocationValue OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.TimeAllocationId = SRC.TimeAllocationId,
DST.AllocationValueTypeId = SRC.AllocationValueTypeId,
DST.ProjectId = SRC.ProjectId,
DST.ProjectGroupId = SRC.ProjectGroupId,
DST.AllocationValue = SRC.AllocationValue,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
TimeAllocationDetailId,
TimeAllocationId,
AllocationValueTypeId,
ProjectId,
ProjectGroupId,
AllocationValue,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.TimeAllocationDetailId,
SRC.TimeAllocationId,
SRC.AllocationValueTypeId,
SRC.ProjectId,
SRC.ProjectGroupId,
SRC.AllocationValue,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [TAPASUS]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[BillingUploadType]') AND type in (N'U'))
DROP TABLE [Billing].[BillingUploadType]

GO
CREATE TABLE [Billing].[BillingUploadType](
[BillingUploadTypeId] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL,
[Description] [varchar] (100) NOT NULL,
[InsertedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL,
[UpdatedByStaffId] [int] NOT NULL,
CONSTRAINT [PK_BillingUploadType] PRIMARY KEY CLUSTERED 
(
	[BillingUploadTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncBillingUploadType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncBillingUploadType]
GO
	
CREATE PROCEDURE [dbo].[SyncBillingUploadType]
AS

MERGE 	
	 [TAPASUS].[Billing].[BillingUploadType] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[BillingUploadTypeReplication] AS SRC ON
	DST.BillingUploadTypeId = SRC.BillingUploadTypeId
WHEN MATCHED AND	
	
DST.Name <> SRC.Name OR

DST.Description <> SRC.Description OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.Name = SRC.Name,
DST.Description = SRC.Description,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
BillingUploadTypeId,
Name,
Description,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.BillingUploadTypeId,
SRC.Name,
SRC.Description,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [TAPASUS]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Project].[AllocationWeight]') AND type in (N'U'))
DROP TABLE [Project].[AllocationWeight]

GO
CREATE TABLE [Project].[AllocationWeight](
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
	[AllocationWeightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncAllocationWeight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncAllocationWeight]
GO
	
CREATE PROCEDURE [dbo].[SyncAllocationWeight]
AS

MERGE 	
	 [TAPASUS].[Project].[AllocationWeight] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[AllocationWeightReplication] AS SRC ON
	DST.AllocationWeightId = SRC.AllocationWeightId
WHEN MATCHED AND	
	
DST.ProjectGroupAllocationId <> SRC.ProjectGroupAllocationId OR

DST.ProjectId <> SRC.ProjectId OR

DST.Weight <> SRC.Weight OR

DST.IsPropertyWeightAllocation <> SRC.IsPropertyWeightAllocation OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.ProjectGroupAllocationId = SRC.ProjectGroupAllocationId,
DST.ProjectId = SRC.ProjectId,
DST.Weight = SRC.Weight,
DST.IsPropertyWeightAllocation = SRC.IsPropertyWeightAllocation,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
AllocationWeightId,
ProjectGroupAllocationId,
ProjectId,
Weight,
IsPropertyWeightAllocation,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.AllocationWeightId,
SRC.ProjectGroupAllocationId,
SRC.ProjectId,
SRC.Weight,
SRC.IsPropertyWeightAllocation,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO


USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Project].[ProjectGroup]') AND type in (N'U'))
DROP TABLE [Project].[ProjectGroup]

GO
CREATE TABLE [Project].[ProjectGroup](
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
	[ProjectGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncProjectGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncProjectGroup]
GO
	
CREATE PROCEDURE [dbo].[SyncProjectGroup]
AS

MERGE 	
	 [TAPASUS].[Project].[ProjectGroup] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[ProjectGroupReplication] AS SRC ON
	DST.ProjectGroupId = SRC.ProjectGroupId
WHEN MATCHED AND	
	
DST.SourceCode <> SRC.SourceCode OR

DST.Name <> SRC.Name OR

DST.EndPeriod <> SRC.EndPeriod OR
						(DST.EndPeriod is not null and SRC.EndPeriod is null) OR 
						(DST.EndPeriod is null and SRC.EndPeriod is not null) OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.AMProjectGroupId <> SRC.AMProjectGroupId OR
						(DST.AMProjectGroupId is not null and SRC.AMProjectGroupId is null) OR 
						(DST.AMProjectGroupId is null and SRC.AMProjectGroupId is not null) OR

DST.IsFunctionalDepartmentIncluded <> SRC.IsFunctionalDepartmentIncluded OR
						(DST.IsFunctionalDepartmentIncluded is not null and SRC.IsFunctionalDepartmentIncluded is null) OR 
						(DST.IsFunctionalDepartmentIncluded is null and SRC.IsFunctionalDepartmentIncluded is not null) 
THEN
	UPDATE
	SET
DST.SourceCode = SRC.SourceCode,
DST.Name = SRC.Name,
DST.EndPeriod = SRC.EndPeriod,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.AMProjectGroupId = SRC.AMProjectGroupId,
DST.IsFunctionalDepartmentIncluded = SRC.IsFunctionalDepartmentIncluded
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
ProjectGroupId,
SourceCode,
Name,
EndPeriod,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
AMProjectGroupId,
IsFunctionalDepartmentIncluded
)
VALUES
(
SRC.ProjectGroupId,
SRC.SourceCode,
SRC.Name,
SRC.EndPeriod,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.AMProjectGroupId,
SRC.IsFunctionalDepartmentIncluded
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO

USE [TAPASUS]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Project].[ProjectGroupAllocation]') AND type in (N'U'))
DROP TABLE [Project].[ProjectGroupAllocation]

GO
CREATE TABLE [Project].[ProjectGroupAllocation](
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
	[ProjectGroupAllocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncProjectGroupAllocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncProjectGroupAllocation]
GO
	
CREATE PROCEDURE [dbo].[SyncProjectGroupAllocation]
AS

MERGE 	
	 [TAPASUS].[Project].[ProjectGroupAllocation] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[ProjectGroupAllocationReplication] AS SRC ON
	DST.ProjectGroupAllocationId = SRC.ProjectGroupAllocationId
WHEN MATCHED AND	
	
DST.ProjectGroupId <> SRC.ProjectGroupId OR

DST.EffectivePeriod <> SRC.EffectivePeriod OR

DST.TotalPropertyWeight <> SRC.TotalPropertyWeight OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.SnapshotNumber <> SRC.SnapshotNumber OR
						(DST.SnapshotNumber is not null and SRC.SnapshotNumber is null) OR 
						(DST.SnapshotNumber is null and SRC.SnapshotNumber is not null) 
THEN
	UPDATE
	SET
DST.ProjectGroupId = SRC.ProjectGroupId,
DST.EffectivePeriod = SRC.EffectivePeriod,
DST.TotalPropertyWeight = SRC.TotalPropertyWeight,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.SnapshotNumber = SRC.SnapshotNumber
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
ProjectGroupAllocationId,
ProjectGroupId,
EffectivePeriod,
TotalPropertyWeight,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
SnapshotNumber
)
VALUES
(
SRC.ProjectGroupAllocationId,
SRC.ProjectGroupId,
SRC.EffectivePeriod,
SRC.TotalPropertyWeight,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.SnapshotNumber
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [TAPASUS]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[HREmployee]') AND type in (N'U'))
DROP TABLE [HR].[HREmployee]

GO
CREATE TABLE [HR].[HREmployee](
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
	[HREmployeeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncHREmployee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncHREmployee]
GO
	
CREATE PROCEDURE [dbo].[SyncHREmployee]
AS

MERGE 	
	 [TAPASUS].[HR].[HREmployee] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[HREmployeeReplication] AS SRC ON
	DST.HREmployeeId = SRC.HREmployeeId
WHEN MATCHED AND	
	
DST.HREmployeeNumber <> SRC.HREmployeeNumber OR

DST.EncryptedSSN <> SRC.EncryptedSSN OR
						(DST.EncryptedSSN is not null and SRC.EncryptedSSN is null) OR 
						(DST.EncryptedSSN is null and SRC.EncryptedSSN is not null) OR

DST.StaffId <> SRC.StaffId OR
						(DST.StaffId is not null and SRC.StaffId is null) OR 
						(DST.StaffId is null and SRC.StaffId is not null) OR

DST.EDEmployeeId <> SRC.EDEmployeeId OR
						(DST.EDEmployeeId is not null and SRC.EDEmployeeId is null) OR 
						(DST.EDEmployeeId is null and SRC.EDEmployeeId is not null) OR

DST.IsTerminated <> SRC.IsTerminated OR

DST.IsEmployeeMappedToGacs <> SRC.IsEmployeeMappedToGacs OR

DST.IsEmployeeMappedToED <> SRC.IsEmployeeMappedToED OR

DST.DisplayName <> SRC.DisplayName OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.MappedByStaffId <> SRC.MappedByStaffId OR

DST.NTLogin <> SRC.NTLogin OR
						(DST.NTLogin is not null and SRC.NTLogin is null) OR 
						(DST.NTLogin is null and SRC.NTLogin is not null) OR

DST.Email <> SRC.Email OR
						(DST.Email is not null and SRC.Email is null) OR 
						(DST.Email is null and SRC.Email is not null) OR

DST.IsActive <> SRC.IsActive OR
						(DST.IsActive is not null and SRC.IsActive is null) OR 
						(DST.IsActive is null and SRC.IsActive is not null) OR

DST.IsTapasEmployee <> SRC.IsTapasEmployee OR
						(DST.IsTapasEmployee is not null and SRC.IsTapasEmployee is null) OR 
						(DST.IsTapasEmployee is null and SRC.IsTapasEmployee is not null) OR

DST.EmployeeHistoryId <> SRC.EmployeeHistoryId OR

DST.FileNumber <> SRC.FileNumber OR
						(DST.FileNumber is not null and SRC.FileNumber is null) OR 
						(DST.FileNumber is null and SRC.FileNumber is not null) OR

DST.PayGroupId <> SRC.PayGroupId OR
						(DST.PayGroupId is not null and SRC.PayGroupId is null) OR 
						(DST.PayGroupId is null and SRC.PayGroupId is not null) OR

DST.LocationId <> SRC.LocationId OR
						(DST.LocationId is not null and SRC.LocationId is null) OR 
						(DST.LocationId is null and SRC.LocationId is not null) OR

DST.SubDepartmentId <> SRC.SubDepartmentId OR
						(DST.SubDepartmentId is not null and SRC.SubDepartmentId is null) OR 
						(DST.SubDepartmentId is null and SRC.SubDepartmentId is not null) OR

DST.ImportSubDepartmentId <> SRC.ImportSubDepartmentId OR
						(DST.ImportSubDepartmentId is not null and SRC.ImportSubDepartmentId is null) OR 
						(DST.ImportSubDepartmentId is null and SRC.ImportSubDepartmentId is not null) OR

DST.FunctionalDepartmentId <> SRC.FunctionalDepartmentId OR
						(DST.FunctionalDepartmentId is not null and SRC.FunctionalDepartmentId is null) OR 
						(DST.FunctionalDepartmentId is null and SRC.FunctionalDepartmentId is not null) OR

DST.UnionCodeId <> SRC.UnionCodeId OR
						(DST.UnionCodeId is not null and SRC.UnionCodeId is null) OR 
						(DST.UnionCodeId is null and SRC.UnionCodeId is not null) OR

DST.JobTitleId <> SRC.JobTitleId OR
						(DST.JobTitleId is not null and SRC.JobTitleId is null) OR 
						(DST.JobTitleId is null and SRC.JobTitleId is not null) OR

DST.OverheadRegionId <> SRC.OverheadRegionId OR
						(DST.OverheadRegionId is not null and SRC.OverheadRegionId is null) OR 
						(DST.OverheadRegionId is null and SRC.OverheadRegionId is not null) OR

DST.ImportOverHeadRegionId <> SRC.ImportOverHeadRegionId OR
						(DST.ImportOverHeadRegionId is not null and SRC.ImportOverHeadRegionId is null) OR 
						(DST.ImportOverHeadRegionId is null and SRC.ImportOverHeadRegionId is not null) OR

DST.IsLatestInformation <> SRC.IsLatestInformation OR
						(DST.IsLatestInformation is not null and SRC.IsLatestInformation is null) OR 
						(DST.IsLatestInformation is null and SRC.IsLatestInformation is not null) OR

DST.EffectivePeriod <> SRC.EffectivePeriod OR
						(DST.EffectivePeriod is not null and SRC.EffectivePeriod is null) OR 
						(DST.EffectivePeriod is null and SRC.EffectivePeriod is not null) OR

DST.EffectiveDate <> SRC.EffectiveDate OR
						(DST.EffectiveDate is not null and SRC.EffectiveDate is null) OR 
						(DST.EffectiveDate is null and SRC.EffectiveDate is not null) OR

DST.FirstName <> SRC.FirstName OR
						(DST.FirstName is not null and SRC.FirstName is null) OR 
						(DST.FirstName is null and SRC.FirstName is not null) OR

DST.LastName <> SRC.LastName OR
						(DST.LastName is not null and SRC.LastName is null) OR 
						(DST.LastName is null and SRC.LastName is not null) OR

DST.Initials <> SRC.Initials OR
						(DST.Initials is not null and SRC.Initials is null) OR 
						(DST.Initials is null and SRC.Initials is not null) OR

DST.BirthDate <> SRC.BirthDate OR
						(DST.BirthDate is not null and SRC.BirthDate is null) OR 
						(DST.BirthDate is null and SRC.BirthDate is not null) OR

DST.HirePeriod <> SRC.HirePeriod OR
						(DST.HirePeriod is not null and SRC.HirePeriod is null) OR 
						(DST.HirePeriod is null and SRC.HirePeriod is not null) OR

DST.HireDate <> SRC.HireDate OR
						(DST.HireDate is not null and SRC.HireDate is null) OR 
						(DST.HireDate is null and SRC.HireDate is not null) OR

DST.RehirePeriod <> SRC.RehirePeriod OR
						(DST.RehirePeriod is not null and SRC.RehirePeriod is null) OR 
						(DST.RehirePeriod is null and SRC.RehirePeriod is not null) OR

DST.RehireDate <> SRC.RehireDate OR
						(DST.RehireDate is not null and SRC.RehireDate is null) OR 
						(DST.RehireDate is null and SRC.RehireDate is not null) OR

DST.TerminatePeriod <> SRC.TerminatePeriod OR
						(DST.TerminatePeriod is not null and SRC.TerminatePeriod is null) OR 
						(DST.TerminatePeriod is null and SRC.TerminatePeriod is not null) OR

DST.TerminateDate <> SRC.TerminateDate OR
						(DST.TerminateDate is not null and SRC.TerminateDate is null) OR 
						(DST.TerminateDate is null and SRC.TerminateDate is not null) OR

DST.IsEmployed <> SRC.IsEmployed OR
						(DST.IsEmployed is not null and SRC.IsEmployed is null) OR 
						(DST.IsEmployed is null and SRC.IsEmployed is not null) OR

DST.ERSApproverStaffId <> SRC.ERSApproverStaffId OR
						(DST.ERSApproverStaffId is not null and SRC.ERSApproverStaffId is null) OR 
						(DST.ERSApproverStaffId is null and SRC.ERSApproverStaffId is not null) OR

DST.ApproverStaffId <> SRC.ApproverStaffId OR
						(DST.ApproverStaffId is not null and SRC.ApproverStaffId is null) OR 
						(DST.ApproverStaffId is null and SRC.ApproverStaffId is not null) 
THEN
	UPDATE
	SET
DST.HREmployeeNumber = SRC.HREmployeeNumber,
DST.EncryptedSSN = SRC.EncryptedSSN,
DST.StaffId = SRC.StaffId,
DST.EDEmployeeId = SRC.EDEmployeeId,
DST.IsTerminated = SRC.IsTerminated,
DST.IsEmployeeMappedToGacs = SRC.IsEmployeeMappedToGacs,
DST.IsEmployeeMappedToED = SRC.IsEmployeeMappedToED,
DST.DisplayName = SRC.DisplayName,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.MappedByStaffId = SRC.MappedByStaffId,
DST.NTLogin = SRC.NTLogin,
DST.Email = SRC.Email,
DST.IsActive = SRC.IsActive,
DST.IsTapasEmployee = SRC.IsTapasEmployee,
DST.EmployeeHistoryId = SRC.EmployeeHistoryId,
DST.FileNumber = SRC.FileNumber,
DST.PayGroupId = SRC.PayGroupId,
DST.LocationId = SRC.LocationId,
DST.SubDepartmentId = SRC.SubDepartmentId,
DST.ImportSubDepartmentId = SRC.ImportSubDepartmentId,
DST.FunctionalDepartmentId = SRC.FunctionalDepartmentId,
DST.UnionCodeId = SRC.UnionCodeId,
DST.JobTitleId = SRC.JobTitleId,
DST.OverheadRegionId = SRC.OverheadRegionId,
DST.ImportOverHeadRegionId = SRC.ImportOverHeadRegionId,
DST.IsLatestInformation = SRC.IsLatestInformation,
DST.EffectivePeriod = SRC.EffectivePeriod,
DST.EffectiveDate = SRC.EffectiveDate,
DST.FirstName = SRC.FirstName,
DST.LastName = SRC.LastName,
DST.Initials = SRC.Initials,
DST.BirthDate = SRC.BirthDate,
DST.HirePeriod = SRC.HirePeriod,
DST.HireDate = SRC.HireDate,
DST.RehirePeriod = SRC.RehirePeriod,
DST.RehireDate = SRC.RehireDate,
DST.TerminatePeriod = SRC.TerminatePeriod,
DST.TerminateDate = SRC.TerminateDate,
DST.IsEmployed = SRC.IsEmployed,
DST.ERSApproverStaffId = SRC.ERSApproverStaffId,
DST.ApproverStaffId = SRC.ApproverStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
HREmployeeId,
HREmployeeNumber,
EncryptedSSN,
StaffId,
EDEmployeeId,
IsTerminated,
IsEmployeeMappedToGacs,
IsEmployeeMappedToED,
DisplayName,
UpdatedByStaffId,
InsertedDate,
UpdatedDate,
MappedByStaffId,
NTLogin,
Email,
IsActive,
IsTapasEmployee,
EmployeeHistoryId,
FileNumber,
PayGroupId,
LocationId,
SubDepartmentId,
ImportSubDepartmentId,
FunctionalDepartmentId,
UnionCodeId,
JobTitleId,
OverheadRegionId,
ImportOverHeadRegionId,
IsLatestInformation,
EffectivePeriod,
EffectiveDate,
FirstName,
LastName,
Initials,
BirthDate,
HirePeriod,
HireDate,
RehirePeriod,
RehireDate,
TerminatePeriod,
TerminateDate,
IsEmployed,
ERSApproverStaffId,
ApproverStaffId
)
VALUES
(
SRC.HREmployeeId,
SRC.HREmployeeNumber,
SRC.EncryptedSSN,
SRC.StaffId,
SRC.EDEmployeeId,
SRC.IsTerminated,
SRC.IsEmployeeMappedToGacs,
SRC.IsEmployeeMappedToED,
SRC.DisplayName,
SRC.UpdatedByStaffId,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.MappedByStaffId,
SRC.NTLogin,
SRC.Email,
SRC.IsActive,
SRC.IsTapasEmployee,
SRC.EmployeeHistoryId,
SRC.FileNumber,
SRC.PayGroupId,
SRC.LocationId,
SRC.SubDepartmentId,
SRC.ImportSubDepartmentId,
SRC.FunctionalDepartmentId,
SRC.UnionCodeId,
SRC.JobTitleId,
SRC.OverheadRegionId,
SRC.ImportOverHeadRegionId,
SRC.IsLatestInformation,
SRC.EffectivePeriod,
SRC.EffectiveDate,
SRC.FirstName,
SRC.LastName,
SRC.Initials,
SRC.BirthDate,
SRC.HirePeriod,
SRC.HireDate,
SRC.RehirePeriod,
SRC.RehireDate,
SRC.TerminatePeriod,
SRC.TerminateDate,
SRC.IsEmployed,
SRC.ERSApproverStaffId,
SRC.ApproverStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HR].[EmployeeHistory]') AND type in (N'U'))
DROP TABLE [HR].[EmployeeHistory]

GO
CREATE TABLE [HR].[EmployeeHistory](
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
	[EmployeeHistoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncEmployeeHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncEmployeeHistory]
GO
	
CREATE PROCEDURE [dbo].[SyncEmployeeHistory]
AS

MERGE 	
	 [TAPASUS].[HR].[EmployeeHistory] AS DST
USING 	
	[SERVER3].[TAPASUS].[GMR].[EmployeeHistoryReplication] AS SRC ON
	DST.EmployeeHistoryId = SRC.EmployeeHistoryId
WHEN MATCHED AND	
	
DST.HREmployeeId <> SRC.HREmployeeId OR

DST.FileNumber <> SRC.FileNumber OR

DST.PayGroupId <> SRC.PayGroupId OR

DST.LocationId <> SRC.LocationId OR

DST.SubDepartmentId <> SRC.SubDepartmentId OR

DST.ImportSubDepartmentId <> SRC.ImportSubDepartmentId OR

DST.FunctionalDepartmentId <> SRC.FunctionalDepartmentId OR

DST.UnionCodeId <> SRC.UnionCodeId OR
						(DST.UnionCodeId is not null and SRC.UnionCodeId is null) OR 
						(DST.UnionCodeId is null and SRC.UnionCodeId is not null) OR

DST.JobTitleId <> SRC.JobTitleId OR

DST.EncryptedSSN <> SRC.EncryptedSSN OR

DST.OverheadRegionId <> SRC.OverheadRegionId OR
						(DST.OverheadRegionId is not null and SRC.OverheadRegionId is null) OR 
						(DST.OverheadRegionId is null and SRC.OverheadRegionId is not null) OR

DST.ImportOverheadRegionId <> SRC.ImportOverheadRegionId OR
						(DST.ImportOverheadRegionId is not null and SRC.ImportOverheadRegionId is null) OR 
						(DST.ImportOverheadRegionId is null and SRC.ImportOverheadRegionId is not null) OR

DST.IsLatestInformation <> SRC.IsLatestInformation OR
						(DST.IsLatestInformation is not null and SRC.IsLatestInformation is null) OR 
						(DST.IsLatestInformation is null and SRC.IsLatestInformation is not null) OR

DST.EffectivePeriod <> SRC.EffectivePeriod OR
						(DST.EffectivePeriod is not null and SRC.EffectivePeriod is null) OR 
						(DST.EffectivePeriod is null and SRC.EffectivePeriod is not null) OR

DST.EffectiveDate <> SRC.EffectiveDate OR

DST.FirstName <> SRC.FirstName OR

DST.LastName <> SRC.LastName OR

DST.Initials <> SRC.Initials OR
						(DST.Initials is not null and SRC.Initials is null) OR 
						(DST.Initials is null and SRC.Initials is not null) OR

DST.BirthDate <> SRC.BirthDate OR

DST.HirePeriod <> SRC.HirePeriod OR
						(DST.HirePeriod is not null and SRC.HirePeriod is null) OR 
						(DST.HirePeriod is null and SRC.HirePeriod is not null) OR

DST.HireDate <> SRC.HireDate OR

DST.RehirePeriod <> SRC.RehirePeriod OR
						(DST.RehirePeriod is not null and SRC.RehirePeriod is null) OR 
						(DST.RehirePeriod is null and SRC.RehirePeriod is not null) OR

DST.RehireDate <> SRC.RehireDate OR
						(DST.RehireDate is not null and SRC.RehireDate is null) OR 
						(DST.RehireDate is null and SRC.RehireDate is not null) OR

DST.TerminatePeriod <> SRC.TerminatePeriod OR
						(DST.TerminatePeriod is not null and SRC.TerminatePeriod is null) OR 
						(DST.TerminatePeriod is null and SRC.TerminatePeriod is not null) OR

DST.TerminateDate <> SRC.TerminateDate OR
						(DST.TerminateDate is not null and SRC.TerminateDate is null) OR 
						(DST.TerminateDate is null and SRC.TerminateDate is not null) OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.ERSApproverStaffId <> SRC.ERSApproverStaffId OR
						(DST.ERSApproverStaffId is not null and SRC.ERSApproverStaffId is null) OR 
						(DST.ERSApproverStaffId is null and SRC.ERSApproverStaffId is not null) OR

DST.ApproverStaffId <> SRC.ApproverStaffId OR
						(DST.ApproverStaffId is not null and SRC.ApproverStaffId is null) OR 
						(DST.ApproverStaffId is null and SRC.ApproverStaffId is not null) OR

DST.NTLogin <> SRC.NTLogin OR
						(DST.NTLogin is not null and SRC.NTLogin is null) OR 
						(DST.NTLogin is null and SRC.NTLogin is not null) OR

DST.Email <> SRC.Email OR
						(DST.Email is not null and SRC.Email is null) OR 
						(DST.Email is null and SRC.Email is not null) OR

DST.IsActive <> SRC.IsActive OR
						(DST.IsActive is not null and SRC.IsActive is null) OR 
						(DST.IsActive is null and SRC.IsActive is not null) 
THEN
	UPDATE
	SET
DST.HREmployeeId = SRC.HREmployeeId,
DST.FileNumber = SRC.FileNumber,
DST.PayGroupId = SRC.PayGroupId,
DST.LocationId = SRC.LocationId,
DST.SubDepartmentId = SRC.SubDepartmentId,
DST.ImportSubDepartmentId = SRC.ImportSubDepartmentId,
DST.FunctionalDepartmentId = SRC.FunctionalDepartmentId,
DST.UnionCodeId = SRC.UnionCodeId,
DST.JobTitleId = SRC.JobTitleId,
DST.EncryptedSSN = SRC.EncryptedSSN,
DST.OverheadRegionId = SRC.OverheadRegionId,
DST.ImportOverheadRegionId = SRC.ImportOverheadRegionId,
DST.IsLatestInformation = SRC.IsLatestInformation,
DST.EffectivePeriod = SRC.EffectivePeriod,
DST.EffectiveDate = SRC.EffectiveDate,
DST.FirstName = SRC.FirstName,
DST.LastName = SRC.LastName,
DST.Initials = SRC.Initials,
DST.BirthDate = SRC.BirthDate,
DST.HirePeriod = SRC.HirePeriod,
DST.HireDate = SRC.HireDate,
DST.RehirePeriod = SRC.RehirePeriod,
DST.RehireDate = SRC.RehireDate,
DST.TerminatePeriod = SRC.TerminatePeriod,
DST.TerminateDate = SRC.TerminateDate,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.ERSApproverStaffId = SRC.ERSApproverStaffId,
DST.ApproverStaffId = SRC.ApproverStaffId,
DST.NTLogin = SRC.NTLogin,
DST.Email = SRC.Email,
DST.IsActive = SRC.IsActive
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
EmployeeHistoryId,
HREmployeeId,
FileNumber,
PayGroupId,
LocationId,
SubDepartmentId,
ImportSubDepartmentId,
FunctionalDepartmentId,
UnionCodeId,
JobTitleId,
EncryptedSSN,
OverheadRegionId,
ImportOverheadRegionId,
IsLatestInformation,
EffectivePeriod,
EffectiveDate,
FirstName,
LastName,
Initials,
BirthDate,
HirePeriod,
HireDate,
RehirePeriod,
RehireDate,
TerminatePeriod,
TerminateDate,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
ERSApproverStaffId,
ApproverStaffId,
NTLogin,
Email,
IsActive
)
VALUES
(
SRC.EmployeeHistoryId,
SRC.HREmployeeId,
SRC.FileNumber,
SRC.PayGroupId,
SRC.LocationId,
SRC.SubDepartmentId,
SRC.ImportSubDepartmentId,
SRC.FunctionalDepartmentId,
SRC.UnionCodeId,
SRC.JobTitleId,
SRC.EncryptedSSN,
SRC.OverheadRegionId,
SRC.ImportOverheadRegionId,
SRC.IsLatestInformation,
SRC.EffectivePeriod,
SRC.EffectiveDate,
SRC.FirstName,
SRC.LastName,
SRC.Initials,
SRC.BirthDate,
SRC.HirePeriod,
SRC.HireDate,
SRC.RehirePeriod,
SRC.RehireDate,
SRC.TerminatePeriod,
SRC.TerminateDate,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.ERSApproverStaffId,
SRC.ApproverStaffId,
SRC.NTLogin,
SRC.Email,
SRC.IsActive
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO


USE [TAPASUS]
GO

/****** Object:  StoredProcedure [dbo].[SyncTAPASUS]    Script Date: 06/05/2012 01:56:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncTAPASUS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncTAPASUS]
GO

USE [TAPASUS]
GO

/****** Object:  StoredProcedure [dbo].[SyncTAPASUS]    Script Date: 06/05/2012 01:56:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SyncTAPASUS]
AS

	EXEC TAPASUS.dbo.SyncSystemSetting
	EXEC TAPASUS.dbo.SyncRegionExtended
	EXEC TAPASUS.dbo.SyncProject
	EXEC TAPASUS.dbo.SyncPayrollRegion
	EXEC TAPASUS.dbo.SyncOverheadRegion
	EXEC TAPASUS.dbo.SyncOverhead
	EXEC TAPASUS.dbo.SyncBillingUploadDetail
	EXEC TAPASUS.dbo.SyncBillingUpload
	EXEC TAPASUS.dbo.SyncSystemSettingRegion
	
	EXEC TAPASUS.dbo.SyncTimeAllocation
	EXEC TAPASUS.dbo.SyncTimeAllocationDetail
	EXEC TAPASUS.dbo.SyncBillingUploadType
	EXEC TAPASUS.dbo.SyncAllocationWeight
	EXEC TAPASUS.dbo.SyncProjectGroup
	EXEC TAPASUS.dbo.SyncProjectGroupAllocation
	EXEC TAPASUS.dbo.SyncHREmployee
	EXEC TAPASUS.dbo.SyncEmployeeHistory




GO




USE [TAPASUS_Budgeting]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Budget].[BudgetAllocation]') AND type in (N'U'))
DROP TABLE [Budget].[BudgetAllocation]

GO
CREATE TABLE [Budget].[BudgetAllocation](
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
	[BudgetAllocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncBudgetAllocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncBudgetAllocation]
GO
	
CREATE PROCEDURE [dbo].[SyncBudgetAllocation]
AS

MERGE 	
	 [TAPASUS_Budgeting].[Budget].[BudgetAllocation] AS DST
USING 	
	[SERVER3].[TAPASUS_Budgeting].[GMR].[BudgetAllocationReplication] AS SRC ON
	DST.BudgetAllocationId = SRC.BudgetAllocationId
WHEN MATCHED AND	
	
DST.BudgetEmployeeId <> SRC.BudgetEmployeeId OR

DST.BudgetAllocationSetupId <> SRC.BudgetAllocationSetupId OR
						(DST.BudgetAllocationSetupId is not null and SRC.BudgetAllocationSetupId is null) OR 
						(DST.BudgetAllocationSetupId is null and SRC.BudgetAllocationSetupId is not null) OR

DST.BudgetPeriod <> SRC.BudgetPeriod OR

DST.IsEditable <> SRC.IsEditable OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.OriginalBudgetAllocationId <> SRC.OriginalBudgetAllocationId OR
						(DST.OriginalBudgetAllocationId is not null and SRC.OriginalBudgetAllocationId is null) OR 
						(DST.OriginalBudgetAllocationId is null and SRC.OriginalBudgetAllocationId is not null) 
THEN
	UPDATE
	SET
DST.BudgetEmployeeId = SRC.BudgetEmployeeId,
DST.BudgetAllocationSetupId = SRC.BudgetAllocationSetupId,
DST.BudgetPeriod = SRC.BudgetPeriod,
DST.IsEditable = SRC.IsEditable,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.OriginalBudgetAllocationId = SRC.OriginalBudgetAllocationId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
BudgetAllocationId,
BudgetEmployeeId,
BudgetAllocationSetupId,
BudgetPeriod,
IsEditable,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
OriginalBudgetAllocationId
)
VALUES
(
SRC.BudgetAllocationId,
SRC.BudgetEmployeeId,
SRC.BudgetAllocationSetupId,
SRC.BudgetPeriod,
SRC.IsEditable,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.OriginalBudgetAllocationId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Budget].[BudgetAllocationDetail]') AND type in (N'U'))
DROP TABLE [Budget].[BudgetAllocationDetail]

GO
CREATE TABLE [Budget].[BudgetAllocationDetail](
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
	[BudgetAllocationDetailId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncBudgetAllocationDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncBudgetAllocationDetail]
GO
	
CREATE PROCEDURE [dbo].[SyncBudgetAllocationDetail]
AS

MERGE 	
	 [TAPASUS_Budgeting].[Budget].[BudgetAllocationDetail] AS DST
USING 	
	[SERVER3].[TAPASUS_Budgeting].[GMR].[BudgetAllocationDetailReplication] AS SRC ON
	DST.BudgetAllocationDetailId = SRC.BudgetAllocationDetailId
WHEN MATCHED AND	
	
DST.BudgetAllocationId <> SRC.BudgetAllocationId OR

DST.BudgetProjectId <> SRC.BudgetProjectId OR
						(DST.BudgetProjectId is not null and SRC.BudgetProjectId is null) OR 
						(DST.BudgetProjectId is null and SRC.BudgetProjectId is not null) OR

DST.BudgetProjectGroupId <> SRC.BudgetProjectGroupId OR
						(DST.BudgetProjectGroupId is not null and SRC.BudgetProjectGroupId is null) OR 
						(DST.BudgetProjectGroupId is null and SRC.BudgetProjectGroupId is not null) OR

DST.AllocationValue <> SRC.AllocationValue OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.BudgetAllocationId = SRC.BudgetAllocationId,
DST.BudgetProjectId = SRC.BudgetProjectId,
DST.BudgetProjectGroupId = SRC.BudgetProjectGroupId,
DST.AllocationValue = SRC.AllocationValue,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
BudgetAllocationDetailId,
BudgetAllocationId,
BudgetProjectId,
BudgetProjectGroupId,
AllocationValue,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.BudgetAllocationDetailId,
SRC.BudgetAllocationId,
SRC.BudgetProjectId,
SRC.BudgetProjectGroupId,
SRC.AllocationValue,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO

USE [TAPASUS_Budgeting]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Budget].[BudgetProjectGroup]') AND type in (N'U'))
DROP TABLE [Budget].[BudgetProjectGroup]

GO
CREATE TABLE [Budget].[BudgetProjectGroup](
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
	[BudgetProjectGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncBudgetProjectGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncBudgetProjectGroup]
GO
	
CREATE PROCEDURE [dbo].[SyncBudgetProjectGroup]
AS

MERGE 	
	 [TAPASUS_Budgeting].[Budget].[BudgetProjectGroup] AS DST
USING 	
	[SERVER3].[TAPASUS_Budgeting].[GMR].[BudgetProjectGroupReplication] AS SRC ON
	DST.BudgetProjectGroupId = SRC.BudgetProjectGroupId
WHEN MATCHED AND	
	
DST.ProjectGroupId <> SRC.ProjectGroupId OR
						(DST.ProjectGroupId is not null and SRC.ProjectGroupId is null) OR 
						(DST.ProjectGroupId is null and SRC.ProjectGroupId is not null) OR

DST.BudgetId <> SRC.BudgetId OR

DST.Name <> SRC.Name OR
						(DST.Name is not null and SRC.Name is null) OR 
						(DST.Name is null and SRC.Name is not null) OR

DST.EndPeriod <> SRC.EndPeriod OR
						(DST.EndPeriod is not null and SRC.EndPeriod is null) OR 
						(DST.EndPeriod is null and SRC.EndPeriod is not null) OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.OriginalBudgetProjectGroupId <> SRC.OriginalBudgetProjectGroupId OR
						(DST.OriginalBudgetProjectGroupId is not null and SRC.OriginalBudgetProjectGroupId is null) OR 
						(DST.OriginalBudgetProjectGroupId is null and SRC.OriginalBudgetProjectGroupId is not null) OR

DST.AMBudgetProjectGroupId <> SRC.AMBudgetProjectGroupId OR
						(DST.AMBudgetProjectGroupId is not null and SRC.AMBudgetProjectGroupId is null) OR 
						(DST.AMBudgetProjectGroupId is null and SRC.AMBudgetProjectGroupId is not null) 
THEN
	UPDATE
	SET
DST.ProjectGroupId = SRC.ProjectGroupId,
DST.BudgetId = SRC.BudgetId,
DST.Name = SRC.Name,
DST.EndPeriod = SRC.EndPeriod,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.OriginalBudgetProjectGroupId = SRC.OriginalBudgetProjectGroupId,
DST.AMBudgetProjectGroupId = SRC.AMBudgetProjectGroupId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
BudgetProjectGroupId,
ProjectGroupId,
BudgetId,
Name,
EndPeriod,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
OriginalBudgetProjectGroupId,
AMBudgetProjectGroupId
)
VALUES
(
SRC.BudgetProjectGroupId,
SRC.ProjectGroupId,
SRC.BudgetId,
SRC.Name,
SRC.EndPeriod,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.OriginalBudgetProjectGroupId,
SRC.AMBudgetProjectGroupId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO


USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Budget].[BudgetProjectGroupAllocation]') AND type in (N'U'))
DROP TABLE [Budget].[BudgetProjectGroupAllocation]

GO
CREATE TABLE [Budget].[BudgetProjectGroupAllocation](
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
	[BudgetProjectGroupAllocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncBudgetProjectGroupAllocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncBudgetProjectGroupAllocation]
GO
	
CREATE PROCEDURE [dbo].[SyncBudgetProjectGroupAllocation]
AS

MERGE 	
	 [TAPASUS_Budgeting].[Budget].[BudgetProjectGroupAllocation] AS DST
USING 	
	[SERVER3].[TAPASUS_Budgeting].[GMR].[BudgetProjectGroupAllocationReplication] AS SRC ON
	DST.BudgetProjectGroupAllocationId = SRC.BudgetProjectGroupAllocationId
WHEN MATCHED AND	
	
DST.BudgetProjectGroupId <> SRC.BudgetProjectGroupId OR

DST.EffectivePeriod <> SRC.EffectivePeriod OR

DST.TotalPropertyWeight <> SRC.TotalPropertyWeight OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId OR

DST.OriginalBudgetProjectGroupAllocationId <> SRC.OriginalBudgetProjectGroupAllocationId OR
						(DST.OriginalBudgetProjectGroupAllocationId is not null and SRC.OriginalBudgetProjectGroupAllocationId is null) OR 
						(DST.OriginalBudgetProjectGroupAllocationId is null and SRC.OriginalBudgetProjectGroupAllocationId is not null) 
THEN
	UPDATE
	SET
DST.BudgetProjectGroupId = SRC.BudgetProjectGroupId,
DST.EffectivePeriod = SRC.EffectivePeriod,
DST.TotalPropertyWeight = SRC.TotalPropertyWeight,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId,
DST.OriginalBudgetProjectGroupAllocationId = SRC.OriginalBudgetProjectGroupAllocationId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
BudgetProjectGroupAllocationId,
BudgetProjectGroupId,
EffectivePeriod,
TotalPropertyWeight,
InsertedDate,
UpdatedDate,
UpdatedByStaffId,
OriginalBudgetProjectGroupAllocationId
)
VALUES
(
SRC.BudgetProjectGroupAllocationId,
SRC.BudgetProjectGroupId,
SRC.EffectivePeriod,
SRC.TotalPropertyWeight,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId,
SRC.OriginalBudgetProjectGroupAllocationId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO

USE [TAPASUS_Budgeting]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Budget].[BudgetAllocationWeight]') AND type in (N'U'))
DROP TABLE [Budget].[BudgetAllocationWeight]

GO
CREATE TABLE [Budget].[BudgetAllocationWeight](
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
	[BudgetAllocationWeightId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [TAPASUS_Budgeting]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncBudgetAllocationWeight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncBudgetAllocationWeight]
GO
	
CREATE PROCEDURE [dbo].[SyncBudgetAllocationWeight]
AS

MERGE 	
	 [TAPASUS_Budgeting].[Budget].[BudgetAllocationWeight] AS DST
USING 	
	[SERVER3].[TAPASUS_Budgeting].[GMR].[BudgetAllocationWeightReplication] AS SRC ON
	DST.BudgetAllocationWeightId = SRC.BudgetAllocationWeightId
WHEN MATCHED AND	
	
DST.BudgetProjectGroupAllocationId <> SRC.BudgetProjectGroupAllocationId OR

DST.BudgetProjectId <> SRC.BudgetProjectId OR

DST.Weight <> SRC.Weight OR

DST.IsPropertyWeightAllocation <> SRC.IsPropertyWeightAllocation OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.BudgetProjectGroupAllocationId = SRC.BudgetProjectGroupAllocationId,
DST.BudgetProjectId = SRC.BudgetProjectId,
DST.Weight = SRC.Weight,
DST.IsPropertyWeightAllocation = SRC.IsPropertyWeightAllocation,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
BudgetAllocationWeightId,
BudgetProjectGroupAllocationId,
BudgetProjectId,
Weight,
IsPropertyWeightAllocation,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.BudgetAllocationWeightId,
SRC.BudgetProjectGroupAllocationId,
SRC.BudgetProjectId,
SRC.Weight,
SRC.IsPropertyWeightAllocation,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO


USE [TAPASUS_Budgeting]
GO

/****** Object:  StoredProcedure [dbo].[SyncTAPASUS_Budgeting]    Script Date: 06/05/2012 02:00:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncTAPASUS_Budgeting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncTAPASUS_Budgeting]
GO

USE [TAPASUS_Budgeting]
GO

/****** Object:  StoredProcedure [dbo].[SyncTAPASUS_Budgeting]    Script Date: 06/05/2012 02:00:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SyncTAPASUS_Budgeting]
AS


exec TAPASUS_Budgeting.dbo.SyncBudgetEmployeePayrollAllocationDetail
exec TAPASUS_Budgeting.dbo.SyncBudgetOverheadAllocation
exec TAPASUS_Budgeting.dbo.SyncBudgetOverheadAllocationDetail
exec TAPASUS_Budgeting.dbo.SyncBudgetProject
exec TAPASUS_Budgeting.dbo.SyncBudgetReportGroup
exec TAPASUS_Budgeting.dbo.SyncBudgetReportGroupDetail
exec TAPASUS_Budgeting.dbo.SyncBudgetStatus
exec TAPASUS_Budgeting.dbo.SyncBudgetTaxType
exec TAPASUS_Budgeting.dbo.SyncReforecastActualBilledPayroll
exec TAPASUS_Budgeting.dbo.SyncTaxType
exec TAPASUS_Budgeting.dbo.SyncBudget
exec TAPASUS_Budgeting.dbo.SyncBudgetEmployee
exec TAPASUS_Budgeting.dbo.SyncBudgetEmployeeFunctionalDepartment
exec TAPASUS_Budgeting.dbo.SyncBudgetEmployeePayrollAllocation


exec TAPASUS_Budgeting.dbo.SyncBudgetAllocation
exec TAPASUS_Budgeting.dbo.SyncBudgetAllocationDetail
exec TAPASUS_Budgeting.dbo.SyncBudgetProjectGroup
exec TAPASUS_Budgeting.dbo.SyncBudgetProjectGroupAllocation
exec TAPASUS_Budgeting.dbo.SyncBudgetAllocationWeight



GO





USE [ErpHR]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayGroup]') AND type in (N'U'))
DROP TABLE [dbo].[PayGroup]

GO
CREATE TABLE [dbo].[PayGroup](
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
	[PayGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [ErpHR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncPayGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncPayGroup]
GO
	
CREATE PROCEDURE [dbo].[SyncPayGroup]
AS

MERGE 	
	 [ErpHR].[dbo].[PayGroup] AS DST
USING 	
	[SERVER3].[ErpHR].[GMR].[PayGroupReplication] AS SRC ON
	DST.PayGroupId = SRC.PayGroupId
WHEN MATCHED AND	
	
DST.PayFrequencyId <> SRC.PayFrequencyId OR

DST.RegionId <> SRC.RegionId OR

DST.Code <> SRC.Code OR

DST.Name <> SRC.Name OR

DST.IsUnion <> SRC.IsUnion OR

DST.IsActive <> SRC.IsActive OR

DST.IsPartTime <> SRC.IsPartTime OR

DST.IsPayroll <> SRC.IsPayroll OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.PayFrequencyId = SRC.PayFrequencyId,
DST.RegionId = SRC.RegionId,
DST.Code = SRC.Code,
DST.Name = SRC.Name,
DST.IsUnion = SRC.IsUnion,
DST.IsActive = SRC.IsActive,
DST.IsPartTime = SRC.IsPartTime,
DST.IsPayroll = SRC.IsPayroll,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
PayGroupId,
PayFrequencyId,
RegionId,
Code,
Name,
IsUnion,
IsActive,
IsPartTime,
IsPayroll,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.PayGroupId,
SRC.PayFrequencyId,
SRC.RegionId,
SRC.Code,
SRC.Name,
SRC.IsUnion,
SRC.IsActive,
SRC.IsPartTime,
SRC.IsPayroll,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [ErpHR]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExternalSubRegion]') AND type in (N'U'))
DROP TABLE [dbo].[ExternalSubRegion]

GO
CREATE TABLE [dbo].[ExternalSubRegion](
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
	[ExternalSubRegionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [ErpHR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncExternalSubRegion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncExternalSubRegion]
GO
	
CREATE PROCEDURE [dbo].[SyncExternalSubRegion]
AS

MERGE 	
	 [ErpHR].[dbo].[ExternalSubRegion] AS DST
USING 	
	[SERVER3].[ErpHR].[GMR].[ExternalSubRegionReplication] AS SRC ON
	DST.ExternalSubRegionId = SRC.ExternalSubRegionId
WHEN MATCHED AND	
	
DST.ExternalRegionId <> SRC.ExternalRegionId OR

DST.Code <> SRC.Code OR

DST.Name <> SRC.Name OR

DST.IsActive <> SRC.IsActive OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.ExternalRegionId = SRC.ExternalRegionId,
DST.Code = SRC.Code,
DST.Name = SRC.Name,
DST.IsActive = SRC.IsActive,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
ExternalSubRegionId,
ExternalRegionId,
Code,
Name,
IsActive,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.ExternalSubRegionId,
SRC.ExternalRegionId,
SRC.Code,
SRC.Name,
SRC.IsActive,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [ErpHR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubDepartment]') AND type in (N'U'))
DROP TABLE [dbo].[SubDepartment]

GO
CREATE TABLE [dbo].[SubDepartment](
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
	[SubDepartmentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [ErpHR]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncSubDepartment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncSubDepartment]
GO
	
CREATE PROCEDURE [dbo].[SyncSubDepartment]
AS

MERGE 	
	 [ErpHR].[dbo].[SubDepartment] AS DST
USING 	
	[SERVER3].[ErpHR].[GMR].[SubDepartmentReplication] AS SRC ON
	DST.SubDepartmentId = SRC.SubDepartmentId
WHEN MATCHED AND	
	
DST.FunctionalDepartmentId <> SRC.FunctionalDepartmentId OR
						(DST.FunctionalDepartmentId is not null and SRC.FunctionalDepartmentId is null) OR 
						(DST.FunctionalDepartmentId is null and SRC.FunctionalDepartmentId is not null) OR

DST.Name <> SRC.Name OR

DST.Code <> SRC.Code OR

DST.IsActive <> SRC.IsActive OR

DST.InsertedDate <> SRC.InsertedDate OR

DST.UpdatedDate <> SRC.UpdatedDate OR

DST.UpdatedByStaffId <> SRC.UpdatedByStaffId 
THEN
	UPDATE
	SET
DST.FunctionalDepartmentId = SRC.FunctionalDepartmentId,
DST.Name = SRC.Name,
DST.Code = SRC.Code,
DST.IsActive = SRC.IsActive,
DST.InsertedDate = SRC.InsertedDate,
DST.UpdatedDate = SRC.UpdatedDate,
DST.UpdatedByStaffId = SRC.UpdatedByStaffId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
SubDepartmentId,
FunctionalDepartmentId,
Name,
Code,
IsActive,
InsertedDate,
UpdatedDate,
UpdatedByStaffId
)
VALUES
(
SRC.SubDepartmentId,
SRC.FunctionalDepartmentId,
SRC.Name,
SRC.Code,
SRC.IsActive,
SRC.InsertedDate,
SRC.UpdatedDate,
SRC.UpdatedByStaffId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO


USE [ErpHR]
GO

/****** Object:  StoredProcedure [dbo].[SyncErpHR]    Script Date: 06/05/2012 02:04:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncErpHR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncErpHR]
GO

USE [ErpHR]
GO

/****** Object:  StoredProcedure [dbo].[SyncErpHR]    Script Date: 06/05/2012 02:04:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SyncErpHR]
AS

EXEC dbo.SyncFunctionalDepartment
EXEC dbo.SyncLocation
EXEC dbo.SyncRegion

EXEC dbo.SyncPayGroup
EXEC dbo.SyncExternalSubRegion
EXEC dbo.SyncSubDepartment


GO


USE [GACS]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Team]') AND type in (N'U'))
DROP TABLE [dbo].[Team]

GO
CREATE TABLE [dbo].[Team](
[TeamID] [int] NOT NULL,
[SiteID] [int] NOT NULL,
[Name] [varchar] (255) NOT NULL,
[Description] [varchar] (500) NOT NULL,
[IsActive] [bit] NOT NULL,
[SDate] [datetime] NOT NULL,
[UDate] [datetime] NOT NULL,
CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[TeamId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [GACS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncTeam]
GO
	
CREATE PROCEDURE [dbo].[SyncTeam]
AS

MERGE 	
	 [GACS].[dbo].[Team] AS DST
USING 	
	[SERVER3].[GACS].[GMR].[TeamReplication] AS SRC ON
	DST.TeamId = SRC.TeamId
WHEN MATCHED AND	
	
DST.SiteID <> SRC.SiteID OR

DST.Name <> SRC.Name OR

DST.Description <> SRC.Description OR

DST.IsActive <> SRC.IsActive OR

DST.SDate <> SRC.SDate OR

DST.UDate <> SRC.UDate 
THEN
	UPDATE
	SET
DST.SiteID = SRC.SiteID,
DST.Name = SRC.Name,
DST.Description = SRC.Description,
DST.IsActive = SRC.IsActive,
DST.SDate = SRC.SDate,
DST.UDate = SRC.UDate
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
TeamID,
SiteID,
Name,
Description,
IsActive,
SDate,
UDate
)
VALUES
(
SRC.TeamID,
SRC.SiteID,
SRC.Name,
SRC.Description,
SRC.IsActive,
SRC.SDate,
SRC.UDate
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO



USE [GACS]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Site]') AND type in (N'U'))
DROP TABLE [dbo].[Site]

GO
CREATE TABLE [dbo].[Site](
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
	[SiteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [GACS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncSite]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncSite]
GO
	
CREATE PROCEDURE [dbo].[SyncSite]
AS

MERGE 	
	 [GACS].[dbo].[Site] AS DST
USING 	
	[SERVER3].[GACS].[GMR].[SiteReplication] AS SRC ON
	DST.SiteId = SRC.SiteId
WHEN MATCHED AND	
	
DST.Name <> SRC.Name OR

DST.Description <> SRC.Description OR

DST.AppPrefix <> SRC.AppPrefix OR

DST.IsActive <> SRC.IsActive OR

DST.SDate <> SRC.SDate OR

DST.UDate <> SRC.UDate OR

DST.StaffDetailURL <> SRC.StaffDetailURL OR

DST.FilterName <> SRC.FilterName OR
						(DST.FilterName is not null and SRC.FilterName is null) OR 
						(DST.FilterName is null and SRC.FilterName is not null) OR

DST.FilterPath <> SRC.FilterPath OR
						(DST.FilterPath is not null and SRC.FilterPath is null) OR 
						(DST.FilterPath is null and SRC.FilterPath is not null) OR

DST.DatabaseName <> SRC.DatabaseName OR

DST.SiteStatusId <> SRC.SiteStatusId 
THEN
	UPDATE
	SET
DST.Name = SRC.Name,
DST.Description = SRC.Description,
DST.AppPrefix = SRC.AppPrefix,
DST.IsActive = SRC.IsActive,
DST.SDate = SRC.SDate,
DST.UDate = SRC.UDate,
DST.StaffDetailURL = SRC.StaffDetailURL,
DST.FilterName = SRC.FilterName,
DST.FilterPath = SRC.FilterPath,
DST.DatabaseName = SRC.DatabaseName,
DST.SiteStatusId = SRC.SiteStatusId
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT(
SiteID,
Name,
Description,
AppPrefix,
IsActive,
SDate,
UDate,
StaffDetailURL,
FilterName,
FilterPath,
DatabaseName,
SiteStatusId
)
VALUES
(
SRC.SiteID,
SRC.Name,
SRC.Description,
SRC.AppPrefix,
SRC.IsActive,
SRC.SDate,
SRC.UDate,
SRC.StaffDetailURL,
SRC.FilterName,
SRC.FilterPath,
SRC.DatabaseName,
SRC.SiteStatusId
)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;

GO


USE [GACS]
GO

/****** Object:  StoredProcedure [dbo].[SyncGACS]    Script Date: 06/05/2012 02:06:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SyncGACS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SyncGACS]
GO

USE [GACS]
GO

/****** Object:  StoredProcedure [dbo].[SyncGACS]    Script Date: 06/05/2012 02:06:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SyncGACS]
AS

EXEC [dbo].[SyncJobCode]
EXEC [dbo].[SyncEntityMapping]
EXEC [dbo].[SyncEntity]
EXEC [dbo].[SyncStaff]

EXEC [dbo].[SyncTeam]
EXEC [dbo].[SyncSite]



GO


