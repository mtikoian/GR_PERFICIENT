http://dwbijourney.blogspot.com/2008/10/dynamic-dimension-security-in-ssas.html

http://www.mosha.com/msolap/security.htm

http://sqlblog.com/blogs/mosha/archive/2004/12/16/dynamic-dimension-security-in-analysis-services-2000.aspx


http://support.microsoft.com/kb/952113

A common implementation is to pass the UserName variable from Analysis Services to an assembly that performs 
authentication and that then returns a result string or a result set for the permissions of a user. 
Analysis Services caches this result globally. Therefore, after Analysis Services evaluates the first 
result for a particular user, Analysis Services does not evaluate the result again until you clear the 
cache oruntil you restart the Analysis Services service. This can cause unexpected results. 
For example, if you update the permissions of a user in a relational source, and the authentication 
assembly checks that source, the change does not appear until you clear the cache manually or 
until you restart the Analysis Services service.


Some Points on the Role:

Read access to cube and definition is required