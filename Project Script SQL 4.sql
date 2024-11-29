---total sales for each customer segment and orders
SELECT 
    C.[Customer_Segment], 
	sum(
    oi.[Total]) As Total_Sales
FROM 
   [dbo].[Customers] C
JOIN 
    [dbo].[Orders] O ON C.Customer_Id = O.Customer_Id  
JOIN 
    [dbo].[Order_Items] OI ON O.Order_Id = OI.Order_Id  
JOIN 
    [dbo].[Products] P ON OI.Product_Id = P.Product_Id  
GROUP BY 
    C.Customer_Segment  
ORDER BY 
    Total_Sales DESC;