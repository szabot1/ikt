import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/cart/checkout").createRoute({
  component: CartCheckout,
  errorComponent: ErrorPage,
});

function CartCheckout() {
  return <></>;
}
