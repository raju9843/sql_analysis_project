🛒 E-Commerce Data Warehouse (Bronze–Silver–Gold)
📌 Project Overview

This project implements a production-style data warehouse using the Bronze–Silver–Gold architecture on an e-commerce dataset.
The goal is to transform raw operational data into business-ready, analytics-ready tables without embedding analytical logic or KPIs.

 Architecture
Data Source (CSV / Database)
        ↓
Bronze Layer  →  Raw, as-is ingestion
        ↓
Silver Layer  →  Cleaned, validated, standardized data
        ↓
Gold Layer    →  Curated, business-ready fact & dimension tables


Note:
The Gold layer contains analytics-ready data, not analyzed results.
All metrics and percentages are intentionally left to BI tools.

🥉 Bronze Layer (Raw Data)

Purpose: Preserve source data exactly as received.

Characteristics

No transformations

No filtering (except basic schema constraints)

One-to-one mapping with source files

Tables

olist_bronze_orders

olist_bronze_customers

olist_bronze_order_items

olist_bronze_products

olist_bronze_payments

olist_bronze_sellers

olist_bronze_geolocation

olist_bronze_order_review

olist_bronze_product_english_name

🥈 Silver Layer (Cleaned & Standardized)

Purpose: Prepare reliable, consistent data for modeling.

Key Actions

Null handling and validation

Data type standardization

Deduplication where required

Logical consistency checks (dates, values)

Outcome

Data is trustworthy

Still close to source

No aggregations or business metrics

🥇 Gold Layer (Business-Ready)

Purpose: Provide curated tables ready for BI tools and downstream analysis.

Design Principles

Clear grain (fact vs dimension)

Business-friendly column names

All relevant timestamps preserved

No KPIs or percentages calculated

Fact Tables

fact_sale

Order-item grain

Revenue facts

Includes all operational timestamps:

purchase

approved

carrier delivery

customer delivery

estimated delivery

shipping limit

Dimension Tables

dim_customers – customer attributes + lifetime value

dim_products – product & category attributes

dim_sellers – seller attributes

dim_time – calendar dimension (purchase date based)