/*----------------D3_3 Hands-on----------------
1) File formats
2) File format options
3) COPY INTO <table> statement
4) COPY INTO <table> copy options
5) COPY INTO <table> load transformation
6) COPY INTO <table> load validation
----------------------------------------------*/

--Set context
USE ROLE SYSADMIN;
USE DATABASE FILMS_DB;
USE SCHEMA FILMS_SCHEMA;

SELECT $1, $2, $3 FROM @FILMS_STAGE/films.csv (file_format=>'CSV_FILE_FORMAT');

-- Reading file ERROR
COPY INTO FILMS FROM @FILMS_STAGE/films.csv;

-- Set file format options directly on COPY INTO statement
COPY INTO FILMS FROM @FILMS_STAGE/films.csv
FILE_FORMAT = (TYPE='CSV' SKIP_HEADER=1);

-- Set file format object on COPY INTO statement
COPY INTO FILMS FROM @FILMS_STAGE/films.csv
FILE_FORMAT = CSV_FILE_FORMAT;

-- Set file format object on stage
ALTER STAGE FILMS_STAGE SET FILE_FORMAT=CSV_FILE_FORMAT;

COPY INTO FILMS FROM @FILMS_STAGE/films.csv force=true;

-- COPY from table stage
COPY INTO FILMS FROM @%FILMS/films.csv force=true;

-- Set file format on table stage
ALTER TABLE FILMS SET STAGE_FILE_FORMAT=(FORMAT_NAME = 'CSV_FILE_FORMAT');

COPY INTO FILMS FROM @%FILMS/films.csv force=true;

-- FILES copy option
COPY INTO FILMS FROM @FILMS_STAGE
FILE_FORMAT = CSV_FILE_FORMAT
FILES = ('films.csv')
FORCE=true;

-- PATTERN copy option
COPY INTO FILMS FROM @FILMS_STAGE
FILE_FORMAT = CSV_FILE_FORMAT
PATTERN = '.*[.]csv'
FORCE=true;

-- Omit columns
COPY INTO FILMS (ID, TITLE) FROM
( SELECT 
 $1,
 $2
 FROM @%FILMS/films.csv)
FILE_FORMAT = CSV_FILE_FORMAT
FORCE = TRUE;

-- Cast columns
COPY INTO FILMS FROM
( SELECT 
 $1,
 $2,
 to_date($3)
 FROM @%FILMS/films.csv)
FILE_FORMAT = CSV_FILE_FORMAT
FORCE = TRUE;

-- Reorder columns
COPY INTO FILMS FROM
( SELECT 
 $2,
 $1,
 date($3)
 FROM @%FILMS/films.csv)
FILE_FORMAT = CSV_FILE_FORMAT
FORCE = TRUE;


-- VALIDATION MODE copy option. Possible values: RETURN_<number>_ROWS, RETURN_ERRORS, RETURN_ALL_ERRORS
COPY INTO FILMS FROM @FILMS_STAGE/films.csv
VALIDATION_MODE = 'RETURN_ROWS';

-- Validate function to validate historical copy into execution via query id
COPY INTO FILMS FROM @FILMS_STAGE
FILE_FORMAT = (TYPE='CSV', SKIP_HEADER=0)
ON_ERROR=CONTINUE
FILES = ('films.csv')
FORCE=true;

SELECT * FROM TABLE(VALIDATE(FILMS, job_id=>'<failed_job_id>'));