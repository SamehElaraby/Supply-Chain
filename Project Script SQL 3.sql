-- Late Deliveries risk % per Shipping mode

SELECT 
    [Shipping_Mode],
    COUNT(CASE WHEN [Delivery_Status] = 'Late' THEN 1 END) AS Late_Deliveries,
    COUNT(*) AS Total_Deliveries,
    (COUNT(CASE WHEN [Delivery_Status] = 'Late' THEN 1 END) * 100.0 / COUNT(*)) AS Late_Delivery_Risk_Percentage
FROM 
    [dbo].[ShippingDetails]
group by [Shipping_Mode]
