import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";

export const Route = new FileRoute("/cart/checkout").createRoute({
  component: CartCheckout,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/cart/checkout",
        },
      });
    }
  },
});

function CartCheckout() {
  return <></>;
}
