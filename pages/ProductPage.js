class ProductPage {
  constructor(page) {
    this.page = page;
  }

  async openFromCatalog(name) {
    await this.page.goto('/');
    await this.page.getByTestId('product-name').getByText(name, { exact: true }).click();
  }

  async addToCart(quantity) {
    await this.page.getByTestId('quantity').fill(String(quantity));
    await this.page.getByTestId('add-to-cart').click();
  }
}

module.exports = { ProductPage };
