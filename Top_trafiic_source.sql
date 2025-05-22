CREATE VIEW TOP_SOURCE AS
WITH ranks AS (
SELECT  
YEAR(created_at) as years, 
EXTRACT(MONTH FROM created_at) as month_no, 
MONTHNAME(created_at) AS month_name, 
utm_source, utm_campaign, http_referer,
COUNT(website_session_id) AS session_count 
FROM website_sessions ws 
GROUP BY years,month_no, month_name, utm_source, utm_campaign, http_referer
ORDER BY years, month_no , session_count DESC
),
RAN AS (SELECT years, month_no, month_name , utm_source, utm_campaign, http_referer, session_count,
RANK() OVER(PARTITION BY years,month_no ORDER BY session_count DESC) AS ranks
FROM ranks)
SELECT utm_source,utm_campaign, http_referer, COUNT(ranks) AS Bulk_of_utm_source
FROM RAN
WHERE ranks BETWEEN 1 AND 3
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY Bulk_of_utm_source DESC;