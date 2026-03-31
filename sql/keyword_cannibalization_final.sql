CREATE OR REPLACE TABLE `example-483110.gsc_analytics.keyword_cannibalization_final` AS

WITH base AS (
  SELECT
    query,
    page,
    clicks,
    impressions,
    avg_position
  FROM `planeks-483110.gsc_analytics.keyword_page_pairs`
),

ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY query
      ORDER BY avg_position ASC
    ) AS rank_pos,
    COUNT(*) OVER (PARTITION BY query) AS page_count,
    MAX(avg_position) OVER (PARTITION BY query) - MIN(avg_position) OVER (PARTITION BY query) AS position_gap
  FROM base
)

SELECT
  query,
  page,
  page_count,
  clicks,
  impressions,
  avg_position,
  CASE WHEN rank_pos = 1 THEN 'MAIN' ELSE 'SECONDARY' END AS page_role,
  CASE WHEN position_gap <= 5 THEN 'HIGH' ELSE 'MEDIUM' END AS severity
FROM ranked
WHERE page_count > 1
