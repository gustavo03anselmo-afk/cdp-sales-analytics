-- =====================================================================
-- 03_analysis.sql | Business questions answered with SQL
-- Database: cdp_basic | Tables: sales_clean, targets
-- =====================================================================

-- 1. Revenue and orders by year
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(*) AS orders,
    SUM(net_revenue_eur) AS net_revenue
FROM sales_clean
GROUP BY year
ORDER BY year;

-- 2. Revenue by game
SELECT
    game,
    COUNT(*) AS orders,
    SUM(net_revenue_eur) AS net_revenue
FROM sales_clean
GROUP BY game
ORDER BY net_revenue DESC;

-- 3. Revenue by platform in 2025
SELECT
    platform,
    COUNT(*) AS orders,
    SUM(net_revenue_eur) AS net_revenue
FROM sales_clean
WHERE EXTRACT(YEAR FROM order_date) = 2025
GROUP BY platform
ORDER BY net_revenue DESC;

-- 4. Top 5 countries by revenue
SELECT
    country,
    COUNT(*) AS orders,
    SUM(net_revenue_eur) AS net_revenue
FROM sales_clean
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY net_revenue DESC
LIMIT 5;

-- 5. Refund rate by country (highest first)
SELECT
    country,
    COUNT(*) AS orders,
    SUM(CASE WHEN refunded = 'Y' THEN 1 ELSE 0 END) AS refunds,
    ROUND(100.0 * SUM(CASE WHEN refunded = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 2) AS refund_rate_pct
FROM sales_clean
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY refund_rate_pct DESC;

-- 6. Markets with more than 1,000 orders
SELECT
    country,
    region,
    COUNT(*) AS orders,
    ROUND(AVG(net_revenue_eur), 2) AS avg_order_value
FROM sales_clean
WHERE country <> 'Unknown'
GROUP BY country, region
HAVING COUNT(*) > 1000
ORDER BY orders DESC;

-- 7. Monthly revenue vs target (JOIN with the targets table)
SELECT
    t.month,
    t.target_eur,
    SUM(s.net_revenue_eur) AS net_revenue,
    SUM(s.net_revenue_eur) - t.target_eur AS variance_eur,
    ROUND(100.0 * SUM(s.net_revenue_eur) / t.target_eur, 1) AS achievement_pct
FROM targets AS t
JOIN sales_clean AS s
    ON CAST(DATE_TRUNC('month', s.order_date) AS DATE) = t.month
GROUP BY t.month, t.target_eur
ORDER BY t.month;

-- 8. Full price vs discounted orders
SELECT
    CASE WHEN discount_pct = 0 THEN 'Full price' ELSE 'Discounted' END AS price_type,
    COUNT(*) AS orders,
    SUM(net_revenue_eur) AS net_revenue,
    ROUND(AVG(net_revenue_eur), 2) AS avg_order_value
FROM sales_clean
GROUP BY price_type
ORDER BY net_revenue DESC;
