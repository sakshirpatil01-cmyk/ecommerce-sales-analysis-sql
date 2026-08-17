-- Explore the orders table to understand how orders are recorded
SELECT *
FROM ecom.orders
LIMIT 10;
-- Explore the customers table to understand who buys from the business
SELECT *
FROM ecom.customers
LIMIT 10;
-- Explore order-items to understand which products are included in each order
SELECT *
FROM ecom.order_items
LIMIT 10;
-- Explore products to understand what the business sells
SELECT *
FROM ecom.products
LIMIT 10;
-- Explore product variants to understand different versions of products
SELECT *
FROM ecom.product_variants
LIMIT 10;
-- Explore categories to understand how products are grouped
SELECT *
FROM ecom.categories
LIMIT 10;

-- Count the total number of customers
SELECT COUNT(*) AS customer_count
FROM ecom.customers;

-- Count the total number of orders
SELECT COUNT(*) AS order_count
FROM ecom.orders;

-- Find the earliest and latest order dates
SELECT
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date
FROM ecom.orders;

-- Check whether any orders reference a customer that does not exist
SELECT COUNT(*) AS orphan_orders
FROM ecom.orders o
LEFT JOIN ecom.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Calculate the average number of orders per customer
SELECT
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM ecom.customers) AS orders_per_customer
FROM ecom.orders;

-- Count the total number of products
SELECT COUNT(*) AS product_count
FROM ecom.products;

-- Count the total number of product categories
SELECT COUNT(*) AS category_count
FROM ecom.categories;

-- See how products are distributed across categories
SELECT
    c.category_name AS category,
    COUNT(p.product_id) AS product_count
FROM ecom.categories c
LEFT JOIN ecom.products p
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

-- Identify categories that currently have no products
SELECT
    c.category_id,
    c.category_name
FROM ecom.categories c
LEFT JOIN ecom.products p
    ON p.category_id = c.category_id
WHERE p.product_id IS NULL;

-- Check how many products have no category assigned
SELECT COUNT(*) AS uncategorized_products
FROM ecom.products
WHERE category_id IS NULL;

-- Count customers by the number of orders they placed
SELECT
    customer_id,
    COUNT(*) AS order_count
FROM ecom.orders
GROUP BY customer_id
ORDER BY order_count DESC;

-- Summarize customers by how many orders they placed
SELECT
    order_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM ecom.orders
    GROUP BY customer_id
) customer_orders
GROUP BY order_count
ORDER BY order_count;

-- Compare one-time buyers with repeat customers
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM ecom.orders
    GROUP BY customer_id
) customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-time customer'
        ELSE 'Repeat customer'
    END
ORDER BY customer_type;

-- Count customers who have never placed an order
SELECT COUNT(*) AS customers_with_no_orders
FROM ecom.customers c
LEFT JOIN ecom.orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;