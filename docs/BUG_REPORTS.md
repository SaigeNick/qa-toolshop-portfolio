# Bug Reports - Toolshop

Severity and priority follow the definitions in TEST_PLAN.md (section 8).

| ID | Title | Environment | Severity | Priority | Linked |
|---|---|---|---|---|---|
| BUG-01 | Cart quantity limit of 99 can be bypassed by adding the same product twice | Stable | High | P2 - Medium | CHK-11, TC-01 |
| BUG-02 | Registration password error says "minimal 6 characters" while the real rule is 8 | Stable | Low | P3 - Low | CHK-06, TC-03 |

BUG-01 and BUG-02 were found on the stable site during the Day 2 checklist run and re-checked on 2026-10-20.

---

## BUG-01 - Cart quantity limit of 99 can be bypassed by adding the same product twice

| Field | Value |
|---|---|
| Environment | Stable, https://practicesoftwaretesting.com (footer: v2.5, built 2026-10-11), API https://api.practicesoftwaretesting.com, as of 2026-10-20 |
| Browser | Chrome (latest) 1920x1080, re-checked in Playwright Chromium (headless) |
| Severity | High - cart calculation works wrong, the cart line and total go above the allowed limit |
| Priority | P2 - Medium - a business rule is broken in a High risk area (cart), but normal orders are not blocked |
| Linked | CHK-11, TC-01 |
| Reproducibility | 2 of 2 attempts |

**Preconditions:** User is not logged in (guest), cart is empty. The quantity field on the product page allows 1-99 (`min="1"`, `max="99"`, typing `100` shows "You can order at most 99 of this product.").

**Steps to reproduce:**

1. Open https://practicesoftwaretesting.com and search for `Claw Hammer`.
2. Open the "Claw Hammer" product page ($11.48).
3. Type `99` in the quantity field and click "Add to cart".
4. Type `99` in the quantity field again and click "Add to cart".
5. Open the cart.

**Expected result:** The cart line for Claw Hammer never goes above 99. On the second add the user sees "You can order at most 99 of this product." (or the quantity stays at 99), cart total is at most $1,136.52 (99 x $11.48).

**Actual result:** Both adds succeed with the toast "Product added to shopping cart.". The cart counter in the header shows 198, the cart line has quantity 198 and the total is $2,273.04 (198 x $11.48). "Proceed to checkout" is available.

**DevTools / technical observation:**

- Network: each add sends `POST /carts/{cart_id}` with body `{"product_id":"...","quantity":99}`. Both requests return `200 {"result":"item added or updated"}`, then `GET /carts/{cart_id}` returns the item with `"quantity":198`.
- The API does validate the quantity of a single request: `POST /carts/{cart_id}` with `"quantity":150` returns `422 {"message":"The quantity field must not be greater than 99."}`.
- Root cause (likely): the 99 limit is checked only for the requested quantity, not for the resulting cart line (existing quantity + new quantity). Both the UI and the API add the quantities without checking the sum.
- Console: no errors related to the add. The `401` on `GET /users/me` is expected for a guest user and is not related.
- Not checked: whether the order can be confirmed with 198 items (checkout was not completed to avoid creating orders with wrong data on the shared demo).

**Screenshot:**

![BUG-01 cart with 198 Claw Hammers](screenshots/bug-01-cart-limit-bypass.png)

---

## BUG-02 - Registration password error says "minimal 6 characters" while the real rule is 8

| Field | Value |
|---|---|
| Environment | Stable, https://practicesoftwaretesting.com (footer: v2.5, built 2026-10-11), API https://api.practicesoftwaretesting.com, as of 2026-10-20 |
| Browser | Chrome (latest) 1920x1080, re-checked in Playwright Chromium (headless) |
| Severity | Low - text issue, validation itself works correctly |
| Priority | P3 - Low - misleading for new customers, but registration is possible |
| Linked | CHK-06, TC-03 |
| Reproducibility | Always |

**Preconditions:** User is logged out. Registration page is open: https://practicesoftwaretesting.com/auth/register

**Steps to reproduce:**

1. Type `Ab1!xyz` (7 characters, has uppercase, lowercase, number and symbol) in the Password field.
2. Leave the other fields empty and click "Register".
3. Check the message under the Password field and the hint "Your password must:".

**Expected result:** The error text matches the hint and the real rule, for example "Password must be at least 8 characters long."

**Actual result:** The hint says "Be at least 8 characters long", and 7 characters are rejected, but the error message says "Password must be minimal 6 characters long.". A user who follows the error message and enters 6 or 7 characters is rejected again. 8 characters (`Ab1!xyz7`) are accepted, so the real minimum is 8.

**DevTools / technical observation:**

- Network: the server rule is 8. `POST /users/register` with a valid body and password `Ab1!xyz` returns `422 {"password":["The password field must be at least 8 characters."]}`.
- The wrong text comes from the frontend translation file `GET /assets/i18n/en.json`, key `fields.password.errors.minlength`: `"Password must be minimal 6 characters long."`.
- Root cause: the error text in the translation file was not updated when the minimum length was changed to 8. The validator, the hint and the API all use 8.
- Console: no errors related to the form. The `401` on `GET /users/me` is expected for a guest user.

**Screenshot:**

![BUG-02 password error says minimal 6](screenshots/bug-02-password-length-mismatch.png)
