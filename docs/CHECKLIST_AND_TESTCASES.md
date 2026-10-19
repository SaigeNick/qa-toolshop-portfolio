# Checklist and Test Cases - Toolshop

Environment: https://practicesoftwaretesting.com (v5.0), executed on 2026-10-19.
Browser: Chrome (latest), 1920x1080.
Test data: demo account `customer@practicesoftwaretesting.com` / `welcome01` (see TEST_PLAN.md, section 5).

Note: the price slider is set to 1-100 by default (scale 0-200), so the catalog shows 45 of 50 products until the range is changed.

## Part 1 - Checklist

Items follow the risk matrix in TEST_PLAN.md (section 10):

| Risk / Priority | Areas | Items |
|---|---|---|
| High / P1 | Auth, Cart, Checkout | 15 (CHK-01 to CHK-15) |
| Medium / P2 | Search, Price range, Category/Brand filters | 6 (CHK-16 to CHK-21) |
| Low / P3 | Sorting, Pagination, Contact form | 4 (CHK-22 to CHK-25) |

| ID | Module / Area | Risk & Priority | Check | Expected result | Result | Notes / Bug ID |
|---|---|---|---|---|---|---|
| CHK-01 | Auth - Login | High / P1 | Log in with the demo customer account (valid email + password) | User is redirected to "My account", the header shows the user name instead of "Sign in" | Pass | Header shows "Jane Doe" |
| CHK-02 | Auth - Login | High / P1 | Log in with a valid email and a wrong password | Error "Invalid email or password" is shown, user stays on the login page | Pass | - |
| CHK-03 | Auth - Login | High / P1 | Click "Login" with empty email and password fields | Errors "Email is required" and "Password is required" are shown under the fields | Pass | - |
| CHK-04 | Auth - Login | High / P1 | Enter an email without "@" (e.g. `customer.practicesoftwaretesting.com`) and submit | Error "Email format is invalid" is shown under the email field | Pass | - |
| CHK-05 | Auth - Register | High / P1 | Submit the registration form with all fields empty | First name, Last name, Date of Birth, Country, Postal code, House number, Street, City, State, Phone, Email address and Password each show their own validation message, account is not created | Pass | - |
| CHK-06 | Auth - Register | High / P1 | Enter a password of 7 characters (`Ab1!xyz`) in the registration form | Error message matches the rule shown under the field ("Be at least 8 characters long") | Fail | Validation works (7 chars rejected, 8 accepted), but the error text says "Password must be minimal 6 characters long." |
| CHK-07 | Auth - Sign out | High / P1 | Log in, open the user menu and click "Sign out" | User is logged out, header shows "Sign in" again | Pass | - |
| CHK-08 | Cart - Add | High / P1 | Open a product page, keep quantity 1 and click "Add to cart" | Toast "Product added to shopping cart." appears, cart counter in the header shows 1 | Pass | - |
| CHK-09 | Cart - Quantity | High / P1 | On the product page click "+" twice (quantity 3) and add to cart | Cart counter increases by 3 | Pass | - |
| CHK-10 | Cart - Calculation | High / P1 | In the cart change quantity of Claw Hammer ($11.48) from 1 to 2 | Toast "Product quantity updated.", line total and cart total are $22.96 | Pass | - |
| CHK-11 | Cart - Quantity limits | High / P1 | Type `0`, `-1` and `100` in the quantity field (product page and cart), then add 99 of the same product twice | `0` and `-1` are reset to 1. `100` is reset to 99 with message "You can order at most 99 of this product.". Cart line never goes above 99 | Fail | Field limits work. But two adds of 99 put 198 Claw Hammers in the cart ($2,273.04), the 99 limit is checked per add only |
| CHK-12 | Cart - Product limit | High / P1 | Add "Thor Hammer" to the cart twice | First add succeeds. Second add shows "You can only have one Thor Hammer in the cart.", quantity stays 1 | Pass | - |
| CHK-13 | Cart - Remove | High / P1 | Remove the only product from the cart with the red delete button | Toast "Product deleted.", text "The cart is empty. Nothing to display.", cart icon disappears from the header | Pass | - |
| CHK-14 | Checkout - Steps | High / P1 | Go through checkout as a logged-in user: Cart -> Sign in -> Billing address -> Payment | Each step opens in order, the step indicator (1-4) highlights the current step | Pass | Step 2 has "Sign in" and "Continue as Guest" tabs. See TC-05 |
| CHK-15 | Checkout - Payment | High / P1 | On the Payment step check the payment method dropdown and pay with "Bank Transfer" | Dropdown has 5 methods (Bank Transfer, Cash on Delivery, Credit Card, Buy Now Pay Later, Gift Card), after "Check payment" the message "Payment was successful" is shown, after "Confirm" the order is placed with an invoice number | Pass | Bank Transfer fields: Bank Name, Account Name, Account Number (digits only, otherwise "Account number must be numeric.") |
| CHK-16 | Search | Medium / P2 | Search for `pliers` | Caption "Searched for: pliers", 4 products: Combination Pliers, Pliers, Long Nose Pliers, Slip Joint Pliers | Pass | - |
| CHK-17 | Search | Medium / P2 | Search for a non-existing word (`xyzqwe`) | Message "There are no products found.", no product cards | Pass | - |
| CHK-18 | Search | Medium / P2 | After a search click the "X" (reset) button | Search field is cleared, caption disappears, default product list is shown again | Pass | - |
| CHK-19 | Price range | Medium / P2 | Move the price slider handles to 10-15 | Only products priced 10-15 are shown (13 products, 2 pages) | Pass | - |
| CHK-20 | Category filter | Medium / P2 | Under "By category" select "Hand Tools" > "Pliers" | Only products of category Pliers are shown | Pass | 5 products, including Bolt Cutters (category Pliers in the API data) |
| CHK-21 | Brand filter | Medium / P2 | Select brand "ForgeFlex Tools", then also "MightyCraft Hardware" | ForgeFlex only: 36 products (4 pages). Both brands: 45 products (5 pages), same as without filter | Pass | Counts are within the default 1-100 price range |
| CHK-22 | Sorting | Low / P3 | Select sort "Price (Low - High)", then "Price (High - Low)" | Prices are in ascending / descending order (first page starts with $3.55 / $89.55) | Pass | Highest price is $89.55, not $178.20, because of the default 1-100 slider range |
| CHK-23 | Sorting | Low / P3 | Select sort "Name (A - Z)", then "Name (Z - A)" | Names are in alphabetical / reverse order (first: "Adjustable Wrench" / "Wood Saw") | Pass | - |
| CHK-24 | Pagination | Low / P3 | Open pages 1-5, then use "«" and "»" | 9 products per page, 45 unique products, no duplicates. Active page is highlighted, "«" is disabled on page 1 and "»" on page 5 | Pass | - |
| CHK-25 | Contact form | Low / P3 | Click "Send" on the Contact page with all fields empty | Errors for First name, Last name, Email, Subject and Message are shown, form is not sent | Pass | - |

