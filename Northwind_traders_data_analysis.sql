-- Total Sales trends over time.

select *  from order_details , products;

-- First we create a view to create and store the revenue table 


create view revenue_table as (select o.orderID , o.productID , o.unitPrice , o.quantity , o.discount  , case when 
               discontinued = 0
               then
               round((o.unitPrice * o.quantity) * (1-o.discount) , 1 ) 
               else 0.0
               end
               as revenue 
               from order_details o join products p on o.productID = p.productID);
               
 
  
-- Now we create 2 more CTE of dayrevenue and daycount.
  
with 
dayrevenue as (select o.orderDate , round(sum(r.revenue),1) as Total_Revenue from orders o join revenue_table r on o.orderID = r.orderID
			   group by o.orderDate) , 
daycount as (select o.orderDate , count(*) as orderCount from orders o
			 group by o.orderDate)
select dr.orderDate , dr.Total_Revenue , dc.orderCount  from dayrevenue dr join daycount dc on dr.orderDate = dc.orderDate
order by orderDate;
             
             
             
-- Which are the best and worst-selling products?

-- Top 5 products

with top_products as ( select p.productName ,  case when 
               discontinued = 0
               then
               round((o.unitPrice * o.quantity) * (1-o.discount) , 1 ) 
               else 0.0
               end
               as revenue from order_details o join products p on o.productID = p.productID 
               where p.discontinued = 0)
select productName , round(sum(revenue) ,1) as Total_revenue from top_products
group by productName
order by Total_revenue desc
limit 5;

-- Bottom 5 products

with bottom_products as ( select p.productName ,  case when 
               discontinued = 0
               then
               round((o.unitPrice * o.quantity) * (1-o.discount) , 1 ) 
               else 0.0
               end
               as revenue from order_details o join products p on o.productID = p.productID
               where p.discontinued = 0)
select productName , round(sum(revenue) ,1) as Total_revenue from bottom_products
group by productName
order by Total_revenue asc;


-- Key customers

with 
customerorderrevenue as (select c.companyName, round(sum(r.revenue),1) as Total_Revenue from orders o join revenue_table r
						 on o.orderID = r.orderID
						 join customers c on o.customerID = c.customerID
						 group by c.companyName) , 
customerordercount as (select c.companyName , count(*) as orderCount from orders o 
                       join customers c on o.customerID = c.customerID
					   group by c.companyName)
select cor.companyName , cor.Total_Revenue , coc.orderCount  from customerorderrevenue cor join 
customerordercount coc on cor.companyName = coc.companyname
order by cor.Total_Revenue desc;


-- Most revenue generating countries


with 
customerorderrevenue as (select c.country, round(sum(r.revenue),1) as Total_Revenue from orders o join revenue_table r
						 on o.orderID = r.orderID
						 join customers c on o.customerID = c.customerID
						 group by c.country) , 
customerordercount as (select c.country , count(*) as orderCount from orders o 
                       join customers c on o.customerID = c.customerID
					   group by c.country)
select cor.country , cor.Total_Revenue , coc.orderCount  from customerorderrevenue cor join 
customerordercount coc on cor.country = coc.country
order by cor.Total_Revenue desc;


-- Shipping costs of different providers.

with shippingcost as ( select s.companyName , round(sum(o.freight) , 1) as Total_cost from orders o join shippers s 
                        on o.shipperID = s.shipperID
                        group by s.companyName)
select * from shippingcost
order by Total_cost desc;

  -- All time revenue distribution % product category wise 
  
  with productdistribution as ( select c.categoryName , case when 
               p.discontinued = 0
               then
               round((o.unitPrice * o.quantity) * (1-o.discount) , 1 ) 
               else 0.0
               end
               as revenue  from order_details o join products p 
                                on o.productID = p.productID
                                join categories c on p.categoryID = c.categoryID)  ,
      categorysales as (select categoryName , round(sum(revenue) ,1) as total_category_revenue
                      from productdistribution
					  group by productdistribution.categoryName)
select categoryName , round((total_category_revenue / s.total) * 100, 1) as percent
from categorysales cs cross join (select sum(total_category_revenue) as total from categorysales) s
order by percent desc;

-- Each month best product

  with productdistribution as ( select month(str_to_date(ord.orderDate , '%Y-%m-%d')) as OrderMonth,c.categoryName ,
               case when 
               p.discontinued = 0
               then
               round((o.unitPrice * o.quantity) * (1-o.discount) , 1 ) 
               else 0.0
               end
               as revenue  from orders ord join order_details o
								on ord.orderID = o.orderID join products p 
                                on o.productID = p.productID
                                join categories c on p.categoryID = c.categoryID)  ,
      categorysales as (select OrderMonth , categoryName , round(sum(revenue) ,1) as total_category_revenue
                      from productdistribution
					  group by OrderMonth , categoryName)
select OrderMonth , categoryName , total_category_revenue ,  rank() over (partition by OrderMonth Order by total_category_revenue desc) as rank_num
from categorysales 
order by rank_num , OrderMonth
limit 12;