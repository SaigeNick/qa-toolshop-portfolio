const { test, expect } = require('@playwright/test');

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
