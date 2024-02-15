/*----------------D3_1 Hands-on----------------
1) INSERT statement variations 
2) Uploading data via the UI
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

-- Clone only structure
CREATE TABLE FILMS_2000 CLONE FILMS;

-- Insert one row via a select query without specifying columns
INSERT INTO FILMS SELECT 'fi3p9f8hu8', 'Parasite', DATE('2019-05-30');
                                                      
-- Insert one row via a select query and specify columns (omit release date column)
INSERT INTO  FILMS (ID, TITLE) SELECT 'dm8d7g7mng', '12 Angry Men';

-- Insert one row via VALUES syntax
INSERT INTO FILMS VALUES ('ily1n9muxd','Back to the Future',DATE('1985-12-04'));

-- Insert multiple rows via VALUES syntax
INSERT INTO FILMS VALUES 
('9x3wnr0zit', 'Citizen Kane', DATE('1942-01-24')),
('2wyaojnzfq', 'Old Boy', DATE('2004-10-15')), 
('0s0smukk2p', 'Ratatouille', DATE('2007-06-29'));

SELECT * FROM FILMS;

-- Insert all rows from another table - must be structually identical
INSERT INTO FILMS_2000 SELECT * FROM FILMS WHERE RELEASE_DATE > DATE('2000-01-01');

-- Executing previous statement twice will load duplicates
SELECT * FROM FILMS_2000;

-- Effectively truncates tables and inserts select statement
INSERT OVERWRITE INTO FILMS_2000 SELECT * FROM FILMS;

SELECT * FROM FILMS_2000;

-- Clear-down resources
DROP DATABASE FILMS_DB;