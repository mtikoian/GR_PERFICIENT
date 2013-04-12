/*
1. Gdm.ConsolidationRegionCorporateDepartmentActive
2. Gdm.ConsolidationRegionPropertyEntityActive
3. Gdm.ConsolidationSubRegionActive
4. Gdm.ConsolidationRegionActive
*/ 

USE GrReportingStaging
GO
 
/*
1. Gdm.ConsolidationRegionCorporateDepartmentActive
*/ 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].ConsolidationRegionCorporateDepartmentActive') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[BudgetExchangeRateActive]
GO

 CREATE FUNCTION [Gdm].ConsolidationRegionCorporateDepartmentActive
	(@DatePriorToDate DATETIME)
	
RETURNS TABLE as RETURN
(
	SELECT
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].ConsolidationRegionCorporateDepartment Gl1
		INNER JOIN (
			SELECT
				ConsolidationRegionCorporateDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM
				[Gdm].ConsolidationRegionCorporateDepartment
			WHERE
				UpdatedDate <= @DatePriorToDate
			GROUP BY
				ConsolidationRegionCorporateDepartmentId
		) t1 ON t1.ConsolidationRegionCorporateDepartmentId = Gl1.ConsolidationRegionCorporateDepartmentId AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DatePriorToDate
	GROUP BY
		Gl1.ConsolidationRegionCorporateDepartmentId
)

GO

/*
2. Gdm.ConsolidationRegionPropertyEntityActive
*/ 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].ConsolidationRegionPropertyEntityActive') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[BudgetExchangeRateActive]
GO

CREATE FUNCTION [Gdm].ConsolidationRegionPropertyEntityActive
	(@DatePriorToDate DATETIME)
	
RETURNS TABLE as RETURN
(
	SELECT
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].ConsolidationRegionPropertyEntity Gl1
		INNER JOIN (
			SELECT
				ConsolidationRegionPropertyEntityId,
				MAX(UpdatedDate) UpdatedDate
			FROM
				[Gdm].ConsolidationRegionPropertyEntity
			WHERE
				UpdatedDate <= @DatePriorToDate
			GROUP BY
				ConsolidationRegionPropertyEntityId
		) t1 ON t1.ConsolidationRegionPropertyEntityId = Gl1.ConsolidationRegionPropertyEntityId AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DatePriorToDate
	GROUP BY
		Gl1.ConsolidationRegionPropertyEntityId
)

GO

/*
3. Gdm.ConsolidationSubRegionActive
*/ 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationSubRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ConsolidationSubRegionActive]
GO

CREATE FUNCTION [Gdm].[ConsolidationSubRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ConsolidationSubRegion] Gl1
		INNER JOIN (
			SELECT 
				ConsolidationSubRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ConsolidationSubRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ConsolidationSubRegionGlobalRegionId
		) t1 ON t1.ConsolidationSubRegionGlobalRegionId = Gl1.ConsolidationSubRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ConsolidationSubRegionGlobalRegionId
)

GO

/*
4. Gdm.ConsolidationRegionActive
*/ 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ConsolidationRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[ConsolidationRegionActive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ConsolidationRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ConsolidationRegion] Gl1
		INNER JOIN (
			SELECT 
				ConsolidationRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ConsolidationRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ConsolidationRegionGlobalRegionId
		) t1 ON t1.ConsolidationRegionGlobalRegionId = Gl1.ConsolidationRegionGlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ConsolidationRegionGlobalRegionId
)

GO