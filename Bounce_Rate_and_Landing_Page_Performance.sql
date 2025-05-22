-- Bounce Rate & Landing Page Performance
CREATE VIEW BOUNCE_RATE AS
WITH PAGEVIEW_COUNT AS (
SELECT website_session_id,
COUNT(*) AS Total_views
FROM website_pageviews wp 
GROUP BY website_session_id),
LANDING_PAGEVIEW AS (SELECT
website_session_id,
pageview_url, 
ROW_NUMBER() OVER (PARTITION BY website_session_id ORDER BY created_at ASC) AS rn
FROM website_pageviews),
BOUNCE_ANALYSIS AS (
SELECT lp.pageview_url,
pc.Total_views
FROM LANDING_PAGEVIEW lp
LEFT JOIN PAGEVIEW_COUNT pc 
ON lp.website_session_id = pc.website_session_id 
WHERE rn = 1)
SELECT 
pageview_url,
  COUNT(*) AS Total_Sessions,
  SUM(CASE WHEN total_views = 1 THEN 1 ELSE 0 END) AS Bounces,
  1.0 * SUM(CASE WHEN total_views = 1 THEN 1 ELSE 0 END) / COUNT(*) AS Bounce_Rate
FROM BOUNCE_ANALYSIS
GROUP BY pageview_url
ORDER BY Bounce_Rate DESC
