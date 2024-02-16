import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";

export const Route = new FileRoute("/cart/checkout/cancel").createRoute({
  component: CartCheckoutSuccess,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/cart/checkout/success",
        },
      });
    }
  },
});

function CartCheckoutSuccess() {
  return <span>Checkout cancelled</span>;
}
