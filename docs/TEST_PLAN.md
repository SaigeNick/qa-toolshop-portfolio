# Test Plan - Toolshop (Practice Software Testing)

## 1. Overview

Toolshop is a demo online shop for tools (version 5.0, as of 2026-10-18).
As of 2026-10-18 the catalog has 50 products in 3 main categories, prices range from 3.55 to 178.20.
The goal of this plan is to check the main user flows of a customer: find a product, add it to the cart, log in and place an order.

## 2. Scope

### In scope

| Area | What we check |
|---|---|
| Catalog | Product grid, pagination (9 products per page), product details page |
| Search | Search by product name, result count, "no results" message, reset |
| Filters | Categories (Hand Tools, Power Tools, Other + subcategories), brands, price range slider, eco-friendly filter |
| Sorting | Name A-Z / Z-A, price low-high / high-low |
| Cart | Add to cart, change quantity, remove product, line price, subtotal and total, cart counter in header |
| Auth | Login, login validation errors, registration form, forgot password, sign out |
| Checkout | 4 steps: Cart -> Sign in (or guest) -> Billing address -> Payment |
| Payment | Bank Transfer, Cash on Delivery, Credit Card, Buy Now Pay Later, Gift Card |
| API | Public REST API: products, search, brands, categories, login, carts |

### Out of scope

- Admin panel (products, orders, users management)
- Performance and load testing
- Security testing (only basic checks like error messages that leak data)
- Two-factor authentication (TOTP), chat widget, product comparison
- Translations (only English is tested)
- Mobile apps / native devices (only desktop browser + responsive check in DevTools)
- Direct database access (see section 4)

## 3. Test types

| Type | How | Status |
|---|---|---|
| Smoke | Short manual run of key flows before each test run (search, product page, login, add to cart) | Active |
| Functional | Checklist + detailed test cases for each area in scope | Active |
| Negative | Invalid login, empty required fields, invalid email format, quantity 0 | Active |
| Boundary values / equivalence partitioning | Price slider limits, quantity field, password length | Active |
| Exploratory | Free sessions on the buggy version to find defects | Active |
| API | Postman collection, status codes and response body checks | Planned |
| Database | SQL queries for data validation logic (see section 4) | Planned |
| Regression (automated) | Playwright smoke suite in CI | Planned |

## 4. Database checks - limitation

The project tests a public live demo, so there is no direct access to the database.
SQL queries (planned) are written against a reconstructed relational schema inferred from the public API JSON responses
(for example `GET /products` returns `category` and `brand` objects, so the schema has `products`, `categories` and `brands` tables linked by ids).
The goal is to demonstrate DB validation logic (what a QA would check and how), not to run the queries against the real database.

## 5. Environments

| Environment | URL | Use |
|---|---|---|
| Stable | https://practicesoftwaretesting.com | Test cases, automation |
| Buggy | https://with-bugs.practicesoftwaretesting.com | Exploratory testing, bug reports |
| API | https://api.practicesoftwaretesting.com | Postman, API tests |

Browsers: Chrome (latest) - main, Firefox (latest) - spot checks.
Screen sizes: 1920x1080 and 375x812 (mobile view in DevTools).

### Test data

Demo accounts provided by the site (shown on the login page):

| Role | Email | Password |
|---|---|---|
| Customer | customer@practicesoftwaretesting.com | welcome01 |
| Customer 2 | customer2@practicesoftwaretesting.com | welcome01 |

Search keywords: `pliers`, `hammer`, `saw`, a non-existing word (for "no results").

## 6. Entry criteria

- Environment is up and the home page loads with the product grid
- API returns 200 for `GET /products`
- Demo accounts can log in
- Test cases for the area are self-reviewed against requirements

## 7. Exit criteria

- All smoke tests passed
- At least 95% of planned test cases executed
- No open Critical / High bugs in checkout and login
- All found bugs are reported with steps, expected/actual result and evidence

## 8. Bug reporting

Each bug report contains: ID, title, environment, severity, priority, steps to reproduce, expected result, actual result, screenshot, notes from DevTools (Network / Console).

| Severity | Meaning |
|---|---|
| Critical | Main flow is blocked (cannot log in, cannot pay) |
| High | Main feature works wrong (wrong total, filter shows wrong products) |
| Medium | Feature works with a workaround |
| Low | UI / text issues |

| Priority | Meaning |
|---|---|
| P1 - High | Fix as soon as possible, blocks release |
| P2 - Medium | Fix in the current release if time allows |
| P3 - Low | Can wait for a later release |

## 9. Tools

| Tool | Purpose | Status |
|---|---|---|
| Chrome DevTools | Network requests, console errors, local storage | Active |
| Git / GitHub (Markdown) | Version control, test documentation | Active |
| Postman | Manual API testing, collection with basic tests | Planned |
| SQL | Data validation queries (reconstructed schema) | Planned |
| Playwright (JavaScript) | UI smoke automation | Planned |
| GitHub Actions | Run Playwright tests on every push | Planned |

## 10. Risks

### Product area risk matrix

| Risk | Area | Why |
|---|---|---|
| High | Checkout | Money flow, many steps and payment methods |
| High | Auth | Blocks checkout and account features |
| High | Cart calculation | Wrong totals or discounts mean wrong charges |
| Medium | Search and category filters | Customer cannot find products, but has a workaround (browse the catalog) |
| Low | Sorting, pagination, static pages | Inconvenient but does not block a purchase |

High risk areas are tested first and in the most detail.

### Project risks

- Demo site is public and shared, data (carts, accounts) can be changed by other users
- Site can be updated without notice, so locators and data may change
- The buggy version may have different bugs after updates
- No direct DB access, SQL checks are based on a reconstructed schema
