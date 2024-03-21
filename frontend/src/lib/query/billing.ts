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

export type CheckoutUrlResult =
  | {
      result: "success";
      url: string;
    }
  | {
      result: "error";
      message: string;
    };

export async function checkout(offerId: string): Promise<CheckoutUrlResult> {
  const response = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/billing/checkout`,
    {
      offerId,
    }
  );

  if (response.result === "success") {
    return {
      result: "success",
      url: (response.data as any).url,
    };
  }

  return {
    result: "error",
    message: response.error?.message || "An error occurred",
  };
}
