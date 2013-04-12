/* Views to DROP

[Gdm].[GlobalRegionExpanded] - changed to a function

*/

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalRegionExpanded]'))
BEGIN
	DROP VIEW [Gdm].[GlobalRegionExpanded]
	PRINT ('View Gdm.GlobalRegionExpanded dropped.')
END
ELSE
BEGIN
	PRINT ('Cannot drop wiew Gdm.GlobalRegionExpanded as it does not exist.')
END

GO