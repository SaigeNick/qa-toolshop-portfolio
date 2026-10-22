const { test, expect } = require('@playwright/test');
const { LoginPage } = require('../pages/LoginPage');
const { ProductPage } = require('../pages/ProductPage');

test('Catalog loads and displays products with prices', async ({ page }) => {
  await page.goto('/');

  const cards = page.locator('a.card');
  await expect(cards.first()).toBeVisible();

  const thorHammer = cards.filter({ hasText: 'Thor Hammer' });
  await expect(thorHammer).toBeVisible();
  await expect(thorHammer.getByTestId('product-price')).toHaveText('$11.14');
});

test('CHK-16: Search for "pliers" returns 4 matching products', async ({ page }) => {
  await page.goto('/');

  await page.getByTestId('search-query').fill('pliers');
  await page.getByTestId('search-submit').click();
  await expect(page.getByTestId('search-caption')).toContainText('pliers');

  const names = page.getByTestId('product-name');
  await expect(names).toHaveCount(4);
  for (const name of await names.allTextContents()) {
    expect(name.toLowerCase()).toContain('pliers');
  }
});

test('CHK-08: Add Thor Hammer to cart updates header counter', async ({ page }) => {
  const productPage = new ProductPage(page);
  await productPage.openFromCatalog('Thor Hammer');
  await expect(page.getByTestId('product-name')).toHaveText('Thor Hammer');

  await productPage.addToCart(1);

  await expect(page.getByRole('alert')).toContainText('Product added to shopping cart.');
  await expect(page.getByTestId('cart-quantity')).toHaveText('1');
});

test('Login with unknown email and wrong password shows error', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();

  // Not the demo customer: wrong passwords lock that shared account
  await loginPage.login('wrong@example.com', 'wrongpass123');

  await expect(page.getByTestId('login-error')).toBeVisible();
  await expect(page.getByTestId('login-error')).toContainText('Invalid email or password');
});

// BUG-01 (KAN-4): second add of 99 is accepted, counter shows 198. Remove fixme when fixed.
test.fixme('BUG-01: Cart line for Claw Hammer never goes above 99', async ({ page }) => {
  const productPage = new ProductPage(page);
  await productPage.openFromCatalog('Claw Hammer');

  await productPage.addToCart(99);
  await expect(page.getByTestId('cart-quantity')).toHaveText('99');

  // Wait for the second add request, otherwise the counter is checked before it updates
  const secondAdd = page.waitForResponse((res) => res.url().includes('/carts/') && res.request().method() === 'POST');
  await productPage.addToCart(99);
  await secondAdd;

  await page.goto('/checkout');
  await expect(page.getByTestId('product-quantity')).toHaveValue('99');
});
