Use [Supply_Chain];

--Creating the customers Table

CREATE TABLE Customers (
    Customer_Id INT PRIMARY KEY,
    Customer_Fname NVARCHAR(50),
    Customer_Lname NVARCHAR(50),
    Customer_Segment NVARCHAR(50),
    Customer_City NVARCHAR(50),
    Customer_State NVARCHAR(50),
    Customer_Country NVARCHAR(50),
    Customer_Zipcode INT,
    Customer_Street NVARCHAR(50)
);

Alter Table Customers Add Sales_per_customer Float;

--Creating the Products Table

CREATE TABLE Products (
    Product_Id INT PRIMARY KEY,
    Product_Name NVARCHAR(50),
    Product_Price float,
	Sales Float,
    Product_Category_Id INT,
	Department_Id INT,
	Department_Name NVARCHAR(50),
	Category_Name NVARCHAR(50),
	Class NVARCHAR(50)
);


--Creating the Order_Items Table

CREATE TABLE Order_Items (
    Order_ItemId INT PRIMARY KEY,
    Order_Id INT,
    Product_Id INT,
    Quantity INT,
    Item_Price Float,
    Discount Float,
    Discount_Rate Float,
    Total AS (Quantity * Item_Price - Discount) PERSISTED,
    ProfitRatio Float,
    FOREIGN KEY (Product_Id) REFERENCES Products(Product_Id)
);

--Creating the Orders Table

CREATE TABLE Orders (
    Order_Id INT PRIMARY KEY,
    Order_Date DATETIME,
    Order_Status NVARCHAR(50),
    Delivery_Status NVARCHAR(50),
    Customer_Id INT,
    Order_City NVARCHAR(50),
    Order_State NVARCHAR(50),
    Order_Country NVARCHAR(50),
    Order_Region NVARCHAR(50),
	Market NVARCHAR(50),
	Total_Order_Value Float,
    FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id)
);

ALTER TABLE Orders
ADD CONSTRAINT FK_Order_Items_Orders
FOREIGN KEY (Order_Id) REFERENCES Orders(Order_Id);


--Creating the Shipping Details Table

CREATE TABLE ShippingDetails (
    Shipping_Id INT PRIMARY KEY,
    Order_Id INT,
    Shipping_Date DATETIME2(7),
    Shipping_Mode NVARCHAR(50),
    Days_For_Shipment_Scheduled INT,
    Days_For_Shipping_Real INT,
	Latitude Float,
	Longitude Float,
    FOREIGN KEY (Order_Id) REFERENCES Orders(Order_Id)
);



--To only transfer one record for each Customer_Id to Customers Table

WITH UniqueCustomers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[Sales_Shipment_Data]
)
INSERT INTO [dbo].[Customers] (Customer_Id, Customer_Fname,Customer_Lname,Customer_Segment,Customer_City,Customer_State,Customer_Country,Customer_Zipcode,Customer_Street,Sales_per_customer)
SELECT Customer_Id, Customer_Fname,Customer_Lname,Customer_Segment,Customer_City,Customer_State,Customer_Country,Customer_Zipcode,Customer_Street, Sales_per_customer, Sales_per_customer
FROM UniqueCustomers
WHERE rn = 1;





--Inserting Orders table data from original table

WITH UniqueOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Order_Id ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[Sales_Shipment_Data]
)
INSERT INTO [dbo].[Orders] (Order_Id,Order_Date ,Order_Status, Delivery_Status, Customer_Id, Order_City,Order_State,Order_Country,Order_Region, Market)
SELECT Order_Id, [order_date_DateOrders] ,Order_Status, Delivery_Status, Customer_Id, Order_City,Order_State,Order_Country,Order_Region, Market
FROM UniqueOrders
WHERE rn = 1;



--Inserting Order_Items table data from original table

WITH UniqueOrder_Items AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Order_Item_Id ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[Sales_Shipment_Data]
)
INSERT INTO [dbo].[Order_Items](Order_ItemId,Order_Id, Product_Id,Quantity, Item_Price, Discount, Discount_Rate,ProfitRatio)
SELECT Order_Item_Id,Order_Id,Order_Item_Cardprod_Id ,Order_Item_Quantity, Order_Item_Product_Price, Order_Item_Discount, Order_Item_Discount_Rate,Order_Item_Profit_Ratio
FROM UniqueOrder_Items
WHERE rn = 1;




--Inserting Products table data from original table

WITH UniqueProducts AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Product_Id ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[Sales_Shipment_Data]
)
INSERT INTO [dbo].[Products](Product_Id,Product_Name, Product_Price,Sales, Product_Category_Id, Department_Id, Department_Name,Category_Name, Class)
SELECT Product_Id,Product_Name, Product_Price,Sales, Product_Category_Id, Department_Id, Department_Name,Category_Name, Class
FROM UniqueProducts
WHERE rn = 1;



--Inserting ShippingDetails table data from original table
WITH UniqueShippingDetails AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Order_Id ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[Sales_Shipment_Data]
)
INSERT INTO [dbo].[ShippingDetails](Order_Id, Shipping_Date,Shipping_Mode, Days_For_Shipment_Scheduled, Days_For_Shipping_Real, Latitude,Longitude)
SELECT Order_Id,shipping_date_DateOrders ,Shipping_Mode, Days_For_Shipment_Scheduled, Days_For_Shipping_Real, Latitude,Longitude
FROM UniqueShippingDetails
WHERE rn = 1;


Alter Table Orders
Drop Column Total_Order_Value;

ALTER TABLE [dbo].[Inventory_Stock_Data]
ADD CONSTRAINT FK_Inventory_Stock_Data_Products
FOREIGN KEY (Product_Id) REFERENCES Products(Product_Id);


