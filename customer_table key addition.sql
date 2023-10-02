-- Checking the data of customers table.


select * from customers;

-- Checking data type of the columns of customers table.

describe customers;


-- Here we see that customerID column has to be the primary key in this table.
 
 -- Checking for null values in the column 'customerID'.
 
 
 select * from customers 
where customerID is NULL;


-- To check if any duplicate values are there in the column 'customerID' or not.


select customerID , count(*) from customers
group by customerID
having count(*) > 1;


-- Now, we can make it as a primary key

alter table customers
modify customerID varchar(10) primary key;