Summary: 23 Pass, 2 Fail (CHK-06, CHK-11).

## Part 2 - Test Cases

### TC-01 - Quantity field boundary values (product page and cart)

| Field | Value |
|---|---|
| Linked CHK | CHK-11 |
| Priority | High / P1 |
| Technique | Boundary Value Analysis |
| Preconditions | Cart is empty. Allowed quantity per product is 1-99 (input has `min="1"` and `max="99"`) |
| Test data | Product "Claw Hammer", $11.48. Values: 0, 1, 2, 98, 99, 100 |

Steps:

1. Open the "Claw Hammer" product page.
2. Type each value into the quantity field, leave the field, check the value in the field.
3. Click "Add to cart" and check the toast and the cart counter.
4. Open the cart, type each value into the cart quantity field, check the field, line total and cart total.

Expected result:

| Value | Partition | Product page | Cart |
|---|---|---|---|
| 0 | Invalid (below min) | Field resets to 1, 1 item is added | Field resets to 1, total $11.48 |
| 1 | Valid (min) | 1 item is added | Total $11.48 |
| 2 | Valid (min+1) | 2 items are added | Total $22.96 |
| 98 | Valid (max-1) | 98 items are added | Total $1,125.04 |
| 99 | Valid (max) | 99 items are added | Total $1,136.52 |
| 100 | Invalid (above max) | Field resets to 99, message "You can order at most 99 of this product." | Field resets to 99, same message, total $1,136.52 |

Actual result: **Pass** - every value behaved as expected (also checked `-1`, it resets to 1).
Related observation: the limit is checked per add, not per cart line (see CHK-11).

### TC-02 - Login validation with equivalence partitions

| Field | Value |
|---|---|
| Linked CHK | CHK-01, CHK-02, CHK-03, CHK-04 |
| Priority | High / P1 |
| Technique | Equivalence Partitioning |
| Preconditions | User is logged out, login page is open (`/auth/login`) |
| Test data | See table below, one value per partition |

Steps:

1. Enter the email and password for the partition.
2. Click "Login".
3. Check the message and the current page.

| # | Partition | Email | Password | Expected result | Actual |
|---|---|---|---|---|---|
| 1 | Valid credentials | `customer@practicesoftwaretesting.com` | `welcome01` | Redirect to "My account", user name in the header | Pass ("Jane Doe") |
| 2 | Registered email, wrong password | `customer@practicesoftwaretesting.com` | `Xq7!test` | "Invalid email or password", stays on `/auth/login` | Pass |
| 3 | Unregistered email | `not.registered.qa@example.com` | `Xq7!test` | "Invalid email or password" (same text, does not reveal that the email does not exist) | Pass |
| 4 | Empty fields | (empty) | (empty) | "Email is required", "Password is required" | Pass |
| 5 | Email without "@" | `customer.practicesoftwaretesting.com` | `Xq7!test` | "Email format is invalid", no login request | Pass |

