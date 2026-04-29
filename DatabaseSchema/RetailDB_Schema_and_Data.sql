-- ============================================================
-- RetailDB: A Comprehensive Practice Database for SQL Learners
-- Compatible with SQL Server (T-SQL)
-- ============================================================

-- ============================================================
-- SECTION 1: CREATE DATABASE
-- ============================================================
CREATE DATABASE RetailDB;
GO
USE RetailDB;
GO

-- ============================================================
-- SECTION 2: CREATE TABLES
-- ============================================================

-- 1. Regions
CREATE TABLE Regions (
    RegionID    INT PRIMARY KEY IDENTITY(1,1),
    RegionName  VARCHAR(50) NOT NULL,
    Country     VARCHAR(50) NOT NULL
);

-- 2. Stores
CREATE TABLE Stores (
    StoreID     INT PRIMARY KEY IDENTITY(1,1),
    StoreName   VARCHAR(100) NOT NULL,
    RegionID    INT FOREIGN KEY REFERENCES Regions(RegionID),
    City        VARCHAR(50),
    OpenDate    DATE,
    StoreType   VARCHAR(20) CHECK (StoreType IN ('Mall','Street','Online','Warehouse'))
);

-- 3. Departments
CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY IDENTITY(1,1),
    DeptName       VARCHAR(50) NOT NULL,
    Budget         DECIMAL(12,2)
);

-- 4. Employees
CREATE TABLE Employees (
    EmployeeID     INT PRIMARY KEY IDENTITY(1,1),
    FirstName      VARCHAR(50) NOT NULL,
    LastName       VARCHAR(50) NOT NULL,
    Email          VARCHAR(100) UNIQUE,
    Phone          VARCHAR(20),
    HireDate       DATE,
    JobTitle       VARCHAR(50),
    Salary         DECIMAL(10,2),
    DepartmentID   INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    StoreID        INT FOREIGN KEY REFERENCES Stores(StoreID),
    ManagerID      INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    Gender         CHAR(1) CHECK (Gender IN ('M','F','O')),
    BirthDate      DATE
);

-- 5. Categories
CREATE TABLE Categories (
    CategoryID     INT PRIMARY KEY IDENTITY(1,1),
    CategoryName   VARCHAR(50) NOT NULL,
    ParentCategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID)
);

-- 6. Suppliers
CREATE TABLE Suppliers (
    SupplierID     INT PRIMARY KEY IDENTITY(1,1),
    SupplierName   VARCHAR(100) NOT NULL,
    ContactName    VARCHAR(100),
    Email          VARCHAR(100),
    Phone          VARCHAR(20),
    Country        VARCHAR(50),
    City           VARCHAR(50),
    Rating         DECIMAL(3,1) CHECK (Rating BETWEEN 1 AND 5)
);

-- 7. Products
CREATE TABLE Products (
    ProductID      INT PRIMARY KEY IDENTITY(1,1),
    ProductName    VARCHAR(100) NOT NULL,
    CategoryID     INT FOREIGN KEY REFERENCES Categories(CategoryID),
    SupplierID     INT FOREIGN KEY REFERENCES Suppliers(SupplierID),
    UnitPrice      DECIMAL(10,2) NOT NULL,
    CostPrice      DECIMAL(10,2),
    StockQuantity  INT DEFAULT 0,
    ReorderLevel   INT DEFAULT 10,
    Discontinued   BIT DEFAULT 0,
    ProductCode    VARCHAR(20) UNIQUE,
    Weight         DECIMAL(8,2),
    Description    VARCHAR(500)
);

-- 8. Customers
CREATE TABLE Customers (
    CustomerID     INT PRIMARY KEY IDENTITY(1,1),
    FirstName      VARCHAR(50) NOT NULL,
    LastName       VARCHAR(50) NOT NULL,
    Email          VARCHAR(100) UNIQUE,
    Phone          VARCHAR(20),
    BirthDate      DATE,
    Gender         CHAR(1) CHECK (Gender IN ('M','F','O')),
    City           VARCHAR(50),
    Country        VARCHAR(50),
    JoinDate       DATE,
    LoyaltyPoints  INT DEFAULT 0,
    CustomerTier   VARCHAR(20) CHECK (CustomerTier IN ('Bronze','Silver','Gold','Platinum'))
);

-- 9. Orders
CREATE TABLE Orders (
    OrderID        INT PRIMARY KEY IDENTITY(1,1),
    CustomerID     INT FOREIGN KEY REFERENCES Customers(CustomerID),
    StoreID        INT FOREIGN KEY REFERENCES Stores(StoreID),
    EmployeeID     INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    OrderDate      DATETIME,
    RequiredDate   DATE,
    ShippedDate    DATE,
    Status         VARCHAR(20) CHECK (Status IN ('Pending','Processing','Shipped','Delivered','Cancelled','Returned')),
    ShipCity       VARCHAR(50),
    ShipCountry    VARCHAR(50),
    PaymentMethod  VARCHAR(20) CHECK (PaymentMethod IN ('Cash','Card','Online','Wallet')),
    Discount       DECIMAL(5,2) DEFAULT 0
);

-- 10. OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID  INT PRIMARY KEY IDENTITY(1,1),
    OrderID        INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID      INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity       INT NOT NULL,
    UnitPrice      DECIMAL(10,2) NOT NULL,
    Discount       DECIMAL(5,2) DEFAULT 0
);

