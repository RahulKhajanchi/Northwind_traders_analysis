-- Checking the data of shippers table.


select * from shippers;

-- Checking data type of the columns of shippers table.

describe shippers;


-- Here we see that shipperID column has to be the primary key in this table.
 
 -- Checking for null values in the column 'shipperID'.
 
 
 select * from shippers 
where shipperID is NULL;


-- To check if any duplicate values are there in the column 'shipperID' or not.


select shipperID , count(*) from shippers
group by shipperID
having count(*) > 1;

-- Now, we can make it as a primary key

alter table shippers
add primary key(shipperID);