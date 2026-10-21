# Postman Collection - Toolshop API

Collection: `Toolshop_API.postman_collection.json` (Postman Collection v2.1)

## How to import

1. Open Postman, click **Import** and select `Toolshop_API.postman_collection.json`.
2. Open the collection and click **Run** (Collection Runner). Keep the default order, because later requests use variables saved by earlier ones.

It can also be run from the command line with newman:

```
npx newman run postman/Toolshop_API.postman_collection.json
```

## Variables

Collection variables, so no environment file is needed:

| Variable | Value | Set by |
|---|---|---|
| `baseUrl` | `https://api.practicesoftwaretesting.com` | static |
| `productId` | id of the first product | `Get products` test script |
| `authToken` | JWT of the demo customer (valid 5 minutes) | `Login - demo customer` test script |
| `cartId` | id of the new cart | `Create cart` test script |

`productId` is not hardcoded because product ids change when the demo data is reset (see Risks in `docs/TEST_PLAN.md`).
The login uses the public demo account `customer@practicesoftwaretesting.com` / `welcome01` shown on the site.

## Requests

| # | Request | Type | Checks |
|---|---|---|---|
| 1 | `GET /products` | Positive | 200, response time < 5000ms, `data` not empty, `current_page` and `total` exist |
| 2 | `GET /products/search?q=pliers` | Positive | 200, results not empty, every name contains "pliers" (same as CHK-16) |
| 3 | `GET /brands` | Positive | 200, non-empty array, every brand has `id`, `name`, `slug` |
| 4 | `POST /users/login` with wrong credentials | Negative | 401, body is exactly `{"error": "Unauthorized"}`, no `access_token` |
| 5 | `POST /users/login` with the demo customer | Positive | 200, `access_token` returned, `token_type` is `bearer`, saved to `authToken` |
| 6 | `GET /users/me` with `Bearer {{authToken}}` | Positive | 200, email and first name of the demo customer, no `password` field |
| 7 | `POST /carts` | Positive | 201, cart `id` returned, saved to `cartId` |
| 8 | `POST /carts/{{cartId}}` quantity 99 | Positive | 200, `{"result": "item added or updated"}`, uses `cartId` and `productId` |
| 9 | `POST /carts/{{cartId}}` same product, quantity 99 again | Bug check | BUG-01 / KAN-4: API accepts it with 200 |
| 10 | `GET /carts/{{cartId}}` | Bug check | 200, one cart line for the product, quantity is 198 |
| 11 | `GET /products/non-existent-id-99999` | Negative | 404, `{"message": "Requested item not found"}` |

The response time limit is 5000ms on purpose: this is a shared public demo server, a strict limit would make the run flaky without finding real problems.

## BUG-01 on API level

Requests 8-10 repeat the BUG-01 steps without the UI. The API checks the limit per request
(150 in one request gives 422 "The quantity field must not be greater than 99.", re-checked on 2026-10-21), but two requests of 99 are both accepted
and the cart line becomes 198. So the missing validation is on the backend, not only in the UI.

The tests in requests 9 and 10 assert the current (wrong) behaviour and say so in their names
("BUG-01 still present: ..."). This keeps the run green while the bug is known. When BUG-01 is fixed,
these tests fail, which is the signal to re-test the bug and change the assertion to "quantity is at most 99".

## Execution result

Run on 2026-10-21 against the live API with newman: 11/11 requests passed, 29/29 assertions passed, average response time 202 ms.

Note: `GET /brands` can contain leftover test brands created by other users (for example names like `3684441160626030editado`), so the check covers the structure only, not exact brand names.