-- 11. Inventory
CREATE TABLE Inventory (
    InventoryID    INT PRIMARY KEY IDENTITY(1,1),
    ProductID      INT FOREIGN KEY REFERENCES Products(ProductID),
    StoreID        INT FOREIGN KEY REFERENCES Stores(StoreID),
    Quantity       INT DEFAULT 0,
    LastUpdated    DATETIME
);

-- 12. Returns
CREATE TABLE Returns (
    ReturnID       INT PRIMARY KEY IDENTITY(1,1),
    OrderDetailID  INT FOREIGN KEY REFERENCES OrderDetails(OrderDetailID),
    ReturnDate     DATE,
    Reason         VARCHAR(200),
    RefundAmount   DECIMAL(10,2),
    Status         VARCHAR(20) CHECK (Status IN ('Pending','Approved','Rejected','Refunded'))
);

-- 13. Reviews
CREATE TABLE Reviews (
    ReviewID       INT PRIMARY KEY IDENTITY(1,1),
    ProductID      INT FOREIGN KEY REFERENCES Products(ProductID),
    CustomerID     INT FOREIGN KEY REFERENCES Customers(CustomerID),
    Rating         INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText     VARCHAR(1000),
    ReviewDate     DATE
);

-- 14. Promotions
CREATE TABLE Promotions (
    PromotionID    INT PRIMARY KEY IDENTITY(1,1),
    PromoName      VARCHAR(100),
    DiscountPct    DECIMAL(5,2),
    StartDate      DATE,
    EndDate        DATE,
    MinOrderAmount DECIMAL(10,2)
);

-- 15. EmployeeShifts
CREATE TABLE EmployeeShifts (
    ShiftID        INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID     INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    ShiftDate      DATE,
    StartTime      TIME,
    EndTime        TIME,
    StoreID        INT FOREIGN KEY REFERENCES Stores(StoreID)
);

-- ============================================================
-- SECTION 3: SAMPLE DATA INSERTS (representative subset)
-- ============================================================

-- Regions
INSERT INTO Regions (RegionName, Country) VALUES
('North',   'USA'), ('South',  'USA'), ('East',   'USA'), ('West',   'USA'),
('Central', 'USA'), ('North',  'UK'),  ('South',  'UK'),  ('East',   'UK'),
('North',   'Canada'), ('West', 'Canada');

-- Departments
INSERT INTO Departments (DeptName, Budget) VALUES
('Sales',          500000), ('Marketing',    300000), ('IT',             400000),
('HR',             200000), ('Finance',       350000), ('Operations',     450000),
('Customer Service',180000),('Logistics',    250000), ('Management',     600000),
('Procurement',    220000);

-- Stores (10 stores)
INSERT INTO Stores (StoreName, RegionID, City, OpenDate, StoreType) VALUES
('Downtown Flagship', 1, 'New York',    '2010-03-15', 'Mall'),
('West Side Store',   4, 'Los Angeles', '2012-06-20', 'Street'),
('Chicago Central',   5, 'Chicago',     '2011-09-10', 'Mall'),
('Houston Hub',       2, 'Houston',     '2013-01-05', 'Warehouse'),
('Miami Beach',       2, 'Miami',       '2014-07-22', 'Street'),
('London West',       6, 'London',      '2015-02-14', 'Mall'),
('Manchester Store',  7, 'Manchester',  '2016-05-30', 'Street'),
('Toronto Mall',      9, 'Toronto',     '2013-11-18', 'Mall'),
('Online Store',      1, 'Virtual',     '2009-01-01', 'Online'),
('Seattle Hub',       4, 'Seattle',     '2017-08-12', 'Warehouse');

-- NOTE: Full 1000+ row data inserts for Customers, Employees, Products,
-- Orders, OrderDetails etc. would be generated via the scripts below.
-- Use the provided Python data-generation script to populate large datasets.

-- ============================================================
-- SECTION 4: USEFUL VIEWS FOR PRACTICE
-- ============================================================

-- View: Full Order Summary
CREATE VIEW vw_OrderSummary AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.Status,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.CustomerTier,
    s.StoreName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount/100)) AS OrderTotal,
    COUNT(od.OrderDetailID) AS TotalItems
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Stores s ON o.StoreID = s.StoreID
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate, o.Status,
         c.FirstName, c.LastName, c.CustomerTier,
         s.StoreName, e.FirstName, e.LastName;

-- View: Product Performance
CREATE VIEW vw_ProductPerformance AS
SELECT
    p.ProductID, p.ProductName,
    cat.CategoryName,
    sup.SupplierName,
    SUM(od.Quantity) AS TotalUnitsSold,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
    SUM(od.Quantity * (od.UnitPrice - p.CostPrice)) AS TotalProfit,
    AVG(CAST(r.Rating AS FLOAT)) AS AvgRating
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
LEFT JOIN Categories cat ON p.CategoryID = cat.CategoryID
LEFT JOIN Suppliers sup ON p.SupplierID = sup.SupplierID
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName, cat.CategoryName, sup.SupplierName;

-- ============================================================
-- END OF SCHEMA SCRIPT
-- ============================================================
