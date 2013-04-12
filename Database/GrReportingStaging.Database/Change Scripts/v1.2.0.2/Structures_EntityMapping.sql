USE [GrReportingStaging]
GO

/****** Object:  Table [GACS].[EntityMapping]    Script Date: 02/19/2010 10:14:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [GACS].[EntityMapping](
	[ImportKey] [int] IDENTITY(1,1) NOT NULL,
	[ImportBatchId] [int] NOT NULL,
	[ImportDate] [datetime] NOT NULL,
	[EntityMappingId] [int] NOT NULL,
	[Source] [char](2) NOT NULL,
	[OriginalEntityRef] [char](7) NOT NULL,
	[LocalEntityRef] [char](6) NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EntityMapping_1] PRIMARY KEY CLUSTERED 
(
	[ImportKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_EntityMapping_OriginalEntityRef] UNIQUE NONCLUSTERED 
(
	[Source] ASC,
	[OriginalEntityRef] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [GACS].[EntityMapping] ADD  CONSTRAINT [DF_EntityMapping_ImportDate]  DEFAULT (getdate()) FOR [ImportDate]
GO

ALTER TABLE [GACS].[EntityMapping] ADD  CONSTRAINT [DF_EntityMapping_InsertedDate]  DEFAULT (getdate()) FOR [InsertedDate]
GO


 