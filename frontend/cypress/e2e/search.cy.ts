describe("search", () => {
  it("empty search redirects", () => {
    cy.visit("http://localhost:5173");

    cy.get('input[name="search"]').type("{enter}");

    cy.url().should("eq", "http://localhost:5173/search?q=");
  });

  it("non-empty search redirects", () => {
    cy.visit("http://localhost:5173");

    cy.get('input[name="search"]').type("cypress{enter}");

    cy.url().should("eq", "http://localhost:5173/search?q=cypress");
  });

  it("returns correct results", () => {
    cy.visit("http://localhost:5173/search?q=counter");

    cy.get("h2").contains("Counter-Strike");
    cy.get("h2").contains("Counter-Strike 2");

    cy.get("div").contains(/\d+ offer(s)?/);
  });
});
