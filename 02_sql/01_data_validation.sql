-- How many records are in each dataset?
SELECT COUNT(*) AS total_orders
FROM ecommerce_sales_customer_analytics;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_products
FROM product_catalog;

-- What dates does the dataset cover?
SELECT 
	MIN(order_date) AS first_order , 
	MAX(order_date) AS latest_order
FROM ecommerce_sales_customer_analytics;

-- What are the different order statuses and how common are they?
SELECT
    order_status,
    COUNT(*) AS order_count
FROM ecommerce_sales_customer_analytics
GROUP BY order_status
ORDER BY order_count DESC;

-- Are there duplicate order IDs?
SELECT
    order_id,
    COUNT(*) AS record_count
FROM ecommerce_sales_customer_analytics
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- Are there duplicate product IDs?
SELECT
    product_id,
    COUNT(*) AS record_count
FROM product_catalog
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- Are there order items without a matching product? **COME BACK TO THIS**
SELECT COUNT(*) AS unmatched_products
FROM order_items AS o
LEFT JOIN product_catalog AS p
    ON o.product_id = p.product_id
WHERE p.product_id IS NULL;