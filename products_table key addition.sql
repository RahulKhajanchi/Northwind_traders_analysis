-- Checking the data of products table.


select * from products;

-- Checking data type of the columns of products table.

describe products;


-- Here we see that productID column has to be the primary key in this table.
 
 -- Checking for null values in the column 'productID'.
 
 
 select * from products 
where productID is NULL;


-- To check if any duplicate values are there in the column 'productID' or not.


select productID , count(*) from products
group by productID
having count(*) > 1;

-- Now, we can make it as a primary key

alter table products
add  primary key(productID);

-- Let's create foreign keys

-- create foreign key on orderID


alter table products
add constraint cat_product foreign key(categoryID) references categories(categoryID);
