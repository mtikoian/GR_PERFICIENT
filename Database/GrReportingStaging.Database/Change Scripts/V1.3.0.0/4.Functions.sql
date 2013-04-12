USE [GrReportingStaging]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSplit]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[GetSplit]
	(@str varchar(1024))
RETURNS @table TABLE 
	(item varchar(100))
AS
BEGIN   

	declare @start int
	set @start = 0
	WHILE (charindex(',', @str, @start) > 0)
	BEGIN
		if substring(@str, charindex(',', @str, @start) - 1, 1) = '\' begin
			set @start = charindex(',', @str, @start) + 1
		end else begin
			INSERT @table
			SELECT replace(left(@str, charindex(',', @str, @start) - 1), '\,', ',')

			set @str = stuff(@str, 1, charindex(',', @str, @start), '')
			set @start = 0
		end
	END
	INSERT @table
	SELECT replace(@str, '\,', ',')
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetLongestWord]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetLongestWord]
(
	@InputString Varchar(255)
)
RETURNS int
AS

BEGIN
DECLARE @Name Varchar(50),
		@Output Varchar(50),
		@SpaceIndex Int,
		@ExitCount Int
DECLARE @Rows TABLE(Portion Varchar(50) NOT NULL)


SET @Name = @InputString
SET @SpaceIndex = PATINDEX('% %',@Name)
SET @ExitCount = 1

WHILE (@SpaceIndex > 0 AND @ExitCount <= 5)
	BEGIN
	--print '@SpaceIndex'
	--print @SpaceIndex

	
	INSERT INTO  @Rows
	(Portion)
	Select SUBSTRING(@Name,0,@SpaceIndex)
	
	--print @Name
	--Select * From @Rows
	
	SET  @Name = SUBSTRING(@Name,@SpaceIndex+1, LEN(@Name)-@SpaceIndex)
	
	--print @Name
	
	SET @SpaceIndex = PATINDEX('% %',@Name)
	
	SET @ExitCount = @ExitCount + 1
	END

INSERT INTO  @Rows
(Portion)
Select @Name


RETURN (Select MAX(LEN(Portion)) From @Rows)

