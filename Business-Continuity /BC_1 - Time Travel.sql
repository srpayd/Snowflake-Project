/*----------------D6_1 Hands-on----------------
1) Time Travel 
2) DATA_RETENTION_TIME_IN_DAYS parameter
3) Time Travel SQL extensions
----------------------------------------------*/

-- Set context
USE ROLE ACCOUNTADMIN;

CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

CREATE TABLE DEMO_TABLE_TT
(
ID STRING, 
FIRST_NAME STRING, 
AGE NUMBER
);

INSERT INTO DEMO_TABLE_TT VALUES ('55D899','Edric',56),('MMD829','Jayanthi',23),('7DM899','Chloe',51);


-- Verify retention_time is set to default of 1
SHOW DATABASES LIKE 'DEMO_DB';

ALTER ACCOUNT SET DATA_RETENTION_TIME_IN_DAYS=90;

-- Verify updated retention_time 
SHOW DATABASES LIKE 'DEMO_DB';

ALTER DATABASE DEMO_DB SET DATA_RETENTION_TIME_IN_DAYS=45;

-- Verify updated retention_time 
SHOW DATABASES LIKE 'DEMO_DB';

-- Verify updated retention_time 
SHOW SCHEMAS LIKE 'DEMO_SCHEMA';

-- Verify updated retention_time 
SHOW TABLES LIKE 'DEMO_TABLE_TT';

ALTER SCHEMA DEMO_SCHEMA SET DATA_RETENTION_TIME_IN_DAYS=10;
ALTER TABLE DEMO_TABLE_TT SET DATA_RETENTION_TIME_IN_DAYS=5;

-- Setting DATA_RETENTION_TIME_IN_DAYS to 0 effectively disables Time Travel
ALTER SCHEMA DEMO_SCHEMA SET DATA_RETENTION_TIME_IN_DAYS=0;


-- UNDROP 
SHOW TABLES HISTORY;
SELECT "name","retention_time","dropped_on" FROM TABLE(result_scan(LAST_QUERY_ID()));

DROP TABLE DEMO_TABLE_TT;

SHOW TABLES HISTORY;
SELECT "name","retention_time","dropped_on" FROM TABLE(result_scan(LAST_QUERY_ID()));

UNDROP TABLE DEMO_TABLE_TT;

SHOW TABLES HISTORY;
SELECT "name","retention_time","dropped_on" FROM TABLE(result_scan(LAST_QUERY_ID()));

SELECT * FROM DEMO_TABLE_TT;


-- The AT keyword allows you to capture historical data inclusive of all changes made by a statement or transaction up until that point.
TRUNCATE TABLE DEMO_TABLE_TT;

SELECT * FROM DEMO_TABLE_TT;

--  Select table as it was 5 minutes ago, expressed in difference in seconds between current time
SELECT * FROM DEMO_TABLE_TT
AT(OFFSET => -60*5);

-- Select rows from point in time of inserting records into table
SELECT * FROM DEMO_TABLE_TT
AT(STATEMENT => '<insert_statement_id>');

-- Select tables as it was 15 minutes ago using Timestamp
SELECT * FROM DEMO_TABLE_TT
AT(TIMESTAMP => DATEADD(minute,-15, current_timestamp()));

SELECT * FROM DEMO_TABLE_TT
AT(TIMESTAMP => DATEADD(minute,-15, current_timestamp()));


-- The BEFORE keyword allows you to select historical data from a table up to, but not including any changes made by a specified statement or transaction.

-- Select rows from BEFORE truncate command
SELECT * FROM DEMO_TABLE_TT
BEFORE(STATEMENT => '<insert_statement_id>');

SELECT * FROM DEMO_TABLE_TT
BEFORE(STATEMENT => '<truncate_statement_id>');

CREATE TABLE DEMO_TABLE_TT_RESTORED
AS 
SELECT * FROM DEMO_TABLE_TT
BEFORE(STATEMENT => '<truncate_statement_id>');

SELECT * FROM DEMO_TABLE_TT_RESTORED;

-- Clear-down resources
DROP DATABASE DEMO_DB;
ALTER ACCOUNT SET DATA_RETENTION_TIME_IN_DAYS=1;