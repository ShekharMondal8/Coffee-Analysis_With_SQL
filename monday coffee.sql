                           -- MONDAY COFFEE -DATA ANALYSIS--
                           
                           
Select*from city;

-- coffee Customers count ?
-- How Many People in city are estimated to comsume coffee ,given that 25% of the Population  does?

Select city_name, 
       Round ( (Population *0.25)/1000000,2)
       city_rank
From city
Order By 2 DESC;

-- Total Revenue From coffee Sales
-- What is The Total Revenue generateed from coffee sales across all citiesin the last quarter of 2023?
Select
      Sum(total) as total_revene
From sales
Where
       Extract(year From sale_date) =2023 
       and 
	Extract(quarter From sale_date)= 4;
    
    Select 
    ci.city_name,
      Sum(total) as total_revenue
      From sales as s
      Join customers as c 
      On s.customer_id= c.customer_id
      Join city as ci 
      On ci.city_id= c.city_id
      Where
         Extract(year From sale_date) =2023 
            and 
	     Extract(quarter From sale_date)= 4
         Group By city_name
         order by 2 DESC;
    
 -- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?


Select 
 ci.city_name,
 p.product_name,
 COUNT(s.sale_id) as total_orders,
 Dense_Rank() over(Partition By ci.city_name Order By COUNT(s.sale_id) Desc) 
From sales as s
Join products as p
On s.product_id = p.product_id 
Join customers as c
On c.customer_id = s.customer_id
Join city as ci
On ci.city_id = c.city_id
Group By 1, 2;
   
    -- Average Sales Amount per City
-- What is the average sales amount per customer in each city?


    Select 
    ci.city_name,
      Sum(s.total) as total_revenue,
      Count(Distinct s.customer_id)as total_cx	,
	Round( 
    Sum(s.total)/Count(Distinct s.customer_id),2)
	   as avg_sale_pr_cx
      From sales as s
      Join customers as c 
      On s.customer_id= c.customer_id
      Join city as ci 
      On ci.city_id= c.city_id
      
         Group By 1
         order by 2 DESC;
  
    
    
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?
Select 
	p.product_name,
	Count(s.sale_id) as total_orders
From products as p
Left Join
sales as s
On s.product_id = p.product_id
Group By product_name
Order By 2 DESC;


-- City Population and Coffee Consumers 25%
-- Provide a list of cities along with their populations and estimated coffee consumers.

With city_table as 
(
Select 
	city_name,
	ROUND((population * 0.25)/1000000, 2) as coffee_consumers
	From city
 
 ),
customers_table
AS
(
	Select 
	ci.city_name,
	COUNT(Distinct c.customer_id) as unique_cx
	From sales as s
	Join customers as c
	On c.customer_id = s.customer_id
	Join city as ci
	On ci.city_id = c.city_id
	Group BY 1

)
Select 
customers_table.city_name,
city_table.coffee_consumers as coffee_consumer_in_millions,
customers_table.unique_cx
From city_table
Join 
customers_table
ON city_table.city_name = customers_table.city_name;





