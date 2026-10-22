class LoginPage {
  constructor(page) {
    this.page = page;
  }

  async goto() {
    await this.page.goto('/auth/login');
  }

  async login(email, password) {
    await this.page.getByTestId('email').fill(email);
    await this.page.getByTestId('password').fill(password);
    await this.page.getByTestId('login-submit').click();
  }
}

module.exports = { LoginPage };