END
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalAccountCategoryActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [Gdm].[GlobalAccountCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[GlobalAccountCategory] Gl1
		INNER JOIN (
		Select 
				GlobalAccountCategoryId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[GlobalAccountCategory]
		Where	UpdatedDate <= @DataPriorToDate
		Group By GlobalAccountCategoryId
		) t1 ON t1.GlobalAccountCategoryId = Gl1.GlobalAccountCategoryId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.GlobalAccountCategoryId	

RETURN 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalFunctionalDepartmentActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [Gdm].[GlobalFunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[GlobalFunctionalDepartment] Gl1
		INNER JOIN (
		Select 
				GlobalFunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[GlobalFunctionalDepartment]
		Where	UpdatedDate < @DataPriorToDate
		Group By GlobalFunctionalDepartmentId
		) t1 ON t1.GlobalFunctionalDepartmentId = Gl1.GlobalFunctionalDepartmentId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate < @DataPriorToDate
	Group By Gl1.GlobalFunctionalDepartmentId	

RETURN 
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[TaxTypeActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[TaxTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[TaxType] B1
		INNER JOIN (
			SELECT 
				TaxTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[TaxType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY TaxTypeId
		) t1 ON t1.TaxTypeId = B1.TaxTypeId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.TaxTypeId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingRegionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[SystemSettingRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[SystemSettingRegion] Gl1
		INNER JOIN (
			SELECT 
				SystemSettingRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[SystemSettingRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SystemSettingRegionId
		) t1 ON t1.SystemSettingRegionId = Gl1.SystemSettingRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SystemSettingRegionId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[SystemSettingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[SystemSettingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[SystemSetting] Gl1
		INNER JOIN (
		SELECT 
			SystemSettingId,
			MAX(UpdatedDate) UpdatedDate
		FROM 
			[TapasGlobal].[SystemSetting]
		WHERE	UpdatedDate <= @DataPriorToDate
		GROUP BY SystemSettingId
		) t1 ON t1.SystemSettingId = Gl1.SystemSettingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.SystemSettingId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[RegionExtendedActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[RegionExtendedActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[RegionExtended] Gl1
		INNER JOIN (
			SELECT 
				RegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[RegionExtended]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY RegionId
		) t1 ON t1.RegionId = Gl1.RegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.RegionId	
)
GO
/****** Object:  UserDefinedFunction [HR].[RegionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [HR].[RegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[Region] Gl1
		INNER JOIN (
			SELECT 
				RegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[Region]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY RegionId
		) t1 ON t1.RegionId = Gl1.RegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.RegionId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundMappingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[PropertyFundMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[PropertyFundMapping] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				PropertyFundCode,
				ActivityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[PropertyFundMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SourceCode,
				PropertyFundCode,
				ActivityTypeId
		) t1 ON t1.SourceCode = Gl1.SourceCode AND
				t1.PropertyFundCode = Gl1.PropertyFundCode AND
				(
				(t1.ActivityTypeId IS NOT NULL AND t1.ActivityTypeId = Gl1.ActivityTypeId)
				OR
				(t1.ActivityTypeId IS NULL AND Gl1.ActivityTypeId IS NULL)
				) AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PropertyFundMappingId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[PropertyFundActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [Gdm].[PropertyFundActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
BEGIN   

INSERT Into @Result
(ImportKey)
Select 
	MAX(Gl1.ImportKey) ImportKey
	From
	[Gdm].[PropertyFund] Gl1
		INNER JOIN (
		Select 
				PropertyFundId,
				MAX(UpdatedDate) UpdatedDate
		From 
				[Gdm].[PropertyFund]
		Where	UpdatedDate <= @DataPriorToDate
		Group By PropertyFundId
		) t1 ON t1.PropertyFundId = Gl1.PropertyFundId
	AND t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	Group By Gl1.PropertyFundId	

RETURN 
END
GO
/****** Object:  UserDefinedFunction [Gdm].[ProjectRegionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[ProjectRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ProjectRegion] Gl1
		INNER JOIN (
			SELECT 
				ProjectRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ProjectRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ProjectRegionId
		) t1 ON t1.ProjectRegionId = Gl1.ProjectRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ProjectRegionId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[ProjectActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[ProjectActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[Project] Gl1
		INNER JOIN (
			SELECT 
				ProjectId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
					[TapasGlobal].[Project]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ProjectId
		) t1 ON t1.ProjectId = Gl1.ProjectId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ProjectId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[PayrollRegionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[PayrollRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[PayrollRegion] Gl1
		INNER JOIN (
			SELECT 
				PayrollRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[PayrollRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY PayrollRegionId
		) t1 ON t1.PayrollRegionId = Gl1.PayrollRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.PayrollRegionId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadRegionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[OverheadRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[OverheadRegion] Gl1
		INNER JOIN (
			SELECT 
				OverheadRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[OverheadRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OverheadRegionId
		) t1 ON t1.OverheadRegionId = Gl1.OverheadRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OverheadRegionId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[OverheadActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[OverheadActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[Overhead] Gl1
		INNER JOIN (
			SELECT 
				OverheadId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[Overhead]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY OverheadId
		) t1 ON t1.OverheadId = Gl1.OverheadId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OverheadId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[OriginatingRegionMappingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[OriginatingRegionMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[OriginatingRegionMapping] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				RegionCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[OriginatingRegionMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SourceCode,
				RegionCode
		) t1 ON t1.SourceCode = Gl1.SourceCode AND
				t1.RegionCode = Gl1.RegionCode AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.OriginatingRegionMappingId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[MinorGlAccountCategoryActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[MinorGlAccountCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[MinorGlAccountCategory] Gl1
		INNER JOIN (
			SELECT 
				MinorGlAccountCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[MinorGlAccountCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY MinorGlAccountCategoryId
		) t1 ON t1.MinorGlAccountCategoryId = Gl1.MinorGlAccountCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.MinorGlAccountCategoryId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[MajorGlAccountCategoryActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[MajorGlAccountCategoryActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[MajorGlAccountCategory] Gl1
		INNER JOIN (
			SELECT 
				MajorGlAccountCategoryId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[MajorGlAccountCategory]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY MajorGlAccountCategoryId
		) t1 ON t1.MajorGlAccountCategoryId = Gl1.MajorGlAccountCategoryId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	Where Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.MajorGlAccountCategoryId	
)
GO
/****** Object:  UserDefinedFunction [HR].[LocationActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [HR].[LocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[HR].[Location] Gl1
		INNER JOIN (
			SELECT 
				LocationId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[Location]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY LocationId
		) t1 ON t1.LocationId = Gl1.LocationId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.LocationId	
)
GO
/****** Object:  UserDefinedFunction [GACS].[JobCodeActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [GACS].[JobCodeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[JobCode] Gl1
		INNER JOIN (
			SELECT 
				JobCode,
				Source,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[GACS].[JobCode]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY JobCode,
				Source
		) t1 ON t1.JobCode = Gl1.JobCode AND
				t1.Source = Gl1.Source AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.JobCode,
				Gl1.Source
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[GRBudgetReportGroupPeriodActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[GRBudgetReportGroupPeriodActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[GRBudgetReportGroupPeriod] B1
		INNER JOIN (
			SELECT 
				GRBudgetReportGroupPeriodId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[GRBudgetReportGroupPeriod]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GRBudgetReportGroupPeriodId
		) t1 ON t1.GRBudgetReportGroupPeriodId = B1.GRBudgetReportGroupPeriodId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.GRBudgetReportGroupPeriodId	

)
GO
/****** Object:  UserDefinedFunction [BudgetingCorp].[GlobalReportingCorporateBudgetActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BudgetingCorp].[GlobalReportingCorporateBudgetActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		B1.ImportKey ImportKey
	FROM
		[BudgetingCorp].[GlobalReportingCorporateBudget] B1

		INNER JOIN (
			SELECT 
				Budget.BudgetId,
				MAX(Budget.ImportBatchId) as ImportBatchId
			FROM 
				[BudgetingCorp].[GlobalReportingCorporateBudget] budget
				
				INNER JOIN Batch ON
					Budget.ImportBatchId = batch.BatchId
				
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.BudgetingCorp' AND
				batch.ImportEndDate <= @DataPriorToDate
				
		GROUP BY Budget.BudgetId
		) t1 ON 
			t1.BudgetId = B1.BudgetId AND
			t1.ImportBatchId = B1.ImportBatchId

)
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalRegionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[GlobalRegionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalRegion] Gl1
		INNER JOIN (
			SELECT 
				GlobalRegionId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalRegion]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalRegionId
		) t1 ON t1.GlobalRegionId = Gl1.GlobalRegionId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalRegionId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalGlAccountCategoryHierarchyGroupActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[GlobalGlAccountCategoryHierarchyGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalGlAccountCategoryHierarchyGroup] Gl1
		INNER JOIN (
			SELECT 
				GlobalGlAccountCategoryHierarchyGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalGlAccountCategoryHierarchyGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalGlAccountCategoryHierarchyGroupId
		) t1 ON t1.GlobalGlAccountCategoryHierarchyGroupId = Gl1.GlobalGlAccountCategoryHierarchyGroupId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalGlAccountCategoryHierarchyGroupId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[ExchangeRateActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[ExchangeRateActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[ExchangeRate] B1
		INNER JOIN (
			SELECT 
				ExchangeRateId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[ExchangeRate]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ExchangeRateId
		) t1 ON t1.ExchangeRateId = B1.ExchangeRateId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.ExchangeRateId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[EntityTypeActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[EntityTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[EntityType] Gl1
		INNER JOIN (
			SELECT 
				EntityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[EntityType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY EntityTypeId
		) t1 ON t1.EntityTypeId = Gl1.EntityTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.EntityTypeId	
)
GO
/****** Object:  UserDefinedFunction [GACS].[EntityMappingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [GACS].[EntityMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[EntityMapping] Gl1
		INNER JOIN (
		
			SELECT 
				EntityMappingId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[GACS].[EntityMapping]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY EntityMappingId
			
		) t1 ON t1.EntityMappingId = Gl1.EntityMappingId AND
				t1.InsertedDate = Gl1.InsertedDate
	WHERE Gl1.InsertedDate <= @DataPriorToDate
	GROUP BY Gl1.EntityMappingId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetTaxTypeActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetTaxTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetTaxType] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetTaxTypeId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetTaxType] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetTaxTypeId
			
		) t1 ON 
			t1.BudgetTaxTypeId = B1.BudgetTaxTypeId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetTaxTypeId
)
GO
/****** Object:  UserDefinedFunction [USProp].[EntityActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [USProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
					ENTITYID,
					MAX(LASTDATE) LASTDATE
			FROM 
					[USProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [USCorp].[EntityActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [USCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [INProp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [INCorp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[INCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [EUProp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [EUCorp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [CNProp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID
)
GO
/****** Object:  UserDefinedFunction [CNCorp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [BRProp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BRProp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[BRProp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRProp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [BRCorp].[EntityActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BRCorp].[EntityActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRCorp].[Entity] Gl1
		INNER JOIN (
			SELECT 
				ENTITYID,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[Entity]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ENTITYID
		) t1 ON t1.ENTITYID = Gl1.ENTITYID AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ENTITYID	
)
GO
/****** Object:  UserDefinedFunction [GACS].[DepartmentActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [GACS].[DepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[GACS].[Department] Gl1
		INNER JOIN (
			SELECT 
				Department,
				Source,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[GACS].[Department]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY Department,
				Source
		) t1 ON t1.Department = Gl1.Department AND
				t1.Source = Gl1.Source AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.Department,
				Gl1.Source
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetStatusActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetStatusActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
	[TapasGlobalBudgeting].[BudgetStatus] B1
		INNER JOIN (
			SELECT 
				BudgetStatusId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetStatus]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY BudgetStatusId
		) t1 ON t1.BudgetStatusId = B1.BudgetStatusId AND
				t1.InsertedDate = B1.InsertedDate
	WHERE B1.InsertedDate <= @DataPriorToDate
	GROUP BY B1.BudgetStatusId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetReportGroupDetail] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetReportGroupDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupDetailId
		) t1 ON t1.BudgetReportGroupDetailId = B1.BudgetReportGroupDetailId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupDetailId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetReportGroupActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetReportGroupActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetReportGroup] B1
		INNER JOIN (
			SELECT 
				BudgetReportGroupId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[BudgetReportGroup]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BudgetReportGroupId
		) t1 ON t1.BudgetReportGroupId = B1.BudgetReportGroupId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.BudgetReportGroupId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetProjectActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetProjectActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetProject] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetProjectId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetProject] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetProjectId
			
		) t1 ON 
			t1.BudgetProjectId = B1.BudgetProjectId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetProjectId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadDetailActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[BillingUploadDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[BillingUploadDetail] Gl1
		INNER JOIN (
			SELECT 
				BillingUploadDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[BillingUploadDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BillingUploadDetailId
		) t1 ON t1.BillingUploadDetailId = Gl1.BillingUploadDetailId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BillingUploadDetailId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobal].[BillingUploadActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobal].[BillingUploadActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[TapasGlobal].[BillingUpload] Gl1
		INNER JOIN (
			SELECT 
				BillingUploadId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobal].[BillingUpload]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY BillingUploadId
		) t1 ON t1.BillingUploadId = Gl1.BillingUploadId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.BillingUploadId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BenefitOptionActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BenefitOptionActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BenefitOption] B1
		INNER JOIN (
		
			SELECT 
				BenefitOptionId,
				MAX(InsertedDate) InsertedDate
			FROM 
				[TapasGlobalBudgeting].[BenefitOption]
			WHERE	InsertedDate <= @DataPriorToDate
			GROUP BY BenefitOptionId
		
		) t1 ON t1.BenefitOptionId = B1.BenefitOptionId AND
				t1.InsertedDate = B1.InsertedDate
	WHERE B1.InsertedDate <= @DataPriorToDate
	GROUP BY B1.BenefitOptionId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[ActivityTypeActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [Gdm].[ActivityTypeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[ActivityType] Gl1
		INNER JOIN (
			SELECT 
				ActivityTypeId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[ActivityType]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ActivityTypeId
		) t1 ON t1.ActivityTypeId = Gl1.ActivityTypeId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.ActivityTypeId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[AllocationRegionMappingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[AllocationRegionMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[AllocationRegionMapping] Gl1
		INNER JOIN (
			SELECT 
				SourceCode,
				RegionCode,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[AllocationRegionMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY SourceCode,
				RegionCode
				
		) t1 ON t1.SourceCode = Gl1.SourceCode AND
				t1.RegionCode = Gl1.RegionCode AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.AllocationRegionMappingId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(B1.ImportKey) ImportKey
	From
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeePayrollAllocationId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocation] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeePayrollAllocationId
			
		) t1 ON 
			t1.BudgetEmployeePayrollAllocationId = B1.BudgetEmployeePayrollAllocationId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeePayrollAllocationId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeeFunctionalDepartmentId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployeeFunctionalDepartment] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeeFunctionalDepartmentId
			
		) t1 ON 
			t1.BudgetEmployeeFunctionalDepartmentId = B1.BudgetEmployeeFunctionalDepartmentId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeeFunctionalDepartmentId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeeActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeeActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployee] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetEmployeeId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetEmployee] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetEmployeeId
		
		) t1 ON 
			t1.BudgetEmployeeId = B1.BudgetEmployeeId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeeId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[Budget] B1
	
		INNER JOIN (
		
			SELECT 
				Budget.BudgetId,
				MAX(Budget.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[Budget] budget
					
				INNER JOIN Batch ON
					Budget.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY Budget.BudgetId
		
		) t1 ON 
			t1.BudgetId = B1.BudgetId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetOverheadAllocationDetailId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetOverheadAllocationDetail] B2
				
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetOverheadAllocationDetailId
			
		) t1 ON 
			t1.BudgetOverheadAllocationDetailId = B1.BudgetOverheadAllocationDetailId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetOverheadAllocationDetailId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetOverheadAllocationActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetOverheadAllocation] B1

		INNER JOIN (
		
			SELECT 
				B2.BudgetOverheadAllocationId,
				MAX(B2.ImportBatchId) as ImportBatchId
			FROM 
				[TapasGlobalBudgeting].[BudgetOverheadAllocation] B2
					
				INNER JOIN Batch ON
					B2.ImportBatchId = batch.BatchId
					
			WHERE	
				batch.BatchEndDate IS NOT NULL AND
				batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
				batch.ImportEndDate <= @DataPriorToDate
					
			GROUP BY B2.BudgetOverheadAllocationId
			
		) t1 ON 
			t1.BudgetOverheadAllocationId = B1.BudgetOverheadAllocationId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetOverheadAllocationId
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActiveInner]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(BudgetEmployeePayrollAllocationDetailId Int NOT NULL,
	ImportBatchId Int NOT NULL)
AS
BEGIN 
	Insert Into @Result
	SELECT 
		B2.BudgetEmployeePayrollAllocationDetailId,
		MAX(B2.ImportBatchId) as ImportBatchId
	FROM 
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B2
			
		INNER JOIN Batch ON
			B2.ImportBatchId = batch.BatchId
			
	WHERE	
		batch.BatchEndDate IS NOT NULL AND
		batch.PackageName = 'ETL.Staging.TapasGlobalBudgeting' AND
		batch.ImportEndDate <= @DataPriorToDate
			
	GROUP BY B2.BudgetEmployeePayrollAllocationDetailId

RETURN
 END
GO
/****** Object:  UserDefinedFunction [USProp].[GDepActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [USProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [USCorp].[GDepActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [USCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
					DEPARTMENT,
					MAX(LASTDATE) LASTDATE
			FROM 
					[USCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
		GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [INProp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	From
		[INProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [INCorp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [EUProp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [EUCorp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [CNProp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT ANd
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [CNCorp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [BRProp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BRProp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(Gl1.ImportKey) ImportKey
	From
		[BRProp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [BRCorp].[GDepActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [BRCorp].[GDepActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	Select 
		MAX(Gl1.ImportKey) ImportKey
	From
		[BRCorp].[GDep] Gl1
		INNER JOIN (
			SELECT 
				DEPARTMENT,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GDep]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY DEPARTMENT
		) t1 ON t1.DEPARTMENT = Gl1.DEPARTMENT AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.DEPARTMENT	
)
GO
/****** Object:  UserDefinedFunction [HR].[FunctionalDepartmentActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [HR].[FunctionalDepartmentActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[HR].[FunctionalDepartment] Gl1
		INNER JOIN (
			SELECT 
				FunctionalDepartmentId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[HR].[FunctionalDepartment]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY FunctionalDepartmentId
		) t1 ON t1.FunctionalDepartmentId = Gl1.FunctionalDepartmentId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.FunctionalDepartmentId	
)
GO
/****** Object:  UserDefinedFunction [USProp].[GAccActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [USProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [USCorp].[GAccActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [USCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [INProp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INProp].[GAcc] Gl1
		INNER JOIN (
		SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
		FROM 
				[INProp].[GAcc]
		WHERE	LASTDATE <= @DataPriorToDate
		GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [INCorp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [EUProp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [EUCorp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	

)
GO
/****** Object:  UserDefinedFunction [CNProp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [CNCorp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [BRProp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BRProp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRProp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRProp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [BRCorp].[GAccActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BRCorp].[GAccActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRCorp].[GAcc] Gl1
		INNER JOIN (
			SELECT 
				ACCTNUM,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GAcc]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY ACCTNUM
		) t1 ON t1.ACCTNUM = Gl1.ACCTNUM AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.ACCTNUM	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalGlAccountCategoryHierarchyActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[GlobalGlAccountCategoryHierarchyActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalGlAccountCategoryHierarchy] Gl1
		INNER JOIN (
			SELECT 
				GlobalGlAccountCategoryHierarchyId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalGlAccountCategoryHierarchy]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalGlAccountCategoryHierarchyId
		) t1 ON t1.GlobalGlAccountCategoryHierarchyId = Gl1.GlobalGlAccountCategoryHierarchyId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalGlAccountCategoryHierarchyId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalGlAccountActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[GlobalGlAccountActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalGlAccount] Gl1
		INNER JOIN (
			SELECT 
				GlobalGlAccountId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalGlAccount]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalGlAccountId
		) t1 ON t1.GlobalGlAccountId = Gl1.GlobalGlAccountId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalGlAccountId	
)
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[ExchangeRateDetailActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[ExchangeRateDetailActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[ExchangeRateDetail] B1
		INNER JOIN (
			SELECT 
				ExchangeRateDetailId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[TapasGlobalBudgeting].[ExchangeRateDetail]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY ExchangeRateDetailId
		) t1 ON t1.ExchangeRateDetailId = B1.ExchangeRateDetailId AND
				t1.UpdatedDate = B1.UpdatedDate
	WHERE B1.UpdatedDate <= @DataPriorToDate
	GROUP BY B1.ExchangeRateDetailId	
)
GO
/****** Object:  UserDefinedFunction [Gdm].[GlobalAllocationRegionMappingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[GlobalAllocationRegionMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlobalAllocationRegionMapping] Gl1
		INNER JOIN (
			SELECT 
				GlobalAllocationRegionMappingId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlobalAllocationRegionMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlobalAllocationRegionMappingId
		) t1 ON t1.GlobalAllocationRegionMappingId = Gl1.GlobalAllocationRegionMappingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlobalAllocationRegionMappingId	

)
GO
/****** Object:  UserDefinedFunction [Gdm].[GlAccountMappingActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gdm].[GlAccountMappingActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[Gdm].[GlAccountMapping] Gl1
		INNER JOIN (
			SELECT 
				GlAccountMappingId,
				MAX(UpdatedDate) UpdatedDate
			FROM 
				[Gdm].[GlAccountMapping]
			WHERE	UpdatedDate <= @DataPriorToDate
			GROUP BY GlAccountMappingId
		) t1 ON t1.GlAccountMappingId = Gl1.GlAccountMappingId AND
				t1.UpdatedDate = Gl1.UpdatedDate
	WHERE Gl1.UpdatedDate <= @DataPriorToDate
	GROUP BY Gl1.GlAccountMappingId	
)
GO
/****** Object:  UserDefinedFunction [USProp].[GJobActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [USProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
	[USProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[USProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
			    t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	

)
GO
/****** Object:  UserDefinedFunction [USCorp].[GJobActive]    Script Date: 05/04/2010 16:53:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [USCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[USCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
					[USCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)
GO
/****** Object:  UserDefinedFunction [INCorp].[GJobActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [INCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[INCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[INCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)
GO
/****** Object:  UserDefinedFunction [EUProp].[GJobActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)
GO
/****** Object:  UserDefinedFunction [EUCorp].[GJobActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [EUCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[EUCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[EUCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)
GO
/****** Object:  UserDefinedFunction [CNProp].[GJobActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNProp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNProp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[CNProp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	

)
GO
/****** Object:  UserDefinedFunction [CNCorp].[GJobActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CNCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[CNCorp].[GJob] Gl1
		INNER JOIN (
			Select 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			From 
				[CNCorp].[GJob]
			Where	LASTDATE <= @DataPriorToDate
			Group By JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)
GO
/****** Object:  UserDefinedFunction [BRCorp].[GJobActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [BRCorp].[GJobActive]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		MAX(Gl1.ImportKey) ImportKey
	FROM
		[BRCorp].[GJob] Gl1
		INNER JOIN (
			SELECT 
				JOBCODE,
				MAX(LASTDATE) LASTDATE
			FROM 
				[BRCorp].[GJob]
			WHERE	LASTDATE <= @DataPriorToDate
			GROUP BY JOBCODE
		) t1 ON t1.JOBCODE = Gl1.JOBCODE AND
				t1.LASTDATE = Gl1.LASTDATE
	WHERE Gl1.LASTDATE <= @DataPriorToDate
	GROUP BY Gl1.JOBCODE	
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetGreatest]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetGreatest] (@str varchar(1024))
	
RETURNS varchar(100) 


AS 
BEGIN	
	DECLARE @item varchar(100)
	SET @item = (SELECT MAX(item) FROM dbo.GetSplit(@str))

	RETURN @item
END
GO
/****** Object:  UserDefinedFunction [Gr].[GetGlobalGlAccountCategoryHierarchy]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Gr].[GetGlobalGlAccountCategoryHierarchy]
	(@DataPriorToDate DateTime)
RETURNS TABLE as RETURN 
(
	SELECT 
		DISTINCT 
		GlHg.Name HierarchyName,
		LTRIM(STR(GlH.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':'+LTRIM(STR(GlH.MajorGlAccountCategoryId,10,0))+':'+LTRIM(STR(GlH.MinorGlAccountCategoryId,10,0)) as GlobalAccountCategoryCode,
		GlH.MajorGlAccountCategoryId,
		GlMa.Name MajorGlAccountCategoryName,
		GlH.MinorGlAccountCategoryId,
		GlMi.Name MinorGlAccountCategoryName,
		CASE WHEN GlH.AccountType LIKE '%EXP%' THEN 'EXPENSE' 
			WHEN GlH.AccountType LIKE '%INC%' THEN 'INCOME'
			ELSE 'UNKNOWN' END as FeeOrExpense,
		GlH.ExpenseType,
		MIN(GlH.InsertedDate) InsertedDate,
		MAX(GlH.UpdatedDate) UpdatedDate
			
	FROM	
			(
				SELECT GlH.*
				FROM
					Gdm.GlobalGlAccountCategoryHierarchy GlH
					INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyActive(@DataPriorToDate) GlHA ON GlHA.ImportKey = GlH.ImportKey
			) GlH
			
			INNER JOIN (
				SELECT GlHg.*
				FROM
					Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
					INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHgA ON GlHgA.ImportKey = GlHg.ImportKey
			) GlHg ON GlHg.GlobalGlAccountCategoryHierarchyGroupId = GlH.GlobalGlAccountCategoryHierarchyGroupId
			
			INNER JOIN (
				SELECT GlMa.*
				FROM
					Gdm.MajorGlAccountCategory GlMa
					INNER JOIN Gdm.MajorGlAccountCategoryActive(@DataPriorToDate) GlMaA ON GlMaA.ImportKey = GlMa.ImportKey
			) GlMa ON GlMa.MajorGlAccountCategoryId = GlH.MajorGlAccountCategoryId
			
			INNER JOIN (
				SELECT GlMi.*
				FROM
					Gdm.MinorGlAccountCategory GlMi
					INNER JOIN Gdm.MinorGlAccountCategoryActive(@DataPriorToDate) GlMiA ON GlMiA.ImportKey = GlMi.ImportKey
			) GlMi ON GlMi.MinorGlAccountCategoryId = GlH.MinorGlAccountCategoryId		
	GROUP BY 
		GlH.GlobalGlAccountCategoryHierarchyGroupId,
		GlHg.Name,
		GlH.MajorGlAccountCategoryId,
		GlMa.Name,
		GlH.MinorGlAccountCategoryId,
		GlMi.Name,
		GlH.AccountType,
		GlH.ExpenseType
		
	UNION ALL

	SELECT 
		GlHg.Name HierarchyName,
		LTRIM(STR(GlHg.GlobalGlAccountCategoryHierarchyGroupId,10,0))+':-1:-1',
		-1,
		'UNKNOWN',
		-1,
		'UNKNOWN',
		'UNKNOWN',
		'UNKNOWN',
		'1900-01-01',
		'1900-01-01'
		
		FROM
			Gdm.GlobalGlAccountCategoryHierarchyGroup GlHg
			INNER JOIN Gdm.GlobalGlAccountCategoryHierarchyGroupActive(@DataPriorToDate) GlHgA ON GlHgA.ImportKey = GlHg.ImportKey
)
GO
/****** Object:  UserDefinedFunction [Gr].[GetFunctionalDepartmentExpanded]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [Gr].[GetFunctionalDepartmentExpanded]
	()
RETURNS @Result TABLE 
	(
	FunctionalDepartmentId Int NOT NULL,
	ReferenceCode varchar(20) NULL,
	FunctionalDepartmentCode varchar(20) NOT NULL,
	FunctionalDepartmentName Varchar(50) NOT NULL,
	SubFunctionalDepartmentCode varchar(20) NOT NULL,
	SubFunctionalDepartmentName Varchar(100) NOT NULL,
	UpdatedDate DateTime NOT NULL
	)
AS
BEGIN 
DECLARE @DataPriorToDate	DateTime


SET @DataPriorToDate = CONVERT(DateTime,(Select t1.ConfiguredValue From GrReportingStaging.dbo.SSISConfigurations t1 where ConfigurationFilter = 'DataPriorToDate'),103)

Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+':',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		Fd.GlobalCode SubFunctionalDepartmentCode,
		RTRIM(Fd.GlobalCode) + ' - ' + Fd.Name SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
Where Fd.GlobalCode IS NOT NULL

Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		T2.FunctionalDepartmentId,
		T1.FunctionalDepartmentCode+':'+T2.Code,
		T1.FunctionalDepartmentCode,
		T1.FunctionalDepartmentName,
		T2.Code,
		RTRIM(T2.Code) + ' - ' + T2.Description,
		T2.UpdatedDate
From	
		@Result T1
			INNER JOIN 
						(
							Select 
									--Jc.Source,
									Jc.JobCode Code,
									Max(Jc.Description) as Description,
									Max(Jc.FunctionalDepartmentId) as FunctionalDepartmentId,
									Max(Jc.UpdatedDate) as UpdatedDate
							From GACS.JobCode Jc
								INNER JOIN GACS.JobCodeActive(@DataPriorToDate) JcA ON JcA.ImportKey = Jc.ImportKey
							Where Jc.FunctionalDepartmentId IS NOT NULL
							Group By --TODO. As per AW advice job code will never be map to functional departments for day 1, we will address a change in this when the time comes.
									Jc.JobCode
							
						) T2 ON T2.FunctionalDepartmentId = T1.FunctionalDepartmentId
						AND T2.Code <> T1.FunctionalDepartmentCode

Order By T1.FunctionalDepartmentCode

--Add All the Parent FunctionalDepartments with UNKNOWN SubFunctionalDepartment, (that have a GlobalCode)
Insert Into @Result
(FunctionalDepartmentId, ReferenceCode,FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName,UpdatedDate)
Select 
		Fd.FunctionalDepartmentId,
		Fd.GlobalCode+':UNKNOWN',
		Fd.GlobalCode FunctionalDepartmentCode,
		Fd.Name FunctionalDepartmentName,
		'UNKNOWN' SubFunctionalDepartmentCode,
		'UNKNOWN' SubFunctionalDepartmentName,
		Fd.UpdatedDate
FROM HR.FunctionalDepartment Fd
	INNER JOIN HR.FunctionalDepartmentActive(@DataPriorToDate) FdA ON FdA.ImportKey = Fd.ImportKey
Where Fd.GlobalCode IS NOT NULL

RETURN
END
GO
/****** Object:  UserDefinedFunction [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]    Script Date: 05/04/2010 16:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetailActive]
	(@DataPriorToDate DateTime)
RETURNS @Result TABLE 
	(ImportKey Int NOT NULL)
AS
	BEGIN
	
	DECLARE @t1 TABLE (BudgetEmployeePayrollAllocationDetailId Int NOT NULL,
						ImportBatchId Int NOT NULL)
	
	Insert Into @t1
	Select * From TapasGlobalBudgeting.BudgetEmployeePayrollAllocationDetailActiveInner(@DataPriorToDate)
	
	Insert Into @Result
	SELECT 
		MAX(B1.ImportKey) ImportKey
	FROM
		[TapasGlobalBudgeting].[BudgetEmployeePayrollAllocationDetail] B1

		INNER JOIN @t1 t1 ON 
			t1.BudgetEmployeePayrollAllocationDetailId = B1.BudgetEmployeePayrollAllocationDetailId AND
			t1.ImportBatchId = B1.ImportBatchId
	
	GROUP BY B1.BudgetEmployeePayrollAllocationDetailId
	RETURN
	END
GO
