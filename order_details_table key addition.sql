-- Checking the data of order_details table.


select * from order_details;


-- Checking data type of the columns of order_details table.


describe order_details;

-- Let's create foreign keys

-- create foreign key on orderID


alter table order_details
add constraint fk_order foreign key(orderID) references orders(orderID);


-- create foreign key on productID


alter table order_details
add constraint fk_product foreign key(productID) references products(productID);