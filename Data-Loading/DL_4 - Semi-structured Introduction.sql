/*----------------D3_4 Hands-on----------------
1) JSON file format 
2) JSON file format options
3) Three methods of semi-structured data loading: ELT, ETL, Automatic Schema Detection
4) Querying semi-structured data
5) Semi-structured functions
----------------------------------------------*/

--Set context
USE ROLE SYSADMIN;
USE DATABASE FILMS_DB;
USE SCHEMA FILMS_SCHEMA;

-- Create JSON file format object with default options
CREATE OR REPLACE FILE FORMAT JSON_FILE_FORMAT
TYPE='JSON',
FILE_EXTENSION=NULL,
DATE_FORMAT='AUTO',
TIME_FORMAT='AUTO',
TIMESTAMP_FORMAT='AUTO',
BINARY_FORMAT='HEX',
TRIM_SPACE=FALSE,
NULL_IF='',
COMPRESSION='AUTO',
ENABLE_OCTAL=FALSE,
ALLOW_DUPLICATE=FALSE,
STRIP_OUTER_ARRAY=FALSE,
STRIP_NULL_VALUES=FALSE,
IGNORE_UTF8_ERRORS=FALSE,
REPLACE_INVALID_CHARACTERS=FALSE,
SKIP_BYTE_ORDER_MARK=TRUE;

-- PUT command (execute from within SnowSQL)
USE ROLE SYSADMIN;
USE DATABASE FILMS_DB;
USE SCHEMA FILMS_SCHEMA;

--PUT file://C:\Users\Admin\Downloads\films.json @FILMS_STAGE auto_compress=false;

CREATE OR REPLACE TABLE FILMS_ELT (
JSON_VARIANT VARIANT
);

COPY INTO FILMS_ELT
FROM @FILMS_STAGE/films.json
FILE_FORMAT = JSON_FILE_FORMAT;

SELECT JSON_VARIANT FROM FILMS_ELT;

TRUNCATE TABLE FILMS_ELT;

-- Query semi-structured data type
SELECT 
json_variant:id as id, 
json_variant:title as title, 
json_variant:release_date AS release_date, 
json_variant:release_date::date AS release_date_dd_cast, 
to_date(json_variant:release_date) AS release_date_func_cast,
json_variant:actors AS actors,
json_variant:actors[0] as first_actor,
json_variant:ratings AS ratings,
json_variant:ratings.imdb_rating AS IMDB_rating
FROM FILMS_ELT
WHERE release_date >= date('2000-01-01');

-- Query semi-structured data type - case sensitivity
SELECT 
json_variant:id as id, 
json_variant:Title as title, 
json_variant:release_date::date AS release_date, 
json_variant:actors[0] as first_actor,
json_variant:RATINGS.imdb_rating AS IMDB_rating
FROM FILMS_ELT
WHERE release_date >= date('2000-01-01');

-- Query semi-structured data type with bracket notation
SELECT 
json_variant['id'] as id, 
json_variant['title'] as title, 
json_variant['release_date']::date AS release_date, 
json_variant['actors'][0] as first_actor,
json_variant['ratings']['imdb_rating'] AS IMDB_rating
FROM FILMS_ELT
WHERE release_date >= date('2000-01-01');

-- Flatten table function
select json_variant:title, json_variant:ratings from films_ELT limit 1;

SELECT * FROM TABLE(FLATTEN(INPUT => select json_variant:ratings from films_ELT limit 1)) ;

SELECT VALUE FROM TABLE(FLATTEN(INPUT => select json_variant:ratings from films_ELT limit 1));

-- Lateral Flatten
SELECT 
json_variant:title,
json_variant:release_date::date,
L.value 
FROM FILMS_ELT F,
LATERAL FLATTEN(INPUT => F.json_variant:ratings) L
LIMIT 2;
 
 
CREATE OR REPLACE TABLE FILMS_ETL (
ID STRING, 
TITLE STRING, 
RELEASE_DATE DATE, 
STARS ARRAY, 
RATINGS OBJECT
);

COPY INTO FILMS_ETL FROM
(SELECT
$1:id,
$1:title,
$1:release_date::date,
$1:actors,
$1:ratings
FROM @FILMS_STAGE/films.json)
FILE_FORMAT = JSON_FILE_FORMAT
FORCE=TRUE;

SELECT * FROM FILMS_ETL;

SELECT 
ID, 
TITLE, 
RELEASE_DATE, 
STARS[0]::string AS FIRST_STAR, 
RATINGS['imdb_rating'] AS imdb_rating 
FROM FILMS_ETL;

-- Match by column name
TRUNCATE TABLE FILMS_ETL;

COPY INTO FILMS_ETL
FROM @FILMS_STAGE/films.json
FILE_FORMAT = JSON_FILE_FORMAT
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
FORCE=TRUE;

SELECT * FROM FILMS_ETL;

DROP DATABASE FILMS_DB;