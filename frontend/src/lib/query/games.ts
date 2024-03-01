import { Tag } from "./tags";
import { makeQuery } from "./util";

export interface Game {
  id: string;
  slug: string;
  name: string;
  description: string;
  isActive: boolean;
  isFeatured: boolean;
  createdAt: string;
  updatedAt: string;
  images: GameImage[];
  tags: GameTag[];
}

interface GameImage {
  id: string;
  gameId: string;
  imageUrl: string;
  createdAt: string;
  updatedAt: string;
}

interface GameTag {
  id: string;
  gameId: string;
  tagId: string;
  createdAt: string;
  tag: Tag;
}

export function gameQuery(gameId: string) {
  return makeQuery(
    ["game", gameId],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/games/${gameId}`
  );
}

export function gamesQuery(page: number, pageSize: number) {
  return makeQuery(
    ["games", `page=${page},pageSize=${pageSize}`],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/games?page=${page}&size=${pageSize}`
  );
}

export function featuredGamesQuery() {
  return makeQuery(
    ["featuredGames"],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/games/featured?page=1&size=15`
  );
}

export function recentlyUpdatedGamesQuery() {
  return makeQuery(
    ["recentlyUpdatedGames"],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/games/recently-updated?page=1&size=15`
  );
}

export function discountedGamesQuery() {
  return makeQuery(
    ["discountedGames"],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/games/discounted?page=1&size=15`
  );
}

export function searchQuery(query: string) {
  return makeQuery(
    ["search", query],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/games/search?query=${query}`
  );
}
