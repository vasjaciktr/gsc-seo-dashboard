CREATE OR REPLACE TABLE `example-483110.gsc_analytics.keyword_page_pairs` AS
SELECT
  query,
  page,
  SUM(clicks) AS clicks,
  SUM(impressions) AS impressions,
  SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
  SAFE_DIVIDE(SUM(position * impressions), SUM(impressions)) AS avg_position
FROM `planeks-483110.gsc_analytics.gsc_raw_daily`
GROUP BY query, page
