-- Session to order conversion rate by month,
CREATE VIEW MONTHLY_CVR AS
SELECT 
year(ws.created_at),
month(ws.created_at),
monthname(ws.created_at),
COUNT(DISTINCT ws.website_session_id) AS total_sessions,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) * 100, 2) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id
GROUP BY year(ws.created_at), month(ws.created_at),  monthname(ws.created_at)
ORDER BY year(ws.created_at), month(ws.created_at);

