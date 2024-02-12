/*----------------D5_2 Hands-on----------------
1) User Defined Functions (UDFs)
2) External Functions 
3) Stored Procedures
----------------------------------------------*/

-- Set context 
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;

-- Create demo database and schema
CREATE DATABASE DEMO_DB;
CREATE SCHEMA DEMO_SCHEMA;

--Set context
USE DATABASE DEMO_DB;
USE SCHEMA DEMO_SCHEMA;

--User Defined Functions

-- SQL UDF to return the name of the day of the week on a date in the future
CREATE OR REPLACE FUNCTION DAY_NAME_ON(num_of_days int)
RETURNS STRING
  AS
  $$
    select 'In ' || CAST(num_of_days AS string) || ' days it will be a ' || dayname(dateadd(day,num_of_days, current_date()))
  $$; 
  -- single quote can be used instead of dollar sign to delimit function body
  
  
-- Use the SQL UDF as part of a query. 
SELECT DAY_NAME_ON(100);


-- JavaScript UDF to return the name of the day of the week on a date in the future
CREATE OR REPLACE FUNCTION JS_DAY_NAME_ON(num_of_days float)
RETURNS STRING
LANGUAGE JAVASCRIPT
  AS
  $$
    const weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
    
    const date = new Date();
    date.setDate(date.getDate() + NUM_OF_DAYS);
    let day = weekday[date.getDay()];
    
    var result = 'In ' + NUM_OF_DAYS + ' days it will be a '+ day; 
   
    return result;
  $$;

-- Use the JavaScript UDF as part of a query. 
SELECT JS_DAY_NAME_ON(100);
  
-- Overloading JavaScript UDF (all UDF languages can be overloaded)
CREATE OR REPLACE FUNCTION JS_DAY_NAME_ON(num_of_days float, is_abbr boolean)
RETURNS STRING
LANGUAGE JAVASCRIPT
  AS
  $$
    if (IS_ABBR === 1){
        var weekday = ["Sun","Mon","Tues","Wed","Thu","Fri","Sat"];
    } else {
        var weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
    }    
    
    const date = new Date();
    date.setDate(date.getDate() + NUM_OF_DAYS);
    
    
    let day = weekday[date.getDay()];
    
    var result = 'In ' + NUM_OF_DAYS + ' days it will be a '+ day; 
   
    return result;
  $$;


-- Use the JavaScript UDF as part of a query. 
SELECT JS_DAY_NAME_ON(100,TRUE);
SELECT JS_DAY_NAME_ON(100,FALSE);


-- External Function 
    
CREATE OR REPLACE API INTEGRATION demonstration_external_api_integration_01
    API_PROVIDER=aws_api_gateway
    API_AWS_ROLE_ARN='arn:aws:iam::123456789012:role/my_cloud_account_role'
    API_ALLOWED_PREFIXES=('https://xyz.execute-api.us-west-2.amazonaws.com/production')
    ENABLED=true;

CREATE OR REPLACE EXTERNAL FUNCTION local_echo(string_col varchar)
    RETURNS variant
    API_INTEGRATION = demonstration_external_api_integration_01 -- API Integration object
    AS 'https://xyz.execute-api.us-west-2.amazonaws.com/production/remote_echo'; -- Proxy service URL

SELECT my_external_function(34, 56);

-- Stored procedure JavaScript

-- Create demo tables and insert data to test procedure
CREATE TABLE DEMO_TABLE 
(
NAME STRING, 
AGE INT
);

CREATE TABLE DEMO_TABLE_2 
(
NAME STRING, 
AGE INT
);
    
INSERT INTO DEMO_TABLE VALUES ('Edric',56),('Jayanthi',23),('Chloe',51),('Rowland',50),('Lorna',33),('Satish',19);
INSERT INTO DEMO_TABLE_2 VALUES ('Edric',56),('Jayanthi',23),('Chloe',51),('Rowland',50),('Lorna',33),('Satish',19);

SELECT COUNT(*) FROM DEMO_TABLE;
SELECT COUNT(*) FROM DEMO_TABLE_2;


CREATE OR REPLACE PROCEDURE TRUNCATE_ALL_TABLES_IN_SCHEMA(DATABASE_NAME STRING, SCHEMA_NAME STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS OWNER -- can also be executed as 'caller'
    AS
    $$
    var result = [];
    var namespace = DATABASE_NAME + '.' + SCHEMA_NAME;
    var sql_command = 'SHOW TABLES in ' + namespace ; 
    var result_set = snowflake.execute({sqlText: sql_command});
    while (result_set.next()){
        var table_name = result_set.getColumnValue(2);
        var truncate_result = snowflake.execute({sqlText: 'TRUNCATE TABLE ' + table_name});
        result.push(namespace + '.' + table_name + ' has been sucessfully truncated.');
        
    }
    return result.join("\n"); 
    $$;


-- Calling a stored procedure cannot be used as part of a SQL statement, dissimilar to a UDF. 
CALL TRUNCATE_ALL_TABLES_IN_SCHEMA('DEMO_DB', 'DEMO_SCHEMA');

SELECT COUNT(*) FROM DEMO_TABLE;
SELECT COUNT(*) FROM DEMO_TABLE_2;

-- Clear-down objects
DROP DATABASE DEMO_DB;