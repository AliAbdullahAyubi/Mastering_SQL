--Business Analytics
Use RetailDB;
Go

--Q327. Calculate month-over-month revenue growth rate as a percentage.
--Q328. Find the customer retention rate: % of customers who ordered in year N and also in year N+1.
--Q329. Compute the average number of days between consecutive orders per customer.
--Q330. Calculate the product return rate (returns / units sold) for each product.
Select 
	us.*,
	ru.Unit_Returns,
	(ru.Unit_Returns*1.0/us.Unit_Sold) AS return_rate
From
(Select p.ProductID,Sum(od.Quantity) AS Unit_Sold From Products As p Left Join OrderDetails AS od On od.ProductID=p.ProductID Group by p.ProductID) AS us
Left Join
(Select od.ProductID,Sum(od.Quantity) AS Unit_Returns From Returns AS r Inner Join OrderDetails AS od On od.OrderDetailID=r.OrderDetailID Group by od.ProductID) AS ru On ru.ProductID=us.ProductID;
--Q331. Find the revenue contribution of the top 20% of customers (Pareto analysis).
--Q332. Compute the average basket size (items per order) per store.
--Q333. Identify seasonality: which month has the highest average revenue across all years.
--Q334. Calculate inventory turnover ratio per product (Units Sold / Avg Stock).
--Q335. Find cross-sell pairs: products most frequently ordered together.
--Q336. Compute customer lifetime value (total spend) segmented by acquisition year.
--Q337. Identify the 'golden customers': top 10% by spend AND top 10% by order frequency.
--Q338. Calculate employee productivity: revenue generated per employee per store.
--Q339. Find the churn rate by customer tier (customers who stopped ordering).
--Q340. Compute the average review rating trend over time per product.
--Q341. Identify stores where revenue is declining over the last 3 consecutive months.
