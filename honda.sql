show databases;
create database honda;
use honda;
create table hondacanada(
Install_Customer int not null,
Bill_Customer_Number int not null,
Customer_Name varchar(20),
Address text,
City text,
State_Province text,
Postal_Code text,
Original_Contract_Number text,
Contract_Number text,
Current_Period text,
Term int,
Frequency text,
Adv_Arr_Indicator text,
Transaction_Type_Code text,
Customer_Reference_1 text,
Customer_Reference_2 text,
Product_Description text,
Machine_Type text,
Model text,
Serial text,
MES_Number text,
Manufacturer_Serial_Number text,
Net_Amount_Financed decimal(10,2),
Lease_Type text,
Current_Period_Bill_Amount decimal(10,2),
Flat_Profile text,
Billing_Start_Date date,
Billing_End_Date date,
New_Lease_Start_Date date,
New_Lease_End_Date date
);
describe hondacanada;
show variables like '%secure%';

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\hondacanada.csv'
into table hondacanada
fields terminated by ','
enclosed by ''
enclosed by '\\'
lines terminated by '\r\n'
starting by ''
ignore 1 lines;

show variables like 'character%';
show tables;
drop table hondacanada;
select * from hondacanada;
select sum(Net_Amount_Financed) from hondacanada;
select sum(Current_Period_Bill_Amount) from hondacanada;
truncate table hondacanada;

select count(p.*) from (select distinct a.* from hondacanada as a) as p;
# 2940 distinct rows in total 
with base as (select distinct * from hondacanada)
select count(*) from base;

help table hondacanada;
table type hondacanada;


select * from hondacanada;

#2932 distinct rows
select count(distinct Install_Customer, Serial) from hondacanada;

select Install_Customer, Serial, count(*) as ccc from hondacanada
group by 1, 2
having ccc>1
order by 3 DESC;


# distinct 2940 rows, primary key
select count(distinct Install_Customer, Serial, Contract_Number) from hondacanada;

#select different address
select distinct address from hondacanada;

#simple current period bill amount, 4700 Industrial PKY:190820.45, 180 Honda Blvd:70445.93, 6900 Industrial PKY:914.74
select sum(current_period_bill_amount)
from hondacanada;

#current period bill amount in April 2021
select address, sum(current_period_bill_amount)
from hondacanada
where billing_End_Date >'2021/4/30'
group by address;

# avg term in 3 officies
select address, avg(term), count(term)
from hondacanada
group by address
order by 2 desc;

#term situation in various transaction type
select avg(term), transaction_type_code, count(term), concat(round(count(term)*100/(select count(*) from hondacanada),2),'%')
from hondacanada
group by transaction_type_code;

#term in 180 honda
select  avg(term), transaction_type_code, count(term), concat(round(count(term)*100/(select count(*) from hondacanada where address='180 HONDA BLVD'),2),'%')
from hondacanada
where address ='180 HONDA BLVD'
group by transaction_type_code;

#term in 4700 honda
select  avg(term), transaction_type_code, count(term), concat(round(count(term)*100/(select count(*) from hondacanada where address='4700 INDUSTRIAL PKY'),2),'%')
from hondacanada
where address ='4700 INDUSTRIAL PKY'
group by transaction_type_code;

#term in 6900 honda
select  avg(term), transaction_type_code, count(term), concat(round(count(term)*100/(select count(*) from hondacanada where address='6900 INDUSTRIAL PKY'),2),'%')
from hondacanada
where address ='6900 INDUSTRIAL PKY'
group by transaction_type_code;

#number of transaction in 3 addresses
select address, count(*) from hondacanada group by address;

#net amount financed
select address, sum(net_amount_financed), concat(round(sum(net_amount_financed)*100/(select sum(net_amount_financed) from hondacanada),2),'%') 
from hondacanada 
group by address;

# compare billing start date, which is valid in April 2021 
select year(billing_start_date)as year, transaction_type_code, count(install_customer) as number_of_transaction
from hondacanada
where billing_end_date >'2021/3/31'
group by year, transaction_type_code
order by year;

#compare billing end date, valid in April 2021
select year(billing_end_date)as year, transaction_type_code, count(Install_customer) as number_of_transaction
from hondacanada
where billing_end_date >'2021/3/31'
group by year, transaction_type_code
order by year;

#lease type, transaction type
select count(Install_customer), transaction_type_code, lease_type
from hondacanada
group by transaction_type_code, lease_type;

#top 10 product description
select product_description, count(*)
from hondacanada
group by product_description
order by count(*) desc
limit 10;

#average current bill amount
select avg(current_period_bill_amount),count(*), product_description
from hondacanada
where billing_end_date >='2021/4/1'
group by product_description
order by avg(current_period_bill_amount) desc;

show tables;