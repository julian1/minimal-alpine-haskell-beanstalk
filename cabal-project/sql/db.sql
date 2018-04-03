

-- non-transaction db creation - that needs to be done as root
-- psql -h postgres.localnet -U admin -d postgres -f db.sql

drop database if exists test; 
drop role if exists test; 

create role test password 'test' login; 
create database test owner test; 

