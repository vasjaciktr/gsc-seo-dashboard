CREATE OR REPLACE TABLE `example-483110.gsc_analytics.page_momentum_summary` AS

WITH page_periods AS (
  SELECT
    page,
    CASE
      WHEN date >= DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY) THEN 'last_28_days'
      WHEN date >= DATE_SUB(CURRENT_DATE(), INTERVAL 56 DAY)
           AND date < DATE_SUB(CURRENT_DATE(), INTERVAL 28 DAY) THEN 'previous_28_days'
    END AS period,
    SUM(clicks) AS clicks,
    SUM(impressions) AS impressions,
    SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
    SAFE_DIVIDE(SUM(position * impressions), SUM(impressions)) AS avg_position
  FROM `planeks-483110.gsc_analytics.gsc_raw_daily`
  WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 56 DAY)
  GROUP BY page, period
),

pivoted AS (
  SELECT
    page,
    MAX(CASE WHEN period = 'last_28_days' THEN clicks END) AS clicks_last_28,
    MAX(CASE WHEN period = 'previous_28_days' THEN clicks END) AS clicks_prev_28,
    MAX(CASE WHEN period = 'last_28_days' THEN impressions END) AS impressions_last_28,
    MAX(CASE WHEN period = 'previous_28_days' THEN impressions END) AS impressions_prev_28,
    MAX(CASE WHEN period = 'last_28_days' THEN ctr END) AS ctr_last_28,
    MAX(CASE WHEN period = 'previous_28_days' THEN ctr END) AS ctr_prev_28,
    MAX(CASE WHEN period = 'last_28_days' THEN avg_position END) AS position_last_28,
    MAX(CASE WHEN period = 'previous_28_days' THEN avg_position END) AS position_prev_28
  FROM page_periods
  GROUP BY page
)

SELECT
  page,
  clicks_last_28,
  clicks_prev_28,
  clicks_last_28 - clicks_prev_28 AS clicks_change,
  impressions_last_28,
  impressions_prev_28,
  impressions_last_28 - impressions_prev_28 AS impressions_change,
  ctr_last_28,
  ctr_prev_28,
  position_last_28,
  position_prev_28,
  position_last_28 - position_prev_28 AS position_change
FROM pivoted
