CREATE OR REPLACE TABLE `example-483110.gsc_analytics.seo_opportunity_scores` AS

WITH base AS (
  SELECT
    query,
    page,
    SUM(clicks) AS clicks,
    SUM(impressions) AS impressions,
    SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
    SAFE_DIVIDE(SUM(position * impressions), SUM(impressions)) AS avg_position
  FROM `planeks-483110.gsc_analytics.gsc_raw_daily`
  GROUP BY query, page
)

SELECT
  query,
  page,
  clicks,
  impressions,
  ctr,
  avg_position,
  impressions * (1 - ctr) / avg_position AS opportunity_score
FROM base
WHERE impressions > 50
  AND avg_position BETWEEN 4 AND 20
