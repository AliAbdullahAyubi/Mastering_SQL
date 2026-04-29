--Subqueries
Use RetailDB;
Go

--Q141. Find products priced above the average product price.
Select * From Products
Where UnitPrice > (Select Avg(UnitPrice) From Products);
--Q142. List customers who have spent more than the average customer spending.
Select 
	o.CustomerID,
	Sum(od.Quantity * od.UnitPrice * (1-od.Discount/100)) As Total_Spending_per_Customer
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.CustomerID
Having Sum(od.Quantity * od.UnitPrice * (1-od.Discount/100)) > 
(Select Sum(od.Quantity*od.UnitPrice)/Count(Distinct o.CustomerID) From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID);
--Q143. Show employees earning more than the average salary in their department.
Select 
	e.* 
From Employees As e
Inner Join
(Select 
	e.DepartmentID,
	Avg(e.Salary) As Avg_Salary_per_Dept
From Employees As e
Group by e.DepartmentID) AS DeptWise_AvgSalary On DeptWise_AvgSalary.DepartmentID=e.DepartmentID
Where e.Salary > DeptWise_AvgSalary.Avg_Salary_per_Dept;
--Q144. Find the most expensive product in each category using a subquery.
Select * 
From Products As p
Where p.UnitPrice >= All(Select Products.UnitPrice From Products Where Products.CategoryID=p.CategoryID);
--Q145. List orders with a total value above the average order value.
Select 
	od.OrderID,
	Sum(od.Quantity*od.UnitPrice) Total_Value_per_Order
From OrderDetails As od
Group by od.OrderID
Having Sum(od.Quantity*od.UnitPrice) > (Select Avg(od.Quantity*od.UnitPrice) From OrderDetails AS od);
--Q146. Show products that have been returned at least once.
Select * From Products As p
Where p.ProductID In (Select od.ProductID From OrderDetails As od Inner Join Returns As r On r.OrderDetailID=od.OrderDetailID);
--Q147. Find customers who placed orders in every year from 2021 to 2023.
Select 
	Customer_Order_Year.CustomerID,
	Count(Customer_Order_Year.year) As Count_Year
From (Select 
	o.CustomerID,
	Year(o.OrderDate) AS year
From Orders AS o
Where Year(o.OrderDate) Between 2021 and 2023) As Customer_Order_Year
Group by Customer_Order_Year.CustomerID
Having Count(Distinct Customer_Order_Year.year) = 3;
--Q148. List employees whose salary is in the top 10% of all salaries.
SELECT * FROM Employees
WHERE Salary >= (
    SELECT TOP 1 Salary
    FROM (
        SELECT TOP 10 PERCENT Salary
        FROM Employees
        ORDER BY Salary DESC
    ) AS Top10
    ORDER BY Salary ASC
);
--Q149. Show stores whose revenue is above the median store revenue.
SELECT StoreID, Revenue
FROM (
    SELECT 
        o.StoreID,
        SUM(od.Quantity * od.UnitPrice) AS Revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice)) AS RowNum,
        COUNT(*) OVER () AS Total
    FROM OrderDetails AS od
    INNER JOIN Orders AS o ON o.OrderID = od.OrderID
    GROUP BY o.StoreID
) AS StoreRevenue
WHERE RowNum > Total / 2;

--Q150. Find products that have a higher rating than the category average.
SELECT r.ProductID
FROM Reviews AS r
INNER JOIN Products AS p ON p.ProductID = r.ProductID
WHERE r.Rating > (
    SELECT AVG(r2.Rating)
    FROM Reviews AS r2
    INNER JOIN Products AS p2 ON p2.ProductID = r2.ProductID
    WHERE p2.CategoryID = p.CategoryID  -- correlated: same category
)
GROUP BY r.ProductID;
--Q151. List customers who bought products from more than 3 different categories.
SELECT o.CustomerID
FROM Orders AS o
INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
INNER JOIN Products AS p ON p.ProductID = od.ProductID
GROUP BY o.CustomerID
HAVING COUNT(DISTINCT p.CategoryID) > 3;
--Q152. Show suppliers who supply the most expensive product in their category.
Select 
	p.SupplierID,
	CategoryWise_MaxPrice.CategoryID
From (Select 
	CategoryID,
	Max(UnitPrice) As Max_Price
From Products
Group by CategoryID) As CategoryWise_MaxPrice
Inner Join Products As p On CategoryWise_MaxPrice.Max_Price=p.UnitPrice;

--Q153. Find the second highest salary in the Employees table.
Select TOP 1 With Ties e.Salary From Employees As e
Where e.Salary < (Select Top 1 With Ties Employees.Salary From Employees Order by Employees.Salary Desc)
Order by e.Salary DESC;
--Q154. List employees whose salary is higher than their manager's salary.
Select e.*
From Employees as e
Where e.Salary >(Select m.Salary From Employees as m Where e.ManagerID=m.EmployeeID);
--Q155. Show orders that contain the product 'ProductCode = PRD0001'.
Select o.* From OrderDetails as od
Inner Join Orders As o On o.OrderID=od.OrderID
Where od.ProductID = (Select p.ProductID From Products As p Where p.ProductCode = 'PRD0001');
