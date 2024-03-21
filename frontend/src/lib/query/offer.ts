import { fetch, post } from "../fetch";
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

export type OfferType = {
  id: string;
  slug: string;
  name: string;
  description: string;
  claimInstructions: string;
  createdAt: string;
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

export const offerTypesQuery = makeQuery(
  ["offer", "types"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/types`
);

export const createOfferGameListQuery = makeQuery(
  ["offer", "create-offer-game-list"],
  `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer/create-offer-game-list`
);

export async function createOffer(
  gameId: string,
  typeId: string,
  price: number
): Promise<string | null> {
  const response = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/offer`,
    {
      gameId,
      typeId,
      price,
    }
  );

  if (response.result === "success") {
    return null;
  }

  return response.error || "Unknown error";
}
