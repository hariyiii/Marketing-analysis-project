-- Quarterly session-to-order conversion rate by UTM source and campaign
CREATE VIEW CVR_BY_SOURCE_AND_CAMPAIGN AS
SELECT Quarter(ws.created_at) AS Quarters,
ws.utm_source,
ws.utm_campaign,
COUNT(DISTINCT ws.website_session_id) AS Session_Count,
COUNT(DISTINCT o.order_id) AS Order_Count,
ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id), 4) AS Conversion_Rate
FROM website_sessions ws 
LEFT JOIN orders o
ON ws.website_session_id = o.order_id
GROUP BY Quarters, ws.utm_source, ws.utm_campaign
ORDER BY Quarters, Conversion_Rate DESC