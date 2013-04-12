
INSERT INTO [Gr].[GlAccountMapping]
           ([GlobalGlAccountId]
           ,[SourceCode]
           ,[GlAccountCode]
           ,[InsertedDate]
           ,[UpdatedDate]
           ,[IsDeleted])
Select 
		DISTINCT
		NULL,
		Gl.GlobalGlAccountId,
		Pr.SourceCode , 
		Pr.GlAccountCode,
		'2010-01-01',
		'2010-01-01',
		0,
		
		Gl.GlAccountCode , '%' + RIGHT(Pr.GlAccountCode,10) + '%'
		,Glm.GlAccountCode
From Gr.ProfitabilityGeneralLedger Pr
		LEFT OUTER JOIN Gdm.GlobalGlAccount Gl ON Gl.GlAccountCode = RIGHT(Pr.GlAccountCode,10)
		LEFT OUTER JOIN Gdm.GlAccountMapping Glm ON Glm.SourceCode =  Pr.SourceCode 
												AND Glm.GlAccountCode = Pr.GlAccountCode
		--Can make a new mapping
Where	Gl.GlAccountCode IS NOT NULL
		--Have no existing mapping
AND 	Glm.GlAccountCode IS NULL	

select * from Gr.ProfitabilityGeneralLedger Pr