-- What are total revenue, orders, and average order value?
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS avg_order_value
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD';

-- How have sales changed year over year?
SELECT
    YEAR(order_date) AS year,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY YEAR(order_date)
ORDER BY year;

-- How do sales change from month to month?
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY year, month;

-- Which months had the highest revenue?
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(net_sales), 2) AS revenue
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY revenue DESC
LIMIT 10;

-- How much revenue comes from each customer type?
SELECT
    customer_type,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY customer_type
ORDER BY revenue DESC;