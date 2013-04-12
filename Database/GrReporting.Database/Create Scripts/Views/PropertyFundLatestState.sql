 USE [GrReporting]
GO

/****** Object:  View [dbo].[PropertyFundLatestState]    Script Date: 01/23/2012 17:01:20 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PropertyFundLatestState]'))
DROP VIEW [dbo].[PropertyFundLatestState]
GO

USE [GrReporting]
GO

/****** Object:  View [dbo].[PropertyFundLatestState]    Script Date: 01/23/2012 17:01:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE VIEW [dbo].[PropertyFundLatestState]
AS

/*********************************************************************************************************************
Description
	This view returns all records in the property fund dimension, 
	as well as the latest property fund state for that GDM item. 
	This allows us to handle property fund name and property fund type
	changes correctly.
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

2012-01-18	Sarah-Marie Nothling	: Created View
**********************************************************************************************************************/

SELECT
	PropertyFund.PropertyFundKey AS 'PropertyFundKey',
	PropertyFund.PropertyFundId AS 'PropertyFundId',
	PropertyFund.SnapshotId AS 'PropertyFundSnapshotId',
	MaxPropertyFundRecord.PropertyFundName AS 'LatestPropertyFundName',
	MaxPropertyFundRecord.PropertyFundType AS 'LatestPropertyFundType'
FROM
	dbo.PropertyFund
	INNER JOIN (
		SELECT
			PropertyFundId,
			SnapshotId,
			MAX(EndDate) AS 'MaxPropertyFundEndDate'
		FROM 
			dbo.PropertyFund
		GROUP BY 
			PropertyFundId,
			SnapshotId
		) MaxPropertyFund ON
		PropertyFund.PropertyFundId = MaxPropertyFund.PropertyFundId AND
		PropertyFund.SnapshotId = MaxPropertyFund.SnapshotId
	INNER JOIN dbo.PropertyFund MaxPropertyFundRecord ON
		MaxPropertyFund.PropertyFundId = MaxPropertyFundRecord.PropertyFundId AND
		MaxPropertyFund.SnapshotId = MaxPropertyFundRecord.SnapshotId AND
		MaxPropertyFund.MaxPropertyFundEndDate = MaxPropertyFundRecord.EndDate







GO


