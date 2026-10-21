-- SQL validation queries for the Toolshop catalog
-- Run against the local SQLite snapshot from sql/schema_and_seed.sql
-- (built from https://api.practicesoftwaretesting.com responses on 2026-10-21).
-- "Result" comments are the actual output of the run on 2026-10-21.


-- Query 1: products in the price range 10-15, cheapest first
-- Goal: cross-check the price filter (TC-04) with the data.
-- The API gives the same 13 products: GET /products?between=price,10,15&sort=price,asc -> total 13.
-- Result: 13 rows, from Measuring Tape 10.07 to Long Nose Pliers 14.24
-- (Measuring Tape 10.07, Thor Hammer 11.14, Claw Hammer 11.48, Pliers 12.01, ...)
SELECT name, price
FROM products
WHERE price BETWEEN 10 AND 15
ORDER BY price ASC;


-- Query 2: search by name
-- Goal: the same 4 products as the UI search for "pliers" (CHK-16) and GET /products/search?q=pliers.
-- Note: LIKE in SQLite is case-insensitive for ASCII, so "Pliers" is found too.
-- Result: 4 rows - Combination Pliers 14.15, Long Nose Pliers 14.24, Pliers 12.01, Slip Joint Pliers 9.17
SELECT name, price
FROM products
WHERE name LIKE '%pliers%'
ORDER BY name;


-- Query 3: readable catalog with brand and category names
-- Goal: check that every product points to an existing brand and category.
-- INNER JOIN drops a product if its brand_id or category_id has no match,
-- so the row count must be the same as SELECT COUNT(*) FROM products.
-- Result: 50 rows, same as products total (50), so no broken references.
-- First rows: Chisels Set | MightyCraft Hardware | Chisels | 12.96, Swiss Woodcarving Chisels | ForgeFlex Tools | Chisels | 22.96
SELECT p.name AS product, b.name AS brand, c.name AS category, p.price
FROM products p
INNER JOIN brands b ON b.id = p.brand_id
INNER JOIN categories c ON c.id = p.category_id
ORDER BY c.name, p.name;


-- Query 4: brands and categories without products
-- Goal: find orphan / test data. LEFT JOIN keeps the brand even if there is no product,
-- COUNT(p.id) is 0 then. Top level categories (Hand Tools, Power Tools, Other) are skipped
-- because products are linked to subcategories only.
-- Result: 3 rows
--   brand    | 3684441160626030editado | 0   <- leftover test brand from another API user
--   brand    | 3871202975439377editado | 0   <- leftover test brand from another API user
--   category | Grinder                 | 0   <- shown in the category filter but has no products
SELECT 'brand' AS type, b.name, COUNT(p.id) AS products
FROM brands b
LEFT JOIN products p ON p.brand_id = b.id
GROUP BY b.id, b.name
HAVING COUNT(p.id) = 0
UNION ALL
SELECT 'category', c.name, COUNT(p.id)
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
WHERE c.parent_id IS NOT NULL
GROUP BY c.id, c.name
HAVING COUNT(p.id) = 0;


-- Query 5: products and price stats per category
-- Goal: compare product counts with the category filter in the UI (e.g. Pliers = 5, CHK-20)
-- and spot strange prices (0 or negative). HAVING keeps only categories with 3+ products.
-- Result: 9 rows
--   Hammer 7 | 11.14 | 20.14 | 15.02
--   Fasteners 6 | 3.55 | 7.99 | 5.32
--   Safety Gear 6 | 18.58 | 41.29 | 29.94
--   Pliers 5 | 9.17 | 48.41 | 19.6
--   Drill 4 | 46.5 | 125.23 | 89.38
--   Measures 4 | 7.23 | 15.75 | 11.49
--   Chisels 3 | 12.96 | 45.23 | 27.05
--   Sander 3 | 58.48 | 100.79 | 77.62
--   Wrench 3 | 14.14 | 38.51 | 24.33
SELECT c.name AS category,
       COUNT(p.id) AS products,
       MIN(p.price) AS min_price,
       MAX(p.price) AS max_price,
       ROUND(AVG(p.price), 2) AS avg_price
FROM categories c
INNER JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(p.id) >= 3
ORDER BY products DESC, c.name;


-- Query 6: cart lines above the 99 limit (BUG-01)
-- Goal: the business rule is max 99 per product, so this query should return 0 rows.
-- Line total = quantity * price, the same as the cart page shows.
-- Result: 1 row - Claw Hammer | 198 | 11.48 | 2273.04
-- Same amount as in BUG-01 ($2,273.04), so the bug is confirmed in the data too.
-- The second cart (TC-05 data: Pliers x2 + Claw Hammer x1 = 35.50) is not returned, as expected.
SELECT ci.cart_id, p.name, ci.quantity, p.price,
       ROUND(ci.quantity * p.price, 2) AS line_total
FROM cart_items ci
INNER JOIN products p ON p.id = ci.product_id
WHERE ci.quantity > 99;
