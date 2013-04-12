

------------------------

USE [GrReporting]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_ActivityType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_AllocationRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Calendar]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Calendar]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Currency]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Currency]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_FunctionalDepartment]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_FunctionalDepartment]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_GlAccount]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_OriginatingRegion]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Overhead]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Overhead]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_PropertyFund]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Reimbursable]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Reimbursable]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProfitabilityActualArchive_Source]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FK_ProfitabilityActualArchive_Source]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKDevelopmentGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKEUPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKGlobalGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKUSPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]'))
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Overh__07CDACD6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [DF__Profitabi__Overh__07CDACD6]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Profitabi__Inser__08C1D10F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProfitabilityActualArchive] DROP CONSTRAINT [DF__Profitabi__Inser__08C1D10F]
END

GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[ProfitabilityActualArchive]    Script Date: 10/27/2010 11:46:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityActualArchive]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitabilityActualArchive]
GO

USE [GrReporting]
GO

/****** Object:  Table [dbo].[ProfitabilityActualArchive]    Script Date: 10/27/2010 11:46:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ProfitabilityActualArchive](
	[ProfitabilityActualArchiveKey] [bigint] NOT NULL,
	[CalendarKey] [int] NOT NULL,
	[GlAccountKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[FunctionalDepartmentKey] [int] NOT NULL,
	[ReimbursableKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[PropertyFundKey] [int] NOT NULL,
	[OriginatingRegionKey] [int] NOT NULL,
	[AllocationRegionKey] [int] NOT NULL,
	[LocalCurrencyKey] [int] NOT NULL,
	[LocalActual] [money] NOT NULL,
	[ReferenceCode] [varchar](100) NOT NULL,
	[ProfitabilityActualSourceTableId] [int] NOT NULL,
	[EUCorporateGlAccountCategoryKey] [int] NULL,
	[USPropertyGlAccountCategoryKey] [int] NULL,
	[USFundGlAccountCategoryKey] [int] NULL,
	[EUPropertyGlAccountCategoryKey] [int] NULL,
	[USCorporateGlAccountCategoryKey] [int] NULL,
	[DevelopmentGlAccountCategoryKey] [int] NULL,
	[EUFundGlAccountCategoryKey] [int] NULL,
	[GlobalGlAccountCategoryKey] [int] NULL,
	[EntryDate] [datetime] NULL,
	[User] [nvarchar](20) NULL,
	[Description] [nvarchar](60) NULL,
	[AdditionalDescription] [nvarchar](4000) NULL,
	[OriginatingRegionCode] [char](6) NULL,
	[PropertyFundCode] [char](12) NULL,
	[FunctionalDepartmentCode] [char](15) NULL,
	[OverheadKey] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[ReasonForArchival] [varchar](256) NOT NULL,
 CONSTRAINT [PK_ProfitabilityActualArchive] PRIMARY KEY NONCLUSTERED 
(
	[ProfitabilityActualArchiveKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType] FOREIGN KEY([ActivityTypeKey])
REFERENCES [dbo].[ActivityType] ([ActivityTypeKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_ActivityType]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion] FOREIGN KEY([AllocationRegionKey])
REFERENCES [dbo].[AllocationRegion] ([AllocationRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_AllocationRegion]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Calendar] FOREIGN KEY([CalendarKey])
REFERENCES [dbo].[Calendar] ([CalendarKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Calendar]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Currency] FOREIGN KEY([LocalCurrencyKey])
REFERENCES [dbo].[Currency] ([CurrencyKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Currency]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_FunctionalDepartment] FOREIGN KEY([FunctionalDepartmentKey])
REFERENCES [dbo].[FunctionalDepartment] ([FunctionalDepartmentKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_FunctionalDepartment]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount] FOREIGN KEY([GlAccountKey])
REFERENCES [dbo].[GlAccount] ([GlAccountKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_GlAccount]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion] FOREIGN KEY([OriginatingRegionKey])
REFERENCES [dbo].[OriginatingRegion] ([OriginatingRegionKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_OriginatingRegion]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Overhead] FOREIGN KEY([OverheadKey])
REFERENCES [dbo].[Overhead] ([OverheadKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Overhead]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable] FOREIGN KEY([ProfitabilityActualSourceTableId])
REFERENCES [dbo].[ProfitabilityActualSourceTable] ([ProfitabilityActualSourceTableId])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_ProfitabilityActualSourceTable]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund] FOREIGN KEY([PropertyFundKey])
REFERENCES [dbo].[PropertyFund] ([PropertyFundKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_PropertyFund]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Reimbursable] FOREIGN KEY([ReimbursableKey])
REFERENCES [dbo].[Reimbursable] ([ReimbursableKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Reimbursable]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FK_ProfitabilityActualArchive_Source] FOREIGN KEY([SourceKey])
REFERENCES [dbo].[Source] ([SourceKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FK_ProfitabilityActualArchive_Source]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([DevelopmentGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKDevelopmentGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([EUCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKEUCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([EUFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKEUFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([EUPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKEUPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([GlobalGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKGlobalGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([USCorporateGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKUSCorporateGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([USFundGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKUSFundGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive]  WITH CHECK ADD  CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory] FOREIGN KEY([USPropertyGlAccountCategoryKey])
REFERENCES [dbo].[GlAccountCategory] ([GlAccountCategoryKey])
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] CHECK CONSTRAINT [FKUSPropertyGlAccountCategoryKey_ProfitabilityActualArchive_GlAccountCategory]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] ADD  DEFAULT ((-1)) FOR [OverheadKey]
GO

ALTER TABLE [dbo].[ProfitabilityActualArchive] ADD  DEFAULT (getdate()) FOR [InsertedDate]
GO


---------------------------------------------------------------