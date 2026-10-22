# QA Portfolio - Practice Software Testing (Toolshop)

Manual and automated testing of the demo e-commerce app **Toolshop** by Testsmith (v2.5, built 2026-10-11 as shown in the site footer, last verified on 2026-10-21).

| Environment | URL |
|---|---|
| Stable (main target) | https://practicesoftwaretesting.com |
| Buggy version (bug hunting) | https://with-bugs.practicesoftwaretesting.com |
| REST API | https://api.practicesoftwaretesting.com |

## What is inside

| Folder / file | Content | Status |
|---|---|---|
| `docs/TEST_PLAN.md` | Test strategy: scope, risks, environments, entry/exit criteria, tools | Done |
| `docs/CHECKLIST_AND_TESTCASES.md` | 25-item risk-based checklist with execution results + 5 detailed test cases (BVA, EP, state transition) | Active |
| `docs/BUG_REPORTS.md` | 4 bug reports: 2 from the stable site (found by the checklist), 2 from the buggy version (exploratory), with screenshots and DevTools notes, linked to Jira (KAN-4 to KAN-7) | Active (as of 2026-10-20) |
| `postman/` | Postman collection for the public API: 11 requests, positive and negative checks, variable chaining | Active (verified 2026-10-21) |
| `sql/` | Schema + seed built from API responses and 8 SQL validation queries | Active (verified 2026-10-21) |
| `tests/`, `pages/` | Playwright (JavaScript) smoke tests: 4 UI tests (catalog, search CHK-16, add to cart CHK-08, login error) + 1 `test.fixme` for known bug BUG-01, `LoginPage` and `ProductPage` page objects | In progress (CI planned for Day 7) |

## Test types

| Type | Status |
|---|---|
| Smoke, Functional, Negative | Active |
| Boundary values / equivalence partitioning | Active |
| Exploratory | Active (as of 2026-10-20) |
| API, Database (SQL) | Active (verified 2026-10-21) |
| Regression (Playwright in CI) | In progress (CI planned for Day 7) |

## Tools

| Tool | Status |
|---|---|
| Chrome DevTools (Network, Console, Application) | Active |
| Git / GitHub | Active |
| Postman | Active (verified 2026-10-21) |
| SQL / SQLite | Active (verified 2026-10-21) |
| Playwright (`@playwright/test`, JavaScript) | In progress |
| GitHub Actions | Planned (Day 7) |

## How to run the UI tests

Needs Node.js. From the repository root:

```
npm install
npx playwright install chromium
npm test
```

Expected result: 4 passed, 1 skipped. The skipped test is `test.fixme` for BUG-01 (cart limit of 99 can be bypassed). It fails with "Received: 198" while the bug exists, remove `.fixme` after the fix to use it as a regression check.

## Note about SQL

This is a public live demo without direct database access.
SQL queries are written against a reconstructed relational schema inferred from the public API JSON responses.
All queries in `sql/test_queries.sql` were executed against a local SQLite copy built from API responses (`sql/schema_and_seed.sql`, data from 2026-10-21) with zero errors.
Only `.sql` files are in the repo, the `.db` file is created locally when needed.
The real production database is not used.

## About

I focus on manual and API testing. Playwright is used to automate the core smoke scenarios (in progress).
The repository grows step by step, the plan is in `docs/TEST_PLAN.md`.
