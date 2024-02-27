import { fetch } from "../fetch";
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

export function offersBySellerIdQuery(sellerId: string) {
  return makeQuery(
    ["offer", "seller-id", sellerId],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/seller-id/${sellerId}`
  );
}

export function offerByIdQuery(offerId: string) {
  return makeQuery(
    ["offer", "id", offerId],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/${offerId}`
  );
}

export function updateOffer(offer: Offer) {
  return fetch(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/${offer.id}`,
    {
      method: "PUT",
      body: JSON.stringify(offer),
    }
  );
}

export function deleteOffer(offerId: string) {
  return fetch(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/${offerId}`,
    {
      method: "DELETE",
    }
  );
}
