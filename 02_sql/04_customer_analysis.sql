-- Completed USD orders per customer
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY customer_id
ORDER BY total_orders DESC, customer_id;

-- Top 10 customers by total revenue (USD)
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY
    customer_id
ORDER BY
    total_revenue DESC,
    customer_id
LIMIT 10;

-- Top 10 customers by average order value (USD)
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(
        SUM(net_sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY
    customer_id
ORDER BY
    average_order_value DESC,
    customer_id
LIMIT 10;

-- One-time vs. repeat customers (completed USD orders)
SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE WHEN total_orders = 1 THEN 1 ELSE 0 END
    ) AS one_time_customers,
    SUM(
        CASE WHEN total_orders > 1 THEN 1 ELSE 0 END
    ) AS repeat_customers,
    ROUND(
        SUM(
            CASE WHEN total_orders > 1 THEN 1 ELSE 0 END
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
) AS customer_orders;

-- Revenue from one-time vs. repeat customers (USD)
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(net_sales) AS total_revenue
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0 /
        NULLIF(
            (SELECT SUM(net_sales)
             FROM ecommerce_sales_customer_analytics
             WHERE
                 order_status = 'Completed'
                 AND currency = 'USD'),
            0
        ),
        2
    ) AS revenue_percentage
FROM customer_orders
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Average orders and revenue per customer type (USD)
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(net_sales) AS total_revenue
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM customer_orders
GROUP BY customer_type
ORDER BY avg_revenue_per_customer DESC;

-- New customers by month (first completed USD order)
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    YEAR(first_order_date) AS year,
    MONTH(first_order_date) AS month,
    MONTHNAME(first_order_date) AS month_name,
    COUNT(*) AS new_customers
FROM first_purchase
GROUP BY
    YEAR(first_order_date),
    MONTH(first_order_date),
    MONTHNAME(first_order_date)
ORDER BY
    year,
    month;
    
-- Returning customers by month (completed USD orders)
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    YEAR(s.order_date) AS year,
    MONTH(s.order_date) AS month,
    MONTHNAME(s.order_date) AS month_name,
    COUNT(DISTINCT s.customer_id) AS returning_customers
FROM ecommerce_sales_customer_analytics AS s
JOIN first_purchase AS fp
    ON s.customer_id = fp.customer_id
WHERE
    s.order_status = 'Completed'
    AND s.currency = 'USD'
    AND DATE_FORMAT(s.order_date, '%Y-%m')
        > DATE_FORMAT(fp.first_order_date, '%Y-%m')
GROUP BY
    YEAR(s.order_date),
    MONTH(s.order_date),
    MONTHNAME(s.order_date)
ORDER BY
    year,
    month;
    
-- Customer distribution by completed USD order count
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN '1 Order'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 Orders'
        WHEN total_orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        WHEN total_orders BETWEEN 6 AND 10 THEN '6-10 Orders'
        ELSE '11+ Orders'
    END AS order_frequency,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY
    CASE
        WHEN total_orders = 1 THEN '1 Order'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 Orders'
        WHEN total_orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        WHEN total_orders BETWEEN 6 AND 10 THEN '6-10 Orders'
        ELSE '11+ Orders'
    END
ORDER BY MIN(total_orders);

-- Average customer revenue by order frequency (USD)
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(net_sales) AS total_revenue
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN '1 Order'
        WHEN total_orders BETWEEN 2 AND 3 THEN '2-3 Orders'
        WHEN total_orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        WHEN total_orders BETWEEN 6 AND 10 THEN '6-10 Orders'
        ELSE '11+ Orders'
    END AS order_frequency,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_customer
FROM customer_orders
GROUP BY order_frequency
ORDER BY MIN(total_orders);

-- Customer distribution by revenue segment (USD)
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(net_sales) AS total_revenue
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_revenue < 1000 THEN 'Under $1,000'
        WHEN total_revenue < 5000 THEN '$1,000-$4,999'
        WHEN total_revenue < 10000 THEN '$5,000-$9,999'
        ELSE '$10,000+'
    END AS revenue_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_revenue
GROUP BY revenue_segment
ORDER BY MIN(total_revenue);