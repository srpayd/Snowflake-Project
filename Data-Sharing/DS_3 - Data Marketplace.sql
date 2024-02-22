/*----------------D5_5 Hands-on----------------
1) Import share from Data Marketplace
-- From standard listing: https://app.snowflake.com/marketplace/listing/GZ1M7Z2MQ39?search=OAG
----------------------------------------------*/

select *
from public.OAG_schedule
where DEPCTRY='US'
and ARRCITY='PAR'
and flight_date=current_date;