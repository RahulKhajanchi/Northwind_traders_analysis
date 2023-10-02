-- Checking the data of employees table.


select * from employees;

-- Checking data type of the columns of employees table.

describe employees;


-- Here we see that employeeID column has to be the primary key in this table.
 
 -- Checking for null values in the column 'employeeID'.
 
 
 select * from employees 
where employeeID is NULL;


-- To check if any duplicate values are there in the column 'employeeID' or not.


select employeeID , count(*) from employees
group by employeeID
having count(*) > 1;

-- Now, we can make it as a primary key

alter table employees
add primary key(employeeID);
