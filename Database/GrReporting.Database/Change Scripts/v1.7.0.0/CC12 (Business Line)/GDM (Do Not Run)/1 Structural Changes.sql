 USE GDM
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

---------------------------------------------
/* Create BusinessLine Table */
---------------------------------------------

CREATE TABLE [dbo].BusinessLine
(
	BusinessLineId INT IDENTITY NOT FOR REPLICATION NOT NULL,
	[Name] VARCHAR (50) NOT NULL,
	IsActive BIT NOT NULL,
	Version TIMESTAMP NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
	
	CONSTRAINT [PK_BusinessLine] PRIMARY KEY CLUSTERED
	(
		[BusinessLineId] ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	 
	 CONSTRAINT [IX_BusinessLine_Name] UNIQUE NONCLUSTERED 
	(
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
	
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE BusinessLine 
	ADD  CONSTRAINT [DF_BusinessLine_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE BusinessLine 
	ADD  CONSTRAINT [DF_BusinessLine_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE BusinessLine ADD  
	CONSTRAINT [DF_BusinessLine_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

-- Create the Snapshot BusinessLine table

CREATE TABLE [dbo].SnapshotBusinessLine
(
	SnapshotId INT NOT NULL,
	BusinessLineId INT,
	[Name] VARCHAR (50) NOT NULL,
	IsActive BIT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL
	
	CONSTRAINT [PK_SnapshotBusinessLine] PRIMARY KEY CLUSTERED
	(
		SnapshotId ASC,
		BusinessLineId ASC
	) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	 
	 CONSTRAINT [IX_SnapshotBusinessLine_Name] UNIQUE NONCLUSTERED 
	(
		[Name] ASC,
		SnapshotId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]
	
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE dbo.SnapshotBusinessLine WITH CHECK ADD CONSTRAINT [FK_SnapshotBusinessLine_BusinessLine] FOREIGN KEY(BusinessLineId)
REFERENCES dbo.BusinessLine (BusinessLineId)

ALTER TABLE dbo.SnapshotBusinessLine CHECK CONSTRAINT [FK_SnapshotBusinessLine_BusinessLine]
---------------------------------------------
/* Create ActivityTypeBusinessLine Table */
---------------------------------------------

CREATE TABLE [dbo].ActivityTypeBusinessLine
(
	ActivityTypeBusinessLineId INT IDENTITY NOT FOR REPLICATION NOT NULL,
	ActivityTypeId INT NOT NULL,
	BusinessLineId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsActive BIT NOT NULL
	
	CONSTRAINT [PK_ActivityTypeBusinessLine] PRIMARY KEY CLUSTERED 
	(
		ActivityTypeBusinessLineId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	
	CONSTRAINT [IX_ActivityTypeBusinessLine_ActivityTypeId] UNIQUE NONCLUSTERED 
	(
		ActivityTypeId ASC,
		BusinessLineId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE ActivityTypeBusinessLine  WITH CHECK ADD  CONSTRAINT [FK_ActivityTypeBusinessLine_ActivityType] FOREIGN KEY(ActivityTypeId)
REFERENCES ActivityType (ActivityTypeId)
GO

ALTER TABLE ActivityTypeBusinessLine CHECK CONSTRAINT [FK_ActivityTypeBusinessLine_ActivityType]
GO

ALTER TABLE ActivityTypeBusinessLine  WITH CHECK ADD  CONSTRAINT [FK_ActivityTypeBusinessLine_BusinessLine] FOREIGN KEY(BusinessLineId)
REFERENCES BusinessLine (BusinessLineId)
GO

ALTER TABLE ActivityTypeBusinessLine CHECK CONSTRAINT [FK_ActivityTypeBusinessLine_BusinessLine]
GO

ALTER TABLE ActivityTypeBusinessLine ADD  CONSTRAINT [DF_ActivityTypeBusinessLine_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE ActivityTypeBusinessLine ADD  CONSTRAINT [DF_ActivityTypeBusinessLine_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO

ALTER TABLE ActivityTypeBusinessLine ADD  CONSTRAINT [DF_ActivityTypeBusinessLine_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

--Create the Snapshot ActivityTypeBusinessLine table

CREATE TABLE [dbo].SnapshotActivityTypeBusinessLine
(
	SnapshotId INT,
	ActivityTypeBusinessLineId INT IDENTITY,
	ActivityTypeId INT NOT NULL,
	BusinessLineId INT NOT NULL,
	InsertedDate DATETIME NOT NULL,
	UpdatedDate DATETIME NOT NULL,
	UpdatedByStaffId INT NOT NULL,
	IsActive BIT NOT NULL
	
	CONSTRAINT [PK_SnapshotActivityTypeBusinessLine] PRIMARY KEY CLUSTERED 
	(
		SnapshotId ASC,
		ActivityTypeBusinessLineId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	
	CONSTRAINT [IX_SnapshotActivityTypeBusinessLine_ActivityTypeId] UNIQUE NONCLUSTERED 
	(
		SnapshotId ASC,
		ActivityTypeId ASC,
		BusinessLineId ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE dbo.SnapshotActivityTypeBusinessLine WITH CHECK ADD CONSTRAINT [FK_SnapshotActivityTypeBusinessLine_SnapshotActivityType] FOREIGN KEY(ActivityTypeId, SnapshotId)
REFERENCES dbo.SnapshotActivityType (ActivityTypeId, SnapshotId)
GO

ALTER TABLE dbo.SnapshotActivityTypeBusinessLine CHECK CONSTRAINT [FK_SnapshotActivityTypeBusinessLine_SnapshotActivityType]
GO

ALTER TABLE dbo.SnapshotActivityTypeBusinessLine WITH CHECK ADD CONSTRAINT [FK_SnapshotActivityTypeBusinessLine_SnapshotBusinessLine] FOREIGN KEY(SnapshotId, BusinessLineId)
REFERENCES dbo.SnapshotBusinessLine (SnapshotId, BusinessLineId)
GO

ALTER TABLE dbo.SnapshotActivityTypeBusinessLine CHECK CONSTRAINT [FK_SnapshotActivityTypeBusinessLine_SnapshotBusinessLine]
GO
  