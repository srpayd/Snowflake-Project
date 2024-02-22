/*----------------D5_4 Hands-on----------------
1) Creating Share object
2) Creating Reader Account
3) Create Database from Share
4) Adding objects to Share
5) Revoke access to a Share
----------------------------------------------*/

-- Set context 
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;

-- Create demo database and schema
CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

-- Create table and secure view
CREATE TABLE DEMO_TABLE 
(
NAME STRING, 
AGE INT
);

INSERT INTO DEMO_TABLE VALUES ('Edric',56),('Jayanthi',23),('Chloe',51),('Rowland',50),('Lorna',33),('Satish',19);

CREATE SECURE VIEW DEMO_SEC_VIEW
AS 
SELECT NAME 
FROM DEMO_TABLE 
WHERE AGE > 30;

USE ROLE ACCOUNTADMIN;

-- Create a share and include two tables
CREATE SHARE DEMO_SHARE COMMENT='Sharing demo data';
GRANT USAGE ON DATABASE DEMO_DB TO SHARE DEMO_SHARE;
GRANT USAGE ON SCHEMA DEMO_DB.DEMO_SCHEMA TO SHARE DEMO_SHARE;
GRANT SELECT ON TABLE DEMO_DB.DEMO_SCHEMA.DEMO_TABLE TO SHARE DEMO_SHARE;

-- Create a reader account
CREATE MANAGED ACCOUNT SNOWFLAKE_TUTORIAL_READER_ACCOUNT 
admin_name='admin', 
admin_password='Passw0rd', 
type=reader;

SHOW MANAGED ACCOUNTS;

-- Add reader account to share
ALTER SHARE DEMO_SHARE ADD ACCOUNTS = <reader_account_locator>;

-- EXECUTE FROM WITHIN READER ACCOUNT
USE ROLE ACCOUNTADMIN;

-- Create a database in the reader account from a share
CREATE DATABASE DEMO_DB_READER FROM SHARE <main_account_locator>.DEMO_SHARE; -- e.g ek83803

GRANT IMPORTED PRIVILEGES ON DATABASE DEMO_DB_READER TO ROLE SYSADMIN;

USE ROLE SYSADMIN;

--Create warehouse in reader account
CREATE OR REPLACE WAREHOUSE COMPUTE_XS WITH 
WAREHOUSE_SIZE = 'XSMALL'
WAREHOUSE_TYPE = 'STANDARD'
AUTO_SUSPEND = 600 
AUTO_RESUME = TRUE 
SCALING_POLICY = 'STANDARD';

-- Set context
USE WAREHOUSE COMPUTE_XS;
USE SCHEMA DEMO_SCHEMA;

SELECT * FROM DEMO_TABLE;

-- EXECUTE FROM WITHIN MAIN ACCOUNT
-- Add additional objects
GRANT SELECT ON VIEW DEMO_SEC_VIEW TO SHARE DEMO_SHARE;


-- EXECUTE FROM WITHIN READER ACCOUNT AS SYSADMIN
-- If changes made to a definition of a schema-level object the grant will have to be reissued
SELECT * FROM DEMO_SEC_VIEW;


-- EXECUTE FROM WITHIN MAIN ACCOUNT AS ACCOUNTADMIN
-- Remove access to share from reader account
ALTER SHARE DEMO_SHARE REMOVE ACCOUNTS = <reader_account_locator>; -- e.g we79908

-- Clear-down objects
DROP DATABASE DEMO_DB;
DROP SHARE DEMO_SHARE;