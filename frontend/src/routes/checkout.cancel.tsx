import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";

export const Route = new FileRoute("/checkout/cancel").createRoute({
  component: CheckoutSuccess,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/checkout/success",
        },
      });
    }
  },
});

function CheckoutSuccess() {
  return <span>Checkout cancelled</span>;
}
