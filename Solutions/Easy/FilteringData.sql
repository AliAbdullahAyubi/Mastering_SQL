--Filtering Data
Use RetailDB;
Go
--Q31. Find all customers from 'USA'.
Select *
From Customers
Where Country = 'USA';
--Q32. Find all products with UnitPrice greater than 50.
Select *
From Products
Where UnitPrice > 50.0;
--Q33. List employees with Salary less than 40000.
Select *
From Employees
Where Salary < 40000;
--Q34. Show all orders with Status = 'Delivered'.
Select *
From Orders
Where Status = 'Delivered';
--Q35. Find all customers whose CustomerTier is 'Gold'.
Select *
From Customers
Where CustomerTier = 'Gold';
--Q36. List products that are discontinued (Discontinued = 1).
Select *
From Products
Where Discontinued = 1;
--Q37. Show employees hired after '2018-01-01'.
Select *
From Employees
Where HireDate > '2018-01-01';
--Q38. Find all orders placed in the year 2023.
Select *
From Orders
Where Year(OrderDate) = '2023';

--Q39. List customers with LoyaltyPoints greater than 500.
Select *
From Customers
Where LoyaltyPoints > 500;
--Q40. Show products with StockQuantity below 20.
Select *
From Products
Where StockQuantity < 20;
--Q41. Find all stores of type 'Online'.
Select *
From Stores
Where StoreType = 'Online';
--Q42. Show orders with PaymentMethod = 'Card'.
Select *
From Orders
Where PaymentMethod = 'Card';
--Q43. List employees in DepartmentID = 1 (Sales).
Select *
From Employees
Where DepartmentID = 1;
--Q44. Find customers born before 1990.
Select *
From Customers
Where Year(BirthDate) < '1990';
--Q45. List all products where CostPrice is NULL.
Select *
From Products
Where CostPrice is Null;
--Q46. Show employees whose Salary is between 30000 and 60000.
Select *
From Employees
Where Salary Between 30000 and 60000;
--Q47. Find orders placed between '2022-01-01' and '2022-12-31'.
Select *
From Orders
Where OrderDate Between '2022-01-01' and '2022-12-31';
--Q48. List products with UnitPrice between 10 and 100.
Select *
From Products
Where UnitPrice Between 10 and 100;
--Q49. Show customers with LoyaltyPoints between 100 and 1000.
Select *
From Customers
Where LoyaltyPoints Between 100 and 1000;
--Q50. Find employees with Salary NOT between 50000 and 80000.
Select *
From Employees
Where Salary Not Between 50000 and 80000;
--Q51. Find customers whose LastName starts with 'S'.
Select *
From Customers
Where LastName Like 'S%';
--Q52. List products whose ProductName contains 'Pro'.
Select *
From Products
Where ProductName Like '%Pro%';
--Q53. Show employees whose Email ends with '@company.com'.
Select *
From Employees
Where Email Like '%@company.com';
--Q54. Find customers whose city is either 'New York' or 'London'.
Select *
From Customers
Where City In ('New York', 'London');
--Q55. List orders where Status IN ('Pending', 'Processing').
Select *
From Orders
Where Status In ('Pending', 'Processing');
--Q56. Show products supplied by SupplierID IN (1, 2, 3).
Select *
From Products
Where SupplierID In (1,2,3);
--Q57. Find employees in departments 2, 3, or 5.
Select *
From Employees
Where DepartmentID in (2,3,5);
--Q58. List customers NOT from 'USA'.
Select *
From Customers
Where Country <> 'USA';
--Q59. Show orders with Status NOT IN ('Cancelled', 'Returned').
Select *
From Orders 
Where Status Not In ('Cancelled', 'Returned');
--Q60. Find products NOT in CategoryID 1.
Select *
From Products
Where CategoryID <> 1;
--Q61. List employees where ManagerID IS NULL (top-level managers).
Select *
From Employees
Where ManagerID Is Null;
--Q62. Find customers with no phone number (Phone IS NULL).
Select *
From Customers
Where Phone Is Null;
--Q63. Show products with a non-null Description.
Select *
From Products
Where Description Is Not Null;
--Q64. List orders where ShippedDate IS NULL.
Select *
From Orders
Where ShippedDate Is Null;
--Q65. Find suppliers with a NULL Rating.
Select *
From Suppliers
Where Rating Is Null;
