import { method } from "../fetch";
import { makeQuery } from "./util";

export type Seller = {
  id: string;
  slug: string;
  displayName: string;
  imageUrl: string;
  isVerified: boolean;
  isClosed: boolean;
  createdAt: string;
  updatedAt: string;
};

export function sellerMeQuery() {
  return makeQuery(
    ["seller", "me"],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/me`
  );
}

export function sellerByUserIdQuery(userId: string) {
  return makeQuery(
    ["seller", "user-id", userId],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/user-id/${userId}`
  );
}

export function sellerIdQuery(id: string) {
  return makeQuery(
    ["seller", "id", id],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/id/${id}`
  );
}

export function sellerSlugQuery(slug: string) {
  return makeQuery(
    ["seller", "slug", slug],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/slug/${slug}`
  );
}

export async function closeSellerAccount() {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/close-account`,
    "POST"
  );

  return response.result === "success";
}

export async function setSellerDisplayName(displayName: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/display-name`,
    "POST",
    { displayName }
  );

  return response.result === "success";
}

export async function setSellerImageUrl(imageUrl: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller/image-url`,
    "POST",
    { imageUrl }
  );

  return response.result === "success";
}

export async function createSellerProfile(userId: string) {
  const response = await method(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/seller`,
    "POST",
    { userId }
  );

  return response.result === "success";
}
