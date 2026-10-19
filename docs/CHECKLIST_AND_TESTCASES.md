# Checklist and Test Cases - Toolshop

Environment: https://practicesoftwaretesting.com (v5.0), checked on 2026-10-19.
Browser: Chrome (latest), 1920x1080.
Test data: demo account `customer@practicesoftwaretesting.com` / `welcome01` (see TEST_PLAN.md, section 5).

## Part 1 - Checklist

Items follow the risk matrix in TEST_PLAN.md (section 10):

| Risk / Priority | Areas | Items |
|---|---|---|
| High / P1 | Auth, Cart, Checkout | 15 (CHK-01 to CHK-15) |
| Medium / P2 | Search, Price range, Category/Brand filters | 6 (CHK-16 to CHK-21) |
| Low / P3 | Sorting, Pagination, Contact form | 4 (CHK-22 to CHK-25) |

| ID | Module / Area | Risk & Priority | Check | Expected result |
|---|---|---|---|---|
| CHK-01 | Auth - Login | High / P1 | Log in with the demo customer account (valid email + password) | User is redirected to "My account", the header shows the user name instead of "Sign in" |
| CHK-02 | Auth - Login | High / P1 | Log in with a valid email and a wrong password | Error "Invalid email or password" is shown, user stays on the login page |
| CHK-03 | Auth - Login | High / P1 | Click "Login" with empty email and password fields | Errors "Email is required" and "Password is required" are shown under the fields, no request is sent |
| CHK-04 | Auth - Login | High / P1 | Enter an email without "@" (e.g. `abc`) and submit | Error "Email format is invalid" is shown under the email field |
| CHK-05 | Auth - Register | High / P1 | Submit the registration form with all fields empty | Every required field (name, date of birth, address, phone, email, password) shows its own "... is required" message |
| CHK-06 | Auth - Register | High / P1 | Enter a password shorter than 6 characters in the registration form | Error "Password must be minimal 6 characters long." is shown, account is not created |
| CHK-07 | Auth - Sign out | High / P1 | Log in, open the user menu and click "Sign out" | User is logged out, header shows "Sign in" again, "My account" pages are not accessible |
| CHK-08 | Cart - Add | High / P1 | Open a product page, keep quantity 1 and click "Add to cart" | Toast "Product added to shopping cart." appears, cart counter in the header shows 1 |
| CHK-09 | Cart - Quantity | High / P1 | On the product page set quantity to 3 with the "+" button and add to cart | Cart counter increases by 3, cart line shows quantity 3 |
| CHK-10 | Cart - Calculation | High / P1 | In the cart change quantity of a product from 1 to 2 | Line total = unit price x 2, cart total is recalculated without page reload |
| CHK-11 | Cart - Quantity limits | High / P1 | Enter quantity 0, then 100, in the cart quantity field (allowed range is 1-99) | Values outside 1-99 are rejected or corrected, totals are not calculated with 0 or 100 |
| CHK-12 | Cart - Product limit | High / P1 | Add "Thor Hammer" to the cart twice | Message "You can only have one Thor Hammer in the cart." is shown, quantity stays 1 |
| CHK-13 | Cart - Remove | High / P1 | Remove the only product from the cart with the red delete button | Product disappears from the cart, total and header counter are updated, cart shows that it is empty |
| CHK-14 | Checkout - Steps | High / P1 | Go through checkout as a logged-in user: Cart -> Sign in -> Billing address -> Payment | Each step opens in order, step indicator (1-4) shows the current step, "Proceed to checkout" is available on each step |
| CHK-15 | Checkout - Payment | High / P1 | On the Payment step check the payment method dropdown and confirm with "Bank Transfer" | Dropdown has 5 methods (Bank Transfer, Cash on Delivery, Credit Card, Buy Now Pay Later, Gift Card), after "Confirm" a payment success message is shown |
| CHK-16 | Search | Medium / P2 | Search for `pliers` | Caption "Searched for: pliers", only products with "pliers" in the name are shown (4 products) |
| CHK-17 | Search | Medium / P2 | Search for a non-existing word (e.g. `xyzqwe`) | Message "There are no products found." is shown, no product cards |
| CHK-18 | Search | Medium / P2 | After a search click the "X" (reset) button | Search field is cleared, full product list is shown again |
| CHK-19 | Price range | Medium / P2 | Move the price slider handles (default 1-100, scale 0-200) to a narrow range, e.g. 10-15 | Only products with price inside the selected range are shown, the grid updates without page reload |
| CHK-20 | Category filter | Medium / P2 | Under "By category" select "Hand Tools" > "Pliers" | Only pliers are shown, products from other categories (e.g. Power Tools) disappear |
| CHK-21 | Brand filter | Medium / P2 | Under "By brand" select "ForgeFlex Tools", then also "MightyCraft Hardware" | First only ForgeFlex products are shown, with both brands checked products of both brands are shown |
| CHK-22 | Sorting | Low / P3 | Select sort "Price (Low - High)", then "Price (High - Low)" | Product prices on the page are in ascending / descending order |
| CHK-23 | Sorting | Low / P3 | Select sort "Name (A - Z)", then "Name (Z - A)" | Product names are in alphabetical / reverse alphabetical order |
| CHK-24 | Pagination | Low / P3 | Click page "2", then "»" (next) and "«" (previous) | Each page shows up to 9 products, active page is highlighted, no duplicate products between pages |
| CHK-25 | Contact form | Low / P3 | Click "Send" on the Contact page with all fields empty | Errors for first name, last name, email, subject and message are shown, form is not sent |
