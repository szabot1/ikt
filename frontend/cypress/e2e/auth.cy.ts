describe("auth", () => {
  it(
    "sign in",
    {
      defaultCommandTimeout: 15000, // Increase timeout for first action, backend might take a while to start
    },
    () => {
      cy.clearLocalStorage();

      cy.visit("http://localhost:5173/auth/signin");

      cy.get('input[name="email"]').type("szabot+cypress@kkszki.hu");
      cy.get('input[name="password"]').type("Cypress123!");

      cy.get("button").contains("Continue").click();

      cy.url().should("eq", "http://localhost:5173/");

      cy.saveLocalStorage();
    }
  );

  it("cannot access auth routes after signing in", () => {
    cy.restoreLocalStorage();

    cy.visit("http://localhost:5173/auth/signin");

    cy.url().should("eq", "http://localhost:5173/");

    cy.visit("http://localhost:5173/auth/register");

    cy.url().should("eq", "http://localhost:5173/");
  });

  it("user dropdown has the right content", () => {
    cy.restoreLocalStorage();

    cy.visit("http://localhost:5173/");

    cy.get("nav").find("button").contains("cypress").click();

    cy.get("div").contains("Profile");
    cy.get("div").contains("Settings");
    cy.get("div").contains("Sign out");
  });

  it("profile page", () => {
    cy.restoreLocalStorage();

    cy.visit("http://localhost:5173/");

    cy.get("nav").find("button").contains("cypress").click();
    cy.get("div").contains("Profile").click();

    cy.url().should("include", "/profile");

    cy.get("h1").contains("Profile");

    cy.get("h1").contains("cypress");
  });

  it("settings page", () => {
    cy.restoreLocalStorage();

    cy.visit("http://localhost:5173/");

    cy.get("nav").find("button").contains("cypress").click();
    cy.get("div").contains("Settings").click();

    cy.url().should("include", "/settings");

    cy.get("h1").contains("Account");

    cy.get("button").contains("Delete account");

    cy.get("h1").contains("Billing");

    cy.get("button").contains("Manage billing");
  });

  it("cannot access admin routes without admin role", () => {
    cy.restoreLocalStorage();

    cy.visit("http://localhost:5173/admin");

    cy.url().should("eq", "http://localhost:5173/");

    cy.visit("http://localhost:5173/admin/users");

    cy.url().should("eq", "http://localhost:5173/");
  });

  it("sign out", () => {
    cy.restoreLocalStorage();

    cy.visit("http://localhost:5173/");

    cy.get("nav").find("button").contains("cypress").click();
    cy.get("div").contains("Sign out").click();

    cy.url().should("eq", "http://localhost:5173/");

    cy.get("nav").find("a").contains("Sign In");

    cy.clearLocalStorage();
  });
});
