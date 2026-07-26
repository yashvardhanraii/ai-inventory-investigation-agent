from pathlib import Path

import pandas as pd


raw_folder = Path(__file__).parent / "raw"
raw_folder.mkdir(exist_ok=True)


categories = pd.DataFrame([
    ["CAT001", "Beverages", "Grocery"],
    ["CAT002", "Dairy", "Fresh Food"],
    ["CAT003", "Bakery", "Fresh Food"],
    ["CAT004", "Snacks", "Grocery"],
    ["CAT005", "Household", "General Merchandise"],
], columns=[
    "CategoryCode",
    "CategoryName",
    "DepartmentName",
])


stores = pd.DataFrame([
    ["STR001", "Brisbane Central", "Brisbane", "QLD", "4000", "Metro"],
    ["STR002", "South Brisbane", "Brisbane", "QLD", "4101", "Metro"],
    ["STR003", "Sunshine Coast", "Palmview", "QLD", "4553", "Suburban"],
], columns=[
    "StoreCode",
    "StoreName",
    "City",
    "StateCode",
    "Postcode",
    "StoreType",
])


suppliers = pd.DataFrame([
    ["SUP001", "Fresh Foods Australia", "Mia Wilson",
     "mia@freshfoods.com.au", "07 3000 1001", 3, 250.00],

    ["SUP002", "National Grocery Supply", "Jack Brown",
     "jack@ngs.com.au", "07 3000 1002", 5, 500.00],

    ["SUP003", "Coastal Beverages", "Sophie Taylor",
     "sophie@coastalbeverages.com.au", "07 3000 1003", 4, 300.00],
], columns=[
    "SupplierCode",
    "SupplierName",
    "ContactName",
    "ContactEmail",
    "ContactPhone",
    "LeadTimeDays",
    "MinimumOrderValue",
])


products = pd.DataFrame([
    ["SKU001", "Full Cream Milk 2L", "Dairy", "Farm Fresh",
     "Each", 2.20, 3.80, 10],

    ["SKU002", "White Bread 700g", "Bakery", "Daily Bake",
     "Each", 1.80, 3.20, 5],

    ["SKU003", "Orange Juice 2L", "Beverages", "Coastal",
     "Each", 3.10, 5.50, 30],

    ["SKU004", "Sparkling Water 10 Pack", "Beverages", "Clear Springs",
     "Pack", 5.50, 9.00, 365],

    ["SKU005", "Potato Chips 175g", "Snacks", "Crunch Time",
     "Each", 1.70, 3.50, 180],

    ["SKU006", "Chocolate Bar 50g", "Snacks", "Cocoa House",
     "Each", 0.90, 2.00, 270],

    ["SKU007", "Paper Towels 4 Pack", "Household", "HomeCare",
     "Pack", 4.20, 7.50, None],

    ["SKU008", "Dishwashing Liquid 1L", "Household", "CleanHome",
     "Each", 2.80, 5.00, None],
], columns=[
    "SKU",
    "ProductName",
    "CategoryName",
    "BrandName",
    "UnitOfMeasure",
    "UnitCost",
    "RetailPrice",
    "ShelfLifeDays",
])


categories.to_csv(raw_folder / "product_categories.csv", index=False)
stores.to_csv(raw_folder / "stores.csv", index=False)
suppliers.to_csv(raw_folder / "suppliers.csv", index=False)
products.to_csv(raw_folder / "products.csv", index=False)

print("Sample source files created:")
for file in raw_folder.glob("*.csv"):
    print(f"- {file.name}")