/*----------------D3_2 Hands-on----------------
1) Stage types
2) Listing staged data files
3) PUT command
4) Querying staged data files
5) Removing staged data files
----------------------------------------------*/

--Set context
USE ROLE SYSADMIN;

CREATE DATABASE FILMS_DB;
CREATE SCHEMA FILMS_SCHEMA;

CREATE TABLE FILMS
(
ID STRING, 
TITLE STRING, 
RELEASE_DATE DATE
);

-- INTERNAL STAGES
-- list contents of user stage (contains worksheet data)
ls @~;
list @~;

-- list contents of table stage 
ls @%FILMS; 

-- Create internal named stage
CREATE STAGE FILMS_STAGE;

-- list contents of internal named stage 
ls @FILMS_STAGE;

-- EXTERNAL STAGES
-- Create external stage 
CREATE STAGE EXTERNAL_STAGE
  URL='s3://<bucket_name>/path1/'
  storage_integration = s3_int;

-- Create storage integration object
CREATE STORAGE INTEGRATION s3_int
  type = external_stage
  storage_provider = s3
  storage_aws_role_arn = 'arn:aws:iam::001234567890:role/<aws_role_name>'
  enabled = true
  storage_allowed_locations = ('s3://<bucket_name>/path1/', 's3://<bucket_name>/path2/');
  
  
-- PUT command (execute from within SnowSQL)
USE ROLE SYSADMIN;
USE DATABASE FILMS_DB;
USE SCHEMA FILMS_SCHEMA;

-- PUT file://C:\Users\Admin\Downloads\films.csv @~ auto_compress=false;

-- PUT file://C:\Users\Admin\Downloads\films.csv @%FILMS auto_compress=false;

-- PUT file://C:\Users\Admin\Downloads\films.csv @FILMS_STAGE auto_compress=false;

ls @~/films.csv;

ls @%FILMS; 

ls @FILMS_STAGE;


-- Contents of a stage can be queried
SELECT $1, $2, $3 FROM @~/films.csv;

-- Create csv file format to parse files in stage
CREATE FILE FORMAT CSV_FILE_FORMAT
  TYPE = CSV
  SKIP_HEADER = 1;

-- Metadata columns and file format
SELECT metadata$filename, metadata$file_row_number, $1, $2, $3 FROM @%FILMS (file_format => 'CSV_FILE_FORMAT');
-- Pattern
SELECT metadata$filename, metadata$file_row_number, $1, $2, $3 FROM @FILMS_STAGE (file_format => 'CSV_FILE_FORMAT', pattern=>'.*[.]csv') t;
-- Path
SELECT metadata$filename, metadata$file_row_number, $1, $2, $3 FROM @FILMS_STAGE/films.csv (file_format => 'CSV_FILE_FORMAT') t;

-- Remove file from stage
rm @~/films.csv;
rm @%FILMS; 
rm @FILMS_STAGE;
-- remove @~/films.csv;