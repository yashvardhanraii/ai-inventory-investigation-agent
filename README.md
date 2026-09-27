# AI Inventory Investigation Agent

An AI-assisted inventory investigation system that combines data engineering, business rules, analytics, and generative AI to investigate stock anomalies and support operational decision-making.

## Overview

Inventory discrepancies often require staff to manually check stock records, supplier activity, inventory movements, and operational KPIs before identifying a likely cause.

This project automates that investigation workflow by combining Python, Azure SQL, deterministic business rules, Azure AI Foundry, and Power BI.

## Architecture

![AI Inventory Investigation Agent Process Map](docs/process-map.svg)

[View full process map](docs/process-map.svg)

### Workflow

ERP Data  
→ Python ETL Pipeline  
→ Data Quality Validation  
→ Azure SQL Database  
→ KPI Calculations + Rule Engine  
→ Investigation Payload  
→ Azure AI Foundry  
→ Explanation + Recommendations  
→ Power BI Dashboard

## Data Pipeline

The Python ETL pipeline extracts CSV-based operational data and performs initial transformation and validation.

Current checks include:

- duplicate removal
- empty-row removal
- missing-value validation
- inventory-data validation
- supplier-data validation

Clean operational data is prepared for storage and analysis in Azure SQL.

## Azure SQL Data Model

The database contains tables covering:

- products and categories
- stores
- suppliers
- product-supplier relationships
- purchase orders
- goods receipts
- current inventory
- store-level reorder settings
- inventory movements

Inventory movements include events such as:

- purchases
- sales
- transfers
- waste
- theft
- adjustments

## KPI and Rule Layer

Deterministic calculations and business rules are used before the AI layer.

Example indicators include:

- stock below reorder point
- negative or abnormal inventory variance
- supplier delivery delays
- high sales activity with low stock
- waste or adjustment activity
- outstanding purchase orders

This keeps numerical calculations and known business logic outside the language model.

## Investigation Payload

Relevant KPI results and triggered rules are combined into a structured payload.

Example:

```json
{
  "sku": "SKU-1045",
  "store": "MEL01",
  "quantity_on_hand": 12,
  "reorder_point": 30,
  "recent_sales_units": 48,
  "open_po_quantity": 50,
  "supplier_delay_days": 7,
  "days_overdue": 3,
  "triggered_rules": [
    "BELOW_REORDER_POINT",
    "SUPPLIER_DELIVERY_OVERDUE"
  ]
}
