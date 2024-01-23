import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/cart/checkout/success").createRoute({
  component: CartCheckoutSuccess,
  errorComponent: ErrorPage,
});

function CartCheckoutSuccess() {
  return <></>;
}
