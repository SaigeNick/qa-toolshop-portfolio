# SQL Checks - Toolshop

The public demo does not expose its database, so the checks run on a local SQLite snapshot
built from real API responses (`https://api.practicesoftwaretesting.com`, 2026-10-21).

| File | Content |
|---|---|
| `schema_and_seed.sql` | `CREATE TABLE` for `brands`, `categories`, `products`, `cart_items` + `INSERT` with the API data (2 brands + 2 leftover test brands, 19 categories, 50 products, 3 cart rows) |
| `test_queries.sql` | 8 validation queries, each with its goal and the actual result in a comment |

## How to run

You need the `sqlite3` command line tool (https://www.sqlite.org/download.html, "sqlite-tools" package).
Run from the repository root:

```
sqlite3 toolshop.db < sql/schema_and_seed.sql
sqlite3 -header -column toolshop.db < sql/test_queries.sql
```

In Windows PowerShell `<` does not work, use `.read` instead:

```
sqlite3 toolshop.db ".read sql/schema_and_seed.sql"
sqlite3 -header -column toolshop.db ".read sql/test_queries.sql"
```

The seed script drops and recreates the tables, so it can be run again at any time.
`toolshop.db` is a local file only, do not commit it.

## Queries

| # | Check | SQL used | Result on 2026-10-21 |
|---|---|---|---|
| 1 | Products with price 10-15, cheapest first (TC-04) | `WHERE`, `BETWEEN`, `ORDER BY` | 13 rows, same total as the API price filter |
| 2 | Name search for "pliers" (CHK-16) | `LIKE` | 4 rows, same as UI and API search |
| 3 | Catalog with brand and category names, no broken references | `INNER JOIN` | 50 rows = 50 products |
| 4 | Brands and categories without products | `LEFT JOIN`, `GROUP BY`, `HAVING` | 2 leftover test brands + category Grinder |
| 5 | Product count and min/max/avg price per category (3+ products) | `GROUP BY`, `HAVING`, aggregates | 9 rows, Pliers = 5 (CHK-20) |
| 6 | Audit: cart lines above the 99 limit (BUG-01 / KAN-4) | `INNER JOIN`, calculation | 1 row: Claw Hammer x198 = 2273.04 |
| 7 | Products with zero or negative price | `WHERE` | 0 rows |
| 8 | Duplicate product names | `GROUP BY`, `HAVING` | 0 rows |

Verified on 2026-10-21 with sqlite3 3.54.1: both files run with zero errors.

## Limitation

This is a snapshot, not the real database. The demo data is reset from time to time,
so the ids in the seed will not match the live API later. The queries show what a QA would check
on a real test database: references between tables, orphan data, aggregates and business rules.
