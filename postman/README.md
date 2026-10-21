# Postman Collection - Toolshop API

Collection: `Toolshop_API.postman_collection.json` (Postman Collection v2.1)

## How to import

1. Open Postman, click **Import** and select `Toolshop_API.postman_collection.json`.
2. Open the collection and click **Run** (Collection Runner). Keep the default order, because the cart requests use variables from earlier requests.

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
| `cartId` | id of the new cart | `Create cart` test script |

`productId` is not hardcoded because product ids change when the demo data is reset (see Risks in `docs/TEST_PLAN.md`).

## Requests

| # | Request | Type | Checks |
|---|---|---|---|
| 1 | `GET /products` | Positive | 200, response time < 2000ms, `data` not empty, `current_page` and `total` exist |
| 2 | `GET /products/search?q=pliers` | Positive | 200, results not empty, every name contains "pliers" (same as CHK-16) |
| 3 | `GET /brands` | Positive | 200, non-empty array, every brand has `id`, `name`, `slug` |
| 4 | `POST /users/login` with wrong credentials | Negative | 401, body is exactly `{"error": "Unauthorized"}`, no `access_token` |
| 5 | `POST /carts` | Positive | 201, cart `id` returned, saved to `cartId` |
| 6 | `POST /carts/{{cartId}}` | Positive | 200, `{"result": "item added or updated"}`, uses `cartId` and `productId` |
| 7 | `GET /products/non-existent-id-99999` | Negative | 404, `{"message": "Requested item not found"}` |

## Execution result

Run on 2026-10-21 against the live API with newman: 7/7 requests passed, 20/20 assertions passed, average response time 182 ms.

Note: `GET /brands` can contain leftover test brands created by other users (for example names like `3684441160626030editado`), so the check covers the structure only, not exact brand names.
