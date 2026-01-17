DROP TABLE IF EXISTS gold.fact_sale;
CREATE TABLE gold.fact_sale AS (

	SELECT o.order_id,
		   o.order_purchase_timestamp::DATE AS order_date,
		   o.customer_id,
		   oi.product_id,
		   oi.seller_id,
		   SUM(oi.price+coalesce(oi.freight_value,0)) AS item_revenue,
		   COUNT(DISTINCT oi.order_id) AS total_orders
	FROM silver.olist_silver_orders o
	JOIN silver.olist_silver_order_items oi
	ON o.order_id = oi.order_id
	GROUP BY o.order_id,
		   o.order_purchase_timestamp,
		   o.customer_id,
		   oi.product_id,
		   oi.seller_id
);

SELECT *
FROM gold.fact_sale
LIMIT 10


DROP TABLE IF EXISTS gold.fact_payment;
CREATE TABLE gold.fact_payment AS (

	SELECT c.customer_id,
		   p.payment_type,
		   SUM(COALESCE(p.payment_value,0)) AS total_payment,
		   ROUND(AVG(COALESCE(p.payment_installments,0)),2) AS avg_installment
	FROM silver.olist_silver_payments p
	JOIN silver.olist_silver_orders o
	ON o.order_id = p.order_id
	JOIN silver.olist_silver_customers c
	ON c.customer_id = o.customer_id
	GROUP BY c.customer_id,
		   p.payment_type
)

SELECT * 
FROM gold.fact_payment
limit 10


DROP TABLE IF EXISTS gold.dim_customers;
CREATE TABLE gold.dim_customers AS (

		SELECT c.customer_unique_id,
			   c.customer_city,
			   c.customer_state,
			   COUNT(oi.order_id) AS total_orders,
			   SUM(oi.price + COALESCE(oi.freight_value,0)) AS lifetime_value
		FROM silver.olist_silver_customers c
		JOIN silver.olist_silver_orders o
		ON o.customer_id = c.customer_id
		JOIN silver.olist_silver_order_items oi
		ON o.order_id= oi.order_id
		GROUP BY c.customer_unique_id,
			   c.customer_city,
			   c.customer_state
			   
)


SELECT *
FROM gold.dim_customers
LIMIT 10


DROP TABLE IF EXISTS gold.dim_products
CREATE TABLE gold.dim_products AS (

	SELECT p.product_id,
		   pe.product_category_english AS product_category,
		   ROUND(AVG(oi.price),2) AS avg_price,
		   SUM(oi.price + COALESCE(oi.freight_value , 0)) AS total_sales
    FROM silver.olist_silver_products p
	JOIN silver.olist_silver_product_english_name pe
	ON p.product_category_name = pe.product_category_name
	JOIN silver.olist_silver_order_items oi
	ON oi.product_id = p.product_id
	GROUP BY p.product_id,
		     pe.product_category_english
)


SELECT *
FROM gold.dim_products
LIMIT 10


DROP TABLE IF EXISTS gold.dim_sellers;
CREATE TABLE gold.dim_sellers AS (

	SELECT s.seller_id,
		   s.seller_city,
		   s.seller_state,
		   SUM(oi.price) AS total_revenue,
		   COUNT(DISTINCT oi.order_id) AS total_count
	FROM silver.olist_silver_sellers s
	JOIN silver.olist_silver_order_items oi
	ON oi.seller_id = s.seller_id
	GROUP BY s.seller_id,
		     s.seller_city,
			 s.seller_state
)


SELECT *
FROM gold.dim_sellers
LIMIT 10


DROP TABLE IF EXISTS gold.dim_time;
CREATE TABLE gold.dim_time AS
SELECT DISTINCT
    order_purchase_timestamp::date AS date,
    EXTRACT(DAY FROM order_purchase_timestamp) AS day,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(QUARTER FROM order_purchase_timestamp) AS quarter
FROM silver.olist_silver_orders;


SELECT *
FROM gold.dim_time
LIMIT 10;