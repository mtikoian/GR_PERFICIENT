USE GrReporting
GO


IF NOT EXISTS(Select * From GlAccount Where GlAccountCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT GLACCOUNT ON 
	INSERT INTO GLACCOUNT
	(GLACCOUNTKEY,GLOBALGLACCOUNTID,GLACCOUNTCODE,GLACCOUNTNAME,STARTDATE,ENDDATE)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT GLACCOUNT OFF
	END

--IF NOT EXISTS(Select * From GlAccountCategory Ac Where Ac.GlAccountCategoryName = 'UNKNOWN')
--	BEGIN
--	SET IDENTITY_INSERT GlAccountCategory ON 
--	INSERT INTO GlAccountCategory
--	(AccountCategoryKey,GlobalAccountCategoryId, AccountCategoryName,AccountSubCategoryName, AccountType,FeeOrExpense, StartDate, EndDate)
--	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
--	SET IDENTITY_INSERT AccountCategory OFF
--	END

IF NOT EXISTS(Select * From ActivityType At Where At.ActivityTypeCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT ActivityType ON 
	INSERT INTO ActivityType
	(ActivityTypeKey, ActivityTypeId, ActivityTypeCode,ActivityTypeName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT ActivityType OFF
	END
	
IF NOT EXISTS(Select * From AllocationRegion Ar Where Ar.RegionCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT AllocationRegion ON 
	INSERT INTO AllocationRegion
	(AllocationRegionKey,GlobalRegionId,RegionCode,RegionName,SubRegionCode,SubRegionName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT AllocationRegion OFF
	END
	
IF NOT EXISTS(Select * From PropertyFund Pf Where Pf.PropertyFundName = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT PropertyFund ON 
	INSERT INTO PropertyFund
	(PropertyFundKey,PropertyFundId,PropertyFundName,PropertyFundType, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT PropertyFund OFF
	END
	

IF NOT EXISTS(Select * From FunctionalDepartment Fd Where Fd.FunctionalDepartmentCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT FunctionalDepartment ON 
	INSERT INTO FunctionalDepartment
	(FunctionalDepartmentKey, ReferenceCode, FunctionalDepartmentCode,FunctionalDepartmentName,SubFunctionalDepartmentCode,SubFunctionalDepartmentName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT FunctionalDepartment OFF
	END

IF NOT EXISTS(Select * From OriginatingRegion Ar Where Ar.RegionCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT OriginatingRegion ON 
	INSERT INTO OriginatingRegion
	(OriginatingRegionKey,GlobalRegionId,RegionCode,RegionName,SubRegionCode,SubRegionName, StartDate, EndDate)
	VALUES(-1,-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','1900-01-01','9999-01-01')
	SET IDENTITY_INSERT OriginatingRegion OFF
	END
IF NOT EXISTS(Select * From Reimbursable Re Where Re.ReimbursableCode = 'UNKNOWN')
	BEGIN
	SET IDENTITY_INSERT Reimbursable ON 
	INSERT INTO Reimbursable
	(ReimbursableKey,ReimbursableCode,ReimbursableName)
	VALUES(-1,'UNKNOWN','UNKNOWN')
	SET IDENTITY_INSERT Reimbursable OFF
	END
	
IF NOT EXISTS(Select * From Reimbursable Re Where Re.ReimbursableCode = 'YES')
	BEGIN
	SET IDENTITY_INSERT Reimbursable ON 
	INSERT INTO Reimbursable
	(ReimbursableKey,ReimbursableCode,ReimbursableName)
	VALUES(2,'YES','Reimbursable')
	SET IDENTITY_INSERT Reimbursable OFF
	END
	
IF NOT EXISTS(Select * From Reimbursable Re Where Re.ReimbursableCode = 'NO')
	BEGIN
	SET IDENTITY_INSERT Reimbursable ON 
	INSERT INTO Reimbursable
	(ReimbursableKey,ReimbursableCode,ReimbursableName)
	VALUES(3,'NO','Not Reimbursable')
	SET IDENTITY_INSERT Reimbursable OFF
	END

GO


IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'UN')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(-1,'UN','UNKNOWN','UNKNOWN','NO','NO')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'US')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(1,'US','USProp','USA Property','NO','YES')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'UC')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(2,'UC','USCorp','USA Corporate','YES','NO')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'EU')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(3,'EU','EUProp','EU Property','NO','YES')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'EC')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(4,'EC','EUCorp','EU Corporate','YES','NO')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'CN')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(5,'CN','CNProp','CN Property','NO','YES')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'CC')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(6,'CC','CNCorp','CN Corporate','YES','NO')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'BR')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(7,'BR','BRProp','BR Property','NO','YES')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'BR')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(8,'CC','BRCorp','BR Corporate','YES','NO')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'IN')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(9,'IN','INProp','IN Property','NO','YES')
	SET IDENTITY_INSERT [Source] OFF
	END
GO
IF NOT EXISTS(Select * From dbo.Source Sc Where Sc.SourceCode = 'IN')
	BEGIN
	SET IDENTITY_INSERT [Source] ON 
	INSERT INTO  [Source] 
	(SourceKey,SourceCode,SourceSystem,SourceName,IsCorporate,IsProperty)
	VALUES(10,'IC','INCorp','IN Corporate','YES','NO')
	SET IDENTITY_INSERT [Source] OFF
	END

GO
