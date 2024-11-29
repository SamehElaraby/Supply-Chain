CREATE VIEW Customer_Sales AS
SELECT 
    c.Customer_Id AS Customer_ID,
    CONCAT(c.Customer_Fname, ' ', c.Customer_Lname) AS Customer_Name,
	c.Customer_Segment,
    o.Order_Id AS Order_ID,
    o.order_date_DateOrders AS Order_Date_and_Time ,
    o.Delivery_Status,
	o.Order_Status,
	o.Order_City,
	o.Order_Country,
	o.Type,
	o.Market,
	o.Order_Region,
    s.Shipping_Mode,
    s.shipping_date AS Shipping_Date,
    s.Days_For_Shipment_Scheduled,
    s.Days_for_shipping_real,
	s.Latitude,
	s.Longitude,
    oi.Product_Id AS Product_ID,
	oi.Order_Item_Id AS Order_Item_ID,
	oi.Order_Item_Discount_Rate AS Discount_Ratio,
	oi.Order_Item_Discount AS Discount_Value,
	oi.Order_Item_Product_Price AS Product_Price,
	oi.Order_Item_Profit_Ratio AS Profit_Ratio,
	oi.Order_Profit_Per_Order AS Profit_Per_Item,
    oi.Order_Item_Quantity AS Quantity,
    oi.Order_Item_Total AS Total_With_Discount,
    oi.Sales AS Sales_Without_Discount

FROM Customer c
JOIN Orders o ON c.Customer_Id = o.Order_Customer_Id
JOIN Shipping s ON o.Order_Id = s.Order_Id
JOIN [dbo].[Order_Items]oi ON o.Order_Id = oi.Order_Id;



CREATE VIEW InventoryProductDetails AS
SELECT 
    p.Product_Id AS Product_ID,
    p.Product_Name,
    p.Category_Name,
	p.Product_Category_Id AS Category_ID,
    p.Department_Name,
	p.Class,
	i.order_now AS Order_Now,
	i.Current_Stock,
    i.Reorder_Point,
    i.Safety_Stock,
    i.Avg_Lead_Time,
	i.avg_order_qty,
    i.Max_Lead_Time,
	i.max_order_qty,
	i.mod
FROM Products p
JOIN Inventory_Stock_Data i ON p.Product_Id = i.Product_Id;