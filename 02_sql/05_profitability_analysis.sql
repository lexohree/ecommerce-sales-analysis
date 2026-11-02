-- What are the overall revenue, profit, and profit margin?
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD';
    
-- How has profitability changed year over year?
SELECT
    YEAR(order_date) AS year,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY YEAR(order_date)
ORDER BY year;

-- How has profitability changed month over month?
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY year, month;

-- How do discounts affect profit margins?
SELECT
    CASE
        WHEN discount_amount = 0 THEN 'No Discount'
        WHEN discount_amount <= 50 THEN '$0.01 - $50'
        WHEN discount_amount <= 100 THEN '$50.01 - $100'
        WHEN discount_amount <= 200 THEN '$100.01 - $200'
        ELSE 'Over $200'
    END AS discount_range,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(SUM(discount_amount), 2) AS total_discounts,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY discount_range
ORDER BY MIN(discount_amount);

-- Which months have the highest and lowest profit margins?
WITH monthly_profitability AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        MONTHNAME(order_date) AS month_name,
        ROUND(SUM(net_sales), 2) AS total_revenue,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(
            SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
            2
        ) AS profit_margin_pct
    FROM ecommerce_sales_customer_analytics
    WHERE
        order_status = 'Completed'
        AND currency = 'USD'
    GROUP BY
        YEAR(order_date),
        MONTH(order_date),
        MONTHNAME(order_date)
),
ranked_months AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY profit_margin_pct DESC
        ) AS highest_rank,
        ROW_NUMBER() OVER (
            ORDER BY profit_margin_pct ASC
        ) AS lowest_rank
    FROM monthly_profitability
)
SELECT
    year,
    month_name,
    total_revenue,
    total_profit,
    profit_margin_pct,
    CASE
        WHEN highest_rank <= 5 THEN 'Top 5'
        WHEN lowest_rank <= 5 THEN 'Bottom 5'
    END AS profitability_group
FROM ranked_months
WHERE highest_rank <= 5
   OR lowest_rank <= 5
ORDER BY profit_margin_pct DESC;

-- How do discounts and profitability vary by month?
SELECT
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(discount_amount), 2) AS avg_discount_amount,
    ROUND(SUM(discount_amount), 2) AS total_discounts,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM ecommerce_sales_customer_analytics
WHERE
    order_status = 'Completed'
    AND currency = 'USD'
GROUP BY
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY month;