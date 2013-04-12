
/****** Object:  View [dbo].[ProfitabilityType]    Script Date: 07/08/2010 09:56:42 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ProfitabilityType]'))
DROP VIEW [dbo].[ProfitabilityType]
GO

/****** Object:  View [dbo].[ProfitabilityType]    Script Date: 07/08/2010 09:56:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[ProfitabilityType]
AS

SELECT 1 as ProfitabilityTypeKey, 'Actual' as Name UNION ALL
SELECT 2, 'Budget' UNION ALL
SELECT 3, 'Reforecast'



GO

