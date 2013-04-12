------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageTypeActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageTypeActive]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ManageTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageType] Gl1
		INNER JOIN (
			SELECT 
				ManageTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ManageTypeId
		) t1 ON t1.ManageTypeId = Gl1.ManageTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ManageTypeId
)

GO

------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManagePropertyEntityActive]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ManagePropertyEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManagePropertyEntity] Gl1
		INNER JOIN (
			SELECT 
				ManagePropertyEntityId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManagePropertyEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ManagePropertyEntityId
		) t1 ON t1.ManagePropertyEntityId = Gl1.ManagePropertyEntityId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ManagePropertyEntityId
)

GO

------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManagePropertyDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManagePropertyDepartmentActive]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ManagePropertyDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManagePropertyDepartment] Gl1
		INNER JOIN (
			SELECT 
				ManagePropertyDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManagePropertyDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ManagePropertyDepartmentId
		) t1 ON t1.ManagePropertyDepartmentId = Gl1.ManagePropertyDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ManagePropertyDepartmentId
)

GO

------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateEntityActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageCorporateEntityActive]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ManageCorporateEntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageCorporateEntity] Gl1
		INNER JOIN (
			SELECT 
				ManageCorporateEntityId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageCorporateEntity]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ManageCorporateEntityId
		) t1 ON t1.ManageCorporateEntityId = Gl1.ManageCorporateEntityId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ManageCorporateEntityId
)

GO

------------------------------------

USE [GrReportingStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ManageCorporateDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ManageCorporateDepartmentActive]
GO

USE [GrReportingStaging]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Gdm].[ManageCorporateDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ManageCorporateDepartment] Gl1
		INNER JOIN (
			SELECT 
				ManageCorporateDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ManageCorporateDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ManageCorporateDepartmentId
		) t1 ON t1.ManageCorporateDepartmentId = Gl1.ManageCorporateDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ManageCorporateDepartmentId
)

GO

------------------------------------



 
 