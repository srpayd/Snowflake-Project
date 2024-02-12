/*----------------D5_1 Hands-on----------------
1) Introduce Databases & schemas
2) Understand table and view types
----------------------------------------------*/

-- Set context 
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

--"SNOWFLAKE_SAMPLE_DATA"."WEATHER"."DAILY_14_TOTAL"

-- Describe table schema
DESC TABLE CUSTOMER;

-- Provide details on all tables in current context
SHOW TABLES;

-- Filter output of SHOW TABLES using LIKE string matching
SHOW TABLES LIKE 'CUSTOMER';

SELECT "name", "database_name", "schema_name", "kind", "is_external", "retention_time" FROM TABLE(result_scan(last_query_id()));

-- Create demo database & schema 
CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHEMA;

-- Create three table types
CREATE TABLE PERMANENT_TABLE 
(
  NAME STRING,
  AGE INT
  );

CREATE TEMPORARY TABLE TEMPORARY_TABLE
(
  NAME STRING,
  AGE INT
  );

CREATE TRANSIENT TABLE TRANSIENT_TABLE 
(
  NAME STRING,
  AGE INT
  );

SHOW TABLES;

SELECT "name", "database_name", "schema_name", "kind", "is_external" FROM TABLE(result_scan(last_query_id()));

-- Successful 
ALTER TABLE PERMANENT_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 90;

-- Invalid value [90]
ALTER TABLE TRANSIENT_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 2;

-- Create external table 
CREATE EXTERNAL TABLE EXT_TABLE
(
 	
  col1 varchar as (value:col1::varchar),
  col2 varchar as (value:col2::int)
  col3 varchar as (value:col3::varchar)

)
LOCATION=@s1/logs/
FILE_FORMAT = (type = parquet);


-- Refresh external table metadata so it reflects latest changes in external cloud storage
ALTER EXTERNAL TABLE EXT_TABLE REFRESH;


-- Create three views - one of each type

CREATE VIEW STANDARD_VIEW AS
SELECT * FROM PERMANENT_TABLE;

CREATE SECURE VIEW SECURE_VIEW AS
SELECT * FROM PERMANENT_TABLE;

CREATE MATERIALIZED VIEW MATERIALIZED_VIEW AS
SELECT * FROM PERMANENT_TABLE;

SHOW VIEWS;

SELECT "name", "database_name", "schema_name", "is_secure", "is_materialized" FROM TABLE(result_scan(last_query_id()));

-- Secure view functionality

GRANT USAGE ON DATABASE DEMO_DB TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA DEMO_SCHEMA TO ROLE SYSADMIN;
GRANT SELECT, REFERENCES ON TABLE STANDARD_VIEW TO ROLE SYSADMIN;
GRANT SELECT, REFERENCES ON TABLE SECURE_VIEW TO ROLE SYSADMIN;

-- DDL returned from secure view as role that owns secure view
SELECT get_ddl('view', 'SECURE_VIEW');

-- Set context
USE ROLE SYSADMIN;

-- Will not work with SYSADMIN role as only ownership role can view DDL
SELECT get_ddl('view', 'SECURE_VIEW');

-- Will work with SYSADMIN role as view not desginated as SECURE  
SELECT get_ddl('view', 'STANDARD_VIEW');

-- Set context
USE ROLE ACCOUNTADMIN;

-- Clear down database
DROP DATABASE DEMO_DB;