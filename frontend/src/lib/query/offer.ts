import { makeQuery } from "./util";

export type Offer = {
  id: string;
  gameId: string;
  sellerId: string;
  price: number;
  isActive: boolean;
  type: string;
  createdAt: string;
  updatedAt: string;
};

export function offersByGameIdQuery(gameId: string) {
  return makeQuery(
    ["offer", "game-id", gameId],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/game-id/${gameId}`
  );
}

export function offerByIdQuery(offerId: string) {
  return makeQuery(
    ["offer", "id", offerId],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/${offerId}`
  );
}
