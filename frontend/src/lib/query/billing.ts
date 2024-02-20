import { get, post } from "../fetch";

export async function getCustomerPortalUrl(): Promise<string | null> {
  const response = await get(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/billing/customer-portal`
  );

  if (response.result === "success") {
    return (response.data as any).url;
  }

  return null;
}

export async function checkout(): Promise<string | null> {
  const response = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/billing/checkout`
  );

  if (response.result === "success") {
    return (response.data as any).url;
  }

  return null;
}
