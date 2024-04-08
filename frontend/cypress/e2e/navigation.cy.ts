describe("navigation", () => {
  it("navbar contains sign in and register link", () => {
    cy.visit("http://localhost:5173");

    cy.get("nav").find("a").contains("Sign In");
    cy.get("nav").find("a").contains("Register");
  });

  it("sign in redirects to /auth/signin", () => {
    cy.visit("http://localhost:5173");

    cy.get("nav").find("a").contains("Sign In").click();

    cy.url().should("include", "/auth/signin");
  });

  it("register redirects to /auth/register", () => {
    cy.visit("http://localhost:5173");

    cy.get("nav").find("a").contains("Register").click();

    cy.url().should("include", "/auth/register");
  });

  it("can sign in and sign out", () => {
    cy.visit("http://localhost:5173/auth/signin");

    cy.get('input[name="email"]').type("szabot+cypress@kkszki.hu");
    cy.get('input[name="password"]').type("Cypress123!");

    cy.get("button").contains("Continue").click();

    cy.url().should("eq", "http://localhost:5173/");

    cy.get("nav").find("button").contains("cypress").click();
    cy.get("div").contains("Sign out").click();

    cy.clearLocalStorage();
    cy.url().should("eq", "http://localhost:5173/");

    cy.get("nav").find("a").contains("Sign In");
  });
});
