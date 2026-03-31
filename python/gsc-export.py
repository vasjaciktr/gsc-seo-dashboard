import os
import pandas as pd
from datetime import datetime, timedelta
from google.oauth2 import service_account
from googleapiclient.discovery import build

SITE_URL = "sc-domain:example.com"
OUTPUT_FILE = "gsc_export.csv"

SCOPES = ['https://www.googleapis.com/auth/webmasters.readonly']
KEY_FILE = "example-483110-8763c737311b.json"

credentials = service_account.Credentials.from_service_account_file(
    KEY_FILE, scopes=SCOPES
)

service = build("searchconsole", "v1", credentials=credentials)

# determine start date
if os.path.exists(OUTPUT_FILE):
    existing = pd.read_csv(OUTPUT_FILE)
    last_date = existing["date"].max()
    start_date = datetime.strptime(last_date, "%Y-%m-%d") + timedelta(days=1)
else:
    start_date = datetime(2024, 1, 1)

end_date = datetime.today() - timedelta(days=2)

rows = []

current_date = start_date

while current_date <= end_date:

    start_row = 0

    while True:

        request = {
            "startDate": current_date.strftime("%Y-%m-%d"),
            "endDate": current_date.strftime("%Y-%m-%d"),
            "dimensions": ["date", "query", "page", "country", "device"],
            "rowLimit": 25000,
            "startRow": start_row
        }

        response = service.searchanalytics().query(
            siteUrl=SITE_URL,
            body=request
        ).execute()

        data = response.get("rows", [])

        if not data:
            break

        for row in data:
            rows.append({
                "date": row["keys"][0],
                "query": row["keys"][1],
                "page": row["keys"][2],
                "country": row["keys"][3],
                "device": row["keys"][4],
                "clicks": row["clicks"],
                "impressions": row["impressions"],
                "ctr": row["ctr"],
                "position": row["position"]
            })

        start_row += 25000

    current_date += timedelta(days=1)

new_data = pd.DataFrame(rows)

if os.path.exists(OUTPUT_FILE):
    new_data.to_csv(OUTPUT_FILE, mode="a", header=False, index=False)
else:
    new_data.to_csv(OUTPUT_FILE, index=False)

print("Update complete.")
