import { post } from "../fetch";
import { makeQuery } from "./util";

export interface Tag {
  id: string;
  name: string;
  createdAt: string;
}

export const tagsQuery = makeQuery(
  ["tags"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/tags`
);

export function tagQuery(id: string) {
  return makeQuery(
    ["tag", id],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/tags/${id}`
  );
}

export function tagGamesQuery(id: string, page: number, pageSize: number) {
  return makeQuery(
    ["tagGames", id, `page=${page},pageSize=${pageSize}`],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/tags/${id}/games?page=${page}&size=${pageSize}`
  );
}

export async function createTag(name: string): Promise<string | null> {
  const response = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/tags/new`,
    {
      name,
    }
  );

  if (response.result === "success") {
    return null;
  }

  return response.error.message || response.error || "Unknown error";
}
