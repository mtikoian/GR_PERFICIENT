GDM Script Deployment
============================

1.GDM_Schema Changes to move PropertyFund from TapasUS to Gdm.sql
	- Structural changes to create tables to replace table that were once in TAPAUS e.g. PropertyFund
	-NOTE: This script will break becuase of a foreign key constraint the first time it is run. If it is rerun the problem goes away, so it must be run twice.

2.GDM_Data to move from PropertyFund in TapasUS to Gdm.sql
	- Copies data from tables in TAPAUS into the new tables in GDM
	- NOTE: This script can not be run once the tables have been deleted in TAPAUS

3.--- NOT USED GDM_PropertyFund Import Spreadsheet Schema.sql
	- Creates necessary tables in GDM_Import to facilitate corporate department mapping changes

4.GDM_Data Changes.sql
	- Inserts an EU FUNDS global region 
	- Updates the names of certain PropertyFunds
	- Updates Project Region Names
	- Inserts an Allocation Region Mapping
	- Updates the Fund I Extension property fund mapping

5.GDM_PropertyFund Transfer Spreadsheet Data.sql (runs in GDM_Import)
	- Updates corporate department mappings to match what is in the GDM_Import.dbo.ImportCorporateDepartmentMapping table
	- NOTE:
		1. This script requires that the latest verion of the mapping spreadsheet has been imported (the following is an example for a dev/test deployment the locations will be different on staging/live):
			i. Save an xls version of the spreadsheet called PropertyFundMapping.xls to the following location - \\obtssql10\c$\SSIS\ImportFiles\GDM
			ii. Go to \\obtssql10\c$\SSIS\Packages\DEV\GDM 
			iii. Ensure before executing either the validate or import package that the DestinationConnectionOLEBD connection is pointing to the correct database this can be done by opening the package in SQL Server 2008 and goign to the Connection Manager tab
			iv. The ValdiatePropertyFundMapping.dtsx package outputs four files detailing the data changes caused by the import
			v. The ImportPropertyFundMapping.dtsx package imports the data from the spreadhseet into the ImportCorporateDepartmentMapping table

		2. The @ImportVersion varible in this script must be set to the correct version: Select max(ImportVersion) From GDM_Import.dbo.ImportCorporateDepartmentMapping 

6.GDM_Update Property Entity Fund Mappings.sql
	- Updates the property entity mappings to match what is in the GDM.dbo.ImportPropertyEntityMapping table
	- NOTE: This script requires that the latest version of the PropertyEntityMapping tab of the Property Fund Mapping spreadsheet has been imported into a table called ImportPropertyEntityMapping in GDM
		i. Save a csv version of the PropertyEntityMapping tab
		ii. Import the csv file into a table called ImportPropertyEntityMapping in GDM ensuring that any existing data is overwritten or that the table is deleted before importing
			- When importing: 1. The Text Qulifier must be set to "
							  2. The 'Column names in the first data row' check box must be checked 
							  3. The last four columns must have their data type lenght incresed to 255 (Advanced tab)