/* =========================================================================
   ROAST & ROWS — Analytics Queries
   Run against schema.sql + seed_data.sql (SQLite dialect).
   Each query is annotated with the technique it demonstrates.
   ========================================================================= */


-- -------------------------------------------------------------------------
-- 1. MULTI-TABLE JOIN + AGGREGATION
-- Revenue and order volume by store, most recent month first.
-- Demonstrates: INNER JOIN across 3 tables, GROUP BY, ROUND, strftime.
-- -------------------------------------------------------------------------
SELECT
    s.name                                   AS store,
    strftime('%Y-%m', o.order_ts)            AS month,
    COUNT(DISTINCT o.order_id)               AS orders,
    ROUND(SUM(oi.quantity * oi.unit_price),2) AS revenue
FROM orders o
JOIN stores s       ON s.store_id = o.store_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY s.name, month
ORDER BY month DESC, revenue DESC;


-- -------------------------------------------------------------------------
-- 2. TOP-SELLING MENU ITEMS
-- Demonstrates: JOIN, GROUP BY, computed margin column, ORDER BY + LIMIT.
-- -------------------------------------------------------------------------
SELECT
    m.name,
    m.category,
    SUM(oi.quantity)                                   AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)         AS revenue,
    ROUND(SUM(oi.quantity * (oi.unit_price - m.cost)), 2) AS gross_profit
FROM order_items oi
JOIN menu_items m ON m.item_id = oi.item_id
GROUP BY m.item_id
ORDER BY revenue DESC
LIMIT 10;


-- -------------------------------------------------------------------------
-- 3. CUSTOMER LIFETIME VALUE + RFM-STYLE SEGMENTATION
-- Demonstrates: CTE, correlated subquery in SELECT, CASE-based
-- segmentation, JULIANDAY date arithmetic.
-- -------------------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id)                        AS order_count,
        SUM(oi.quantity * oi.unit_price)                   AS lifetime_value,
        MAX(o.order_ts)                                    AS last_order_ts
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.name,
    co.order_count,
    ROUND(co.lifetime_value, 2)                        AS lifetime_value,
    ROUND(JULIANDAY('2025-08-20') - JULIANDAY(co.last_order_ts)) AS days_since_last_order,
    CASE
        WHEN co.order_count >= 15 AND
             JULIANDAY('2025-08-20') - JULIANDAY(co.last_order_ts) <= 30
            THEN 'VIP - Active'
        WHEN co.order_count >= 15
            THEN 'VIP - Lapsing'
        WHEN JULIANDAY('2025-08-20') - JULIANDAY(co.last_order_ts) > 90
            THEN 'At Risk'
        ELSE 'Regular'
    END                                                 AS segment
FROM customers c
JOIN customer_orders co ON co.customer_id = c.customer_id
ORDER BY lifetime_value DESC
LIMIT 15;


-- -------------------------------------------------------------------------
-- 4. MONTH-OVER-MONTH REVENUE GROWTH (WINDOW FUNCTION)
-- Demonstrates: LAG(), window function ORDER BY, percentage-change calc.
-- -------------------------------------------------------------------------
WITH monthly AS (
    SELECT
        strftime('%Y-%m', o.order_ts)              AS month,
        SUM(oi.quantity * oi.unit_price)            AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2)                                          AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY month), 2)                AS prev_month_revenue,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
          / LAG(revenue) OVER (ORDER BY month), 1)              AS pct_change
FROM monthly
ORDER BY month;


-- -------------------------------------------------------------------------
-- 5. EMPLOYEE PERFORMANCE RANKING WITHIN EACH STORE
-- Demonstrates: window function PARTITION BY, RANK(), multi-table JOIN.
-- -------------------------------------------------------------------------
SELECT
    s.name                                             AS store,
    e.name                                             AS employee,
    e.role,
    COUNT(DISTINCT o.order_id)                         AS orders_handled,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)         AS revenue_rung_up,
    RANK() OVER (
        PARTITION BY s.store_id
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    )                                                   AS rank_in_store
FROM employees e
JOIN stores s        ON s.store_id = e.store_id
JOIN orders o         ON o.employee_id = e.employee_id
JOIN order_items oi   ON oi.order_id = o.order_id
GROUP BY e.employee_id
ORDER BY store, rank_in_store;


