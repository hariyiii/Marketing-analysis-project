-- Quarterly increase in CVR 
CREATE VIEW QUARTERLY_CVR AS
With Quat AS (SELECT 
year (ws.created_at) AS `YEAR`,
quarter(ws.created_at) AS `QUARTER`,
COUNT(DISTINCT ws.website_session_id) AS total_sessions,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id)  , 4) AS CVR
FROM website_sessions ws
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id
group by  year (ws.created_at), quarter(ws.created_at)
ORDER BY  year (ws.created_at), quarter(ws.created_at))

Select *, LAG(CVR, 1, 0) OVER (ORDER BY `YEAR`, `QUARTER`) AS PREVIOUS_CVR , 
CVR - LAG(CVR, 1, 0) OVER (ORDER BY `YEAR`, `QUARTER`) AS CVR_DIFF, 
ROUND((CVR - LAG(CVR, 1, 0) OVER (ORDER BY `YEAR`, `QUARTER`)) /  NULLIF(LAG(CVR, 1, 0) OVER (ORDER BY `YEAR`, `QUARTER`), 0) * 100, 2) AS Quat_inc
FROM Quat 