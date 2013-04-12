 update Gr.GlobalGlAccount
Set ActivityTypeId = t1.ActivityTypeId
From (
	Select 
			Gl.GlobalGlAccountId,
			ISNULL(Ac.ActivityTypeId, -1) ActivityTypeId,
			SUBSTRING(Gl.GlAccountCode,9,2) GLSuffix
	From	Gr.GlobalGlAccount Gl
				LEFT OUTER JOIN dbo.ActivityType Ac ON Ac.GLSuffix = SUBSTRING(Gl.GlAccountCode,9,2)

	) t1
Where GlobalGlAccount.GlobalGlAccountId = t1.GlobalGlAccountId