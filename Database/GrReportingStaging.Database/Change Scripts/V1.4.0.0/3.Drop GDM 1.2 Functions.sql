-------------------------------------
-- Gdm.AllocationRegionMappingActive
-------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:49:21
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[AllocationRegionMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[AllocationRegionMappingActive]
GO

------------------------------
-- Gdm.GlAccountMappingActive
------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:50:04
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlAccountMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [Gdm].[GlAccountMappingActive]
GO

-----------------------------------
-- Gdm.GlobalAccountCategoryActive
-----------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:50:41
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAccountCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalAccountCategoryActive]
GO

-------------------------------------------
-- Gdm.GlobalAllocationRegionMappingActive
-------------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:52:42
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalAllocationRegionMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalAllocationRegionMappingActive]
GO

----------------------------------------
-- Gdm.GlobalFunctionalDepartmentActive
----------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:55:28
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalFunctionalDepartmentActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalFunctionalDepartmentActive]
GO

-----------------------------
-- Gdm.GlobalGlAccountActive
-----------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:55:56
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalGlAccountActive]
GO

----------------------------------------------
-- Gdm.GlobalGlAccountCategoryHierarchyActive
----------------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:56:14
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHierarchyActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalGlAccountCategoryHierarchyActive]
GO

---------------------------------------------------
-- Gdm.GlobalGlAccountCategoryHierarchyGroupActive
---------------------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:56:32
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[GlobalGlAccountCategoryHierarchyGroupActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[GlobalGlAccountCategoryHierarchyGroupActive]
GO

------------------------------------
-- Gdm.MajorGlAccountCategoryActive
------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:57:33
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MajorGlAccountCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[MajorGlAccountCategoryActive]
GO

------------------------------------
-- Gdm.MinorGlAccountCategoryActive
------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:57:47
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[MinorGlAccountCategoryActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[MinorGlAccountCategoryActive]
GO

--------------------------------------
-- Gdm.OriginatingRegionMappingActive
--------------------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:58:52
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[OriginatingRegionMappingActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[OriginatingRegionMappingActive]
GO

---------------------------
-- Gdm.ProjectRegionActive
---------------------------

USE [GrReportingStaging]
GO

-- Script Date: 07/02/2010 10:59:17
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ProjectRegionActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ProjectRegionActive]
GO
