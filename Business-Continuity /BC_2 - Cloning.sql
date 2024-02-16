/*----------------D6_2 Hands-on----------------
1) Clone objects
2) Cloning and Time Travel
----------------------------------------------*/

-- Set context
USE ROLE SYSADMIN;

CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

CREATE TABLE DEMO_TABLE
(
ID STRING, 
FIRST_NAME STRING, 
AGE NUMBER
);

INSERT INTO DEMO_TABLE VALUES ('55D899','Edric',56),('MMD829','Jayanthi',23);

-- Cloning is metadata operation only, no data is transferred: "zero-copy" cloning
CREATE TABLE DEMO_TABLE_CLONE CLONE DEMO_TABLE;

SELECT * FROM DEMO_TABLE_CLONE;

-- We can create clones of clones
CREATE TABLE DEMO_TABLE_CLONE_TWO CLONE DEMO_TABLE_CLONE;

SELECT * FROM DEMO_TABLE_CLONE_TWO;

-- Easily and quickly create entire database from existing database
CREATE DATABASE DEMO_DB_CLONE CLONE DEMO_DB;

USE DATABASE DEMO_DB_CLONE;
USE SCHEMA DEMO_SCHEMA;

-- Cloning is recursive for databases and schemas
SHOW TABLES;

SELECT * FROM DEMO_TABLE;

-- Data added to cloned database table will start to store micro-partitions, incurring additional cost
INSERT INTO DEMO_TABLE VALUES ('7DM899','Chloe',51);

-- cloned table
SELECT * FROM DEMO_TABLE;

-- source table unchanged
SELECT * FROM "DEMO_DB"."DEMO_SCHEMA"."DEMO_TABLE";

-- Create clone from point in past with Time Travel 
CREATE OR REPLACE TABLE DEMO_TABLE_CLONE_TIME_TRAVEL CLONE DEMO_TABLE
AT(OFFSET => -60*2);

SELECT * FROM DEMO_TABLE_CLONE_TIME_TRAVEL;

-- Clear-down resources
DROP DATABASE DEMO_DB;
DROP DATABASE DEMO_DB_CLONE;