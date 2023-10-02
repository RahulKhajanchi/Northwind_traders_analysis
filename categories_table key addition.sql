-- Checking the data of categories table.


select * from categories;

-- Checking data type of the columns of categories table.

describe categories;


-- Here we see that categoryID column has to be the primary key in this table.
 
 -- Checking for null values in the column 'categoryID'.
 
 
 select * from categories 
where categoryID is NULL;


-- To check if any duplicate values are there in the column 'categoryID' or not.


select categoryID , count(*) from categories
group by categoryID
having count(*) > 1;


-- Now, we can make it as a primary key

alter table categories
add  primary key(categoryID);