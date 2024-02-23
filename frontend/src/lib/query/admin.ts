import { method } from "../fetch";
import { makeQuery } from "./util";

export const adminUsersQuery = makeQuery(
  ["admin", "users"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/users`
);

export const adminTagsQuery = makeQuery(
  ["admin", "tags"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/tags`
);

export async function deleteTag(id: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/tags/${id}`,
    "DELETE"
  );

  return response.result === "success";
}

export const adminGamesQuery = makeQuery(
  ["admin", "games"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/games`
);

export async function deleteGame(id: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/games/${id}`,
    "DELETE"
  );

  return response.result === "success";
}

export const adminSellersQuery = makeQuery(
  ["admin", "sellers"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/sellers`
);

export async function deleteSeller(id: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/sellers/${id}`,
    "DELETE"
  );

  return response.result === "success";
}

export const adminOffersQuery = makeQuery(
  ["admin", "offers"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/offers`
);

export async function deleteOffer(id: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/admin/offers/${id}`,
    "DELETE"
  );

  return response.result === "success";
}
