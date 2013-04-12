USE GrReportingStaging
GO

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gdm].[ReportingCategorizationActive]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Gdm].[ReportingCategorizationActive]
GO

/*********************************************************************************************************************
Description
	This function returns the Import Keys of the active [Gdm].[ReportingCategorizationActive] records
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2011-09-08		: PKayongo	:	The function was created. 	
**********************************************************************************************************************/

CREATE FUNCTION [Gdm].[ReportingCategorizationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ReportingCategorization] Gl1
		INNER JOIN (
			SELECT 
				EntityTypeId,
				AllocationSubRegionGlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ReportingCategorization]
			WHERE	
				UpdatedDate <= @DataPriorToDate
			GROUP BY 
				EntityTypeId,
				AllocationSubRegionGlobalRegionId
		) t1 ON 
			t1.EntityTypeId = Gl1.EntityTypeId AND
			t1.AllocationSubRegionGlobalRegionId = Gl1.AllocationSubRegionGlobalRegionId AND
			t1.UpdatedDate = Gl1.UpdatedDate
	WHERE 
		Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY 
		Gl1.EntityTypeId,
		Gl1.AllocationSubRegionGlobalRegionId
)

GO