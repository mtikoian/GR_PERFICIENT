SELECT	DISTINCT
		NULL,
		Pf.[PropertyFundId]
		,Pf.[Name]
		,t10.SourceCode
		,t10.PropertyFundCode
		,'2010-01-01'
		,'2010-01-01'
  FROM [GDM].[PropertyFund] Pf
		--Can be mapped
		LEFT OUTER JOIN (
						Select SourceCode,
								PropertyFundCode,
								PropertyFundName			
						From	(
								Select SourceCode, PropertyFundCode, PropertyFundName From USProp.GeneralLedger
								UNION
								Select SourceCode, PropertyFundCode, PropertyFundName From USCorp.GeneralLedger
								UNION
								Select SourceCode, PropertyFundCode, PropertyFundName From EUCorp.GeneralLedger
								UNION
								Select SourceCode, PropertyFundCode, PropertyFundName From EUProp.GeneralLedger
								) t1
						) t10 ON LTRIM(RTRIM(t10.PropertyFundName)) = Pf.Name
		--Is not mapped already
		--LEFT OUTER JOIN Gdm.PropertyFundMapping Pfm ON
		--		Pfm.PropertyFundId = Pf.PropertyFundId
Where	t10.PropertyFundName IS NOT NULL
--AND		Pfm.PropertyFundId IS NULL


--select * from [GDM].[PropertyFund] Pf

select * from Gdm.PropertyFund where Name like '%TS DEVELOPMENT%'