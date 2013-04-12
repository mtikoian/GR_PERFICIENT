USE GDM
GO
/*
EntityType: populate with correct data 
Relatedfund: rename to RelatedFund and populate
PropertyFund: populate with correct data 
ProjectRegion
GlobalProjectRegion			
PropertyFundMapping: add foreign key reference to PropertyFund
					 Add column & foregnkey reference to ActivityType (allow null)
					 
*/
--DROP VIEWS
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PropertyFund]'))
DROP VIEW [dbo].[PropertyFund]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProjectRegion]'))
DROP VIEW [dbo].[ProjectRegion]
GO


IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'EntityType')
	BEGIN
	CREATE TABLE [dbo].[EntityType](
		[EntityTypeId] [int] IDENTITY(1,1) NOT NULL,
		[Name] [varchar](50) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[Version] [timestamp] NOT NULL,
		[InsertedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
	 CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED 
	(
		[EntityTypeId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[EntityType] ADD  CONSTRAINT [DF_EntityType_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
	ALTER TABLE [dbo].[EntityType] ADD  CONSTRAINT [DF_EntityType_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
	END
GO
IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'RelatedFund')
	BEGIN
	CREATE TABLE [dbo].[RelatedFund](
		[RelatedFundId] [int] IDENTITY(1,1) NOT NULL,
		[Name] [varchar](100) NOT NULL,
		[Version] [timestamp] NOT NULL,
		[InsertedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
	 CONSTRAINT [PK_RelatedFund] PRIMARY KEY CLUSTERED 
	(
		[RelatedFundId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[RelatedFund] ADD  CONSTRAINT [DF_RelatedFund_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]

	ALTER TABLE [dbo].[RelatedFund] ADD  CONSTRAINT [DF_RelatedFund_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
	END
GO


IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'GlobalProjectRegion')
	BEGIN
	
	CREATE TABLE [dbo].[GlobalProjectRegion](
	[GlobalProjectRegionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Version] [timestamp] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedByStaffId] [int] NOT NULL,
	CONSTRAINT [PK_GlobalProjectRegion] PRIMARY KEY CLUSTERED 
	(
	[GlobalProjectRegionId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]


	ALTER TABLE [dbo].[GlobalProjectRegion] ADD  CONSTRAINT [DF_GlobalProjectRegion_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]

	ALTER TABLE [dbo].[GlobalProjectRegion] ADD  CONSTRAINT [DF_GlobalProjectRegion_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]

	END
GO

IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'ProjectRegion')
	BEGIN
	CREATE TABLE [dbo].[ProjectRegion](
		[ProjectRegionId] [int] IDENTITY(1,1) NOT NULL,
		[GlobalProjectRegionId] [int] NOT NULL,
		[Name] [varchar](100) NOT NULL,
		[Version] [timestamp] NOT NULL,
		[InsertedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
	 CONSTRAINT [PK_ProjectRegion] PRIMARY KEY CLUSTERED 
	(
		[ProjectRegionId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[ProjectRegion]  WITH CHECK ADD  CONSTRAINT [FK_ProjectRegion_GlobalProjectRegion] FOREIGN KEY([GlobalProjectRegionId])
	REFERENCES [dbo].[GlobalProjectRegion] ([GlobalProjectRegionId])

	ALTER TABLE [dbo].[ProjectRegion] CHECK CONSTRAINT [FK_ProjectRegion_GlobalProjectRegion]

	ALTER TABLE [dbo].[ProjectRegion] ADD  CONSTRAINT [DF_ProjectRegion_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]

	ALTER TABLE [dbo].[ProjectRegion] ADD  CONSTRAINT [DF_ProjectRegion_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
	END
	
GO



IF NOT EXISTS(Select * From INFORMATION_SCHEMA.TABLES Where TABLE_NAME = 'PropertyFund')
	BEGIN
	CREATE TABLE [dbo].[PropertyFund](
		[PropertyFundId] [int] IDENTITY(1,1) NOT NULL,
		[RelatedFundId] [int] NULL,
		[EntityTypeId] [int] NOT NULL,
		[ProjectRegionId] [int] NOT NULL,
		[Name] [varchar](100) NOT NULL,
		[IsReportingEntity] [bit] NOT NULL DEFAULT 1,
		[IsPropertyFund] [bit] NOT NULL DEFAULT 1,
		[Version] [timestamp] NOT NULL,
		[InsertedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
		[UpdatedByStaffId] [int] NOT NULL,
	 CONSTRAINT [PK_PropertyFund] PRIMARY KEY CLUSTERED 
	(
		[PropertyFundId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[PropertyFund]  WITH CHECK ADD  CONSTRAINT [FK_PropertyFund_ProjectRegion] FOREIGN KEY([ProjectRegionId])
	REFERENCES [dbo].[ProjectRegion] ([ProjectRegionId])

	ALTER TABLE [dbo].[PropertyFund] CHECK CONSTRAINT [FK_PropertyFund_ProjectRegion]

	ALTER TABLE [dbo].[PropertyFund]  WITH CHECK ADD  CONSTRAINT [FK_PropertyFund_EntityType] FOREIGN KEY([EntityTypeId])
	REFERENCES [dbo].[EntityType] ([EntityTypeId])

	ALTER TABLE [dbo].[PropertyFund] CHECK CONSTRAINT [FK_PropertyFund_EntityType]

	ALTER TABLE [dbo].[PropertyFund]  WITH CHECK ADD  CONSTRAINT [FK_PropertyFund_RelatedFund] FOREIGN KEY([RelatedFundId])
	REFERENCES [dbo].[RelatedFund] ([RelatedFundId])

	ALTER TABLE [dbo].[PropertyFund] CHECK CONSTRAINT [FK_PropertyFund_RelatedFund]

	ALTER TABLE [dbo].[PropertyFund] ADD  CONSTRAINT [DF_PropertyFund_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]

	ALTER TABLE [dbo].[PropertyFund] ADD  CONSTRAINT [DF_PropertyFund_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]

	ALTER TABLE dbo.ProjectRegion ADD CONSTRAINT FK_ProjectRegion_GlobalProjectRegion FOREIGN KEY (GlobalProjectRegionId) 
	REFERENCES dbo.GlobalProjectRegion (GlobalProjectRegionId) ON UPDATE  NO ACTION ON DELETE  NO ACTION 

	END
GO

IF NOT EXISTS(Select * From INFORMATION_SCHEMA.COLUMNS Where 
		TABLE_NAME = 'PropertyFundMapping' AND COLUMN_NAME = 'ActivityTypeId')
	BEGIN
	ALTER TABLE Gr.PropertyFundMapping ADD ActivityTypeId Int NULL
	END
GO
IF EXISTS(Select * From sysobjects Where Name = 'FK_PropertyFundMapping_ActivityType')
	BEGIN
	ALTER TABLE dbo.PropertyFundMapping DROP CONSTRAINT FK_PropertyFundMapping_ActivityType

	ALTER TABLE dbo.PropertyFundMapping ADD CONSTRAINT
		FK_PropertyFundMapping_ActivityType FOREIGN KEY
		(
		ActivityTypeId
		) REFERENCES GL.ActivityType
		(
		ActivityTypeId
		) ON UPDATE  NO ACTION 
		 ON DELETE  NO ACTION 

	END

GO
GO

/****** Object:  Index [IX_Unique]    Script Date: 04/16/2010 10:40:44 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Gr].[PropertyFundMapping]') AND name = N'IX_Unique')
DROP INDEX [IX_Unique] ON [Gr].[PropertyFundMapping] WITH ( ONLINE = OFF )
GO



CREATE UNIQUE NONCLUSTERED INDEX [IX_Unique] ON [Gr].[PropertyFundMapping] 
(
	[SourceCode] ASC,
	[PropertyFundCode] ASC,
	[ActivityTypeId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
