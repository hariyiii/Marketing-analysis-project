-- Quarterly view of Orders by UTM source and campaign 
CREATE VIEW QUARTERLY_VIEW AS
SELECT 
Quarter(o.created_at) AS Quarters,
ws.utm_source,
ws.utm_campaign,
COUNT(DISTINCT o.order_id) AS Order_Count
FROM orders o 
LEFT JOIN website_sessions ws
ON o.website_session_id = ws.website_session_id
GROUP BY Quarters, ws.utm_source, ws.utm_campaign
ORDER BY Quarters, Order_Count DESC