 IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where COLUMN_NAME = 'IsUnallocatedOverhead' AND TABLE_NAME = 'GlobalReportingCorporateBudget')
	BEGIN
	ALTER TABLE BudgetingCorp.GlobalReportingCorporateBudget ADD IsUnallocatedOverhead bit NULL
	END
GO
ALTER TABLE BudgetingCorp.GlobalReportingCorporateBudget ALTER COLUMN AllocationSubRegionProjectRegionId Varchar(50) NULL
GO

--- Add table: [Gdm].[ReportingEntityGLAccountInclusion]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyEntityGLAccountInclusion_ImportDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyEntityGLAccountInclusion] DROP CONSTRAINT [DF_PropertyEntityGLAccountInclusion_ImportDate]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyEntityGLAccountInclusion_IsDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyEntityGLAccountInclusion] DROP CONSTRAINT [DF_PropertyEntityGLAccountInclusion_IsDeleted]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PropertyEntityGLAccountInclusion_UpdatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [Gdm].[PropertyEntityGLAccountInclusion] DROP CONSTRAINT [DF_PropertyEntityGLAccountInclusion_UpdatedDate]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[PropertyEntityGLAccountInclusion]') AND type in (N'U'))
DROP TABLE [Gdm].[PropertyEntityGLAccountInclusion]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Gdm].[PropertyEntityGLAccountInclusion](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[PropertyEntityGLAccountInclusionId] [int] NOT NULL,
	[PropertyEntityCode] [varchar](10) NOT NULL,
	[GLAccountCode] [varchar](12) NOT NULL,
	[SourceCode] [char](2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Gdm].[PropertyEntityGLAccountInclusion] ADD  CONSTRAINT [DF_PropertyEntityGLAccountInclusion_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [Gdm].[PropertyEntityGLAccountInclusion] ADD  CONSTRAINT [DF_PropertyEntityGLAccountInclusion_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [Gdm].[PropertyEntityGLAccountInclusion] ADD  CONSTRAINT [DF_PropertyEntityGLAccountInclusion_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

--------