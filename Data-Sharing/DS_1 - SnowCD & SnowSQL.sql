/*----------------D5_3 Hands-on----------------
1) Configuring SnowSQL
2) Querying with SnowSQL
3) Variables in SnowSQL
----------------------------------------------*/

-- snowsql -a <account_locato>.<region>.<cloud_provider> -u admin 

snowsql -a go44755.eu-west-2.aws -u admin 

snowsql -a go44755.eu-west-2.aws -u admin -r ACCOUNTADMIN -w COMPUTE_WH -d SNOWFLAKE_SAMPLE_DATA -s TPCH_SF1

DESC TABLE CUSTOMER;

-- Query option

snowsql -q "select current_role()"

-- File option

New-Item .\query_file.sql

Set-Content .\query_file.sql "select current_role();"

snowsql -f .\query_file.sql

-- Variables

snowsql -D table_name=DEMO_TABLE -o variable_substitution=true

select $table_name;

select '&table_name';

!define table_name_two=DEMO_TABLE_TWO

!variables




