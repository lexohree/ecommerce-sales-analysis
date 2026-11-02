-- Total products by category
SELECT
    product_category,
    COUNT(*) AS total_products
FROM product_catalog
GROUP BY product_category
ORDER BY total_products DESC;

-- Total products by category and subcategory
SELECT
    product_category,
    product_subcategory,
    COUNT(*) AS total_products
FROM product_catalog
GROUP BY
    product_category,
    product_subcategory
ORDER BY
    product_category,
    total_products DESC;
    
-- Total products by brand
SELECT
    brand,
    COUNT(*) AS total_products
FROM product_catalog
GROUP BY brand
ORDER BY total_products DESC, brand;

-- Total units sold by product category (USD)
SELECT
    pc.product_category,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.product_category
ORDER BY
    total_units_sold DESC;

-- Total revenue by product category and currency
SELECT
    s.currency,
    pc.product_category,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE s.order_status = 'Completed'
GROUP BY
    s.currency,
    pc.product_category
ORDER BY
    s.currency,
    total_revenue DESC;

-- Top 10 products by revenue (USD)
SELECT
    pc.product_id,
    pc.product_name,
    pc.product_category,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.product_id,
    pc.product_name,
    pc.product_category
ORDER BY
    total_revenue DESC
LIMIT 10;

-- Top 10 products by units sold (USD)
SELECT
    pc.product_id,
    pc.product_name,
    pc.product_category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.product_id,
    pc.product_name,
    pc.product_category
ORDER BY
    units_sold DESC,
    total_revenue DESC
LIMIT 10;

-- Total profit by product category (USD)
SELECT
    pc.product_category,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.product_category
ORDER BY
    total_profit DESC;
    
-- Top 10 products by total profit (USD)
SELECT
    pc.product_id,
    pc.product_name,
    pc.product_category,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.product_id,
    pc.product_name,
    pc.product_category
ORDER BY
    total_profit DESC
LIMIT 10;

-- Top 10 brands by revenue and profit (USD)
SELECT
    pc.brand,
    COUNT(DISTINCT pc.product_id) AS products_sold,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.brand
ORDER BY
    total_revenue DESC
LIMIT 10;

-- Top 10 product subcategories by revenue (USD)
SELECT
    pc.product_category,
    pc.product_subcategory,
    COUNT(DISTINCT pc.product_id) AS products_sold,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.net_sales), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
JOIN ecommerce_sales_customer_analytics s
    ON oi.order_id = s.order_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
GROUP BY
    pc.product_category,
    pc.product_subcategory
ORDER BY
    total_revenue DESC
LIMIT 10;

-- Product ratings vs. sales performance (USD)
WITH product_performance AS (
    SELECT
        pc.product_id,
        pc.product_rating,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.net_sales) AS total_revenue
    FROM order_items oi
    JOIN product_catalog pc
        ON oi.product_id = pc.product_id
    JOIN ecommerce_sales_customer_analytics s
        ON oi.order_id = s.order_id
    WHERE
        s.order_status = 'Completed'
        AND s.currency = 'USD'
        AND pc.product_rating IS NOT NULL
    GROUP BY
        pc.product_id,
        pc.product_rating
)
SELECT
    product_rating,
    COUNT(*) AS products_sold,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_product
FROM product_performance
GROUP BY
    product_rating
ORDER BY
    product_rating DESC;
    
-- Correlation between product ratings and revenue (USD)
WITH product_performance AS (
    SELECT
        pc.product_id,
        pc.product_rating,
        SUM(oi.net_sales) AS total_revenue
    FROM order_items oi
    JOIN product_catalog pc
        ON oi.product_id = pc.product_id
    JOIN ecommerce_sales_customer_analytics s
        ON oi.order_id = s.order_id
    WHERE
        s.order_status = 'Completed'
        AND s.currency = 'USD'
        AND pc.product_rating IS NOT NULL
    GROUP BY
        pc.product_id,
        pc.product_rating
)
SELECT
    COUNT(*) AS total_products,
    ROUND(
        (
            AVG(product_rating * total_revenue)
            - AVG(product_rating) * AVG(total_revenue)
        ) /
        NULLIF(
            STDDEV_POP(product_rating) * STDDEV_POP(total_revenue),
            0
        ),
        4
    ) AS rating_revenue_correlation
FROM product_performance;