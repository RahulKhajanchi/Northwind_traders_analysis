-- Checking the data of orders table.


select * from orders;


-- Checking data type of the columns of orders table.


describe orders;


 -- Here we see that orderID column has to be the primary key in this table.
 -- Checking for null values in the column 'orderID'.
 
 select * from orders 
where orderID is NULL;


-- To check if any duplicate values are there in the column 'orderID' or not.


select order1.orderID from (select * , ROW_NUMBER() over(partition by orderID) as rownum from orders) order1   
join (select * , ROW_NUMBER() over(partition by orderID) as rownum from orders) order2
where order1.orderID = order2.orderID and order1.rownum <> order2.rownum;

-- Now, we can make it as a primary key

alter table orders
modify orderID int primary key;


-- Now, we have to make foreign keys in the table

-- First let's make customerID a foreign key coz we can fetch the details from customers table using that key.

alter table orders
modify customerID varchar(10);

alter table orders
add constraint fk_customer foreign key(customerID) references customers(customerID);

-- employeeID as foreign key 

alter table orders
add constraint fk_employee foreign key(employeeID) references employees(employeeID);

-- shipperID as foreign key 

alter table orders
add constraint fk_shipper foreign key(shipperID) references shippers(shipperID);




