﻿ IF (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ENTITY' AND 
												   COLUMN_NAME = 'PHONE' AND
												   TABLE_SCHEMA = 'USProp') = 14
BEGIN

	ALTER TABLE USProp.ENTITY
	ALTER COLUMN PHONE char(15)

END

 IF (SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GHIS' AND 
												   COLUMN_NAME = 'BANKRECID' AND
												   TABLE_SCHEMA = 'USProp') = 'float'
BEGIN

	ALTER TABLE USProp.GHIS
	ALTER COLUMN BANKRECID int

END


 IF (SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOURNAL' AND 
												   COLUMN_NAME = 'BANKRECID' AND
												   TABLE_SCHEMA = 'USProp') = 'float'
BEGIN

	ALTER TABLE USProp.JOURNAL
	ALTER COLUMN BANKRECID int

END