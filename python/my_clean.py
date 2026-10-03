# %%
import pandas as pd
import numpy as np
import os

sales = pd.read_csv("data/raw/sales_raw.csv")


# %%
sales = sales.drop_duplicates()

# %%
sales["country"] = sales["country"].fillna("Unknown")

# %%
sales["platform"] = sales["platform"].str.strip()

# %%
sales['price_eur'] = sales['price_eur'].str.replace(',','.')
sales['price_eur'] = sales['price_eur'].astype(float)


sales['refunded'] = np.where(sales['refunded'] == 'yes', 'Y',
                    np.where(sales['refunded'] == 'no', 'N', sales['refunded']))


# %%
sales['net_revenue_eur'] = round(sales['price_eur'] * (1- sales['discount_pct']),2)
os.makedirs("data/clean", exist_ok=True)
sales.to_csv("data/clean/sales_clean.csv", index=False)
print(sales.shape)
