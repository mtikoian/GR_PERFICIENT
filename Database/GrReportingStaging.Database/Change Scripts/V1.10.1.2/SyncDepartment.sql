USE [GDM]
GO
/****** Object:  StoredProcedure [dbo].[SyncDepartment]    Script Date: 07/18/2012 21:55:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SyncDepartment]
AS

MERGE 
	GDM.dbo.Department AS DST 
USING 
	SERVER3.GDM.GMR.DepartmentReplication AS SRC ON
		DST.DepartmentCode = SRC.DepartmentCode AND
		DST.Source = SRC.Source
WHEN
	MATCHED AND
	
		DST.DepartmentTypeCode <> SRC.DepartmentTypeCode OR 
		(DST.DepartmentTypeCode IS NULL AND SRC.DepartmentTypeCode IS NOT NULL) OR
		(DST.DepartmentTypeCode IS NOT NULL AND SRC.DepartmentTypeCode IS NULL) OR
		
		DST.Description <> SRC.Description OR 
		(DST.Description IS NULL AND SRC.Description IS NOT NULL) OR
		(DST.Description IS NOT NULL AND SRC.Description IS NULL) OR
		
		DST.FunctionalDepartmentId <> SRC.FunctionalDepartmentId OR 
		(DST.FunctionalDepartmentId IS NULL AND SRC.FunctionalDepartmentId IS NOT NULL) OR
		(DST.FunctionalDepartmentId IS NOT NULL AND SRC.FunctionalDepartmentId IS NULL) OR
		
		DST.IsActive <> SRC.IsActive OR
		(DST.IsActive IS NULL AND SRC.IsActive IS NOT NULL) OR
		(DST.IsActive IS NOT NULL AND SRC.IsActive IS NULL) OR
		 
		DST.IsTsCost <> SRC.IsTsCost OR 
		(DST.IsTsCost IS NULL AND SRC.IsTsCost IS NOT NULL) OR
		(DST.IsTsCost IS NOT NULL AND SRC.IsTsCost IS NULL) OR
		
		DST.IsDeleted <> SRC.IsDeleted OR 
		(DST.IsDeleted IS NULL AND SRC.IsDeleted IS NOT NULL) OR
		(DST.IsDeleted IS NOT NULL AND SRC.IsDeleted IS NULL) OR
		
		DST.LastDate <> SRC.LastDate OR 
		(DST.LastDate IS NULL AND SRC.LastDate IS NOT NULL) OR
		(DST.LastDate IS NOT NULL AND SRC.LastDate IS NULL) OR
		
		DST.MRIUserID <> SRC.MRIUserID OR 
		(DST.MRIUserID IS NULL AND SRC.MRIUserID IS NOT NULL) OR
		(DST.MRIUserID IS NOT NULL AND SRC.MRIUserID IS NULL) OR
			 
		DST.UpdatedDate <> SRC.UpdatedDate OR 
		(DST.UpdatedDate IS NULL AND SRC.UpdatedDate IS NOT NULL) OR
		(DST.UpdatedDate IS NOT NULL AND SRC.UpdatedDate IS NULL) OR
		
		DST.UseInServiceCharge <> SRC.UseInServiceCharge OR
		(DST.UseInServiceCharge IS NULL AND SRC.UseInServiceCharge IS NOT NULL) OR
		(DST.UseInServiceCharge IS NOT NULL AND SRC.UseInServiceCharge IS NULL)
THEN
UPDATE
	SET
		
		DST.DepartmentTypeCode = SRC.DepartmentTypeCode,
		DST.Description = SRC.Description,
		DST.FunctionalDepartmentId = SRC.FunctionalDepartmentId,
		DST.IsActive = SRC.IsActive,
		DST.IsTsCost = SRC.IsTsCost,
		DST.IsDeleted = SRC.IsDeleted,		
		DST.LastDate = SRC.LastDate,
		DST.MRIUserID = SRC.MRIUserID,
		DST.UpdatedDate = SRC.UpdatedDate,
		DST.UseInServiceCharge = SRC.UseInServiceCharge
WHEN
	NOT MATCHED BY TARGET
THEN
	INSERT
	(
		DepartmentCode,
		DepartmentTypeCode,
		Description,
		FunctionalDepartmentId,
		IsActive,
		IsTsCost,
		LastDate,
		MRIUserID,
		Source,
		UpdatedDate,
		UseInServiceCharge,
		IsDeleted
	)
	VALUES
	(
		SRC.DepartmentCode,
		SRC.DepartmentTypeCode,
		SRC.Description,
		SRC.FunctionalDepartmentId,
		SRC.IsActive,
		SRC.IsTsCost,
		SRC.LastDate,
		SRC.MRIUserID,
		SRC.Source,
		SRC.UpdatedDate,
		SRC.UseInServiceCharge,
		SRC.IsDeleted
	)
WHEN
	NOT MATCHED BY SOURCE
 THEN
	DELETE;


