# GSC Organic Traffic Intelligence Dashboard

A portfolio SEO analytics project that transforms Google Search Console data into a BigQuery data model and a Looker Studio dashboard for analyzing organic growth opportunities, keyword cannibalization, and page momentum.

## Project Overview

This project was built to move beyond basic Google Search Console exports and create a reusable SEO analytics workflow.

The pipeline extracts raw Search Console data with Python, stores it in BigQuery, transforms it with SQL, and visualizes insights in Looker Studio.

The dashboard focuses on three practical SEO use cases:

- finding keyword and page opportunities with strong growth potential
- detecting keyword cannibalization across multiple URLs
- identifying pages gaining or losing organic visibility over time

## Tech Stack

- Python
- Google Search Console API
- Google BigQuery
- SQL
- Looker Studio

## Data Flow

Google Search Console API → Python export → BigQuery raw table → SQL transformation tables → Looker Studio dashboard

## Repository Structure

```text
python/
  gsc_export.py

sql/
  01_keyword_daily_metrics.sql
  02_page_daily_metrics.sql
  03_keyword_page_pairs.sql
  04_keyword_cannibalization_final.sql
  05_seo_opportunity_scores.sql
  06_page_momentum_summary.sql

images/
  opportunity-finder.png
  cannibalization-report.png
  page-momentum.png