-- -------------------------------------------------------------------------
-- 6. 7-DAY ROLLING AVERAGE OF DAILY REVENUE
-- Demonstrates: window frame (ROWS BETWEEN), smoothing a noisy time series.
-- -------------------------------------------------------------------------
WITH daily AS (
    SELECT
        DATE(o.order_ts)                            AS day,
        SUM(oi.quantity * oi.unit_price)            AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY day
)
SELECT
    day,
    ROUND(revenue, 2)                                        AS revenue,
    ROUND(AVG(revenue) OVER (
        ORDER BY day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2)                                                     AS rolling_7day_avg
FROM daily
ORDER BY day;


-- -------------------------------------------------------------------------
-- 7. MENU CATEGORY MIX BY ORDER CHANNEL
-- Demonstrates: JOIN + GROUP BY on two dimensions, share-of-total via
-- window function used as a denominator (no self-join needed).
-- -------------------------------------------------------------------------
SELECT
    o.channel,
    m.category,
    SUM(oi.quantity)                                          AS units_sold,
    ROUND(100.0 * SUM(oi.quantity) /
        SUM(SUM(oi.quantity)) OVER (PARTITION BY o.channel), 1) AS pct_of_channel
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN menu_items m   ON m.item_id = oi.item_id
GROUP BY o.channel, m.category
ORDER BY o.channel, pct_of_channel DESC;


-- -------------------------------------------------------------------------
-- 8. STORES WITH ABOVE-AVERAGE CUSTOMER RATINGS
-- Demonstrates: subquery in WHERE clause (scalar subquery), HAVING.
-- -------------------------------------------------------------------------
SELECT
    s.name,
    ROUND(AVG(r.rating), 2)   AS avg_rating,
    COUNT(*)                  AS review_count
FROM reviews r
JOIN stores s ON s.store_id = r.store_id
GROUP BY s.store_id
HAVING AVG(r.rating) > (SELECT AVG(rating) FROM reviews)
ORDER BY avg_rating DESC;


-- -------------------------------------------------------------------------
-- 9. CUSTOMERS WHO HAVE NEVER LEFT A REVIEW (ANTI-JOIN)
-- Demonstrates: LEFT JOIN ... WHERE IS NULL pattern, aggregation.
-- -------------------------------------------------------------------------
SELECT
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS orders_placed
FROM customers c
JOIN orders o        ON o.customer_id = c.customer_id
LEFT JOIN reviews r  ON r.customer_id = c.customer_id
WHERE r.review_id IS NULL
GROUP BY c.customer_id
HAVING orders_placed >= 10
ORDER BY orders_placed DESC;


-- -------------------------------------------------------------------------
-- 10. DAYPART DEMAND CURVE (WHEN DOES EACH STORE GET BUSY?)
-- Demonstrates: CASE-based bucketing used as a GROUP BY key.
-- -------------------------------------------------------------------------
SELECT
    CASE
        WHEN CAST(strftime('%H', order_ts) AS INTEGER) BETWEEN 7  AND 9  THEN '07:00-10:00 Morning Rush'
        WHEN CAST(strftime('%H', order_ts) AS INTEGER) BETWEEN 10 AND 11 THEN '10:00-12:00 Late Morning'
        WHEN CAST(strftime('%H', order_ts) AS INTEGER) BETWEEN 12 AND 13 THEN '12:00-14:00 Lunch'
        ELSE '14:00-18:00 Afternoon'
    END                             AS daypart,
    COUNT(*)                        AS orders,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 1) AS pct_of_all_orders
FROM orders
GROUP BY daypart
ORDER BY orders DESC;


-- -------------------------------------------------------------------------
-- 11. NEW VS. RETURNING CUSTOMER REVENUE PER MONTH
-- Demonstrates: correlated subquery to classify first purchase month,
-- CTE, conditional aggregation with CASE inside SUM.
-- -------------------------------------------------------------------------
WITH first_order AS (
    SELECT customer_id, MIN(strftime('%Y-%m', order_ts)) AS first_month
    FROM orders
    GROUP BY customer_id
),
order_rev AS (
    SELECT o.order_id, o.customer_id, strftime('%Y-%m', o.order_ts) AS month,
           SUM(oi.quantity * oi.unit_price) AS rev
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY o.order_id
)
SELECT
    orr.month,
    ROUND(SUM(CASE WHEN orr.month = fo.first_month THEN orr.rev ELSE 0 END), 2) AS new_customer_revenue,
    ROUND(SUM(CASE WHEN orr.month != fo.first_month THEN orr.rev ELSE 0 END), 2) AS returning_customer_revenue
FROM order_rev orr
JOIN first_order fo ON fo.customer_id = orr.customer_id
GROUP BY orr.month
ORDER BY orr.month;


-- -------------------------------------------------------------------------
-- 12. ITEM PAIRING — WHAT GETS ORDERED TOGETHER WITH A LATTE?
-- Demonstrates: self-join on order_items to find co-occurring items
-- within the same order (a lightweight market-basket query).
-- -------------------------------------------------------------------------
SELECT
    m2.name          AS paired_with,
    COUNT(*)         AS times_paired
FROM order_items oi1
JOIN order_items oi2 ON oi2.order_id = oi1.order_id AND oi2.item_id != oi1.item_id
JOIN menu_items m1   ON m1.item_id = oi1.item_id
JOIN menu_items m2   ON m2.item_id = oi2.item_id
WHERE m1.name = 'Latte'
GROUP BY m2.name
ORDER BY times_paired DESC
LIMIT 5;
