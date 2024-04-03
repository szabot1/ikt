/// <reference types="cypress" />

let LOCAL_STORAGE_MEMORY: { [key: string]: string } = {};

Cypress.Commands.add("saveLocalStorage", () => {
  Object.keys(localStorage).forEach((key) => {
    LOCAL_STORAGE_MEMORY[key] = localStorage[key];
  });
});

Cypress.Commands.add("restoreLocalStorage", () => {
  Object.keys(LOCAL_STORAGE_MEMORY).forEach((key) => {
    localStorage.setItem(key, LOCAL_STORAGE_MEMORY[key]);
  });
});

Cypress.Commands.overwrite("clearLocalStorage", () => {
  LOCAL_STORAGE_MEMORY = {};
  localStorage.clear();
});

export {};

declare global {
  namespace Cypress {
    interface Chainable {
      saveLocalStorage: () => void;
      restoreLocalStorage: () => void;
      clearLocalStorage: () => void;
    }
  }
}
