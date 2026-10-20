# QA Portfolio - Practice Software Testing (Toolshop)

Manual and automated testing of the demo e-commerce app **Toolshop** by Testsmith (v2.5, built 2026-10-11 as shown in the site footer, last verified on 2026-10-20).

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
| `docs/BUG_REPORTS.md` | 4 bug reports: 2 from the stable site (found by the checklist), 2 from the buggy version (exploratory), with screenshots and DevTools notes | Active (as of 2026-10-20) |
| `postman/` | Postman collection for the public API | Planned (Day 4) |
| `sql/` | SQL queries for data validation | Planned (Day 4) |
| `tests/`, `pages/` | Playwright (JavaScript) smoke tests | Planned (Day 5-6) |

## Test types

| Type | Status |
|---|---|
| Smoke, Functional, Negative | Active |
| Boundary values / equivalence partitioning | Active |
| Exploratory | Active (as of 2026-10-20) |
| API, Database (SQL) | Planned (Day 4) |
| Regression (Playwright in CI) | Planned (Day 5-7) |

## Tools

| Tool | Status |
|---|---|
| Chrome DevTools (Network, Console, Application) | Active |
| Git / GitHub | Active |
| Postman | Planned (Day 4) |
| SQL / SQLite | Planned (Day 4) |
| Playwright (`@playwright/test`, JavaScript) | Planned (Day 5) |
| GitHub Actions | Planned (Day 7) |

## Note about SQL

This is a public live demo without direct database access.
SQL queries are written against a reconstructed relational schema inferred from the public API JSON responses.
To check that they are correct, they will be executed against a local SQLite copy built from API responses (Day 4).
The real production database is not used.

## About

I focus on manual and API testing. Playwright will be used to automate the core smoke scenarios (from Day 5).
The repository grows step by step, the plan is in `docs/TEST_PLAN.md`.
