-- ================================
-- BRONZE: ORDERS
-- ================================
DROP TABLE IF EXISTS olist_bronze_orders;

CREATE TABLE olist_bronze_orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    order_status TEXT NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP NOT NULL
);

-- ================================
-- BRONZE: CUSTOMERS
-- ================================
DROP TABLE IF EXISTS olist_bronze_customers;

CREATE TABLE olist_bronze_customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix INT NOT NULL,
    customer_city TEXT NOT NULL,
    customer_state TEXT NOT NULL
);

-- ================================
-- BRONZE: ORDER ITEMS
-- ================================
DROP TABLE IF EXISTS olist_bronze_order_items;

CREATE TABLE olist_bronze_order_items (
    order_id TEXT NOT NULL,
    order_item_id INT NOT NULL,
    product_id TEXT NOT NULL,
    seller_id TEXT NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC,
    freight_value NUMERIC,
    PRIMARY KEY (order_id, order_item_id)
);

-- ================================
-- BRONZE: PRODUCTS
-- ================================
DROP TABLE IF EXISTS olist_bronze_products;

CREATE TABLE olist_bronze_products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

-- ================================
-- BRONZE: PAYMENTS
-- ================================
DROP TABLE IF EXISTS olist_bronze_payments;

CREATE TABLE olist_bronze_payments (
    order_id TEXT NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type TEXT NOT NULL,
    payment_installments INT NOT NULL,
    payment_value NUMERIC NOT NULL,
    PRIMARY KEY (order_id, payment_sequential)
);

-- ================================
-- BRONZE: SELLERS
-- ================================
DROP TABLE IF EXISTS olist_bronze_sellers;

CREATE TABLE olist_bronze_sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix INT NOT NULL,
    seller_city TEXT NOT NULL,
    seller_state TEXT NOT NULL
);

DROP TABLE IF EXISTS olist_bronze_geolocation;
CREATE TABLE olist_bronze_geolocaton(
	geolocation_zip_code NUMERIC NOT NULL,
	geolocation_lat NUMERIC NOT NULL,
	geolocation_lng NUMERIC NOT NULL,
	geolocation_city VARCHAR(75)  NOT NULL,
	geolocation_state VARCHAR(10) NOT NULL
);

DROP TABLE IF EXISTS olist_bronze_product_english_name;
CREATE TABLE olist_bronze_product_english_name(
	product_category_name VARCHAR (100)NOT NULL,
	product_category_english VARCHAR(200)
)

DROP TABLE IF EXISTS olist_bronze_order_review;
CREATE TABLE olist_bronze_order_review(
	review_id TEXT,
	order_id TEXT,
	review_score NUMERIC,
	review_command_title TEXT,
	review_command_msg TEXT,
	review_creation_date TIMESTAMP,
	review_answer_date TIMESTAMP)