USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[GetLocalNonLocalStr]    Script Date: 07/17/2012 22:09:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLocalNonLocalStr]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetLocalNonLocalStr]
GO

USE [GrReporting]
GO

/****** Object:  UserDefinedFunction [dbo].[GetLocalNonLocalStr]    Script Date: 07/17/2012 22:09:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********************************************************************************************************************
Description
		
		a.	The Local/Non-local field will read “local” when the allocation sub region and the originating sub-region are the same (except for
				China).
		b.	The Local/Non-local field will read “non-local” when the allocation sub region and originating sub-region differ (except for China).
		c.	For China, the four regions of China (Beijing, Shanghai, Tianjin and Chengdu) will be treated as local (i.e. if the allocation region
				is China and the originating region is Beijing, then the Local/Non-local field will be “local” however, if the allocation region
				is China and the originating region is New York, then the Local/Non-local field will be “non-local”).
	
History:	[yyyy-mm-dd]	: [Person]	:	[Details of changes made]

			2012-07-11		: Jgu	    :	create function [GetLocalNonLocalStr]  
	
		

**********************************************************************************************************************/

CREATE FUNCTION [dbo].[GetLocalNonLocalStr] 
(
		@OriginatingRegionName VARCHAR (50),
		@OriginatingSubRegionName VARCHAR(50),
		@AllocationRegionName VARCHAR (50),
		@AllocationSubRegionName VARCHAR(50)
)
RETURNS varchar(10) 
AS
BEGIN
	DECLARE @Result varchar(10) = 'Non-Local'

	IF
		(
			@OriginatingSubRegionName = @AllocationSubRegionName AND
			@AllocationRegionName <> 'China' AND
			@OriginatingRegionName <> 'China'
			
			--OriginatingRegion.SubRegionName = AllocationRegion.SubRegionName AND
			--AllocationRegion.RegionName <> 'China' AND
			--OriginatingRegion.RegionName <> 'China'
		)
		OR
		(
			@AllocationRegionName = 'China' AND
			@OriginatingRegionName = 'China'
		) 
		OR 
		(
			@OriginatingSubRegionName = 'Rock Center' AND @AllocationSubRegionName = 'New York'
		)
	  
	
		set	@Result = 'Local'
		
	else if
		(
			@OriginatingSubRegionName <> @AllocationSubRegionName AND
			@AllocationRegionName <> 'China' AND
			@OriginatingRegionName <> 'China'
		)
		OR
		(
			@OriginatingSubRegionName <> @AllocationSubRegionName AND
			@AllocationRegionName = 'China' AND
			@OriginatingRegionName <> 'China'
			
		)
		OR
		(
			@OriginatingSubRegionName <> @AllocationSubRegionName AND
			@AllocationRegionName <> 'China' AND
			@OriginatingRegionName = 'China'	
		)
	 
	 set @Result = 'Non-Local' 
	
	return @Result
	
	
		
	
END



GO


