-- Monthly session and order trends for top traffic source.
CREATE VIEW TOP_SOURCE_TREND AS
WITH RANK2 AS (SELECT  YEAR(ws.created_at) as years, 
EXTRACT(MONTH FROM ws.created_at) as month_no, 
MONTHNAME(ws.created_at) AS month_name, 
utm_source, utm_campaign, http_referer, device_type, COUNT(ws.website_session_id) AS session_count, COUNT(DISTINCT order_id) AS Orders_placed
FROM website_sessions ws 
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id 
GROUP BY years,month_no, month_name, utm_source, utm_campaign, http_referer, device_type
ORDER BY years,month_no),
RANK3 AS
(SELECT years, month_no, month_name , utm_source, utm_campaign, http_referer, device_type, Session_count, Orders_placed,
DENSE_RANK() OVER (PARTITION BY years,month_no ORDER BY Session_count DESC) AS ranks
FROM RANK2)
SELECT years, month_no, month_name, utm_source, utm_campaign, http_referer, device_type, Session_count, Orders_placed, ranks
FROM RANK3
where ranks = 1
GROUP BY years, month_no, month_name, utm_source, utm_campaign, http_referer, device_type, Session_count, Orders_placed
