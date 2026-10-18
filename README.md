# QA Portfolio - Practice Software Testing (Toolshop)

Manual and automated testing of the demo e-commerce app **Toolshop** by Testsmith (version 5.0, as of 2026-10-18).

| Environment | URL |
|---|---|
| Stable (main target) | https://practicesoftwaretesting.com |
| Buggy version (bug hunting) | https://with-bugs.practicesoftwaretesting.com |
| REST API | https://api.practicesoftwaretesting.com |

## What is inside

| Folder / file | Content | Status |
|---|---|---|
| `docs/TEST_PLAN.md` | Test strategy: scope, risks, environments, entry/exit criteria, tools | Done |
| `docs/CHECKLIST_AND_TESTCASES.md` | Checklist + detailed test cases | Planned |
| `docs/BUG_REPORTS.md` | Bug reports from the buggy version | Planned |
| `postman/` | Postman collection for the public API | Planned |
| `sql/` | SQL queries for data validation | Planned |
| `tests/`, `pages/` | Playwright (JavaScript) smoke tests | Planned |

## Tools

| Tool | Status |
|---|---|
| Chrome DevTools (Network, Console, Application) | Active |
| Git / GitHub | Active |
| Postman | Planned |
| SQL | Planned |
| Playwright (`@playwright/test`, JavaScript) | Planned |
| GitHub Actions | Planned |

## Note about SQL

This is a public live demo without direct database access.
SQL queries are written against a reconstructed relational schema inferred from the public API JSON responses.
They demonstrate DB validation logic, they are not run against the real database.

## About

I focus on manual and API testing and use Playwright to automate the core smoke scenarios.
The repository grows step by step, the plan is in `docs/TEST_PLAN.md`.
