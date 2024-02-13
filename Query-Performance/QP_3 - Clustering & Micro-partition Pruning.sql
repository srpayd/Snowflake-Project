/*----------------D4_3 Hands-on----------------
1) Clustering information system function 
2) Automatic Clustering usage and cost monitoring 
----------------------------------------------*/

-- Set context
USE ROLE SYSADMIN;
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCDS_SF100TCL;

-- Check cluster_by column to determine if a table has a cluster key(s) 
SHOW TABLES;
SELECT "name", "database_name", "schema_name", "cluster_by" FROM TABLE(result_scan(last_query_id()));


SELECT SYSTEM$CLUSTERING_INFORMATION('CATALOG_SALES');

SELECT SYSTEM$CLUSTERING_INFORMATION('CATALOG_SALES', '(CS_LIST_PRICE)');


SELECT CS_SOLD_DATE_SK, CS_SOLD_TIME_SK, CS_ITEM_SK, CS_ORDER_NUMBER FROM CATALOG_SALES
WHERE CS_SOLD_DATE_SK = 2451092 AND CS_ITEM_SK = 140947;

-- Applying a clustering key

-- CREATE TABLE MY_TABLE (c1 DATE, c2 STRING, c3 NUMBER) CLUSTER BY (c1);

-- ALTER TABLE MY_TABLE CLUSTER BY (c1);

-- Set context
USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE;
USE SCHEMA ACCOUNT_USAGE;

-- Monitoring Automatic Clustering serverless feature costs 
SELECT 
  START_TIME, 
  END_TIME, 
  CREDITS_USED, 
  NUM_BYTES_RECLUSTERED,
  TABLE_NAME, 
  SCHEMA_NAME,
  DATABASE_NAME
FROM AUTOMATIC_CLUSTERING_HISTORY;