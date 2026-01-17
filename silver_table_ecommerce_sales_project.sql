===================================
INSERT DATA INTO CUSTOMERS TABLE
===================================

INSERT INTO silver.olist_silver_customers
SELECT customer_id,
	   customer_unique_id,
	   customer_zip_code_prefix,
	   customer_city,
	   customer_state
FROM bronze.olist_bronze_customers
WHERE customer_id IS NOT NULL AND
	  customer_unique_id IS NOT NULL;

=============================================
INSERT DATA INTO ORDERS TABLE
=============================================


INSERT INTO silver.olist_silver_orders
SELECT order_id,
       customer_id,
       order_status,
       order_purchase_timestamp,
       order_approved_at,
       order_delivered_carrier_date,
       order_delivered_customer_date,
       order_estimated_delivery_date
FROM bronze.olist_bronze_orders
WHERE order_id IS NOT NULL
  AND order_purchase_timestamp <= order_approved_at
  AND order_approved_at <= order_delivered_carrier_date
  AND order_delivered_carrier_date <= order_delivered_customer_date
  AND order_delivered_customer_date <= order_estimated_delivery_date
  AND order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


===================================
INSERT DATA INTO  TABLE PAYMENTS
===================================
truncate table silver.olist_silver_products;
INSERT INTO silver.olist_silver_payments
SELECT
    order_id,
    payment_sequential,
    payment_type,
    CASE 
        WHEN payment_installments < 1 THEN 1
        ELSE CEIL(payment_installments)
    END AS payment_installments,
    payment_value
FROM bronze.olist_bronze_payments
WHERE order_id IS NOT NULL
  AND payment_value > 0
  AND payment_sequential >= 1
  AND payment_type IS NOT NULL;


===================================
INSERT DATA INTO TABLE GEOLOCATION
===================================
INSERT INTO silver.olist_silver_geolocation
SELECT geolocation_zip_code,
	   geolocation_lat,
	   geolocation_lng,
	   geolocation_city,
	   geolocation_state
FROM bronze.olist_bronze_geolocation
WHERE geolocation_zip_code IS NOT NULL
	  AND geolocation_lat IS NOT NULL
	  AND geolocation_lng IS NOT NULL
	  AND geolocation_city IS NOT NULL
	 AND geolocation_state IS NOT NULL



===================================
INSERT DATA INTO TABLE ORDER_ITEMS
===================================

INSERT INTO silver.olist_silver_order_items
SELECT boi.order_id,
	   order_item_id,
	   boi.product_id,
	   seller_id,
	   shipping_limit_date,
	   price,
	   freight_value
FROM bronze.olist_bronze_order_items boi
JOIN bronze.olist_bronze_orders obo
  ON boi.order_id = obo.order_id
WHERE boi.shipping_limit_date IS NOT NULL
  AND boi.shipping_limit_date > obo.order_purchase_timestamp
  AND boi.order_id IS NOT NULL
  AND order_item_id IS NOT NULL
  AND boi.product_id IS NOT NULL
  AND seller_id IS NOT NULL
  AND price IS NOT NULL
  AND freight_value>0;




===================================
INSERT DATA INTO TABLE PRODUCTS
===================================

INSERT INTO silver.olist_silver_products

SELECT  product_id,
		product_category_name ,
		product_name_length ,
		product_description_length,
		product_photos_qty,
		product_weight_g ,
		product_length_cm,
		product_height_cm,
		product_width_cm
FROM bronze.olist_bronze_products
where product_id is not null---no
    AND product_category_name is not null
    AND(product_photos_qty is null or product_photos_qty >0)
    AND (product_weight_g is null or product_weight_g>0)  ---yes(4)
	AND (product_length_cm is null or product_length_cm >0)---no
	AND (product_height_cm is null or product_height_cm >0)---no
	AND (product_width_cm is null or product_width_cm >0); ---no




===================================
INSERT DATA INTO TABLE SELLERS
===================================

INSERT INTO silver.olist_silver_sellers
SELECT seller_id,
	   seller_zip_code_prefix,
	   seller_city ,
	   seller_state
FROM bronze.olist_bronzE_SELLERS
WHERE seller_id is NOT null	
	  AND seller_zip_code_prefix is NOT null
      AND seller_city is NOT null
      AND seller_state is NOT null;



===================================
INSERT DATA INTO TABLE ORDER_REVIEW
===================================

INSERT INTO silver.olist_silver_order_review
SELECT review_id,
		order_id,
		review_score ,
		review_command_title,
		review_command_msg,
			review_creation_date,
		review_answer_date 
FROM bronze.olist_bronze_order_review
WHERE review_id IS NOT NULL
	 AND order_id IS NOT NULL
	 AND review_score between 1 and 5
	 AND review_answer_date >= review_creation_date


===================================
INSERT DATA INTO TABLE PRODUCT_NAME_ENGLISH
===================================

INSERT INTO silver.olist_silver_product_english_name
SELECT product_category_name,
	   product_category_english
FROM bronze.olist_bronze_product_english_name
WHERE product_category_name IS NOT NULL
	   AND product_category_english IS NOT NULL

select count(*)
from bronze.olist_bronze_ORDER_REVIEW
WHERE review_id is null;

