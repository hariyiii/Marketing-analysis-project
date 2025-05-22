-- Quarterly session to order conversion rate, revenue per order, revenue per session
CREATE VIEW CVR_REVENUE_AND_REVENUE_PER_SESSION AS
SELECT 
CONCAT(YEAR(ws.created_at), '-Q', QUARTER(ws.created_at)) AS Quarters, 
COUNT(DISTINCT ws.website_session_id) AS Total_Sessions,
COUNT(DISTINCT order_id) AS Total_Orders,
SUM(o.price_usd) AS Total_Revenue, 
ROUND(COUNT(DISTINCT order_id) / COUNT(DISTINCT ws.website_session_id), 4) AS Conversion_Rate,
ROUND(SUM(o.price_usd) / NULLIF(COUNT(DISTINCT o.order_id), 0) ,2) AS Revenue_per_Order,
ROUND(SUM(o.price_usd) / NULLIF(COUNT(DISTINCT ws.website_session_id), 0) ,2) AS Revenue_per_Session
FROM website_sessions ws 
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id 
GROUP BY 1
ORDER BY 1