Actual result: **Pass** - all 5 partitions behaved as expected.

### TC-03 - Registration password length boundaries

| Field | Value |
|---|---|
| Linked CHK | CHK-05, CHK-06 |
| Priority | High / P1 |
| Technique | Boundary Value Analysis |
| Preconditions | Registration page is open (`/auth/register`). The hint under the field says: at least 8 characters, uppercase and lowercase letters, at least one number, at least one special symbol |
| Test data | Passwords that meet all rules except length: `Ab1!xyz` (7), `Ab1!xyz7` (8), `Ab1!xyz78` (9) |

Steps:

1. Type the password into the Password field.
2. Click "Register" (other fields stay empty, so no account is created).
3. Check the message under the Password field.

| Length | Boundary | Expected result | Actual |
|---|---|---|---|
| 7 | min-1 | Password error is shown | Error shown: "Password must be minimal 6 characters long." |
| 8 | min | No password error | No password error |
| 9 | min+1 | No password error | No password error |

Actual result: **Pass** - the length boundary is at 8 characters, as the hint says.
Observation: the error text says "minimal 6", which does not match the real rule (CHK-06 = Fail).
Also, a password without a number and symbol (`Abcdefgh`) shows "Password can not include invalid characters.", which is confusing because the problem is missing characters.
Only client-side validation was checked, a full registration was not submitted.

### TC-04 - Price range slider boundaries

| Field | Value |
|---|---|
| Linked CHK | CHK-19 |
| Priority | Medium / P2 |
| Technique | Boundary Value Analysis + Equivalence Partitioning |
| Preconditions | Home page is open, no search or filters. Cheapest product is $3.55, most expensive is $178.20 |
| Test data | Slider ranges below |

Steps:

1. Drag the min and max handles of the price slider to the range.
2. Wait for the product grid to update.
3. Check the number of products (pages) and that every price is inside the range.

| # | Range | Partition | Expected result | Actual |
|---|---|---|---|---|
| 1 | 1-100 | Default | 45 products, 5 pages | 45 products, 5 pages |
| 2 | 0-200 | Scale extremes | All 50 products, 6 pages | 6 pages, all products |
| 3 | 10-15 | Narrow range, few items | 13 products, all priced 10-15 | 13 products (9 + 4), $10.07 - $14.24 |
| 4 | 0-4 | Just above the cheapest price | 2 products: Washers $3.55, Flat-Head Wood Screws $3.95 | Same 2 products |
| 5 | 0-3 | Below the cheapest price, no items | "There are no products found." | Same message, no cards, no pagination |

Actual result: **Pass**. Product counts match the API (`GET /products?between=price,10,15` returns 13).

### TC-05 - End-to-end checkout with Bank Transfer and total check

| Field | Value |
|---|---|
| Linked CHK | CHK-14, CHK-15, CHK-10 |
| Priority | High / P1 |
| Technique | State Transition / functional flow |
| Preconditions | Demo customer account exists, cart is empty, user is logged out |
| Test data | `customer@practicesoftwaretesting.com` / `welcome01`. Products: Pliers ($12.01) x2, Claw Hammer ($11.48) x1. Payment: Bank Transfer, test bank details (e.g. Bank Name `Test Bank`, Account Name `Jane Doe`, Account Number `12345678`) |

States: Cart (1) -> Sign in (2) -> Billing address (3) -> Payment (4) -> Order confirmed.

Steps:

1. Add Pliers with quantity 2 and Claw Hammer with quantity 1 to the cart.
2. Open the cart. Check line totals and cart total.
3. Click "Proceed to checkout".
4. On "Sign in" log in with the demo account, click "Proceed to checkout".
5. On "Billing address" fill the empty required fields (Postal code, House number, State), click "Proceed to checkout".
6. On "Payment" select "Bank Transfer", fill Bank Name, Account Name and Account Number, click "Check payment".
7. Click "Confirm".
8. Check the order confirmation and the cart.

Expected result:

- Step 2: Pliers line $24.02, Claw Hammer line $11.48, cart total $35.50.
- Steps 3-6: each step opens only after the previous one, the step indicator moves 1 -> 2 -> 3 -> 4.
- Step 6: Account Number accepts digits only ("Account number must be numeric." for other input).
- Step 6: after "Check payment" the message "Payment was successful" is shown and the "Confirm" button appears.
- Step 7-8: "Thanks for your order! Your invoice number is INV-...", the cart is empty and the cart icon disappears from the header.

Actual result: **Pass** - cart total was $35.50, all 4 steps opened in order, "Payment was successful" after "Check payment", then "Thanks for your order! Your invoice number is INV-2026000028." after "Confirm", the cart was emptied.
Observation: the billing address of the shared demo account was only partly filled (Country "Slovakia", Street "Test street 98", City "Vienna", Postal code / House number / State empty). Most likely changed by other users of the public demo, so test data has to be checked before each run (see TEST_PLAN.md, project risks).
